report 123456798 "SMB Create Seminar Invoices"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem("SMB Seminar Ledger Entry"; "SMB Seminar Ledger Entry")
        {
            DataItemTableView = sorting("Bill-to Customer No.") where("Charge Type" = const("SMB Sem. Ledger Charge Type"::Participant),
                                                                      "Closed by Document No." = const(''))                                                                    ;
            RequestFilterFields = "Seminar No.";

            trigger OnAfterGetRecord()
            begin
                if "Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then
                    CreateSalesHeader();

                CreateSalesLine();
            end;

        }
    }
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        GeneralPostingSetup: Record "General Posting Setup";
        NextLineNo: Integer;

    local procedure CreateSalesLine()
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := NextLineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");

        GeneralPostingSetup.Get(
            "SMB Seminar Ledger Entry"."Gen. Bus. Posting Group",
            "SMB Seminar Ledger Entry"."Gen. Prod. Posting Group");
        SalesLine.Validate("No.", GeneralPostingSetup."Sales Account");

        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", "SMB Seminar Ledger Entry"."Unit Price");
        SalesLine.Description := "SMB Seminar Ledger Entry"."Seminar No." + ' ' + "SMB Seminar Ledger Entry"."Participant Name";
        SalesLine."SMB Apply-to Seminar Entry" := "SMB Seminar Ledger Entry"."Entry No.";
        SalesLine.Modify(true);
        NextLineNo += 10000;
    end;

    local procedure CreateSalesHeader()
    begin
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."No." := '';
        SalesHeader.Insert(true);

        SalesHeader.Validate("Sell-to Customer No.", "SMB Seminar Ledger Entry"."Bill-to Customer No.");
        SalesHeader.Modify(true);
        NextLineNo := 10000;
    end;
}



// report 123456710 "SMB Create Seminar Invoices"
// {
//     Caption = 'Create Seminar Invoices';
//     ProcessingOnly = true;
//     ApplicationArea = All;
//     UsageCategory = Tasks;

//     dataset
//     {
//         dataitem("Seminar Ledger Entry"; "SMB Seminar Ledger Entry")
//         {
//             DataItemTableView = sorting("Bill-to Customer No.", "Closed by Document No.", Chargeable)
//                                 where("Charge Type" = const(Participant), "Entry Type" = CONST(Registration),
//                                        Chargeable = CONST(true),
//                                        "Closed by Document No." = const(''),
//                                        "Gen. Bus. Posting Group" = filter('<>'''''),
//                                        "Gen. Prod. Posting Group" = filter('<>'''''));
//             RequestFilterFields = "Starting Date", "Posting Date", "Seminar No.", "Bill-to Customer No.";

//             trigger OnAfterGetRecord()
//             begin
//                 SemLedgEntryBuf := "Seminar Ledger Entry";
//                 SemLedgEntryBuf.Insert();
//                 Window.Update();
//             end;

//             trigger OnPreDataItem()
//             begin
//                 if PostingDateReq = 0D then
//                     Error(PostingDateMandatoryErr);
//                 if DocDateReq = 0D then
//                     Error(DocumentDateMandatoryErr);

//                 Window.Open(StatusDlgTxt, SemLedgEntryBuf."Bill-to Customer No.", SemLedgEntryBuf."Seminar Registration No.");
//                 SemLedgEntryBuf.DeleteAll();
//             end;
//         }
//         dataitem(SemLedgEntryBuf; "SMB Seminar Ledger Entry")
//         {
//             DataItemTableView = sorting("Bill-to Customer No.");
//             UseTemporary = true;

//             trigger OnAfterGetRecord()
//             begin
//                 if "Bill-to Customer No." = '' then begin
//                     NoOfSalesInvErrors += 1;
//                     CurrReport.Skip();
//                     exit;
//                 end;

//                 if "Bill-to Customer No." <> Customer."No." then
//                     Customer.Get("Bill-to Customer No.");

