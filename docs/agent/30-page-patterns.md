# 30 – Page-Muster

Die Spezifikationen schreiben die UI meist wörtlich vor („nicht editierbare Listenpage",
„editierbare Kartenpage", „als Menüpunkt im Rollencenter"). Diese Formulierungen sind
1:1 in Properties übersetzbar.

---

## Welcher PageType wofür

| Anforderung | `PageType` | Kennzeichen |
|---|---|---|
| Übersicht über Stammdaten | `List` | `CardPageId`, `Editable = false` falls Karte existiert |
| Einzelsatz bearbeiten | `Card` | `UsageCategory = None` (Einstieg über die Liste) |
| Einrichtung | `Card` | `InsertAllowed = false`, `DeleteAllowed = false`, `UsageCategory = Administration` |
| Beleg | `Document` | Kopf-Gruppen + `part` mit den Zeilen |
| Belegzeilen | `ListPart` | `AutoSplitKey = true`, `DelayedInsert = true` |
| Info-Kachel rechts | `CardPart` / `ListPart` | eingebunden in `area(factboxes)` |
| Rollencenter | `RoleCenter` | `area(RoleCenter)` + `area(Sections)`/`(Embedding)` |
| Aktivitätskacheln | `CardPart` | `SourceTable` = Cue-Tabelle, `cuegroup` |
| Einfache Bearbeitungsliste | `List` | direkt editierbar, kein `CardPageId` |
| Posten | `List` | `Editable = false`, `SourceTableView` mit Sortierung |

---

## `UsageCategory` und `ApplicationArea`

Beide zusammen entscheiden, ob eine Page über „Suchen" (Alt+Q) auffindbar ist.

```al
page 63020 "GOB Commission Contract List"
{
    PageType = List;
    SourceTable = "GOB Commission Contract";
    Caption = 'Commission Contracts';
    UsageCategory = Lists;         // ← auffindbar
    ApplicationArea = All;
    Editable = false;
    CardPageId = "GOB Commission Contract Card";
```

Regeln:
- Card-Pages, die nur aus einer Liste heraus geöffnet werden: `UsageCategory = None`.
- Setup-Pages: `UsageCategory = Administration` – das erfüllt die Spec-Anforderung
  „über den Bereich ‚manuelle Einrichtung' einrichtbar".
- Subpages und FactBoxes: kein `UsageCategory`.
- `ApplicationArea` einmal auf Page-Ebene setzen, wenn die Basis-App das so hält; sonst je Feld.
  **Nicht mischen.**

---

## List-Page

```al
page 63020 "GOB Commission Contract List"
{
    ApplicationArea = All;
    Caption = 'Commission Contracts';
    PageType = List;
    SourceTable = "GOB Commission Contract";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "GOB Commission Contract Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
                field("Commission Type Code"; Rec."Commission Type Code") { }
                field("Commission %"; Rec."Commission %") { }
                field("Starting Date"; Rec."Starting Date") { }
                field("Ending Date"; Rec."Ending Date") { }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = RecordLinks; }
            systempart(Notes; Notes) { ApplicationArea = Notes; }
        }
    }
    actions { … }
}
```

---

## Card-Page

Felder in fachliche Gruppen. Selten benutzte Felder bekommen `Importance = Additional`,
zentrale `Importance = Promoted`.

```al
layout
{
    area(content)
    {
        group(General)
        {
            Caption = 'General';
            field("No."; Rec."No.")
            {
                Importance = Promoted;
                trigger OnAssistEdit()
                begin
                    if Rec.AssistEdit(xRec) then
                        CurrPage.Update();
                end;
            }
            field(Description; Rec.Description)
            {
                Importance = Promoted;
                ShowMandatory = true;
            }
            field(Blocked; Rec.Blocked) { }
        }
        group(Commission)
        {
            Caption = 'Commission';
            field("Commission %"; Rec."Commission %") { }
            field("Pay Commission Bonus"; Rec."Pay Commission Bonus") { }
            field("Target Achievement Amount"; Rec."Target Achievement Amount") { }
            field("Commission Bonus Amount"; Rec."Commission Bonus Amount") { }
        }
    }
    area(factboxes) { … }
}
```

`OnAssistEdit` ist die **einzige** Stelle, an der die `AssistEdit`-Funktion der Tabelle gerufen
wird.

---

## Setup-Page

Die Setup-Tabelle hat genau eine Zeile. Die Page legt sie an, wenn sie fehlt:

```al
page 63000 "GOB Commission Mgt. Setup"
{
    Caption = 'Commission Management Setup';
    PageType = Card;
    SourceTable = "GOB Commission Mgt. Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General) { Caption = 'General'; … }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Commission Contract Nos."; Rec."Commission Contract Nos.") { }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
```

