# 50 – Integration in die Standardapplikation

Die Spezifikationen fordern regelmäßig: „Die Lösung soll in den Sales-Bereich von Business
Central integriert werden. Dabei soll die User-Experience mit einem herkömmlichen Business
Central Modul vergleichbar sein."

Das heißt konkret: Erweitern, nicht danebenbauen.

---

## Extension-Objekte

### `tableextension`

```al
tableextension 63000 "GOB Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        field(63000; "GOB Commission Contract No."; Code[20])
        {
            Caption = 'Commission Contract No.';
            DataClassification = CustomerContent;
            TableRelation = "GOB Commission Contract";
            ToolTip = 'Specifies the commission contract assigned to the salesperson.';
        }
        field(63001; "GOB Commission Amount"; Decimal)
        {
            Caption = 'Commission Amount';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            CalcFormula = sum("GOB Commission Ledger Entry"."Commission Amount"
                              where("Salesperson Code" = field(Code),
                                    "Posting Date" = field("GOB Date Filter")));
            ToolTip = 'Specifies the total commission amount calculated for the salesperson.';
        }
        field(63002; "GOB Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
            ToolTip = 'Specifies the period used to calculate the commission amount.';
        }
    }
}
```

Regeln:
- Feldnummern innerhalb des eigenen ID-Bereichs.
- Feldnamen mit Prefix.
- `DataClassification` ist bei neuen Feldern Pflicht.
- Löschweitergabe für Daten, die an diesem Fremdschlüssel hängen, kann **nicht** in der
  `tableextension` erzwungen werden → dafür einen Subscriber auf `OnAfterDeleteEvent` der
  Basistabelle nutzen.

### `pageextension`

Siehe `30-page-patterns.md`.

### `enumextension`

```al
enumextension 63000 "GOB Comment Line Table Name" extends "Comment Line Table Name"
{
    value(63000; "GOB Commission Contract") { Caption = 'Commission Contract'; }
}
```

Die Basis-Enum muss `Extensible = true` sein. Eigene Enums, die andere erweitern können sollen,
bekommen diese Property ebenfalls.

---

## Herkunftscode (Source Code)

Jedes Fragment, das eine Buchung erzeugt, muss eine Herkunft tragen. Dafür wird die
Standard-Einrichtung erweitert:

```al
tableextension 63001 "GOB Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(63000; "GOB Commission"; Code[10])
        {
            Caption = 'Commission';
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            ToolTip = 'Specifies the source code assigned to commission postings.';
        }
    }
}

pageextension 63001 "GOB Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        addlast(Content)
        {
            group("GOB Commission Group")
            {
                Caption = 'Commission';
                field("GOB Commission"; Rec."GOB Commission")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
```

Gelesen wird der Code **einmal pro Buchungslauf** in der Post-Codeunit.

Muster: `SolDev/Final/src/tableextension/SMBSourceCodeSetup.TableExt.al` +
`SolDev/Final/src/pageextension/SMBSourceCodeSetup.PageExt.al`

---

## Event-Subscriber

Der Weg, in Standardprozesse einzugreifen, ohne sie zu verändern.

### Aufbau

```al
codeunit 63010 "GOB Commission Invoicing"
{
    Permissions = tabledata "GOB Commission Ledger Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterTestSalesLine, '', false, false)]
    local procedure CheckCommissionOnAfterTestSalesLine(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; …)
    var
        CommissionLedgerEntry: Record "GOB Commission Ledger Entry";
    begin
        if (SalesLine."GOB Apply-to Commission Entry" <> 0) and
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)
        then begin
            CommissionLedgerEntry.Get(SalesLine."GOB Apply-to Commission Entry");
            CommissionLedgerEntry.TestField("Closed by Document No.", '', ErrorInfo.Create());
        end;
    end;
}
```

### Regeln

