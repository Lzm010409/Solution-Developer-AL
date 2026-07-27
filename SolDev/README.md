# Seminar Management – Kursbegleitendes Handbuch

Dieses Dokument beschreibt vollständig, was im Kurs **„VS Code AL Solution Development"**
(get&use Academy, GOB) am Beispiel des Moduls *Seminar Management* erarbeitet wurde – so
ausführlich, dass sich jeder Sachverhalt eigenständig nachbauen lässt.

**Zielgruppe:** jemand, der AL-Grundlagen kennt (Tabellen, Pages, einfache Trigger) und nun
eine vollständige, standardkonforme BC-Lösung mit Belegen, Buchungslogik, Posten und
Standardintegration bauen will.

---

## Inhalt

| Teil | Kapitel |
|---|---|
| **0 – Orientierung** | [Repo-Aufbau](#0-orientierung) · [Objektübersicht](#02-objektübersicht) · [Umgebung](#03-entwicklungsumgebung) |
| **I – Grundlagen** | [1 Tabellenarten](#1-tabellenarten-in-business-central) · [2 Datenfluss](#2-der-allgemeine-datenfluss) · [3 Trigger & Globals](#3-trigger-und-die-lebensdauer-von-al-globals) · [4 Implementierungsreihenfolge](#4-implementierungsreihenfolge) |
| **II – Stammdaten** | [5 Setup](#5-setup-tabelle-und-page) · [6 Enums](#6-enums) · [7 Supplementals](#7-supplemental-tabellen) · [8 Master](#8-die-master-tabelle) · [9 Nummernserie](#9-nummernserie) · [10 Bemerkungen](#10-bemerkungszeilen) · [11 Bild](#11-bild-media) |
| **III – Beleg** | [12 Belegtabellen](#12-belegtabellen) · [13 Beleg-Pages](#13-beleg-pages) · [14 Kopf-Funktionalität](#14-belegkopf-funktionalität) · [15 Zeilen-Funktionalität](#15-belegzeilen-funktionalität) · [16 Währung](#16-währung) |
| **IV – Buchen** | [17 Blatt vs. Posten](#17-buch-blatt-versus-posten) · [18 Nomenklatur](#18-nomenklatur-der-buchungsroutinen) · [19 Check Line](#19-check-line-codeunit) · [20 Post Line](#20-post-line-codeunit) · [21 Belegbuchung](#21-belegbuchung) · [22 Gebuchte Belege](#22-gebuchte-belege) · [23 Fremdmodul mitbuchen](#23-fremdmodul-mitbuchen-ressourcenposten) |
| **V – Auswertung** | [24 Navigate](#24-navigate) · [25 Fakturierung](#25-fakturierung) · [26 Posten schließen](#26-posten-schließen-über-events) · [27 Dimensionen](#27-dimensionen) · [28 Statistik](#28-statistik) |
| **VI – Rollencenter** | [29 Cues](#29-cues-und-aktivitäten-part) · [30 Rollencenter](#30-rollencenter) · [31 Profile](#31-profile-und-pagecustomization) · [32 Filter Token](#32-filter-token) |
| **VII – Qualität** | [33 Berechtigungen](#33-berechtigungen) · [34 Tests](#34-application-tests) · [35 Übersetzung](#35-übersetzung) |
| **Anhang** | [Stolperfallen](#anhang-a--stolperfallen) · [Übungsverbote](#anhang-b--übungsverbote) · [Glossar](#anhang-c--glossar) |

---

# 0 Orientierung

## 0.1 Repo-Aufbau

Der Ordner `SolDev/` enthält die Musterlösung in mehreren **Ausbaustufen**. Sie zeigen den
Kursverlauf: was zu welchem Zeitpunkt existierte und was der Trainee jeweils ergänzt hat.

| Ordner | Inhalt | Kursphase |
|---|---|---|
| `Tag01/src/` | Setup, Master, Supplementals, Bemerkungen, Beleg (Tabellen + Pages) – **ohne** Buchungslogik | Ende Tag 1 |
| `01-Start Doc/` | Vorgabeobjekte für die Belegimplementierung (Reg. Header/Line, Status-Enum) | Start Belegkapitel |
| `02_StartJnlPosting/` | Vorgabeobjekte für die Buch.-Blattbuchung (Journal Line, Ledger Entry, Register, Posten-Pages, Show-Ledger) | Start Buchungskapitel |
| `03_StartDocPosting/` | Vorgabeobjekte für die Belegbuchung (gebuchte Belegtabellen und -pages) | Start Belegbuchung |
| **`Final/src/`** | **Der vollständige Endstand.** Maßgeblich bei jedem Widerspruch. | Kursende |
| `Final/TestSeminarManagement/` | Separate Test-App (Prefix `SMT`) | Testkapitel |

Weiteres Material:

| Datei | Inhalt |
|---|---|
| `guA - … GOB Handout.pdf` | Das Kursskript (61 Seiten) – Theorie und Aufgabenstellungen |
| `SolDev0726.xlsx` | Architektur-Schaubilder: Tabellenarten, Datenmodell, Rabatt, Währung, beide Buchungsketten |
| `Import TestToolkit BC27.ps1` | PowerShell zum Einspielen des Microsoft-Test-Frameworks in eine OnPrem-Instanz |
| `TestDep.txt` | Die `dependencies`-Blöcke für die `app.json` der Test-App |
| `PostResSemJnlLine.txt` | Vorgabecode: Ressourcen-Buch.-Blattzeile füllen |
| `CreateSeminarInvoice.txt.txt` | Vorgabecode: ausführliche Fakturierungsvariante |

**Prefix `SMB`, ID-Bereich 123456700 – 123456799** (Test-App: `SMT`, 80150 – 80199).

## 0.2 Objektübersicht

Alle Objekte des Endstands, verifiziert aus dem Code:

### Tabellen

| ID | Name | Archetyp |
|---|---|---|
| 123456700 | `SMB Seminar` | Master |
| 123456701 | `SMB Seminar Setup` | Setup |
| 123456702 | `SMB Seminar Room` | Supplemental |
| 123456703 | `SMB Instructor` | Supplemental |
| 123456704 | `SMB Seminar Comment Line` | Bemerkungen |
| 123456710 | `SMB Seminar Reg. Header` | Document Header |
| 123456711 | `SMB Seminar Reg. Line` | Document Line |
| 123456718 | `SMB Posted Seminar Reg. Header` | Posted Doc. Header |
| 123456719 | `SMB Posted Seminar Reg. Line` | Posted Doc. Line |
| 123456730 | `SMB My Seminar` | Personalisierung |
| 123456731 | `SMB Seminar Journal Line` | Journal Line |
| 123456732 | `SMB Seminar Ledger Entry` | Ledger Entry |
| 123456733 | `SMB Seminar Register` | Register |
| 123456751 | `SMB Seminar Cue` | Cue |

### Pages

| ID | Name | Typ |
|---|---|---|
| 123456700 | `SMB Seminar Card` | Card |
| 123456701 | `SMB Seminar List` | List |
| 123456702 | `SMB Seminar Setup` | Card (Setup) |
| 123456703 | `SMB Instructors` | List |
| 123456704 | `SMB Seminar Room List` | List |
| 123456705 | `SMB Seminar Room Card` | Card |
| 123456706 | `SMB Seminar Comment Sheet` | List (editierbar) |
| 123456707 | `SMB Seminar Comment List` | List (nicht editierbar) |
| 123456708 | `SMB Seminar Reg. Line List` | List |
| 123456710 | `SMB Seminar Registration` | Document |
| 123456711 | `SMB Seminar Reg. Lines Subpage` | ListPart |
| 123456713 | `SMB Seminar Registration List` | List |
| 123456717 | `SMB Seminar Details FactBox` | CardPart |
| 123456718 | `SMB Contact Details Factbox` | CardPart |
| 123456721 | `SMB Seminar Ledger Entries` | List (History) |
| 123456722 | `SMB Seminar Registers` | List (History) |
| 123456730 | `SMB My Seminars` | ListPart |
| 123456734 | `SMB Pst. Sem. Registration` | Document |
| 123456735 | `SMB Pst. Sem. Reg. Subpage` | ListPart |
| 123456736 | `SMB Posted Seminar Reg. List` | List |
| 123456750 | `SMB Seminar Role Center` | RoleCenter |
| 123456751 | `SMB Seminar Mgt. Activities` | CardPart (Cues) |
| 123456755 | `SMB Seminar Picture` | CardPart |

### Codeunits

| ID | Name | Rolle |
|---|---|---|
| 123456700 | `SMB Seminar-Post` | Document – Post (**x0**) |
| 123456701 | `SMB Seminar-Post (Yes/No)` | Starter (**x1**) |
| 123456704 | `SMB Seminar Navigate` | Navigate-Subscriber |
| 123456710 | `SMB Seminar Invoicing` | Sales-Post-Subscriber |
| 123456730 | `SMB MySeminar Filter Token` | Filter Token |
| 123456731 | `SMB Sem. Jnl.-Check Line` | Check Line (**x1**) |
| 123456732 | `SMB Sem. Jnl.-Post Line` | Post Line (**x2**) |
| 123456745 | `SMB Seminar Reg.-Show Ledger` | Show Ledger (**x5**) |

### Übrige

| Typ | ID | Name |
|---|---|---|
| Enum | 123456701 | `SMB Internal/External` |
| Enum | 123456702 | `SMB Seminar Reg. Status` |
| Enum | 123456703 | `SMB Sem. Ledger Charge Type` |
| Enum | 123456710 | `SMB Sem. Comment Document Type` |
| EnumExt | 123456700 | `SMB Comment Line Table Name` |
| TableExt | 123456700 | `SMB Source Code Setup` |
| TableExt | 123456701 | `SMB Sales Line` |
| TableExt | 123456702 | `SMB Sales Invoice Line` |
| PageExt | 123456700 | `SMB Source Code Setup` |
| PageCust | – | `SMB Seminar Registration List` |
| Report | 123456798 | `SMB Create Seminar Invoices` |
| PermissionSet | 123456700 | `SMB SemRegistration` |
| Profile | – | `SMB Seminar Manager`, `SMB Seminar Worker` |
| Test-CU | 80150/80151/80152 | `SMT Test Seminar`, `SMT Library - Seminar Mgt.`, `TestRunner Seminar` |

## 0.3 Entwicklungsumgebung

**`app.json` – die relevanten Einstellungen:**

```jsonc
{
  "idRanges": [ { "from": 123456700, "to": 123456799 } ],
  "runtime": "16.0",
  "application": "27.0.0.0",
  "features": [ "NoImplicitWith" ]
}
```

`NoImplicitWith` schaltet das alte `with`-Statement ab – `Rec.` muss überall explizit stehen.

**Test-Framework einspielen (OnPrem):** `Import TestToolkit BC27.ps1` veröffentlicht acht
Microsoft-Test-Apps in der Server-Instanz. Reihenfolge ist wichtig (Library Assert zuerst,
dann Variable Storage, Business Foundation, Any, …). In Docker-Containern entspricht das
`Import-TestToolkitToNavContainer -containerName bc`.

Die Versionsnummern in `TestDep.txt` müssen zur eingespielten BC-Version passen – sonst
kompiliert die Test-App nicht.

---

# Teil I – Grundlagen

## 1 Tabellenarten in Business Central

Jede Tabelle einer BC-Lösung gehört zu einem **Archetyp**. Der Archetyp bestimmt
Primärschlüssel, Trigger, Löschverhalten und welche Pages dazugehören. Das ist der wichtigste
Einzelbegriff des ganzen Kurses.

| Archetyp | Zweck | Primärschlüssel | Beispiel Standard | Beispiel Seminar |
|---|---|---|---|---|
| **Setup** | Einrichtung, eine Zeile pro Mandant | leerer `Code[10]` | `Sales & Receivables Setup` (311) | `SMB Seminar Setup` |
| **Master** | Haupt-Stammdaten des Moduls | `No.` (Nummernserie) | `Item` (27), `Customer` (18) | `SMB Seminar` |
| **Supplemental** | Ergänzende Stammdaten, eigenständig | `Code` (manuell) | `Unit of Measure` | `SMB Seminar Room`, `SMB Instructor` |
| **Subsidiary** | Zuordnung zweier Stammdaten | zusammengesetzt | `Item Unit of Measure` | – |
| **Document** | Beleg: Kopf + Zeilen | `[Type,] No.` / `[Type,] Doc. No., Line No.` | `Sales Header`/`Line` | `SMB Seminar Reg. Header`/`Line` |
| **Journal** | Frei editierbares Buchungsblatt | Template, Batch, Line No. | `Gen. Journal Line` | `SMB Seminar Journal Line` |
| **Ledger Entry** | Posten, schreibgeschützt, unveränderlich | `Entry No.` (Integer) | `G/L Entry`, `Res. Ledger Entry` | `SMB Seminar Ledger Entry` |
| **Register** | Klammer über einen Buchungslauf | `No.` (Integer) | `G/L Register` | `SMB Seminar Register` |
| **Posted Document** | Archivierter Beleg | wie Document | `Sales Invoice Header` | `SMB Posted Seminar Reg. Header` |
| **Cue** | Kacheln fürs Rollencenter | leerer `Code[10]` | `Activities Cue` | `SMB Seminar Cue` |

**Das Beispiel aus dem Skript:**

```
Item (Master)  ──PK: No.──▶  Item Unit of Measure (Subsidiary)  ──▶  Unit of Measure (Supplemental)
                             PK: Item No., Unit of Measure Code       PK: Code

Sales Header (Document Header)  ──PK: Document Type, No.
Sales Line   (Document Line)    ──PK: Document Type, Document No., Line No.
```

### Selbst umsetzen

Bevor du irgendeine Tabelle anlegst, ordne sie einem Archetyp zu. Wenn du das nicht kannst,
ist das Datenmodell noch nicht verstanden. Aus dem Archetyp folgt dann automatisch:

- welchen Primärschlüssel sie bekommt,
- welche Standardfelder hineingehören,
- ob sie gelöscht werden darf,
- welche Pages es braucht.

## 2 Der allgemeine Datenfluss

Alle BC-Module folgen demselben Fluss von links nach rechts:

```
    Stammdaten              Bewegungsdaten                    Historie
    ──────────              ──────────────                    ────────

    Master  ──────┐
                  ├──────▶  Document Header ──────────▶  Posted Document Header
    Supplemental ─┘         Document Line   ──────────▶  Posted Document Line
    Subsidiary                     │
                                   │  TransferFields
                                   ▼
                          Journal Template
                          Journal Batch
                          Journal Line   ─────────────▶  Register (From/To Entry No.)
                                                         Ledger Entry
```

Zwei Mechanismen transportieren die Daten:

- **`:=`** – Feldweise Zuweisung, wenn Feldnummern oder Bedeutungen sich unterscheiden
  (z. B. Beleg → Buch.-Blattzeile).
- **`Record.TransferFields()`** – Massenkopie über gleiche Feldnummern, wenn Quell- und
  Zieltabelle strukturgleich sind (Beleg → gebuchter Beleg).

Deshalb gilt: **Bei Header/Line-Paaren bedeutet gleiche Feldnummer gleiche Bedeutung.** Wer die
gebuchte Tabelle mit anderen Feldnummern baut, kann `TransferFields` nicht nutzen.

## 3 Trigger und die Lebensdauer von AL-Globals

Eine Falle, die im Kurs eigens behandelt wird, weil sie schwer zu debuggen ist.

**Wenn die Steuerung aus einer Page kommt:**

| Trigger | AL-Globals der Tabelle |
|---|---|
| `OnInsert`, `OnDelete`, `Field.OnValidate` | werden **vor** dem Aufruf initialisiert |
| `OnModify`, `OnRename`, `Field.OnLookup` | werden **nicht** initialisiert |

**Wenn die Steuerung nicht aus einer Page kommt** (Codeunit, Report, Test):
Globals bleiben bei **allen** Triggern erhalten.

Weitere Verhaltensregeln:

- Ein neuer Datensatz über eine Card-Page instanziiert eine **neue Page-Instanz**.
- Datensatzwechsel, Partwechsel oder Wechsel ins Action Pane lösen `OnModify` aus, sofern nötig.
- Löschen über die Karte (aus der Übersicht heraus) schließt die Karte nach dem Löschen.

**Praktische Folge:** Verlasse dich in `OnModify` nie darauf, dass eine globale
Record-Variable noch gefüllt ist. Lies sie neu oder benutze eine Cache-Prozedur:

```al
procedure GetSemRegHeader()
begin
    if "Document No." <> SMBSeminarRegHeader."No." then
        SMBSeminarRegHeader.Get("Document No.");
end;
```

Das Muster (`SMBSeminarRegLine.Table.al`) liest nur, wenn sich der Schlüssel geändert hat – es
ist gleichzeitig Cache und Korrektheitsgarantie.

## 4 Implementierungsreihenfolge

### Inhaltlich

```
1. Stammdaten (Master und andere)
2. Beleg und Belegfunktionalität
3. Buchungsfunktionalität
   3a. Buch.-Blätter und Buchen in Posten
   3b. Belegbuchung
4. Verarbeiten von Posten und Integration in die Standardapplikation
5. Auswertungen
```

### Technisch, je Tabelle

```
1. Datenmodell festlegen und Tabellenklassen identifizieren
2. Tabellen erstellen
   - Felder anlegen, Properties inkl. Caption bearbeiten
   - Primärschlüssel definieren
   - Table Relations definieren
     → dazu gehört STETS die Überlegung, was im OnDelete zu programmieren ist
   - noch KEINE Funktionalität, außer was beim Kopieren aus dem Standard mitkommt
3. Pages erstellen und einbinden
4. Verfeinerungen: Nummernserie, Comment Sheet, Funktionalität
```

Der Punkt „noch keine Funktionalität" ist Absicht: Erst steht das Datenmodell, dann die
Oberfläche, dann die Logik. Wer die Logik zu früh schreibt, baut sie zweimal.

---

# Teil II – Stammdaten

## 5 Setup-Tabelle und Page

**Zweck:** Einstellungen, die für den ganzen Mandanten gelten – Nummernserien, Schalter,
Rundungsregeln.

**Vorlage im Standard:** Table 311 / Page 459 `Sales & Receivables Setup`.

### Tabelle

```al
table 123456701 "SMB Seminar Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Seminar Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Seminar Nos."; Code[20])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Seminar Nos. field.';
        }
        field(3; "Seminar Registration Nos."; Code[20]) { … }
        field(4; "Posted Seminar Reg. Nos."; Code[20]) { … }
        field(5; "Copy Comments Reg. to Pst."; Boolean)
        {
            Caption = 'Copy Comments Reg. to Pst.';
            DataClassification = CustomerContent;
            InitValue = true;                    // ← initial gesetzt
        }
    }

    keys
    {
        key(PK; "Primary Key") { Clustered = true; }
    }
}
```

Der Primärschlüssel bleibt **immer leer**. Dadurch kann es nur einen Datensatz geben.

### Page

```al
page 123456702 "SMB Seminar Setup"
{
    Caption = 'Seminar Setup';
    PageType = Card;
    SourceTable = "SMB Seminar Setup";
    UsageCategory = Administration;        // ← erscheint unter "Manuelle Einrichtung"
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
                field("Seminar Nos."; Rec."Seminar Nos.") { }
                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.") { }
                field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.") { }
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

### Selbst umsetzen

1. Tabelle mit `Primary Key` (Code[10]) als PK anlegen.
2. Je Nummernkreis ein `Code[20]`-Feld mit `TableRelation = "No. Series"`.
3. Page als `Card` mit `InsertAllowed = false`, `DeleteAllowed = false`,
   `UsageCategory = Administration`.
4. `OnOpenPage` legt den Satz an, falls er fehlt.
5. Im Code den Setup-Satz **einmal pro Lauf** lesen und cachen.

**Stolperfalle:** Ohne den `OnOpenPage`-Code läuft die Page beim ersten Öffnen in einen leeren
Zustand, und `Setup.Get()` schlägt überall fehl.

## 6 Enums

Enums ersetzen die alten Option-Felder. Sie sind eigene Objekte und damit erweiterbar.

```al
enum 123456702 "SMB Seminar Reg. Status"
{
    Extensible = true;

    value(0; Planning)     { Caption = 'Planning'; }
    value(1; Registration) { Caption = 'Registration'; }
    value(2; Closed)       { Caption = 'Closed'; }
    value(3; Canceled)     { Caption = 'Canceled'; }
}
```

Die vier Enums des Moduls:

| Enum | Werte | Verwendung |
|---|---|---|
| `SMB Internal/External` | Internal, External | Trainer und Räume klassifizieren |
| `SMB Seminar Reg. Status` | Planning, Registration, Closed, Canceled | Belegstatus |
| `SMB Sem. Ledger Charge Type` | Instructor, Room, Participant | Postenart |
| `SMB Sem. Comment Document Type` | Seminar Registration, Posted Seminar Registration | Belegart der Bemerkung |

**Besonderheit:**

```al
enum 123456710 "SMB Sem. Comment Document Type"
{
    Extensible = true;
    AssignmentCompatibility = true;      // ← erlaubt Zuweisung von/zu Integer
    …
}
```

`AssignmentCompatibility = true` wird gebraucht, weil die Kopierprozeduren der Bemerkungstabelle
`Integer`-Parameter haben (Standardmuster aus `Sales Comment Line`).

**Stolperfalle:** `Extensible = true` ist nachträglich nicht mehr abschaltbar, ohne die
Kompatibilität zu brechen – also gleich richtig setzen.

## 7 Supplemental-Tabellen

Ergänzende Stammdaten mit eigenem, vom Anwender vergebenem `Code`.

### `SMB Instructor` (Trainer)

Kerngedanke: Der Trainer ist eine **Brücke** zwischen dem Seminarmodul und den
Standardstammdaten `Contact` und `Resource`.

```al
field(30; "Contact No."; Code[20])
{
    TableRelation = Contact;
    trigger OnValidate()
    var
        Contact: Record Contact;
    begin
        Contact.Get("Contact No.");
        if Name = '' then Name := Contact.Name;                       // nur wenn leer!
        if "E-Mail" = '' then "E-Mail" := Contact."E-Mail";
        if "Phone No." = '' then "Phone No." := Contact."Phone No.";
        if "Salesperson Code" = '' then "Salesperson Code" := Contact."Salesperson Code";
        if "Language Code" = '' then "Language Code" := Contact."Language Code";
    end;
}

field(31; "Resource No."; Code[20])
{
    TableRelation = Resource where(Type = const(Person), Blocked = const(false));
    trigger OnValidate()
    var
        Resource: Record Resource;
    begin
        Resource.Get("Resource No.");
        Resource.TestField(Blocked, false);
        if Name = '' then Name := Resource.Name;
    end;
}
```

Zwei Muster daran:

1. **`if Feld = '' then`** – vorbelegen, aber nie überschreiben, was der Anwender selbst
   eingetragen hat.
2. **Gefilterte `TableRelation`** – der Trainer kann nur eine Ressource vom Typ `Person`
   bekommen, der Raum nur eine vom Typ `Machine`.

### Standard-Validierungshelfer nutzen

Statt eigene Prüfungen zu schreiben, nimmt man die Codeunits des Standards:

```al
local procedure ValidateEmail()
var
    MailManagement: Codeunit "Mail Management";
begin
    if "E-Mail" = '' then
        exit;
    MailManagement.CheckValidEmailAddresses("E-Mail");
end;

trigger OnValidate()                      // Telefonnummer
var
    TypeHelper: Codeunit "Type Helper";
begin
    if not TypeHelper.IsPhoneNumber("Phone No.") then
        FieldError("Phone No.", PhoneNoCannotContainLettersErr);
end;

local procedure ValidateSalesPersonCode()
var
    SalespersonPurchaser: Record "Salesperson/Purchaser";
begin
    if "Salesperson Code" <> '' then
        if SalespersonPurchaser.Get("Salesperson Code") then
            if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                Error(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser, true));
end;
```

### `SMB Seminar Room` – Adressfelder

Ein Adressblock im Standard ist mehr als ein paar Textfelder. Das vollständige Muster:

```al
field(7; City; Text[30])
{
    TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
                    else if ("Country/Region Code" = filter(<> ''))
                        "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
    ValidateTableRelation = false;         // ← freie Eingabe erlaubt

    trigger OnValidate()
    begin
        PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code",
                              (CurrFieldNo <> 0) and GuiAllowed);
    end;

    trigger OnLookup()
    var
        City2: Text;
        County2: Text;
    begin
        City2 := City;
        County2 := County;
        PostCode.LookupPostCode(City2, "Post Code", County2, "Country/Region Code");
        City := CopyStr(City2, 1, MaxStrLen(City));
        County := CopyStr(County2, 1, MaxStrLen(County));
    end;
}

field(11; "Country/Region Code"; Code[10])
{
    TableRelation = "Country/Region";
    trigger OnValidate()
    begin
        PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County,
                                              "Country/Region Code", xRec."Country/Region Code");
    end;
}

field(15; County; Text[30])
{
    CaptionClass = '5,1,' + "Country/Region Code";   // ← länderabhängige Beschriftung
}
```

Beachte die `Text`-Zwischenvariablen im `OnLookup`: Der Standard erwartet `Text`-Parameter, die
Felder sind aber längenbegrenzt – deshalb `CopyStr` beim Zurückschreiben. Ohne das gibt es die
Analyzer-Warnung `AA0139` (möglicher Overflow).

### Selbst umsetzen

1. `Code` (Code[20], `NotBlank = true`) als PK, `Name` als Bezeichnung.
2. `Blocked` + `TestBlocked()`.
3. Fremdschlüssel auf Standardstammdaten mit gefilterter `TableRelation`.
4. Vorbelegung nur bei leeren Feldern.
5. `fieldgroups` für DropDown und Brick.
6. `LookupPageId` / `DrillDownPageId`.
7. Adressfelder über `Record "Post Code"` validieren, nie selbst gebaut.

## 8 Die Master-Tabelle

Die Haupttabelle des Moduls. **Vorlage:** Table 27 `Item`.

### Pflichtausstattung

| Feld | Nr. | Typ | Zweck |
|---|---|---|---|
| `No.` | 1 | Code[20] | PK, Nummernserie |
| `Description` | 3 | Text[100] | Bezeichnung |
| `Search Description` | 4 | Code[100] | Suchbegriff |
| `Description 2` | 5 | Text[50] | Zusatz |
| `Blocked` | 20 | Boolean | Sperre |
| `Last Date Modified` | 22 | Date | Änderungsdatum |
| `No. Series` | 24 | Code[20] | genutzte Serie, `Editable = false` |
| `Comment` | 27 | Boolean FlowField | „gibt es Bemerkungen?" |
| `Global Dimension 1/2 Code` | 30/31 | Code[20] | Dimensionen |
| `Gen./VAT Prod. Posting Group` | 32/33 | Code[20] | Buchungsgruppen |
| fachliche Felder | 40 ff. | | Duration Days, Min/Max Participants, Language Code, Seminar Price |
| `Image` | 140 | Media | Bild |

### Abschlussarbeiten – die fünf Dinge, die leicht vergessen werden

**1. Fieldgroups**

```al
fieldgroups
{
    fieldgroup(DropDown; "No.", Description, "Language Code", "Duration Days") { }
    fieldgroup(Brick; "No.", Description, "Language Code", "Duration Days", Image) { }
}
```

`DropDown` bestimmt, was in Lookups erscheint, `Brick` was in Kachelansichten steht.

**2. Änderungsdatum**

```al
trigger OnModify()
begin
    "Last Date Modified" := Today();
end;

trigger OnRename()
begin
    CommentLine.RenameCommentLine(CommentLine."Table Name"::"SMB Seminar", xRec."No.", "No.");
    "Last Date Modified" := Today();
end;
```

**3. Suchbegriff**

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

Die Bedingung prüft, ob der bisherige Suchbegriff **automatisch** erzeugt war. Nur dann wird er
überschrieben. Hat der Anwender ihn manuell gesetzt, bleibt er stehen.

**4. Buchungsgruppen-Kopplung**

```al
field(32; "Gen. Prod. Posting Group"; Code[20])
{
    TableRelation = "Gen. Product Posting Group";
    trigger OnValidate()
    begin
        if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
            if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
    end;
}
```

Die MwSt.-Produktbuchungsgruppe wird aus der Standardvorgabe der Gen.-Prod.-Buchungsgruppe
vorbelegt – exakt wie beim Artikel.

**5. Wechselseitige Plausibilität**

```al
field(41; "Minimum Participants"; Integer)
{
    MinValue = 0;
    trigger OnValidate()
    begin
        if ("Minimum Participants" > "Maximum Participants") and
           ("Minimum Participants" > 0) and ("Maximum Participants" > 0)
        then
            FieldError("Minimum Participants",
                StrSubstNo(MustBeLEErr, FieldCaption("Maximum Participants")));
    end;
}
// … und spiegelbildlich in "Maximum Participants"
```

Die Prüfung steht in **beiden** Feldern. Die `> 0`-Bedingungen erlauben, dass beide Felder
gemeinsam auf 0 stehen (Zustand „nicht gepflegt").

### `TestBlocked` – zentrale Prüfung

```al
procedure TestBlocked()
begin
    TestField(Blocked, false);
end;
```

Aufrufer schreiben `SMBSeminar.TestBlocked()`, nicht `SMBSeminar.TestField(Blocked, false)`.
Vorteil: Wird die Sperrlogik später komplexer (z. B. datumsabhängig), ändert man eine Stelle.

### Löschbedingungen

```al
trigger OnDelete()
var
    SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
begin
    // 1. Blockierende Prüfung
    SMBSeminarRegHeader.SetRange("Seminar No.", "No.");
    if not SMBSeminarRegHeader.IsEmpty() then
        Error(CannotDeleteErr, TableCaption, SMBSeminarRegHeader.TableCaption);

    // 2. Löschweitergabe
    CommentLine.SetRange("Table Name", CommentLine."Table Name"::"SMB Seminar");
    CommentLine.SetRange("No.", "No.");
    CommentLine.DeleteAll();
end;
```

**Die Reihenfolge ist zwingend.** Erst prüfen, ob gelöscht werden darf; dann abhängige Daten
mitlöschen. Umgekehrt hättest du Bemerkungen gelöscht und danach abgebrochen.

**Regel aus dem Kurs:** *Ein Seminar darf nur gelöscht werden, wenn es keine Seminarregistrierung
mehr dafür gibt.* Posten werden **nie** mitgelöscht.

### Selbst umsetzen

1. Aus einer passenden Standard-Master-Tabelle (`Item`, `Customer`) die Feldstruktur kopieren.
2. Nicht benötigte Felder entfernen, fachliche ergänzen.
3. PK, Fieldgroups, Lookup-/DrillDownPageId setzen.
4. Die fünf Abschlussarbeiten oben.
5. `OnDelete` mit Prüfung + Weitergabe.
6. Erst danach List- und Card-Page.

## 9 Nummernserie

Fünf Schritte, immer dieselben. **Wichtig:** Die alte Codeunit `NoSeriesManagement` ist
abgelöst. Aktuell ist `Codeunit "No. Series"`.

### Schritt 1 – Feld in der Setup-Tabelle

```al
field(2; "Seminar Nos."; Code[20])
{
    Caption = 'Seminar Nos.';
    TableRelation = "No. Series";
}
```

### Schritt 2 – Feld in der Master-Tabelle

```al
field(24; "No. Series"; Code[20])
{
    Caption = 'No. Series';
    Editable = false;
    TableRelation = "No. Series";
}
```

Es speichert, **welche** Serie verwendet wurde – nicht die Nummer selbst.

### Schritt 3 – Automatische Vergabe im `OnInsert`

```al
trigger OnInsert()
begin
    if "No." = '' then begin
        SMBSemSetup.Get();
        SMBSemSetup.TestField("Seminar Nos.");

        "No. Series" := SMBSemSetup."Seminar Nos.";
        if NoSeries.AreRelated("No. Series", xRec."No. Series") then
            "No. Series" := xRec."No. Series";      // verwandte Serie beibehalten

        "No." := NoSeries.GetNextNo("No. Series");

        // Kollisionsschutz gegen manuell vergebene Nummern
        SMBSem.ReadIsolation(IsolationLevel::ReadUncommitted);
        SMBSem.SetLoadFields("No.");
        while SMBSem.Get("No.") do
            "No." := NoSeries.GetNextNo("No. Series");
    end;
end;
```

Die `while`-Schleife am Ende ist neu gegenüber älteren BC-Versionen: Sie fängt den Fall ab, dass
jemand manuell eine Nummer vergeben hat, die die Serie später erreicht.

Bei **Belegen** kommt das Buchungsdatum dazu, weil Nummernserien chronologisch sein können:

```al
"No." := NoSeries.GetNextNo("No. Series", "Posting Date");
```

### Schritt 4 – Prüfung auf manuelle Nummer

```al
field(1; "No."; Code[20])
{
    trigger OnValidate()
    begin
        if "No." <> xRec."No." then begin
            SMBSemSetup.Get();
            NoSeries.TestManual(SMBSemSetup."Seminar Nos.");   // wirft Fehler, wenn nicht erlaubt
            "No. Series" := '';
        end;
    end;
}
```

### Schritt 5 – Nummernserienauswahl (AssistEdit)

In der **Tabelle**:

```al
procedure AssistEdit(OldSem: Record "SMB Seminar") Result: Boolean
begin
    SMBSem := Rec;
    SMBSemSetup.Get();
    SMBSemSetup.TestField("Seminar Nos.");
    if NoSeries.LookupRelatedNoSeries(
        SMBSemSetup."Seminar Nos.", OldSem."No. Series", SMBSem."No. Series")
    then begin
        SMBSem."No." := NoSeries.GetNextNo(SMBSem."No. Series");
        Rec := SMBSem;
        exit(true);
    end;
end;
```

In der **Page**:

```al
field("No."; Rec."No.")
{
    Importance = Promoted;
    trigger OnAssistEdit()
    begin
        if Rec.AssistEdit(xRec) then
            CurrPage.Update();
    end;
}
```

### Die API im Überblick

| Methode | Zweck |
|---|---|
| `GetNextNo(Series[, Date])` | Nächste Nummer ziehen |
| `AreRelated(A, B)` | Sind zwei Serien verwandt? |
| `TestAreRelated(A, B)` | dito, mit Fehler |
| `LookupRelatedNoSeries(Default, [Old,] var New)` | Auswahldialog |
| `IsAutomatic(Series)` | Wird automatisch vergeben? |
| `TestManual(Series)` | Darf manuell erfasst werden? |

**Stolperfalle:** `AssistEdit` bekommt `xRec` als Parameter, nicht `Rec`. Nur so kennt die
Funktion die vorher genutzte Serie.

## 10 Bemerkungszeilen

Zwei Varianten – die Wahl hängt davon ab, ob Belegarten unterschieden werden müssen.

### Variante A – Standard-`Comment Line` erweitern (Stammdaten)

Für das Seminar reicht die Standardtabelle. Vier Schritte:

**1. Enum erweitern**

```al
enumextension 123456700 "SMB Comment Line Table Name" extends "Comment Line Table Name"
{
    value(123456700; "SMB Seminar") { Caption = 'Seminar'; }
}
```

**2. FlowField im Master**

```al
field(27; Comment; Boolean)
{
    Caption = 'Comment';
    Editable = false;
    FieldClass = FlowField;
    CalcFormula = exist("Comment Line" where("Table Name" = const("SMB Seminar"),
                                             "No." = field("No.")));
}
```

**3. Löschweitergabe und Umbenennen**

```al
trigger OnDelete()
begin
    CommentLine.SetRange("Table Name", CommentLine."Table Name"::"SMB Seminar");
    CommentLine.SetRange("No.", "No.");
    CommentLine.DeleteAll();
end;

trigger OnRename()
begin
    CommentLine.RenameCommentLine(CommentLine."Table Name"::"SMB Seminar", xRec."No.", "No.");
end;
```

**4. Action in Liste und Karte**

```al
action(Comments)
{
    ApplicationArea = All;
    Caption = 'Co&mments';
    Image = ViewComments;
    RunObject = Page "Comment Sheet";
    RunPageLink = "Table Name" = const("SMB Seminar"),
                  "No." = field("No.");
    ToolTip = 'View or add comments for the record.';
}
```

Und promoted über `actionref` – nicht über die alten `Promoted*`-Properties.

### Variante B – Eigene Bemerkungstabelle (Belege)

Belege brauchen eine Unterscheidung „ungebucht / gebucht" und Zeilenbemerkungen. Vorlage:
`Sales Comment Line`.

```al
table 123456704 "SMB Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DrillDownPageID = "SMB Seminar Comment List";
    LookupPageID = "SMB Seminar Comment List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "SMB Sem. Comment Document Type") { }
        field(2; "No."; Code[20]) { }
        field(3; "Line No."; Integer) { }
        field(4; "Date"; Date) { }
        field(5; "Code"; Code[10]) { }
        field(6; Comment; Text[80]) { }
        field(7; "Document Line No."; Integer) { }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.") { Clustered = true; }
    }
}
```

`"Document Line No." = 0` bedeutet „Bemerkung zum Kopf", `<> 0` „Bemerkung zur Zeile".

**Die Pflichtprozeduren:**

```al
procedure SetUpNewLine()                                  // Datum vorbelegen
var
    SeminarCommentLine: Record "SMB Seminar Comment Line";
begin
    SeminarCommentLine.SetRange("Document Type", "Document Type");
    SeminarCommentLine.SetRange("No.", "No.");
    SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
    SeminarCommentLine.SetRange(Date, WorkDate());
    if SeminarCommentLine.IsEmpty() then
        Date := WorkDate();
end;

procedure CopyComments(FromDocumentType: Integer; ToDocumentType: Integer;
                       FromNumber: Code[20]; ToNumber: Code[20])
var
    Source, Target : Record "SMB Seminar Comment Line";
begin
    Source.SetRange("Document Type", FromDocumentType);
    Source.SetRange("No.", FromNumber);
    if Source.FindSet() then
        repeat
            Target := Source;
            Target."Document Type" :=
                Enum::"SMB Sem. Comment Document Type".FromInteger(ToDocumentType);
            Target."No." := ToNumber;
            Target.Insert();
        until Source.Next() = 0;
end;

procedure DeleteComments(DocType: Enum "SMB Sem. Comment Document Type"; DocNo: Code[20])
begin
    SetRange("Document Type", DocType);
    SetRange("No.", DocNo);
    if not IsEmpty() then
        DeleteAll();
end;

procedure ShowComments(DocType: Enum "…"; DocNo: Code[20]; DocLineNo: Integer)
var
    SeminarCommentSheet: Page "SMB Seminar Comment Sheet";
begin
    SetRange("Document Type", DocType);
    SetRange("No.", DocNo);
    SetRange("Document Line No.", DocLineNo);
    Clear(SeminarCommentSheet);
    SeminarCommentSheet.SetTableView(Rec);
    SeminarCommentSheet.RunModal();
end;
```

### Die zwei Pages

**Comment Sheet** – editierbar, zum Erfassen:

```al
page 123456706 "SMB Seminar Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionFields = "Document Type", "No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "SMB Seminar Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Date"; Rec.Date) { ApplicationArea = Comments; }
                field(Comment; Rec.Comment) { ApplicationArea = Comments; }
                field("Code"; Rec.Code) { ApplicationArea = Comments; Visible = false; }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine();
    end;
}
```

**Comment List** – `Editable = false`, zum Ansehen.

`MultipleNewLines = true` erlaubt das schnelle Erfassen mehrerer Zeilen hintereinander –
typisch für Bemerkungsblätter.

### Aufruf aus dem Beleg

Kopfbemerkung per `RunObject`:

```al
action("Co&mments")
{
    ApplicationArea = Comments;
    Caption = 'Co&mments';
    Image = ViewComments;
    RunObject = Page "SMB Seminar Comment Sheet";
    RunPageLink = "Document Type" = const("SMB Sem. Comment Document Type"::"Seminar Registration"),
                  "No." = field("No."),
                  "Document Line No." = const(0);
    ToolTip = 'View or add comments for the record.';
}
```

Zeilenbemerkung per Prozedur (weil zwei Schlüssel dynamisch sind):

```al
action("Co&mments")
{
    trigger OnAction()
    begin
        Rec.ShowLineComments();
    end;
}
```

### Selbst umsetzen

1. Entscheiden: Standard-`Comment Line` (Stammdaten) oder eigene Tabelle (Belege)?
2. Bei eigener Tabelle: aus `Sales Comment Line` kopieren, Enum für die Belegarten anlegen.
3. Die vier Prozeduren `SetUpNewLine`, `CopyComments`, `DeleteComments`, `ShowComments`.
4. Comment Sheet (editierbar) und Comment List (nicht editierbar).
5. `Comment`-FlowField in Kopf und Master.
6. Löschweitergabe in **jedem** `OnDelete`, das Bemerkungen haben kann.
7. Actions in allen Pages.

## 11 Bild (Media)

```al
field(140; Image; Media)
{
    Caption = 'Image';
    DataClassification = CustomerContent;
    ToolTip = 'Specifies the picture that has been inserted for the resource.';
}
```

Dazu die Page `SMB Seminar Picture` (`PageType = CardPart`) mit Actions zum Hochladen,
Exportieren und Löschen – Vorlage im Standard ist `Item Picture` / `Resource Picture`.

Eingebunden als FactBox:

```al
area(factboxes)
{
    part(Picture; "SMB Seminar Picture")
    {
        ApplicationArea = All;
        SubPageLink = "No." = field("No.");
    }
}
```

Das Feld gehört in die `Brick`-Fieldgroup, damit es in Kachelansichten erscheint.

---

# Teil III – Beleg

## 12 Belegtabellen

### Standardschema der Belegimplementierung

```
1. Document-Tabellen anlegen
   PK Kopf:  [Document Type,] No.
   PK Zeile: [Document Type,] Document No., Line No.
2. Table Relation abbilden
   - Property TableRelation von Zeile auf Kopf
   - OnDelete-Trigger von Kopf auf Zeile
3. Umbenennen des Belegs unterbinden
4. Nummernserie implementieren
5. Funktion InitRecord, Aufruf im OnInsert nach dem Nummernserien-Code
6. Main-/Sub-Page und List-Page erstellen
7. Belegbemerkungen implementieren
```

Das Seminar hat keinen `Document Type` (es gibt nur eine Belegart), deshalb ist der PK des
Kopfes nur `"No."`.

### Kopf – die Feldblöcke

| Block | Felder |
|---|---|
| Identität | `No.` (1), `No. Series` (60) |
| Fachlich | `Starting Date`, `Seminar No.`, `Seminar Description`, `Instructor Code`, `Instructor Name`, `Status`, `Duration Days`, `Min/Max Participants`, `Language Code`, `Salesperson Code` |
| Fakturierung | `Seminar Price`, `Gen./VAT Prod. Posting Group` |
| Organisation | `Responsibility Center` |
| Adresse (denormalisiert) | `Room Code` + `Room Name`, `Room Address`, `Room City`, `Room Post Code`, … |
| Buchung | `Posting Date` (52), `Document Date` (53), `Posting Description` (54), `Reason Code` (56) |
| Zielnummernkreis | `Posting No.` (61), `Posting No. Series` (62), `Last Posting No.` (63) |
| Auswertung | `Comment` (42, FlowField), `No. of Participants` (100, FlowField) |
| Dimensionen | `Dimension Set ID` (480), `Shortcut Dimension 1/2 Code` (490/491) |

**Warum die Raumadresse im Beleg gespeichert wird:** Der Beleg muss die Adresse zum Zeitpunkt
der Buchung archivieren. Zieht der Seminarraum später um, darf sich der gebuchte Beleg nicht
rückwirkend ändern. Dasselbe Prinzip wie bei der Verkaufsrechnung, die die Debitorenadresse
kopiert und nicht referenziert.

### `Instructor Name` als FlowField – und warum nicht im gebuchten Beleg

Im **ungebuchten** Beleg ist der Name ein FlowField (immer aktuell):

```al
field(6; "Instructor Name"; Text[100])
{
    FieldClass = FlowField;
    Editable = false;
    CalcFormula = lookup("SMB Instructor".Name where(Code = field("Instructor Code")));
}
```

Im **gebuchten** Beleg ist es ein normales Feld:

```al
field(6; "Instructor Name"; Text[100])
{
    Caption = 'Instructor Name';
    // Es soll im gebuchten Beleg der historische Name archiviert werden
    // FieldClass = FlowField;
    Editable = false;
}
```

Deshalb muss beim Buchen `CalcFields` gerufen und der Wert explizit zugewiesen werden:

```al
SMBSeminarRegHeader.CalcFields("Instructor Name");
SMBPostedSeminarRegHeader.TransferFields(SMBSeminarRegHeader);
SMBPostedSeminarRegHeader."Instructor Name" := SMBSeminarRegHeader."Instructor Name";
```

`TransferFields` überträgt FlowFields **nicht** – das ist eine der häufigsten Fehlerquellen
beim Buchen.

### Umbenennen unterbinden

```al
trigger OnRename()
begin
    Error(CannotRenameErr, TableCaption);
end;
```

### Zeile – Verweis auf den Kopf

```al
field(1; "Document No."; Code[20])
{
    Caption = 'Document No.';
    TableRelation = "SMB Seminar Reg. Header";
}
field(2; "Line No."; Integer) { Caption = 'Line No.'; }

keys
{
    key(PK; "Document No.", "Line No.") { Clustered = true; }
}
```

### Löschbedingungen für Belege

Aus dem Kurs:

> **Ein Beleg darf gelöscht werden, wenn**
> - der Status des Kopfes `Canceled` oder `Closed` ist
> - alle oder keine Belegzeilen des Kopfes gebucht wurden
>
> **Eine Belegzeile darf gelöscht werden, wenn**
> - die Zeile noch nicht gebucht wurde
> - der Status des Kopfes `Registration` ist

Im Kopf:

```al
trigger OnDelete()
var
    SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    TestStatusFinished();

    // "gemischte" Zeilen (teils gebucht, teils nicht) verbieten
    SMBSeminarRegLine.SetRange("Document No.", "No.");
    SMBSeminarRegLine.SetRange(Registered, true);
    if not SMBSeminarRegLine.IsEmpty() then begin
        SMBSeminarRegLine.SetRange(Registered, false);
        if not SMBSeminarRegLine.IsEmpty() then
            Error(MixedLineExistErr, TableCaption);
    end;
    SMBSeminarRegLine.SetRange(Registered);      // Filter zurücknehmen

    SMBSeminarRegLine.DeleteAll();
    SMBSeminarCommentLine.DeleteComments(
        SMBSeminarCommentLine."Document Type"::"Seminar Registration", "No.");
end;

local procedure TestStatusFinished()
begin
    if (Status = Status::Planning) or (Status = Status::Registration) then
        FieldError(Status, StrSubstNo(MustBeErr, Status::Canceled, Status::Closed));
end;
```

Beachte `SMBSeminarRegLine.SetRange(Registered);` **ohne** Wert – das entfernt den Filter
wieder, sodass `DeleteAll()` alle Zeilen erwischt.

In der Zeile:

```al
trigger OnDelete()
var
    SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
begin
    TestStatusOpen();

    SMBSeminarCommentLine.SetRange("Document Type",
        SMBSeminarCommentLine."Document Type"::"Seminar Registration");
    SMBSeminarCommentLine.SetRange("No.", "Document No.");
    SMBSeminarCommentLine.SetRange("Document Line No.", "Line No.");
    SMBSeminarCommentLine.DeleteAll();
end;

local procedure TestStatusOpen()
begin
    TestField(Registered, false);
    GetSemRegHeader();
    SMBSeminarRegHeader.TestStatusOpen();
end;
```

Die Zeile prüft **beides**: den eigenen Buchungsstatus und den Status des Kopfes. Dafür braucht
sie `GetSemRegHeader()` in der Zeile und `TestStatusOpen()` im Kopf.

### `InitInsert` und `InitRecord`

```al
trigger OnInsert()
begin
    InitInsert();

    // Vorbelegung, wenn der Beleg aus dem Stammsatz heraus angelegt wird
    // Vorlage: Table "Sales Header", OnInsert / GetSellToCustomerFilter
    if GetFilter("Seminar No.") <> '' then
        if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
            Validate("Seminar No.", GetRangeMin("Seminar No."));
end;

local procedure InitInsert()
begin
    if "No." = '' then begin
        SMBSeminarSetup.Get();
        SMBSeminarSetup.TestField("Seminar Registration Nos.");
        "No. Series" := SMBSeminarSetup."Seminar Registration Nos.";
        if NoSeries.AreRelated("No. Series", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
        SMBSeminarRegHeader.ReadIsolation(IsolationLevel::ReadUncommitted);
        SMBSeminarRegHeader.SetLoadFields("No.");
        while SMBSeminarRegHeader.Get("No.") do
            "No." := NoSeries.GetNextNo("No. Series", "Posting Date");
    end;

    InitRecord();
end;

local procedure InitRecord()
begin
    SMBSeminarSetup.Get();

    // Buchungsnummernserie aus der Einrichtung, wenn automatisch
    if "Posting No. Series" = '' then
        if NoSeries.IsAutomatic(SMBSeminarSetup."Posted Seminar Reg. Nos.") then
            "Posting No. Series" := SMBSeminarSetup."Posted Seminar Reg. Nos.";

    if "Posting Date" = 0D then
        "Posting Date" := WorkDate();
    "Document Date" := WorkDate();
    "Posting Description" := TableCaption + ' ' + "No.";
    "Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
end;
```

Die drei Zeilen mit `GetFilter`/`GetRangeMin`/`GetRangeMax` sind der Standardweg, den
Fremdschlüssel vorzubelegen, wenn die Page mit `RunPageLink` und `RunPageMode = Create`
geöffnet wurde.

### Buchungsdatum und chronologische Nummernserien

```al
field(52; "Posting Date"; Date)
{
    trigger OnValidate()
    begin
        TestField("Posting Date");
        TestNoSeriesDate("Posting No.", "Posting No. Series",
                         FieldCaption("Posting No."), FieldCaption("Posting No. Series"));
        UpdateCurrFactorInLines();
    end;
}

procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[20];
                           NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
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

Ist bereits eine Buchungsnummer gezogen **und** die Serie chronologisch, darf das
Buchungsdatum nicht mehr geändert werden.

## 13 Beleg-Pages

Ein Beleg braucht drei Pages: Document, Subpage, List.

### Document-Page

```al
page 123456710 "SMB Seminar Registration"
{
    ApplicationArea = All;
    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = "SMB Seminar Reg. Header";
    UsageCategory = None;          // Einstieg über die List-Page

    layout
    {
        area(Content)
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
                field("Seminar No."; Rec."Seminar No.") { Importance = Promoted; }
                field("Seminar Description"; Rec."Seminar Description") { }
                field("Starting Date"; Rec."Starting Date") { Importance = Promoted; }
                field(Status; Rec.Status) { }
                field("Language Code"; Rec."Language Code") { Importance = Additional; }
                field("No. of Participants"; Rec."No. of Participants") { }
            }

            part(Lines; "SMB Seminar Reg. Lines Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                Caption = 'Lines';
                UpdatePropagation = Both;
            }

            group(SeminarRoom) { Caption = 'Seminar Room'; … }
            group(Invoicing)   { Caption = 'Invoicing'; … }
        }

        area(FactBoxes)
        {
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }

            part(SeminarDetails; "SMB Seminar Details FactBox")
            {
                SubPageLink = "No." = field("Seminar No.");
            }
            part(CustomerDetails; "Customer Details FactBox")
            {
                Provider = Lines;                                 // ← folgt der Zeile
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            part(ContactDetails; "SMB Contact Details Factbox")
            {
                Provider = Lines;
                SubPageLink = "No." = field("Participant Contact No.");
            }
        }
    }
}
```

Zwei Details, die den Unterschied machen:

- **`UpdatePropagation = Both`** – Änderungen im Kopf aktualisieren die Zeilen und umgekehrt.
- **`Provider = Lines`** – die FactBox folgt dem markierten Satz in der Subpage, nicht dem Kopf.
  So sieht man die Debitor- und Kontaktdetails des aktuell gewählten Teilnehmers.

### Subpage

```al
page 123456711 "SMB Seminar Reg. Lines Subpage"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "SMB Seminar Reg. Line";
    AutoSplitKey = true;         // Zeilennummern in 10.000er-Schritten
    DelayedInsert = true;        // Insert erst beim Verlassen der Zeile
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
                        CurrPage.Update();       // FactBoxes neu zeichnen
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

`AutoSplitKey` + `DelayedInsert` sind bei **jeder** Belegzeilen-Subpage Pflicht. Ohne
`DelayedInsert` wird die Zeile bereits beim Betreten eingefügt und die Validierungslogik läuft
auf einem halbleeren Satz.

### Währungsauswahl mit Kursänderung

```al
field("Currency Code"; Rec."Currency Code")
{
    trigger OnAssistEdit()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        Clear(ChangeExchangeRate);
        SMBSeminarRegHeader.Get(Rec."Document No.");
        if SMBSeminarRegHeader."Posting Date" <> 0D then
            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor",
                                            SMBSeminarRegHeader."Posting Date")
        else
            ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", WorkDate());

        if ChangeExchangeRate.RunModal() = Action::OK then
            Rec.Validate("Currency Factor", ChangeExchangeRate.GetParameter());
        Clear(ChangeExchangeRate);
    end;
}

var
    ChangeExchangeRate: Page "Change Exchange Rate";
```

Die Standard-Page `Change Exchange Rate` wird per `SetParameter`/`GetParameter` bedient – das
gleiche Muster wie im Verkaufsbeleg.

### List-Page

`Editable = false`, `UsageCategory = Lists`, `CardPageId` zeigt auf die Document-Page. Sie trägt
dieselben Actions wie die Document-Page (Bemerkungen, Buchen).

### Die Buchen-Action

```al
action(Post)
{
    ApplicationArea = Basic, Suite;
    Caption = 'P&ost';
    Image = PostOrder;
    ShortCutKey = 'F9';
    AboutTitle = 'When all is set, you post';
    AboutText = 'After entering the lines and other information, you post the document …';
    ToolTip = 'Finalize the document or journal by posting the amounts and quantities …';

    trigger OnAction()
    begin
        Codeunit.Run(Codeunit::"SMB Seminar-Post (Yes/No)", Rec);
    end;
}
```

`AboutTitle`/`AboutText` speisen die In-App-Tour („Teaching Tips").

## 14 Belegkopf-Funktionalität

Sieben Aufgaben, die der Kurs am Belegkopf durchspielt.

### 14.1 `TestStatusOpen` – zentrale Statusprüfung

```al
procedure TestStatusOpen()
begin
    if Status in [Status::Canceled, Status::Closed] then
        FieldError(Status);
end;

local procedure TestStatusPlanning()
begin
    if Status <> Status::Planning then
        FieldError(Status, StrSubstNo(StatusMustBeErr, Status::Planning));
end;
```

Aus **allen** Feldern rufen, deren Änderung im falschen Status unzulässig ist.

### 14.2 `TestNoLine` – keine Änderung nach Zeilenerfassung

```al
local procedure TestNoLine()
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    SMBSeminarRegLine.SetRange("Document No.", "No.");
    if not SMBSeminarRegLine.IsEmpty() then
        Error(LineExistErr, SMBSeminarRegLine.TableCaption, TableCaption);
end;
```

### 14.3 Startdatum in der Vergangenheit – Warnung statt Fehler

```al
field(2; "Starting Date"; Date)
{
    trigger OnValidate()
    begin
        TestStatusPlanning();
        TestNoLine();

        if ("Starting Date" < WorkDate()) and ("Starting Date" > 0D) then
            Message(DateInPastMsg, FieldCaption("Starting Date"));
    end;
}
```

`Message` blockiert nicht – der Anwender wird informiert, darf aber weitermachen. Für die
gehobene Variante schlägt der Kurs eine **Smart Notification** vor
(`Notification.Send()`), die der Anwender abschalten kann.

### 14.4 Validierung der Master-Entität

Die feste Abfolge:

```al
field(3; "Seminar No."; Code[20])
{
    TableRelation = "SMB Seminar" where(Blocked = const(false));

    trigger OnValidate()
    begin
        TestStatusPlanning();              // 1. Darf geändert werden?
        TestNoLine();                      // 2. Gibt es schon Zeilen?

        SMBSeminar.Get("Seminar No.");     // 3. Stammsatz lesen
        SMBSeminar.TestBlocked();          // 4. Darf er verwendet werden?

        FillHeaderFieldsFromMaster();      // 5. Felder übernehmen
    end;
}

local procedure FillHeaderFieldsFromMaster()
begin
    "Seminar Description" := SMBSeminar.Description;
    "Duration Days" := SMBSeminar."Duration Days";
    "Minimum Participants" := SMBSeminar."Minimum Participants";
    "Maximum Participants" := SMBSeminar."Maximum Participants";
    "Language Code" := SMBSeminar."Language Code";
    Validate("Seminar Price", SMBSeminar."Seminar Price");     // ← Validate, nicht :=
    SMBSeminar.TestField("Gen. Prod. Posting Group");
    "Gen. Prod. Posting Group" := SMBSeminar."Gen. Prod. Posting Group";
    SMBSeminar.TestField("VAT Prod. Posting Group");
    "VAT Prod. Posting Group" := SMBSeminar."VAT Prod. Posting Group";
    "Shortcut Dimension 1 Code" := SMBSeminar."Global Dimension 1 Code";
    "Shortcut Dimension 2 Code" := SMBSeminar."Global Dimension 2 Code";
end;
```

Der Preis wird mit `Validate` gesetzt, weil daran Folgelogik hängt. Alle anderen Felder per
einfacher Zuweisung.

### 14.5 Sofortige Aktualisierung eines FlowFields

```al
field(5; "Instructor Code"; Code[20])
{
    TableRelation = "SMB Instructor" where(Blocked = const(false));

    trigger OnValidate()
    var
        SMBInstructor: Record "SMB Instructor";
    begin
        SMBInstructor.Get("Instructor Code");
        SMBInstructor.TestField(Blocked, false);
        CalcFields("Instructor Name");        // ← sonst bleibt der alte Name stehen
    end;
}
```

### 14.6 Raum validieren – inklusive Zurücksetzen

```al
field(20; "Room Code"; Code[20])
{
    TableRelation = "SMB Seminar Room" where(Blocked = const(false));

    trigger OnValidate()
    begin
        if "Room Code" <> '' then begin
            SMBSeminarRoom.Get("Room Code");
            SMBSeminarRoom.TestBlocked();
        end else
            SMBSeminarRoom.Init();           // ← leert die Variable

        FillRoomFields();                    // überträgt (dann leere) Werte
    end;
}
```

Der `else`-Zweig ist wichtig: Wird der Raumcode geleert, muss auch die kopierte Adresse
verschwinden. `Init()` auf der Puffervariablen erledigt das elegant, ohne die Zuweisungen
doppelt zu schreiben.

### 14.7 Kopfänderung an die Zeilen weiterreichen

```al
field(14; "Seminar Price"; Decimal)
{
    trigger OnValidate()
    begin
        UpdateSMBSeminarRegLinesByFieldNo(FieldNo("Seminar Price"), CurrFieldNo <> 0, true);
    end;
}

procedure UpdateSMBSeminarRegLinesByFieldNo(ChangedFieldNo: Integer;
                                            AskQuestion: Boolean;
                                            UnregisteredLinesOnly: Boolean)
var
    "Field": Record "Field";
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    Question: Text[250];
    ConfirmUpdateLinesQst: Label 'You have modified %1.\\Do you want to update the lines?',
        Comment = '%1 = caption of the changed field';
begin
    SMBSeminarRegLine.Reset();
    SMBSeminarRegLine.SetRange("Document No.", "No.");
    if UnregisteredLinesOnly then
        SMBSeminarRegLine.SetRange(Registered, false);

    if SMBSeminarRegLine.IsEmpty() then
        exit;

    if not Field.Get(Database::"SMB Seminar Reg. Header", ChangedFieldNo) then
        Field.Get(Database::"SMB Seminar Reg. Line", ChangedFieldNo);

    if AskQuestion then begin
        Question := StrSubstNo(ConfirmUpdateLinesQst, Field."Field Caption");
        if GuiAllowed() then
            if not Dialog.Confirm(Question, true) then
                exit;
    end;

    SMBSeminarRegLine.LockTable();
    Modify();

    if SMBSeminarRegLine.FindSet() then
        repeat
            case ChangedFieldNo of
                FieldNo("Seminar Price"):
                    SMBSeminarRegLine.Validate("Seminar Price (LCY)", "Seminar Price");
            end;
            SMBSeminarRegLine.Modify(true);
        until SMBSeminarRegLine.Next() = 0;
end;
```

Drei Techniken darin:

1. **`Record "Field"`** liefert die übersetzte Feldbeschriftung für die Rückfrage – dadurch
   funktioniert der Text in jeder Sprache.
2. **`CurrFieldNo <> 0`** als `AskQuestion` – gefragt wird nur bei Eingabe über die Oberfläche,
   nicht bei programmatischer Änderung.
3. **`case ChangedFieldNo of`** – eine Prozedur für beliebig viele Felder erweiterbar.

## 15 Belegzeilen-Funktionalität

### 15.1 Das führende Feld

Jede Belegzeile hat **ein** Feld, dessen Validierung die Zeile initialisiert. Beim Seminar ist
das `Bill-to Customer No.`:

```al
field(3; "Bill-to Customer No."; Code[20])
{
    TableRelation = Customer where(Blocked = const("Customer Blocked"::" "));

    trigger OnValidate()
    var
        Customer: Record Customer;
    begin
        TestStatusOpen();
        TestField("Participant Contact No.", '');       // Reihenfolge erzwingen

        // Daten vom Debitor
        Customer.Get("Bill-to Customer No.");
        Customer.TestField(Blocked, Customer.Blocked::" ");
        Customer.TestField("Gen. Bus. Posting Group");
        "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
        Customer.TestField("VAT Bus. Posting Group");
        "VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
        Validate("Currency Code", Customer."Currency Code");

        // Daten vom Kopf
        GetSemRegHeader();
        SMBSeminarRegHeader.TestField("Seminar No.");
        Validate("Seminar Price (LCY)", SMBSeminarRegHeader."Seminar Price");
        "Registration Date" := WorkDate();
    end;
}
```

`TestField("Participant Contact No.", '')` erzwingt, dass zuerst der Debitor und dann der
Kontakt gewählt wird – sonst wäre die Kontaktfilterung sinnlos.

### 15.2 Gefilterter Lookup – nur Kontakte des Debitors

```al
trigger OnLookup()
var
    Contact: Record Contact;
    ContactBusinessRelation: Record "Contact Business Relation";
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    TestField("Bill-to Customer No.");

    if not ContactBusinessRelation.FindByRelation(
        ContactBusinessRelation."Link to Table"::Customer, "Bill-to Customer No.")
    then
        Error(NoContactErr, Contact.TableCaption);

    SMBSeminarRegLine := Rec;

    Contact.FilterGroup(2);                                        // unentfernbarer Filter
    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
    Contact.FilterGroup(0);

    Contact."No." := SMBSeminarRegLine."Participant Contact No.";   // Cursor positionieren
    Contact.SetCurrentKey(Name);

    if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then begin
        SMBSeminarRegLine.Validate("Participant Contact No.", Contact."No.");
        Rec := SMBSeminarRegLine;
    end;
end;
```

Drei Techniken:

- **`FilterGroup(2)`** – ein Filterbereich, den der Anwender in der Lookup-Page nicht entfernen
  kann. `FilterGroup(0)` schaltet zurück auf den normalen Bereich.
- **`ContactBusinessRelation.FindByRelation(...)`** – die Standardmethode, um vom Debitor zum
  Firmenkontakt zu kommen. Nicht selbst mit `SetRange` nachbauen.
- **Umweg über eine lokale Kopie** (`SMBSeminarRegLine := Rec` … `Rec := SMBSeminarRegLine`) –
  in `OnLookup` darf `Rec` nicht direkt geändert werden.

**Der Datenmodell-Hintergrund** (Blatt „Datenmodell Kontakt Debitor" der XLSX):

```
Sales/Seminar Line          Contact Business Relation        Contact
Bill-to Cust. No. = 10000   Contact No. | Link to Table | No.    No.     | Type    | Company No.
                            Kt0005      | Customer      | 10000  Kt0005  | Company | Kt0005
                                                                 Kt0012  | Person  | Kt0005
```

Der Debitor hängt am **Firmenkontakt**; die Personen darunter tragen dessen Nummer in
`Company No.`.

### 15.3 Doppelanmeldung verhindern – mit einem Lesezugriff

Die Kursaufgabe verbietet ausdrücklich `Count()`, `Next()` und Schleifen. Die Lösung ist ein
Filter:

```al
trigger OnValidate()
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    Contact: Record Contact;
    ContactBusinessRelation: Record "Contact Business Relation";
begin
    TestStatusOpen();
    TestField("Bill-to Customer No.");

    // Ist der Kontakt in dieser Anmeldung schon erfasst?
    SMBSeminarRegLine.SetRange("Document No.", "Document No.");
    SMBSeminarRegLine.SetRange("Participant Contact No.", "Participant Contact No.");
    SMBSeminarRegLine.SetFilter("Line No.", '<>%1', "Line No.");    // sich selbst ausschließen
    if not SMBSeminarRegLine.IsEmpty() then
        Error(ParticipantRegisteredErr, FieldCaption("Participant Contact No."));

    // Passt der Kontakt zum Debitor?
    Contact.Get("Participant Contact No.");
    ContactBusinessRelation.SetRange("Link to Table",
        ContactBusinessRelation."Link to Table"::Customer);
    ContactBusinessRelation.SetRange("Contact No.", Contact."Company No.");
    if not ContactBusinessRelation.FindFirst() then
        Error(NoCompanyErr);

    if "Bill-to Customer No." <> ContactBusinessRelation."No." then
        Error(WrongCustomerErr);

    CalcFields("Participant Name");
end;
```

Die Zeile `SetFilter("Line No.", '<>%1', "Line No.")` löst das Problem „der Datensatz findet
sich selbst" – ohne sie schlüge die Prüfung beim Bearbeiten einer bestehenden Zeile fehl.

### 15.4 Rabatt- und Betragslogik

Vier Felder, die sich gegenseitig aktualisieren. Vorlage ist `Sales Line`:

| Standard (`Sales Line`) | Seminar (`Seminar Reg. Line`) | `OnValidate` tut |
|---|---|---|
| `Unit Price` | `Seminar Price (LCY)` | `Validate("Line Discount %")` |
| `Line Discount %` | `Line Discount %` | Rabattbetrag berechnen, Zeilenbetrag aktualisieren |
| `Line Discount Amount` | `Line Discount Amount (LCY)` | Rabatt-% zurückrechnen, Zeilenbetrag aktualisieren |
| `Line Amount` | `Line Amount (LCY)` | in Rabattbetrag umrechnen und diesen validieren |

```al
field(10; "Seminar Price (LCY)"; Decimal)
{
    trigger OnValidate()
    begin
        TestStatusOpen();
        Validate("Line Discount %");
    end;
}

field(11; "Line Discount %"; Decimal)
{
    DecimalPlaces = 0 : 5;
    MinValue = 0;
    MaxValue = 100;
    trigger OnValidate()
    begin
        ValidateLineDiscountPercent();
    end;
}

field(12; "Line Discount Amount (LCY)"; Decimal)
{
    trigger OnValidate()
    begin
        "Line Discount Amount (LCY)" := Round("Line Discount Amount (LCY)");
        TestStatusOpen();
        if xRec."Line Discount Amount (LCY)" <> "Line Discount Amount (LCY)" then
            UpdateLineDiscPct();
        UpdateAmounts();
    end;
}

field(13; "Line Amount (LCY)"; Decimal)
{
    trigger OnValidate()
    var
        MaxLineAmount: Decimal;
    begin
        TestField("Seminar Price (LCY)");
        MaxLineAmount := "Seminar Price (LCY)" - "Line Amount (LCY)";
        Validate("Line Discount Amount (LCY)", MaxLineAmount);
    end;
}
```

Die beiden Rechenprozeduren:

```al
procedure ValidateLineDiscountPercent()
begin
    TestStatusOpen();
    "Line Discount Amount (LCY)" :=
        Round(Round("Seminar Price (LCY)") * "Line Discount %" / 100);
    UpdateAmounts();
end;

local procedure UpdateLineDiscPct()
var
    LineDiscountPct: Decimal;
begin
    if Round("Seminar Price (LCY)") <> 0 then begin
        LineDiscountPct := Round(
            "Line Discount Amount (LCY)" / Round("Seminar Price (LCY)") * 100, 0.00001);
        if not (LineDiscountPct in [0 .. 100]) then
            Error(LineDiscountPctErr);
        "Line Discount %" := LineDiscountPct;
    end else
        "Line Discount %" := 0;
end;
```

**Stolperfalle:** Die gegenseitigen `Validate`-Aufrufe können sich im Kreis drehen. Der Standard
löst das, indem die rechnenden Prozeduren nur **zuweisen** (`:=`) statt zu validieren – nur der
Einstiegspunkt validiert.

## 16 Währung

Jede Zeile trägt Beträge doppelt: in Mandantenwährung (LCY) und in Belegwährung.

```
Debitor ──▶ Währungscode ──▶ Währungsfaktor
                 │
                 ▼
  Seminarpreis (MW) ─ Rabatt % ─ Rabattbetrag (MW) ─▶ Betrag (MW) ──▶ Betrag Fremdwährung
                                                       Line Amount (LCY)   Line Amount
```

### Währungsfaktor aktualisieren

```al
field(17; "Currency Code"; Code[10])
{
    TableRelation = Currency;
    trigger OnValidate()
    begin
        UpdateCurrencyFactor();
    end;
}

procedure UpdateCurrencyFactor()
var
    UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
    CurrencyDate: Date;
begin
    if "Currency Code" <> '' then begin
        GetSemRegHeader();
        if SMBSeminarRegHeader."Posting Date" <> 0D then
            CurrencyDate := SMBSeminarRegHeader."Posting Date"
        else
            CurrencyDate := WorkDate();

        if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then
            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code")
        else
            UpdateCurrencyExchangeRates.ShowMissingExchangeRatesNotification("Currency Code");
    end else
        "Currency Factor" := 0;
end;
```

Fehlt der Kurs, wird **keine** Exception geworfen, sondern eine Notification gezeigt – so macht
es der Standard auch.

### Umrechnung in beide Richtungen

```al
local procedure UpdateAmounts()
begin
    "Line Amount (LCY)" := Round("Seminar Price (LCY)" - "Line Discount Amount (LCY)");

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

field(19; "Line Amount"; Decimal)         // Eingabe in Fremdwährung
{
    AutoFormatType = 1;
    AutoFormatExpression = "Currency Code";
    trigger OnValidate()
    begin
        if "Currency Code" <> '' then
            Validate("Line Amount (LCY)",
                Round(CurrExchRate.ExchangeAmtFCYToLCY(
                    GetDate(), "Currency Code", "Line Amount", "Currency Factor")))
        else
            Validate("Line Amount (LCY)", "Line Amount");
    end;
}

local procedure GetDate(): Date
begin
    GetSemRegHeader();
    if SMBSeminarRegHeader."Posting Date" <> 0D then
        exit(SMBSeminarRegHeader."Posting Date");
    exit(WorkDate());
end;
```

`AutoFormatType = 1` + `AutoFormatExpression = "Currency Code"` sorgt dafür, dass der Client
das richtige Währungssymbol anzeigt.

### Kursänderung an die Zeilen weiterreichen

Ändert sich das Buchungsdatum im Kopf, sind die Kurse womöglich veraltet:

```al
local procedure UpdateCurrFactorInLines()
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    SMBSeminarRegLine.SetRange("Document No.", "No.");
    SMBSeminarRegLine.SetRange(Registered, false);
    SMBSeminarRegLine.SetFilter("Currency Code", '<>%1', '');

    if not SMBSeminarRegLine.IsEmpty() then
        if Confirm(CurrExRateQst, true) then begin
            SMBSeminarRegLine.FindSet(true);
            repeat
                SMBSeminarRegLine.UpdateCurrencyFactor();
                SMBSeminarRegLine.Modify();
            until SMBSeminarRegLine.Next() = 0;
        end;
end;
```

---

# Teil IV – Buchen

## 17 Buch.-Blatt versus Posten

Der begriffliche Kern des ganzen Buchungskapitels.

| | **Buch.-Blatt (Journal)** | **Posten (Ledger Entry)** |
|---|---|---|
| Editierbarkeit | frei editierbares Arbeitsblatt | schreibgeschützt |
| Primärschlüssel | zusammengesetzt: Template, Batch, Line No. | `Entry No.` (Integer), beginnend bei 1 |
| Zeilennummern | automatisch in 10.000er-Schritten | fortlaufend +1 |
| Weitere Tabellen | Journal Template, Journal Batch | Register |
| Sekundärschlüssel | wenige | viele, für Auswertungen |
| Inhalt | ein Buchungssatz je Zeile (bei Split mehrere) | die wichtigsten Informationen des Moduls |
| Regel | – | **niemals direkt einfügen oder löschen** |

### Struktur der Buch.-Blätter

```
Template ──┬── Batch ──┬── Line
           │           ├── Line
           │           └── Line
           ├── Batch ──┬── Line
           │           └── Line
           └── Batch
```

| Ebene | Zweck | Buchen möglich? |
|---|---|---|
| **Journal Template** | Vorlage, konfiguriert verschiedene Blätter | nein |
| **Journal Batch** | „Kopf" für die Zeilen, mehrere je Vorlage | ja |
| **Journal Line** | enthält alle Informationen eines Buchungssatzes | ja |

Das Seminarmodul nutzt eine **reduzierte Variante**: Es gibt nur die `SMB Seminar Journal Line`,
keine Template- und Batch-Tabellen. Grund: Das Buch.-Blatt wird nie manuell erfasst, sondern
ausschließlich programmatisch von der Belegbuchung gefüllt. Die PK-Felder bleiben trotzdem
erhalten, damit die Struktur mit dem Standard vergleichbar bleibt:

```al
keys
{
    key(PK; "Journal Template Name", "Journal Batch Name", "Line No.") { Clustered = true; }
}
```

### `EmptyLine` – die Pflichtprozedur der Journal Line

```al
procedure EmptyLine(): Boolean
begin
    exit(("Seminar No." = '') and (Quantity = 0));
end;
```

Check Line und Post Line rufen sie als Erstes und steigen bei einer leeren Zeile sofort aus.

## 18 Nomenklatur der Buchungsroutinen

Die **Endziffer** der Codeunit-ID ist in BC bedeutungstragend. Das ist keine Konvention zum
Aussuchen, sondern gelebter Standard.

### Verwaltungs- und Starter-Codeunits

| Endziffer | Buch.-Blatt | Beleg |
|---|---|---|
| **0** | Journal Management | **Document – Post** |
| **1** | Journal Post (Stapel buchen) | **Document – Post (Yes/No)** |
| **2** | Journal Post + Print | Document – Post + Print |
| **3** | Journal Batch Post | – |
| **4** | Journal Batch Post + Print | – |
| **5** | Show Ledger | – |

Starter-Codeunits dürfen kurz mit dem Anwender interagieren, dann starten sie die Verarbeitung.

### Buchungsroutinen – kein UI erlaubt

| Endziffer | Name | Aufgabe |
|---|---|---|
| **1** | Jnl. Check Line | Schnelltest einer Zeile, möglichst ohne DB-Zugriff |
| **2** | Jnl. Post Line | Buchen einer Zeile in einen oder mehrere Posten |
| **3** | Jnl. Post Batch | Buchen eines ganzen Stapels |

```
Starter Codeunit
      │
      ├──▶ Post Batch (x3) ──┬──▶ Check Line (x1)   [Vorabprüfung aller Zeilen]
      │                      └──▶ Post Line  (x2) ──▶ Check Line (x1)
      └──▶ Post Line (x2) ────────▶ Check Line (x1)
```

### Im Seminarmodul

| ID | Objekt | Rolle |
|---|---|---|
| 123456700 | `SMB Seminar-Post` | Document – Post (**0**) |
| 123456701 | `SMB Seminar-Post (Yes/No)` | Starter (**1**) |
| 123456731 | `SMB Sem. Jnl.-Check Line` | Check Line (**1**) |
| 123456732 | `SMB Sem. Jnl.-Post Line` | Post Line (**2**) |
| 123456745 | `SMB Seminar Reg.-Show Ledger` | Show Ledger (**5**) |

Ein `Post Batch` gibt es nicht, weil das Buch.-Blatt nicht manuell bebucht wird.

## 19 Check-Line-Codeunit

**Vorlage:** Codeunit 211 `Res. Jnl.-Check Line`.

### Die fünf Merkmale – alle verbindlich

1. Erhält **genau eine** zu prüfende Buch.-Blattzeile als Parameter.
2. **Kein UI** – kein `Message`, kein `Confirm`, kein `Dialog`.
3. **Lesen und Schreiben der Buch.-Blattzeile ist nicht erlaubt** – die Zeile kommt als
   Parameter und wird nicht aus der Datenbank nachgelesen oder zurückgeschrieben.
4. Führt nur Prüfungen durch, die den **Datenbankserver nicht belasten**: Pflichtfelder,
   geschäftsvorfallabhängige Regeln, zulässiges Buchungsdatum.
5. Einrichtungsdatensätze dürfen ausnahmsweise gelesen werden – aber nur **einmal pro
   Buchungslauf**, also auch im Stapel. Dimensionskonfigurationen zählen als Einrichtung.

### Der Code

```al
codeunit 123456731 "SMB Sem. Jnl.-Check Line"
{
    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ClosingDateErr: Label 'cannot be a closing date';

    procedure RunCheck(var SMBSeminarJnlLine: Record "SMB Seminar Journal Line")
    begin
        GLSetup.Get();

        if SMBSeminarJnlLine.EmptyLine() then
            exit;

        SMBSeminarJnlLine.TestField("Seminar No.", ErrorInfo.Create());
        SMBSeminarJnlLine.TestField("Posting Date", ErrorInfo.Create());

        // Geschäftsvorfall-abhängige Prüfungen
        case SMBSeminarJnlLine."Charge Type" of
            SMBSeminarJnlLine."Charge Type"::Instructor:
                SMBSeminarJnlLine.TestField("Instructor Code");
            SMBSeminarJnlLine."Charge Type"::Room:
                SMBSeminarJnlLine.TestField("Seminar Room Code");
            SMBSeminarJnlLine."Charge Type"::Participant:
                begin
                    SMBSeminarJnlLine.TestField("Bill-to Customer No.");
                    SMBSeminarJnlLine.TestField("Participant Contact No.");
                end;
        end;

        // Nur was fakturiert wird, braucht Buchungsgruppen
        if SMBSeminarJnlLine.Chargeable then begin
            SMBSeminarJnlLine.TestField("Bill-to Customer No.");
            SMBSeminarJnlLine.TestField("Gen. Prod. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("VAT Prod. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("Gen. Bus. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("VAT Bus. Posting Group", ErrorInfo.Create());
        end;

        CheckPostingDate(SMBSeminarJnlLine);

        if SMBSeminarJnlLine."Document Date" <> 0D then
            if SMBSeminarJnlLine."Document Date" <> NormalDate(SMBSeminarJnlLine."Document Date") then
                SMBSeminarJnlLine.FieldError("Document Date", ErrorInfo.Create(ClosingDateErr, true));
    end;

    local procedure CheckPostingDate(SMBSeminarJnlLine: Record "SMB Seminar Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        if SMBSeminarJnlLine."Posting Date" <> NormalDate(SMBSeminarJnlLine."Posting Date") then
            SMBSeminarJnlLine.FieldError("Posting Date", ErrorInfo.Create(ClosingDateErr, true));

        UserSetupManagement.CheckAllowedPostingDate(SMBSeminarJnlLine."Posting Date");
    end;
}
```

**Erläuterungen:**

- `NormalDate(D) <> D` erkennt ein **Abschlussdatum** (z. B. `31.12.2025 C`). Auf ein solches
  darf nicht normal gebucht werden.
- `UserSetupManagement.CheckAllowedPostingDate` prüft den erlaubten Buchungszeitraum aus
  Benutzereinrichtung und Finanzbuchhaltungs-Einrichtung.
- `ErrorInfo.Create()` erzeugt eine aufklappbare, im Client verlinkbare Fehlermeldung – die
  moderne Form gegenüber einem nackten `Error`.

### Selbst umsetzen

1. Standard-Check-Line kopieren (`Res. Jnl.-Check Line` oder `Gen. Jnl.-Check Line`).
2. Kopie bereinigen: nur behalten, was fachlich passt.
3. `TableNo` auf die eigene Journal Line setzen, `OnRun` ruft `RunCheck`.
4. `EmptyLine()`-Ausstieg an den Anfang.
5. Pflichtfeldprüfungen, dann fallabhängige Prüfungen per `case`.
6. Buchungsdatum prüfen.
7. **Kein** UI, **kein** Nachlesen der Zeile.

## 20 Post-Line-Codeunit

**Vorlage:** Codeunit 212 `Res. Jnl.-Post Line`.

### Die Merkmale

1. Bucht die als Parameter übergebene Buch.-Blattzeile.
2. **Kein UI.**
3. Ruft für die Zeile zuerst die **Check-Line-Codeunit**.
4. Führt die Prüfungen durch, für die **DB-Zugriffe** nötig sind (z. B. Stammsatz gesperrt).
5. Erstellt **Posten und Journaleintrag** – braucht dafür `Permissions`.
6. Stellt bei Bedarf Verknüpfungen zwischen korrespondierenden Posten her.
7. Wird von anderen Buchungsroutinen aufgerufen.

### Der Code

```al
codeunit 123456732 "SMB Sem. Jnl.-Post Line"
{
    Permissions = tabledata "SMB Seminar Ledger Entry" = rimd,
                  tabledata "SMB Seminar Register" = rimd;
    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SMBSeminarJournalLineGlobal: Record "SMB Seminar Journal Line";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
        SMBSeminar: Record "SMB Seminar";
        SMBSeminarRegister: Record "SMB Seminar Register";
        SMBSemJnlCheckLine: Codeunit "SMB Sem. Jnl.-Check Line";
        NextEntryNo: Integer;                       // ← überlebt mehrere Aufrufe!

    procedure RunWithCheck(var SMBSeminarJournalLine: Record "SMB Seminar Journal Line")
    begin
        SMBSeminarJournalLineGlobal.Copy(SMBSeminarJournalLine);
        Code();
        SMBSeminarJournalLine := SMBSeminarJournalLineGlobal;
    end;

    local procedure "Code"()
    begin
        if SMBSeminarJournalLineGlobal.EmptyLine() then
            exit;

        SMBSemJnlCheckLine.RunCheck(SMBSeminarJournalLineGlobal);

        if NextEntryNo = 0 then begin
            SMBSeminarLedgerEntry.LockTable();
            NextEntryNo := SMBSeminarLedgerEntry.GetLastEntryNo() + 1;
        end;

        if SMBSeminarJournalLineGlobal."Document Date" = 0D then
            SMBSeminarJournalLineGlobal."Document Date" := SMBSeminarJournalLineGlobal."Posting Date";

        // Prüfung mit DB-Zugriff — gehört hierher, nicht in die Check Line
        SMBSeminar.Get(SMBSeminarJournalLineGlobal."Seminar No.");
        SMBSeminar.TestField(Blocked, false);

        SMBSeminarLedgerEntry.Init();
        SMBSeminarLedgerEntry.CopyFromSemJnlLine(SMBSeminarJournalLineGlobal);
        SMBSeminarLedgerEntry."User ID" :=
            CopyStr(UserId(), 1, MaxStrLen(SMBSeminarLedgerEntry."User ID"));
        SMBSeminarLedgerEntry."Entry No." := NextEntryNo;

        InsertRegister(SMBSeminarLedgerEntry."Entry No.");
        SMBSeminarLedgerEntry.Insert(true);

        NextEntryNo := NextEntryNo + 1;
    end;
}
```

**Warum `NextEntryNo` global ist:** Die Post Line wird pro Zeile aufgerufen. Wäre der Zähler
lokal, würde bei jedem Aufruf erneut die Postentabelle gesperrt und die letzte Nummer gelesen.
Global gelesen wird nur einmal pro Buchungslauf.

**Das gleiche gilt für den Register:** `SMBSeminarRegister."No." = 0` bedeutet „noch kein
Register in diesem Lauf".

### Postentabelle – `GetLastEntryNo` und `CopyFrom…`

Beide Prozeduren gehören in die **Postentabelle**, nicht in die Codeunit:

```al
procedure GetLastEntryNo(): Integer
var
    FindRecordManagement: Codeunit "Find Record Management";
begin
    exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
end;

procedure CopyFromSemJnlLine(SemJnlLine: Record "SMB Seminar Journal Line")
begin
    "Seminar No." := SemJnlLine."Seminar No.";
    "Posting Date" := SemJnlLine."Posting Date";
    …
    "No. Series" := SemJnlLine."Posting No. Series";
    // Buchungsgruppen für die spätere Fakturierung
    "Gen. Bus. Posting Group" := SemJnlLine."Gen. Bus. Posting Group";
    "VAT Bus. Posting Group" := SemJnlLine."VAT Bus. Posting Group";
    "Gen. Prod. Posting Group" := SemJnlLine."Gen. Prod. Posting Group";
    "VAT Prod. Posting Group" := SemJnlLine."VAT Prod. Posting Group";
    // Dimensionen
    "Dimension Set ID" := SemJnlLine."Dimension Set ID";
end;
```

`FindRecordManagement.GetLastEntryIntFieldValue` ist der performante Standardweg – schneller als
`FindLast()` auf der ganzen Tabelle.

### Der Register

```al
local procedure InsertRegister(SemLedgEntryNo: Integer)
begin
    if SMBSeminarRegister."No." = 0 then begin
        SMBSeminarRegister.LockTable();
        SMBSeminarRegister."No." := SMBSeminarRegister.GetLastEntryNo() + 1;
        SMBSeminarRegister.Init();
        SMBSeminarRegister."From Entry No." := NextEntryNo;
        SMBSeminarRegister."To Entry No." := NextEntryNo;
        SMBSeminarRegister."Creation Date" := Today();
        SMBSeminarRegister."Creation Time" := Time();
        SMBSeminarRegister."Source Code" := SMBSeminarJournalLineGlobal."Source Code";
        SMBSeminarRegister."Journal Batch Name" := SMBSeminarJournalLineGlobal."Journal Batch Name";
        SMBSeminarRegister."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBSeminarRegister."User ID"));
        SMBSeminarRegister.Insert();
    end else begin
        if ((SemLedgEntryNo < SMBSeminarRegister."From Entry No.") and (SemLedgEntryNo <> 0)) or
           ((SMBSeminarRegister."From Entry No." = 0) and (SemLedgEntryNo > 0))
        then
            SMBSeminarRegister."From Entry No." := SemLedgEntryNo;
        if SemLedgEntryNo > SMBSeminarRegister."To Entry No." then
            SMBSeminarRegister."To Entry No." := SemLedgEntryNo;
        SMBSeminarRegister.Modify();
    end;
end;
```

Beim ersten Posten wird der Register angelegt, bei jedem weiteren `To Entry No.` erweitert. So
klammert ein Register genau die Posten **eines** Buchungslaufs.

### Show Ledger – vom Register zu den Posten

```al
codeunit 123456745 "SMB Seminar Reg.-Show Ledger"
{
    TableNo = "SMB Seminar Register";

    trigger OnRun()
    begin
        SeminarLedgerEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        Page.Run(Page::"SMB Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
}
```

Eingebunden in die Register-Page:

```al
action("Seminar Ledger")
{
    RunObject = Codeunit "SMB Seminar Reg.-Show Ledger";
    ToolTip = 'Executes the Seminar Ledger action';
}
```

### Die Postentabelle – Schlüssel

```al
keys
{
    key(PK; "Entry No.") { Clustered = true; }
    key(DocNo; "Document No.") { }
    key(Nav; "Document No.", "Posting Date") { }                  // für Navigate
    key(SemNo_PostDat_SemRoomCod; "Seminar No.", "Posting Date", "Seminar Room Code")
    {
        SumIndexFields = Quantity;
    }
    key(Inv; "Bill-to Customer No.", "Closed by Document No.", Chargeable) { }   // für Fakturierung
    key(SK5; "Seminar No.", "Posting Date", "Charge Type", Chargeable)
    {
        SumIndexFields = "Total Price";                            // für Statistik-FlowFields
    }
}
```

**Regel:** Jeder Zugriffspfad, den Auswertungen, Navigate oder FlowFields brauchen, bekommt
einen eigenen Sekundärschlüssel. `SumIndexFields` nur dort, wo tatsächlich summiert wird.

### Selbst umsetzen

1. Standard-Post-Line kopieren, bereinigen.
2. `Permissions`-Property setzen (`tabledata … = rimd` für Posten und Register).
3. `RunWithCheck` als Einstieg, `Code()` als interne Arbeitsprozedur.
4. Globale `NextEntryNo` und globale Register-Variable.
5. `EmptyLine`-Ausstieg, dann `RunCheck`.
6. DB-abhängige Prüfungen.
7. `Init` → `CopyFrom…` → `User ID` → `Entry No.` → `InsertRegister` → `Insert(true)`.
8. In der Postentabelle: `GetLastEntryNo()` und `CopyFrom…()` bereitstellen.

## 21 Belegbuchung

### Der Datenfluss

```
   Instructor    Sem. Room    Participant
        │            │             │
        └────────────┴─────────────┘
                     ▼
            Sem. Reg. Header ──────────────▶  Pstd. Sem. Reg. Header
            Sem. Reg. Line   ──────────────▶  Pstd. Sem. Reg. Line
            Sem. Comment Line ─────────────▶  (kopiert, wenn Setup-Schalter an)
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
   Sem. Journal Line        Res. Journal Line
        │                         │
        ▼                         ▼
   Sem. Register            Res. Register
   Sem. Ledger Entry        Res. Ledger Entry
```

Das Seminarmodul bucht **zwei** Postenarten: eigene Seminarposten und Standard-Ressourcenposten
(für Trainer und Raum). Die Verknüpfung läuft über `Res. Ledger Entry No.` im Seminarposten.

### Vorbereitung – die Starter-Codeunit

```al
codeunit 123456701 "SMB Seminar-Post (Yes/No)"
{
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        if not Rec.Find() then
            Error(DocumentErrorsMgt.GetNothingToPostErrorMsg());

        SMBSeminarRegHeader.Copy(Rec);
        Code(SMBSeminarRegHeader);
        Rec := SMBSeminarRegHeader;
    end;

    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        WantToPostQst: Label 'Do you want to post the %1?', Comment = '%1 = TableCaption';

    local procedure "Code"(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        if not Confirm(WantToPostQst, true, SMBSeminarRegHeader.TableCaption) then
            exit;

        Codeunit.Run(Codeunit::"SMB Seminar-Post", SMBSeminarRegHeader);
    end;
}
```

Mehr macht sie nicht: fragen und weiterreichen. `DocumentErrorsMgt.GetNothingToPostErrorMsg()`
liefert den übersetzten Standardtext.

### Die Post-Codeunit – Aufbau

**Vorlage:** Codeunit 80 `Sales-Post`.

```al
codeunit 123456700 "SMB Seminar-Post"
{
    Permissions = tabledata "SMB Posted Seminar Reg. Header" = rimd,
                  tabledata "SMB Posted Seminar Reg. Line" = rimd,
                  tabledata "SMB Seminar Reg. Header" = rimd,
                  tabledata "SMB Seminar Reg. Line" = rimd;
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    internal procedure RunWithCheck(var SMBSeminarRegHeader2: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        ClearAllVariables();                                    // 1
        GetSeminarSetup();                                      // 1.1
        SMBSeminarRegHeader := SMBSeminarRegHeader2;            // 1.2

        FillTempLines(SMBSeminarRegHeader, TempSMBSeminarRegLineGlobal);   // 2

        CheckAndUpdate(SMBSeminarRegHeader);                    // 3  Kopf
        ProcessPostingLines(SMBSeminarRegHeader);               // 17 Zeilen
        FinalizeSeminarRegistration(SMBSeminarRegHeader);       // 21 Aufräumen

        Commit();
    end;
```

### Schritt 1 – Variablen initialisieren

```al
local procedure ClearAllVariables()
begin
    ClearAll();
    TempSMBSeminarRegLineGlobal.DeleteAll();     // ClearAll leert Temp-Tabellen nicht!
end;
```

`ClearAll()` setzt alle globalen Variablen zurück – **außer** dem Inhalt temporärer Tabellen.
Die müssen explizit geleert werden.

### Schritt 2 – Zeilen in eine temporäre Tabelle

```al
procedure FillTempLines(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
                        var TempSMBSeminarRegLine: Record "SMB Seminar Reg. Line" temporary)
begin
    TempSMBSeminarRegLine.Reset();
    if TempSMBSeminarRegLine.IsEmpty() then
        CopyToTempLines(SMBSeminarRegHeader, TempSMBSeminarRegLine);
end;

procedure CopyToTempLines(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
                          var TempSMBSeminarRegLine: Record "SMB Seminar Reg. Line" temporary)
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
    if SMBSeminarRegLine.FindSet() then
        repeat
            TempSMBSeminarRegLine := SMBSeminarRegLine;
            TempSMBSeminarRegLine.Insert();
        until SMBSeminarRegLine.Next() = 0;
end;
```

**Warum temporär?** Die Verarbeitung wird von Änderungen an der echten Tabelle entkoppelt.
Während des Buchens werden die echten Zeilen modifiziert (`Registered := true`) und am Ende
gelöscht – die Schleife läuft trotzdem sauber über die Kopie weiter.

### Schritt 3 – `CheckAndUpdate`

```al
local procedure CheckAndUpdate(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    SourceCodeSetup: Record "Source Code Setup";
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    LastResEntryNo: Integer;
    ModifyHeader: Boolean;
begin
    CheckSeminarDocument(SMBSeminarRegHeader);                       // 4

    ModifyHeader := UpdatePostingNos(SMBSeminarRegHeader);           // 11
    if ModifyHeader then begin                                       // 12
        SMBSeminarRegHeader.Modify();
        Commit();
    end;

    LockTables(SMBSeminarRegHeader);                                 // 13

    SourceCodeSetup.Get();                                           // 14
    SrcCode := SourceCodeSetup."SMB Seminar";

    InsertPostedHeaders(SMBSeminarRegHeader);                        // 15

    // 16 – Ressourcen- und Seminarposten für Trainer und Raum
    LastResEntryNo := PostResJnlLine("SMB Sem. Ledger Charge Type"::Instructor, SMBSeminarRegHeader);
    PostSemJnlLine("SMB Sem. Ledger Charge Type"::Instructor, SMBSeminarRegHeader,
                   SMBSeminarRegLine, LastResEntryNo);

    LastResEntryNo := PostResJnlLine("SMB Sem. Ledger Charge Type"::Room, SMBSeminarRegHeader);
    PostSemJnlLine("SMB Sem. Ledger Charge Type"::Room, SMBSeminarRegHeader,
                   SMBSeminarRegLine, LastResEntryNo);
end;
```

### Die Prüfkaskade

```al
procedure CheckSeminarDocument(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    UserSetupManagement: Codeunit "User Setup Management";
begin
    CheckMandatoryHeaderFields(SMBSeminarRegHeader);                          // 5–7
    UserSetupManagement.CheckAllowedPostingDate(SMBSeminarRegHeader."Posting Date");  // 8
    CheckSemRegLineExistToPost(SMBSeminarRegHeader);                          // 9
    InitProgressWindow(SMBSeminarRegHeader);                                  // 10
end;

local procedure CheckMandatoryHeaderFields(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    SMBInstructor: Record "SMB Instructor";
    SMBSeminarRoom: Record "SMB Seminar Room";
begin
    SMBSeminarRegHeader.TestField("Seminar No.");
    SMBSeminarRegHeader.TestField("Posting Date");
    SMBSeminarRegHeader.TestField("Document Date");
    SMBSeminarRegHeader.TestField("Starting Date");
    SMBSeminarRegHeader.TestField("Instructor Code");
    SMBSeminarRegHeader.TestField("Room Code");
    SMBSeminarRegHeader.TestField(Status, SMBSeminarRegHeader.Status::Closed);

    // Buchungsgruppen für die Fakturierung
    SMBSeminarRegHeader.TestField("Gen. Prod. Posting Group");
    SMBSeminarRegHeader.TestField("VAT Prod. Posting Group");

    // Ressourcen müssen hinterlegt sein, sonst schlägt die Ressourcenbuchung fehl
    SMBInstructor.Get(SMBSeminarRegHeader."Instructor Code");
    SMBInstructor.TestField("Resource No.");
    SMBSeminarRoom.Get(SMBSeminarRegHeader."Room Code");
    SMBSeminarRoom.TestField("Resource No.");
end;

local procedure CheckSemRegLineExistToPost(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
begin
    SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
    SMBSeminarRegLine.SetRange(Registered, false);
    SMBSeminarRegLine.SetFilter("Bill-to Customer No.", '<>%1', '');
    if SMBSeminarRegLine.IsEmpty() then
        Error(NothingToPostErr);
end;
```

`TestField(Status, Status::Closed)` erzwingt, dass nur abgeschlossene Anmeldungen gebucht werden.

### Buchungsnummer ziehen

```al
local procedure UpdatePostingNos(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header") ModifyHeader: Boolean
begin
    UpdatePostingNo(SMBSeminarRegHeader, ModifyHeader);
    // Platz für weitere Nummern (z. B. bei Lieferung + Rechnung in einem Lauf)
end;

local procedure UpdatePostingNo(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
                                var ModifyHeader: Boolean)
var
    NoSeries: Codeunit "No. Series";
begin
    if SMBSeminarRegHeader."Posting No." = '' then begin
        SMBSeminarRegHeader.TestField("Posting No. Series");
        SMBSeminarRegHeader."Posting No." :=
            NoSeries.GetNextNo(SMBSeminarRegHeader."Posting No. Series",
                               SMBSeminarRegHeader."Posting Date");
        ModifyHeader := true;
    end;
end;
```

Das anschließende `Modify` + `Commit` schreibt die Nummer fest. Bricht die Buchung danach ab,
bleibt die Nummer am Beleg – beim nächsten Versuch wird dieselbe verwendet. Genau so verhält
sich der Standard.

### Tabellen sperren

```al
local procedure LockTables(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
    ResLedgerEntry: Record "Res. Ledger Entry";
begin
    SMBSeminarRegHeader.LockTable();
    SMBSeminarRegHeader.Find();              // ← nach LockTable neu lesen
    SMBSeminarRegLine.LockTable();
    SMBSeminarLedgerEntry.LockTable();
    ResLedgerEntry.LockTable();
end;
```

**Immer dieselbe Reihenfolge** – sonst entstehen Deadlocks zwischen parallelen Buchungsläufen.

### Gebuchten Kopf erzeugen

```al
local procedure InsertPstSemRegHeader(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
    RecordLinkManagement: Codeunit "Record Link Management";
begin
    SMBPostedSeminarRegHeader.Init();
    SMBSeminarRegHeader.CalcFields("Instructor Name");            // FlowField vorher berechnen!

    SMBPostedSeminarRegHeader.TransferFields(SMBSeminarRegHeader);
    SMBPostedSeminarRegHeader."Instructor Name" := SMBSeminarRegHeader."Instructor Name";

    // Herkunft des gebuchten Belegs
    SMBPostedSeminarRegHeader."Registration No. Series" := SMBSeminarRegHeader."No. Series";
    SMBPostedSeminarRegHeader."Registration No." := SMBSeminarRegHeader."No.";
    SMBPostedSeminarRegHeader."No. Series" := SMBSeminarRegHeader."Posting No. Series";
    SMBPostedSeminarRegHeader."No." := SMBSeminarRegHeader."Posting No.";

    SMBPostedSeminarRegHeader."Source Code" := SrcCode;
    SMBPostedSeminarRegHeader."User ID" :=
        CopyStr(UserId(), 1, MaxStrLen(SMBPostedSeminarRegHeader."User ID"));
    SMBPostedSeminarRegHeader."No. Printed" := 0;
    SMBPostedSeminarRegHeader.Insert(true);

    // Bemerkungen und Notizen mitnehmen — gesteuert über die Einrichtung
    GetSeminarSetup();
    if SMBSeminarSetup."Copy Comments Reg. to Pst." then begin
        SMBSeminarCommentLine.CopyComments(
            SMBSeminarCommentLine."Document Type"::"Seminar Registration".AsInteger(),
            SMBSeminarCommentLine."Document Type"::"Posted Seminar Registration".AsInteger(),
            SMBSeminarRegHeader."No.", SMBPostedSeminarRegHeader."No.");
        RecordLinkManagement.CopyLinks(SMBSeminarRegHeader, SMBPostedSeminarRegHeader);
    end;
end;
```

Die vier Zuweisungen nach `TransferFields` sind der Kern: Der gebuchte Beleg bekommt die
**Buchungsnummer** als eigene `No.` und speichert die Ursprungsnummer separat.

### Zeilen verarbeiten

```al
local procedure ProcessPostingLines(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
var
    LineCount: Integer;
begin
    TempSMBSeminarRegLineGlobal.FindSet();
    repeat
        LineCount := LineCount + 1;
        if GuiAllowed() then
            Window.Update(2, LineCount);
        PostSemRegLine(SMBSeminarRegHeader, TempSMBSeminarRegLineGlobal);
    until TempSMBSeminarRegLineGlobal.Next() = 0;
end;

local procedure PostSemRegLine(var SMBSeminarRegHeader: Record "…";
                               var SMBSeminarRegLine: Record "…")
begin
    TestAndUpdateSemRegLine(SMBSeminarRegLine);                     // 18
    InsertPstSemRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);    // 19
    PostSemJnlLine("SMB Sem. Ledger Charge Type"::Participant,
                   SMBSeminarRegHeader, SMBSeminarRegLine, 0);      // 20
end;

local procedure TestAndUpdateSemRegLine(var SMBSeminarRegLine: Record "…")
begin
    SMBSeminarRegLine.TestField("Bill-to Customer No.");
    SMBSeminarRegLine.TestField("Participant Contact No.");
    SMBSeminarRegLine.TestField("Gen. Bus. Posting Group");
    SMBSeminarRegLine.TestField("VAT Bus. Posting Group");

    // Nicht zu fakturierende Zeilen: Beträge auf null
    if not SMBSeminarRegLine."To Invoice" then begin
        SMBSeminarRegLine."Seminar Price (LCY)" := 0.0;
        SMBSeminarRegLine."Line Discount %" := 0.0;
        SMBSeminarRegLine."Line Discount Amount (LCY)" := 0.0;
        SMBSeminarRegLine."Line Amount (LCY)" := 0.0;
        SMBSeminarRegLine."Line Amount" := 0.0;
    end;
end;

local procedure InsertPstSemRegLine(var SMBSeminarRegLine: Record "…";
                                    SMBSeminarRegHeader: Record "…")
begin
    SMBPostedSeminarRegLine.Init();
    SMBSeminarRegLine.Registered := true;
    SMBSeminarRegLine.Participated := true;
    SMBSeminarRegLine.Modify();
    SMBSeminarRegLine.CalcFields("Participant Name");               // FlowField!
    SMBPostedSeminarRegLine.TransferFields(SMBSeminarRegLine);
    SMBPostedSeminarRegLine."Participant Name" := SMBSeminarRegLine."Participant Name";
    SMBPostedSeminarRegLine."Document No." := SMBSeminarRegHeader."Posting No.";
    SMBPostedSeminarRegLine.Insert();
end;
```

### Buch.-Blattzeile füllen und übergeben

Die Post-Codeunit schreibt **nie direkt** in die Postentabelle:

```al
local procedure PostSemJnlLine(ChargeType: Enum "SMB Sem. Ledger Charge Type";
                               var SMBSeminarRegHeader: Record "…";
                               var SMBSeminarRegLine: Record "…";
                               LastResLedgEntryNo: Integer)
var
    SMBSeminarJournalLine: Record "SMB Seminar Journal Line";
    SMBSemJnlPostLine: Codeunit "SMB Sem. Jnl.-Post Line";
begin
    SMBSeminarJournalLine.Init();

    // Gemeinsame Felder
    SMBSeminarJournalLine."Seminar No." := SMBSeminarRegHeader."Seminar No.";
    SMBSeminarJournalLine."Posting Date" := SMBSeminarRegHeader."Posting Date";
    SMBSeminarJournalLine."Document Date" := SMBSeminarRegHeader."Document Date";
    SMBSeminarJournalLine."Entry Type" := SMBSeminarJournalLine."Entry Type"::Registration;
    SMBSeminarJournalLine."Document No." := SMBSeminarRegHeader."Posting No.";
    SMBSeminarJournalLine."Source Code" := SrcCode;
    SMBSeminarJournalLine."Res. Ledger Entry No." := LastResLedgEntryNo;
    SMBSeminarJournalLine."Gen. Prod. Posting Group" := SMBSeminarRegHeader."Gen. Prod. Posting Group";
    SMBSeminarJournalLine."VAT Prod. Posting Group" := SMBSeminarRegHeader."VAT Prod. Posting Group";
    …

    // Fallabhängige Felder
    case ChargeType of
        ChargeType::Instructor:
            begin
                SMBSeminarJournalLine."Charge Type" := ChargeType;
                SMBSeminarJournalLine.Chargeable := false;         // Trainer wird nicht fakturiert
                SMBInstructor.Get(SMBSeminarRegHeader."Instructor Code");
                SMBSeminarJournalLine."Instructor Code" := SMBInstructor.Code;
                SMBSeminarJournalLine.Description := SMBInstructor.Name;
                SMBSeminarJournalLine.Quantity := SMBSeminarRegHeader."Duration Days";
                SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
            end;
        ChargeType::Room:
            begin … end;                                            // analog
        ChargeType::Participant:
            begin
                SMBSeminarJournalLine."Charge Type" := ChargeType;
                SMBSeminarJournalLine.Chargeable := SMBSeminarRegLine."To Invoice";
                SMBSeminarRegLine.CalcFields("Participant Name");
                SMBSeminarJournalLine."Participant Name" := SMBSeminarRegLine."Participant Name";
                SMBSeminarJournalLine."Bill-to Customer No." := SMBSeminarRegLine."Bill-to Customer No.";
                SMBSeminarJournalLine.Quantity := 1;
                SMBSeminarJournalLine."Unit Price" := SMBSeminarRegLine."Line Amount (LCY)";
                SMBSeminarJournalLine."Total Price" := SMBSeminarRegLine."Line Amount (LCY)";
                SMBSeminarJournalLine."Gen. Bus. Posting Group" := SMBSeminarRegLine."Gen. Bus. Posting Group";
                SMBSeminarJournalLine."VAT Bus. Posting Group" := SMBSeminarRegLine."VAT Bus. Posting Group";
                // Dimensionen aus der ZEILE, nicht aus dem Kopf
                SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegLine."Dimension Set ID";
            end;
    end;

    SMBSemJnlPostLine.RunWithCheck(SMBSeminarJournalLine);
end;
```

Beachte: Trainer- und Raumposten holen die Dimensionen aus dem **Kopf**, Teilnehmerposten aus
der **Zeile**.

### Fortschrittsanzeige

```al
var
    Window: Dialog;
    PostingLinesMsg: Label 'Posting lines              #2######\', Comment = '#2 = line counter';

procedure InitProgressWindow(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
begin
    Window.Open('#1#################################\\' + PostingLinesMsg);
    Window.Update(1, StrSubstNo('%1', SMBSeminarRegHeader."No."));
end;
```

`#1`, `#2` sind Platzhalter, die Rautenzahl bestimmt die Feldbreite. **Jeder** `Window.Update`
muss mit `GuiAllowed()` geschützt sein, sonst brechen Tests und Hintergrundläufe.

### Abschluss

```al
local procedure FinalizeSeminarRegistration(var SMBSeminarRegHeader: Record "…")
var
    SMBSeminarRegLine: Record "…";
    SMBSeminarCommentLine: Record "…";
begin
    if EverythingPosted() then begin
        SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
        SMBSeminarRegLine.DeleteAll();

        SMBSeminarCommentLine.DeleteComments(
            SMBSeminarCommentLine."Document Type"::"Seminar Registration",
            SMBSeminarRegHeader."No.");

        if SMBSeminarRegHeader.HasLinks() then
            SMBSeminarRegHeader.DeleteLinks();

        SMBSeminarRegHeader.Delete();
    end;
end;

local procedure EverythingPosted(): Boolean
begin
    TempSMBSeminarRegLineGlobal.Reset();
    TempSMBSeminarRegLineGlobal.SetRange(Registered, false);
    exit(TempSMBSeminarRegLineGlobal.IsEmpty());
end;
```

Der ungebuchte Beleg **verschwindet** nach dem vollständigen Buchen – wie die Verkaufsrechnung,
die nach dem Buchen nur noch als gebuchte Rechnung existiert. Sind nur Teile gebucht
(Teilbuchung), bleibt der Rest stehen.

### Commit-Punkte

Nur zwei:

1. Nach dem Ziehen der Buchungsnummer.
2. Ganz am Ende von `RunWithCheck`.

**Kein `Commit` innerhalb der Zeilenschleife** – sonst ist die Transaktion nicht mehr atomar.

## 22 Gebuchte Belege

### Tabellen erstellen – die Checkliste

Die gebuchten Tabellen entstehen als **Kopie** der ungebuchten. Danach:

- [ ] Pages nicht editierbar machen
- [ ] Validierungs- und Lookup-Code entfernen
- [ ] Code aus Tabellentriggern entfernen
- [ ] `LookupPageID`, `DrillDownPageID`, `Caption` anpassen
- [ ] Table Relation der gebuchten Zeile auf den gebuchten Kopf umstellen
- [ ] Löschweitergabe an die Bemerkungszeilen
- [ ] Felder `User ID`, `Source Code`, `No. Printed` einbauen
- [ ] Herkunftsfelder `Registration No.`, `Registration No. Series`
- [ ] Beim Löschen `No. Printed` prüfen
- [ ] FlowFields, die archiviert werden sollen, in normale Felder umwandeln
- [ ] Actions anlegen: Comments, Navigate, Statistics, Dimensions, Print

**Feldnummern bleiben identisch** – sonst funktioniert `TransferFields` nicht.

### Der `OnDelete`-Schutz

```al
trigger OnDelete()
begin
    TestField("No. Printed");        // ← 0 erzwingen: ausgedruckte Belege bleiben
    LockTable();

    SeminarCommentLine.SetRange("Document Type",
        SeminarCommentLine."Document Type"::"Posted Seminar Registration");
    SeminarCommentLine.SetRange("No.", "No.");
    SeminarCommentLine.DeleteAll();
end;
```

`TestField("No. Printed")` ohne zweiten Parameter prüft auf den Standardwert (`0`). Wurde der
Beleg gedruckt, kann er nicht mehr gelöscht werden.

### Navigate-Prozedur in der Tabelle

```al
procedure Navigate()
var
    NavigateForm: Page Navigate;
begin
    NavigateForm.SetDoc("Posting Date", "No.");
    NavigateForm.Run();
end;
```

### Der Copy-Comments-Schalter

Der Anwender soll entscheiden können, ob Bemerkungen mitwandern:

```al
// In der Setup-Tabelle
field(5; "Copy Comments Reg. to Pst."; Boolean)
{
    Caption = 'Copy Comments Reg. to Pst.';
    DataClassification = CustomerContent;
    InitValue = true;                        // ← standardmäßig an
}
```

`InitValue = true` sorgt dafür, dass der Schalter beim Anlegen des Setup-Satzes gesetzt ist.

## 23 Fremdmodul mitbuchen (Ressourcenposten)

Trainer und Raum sind im Standard **Ressourcen**. Die Seminarbuchung erzeugt deshalb zusätzlich
echte Ressourcenposten – über die Standard-Codeunit, nicht per direktem Insert.

```al
local procedure PostResJnlLine(ChargeType: Enum "SMB Sem. Ledger Charge Type";
                               var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"): Integer
var
    Resource: Record Resource;
    ResLedgerEntry: Record "Res. Ledger Entry";
    SMBInstructor: Record "SMB Instructor";
    SMBSeminarRoom: Record "SMB Seminar Room";
    ResJnlLine: Record "Res. Journal Line";
    ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
begin
    ResJnlLine.Init();

    // Gemeinsame Felder
    ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
    ResJnlLine."Document No." := SMBSeminarRegHeader."Posting No.";
    ResJnlLine."Posting Date" := SMBSeminarRegHeader."Posting Date";
    ResJnlLine.Description := SMBSeminarRegHeader."Seminar Description";
    ResJnlLine."Source Code" := SrcCode;
    ResJnlLine."Reason Code" := SMBSeminarRegHeader."Reason Code";
    ResJnlLine."Gen. Prod. Posting Group" := SMBSeminarRegHeader."Gen. Prod. Posting Group";
    ResJnlLine."Document Date" := SMBSeminarRegHeader."Document Date";
    ResJnlLine."Posting No. Series" := SMBSeminarRegHeader."Posting No. Series";

    case ChargeType of
        ChargeType::Instructor:
            begin
                SMBInstructor.Get(SMBSeminarRegHeader."Instructor Code");
                SMBInstructor.TestField("Resource No.");
                Resource.Get(SMBInstructor."Resource No.");
                ResJnlLine."Resource No." := Resource."No.";
                ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
                ResJnlLine.Quantity := SMBSeminarRegHeader."Duration Days";
                ResJnlLine."Qty. per Unit of Measure" := 1;
                ResJnlLine."Unit Cost" := Resource."Unit Cost";
                ResJnlLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
            end;
        ChargeType::Room:
            begin … end;                     // analog, mit SMBSeminarRoom
    end;

    ResJnlPostLine.RunWithCheck(ResJnlLine);

    // Nummer des erzeugten Postens zurückgeben, um ihn mit dem Seminarposten zu verknüpfen
    ResLedgerEntry.FindLast();
    exit(ResLedgerEntry."Entry No.");
end;
```

Die zurückgegebene Nummer landet im Seminarposten:

```al
SMBSeminarJournalLine."Res. Ledger Entry No." := LastResLedgEntryNo;
```

**Merksatz:** Wenn du Posten eines fremden Moduls erzeugen willst, füllst du dessen
Buch.-Blattzeile und rufst dessen Post-Line-Codeunit. Niemals direkt in die fremde
Postentabelle schreiben.

**Kritische Anmerkung:** `ResLedgerEntry.FindLast()` ohne Filter ist die Variante der
Musterlösung, aber nicht robust – bei parallelen Buchungen kann ein fremder Posten gefunden
werden. Sauberer wäre, die Nummer vor und nach dem Aufruf zu vergleichen oder auf
`Document No.` zu filtern.

### Source Code Setup erweitern

Jedes erzeugte Buchungsfragment braucht eine Herkunft:

```al
tableextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    fields
    {
#pragma warning disable PTE0002
        field(123456700; "SMB Seminar"; Code[10])
#pragma warning restore PTE0002
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
            Caption = 'Seminar';
        }
    }
}

pageextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        addlast(Content)
        {
            group("SMB Seminar Group")
            {
                Caption = 'Seminar';
                field("SMB Seminar"; Rec."SMB Seminar") { ApplicationArea = All; }
            }
        }
    }
}
```

Gelesen wird der Code **einmal** in `CheckAndUpdate` und in der globalen Variable `SrcCode`
gehalten.

### Selbst umsetzen – Belegbuchung von null

1. `Post (Yes/No)` anlegen: `TableNo`, `OnRun`, `Code`-Prozedur mit `Confirm`.
2. `Post` anlegen: `TableNo`, `Permissions`, leeres `RunWithCheck`.
3. `ClearAllVariables`, `GetSetup`, `FillTempLines`.
4. `CheckAndUpdate` mit Prüfkaskade, Nummernvergabe, `LockTables`, Source Code.
5. Gebuchten Kopf per `TransferFields` + Korrekturen.
6. Zeilenschleife mit `TestAndUpdate…`, `InsertPst…Line`, `Post…JnlLine`.
7. `FinalizeDocument` mit `EverythingPosted`.
8. Zwei `Commit`-Punkte, sonst keine.
9. Mit dem Debugger schrittweise prüfen: Entstehen Posten, Register, gebuchter Beleg,
   Bemerkungen?

---

# Teil V – Auswertung und Integration

## 24 Navigate

„Verbindungsinfo suchen" (früher *Navigate*) zeigt zu einer Belegnummer und einem
Buchungsdatum **alle** Fragmente im System. Eigene Belege und Posten müssen sich dort selbst
eintragen – über zwei Event-Subscriber.

```al
codeunit 123456704 "SMB Seminar Navigate"
{
    var
        SMBPostedSeminarRegHeader: Record "SMB Posted Seminar Reg. Header";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";

    // 1. Eintragen in die Übersicht
    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterFindRecords, '', false, false)]
    local procedure InsertRecordsNavigateOnAfterFindRecords(var Sender: Page Navigate;
        var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindPstSeminarRegHeader(DocumentEntry, DocNoFilter, PostingDateFilter);
        FindSeminarEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    // 2. Öffnen beim Klick auf die Zeile
    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure Navigate_OnAfterShowRecords(var Sender: Page Navigate;
        var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text;
        ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type";
        ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
        case DocumentEntry."Table ID" of
            Database::"SMB Posted Seminar Reg. Header":
                begin
                    SetPstSeminarRegHeaderFilter(DocNoFilter, PostingDateFilter);
                    Page.Run(Page::"SMB Pst. Sem. Registration", SMBPostedSeminarRegHeader);
                end;
            Database::"SMB Seminar Ledger Entry":
                begin
                    SetSeminarLedgEntryFilter(DocNoFilter, PostingDateFilter);
                    Page.Run(0, SMBSeminarLedgerEntry);       // 0 = LookupPageId der Tabelle
                end;
        end;
    end;

    local procedure FindSeminarEntries(var DocumentEntry: Record "Document Entry";
                                       DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;

        if SMBSeminarLedgerEntry.ReadPermission() then begin        // ← Pflicht!
            SetSeminarLedgEntryFilter(DocNoFilter, PostingDateFilter);
            DocumentEntry.InsertIntoDocEntry(
                Database::"SMB Seminar Ledger Entry",
                SMBSeminarLedgerEntry.TableCaption(),
                SMBSeminarLedgerEntry.Count());
        end;
    end;

    local procedure SetSeminarLedgEntryFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        SMBSeminarLedgerEntry.Reset();
        SMBSeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");   // ← passender Key
        SMBSeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
        SMBSeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
    end;
}
```

**Drei Punkte, die leicht vergessen werden:**

1. **`ReadPermission()` prüfen** – sonst bekommt ein Anwender ohne Rechte einen Fehler statt
   einer leeren Zeile.
2. **Sekundärschlüssel `("Document No.", "Posting Date")`** in der Postentabelle. Ohne ihn
   wird Navigate mit wachsender Postenmenge unbrauchbar langsam.
3. **`Page.Run(0, Rec)`** öffnet die in `LookupPageID` der Tabelle hinterlegte Page – man muss
   die ID nicht kennen.

### Navigate einbinden

Als Action in vier Pages:

| Page | |
|---|---|
| Gebuchter Beleg (Karte) | über die Tabellenprozedur `Navigate()` |
| Gebuchte Belege (Übersicht) | dito |
| Posten | eigene Action mit `SetDoc` |
| Register / Journal | dito |

```al
action("&Navigate")
{
    ApplicationArea = All;
    Caption = '&Navigate';
    Image = Navigate;
    ShortCutKey = 'Ctrl+Alt+Q';
    ToolTip = 'Find entries and documents that exist for the document number and posting date.';

    trigger OnAction()
    var
        Navigate: Page Navigate;
    begin
        Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
        Navigate.Run();
    end;
}
```

## 25 Fakturierung

Aus den Seminarposten sollen Verkaufsrechnungen entstehen. Das ist ein **ProcessingOnly-Report**.

### Report-Trigger – die Reihenfolge

```
OnInitReport
    │
    ├── Request Page Triggers
    │
    OnPreReport
        │
        ├── für jedes DataItem: OnPreDataItem
        │       │
        │       └── für jeden Datensatz: OnAfterGetRecord
        │               └── verschachtelt: innere DataItems
        │
        └── OnPostDataItem
    │
    OnPostReport
```

### Aufbau eines Batch-Reports

1. `ProcessingOnly = true`
2. DataItems anlegen
3. `RequestFilterFields` definieren
4. `DataItemTableView` (Sortierung und Filter) definieren
5. DataItem-Trigger verwenden

### Die schlanke Variante (Endstand)

```al
report 123456798 "SMB Create Seminar Invoices"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("SMB Seminar Ledger Entry"; "SMB Seminar Ledger Entry")
        {
            DataItemTableView = sorting("Bill-to Customer No.")
                                where("Charge Type" = const("SMB Sem. Ledger Charge Type"::Participant),
                                      "Closed by Document No." = const(''));
            RequestFilterFields = "Seminar No.";

            trigger OnAfterGetRecord()
            begin
                // Gruppenwechsel Debitor → neuen Rechnungskopf
                if "Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then
                    CreateSalesHeader();

                CreateSalesLine();
            end;
        }
    }

    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GeneralPostingSetup: Record "General Posting Setup";
        NextLineNo: Integer;

    local procedure CreateSalesHeader()
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';                 // ← Nummernserie des Standards greift
        SalesHeader.Insert(true);                // ← true: OnInsert-Trigger ausführen

        SalesHeader.Validate("Sell-to Customer No.", "SMB Seminar Ledger Entry"."Bill-to Customer No.");
        SalesHeader.Modify(true);
        NextLineNo := 10000;
    end;

    local procedure CreateSalesLine()
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NextLineNo;
        SalesLine.Insert(true);

        // Fakturierung über das Sachkonto aus der Buchungsmatrix
        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        GeneralPostingSetup.Get(
            "SMB Seminar Ledger Entry"."Gen. Bus. Posting Group",
            "SMB Seminar Ledger Entry"."Gen. Prod. Posting Group");
        SalesLine.Validate("No.", GeneralPostingSetup."Sales Account");

        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", "SMB Seminar Ledger Entry"."Unit Price");
        SalesLine.Description := "SMB Seminar Ledger Entry"."Seminar No." + ' ' +
                                 "SMB Seminar Ledger Entry"."Participant Name";

        // Die Brücke zurück zum Posten
        SalesLine."SMB Apply-to Seminar Entry" := "SMB Seminar Ledger Entry"."Entry No.";

        SalesLine.Modify(true);
        NextLineNo += 10000;
    end;
}
```

### Der vollständige Ablaufplan (aus dem Kursskript)

```
Request Page
     │
OnPreDataItem()   ── Posten sortiert nach Debitornr. selektieren
     │
     ▼
OnAfterGetRecord()
     │
     ├─ Gruppenwechsel Debitornr.? ──ja──▶ ggf. vorherige Rechnung abschließen/buchen
     │                                      FinalizeSalesInvoiceHeader()
     │                                     ▼
     │                                    Debitor gesperrt? ──ja──▶ Fehlerzähler++
     │                                     ▼
     │                                    neuen Rechnungskopf erstellen
     │                                     InsertSalesInvoiceHeader()
     │                                     ▼
     └─────────────────────────────────▶ Rechnungszeile anfügen
                                          ggf. Betrag in Fremdwährung umrechnen
     │
     ▼ (kein weiterer Posten)
OnPostDataItem()  ── letzte Rechnung abschließen/buchen
                     Meldung Erfolg/Fehler
```

Die ausführliche Variante mit Request Page, Buchungsdatum, Rechnungsrabatt, optionalem Buchen
und Fehlerzählern liegt auskommentiert in
`SolDev/CreateSeminarInvoice.txt.txt` bzw. am Ende von
`SolDev/Final/src/report/SMBCreateSeminarInvoices.Report.al`.

Wesentliche Elemente dieser Variante:

```al
requestpage
{
    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(PostingDateReq; PostingDateReq) { … }
                field(DocDateReq; DocDateReq) { … }
                field(CalcInvoiceDiscount; CalcInvoiceDiscount) { … }
                field(PostInvoices; PostInvoices) { … }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if PostingDateReq = 0D then PostingDateReq := WorkDate();
        if DocDateReq = 0D then DocDateReq := WorkDate();
        SalesSetup.Get();
        CalcInvoiceDiscount := SalesSetup."Calc. Inv. Discount";     // Vorbelegung aus Setup
    end;
}

local procedure FinalizeSalesInvoiceHeader()
begin
    if CalcInvoiceDiscount then
        SalesCalcDiscount.Run(SalesLine);
    SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
    Commit();
    Clear(SalesCalcDiscount);
    Clear(SalesPost);
    NoOfSalesInv += 1;
    if PostInvoices then begin
        Clear(SalesPost);
        if not SalesPost.Run(SalesHeader) then          // ← Run statt direktem Aufruf
            NoOfSalesInvErrors += 1;                    //   fängt Fehler ab
    end;
end;
```

`if not Codeunit.Run(…)` fängt einen Fehler ab, statt den ganzen Lauf abzubrechen – das Muster
für Stapelverarbeitungen, die einzelne Fehlschläge tolerieren sollen.

### Die drei offenen Probleme (Kursfrage)

Der Kurs stellt sie bewusst als Diskussionspunkte:

1. **Was, wenn der Anwender die Verkaufszeile vor dem Buchen ändert?**
   → Antwort in Kapitel 26: Prüfung beim Buchen per Event.
2. **Wie verarbeitet man nur die noch nicht fakturierten Posten?**
   → Feld `Closed by Document No.` + Filter `= const('')`.
3. **Was, wenn der Lauf alle offenen Posten selektiert und dann schrittweise markiert?**
   → Konflikt zwischen Selektion und Änderung derselben Menge; deshalb wird der Posten erst
   beim **Buchen der Rechnung** geschlossen, nicht beim Erstellen.

## 26 Posten schließen über Events

Die Verknüpfung zwischen Verkaufsbeleg und eigenem Posten – in fünf Bausteinen.

### Baustein 1 und 2 – Table Extensions

```al
tableextension 123456701 "SMB Sales Line" extends "Sales Line"
{
    fields
    {
        field(123456700; "SMB Apply-to Seminar Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Apply-to seminar Entry';
        }
    }
}

tableextension 123456702 "SMB Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(123456700; "SMB Apply-to Seminar Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Apply-to seminar Entry';
        }
    }
}
```

**Beide** brauchen dasselbe Feld: `Sales-Post` überträgt beim Buchen gleichnamige Felder von
der `Sales Line` in die `Sales Invoice Line`.

### Baustein 3 – Feld in der Postentabelle

```al
field(100; "Closed by Document No."; Code[20])
{
    Caption = 'Closed by Document No.';
    TableRelation = "Sales Invoice Header";
}
```

### Baustein 4 – Prüfung beim Buchen

```al
codeunit 123456710 "SMB Seminar Invoicing"
{
    Permissions = tabledata "SMB Seminar Ledger Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterTestSalesLine, '', false, false)]
    local procedure CheckSeminarInvoicingSalesPostOnAfterTestSalesLine(
        SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line";
        WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    var
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
    begin
        if (SalesLine."SMB Apply-to Seminar Entry" <> 0) and
           (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice)
        then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry.TestField("Closed by Document No.", '', ErrorInfo.Create());
        end;
    end;
```

Verhindert, dass derselbe Posten zweimal fakturiert wird.

### Baustein 5 – Posten schließen

```al
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvLineInsert, '', false, false)]
    local procedure CloseSeminarLedgerSalesPostOnAfterSalesInvLineInsert(
        var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header";
        SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean;
        WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header";
        var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary;
        var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; PreviewMode: Boolean)
    var
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
    begin
        if SalesLine."SMB Apply-to Seminar Entry" <> 0 then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry."Closed by Document No." := SalesInvLine."Document No.";
            SMBSeminarLedgerEntry.Modify();
        end;
    end;
}
```

Der Posten wird erst geschlossen, wenn die **gebuchte** Rechnungszeile existiert – also nach
erfolgreichem Buchen, nicht vorher.

### Regeln für Event-Subscriber

| Regel | Begründung |
|---|---|
| **immer `local procedure`** | Subscriber sollen nicht direkt aufrufbar sein |
| **Signatur exakt übernehmen** | Sonst Kompilierfehler – niemals raten, im Symbol nachsehen |
| **sprechender Name** `<WasPassiert>On<EventName>` | Fehlersuche |
| **eine Codeunit pro Integrationsthema** | Übersicht |
| **kein UI** in Subscribern, die beim Buchen feuern | bricht Hintergrundverarbeitung |
| letzte zwei Parameter meist `false, false` | `true, true` überspringt bei fehlender Lizenz/Berechtigung |

## 27 Dimensionen

### Historie – warum es heute anders ist

| Zeitraum | Mechanismus |
|---|---|
| vor NAV 3 (Attain) | keine Dimensionen |
| bis NAV 2009 R2 | **eine Dimensionstabelle je Standardtabellentyp** (355, 356, 357, 359 …) |
| ab NAV 2013 | **Dimension Sets** – eine ID transportiert die ganze Kombination |

Das alte Modell erzeugte massive Redundanz: Bei jedem Buchungsvorgang wurden Dimensionszeilen
von Tabelle zu Tabelle kopiert – dieselben Kombinationen immer wieder.

**Entfernte Tabellen:** 355 Ledger Entry Dimension, 356 Journal Line Dimension,
357 Document Dimension, 359 Posted Document Dimension, 361 G/L Budget Dimension u. a.

**Neue Tabellen:** 480 `Dimension Set Entry`, 481 `Dimension Set Tree Node`,
482 `Reclas. Dimension Set Buffer`.

### Das heutige Prinzip

Gleiche Dimensionskombinationen werden zu einem **Dimension Set** zusammengefasst, das eine
`Dimension Set ID` (Integer, AutoIncrement) bekommt. Kopiert wird nur noch die ID.

```
Vorher (bis NAV 2009 R2)                    Nachher (ab NAV 2013)
────────────────────────                    ─────────────────────
TempJnlLineDim.DELETEALL;                   ResJnlLine."Dimension Set ID" :=
TempDocDim.RESET;                               SalesLine."Dimension Set ID";
TempDocDim.SETRANGE("Table ID", …);
TempDocDim.SETRANGE("Line No.", …);         ResJnlPostLine.Run(ResJnlLine);
DimMgt.CopyDocDimToJnlLineDim(
    TempDocDim, TempJnlLineDim);
ResJnlPostLine.RunWithCheck(
    ResJnlLine, TempJnlLineDim);
```

### Wo die Felder hingehören

| Tabellenart | Felder |
|---|---|
| Stammdaten | `Global Dimension 1/2 Code` (30/31), `CaptionClass = '1,1,1'` bzw. `'1,1,2'` |
| Belegkopf und -zeile | `Dimension Set ID` (480), `Shortcut Dimension 1/2 Code` (490/491), `CaptionClass = '1,2,1'` / `'1,2,2'` |
| Buch.-Blattzeile | `Dimension Set ID` (480), Shortcut 1/2 |
| Posten | zusätzlich `Shortcut Dimension 3–8 Code` (481–486) als **FlowFields** |

```al
field(481; "Shortcut Dimension 3 Code"; Code[20])
{
    CaptionClass = '1,2,3';
    Caption = 'Shortcut Dimension 3 Code';
    Editable = false;
    FieldClass = FlowField;
    CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code"
                         where("Dimension Set ID" = field("Dimension Set ID"),
                               "Global Dimension No." = const(3)));
}
```

### Weitergabe beim Buchen

Vom Stammsatz in den Beleg wandern die **Shortcut-Codes**:

```al
"Shortcut Dimension 1 Code" := SMBSeminar."Global Dimension 1 Code";
"Shortcut Dimension 2 Code" := SMBSeminar."Global Dimension 2 Code";
```

Ab dem Beleg wandert nur noch die **ID**:

```al
SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";  // Kopfposten
SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegLine."Dimension Set ID";    // Zeilenposten
SMBSeminarLedgerEntry."Dimension Set ID" := SemJnlLine."Dimension Set ID";
SalesLine.Validate("Dimension Set ID", SMBSeminarLedgerEntry."Dimension Set ID");
```

Für das Zusammenführen mehrerer Dimensionsquellen (Standarddimension des Stammsatzes +
Belegdimension) ist **Codeunit 408 `DimensionManagement`** zuständig.

### Caption Classes

Dimensionsfelder haben keine feste Beschriftung – sie zeigen den Namen, den der Anwender der
Dimension gegeben hat. Das leistet die `CaptionClass`.

**Aufbau:** `'<Caption Area>,<Dim Caption Type>,<Dim Caption Ref>'`

| Caption Area | Bedeutung |
|---|---|
| `1` | Dimensionen |
| `2` | MwSt. |
| `3` | individuelle Berechnung der CaptionExpr |
| `5` | länderabhängige Beschriftung (z. B. `County`) |

| Dim Caption Type | Bedeutung |
|---|---|
| `1` / `2` | Code-Caption für globale Dimension / Shortcut-Dimension |
| `3` / `4` | Filter-Caption für globale / Shortcut-Dimension |
| `5` / `6` | Code-Caption für andere Dimension / Shortcut-Dimension |

**Dim Caption Ref:** die Nummer der Dimension (1, 2, …).

Beispiel aus dem Seminarraum:

```al
field(15; County; Text[30])
{
    CaptionClass = '5,1,' + "Country/Region Code";     // Beschriftung je Land
}
```

### Aufgaben rund um Dimensionen

- Dimensionen in der Stammdatentabelle
- Dimensionen in der Belegkopftabelle
- Dimensionen in der Zeilentabelle
- Übergabe bei der Buchung
- Prüfungen bei der Buchung (`DimMgt.CheckDimIDComb`, `DimMgt.CheckDimValuePosting`)
- Übergabe beim Erstellen der Rechnung

> **Hinweis zur Musterlösung:** Die Dimensionsprüfungen in `SMBSemJnlCheckLine` und die
> `ValidateShortcutDimCode`-Aufrufe in den Stammdaten sind dort **auskommentiert**. Für eine
> produktive Lösung müssten sie ausprogrammiert werden.

## 28 Statistik

Im Kursskript beschrieben, in der Musterlösung **nicht ausprogrammiert**. Das Muster:

**1. FlowFields in der Master-Tabelle auf Basis der Posten:**

```al
field(60; "Net Change"; Decimal)
{
    Caption = 'Net Change';
    Editable = false;
    FieldClass = FlowField;
    AutoFormatType = 1;
    CalcFormula = sum("SMB Seminar Ledger Entry"."Total Price"
                      where("Seminar No." = field("No."),
                            "Posting Date" = field("Date Filter"),
                            "Charge Type" = field("Charge Type Filter")));
}
```

Typische Kennzahlen: `Net Change`, `Total Refunds`, `Common Costs`, `Invoiced`,
`Not Yet Invoiced`.

**2. FlowFilter-Felder ergänzen**, insbesondere ein `Date Filter`:

```al
field(70; "Date Filter"; Date)
{
    Caption = 'Date Filter';
    FieldClass = FlowFilter;
}
```

**3. Statistik-Page** (`PageType = Card`, `SourceTable` = Master), die im `OnAfterGetRecord`
die Filter setzt und `CalcFields` ruft.

**4. Einbinden** in Card und List:

```al
action(Statistics)
{
    ApplicationArea = All;
    Caption = 'Statistics';
    Image = Statistics;
    RunObject = Page "SMB Seminar Statistics";
    RunPageLink = "No." = field("No.");
    ShortCutKey = 'F7';
    ToolTip = 'View statistical information about the record.';
}
```

**Voraussetzung:** Die Postentabelle braucht Schlüssel mit `SumIndexFields` für die summierten
Felder – sonst ist die Statistik langsam.

---

# Teil VI – Rollencenter und Personalisierung

## 29 Cues und Aktivitäten-Part

Cues sind die Zahlenkacheln im Rollencenter. Sie bestehen aus drei Teilen: einer Tabelle mit
FlowFields, einer `CardPart`-Page und der Logik, die die Filter setzt.

### Die Cue-Tabelle

```al
table 123456751 "SMB Seminar Cue"
{
    Caption = 'Seminar Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;         // nicht personalisierbar
            Caption = 'Primary Key';
        }

        // Ein Zählfeld je Status
        field(2; "Seminar Reg. - Planning"; Integer)
        {
            Caption = 'Seminar Reg. - Planning';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("SMB Seminar Reg. Header"
                                where(Status = const(Planning),
                                      "Responsibility Center" = field("Responsibility Center Filter")));
            ToolTip = 'Specifies the number of seminar registrations in planning.';
        }
        field(3; "Seminar Reg. - Registration"; Integer) { … }
        field(4; "Seminar Reg. - Closed"; Integer) { … }
        field(5; "Seminar Reg. - Canceled"; Integer) { … }

        // Zeitbezogene Kacheln
        field(6; "Seminar Reg. - Today"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header"
                                where(Status = const(Closed),
                                      "Starting Date" = field("Date Filter"),
                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Seminar Reg. - This Week"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header"
                                where(Status = const(Closed),
                                      "Starting Date" = field("Date Filter2"),
                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Editable = false;
            FieldClass = FlowField;
        }

        // Filterfelder
        field(20; "Date Filter"; Date)   { Editable = false; FieldClass = FlowFilter; }
        field(21; "Date Filter2"; Date)  { Editable = false; FieldClass = FlowFilter; }
        field(22; "Responsibility Center Filter"; Code[10]) { Editable = false; FieldClass = FlowFilter; }
        field(23; "User ID Filter"; Code[50]) { FieldClass = FlowFilter; }
    }

    keys
    {
        key(Key1; "Primary Key") { Clustered = true; }
    }

    procedure SetRespCenterFilter()
    var
        UserSetupMgt: Codeunit "User Setup Management";
        RespCenterCode: Code[10];
    begin
        RespCenterCode := UserSetupMgt.GetSalesFilter();
        if RespCenterCode <> '' then begin
            FilterGroup(2);                            // ← vom Anwender nicht entfernbar
            SetRange("Responsibility Center Filter", RespCenterCode);
            FilterGroup(0);
        end;
    end;
}
```

**Warum zwei Datumsfilter?** Ein FlowFilter kann nur einen Bereich tragen. „Heute" und „diese
Woche" brauchen daher zwei getrennte Felder.

### Der Aktivitäten-Part

```al
page 123456751 "SMB Seminar Mgt. Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SMB Seminar Cue";
    Caption = 'Activities';
    RefreshOnActivate = true;              // aktualisiert beim Zurückwechseln

    layout
    {
        area(Content)
        {
            cuegroup(Registrations)
            {
                Caption = 'Registrations';
                field("Seminar Reg. - Planning"; Rec."Seminar Reg. - Planning")
                {
                    DrillDownPageId = "SMB Seminar Registration List";
                    ToolTip = 'Specifies the number of seminar registrations in planning.';
                }
                field("Seminar Reg. - Registration"; Rec."Seminar Reg. - Registration") { … }
                field("Seminar Reg. - Closed"; Rec."Seminar Reg. - Closed") { … }
                field("Seminar Reg. - Canceled"; Rec."Seminar Reg. - Canceled") { … }
            }
            cuegroup(CurrentRegistration)
            {
                Caption = 'Current Registration';
                field("Seminar Reg. - Today"; Rec."Seminar Reg. - Today") { … }
                field("Seminar Reg. - This Week"; Rec."Seminar Reg. - This Week") { … }
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
    var
        StartDateFromWeek: Date;
        EndDateFromWeek: Date;
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        StartDateFromWeek := CalcDate('<-CW>', WorkDate());       // Wochenanfang
        EndDateFromWeek := CalcDate('<-CW+6D>', WorkDate());      // Wochenende

        Rec.SetRespCenterFilter();
        Rec.SetRange("Date Filter", WorkDate());
        Rec.SetRange("Date Filter2", StartDateFromWeek, EndDateFromWeek);
        Rec.SetRange("User ID Filter", UserId());
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
}
```

Die Action **„Set Up Cues"** erfüllt die Anforderung, dass der Anwender eigene Schwellwerte
(Ampelfarben) definieren kann. `Codeunit "Cues And KPIs"` ist der Standardweg dafür.

**Datumsformeln:** `<-CW>` = Anfang der aktuellen Woche, `<-CW+6D>` = sechs Tage später, also
Wochenende.

## 30 Rollencenter

```al
page 123456750 "SMB Seminar Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(RoleCenter)
        {
            part(SeminarActivities; "SMB Seminar Mgt. Activities")
            {
                AccessByPermission = TableData "SMB Seminar Reg. Header" = R;
            }
            part("Emails"; "Email Activities")   { ApplicationArea = Basic, Suite; }
            part(MySeminars; "SMB My Seminars")  { ApplicationArea = Basic, Suite; }
            part(Control1907692008; "My Customers") { ApplicationArea = Basic, Suite; }
            part(Control21; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(Sections)      // linke Navigationsspalte, gruppiert
        {
            group(Seminar)
            {
                Caption = 'Seminar';
                action(SeminarRegistrationsSections)
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Registrations';
                    RunObject = page "SMB Seminar Registration List";
                    ToolTip = 'Executes the Seminar Registrations action.';
                }
                action(SeminarsSections) { … }
                action(InstructorsSections) { … }
                action(SeminarRoomsSections) { … }
            }
            group(Sales)             { Caption = 'Sales'; Image = Sales; … }
            group("Posted Documents"){ Caption = 'Posted Documents'; Image = FiledPosted; … }
        }

        area(Processing)    // Aktionsleiste
        {
            action(CreateSeminarInvoices)
            {
                Caption = 'Create Seminar Invoices';
                RunObject = report "SMB Create Seminar Invoices";
                ApplicationArea = All;
                ToolTip = 'Create sales invoices from the seminar ledger entries.';
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number …';
                }
            }
        }

        area(Creation)      // "+ Neu"
        {
            action(NewSeminarRegistration)
            {
                ApplicationArea = All;
                RunObject = page "SMB Seminar Registration";
                RunPageMode = Create;
                Caption = 'New Seminar Registration';
                ToolTip = 'Create a new seminar registration.';
            }
            action("Sales &Invoice") { … }
        }

        area(Embedding)     // oberste Menüleiste
        {
            action(SeminarRegistrations) { … }
            action(Seminars) { … }
            action(Instructors) { … }
            action(SeminarRooms) { … }
            action(Customer) { … }
        }
    }
}
```

### Die vier Action-Bereiche

| Bereich | Erscheint | Zweck |
|---|---|---|
| `Sections` | linke Navigationsspalte, aufklappbar | thematisch gruppierte Einstiege |
| `Embedding` | oberste Menüleiste | die wichtigsten Listen, direkt erreichbar |
| `Processing` | Aktionsleiste | Aktionen ausführen (Berechnen, Navigate) |
| `Creation` | „+ Neu" | neue Belege anlegen |

Ein Menüpunkt, der überall erreichbar sein soll, wird in **mehreren** Bereichen angelegt – das
ist normal und kein Fehler.

### Ein bestehendes Rollencenter erweitern

Statt eines eigenen Rollencenters kann man eine Gruppe in ein Standard-Rollencenter einhängen:

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
                …
            }
        }
    }
}
```

Anker: `addfirst`, `addlast`, `addbefore`, `addafter`, `movefirst`, `movelast`, `movebefore`,
`moveafter`, `modify`.

## 31 Profile und PageCustomization

### Profile

Ein Profil verbindet eine Rolle mit einem Rollencenter:

```al
profile "SMB Seminar Manager"
{
    Description = 'Seminar Manager';
    Caption = 'Seminar Manager';
    RoleCenter = "SMB Seminar Role Center";
}

profile "SMB Seminar Worker"
{
    Description = 'Seminar Worker';
    Caption = 'Seminar Worker';
    RoleCenter = "SMB Seminar Role Center";
    Customizations = "SMB Seminar Registration List";     // ← rollenspezifische Anpassung
}
```

Beide nutzen dasselbe Rollencenter, aber der *Worker* bekommt eine angepasste Ansicht.

### PageCustomization

Passt eine Page **nur für ein Profil** an, ohne sie global zu ändern:

```al
pagecustomization "SMB Seminar Registration List" customizes "SMB Seminar Registration List"
{
    layout
    {
        modify("Instructor Code")
        {
            Visible = false;              // für diese Rolle uninteressant
        }
    }

    views
    {
        addlast
        {
            view(Myseminars)
            {
                Caption = 'My Seminars';
                Filters = where("Seminar No." = const('%MYSEMINAR'));   // ← Filter Token!
                SharedLayout = false;                                    // eigenes Layout
                layout
                {
                    modify("Seminar Description") { Visible = false; }
                }
            }
        }
    }
}
```

`SharedLayout = false` erlaubt der Ansicht ein eigenes Spaltenlayout, unabhängig von der
Grundansicht.

Der Filter `'%MYSEMINAR'` verweist auf den Filter Token aus Kapitel 32.

## 32 Filter Token

Filter Tokens sind Platzhalter, die der Anwender in **jedem** Filterfeld eingeben kann und die
zur Laufzeit in eine konkrete Filterzeichenkette aufgelöst werden. Der Standard kennt z. B.
`%ME` und `%MYCUSTOMERS`.

### Die „My …"-Tabelle

```al
table 123456730 "SMB My Seminar"
{
    Caption = 'My Seminar';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;     // ← DSGVO-relevant
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            NotBlank = true;
            TableRelation = "SMB Seminar";
            ToolTip = 'Specifies the seminar numbers displayed in the My Seminar Cue.';

            trigger OnValidate()
            begin
                SetSeminarFields();
            end;
        }
        field(3; Description; Text[100])    { Editable = false; }
        field(4; "Duration Days"; Integer)  { Editable = false; }
        field(5; "Seminar Price"; Decimal)  { Editable = false; AutoFormatType = 1; }
    }

    keys
    {
        key(Key1; "User ID", "Seminar No.") { Clustered = true; }
        key(Key2; Description) { }
        key(Key3; "Duration Days") { }
    }

    procedure SetSeminarFields()
    var
        SMBSeminar: Record "SMB Seminar";
    begin
        SMBSeminar.SetLoadFields(Description, "Duration Days", "Seminar Price");
        if SMBSeminar.Get("Seminar No.") then begin
            Description := SMBSeminar.Description;
            "Duration Days" := SMBSeminar."Duration Days";
            "Seminar Price" := SMBSeminar."Seminar Price";
        end;
    end;
}
```

Der PK beginnt mit `User ID` – jeder Anwender hat seine eigene Liste.

Die kopierten Felder (`Description` etc.) sind **denormalisiert** für die Anzeige. Damit sie
aktuell bleiben, synchronisiert die Page sie beim Lesen:

```al
local procedure SyncFieldsWithSeminar()
begin
    Clear(SMBSeminar);
    SMBSeminar.ReadIsolation(IsolationLevel::ReadCommitted);
    SMBSeminar.SetLoadFields(Description, "Duration Days", "Seminar Price");
    if SMBSeminar.Get(Rec."Seminar No.") then
        if (Rec.Description <> SMBSeminar.Description) or
           (Rec."Duration Days" <> SMBSeminar."Duration Days") or
           (Rec."Seminar Price" <> SMBSeminar."Seminar Price")
        then begin
            Rec.Description := SMBSeminar.Description;
            Rec."Duration Days" := SMBSeminar."Duration Days";
            Rec."Seminar Price" := SMBSeminar."Seminar Price";
            if not IsNullGuid(Rec.SystemId) then       // nur bestehende Sätze modifizieren
                Rec.Modify();
        end;
end;
```

`if not IsNullGuid(Rec.SystemId)` verhindert ein `Modify` auf einem noch nicht eingefügten
Satz – ein klassischer Laufzeitfehler in `OnAfterGetRecord`.

### Die Token-Codeunit

```al
codeunit 123456730 "SMB MySeminar Filter Token"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens",
                     'OnResolveTextFilterToken', '', true, true)]
    local procedure FilterMyAccounts(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SMBMySeminar: Record "SMB My Seminar";
        MaxCount: Integer;
        MyTokenTxt: Label 'MYSEMINAR', Comment = 'Must be uppercase';
    begin
        if StrLen(TextToken) < 3 then
            exit;                                          // zu kurz, um eindeutig zu sein

        if StrPos(UpperCase(MyTokenTxt), UpperCase(TextToken)) = 0 then
            exit;                                          // nicht unser Token

        Handled := true;

        MaxCount := 20;                                    // Filterlänge begrenzen
        SMBMySeminar.SetRange("User ID", UserId());

        if SMBMySeminar.FindSet() then begin
            MaxCount -= 1;
            TextFilter := SMBMySeminar."Seminar No.";

            if SMBMySeminar.Next() <> 0 then
                repeat
                    MaxCount -= 1;
                    TextFilter += '|' + SMBMySeminar."Seminar No.";
                until (SMBMySeminar.Next() = 0) or (MaxCount <= 0);
        end;
    end;
}
```

**Drei Details:**

1. **`StrPos(UpperCase(MyTokenTxt), UpperCase(TextToken))`** – die Prüfung läuft „andersherum":
   Es wird geprüft, ob die Eingabe ein **Anfangsstück** des Tokens ist. So funktioniert auch
   `%MYSEM`.
2. **`Handled := true`** – signalisiert dem Standard, dass das Token verarbeitet wurde.
3. **`MaxCount`** – der resultierende Filterstring ist längenbegrenzt. Ohne Deckelung bricht
   der Filter bei vielen Einträgen.

Die letzten beiden Parameter des Subscribers sind `true, true`: Bei fehlender Lizenz oder
Berechtigung wird der Subscriber übersprungen statt einen Fehler zu werfen.

### Die „My …"-Page

```al
page 123456730 "SMB My Seminars"
{
    Caption = 'My Seminars';
    PageType = ListPart;
    SourceTable = "SMB My Seminar";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = Basic, Suite;
                    Width = 4;
                    trigger OnValidate()
                    begin
                        SyncFieldsWithSeminar();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;          // kein Absprung aus dem Rollencenter
                    Lookup = false;
                    Width = 20;
                }
                …
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "SMB Seminar Card";
                RunPageLink = "No." = field("Seminar No.");
                RunPageMode = View;
                Scope = Repeater;                   // Action gilt für die markierte Zeile
                ShortCutKey = 'Return';             // Enter öffnet
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;
}
```

`Scope = Repeater` + `ShortCutKey = 'Return'` ergeben das gewohnte Verhalten: Enter auf einer
Zeile öffnet den Datensatz.

---

# Teil VII – Qualität

## 33 Berechtigungen

```al
permissionset 123456700 "SMB SemRegistration"
{
    Assignable = true;

    Permissions =
        // Tabellendaten
        tabledata "SMB Seminar" = RIMD,
        tabledata "SMB Seminar Setup" = RIMD,
        tabledata "SMB Seminar Reg. Header" = RIMD,
        tabledata "SMB Seminar Ledger Entry" = RIMD,
        …
        // Tabellenobjekte
        table "SMB Seminar" = X,
        table "SMB Seminar Setup" = X,
        …
        // Pages
        page "SMB Seminar Card" = X,
        page "SMB Seminar List" = X,
        …
        // Codeunits und Reports
        codeunit "SMB Seminar-Post" = X,
        codeunit "SMB Sem. Jnl.-Post Line" = X,
        report "SMB Create Seminar Invoices" = X;
}
```

### Regeln

| Regel | |
|---|---|
| **Jedes** neue Objekt gehört hinein | Sonst ist es für Anwender nicht erreichbar |
| Pro Tabelle **zwei** Einträge | `tabledata … = RIMD` **und** `table … = X` |
| `RIMD` | Read, Insert, Modify, Delete |
| `X` | Execute (Objekt darf ausgeführt werden) |
| `Assignable = true` | Nur beim zuweisbaren Set; Bausteine sind `false` |

### Abgestufte Rollen

```al
permissionset 63001 "GOB Commission Objects"
{
    Assignable = false;                          // reiner Baustein
    Permissions = table … = X, page … = X, codeunit … = X;
}

permissionset 63002 "GOB Commission Read"
{
    Assignable = true;
    IncludedPermissionSets = "GOB Commission Objects";
    Permissions = tabledata "GOB Commission Contract" = R, …;
}
```

### `Permissions` an Codeunits

Zusätzlich zum PermissionSet brauchen Buchungs-Codeunits die Property auf **Objektebene**:

```al
codeunit 123456732 "SMB Sem. Jnl.-Post Line"
{
    Permissions = TableData "SMB Seminar Ledger Entry" = rimd,
                  TableData "SMB Seminar Register" = rimd;
```

Damit darf die Codeunit Posten schreiben, auch wenn der aufrufende Anwender nur Leserecht hat.
Ohne sie schlägt die Buchung beim Anwender fehl, obwohl sie beim Entwickler läuft.

### `AccessByPermission` an Actions

```al
action(NewSeminarRegistration)
{
    AccessByPermission = TableData "SMB Seminar Reg. Header" = RIM;
    …
}
```

Die Action wird ausgeblendet, wenn der Anwender die Rechte nicht hat.

## 34 Application Tests

### Konzept

> „Funktionaler Test, ob die Anwendung, gegeben eine Menge von Eingangsparametern, eine
> definierte und korrekte Menge von Ausgangszuständen erzeugt."

**Ziele:** automatisierter Ablauf, Wiederholbarkeit (auch bezüglich Daten), Nachweis
funktionaler Korrektheit, Einbeziehen der Rollenanpassungen.
**Nicht:** Last- oder Performance-Test.

### Aufbau

```
Test Runner  (TestIsolation: Disabled | Codeunit | Function)
     │
     └──▶ Test-Codeunit  (Subtype = Test)
              ├── TestFunction1     [Test]
              ├── TestFunction2     [Test]
              ├── UI-HandlerFunction  [ConfirmHandler] …
              └── Other Functions
```

**Properties der Testmethode:**

| Property | Werte |
|---|---|
| `FunctionType` | `Test` |
| `HandlerFunctions` | Liste der UI-Handler |
| `TransactionModel` | `AutoCommit`, `AutoRollback`, `None` |

**Handler-Typen:** `MessageHandler`, `ConfirmHandler`, `StrMenuHandler`, `PageHandler`,
`ModalPageHandler`, `ReportHandler`, `RequestPageHandler`.

### Die Test-App

Eigene App mit eigenem Prefix (`SMT`) und ID-Bereich (80150–80199), abhängig von der
zu testenden App:

```jsonc
{
  "name": "Test Seminar Management",
  "dependencies": [
    { "id": "…", "name": "Seminar Management", "publisher": "…", "version": "1.0.0.0" },
    { "id": "dd0be2ea-…", "publisher": "Microsoft", "name": "Library Assert", "version": "27.4.…" },
    { "id": "23de40a6-…", "publisher": "Microsoft", "name": "Test Runner", "version": "27.4.…" },
    { "id": "bee8cf2f-…", "publisher": "Microsoft", "name": "Business Foundation Test Libraries", … },
    { "id": "c14a958d-…", "publisher": "Microsoft", "name": "Business Foundation Tests", … },
    { "id": "5d86850b-…", "publisher": "Microsoft", "name": "Tests-TestLibraries", … },
    { "id": "9856ae4f-…", "publisher": "Microsoft", "name": "System Application Test Library", … },
    { "id": "e7320ebb-…", "publisher": "Microsoft", "name": "Any", … }
  ],
  "idRanges": [ { "from": 80150, "to": 80199 } ],
  "features": [ "NoImplicitWith" ],
  "suppressWarnings": [ "PTE0001" ]
}
```

Die aktuellen IDs und Versionen stehen in `SolDev/TestDep.txt`. **Die Versionen müssen zur
eingespielten BC-Version passen.**

### Library-Codeunit

Trennt Testdaten-Erzeugung von den Testfällen. Jede Datenart bekommt eine `Create…`-Prozedur
mit `var`-Parameter.

```al
codeunit 80151 "SMT Library - Seminar Mgt."
{
    procedure CreateSeminarSetup(var SMBSeminarSetup: Record "SMB Seminar Setup")
    var
        LibraryNoSeries: Codeunit "Library - No. Series";
        NoseriesCodeSemTxt: Label 'TESTSM';
        NoSeriesLineStaringNoSemTxt: Label 'SM00001';
        …
    begin
        LibraryNoSeries.CreateNoSeries(NoseriesCodeSemTxt);
        LibraryNoSeries.CreateNoSeriesLine(NoseriesCodeSemTxt, 1, NoSeriesLineStaringNoSemTxt, '');
        …
        Clear(SMBSeminarSetup);
        if SMBSeminarSetup.Get() then
            SMBSeminarSetup.Delete();
        if not SMBSeminarSetup.Get() then begin
            SMBSeminarSetup.Init();
            SMBSeminarSetup."Primary Key" := '';
            SMBSeminarSetup.Insert();
        end;

        SMBSeminarSetup."Seminar Nos." := NoseriesCodeSemTxt;
        …
        SMBSeminarSetup.Modify();
    end;

    procedure CreateInstructor(var SMBInstructor: Record "SMB Instructor")
    var
        Resource: Record Resource;
        LibraryResource: Codeunit "Library - Resource";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        Clear(SMBInstructor);
        SMBInstructor.Init();
        SMBInstructor.Validate(Code,
            LibraryUtility.GenerateRandomCode20(SMBInstructor.FieldNo(Code),
                                                Database::"SMB Instructor"));
        SMBInstructor.Insert(true);
        SMBInstructor.Validate(Name, SMBInstructor.Code);

        LibraryResource.CreateResourceNew(Resource);
        Resource.Validate(Type, Resource.Type::Person);
        Resource.Modify();

        SMBInstructor.Validate("Resource No.", Resource."No.");
        SMBInstructor.Modify();
    end;

    procedure CreateSeminar(var SMBSeminar: Record "SMB Seminar")
    var
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        LibraryERM: Codeunit "Library - ERM";
        Any: Codeunit Any;
    begin
        Clear(SMBSeminar);
        SMBSeminar.Init();
        SMBSeminar."No." := '';
        SMBSeminar.Insert(true);                          // ← Nummernserie greift
        SMBSeminar.Validate(Description, SMBSeminar."No.");
        SMBSeminar.Validate("Duration Days", Any.IntegerInRange(5));
        SMBSeminar.Validate("Seminar Price", Any.DecimalInRange(1000, 2));
        SMBSeminar.Validate("Minimum Participants", Any.IntegerInRange(5));
        SMBSeminar.Validate("Maximum Participants",
            SMBSeminar."Minimum Participants" + Any.IntegerInRange(5));

        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);
        LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);
        SMBSeminar.Validate("Gen. Prod. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
        SMBSeminar.Validate("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");
        SMBSeminar.Modify();
    end;

    procedure CreateSeminarRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
                                   SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        Customer: Record Customer;
        Contact: Record Contact;
        LibraryUtility: Codeunit "Library - Utility";
        LibraryMarketing: Codeunit "Library - Marketing";
        RecRef: RecordRef;
    begin
        Clear(SMBSeminarRegLine);
        SMBSeminarRegLine.Init();
        SMBSeminarRegLine."Document No." := SMBSeminarRegHeader."No.";
        RecRef.GetTable(SMBSeminarRegLine);
        SMBSeminarRegLine."Line No." :=
            LibraryUtility.GetNewLineNo(RecRef, SMBSeminarRegLine.FieldNo("Line No."));
        SMBSeminarRegLine.Insert(true);

        LibraryMarketing.CreateContactWithCustomer(Contact, Customer);   // beide auf einmal
        SMBSeminarRegLine.Validate("Bill-to Customer No.", Customer."No.");
        SMBSeminarRegLine.Validate("Participant Contact No.", Contact."No.");
        SMBSeminarRegLine.Modify(true);
    end;
}
```

### Die wichtigsten Standard-Libraries

| Library | Nützliche Prozeduren |
|---|---|
| `Library - Utility` | `GenerateRandomCode20`, `GetNewLineNo` |
| `Library - No. Series` | `CreateNoSeries`, `CreateNoSeriesLine` |
| `Library - ERM` | `FindGeneralPostingSetupInvtFull`, `FindVATPostingSetupInvt` |
| `Library - Sales` | Debitoren, Verkaufsbelege |
| `Library - Marketing` | `CreateContactWithCustomer` |
| `Library - Resource` | `CreateResourceNew` |
| `Any` | `IntegerInRange`, `DecimalInRange`, `AlphabeticText` |
| `Assert` | `AreEqual`, `AreNotEqual`, `IsTrue`, `ExpectedError` |

### Test-Codeunit

```al
codeunit 80150 "SMT Test Seminar"
{
    Subtype = Test;
    TestPermissions = Disabled;

    // [FEATURE] [Seminar Management]

    [Test]
    procedure TestSeminar()
    var
        SMBSeminar: Record "SMB Seminar";
        SMTLibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
        Assert: Codeunit Assert;
        Any: Codeunit Any;
    begin
        // [Scenario] Create new seminar
        // [Given] New Company
        // [When] Add new seminar and fill fields
        SMTLibrarySeminarManagement.CreateSeminar(SMBSeminar);

        // Suchbegriff wird aus der Beschreibung abgeleitet
        SMBSeminar.Validate(Description, LowerCase(Any.AlphabeticText(100)));
        Assert.AreEqual(
            SMBSeminar."Search Description",
            UpperCase(CopyStr(SMBSeminar.Description, 1, MaxStrLen(SMBSeminar."Search Description"))),
            'Suchbegriff ist falsch oder nicht gefüllt');

        // Min/Max-Plausibilität – positiver Fall
        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);
        SMBSeminar.Validate("Minimum Participants", Any.IntegerInRange(5));
        SMBSeminar.Validate("Maximum Participants",
            SMBSeminar."Minimum Participants" + Any.IntegerInRange(5));

        // Negativer Fall – muss fehlschlagen
        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);
        SMBSeminar.Validate("Minimum Participants", 5);
        asserterror SMBSeminar.Validate("Maximum Participants",
            SMBSeminar."Minimum Participants" - 1);

        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 5);
        asserterror SMBSeminar.Validate("Minimum Participants",
            SMBSeminar."Maximum Participants" + 1);
    end;

    [Test]
    [HandlerFunctions('StartingDateMessageHandler,SeminarPostConfirmHandler')]
    procedure TestSeminarRegistration()
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        LibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
        SMBSeminarPostYesNo: Codeunit "SMB Seminar-Post (Yes/No)";
    begin
        // [GIVEN] A new seminar registration with defaults
        LibrarySeminarManagement.CreateSeminarRegHeader(SMBSeminarRegHeader);

        // [WHEN] enter various values
        SMBSeminarRegHeader.Validate("Starting Date", WorkDate() - 1);   // löst Message aus
        LibrarySeminarManagement.CreateSeminarRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);
        LibrarySeminarManagement.CreateSeminarRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);

        SMBSeminarRegHeader.Validate(Status, SMBSeminarRegHeader.Status::Closed);
        SMBSeminarRegHeader.Modify(true);

        // [THEN] Post the registration
        SMBSeminarPostYesNo.Run(SMBSeminarRegHeader);                   // löst Confirm aus
    end;

    [ConfirmHandler]
    procedure SeminarPostConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [MessageHandler]
    procedure StartingDateMessageHandler(MessageText: Text[1024])
    begin
    end;
}
```

**Wichtig:** Jeder Dialog, der im Test auftreten kann, braucht einen Handler in
`[HandlerFunctions(…)]`. Fehlt einer, schlägt der Test mit „unhandled UI" fehl. Der
Message-Handler darf leer sein – er muss nur existieren.

### TestPages

Für Tests, die die Page-Logik einbeziehen (Sichtbarkeit von Controls, Actions):

| Funktion | Entspricht |
|---|---|
| `OpenNew()`, `OpenEdit()`, `OpenView()` | Page öffnen |
| `GotoKey()` | `Get()` |
| `New()` | neuen Datensatz anlegen |
| `Close()` | Page schließen |
| `Trap()` | nächste Page mit gleichem Subtype abfangen |
| `First()`, `Last()`, `Next()`, `Previous()` | navigieren |
| `Field.AssertEquals()` | `TestField()` |
| `Field.SetValue()` | Wert eintragen |
| `Field.AsType()` | Wert typisiert lesen |
| `Action.Invoke()` | Aktion ausführen |

**Ablauf Card-Page:**

```
OpenNew()  →  Field.SetValue() …  →  Next()  (speichert)  →  Close()
```

**Ablauf Main/Sub-Page:**

```
OpenEdit()  →  GotoKey()  →  SubPagePart.Last()  →  SubPagePart.New()
            →  Field.SetValue() …  →  Close()
```

### Grenzen und Empfehlungen

- Test-Codeunits sollten unter 2 Minuten laufen.
- Nicht mehr als 100 Testmethoden je Codeunit.
- Der Client ist nicht beteiligt – benötigte Komponenten müssen serverseitig installiert sein.
- `CurrFieldNo` wird unterstützt (> 0).
- Test Isolation: `Disabled`, `Codeunit` oder `Function` – bestimmt, wann zurückgerollt wird.

## 35 Übersetzung

### Vorgehen

1. In der `app.json`:

```jsonc
"features": [ "NoImplicitWith", "TranslationFile" ]
```

2. Alle Captions, ToolTips und Labels **auf Englisch** schreiben – das ist die Quellsprache.

3. Beim Build entsteht `Translations/<AppName>.g.xlf` mit einem `<source>`-Element je Text.

4. Datei kopieren nach `Translations/<AppName>.de-DE.xlf`, `target-language="de-DE"` setzen und
   je `<source>` ein `<target>` ergänzen:

```xml
<trans-unit id="Table 123456700 - Field 3 - Property 2879900210" …>
  <source>Description</source>
  <target>Beschreibung</target>
</trans-unit>
```

5. `en-US` ist die Quellsprache und braucht meist keine eigene Datei.

### Regeln

| Regel | |
|---|---|
| **Keine `CaptionML` / `ToolTipML`** | Durch XLIFF abgelöst |
| **Keine Text-Literale im Code** | Alles ist `Label` oder `Caption` |
| `Locked = true` | An Labels, die nicht übersetzt werden dürfen (Tokens, Codes) |
| `Comment` an Labels mit Platzhaltern | Sonst kann der Übersetzer die Reihenfolge nicht anpassen |
| `.g.xlf` nicht von Hand pflegen | Wird generiert |
| Übersetzungs-IDs nicht ändern | Ein umbenanntes Feld verliert seine Übersetzung |

**Beispiel für ein gesperrtes Label:**

```al
MyTokenTxt: Label 'MYSEMINAR', Comment = 'Must be uppercase', Locked = true;
```

---

# Anhang A – Stolperfallen

Gesammelt aus dem Kursverlauf und aus dem Code der Musterlösung.

| # | Falle | Lösung |
|---|---|---|
| 1 | `TransferFields` überträgt **keine** FlowFields | Vor dem Buchen `CalcFields` rufen und den Wert explizit zuweisen |
| 2 | `ClearAll()` leert **keine** temporären Tabellen | Zusätzlich `TempRec.DeleteAll()` |
| 3 | Filterreste aus vorherigen Aufrufen | `Reset()` vor dem Neuaufbau; `SetRange(Feld)` ohne Wert entfernt einen einzelnen Filter |
| 4 | Der Datensatz „findet sich selbst" bei Dublettenprüfung | `SetFilter("Line No.", '<>%1', "Line No.")` |
| 5 | `Modify()` auf einem noch nicht eingefügten Satz | `if not IsNullGuid(Rec.SystemId) then Modify()` |
| 6 | `Message`/`Confirm`/`Dialog` bricht Tests und Hintergrundläufe | Immer mit `GuiAllowed()` schützen |
| 7 | Rückfrage erscheint auch bei programmatischer Änderung | `CurrFieldNo <> 0` als Bedingung |
| 8 | `UserId()` ist länger als das Zielfeld | `CopyStr(UserId(), 1, MaxStrLen(Feld))` |
| 9 | Deadlocks bei parallelen Buchungen | `LockTable()` immer in derselben Reihenfolge; nach `LockTable` neu `Find()` |
| 10 | Buchungsnummer geht bei Abbruch verloren | `Modify` + `Commit` direkt nach dem Ziehen |
| 11 | Adressfelder werden beim Leeren des Codes nicht zurückgesetzt | `else Rec.Init()` auf der Puffervariablen |
| 12 | Manuell gesetzter Suchbegriff wird überschrieben | Prüfen, ob er dem alten Auto-Wert entspricht |
| 13 | `OnLookup` darf `Rec` nicht direkt ändern | Über eine lokale Kopie arbeiten |
| 14 | Anwender entfernt den Filter der Lookup-Page | `FilterGroup(2)` … `FilterGroup(0)` |
| 15 | Rekursion in der Rabattlogik | Rechenprozeduren nur zuweisen (`:=`), nicht validieren |
| 16 | Navigate wird mit wachsenden Posten langsam | Sekundärschlüssel `("Document No.", "Posting Date")` |
| 17 | Fehler bei Anwendern ohne Leserecht in Navigate | `ReadPermission()` prüfen |
| 18 | Event-Subscriber kompiliert nicht | Signatur exakt aus dem Symbol übernehmen, nie raten |
| 19 | Buchung läuft beim Entwickler, nicht beim Anwender | `Permissions`-Property an der Post-Line-Codeunit |
| 20 | Neues Objekt für den Anwender unsichtbar | Eintrag im PermissionSet vergessen (**zwei** Zeilen pro Tabelle) |
| 21 | Setup-Page zeigt leeren Zustand | `OnOpenPage` mit `Init`/`Insert` |
| 22 | Belegzeile wird zu früh eingefügt | `DelayedInsert = true` auf der Subpage |
| 23 | `ResLedgerEntry.FindLast()` ohne Filter | Bei paralleler Buchung unzuverlässig – auf `Document No.` filtern |
| 24 | Übersetzung geht nach Umbenennung verloren | Feld- und Objektnamen nicht ändern |
| 25 | `Text`-Parameter vs. längenbegrenztes Feld | `CopyStr` beim Zurückschreiben (`AA0139`) |

# Anhang B – Übungsverbote

Der Kurs verbietet in einzelnen Aufgaben bestimmte Konstrukte, um mengenbasiertes Denken zu
erzwingen:

> **Verbotene Anweisungen:** `Record.Count()`, `Record.Next()`, `for/do`, `repeat/until`,
> `while/do`

**Betroffene Aufgaben:**

1. **Löschbedingungen** – „Ein Seminar darf nur gelöscht werden, wenn es keine
   Seminarregistrierung mehr dafür gibt."
2. **Teilnehmererfassung prüfen** – zusätzlich: *nur ein einziger Lesezugriff auf die
   Datenbank*, und die Prüfung darf auf einem bereits erfassten Datensatz nicht fehlschlagen.

**Die Denkweise dahinter:** Statt Datensätze einzeln durchzugehen, formuliert man eine
Filterbedingung und fragt die Datenbank, ob die Menge leer ist.

```al
// ✘ verboten
Line.SetRange("Document No.", "Document No.");
if Line.FindSet() then
    repeat
        if Line."Participant Contact No." = "Participant Contact No." then
            Error(…);
    until Line.Next() = 0;

// ✔ richtig — ein Lesezugriff, keine Schleife
Line.SetRange("Document No.", "Document No.");
Line.SetRange("Participant Contact No.", "Participant Contact No.");
Line.SetFilter("Line No.", '<>%1', "Line No.");
if not Line.IsEmpty() then
    Error(ParticipantRegisteredErr, FieldCaption("Participant Contact No."));
```

Die Verbote gelten **nur** in diesen Übungen. In Buchungsroutinen sind Schleifen
selbstverständlich zulässig und notwendig.

**Die fortgeschrittene Variante** der Teilnehmerprüfung verlangt zusätzlich, überlappende
Seminare zu erkennen – und erlaubt dafür ausdrücklich, das Datenmodell geringfügig anzupassen
(z. B. das Startdatum in die Zeile zu denormalisieren, damit ein einziger Filter genügt).

# Anhang C – Glossar

| Begriff | Bedeutung |
|---|---|
| **Archetyp** | Die Rolle einer Tabelle im BC-Datenmodell (Master, Document, Ledger Entry …) |
| **Beleg (Document)** | Kopf-/Zeilen-Paar, das einen Geschäftsvorfall abbildet, bevor er gebucht ist |
| **Buch.-Blatt (Journal)** | Frei editierbares Arbeitsblatt als Vorstufe zum Posten |
| **Posten (Ledger Entry)** | Unveränderlicher historischer Eintrag; nur einfügen, nie ändern oder löschen |
| **Register** | Klammert die Posten eines Buchungslaufs über `From`/`To Entry No.` |
| **Buchen (Posting)** | Der Vorgang, aus Bewegungsdaten Historie zu erzeugen |
| **Herkunftscode (Source Code)** | Kennzeichnet, welcher Prozess ein Buchungsfragment erzeugt hat |
| **Dimension Set ID** | Integer, der eine ganze Dimensionskombination repräsentiert |
| **FlowField** | Berechnetes Feld (`count`, `sum`, `lookup`, `exist`); wird nicht gespeichert |
| **FlowFilter** | Filterfeld, das FlowFields zur Laufzeit einschränkt |
| **SumIndexField** | Vorberechnete Summe an einem Schlüssel, macht `sum`-FlowFields schnell |
| **Cue** | Zahlenkachel im Rollencenter |
| **Filter Token** | Platzhalter wie `%MYSEMINAR`, der zur Laufzeit zu einem Filter aufgelöst wird |
| **Caption Class** | Dynamische Beschriftung, zur Laufzeit von der Anwendung ermittelt |
| **Event Subscriber** | Methode, die auf ein veröffentlichtes Ereignis reagiert |
| **Test Isolation** | Legt fest, wann eine Testtransaktion zurückgerollt wird |
| **XLIFF** | Standardformat für Übersetzungen (`.xlf`) |

---

## Weiterführend

- **Regelwerk für Coding Agents:** [`../docs/agent/`](../docs/agent/) – dieselben Muster als
  verbindliche Anweisungen zum Erweitern einer bestehenden App
- **Verifizierte Microsoft-Quellen:** [`../docs/agent/80-msdocs-links.md`](../docs/agent/80-msdocs-links.md)
- **Der Endstand als Code:** [`Final/src/`](Final/src/)
