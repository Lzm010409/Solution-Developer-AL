# 05 – Interne GOB-Projektentwicklungsrichtlinien

> **Dieses Dokument steht über allen anderen Regeldokumenten dieses Repos.**
>
> Die Spezifikation fordert unter „Technische Anforderungen" ausdrücklich:
> *„Der Microsoft Style Guide muss eingehalten werden. Die Entwicklungsrichtlinien der GOB
> müssen eingehalten werden."*
>
> Wo eine interne Richtlinie etwas anderes sagt als `10-`…`70-` oder als die Musterlösung
> `SolDev/Final/`, gilt **die interne Richtlinie**.

---

## Geltungsrangfolge

Bei Widersprüchen gilt von oben nach unten:

| Rang | Quelle | Warum |
|---|---|---|
| **1** | **GOB-Projektentwicklungsrichtlinien** (`docs.gob.de`) | Verbindliche interne Vorgabe, von der Spezifikation eingefordert |
| **2** | Die **Spezifikation** der konkreten Aufgabe | Legt Datenmodell, UI und Fachlogik fest |
| **3** | Der **Stil der gestellten Basis-App** | Neues muss sich in Vorhandenes einfügen |
| **4** | **Microsoft AL Style Guide / Best Practices** | Plattformstandard |
| **5** | Die **Musterlösung** `SolDev/Final/` | Architektur- und Musterreferenz |
| **6** | Die Regeldokumente `10-`…`70-` dieses Repos | Ableitung aus 1–5 |

Punkt 5 rangiert bewusst hinter Punkt 4: Die Musterlösung ist Schulungsmaterial und enthält
Artefakte (auskommentierter Code, `//FIXME`, Platzhalter-ToolTips), die nicht dem
Produktivstandard entsprechen. Sie ist Vorbild für **Architektur und Muster**, nicht für
Codehygiene.

---

## Aufbau der internen Richtlinien

Quelle: `https://docs.gob.de/documentation/de-DE/project-development/extensions-project-development.html`

> *„In den Projekt Entwicklungsrichtlinien werden die Rahmenparameter für Individualanpassungen
> und Entwicklungen erläutert."*
>
> *„Unterstützt die Entwicklung von Extensions in Kundenprojekten mit einheitlichen Vorgaben für
> die Werkzeuge sowie die Art und Weise, in der wir Quellcode schreiben."*

Das Regelwerk gliedert sich in zwei Stränge:

```
Projektentwicklungsrichtlinien
│
├── Business Central Extensions (AL)
│   │
│   ├── Entwicklungsrichtlinie AL
│   │   ├── Struktur einer Extension
│   │   ├── Coderichtlinien
│   │   ├── Automatisierte Tests
│   │   ├── Übersetzen einer App
│   │   ├── Checkliste Code Review
│   │   └── Mitentwicklung durch Kunde oder Drittpartner
│   │
│   └── Verwendung der Werkzeuge
│       ├── Azure DevOps
│       ├── git
│       ├── Visual Studio Code
│       └── Xliff Sync
│
└── UAD Plus  (unitop Automated Deployment – Bereitstellung von BC-Umgebungen)
    ├── Quickstart
    ├── UAD-Umgebung oder BC-Sandbox?
    ├── Phasen der Projektvorbereitung
    ├── Neue UAD-Umgebung bereitstellen
    ├── Umgebungserstellung überwachen
    ├── Umgebung administrieren (Kunden, Abonnements, Rollenzuweisung)
    ├── Umgebungsverwaltung und -betrieb
    ├── Infrastruktur Einrichtungen
    └── FAQ
```

### Direktlinks

