page 123456717 "SMB Seminar Details FactBox"
{
    ApplicationArea = All;
    Caption = 'Seminar Details';
    PageType = CardPart;
    SourceTable = "SMB Seminar";

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Seminar No.';
                trigger OnDrillDown()
                begin
                    ShowDetails();
                end;
            }
            field(Description; Rec.Description){}
            field("Duration Days"; Rec."Duration Days"){}
            field("Minimum Participants"; Rec."Minimum Participants"){}
            field("Maximum Participants"; Rec."Maximum Participants"){}
            field("Seminar Price"; Rec."Seminar Price"){}
        }
    }

    local procedure ShowDetails()
    begin
        Page.Run(Page::"SMB Seminar Card",Rec);
    end;
}