| Regel | Warum |
|---|---|
| Subscriber sind **immer** `local procedure` | Sie sollen nicht direkt aufrufbar sein |
| Die Parameterliste muss **exakt** der Signatur des Publishers entsprechen | Sonst Kompilierfehler |
| Sprechende Prozedurnamen: `<WasPassiert>On<EventName>` | Fehlersuche |
| Subscriber-Codeunits nach Thema gruppieren | Eine Codeunit pro Integrationsthema |
| Kein UI in Subscribern innerhalb von Buchungsläufen | Bricht Hintergrundverarbeitung |
| Die Signatur **nicht raten** | Im Symbol nachsehen oder per Go-to-Definition holen |
| **Kein Code im Subscriber – nur ein Funktionsaufruf** | GOB-Richtlinie: Projekte müssen die Logik übersteuern können |
| **Früh aussteigen**, wenn das Szenario nicht zutrifft | `if not IsRelevantStuff() then exit;` |
| **`if not RunTrigger() then exit;`** | Insert/Modify/Delete-Trigger nicht ungewollt auslösen |
| **`if Rec.IsTemporary() then exit;`** | Sonst zerstört kaskadierende Logik echte Daten |

### Die zwei letzten Parameter – **immer `false, false`**

`[EventSubscriber(…, '', SkipOnMissingLicense, SkipOnMissingPermission)]`

> ⚠️ **GOB-Richtlinie:** Beide müssen **immer `false`** sein. Subscriber sollen zur Laufzeit mit
> Fehler abbrechen, wenn Lizenz oder Berechtigung fehlen – sonst werden Programmteile unerkannt
> nicht durchlaufen und Daten werden inkonsistent.
> Siehe [`05-gob-richtlinien.md`](05-gob-richtlinien.md), Teil F.

Das gilt auch für Filter-Token-Subscriber: Die Musterlösung verwendet dort `true, true` – das
ist nach dieser Regel unzulässig.

### Feldvalidierung: Trigger statt Subscriber

Für Code, der nach dem Validate eines **Standardfelds** laufen soll, ist der Trigger in der
Table Extension der empfohlene Weg – nicht ein `OnAfterValidateEvent`-Subscriber:

```al
tableextension 63000 "GOB Salesperson/Purchaser" extends "Salesperson/Purchaser"
{
    fields
    {
        modify("Commission %")
        {
            trigger OnAfterValidate()
            begin
                PreventCommissionPctWhenContractAssigned(Rec, xRec, CurrFieldNo);
            end;
        }
    }
}
```

Vorteile: Pro App gibt es nur **eine** Table Extension, der Code ist also auffindbar, und man
kommt an `protected var` der Tabelle heran. Dasselbe gilt für Page Extensions, wo im
`modify(Control)`-Block `OnBeforeValidate`, `OnAfterValidate`, `OnLookup`, `OnDrilldown`,
`OnAssistEdit` und `OnAfterAfterLookup` zur Verfügung stehen.

Muster: `SolDev/Final/src/codeunit/SMBSeminarInvoicing.Codeunit.al`

---

## Beleg-Verknüpfung Standard ⇄ eigene Posten

Das Muster, mit dem eigene Posten über den Standard-Verkaufsprozess abgerechnet und
geschlossen werden:

1. `tableextension` auf `"Sales Line"` mit Feld `"GOB Apply-to Commission Entry"` (Integer)
2. `tableextension` auf `"Sales Invoice Line"` mit demselben Feld
   (damit es beim Buchen mitwandert — `Sales-Post` überträgt gleichnamige Felder)
3. Feld `"Closed by Document No."` in der eigenen Postentabelle
4. Subscriber auf `OnAfterTestSalesLine` → prüft, ob der Posten schon geschlossen ist
5. Subscriber auf `OnAfterSalesInvLineInsert` → schließt den Posten

```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvLineInsert, '', false, false)]
local procedure CloseCommissionEntryOnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; …; SalesLine: Record "Sales Line"; …)
var
    CommissionLedgerEntry: Record "GOB Commission Ledger Entry";
begin
    if SalesLine."GOB Apply-to Commission Entry" <> 0 then begin
        CommissionLedgerEntry.Get(SalesLine."GOB Apply-to Commission Entry");
        CommissionLedgerEntry."Closed by Document No." := SalesInvLine."Document No.";
        CommissionLedgerEntry.Modify();
    end;
end;
```

