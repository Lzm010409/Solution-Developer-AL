page 123456700 "SMB Seminar Card"
{
    UsageCategory = None;
    Caption = 'Seminar Card';
    PageType = Card;
    SourceTable = "SMB Seminar";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                }

            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "SMB Seminar Picture")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
            }
            systempart(Links; Links) { ApplicationArea = All; }
            systempart(Notes; Notes) { ApplicationArea = All; }
            
        }
    }
    actions
    {
        area(Navigation)
        {
            group(Seminar)
            {
                Caption = 'Seminar';

                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST("SMB Seminar"),
                                  "No." = FIELD("No.");
                    ToolTip = 'View or add comments for the record.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = All;
                    Caption = 'Ledger E&ntries';
                    Image = LedgerEntries;
                    RunObject = Page "SMB Seminar Ledger Entries";
                    RunPageLink = "Seminar No." = field("No.");
                    RunPageView = sorting("Seminar No.", "Posting Date", "Charge Type", Chargeable)
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }

        area(Creation)
        {
            action(NewSeminarRegistration)
            {
                AccessByPermission = TableData "SMB Seminar Reg. Header" = RIM;
                ApplicationArea = All;
                Caption = 'Seminar Registration';
                Image = Document;
                RunObject = Page "SMB Seminar Registration";
                RunPageLink = "Seminar No." = field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a seminar registration for the seminar.';

            }
        }

        area(Promoted)
        {
            group(Category_Seminar)
            {
                Caption = 'Seminar';
                actionref(SeminarComment_Promoted; Comments) { }
            }
            group(Category_Category5)
            {
                Caption = 'New Document';

                actionref(NewRegistration_Promoted; NewSeminarRegistration)
                {
                }
            }
        }
    }
}
