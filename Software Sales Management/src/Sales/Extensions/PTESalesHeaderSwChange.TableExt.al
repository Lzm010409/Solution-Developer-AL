tableextension 63600 "PTE Sales Header Sw. Change" extends "Sales Header"
{
    fields
    {
        field(63600; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'This is the PTE Software Change No. field added to the Sales Header table by the PTE Software Sales Management Extension. It carries no table relation because the software change is deleted when it is posted.', Comment = 'de-DE=Dies ist das Feld PTE Softwareanpassungsnr., das die Erweiterung PTE Software Verkaufsmanagement zur Tabelle Verkaufskopf hinzufügt. Es hat keine Tabellenrelation, weil die Softwareanpassung beim Buchen gelöscht wird.';
        }
    }
}
