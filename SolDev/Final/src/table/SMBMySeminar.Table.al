table 123456730 "SMB My Seminar"
{
    Caption = 'My Seminar';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            NotBlank = true;
            TableRelation = "SMB Seminar";
            ToolTip = 'Specifies the seminar numbers that are displayed in the My Seminar Cue on the Role Center.';

            trigger OnValidate()
            begin
                SetSeminarFields();
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
            ToolTip = 'Specifies the Description of the customer.';
        }
        field(4; "Duration Days"; Integer)
        {
            Caption = 'Duration';
            Editable = false;
            ToolTip = 'bla.';
        }
        field(5; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            Editable = false;
            AutoFormatType = 1;
            ToolTip = 'bla.';
        }
        
    }

    keys
    {
        key(Key1; "User ID", "Seminar No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
        key(Key3; "Duration Days")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetSeminarFields()
    var
        SMBSeminar: Record "SMB Seminar";
    begin
        SMBSeminar.SetLoadFields(Description,"Duration Days","Seminar Price");
        if SMBSeminar.Get("Seminar No.") then begin
            Description := SMBSeminar.Description;
            "Duration Days" := SMBSeminar."Duration Days";
            "Seminar Price" := SMBSeminar."Seminar Price"
        end;
    end;
}