//                 if Customer.Blocked in [Customer.Blocked::All, Customer.Blocked::Invoice] then
//                     NoOfSalesInvErrors += 1
//                 else begin
//                     if "Bill-to Customer No." <> SalesHeader."Bill-to Customer No." then begin
//                         if SalesHeader."No." <> '' then
//                             FinalizeSalesInvoiceHeader();
//                         CurrReport.Language := Language.GetLanguageID(Customer."Language Code");
//                         InsertSalesInvoiceHeader();
//                     end;
//                     Window.Update();

//                     SalesLine.Init();
//                     SalesLine."Line No." += 10000;

//                     if "Instructor Code" <> Instr.Code then begin
//                         Instr.Get("Instructor Code");
//                         Instr.TestField("Resource No.");
//                     end;
//                     // Fakturierung über Ressource
//                     // SalesLine.Validate(Type, SalesLine.Type::Resource);
//                     // SalesLine.Validate("No.", Instr."Resource No.");

//                     // Erweiterete Anforderung, Fakturierung über Sachkonto aus Buchungsgruppen
//                     if ("Gen. Bus. Posting Group" = '') or ("Gen. Prod. Posting Group" = '') then begin
//                         NoOfSalesInvErrors += 1;
//                         CurrReport.Skip();
//                     end;
//                     GeneralPostingSetup.Get("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");
//                     GeneralPostingSetup.TestField("Sales Account");
//                     SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
//                     SalesLine.Validate("No.", GeneralPostingSetup."Sales Account");

//                     SalesLine.Validate("Location Code", '');
//                     SalesLine.Validate(Quantity, Quantity);

//                     if "Participant Name" <> '' then
//                         SalesLine.Description := "Participant Name";

//                     SalesLine.validate("Unit Price", "Total Price");
//                     // if SalesHeader."Currency Code" <> '' then begin
//                     //     SalesHeader.TestField("Currency Factor");
//                     //     SalesLine."Unit Price" :=
//                     //       Round(
//                     //         CurrencyExchRate.ExchangeAmtLCYToFCY(
//                     //         WorkDate(), SalesHeader."Currency Code",
//                     //         SalesLine."Unit Price", SalesHeader."Currency Factor"));
//                     // end;
//                     SalesLine."SMB Apply-to Seminar Entry" := "Entry No.";
//                     SalesLine.Validate("Dimension Set ID","Dimension Set ID");
//                     SalesLine.Insert();

//                     InsertTextLine(
//                       StrSubstNo(InvTxtSemRegNoTxt, "Seminar Registration No."));

//                     InsertTextLine(
//                       StrSubstNo(InvTxtSemNoTxt, "Seminar No."));

//                     InsertTextLine(
//                       StrSubstNo(InvTxtStartDateTxt, SemLedgEntryBuf."Starting Date"));
//                 end;
//             end;

//             trigger OnPostDataItem()
//             begin
//                 Window.Close();
//                 if SalesHeader."No." = '' then
//                     Message(NothingToPostErr)
//                 else begin
//                     FinalizeSalesInvoiceHeader();
//                     if NoOfSalesInvErrors = 0 then
//                         Message(
//                           SuccessMsg,
//                           NoOfSalesInv)
//                     else
//                         Message(
//                           PartialSuccessMsg,
//                           NoOfSalesInvErrors)
//                 end;
//             end;
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(PostingDateReq; PostingDateReq)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Posting Date';
//                         ToolTip = 'Specifies the value of the Posting Date field.';
//                     }
//                     field(DocDateReq; DocDateReq)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Document Date';
//                         ToolTip = 'Specifies the value of the Document Date field.';
//                     }
//                     field(CalcInvoiceDiscount; CalcInvoiceDiscount)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Calc. Inv. Discount';
//                         ToolTip = 'Specifies the value of the Calc. Inv. Discount field.';
//                     }
//                     field(PostInvoices; PostInvoices)
//                     {
//                         ApplicationArea = All;
//                         Caption = 'Post Invoices';
//                         ToolTip = 'Specifies the value of the Post Invoices field.';
//                     }
//                 }
//             }
//         }

