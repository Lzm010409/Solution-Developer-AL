page 123456708 "SMB Seminar Reg. Line List"
{
    ApplicationArea = All;
    Caption = 'Seminar Reg. Line List';
    PageType = List;
    SourceTable = "SMB Seminar Reg. Line";
    UsageCategory = None;
    Editable = false;

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
                field(Registered; Rec.Registered) { }
                field("Line Amount"; Rec."Line Amount") { }
            }
        }
    }
}
