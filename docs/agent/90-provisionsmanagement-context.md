# 90 – Domänenkontext: Provisionsmanagement (Basis-App)

Dieses Dokument beschreibt die **tatsächlich gestellte Basis-App**, wie sie im Repository
unter `CommissionManagement/` liegt. Der Agent baut sie nicht –
er erweitert sie.

Die Angaben stammen aus dem Code, nicht aus der Spezifikation. Wo Spezifikation und Code
auseinandergehen, **gilt der Code**.

---

## Eckdaten

| | |
|---|---|
| Ordner | `CommissionManagement/` |
| Name | `Commission Management` |
| Publisher | `GOB Software und Systeme GmbH & Co. KG` |
| App-ID | `c8c8e0da-e740-4159-a463-83431d5e1480` |
| Version | `1.0.0.0` |
| **Objekt-Prefix** | **`PTE`** |
| ID-Bereich | 63000 – 63500 |
| Platform / Application | `26.0.0.0` / `26.3.0.0` |
| Runtime | `15.0` |
| Features | `NoImplicitWith`, `TranslationFile` |
| Dependencies | **keine** – die App steht allein auf der BaseApp |
| Übersetzungen | `de-DE`, `en-US`, `.g.xlf` unter `Translations/` |

> ⚠️ **Der Prefix ist `PTE`, nicht `GOB`.** Die Spezifikation nennt `GOB`; die gestellte App
> verwendet durchgängig `PTE`. `GOB` ist der bei Microsoft registrierte Produktprefix für
> unitop – im Projekt gilt `PTE`. Alle neuen Objekte tragen ebenfalls `PTE`.

---

## Objektinventar (belegte IDs)

### Tabellen

| ID | Name | Archetyp |
|---|---|---|
| 63000 | `PTE Commission Mgt. Setup` | Setup |
| 63001 | `PTE Commission Type` | Supplemental |
| 63020 | `PTE Commission Contract` | Master |
| 63021 | `PTE Commission Comment Line` | Bemerkungen |
| 63022 | `PTE Commission Ledger Entry` | Ledger Entry |

### Table Extension

| ID | Name | erweitert |
|---|---|---|
| 63000 | `PTE Salesperson Com. Table Ext` | `Salesperson/Purchaser` |

Felder darin: `PTE Commission Contract No.` (63020), `PTE Commission Amount (LCY)`
(63021, FlowField), `PTE Date Filter` (63022, FlowFilter).

### Pages

| ID | Name | Typ |
|---|---|---|
| 63000 | `PTE Commission Mgt. Setup Card` | Card (Setup) |
| 63001 | `PTE Commission Type List` | List |
| 63020 | `PTE Commission Contract List` | List |
| 63021 | `PTE Commission Contract Card` | Card |
| 63022 | `PTE Com. Contract Factbox` | CardPart |
| 63023 | `PTE Commission Comment List` | List |
| 63024 | `PTE Commission Comment Sheet` | List |
| 63025 | `PTE Commission Ledger Entries` | List |

### Page Extensions

| ID | Name | erweitert |
|---|---|---|
| 63000 | `PTE Com. Contract Role Center` | `Order Processor Role Center` |
| 63001 | `PTE Salesperson Com. Page Ext` | `Salesperson/Purchaser Card` |
| 63002 | `PTE Salesperson Com. List Ext` | `Salespersons/Purchasers` |

### Codeunits

| ID | Name | Rolle |
|---|---|---|
| 63000 | `PTE Com. Mgt. Validation` | prüft, ob der Setup-Satz existiert |
| 63001 | `PTE Com. Mgt. Inst. Lib` | Subscriber auf `OnRegisterManualSetup` (Manuelle Einrichtung) |
| 63021 | `PTE Calculate Commission` | Provisionsberechnung, Doppelerfassungsprüfung |
| 63022 | `PTE Post Com. Ledger Entry` | erzeugt Provisionsposten |
| 63023 | `PTE Commission Contract` | Vertragslogik für den `OnDelete`-Trigger |

### Enums

