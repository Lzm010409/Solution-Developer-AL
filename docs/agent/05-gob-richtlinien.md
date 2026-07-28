# 05 – Interne GOB-Entwicklungsrichtlinien

> **Dieses Dokument steht über allen anderen Regeldokumenten dieses Repos.**
>
> Die Spezifikation fordert unter „Technische Anforderungen" ausdrücklich:
> *„Der Microsoft Style Guide muss eingehalten werden. Die Entwicklungsrichtlinien der GOB
> müssen eingehalten werden."*
>
> Wo eine interne Richtlinie etwas anderes sagt als `10-`…`70-` oder als die Musterlösung
> `SolDev/Final/`, gilt **die interne Richtlinie**.

Quelle: `https://docs.gob.de/documentation/de-DE/project-development/al-development-and-tools-guideline/`

**Vorliegend:** Coderichtlinien (`al-coding-guidelines`), Test Units (`al-test-units`).
**Noch nicht vorliegend:** Struktur einer Extension, Übersetzen einer App, Checkliste Code
Review, Mitentwicklung, Werkzeugseiten. Siehe [Offene Lücken](#offene-lücken).

---

## Geltungsrangfolge

| Rang | Quelle |
|---|---|
| **1** | **GOB-Entwicklungsrichtlinien** (dieses Dokument) |
| **2** | Die **Spezifikation** der konkreten Aufgabe |
| **3** | Der **Stil der gestellten Basis-App** |
| **4** | **Microsoft AL Style Guide / Best Practices** |
| **5** | Die **Musterlösung** `SolDev/Final/` |
| **6** | Die Regeldokumente `10-`…`70-` dieses Repos |

Die Richtlinie nennt als grundsätzlich gültige Quellen: die Prinzipien der objektorientierten
Programmierung und die AL-Dokumentation von Microsoft – *„sofern nicht in der
Entwicklungsrichtlinie eine abweichende oder verfeinernde Regelung getroffen wird"*.

---

## Teil A – Grundprinzip: „Überrasche niemanden. Verstecke nichts."

> *„Generell ist Code so aufzubauen, dass eine spätere Anpassung und Wartung gut möglich ist.
> Ein anderer Entwickler muss in der Lage sein, sich auch ohne spezifische Einweisung in den
> Code einarbeiten zu können."*

### Code muss sich dort befinden, wo man ihn erwartet

**Erlaubt:**

- Eine **Tabelle stellt eine Klasse dar**.
- Die Funktionen der Klasse sind **von der Tabelle aus auffindbar** – bevorzugt als
  Tabellenfunktion, die ihrerseits Codeunits aufruft. Noch tolerabel: Funktionen an namentlich
  erkennbaren, in der Ordnerstruktur zuzuordnenden Orten.
- **Pages haben nur Funktionen, die etwas mit der Darstellung zu tun haben.** Alle Funktionen
  für den Datensatz liegen in der Tabelle und/oder in Codeunits.
- Funktionalitäten im Workspace logisch organisiert (Ordner, Objektnamen, Funktionsnamen).
- **Globale Variablen nur, wenn es technisch nicht anders geht.**

**Verboten:**

- **Sammelcodeunit** für unzusammenhängende Funktionen.
- **Funktionaler Code auf Pages.**
- Funktionen einer Tabelle verstreut in Codeunits, ohne dass man sie finden kann.

### Code muss sich selbst erläutern

**Erlaubt:**

- Auf oberster Ebene werden nur Funktionen mit **sprechenden Namen** aufgerufen – der Prozess
  ist ohne Blick in die Tiefe erkennbar.
- Jede Funktion erfüllt **genau einen Zweck**, ihr Name lässt ihn erahnen.
- Jede Funktion kommt mit **möglichst wenig Verzweigungen** aus; werden welche gebraucht,
  entstehen Unterfunktionen.

**Verboten:**

- Man muss **mehrmals scrollen**, um eine Funktion ganz zu sehen.
- Eine Funktion macht alles selbst: prüfen, verzweigen, abwickeln, Werte zurückgeben, schreiben.
- Eine Funktion heißt, als würde sie prüfen, **schreibt aber auch Daten**.
- Eine Funktion heißt, als täte sie etwas im Verkauf, **erledigt aber etwas im Einkauf**.

### Code muss testbar sein

> *„Lassen sich Funktionen nicht in einem automatisierten Test prüfen, ist das ein Hinweis auf
> eine überarbeitungswürdige Struktur. Das Test-Framework ist in solchen Fällen nicht die
> Ursache – es macht lediglich sichtbar, dass die Funktion neu strukturiert werden sollte."*

---

## Teil B – Codequalität

### CodeCops – keine eigenmächtige Unterdrückung

> **Code muss ohne Warnungen kompilieren.**

- Die aktivierten CodeCops erzeugen Warnungen für unsaubere Konstruktionen. Diese **müssen
  berücksichtigt** werden.
- **Es ist nicht gestattet, eigenständig Warnungen zu unterdrücken** – weder global (Workspace,
  `app.json`, `ruleset.json`) noch durch Pragmas im Code.
- Ausnahmen nur **in Abstimmung mit der Entwicklungsleitung**.
- Einzige reguläre Ausnahme: Warnungen durch **obsolete Strukturen**, für die noch kein Ersatz
  verfügbar ist.

### Pragmas

- Pragmas sind **generell zu meiden**.
- Erlaubter Einsatz beschränkt sich auf anstehende Obsoletions in BC, auf die nicht unmittelbar
  mit Refactoring reagiert werden kann. Weitere Einzelfälle: Freigabe durch Lead Developer.
- Wenn Pragmas eingesetzt werden: **kleinstmögliche Umschließung**. Ganze Codeblöcke zu
  umschließen ist unzulässig, wenn kleinteiliger möglich – sonst bleiben neu auftretende
  Probleme unentdeckt.

### Formatierung

> **Formatierung und Einrückung werden über AutoFormat (`Shift+Alt+F`) erreicht. Davon
> abweichende Formatierung des Quellcodes ist falsch.**

### Region Directive

**Die Nutzung von `#region` ist nicht erlaubt.**

```al
// VERBOTEN
#region Generic Item
…
#endregion
```

### Data Classification

- Tabellen und Tabellenfelder (originär **und** in Table Extensions) benötigen
  `DataClassification`.
- Das Property muss vorhanden **und mit einem konkreten Wert belegt** sein.
- **`ToBeClassified` ist unzulässig.**
- Bei temporären Tabellen (`TableType = temporary`) muss `DataClassification = SystemMetaData`
  gesetzt werden.

Die Klassifizierung wird für den Anwender zum Vorschlag für sein DSGVO-Reporting – also
inhaltlich passend wählen, nicht pauschal.

### Partielle Datensätze

> **Die Nutzung ist obligatorisch.**

`SetLoadFields()` ist verbindlich, nicht optional. Der Entwickler entscheidet über den konkreten
Einsatz, der Reviewer kann ihn einfordern oder übersteuern. Besonders Schleifen und Reports
profitieren, aber auch Einzelzugriffe werden schneller.

### `IsEmpty` vor Datenzugriff – **geänderte Regel**

> *„Entgegen der bisherigen Vorgehensweise, Find-Abfragen mit `if not IsEmpty() then` zu
> beginnen oder mit `if IsEmpty() then exit;` vorzeitig zu verlassen, hat dieses Vorgehen
> Performance-Nachteile. […] Daher unterlassen wir die zusätzliche Abfrage nun ebenfalls:
> **Vor `Get`- oder `Find`-Befehlen wird keine `IsEmpty`-Abfrage gemacht.**"*

**Ausnahme:** Vor `DeleteAll` und `ModifyAll` **soll** `IsEmpty` weiterhin genutzt werden – dort
bringt es Performancevorteile.

```al
// FALSCH – doppelter Zugriff
if not Line.IsEmpty() then
    if Line.FindSet() then
        repeat … until Line.Next() = 0;

// RICHTIG
if Line.FindSet() then
    repeat … until Line.Next() = 0;

// RICHTIG – reine Existenzprüfung ohne folgenden Find bleibt zulässig
if not Line.IsEmpty() then
    Error(LineExistErr);

// RICHTIG – vor DeleteAll/ModifyAll weiterhin erwünscht
if not CommentLine.IsEmpty() then
    CommentLine.DeleteAll();
```

---

## Teil C – Präfix und Namenskonventionen

### Präfix

- Für GOB ist das Kürzel **`GOB`** bei Microsoft registriert; es wird **durchgängig als Präfix**
  verwendet (nicht als Suffix).
- **Objektnamen:** Präfix plus **ein Leerzeichen** → `codeunit 5059450 "GOB Address Format"`
- **Feldnamen:** nur in **Table Extensions auf BaseApp-Tabellen** ist der Präfix Pflicht →
  `field(5059560; "GOB Bill-to Cust.-No. Member"; Code[20])`
- Feldnummern in Table Extensions müssen aus dem eigenen Nummernkreis kommen **und über den
  gesamten Workspace eindeutig sein** – es darf keine zweite Table Extension auf dieselbe
  Tabelle mit derselben Feldnummer geben.

### Präfix bei Erweiterungen des Microsoft-Standards

Der Präfix ist **immer** zu verwenden, wenn der Microsoft-Standard erweitert wird:

- `global procedures` in Table-, Page-, Report- und Enum-Extensions
- Zugriffsmodifikatoren in Extension-Objekten, z. B. `protected var`
- **neue Controls oder Control-Gruppen** auf Pages und Reports

### Technische Namenskonventionen

- Elemente werden **sprechend** benannt.
- Elemente sind **immer englisch** benannt.
- **Ungarische Notation ist verboten** (`recItem`, `decSomeNumber`, `parSomething`, `locItem`) –
  kein Präfix für Typ oder Kontext.
- Teile dürfen sprechend abgekürzt werden.

### Key-Namenskonventionen

- **Jeder Primärschlüssel bekommt den Namen `PK`.**
- **Sekundärschlüssel werden fortlaufend `Key01`, `Key02`, …** benannt – in Extension-Objekten
  `GOBKey01`, `GOBKey02`, …
- Ein zweckgebundener, sprechender Name ist nur zulässig, wenn der Schlüssel **genau einem**
  Zweck dient und Mehrfachverwendung nicht absehbar ist. **Ausnahmefall** – der Reviewer kann
  ihn unterbinden.

> ⚠️ Die Musterlösung `SolDev/Final/` verstößt hiergegen: Sie verwendet Schlüsselnamen wie
> `key(DocNo; …)`, `key(Nav; …)`, `key(Inv; …)`, `key(SK5; …)`. Richtig wäre `Key01`, `Key02`, …

### Inhaltliche Namenskonventionen

Die Benennung folgt den üblichen Microsoft-Konventionen. Namen zentraler Tabellen und Masken
gibt teilweise der **Product Owner** vor. Abweichungen in der Umsetzung:

- **kosmetisch** (Einzahl/Mehrzahl, Rechtschreibung) → Entwickler informiert den PO
- **schwerwiegend** (missverständlicher Branchenbegriff, Kollision mit BC-Standard) → gemeinsam
  mit dem PO eine Lösung finden

---

## Teil D – Dokumentation im Quellcode

### Objekte und Änderungen

- **Keine Dokumentations-Trigger.**
- Die Kommentierung von Objekten erfolgt über **git** und die Verbindung zu konkreten
  Entwicklungstätigkeiten (Commits, Pull Requests).
- **Zu ändernder Quellcode wird nicht auskommentiert, sondern überschrieben bzw. gelöscht.**
  Die Sicherung des Zustands vor und nach der Änderung leistet git.

> ⚠️ Die Musterlösung enthält umfangreiche auskommentierte Codeblöcke (z. B. das gesamte
> Ende von `SMBSemJnlPostLine.Codeunit.al` und `SMBCreateSeminarInvoices.Report.al`). Das ist
> nach dieser Regel **unzulässig** und darf nicht nachgeahmt werden.

### Kommentare zum Verständnis

Zulässig **nur**, wenn ein Codeabschnitt funktionell erläutert werden muss – etwa bei einer
komplexen Kalkulation.

**Unzulässig**, wenn der Kommentar durch bessere Struktur überflüssig würde:

> *„In aller Regel ist ein Kommentar falsch, der durch das Auslagern eines Codeblocks in eine
> sprechend benannte Funktion ersetzt werden kann."*
>
> *„Wenn Kommentare benötigt werden, um den Programmablauf verstehen zu können, ist der Code
> schlecht strukturiert. Die Kommentierung ist damit unzulässig."*

### Funktionskommentare

- Grundsätzlich erlaubt, **in Englisch** zu verfassen.
- **Erlaubt**, wenn es dem Verständnis wirklich hilft – etwa bei einer globalen Funktion mit
  zentraler Rolle.
- **Verboten**, wenn Name und Parameter bereits alles verraten. `CheckSetupNoSeries()` braucht
  keine Erläuterung; `CreateCustomerFromMyWebShop(CustomerTemplateCode: Code[20])` kann
  profitieren, wenn Voraussetzungen gelten.
- In lokalen/internen Funktionen nicht verboten, aber im Review ggf. zu begründen.

Format (XML-Doc):

```al
/// <summary>
/// Sets the Calculated Pension Result in the Pension Buffer (Sub) Header
/// </summary>
/// <param name="PensionBufferHeader">PensionBuffer Header to calculate. Temp Records not supported.</param>
procedure RunPensionCalculation(var PensionBufferHeader: Record "GOB Pension Buffer Header")
```

> **Es ist nicht erlaubt, in einem Kommentar Referenzen zu Feldnamen und/oder Objekten
> herzustellen.** Beispiel für einen unzulässigen Kommentar: *„Die Funktion macht …, wenn im
> Feld ‚GOB My cool field' …"* – man kann später nicht feststellen, ob das Feld noch existiert
> oder anders heißt. Besser: den **Prozess** beschreiben, den die Funktion unterstützt.

### Kommentare in Tests

In Unit Tests sind Kommentare **zwingend erforderlich**, im
`Feature/Scenario/Given/When/Then`-Schema. Siehe Teil G.

---

## Teil E – Pages und UI

### Promoted Actions – **wichtige Einschränkung**

> **Actions und Groups, die wir Standard-Pages hinzufügen, werden nie promoted entwickelt.**
> Das gilt auch, wenn der PO das fordert. Ausnahmen nur mit der Entwicklungsleitung.

**In Page Extensions auf Standard-Pages verboten:**

```al
area(Promoted)                          // ✘ verboten
actionref(RefName; ActionName)          // ✘ verboten
```

**Generell verboten** sind die Legacy-Properties `Promoted`, `PromotedIsBig`,
`PromotedCategory`, `PromotedOnly`.

**Ausnahme:** Wenn eine Standard-Action durch eine eigene ersetzt werden muss, soll der Zustand
des Standards wiederhergestellt werden.

**Erlaubt:** In **eigenen** Pages dürfen Actions und Groups promoted entwickelt werden.

Promoted Actions auf Standard-Pages werden stattdessen **je Branche über Profile und
PageCustomization** implementiert.

> ⚠️ Das korrigiert `30-page-patterns.md`: Das dortige `pageextension`-Beispiel mit
> `addlast(Promoted)` auf der Verkäuferkarte ist nach dieser Regel unzulässig.

### Importance

Felder werden **immer ohne explizite Änderung der Importance** entwickelt. Nur auf ausdrückliche
Forderung des PO erlaubt:

```al
Importance = Additional;
Importance = Promoted;
Importance = Optional;
```

> ⚠️ Das korrigiert `30-page-patterns.md` und die Musterlösung, die `Importance = Promoted` /
> `Additional` durchgängig verwenden.

### ApplicationArea und UsageCategory

- **Alle Elemente, die in der GUI sichtbar werden, benötigen `ApplicationArea`** – betrifft
  Pages und Reports. Ohne das Property werden sie nicht sichtbar.
- Für unitop: `ApplicationArea = GOBunitop;`. Bei Elementen im Bereich Service und Produktion
  kann fallweise `Suite` verwendet werden.
- **`UsageCategory`** muss je Page und Report gesetzt sein, sofern der Anwender das Objekt über
  die Suche finden können soll.

> **Für Projekte:** Welche `ApplicationArea` in einem Kundenprojekt zu verwenden ist, geht aus
> der vorliegenden Seite nicht hervor (`GOBunitop` ist die unitop-Ausprägung). **Im Zweifel
> nachfragen** oder den Wert der gestellten Basis-App übernehmen.

### Permission Sets

> **Für jede Extension müssen Berechtigungssätze mitgeliefert werden. Es ist unzulässig, eine
> Extension ohne Permission Sets freizugeben.**

---

## Teil F – Event Subscriber

### Keine unnötige Ausführung

Früh prüfen, ob das Szenario überhaupt zutrifft, und früh aussteigen:

```al
if not IsRelevantStuff() then
    exit;

if not RunTrigger() then          // Insert/Modify/Delete-Trigger nicht ungewollt auslösen
    exit;

if Rec.IsTemporary() then         // temporäre Datensätze nicht wie echte behandeln
    exit;
```

Der `IsTemporary()`-Ausstieg ist besonders wichtig bei kaskadierendem Löschen oder
Aktualisieren – sonst werden leicht echte Daten zerstört.

### Keine Prüfung auf Lizenz oder Zugriffsrechte

> **`SkipOnMissingLicense` und `SkipOnMissingPermission` müssen immer `false` sein.**

Subscriber müssen zur Laufzeit mit Fehler abbrechen, wenn Lizenz oder Berechtigung fehlen –
sonst werden Programmteile unerkannt nicht durchlaufen und Daten werden inkonsistent.

```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterTestSalesLine, '', false, false)]
//                                                                                       ^^^^^  ^^^^^
//                                                                                       immer false
```

> ⚠️ Das korrigiert `50-integration.md` und die Musterlösung: Der Filter-Token-Subscriber in
> `SMBMySeminarFilterToken.Codeunit.al` verwendet `'', true, true` – nach dieser Regel
> unzulässig.

### Kein Code in Subscribern

> **Ein Subscriber ist auf einen Funktionsaufruf zu beschränken.**

Begründung: Direkt implementierte Logik lässt sich in Projekten nicht durch
Individualanpassungen oder Workarounds übersteuern.

```al
// FALSCH
[EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Address 2', false, false)]
local procedure OnAfterValidate_Address2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
var
    EqualAddressErr: Label 'The second address cannot be the same as the first one.',
        Comment = 'de-DE=Die zweite Adresse darf nicht gleich der ersten Adresse sein.';
begin
    if Rec."Address 2" = Rec.Address then
        Error(EqualAddressErr);
end;

// RICHTIG
[EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Address 2', false, false)]
local procedure OnAfterValidate_Address2(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
begin
    PreventAddressEqualsAddress2(Rec, xRec, CurrFieldNo);
end;

local procedure PreventAddressEqualsAddress2(var Customer: Record Customer; var OldCustomer: Record Customer; CurrFieldNo: Integer)
var
    EqualAddressErr: Label 'The second address cannot be the same as the first one.',
        Comment = 'de-DE=Die zweite Adresse darf nicht gleich der ersten Adresse sein.';
    IsHandled: Boolean;
begin
    OnBeforePreventAddressEqualsAddress2(Customer, OldCustomer, CurrFieldNo, IsHandled);
    if IsHandled then
        exit;
    if Customer."Address 2" = Customer.Address then
        Error(EqualAddressErr);
end;

[IntegrationEvent(false, false)]
local procedure OnBeforePreventAddressEqualsAddress2(var Customer: Record Customer; var OldCustomer: Record Customer; CurrFieldNo: Integer; var IsHandled: Boolean)
begin
end;
```

Beachte das `IsHandled`-Muster: Die ausgelagerte Funktion publiziert ihrerseits ein
Integration Event, damit Projekte die Logik übersteuern können.

### Subscriber vs. Trigger bei Feldern – **Empfehlung: Trigger**

Statt `OnAfterValidateEvent` zu abonnieren, wird der Trigger direkt in der **Table Extension**
empfohlen:

```al
tableextension 50111 "CustomerExt" extends Customer
{
    fields
    {
        modify("Address 2")
        {
            trigger OnAfterValidate()
            begin
                PreventAddressEqualsAddress2(Rec, xRec, CurrFieldNo);
            end;
        }
    }
}
```

**Vorteile:**
- Der Code ist leichter wiederzufinden – pro App darf es nur **eine** Table Extension geben,
  aber beliebig viele Subscriber in verschiedenen Codeunits.
- Zugriff auf `protected var` der Tabelle ist möglich, in einem Subscriber nicht.

Auch hier gilt: Triggercode kurz halten und schnell in Unterfunktionen verzweigen.

**Dasselbe gilt für Pages:** Validate-Trigger möglichst in der **Page Extension** im
`modify(Control)`-Block. Verfügbar sind dort `OnBeforeValidate()`, `OnAfterValidate()`,
`OnLookup()`, `OnDrilldown()`, `OnAssistEdit()`, `OnAfterAfterLookup()`.

### Fehlende Publisher im Standard

Fehlt ein geeigneter Publisher, kann nur Microsoft ihn ergänzen. Anforderungen unter
`https://github.com/Microsoft/ALAppExtensions` hinterlegen und verfolgen.

Dasselbe gilt für **interne Funktionen**: Nur `external`-Funktionen sind aus Extensions
ansprechbar (Extension Target `Extension`).

---

## Teil G – Confirm-Dialoge

**Alle Confirm-Abfragen müssen denselben Aufbau haben:**

1. Erster Teil: der Umstand und die Konsequenz des Bejahens
2. Danach **doppelter Zeilenumbruch** (`\\`)
3. Dann die Frage **„Do you want to continue?"**
4. Bei Verneinung mit Benutzerinteraktion: Fehler **„Canceled by user."**
5. Ohne Benutzerinteraktion: leerer `Error` (Default, wie im Microsoft-Standard)
6. Jedes Confirm muss **ohne GUI beeinflussbar** sein – über Publisher, `GuiAllowed()` oder
   Codeunit `Confirm Management`

Die englischen Texte **„Do you want to continue"** und **„Canceled by user"** sind
verpflichtend.

```al
local procedure ChangeDimensionNormInVariants(Item: Record Item)
var
    ItemVariant: Record "Item Variant";
    ConfirmManagement: Codeunit "Confirm Management";
    ChangeVariantsQst: Label 'If you change this field, all related item variants are also changed.\\Do you want to continue?',
        Comment = 'de-DE=Wenn Sie dieses Feld ändern, werden alle zugehörigen Artikelvarianten ebenfalls geändert.\\Möchten Sie fortfahren?';
    CanceledByUserErr: Label 'Canceled by user.',
        Comment = 'de-DE=Benutzerabbruch.';
begin
    ItemVariant.SetRange("Item No.", Item."No.");
    if ItemVariant.FindSet() then
        if ConfirmManagement.GetResponse(ChangeVariantsQst, false) then
            repeat
                ItemVariant.Validate("GOB Dimension Norm Code", Item."GOB Dimension Norm Code");
                OnBeforeModifyVariants(Item, ItemVariant);
                ItemVariant.Modify(true);
            until ItemVariant.Next() = 0
        else
            Error(CanceledByUserErr);
end;
```

**Beachte auch die Übersetzungsform:** `Comment = 'de-DE=…'` direkt am Label. Das ist der in
den Beispielen durchgängig verwendete Weg. Wie er sich zum XLIFF-Workflow verhält, klärt die
noch fehlende Seite „Übersetzen einer App".

---

## Teil H – Automatisierte Tests

Quelle: `al-test-units.html`

### Leitlinien

In Kundenprojekten skalieren Fehler anders als im Standard oder in unitop – wegen der geringen
Zahl an Installationen (meist genau eine) und der geringeren Prozesstiefe vieler
Individualanpassungen. Daher gilt:

- **Tests müssen wirtschaftlich sein**
- **Tests müssen Kernprozesse absichern**
- **Tests können Nebenprozesse absichern, wenn sie dabei wirtschaftlich sind**

**Kernprozesse** sind die Prozesse des Kunden, bei deren Ausfall er sein Kerngeschäft nicht
abwickeln kann.

### Wann ein Test wirtschaftlich ist

Eine der folgenden Bedingungen genügt (oft treffen mehrere zu):

- **Test-driven Development beschleunigt die Entwicklung**, die Tests entstehen ohnehin. Typisch
  bei Funktionalitäten,
  - für die komplexe Datenaufbereitung zum manuellen Testen nötig wäre,
  - oder deren Umsetzung wegen hoher Komplexität mit Unsicherheit behaftet ist.
- Die Funktionalität **erstreckt sich über viele Schritte und Komponenten**, deren Integration
  abzusichern aufwändige Nacharbeiten verhindert – besonders wenn die Bestandteile eigenständige
  Lebenszyklen haben.
- Die Funktionalität **hat sich als fehleranfällig erwiesen**. Mit dem Bugfixing lassen sich
  künftige Nacharbeiten eindämmen.

### Verbindlichkeit

> **Automatisierte Tests sind für Kundenprojekte empfohlen, aber nicht verpflichtend
> vorgeschrieben.** Die Qualitätssicherung kann auch durch manuelle Tests erfolgen. Im Projekt
> legt die **Entwicklungsleitung oder der zuständige Lead Developer** die Nutzung fest.

> ⚠️ Das korrigiert `70-rules-and-checklist.md`, das Tests als Pflichtpunkt führt. Ob Tests
> gefordert sind, ist eine **Projektentscheidung** – im Zweifel nachfragen.

### Technische Organisation

- Tests werden in **eigenen Extensions** bereitgestellt.
- Die Test Extension liegt in einem **eigenen Ordner im Workspace** mit dem Namensschema:

  ```
  [NAME DER EXTENSION][ ]Test
  ```

  Also z. B.: `Meine Extension Test`

- Sie folgt allen sonstigen Strukturvorgaben.
- Sie hat eine **Abhängigkeit von der zu testenden Extension** und **normalerweise keine
  weiteren**. Ausnahme: Abhängigkeiten zu **Test Apps von Microsoft und ggf. unitop** sind
  immer erlaubt.

### Aufbau von Tests

Tests werden in Codeunits geschrieben und folgen dem
**`Feature/Scenario/Given/When/Then`-Schema**:

| Kommentar | Bedeutung |
|---|---|
| `// [FEATURE]` | Das Feature, für das die **gesamte Test-Codeunit** ausgelegt ist |
| `// [Scenario]` | Das konkrete Szenario **der einzelnen Testfunktion** |
| `// [Given]` | Der Ausgangszustand (ggf. mehrere Kommentare); danach folgen die Funktionen, die ihn herstellen |
| `// [When]` | Der Ablauf des Szenarios; danach die konkreten Funktionen |
| `// [Then]` | Das erwartete Ergebnis; danach die Prüfungen |

Beispiel aus unitop:

```al
codeunit 50101 "GOB Webservice Management Test"
{
    // [FEATURE] [GOB Webservice Management]
    Subtype = Test;

    trigger OnRun()
    begin
    end;

    var
        Manager: Codeunit "GOB Webservice Management";
        Mock: Codeunit "GOB Webservice Comm. Mock";
        ResponseGen: Codeunit "GOB Webservice Mock Resp. Gen.";
        ExpCodeTxt: Label '1234';
        ExpMsgTxt: Label 'Error';
        ExpectedResponse: Text;

    [Test]
    procedure TestTrialIsCreated()
    var
        Assert: Codeunit Assert;
        CustomerId: Text;
        State: Boolean;
        ExpCustIdTxt: Label 'E68C256B-EDB8-4E11-B070-FB56FCD9D260';
    begin
        // [Scenario] Start a trial period for a feature app
        // [Given] The trial is started successful

        Setup();
        ResponseGen.CreateTrialSuccessResponse(ExpCustIdTxt, ExpectedResponse);
        Mock.AddResponseWithContent(Mock.StartTrialUrl(), ExpectedResponse, 200, true);

        // [When] CreateTrial is called
        State := Manager.CreateTrial('3a765acd-…', '40716111-…', true, CustomerId);

        // [Then] CreateTrial should return true
        Assert.IsTrue(State, 'Request failed');
        // [Then] CreateTrial should write the customer id contained in the response to CustomerId
        Assert.AreEqual(ExpCustIdTxt, CustomerId, 'CustomerId not set correctly');
        // [Then] LastHttpStatusCode should be set
        Assert.AreEqual(200, Manager.GetLastHttpStatusCode(), 'Http status not set correctly');
    end;
}
```

**Beachte:** Jedes `// [Then]` steht **unmittelbar vor der zugehörigen Prüfung**, nicht
gesammelt am Anfang. Jede Assertion trägt eine aussagekräftige Fehlermeldung.

---

## Teil I – Weitere Regelbereiche

Diese Bereiche sind in der Richtlinie ausführlich geregelt. Sie betreffen primär die
unitop-Produktentwicklung, sind aber bei Projekterweiterungen zu beachten, sobald der jeweilige
Fall eintritt.

### Code-Duplikation

Wenn Code von Microsoft oder einem Partner nicht erweiterbar ist und dupliziert werden muss:

- Die Duplikation **ersetzt niemals** eine tragbare Lösung über normale Extension-Mechanismen.
- Sie muss **technisch eindeutig begründbar** sein (z. B. nicht erweiterbarer Objekttyp).
- Sie wird **je Funktion per Kommentar kenntlich gemacht**, nach diesem Schema:

  ```al
  //This code has been copied from:
  //Module:
  //Object:
  //Version:
  //Reason:
  //Last re-merge with original source:
  ```

  Die Kommentare sind bei Aktualisierung des kopierten Codes zu pflegen.
- Der kopierte Code muss **nicht** allen Vorgaben folgen – die Struktur darf zum späteren
  Vergleich mit dem Original erhalten bleiben.
- **Duplizierter Code wird immer mit Tests untersetzt.**

### Obsoletion

Einmal released, dürfen Schemata und öffentliche Codestrukturen **nicht gelöscht**, sondern
müssen obsolet gesetzt werden.

```al
[Obsolete('Was wrong and replaced by...','2020.3.x.x')]
procedure Send(…)

// an Objekten und Feldern:
ObsoleteState = Pending;
ObsoleteReason = 'Moved to new field "SPFieldType" of type Enum';
ObsoleteTag = '2020.3.x.x';
```

- Der Tag ist in der Regel die Version, in die gerade hineinentwickelt wird.
- Hängt die Entfernung vom Zeitplan **Microsofts** ab, lautet der Tag **`DependsOnMS`** statt
  einer Version.
- Status zuerst `Pending`; erst nach **mindestens einem Jahr** auf `Removed` ändern oder löschen.
- Bei Schemaänderungen prüfen, ob **Upgrade-Code** nötig ist.
- Kann ein Objekttyp nicht obsoleted werden (aktuell: Page Extension), werden **alle enthaltenen
  Elemente** obsoleted.

Hintergrund: PTE-Erweiterungen in Kundenprojekten sollen nach einem Update nicht stillschweigend
brechen.

### Upgrade-Code

Wird mit **Upgrade-Tags** gearbeitet, Aufbau:
`[CompanyPrefix]-[ID]-[Description]-[YYYYMMDD]`

| Bestandteil | Inhalt |
|---|---|
| `CompanyPrefix` | `GOB` – **im Projekt `PTE`** |
| `ID` | Nummer des PBI oder Bugs aus Azure DevOps |
| `Description` | frei wählbar |
| `YYYYMMDD` | z. B. `20221004` |

Ablauf der Upgrade-Routine – **zwingend** in dieser Reihenfolge:

1. Prüfen, ob der Upgrade-Tag bereits in der Upgrade-Tag-Tabelle steht → wenn ja, kein Upgrade
2. Andernfalls Upgrade-Code ausführen
3. Upgrade-Tag eintragen und damit den Vorgang protokollieren

Die Tag-Definitionen liegen pro App in einer eigenen Codeunit nach dem Schema
`[Prefix][App-Kürzel] Upgrade Tag Definition`, die zusätzlich einen Event-Subscriber auf
`OnGetPerCompanyUpgradeTags` enthält. Bei **Neuinstallation** müssen alle Upgrade-Tags als
erledigt eingetragen werden, damit Upgrade-Code nicht ungewollt läuft.

Für **manuelle Upgrades** gibt es einen eigenen Mechanismus (`GOB Manual Upgrade`) mit
festen Regeln – u. a.: Die Upgrade-Routine darf **nicht** im selben Objekt liegen wie die
Funktion, die das manuelle Upgrade erstellt, und muss in einer normalen Codeunit
(nicht `Subtype = Upgrade`) oder einem Report stehen.

### API Pages

- Namensschema: Page-Name mit `API` und Versionsnummer, `APIGroup` beginnt mit `unitop`,
  `APIPublisher = 'gob'`, camelCase, `EntityName` Singular, `EntitySetName` Plural,
  `Caption` = `EntitySetName`.
- **Verbindlich für alle API Pages – auch projektspezifische:**
  - Das Feld **`SystemId`** der Quelltabelle muss auf der Page exponiert werden.
  - **`ODataKeyFields = SystemId`** muss gesetzt sein.

  Fehlt eines von beidem, sind Aktualisieren und Löschen über die API unmöglich.
- **Keine `TableRelation` in API Pages** – im Zusammenhang mit `Expand` führt das zu falschen
  Ergebnissen. Stattdessen separate Page Parts einbinden.
- Ein Part darf wegen des eindeutigen Entitätsnamens **nur einmal pro API Page** verwendet
  werden.

### Standard durch Eigenentwicklung ersetzen

Wird eine Standard-Action durch eine eigene ersetzt, soll immer **entweder** die Standard-
**oder** die eigene Action sichtbar sein. Die Standard-Action wird mit
`Enabled = not <Modul>Active` **und** `Visible = not <Modul>Active` deaktiviert, damit der
Anwender sie nicht per Personalisierung zurückholen kann. Die Steuerung erfolgt **nie pauschal
über die Installation**, sondern immer abhängig vom aktivierten Modul – und **pro Kunde, nicht
pro Benutzer**.

---

## Offene Lücken

Diese Seiten des Regelwerks liegen weiterhin **nicht** vor:

| Seite | Was dort erwartbar geregelt ist | Betrifft |
|---|---|---|
| **Struktur einer Extension** | Ordneraufbau, Dateibenennung, `app.json`, ID-Vergabe, Aufteilung in Apps | `10-naming-and-ids.md` |
| **Übersetzen einer App** | XLIFF-Workflow, Zielsprachen, Xliff Sync, Verhältnis zu `Comment = 'de-DE=…'` | `60-…` |
| **Checkliste Code Review** | Die verbindliche Abnahmeliste | `70-…` |
| **Mitentwicklung durch Kunde/Drittpartner** | Zuständigkeiten, ID-Bereiche, Übergabe | `00-workflow.md` |
| **Azure DevOps / git / VS Code / Xliff Sync** | Branch- und Commit-Konventionen, Analyzer-Konfiguration | `00-`, `70-` |

Ebenfalls unklar und im Projekt zu klären:

- Welche **`ApplicationArea`** in Kundenprojekten zu verwenden ist (`GOBunitop` ist die
  unitop-Ausprägung).
- Der Abschnitt **„Option vs. Enum"** ist in der vorliegenden Fassung ohne Inhalt
  („Die Verwendung wird folgendermaßen entschieden:" – danach bricht der Text ab).

### Geklärt: Präfix im Projekt

Die Upgrade-Tag-Regel nennt „`GOB` – oder im Projekt `PTE`". Für das Provisionsmanagement
ist entschieden: **Im Projekt gilt `PTE`.** Das deckt sich mit der gestellten Basis-App, die
durchgängig `PTE` verwendet — obwohl die Spezifikation `GOB` fordert.

`GOB` bleibt der bei Microsoft registrierte Präfix der unitop-Produktentwicklung; alle
Zitate und Codebeispiele **dieses** Dokuments stammen aus der Richtlinie und zeigen ihn
deshalb weiterhin. In den Regeldokumenten `10-`…`70-` und in allem, was neu entsteht,
gilt `PTE`.

**Bis diese Lücken geschlossen sind:** Bei Entscheidungen, die davon abhängen könnten,
**nachfragen** statt annehmen.

---

## Verhältnis zu den übrigen Dokumenten

```
05-gob-richtlinien.md   ◀── oberste Autorität
        │
        │ überschreibt im Konfliktfall
        ▼
10- · 20- · 30- · 40- · 50- · 60- · 70-
        │
        │ leiten ab aus
        ▼
SolDev/Final/  (Muster)   +   learn.microsoft.com  (Plattformstandard)
```

### Bekannte Verstöße der Musterlösung gegen dieses Regelwerk

Die Musterlösung `SolDev/Final/` ist Schulungsmaterial. Sie zeigt Architektur und Muster
korrekt, verletzt aber an mehreren Stellen die GOB-Coderichtlinien. **Nicht nachahmen:**

| Verstoß | Wo | Richtige Form |
|---|---|---|
| `DataClassification = ToBeClassified` | alle `tableextension`-Felder | konkreter Wert |
| Fehlende `DataClassification` | u. a. `SMBSeminarRegHeader`, `SMBSeminarLedgerEntry` | Property setzen |
| Auskommentierte Codeblöcke | `SMBSemJnlPostLine`, `SMBCreateSeminarInvoices`, `SMBSeminarRoom` | löschen, git nutzen |
| `//FIXME`-Marker | `SMBSeminarLedgerEntry`, `SMBSeminarRegister` | auflösen |
| Sprechende Key-Namen | `key(DocNo;…)`, `key(Nav;…)`, `key(SK5;…)` | `PK`, `Key01`, `Key02`, … |
| `true, true` am Subscriber | `SMBMySeminarFilterToken` | `false, false` |
| `Importance = Promoted/Additional` | `SMBSeminarCard`, `SMBSeminarRegistration` | weglassen, außer PO fordert es |
| Platzhalter-Texte | `ToolTip = 'Bla bla.'`, `'bla.'` | echte Texte |
| Nichtssagende Label-Comments | `Comment = '%1%2'` | Platzhalter erklären |
| `Text000`-Label | `SMBSemJnlCheckLine` | sprechender Name |
| Pragma zur Warnungsunterdrückung | `SMBSourceCodeSetup.TableExt` (`PTE0002`) | nur mit Freigabe |
