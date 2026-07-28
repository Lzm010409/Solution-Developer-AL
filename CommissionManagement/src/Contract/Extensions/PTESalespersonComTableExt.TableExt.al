tableextension 63000 "PTE Salesperson Com. Table Ext" extends "Salesperson/Purchaser"
{
    fields
    {
        field(63020 ; "PTE Commission Contract No."; Code[20])
        {
            Caption = 'PTE Commission Contract No.', Comment = 'de-DE=PTE Provisionsvertragsnr.';
            ToolTip = 'Specifies the PTE Commission Contract No. field added to Salesperson/Purchaser table by PTE Commission Management Extension.', Comment = 'de-DE=Gibt das Feld PTE Provisionsvertragsnr. zur Tabelle Verkäufer/Einkäufer hinzugefügt von der PTE Provisionsverwaltung Erweiterung an.';
            TableRelation = "PTE Commission Contract";
        }
        field(63021; "PTE Commission Amount (LCY)"; Decimal)
        {
            Caption = 'PTE Commission Amount (LCY)', Comment = 'de-DE=PTE Provisionsbetrag (Lokalwährung)';
            ToolTip = 'Specifies the PTE Commission Amount (LCY) field added to Salesperson/Purchaser table by PTE Commission Management Extension.', Comment = 'de-DE=Gibt das Feld PTE Provisionsbetrag (Lokalwährung) zur Tabelle Verkäufer/Einkäufer hinzugefügt von der PTE Provisionsverwaltung Erweiterung an.';
            FieldClass = FlowField;
            CalcFormula = sum("PTE Commission Ledger Entry"."Commission Amount (LCY)" where ("Salesperson Code" = field("Code"),
                                                                                            "Posting Date" = field("PTE Date Filter")));
            Editable = false;
        }
        field(63022; "PTE Date Filter"; Date)
        {
            Caption = 'PTE Date Filter', Comment = 'de-DE=PTE Datumsfilter';
            ToolTip = 'Specifies the PTE Date Filter field added to Salesperson/Purchaser table by PTE Commission Management Extension.', Comment = 'de-DE=Gibt das Feld PTE Datumsfilter zur Tabelle Verkäufer/Einkäufer hinzugefügt von der PTE Provisionsverwaltung Erweiterung an.';
            FieldClass = FlowFilter;
        }
    }
}

