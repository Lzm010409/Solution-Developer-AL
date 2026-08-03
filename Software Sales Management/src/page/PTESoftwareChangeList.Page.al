page 63610 "PTE Software Change List"
{
    PageType = List;
    SourceTable = "PTE Software Change";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PTE Software Change Card";
    Editable = false;
    Caption = 'Software Changes', Comment = 'de-DE=Softwareanpassungen';


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

    views
    {
        view(OpenSoftwareChanges)
        {
            Caption = 'Open Software Changes', Comment = 'de-DE=Offene Softwareanpassungen';
            Filters = where(Status = filter(<> Finished));
        }
        view(SmallSoftwareChanges)
        {
            Caption = 'Small Software Changes', Comment = 'de-DE=Kleine Softwareanpassungen';
            Filters = where("Quantity Implementation (hrs)" = filter(<= 8));
        }
    }
}
