page 123456701 "SMB Seminar List"
{

    ApplicationArea = All;
    Caption = 'Seminars';
    PageType = List;
    SourceTable = "SMB Seminar";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SMB Seminar Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Language Code"; Rec."Language Code")
                {
                    ApplicationArea = All;
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = All;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = All;
                }
                field("Minimum Participants"; Rec."Minimum Participants")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Maximum Participants"; Rec."Maximum Participants")
                {
                    ApplicationArea = All;
                    Visible = false;
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
                    Image = LedgerBudget;
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
