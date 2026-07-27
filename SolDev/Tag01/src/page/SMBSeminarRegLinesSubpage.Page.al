page 123456711 "SMB Seminar Reg. Lines Subpage"
{
    ApplicationArea = All;
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "SMB Seminar Reg. Line";
    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.") { }
                field("Participant Contact No."; Rec."Participant Contact No.") { }
                field("Participant Name"; Rec."Participant Name") { }
                field("Registration Date"; Rec."Registration Date") { }
                field("To Invoice"; Rec."To Invoice") { }
                field(Participated; Rec.Participated) { }
                field("Confirmation Date"; Rec."Confirmation Date") { }
                field("Seminar Price (LCY)"; Rec."Seminar Price (LCY)") { }
                field("Line Discount %"; Rec."Line Discount %") { }
                field("Line Discount Amount (LCY)"; Rec."Line Discount Amount (LCY)") { }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)") { }
                field("Line Amount"; Rec."Line Amount") { }
                field(Registered; Rec.Registered) { }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("Related Information")
                {
                    Caption = 'Related Information';
                    action("Co&mments")
                    {
                        ApplicationArea = Comments;
                        Caption = 'Co&mments';
                        Image = ViewComments;
                        ToolTip = 'View or add comments for the record.';

                        trigger OnAction()
                        begin
                            Rec.ShowLineComments();
                        end;
                    }
                }
            }
        }

    }
}
