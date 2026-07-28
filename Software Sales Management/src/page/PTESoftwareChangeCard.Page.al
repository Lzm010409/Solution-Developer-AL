page 63611 "PTE Software Change Card"
{
    PageType = Card;
    SourceTable = "PTE Software Change";
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Software Change', Comment = 'de-DE=Softwareanpassung';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'de-DE=Allgemein';

                field("No."; Rec."No.")
                {
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEditNoSeries(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Software Change Template Code"; Rec."Software Change Template Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("Closing Date"; Rec."Closing Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Priority; Rec.Priority)
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing', Comment = 'de-DE=Fakturierung';

                field("Salesperson Code"; Rec."Salesperson Code")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("Developer Resource No."; Rec."Developer Resource No.")
                {
                }
                field("Quantity Implementation (hrs)"; Rec."Quantity Implementation (hrs)")
                {
                }
                group(Commission)
                {
                    Caption = 'Commission', Comment = 'de-DE=Provision';
                    InstructionalText = 'Define how the commission for the salesperson is determined.', Comment = 'de-DE=Legen Sie fest, wie die Provision für den Verkäufer ermittelt wird.';

                    field("Accounting Type"; Rec."Accounting Type")
                    {
                    }
                    field("Commission Percentage"; Rec."Commission Percentage")
                    {
                    }
                }
            }
            group(ContactPerson)
            {
                Caption = 'Contact Person', Comment = 'de-DE=Kontaktperson';

                field("Contact No."; Rec."Contact No.")
                {
                }
                field("Contact Name"; Rec."Contact Name")
                {
                }
                field("Contact Phone No."; Rec."Contact Phone No.")
                {
                }
                field("Contact E-Mail"; Rec."Contact E-Mail")
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Posting)
            {
                Caption = 'Posting', Comment = 'de-DE=Buchen';
                Image = Post;

                action(Post)
                {
                    ApplicationArea = All;
                    Caption = 'P&ost', Comment = 'de-DE=B&uchen';
                    ToolTip = 'Finalize the software change by posting it as a sales invoice and creating the commission ledger entry.', Comment = 'de-DE=Schließt die Softwareanpassung ab, indem sie als Verkaufsrechnung gebucht und der Provisionsposten erstellt wird.';
                    Image = PostOrder;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        SoftwChangePostYesNo: Codeunit "PTE Softw. Change-Post (Y/N)";
                    begin
                        SoftwChangePostYesNo.Run(Rec);
                    end;
                }
            }
            group(SoftwareChangeActions)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';
                Image = Document;

                action(CopySoftwareChange)
                {
                    ApplicationArea = All;
                    Caption = 'Copy Software Change', Comment = 'de-DE=Softwareanpassung kopieren';
                    ToolTip = 'Create a new software change by copying the selected one.', Comment = 'de-DE=Erstellt eine neue Softwareanpassung als Kopie der ausgewählten.';
                    Image = Copy;

                    trigger OnAction()
                    var
                        CopySoftwareChangeReport: Report "PTE Copy Software Change";
                    begin
                        CopySoftwareChangeReport.SetSourceSoftwareChange(Rec);
                        CopySoftwareChangeReport.RunModal();
                    end;
                }
            }
        }
        area(Navigation)
        {
            group(RelatedInformation)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';
                Image = Document;

                action(ShowContact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact', Comment = 'de-DE=Kontakt';
                    ToolTip = 'Open the contact assigned to the Software Change.', Comment = 'de-DE=Öffnet den der Softwareanpassung zugewiesenen Kontakt.';
                    Image = ContactPerson;
                    RunObject = page "Contact Card";
                    RunPageLink = "No." = field("Contact No.");
                }
                action(ShowCustomer)
                {
                    ApplicationArea = All;
                    Caption = 'Customer', Comment = 'de-DE=Debitor';
                    ToolTip = 'Open the customer assigned to the Software Change.', Comment = 'de-DE=Öffnet den der Softwareanpassung zugewiesenen Debitor.';
                    Image = Customer;
                    RunObject = page "Customer Card";
                    RunPageLink = "No." = field("Customer No.");
                }
                action(ShowSalesperson)
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson', Comment = 'de-DE=Verkäufer';
                    ToolTip = 'Open the salesperson assigned to the Software Change.', Comment = 'de-DE=Öffnet den der Softwareanpassung zugewiesenen Verkäufer.';
                    Image = SalesPerson;
                    RunObject = page "Salesperson/Purchaser Card";
                    RunPageLink = "Code" = field("Salesperson Code");
                }
                action(ShowResource)
                {
                    ApplicationArea = All;
                    Caption = 'Resource', Comment = 'de-DE=Ressource';
                    ToolTip = 'Open the developer resource assigned to the Software Change.', Comment = 'de-DE=Öffnet die der Softwareanpassung zugewiesene Entwickler-Ressource.';
                    Image = Resource;
                    RunObject = page "Resource Card";
                    RunPageLink = "No." = field("Developer Resource No.");
                }
                action(ShowComments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments', Comment = 'de-DE=Bemerkungen';
                    ToolTip = 'View or add comments for the Software Change.', Comment = 'de-DE=Zeigt die Bemerkungen zur Softwareanpassung an oder ergänzt sie.';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        Rec.ShowComments();
                    end;
                }
            }
        }
        area(Promoted)
        {
            actionref(PostRef; Post)
            {
            }
            actionref(CopySoftwareChangeRef; CopySoftwareChange)
            {
            }
            actionref(ShowCommentsRef; ShowComments)
            {
            }
        }
    }
}
