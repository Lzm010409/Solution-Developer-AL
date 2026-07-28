# Software Sales Management Test

Test-Extension zu *Software Sales Management*. Nach GOB-Richtlinie Teil H liegen Tests in
einer eigenen Extension mit dem Namensschema `[Name der Extension] Test`.

| | |
|---|---|
| Prefix | `PTE` |
| ID-Bereich | 63701 – 63750 |
| Version | 1.0.0.0 |
| Dependencies | Software Sales Management 1.0.0.0, Library Assert |

## Objekte

| Typ | ID | Name | Zweck |
|---|---|---|---|
| Codeunit | 63701 | Softw. Change Test Lib | legt Einrichtung, Stammdaten und Testdaten an |
| Codeunit | 63702 | Softw. Sales Mgt. Test | die Testfälle (`Subtype = Test`) |

## Abgedeckte Szenarien

Die Spezifikation nennt drei Themen, jedes ist ein Testfall:

| Test | Prüft |
|---|---|
| `TestTemplateValuesAreCopiedIntoSoftwareChange` | dass beim Setzen des Vorlagecodes alle Werte der Vorlage in die Anpassung übernommen werden |
| `TestCopySoftwareChangeCopiesAllGroupsAndComments` | dass beim Kopieren alle drei Feldgruppen und die Bemerkungen in der Kopie ankommen, die Kopie aber eine eigene Nummer bekommt |
| `TestPostingAsksTheUserForConfirmation` | dass die Buchungsfunktion den Anwender fragt und bei Ablehnung mit dem Standardabbruch endet |

Alle Tests folgen dem Schema `Feature / Scenario / Given / When / Then`; jede Prüfung trägt
eine eigene Fehlermeldung.

## Aufbau

Die Library legt ihre Stammdaten **direkt** an, statt Microsoft-Testbibliotheken zu nutzen.
Dadurch bleibt die einzige externe Abhängigkeit `Library Assert`, wie es die Richtlinie für
Test-Extensions vorsieht. `CreateSoftwareSalesSetup` ist mehrfach aufrufbar.

Der Kopiertest ruft die Kopier-Codeunit direkt und nicht den Report — die Kopierlogik liegt
genau deshalb in einer eigenen Codeunit und nicht im Report.

Der Buchungstest lehnt die Rückfrage über einen `ConfirmHandler` ab und prüft anschließend
zweierlei: dass überhaupt gefragt wurde, und dass der Abbruch mit der vorgesehenen Meldung
endet. Er bucht also bewusst nicht durch.

## Ausführen

1. Im Ordner `.alpackages` werden die Microsoft-Symbole, `Software Sales Management` und
   `Library Assert` benötigt. Letzteres über `AL: Download Symbols` holen.
2. Die App publizieren und die Tests über die Seite **Test Tool** starten.

Die Test-Extension gehört nicht in eine Produktivumgebung.
