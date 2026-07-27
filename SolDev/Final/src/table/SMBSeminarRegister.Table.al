table 123456733 "SMB Seminar Register"
{
    Caption = 'Seminar Register';

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "SMB Seminar Ledger Entry";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "SMB Seminar Ledger Entry";
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";

            //FIXME
            // trigger OnLookup()
            // var
            //     UserMgt: Codeunit "User Management";
            // begin
            //     UserMgt.LookupUserID("User ID");
            // end;
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(10; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
            Caption = 'Creation Time';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(CreDat; "Creation Date") { }
        key(SrcCode_JnlBname_CreDat; "Source Code", "Journal Batch Name", "Creation Date") { }
    }
    procedure GetLastEntryNo(): Integer;
    var
        FindRecordManagement: Codeunit "Find Record Management";
    begin
        exit(FindRecordManagement.GetLastEntryIntFieldValue(Rec, FieldNo("No.")))
    end;
}