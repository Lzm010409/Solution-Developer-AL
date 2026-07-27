# 40 – Buchungsarchitektur

Das Kernstück jeder BC-Erweiterung, die Bewegungsdaten verarbeitet. Hier wird **nicht**
improvisiert – die Struktur ist im Standard festgelegt und wird 1:1 übernommen.

---

## Die zwei Ketten

### A) Buch.-Blattbuchung (Journal Posting)

```
        Journal Line
             │
    ┌────────┴────────┐
    │  Post Line (x2) │ ──── ruft ───▶  Check Line (x1)
    └────────┬────────┘
             │ erzeugt
      ┌──────┴───────┐
   Register      Ledger Entry
```

### B) Belegbuchung (Document Posting)

```
   Document Header  ──(Page-Action, F9)──▶  Post (Yes/No)  (x1)
                                                  │ Rückfrage
                                                  ▼
                                             Post  (x0)
                                                  │
              ┌───────────────────────────────────┼──────────────────────────┐
              ▼                                   ▼                          ▼
     Posted Doc. Header                    Journal Line              Posted Doc. Line
     Posted Doc. Line                            │
                                                 ▼
                                          Jnl.-Post Line (x2)
                                                 │  ruft Jnl.-Check Line (x1)
                                                 ▼
                                       Register + Ledger Entry
```

Schaubild in `SolDev/SolDev0726.xlsx`, Blätter „Man. Buchung" und „Beleg Buchung".

---

## Nomenklatur der Codeunit-IDs

Die **Endziffer** der Codeunit-ID ist bedeutungstragend. Das ist BC-Konvention und keine
Geschmacksfrage.

### Verwaltungs- und Starter-Codeunits

| Endziffer | Name | Zweck |
|---|---|---|
| `0` | Journal Management / Document – Post | Verwaltung bzw. der eigentliche Belegbuchungslauf |
| `1` | Journal Post / Document – Post (Yes/No) | Starter mit UI-Interaktion |
| `2` | Journal Post+Print / Document – Post+Print | Starter mit Druck |
| `3` | Journal Batch Post | Stapel buchen |
| `4` | Journal Batch Post+Print | Stapel buchen und drucken |
| `5` | Show Ledger | Posten zu einem Journaleintrag anzeigen |

### Buchungsroutinen (kein UI erlaubt)

| Endziffer | Name | Zweck |
|---|---|---|
| `1` | Jnl.-Check Line | Schnelltest einer Buch.-Blattzeile, möglichst ohne DB-Zugriff |
| `2` | Jnl.-Post Line | Buchen einer Zeile in einen oder mehrere Posten |
| `3` | Jnl.-Post Batch | Buchen eines Stapels |

**Beispiel aus der Musterlösung:**

| ID | Objekt |
|---|---|
| `123456700` | `SMB Seminar-Post` (Document – Post, Endziffer 0) |
| `123456701` | `SMB Seminar-Post (Yes/No)` (Starter, Endziffer 1) |
| `123456731` | `SMB Sem. Jnl.-Check Line` (Endziffer 1) |
| `123456732` | `SMB Sem. Jnl.-Post Line` (Endziffer 2) |

Bei der Vergabe der eigenen IDs im Bereich der App: das Schema übernehmen, auch wenn die
absoluten Zahlen andere sind.

---

## Check-Line-Codeunit

**Merkmale – alle verbindlich:**

- Erhält genau **eine** zu prüfende Buch.-Blattzeile als Parameter.
- **Kein UI.** Kein `Message`, kein `Confirm`, kein `Dialog`.
- **Lesen und Schreiben der Buch.-Blattzeile ist nicht erlaubt** (die Zeile kommt als Parameter,
  wird nicht aus der DB nachgelesen und nicht zurückgeschrieben).
- Führt nur Prüfungen durch, die den Datenbankserver **nicht belasten**: Pflichtfelder,
  geschäftsvorfallabhängige Regeln, zulässiges Buchungsdatum.
- Einrichtungsdatensätze dürfen ausnahmsweise gelesen werden – aber **nur einmal pro
  Buchungslauf**, also gecacht.