| ID | Name |
|---|---|
| 63000 | `PTE Commission Contract Status` |
| 63001 | `PTE Comment Line Table Name` |
| 63002 | `PTE Com. Led. Ent. Doc. Type` |
| 63004 | `PTE Commission Payment Type` |

### Report und PermissionSets

| Typ | ID | Name |
|---|---|---|
| Report | 63000 | `PTE Calc. Commissions` |
| PermissionSet | 63000 | `PTE Permission GL` |
| PermissionSet | 63001 | `PTE Permission RO` |
| PermissionSet | 63003 | `PTE Permission PO` |
| PermissionSet | 63004 | `PTE Permission SE` |

**Freie IDs im Bereich 63000–63500:** unter anderem 63002–63019 (teilweise), 63026–63500.
Vor der Vergabe eigener IDs das Inventar erneut prüfen — und beachten: **Eine separate
Erweiterungs-App bekommt einen eigenen ID-Bereich**, nicht diesen.

---

## Ordnerstruktur der Basis-App

Featureorientiert, nicht objekttyporientiert wie die Musterlösung:

```
src/
├── Comment/
│   ├── Data/               PTECommissionCommentLine.Table.al
│   ├── Enums/              PTECommentLineTableName.Enum.al
│   └── Features/CommentManagement/   Comment List + Comment Sheet
├── Contract/
│   ├── Data/               Contract, Ledger Entry, Commission Type
│   ├── Enums/              Status, Doc. Type, Payment Type
│   ├── Extensions/         Salesperson TableExt + 2 PageExt + Role Center PageExt
│   └── Features/
│       ├── CommissionCalculation/    Report + Calculate-Codeunit
│       ├── CommissionTypes/          Type List
│       ├── ContractManagement/       Card, List, Factbox, Contract-Codeunit
│       └── Ledger/                   Ledger Entries Page + Post-Codeunit
├── Permission/             4 PermissionSets
└── Setup/
    ├── Data/               Setup-Tabelle
    └── Features/SetupManagement/   Setup Card, Install Lib, Validation
```

**Neue Objekte folgen diesem Schema**: `<Feature>/Data|Enums|Extensions|Features/<Bereich>/`.

---

## Hausstil der Basis-App

Das ist verbindlich für alles, was dazukommt — er hat Vorrang vor dem Stil der Musterlösung.

### Übersetzung direkt am Property

Captions, ToolTips und Labels tragen die deutsche Übersetzung als `Comment`:

```al
field(30; "Starting Date"; Date)
{
    DataClassification = CustomerContent;
    Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
    ToolTip = 'This is the Starting Date of the Commission Contract.',
        Comment = 'de-DE=Das Startdatum des Provisions Vertrags.';
}
```

Die XLIFF-Dateien unter `Translations/` werden daraus erzeugt. **Nicht** von Hand pflegen.

### Weitere Merkmale

| Merkmal | Ausprägung |
|---|---|
| `DataClassification` | an der Tabelle **und** je Feld, Wert `CustomerContent` |
| ToolTips | **an der Tabelle**, nicht an der Page |
| ToolTip-Formulierung | `'This is the <Feld> of the <Entität>.'` bzw. `'This indicates whether …'` |
| Schlüsselname | `key(PK; …)` mit `Clustered = true` ✓ entspricht der GOB-Konvention |
| Feldnummern | in Zehnerschritten, thematisch geblockt (1, 10, 20/21, 30, 40, 50, 60, 70/71/72, 80, 107) |
| Labels | **lokal im Trigger/in der Prozedur** deklariert, Suffix `Err` |
| Tabellenlogik | delegiert an Codeunits (`OnDelete` ruft `PTE Commission Contract`) |
| Nummernserie | `Setup.Get('')`, dann `NoSeries.AreRelated` / `GetNextNo("No. Series", WorkDate())` |
| Prozeduren | durchgängig **public** – kein `local`, kein `internal`, kein `Access = Internal` |

### Bekannte Abweichungen von den GOB-Coderichtlinien

Auch die Basis-App ist nicht lupenrein. **Nicht ungefragt reparieren**, aber auch nicht
nachahmen:

