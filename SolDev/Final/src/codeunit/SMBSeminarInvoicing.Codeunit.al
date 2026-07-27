codeunit 123456710 "SMB Seminar Invoicing"
{
    Permissions = tabledata "SMB Seminar Ledger Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterTestSalesLine, '', false, false)]
    local procedure "CheckSeminarInvoicingSalesPostOnAfterTestSalesLine"(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean)
    var
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
    begin
        if (SalesLine."SMB Apply-to Seminar Entry" <> 0) and (SalesHeader."Document Type" = SalesHeader."Document Type"::Invoice) then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry.TestField("Closed by Document No.", '', ErrorInfo.Create());
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesInvLineInsert, '', false, false)]
    local procedure "CloseSeminarLedgerSalesPostOnAfterSalesInvLineInsert"(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; PreviewMode: Boolean)
    var
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
    begin
        if SalesLine."SMB Apply-to Seminar Entry" <> 0 then begin
            SMBSeminarLedgerEntry.Get(SalesLine."SMB Apply-to Seminar Entry");
            SMBSeminarLedgerEntry."Closed by Document No." := SalesInvLine."Document No.";
            SMBSeminarLedgerEntry.Modify();            
        end;
    end;

}