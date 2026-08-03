pageextension 63603 "PTE Salesperson Card Sw. Chg." extends "Salesperson/Purchaser Card"
{
    actions
    {
        addlast("&Salesperson")
        {
            action("PTEOpenSoftwareChanges")
            {
                ApplicationArea = All;
                Caption = 'Software Changes', Comment = 'de-DE=Softwareanpassungen';
                ToolTip = 'View the open software changes of this salesperson, or add software changes to the record.', Comment = 'de-DE=Zeigt die offenen Softwareanpassungen dieses Verkäufers an, oder fügt dem Datensatz Softwareanpassungen hinzu.';
                Image = Order;
                RunObject = page "PTE Software Change List";
                RunPageLink = "Salesperson Code" = field("Code"),
                              Status = filter(<> Finished);
            }
        }
    }
}
