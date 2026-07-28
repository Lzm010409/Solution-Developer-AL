codeunit 63021 "PTE Calculate Commission"
{
    [Obsolete('Replaced by CalculateCommissionAmount, which posts through the commission journal line and can be intercepted by other extensions.', '1.1.0.0')]
    procedure Calculate(SalesmanCommission: Decimal; SalesAmount: Decimal; DocumentType: Enum "Gen. Journal Document Type"): Decimal
    var
        Amount: Decimal;
    begin
        if SalesAmount = 0 then
            exit(0);
        Amount := (SalesAmount / 100) * SalesmanCommission;
        exit(Amount);
    end;

    /// <summary>
    /// Indicates that a commission has already been created for a salesperson and a customer
    /// entry. Keeps the same document from being commissioned a second time.
    /// </summary>
    procedure IsAlreadyCommissioned(SalespersonCode: Code[20]; LedgerEntryNo: Integer): Boolean
    var
        CommissionLedgerEntry: Record "PTE Commission Ledger Entry";
    begin
        CommissionLedgerEntry.SetRange("Salesperson Code", SalespersonCode);
        CommissionLedgerEntry.SetRange("Customer Ledger Entry No.", LedgerEntryNo);
        exit(not CommissionLedgerEntry.IsEmpty());
    end;

    /// <summary>
    /// Determines the commission percentage that applies to a single commission journal line.
    /// Other extensions can supply a deviating percentage through the published events.
    /// </summary>
    /// <param name="CommissionJournalLine">The journal line the percentage is determined for.</param>
    procedure GetCommissionPercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"): Decimal
    var
        CommissionContract: Record "PTE Commission Contract";
        CommissionPercentage: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeGetCommissionPercentage(CommissionJournalLine, CommissionPercentage, IsHandled);
        if not IsHandled then begin
            CommissionContract.SetLoadFields("Commission Percentage");
            if CommissionContract.Get(CommissionJournalLine."Commission Contract No.") then
                CommissionPercentage := CommissionContract."Commission Percentage";
        end;

        OnAfterGetCommissionPercentage(CommissionJournalLine, CommissionPercentage);
        exit(CommissionPercentage);
    end;

    /// <summary>
    /// Calculates the commission amount for a single commission journal line.
    /// Credit memos carry a negative sales amount and therefore yield a negative commission.
    /// </summary>
    /// <param name="CommissionJournalLine">The journal line the amount is calculated for.</param>
    /// <param name="CommissionPercentage">The percentage determined by GetCommissionPercentage.</param>
    /// <param name="SalesAmount">The sales amount the commission is based on, in local currency.</param>
    procedure CalculateCommissionAmount(var CommissionJournalLine: Record "PTE Commission Journal Line"; CommissionPercentage: Decimal; SalesAmount: Decimal): Decimal
    var
        CommissionAmount: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateCommissionAmount(CommissionJournalLine, CommissionPercentage, SalesAmount, CommissionAmount, IsHandled);
        if not IsHandled then
            if SalesAmount <> 0 then
                CommissionAmount := (SalesAmount / 100) * CommissionPercentage;

        OnAfterCalculateCommissionAmount(CommissionJournalLine, CommissionPercentage, SalesAmount, CommissionAmount);
        exit(CommissionAmount);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetCommissionPercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"; var CommissionPercentage: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetCommissionPercentage(var CommissionJournalLine: Record "PTE Commission Journal Line"; var CommissionPercentage: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateCommissionAmount(var CommissionJournalLine: Record "PTE Commission Journal Line"; CommissionPercentage: Decimal; SalesAmount: Decimal; var CommissionAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateCommissionAmount(var CommissionJournalLine: Record "PTE Commission Journal Line"; CommissionPercentage: Decimal; SalesAmount: Decimal; var CommissionAmount: Decimal)
    begin
    end;
}
