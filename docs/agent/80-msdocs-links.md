# 80 – Microsoft-Learn-Quellen

Alle Links wurden verifiziert. Sie sind die maßgebliche Quelle, wenn dieses Regelwerk und der
Musterlösungscode eine Frage nicht beantworten.

## Wann nachschlagen – Pflicht

Der Agent **muss** in die Dokumentation sehen, bevor er:

- eine **Event-Signatur** schreibt, die er nicht wörtlich aus dem Symbol oder aus
  `SolDev/Final/` übernommen hat
- eine **Property** verwendet, deren Wirkung er nicht sicher kennt
- eine **AL-Methode** verwendet, die er nicht in der Musterlösung gesehen hat
- entscheidet, ob ein Standardobjekt erweiterbar ist (`Extensible`, verfügbare Events)
- eine **Analyzer-Warnung** unterdrücken will

Nicht nachschlagen muss er für Muster, die in `SolDev/Final/` belegt sind – dort ist der Code
die konkretere Quelle.

---

## Einstieg und Referenz

| Thema | Link |
|---|---|
| Entwicklerdokumentation (Startseite) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-landing |
| AL Reference Guide (alle Objekte, Properties, Trigger, Methoden) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-reference-guide |
| Programming in AL | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-programming-in-al |
| Methodenreferenz (Data types and methods) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/library |

## Regeln und Stil

| Thema | Link |
|---|---|
| **Best practices for AL code** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/compliance/apptest-bestpracticesforalcode |
| **Rules and guidelines for AL code** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/compliance/apptest-overview |
| Prefix/Suffix in Extensions | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/compliance/apptest-prefix-suffix |
| Namespaces in AL | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-namespaces-overview |

## Objekte

| Thema | Link |
|---|---|
| Table object | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-table-object |
| Page object | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-page-object |
| Pages overview | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-pages-overview |
| Page types and layouts | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-page-types-and-layouts |
| FactBox zu einer Page hinzufügen | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-adding-a-factbox-to-page |
| Cues erstellen und anpassen | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-cues-action-tiles |
| Permission set object | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-permissionset-object |
| `Permissions`-Property | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-permissions-property |

## Events

| Thema | Link |
|---|---|
| Events in Business Central | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-events-in-al |
| Event types | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-event-types |
| **Subscribing to events** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-subscribing-to-events |
| `EventSubscriber`-Attribut | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/attributes/devenv-eventsubscriber-attribute |
| Events discoverability (welche Events gibt es?) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-events-discoverability |

## Performance

| Thema | Link |
|---|---|
| **Performance article for developers** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/performance/performance-developer |
| Using partial records (`SetLoadFields`) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-partial-records |
| `Record.SetLoadFields` | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/record/record-setloadfields-method |

## Tests

| Thema | Link |
|---|---|
| **Testing the application (Übersicht)** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-testing-application |
| Test codeunits and test methods | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-test-codeunits-and-test-methods |
| Testing with permission sets | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-testing-with-permission-sets |
| `TestPermissions`-Property | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/properties/devenv-testpermissions-property |
| Beispiel: Test der Advanced Sample Extension | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-extension-advanced-example-test |

## Übersetzung

| Thema | Link |
|---|---|
| **Working with translation files** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-work-with-translation-files |
| Translations overview | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-translations-overview |

## Code-Analyse

| Thema | Link |
|---|---|
| Using the code analysis tool | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-using-code-analysis-tool |
| CodeCop analyzer (Regelliste) | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/analyzers/codecop |
| AppSourceCop analyzer | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/analyzers/appsourcecop |
| AL Language extension configuration | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-al-extension-configuration |

## Sonstiges

| Thema | Link |
|---|---|
| **Adding custom filter tokens** | https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/devenv-adding-filter-tokens |

---

## Umgang mit Suchergebnissen

- Die Dokumentation ist versioniert. Prüfe, ob die gelesene Seite zur `application`-Version aus
  der `app.json` passt – insbesondere bei APIs, die kürzlich abgelöst wurden
  (`NoSeriesManagement` → Codeunit `No. Series`, `Promoted*`-Properties → `actionref`).
- Blogbeiträge und Community-Quellen sind **keine** Entscheidungsgrundlage. Sie können einen
  Hinweis geben, aber die Umsetzung folgt der offiziellen Dokumentation oder der Musterlösung.
- Wenn Dokumentation und `SolDev/Final/` sich widersprechen: Die Dokumentation gewinnt bei
  **APIs**, die Musterlösung gewinnt bei **Architektur und Stil**.