```al
codeunit 63031 "GOB Commis. Jnl.-Check Line"
{
    TableNo = "GOB Commission Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLSetupRead: Boolean;
        ClosingDateErr: Label 'cannot be a closing date';

    procedure RunCheck(var CommissionJnlLine: Record "GOB Commission Journal Line")
    begin
        if CommissionJnlLine.EmptyLine() then
            exit;

        CommissionJnlLine.TestField("Salesperson Code", ErrorInfo.Create());
        CommissionJnlLine.TestField("Posting Date", ErrorInfo.Create());
        CommissionJnlLine.TestField("Commission Contract No.", ErrorInfo.Create());

        CheckPostingDate(CommissionJnlLine);

        if CommissionJnlLine."Document Date" <> 0D then
            if CommissionJnlLine."Document Date" <> NormalDate(CommissionJnlLine."Document Date") then
                CommissionJnlLine.FieldError("Document Date", ErrorInfo.Create(ClosingDateErr, true));
    end;

    local procedure CheckPostingDate(CommissionJnlLine: Record "GOB Commission Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        if CommissionJnlLine."Posting Date" <> NormalDate(CommissionJnlLine."Posting Date") then
            CommissionJnlLine.FieldError("Posting Date", ErrorInfo.Create(ClosingDateErr, true));

        UserSetupManagement.CheckAllowedPostingDate(CommissionJnlLine."Posting Date");
    end;
}
```

`ErrorInfo.Create()` statt eines nackten `Error` macht die Meldung im Client aufklappbar und
verlinkbar – im Standard inzwischen die bevorzugte Form.

Muster: `SolDev/Final/src/codeunit/SMBSemJnlCheckLine.Codeunit.al`

---

## Post-Line-Codeunit

**Merkmale:**

- Bucht die als Parameter übergebene Buch.-Blattzeile.
- **Kein UI.**
- Ruft für die Zeile zuerst die Check-Line-Codeunit.
- Führt Prüfungen durch, die DB-Zugriffe erfordern (z. B. `Blocked` am Stammsatz).
- Erzeugt **Posten und Registereintrag** – und braucht dafür explizite `Permissions`.
- Stellt bei Bedarf Verknüpfungen zwischen korrespondierenden Posten her.

```al
codeunit 63032 "GOB Commis. Jnl.-Post Line"
{
    Permissions = tabledata "GOB Commission Ledger Entry" = rimd,
                  tabledata "GOB Commission Register" = rimd;
    TableNo = "GOB Commission Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        CommissionJnlLineGlobal: Record "GOB Commission Journal Line";
        CommissionLedgerEntry: Record "GOB Commission Ledger Entry";
        CommissionRegister: Record "GOB Commission Register";
        CommissionContract: Record "GOB Commission Contract";
        JnlCheckLine: Codeunit "GOB Commis. Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var CommissionJnlLine: Record "GOB Commission Journal Line")
    begin
        CommissionJnlLineGlobal.Copy(CommissionJnlLine);
        Code();
        CommissionJnlLine := CommissionJnlLineGlobal;
    end;

    local procedure "Code"()
    begin
        if CommissionJnlLineGlobal.EmptyLine() then
            exit;

        JnlCheckLine.RunCheck(CommissionJnlLineGlobal);

        if NextEntryNo = 0 then begin
            CommissionLedgerEntry.LockTable();
            NextEntryNo := CommissionLedgerEntry.GetLastEntryNo() + 1;
        end;

        if CommissionJnlLineGlobal."Document Date" = 0D then
            CommissionJnlLineGlobal."Document Date" := CommissionJnlLineGlobal."Posting Date";

        // Prüfungen mit DB-Zugriff gehören hierher, nicht in die Check Line
        CommissionContract.Get(CommissionJnlLineGlobal."Commission Contract No.");
        CommissionContract.TestField(Blocked, false);

        CommissionLedgerEntry.Init();
        CommissionLedgerEntry.CopyFromJnlLine(CommissionJnlLineGlobal);
        CommissionLedgerEntry."User ID" :=
            CopyStr(UserId(), 1, MaxStrLen(CommissionLedgerEntry."User ID"));
        CommissionLedgerEntry."Entry No." := NextEntryNo;

        InsertRegister(CommissionLedgerEntry."Entry No.");
        CommissionLedgerEntry.Insert(true);

        NextEntryNo += 1;
    end;

    local procedure InsertRegister(LedgEntryNo: Integer)
    begin
        if CommissionRegister."No." = 0 then begin
            CommissionRegister.LockTable();
            CommissionRegister."No." := CommissionRegister.GetLastEntryNo() + 1;
            CommissionRegister.Init();
            CommissionRegister."From Entry No." := NextEntryNo;
            CommissionRegister."To Entry No." := NextEntryNo;
            CommissionRegister."Creation Date" := Today();
            CommissionRegister."Creation Time" := Time();
            CommissionRegister."Source Code" := CommissionJnlLineGlobal."Source Code";
            CommissionRegister."User ID" :=
                CopyStr(UserId(), 1, MaxStrLen(CommissionRegister."User ID"));
            CommissionRegister.Insert();
        end else begin
            if ((LedgEntryNo < CommissionRegister."From Entry No.") and (LedgEntryNo <> 0)) or
               ((CommissionRegister."From Entry No." = 0) and (LedgEntryNo > 0))
            then
                CommissionRegister."From Entry No." := LedgEntryNo;
            if LedgEntryNo > CommissionRegister."To Entry No." then
                CommissionRegister."To Entry No." := LedgEntryNo;
            CommissionRegister.Modify();
        end;
    end;
}
```

