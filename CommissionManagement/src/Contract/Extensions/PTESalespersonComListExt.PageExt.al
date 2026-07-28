pageextension 63002 "PTE Salesperson Com. List Ext" extends "Salespersons/Purchasers"
{
    layout
    {
        modify("Commission %")
        {
            Visible = false;
        }
        addlast(Control1)
        {
            field("PTECommission Contract No."; Rec."PTE Commission Contract No.")
            {
                Caption = 'Commission Contract No.', Comment = 'de-DE=Provisionsvertragsnr.';
                ToolTip = 'This is the Commission Contract No. of the Salesperson/Purchaser.', Comment = 'de-DE=Dies ist die Provisionsvertragsnr. des Verkäufers/Einkäufers.';
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    PTECommissionContract: Record "PTE Commission Contract";
                begin
                    if PTECommissionContract.get(Rec."PTE Commission Contract No.") then
                        Page.Run(page::"PTE Commission Contract Card", PTECommissionContract);
                end;
            }
            field("PTECommission Amount (LCY)"; Rec."PTE Commission Amount (LCY)")
            {
                Caption = 'Commission Amount (LCY)', Comment = 'de-DE=Provisionsbetrag (Lokalwährung)';
                ToolTip = 'This is the Commission Amount (LCY) of the Salesperson/Purchaser.', Comment = 'de-DE=Dies ist der Provisionsbetrag (LCY) des Verkäufers/Einkäufers.';
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    PTECommissionLedgerEntries: Record "PTE Commission Ledger Entry";
                begin
                    PTECommissionLedgerEntries.SetRange("Salesperson Code", Rec.Code);
                    Page.Run(page::"PTE Commission Ledger Entries", PTECommissionLedgerEntries);
                end;

            }
        }
    }
    actions
    {
        addlast("&Salesperson")
        {
            action("PTEOpenCommissionLedgerEntries")
            {
                ApplicationArea = All;
                Caption = 'Open Commission Ledger Entries', Comment = 'de-DE=Provisionsposten anzeigen';
                ToolTip = 'Open the list of Commission Ledger Entries for this Salesperson/Purchaser.', Comment = 'de-DE=Die Liste der Provisionsposten für diesen Verkäufer/Einkäufer öffnen';
                Image = OpenJournal;
                Visible = Rec."PTE Commission Contract No." <> '';
                RunObject = page "PTE Commission Ledger Entries";
                RunPageLink = "Salesperson Code" = field("Code");
            }
            action("PTEOpenCommissionContract")
            {
                ApplicationArea = All;
                Caption = 'Open Commission Contract', Comment = 'de-DE=Provisionsvertrag öffnen';
                ToolTip = 'Open the Commission Contract for this Salesperson/Purchaser.', Comment = 'de-DE=Den Provisionsvertrag für diesen Verkäufer/Einkäufer öffnen';
                Image = Document;
                Visible = Rec."PTE Commission Contract No." <> '';
                RunObject = page "PTE Commission Contract Card";
                RunPageLink = "No." = field("PTE Commission Contract No.");
            }
        }

        addlast("Category_Category4")
        {
            actionref("PTEOpenCommissionLedgerEntriesRef"; "PTEOpenCommissionLedgerEntries")
            {
            }
            actionref("PTEOpenCommissionContractRef"; "PTEOpenCommissionContract")
            {
            }
        }
    }
}
