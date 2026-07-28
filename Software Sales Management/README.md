# Software Sales Management (Software-Verkaufsmanagement)

Erfassung und Abrechnung von Softwareanpassungen. Eine Anpassung wird erfasst, umgesetzt
und am Ende in einem Zug als Verkaufsrechnung fakturiert; dabei entstehen ein historischer
Beleg und der Provisionsposten des Verkäufers.

| | |
|---|---|
| Prefix | `PTE` |
| ID-Bereich | 63600 – 63700 |
| Version | 1.0.0.0 |
| Dependencies | Commission Management 1.1.0.0 |
| Sprachen | `de-DE`, `en-US` (XLIFF unter `Translations/`) |

## Ordnerstruktur

```
src/
├── Setup/           Einrichtung mit den beiden Nummernkreisen
├── SoftwareChange/  Kern: Vorlage, Anpassung, gebuchte Anpassung, Kopieren, Buchen
├── Sales/           Erweiterungen des BC-Belegflusses
├── Commission/      Anbindung an das Provisionsmanagement
└── Permission/      vier Berechtigungssätze
```

## Objekte

| Typ | ID | Name | Zweck |
|---|---|---|---|
| Table | 63600 | Software Sales Mgt. Setup | Nummernkreise für Anpassung und gebuchte Anpassung |
| Table | 63601 | Software Change Template | Vorlage mit Abrechnungs- und Provisionsvorgaben |
| Table | 63610 | Software Change | die Softwareanpassung |
| Table | 63615 | Posted Software Change | historischer Beleg, exakte Kopie plus Herkunftsnummern |
| Page | 63600 | Softw. Sales Setup Card | Einrichtung, auch über „Manuelle Einrichtung" erreichbar |
| Page | 63601/63602 | Vorlagen — Liste und Karte | |
| Page | 63610/63611 | Anpassungen — Liste und Karte | Liste mit zwei vordefinierten Sichten |
| Page | 63615/63616 | Gebuchte Anpassungen — Liste und Karte | nicht editierbar |
| Codeunit | 63600 | Softw. Sales Inst. Lib | Anmeldung in der Manuellen Einrichtung |
| Codeunit | 63610 | Software Change | Tabellenlogik: Vorlage, Kontaktdaten, Datenschutzsperre, Bemerkungen |
| Codeunit | 63612 | Copy Software Change | Kopierlogik, unabhängig vom Report testbar |
| Codeunit | 63621 | Sw. Change Commission | Subscriber auf die Events der Basis-App |
| Codeunit | 63630 | Software Change-Post | die Abrechnungsroutine, ohne jede UI |
| Codeunit | 63631 | Softw. Change-Post (Y/N) | Rückfrage und Abschlussmeldung |
| Codeunit | 63640 | Software Change Navigate | „Posten suchen" für den historischen Beleg |
| Report | 63620 | Copy Software Change | Anfrageseite mit den Kopieroptionen |
| Enum | 63600 | Accounting Type | Provisionsvertrag oder Software Change |
| Enum | 63601 | Software Change Status | Planung, In Bearbeitung, Abgebrochen, Abgeschlossen |
| EnumExt | 63600 | Comment Line Table Name | zwei Werte für die BC-Standardbemerkungen |
| TableExt | 63600–63602 | Sales Header, Sales Invoice Header, Sales Cr.Memo Header | Softwareanpassungsnr. im Belegfluss |
| TableExt | 63603/63604 | Buch.-Blattzeile und Provisionsposten der Basis-App | Herkunft und abweichende Provision |
| PageExt | 63600–63602 | Verkaufsrechnung und die beiden gebuchten Belege | |
| PageExt | 63603/63604 | Verkäuferkarte und -liste | offene Anpassungen des Verkäufers |
| PageExt | 63605 | Order Processor Role Center | drei Einträge in der Gruppe „Provisionsmanagement" |
| PermissionSet | 63600–63603 | Vollzugriff / Lesen / Buchen / Einrichtung | |

## Bemerkungen

Es entsteht **keine eigene Bemerkungstabelle**. Genutzt wird die BC-Standardtabelle
`Comment Line`, erweitert um zwei Werte im Standard-Enum. Die Bemerkungen der Anpassung
wandern beim Buchen in den historischen Beleg und bleiben dort editierbar — sie haben in
diesem Projekt keinen Beleg-Charakter.

## Abrechnung

Codeunit 63630 arbeitet in dieser Reihenfolge, die bindend ist:

```
1. Pflichtfelder prüfen (Status muss „Abgeschlossen" sein)
2. Verkaufsrechnung erzeugen und über Codeunit 80 buchen
3. gebuchte Softwareanpassung anlegen, Bemerkungen und Links übernehmen
4. Provisionsposten über die Buch.-Blattzeile der Basis-App erzeugen
5. die ursprüngliche Anpassung löschen
```

Schritt 4 setzt Schritt 2 voraus: Grundlage der Provision ist der Betrag des entstandenen
Debitorenpostens — dieselbe Quelle, die auch der Stapellauf „Provisionen berechnen"
verwendet. Dadurch erkennt die Basis-App den Beleg später als bereits provisioniert und
bucht ihn nicht doppelt.

Ohne Provisionsvertrag am Verkäufer entsteht kein Provisionsposten. Das ist gewollt.

## Abweichende Provision

Das Feld `Abrechnungsart` steuert, woher der Prozentsatz kommt:

| Abrechnungsart | Wirkung |
|---|---|
| Provisionsvertrag | der Prozentsatz des Vertrags gilt |
| Software Change | der Prozentsatz der Anpassung überschreibt den Vertrag — **nur wenn er nicht 0 ist** |

Umgesetzt ist das in Codeunit 63621 als Subscriber auf `OnAfterGetCommissionPercentage`
der Basis-App. Es gibt bewusst **keine** eigene Berechnungslogik in dieser App.

## Voraussetzungen im Mandanten

Vor dem ersten Anlegen müssen in der Einrichtung beide Nummernkreise hinterlegt sein.
Für eine Abrechnung braucht der Mandant zusätzlich eine Rundungspräzision ungleich 0 in
der Provisionsmanagement-Einrichtung sowie einen Provisionsvertrag am Verkäufer.

Stammdaten mit Datenschutzsperre — Debitor, Kontakt, Verkäufer oder Ressource — werden
abgewiesen.
