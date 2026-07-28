tableextension 63604 "PTE Com. Led. Entry Sw. Chg." extends "PTE Commission Ledger Entry"
{
    fields
    {
        field(63610; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Posted Software Change";
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'This is the number of the posted software change the commission ledger entry originates from.', Comment = 'de-DE=Dies ist die Nummer der gebuchten Softwareanpassung, aus der der Provisionsposten stammt.';
        }
    }
}
