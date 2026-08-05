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
                    ToolTip = 'Specifies the unique number of the Commission Contract.', Comment = 'de-DE=Gibt die eindeutige Nummer des Provisionsvertrags an.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status', Comment = 'de-DE=Status';
                    ToolTip = 'Specifies the status of the Commission Contract.', Comment = 'de-DE=Gibt den Status des Provisionsvertrags an.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = 'de-DE=Beschreibung';
                    ToolTip = 'Specifies the description of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung des Provisionsvertrags an.';
                }
                field("Commission Type Description"; Rec."Commission Type Description")
                {
                    Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
                    ToolTip = 'Specifies the commission type of the Commission Contract.', Comment = 'de-DE=Gibt die Provisionsart des Provisionsvertrags an.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                    ToolTip = 'Specifies the starting date of the Commission Contract.', Comment = 'de-DE=Gibt das Startdatum des Provisionsvertrags an.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                    ToolTip = 'Specifies the ending date of the Commission Contract.', Comment = 'de-DE=Gibt das Enddatum des Provisionsvertrags an.';
                }
            }
        }
    }

}