| Thema | URL |
|---|---|
| Übersicht Projektentwicklung | `…/project-development/extensions-project-development.html` |
| BC Extensions (AL) – Einstieg | `…/al-development-and-tools-guideline/intro-developing-customer-extensions.html` |
| Entwicklungsrichtlinie AL | `…/al-development-and-tools-guideline/al-intro-development-guideline.html` |
| **Struktur einer Extension** | `…/al-development-and-tools-guideline/al-structure-extension.html` |
| **Coderichtlinien** | `…/al-development-and-tools-guideline/al-coding-guidelines.html` |
| **Automatisierte Tests** | `…/al-development-and-tools-guideline/al-test-units.html` |
| **Übersetzen einer App** | `…/al-development-and-tools-guideline/al-translation.html` |
| **Checkliste Code Review** | `…/al-development-and-tools-guideline/al-review-checklist.html` |
| Mitentwicklung durch Kunde/Drittpartner | `…/al-development-and-tools-guideline/al-customer-partner-developing.html` |
| Werkzeuge – Einstieg | `…/al-development-and-tools-guideline/tool-intro.html` |
| Azure DevOps | `…/al-development-and-tools-guideline/tool-azure-devops.html` |
| git | `…/al-development-and-tools-guideline/tool-git.html` |
| Visual Studio Code | `…/al-development-and-tools-guideline/tool-visual-studio-code.html` |
| Xliff Sync | `…/al-development-and-tools-guideline/tool-xliffSync.html` |

Basis-URL: `https://docs.gob.de/documentation/de-DE/project-development/`

---

## ⚠️ Inhaltliche Lücke – Stand dieses Dokuments

**Es liegt nur die Übersichtsseite vor.** Die Unterseiten mit den eigentlichen Regeln wurden
nicht mitgeliefert, und `docs.gob.de` ist nicht ohne Anmeldung erreichbar (HTTP 403).

Damit sind aus dem internen Regelwerk bislang **nur Struktur und Geltungsanspruch** bekannt,
**nicht die Regeln selbst**.

### Was noch fehlt und beschafft werden muss

| Seite | Was dort erwartbar geregelt ist | Wirkt sich aus auf |
|---|---|---|
| **Struktur einer Extension** | Ordneraufbau, Dateibenennung, `app.json`-Vorgaben, ID-Vergabe, Prefix-Regeln, Aufteilung in Apps | `10-naming-and-ids.md` |
| **Coderichtlinien** | Formatierung, Benennung von Variablen und Prozeduren, Label-Konventionen, erlaubte/verbotene Konstrukte, Kommentierung, Fehlerbehandlung | `10-`, `20-`, `30-`, `70-` |
| **Automatisierte Tests** | Testabdeckung, Aufbau der Test-App, Namenskonventionen, verbindliche Test-Libraries | `60-permissions-tests-translation.md` |
| **Übersetzen einer App** | XLIFF-Workflow, Zielsprachen, Umgang mit `Locked`, Einsatz von Xliff Sync | `60-…` |
| **Checkliste Code Review** | Die verbindliche Abnahmeliste | `70-rules-and-checklist.md` |
| **Mitentwicklung durch Kunde/Drittpartner** | Zuständigkeiten, ID-Bereiche, Übergabeprozess | `00-workflow.md` |
| **Werkzeuge** | Azure-DevOps-Prozess, Branch- und Commit-Konventionen, VS-Code-Konfiguration, Analyzer-Einstellungen | `00-`, `70-` |

### Wie diese Lücke geschlossen wird

Eine der folgenden Möglichkeiten:

1. Die Unterseiten als HTML/PDF/Markdown ins Repo legen (z. B. unter `docs/gob-richtlinien/`)
   und dieses Dokument mit dem konkreten Inhalt füllen.
2. Den Text der relevanten Seiten in dieses Dokument übernehmen.
3. Einen authentifizierten Zugang zu `docs.gob.de` bereitstellen.

**Bis dahin gilt für den Agenten:**

> Wenn eine Entscheidung von einer internen Richtlinie abhängen könnte – Formatierung,
> Benennung, Teststrategie, Branch-Konvention, Reviewkriterium – dann **nachfragen**, statt
> die Regel aus `10-`…`70-` als gesichert anzunehmen. Diese Dokumente sind eine begründete
> Ableitung aus Musterlösung und Microsoft-Standard, **kein Ersatz** für das interne Regelwerk.

