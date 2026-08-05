tableextension 63000 "PTE Salesperson Com. Table Ext" extends "Salesperson/Purchaser"
{
    fields
    {
        field(63020 ; "PTE Commission Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Commission Contract No.', Comment = 'de-DE=PTE Provisionsvertragsnr.';
            ToolTip = 'Specifies the commission contract that applies to this salesperson.', Comment = 'de-DE=Gibt den Provisionsvertrag an, der für diesen Verkäufer gilt.';
            TableRelation = "PTE Commission Contract";
        }
        field(63021; "PTE Commission Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'PTE Commission Amount (LCY)', Comment = 'de-DE=PTE Provisionsbetrag (Lokalwährung)';
            ToolTip = 'Specifies the total commission posted for this salesperson within the date filter.', Comment = 'de-DE=Gibt die Summe der für diesen Verkäufer gebuchten Provision innerhalb des Datumsfilters an.';
            FieldClass = FlowField;
            CalcFormula = sum("PTE Commission Ledger Entry"."Commission Amount (LCY)" where ("Salesperson Code" = field("Code"),
                                                                                            "Posting Date" = field("PTE Date Filter")));
            Editable = false;
        }
        field(63022; "PTE Date Filter"; Date)
        {
            Caption = 'PTE Date Filter', Comment = 'de-DE=PTE Datumsfilter';
            ToolTip = 'Specifies the period the posted commission is totalled for.', Comment = 'de-DE=Gibt den Zeitraum an, für den die gebuchte Provision summiert wird.';
            FieldClass = FlowFilter;
        }
    }
}

