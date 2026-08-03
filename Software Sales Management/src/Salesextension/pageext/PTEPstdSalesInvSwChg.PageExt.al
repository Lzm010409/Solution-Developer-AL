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
                ToolTip = 'Specifies the Software Change No. the posted sales invoice belongs to.', Comment = 'de-DE=Gibt die Softwareanpassungsnr. an, zu der die gebuchte Verkaufsrechnung gehört.';
            }
        }
    }
}
