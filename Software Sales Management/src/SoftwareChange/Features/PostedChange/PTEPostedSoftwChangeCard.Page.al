page 63616 "PTE Posted Softw. Change Card"
{
    PageType = Card;
    SourceTable = "PTE Posted Software Change";
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;
    Caption = 'Posted Software Change', Comment = 'de-DE=Geb. Softwareanpassung';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'de-DE=Allgemein';

                field("No."; Rec."No.")
                {
                }
                field("Software Change No."; Rec."Software Change No.")
                {
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
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field("User ID"; Rec."User ID")
                {
                    Importance = Additional;
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
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                }
                group(Commission)
                {
                    Caption = 'Commission', Comment = 'de-DE=Provision';

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
            group(SoftwareChangeActions)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';
                Image = Document;

                action(FindEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Find Entries...', Comment = 'de-DE=Posten suchen...';
                    ToolTip = 'Find all entries and documents that exist for the posted software change.', Comment = 'de-DE=Sucht alle Posten und Belege, die zur gebuchten Softwareanpassung existieren.';
                    Image = Navigate;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        Rec.ShowEntries();
                    end;
                }
                action(ShowComments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments', Comment = 'de-DE=Bemerkungen';
                    ToolTip = 'View the comments of the posted software change.', Comment = 'de-DE=Zeigt die Bemerkungen der gebuchten Softwareanpassung an.';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        Rec.ShowComments();
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(ShowSalesInvoice)
            {
                ApplicationArea = All;
                Caption = 'Posted Sales Invoice', Comment = 'de-DE=Geb. Verkaufsrechnung';
                ToolTip = 'Open the posted sales invoice that was created for the posted software change.', Comment = 'de-DE=Öffnet die gebuchte Verkaufsrechnung, die zur gebuchten Softwareanpassung erstellt wurde.';
                Image = Invoice;
                RunObject = page "Posted Sales Invoice";
                RunPageLink = "No." = field("Sales Invoice No.");
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'de-DE=Prozess';

                actionref(FindEntriesRef; FindEntries)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';

                actionref(ShowCommentsRef; ShowComments)
                {
                }
            }
        }
    }
}
