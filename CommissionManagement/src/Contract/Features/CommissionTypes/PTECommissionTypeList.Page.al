page 63001 "PTE Commission Type List"
{
    ApplicationArea = All;
    Caption = 'Commission Types', Comment = 'de-DE=Liste der Provisionsarten';
    PageType = List;
    SourceTable = "PTE Commission Type";
    UsageCategory = Administration;
    Editable = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies a code to identify this commission type.', Comment = 'de-DE=Gibt einen Code an, um diesen Provisions Typ zu identifizieren.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description for this commission type.', Comment = 'de-DE=Gibt eine Beschreibung für diesen Provisions Typ an.';
                }
                
            }
        }
       
    }

   
}
