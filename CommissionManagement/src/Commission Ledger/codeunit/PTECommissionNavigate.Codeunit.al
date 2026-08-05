codeunit 63024 "PTE Commission Navigate"
{
    var
        CommissionLedgerEntry: Record "PTE Commission Ledger Entry";

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterFindRecords, '', false, false)]
    local procedure Navigate_OnAfterFindRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindCommissionLedgerEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure Navigate_OnAfterShowRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
        ShowCommissionLedgerEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    local procedure FindCommissionLedgerEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;
        if not CommissionLedgerEntry.ReadPermission() then
            exit;

        SetCommissionLedgerEntryFilter(DocNoFilter, PostingDateFilter);
        DocumentEntry.InsertIntoDocEntry(
            Database::"PTE Commission Ledger Entry",
            CommissionLedgerEntry.TableCaption(),
            CommissionLedgerEntry.Count());
    end;

    local procedure ShowCommissionLedgerEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if DocumentEntry."Table ID" <> Database::"PTE Commission Ledger Entry" then
            exit;

        SetCommissionLedgerEntryFilter(DocNoFilter, PostingDateFilter);
        Page.Run(Page::"PTE Commission Ledger Entries", CommissionLedgerEntry);
    end;

    local procedure SetCommissionLedgerEntryFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        CommissionLedgerEntry.Reset();
        CommissionLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        CommissionLedgerEntry.SetFilter("Document No.", DocNoFilter);
        CommissionLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
    end;
}
