# 00 – Arbeitsablauf

Verbindliche Reihenfolge. Phasen werden nicht übersprungen und nicht vertauscht.

---

## Phase 0 – Bestandsaufnahme der gestellten App

**Bevor eine einzige Zeile geschrieben wird.** Die Basis-App ist gesetzt; ihr Stil ist das
Gesetz für alles, was dazukommt.

### 0.0 Interne Richtlinien heranziehen

Über allem stehen die **GOB-Projektentwicklungsrichtlinien** – die Spezifikation fordert ihre
Einhaltung ausdrücklich. Siehe [`05-gob-richtlinien.md`](05-gob-richtlinien.md) für
Geltungsrangfolge und Aufbau.

Solange deren Regeltext nicht im Repo vorliegt, gilt: Bei jeder Entscheidung, die von einer
internen Vorgabe abhängen könnte – Formatierung, Benennung, Branch- und Commit-Konvention,
Teststrategie, Reviewkriterien, Übersetzungs-Workflow – **nachfragen** statt annehmen.

Prüfe außerdem, ob die gestellte App von **unitop-Apps** abhängt (`dependencies` in der
`app.json`). Falls ja, gelten deren Konventionen und Erweiterungspunkte zusätzlich.

### 0.1 `app.json` lesen

Notiere und halte dich daran:

```jsonc
{
  "id": "…",
  "name": "Commission Management",
  "publisher": "…",
  "idRanges": [ { "from": 63000, "to": 63500 } ],   // ← niemals verlassen
  "application": "…",                               // ← Zielversion der BC-Basisapp
  "runtime": "…",
  "features": [ "NoImplicitWith", "TranslationFile" ],
  "dependencies": [ … ]
}
```

Ergebnis dieser Teilphase: **Prefix**, **freier ID-Bereich**, **Zielversion**, **aktivierte Features**.

### 0.2 Objektinventar erstellen

```
find . -name "*.al" | sort
```

Erfasse pro Objekt: Typ, ID, Name, Datei. Daraus ergibt sich, welche IDs bereits belegt sind
und welche Muster die Basis-App bereits verwendet (Nummernserien? Comment Lines? Setup-Tabelle?).

### 0.3 Hausstil ableiten

Lies mindestens die Setup-Tabelle, eine Stammdatentabelle und die zugehörige Card-Page der
Basis-App und beantworte:

- Werden `DataClassification` je Feld oder je Tabelle gesetzt?
- Steht `ApplicationArea` auf Page- oder auf Feldebene?
- Wie sind Labels benannt (`…Err`, `…Msg`, `…Qst`)?
- Werden `ToolTip`s an der Tabelle oder an der Page gepflegt?
- Gibt es bereits einen Rollencenter-Einstieg, eine PermissionSet, eine Test-App?

**Neue Objekte folgen dem vorgefundenen Stil, nicht dem persönlichen Geschmack** – auch dann,
wenn `SolDev/Final/` es anders macht. Nur wo die Basis-App schweigt, entscheidet die Musterlösung.

### 0.4 Abweichungen dokumentieren

Wenn die Basis-App gegen eine Regel aus `70-rules-and-checklist.md` verstößt: **nicht
stillschweigend reparieren.** Notieren und beim Abschlussbericht erwähnen. Repariert wird nur,
was die aktuelle Aufgabe berührt.

---

## Phase 1 – Spezifikation zerlegen

Die Spezifikationen folgen einem festen Aufbau. Jeder Anforderungsblock ist eine Tabelle:

```
┌──────────────────────────────────────────────────────────────┐
│ <Titel des Features>                                         │
│ Kategorie: <Modul>        | Unterkategorie: <Tabellenart>    │
│ Anforderungsbeschreibung: <Fließtext>                        │
│ Skizzierter Lösungsansatz: <Screenshot / Datenmodell>        │
└──────────────────────────────────────────────────────────────┘
```

### 1.1 „Unterkategorie" ist die Tabellenart

Sie sagt dir direkt, welches Archetyp-Muster aus `20-table-patterns.md` gilt:

| Unterkategorie in der Spec | Archetyp | Muster in `SolDev/Final/` |
|---|---|---|
| Einrichtung | Setup | `src/table/SMBSeminarSetup.Table.al` |
| Stammdaten | Master / Supplemental | `src/table/SMBSeminar.Table.al`, `SMBSeminarRoom.Table.al` |
| Historische Daten / Archiv | Ledger Entry | `src/table/SMBSeminarLedgerEntry.Table.al` |
| Beleg / Bewegungsdaten | Document Header + Line | `src/table/SMBSeminarRegHeader.Table.al` + `…RegLine…` |
| Abrechnung / Stapellauf | Report (ProcessingOnly) + Codeunit | `src/report/SMBCreateSeminarInvoices.Report.al` |
| Menü | Rollencenter / PageExt | `src/page/SMBSeminarRoleCenter.Page.al` |

### 1.2 Formulierungen wörtlich nehmen

Die Specs sind präzise. Typische Formulierungen und ihre technische Bedeutung:

