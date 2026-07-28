# 20 – Tabellenarchetypen

> **GOB-Vorgaben, die in allen Beispielen dieses Dokuments gelten:** Schlüssel heißen `PK` und
> `Key01`, `Key02`, … (nicht sprechend); `DataClassification` ist an jeder Tabelle und jedem
> Feld konkret zu setzen (`ToBeClassified` ist unzulässig, temporäre Tabellen bekommen
> `SystemMetaData`); vor `Get`/`Find` steht **kein** `IsEmpty()`.
> Siehe [`05-gob-richtlinien.md`](05-gob-richtlinien.md).

BC kennt eine feste Menge von Tabellenarten. Jede Anforderung lässt sich einer davon zuordnen.
Die Zuordnung entscheidet über Primärschlüssel, Trigger, Löschverhalten und Pages.

```
Stammdaten          Bewegungsdaten              Historie
──────────          ──────────────              ────────
Setup               Document Header             Posted Doc. Header
Master        ───▶  Document Line         ───▶  Posted Doc. Line
Supplemental        Journal Line                Ledger Entry
Subsidiary                                      Register
```

---

## Setup

Eine einzige Zeile pro Mandant, PK ist ein leerer Code.

```al
table 63000 "PTE Commission Mgt. Setup"
{
    Caption = 'Commission Management Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Commission Contract Nos."; Code[20])
        {
            Caption = 'Commission Contract Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the number series for commission contracts.';
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
```

Regeln:
- Der Datensatz wird **von der Page** angelegt, nicht von der Tabelle (`OnOpenPage`, siehe `30-page-patterns.md`).
- Setup-Werte werden im Code über `Get()` gelesen und einmal pro Buchungslauf gecacht.
- Rundungs-, Nummernserien- und Schalterfelder gehören hierher, nicht in die Stammdaten.

Muster: `SolDev/Final/src/table/SMBSeminarSetup.Table.al`

---

## Master

Die Haupttabelle des Moduls. Erkennungsmerkmal: eigene Nummernserie, Karte + Übersicht.

### Pflichtausstattung

| Feld / Element | Zweck |
|---|---|
| `No.` (Code[20]) | PK, Nummernserie |
| `Description`, ggf. `Description 2` | Bezeichnung |
| `Search Description` (Code[100]) | Suchbegriff, wird aus `Description` vorbelegt |
| `Blocked` (Boolean) + `TestBlocked()` | Sperrkennzeichen |
| `Last Date Modified` (Date) | im `OnModify`/`OnRename` gesetzt |
| `No. Series` (Code[20]) | `Editable = false` |
| `Comment` (Boolean, FlowField) | wenn Bemerkungen implementiert sind |
| Buchungsgruppen | `Gen. Prod. Posting Group`, `VAT Prod. Posting Group` |
| `Global Dimension 1/2 Code` | mit `CaptionClass = '1,1,1'` bzw. `'1,1,2'` |
| `fieldgroups` | `DropDown` und `Brick` |
| `LookupPageId` / `DrillDownPageId` | zeigen auf die List-Page |

### Nummernserie – aktuelle API

Die alte Codeunit `NoSeriesManagement` ist abgelöst. Verwende `Codeunit "No. Series"`:

```al
trigger OnInsert()
begin
    if "No." = '' then begin
        SetupRec.Get();
        SetupRec.TestField("Commission Contract Nos.");
        "No. Series" := SetupRec."Commission Contract Nos.";
        if NoSeries.AreRelated("No. Series", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := NoSeries.GetNextNo("No. Series");

        // Schutz gegen Kollision mit manuell vergebenen Nummern
        RecCheck.ReadIsolation(IsolationLevel::ReadUncommitted);
        RecCheck.SetLoadFields("No.");
        while RecCheck.Get("No.") do
            "No." := NoSeries.GetNextNo("No. Series");
    end;
end;
```

Dazu gehören zwingend:

```al
// 1. Prüfung auf manuelle Nummernvergabe
field(1; "No."; Code[20])
{
    trigger OnValidate()
    begin
        if "No." <> xRec."No." then begin
            SetupRec.Get();
            NoSeries.TestManual(SetupRec."Commission Contract Nos.");
            "No. Series" := '';
        end;
    end;
}

// 2. Nummernserienauswahl, aufgerufen aus dem Page-Control OnAssistEdit()
procedure AssistEdit(OldRec: Record "PTE Commission Contract") Result: Boolean
begin
    RecLocal := Rec;
    SetupRec.Get();
    SetupRec.TestField("Commission Contract Nos.");
    if NoSeries.LookupRelatedNoSeries(
        SetupRec."Commission Contract Nos.", OldRec."No. Series", RecLocal."No. Series")
    then begin
        RecLocal."No." := NoSeries.GetNextNo(RecLocal."No. Series");
        Rec := RecLocal;
        exit(true);
    end;
end;
```

