table 123456732 "SMB Seminar Ledger Entry"
{
    Caption = 'Seminar Ledger Entry';
    LookupPageID = "SMB Seminar Ledger Entries";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SMB Seminar";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Registration,Cancelation';
            OptionMembers = Registration,Cancelation;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(9; "Charge Type"; Enum "SMB Sem. Ledger Charge Type")
        {
            Caption = 'Charge Type';           
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,G/L Account';
            OptionMembers = Resource,"G/L Account";
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(13; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(15; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(17; "Seminar Room Code"; Code[20])
        {
            Caption = 'Room Code';
            TableRelation = "SMB Seminar Room";
        }
        field(18; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "SMB Instructor";
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(21; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(22; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Seminar';
            OptionMembers = " ",Seminar;
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            //FIXME   TableRelation = if ("Source Type" = const (Seminar)) Seminar;
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(25; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(26; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(27; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(28; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            //FIXME
            // trigger OnValidate()
            // var
            //     UserMgt: Codeunit "User Management";
            // begin
            //     UserMgt.LookupUserID("User ID");
            // end;
        }
        field(40; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

        }
        field(41; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(42; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

        }
        field(43; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(100; "Closed by Document No."; Code[20])
        {
            Caption = 'Closed by Document No.';
            TableRelation = "Sales Invoice Header";
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
        field(481; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(3)));
        }
        field(482; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(4)));
        }
        field(483; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(5)));
        }
        field(484; "Shortcut Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,2,6';
            Caption = 'Shortcut Dimension 6 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(6)));
        }
        field(485; "Shortcut Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,2,7';
            Caption = 'Shortcut Dimension 7 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(7)));
        }
        field(486; "Shortcut Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,2,8';
            Caption = 'Shortcut Dimension 8 Code';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Dimension Set Entry"."Dimension Value Code" where("Dimension Set ID" = field("Dimension Set ID"),
                                                                                    "Global Dimension No." = const(8)));
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(DocNo; "Document No.") { }
        key(Nav; "Document No.", "Posting Date") { }
        key(SemNo_PostDat_SemRoomCod; "Seminar No.", "Posting Date", "Seminar Room Code")
        {
            SumIndexFields = Quantity;
        }
        key(Inv; "Bill-to Customer No.", "Closed by Document No.", Chargeable) { }
        key(SK5; "Seminar No.", "Posting Date", "Charge Type", Chargeable)
        {
            SumIndexFields = "Total Price";
        }
    }
    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("Entry No.")))
    end;

    procedure CopyFromSemJnlLine(SemJnlLine: Record "SMB Seminar Journal Line");
    begin
        "Seminar No." := SemJnlLine."Seminar No.";
        "Posting Date" := SemJnlLine."Posting Date";
        "Document Date" := SemJnlLine."Document Date";
        "Entry Type" := SemJnlLine."Entry Type";
        "Document No." := SemJnlLine."Document No.";
        Description := SemJnlLine.Description;
        "Bill-to Customer No." := SemJnlLine."Bill-to Customer No.";
        "Charge Type" := SemJnlLine."Charge Type";
        Type := SemJnlLine.Type;
        Quantity := SemJnlLine.Quantity;
        "Unit Price" := SemJnlLine."Unit Price";
        "Total Price" := SemJnlLine."Total Price";
        "Participant Contact No." := SemJnlLine."Participant Contact No.";
        "Participant Name" := SemJnlLine."Participant Name";
        Chargeable := SemJnlLine.Chargeable;
        "Seminar Room Code" := SemJnlLine."Seminar Room Code";
        "Instructor Code" := SemJnlLine."Instructor Code";
        "Starting Date" := SemJnlLine."Starting Date";
        "Seminar Registration No." := SemJnlLine."Seminar Registration No.";
        "Res. Ledger Entry No." := SemJnlLine."Res. Ledger Entry No.";
        "Source Type" := SemJnlLine."Source Type";
        "Source No." := SemJnlLine."Source No.";
        "Journal Batch Name" := SemJnlLine."Journal Batch Name";
        "Source Code" := SemJnlLine."Source Code";
        "Reason Code" := SemJnlLine."Reason Code";
        "No. Series" := SemJnlLine."Posting No. Series";
        // Zusätzlich sollen die Buchungsgruppen in die Posten übergeben werden
        // Anforderung für die Fakturierung, damit auf das Sachkonto aus der Buchungsmatrix gebucht werden kann
        "Gen. Bus. Posting Group" := SemJnlLine."Gen. Bus. Posting Group";
        "VAT Bus. Posting Group" := SemJnlLine."VAT Bus. Posting Group";
        "Gen. Prod. Posting Group" := SemJnlLine."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := SemJnlLine."VAT Prod. Posting Group";
        // Übergabe der Dimensionen
        "Dimension Set ID" := SemJnlLine."Dimension Set ID";
    end;
}