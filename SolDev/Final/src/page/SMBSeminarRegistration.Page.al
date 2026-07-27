page 123456710 "SMB Seminar Registration"
{
    ApplicationArea = All;
    Caption = 'Seminar Registration';
    PageType = Document;
    SourceTable = "SMB Seminar Reg. Header";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;

                }
                field("Seminar No."; Rec."Seminar No.")
                {
                    Importance = Promoted;
                }
                field("Seminar Description"; Rec."Seminar Description")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Importance = Promoted;
                }
                field("Instructor Code"; Rec."Instructor Code")
                {
                }
                field("Instructor Name"; Rec."Instructor Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Duration Days"; Rec."Duration Days")
                {
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                    Importance = Additional;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Importance = Additional;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("No. of Participants"; Rec."No. of Participants")
                {
                }
            }
            part(Lines; "SMB Seminar Reg. Lines Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                Caption = 'Lines';
                UpdatePropagation = Both;
            }
            group(SeminarRoom)
            {
                Caption = 'Seminar Room';

                field("Room Code"; Rec."Room Code")
                {
                    Importance = Promoted;
                }
                field("Room Name"; Rec."Room Name")
                {
                }
                field("Room Name 2"; Rec."Room Name 2")
                {
                    Importance = Additional;
                }
                field("Room Address"; Rec."Room Address")
                {
                }
                field("Room Address 2"; Rec."Room Address 2")
                {
                    Importance = Additional;
                }
                field("Room Post Code"; Rec."Room Post Code")
                {
                }
                field("Room City"; Rec."Room City")
                {
                }
                field("Room County"; Rec."Room County")
                {
                    Importance = Additional;
                }
                field("Room Country/Region Code"; Rec."Room Country/Region Code")
                {
                }
                field("Room Contact"; Rec."Room Contact")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("Seminar Price"; Rec."Seminar Price")
                {
                    Importance = Promoted;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links) { }
            systempart(Notes; Notes) { }
            part(SeminarDetails; "SMB Seminar Details FactBox")
            {
                SubPageLink = "No." = field("Seminar No.");
            }
            part(CustomerDetails; "Customer Details FactBox")
            {
                Provider = Lines;
                SubPageLink = "No." = field("Bill-to Customer No.");
            }
            part(ContactDetails; "SMB Contact Details Factbox")
            {
                Provider = Lines;
                SubPageLink = "No." = field("Participant Contact No.");
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Registration)
            {
                Caption = 'Registration';
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "SMB Seminar Comment Sheet";
                    RunPageLink = "Document Type" = const("SMB Sem. Comment Document Type"::"Seminar Registration"),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
        }
        area(Processing)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';
                    AboutTitle = 'When all is set, you post';
                    AboutText = 'After entering the sales lines and other information, you post the invoice to make it count. After posting, the sales invoice is moved to the Posted Sales Invoices list.';
                    ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                    // RunObject = codeunit "SMB Seminar-Post (Yes/No)";
                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"SMB Seminar-Post (Yes/No)",Rec);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                
                actionref(Post_Promoted; Post)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Registration';

                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }
            }
            
        }
    }
}
