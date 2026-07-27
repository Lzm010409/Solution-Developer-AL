# 90 – Domänenkontext: Provisionsmanagement

Dieses Dokument beschreibt das **gestellte Grundprojekt**. Der Agent baut es nicht – er
erweitert es. Der Zweck dieses Dokuments ist, dass der Agent weiß, was er vorfindet und wie
sich die Muster der Seminar-Musterlösung auf diese Domäne übertragen.

⚠️ Der Stand hier entspricht der Spezifikation **Version 1.02**. Die tatsächlich gestellte App
kann abweichen. **Die vorgefundene App ist maßgeblich**, nicht dieses Dokument. Phase 0 der
Bestandsaufnahme (siehe `00-workflow.md`) ist trotzdem durchzuführen.

---

## Eckdaten

| | |
|---|---|
| Extension-Name | Provisionsmanagement (de) / Commission Management (en) |
| Objekt-Prefix | `GOB` |
| Objektnummernkreis | 63000 – 63500 |
| Sprachen | `de-DE` und `en-US` |
| Fachbegriff „Provision" in AL | `Commission` |
| Integrationsbereich | Sales |
| Einstieg für den Anwender | Manuelle Einrichtung **oder** Rollencenter „Verkaufsauftragbearbeitung" (`Order Processor Role Center`) |

---

## Fachliche Kernprozesse (Release 1.00)

1. Provisionsverträge anlegen und Verkäufern zuordnen
2. Auf den Verkäufer-Masken die Provisionshöhe anzeigen, filterbar auf Perioden
3. Provisionsverträge dürfen nicht gelöscht werden, solange sie einem Verkäufer zugeordnet sind
4. Periodischer Stapellauf „Provisionen ermitteln" für einen oder viele Verkäufer, auf Basis
   gebuchter Verkaufsrechnungen und -gutschriften; Ergebnis sind Provisionsposten je Verkaufsbeleg
5. Integration in den Sales-Bereich mit BC-typischer User Experience

**Ausdrücklich nicht in Release 1.00:** die Auszahlung von Provisionsboni. Die Stammdatenfelder
dafür existieren (`Pay Commission Bonus`, `Target Achievement Amount`, `Commission Bonus Amount`),
tragen aber **keine Geschäftslogik**. Das ist der wahrscheinlichste Ansatzpunkt für eine
Folgeaufgabe.

---

## Datenmodell des Grundprojekts

```
   Salesperson/Purchaser  ────────▶  Commission Contract  ────────▶  Commission Comment Line
   (Standard, erweitert)                    │      │                  (Table Name, No., Line No.)
   Code (PK)                                │      │
   Commission Contract No. ◀────────────────┘      │
                                                   ▼
                                           Commission Type
                                           Code (PK), Description

   Cust. Ledger Entry  ─────────┐
   Entry No. (PK)               │
   Posting Date                 ▼
   Document No.          Commission Ledger Entry
                         Entry No. (PK)
                         Posting Date
                         Salesperson Code        ──▶ Salesperson/Purchaser
                         Commission Contract No. ──▶ Commission Contract
                         Document No.
                         Customer Ldg. Entry No. ──▶ Cust. Ledger Entry
```

Kurz: **Kein Beleg, kein Buch.-Blatt, kein Register.** Die Posten entstehen direkt aus dem
Batch-Report heraus. Genau hier setzen die Erweiterungsaufgaben an.

---

## Objektliste des Grundprojekts

Laut Spezifikation, Abschnitt „Beispiel: Objektliste". Enums sind dort nicht aufgeführt.

| Typ | ID | Name |
|---|---|---|
| Table | 63000 | GOB Commission Mgt. Setup |
| Table | 63001 | GOB Commission Type |
| Table | 63020 | GOB Commission Contract |
| Table | 63021 | GOB Commission Comment Line |
| Table | 63022 | GOB Commission Ledger Entry |
| Report | 63000 | GOB Calc. Commissions - batch |
| Codeunit | 63000 | GOB Commis. Mgt Install Lib. |
| Codeunit | 63021 | GOB Calculate Commission |
| Codeunit | 63022 | GOB Post Commission Ledg Entry |
| Page | 63000 | GOB Commission Mgt. Setup |
| Page | 63001 | GOB Commission Types |
| Page | 63020 | GOB Commission Contract List |
| Page | 63021 | GOB Commission Contract Card |
| Page | 63022 | GOB Commis. Contract Factbox |
| Page | 63023 | GOB Commission Comment List |
| Page | 63024 | GOB Commission Comment Sheet |
| Page | 63025 | GOB Commission Ledger Entries |

Dazu kommen die Erweiterungen des Standards (`tableextension`/`pageextension` auf
`Salesperson/Purchaser` und das Rollencenter) sowie mindestens ein PermissionSet.

**Freie IDs für Erweiterungen:** alles Übrige zwischen 63000 und 63500 – konkret bestätigen
lässt sich das nur über das Objektinventar aus Phase 0.

---

## Vorhandene Muster im Grundprojekt

Der Agent kann davon ausgehen, dass diese Muster bereits im Code stehen und als Vorlage für
Neues dienen:

| Muster | Wo |
|---|---|
| Setup-Tabelle mit Nummernserien und Rundungsfeld | `GOB Commission Mgt. Setup` |
| Master mit Nummernserie und `AssistEdit` | `GOB Commission Contract` |
| Supplemental mit editierbarer Listenpage | `GOB Commission Type` |
| Eigene Bemerkungstabelle (nicht die Standard-`Comment Line`) | `GOB Commission Comment Line` |
| Postentabelle nach Postenkonzept | `GOB Commission Ledger Entry` |
| ProcessingOnly-Report als Stapellauf | `GOB Calc. Commissions - batch` |
| FactBox über Array | `GOB Commis. Contract Factbox` |
| FlowField + FlowFilter auf dem Standardstammsatz | `tableextension` auf `Salesperson/Purchaser` |
| Rollencenter-Erweiterung | `pageextension` auf `Order Processor Role Center` |