Beachte: `NextEntryNo` ist eine **globale** Variable. Sie überlebt mehrere Aufrufe von
`RunWithCheck` innerhalb desselben Buchungslaufs – deshalb wird der letzte Postenschlüssel nur
einmal gelesen und der Register nur einmal angelegt.

Muster: `SolDev/Final/src/codeunit/SMBSemJnlPostLine.Codeunit.al`

---

## Post-(Yes/No)-Codeunit

Kurze UI-Interaktion, dann Übergabe. Sonst nichts.

```al
codeunit 63021 "GOB Commission-Post (Yes/No)"
{
    TableNo = "GOB Commission Doc. Header";

    trigger OnRun()
    var
        CommissionDocHeader: Record "GOB Commission Doc. Header";
    begin
        if not Rec.Find() then
            Error(DocumentErrorsMgt.GetNothingToPostErrorMsg());

        CommissionDocHeader.Copy(Rec);
        Code(CommissionDocHeader);
        Rec := CommissionDocHeader;
    end;

    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        WantToPostQst: Label 'Do you want to post the %1?',
            Comment = '%1 = TableCaption of the document';

    local procedure "Code"(var CommissionDocHeader: Record "GOB Commission Doc. Header")
    begin
        if not Confirm(WantToPostQst, true, CommissionDocHeader.TableCaption) then
            exit;

        Codeunit.Run(Codeunit::"GOB Commission-Post", CommissionDocHeader);
    end;
}
```

Aufruf von der Page:

```al
action(Post)
{
    ApplicationArea = Basic, Suite;
    Caption = 'P&ost';
    Image = PostOrder;
    ShortCutKey = 'F9';
    ToolTip = 'Finalize the document by posting the amounts and quantities to the related accounts.';

    trigger OnAction()
    begin
        Codeunit.Run(Codeunit::"GOB Commission-Post (Yes/No)", Rec);
    end;
}
```

Muster: `SolDev/Final/src/codeunit/SMBSeminarPostYesNo.Codeunit.al`

---

## Post-Codeunit (Document – Post)

Die längste Codeunit. Ihr Ablauf ist immer derselbe – Vorlage ist Codeunit 80 `Sales-Post`.

