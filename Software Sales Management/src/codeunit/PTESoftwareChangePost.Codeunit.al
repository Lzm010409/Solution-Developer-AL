codeunit 63630 "PTE Software Change-Post"
{
    Permissions = tabledata "PTE Posted Software Change" = RIMD,
                  tabledata "PTE Software Change" = RIMD;
    TableNo = "PTE Software Change";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        PostedSoftwareChange: Record "PTE Posted Software Change";
        SoftwareSalesMgtSetup: Record "PTE Software Sales Mgt. Setup";
        Window: Dialog;
        SetupRead: Boolean;
        PostingMsg: Label 'Posting software change  #1##################\', Comment = 'de-DE=Buche Softwareanpassung  #1##################\\';

    /// <summary>
    /// Invoices a software change in one go: it is checked, billed as a sales invoice, turned
    /// into a historical document, commissioned and finally removed. The routine performs no
    /// user interaction so that it stays callable from tests and background sessions.
    /// </summary>
    procedure RunWithCheck(var SoftwareChange2: Record "PTE Software Change")
    var
        SoftwareChange: Record "PTE Software Change";
        SalesInvoiceNo: Code[20];
    begin
        ClearAllVariables();
        GetSetup();
        SoftwareChange := SoftwareChange2;

        CheckSoftwareChange(SoftwareChange);
        LockTables();
        InitProgressWindow(SoftwareChange);

        // The order of these four steps is binding: the invoice has to exist before the
        // commission can be determined, because the commission is based on the amount of the
        // resulting customer entry, and the original record may only be removed once both
        // documents have been created.
        SalesInvoiceNo := PostSalesInvoice(SoftwareChange);
        InsertPostedSoftwareChange(SoftwareChange, SalesInvoiceNo);
        PostCommission(SoftwareChange, SalesInvoiceNo);
        FinalizeSoftwareChange(SoftwareChange);

        CloseProgressWindow();
        Commit();

        SoftwareChange2 := SoftwareChange;
    end;

    /// <summary>
    /// Returns the historical document created by the last run, so that the calling routine can
    /// report it back to the user.
    /// </summary>
    procedure GetPostedSoftwareChange(var PostedSoftwareChange2: Record "PTE Posted Software Change")
    begin
        PostedSoftwareChange2 := PostedSoftwareChange;
    end;

    local procedure ClearAllVariables()
    begin
        ClearAll();
        Clear(PostedSoftwareChange);
        Clear(SoftwareSalesMgtSetup);
    end;

    local procedure CheckSoftwareChange(var SoftwareChange: Record "PTE Software Change")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        SoftwareChange.TestField("No.");
        SoftwareChange.TestField(Description);
        SoftwareChange.TestField(Status, SoftwareChange.Status::Finished);
        SoftwareChange.TestField("Customer No.");
        SoftwareChange.TestField("Salesperson Code");
        SoftwareChange.TestField("Gen. Bus. Posting Group");
        SoftwareChange.TestField("VAT Bus. Posting Group");
        SoftwareChange.TestField("Developer Resource No.");
        SoftwareChange.TestField("Quantity Implementation (hrs)");
        SoftwareChange.TestField("Accounting Type");

        UserSetupManagement.CheckAllowedPostingDate(WorkDate());
    end;

    local procedure LockTables()
    var
        SoftwareChange: Record "PTE Software Change";
    begin
        SoftwareChange.LockTable();
        PostedSoftwareChange.LockTable();
    end;

    local procedure PostSalesInvoice(SoftwareChange: Record "PTE Software Change"): Code[20]
    var
        SalesHeader: Record "Sales Header";
    begin
        CreateSalesInvoice(SoftwareChange, SalesHeader);
        exit(PostSalesHeader(SalesHeader));
    end;

    local procedure CreateSalesInvoice(SoftwareChange: Record "PTE Software Change"; var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", SoftwareChange."Customer No.");
        SalesHeader.Validate("Posting Date", WorkDate());
        SalesHeader.Validate("Document Date", WorkDate());
        SalesHeader.Validate("Salesperson Code", SoftwareChange."Salesperson Code");
        SalesHeader.Validate("Gen. Bus. Posting Group", SoftwareChange."Gen. Bus. Posting Group");
        SalesHeader.Validate("VAT Bus. Posting Group", SoftwareChange."VAT Bus. Posting Group");
        if SoftwareChange."Contact No." <> '' then
            SalesHeader.Validate("Sell-to Contact No.", SoftwareChange."Contact No.");
        SalesHeader."PTE Software Change No." := SoftwareChange."No.";
        SalesHeader.Modify(true);

        CreateSalesLine(SoftwareChange, SalesHeader);
    end;

    local procedure CreateSalesLine(SoftwareChange: Record "PTE Software Change"; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine."Line No." := 10000;
        SalesLine.Insert(true);

        SalesLine.Validate(Type, SalesLine.Type::Resource);
        SalesLine.Validate("No.", SoftwareChange."Developer Resource No.");
        SalesLine.Validate(Quantity, SoftwareChange."Quantity Implementation (hrs)");
        SalesLine.Description := SoftwareChange.Description;
        SalesLine.Modify(true);
    end;

    local procedure PostSalesHeader(var SalesHeader: Record "Sales Header"): Code[20]
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesPost: Codeunit "Sales-Post";
        PreAssignedNo: Code[20];
    begin
        PreAssignedNo := SalesHeader."No.";
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        SalesPost.Run(SalesHeader);

        // The posted document is located through the number the unposted one carried, because
        // posting may draw a number from a separate series.
        SalesInvoiceHeader.SetRange("Pre-Assigned No.", PreAssignedNo);
        SalesInvoiceHeader.FindLast();
        exit(SalesInvoiceHeader."No.");
    end;

    local procedure InsertPostedSoftwareChange(SoftwareChange: Record "PTE Software Change"; SalesInvoiceNo: Code[20])
    var
        SoftwareChangeMgt: Codeunit "PTE Software Change";
        RecordLinkManagement: Codeunit "Record Link Management";
        NoSeries: Codeunit "No. Series";
    begin
        PostedSoftwareChange.Init();
        PostedSoftwareChange.TransferFields(SoftwareChange);
        PostedSoftwareChange."No. Series" := SoftwareSalesMgtSetup."Posted Software Change Nos.";
        PostedSoftwareChange."No." := NoSeries.GetNextNo(PostedSoftwareChange."No. Series", WorkDate());
        PostedSoftwareChange."Software Change No." := SoftwareChange."No.";
        PostedSoftwareChange."Sales Invoice No." := SalesInvoiceNo;
        PostedSoftwareChange."Posting Date" := WorkDate();
        PostedSoftwareChange."User ID" := CopyStr(UserId(), 1, MaxStrLen(PostedSoftwareChange."User ID"));
        PostedSoftwareChange.Insert(true);

        SoftwareChangeMgt.CopyComments(
            "Comment Line Table Name"::"PTE Software Change",
            "Comment Line Table Name"::"PTE Posted Software Change",
            SoftwareChange."No.",
            PostedSoftwareChange."No.");

        RecordLinkManagement.CopyLinks(SoftwareChange, PostedSoftwareChange);
    end;

    local procedure PostCommission(SoftwareChange: Record "PTE Software Change"; SalesInvoiceNo: Code[20])
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        CommissionJournalLine: Record "PTE Commission Journal Line";
        CommisJnlPostLine: Codeunit "PTE Commis. Jnl.-Post Line";
    begin
        SalespersonPurchaser.Get(SoftwareChange."Salesperson Code");
        if SalespersonPurchaser."PTE Commission Contract No." = '' then
            exit;

        FindCustLedgerEntry(SalesInvoiceNo, CustLedgerEntry);
        CustLedgerEntry.CalcFields("Amount (LCY)");

        CommissionJournalLine.SetUpNewLine(SalespersonPurchaser, CustLedgerEntry);
        CommissionJournalLine.Validate("Posting Date", CustLedgerEntry."Posting Date");
        CommissionJournalLine."Posting Description" := SoftwareChange.Description;
        CommissionJournalLine."PTE Software Change No." := PostedSoftwareChange."No.";
        CommissionJournalLine."PTE Accounting Type" := SoftwareChange."Accounting Type";
        CommissionJournalLine."PTE Commission Percentage" := SoftwareChange."Commission Percentage";

        CommisJnlPostLine.RunWithCheck(CommissionJournalLine);
    end;

    local procedure FindCustLedgerEntry(SalesInvoiceNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry.SetRange("Document Type", CustLedgerEntry."Document Type"::Invoice);
        CustLedgerEntry.SetRange("Document No.", SalesInvoiceNo);
        CustLedgerEntry.FindLast();
    end;

    local procedure FinalizeSoftwareChange(var SoftwareChange: Record "PTE Software Change")
    begin
        if SoftwareChange.HasLinks() then
            SoftwareChange.DeleteLinks();
        SoftwareChange.Delete(true);
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
            exit;

        SoftwareSalesMgtSetup.Get();
        SoftwareSalesMgtSetup.TestField("Posted Software Change Nos.");
        SetupRead := true;
    end;

    local procedure InitProgressWindow(SoftwareChange: Record "PTE Software Change")
    begin
        if not GuiAllowed() then
            exit;

        Window.Open(PostingMsg);
        Window.Update(1, SoftwareChange."No.");
    end;

    local procedure CloseProgressWindow()
    begin
        if not GuiAllowed() then
            exit;

        Window.Close();
    end;
}
