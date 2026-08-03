page 63615 "PTE Posted Softw. Change List"
{
    PageType = List;
    SourceTable = "PTE Posted Software Change";
    ApplicationArea = All;
    UsageCategory = History;
    CardPageId = "PTE Posted Softw. Change Card";
    Editable = false;
    Caption = 'Posted Software Changes', Comment = 'de-DE=Geb. Softwareanpassungen';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Developer Resource No."; Rec."Developer Resource No.")
                {
                }
                field("Quantity Implementation (hrs)"; Rec."Quantity Implementation (hrs)")
                {
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                }
                field("Commission Percentage"; Rec."Commission Percentage")
                {
                }
                field("Software Change No."; Rec."Software Change No.")
                {
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
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