```al
codeunit 63020 "GOB Commission-Post"
{
    Permissions = tabledata "GOB Posted Commis. Doc. Header" = rimd,
                  tabledata "GOB Posted Commis. Doc. Line" = rimd,
                  tabledata "GOB Commission Doc. Header" = rimd,
                  tabledata "GOB Commission Doc. Line" = rimd;
    TableNo = "GOB Commission Doc. Header";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    internal procedure RunWithCheck(var DocHeader2: Record "GOB Commission Doc. Header")
    var
        DocHeader: Record "GOB Commission Doc. Header";
    begin
        ClearAllVariables();          // 1. Alle Globals zurücksetzen
        GetSetup();                   //    Einrichtung einmalig lesen
        DocHeader := DocHeader2;      //    Parameter in lokale Variable

        FillTempLines(DocHeader, TempDocLineGlobal);   // 2. Zeilen in Temp-Tabelle

        CheckAndUpdate(DocHeader);    // 3. Kopf: prüfen, Nummer ziehen, geb. Kopf anlegen
        ProcessPostingLines(DocHeader);  // 4. Zeilen einzeln buchen
        FinalizeDocument(DocHeader);  // 5. Aufräumen, wenn alles gebucht ist

        Commit();
    end;
```

### `CheckAndUpdate` – die Kopfverarbeitung

```al
    local procedure CheckAndUpdate(var DocHeader: Record "GOB Commission Doc. Header")
    var
        SourceCodeSetup: Record "Source Code Setup";
        ModifyHeader: Boolean;
    begin
        // a) Prüfungen
        CheckDocument(DocHeader);

        // b) Buchungsnummer ziehen, falls noch nicht vorhanden
        ModifyHeader := UpdatePostingNos(DocHeader);
        if ModifyHeader then begin
            DocHeader.Modify();
            Commit();                 // Nummer festschreiben, bevor gebucht wird
        end;

        // c) Tabellen sperren – IMMER in derselben Reihenfolge (Deadlock-Vermeidung)
        LockTables(DocHeader);

        // d) Herkunftscode setzen
        SourceCodeSetup.Get();
        SrcCode := SourceCodeSetup."GOB Commission";

        // e) Gebuchten Kopf erzeugen
        InsertPostedHeaders(DocHeader);
    end;
```

### `CheckDocument` – die Prüfkaskade

```al
    procedure CheckDocument(var DocHeader: Record "GOB Commission Doc. Header")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        CheckMandatoryHeaderFields(DocHeader);              // Pflichtfelder
        UserSetupManagement.CheckAllowedPostingDate(DocHeader."Posting Date");
        CheckLinesExistToPost(DocHeader);                   // Gibt es buchbare Zeilen?
        InitProgressWindow(DocHeader);                      // Fortschrittsfenster öffnen
    end;

    local procedure CheckLinesExistToPost(DocHeader: Record "GOB Commission Doc. Header")
    var
        DocLine: Record "GOB Commission Doc. Line";
    begin
        DocLine.SetRange("Document No.", DocHeader."No.");
        DocLine.SetRange(Posted, false);
        if DocLine.IsEmpty() then
            Error(NothingToPostErr);
    end;
```

### Zeilenverarbeitung

```al
    local procedure ProcessPostingLines(var DocHeader: Record "GOB Commission Doc. Header")
    var
        LineCount: Integer;
    begin
        TempDocLineGlobal.FindSet();
        repeat
            LineCount += 1;
            if GuiAllowed() then
                Window.Update(2, LineCount);
            PostDocLine(DocHeader, TempDocLineGlobal);
        until TempDocLineGlobal.Next() = 0;
    end;

    local procedure PostDocLine(var DocHeader: …; var DocLine: …)
    begin
        TestAndUpdateDocLine(DocLine);      // Pflichtfelder, Beträge nullen falls nicht relevant
        InsertPostedDocLine(DocLine, DocHeader);
        PostJnlLine(DocHeader, DocLine);    // Buch.-Blattzeile füllen und an Post Line geben
    end;
```

### Gebuchten Beleg erzeugen