Bei **Belegen** wird zusätzlich das Buchungsdatum übergeben, weil die Nummernserie
chronologisch sein kann: `NoSeries.GetNextNo("No. Series", "Posting Date")`.

### Suchbegriff

```al
field(3; Description; Text[100])
{
    trigger OnValidate()
    begin
        if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
            "Search Description" := CopyStr(Description, 1, MaxStrLen("Search Description"));
    end;
}
```

Die Bedingung ist wichtig: Ein vom Anwender **manuell** gesetzter Suchbegriff darf nicht
überschrieben werden.

### Wechselseitige Plausibilitätsprüfung

Zwei zusammenhängende Felder werden **in beiden** `OnValidate` geprüft:

```al
field(41; "Starting Date"; Date)
{
    trigger OnValidate()
    begin
        if ("Ending Date" <> 0D) and ("Starting Date" > "Ending Date") then
            FieldError("Starting Date", StrSubstNo(MustBeLEErr, FieldCaption("Ending Date")));
    end;
}
field(42; "Ending Date"; Date)
{
    trigger OnValidate()
    begin
        if ("Starting Date" <> 0D) and ("Ending Date" < "Starting Date") then
            FieldError("Ending Date", StrSubstNo(MustBeGEErr, FieldCaption("Starting Date")));
    end;
}
```

### Löschbedingungen und Löschweitergabe

Die Reihenfolge ist zwingend: **erst prüfen (und ggf. abbrechen), dann weitergeben.**

```al
trigger OnDelete()
var
    DependentRec: Record "…";
    CommentLine: Record "PTE Commission Comment Line";
begin
    // 1. Blockierende Prüfung – Verweise, die das Löschen verbieten
    DependentRec.SetRange("Commission Contract No.", "No.");
    if not DependentRec.IsEmpty() then
        Error(CannotDeleteErr, TableCaption, DependentRec.TableCaption);

    // 2. Löschweitergabe – untergeordnete Daten, die mitgehen
    CommentLine.SetRange("No.", "No.");
    CommentLine.DeleteAll();

    // 3. Posten werden NIEMALS mitgelöscht.
end;
```

`IsEmpty()` statt `Count()` – siehe `70-rules-and-checklist.md`.

### `TestBlocked`

```al
procedure TestBlocked()
begin
    TestField(Blocked, false);
end;
```

Wird von jeder Tabelle aufgerufen, die diesen Stammsatz referenziert – nicht direkt
`TestField(Blocked, false)` beim Aufrufer, damit die Prüfung an einer Stelle liegt.

Muster: `SolDev/Final/src/table/SMBSeminar.Table.al`

---

## Supplemental / Subsidiary

Ergänzungstabellen (eigener PK, z. B. `Code`) und Zuordnungstabellen (zusammengesetzter PK,
verweist auf zwei Master).

Ausstattung wie Master, aber meist ohne Nummernserie, PK ist ein `Code[20]`, den der Anwender
vergibt. `Blocked` + `TestBlocked()` gehören trotzdem dazu.

Muster: `SolDev/Final/src/table/SMBSeminarRoom.Table.al`, `SMBInstructor.Table.al`

---

## Comment Line

Ein festes BC-Muster, das die Specs regelmäßig fordern („vgl. Business Central z. B.
Debitorenkarte").

Zwei Varianten:

**A) An eine Stammdatentabelle** – dann die Standardtabelle `Comment Line` per `enumextension`
erweitern, keine eigene Tabelle:

```al
enumextension 63000 "PTE Comment Line Table Name" extends "Comment Line Table Name"
{
    value(63000; "PTE Commission Contract") { Caption = 'Commission Contract'; }
}
```

Dazu im Master:

```al
field(27; Comment; Boolean)
{
    Caption = 'Comment';
    Editable = false;
    FieldClass = FlowField;
    CalcFormula = exist("Comment Line" where("Table Name" = const("PTE Commission Contract"),
                                             "No." = field("No.")));
}

trigger OnRename()
begin
    CommentLine.RenameCommentLine(CommentLine."Table Name"::"PTE Commission Contract", xRec."No.", "No.");
end;
```

