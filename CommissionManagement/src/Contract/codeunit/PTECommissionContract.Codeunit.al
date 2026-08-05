codeunit 63023 "PTE Commission Contract"
{
    procedure HasRemainingSalesman(CommissionContractNo: Code[20]): Boolean
    var
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        SalesPerson.SetRange("PTE Commission Contract No.", CommissionContractNo);
        exit(not SalesPerson.IsEmpty());
    end;

    procedure HasLedgerEntries(CommissionContractNo: Code[20]): Boolean
    var
        CommissionLedgerEntry: Record "PTE Commission Ledger Entry";
    begin
        CommissionLedgerEntry.SetRange("Commission Contract No.", CommissionContractNo);
        exit(not CommissionLedgerEntry.IsEmpty());
    end;

    [Obsolete('Commission ledger entries are never changed. A contract that still has entries cannot be deleted, see HasLedgerEntries.', '1.1.0.0')]
    procedure ClearLedgerEntriesForContract(CommissionContractNo: Code[20])
    var
        PTELedgerEntries: Record "PTE Commission Ledger Entry";
    begin
        PTELedgerEntries.SetRange("Commission Contract No.", CommissionContractNo);
        if PTELedgerEntries.FindSet() then
            repeat
                PTELedgerEntries."Commission Contract No." := '';
                PTELedgerEntries.Modify();
            until PTELedgerEntries.Next() = 0;
    end;

    procedure DeleteCommentsForContract(CommissionContractNo: Code[20])
    var
        PTECommentLine: Record "PTE Commission Comment Line";
    begin
        PTECommentLine.SetRange("No.", CommissionContractNo);
        if not PTECommentLine.IsEmpty() then
            PTECommentLine.DeleteAll();
    end;
}
