pageextension 63601 "PTE Pstd. Sales Inv. Sw. Chg." extends "Posted Sales Invoice"
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
                ToolTip = 'This is the Software Change No. the posted sales invoice belongs to.', Comment = 'de-DE=Dies ist die Softwareanpassungsnr., zu der die gebuchte Verkaufsrechnung gehört.';
            }
        }
    }
}
