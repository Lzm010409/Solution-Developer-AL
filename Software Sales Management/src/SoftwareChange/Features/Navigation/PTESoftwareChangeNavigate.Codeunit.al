codeunit 63640 "PTE Software Change Navigate"
{
    var
        PostedSoftwareChange: Record "PTE Posted Software Change";

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterFindRecords, '', false, false)]
    local procedure Navigate_OnAfterFindRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindPostedSoftwareChanges(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure Navigate_OnAfterShowRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
        ShowPostedSoftwareChanges(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    local procedure FindPostedSoftwareChanges(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;
        if not PostedSoftwareChange.ReadPermission() then
            exit;

        SetPostedSoftwareChangeFilter(DocNoFilter, PostingDateFilter);
        DocumentEntry.InsertIntoDocEntry(
            Database::"PTE Posted Software Change",
            PostedSoftwareChange.TableCaption(),
            PostedSoftwareChange.Count());
    end;

    local procedure ShowPostedSoftwareChanges(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if DocumentEntry."Table ID" <> Database::"PTE Posted Software Change" then
            exit;

        SetPostedSoftwareChangeFilter(DocNoFilter, PostingDateFilter);
        Page.Run(Page::"PTE Posted Softw. Change List", PostedSoftwareChange);
    end;

    local procedure SetPostedSoftwareChangeFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        PostedSoftwareChange.Reset();
        PostedSoftwareChange.SetFilter("Sales Invoice No.", DocNoFilter);
        PostedSoftwareChange.SetFilter("Posting Date", PostingDateFilter);
    end;
}
