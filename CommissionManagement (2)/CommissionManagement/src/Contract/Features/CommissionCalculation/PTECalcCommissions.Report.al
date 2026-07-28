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
                    PTECalculateCommissionCodenunit: Codeunit "PTE Calculate Commission";
                    PTEPostLedgerEntry: Codeunit "PTE Post Com. Ledger Entry";
                    CommissionAmount: Decimal;
                    RoundedCommissionAmount: Decimal;
                begin
                    Counter += 1;
                    UpdateProgress();
                    if (PTECalculateCommissionCodenunit.IsAlreadyCommissioned(Salesperson.Code, CustLedgEntry."Entry No.")) then
                        CurrReport.Skip();
                    CalcFields(CustLedgEntry."Amount (LCY)");
                    CommissionAmount := PTECalculateCommissionCodenunit.Calculate(CurrentCommissionPct, CustLedgEntry."Amount (LCY)", CustLedgEntry."Document Type");
                    RoundedCommissionAmount := Round(CommissionAmount, RoundingValue);
                    PTEPostLedgerEntry.PostNewEntry(Salesperson, CustLedgEntry, RoundedCommissionAmount);
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

                Clear(CurrentCommissionPct);
                if Salesperson."PTE Commission Contract No." = '' then
                    CurrReport.Skip();
                Contract.Get(Salesperson."PTE Commission Contract No.");
                Contract.TestField("Commission Percentage");
                CurrentCommissionPct := Contract."Commission Percentage";
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
        CurrentCommissionPct: Decimal;
        RoundingValue: Decimal;
        ProgressDlgMsg: Label 'Calculate Commission for: #1 Progress: #2', Comment = 'de-DE=Berechne Provision für: #1 Fortschritt: #2';
        Counter: Integer;
        TotalCount: Integer;
        LastPercent: Integer;

    local procedure UpdateProgress()
    var
        CurrentPercent: Integer;
    begin
        Sleep(500);
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
        PTECommissionSetup: Record "PTE Commission Mgt. Setup";
        PTECommissionManagementSetupCodeunit: Codeunit "PTE Com. Mgt. Validation";
    begin
        PTECommissionManagementSetupCodeunit.Run();
        PTECommissionSetup.Get();
        RoundingValue := PTECommissionSetup."Rounding Precision";
    end;

}