---

## Navigate („Verbindungsinfo suchen")

Damit die eigenen gebuchten Belege und Posten in der Standard-Navigate-Funktion auftauchen.

```al
codeunit 63004 "GOB Commission Navigate"
{
    var
        PostedDocHeader: Record "GOB Posted Commis. Doc. Header";
        CommissionLedgerEntry: Record "GOB Commission Ledger Entry";

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterFindRecords, '', false, false)]
    local procedure InsertRecordsOnAfterFindRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindPostedDocuments(DocumentEntry, DocNoFilter, PostingDateFilter);
        FindLedgerEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure ShowRecordsOnAfterShowRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; …)
    begin
        case DocumentEntry."Table ID" of
            Database::"GOB Posted Commis. Doc. Header":
                begin
                    SetPostedDocFilter(DocNoFilter, PostingDateFilter);
                    Page.Run(Page::"GOB Posted Commission Document", PostedDocHeader);
                end;
            Database::"GOB Commission Ledger Entry":
                begin
                    SetLedgerEntryFilter(DocNoFilter, PostingDateFilter);
                    Page.Run(0, CommissionLedgerEntry);
                end;
        end;
    end;

    local procedure FindLedgerEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;
        if CommissionLedgerEntry.ReadPermission() then begin        // ← Berechtigung prüfen!
            SetLedgerEntryFilter(DocNoFilter, PostingDateFilter);
            DocumentEntry.InsertIntoDocEntry(
                Database::"GOB Commission Ledger Entry",
                CommissionLedgerEntry.TableCaption(),
                CommissionLedgerEntry.Count());
        end;
    end;

    local procedure SetLedgerEntryFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        CommissionLedgerEntry.Reset();
        CommissionLedgerEntry.SetCurrentKey("Document No.", "Posting Date");   // ← passender Key!
        CommissionLedgerEntry.SetFilter("Document No.", DocNoFilter);
        CommissionLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
    end;
}
```

Zwei Punkte, die leicht vergessen werden:

1. **`ReadPermission()` prüfen**, bevor gezählt wird – sonst Fehler bei Anwendern ohne Rechte.
2. Ein **Sekundärschlüssel** `("Document No.", "Posting Date")` in der Postentabelle, sonst
   wird Navigate langsam.

`Navigate` wird zusätzlich als Action eingebunden in: gebuchte Belegkarte, gebuchte
Belegübersicht, Postenliste, Journal.

Muster: `SolDev/Final/src/codeunit/SMBSeminarNavigate.Codeunit.al`

---

## Filter Token

Erlaubt Filter wie `%MYCONTRACT` in jedem Filterfeld.

```al
codeunit 63030 "GOB Commission Filter Token"
{
    // GOB-Richtlinie: letzte beide Parameter immer false, false
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', false, false)]
    local procedure ResolveMyContractToken(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        MyContract: Record "GOB My Commission Contract";
        MaxCount: Integer;
        MyTokenTxt: Label 'MYCONTRACT', Comment = 'Must be uppercase', Locked = true;
    begin
        if StrLen(TextToken) < 3 then
            exit;
        if StrPos(UpperCase(MyTokenTxt), UpperCase(TextToken)) = 0 then
            exit;

        Handled := true;

        MaxCount := 20;
        MyContract.SetRange("User ID", UserId());
        if MyContract.FindSet() then begin
            MaxCount -= 1;
            TextFilter := MyContract."Contract No.";
            if MyContract.Next() <> 0 then
                repeat
                    MaxCount -= 1;
                    TextFilter += '|' + MyContract."Contract No.";
                until (MyContract.Next() = 0) or (MaxCount <= 0);
        end;
    end;
}
```

Zum Token gehören eine „My …"-Tabelle (PK `User ID` + Fremdschlüssel) und eine „My …"-Page für
das Rollencenter.

