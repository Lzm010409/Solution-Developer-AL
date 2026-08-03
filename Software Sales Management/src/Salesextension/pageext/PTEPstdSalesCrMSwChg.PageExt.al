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
                ToolTip = 'Specifies the Software Change No. the posted sales credit memo belongs to.', Comment = 'de-DE=Gibt die Softwareanpassungsnr. an, zu der die gebuchte Verkaufsgutschrift gehört.';
            }
        }
    }
}
