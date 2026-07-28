page 63000 "PTE Commission Mgt. Setup Card"
{
    PageType = Card;
    SourceTable = "PTE Commission Mgt. Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Commission Management Setup', Comment = 'de-DE=Provisionsmanagement Einrichtung';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'de-DE=Allgemein';

                field("Rounding Precision"; Rec."Rounding Precision")
                {
                    ApplicationArea = All;
                }
                field("Contract Nos."; Rec."Contract Nos.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    
    actions
    {
        area(Navigation)
        {
            group(PTECommission)
            {
                Caption = 'Commission', Comment = 'de-DE=Provision';
                ToolTip = 'Navigate to commission management related pages.', Comment = 'de-DE=Hierüber lässt sich zu den Seiten rund um die Provisionsverwaltung navigieren.';
                action(PTECommissionTypes)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Types', Comment = 'de-DE=Provisionsarten';
                    ToolTip = 'Manage commission types.', Comment = 'de-DE=Hierüber lassen sich die Provisionsarten verwalten.';
                    Image = List;
                    RunObject = page "PTE Commission Type List";
                }
                action(PTESalesPersons)
                {
                    ApplicationArea = All;
                    Caption = 'Salespersons', Comment = 'de-DE=Verkäufer';
                    ToolTip = 'Manage salespersons.', Comment = 'de-DE=Hierüber lassen sich die Verkäufer verwalten.';
                    Image = SalesPerson;
                    RunObject = page "Salespersons/Purchasers";
                }
                action(PTECommissionContracts)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Contracts', Comment = 'de-DE=Provisionsverträge';
                    ToolTip = 'View and manage commission contracts.', Comment = 'de-DE=Hierüber lassen sich die Provisionsverträge anzeigen und verwalten.';
                    Image = ContractPayment;
                    RunObject = page "PTE Commission Contract List";
                }
                action(PTECommissionLedgerEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Ledger Entries', Comment = 'de-DE=Provisionsposten';
                    ToolTip = 'View commission ledger entries.', Comment = 'de-DE=Hierüber lassen sich die Provisionsposten anzeigen.';
                    Image = LedgerEntries;
                    RunObject = page "PTE Commission Ledger Entries";
                }
                action(PTECalculateCommissions)
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Commissions', Comment = 'de-DE=Provisionen Berechnen';
                    ToolTip = 'Calculate commissions based on the defined contracts and ledger entries.', Comment = 'de-DE=Hierüber lassen sich die Provisionen basierend auf den definierten Verträgen und Posten berechnen.';
                    Image = CalculateCost;
                    RunObject = report "PTE Calc. Commissions";
                }
                action(PTECommissionComments)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Comments', Comment = 'de-DE=Provisionskommentare';
                    ToolTip = 'View and manage commission comments.', Comment = 'de-DE=Hierüber lassen sich die Provisionskommentare anzeigen und verwalten.';
                    Image = Comment;
                    RunObject = page "PTE Commission Comment Sheet";
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Commission', Comment = 'de-DE=Provision';

                actionref(CommissionPageRef; PTECommissionContracts)
                {
                }
                actionref(CommissionContractTypesRef; PTECommissionTypes)
                {
                }
                actionref(SalesPersonRef; PTESalesPersons)
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        Setup: Record "PTE Commission Mgt. Setup";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup.Insert();
        end;
    end;
}