pageextension 63600 "PTE Sales Invoice Sw. Change" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("PTESoftware Change No."; Rec."PTE Software Change No.")
            {
                ApplicationArea = All;
                Caption = 'Software Change No.', Comment = 'de-DE=Softwareanpassungsnr.';
                ToolTip = 'This is the Software Change No. the sales invoice belongs to.', Comment = 'de-DE=Dies ist die Softwareanpassungsnr., zu der die Verkaufsrechnung gehört.';

                trigger OnLookup(var Text: Text): Boolean
                var
                    SoftwareChange: Record "PTE Software Change";
                    SoftwareChangeList: Page "PTE Software Change List";
                begin
                    SoftwareChangeList.LookupMode(true);
                    SoftwareChangeList.SetTableView(SoftwareChange);
                    if SoftwareChangeList.RunModal() <> Action::LookupOK then
                        exit(false);

                    SoftwareChangeList.GetRecord(SoftwareChange);
                    Text := SoftwareChange."No.";
                    exit(true);
                end;
            }
        }
    }
}