**B) Eigene Bemerkungstabelle**, wenn Belegarten unterschieden werden müssen (ungebucht /
gebucht). PK: `"Document Type", "No.", "Document Line No.", "Line No."`.

Pflichtprozeduren, die das Standardmuster mitbringt:

| Prozedur | Zweck |
|---|---|
| `SetUpNewLine()` | Datum vorbelegen, aus `OnNewRecord` der Page gerufen |
| `CopyComments(…)` | beim Buchen in den gebuchten Beleg kopieren |
| `DeleteComments(…)` | Löschweitergabe |
| `ShowComments(…)` | gefiltert öffnen |

Muster: `SolDev/Final/src/table/SMBSeminarCommentLine.Table.al`

Die Spec-Formulierung „In einem zukünftigen Release wird die Bemerkungstabelle auch an andere
Tabellen angebunden" ist ein klarer Hinweis auf Variante **B** mit einem `Document Type`-Enum,
das `Extensible = true` ist.

---

## Document Header + Line

Der Beleg. PK-Konvention:

```
Header:  [Document Type,] "No."
Line:    [Document Type,] "Document No.", "Line No."
```

### Header – Pflichtausstattung

| Element | Regel |
|---|---|
| `No.` + `No. Series` | Nummernserie wie beim Master, aber mit `Posting Date` |
| `Status` (Enum) | steuert, welche Felder wann änderbar sind |
| `Posting Date`, `Document Date`, `Posting Description` | in `InitRecord()` vorbelegt |
| `Posting No.`, `Posting No. Series`, `Last Posting No.` | Zielnummernkreis für den gebuchten Beleg |
| `Responsibility Center` | `UserSetupMgt.GetRespCenter(…)` |
| `Dimension Set ID`, `Shortcut Dimension 1/2 Code` | Dimensionen |
| `OnRename` | `Error(CannotRenameErr, TableCaption)` – Belege werden nie umbenannt |

### `InitInsert` / `InitRecord`

```al
trigger OnInsert()
begin
    InitInsert();

    // Vorbelegung des Fremdschlüssels, wenn der Beleg aus dem Stammsatz heraus
    // angelegt wird (Muster: Table "Sales Header")
    if GetFilter("Salesperson Code") <> '' then
        if GetRangeMin("Salesperson Code") = GetRangeMax("Salesperson Code") then
            Validate("Salesperson Code", GetRangeMin("Salesperson Code"));
end;

local procedure InitInsert()
begin
    if "No." = '' then begin
        Setup.Get();
        Setup.TestField("… Nos.");
        "No. Series" := Setup."… Nos.";
        if NoSeries.AreRelated("No. Series", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
        …
    end;
    InitRecord();
end;

local procedure InitRecord()
begin
    Setup.Get();
    if "Posting No. Series" = '' then
        if NoSeries.IsAutomatic(Setup."Posted … Nos.") then
            "Posting No. Series" := Setup."Posted … Nos.";

    if "Posting Date" = 0D then
        "Posting Date" := WorkDate();
    "Document Date" := WorkDate();
    "Posting Description" := TableCaption + ' ' + "No.";
    "Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
end;
```

### Statusprüfungen

Zentrale, wiederverwendbare Prozeduren statt verstreuter `if`-Abfragen:

```al
local procedure TestStatusPlanning()
begin
    if Status <> Status::Planning then
        FieldError(Status, StrSubstNo(StatusMustBeErr, Status::Planning));
end;

procedure TestStatusOpen()
begin
    if Status in [Status::Canceled, Status::Closed] then
        FieldError(Status);
end;

local procedure TestNoLine()
var
    Line: Record "…";
begin
    Line.SetRange("Document No.", "No.");
    if not Line.IsEmpty() then
        Error(LineExistErr, Line.TableCaption, TableCaption);
end;
```

Diese werden aus **jedem** `OnValidate` gerufen, dessen Feld nach Erfassung von Zeilen nicht
mehr geändert werden darf.

### Stammdaten in den Beleg übernehmen

Feste Abfolge im `OnValidate` des Fremdschlüsselfelds:

```al
trigger OnValidate()
begin
    TestStatusPlanning();          // 1. Darf überhaupt geändert werden?
    TestNoLine();                  // 2. Gibt es schon Zeilen?
    Master.Get("Master No.");      // 3. Stammsatz lesen
    Master.TestBlocked();          // 4. Darf er verwendet werden?
    FillHeaderFieldsFromMaster();  // 5. Felder übernehmen
end;
```

### Kopfänderung an die Zeilen weiterreichen