| Abweichung | Wo |
|---|---|
| `DataClassification` fehlt an TableExt-Feldern | `PTESalespersonComTableExt.TableExt.al` |
| `DataClassification` fehlt am Setup-Feld `Contract Nos.` | `PTECommissionMgtSetup.Table.al` |
| `IsEmpty()` vor `FindSet()` | `PTECommissionContract.Codeunit.al`, `ClearLedgerEntriesForContract` |
| Posten werden nachträglich geändert | ebenda – setzt `Commission Contract No.` in bestehenden Posten auf leer |
| Kleinschreibung von Methoden (`setRange`, `deleteAll`, `onValidate`) | mehrere Dateien |

---

## Fachliche Struktur

```
   Salesperson/Purchaser  ─────▶  PTE Commission Contract  ─────▶  PTE Commission Comment Line
   (TableExt 63000)                       │      │
   PTE Commission Contract No. ◀──────────┘      │
   PTE Commission Amount (LCY)                   ▼
   PTE Date Filter                       PTE Commission Type

   Cust. Ledger Entry  ──────────▶  PTE Commission Ledger Entry
                                    Entry No. · Posting Date · Document Type · Document No.
                                    Customer No. · Amount (LCY) · Salesperson Code
                                    Commission Contract No. · Customer Ledger Entry No.
                                    Commission Amount (LCY) · Currency Code
```

**Kein Beleg, kein Buch.-Blatt, kein Register, keine gebuchten Belege.** Die Posten entstehen
direkt aus dem Report `PTE Calc. Commissions` heraus, der `PTE Calculate Commission` zur
Berechnung und `PTE Post Com. Ledger Entry` zum Schreiben nutzt.

### Öffentliche Schnittstellen der Basis-App

Aus einer separaten App heraus nutzbar:

| Codeunit | Prozedur |
|---|---|
| `PTE Calculate Commission` | `Calculate(SalesmanCommission: Decimal; SalesAmount: Decimal; DocumentType: Enum "Gen. Journal Document Type"): Decimal` |
| `PTE Calculate Commission` | `IsAlreadyCommissioned(SalespersonCode: Code[20]; LedgerEntryNo: Integer): Boolean` |
| `PTE Post Com. Ledger Entry` | `PostNewEntry(SalesPerson: Record "Salesperson/Purchaser"; CustomerLedgerEntry: Record "Cust. Ledger Entry"; CommissionAmountLCY: Decimal)` |
| `PTE Commission Contract` | `HasRemainingSalesman`, `ClearLedgerEntriesForContract`, `DeleteCommentsForContract` |
| `PTE Commission Comment Line` | `SetUpNewLine()` |

> ⚠️ **Die Basis-App publiziert keine Events.** Es gibt weder `IntegrationEvent` noch
> `BusinessEvent`. Ihre Bausteine sind also **aufrufbar, aber ihre Abläufe nicht
> erweiterbar**. Muss eine neue App in einen bestehenden Ablauf eingreifen (etwa in die
> Berechnung im Report), gibt es dafür keinen Einstiegspunkt — das ist ein Blocker, der
> zu melden ist, kein Grund für Code-Duplikation.

---

## Fachliche Regeln aus der Spezifikation

Gelten weiter, auch wenn eine Erweiterungsaufgabe sie nicht wiederholt:

- **Provisionsformel:** `Provisionsbetrag = (Rechnungsbetrag / 100) * Provision in Prozent`
- **Gutschriften ergeben einen negativen Betrag**
- **Rundung über das Einrichtungsfeld** `Rounding Precision`
- **Beträge 1:1 aus den Debitorenposten** – keine erneute Währungsumrechnung
- **`Commission Percentage` zwischen 1 und 100**
- **Keine Doppelerfassung** – bereits verarbeitete Belege werden erkannt und übersprungen
  (`IsAlreadyCommissioned`)
- **Provisionsposten bleiben dauerhaft erhalten**
- **Ein Vertrag darf nicht gelöscht werden, solange ihm ein Verkäufer zugeordnet ist**
- **Das Standardfeld `Commission %` am Verkäufer bleibt ausgeblendet**