Muster: `SolDev/Final/src/page/SMBSeminarSetup.Page.al`

---

## Document-Page + Subpage

```al
page 63030 "GOB Commission Document"
{
    PageType = Document;
    SourceTable = "GOB Commission Doc. Header";
    Caption = '…';
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General) { … }

            part(Lines; "GOB Commission Doc. Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                Caption = 'Lines';
                UpdatePropagation = Both;      // Kopf ⇄ Zeilen synchron halten
            }

            group(Invoicing) { … }
        }
        area(FactBoxes)
        {
            part(MasterDetails; "GOB Commis. Contract Factbox")
            {
                SubPageLink = "No." = field("Commission Contract No.");
            }
            part(CustomerDetails; "Customer Details FactBox")
            {
                Provider = Lines;                                 // FactBox folgt der Zeile
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }
        }
    }
}
```

Die Subpage:

```al
page 63031 "GOB Commission Doc. Subpage"
{
    PageType = ListPart;
    SourceTable = "GOB Commission Doc. Line";
    ApplicationArea = All;
    Caption = 'Lines';
    AutoSplitKey = true;        // Zeilennummern automatisch in 10.000er-Schritten
    DelayedInsert = true;       // Insert erst, wenn die Zeile verlassen wird
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                …
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update();
    end;
}
```

Muster: `SolDev/Final/src/page/SMBSeminarRegistration.Page.al`,
`SMBSeminarRegLinesSubpage.Page.al`

---

## FactBox

FactBoxes zeigen Zusatzinformationen zum aktuellen Satz im rechten Bereich.

### Variante A – FactBox auf der Fremdtabelle

Wenn die anzuzeigenden Felder in einer Tabelle liegen, auf die ein Fremdschlüssel zeigt,
ist die FactBox eine schlichte `CardPart` mit dieser Tabelle als `SourceTable`, verknüpft
über `SubPageLink`:

```al
page 63022 "GOB Commis. Contract Factbox"
{
    PageType = CardPart;
    SourceTable = "GOB Commission Contract";
    Caption = 'Commission Contract Details';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Contract No.';
                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            field(Description; Rec.Description) { }
            field("Commission %"; Rec."Commission %") { }
        }
    }

    local procedure ShowDetails()
    begin
        Page.Run(Page::"GOB Commission Contract Card", Rec);
    end;
}
```

Einbindung:

```al
area(factboxes)
{
    part(ContractDetails; "GOB Commis. Contract Factbox")
    {
        ApplicationArea = All;
        SubPageLink = "No." = field("GOB Commission Contract No.");
    }
}
```

Muster: `SolDev/Final/src/page/SMBSeminarDetailsFactBox.Page.al`

### Variante B – FactBox über ein Array

