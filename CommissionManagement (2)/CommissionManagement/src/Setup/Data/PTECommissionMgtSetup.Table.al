table 63000 "PTE Commission Mgt. Setup"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key', Comment = 'de-DE=Primärschlüssel';
            ToolTip = 'This is the Primary Key of the Datapoint.', Comment = 'de-DE=Primärschlüssel des Datensatzes.';

        }
        field(10; "Rounding Precision"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Rounding Precision', Comment = 'de-DE=Rundungspräzision';
            ToolTip = 'This is the Rounding Precision.', Comment = 'de-DE=Die Rundungspräzision mit welcher gerundet wird.';
            NotBlank = true;
        }
        field(11; "Contract Nos."; Code[20])
        {
            Caption = 'Commission Contract No. Series', Comment = 'de-DE=Nummernkreis der Provisionsverträge';
            TableRelation = "No. Series";
            ToolTip = 'Specifies the code for the number series that will be used to assign numbers to commission contracts.', Comment = 'de-DE=Gibt den Code für den Nummernkreis an, der verwendet wird, um Nummern für Provisionsverträge zu vergeben.';
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