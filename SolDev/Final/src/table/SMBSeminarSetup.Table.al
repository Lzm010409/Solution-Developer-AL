table 123456701 "SMB Seminar Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Seminar Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; "Seminar Nos."; Code[20])
        {
            Caption = 'Seminar Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Seminar Nos. field.';
        }
        field(3; "Seminar Registration Nos."; Code[20])
        {
            Caption = 'Seminar Registration Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Seminar Registration Nos. field.';
        }
        field(4; "Posted Seminar Reg. Nos."; Code[20])
        {
            Caption = 'Posted Seminar Reg. Nos.';
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Posted Seminar Reg. Nos. field.';
        }   
         field(5; "Copy Comments Reg. to Pst."; Boolean)
        {
            Caption = 'Copy Comments Reg. to Pst.';
            DataClassification= CustomerContent;
            InitValue = true;
            ToolTip = 'Specifies the value of the Copy Comments Reg. to Pst. field.', Comment = '%';
        }   
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}