table 63001 "PTE Commission Type"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', Comment = 'de-DE=Code';
            ToolTip = 'This is the Code of the Commission Type.', Comment = 'de-DE=Der Code des Provisions Typs.';
            NotBlank = true; 
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'This is the Description of the Commission Type.', Comment = 'de-DE=Die Beschreibung des Provisions Typs.';
        }
    }
    
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    
}