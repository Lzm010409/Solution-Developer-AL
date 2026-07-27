page 123456704 "SMB Seminar Room List"
{

    ApplicationArea = All;
    Caption = 'Seminar Rooms';
    PageType = List;
    SourceTable = "SMB Seminar Room";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SMB Seminar Room Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field';
                    
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field';
                   
                }
                field("Internal/External"; Rec."Internal/External")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Internal/External field';

                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field';

                }
                field("Post Code"; Rec."Post Code")
                {
                    Visible = false;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
        }
    }
}
