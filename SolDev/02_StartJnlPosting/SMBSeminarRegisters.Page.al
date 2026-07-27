page 123456722 "SMB Seminar Registers"
{
    Caption = 'Seminar Registers';
    PageType = List;
    UsageCategory = History;
    ApplicationArea = All;
    SourceTable = "SMB Seminar Register";
    Editable = false;

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
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Creation Date field';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Source Code field';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Journal Batch Name field';
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the From Entry No. field';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Entry No. field';
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
            group(Register)
            {
                Caption = 'Register';
                action("Seminar Ledger")
                {
                    Caption = 'Seminar Ledger';
                    Image = Ledger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "SMB Seminar Reg.-Show Ledger";
                    ToolTip = 'Executes the Seminar Ledger action';

                }
            }
        }

    }
}