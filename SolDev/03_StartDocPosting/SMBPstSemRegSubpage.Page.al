page 123456735 "SMB Pst. Sem. Reg. Subpage"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "SMB Posted Seminar Reg. Line";
    Editable = false;
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Participant Contact No."; Rec."Participant Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participant Contact No. field';
                }
                field("Participant Name"; Rec."Participant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participant Name field';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bill-to Customer No. field';
                }
                field(Participated; Rec.Participated)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Participated field';
                }
                field("Registration Date"; Rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registration Date field';
                }
                field("Confirmation Date"; Rec."Confirmation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmation Date field';
                }
                field("To Invoice"; Rec."To Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the To Invoice field';
                }
                field(Registered; Rec.Registered)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registered field';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Code field';
                }
                field("Seminar Price (LCY)"; Rec."Seminar Price (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Seminar Price (LCY) field';
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount % field';
                }
                field("Line Discount Amount (LCY)"; Rec."Line Discount Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount Amount (LCY) field';
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount (LCY) field';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Amount field';
                }
            }
        }
    }
}

