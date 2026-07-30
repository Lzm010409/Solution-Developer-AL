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
                    ShowMandatory = true;
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    Importance = Additional;
                }
                field(Status; Rec.Status)
                {
                    ShowMandatory = true;
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
                    ShowMandatory = true;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ShowMandatory = true;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ShowMandatory = true;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ShowMandatory = true;
                }
                field("Developer Resource No."; Rec."Developer Resource No.")
                {
                    ShowMandatory = true;
                }
                field("Quantity Implementation (hrs)"; Rec."Quantity Implementation (hrs)")
                {
                    ShowMandatory = true;
                }
                group(Commission)
                {
                    Caption = 'Commission', Comment = 'de-DE=Provision';
                    InstructionalText = 'Define how the commission for the salesperson is determined.', Comment = 'de-DE=Legen Sie fest, wie die Provision für den Verkäufer ermittelt wird.';

                    field("Accounting Type"; Rec."Accounting Type")
                    {
                        ShowMandatory = true;
                        trigger OnValidate()
                        begin
                            if Rec."Accounting Type" = Rec."Accounting Type"::"Commission Contract" then
                                IsCommissionPercentageEditable := false
                            else
                                IsCommissionPercentageEditable := true;               
                        end;

                    }
                    field("Commission Percentage"; Rec."Commission Percentage")
                    {
                        Editable = IsCommissionPercentageEditable;
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
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'de-DE=Prozess';

                actionref(PostRef; Post)
                {
                }
            }
            group(Category_SoftwareChange)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';

                actionref(CopySoftwareChangeRef; CopySoftwareChange)
                {
                }
                actionref(ShowCommentsRef; ShowComments)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec."Accounting Type" = Rec."Accounting Type"::"Commission Contract" then
            IsCommissionPercentageEditable := false
        else
            IsCommissionPercentageEditable := true;
    end;



    var
        IsCommissionPercentageEditable: Boolean;
}
