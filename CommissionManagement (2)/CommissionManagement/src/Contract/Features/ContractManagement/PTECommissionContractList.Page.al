page 63020 "PTE Commission Contract List"
{
    Caption = 'Commission Contract List', Comment = 'de-DE=Liste der Provisionsverträge';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "PTE Commission Contract Card";
    SourceTable = "PTE Commission Contract";
    Editable = false;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."No.")
                {
                    Caption = 'Contract No.', Comment = 'de-DE=Vertragsnummer';
                    ToolTip = 'This is the unique number of the Commission Contract.', Comment = 'de-DE=Die eindeutige Nummer des Provisions Vertrags.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status', Comment = 'de-DE=Status';
                    ToolTip = 'This is the status of the Commission Contract.', Comment = 'de-DE=Der Status des Provisions Vertrags.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = 'de-DE=Beschreibung';
                    ToolTip = 'This is the description of the Commission Contract.', Comment = 'de-DE=Die Beschreibung des Provisions Vertrags.';
                }
                field("Commission Type Description"; Rec."Commission Type Description")
                {
                    Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
                    ToolTip = 'This is the commission type of the Commission Contract.', Comment = 'de-DE=Die Provisionsart des Provisions Vertrags.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                    ToolTip = 'This is the starting date of the Commission Contract.', Comment = 'de-DE=Das Startdatum des Provisions Vertrags.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                    ToolTip = 'This is the ending date of the Commission Contract.', Comment = 'de-DE=Das Enddatum des Provisions Vertrags.';
                }
            }
        }
        area(Factboxes)
        {
            
        }
    }

}