```al
procedure UpdateLinesByFieldNo(ChangedFieldNo: Integer; AskQuestion: Boolean)
var
    "Field": Record "Field";
    Line: Record "…";
    ConfirmUpdateLinesQst: Label 'You have modified %1.\\Do you want to update the lines?',
        Comment = '%1 = caption of the changed field';
begin
    Line.Reset();
    Line.SetRange("Document No.", "No.");
    if Line.IsEmpty() then
        exit;

    Field.Get(Database::"…", ChangedFieldNo);

    if AskQuestion and GuiAllowed() then
        if not Confirm(StrSubstNo(ConfirmUpdateLinesQst, Field."Field Caption"), true) then
            exit;

    Line.LockTable();
    Modify();

    if Line.FindSet() then
        repeat
            case ChangedFieldNo of
                FieldNo("Commission %"):
                    Line.Validate("Commission %", "Commission %");
            end;
            Line.Modify(true);
        until Line.Next() = 0;
end;
```

Aufruf im Feld: `UpdateLinesByFieldNo(FieldNo("Commission %"), CurrFieldNo <> 0);`
Der `CurrFieldNo <> 0` sorgt dafür, dass **nur bei Eingabe über die Oberfläche** gefragt wird.

### Line – Initialisierung über das führende Feld

Jede Belegzeile hat **ein führendes Feld**, dessen `OnValidate` die ganze Zeile initialisiert
(bei Verkauf: `Bill-to Customer No.`). Dort werden Daten aus dem Stammsatz **und** aus dem Kopf
geholt:

```al
trigger OnValidate()
begin
    TestStatusOpen();
    Customer.Get("Bill-to Customer No.");
    Customer.TestField(Blocked, Customer.Blocked::" ");
    Customer.TestField("Gen. Bus. Posting Group");
    "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
    …
    GetHeader();
    Validate("Price (LCY)", Header."Price");
    "Registration Date" := WorkDate();
end;
```

Der Kopf wird gecacht gelesen, nicht bei jedem Zugriff neu:

```al
procedure GetHeader()
begin
    if "Document No." <> Header."No." then
        Header.Get("Document No.");
end;
```

### Line – Rabatt- und Betragslogik

Vier Felder, die sich gegenseitig aktualisieren (Muster: `Sales Line`):

| Feld | `OnValidate` tut |
|---|---|
| `Price (LCY)` | `Validate("Line Discount %")` |
| `Line Discount %` | Rabattbetrag berechnen, dann `UpdateAmounts()` |
| `Line Discount Amount (LCY)` | Rabatt-% zurückrechnen, dann `UpdateAmounts()` |
| `Line Amount (LCY)` | in Rabattbetrag umrechnen und diesen validieren |

```al
local procedure UpdateAmounts()
begin
    "Line Amount (LCY)" := Round("Price (LCY)" - "Line Discount Amount (LCY)");

    if "Currency Code" <> '' then begin
        Currency.Get("Currency Code");
        Currency.TestField("Amount Rounding Precision");
        "Line Amount" := Round(
            CurrExchRate.ExchangeAmtLCYToFCY(GetDate(), "Currency Code",
                "Line Amount (LCY)", "Currency Factor"),
            Currency."Amount Rounding Precision");
    end else
        "Line Amount" := "Line Amount (LCY)";
end;
```

Muster: `SolDev/Final/src/table/SMBSeminarRegLine.Table.al`, Schaubild im Blatt „Rabatt" und
„Währung" von `SolDev/SolDev0726.xlsx`.

---

## Journal Line

Frei editierbares Arbeitsblatt. Zusammengesetzter PK (`Journal Template Name`,
`Journal Batch Name`, `Line No.`) – bei rein programmatisch gefüllten Buchblättern reicht das
reduzierte Muster der Musterlösung.

Pflicht: `EmptyLine()` als Prozedur, damit Check und Post leere Zeilen überspringen können.

Muster: `SolDev/Final/src/table/SMBSeminarJournalLine.Table.al`

---

## Ledger Entry

**Die wichtigste Tabelle des Moduls.** Die Spec-Formulierung „das Postenkonzept von BC zugrunde
legen (d. h. es werden nie Posten gelöscht, nur hinzugefügt)" meint exakt dieses Muster.

| Regel | |
|---|---|
| PK | `"Entry No."` (Integer), beginnend bei 1 |
| Schreibschutz | Nie direkt aus einer Page einfügen, ändern oder löschen |
| Erzeugung | Ausschließlich über die `Jnl.-Post Line`-Codeunit |
| Sekundärschlüssel | Viele, passend zu den Auswertungen (`SumIndexFields` für Summen) |
| Herkunft | `Source Code`, `Reason Code`, `User ID`, `No. Series` |
| Verknüpfung | Fremdschlüssel auf den auslösenden Beleg und ggf. auf korrespondierende Posten |

