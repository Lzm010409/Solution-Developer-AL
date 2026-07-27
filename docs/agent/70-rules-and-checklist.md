# 70 – Harte Regeln und Abnahme-Checkliste

---

## Teil 1 – Harte Regeln

### Sprache und Syntax

| Regel | Begründung |
|---|---|
| `"features": [ "NoImplicitWith" ]` – kein `with`-Statement | Abgelöst; `Rec.` explizit schreiben |
| Reservierte Schlüsselwörter klein schreiben (`begin`, `end`, `if`, `then`, `var`) | AL-Styleguide |
| Nach dem Variablennamen: Doppelpunkt, ein Leerzeichen, Typ | AL-Styleguide |
| Vier Leerzeichen Einrückung, keine Tabs | Konsistenz |
| Ein Objekt pro Datei | Auffindbarkeit |
| Keine Wildcards (`%`, `&`) in Feld- und Variablennamen | Kompatibilität |

### Datenzugriff

| Regel | Statt | Warum |
|---|---|---|
| `IsEmpty()` verwenden | `Count() = 0` oder `FindFirst()` | Kein Datensatz wird geladen |
| `SetLoadFields()` vor `Get`/`Find`/`FindSet` | alles laden | Nur benötigte Spalten |
| `ReadIsolation(IsolationLevel::ReadUncommitted)` bei reinen Existenzprüfungen | Standardisolation | Weniger Sperren |
| `FindSet()` + `repeat … until Next() = 0` | `Find('-')` | Aktuelle Syntax |
| `FindSet(true)` nur, wenn wirklich geändert wird | `FindSet(true)` überall | Sperrverhalten |
| `Reset()` vor dem Neuaufbau von Filtern | Filterreste | Fehlerquelle Nr. 1 |
| `SetCurrentKey()` setzen, wenn nach Nicht-PK-Feldern gefiltert wird | impliziter PK-Scan | Performance |
| Einrichtungssätze **einmal** pro Lauf lesen und cachen | `Setup.Get()` in der Schleife | DB-Last |

```al
// Cache-Muster
local procedure GetSetup()
begin
    if not SetupRead then
        Setup.Get();
    SetupRead := true;
end;
```

### Fehlerbehandlung

| Regel | |
|---|---|
| `TestField()` für Pflichtfelder statt eigener `if`-Prüfung | |
| `FieldError()` statt `Error()`, wenn der Fehler ein bestimmtes Feld betrifft | |
| Fehlertexte als `Label` mit `Comment` | |
| `ErrorInfo.Create()` in Buchungsroutinen | Aufklappbare, aktionsfähige Meldungen |
| Kein `Error()` in Check-Line-Codeunits ohne `ErrorInfo` | Standardkonvention |

### UI-Zugriff

| Regel | |
|---|---|
| Jeder `Message`, `Confirm`, `Dialog` wird mit `GuiAllowed()` geschützt | Sonst brechen Tests und Hintergrundläufe |
| Kein UI in Check-Line- und Post-Line-Codeunits | Architekturregel |
| Kein UI in Event-Subscribern, die in Buchungsläufen feuern | |
| `CurrFieldNo <> 0` prüfen, wenn nur bei Anwendereingabe gefragt werden soll | |

### Strings

| Regel | |
|---|---|
| `CopyStr()` beim Zuweisen von `UserId()` und anderen längeren Texten | Sonst Overflow-Fehler |
| `MaxStrLen()` statt fester Längen | Bricht nicht bei Feldänderungen |
| `StrSubstNo()` statt Stringverkettung für Meldungen | Übersetzbarkeit |

```al
LedgerEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(LedgerEntry."User ID"));
```

### Posten

| Regel | |
|---|---|
| Posten werden **nie** gelöscht | Postenkonzept |
| Posten werden **nie** direkt aus einer Page eingefügt oder geändert | |
| Posten entstehen **ausschließlich** über die `Jnl.-Post Line`-Codeunit | |
| Postenseiten sind `Editable = false` | |

### Aufgabenspezifische Verbote

Das Schulungsskript verbietet in einzelnen Übungen ausdrücklich bestimmte Konstrukte, um die
mengenbasierte Denkweise zu erzwingen:

> **Verbotene Anweisungen:** `Record.Count()`, `Record.Next()`, `for/do`, `repeat/until`,
> `while/do`

