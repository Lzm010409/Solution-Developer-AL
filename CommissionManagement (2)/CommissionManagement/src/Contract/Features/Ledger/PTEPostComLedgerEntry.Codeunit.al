codeunit 63022 "PTE Post Com. Ledger Entry"
{
    Permissions = tabledata "PTE Commission Ledger Entry" = RI;

    procedure PostNewEntry(SalesPerson: Record "Salesperson/Purchaser"; CustomerLedgerEntry: Record "Cust. Ledger Entry"; CommissionAmountLCY: Decimal)
    var
        NewEntry: Record "PTE Commission Ledger Entry";
    begin
        NewEntry.Init();
        NewEntry."Posting Date" := WorkDate();
        if (CustomerLedgerEntry."Document Type" = "Gen. Journal Document Type"::Invoice) then
            NewEntry."Document Type" := "PTE Com. Led. Ent. Doc. Type"::Invoice
        else
            NewEntry."Document Type" := "PTE Com. Led. Ent. Doc. Type"::"Credit Memo";
        NewEntry."Document No." := CustomerLedgerEntry."Document No.";
        NewEntry."Customer No." := CustomerLedgerEntry."Customer No.";
        NewEntry."Amount (LCY)" := CustomerLedgerEntry."Amount (LCY)";
        NewEntry."Amount" := CustomerLedgerEntry."Amount (LCY)";
        NewEntry."Salesperson Code" := SalesPerson.Code;
        NewEntry."Commission Contract No." := SalesPerson."PTE Commission Contract No.";
        NewEntry."Customer Ledger Entry No." := CustomerLedgerEntry."Entry No.";
        NewEntry."Commission Amount (LCY)" := CommissionAmountLCY;
        NewEntry."Currency Code" := CustomerLedgerEntry."Currency Code";
        NewEntry.Insert(true);
    end;
}