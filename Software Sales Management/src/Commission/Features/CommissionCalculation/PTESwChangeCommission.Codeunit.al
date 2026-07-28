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

    /// <summary>
    /// Replaces the commission percentage of the commission contract with the one agreed for a
    /// single software change. This only applies when the software change is accounted for by
    /// itself and carries a percentage of its own.
    /// </summary>
    local procedure ApplySoftwareChangePercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"; var CommissionPercentage: Decimal)
    begin
        if CommissionJournalLine."PTE Accounting Type" <> "PTE Accounting Type"::"Software Change" then
            exit;
        if CommissionJournalLine."PTE Commission Percentage" = 0 then
            exit;

        CommissionPercentage := CommissionJournalLine."PTE Commission Percentage";
    end;

    local procedure TransferSoftwareChangeNo(var CommissionLedgerEntry: Record "PTE Commission Ledger Entry"; CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        CommissionLedgerEntry."PTE Software Change No." := CommissionJournalLine."PTE Software Change No.";
    end;
}