Wo eine Aufgabe das vorgibt, ist die Lösung ein **Filter plus `IsEmpty()`/`FindFirst()`**, nicht
eine Schleife. Beispiel „Prüfen, ob der Teilnehmer bereits angemeldet ist" – mit genau einem
Lesezugriff und ohne dass der Datensatz sich selbst findet:

```al
Line.SetRange("Document No.", "Document No.");
Line.SetRange("Participant Contact No.", "Participant Contact No.");
Line.SetFilter("Line No.", '<>%1', "Line No.");      // ← sich selbst ausschließen
if not Line.IsEmpty() then
    Error(AlreadyRegisteredErr, FieldCaption("Participant Contact No."));
```

Diese Verbote gelten **nur**, wo die Aufgabe sie nennt. In Buchungsroutinen sind Schleifen
selbstverständlich zulässig.

### Was nie passieren darf

- Objekte oder Felder der Basis-App löschen oder umbenennen
- Primärschlüssel bestehender Tabellen ändern
- Den ID-Bereich der `app.json` verlassen
- Standardobjekte per `modify` funktional aushebeln
- Auskommentierten Code einchecken
- `//FIXME` oder `//TODO` ohne Rücksprache hinterlassen
- Text-Literale statt `Label`
- Felder ohne `Caption`, sichtbare Felder ohne `ToolTip`

> Die Musterlösung in `SolDev/Final/` enthält an einigen Stellen auskommentierte
> Codeblöcke, `//FIXME`-Marker und Platzhalter-ToolTips wie `'Bla bla.'`. Das sind
> **Schulungsartefakte, keine Vorbilder.** Übernimm die Struktur, nicht diese Rückstände.

---

## Teil 2 – Abnahme-Checkliste

Vor dem Abschlussbericht vollständig abarbeiten.

### A – Vollständigkeit gegenüber der Spezifikation

- [ ] Jeder Anforderungsblock der Spec hat eine Entsprechung im Code
- [ ] Jedes Feld aus dem Datenmodell-Schaubild existiert mit dem vorgegebenen Typ
- [ ] Jede geforderte Page existiert mit dem geforderten Typ und der geforderten Editierbarkeit
- [ ] Jede geforderte Action existiert an jeder genannten Stelle
- [ ] Alle geforderten Prüfungen (Plausibilität, Löschbedingungen) sind implementiert
- [ ] Als „Bonusaufgabe" gekennzeichnete Punkte: umgesetzt **oder** im Bericht als bewusst
      ausgelassen benannt

### B – Objektkonventionen

- [ ] Alle neuen Objekte tragen den Prefix
- [ ] Alle IDs liegen im `idRanges` der `app.json`
- [ ] Keine ID-Kollision mit bestehenden Objekten
- [ ] Buchungs-Codeunits folgen der Endziffern-Konvention
- [ ] Dateinamen entsprechen `<Prefix><Name>.<Typ>.al`
- [ ] Ein Objekt pro Datei, im passenden Ordner

### C – Tabellen

- [ ] Jedes Feld hat `Caption` und `DataClassification`
- [ ] Primärschlüssel definiert, `Clustered = true`
- [ ] `TableRelation` überall gesetzt, wo ein Fremdschlüssel vorliegt
- [ ] Zu **jeder** `TableRelation` wurde geprüft, was im `OnDelete` zu passieren hat
- [ ] Löschprüfungen stehen **vor** der Löschweitergabe
- [ ] `fieldgroups` (`DropDown`, `Brick`) an Stammdatentabellen
- [ ] `LookupPageId` / `DrillDownPageId` gesetzt
- [ ] Sekundärschlüssel für Filter, Sortierungen und FlowFields vorhanden
- [ ] `SumIndexFields` an Schlüsseln, über die summiert wird
- [ ] Belegtabellen: `OnRename` verhindert
- [ ] Postentabellen: `GetLastEntryNo()` und `CopyFrom…()` vorhanden

### D – Pages

- [ ] `UsageCategory` + `ApplicationArea` gesetzt, wo die Page auffindbar sein soll
- [ ] Card-Pages, die nur aus Listen geöffnet werden: `UsageCategory = None`
- [ ] **Jedes sichtbare Feld** hat einen `ToolTip`
- [ ] **Jede** Action hat `Caption`, `Image` und `ToolTip`
- [ ] Promotion ausschließlich über `area(Promoted)` mit `actionref`
- [ ] Setup-Page: `InsertAllowed = false`, `DeleteAllowed = false`, `OnOpenPage` legt den Satz an
- [ ] Postenseiten: `Editable = false`
- [ ] Subpages: `AutoSplitKey = true`, `DelayedInsert = true`
- [ ] FactBoxes über `SubPageLink` verknüpft, ggf. `Provider` gesetzt

