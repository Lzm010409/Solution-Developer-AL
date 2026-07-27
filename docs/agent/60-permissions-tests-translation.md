# 60 – Berechtigungen, Tests, Übersetzung

Diese drei Themen sind kein Anhang. Eine Erweiterung ohne Berechtigungseintrag ist für den
Anwender unbenutzbar, eine ohne Übersetzung erfüllt die Spec nicht, und eine ohne Test ist
nicht nachweisbar korrekt.

---

## PermissionSet

Die Spezifikationen fordern: „Es muss ein Vorschlag für ein Berechtigungskonzept mit
ausgeliefert werden."

### Aufbau

```al
permissionset 63000 "GOB Commission Management"
{
    Assignable = true;
    Caption = 'Commission Management';

    Permissions =
        // Tabellendaten – Lese-/Schreibrechte
        tabledata "GOB Commission Mgt. Setup" = RIMD,
        tabledata "GOB Commission Type" = RIMD,
        tabledata "GOB Commission Contract" = RIMD,
        tabledata "GOB Commission Comment Line" = RIMD,
        tabledata "GOB Commission Ledger Entry" = RIMD,

        // Tabellenobjekte – Ausführungsrecht
        table "GOB Commission Mgt. Setup" = X,
        table "GOB Commission Type" = X,
        table "GOB Commission Contract" = X,
        table "GOB Commission Comment Line" = X,
        table "GOB Commission Ledger Entry" = X,

        // Pages
        page "GOB Commission Mgt. Setup" = X,
        page "GOB Commission Types" = X,
        page "GOB Commission Contract List" = X,
        page "GOB Commission Contract Card" = X,
        page "GOB Commis. Contract Factbox" = X,
        page "GOB Commission Comment List" = X,
        page "GOB Commission Comment Sheet" = X,
        page "GOB Commission Ledger Entries" = X,

        // Codeunits und Reports
        codeunit "GOB Calculate Commission" = X,
        codeunit "GOB Post Commission Ledg Entry" = X,
        report "GOB Calc. Commissions - batch" = X;
}
```

### Regeln

| Regel | |
|---|---|
| **Jedes** neue Objekt gehört ins PermissionSet | Sonst ist es für Anwender nicht erreichbar |
| `tabledata … = RIMD` **und** `table … = X` | Zwei getrennte Einträge pro Tabelle |
| `Assignable = true` | Nur beim zuweisbaren Set; Bausteine sind `false` |
| Postentabellen | `RIMD` fürs Set, aber `Editable = false` auf der Page |
| Erweiterung eines bestehenden Sets | `permissionsetextension` statt eines neuen Sets |

### Mehrere Rollen

Fordert die Spec abgestufte Rechte (Sachbearbeiter vs. Manager), dann:

```al
permissionset 63001 "GOB Commission Objects"
{
    Assignable = false;              // Baustein
    Permissions = table … = X, page … = X, codeunit … = X;
}

permissionset 63002 "GOB Commission Read"
{
    Assignable = true;
    Caption = 'Commission Management – Read';
    IncludedPermissionSets = "GOB Commission Objects";
    Permissions = tabledata "GOB Commission Contract" = R, …;
}

permissionset 63003 "GOB Commission Edit"
{
    Assignable = true;
    Caption = 'Commission Management – Edit';
    IncludedPermissionSets = "GOB Commission Objects";
    Permissions = tabledata "GOB Commission Contract" = RIMD, …;
}
```

### `Permissions`-Property an Codeunits

Unabhängig vom PermissionSet brauchen Buchungs-Codeunits die Property auf Objektebene, damit sie
Posten schreiben dürfen, auch wenn der aufrufende Anwender nur Leserecht hat:

```al
codeunit 63032 "GOB Commis. Jnl.-Post Line"
{
    Permissions = tabledata "GOB Commission Ledger Entry" = rimd,
                  tabledata "GOB Commission Register" = rimd;
```

Muster: `SolDev/Final/src/permissionset/SMBSemRegistration.PermissionSet.al`

---

## Tests

### Eigene Test-App

Tests liegen in einer **separaten App** mit eigenem Prefix und eigenem ID-Bereich. Sie hängt per
`dependencies` an der zu testenden App.

