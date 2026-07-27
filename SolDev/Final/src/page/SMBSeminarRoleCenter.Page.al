page 123456750 "SMB Seminar Role Center"
{
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(RoleCenter)
        {
            part(SeminarActivities; "SMB Seminar Mgt. Activities")
            {
                AccessByPermission = TableData "SMB Seminar Reg. Header" = R;
            }
            part("Emails"; "Email Activities")
            {
                ApplicationArea = Basic, Suite;
            }
            part(MySeminars;"SMB My Seminars")
            {
                ApplicationArea = Basic, Suite;
            }

            part(Control1907692008; "My Customers")
            {
                ApplicationArea = Basic, Suite;
            }

            part(Control21; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Seminar)
            {
                Caption = 'Seminar';
                action(SeminarRegistrationsSections)
                {
                    ApplicationArea = All;
                    Caption = 'Seminar Registrations';
                    RunObject = page "SMB Seminar Registration List";
                    ToolTip = 'Executes the Seminar Registrations action.';
                }
                action(SeminarsSections)
                {
                    ApplicationArea = All;
                    Caption = 'Seminars';
                    RunObject = page "SMB Seminar List";
                    ToolTip = 'Executes the Seminars action.';
                }
                action(InstructorsSections)
                {
                    ApplicationArea = All;
                    RunObject = page "SMB Instructors";
                    Caption = 'Instructors';
                    ToolTip = 'Executes the Instructors action.';

                }
                action(SeminarRoomsSections)
                {
                    ApplicationArea = All;
                    RunObject = page "SMB Seminar Room List";
                    Caption = 'Seminar Rooms';
                    ToolTip = 'Executes the Seminar Rooms action.';

                }
            }
            group(Sales)
            {
                Caption = 'Sales';
                Image = Sales;
                ToolTip = 'Make quotes, orders, and credit memos to customers. Manage customers and view transaction history.';
                action(Action61)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customers';
                    Image = Customer;
                    RunObject = Page "Customer List";
                    ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
                }
                action("Sales Quotes")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Quotes';
                    RunObject = Page "Sales Quotes";
                    ToolTip = 'Make offers to customers to sell certain products on certain delivery and payment terms. While you negotiate with a customer, you can change and resend the sales quote as much as needed. When the customer accepts the offer, you convert the sales quote to a sales invoice or a sales order in which you process the sale.';
                }

                action("Blanket Sales Orders")
                {
                    ApplicationArea = Suite;
                    Caption = 'Blanket Sales Orders';
                    Image = Reminder;
                    RunObject = Page "Blanket Sales Orders";
                    ToolTip = 'Use blanket sales orders as a framework for a long-term agreement between you and your customers to sell large quantities that are to be delivered in several smaller shipments over a certain period of time. Blanket orders often cover only one item with predetermined delivery dates. The main reason for using a blanket order rather than a sales order is that quantities entered on a blanket order do not affect item availability and thus can be used as a worksheet for monitoring, forecasting, and planning purposes..';
                }
                action("Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Invoices';
                    RunObject = Page "Sales Invoice List";
                    ToolTip = 'Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer''s account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.';
                }

                action("Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Credit Memos';
                    RunObject = Page "Sales Credit Memos";
                    ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
                }
                action("Sales Journals")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Journals';
                    RunObject = Page "General Journal Batches";
                    RunPageView = where("Template Type" = const(Sales),
                                        Recurring = const(false));
                    ToolTip = 'Post any sales-related transaction directly to a customer, bank, or general ledger account instead of using dedicated documents. You can post all types of financial sales transactions, including payments, refunds, and finance charge amounts. Note that you cannot post item quantities with a sales journal.';
                }
                action("Posted Sales Invoices")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memos';
                    RunObject = Page "Posted Sales Credit Memos";
                    ToolTip = 'Open the list of posted sales credit memos.';
                }


                action(Reminders)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Reminders';
                    RunObject = Page "Reminder List";
                    ToolTip = 'Remind customers about overdue amounts based on reminder terms and the related reminder levels. Each reminder level includes rules about when the reminder will be issued in relation to the invoice due date or the date of the previous reminder and whether interests are added. Reminders are integrated with finance charge memos, which are documents informing customers of interests or other money penalties for payment delays.';
                }
                action("Finance Charge Memos")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Finance Charge Memos';
                    RunObject = Page "Finance Charge Memo List";
                    ToolTip = 'Send finance charge memos to customers with delayed payments, typically following a reminder process. Finance charges are calculated automatically and added to the overdue amounts on the customer''s account according to the specified finance charge terms and penalty/interest amounts.';
                }
            }
            group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View the posting history for sales, shipments, and inventory.';
                action(PostedSemRegistrations)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Seminar Registraions';
                    RunObject = page "SMB Posted Seminar Reg. List";
                    ToolTip = 'Executes the Posted Seminar Registraions action.';
                }
                action(PostedSalesInvoices)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
            }
        }
        area(Processing)
        {
            action(CreateSeminarInvoices)
            {
                Caption = 'Create Seminar Invoices';
                RunObject = report "SMB Create Seminar Invoices";
                ToolTip = 'Bla';
                ApplicationArea = All;
            }
            group(History)
            {
                Caption = 'History';
                action("Navi&gate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Find entries...';
                    Image = Navigate;
                    RunObject = Page Navigate;
                    ShortCutKey = 'Ctrl+Alt+Q';
                    ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                }
            }
        }
        area(Creation)
        {
            action(NewSeminarRegistration)
            {
                ApplicationArea = All;
                RunObject = page "SMB Seminar Registration";
                RunPageMode = Create;
                Caption = 'New Seminar Registration';
                ToolTip = ' ';
            }
            action("Sales &Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Sales &Invoice';
                Image = NewSalesInvoice;
                RunObject = page "Sales Invoice";
                RunPageMode = Create;
                ToolTip = 'Create a new invoice for the sales of items or services. Invoice quantities cannot be posted partially.';
            }
        }
          area(Embedding)
        {
            action(SeminarRegistrations)
            {
                Caption = 'Seminar Registrations';
                RunObject = page "SMB Seminar Registration List";
                ApplicationArea = All;
                ToolTip = 'Executes the Seminar Registrations action.';
            }
            action(Seminars)
            {
                ApplicationArea = All;
                Caption = 'Seminars';
                RunObject = page "SMB Seminar List";
                ToolTip = 'Executes the Seminars action.';
            }
            action(Instructors)
            {
                ApplicationArea = All;
                RunObject = page "SMB Instructors";
                Caption = 'Instructors';
                ToolTip = 'Executes the Instructors action.';

            }
            action(SeminarRooms)
            {
                ApplicationArea = All;
                RunObject = page "SMB Seminar Room List";
                Caption = 'Seminar Rooms';
                ToolTip = 'Executes the Seminar Rooms action.';

            }
            action(Customer)
            {
                ApplicationArea = All;
                RunObject = page "Customer List";
                Caption = 'Customer';
                ToolTip = 'Show the customers';
            }
        }
    }


}