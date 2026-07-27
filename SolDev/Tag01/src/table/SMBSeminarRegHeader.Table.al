table 123456710 "SMB Seminar Reg. Header"
{
    Caption = 'Seminar Registration';
    DataCaptionFields = "No.", "Starting Date", "Seminar Description";
    // LookupPageID = "SMB Seminar Registration List";
    // DrillDownPageID = "SMB Seminar Registration List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the value of the No. field.';
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the value of the Starting Date field.';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SMB Seminar";
            ToolTip = 'Specifies the value of the Seminar No. field.';
        }
        field(4; "Seminar Description"; Text[100])
        {
            Caption = 'Seminar Description';
            ToolTip = 'Specifies the value of the Seminar Description field.';
        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "SMB Instructor";
            ToolTip = 'Specifies the value of the Instructor Code field.';
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            ToolTip = 'Specifies the value of the Instructor Name field.';
            // Flowfield 

        }
        field(7; Status; Enum "SMB Seminar Reg. Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the value of the Status field.';
        }
        field(9; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Duration (Days) field.';
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Minimum Participants field.';
            // Prüfung Min < Max

        }
        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Maximum Participants field.';
            // Prüfung Min < Max

        }
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            ToolTip = 'Specifies the value of the Language Code field.';
        }
        field(13; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the value of the Salesperson Code field.';
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Seminar Price field.';
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            // füllen von VAT

        }
        field(16; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
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
            ToolTip = 'Specifies the value of the Room Code field.';
        }
        field(21; "Room Name"; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the value of the Name field.';
        }
        field(22; "Room Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies the value of the Name 2 field.';
        }
        field(23; "Room Address"; Text[100])
        {
            Caption = 'Address';
            ToolTip = 'Specifies the value of the Address field.';
        }
        field(24; "Room Address 2"; Text[50])
        {
            Caption = 'Address 2';
            ToolTip = 'Specifies the value of the Address 2 field.';
        }
        field(25; "Room City"; Text[30])
        {
            Caption = 'City';
            ToolTip = 'Specifies the value of the City field.';
            // Standard

        }
        field(26; "Room Contact"; Text[50])
        {
            Caption = 'Contact';
            ToolTip = 'Specifies the value of the Contact field.';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the value of the Country/Region Code field.';
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the value of the Post Code field.';
            // Standard


        }
        field(29; "Room County"; Text[30])
        {
            Caption = 'County';
            ToolTip = 'Specifies the value of the County field.';
        }
        field(42; Comment; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("SMB Seminar Comment Line" where("Document Type" = const("SMB Sem. Comment Document Type"::"Seminar Registration"),
                                                                "No." = field("No."),
                                                                "Line No." = const(0)));

        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the value of the Posting Date field.';
        }
        field(53; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the value of the Document Date field.';
        }
        field(54; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
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
        field(61; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(62; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

        }
        field(63; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(100; "No. of Participants"; Integer)
        {
            Caption = 'No. of Participants';
            ToolTip = 'Specifies the value of the No. of Participants field.';
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
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Starting Date", "Seminar No.", "Seminar Description", "Room Code") { }
        fieldgroup(Brick; "No.", "Seminar Description") { }
    }
    trigger OnDelete()
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
    begin
        SMBSeminarCommentLine.DeleteComments(SMBSeminarCommentLine."Document Type"::"Seminar Registration","No.");
    end;

}


