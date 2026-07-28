pageextension 63605 "PTE Sw. Change Role Center" extends "Order Processor Role Center"
{
    actions
    {
        addlast(PTEProvisionsmanagement)
        {
            action(PTESoftwareChanges)
            {
                ApplicationArea = All;
                Caption = 'Software Changes', Comment = 'de-DE=Softwareanpassungen';
                ToolTip = 'Opens the Software Changes List.', Comment = 'de-DE=Öffnet die Liste der Softwareanpassungen.';
                RunObject = page "PTE Software Change List";
            }
            action(PTESoftwareChangeTemplates)
            {
                ApplicationArea = All;
                Caption = 'Software Change Templates', Comment = 'de-DE=Softwareanpassungsvorlagen';
                ToolTip = 'Opens the Software Change Templates List.', Comment = 'de-DE=Öffnet die Liste der Softwareanpassungsvorlagen.';
                RunObject = page "PTE Software Change Templates";
            }
            action(PTEPostedSoftwareChanges)
            {
                ApplicationArea = All;
                Caption = 'Posted Software Changes', Comment = 'de-DE=Geb. Softwareanpassungen';
                ToolTip = 'Opens the Posted Software Changes List.', Comment = 'de-DE=Öffnet die Liste der gebuchten Softwareanpassungen.';
                RunObject = page "PTE Posted Softw. Change List";
            }
        }
    }
}
