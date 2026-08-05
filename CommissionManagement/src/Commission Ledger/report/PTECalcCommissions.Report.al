report 63000 "PTE Calc. Commissions"
{
    Caption = 'Calculate Commissions', Comment = 'de-DE=Berechne Provisionen';
    ApplicationArea = All;
    UsageCategory = Tasks;

    ProcessingOnly = true;

    dataset
    {
        dataitem(Salesperson; "Salesperson/Purchaser")
        {
            RequestFilterFields = "Code", Name;

            dataitem(CustLedgEntry; "Cust. Ledger Entry")
            {
                RequestFilterFields = "Posting Date";

                DataItemLink = "Salesperson Code" = field("Code");
                DataItemTableView = where("Document Type" = filter(Invoice | "Credit Memo"));

                trigger onAfterGetRecord()
                var
                    CalculateCommission: Codeunit "PTE Calculate Commission";
                begin
                    Counter += 1;
                    UpdateProgress();
                    if CalculateCommission.IsAlreadyCommissioned(Salesperson.Code, CustLedgEntry."Entry No.") then
                        CurrReport.Skip();
                    CalcFields(CustLedgEntry."Amount (LCY)");
                    PostCommissionForCustLedgEntry();
                end;
            }

            trigger onAfterGetRecord()
            var
                Contract: Record "PTE Commission Contract";
                CustLedgEntryForSalesperson: Record "Cust. Ledger Entry";
            begin
                CurrentSalespersonName := Salesperson.Name;
                Counter := 0;
                CustLedgEntryForSalesperson.SetRange("Salesperson Code", Salesperson.Code);
                CustLedgEntryForSalesperson.SetRange("Document Type", "Gen. Journal Document Type"::Invoice, "Gen. Journal Document Type"::"Credit Memo");
                TotalCount := CustLedgEntryForSalesperson.Count();
                UpdateProgress();

                if Salesperson."PTE Commission Contract No." = '' then
                    CurrReport.Skip();
                Contract.Get(Salesperson."PTE Commission Contract No.");
                Contract.TestField("Commission Percentage");
            end;

            trigger OnPreDataItem()
            begin
                Dialog.Open(ProgressDlgMsg);
            end;
        }
    }

    var
        Dialog: Dialog;
        CurrentSalespersonName: Text;
        LastSalespersonName: Text;
        ProgressDlgMsg: Label 'Calculate Commission for: #1 Progress: #2', Comment = 'de-DE=Berechne Provision für: #1 Fortschritt: #2';
        Counter: Integer;
        TotalCount: Integer;
        LastPercent: Integer;

    local procedure PostCommissionForCustLedgEntry()
    var
        CommissionJournalLine: Record "PTE Commission Journal Line";
        CommisJnlPostLine: Codeunit "PTE Commis. Jnl.-Post Line";
    begin
        CommissionJournalLine.SetUpNewLine(Salesperson, CustLedgEntry);
        CommisJnlPostLine.RunWithCheck(CommissionJournalLine);
    end;

    local procedure UpdateProgress()
    var
        CurrentPercent: Integer;
    begin
        if CurrentSalespersonName <> LastSalespersonName then begin
            Dialog.Update(1, Format(CurrentSalespersonName));
            Dialog.Update(2, '0%');
            LastSalespersonName := CurrentSalespersonName;
        end else begin
            if TotalCount = 0 then
                exit;
            CurrentPercent := (Counter * 100) div TotalCount;
            if CurrentPercent <> LastPercent then begin
                Dialog.Update(1, Format(CurrentSalespersonName));
                Dialog.Update(2, Format(CurrentPercent) + '%');
                LastPercent := CurrentPercent;
            end;
        end;
    end;

    trigger OnPostReport()
    begin
        Dialog.Close();
    end;

    trigger OnPreReport();
    var
        PTECommissionManagementSetupCodeunit: Codeunit "PTE Com. Mgt. Validation";
    begin
        PTECommissionManagementSetupCodeunit.Run();
    end;
}