**Neue Objekte übernehmen den Stil dieser Objekte**, nicht den der Seminar-Musterlösung, wo
beide sich unterscheiden.

---

## Mapping Seminar-Musterlösung → Provisionsmanagement

Wenn eine Erweiterungsaufgabe ein Muster aus `SolDev/Final/` verlangt, ist das die Übersetzung:

| Rolle im Datenmodell | Seminar (`SMB`) | Provision (`GOB`) |
|---|---|---|
| Setup | `SMB Seminar Setup` | `GOB Commission Mgt. Setup` |
| Master | `SMB Seminar` | `GOB Commission Contract` |
| Supplemental | `SMB Seminar Room`, `SMB Instructor` | `GOB Commission Type` |
| Bemerkungen | `SMB Seminar Comment Line` | `GOB Commission Comment Line` |
| Angebundener Standard-Stammsatz | `Contact`, `Customer` | `Salesperson/Purchaser` |
| Posten | `SMB Seminar Ledger Entry` | `GOB Commission Ledger Entry` |
| Auslösender Standardbeleg | `Sales Invoice` (Fakturierung) | `Cust. Ledger Entry` (Berechnungsgrundlage) |
| Stapellauf | `SMB Create Seminar Invoices` | `GOB Calc. Commissions - batch` |
| FactBox | `SMB Seminar Details FactBox` | `GOB Commis. Contract Factbox` |
| Rollencenter | `SMB Seminar Role Center` (eigenes) | `pageextension` auf `Order Processor Role Center` |

### Was im Grundprojekt (noch) fehlt

Diese Bausteine der Musterlösung haben **kein** Pendant im Grundprojekt. Sie sind die
wahrscheinlichen Inhalte kommender Aufgaben – und für jeden gibt es ein fertiges Muster:

| Fehlender Baustein | Muster in der Musterlösung |
|---|---|
| Beleg (Header + Line) | `SMBSeminarRegHeader/RegLine.Table.al`, `SMBSeminarRegistration.Page.al` |
| Belegstatus-Enum | `SMBSeminarRegStatus.Enum.al` |
| Buch.-Blattzeile | `SMBSeminarJournalLine.Table.al` |
| Register | `SMBSeminarRegister.Table.al` |
| Check-Line- / Post-Line-Codeunit | `SMBSemJnlCheckLine/PostLine.Codeunit.al` |
| Post- / Post-(Yes/No)-Codeunit | `SMBSeminarPost.Codeunit.al`, `SMBSeminarPostYesNo.Codeunit.al` |
| Gebuchte Belege | `SMBPostedSeminarRegHeader/Line.Table.al`, `SMBPstSemRegistration.Page.al` |
| Navigate-Integration | `SMBSeminarNavigate.Codeunit.al` |
| Verknüpfung mit `Sales-Post` | `SMBSeminarInvoicing.Codeunit.al` |
| Herkunftscode-Einrichtung | `SMBSourceCodeSetup.TableExt/PageExt.al` |
| Cue + Aktivitäten-Part | `SMBSeminarCue.Table.al`, `SMBSeminarMgtActivities.Page.al` |
| Eigenes Rollencenter + Profile | `SMBSeminarRoleCenter.Page.al`, `src/profile/` |
| Filter Token + „My …"-Tabelle | `SMBMySeminarFilterToken.Codeunit.al`, `SMBMySeminar.Table.al` |
| Statistik-Page | im Schulungsskript beschrieben (S. 46), in `Final` nicht ausprogrammiert |
| Test-App | `SolDev/Final/TestSeminarManagement/` |

---

## Fachliche Regeln, die bei jeder Erweiterung gelten

Aus der Spezifikation, auch wenn die Erweiterungsaufgabe sie nicht wiederholt:

- **Provisionsformel:** `Provisionsbetrag = (Rechnungsbetrag / 100) * Provision in Prozent`
- **Gutschriften ergeben einen negativen Betrag**
- **Der Provisionsbetrag wird gerundet**, und zwar über das Rundungsfeld aus der Einrichtung
- **Beträge werden 1:1 aus den Debitorenposten übernommen** – keine erneute
  Währungsumrechnung
- **`Commission Percentage` liegt zwischen 1 und 100**
- **Belege, die bereits als Provisionsposten erfasst sind, werden nicht doppelt erfasst** –
  das System erkennt sie und ignoriert sie
- **Provisionsposten sind historisch und bleiben dauerhaft erhalten** – sie werden auch beim
  Löschen eines Vertrags nicht mitgelöscht
- **Ein Vertrag darf nicht gelöscht werden, solange er einem Verkäufer zugeordnet ist**
- **Das Standardfeld `Commission %` am Verkäufer bleibt ausgeblendet** – beide Features sollen
  nicht parallel genutzt werden

---

## Rollencenter-Menü

Die Gruppe „Provisionsmanagement" im `Order Processor Role Center` enthält laut Spezifikation:

1. Provisionsarten
2. Verkäufer
3. Provisionsverträge
4. Provisionsposten
5. Provisionen berechnen

Kommt durch eine Erweiterung ein neuer Einstiegspunkt hinzu (z. B. gebuchte Belege oder ein
Journal), gehört er in dieselbe Gruppe – nicht in eine neue.
