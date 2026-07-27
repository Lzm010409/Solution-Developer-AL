codeunit 123456704 "SMB Seminar Navigate"
{

    var
        SMBPostedSeminarRegHeader: Record "SMB Posted Seminar Reg. Header";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterFindRecords, '', false, false)]
    local procedure InsertRecordsNavigateOnAfterFindRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindPstSeminarRegHeader(DocumentEntry, DocNoFilter, PostingDateFilter);
        FindSeminarEntries(DocumentEntry, DocNoFilter, PostingDateFilter);

    end;

    [EventSubscriber(ObjectType::Page, Page::Navigate, OnAfterShowRecords, '', false, false)]
    local procedure Navigate_OnAfterShowRecords(var Sender: Page Navigate; var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    begin
        case DocumentEntry."Table ID" of
            Database::"SMB Posted Seminar Reg. Header":
                begin
                    SetPstSeminarRegHeaderFilter(DocNoFilter, PostingDateFilter);
                    PAGE.Run(PAGE::"SMB Pst. Sem. Registration", SMBPostedSeminarRegHeader);
                end;
            Database::"SMB Seminar Ledger Entry":
                begin
                    SetSeminarLedgEntryFilter(DocNoFilter, PostingDateFilter);
                    PAGE.Run(0, SMBSeminarLedgerEntry);
                end;
        end;
    end;


    local procedure FindPstSeminarRegHeader(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if SMBPostedSeminarRegHeader.ReadPermission() then begin
            SetPstSeminarRegHeaderFilter(DocNoFilter, PostingDateFilter);
            DocumentEntry.InsertIntoDocEntry(
                Database::"SMB Posted Seminar Reg. Header",
                SMBPostedSeminarRegHeader.TableCaption,
                SMBPostedSeminarRegHeader.Count);
        end;
    end;

    local procedure FindSeminarEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        if (DocNoFilter = '') and (PostingDateFilter = '') then
            exit;
        if SMBSeminarLedgerEntry.ReadPermission() then begin
            SetSeminarLedgEntryFilter(DocNoFilter, PostingDateFilter);
            DocumentEntry.InsertIntoDocEntry(Database::"SMB Seminar Ledger Entry", SMBSeminarLedgerEntry.TableCaption(), SMBSeminarLedgerEntry.Count);
        end;
    end;

    local procedure SetPstSeminarRegHeaderFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        SMBPostedSeminarRegHeader.Reset();
        SMBPostedSeminarRegHeader.SetFilter("No.", DocNoFilter);
        SMBPostedSeminarRegHeader.SetFilter("Posting Date", PostingDateFilter);
    end;

    local procedure SetSeminarLedgEntryFilter(DocNoFilter: Text; PostingDateFilter: Text)
    begin
        SMBSeminarLedgerEntry.Reset();
        SMBSeminarLedgerEntry.SetCurrentKey("Document No.", "Posting Date");
        SMBSeminarLedgerEntry.SetFilter("Document No.", DocNoFilter);
        SMBSeminarLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
    end;
}