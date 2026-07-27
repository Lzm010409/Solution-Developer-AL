table 123456711 "SMB Seminar Reg. Line"
{
    Caption = 'Seminar Registration Line';
    DataCaptionFields = "Document No.", "Participant Name";
    // DrillDownPageId = "SMB Sem. Registration Lines";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SMB Seminar Reg. Header";
            ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
            ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the value of the Participant Contact No. field.', Comment = '%';
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
            ToolTip = 'Specifies the value of the Participant Name field.', Comment = '%';
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Editable = false;
            ToolTip = 'Specifies the value of the Registration Date field.', Comment = '%';
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
            ToolTip = 'Specifies the value of the To Invoice field.', Comment = '%';
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
            ToolTip = 'Specifies the value of the Participated field.', Comment = '%';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
            ToolTip = 'Specifies the value of the Confirmation Date field.', Comment = '%';
        }
        field(10; "Seminar Price (LCY)"; Decimal)
        {
            Caption = 'Seminar Price (LCY)';
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Seminar Price (LCY) field.', Comment = '%';
        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the value of the Line Discount % field.', Comment = '%';
        }
        field(12; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Line Discount Amount (LCY) field.', Comment = '%';
        }
        field(13; "Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            ToolTip = 'Specifies the value of the Registered field.', Comment = '%';
            // TODO Editable = false;
        }
        field(15; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

          
        }
        field(16; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
          
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;


        }
        field(19; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

      
        }
        field(490; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

          
        }
        field(491; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));

          
        }
    }

    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

  } 