Muster: `SolDev/Final/src/codeunit/SMBMySeminarFilterToken.Codeunit.al`,
`SolDev/Final/src/table/SMBMySeminar.Table.al`

---

## Dimensionen

Dimensionen wandern seit NAV 2013 als **`Dimension Set ID`** durch alle Tabellen — nicht mehr
als kopierte Dimensionszeilen.

### Wo sie hingehören

| Tabelle | Felder |
|---|---|
| Stammdaten | `Global Dimension 1/2 Code` mit `CaptionClass = '1,1,1'` / `'1,1,2'` |
| Belegkopf und -zeile | `Dimension Set ID` (480), `Shortcut Dimension 1/2 Code` (490/491) mit `CaptionClass = '1,2,1'` / `'1,2,2'` |
| Buch.-Blattzeile | `Dimension Set ID` |
| Posten | `Dimension Set ID` + `Shortcut Dimension 1–8 Code` (481–486 als FlowFields) |

### Weitergabe

Nur die ID wird zugewiesen – keine Kopierlogik:

```al
JnlLine."Dimension Set ID" := DocLine."Dimension Set ID";
LedgerEntry."Dimension Set ID" := JnlLine."Dimension Set ID";
SalesLine.Validate("Dimension Set ID", LedgerEntry."Dimension Set ID");
```

Vom Stammsatz in den Beleg wandern die **Shortcut-Codes**:

```al
"Shortcut Dimension 1 Code" := Master."Global Dimension 1 Code";
"Shortcut Dimension 2 Code" := Master."Global Dimension 2 Code";
```

Für das Zusammenführen von Standard- und Belegdimensionen ist Codeunit 408
`DimensionManagement` zuständig.

### CaptionClass

Dimensionsfelder tragen niemals eine feste Caption, sondern eine `CaptionClass`, damit im
Client der vom Anwender vergebene Dimensionsname erscheint:

```
'1,1,<n>'   Code-Caption einer globalen Dimension n
'1,2,<n>'   Code-Caption einer Shortcut-Dimension n
```

---

## Zuständigkeitseinheiten (Responsibility Center)

```al
"Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
```

Und für die Filterung in Cues:

```al
procedure SetRespCenterFilter()
var
    UserSetupMgt: Codeunit "User Setup Management";
    RespCenterCode: Code[10];
begin
    RespCenterCode := UserSetupMgt.GetSalesFilter();
    if RespCenterCode <> '' then begin
        FilterGroup(2);                                  // für den Anwender unsichtbar
        SetRange("Responsibility Center Filter", RespCenterCode);
        FilterGroup(0);
    end;
end;
```

`FilterGroup(2)` ist der Filterbereich, den der Anwender nicht entfernen kann.

---

## Nummernserien-Beziehungen

```al
NoSeries.AreRelated(NewSeriesCode, OldSeriesCode)        // Ist der Wechsel zulässig?
NoSeries.TestAreRelated(DefaultCode, ChosenCode)         // Prüfen und ggf. Fehler
NoSeries.LookupRelatedNoSeries(DefaultCode, …)           // Auswahl anbieten
NoSeries.IsAutomatic(SeriesCode)                         // Wird automatisch vergeben?
NoSeries.TestManual(SeriesCode)                          // Darf manuell erfasst werden?
NoSeries.GetNextNo(SeriesCode[, PostingDate])            // Nächste Nummer
```

Bei Belegen mit chronologischer Nummernserie muss eine nachträgliche Änderung des
Buchungsdatums geprüft werden:

```al
procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[20]; NoCapt: Text; NoSeriesCapt: Text)
begin
    if (No <> '') and (NoSeriesCode <> '') then begin
        GlobalNoSeries.Get(NoSeriesCode);
        if GlobalNoSeries."Date Order" then
            Error(CannotChangeFieldErr, FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  GlobalNoSeries.FieldCaption("Date Order"), GlobalNoSeries."Date Order",
                  TableCaption, NoCapt, No);
    end;
end;
```
