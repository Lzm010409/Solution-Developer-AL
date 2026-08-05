pageextension 63000 "PTE Com. Contract Role Center" extends "Order Processor Role Center"
{
    actions
    {
        addafter(Action63)
        {
            group(PTEProvisionsmanagement)
            {
                Caption = 'Commission Management', Comment = 'de-DE=Provisionsmanagement';

                action(PTECommissionTypes)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Types', Comment = 'de-DE=Provisionsarten';
                    ToolTip = 'Opens the Commission Types List.', Comment = 'de-DE=Öffnet die Liste der Provisionsarten.';
                    RunObject = page "PTE Commission Type List"; 
                }

                action(PTESalespersons)
                {
                    ApplicationArea = All;
                    Caption = 'Salespersons', Comment = 'de-DE=Verkäufer';
                    ToolTip = 'Opens the Salespersons List.', Comment = 'de-DE=Öffnet die Liste der Verkäufer.';
                    RunObject = page "Salespersons/Purchasers";
                }

                action(PTECommissionContracts)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Contracts', Comment = 'de-DE=Provisionsverträge';
                    ToolTip = 'Opens the Commission Contracts List.', Comment = 'de-DE=Öffnet die Liste der Provisionsverträge.';
                    RunObject = page "PTE Commission Contract List"; 
                }

                action(PTECommissionLedgerEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Commission Ledger Entries', Comment = 'de-DE=Provisionsposten';
                    ToolTip = 'Opens the Commission Ledger Entries List.', Comment = 'de-DE=Öffnet die Liste der Provisionsposten.';
                    RunObject = page "PTE Commission Ledger Entries"; 
                }

                action(PTECalcCommissions)
                {
                    ApplicationArea = All;
                    Caption = 'Calculate Commissions', Comment = 'de-DE=Provisionen berechnen';
                    ToolTip = 'Runs the Calculate Commissions process.', Comment = 'de-DE=Führt den Prozess zur Berechnung der Provisionen aus.';
                    RunObject = report "PTE Calc. Commissions"; 
                }
            }
        }
    }
}
