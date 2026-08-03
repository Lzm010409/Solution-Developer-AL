codeunit 63621 "PTE Sw. Change Commission"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PTE Calculate Commission", OnAfterGetCommissionPercentage, '', false, false)]
    local procedure CalculateCommission_OnAfterGetCommissionPercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"; var CommissionPercentage: Decimal)
    begin
        ApplySoftwareChangePercentage(CommissionJournalLine, CommissionPercentage);
    end;

    [EventSubscriber(ObjectType::Table, Database::"PTE Commission Ledger Entry", OnAfterCopyFromJnlLine, '', false, false)]
    local procedure CommissionLedgerEntry_OnAfterCopyFromJnlLine(var CommissionLedgerEntry: Record "PTE Commission Ledger Entry"; CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        TransferSoftwareChangeNo(CommissionLedgerEntry, CommissionJournalLine);
    end;


    local procedure ApplySoftwareChangePercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"; var CommissionPercentage: Decimal)
    begin
        if CommissionJournalLine."PTE Accounting Type" = CommissionJournalLine."PTE Accounting Type"::"Commission Contract" then
            exit;
        CommissionPercentage := CommissionJournalLine."PTE Commission Percentage";
    end;

    local procedure TransferSoftwareChangeNo(var CommissionLedgerEntry: Record "PTE Commission Ledger Entry"; CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        CommissionLedgerEntry."PTE Software Change No." := CommissionJournalLine."PTE Software Change No.";
    end;
}
