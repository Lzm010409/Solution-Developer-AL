# 10 – Benennung, IDs, Dateistruktur

---

## Objekt-Prefix

**Im Projekt Provisionsmanagement gilt `PTE`** – so wie in der gestellten Basis-App.
`GOB` ist der Präfix der unitop-Produktentwicklung und kommt hier nicht zum Einsatz, auch
wenn die Spezifikation ihn nennt. Siehe [`05-gob-richtlinien.md`](05-gob-richtlinien.md),
Abschnitt „Geklärt: Präfix im Projekt".

Jedes neue Objekt, jedes neue Feld in einer `tableextension` und jede neue Enum-Value trägt den
Prefix der App. Der Prefix ist genau drei Zeichen lang, steht am Anfang, gefolgt von einem
Leerzeichen im Objektnamen.

```al
table 63023 "PTE Commission Bonus Entry"    // ✔
table 63023 "Commission Bonus Entry"        // ✘ Prefix fehlt
table 63023 "PTECommission Bonus Entry"     // ✘ Leerzeichen fehlt
```

In `tableextension`-Feldern steht der Prefix ebenfalls im Feldnamen:

```al
field(63000; "PTE Commission Contract No."; Code[20]) { … }
```

Referenz: `SolDev/Final/src/tableextension/SMBSalesLine.TableExt.al`
→ Feld `"SMB Apply-to Seminar Entry"`.

**Der Prefix ist außerdem überall dort Pflicht, wo der Microsoft-Standard erweitert wird:**

- `global procedure`s in Table-, Page-, Report- und Enum-Extensions
- Zugriffsmodifikatoren in Extension-Objekten, z. B. `protected var`
- neue **Controls und Control-Gruppen** auf Pages und Reports

Feldnummern in Table Extensions müssen aus dem eigenen Nummernkreis kommen **und über den
gesamten Workspace eindeutig sein** – zwei Table Extensions auf dieselbe Tabelle dürfen dieselbe
Feldnummer nicht doppelt vergeben.

---

## Objekt-IDs

- Nur innerhalb des `idRanges` aus der `app.json`.
- Der Bereich ist **nicht** pro Objekttyp getrennt – Tabelle 63000 und Page 63000 dürfen
  parallel existieren, aber zwei Tabellen mit 63000 nicht.
- Vor der Vergabe: Objektinventar aus Phase 0 prüfen.

### Nummerierung mit System

Die Musterlösung nummeriert nicht fortlaufend, sondern in Blöcken. Übernimm das Schema der
Basis-App. Typisch:

| Block | Inhalt |
|---|---|
| `x000–x019` | Setup, Stammdaten, Supplementals |
| `x020–x029` | Bewegungsdaten / Belege |
| `x030–x039` | Buch.-Blatt, Posten, Register |
| `x050–x059` | Rollencenter, Cues |

**Ausnahme – Buchungs-Codeunits:** Deren Endziffer ist nach BC-Konvention *bedeutungstragend*
und darf nicht frei gewählt werden. Siehe `40-posting-architecture.md`.

---

## Dateinamen und Ordner

⚠️ **Die Basis-App ordnet featureorientiert, nicht objekttyporientiert.** Neue Objekte folgen
ihrem Schema, nicht dem der Musterlösung:

```
src/
├── <Feature>/                     z. B. Contract, Comment, Setup
│   ├── Data/                      Tabellen
│   ├── Enums/                     Enums
│   ├── Extensions/                TableExt, PageExt, EnumExt
│   └── Features/<Bereich>/        Pages, Codeunits, Reports
└── Permission/                    PermissionSets
```

Beispiele aus der Basis-App:

```
src/Contract/Data/PTECommissionContract.Table.al
src/Contract/Extensions/PTESalespersonComTableExt.TableExt.al
src/Contract/Features/ContractManagement/PTECommissionContractCard.Page.al
src/Contract/Features/CommissionCalculation/PTECalcCommissions.Report.al
src/Setup/Data/PTECommissionMgtSetup.Table.al
src/Permission/PTEPermissionGL.PermissionSet.al
```

Die **Dateinamensendungen** bleiben dieselben wie in der Musterlösung:

```
<Prefix><Name>.Table.al · .TableExt.al · .Page.al · .PageExt.al · .PageCust.al
<Prefix><Name>.Codeunit.al · .Report.al · .Enum.al · .EnumExt.al
<Prefix><Name>.PermissionSet.al · .Profile.al
```

Der Dateiname enthält den Objektnamen **ohne Leerzeichen und ohne Sonderzeichen**:

```
"PTE Commission Contract"       →  PTECommissionContract.Table.al
"PTE Post Com. Ledger Entry"    →  PTEPostComLedgerEntry.Codeunit.al
"SMB Sem. Jnl.-Post Line"       →  SMBSemJnlPostLine.Codeunit.al   (Musterlösung)
```

**Ein Objekt pro Datei.** Keine Sammeldateien.

Die Musterlösung `SolDev/Final/src/` ordnet objekttyporientiert (`src/table/`, `src/page/`, …).
Das ist **nicht** das Schema dieses Projekts – halte dich an die Basis-App.

---

## Schlüsselnamen

GOB-Konvention – gilt vor dem, was die Musterlösung zeigt:

| Schlüssel | Name |
|---|---|
| Primärschlüssel | **`PK`** |
| Sekundärschlüssel | **`Key01`, `Key02`, …** – in Extension-Objekten `PTEKey01`, `PTEKey02`, … |
| Ausnahme | Ein sprechender Name ist nur zulässig, wenn der Schlüssel genau einem Zweck dient und Mehrfachverwendung nicht absehbar ist. Der Reviewer kann das unterbinden. |

```al
keys
{
    key(PK; "Entry No.") { Clustered = true; }
    key(Key01; "Document No.", "Posting Date") { }
    key(Key02; "Salesperson Code", "Posting Date") { SumIndexFields = "Commission Amount"; }
}
```

## Variablennamen

Record- und Codeunit-Variablen heißen wie das Objekt, ohne Leerzeichen und Sonderzeichen.
**Ungarische Notation ist verboten** – kein `recCustomer`, `decAmount`, `locItem`:

```al
var
    SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    SMBSemJnlPostLine: Codeunit "SMB Sem. Jnl.-Post Line";
    NoSeries: Codeunit "No. Series";
```

Braucht man zwei Instanzen derselben Tabelle, wird die zweite mit einem sprechenden Suffix
unterschieden (`…Source` / `…Target`, `…2`), siehe
`SolDev/Final/src/table/SMBSeminarCommentLine.Table.al`.

Temporäre Records tragen das Präfix `Temp`:

```al
TempSMBSeminarRegLineGlobal: Record "SMB Seminar Reg. Line" temporary;
```

---

## Labels

**Keine Text-Literale im Code.** Jeder anzeigbare Text ist ein `Label` mit sprechendem Suffix:

| Suffix | Verwendung |
|---|---|
| `…Err` | Fehlermeldung (`Error`, `FieldError`) |
| `…Msg` | Hinweis (`Message`) |
| `…Qst` | Rückfrage (`Confirm`) |
| `…Txt` | sonstiger Text, Tokens |
| `…Lbl` | Beschriftungen, Überschriften |

Jedes Label mit Platzhaltern braucht einen `Comment`, der die Platzhalter erklärt:

```al
var
    CannotDeleteErr: Label 'You cannot delete the %1 because there is one or more %2.',
        Comment = '%1 = TableCaption of the record, %2 = TableCaption of the dependent record';
    WantToPostQst: Label 'Do you want to post the %1?',
        Comment = '%1 = TableCaption of the document';
    DateInPastMsg: Label '%1 is in the past.',
        Comment = '%1 = FieldCaption of the checked date field';
```

Labels stehen in der `var`-Sektion des Objekts – oder lokal in der Prozedur, wenn sie nur dort
gebraucht werden (siehe `UpdateSMBSeminarRegLinesByFieldNo` in
`SolDev/Final/src/table/SMBSeminarRegHeader.Table.al`).

> Hinweis zur Musterlösung: Dort stehen teilweise nichtssagende Comments wie `Comment = '%1%2'`.
> **Das ist nicht nachahmenswert** – schreib den Platzhalter aus, sonst kann der Übersetzer die
> Reihenfolge nicht korrekt anpassen.

---

## Captions und ToolTips

- **Jedes** Feld bekommt eine `Caption` in Englisch.
- **Jedes auf einer Page sichtbare Feld** bekommt einen `ToolTip`. Die Spezifikation fordert das
  ausdrücklich („Die Extension soll vollständig mit Tooltips versehen werden").
- ToolTip-Konvention: `'Specifies …'`.
- Actions bekommen ebenfalls einen `ToolTip`.

Gepflegt wird der ToolTip **an der Tabelle**, wenn die Basis-App das so hält (dann erbt ihn jede
Page automatisch) – sonst an der Page. Nicht mischen.

```al
field(44; "Seminar Price"; Decimal)
{
    Caption = 'Seminar Price';
    AutoFormatType = 1;
    MinValue = 0;
    DataClassification = CustomerContent;
    ToolTip = 'Specifies the price of the seminar.';
}
```

---

## Feldnummern in Tabellen

Übernimm, wo möglich, die Feldnummern des Standardobjekts, von dem du abgeleitet hast. Das
macht `TransferFields` zwischen ungebuchtem und gebuchtem Beleg fehlerfrei.

Reservierte Bereiche, die die Musterlösung durchgängig einhält:

| Nr. | Bedeutung |
|---|---|
| `1` | Primärschlüsselfeld (`No.`, `Code`, `Entry No.`) |
| `480` | `Dimension Set ID` |
| `481–486` | `Shortcut Dimension 3–8 Code` (FlowFields) |
| `490 / 491` | `Shortcut Dimension 1/2 Code` |

Bei **Header/Line-Paaren gilt: gleiche Feldnummer = gleiche Bedeutung**, damit
`TransferFields` funktioniert. Siehe `SMBSeminarRegHeader` ↔ `SMBPostedSeminarRegHeader`.

---

## `app.json`

Bei einer Erweiterung wird die `app.json` nur angefasst, wenn die Aufgabe es erzwingt:

- neue `dependencies` (z. B. weil ein Standardmodul referenziert wird)
- `"features"` ergänzen, wenn Übersetzung neu dazukommt (`"TranslationFile"`)
- **`version` hochziehen** – das gehört zu jeder Erweiterung

`idRanges`, `id` und `publisher` bleiben unangetastet.
