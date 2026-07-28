# Anleitung für Coding Agents – BC-Erweiterungen auf Basis einer Spezifikation

Dieses Repository enthält **kein Produktivprojekt**, sondern das **Regelwerk und die Musterlösung**,
mit denen ein Coding Agent eine bestehende Business-Central-Extension gemäß einer schriftlichen
Spezifikation erweitert.

## Ausgangslage

| | |
|---|---|
| **Was gestellt wird** | Eine fertige Basis-App (z. B. „Provisionsmanagement / Commission Management", Prefix `GOB`, ID-Bereich 63000–63500) **und** eine Spezifikation im GOB-Format. |
| **Was der Agent tut** | Er **erweitert** diese Basis-App um die spezifizierten Funktionen. Er baut die Basis **nicht** neu und schreibt sie nicht um, außer die Spezifikation verlangt es. |
| **Woran er sich hält** | Den BC-Standardpattern. Referenz ist die Musterlösung unter `SolDev/Final/` und die Regeldokumente unter `docs/agent/`. |

## Die goldene Regel

> **Nichts erfinden. Alles ableiten.**
>
> Jede Struktur, die der Agent schreibt, muss eine Entsprechung haben – entweder in der
> vorgefundenen Basis-App, in der Musterlösung `SolDev/Final/`, oder in der
> Microsoft-Standardapplikation. Wenn für eine Anforderung kein Muster existiert, ist das
> ein Grund zurückzufragen, kein Grund zu improvisieren.

## Geltungsrangfolge

Bei Widersprüchen gilt von oben nach unten:

1. **Interne GOB-Projektentwicklungsrichtlinien** → [`05-gob-richtlinien.md`](docs/agent/05-gob-richtlinien.md)
2. Die **Spezifikation** der Aufgabe
3. Der **Stil der gestellten Basis-App**
4. **Microsoft AL Style Guide / Best Practices**
5. Die **Musterlösung** `SolDev/Final/`
6. Die Regeldokumente `10-`…`70-` dieses Repos

⚠️ Von den internen Richtlinien liegt derzeit **nur die Struktur** vor, nicht der Regeltext.
Details und Konsequenzen: [`05-gob-richtlinien.md`](docs/agent/05-gob-richtlinien.md).

## Reihenfolge – verbindlich

1. **Bestandsaufnahme** der gestellten App (Prefix, ID-Bereich, `app.json`, Objektinventar, Stil)
2. **Spezifikation zerlegen** in Objektliste, Feldlisten, Funktionsanforderungen
3. **Musterabgleich**: für jedes Objekt das Pendant in `SolDev/Final/` bestimmen
4. **Implementieren** in der Reihenfolge Setup → Stammdaten → Beleg → Buchung → Integration
5. **Berechtigungen, Übersetzung, Tests** nachziehen
6. **Selbstprüfung** gegen die Checkliste

Details: [`docs/agent/00-workflow.md`](docs/agent/00-workflow.md)

## Regeldokumente

| Dokument | Wofür |
|---|---|
| [`00-workflow.md`](docs/agent/00-workflow.md) | Der verbindliche Arbeitsablauf, inkl. Spec-Parsing und Abbruchkriterien |
| [`05-gob-richtlinien.md`](docs/agent/05-gob-richtlinien.md) | **Interne GOB-Richtlinien: Geltungsrangfolge, Aufbau, Werkzeugkette** |
| [`10-naming-and-ids.md`](docs/agent/10-naming-and-ids.md) | Prefix, IDs, Datei- und Variablennamen, Labels, `app.json` |
| [`20-table-patterns.md`](docs/agent/20-table-patterns.md) | Tabellenarchetypen: Setup, Master, Supplemental, Document, Journal, Ledger Entry, Register, Cue |
| [`30-page-patterns.md`](docs/agent/30-page-patterns.md) | List, Card, Document, Subpage, FactBox, Rollencenter, Profile, PageCustomization |
| [`40-posting-architecture.md`](docs/agent/40-posting-architecture.md) | Die beiden Buchungsketten und ihre Codeunit-Regeln |
| [`50-integration.md`](docs/agent/50-integration.md) | Standard erweitern: TableExt/PageExt/EnumExt, Events, Navigate, Filter Tokens, Dimensionen |
| [`60-permissions-tests-translation.md`](docs/agent/60-permissions-tests-translation.md) | PermissionSet, Test-App, XLIFF |
| [`70-rules-and-checklist.md`](docs/agent/70-rules-and-checklist.md) | Harte Regeln und die Abnahme-Checkliste |
| [`80-msdocs-links.md`](docs/agent/80-msdocs-links.md) | Verifizierte learn.microsoft.com-Quellen und wann sie zu lesen sind |
| [`90-provisionsmanagement-context.md`](docs/agent/90-provisionsmanagement-context.md) | Das konkrete Grundprojekt und das Mapping Seminar → Provision |

## Referenzmaterial in diesem Repo

| Pfad | Inhalt |
|---|---|
| `SolDev/Final/src/` | **Die maßgebliche Musterlösung.** Vollständiges Modul „Seminar Management", Prefix `SMB`. Bei jeder Zweifelsfrage: hier nachsehen. |
| `SolDev/Final/TestSeminarManagement/` | Separate Test-App (Prefix `SMT`) mit Library- und Test-Codeunit |
| `SolDev/Tag01/src/` | Frühe Ausbaustufe: nur Stammdaten und Beleg, ohne Buchung |
| `SolDev/01-Start Doc/`, `SolDev/02_StartJnlPosting/`, `SolDev/03_StartDocPosting/` | Vorgabeobjekte der einzelnen Lernschritte – zeigen, welche Struktur *vor* der Ausprogrammierung stand |
| `SolDev/guA - … GOB Handout.pdf` | Das Schulungsskript: Tabellenarten, Implementierungsreihenfolge, Buchungsrouten-Nomenklatur |
| `SolDev/SolDev0726.xlsx` | Architektur-Schaubilder: Datenfluss Beleg- und Buch.-Blattbuchung, Rabatt- und Währungslogik |

⚠️ Die Ordner `Tag01`, `01-Start Doc`, `02_StartJnlPosting`, `03_StartDocPosting` sind
**Zwischenstände**. Bei widersprüchlichem Code gilt immer `SolDev/Final/`.

## Sprachregelung

- **Dokumentation, Kommentare gegenüber dem Anwender, Commit-Messages:** Deutsch
- **AL-Bezeichner, Captions, ToolTips, Labels im Code:** Englisch
- **Übersetzung:** XLIFF, `de-DE` und `en-US`

## Was der Agent nicht tut

- Objekte der Basis-App umbenennen oder IDs ändern
- Felder aus der Basis-App löschen
- Den Objekt-Prefix wechseln oder den ID-Bereich verlassen
- Eine „elegantere" Architektur als die BC-Standardpattern wählen
- Anforderungen stillschweigend weglassen, umdeuten oder erweitern
