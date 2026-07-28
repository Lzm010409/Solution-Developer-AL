codeunit 63023 "PTE Commission Contract"
{
    procedure HasRemainingSalesman(CommissionContractNo: Code[20]): Boolean
    var
        SalesPerson: Record "Salesperson/Purchaser";

    begin
        SalesPerson.setRange("PTE Commission Contract No.", CommissionContractNo);
        if not SalesPerson.IsEmpty() then
            exit(true);
        exit(false);
    end;

    procedure ClearLedgerEntriesForContract(CommissionContractNo: Code[20])
    var
        PTELedgerEntries: Record "PTE Commission Ledger Entry";
    begin
        PTELedgerEntries.setRange("Commission Contract No.", CommissionContractNo);
        if not PTELedgerEntries.IsEmpty() then begin
            PTELedgerEntries.FindSet();
            repeat
                PTELedgerEntries."Commission Contract No." := '';
                PTELedgerEntries.Modify();
            until PTELedgerEntries.Next() = 0;
        end;
    end;

    procedure DeleteCommentsForContract(CommissionContractNo: Code[20])
    var
        PTECommentLine: Record "PTE Commission Comment Line";
    begin
        PTECommentLine.SetRange("No.", CommissionContractNo);
        PTECommentLine.deleteAll();
    end;
}