---

## Was sich aus der Übersichtsseite bereits ableiten lässt

Auch ohne die Unterseiten sind einige Rahmenbedingungen belegt:

### Werkzeugkette

| Werkzeug | Bedeutung für die Arbeit |
|---|---|
| **Azure DevOps** | Quellcodeverwaltung und Prozess laufen über Azure DevOps, **nicht** GitHub. Arbeitsaufträge, Branches und Pull Requests folgen dem dortigen Prozess. |
| **git** | Es gibt eine eigene interne git-Konvention (Branch-Namen, Commit-Format, Merge-Strategie) – vor dem ersten Commit in einem Kundenprojekt nachlesen. |
| **Visual Studio Code** | Vorgegebene IDE, vermutlich mit vorgegebenem Extension-Set und Analyzer-Konfiguration. |
| **Xliff Sync** | Die Übersetzung läuft über die VS-Code-Extension *XLIFF Sync*, nicht über manuelles Editieren der `.xlf`. Das präzisiert Kapitel 35 des Handbuchs und `60-…`. |

Die Dokumentation der Musterlösung selbst verweist bereits auf denselben Quellcode-Host
(`gob.visualstudio.com`), was den Azure-DevOps-Prozess bestätigt.

### Produktkontext

Die Richtlinien gelten für Extensions im Umfeld der **unitop**-Lösungen von
**GOB Software & Systeme GmbH & Co. KG**. „Einheitliche Standards für unitop Lösungen" bedeutet:
Eine Kundenerweiterung fügt sich nicht nur in Business Central ein, sondern auch in die
bestehende unitop-Produktlandschaft.

**Praktische Folge für die Bestandsaufnahme (Phase 0 in `00-workflow.md`):** Prüfe, ob die
gestellte App von unitop-Apps abhängt (`dependencies` in der `app.json`). Falls ja, sind deren
Konventionen und Erweiterungspunkte ebenso zu beachten wie der BC-Standard.

### Rückfragen im Projekt

Kurzfristige Rückfragen aus Projekten werden als **RFA** erfasst (interner Prozess, dokumentiert
im GOB-Organisationsportal). Für den Agenten heißt das: Eine offene fachliche Frage ist kein
Grund zu improvisieren – es gibt einen definierten Weg, sie zu klären.

### UAD Plus – Umgebungen

**UAD Plus** (unitop Automated Deployment) ist das interne Provisioning-Tool für
BC-Umgebungen: containerbasierte Entwicklungs-, Test- und Schulungsumgebungen über ein
Web-Portal.

Relevanz für die Entwicklung: Die Zielumgebung einer Erweiterung wird in der Regel über UAD
Plus bereitgestellt. Ob eine **UAD-Umgebung oder eine BC-Sandbox** verwendet wird, ist eine
bewusste Entscheidung, für die es eine eigene Entscheidungshilfe im Regelwerk gibt. Der Agent
trifft diese Entscheidung nicht selbst.

---

## Verhältnis zu den übrigen Dokumenten dieses Repos

```
05-gob-richtlinien.md   ◀── oberste Autorität, aktuell unvollständig
        │
        │ überschreibt im Konfliktfall
        ▼
10-naming-and-ids.md · 20-table-patterns.md · 30-page-patterns.md
40-posting-architecture.md · 50-integration.md
60-permissions-tests-translation.md · 70-rules-and-checklist.md
        │
        │ leiten ab aus
        ▼
SolDev/Final/  (Muster)     +     learn.microsoft.com  (Plattformstandard)
```

Wenn eine interne Richtlinie nachgetragen wird, die einem dieser Dokumente widerspricht:
**das betroffene Dokument anpassen**, nicht beide Varianten nebeneinander stehen lassen.
