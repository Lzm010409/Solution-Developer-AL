pageextension 63602 "PTE Pstd. Sales Cr.M. Sw.Chg." extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field("PTESoftware Change No."; Rec."PTE Software Change No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Software Change No.', Comment = 'de-DE=Softwareanpassungsnr.';
                ToolTip = 'This is the Software Change No. the posted sales credit memo belongs to.', Comment = 'de-DE=Dies ist die Softwareanpassungsnr., zu der die gebuchte Verkaufsgutschrift gehört.';
            }
        }
    }
}