### Rollencenter-Menü

Die Gruppe im `Order Processor Role Center` (PageExt 63000) enthält laut Spezifikation:
Provisionsarten, Verkäufer, Provisionsverträge, Provisionsposten, Provisionen berechnen.
Neue Einstiegspunkte gehören in dieselbe Gruppe.

---

## Mapping Musterlösung → Provisionsmanagement

Wenn eine Erweiterungsaufgabe ein Muster aus `SolDev/Final/` verlangt:

| Rolle im Datenmodell | Seminar (`SMB`) | Provision (`PTE`) |
|---|---|---|
| Setup | `SMB Seminar Setup` | `PTE Commission Mgt. Setup` |
| Master | `SMB Seminar` | `PTE Commission Contract` |
| Supplemental | `SMB Seminar Room`, `SMB Instructor` | `PTE Commission Type` |
| Bemerkungen | `SMB Seminar Comment Line` | `PTE Commission Comment Line` |
| Angebundener Standard-Stammsatz | `Contact`, `Customer` | `Salesperson/Purchaser` |
| Posten | `SMB Seminar Ledger Entry` | `PTE Commission Ledger Entry` |
| Auslösender Standardbeleg | `Sales Invoice` (Fakturierung) | `Cust. Ledger Entry` (Berechnungsgrundlage) |
| Stapellauf | `SMB Create Seminar Invoices` | `PTE Calc. Commissions` |
| FactBox | `SMB Seminar Details FactBox` | `PTE Com. Contract Factbox` |
| Rollencenter | `SMB Seminar Role Center` (eigenes) | PageExt auf `Order Processor Role Center` |

### Was in der Basis-App fehlt

Diese Bausteine der Musterlösung haben **kein** Pendant. Sie sind die wahrscheinlichen
Inhalte kommender Aufgaben – und für jeden gibt es ein fertiges Muster:

| Fehlender Baustein | Muster in der Musterlösung |
|---|---|
| Beleg (Header + Line) | `SMBSeminarRegHeader/RegLine.Table.al`, `SMBSeminarRegistration.Page.al` |
| Belegstatus-Enum | `SMBSeminarRegStatus.Enum.al` |
| Buch.-Blattzeile | `SMBSeminarJournalLine.Table.al` |
| Register | `SMBSeminarRegister.Table.al` |
| Check-Line- / Post-Line-Codeunit | `SMBSemJnlCheckLine/PostLine.Codeunit.al` |
| Post- / Post-(Yes/No)-Codeunit | `SMBSeminarPost.Codeunit.al`, `SMBSeminarPostYesNo.Codeunit.al` |
| Gebuchte Belege | `SMBPostedSeminarRegHeader/Line.Table.al`, `SMBPstSemRegistration.Page.al` |
| Navigate-Integration | `SMBSeminarNavigate.Codeunit.al` |
| Verknüpfung mit `Sales-Post` | `SMBSeminarInvoicing.Codeunit.al` |
| Herkunftscode-Einrichtung | `SMBSourceCodeSetup.TableExt/PageExt.al` |
| Cue + Aktivitäten-Part | `SMBSeminarCue.Table.al`, `SMBSeminarMgtActivities.Page.al` |
| Eigenes Rollencenter + Profile | `SMBSeminarRoleCenter.Page.al`, `src/profile/` |
| Filter Token + „My …"-Tabelle | `SMBMySeminarFilterToken.Codeunit.al`, `SMBMySeminar.Table.al` |
| Statistik-Page | im Schulungsskript beschrieben (S. 46), in `Final` nicht ausprogrammiert |
| Test-App | `SolDev/Final/TestSeminarManagement/` |

Der **Bonus-Prozess** ist der wahrscheinlichste Kandidat für eine Folgeaufgabe: Die Felder
`Pay Commission Bonus`, `Target Achievement Amount` und `Commission Bonus Amount` sowie der
Enum `PTE Commission Payment Type` existieren bereits, tragen aber **keine Geschäftslogik**.