```jsonc
{
  "id": "…",
  "name": "Test Commission Management",
  "publisher": "…",
  "version": "1.0.0.0",
  "dependencies": [
    { "id": "<id der Basis-App>", "name": "Commission Management", "publisher": "…", "version": "…" },
    { "id": "dd0be2ea-f733-4d65-bb34-a28f4624fb14", "publisher": "Microsoft", "name": "Library Assert", "version": "…" },
    { "id": "23de40a6-dfe8-4f80-80db-d70f83ce8caf", "publisher": "Microsoft", "name": "Test Runner", "version": "…" },
    { "id": "5d86850b-0d76-4eca-bd7b-951ad998e997", "publisher": "Microsoft", "name": "Tests-TestLibraries", "version": "…" },
    { "id": "e7320ebb-08b3-4406-b1ec-b4927d3e280b", "publisher": "Microsoft", "name": "Any", "version": "…" }
  ],
  "idRanges": [ { "from": 63900, "to": 63999 } ],
  "features": [ "NoImplicitWith" ]
}
```

Die Versionsnummern der Microsoft-Test-Abhängigkeiten müssen zur BC-Zielversion passen.
Vorlage: `SolDev/Final/TestSeminarManagement/app.json`.

### Library-Codeunit

Trennt Testdaten-Erzeugung von den Testfällen. Jede Testdatenart bekommt eine `Create…`-Prozedur.

```al
codeunit 63901 "GOB Library - Commission Mgt."
{
    procedure CreateCommissionSetup(var CommissionSetup: Record "GOB Commission Mgt. Setup")
    var
        LibraryNoSeries: Codeunit "Library - No. Series";
        NoSeriesCodeTxt: Label 'TESTCOM', Locked = true;
        StartingNoTxt: Label 'COM00001', Locked = true;
    begin
        LibraryNoSeries.CreateNoSeries(NoSeriesCodeTxt);
        LibraryNoSeries.CreateNoSeriesLine(NoSeriesCodeTxt, 1, StartingNoTxt, '');

        if not CommissionSetup.Get() then begin
            CommissionSetup.Init();
            CommissionSetup.Insert();
        end;
        CommissionSetup."Commission Contract Nos." := NoSeriesCodeTxt;
        CommissionSetup.Modify();
    end;

    procedure CreateCommissionContract(var CommissionContract: Record "GOB Commission Contract")
    var
        Any: Codeunit Any;
    begin
        Clear(CommissionContract);
        CommissionContract.Init();
        CommissionContract."No." := '';
        CommissionContract.Insert(true);                    // Nummernserie greift
        CommissionContract.Validate(Description, CommissionContract."No.");
        CommissionContract.Validate("Commission %", Any.IntegerInRange(1, 100));
        CommissionContract.Modify();
    end;
}
```

Nützliche Standard-Libraries: `Library - Utility` (`GenerateRandomCode20`, `GetNewLineNo`),
`Library - ERM`, `Library - Sales`, `Library - Marketing`, `Library - No. Series`,
`Library - Resource`, Codeunit `Any` (Zufallswerte), Codeunit `Assert`.

### Test-Codeunit

```al
codeunit 63900 "GOB Test Commission Mgt."
{
    Subtype = Test;
    TestPermissions = Disabled;

    // [FEATURE] [Commission Management]

    [Test]
    procedure TestCommissionContractDates()
    var
        CommissionContract: Record "GOB Commission Contract";
        LibraryCommission: Codeunit "GOB Library - Commission Mgt.";
        CommissionSetup: Record "GOB Commission Mgt. Setup";
    begin
        // [SCENARIO] Ending date before starting date must be rejected
        // [GIVEN] A new commission contract
        LibraryCommission.CreateCommissionSetup(CommissionSetup);
        LibraryCommission.CreateCommissionContract(CommissionContract);

        // [WHEN] Starting date is set and ending date is set before it
        CommissionContract.Validate("Starting Date", WorkDate());

        // [THEN] Validation fails
        asserterror CommissionContract.Validate("Ending Date", WorkDate() - 1);
    end;

    [Test]
    [HandlerFunctions('CommissionPostConfirmHandler,GenericMessageHandler')]
    procedure TestCalculateCommission()
    begin
        // [SCENARIO] …
    end;

    [ConfirmHandler]
    procedure CommissionPostConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        Reply := true;
    end;

    [MessageHandler]
    procedure GenericMessageHandler(MessageText: Text[1024])
    begin
    end;
}
```

### Konventionen