//         trigger OnOpenPage()
//         begin
//             if PostingDateReq = 0D then
//                 PostingDateReq := WorkDate();
//             if DocDateReq = 0D then
//                 DocDateReq := WorkDate();
//             SalesSetup.Get();
//             CalcInvoiceDiscount := SalesSetup."Calc. Inv. Discount";
//         end;
//     }

//     var
//         PostingDateMandatoryErr: Label 'Please enter the posting date.';
//         DocumentDateMandatoryErr: Label 'Please enter the document date.';
//         StatusDlgTxt: Label 'Creating Seminar Invoices...\\Customer No. #1\Registration No. #2';
//         SuccessMsg: Label 'The number of invoice(s) created is %1.';
//         PartialSuccessMsg: Label 'Not all the invoices were posted. A total of %1 invoices were not posted.';
//         NothingToPostErr: Label 'There is nothing to invoice.';

//         InvTxtSemRegNoTxt: Label 'Seminar Reg. No.: %1';
//         InvTxtSemNoTxt: Label 'Seminar No.: %1';
//         InvTxtStartDateTxt: Label 'Start Date: %1';

//         CurrencyExchRate: Record "Currency Exchange Rate";
//         Customer: Record Customer;
//         GLSetup: Record "General Ledger Setup";
//         SalesHeader: Record "Sales Header";
//         SalesLine: Record "Sales Line";
//         SalesSetup: Record "Sales & Receivables Setup";
//         Instr: Record "SMB Instructor";
//         GeneralPostingSetup: Record "General Posting Setup";
//         Language: Codeunit Language;
//         SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
//         SalesPost: Codeunit "Sales-Post";
//         CalcInvoiceDiscount: Boolean;
//         PostInvoices: Boolean;
//         NoOfSalesInvErrors: Integer;
//         NoOfSalesInv: Integer;
//         PostingDateReq: Date;
//         DocDateReq: Date;
//         Window: Dialog;
//         Seminar: Record "SMB Seminar";


//     local procedure FinalizeSalesInvoiceHeader()
//     begin
//         if CalcInvoiceDiscount then
//             SalesCalcDiscount.Run(SalesLine);
//         SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.");
//         Commit();
//         Clear(SalesCalcDiscount);
//         Clear(SalesPost);
//         NoOfSalesInv := NoOfSalesInv + 1;
//         if PostInvoices then begin
//             Clear(SalesPost);
//             if not SalesPost.Run(SalesHeader) then
//                 NoOfSalesInvErrors := NoOfSalesInvErrors + 1;
//         end;
//     end;

//     local procedure InsertSalesInvoiceHeader()
//     begin
//         SalesHeader.Init();
//         SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
//         SalesHeader."No." := '';
//         SalesHeader.Insert(true);
//         SalesHeader.Validate("Sell-to Customer No.", SemLedgEntryBuf."Bill-to Customer No.");
//         if SalesHeader."Bill-to Customer No." <> SalesHeader."Sell-to Customer No." then
//             SalesHeader.Validate("Bill-to Customer No.", SemLedgEntryBuf."Bill-to Customer No.");
//         SalesHeader.Validate("Posting Date", PostingDateReq);
//         SalesHeader.Validate("Document Date", DocDateReq);
//         SalesHeader.Validate("Currency Code", '');
//         SalesHeader.Validate("Salesperson Code");
//         SalesHeader.Modify();
//         Commit();
//         SalesLine."Document Type" := SalesHeader."Document Type";
//         SalesLine."Document No." := SalesHeader."No.";
//         SalesLine."Line No." := 0;
//     end;

//     procedure InsertTextLine(Text: Text[50])
//     begin
//         SalesLine.Init();
//         SalesLine."Line No." += 10000;
//         SalesLine.Type := SalesLine.Type::" ";
//         SalesLine.Description := Text;
//         SalesLine.Insert();
//     end;
// }