```al
    local procedure InsertPostedDocHeader(var DocHeader: Record "GOB Commission Doc. Header")
    var
        CommentLine: Record "GOB Commission Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        PostedDocHeader.Init();
        PostedDocHeader.TransferFields(DocHeader);          // gleiche Feldnummern → alles wandert

        // Danach die Felder korrigieren, die sich unterscheiden
        PostedDocHeader."Document No. Series" := DocHeader."No. Series";
        PostedDocHeader."Document No." := DocHeader."No.";
        PostedDocHeader."No. Series" := DocHeader."Posting No. Series";
        PostedDocHeader."No." := DocHeader."Posting No.";
        PostedDocHeader."Source Code" := SrcCode;
        PostedDocHeader."User ID" := CopyStr(UserId(), 1, MaxStrLen(PostedDocHeader."User ID"));
        PostedDocHeader."No. Printed" := 0;
        PostedDocHeader.Insert(true);

        // Bemerkungen und Links mitnehmen – gesteuert über die Einrichtung
        GetSetup();
        if Setup."Copy Comments to Posted" then begin
            CommentLine.CopyComments(…);
            RecordLinkManagement.CopyLinks(DocHeader, PostedDocHeader);
        end;
    end;
```

### Buch.-Blattzeile füllen und übergeben

Die Post-Codeunit schreibt **nie direkt** in die Postentabelle. Sie füllt eine Journal Line und
gibt sie an die Post-Line-Codeunit:

```al
    local procedure PostJnlLine(var DocHeader: …; var DocLine: …)
    var
        CommissionJnlLine: Record "GOB Commission Journal Line";
        JnlPostLine: Codeunit "GOB Commis. Jnl.-Post Line";
    begin
        CommissionJnlLine.Init();
        CommissionJnlLine."Posting Date" := DocHeader."Posting Date";
        CommissionJnlLine."Document Date" := DocHeader."Document Date";
        CommissionJnlLine."Document No." := DocHeader."Posting No.";
        CommissionJnlLine."Source Code" := SrcCode;
        CommissionJnlLine."Reason Code" := DocHeader."Reason Code";
        CommissionJnlLine."Posting No. Series" := DocHeader."Posting No. Series";
        CommissionJnlLine."Salesperson Code" := DocLine."Salesperson Code";
        CommissionJnlLine."Commission Amount" := DocLine."Commission Amount";
        CommissionJnlLine."Dimension Set ID" := DocLine."Dimension Set ID";

        JnlPostLine.RunWithCheck(CommissionJnlLine);
    end;
```

### Abschluss

```al
    local procedure FinalizeDocument(var DocHeader: Record "GOB Commission Doc. Header")
    var
        DocLine: Record "GOB Commission Doc. Line";
        CommentLine: Record "GOB Commission Comment Line";
    begin
        if EverythingPosted() then begin
            DocLine.SetRange("Document No.", DocHeader."No.");
            DocLine.DeleteAll();
            CommentLine.DeleteComments(…);
            if DocHeader.HasLinks() then
                DocHeader.DeleteLinks();
            DocHeader.Delete();
        end;
    end;
```

Muster: `SolDev/Final/src/codeunit/SMBSeminarPost.Codeunit.al`

---

## Regeln, die überall gelten

### Temporäre Tabellen beim Buchen

Die Belegzeilen werden **vor** dem Buchen in eine temporäre Tabelle kopiert und von dort
verarbeitet. Das entkoppelt die Verarbeitung von Änderungen an der echten Tabelle.

```al
procedure FillTempLines(DocHeader: Record "…"; var TempDocLine: Record "…" temporary)
begin
    TempDocLine.Reset();
    if TempDocLine.IsEmpty() then
        CopyToTempLines(DocHeader, TempDocLine);
end;
```

### `LockTable` – immer in derselben Reihenfolge

```al
local procedure LockTables(var DocHeader: Record "…")
var
    DocLine: Record "…";
    LedgerEntry: Record "…";
begin
    DocHeader.LockTable();
    DocHeader.Find();          // nach LockTable neu lesen!
    DocLine.LockTable();
    LedgerEntry.LockTable();
end;
```

### `Commit`-Punkte

Nur an zwei Stellen:
1. Nachdem eine Buchungsnummer gezogen wurde (damit sie bei Abbruch nicht verlorengeht).
2. Ganz am Ende des Buchungslaufs.