| Konvention | |
|---|---|
| `Subtype = Test` | Macht die Codeunit zur Test-Codeunit |
| `// [FEATURE] […]` | Ordnet die Codeunit einem Feature zu |
| `// [SCENARIO] …` | Beschreibt den Testfall |
| `// [GIVEN] / [WHEN] / [THEN]` | Gliedert den Testkörper |
| `asserterror` | Erwartet einen Fehler – die Zeile *muss* fehlschlagen |
| `[HandlerFunctions('…')]` | Fängt Dialoge ab; ohne sie schlägt jeder Dialog den Test |
| Handler-Typen | `ConfirmHandler`, `MessageHandler`, `PageHandler`, `ModalPageHandler`, `ReportHandler`, `RequestPageHandler`, `StrMenuHandler` |
| Max. 100 Testmethoden pro Codeunit, Laufzeit < 2 min | Microsoft-Empfehlung |

### Was zu testen ist

Mindestens:

1. Jede in der Spec beschriebene **Plausibilitätsprüfung** (positiv und negativ)
2. Jede **Löschbedingung** („darf nicht gelöscht werden, solange …")
3. Der **Berechnungslauf**: korrekter Betrag, korrektes Vorzeichen bei Gutschriften,
   korrekte Rundung, keine Doppelerfassung
4. Die **Buchung**: erzeugt sie Posten, Register und gebuchten Beleg?

### TestPages

Für Tests, die die Oberflächenlogik einbeziehen:

```al
var
    CommissionContractCard: TestPage "GOB Commission Contract Card";
begin
    CommissionContractCard.OpenNew();
    CommissionContractCard.Description.SetValue('Test');
    CommissionContractCard."Commission %".SetValue(10);
    CommissionContractCard.Close();
```

Verfügbar: `OpenNew()`, `OpenEdit()`, `OpenView()`, `GotoKey()`, `New()`, `Close()`, `Trap()`,
`First()/Last()/Next()/Previous()`, `Field.AssertEquals()`, `Field.SetValue()`,
`Field.AsType()`, `Action.Invoke()`.

Muster: `SolDev/Final/TestSeminarManagement/`

---

## Übersetzung

Die Spezifikationen fordern: „Es wird mehrsprachig in Deutsch und Englisch entwickelt
(Sprachcode de-DE und en-US)."

### Vorgehen

1. In der `app.json`:

```jsonc
"features": [ "NoImplicitWith", "TranslationFile" ]
```

2. Alle Captions, ToolTips und Labels **auf Englisch** im Code schreiben. Das ist die
   Quellsprache.

3. Beim Build entsteht `Translations/<AppName>.g.xlf` mit einem `<source>`-Element je Text.

4. Diese Datei kopieren nach `Translations/<AppName>.de-DE.xlf`, dort
   `target-language="de-DE"` setzen und je `<source>` ein `<target>` ergänzen:

```xml
<trans-unit id="Table 63020 - Field 3 - Property 2130029695" …>
  <source>Commission Percentage</source>
  <target>Provision in Prozent</target>
</trans-unit>
```

5. `en-US` ist die Quellsprache und braucht in der Regel keine eigene Datei.

### Regeln

| Regel | |
|---|---|
| **Keine `CaptionML`/`ToolTipML`** | Abgelöst durch XLIFF |
| **Keine Text-Literale** | Alles, was der Anwender sieht, ist ein `Label` oder eine `Caption` |
| `Locked = true` | An Labels, die **nicht** übersetzt werden dürfen (Tokens, Codes, technische Werte) |
| `Comment` an jedem Label mit Platzhaltern | Sonst kann der Übersetzer die Reihenfolge nicht anpassen |
| Die `.g.xlf` wird generiert | Nicht von Hand pflegen; nur die Sprachdateien pflegen |
| Übersetzungs-IDs nicht ändern | Ein umbenanntes Feld verliert seine Übersetzung |

### Fachbegriffe – Zuordnung

Die Spec gibt die deutschen Begriffe vor und den englischen AL-Begriff:

| Deutsch (UI) | Englisch (AL) |
|---|---|
| Provision | Commission |
| Provisionsvertrag | Commission Contract |
| Provisionsart | Commission Type |
| Provisionsposten | Commission Ledger Entry |
| Provisionsmanagement | Commission Management |
| Verkäufer | Salesperson |
| Bemerkung | Comment |
| Einrichtung | Setup |
| Provisionen berechnen | Calculate Commissions |

Diese Zuordnung ist die Grundlage der `de-DE.xlf` und muss durchgängig eingehalten werden.