```al
keys
{
    key(PK; "Entry No.") { Clustered = true; }
    key(Key01; "Document No.", "Posting Date") { }                // für Navigate
    key(Key02; "Bill-to Customer No.", "Closed by Document No.") { }
    key(Key03; "Salesperson Code", "Posting Date")
    {
        SumIndexFields = "Commission Amount";                      // für FlowFields/Statistik
    }
}

procedure GetLastEntryNo(): Integer
var
    FindRecordManagement: Codeunit "Find Record Management";
begin
    exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
end;

procedure CopyFromJnlLine(JnlLine: Record "…")
begin
    "Posting Date" := JnlLine."Posting Date";
    …
    "Dimension Set ID" := JnlLine."Dimension Set ID";
end;
```

`GetLastEntryNo()` und `CopyFrom…()` gehören **in die Postentabelle**, nicht in die Codeunit.

Muster: `SolDev/Final/src/table/SMBSeminarLedgerEntry.Table.al`

---

## Register

Klammert die Posten eines Buchungslaufs. PK `"No."` (Integer), Felder `From Entry No.`,
`To Entry No.`, `Creation Date`, `Creation Time`, `Source Code`, `Journal Batch Name`, `User ID`.
Ebenfalls mit `GetLastEntryNo()`.

Muster: `SolDev/Final/src/table/SMBSeminarRegister.Table.al`

---

## Posted Document Header + Line

Kopie der ungebuchten Belegtabellen mit denselben Feldnummern (wegen `TransferFields`), aber:

- **kein** Validierungs- und Lookup-Code, **keine** Tabellentrigger-Logik
- `LookupPageID` / `DrillDownPageID` / `Caption` auf die gebuchten Pages umgestellt
- Table Relation der Zeile auf den **gebuchten** Kopf
- zusätzliche Felder `User ID`, `Source Code`, `No. Printed`
- zusätzliche Herkunftsfelder auf den Ursprungsbeleg (`Registration No.`, `Registration No. Series`)
- `OnDelete`: `No. Printed > 0` prüfen, Bemerkungen löschen

Muster: `SolDev/Final/src/table/SMBPostedSeminarRegHeader.Table.al`

---

## Cue

Für das Rollencenter. Eine Zeile, PK `"Primary Key"` (Code[10]), Zählfelder als `FlowField`
(`count`/`sum`), Filterfelder als `FlowFilter`.

```al
field(1; "Primary Key"; Code[10])
{
    AllowInCustomizations = Never;
    Caption = 'Primary Key';
}
field(2; "Contracts - Active"; Integer)
{
    Caption = 'Contracts - Active';
    Editable = false;
    FieldClass = FlowField;
    CalcFormula = count("PTE Commission Contract" where(Status = const(Active),
                                                        "Date Filter" = field("Date Filter")));
    ToolTip = 'Specifies the number of active commission contracts.';
}
field(20; "Date Filter"; Date)
{
    Caption = 'Date Filter';
    Editable = false;
    FieldClass = FlowFilter;
}
```

Muster: `SolDev/Final/src/table/SMBSeminarCue.Table.al`

---

## FlowFields und FlowFilters allgemein

Die Spec-Anforderung „Auf den Verkäufer-Masken soll sofort ablesbar sein, wie viel Provision ein
Verkäufer bekommt. Dieser Wert soll auch auf Perioden filterbar sein" ist die
Standard-Beschreibung eines **FlowField mit FlowFilter**:

```al
field(63000; "PTE Commission Amount"; Decimal)
{
    Caption = 'Commission Amount';
    Editable = false;
    FieldClass = FlowField;
    AutoFormatType = 1;
    CalcFormula = sum("PTE Commission Ledger Entry"."Commission Amount"
                      where("Salesperson Code" = field(Code),
                            "Posting Date" = field("PTE Date Filter")));
    ToolTip = 'Specifies the total commission amount for the salesperson.';
}
field(63001; "PTE Date Filter"; Date)
{
    Caption = 'Date Filter';
    FieldClass = FlowFilter;
    ToolTip = 'Specifies the date interval used to filter the commission amount.';
}
```

Damit die Summe performant ist, braucht die Postentabelle einen passenden Schlüssel mit
`SumIndexFields`.