Kein `Commit` innerhalb der Zeilenschleife.

### Fortschrittsanzeige

```al
var
    Window: Dialog;
    PostingLinesMsg: Label 'Posting lines              #2######\', Comment = '#2 = line counter';

procedure InitProgressWindow(DocHeader: Record "…")
begin
    if not GuiAllowed() then
        exit;
    Window.Open('#1#################################\\' + PostingLinesMsg);
    Window.Update(1, DocHeader."No.");
end;
```

Jeder `Window`-Zugriff wird mit `GuiAllowed()` geschützt – sonst brechen Tests und
Hintergrundläufe.

### `Permissions`-Property

Codeunits, die Posten oder gebuchte Belege schreiben, brauchen die `Permissions`-Property auf
Objektebene. Ohne sie schlägt die Buchung beim Anwender fehl, obwohl sie beim Entwickler läuft.

---

## Periodische Stapelläufe (Batch Report)

Anforderungen wie „Der periodische Stapellauf ‚Provisionen ermitteln' muss für einen oder
beliebig viele Verkäufer ausgeführt werden können" ergeben einen **ProcessingOnly-Report**.

```al
report 63000 "GOB Calc. Commissions - batch"
{
    Caption = 'Calculate Commissions';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Salesperson; "Salesperson/Purchaser")
        {
            RequestFilterFields = Code;

            dataitem(CustLedgEntry; "Cust. Ledger Entry")
            {
                DataItemLink = "Salesperson Code" = field(Code);
                DataItemTableView = sorting("Entry No.")
                                    where("Document Type" = filter(Invoice | "Credit Memo"));
                RequestFilterFields = "Posting Date";

                trigger OnAfterGetRecord()
                begin
                    if GuiAllowed() then
                        Window.Update(1, CustLedgEntry."Document No.");

                    // Doppelerfassung verhindern – bereits verarbeitete Belege überspringen
                    if EntryAlreadyProcessed(CustLedgEntry) then
                        CurrReport.Skip();

                    CalculateAndPostCommission(Salesperson, CustLedgEntry);
                end;
            }

            trigger OnPreDataItem()
            begin
                Setup.Get();
                Setup.TestField("Commission Rounding Precision");
                if GuiAllowed() then
                    Window.Open(ProcessingMsg);
            end;

            trigger OnPostDataItem()
            begin
                if GuiAllowed() then begin
                    Window.Close();
                    Message(DoneMsg, ProcessedCount);
                end;
            end;
        }
    }

    requestpage
    {
        layout { area(content) { group(Options) { … } } }
    }
}
```

Merkpunkte für solche Läufe – alle direkt aus der Spec ableitbar:

| Spec-Formulierung | Umsetzung |
|---|---|
| „auf bestimmte Verkäufer oder Zeiträume filtern" | `RequestFilterFields` auf beiden DataItems |
| „Über ein Statusfenster teilt das System den Status mit" | `Dialog` mit `GuiAllowed()`-Schutz |
| „gibt das Programm am Ende eine Meldung aus" | `Message` im `OnPostDataItem` |
| „können nicht doppelt erfasst werden … Beleg ignorieren" | Prüfung + `CurrReport.Skip()` |
| „bricht mit einer Fehlermeldung ab, wenn Einrichtungsdaten fehlen" | `Setup.TestField(…)` im `OnPreDataItem` |
| „Bei einer Gutschrift muss der Betrag negativ sein" | Vorzeichen aus dem Belegtyp ableiten |
| „Der Provisionsbetrag wird gerundet. Dazu wird das Einrichtungsfeld genutzt" | `Round(Amount, Setup."… Rounding Precision")` |

Der Report **berechnet und ruft**, er schreibt die Posten nicht selbst – dafür ist die
Post-Line-Codeunit zuständig. Das ist der Unterschied zwischen „geht" und „standardkonform".

Muster: `SolDev/Final/src/report/SMBCreateSeminarInvoices.Report.al`, Ablaufplan im
Schulungsskript S. 43.
