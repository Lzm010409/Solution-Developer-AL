# Commission Management (Provisionsmanagement)

Basis-App des Projekts. Verwaltet Provisionsverträge je Verkäufer und erzeugt aus den
Debitorenposten die zugehörigen Provisionsposten.

| | |
|---|---|
| Prefix | `PTE` |
| ID-Bereich | 63000 – 63500 |
| Version | 1.1.0.0 |
| Application / Platform | 26.3.0.0 / 26.0.0.0, Runtime 15.0 |
| Dependencies | keine |
| Sprachen | `de-DE`, `en-US` (XLIFF unter `Translations/`) |

## Ordnerstruktur

Featureorientiert; innerhalb eines Features nach Objekttyp — identisch zur zweiten App:

```
src/
├── Setup/             Einrichtung und Anmeldung in der „Manuellen Einrichtung"
│   └── table · page · codeunit
├── Contract/          Verträge und Provisionsarten
│   └── table · page · codeunit · enum
├── Commission Ledger/ Buch.-Blattzeile, Posten, Prüfen, Buchen, Berechnung, Stapellauf
│   └── table · page · codeunit · enum · report
├── Comment/           Bemerkungen zum Vertrag (eigene Tabelle, nicht der BC-Standard)
│   └── table · page · enum
├── Salesextension/    Erweiterungen am Verkäufer und am Rollencenter
│   └── tableext · pageext
└── Permission/        vier Berechtigungssätze
```

## Objekte

| Typ | ID | Name | Zweck |
|---|---|---|---|
| Table | 63000 | Commission Mgt. Setup | Rundungspräzision, Nummernkreis der Verträge |
| Table | 63001 | Commission Type | Provisionsarten |
| Table | 63020 | Commission Contract | Vertrag je Verkäufer, mit Nummernserie |
| Table | 63021 | Commission Comment Line | Bemerkungen zum Vertrag |
| Table | 63022 | Commission Ledger Entry | Provisionsposten, nur einfügen |
| Table | 63023 | Commission Journal Line | Buch.-Blattzeile — Eingang jeder Provisionsbuchung |
| TableExt | 63000 | Salesperson/Purchaser | Vertragsnr., Provisionsbetrag, Datumsfilter |
| Page | 63000–63025 | Setup, Listen, Karte, FactBox, Bemerkungen, Posten | |
| PageExt | 63000 | Order Processor Role Center | Menügruppe „Provisionsmanagement" |
| PageExt | 63001/63002 | Verkäuferkarte / -liste | Vertrag und Posten am Verkäufer |
| Codeunit | 63000 | Com. Mgt. Validation | prüft, ob der Einrichtungssatz existiert |
| Codeunit | 63001 | Com. Mgt. Inst. Lib | Anmeldung in der Manuellen Einrichtung |
| Codeunit | 63021 | Calculate Commission | Prozentsatz- und Betragsermittlung, publiziert Events |
| Codeunit | 63022 | Post Com. Ledger Entry | **obsolet** — nur noch für Altaufrufe vorhanden |
| Codeunit | 63023 | Commission Contract | Vertragslogik für den Löschtrigger |
| Codeunit | 63024 | Commission Navigate | meldet die Posten am Standard-„Posten suchen" an |
| Codeunit | 63031 | Commis. Jnl.-Check Line | prüft eine Buch.-Blattzeile, ohne UI und ohne zu schreiben |
| Codeunit | 63032 | Commis. Jnl.-Post Line | erzeugt aus einer Zeile den Provisionsposten |
| Report | 63000 | Calc. Commissions | Stapellauf über Verkäufer und Debitorenposten |
| Enum | 63000/63001/63002/63004 | Vertragsstatus, Bemerkungsart, Belegart, Provisionsart | |
| PermissionSet | 63000/63001/63003/63004 | Vollzugriff / Lesen / Buchen / Einrichtung | |

## Buchungsweg

```
Report 63000  oder  eine andere Extension
        │  füllt
        ▼
Table 63023  Commission Journal Line
        │
        ▼
Codeunit 63032  Post Line ──ruft──▶ 63031 Check Line
        │                           63021 Calculate Commission
        ▼
Table 63022  Commission Ledger Entry
```

Der Betrag stammt unverändert aus dem Debitorenposten — es findet keine zweite
Währungsumrechnung statt, und eine Gutschrift ergibt dadurch eine negative Provision.
Gerundet wird mit der Präzision aus der Einrichtung. Codeunit 63021 verhindert über
`IsAlreadyCommissioned`, dass derselbe Beleg zweimal provisioniert wird.

## Erweiterungspunkte für andere Apps

Codeunit 63021 publiziert vier Integration Events. Über sie greift die App
*Software Sales Management* in die Ermittlung ein, statt eine eigene Berechnung zu bauen:

| Event | Wofür |
|---|---|
| `OnBeforeGetCommissionPercentage` | Prozentsatz vollständig selbst bestimmen (`IsHandled`) |
| `OnAfterGetCommissionPercentage` | den ermittelten Prozentsatz überschreiben |
| `OnBeforeCalculateCommissionAmount` | Betragsermittlung vollständig ersetzen (`IsHandled`) |
| `OnAfterCalculateCommissionAmount` | den ermittelten Betrag nachbearbeiten |

Table 63022 publiziert zusätzlich `OnAfterCopyFromJnlLine`, damit fremde Felder aus der
Buch.-Blattzeile in den Posten wandern können.

## Änderungen in 1.1.0.0

Neu sind Table 63023 sowie die Codeunits 63024, 63031 und 63032. Der Provisionsposten hat
das Feld `Commission Percentage` (111) bekommen, damit der verwendete Prozentsatz im
Beleg nachvollziehbar bleibt. Der Report schreibt keine Posten mehr selbst.

**Obsolet gesetzt, nicht gelöscht** (Tag `1.1.0.0`):
`Calculate`, `PostNewEntry` und `ClearLedgerEntriesForContract`. Alle drei bleiben in der
öffentlichen Schnittstelle, sollten aber nicht mehr aufgerufen werden.

Das Schema ändert sich — beim Publizieren ist eine Synchronisierung nötig.

## Löschen eines Vertrags

Ein Provisionsvertrag lässt sich nur löschen, solange weder ein Verkäufer noch ein
Provisionsposten auf ihn verweist. Provisionsposten werden dabei **nicht** angefasst — das
Postenkonzept von BC kennt keine nachträgliche Änderung.