Fordert die Spezifikation ausdrücklich ein **Array** („Der Entwickler soll für die Umsetzung ein
Array nutzen"), dann ist das bindend. Das Muster ist eine FactBox ohne `SourceTable`, deren
Zeilen aus einem Array globaler Variablen gespeist werden – Beschriftung und Wert werden zur
Laufzeit gefüllt:

```al
page 63022 "GOB Commis. Contract Factbox"
{
    PageType = CardPart;
    Caption = 'Commission Contract Details';
    ApplicationArea = All;
    SourceTable = "Salesperson/Purchaser";

    layout
    {
        area(Content)
        {
            group(Information)
            {
                Caption = 'Information';
                field(Field1; ContractInfo[1]) { Caption = 'Description'; ShowCaption = true; }
                field(Field2; ContractInfo[2]) { Caption = 'Commission Type Description'; }
                field(Field3; ContractInfo[3]) { Caption = 'Starting Date'; }
                field(Field4; ContractInfo[4]) { Caption = 'Ending Date'; }
                field(Field5; ContractInfo[5]) { Caption = 'Commission %'; }
                field(Field6; ContractInfo[6]) { Caption = 'Pay Commission Bonus'; }
                field(Field7; ContractInfo[7]) { Caption = 'Status'; }
            }
        }
    }

    var
        ContractInfo: array[7] of Text;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateContractInfo();
    end;

    local procedure UpdateContractInfo()
    var
        CommissionContract: Record "GOB Commission Contract";
        CommissionType: Record "GOB Commission Type";
    begin
        Clear(ContractInfo);
        if not CommissionContract.Get(Rec."GOB Commission Contract No.") then
            exit;

        ContractInfo[1] := CommissionContract.Description;
        if CommissionType.Get(CommissionContract."Commission Type Code") then
            ContractInfo[2] := CommissionType.Description;
        ContractInfo[3] := Format(CommissionContract."Starting Date");
        ContractInfo[4] := Format(CommissionContract."Ending Date");
        ContractInfo[5] := Format(CommissionContract."Commission %");
        ContractInfo[6] := Format(CommissionContract."Pay Commission Bonus");
        ContractInfo[7] := Format(CommissionContract.Status);
    end;
}
```

Die genaue Feldreihenfolge gibt die Spezifikation vor – sie ist einzuhalten.

---

## Actions

### Gliederung

```al
actions
{
    area(Navigation)   { … }   // zu verwandten Daten navigieren
    area(Processing)   { … }   // etwas ausführen (Buchen, Berechnen)
    area(Creation)     { … }   // neuen Beleg aus diesem Satz erzeugen
    area(Reporting)    { … }   // Berichte
    area(Promoted)     { … }   // NUR actionrefs, keine eigenen Actions
}
```

### Pflicht-Properties je Action

```al
action("Commission Ledger Entries")
{
    ApplicationArea = All;
    Caption = 'Commission Ledger E&ntries';
    Image = LedgerEntries;
    RunObject = Page "GOB Commission Ledger Entries";
    RunPageLink = "Salesperson Code" = field(Code);
    RunPageView = sorting("Salesperson Code", "Posting Date") order(descending);
    ShortCutKey = 'Ctrl+F7';
    ToolTip = 'View the commission entries that have been posted for the salesperson.';
}
```

Das `&` im Caption setzt den Tastatur-Shortcut – wie im Standard üblich.

### Promoted: nur `actionref`

Die alten `Promoted*`-Properties sind abgelöst. Promotion geschieht ausschließlich über
`area(Promoted)` mit Verweisen:

```al
area(Promoted)
{
    group(Category_Process)
    {
        Caption = 'Process';
        actionref(Post_Promoted; Post) { }
    }
    group(Category_Category4)
    {
        Caption = 'Commission';
        actionref(LedgerEntries_Promoted; "Commission Ledger Entries") { }
    }
}
```

### Berechtigungsabhängige Actions

```al
action(NewCommissionDocument)
{
    AccessByPermission = TableData "GOB Commission Doc. Header" = RIM;
    RunObject = Page "GOB Commission Document";
    RunPageLink = "Salesperson Code" = field(Code);
    RunPageMode = Create;
    …
}
```

`RunPageMode = Create` in Kombination mit `RunPageLink` ist das Muster „neuer Beleg aus dem
Stammsatz" – der Fremdschlüssel wird im `OnInsert` des Kopfes aus dem Filter übernommen
(siehe `20-table-patterns.md`).

---

## Posten-Page

```al
page 63025 "GOB Commission Ledger Entries"
{
    PageType = List;
    SourceTable = "GOB Commission Ledger Entry";
    Caption = 'Commission Ledger Entries';
    UsageCategory = History;
    ApplicationArea = All;
    Editable = false;
    SourceTableView = sorting("Entry No.") order(descending);

    layout { area(content) { repeater(General) { … } } }

    actions
    {
        area(Processing)
        {
            action("Navi&gate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                ShortCutKey = 'Ctrl+Alt+Q';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run();
                end;
            }
        }
    }
}
```

`Editable = false` ist bei Postentabellen nicht optional.

---

## Rollencenter

Zwei Aufgaben: Kacheln anzeigen (`area(RoleCenter)`) und Navigation bereitstellen
(`area(Sections)` und `area(Embedding)`).

```al
page 63050 "GOB Commission Role Center"
{
    PageType = RoleCenter;
    Caption = '…';
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(RoleCenter)
        {
            part(Activities; "GOB Commission Activities")
            {
                AccessByPermission = TableData "GOB Commission Ledger Entry" = R;
            }
            part(Emails; "Email Activities") { ApplicationArea = Basic, Suite; }
            part(Control21; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(Sections)      // linke Navigationsspalte
        {
            group(CommissionManagement)
            {
                Caption = 'Commission Management';
                action(CommissionTypes)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Types';
                    RunObject = page "GOB Commission Types";
                    ToolTip = 'Open the list of commission types.';
                }
                …
            }
        }
        area(Embedding)     // oberste Menüleiste
        {
            action(CommissionContracts) { … }
        }
        area(Processing)    // Aktionen
        {
            action(CalculateCommissions)
            {
                Caption = 'Calculate Commissions';
                RunObject = report "GOB Calc. Commissions - batch";
                ApplicationArea = All;
                ToolTip = 'Calculate the commissions for one or more salespeople.';
            }
        }
        area(Creation) { … }
    }
}
```

### Ein **bestehendes** Rollencenter erweitern

Fordert die Spec „Die wichtigsten Pages sollen in das Rollencenter ‚Verkaufsauftragverarbeitung'
eingefügt werden. Dazu wird eine eigene Gruppe mit der Beschriftung ‚Provisionsmanagement'
hinzugefügt", dann ist das eine **`pageextension`** auf `"Order Processor Role Center"`,
kein neues Rollencenter:

```al
pageextension 63050 "GOB Order Processor RC" extends "Order Processor Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group("GOB Commission Management")
            {
                Caption = 'Commission Management';
                action("GOB Commission Types")
                {
                    ApplicationArea = All;
                    Caption = 'Commission Types';
                    RunObject = page "GOB Commission Types";
                    ToolTip = 'Open the list of commission types.';
                }
                action("GOB Salespersons")
                {
                    ApplicationArea = All;
                    Caption = 'Salespeople';
                    RunObject = page "Salespersons/Purchasers";
                    ToolTip = 'Open the list of salespeople.';
                }
                …
            }
        }
    }
}
```

Muster: `SolDev/Final/src/page/SMBSeminarRoleCenter.Page.al` (neues Rollencenter),
`SolDev/Final/src/pageextension/SMBSourceCodeSetup.PageExt.al` (Erweiterungsmuster).

---

## Aktivitäten-Part (Cues)

```al
page 63051 "GOB Commission Activities"
{
    PageType = CardPart;
    SourceTable = "GOB Commission Cue";
    Caption = 'Activities';
    ApplicationArea = All;
    UsageCategory = None;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Contracts)
            {
                Caption = 'Contracts';
                field("Contracts - Active"; Rec."Contracts - Active")
                {
                    DrillDownPageId = "GOB Commission Contract List";
                    ToolTip = 'Specifies the number of active commission contracts.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        Rec.SetRange("Date Filter", WorkDate());
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
}
```

Die Action „Set Up Cues" erfüllt die Anforderung „Stellen Sie sicher, dass der Benutzer eigene
Limits definieren kann".

Muster: `SolDev/Final/src/page/SMBSeminarMgtActivities.Page.al`

---

## Profile

```al
profile "GOB Commission Manager"
{
    Caption = 'Commission Manager';
    Description = 'Commission Manager';
    RoleCenter = "GOB Commission Role Center";
    Customizations = "GOB Commission Contract List";
}
```

## PageCustomization

Passt eine Page **profilspezifisch** an, ohne sie für alle zu ändern:

```al
pagecustomization "GOB Commission Contract List" customizes "GOB Commission Contract List"
{
    layout
    {
        modify("Commission Type Code") { Visible = false; }
    }

    views
    {
        addlast
        {
            view(ActiveContracts)
            {
                Caption = 'Active Contracts';
                Filters = where(Status = const(Active));
                SharedLayout = false;
            }
        }
    }
}
```

Muster: `SolDev/Final/src/pagecustomization/SMBSeminarRegistrationList.PageCust.al`,
`SolDev/Final/src/profile/`

---

## Standard-Pages erweitern

Die Spec-Anforderungen „Die zusätzlichen Felder werden in die Kartenpage … und die Listenpage …
eingefügt" und „Das Business Central Feld ‚Commission %' soll auf der Kartenpage ausgeblendet
werden" ergeben zusammen eine `pageextension`:

```al
pageextension 63001 "GOB Salesperson Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addlast(General)
        {
            field("GOB Commission Contract No."; Rec."GOB Commission Contract No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the commission contract assigned to the salesperson.';
            }
            field("GOB Commission Amount"; Rec."GOB Commission Amount")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the commission amount calculated for the salesperson.';
            }
        }
        modify("Commission %")
        {
            Visible = false;        // Standardfeld ausblenden, NICHT löschen
        }
        addlast(factboxes)
        {
            part(CommissionContractDetails; "GOB Commis. Contract Factbox")
            {
                ApplicationArea = All;
                SubPageLink = Code = field(Code);
            }
        }
    }

    actions
    {
        addlast(Navigation)
        {
            group("GOB Commission")
            {
                Caption = 'Commission';
                Image = Costs;
                action("GOB Commission Contract") { … }
                action("GOB Commission Ledger Entries") { … }
            }
        }
        addlast(Promoted)
        {
            group(Category_GOBCommission)
            {
                Caption = 'Commission';
                actionref("GOB Commission Contract_Promoted"; "GOB Commission Contract") { }
            }
        }
    }
}
```

Verfügbare Anker: `addfirst`, `addlast`, `addbefore`, `addafter`, `movefirst`, `movelast`,
`movebefore`, `moveafter`, `modify`.

⚠️ `modify` darf Standardfelder ausblenden und Properties ändern, aber **niemals** deren
Verhalten so umbauen, dass Standardprozesse brechen.