### E – Buchung (falls Teil der Aufgabe)

- [ ] Check-Line-Codeunit: kein UI, kein Lesen/Schreiben der Buch.-Blattzeile
- [ ] Post-Line-Codeunit: `Permissions`-Property gesetzt, ruft Check Line
- [ ] Post (Yes/No): nur Rückfrage und Weitergabe
- [ ] Post-Codeunit: Prüfen → Nummer ziehen → `Commit` → sperren → gebuchten Kopf → Zeilen
- [ ] `LockTable`-Reihenfolge konsistent
- [ ] Zeilen laufen über eine temporäre Tabelle
- [ ] Herkunftscode (`Source Code`) wird gesetzt
- [ ] Fortschrittsanzeige mit `GuiAllowed()` geschützt
- [ ] Register wird geschrieben
- [ ] Dimensionen (`Dimension Set ID`) werden durchgereicht

### F – Integration

- [ ] Event-Subscriber sind `local`, Signaturen exakt
- [ ] `ReadPermission()` geprüft, wo fremde Tabellen gezählt werden
- [ ] Navigate eingebunden (falls gebuchte Belege oder Posten entstehen)
- [ ] Rollencenter-Einträge angelegt (`Sections` **und** `Embedding`, falls gefordert)
- [ ] Standardfelder nur ausgeblendet, nicht entfernt

### G – Berechtigungen, Übersetzung, Tests

- [ ] **Jedes** neue Objekt im PermissionSet (`tabledata` = RIMD **und** `table` = X)
- [ ] Alle Texte sind `Label`/`Caption`, keine Literale
- [ ] Labels mit Platzhaltern haben einen aussagekräftigen `Comment`
- [ ] Technische Labels mit `Locked = true`
- [ ] `de-DE.xlf` gepflegt, Fachbegriffe konsistent
- [ ] Tests für Plausibilitätsprüfungen, Löschbedingungen und die Kernberechnung
- [ ] Handler für alle Dialoge, die in Tests auftreten

### H – Codequalität

- [ ] Kompiliert ohne Fehler
- [ ] Keine CodeCop-/AppSourceCop-Warnungen (oder begründet per `#pragma` unterdrückt)
- [ ] Kein auskommentierter Code
- [ ] Keine offenen `//TODO` / `//FIXME`
- [ ] Keine Platzhaltertexte (`'Bla'`, `'…'`) in Captions oder ToolTips
- [ ] Prozeduren sind `local`, wo sie nicht von außen gebraucht werden
- [ ] Wiederholte Logik ist in eine Prozedur ausgelagert

---

## Teil 3 – Code-Analyzer

In `.vscode/settings.json` bzw. `AL-Go`-Konfiguration aktivieren:

```jsonc
{
    "al.codeAnalyzers": [ "${CodeCop}", "${UICop}", "${PerTenantExtensionCop}" ]
}
```

`AppSourceCop` zusätzlich, wenn die App für AppSource gedacht ist.

Warnungen werden **behoben**, nicht unterdrückt. Nur wenn eine Unterdrückung fachlich begründet
ist, eng begrenzt per Pragma:

```al
#pragma warning disable PTE0002
        field(63000; "GOB Commission"; Code[10])
#pragma warning restore PTE0002
```

Häufige Regeln, die in diesem Umfeld greifen:

| Regel | Bedeutung |
|---|---|
| `AA0008` | Klammern bei Funktionsaufrufen erforderlich |
| `AA0072` | Namenskonvention für Variablen |
| `AA0074` | Label-Namen sollen sprechend sein (kein `Text000`) |
| `AA0137` | Variable deklariert, aber nicht verwendet |
| `AA0206` | Variable zugewiesen, aber nicht verwendet |
| `AA0214` | `Modify()` ohne vorheriges `Get()`/`Find()` |
| `AA0470` | Platzhalter im Label ohne erklärenden `Comment` |
| `PTE0001` / `PTE0002` | Objekt-/Feld-ID außerhalb des erlaubten Bereichs für PTEs |
