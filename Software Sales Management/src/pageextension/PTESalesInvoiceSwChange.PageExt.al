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
                ToolTip = 'Specifies the Software Change No. the sales invoice belongs to.', Comment = 'de-DE=Gibt die Softwareanpassungsnr. an, zu der die Verkaufsrechnung gehört.';

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
                    Rec.UpdateSalesHeaderWithSoftwareChange(SoftwareChange."No.");
                    Text := SoftwareChange."No.";
                    exit(true);
                end;
            }
        }
    }
}
