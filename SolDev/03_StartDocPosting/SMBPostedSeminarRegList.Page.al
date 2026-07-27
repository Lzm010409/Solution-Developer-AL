page 123456736 "SMB Posted Seminar Reg. List"
{
    Caption = 'Pst. Seminar Registration List';
    PageType = List;
    SourceTable = "SMB Posted Seminar Reg. Header";
    CardPageID = "SMB Pst. Sem. Registration";
    Editable = false;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Date field';
                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar No. field';
                }
                field("Seminar Description"; Rec."Seminar Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Description field';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field';
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Duration (Days) field';
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Maximum Participants field';
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }
        }
    }
    actions
    {
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page "SMB Seminar Comment Sheet";
                    RunPageLink = "No." = field("No.");
                    RunPageView = where("Document Type" = const("Posted Seminar Registration"));
                    ToolTip = 'Executes the Co&mments action';
                }
            
            }
        }
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the &Navigate action';

                trigger OnAction()
                begin
                    Rec.Navigate();
                end;
            }
        }
    }
}