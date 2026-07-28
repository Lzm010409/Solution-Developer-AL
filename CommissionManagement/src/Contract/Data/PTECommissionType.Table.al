table 63001 "PTE Commission Type"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', Comment = 'de-DE=Code';
            ToolTip = 'Specifies the Code of the Commission Type.', Comment = 'de-DE=Gibt den Code des Provisions Typs an.';
            NotBlank = true; 
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'Specifies the Description of the Commission Type.', Comment = 'de-DE=Gibt die Beschreibung des Provisions Typs an.';
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