table 123456718 "SMB Posted Seminar Reg. Header"
{
    Caption = 'Posted Seminar Registration';
    DataCaptionFields = "No.", "Starting Date", "Seminar Description";
    DrillDownPageID = "SMB Posted Seminar Reg. List";
    LookupPageID = "SMB Posted Seminar Reg. List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SMB Seminar";
        }
        field(4; "Seminar Description"; Text[100])
        {
            Caption = 'Seminar Description';
        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "SMB Instructor";
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            // Es soll im gebuchten Beleg der historische Name archiviert werden
            // FieldClass = FlowField;
            // CalcFormula = lookup("SMB Instructor".Name where(Code = field("Instructor Code")));
            Editable = false;
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning,Registration,Closed,Canceled;
        }
        field(9; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
        }
        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
        }
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(13; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(16; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(20; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
            TableRelation = "SMB Seminar Room";
        }
        field(21; "Room Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(22; "Room Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(23; "Room Address"; Text[100])
        {
            Caption = 'Address';
        }
        field(24; "Room Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(25; "Room City"; Text[30])
        {
            Caption = 'City';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code".City
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(26; "Room Contact"; Text[50])
        {
            Caption = 'Contact';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
        }
        field(29; "Room County"; Text[30])
        {
            Caption = 'County';
        }
        field(42; Comment; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            CalcFormula = exist("SMB Seminar Comment Line" where("Document Type" = const("Posted Seminar Registration"),
                                                               "No." = field("No."),
                                                               "Document Line No." = const(0)));
            Editable = false;
        }
        field(43; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(53; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(54; "Posting Description"; Text[100])
        {
            Caption = 'Posting Description';
        }
        field(55; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(56; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(100; "No. of Participants"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("SMB Posted Seminar Reg. Line" where("Document No." = field("No.")));
            Editable = false;
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
        field(500; "Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(501; "Registration No. Series"; Code[20])
        {
            Caption = 'Registration No. Series';
            TableRelation = "No. Series".Code;
        }
        field(503; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
        }
        field(504; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Starting Date", "Seminar No.", "Seminar Description", "Room Code") { }
    }

    trigger OnDelete()
    begin
        TestField("No. Printed");
        LockTable();

        SeminarCommentLine.SetRange("Document Type", SeminarCommentLine."Document Type"::"Posted Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.DeleteAll();

      

    end;

    var
        SeminarCommentLine: Record "SMB Seminar Comment Line";
       

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run();
    end;
}