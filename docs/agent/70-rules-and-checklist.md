# 70 – Harte Regeln und Abnahme-Checkliste

> ⚠️ **Diese Checkliste ersetzt nicht die interne „Checkliste Code Review"** der
> GOB-Projektentwicklungsrichtlinien. Sie ist eine Ableitung aus Musterlösung und
> Microsoft-Standard. Liegt die interne Checkliste vor, hat sie Vorrang –
> siehe [`05-gob-richtlinien.md`](05-gob-richtlinien.md).

---

## Teil 1 – Harte Regeln

### Sprache und Syntax

| Regel | Begründung |
|---|---|
| `"features": [ "NoImplicitWith" ]` – kein `with`-Statement | Abgelöst; `Rec.` explizit schreiben |
| Reservierte Schlüsselwörter klein schreiben (`begin`, `end`, `if`, `then`, `var`) | AL-Styleguide |
| Nach dem Variablennamen: Doppelpunkt, ein Leerzeichen, Typ | AL-Styleguide |
| **Formatierung ausschließlich über AutoFormat (`Shift+Alt+F`)** | GOB: abweichende Formatierung ist falsch |
| Ein Objekt pro Datei | Auffindbarkeit |
| Keine Wildcards (`%`, `&`) in Feld- und Variablennamen | Kompatibilität |
| **Keine ungarische Notation** (`recItem`, `decAmount`, `locCustomer`) | GOB-Namenskonvention |
| **`#region` / `#endregion` verboten** | GOB-Richtlinie |
| **Bezeichner immer englisch und sprechend** | GOB-Namenskonvention |
| **`DataClassification` an jeder Tabelle und jedem Feld, `ToBeClassified` unzulässig** | GOB-Richtlinie; temporäre Tabellen: `SystemMetaData` |
| **Primärschlüssel heißt `PK`, Sekundärschlüssel `Key01`, `Key02`, … (`GOBKey01` in Extensions)** | GOB-Key-Konvention; sprechende Namen nur im Ausnahmefall |

### Datenzugriff

| Regel | Statt | Warum |
|---|---|---|
| **Kein `IsEmpty()` vor `Get`/`Find`/`FindSet`** | `if not X.IsEmpty() then if X.FindSet() …` | GOB-Richtlinie seit 2024: doppelter Zugriff kostet Performance |
| `IsEmpty()` **vor `DeleteAll`/`ModifyAll`** | direkt löschen | Dort ist die Prüfung erwünscht |
| `IsEmpty()` als reine **Existenzprüfung** (ohne folgenden Find) | `Count() = 0` | Kein Datensatz wird geladen |
| `SetLoadFields()` vor `Get`/`Find`/`FindSet` – **obligatorisch** | alles laden | GOB-Richtlinie: Nutzung partieller Datensätze ist Pflicht |
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

```al
// FALSCH – GOB-Richtlinie: kein IsEmpty vor Find
if not Line.IsEmpty() then
    if Line.FindSet() then
        repeat … until Line.Next() = 0;

// RICHTIG
if Line.FindSet() then
    repeat … until Line.Next() = 0;

// RICHTIG – reine Existenzprüfung, kein Find folgt
if not Line.IsEmpty() then
    Error(LineExistErr);

// RICHTIG – vor DeleteAll/ModifyAll weiterhin erwünscht
if not CommentLine.IsEmpty() then
    CommentLine.DeleteAll();
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
| **Confirm-Aufbau: Sachverhalt + `\\Do you want to continue?`; bei Nein `Canceled by user.`** | GOB-Richtlinie, englische Texte verpflichtend |
| **Confirm über `Codeunit "Confirm Management"`.`GetResponse()`** | muss ohne GUI beeinflussbar sein |

### Event-Subscriber

| Regel | |
|---|---|
| **`SkipOnMissingLicense` und `SkipOnMissingPermission` immer `false`** | GOB-Richtlinie – sonst laufen Programmteile unerkannt nicht |
| **Kein Code im Subscriber – nur ein Funktionsaufruf** | Projekte müssen die Logik übersteuern können |
| Früher Ausstieg: `if not IsRelevantStuff() then exit;` | |
| `if not RunTrigger() then exit;` | Trigger nicht ungewollt auslösen |
| `if Rec.IsTemporary() then exit;` | sonst werden echte Daten durch temporäre zerstört |
| **Feldvalidierung bevorzugt per `modify(...)` + `OnAfterValidate()` in der TableExtension** statt `OnAfterValidateEvent`-Subscriber | GOB-Empfehlung: auffindbarer, Zugriff auf `protected var` |

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
- **Auskommentierten Code einchecken** – zu ändernder Code wird überschrieben oder gelöscht, die Historie leistet git
- `//FIXME` oder `//TODO` ohne Rücksprache hinterlassen
- Text-Literale statt `Label`
- Felder ohne `Caption`, sichtbare Felder ohne `ToolTip`
- **Warnungen eigenmächtig unterdrücken** – weder per Pragma noch über `app.json`/`ruleset.json`; nur mit Freigabe der Entwicklungsleitung
- **Funktionalen Code auf Pages** unterbringen – Pages tragen nur Darstellungslogik
- **Sammelcodeunits** für unzusammenhängende Funktionen anlegen
- **Kommentare, die Feld- oder Objektnamen referenzieren** („… wenn im Feld ‚GOB X' …")
- **Kommentare, die durch bessere Struktur überflüssig wären**

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

### B2 – GOB-Coderichtlinien

- [ ] Kompiliert **ohne Warnungen**; keine eigenmächtig unterdrückten Cops
- [ ] Kein `#region`, keine ungarische Notation, keine Text-Literale
- [ ] Formatierung per AutoFormat
- [ ] `DataClassification` überall konkret gesetzt (nie `ToBeClassified`)
- [ ] Schlüssel heißen `PK` / `Key01` / `Key02` (bzw. `GOBKey01`)
- [ ] Kein `IsEmpty()` vor `Get`/`Find`; `SetLoadFields()` eingesetzt
- [ ] Pages tragen nur Darstellungslogik
- [ ] Jede Funktion erfüllt genau einen Zweck und ist ohne Scrollen lesbar
- [ ] Subscriber enthalten nur einen Funktionsaufruf, `false, false` am Attribut
- [ ] Confirm-Dialoge nach dem vorgegebenen Schema
- [ ] Auf Standard-Pages **kein** `area(Promoted)` / `actionref`, keine `Importance` ohne PO-Vorgabe
- [ ] Präfix auch an neuen Controls, Control-Gruppen und globalen Prozeduren in Extensions

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