| Formulierung | Bedeutet |
|---|---|
| „nicht editierbare Listenpage" | `Editable = false` auf der List-Page |
| „editierbare Kartenpage" | Card-Page, Standard-Editierbarkeit |
| „als Menüpunkt im Rollencenter verfügbar" | `action` in `area(Sections)` **und** `area(Embedding)` |
| „vgl. Business Central Standard" | Standardobjekt suchen und dessen Struktur übernehmen |
| „das gleiche Benutzererlebnis wie z. B. bei Debitoren" | 1:1 das Standardmuster kopieren, inkl. Feldvorbelegung |
| „Zugehörige Daten … automatisch mit gelöscht" | Löschweitergabe im `OnDelete`-Trigger |
| „Das Löschen darf nicht ausgeführt werden, solange …" | `Error()` im `OnDelete` **vor** der Löschweitergabe |
| „Plausibilitätsprüfung der Felder X und Y" | wechselseitige Prüfung in **beiden** `OnValidate`-Triggern |
| „historisch einsehbar" / „dauerhaft erhalten" | Postenkonzept: nur einfügen, nie löschen, nie ändern |
| „[Bonusaufgabe]" | optional – nur umsetzen, wenn ausdrücklich beauftragt |
| „Der Entwickler soll … ein Array nutzen" | technische Vorgabe, ist bindend |

### 1.3 Bilder auswerten

Der Abschnitt „Skizzierter Lösungsansatz" ist fast immer ein **Screenshot der Zielmaske** oder
ein **Datenmodell-Schaubild**. Daraus liest du ab:
- Feldreihenfolge und Gruppierung auf der Page
- welche Felder überhaupt sichtbar sein sollen
- Fremdschlüsselbeziehungen und Primärschlüssel (`(PK)`)

Wenn ein Bild nicht lesbar ist: nachfragen, nicht raten.

### 1.4 Arbeitsliste erzeugen

Ergebnis von Phase 1 ist eine Tabelle, die du dem Nutzer vorlegst:

| Spec-Abschnitt | Objekttyp | ID | Name | Muster in SolDev | Neu/Änderung |
|---|---|---|---|---|---|

Erst wenn diese Liste steht, beginnt die Implementierung.

---

## Phase 2 – Musterabgleich

Für **jedes** geplante Objekt: benenne die konkrete Datei in `SolDev/Final/`, an der du dich
orientierst, und lies sie **vollständig**, bevor du schreibst.

Findest du kein Muster in `SolDev/Final/`, suche in der Microsoft-Standardapplikation
(Symbol-Dateien / `learn.microsoft.com`). Findest du auch dort keins, ist die Anforderung
unterspezifiziert → nachfragen.

---

## Phase 3 – Implementieren

Feste Reihenfolge, weil jede Stufe auf der vorigen aufsetzt:

```
1. Setup-Tabelle + Setup-Page erweitern      (Nummernserien, Schalter, Rundung)
2. Enums                                      (vor den Tabellen, die sie verwenden)
3. Stammdaten- / Supplemental-Tabellen
4. Zugehörige List- und Card-Pages
5. Belegtabellen (Header + Line)              (falls gefordert)
6. Beleg-Pages (Document + Subpage + List)
7. Journal-, Ledger-Entry-, Register-Tabellen (falls gefordert)
8. Buchungs-Codeunits                         (Check Line → Post Line → Post → Post (Yes/No))
9. Gebuchte Belegtabellen + Pages
10. Integration in den Standard               (TableExt, PageExt, Event-Subscriber, Navigate)
11. Rollencenter, Cues, Profile
12. PermissionSet
13. Übersetzung (XLIFF)
14. Tests
```

Innerhalb jeder Stufe gilt die Reihenfolge aus dem Schulungsskript:

> Felder anlegen und Properties inkl. Caption bearbeiten → Primärschlüssel definieren →
> Table Relations definieren (**dabei immer mitüberlegen, was im `OnDelete` zu passieren hat**)
> → erst danach Funktionalität programmieren.

---

## Phase 4 – Berechtigungen, Übersetzung, Tests

Siehe `60-permissions-tests-translation.md`. Diese Phase ist **kein optionaler Anhang** – eine
Erweiterung ohne PermissionSet-Eintrag ist unvollständig, weil die neuen Objekte für den
Anwender unbenutzbar bleiben.

---

## Phase 5 – Selbstprüfung

Vollständige Checkliste in `70-rules-and-checklist.md` abarbeiten. Erst danach berichten.

---

## Abbruch- und Rückfragekriterien

**Zurückfragen statt raten**, wenn:

- die Spezifikation zwei Anforderungen enthält, die einander widersprechen
- ein Feldname, ein Datentyp oder eine Objekt-ID in der Spec fehlt und sich nicht aus dem
  Datenmodell-Bild ableiten lässt
- die geforderte Objekt-ID außerhalb des `idRanges` der `app.json` liegt
- eine Anforderung einen Umbau der Basis-App verlangt (Feld löschen, PK ändern, Objekt umbenennen)
- kein Standardmuster für die Anforderung existiert

**Weiterarbeiten und dokumentieren** (nicht blockieren), wenn:

- nur ein *Detail* offen ist, das die übrige Arbeit nicht blockiert → Annahme treffen,
  im Bericht benennen
- die Spec einen Standardweg offenlässt („der Trainee darf den Weg selbst wählen") → den
  Weg wählen, den `SolDev/Final/` für den vergleichbaren Fall geht, und ihn benennen

Der letzte Fall ist der Normalfall: Die Spezifikationen geben Datenmodell und UI vor und
lassen die technische Umsetzung bewusst offen — **unter der Bedingung**, dass der gewählte Weg
den Entwicklungsrichtlinien nicht widerspricht und für die Anforderung angemessen ist.

---

## Abschlussbericht

Am Ende berichtest du:

1. Welche Spec-Punkte umgesetzt wurden (mit Objektliste)
2. Welche Annahmen du getroffen hast
3. Was **nicht** umgesetzt wurde und warum (Bonusaufgaben, Blockaden)
4. Welche Altlasten der Basis-App dir aufgefallen sind (ohne sie ungefragt zu reparieren)
5. Ob kompiliert / getestet wurde – und wenn nicht, warum nicht
