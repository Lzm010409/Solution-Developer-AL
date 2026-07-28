codeunit 63021 "PTE Calculate Commission"
{
    procedure Calculate(SalesmanCommission: Decimal; SalesAmount: Decimal; DocumentType: Enum "Gen. Journal Document Type"): Decimal
    var
        Amount: Decimal;
    begin
        if SalesAmount = 0 then
            exit(0);
        Amount := (SalesAmount / 100) * SalesmanCommission;
        exit(Amount);
    end;

    procedure IsAlreadyCommissioned(SalespersonCode: Code[20]; LedgerEntryNo: Integer): Boolean
    var
        CommissionLedgerEntry: Record "PTE Commission Ledger Entry";
    begin
        CommissionLedgerEntry.SetRange("Salesperson Code", SalespersonCode);
        CommissionLedgerEntry.SetRange("Customer Ledger Entry No.", LedgerEntryNo);
        exit(not CommissionLedgerEntry.IsEmpty());
    end;
}