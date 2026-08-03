tableextension 63601 "PTE Sales Inv. Hdr. Sw. Chg." extends "Sales Invoice Header"
{
    fields
    {
        field(63600; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'Specifies the PTE Software Change No. field added to the Sales Invoice Header table by the PTE Software Sales Management Extension.', Comment = 'de-DE=Gibt das Feld PTE Softwareanpassungsnr. an, das die Erweiterung PTE Software Verkaufsmanagement zur Tabelle Verkaufsrechnungskopf hinzufügt.';
        }
    }
}
