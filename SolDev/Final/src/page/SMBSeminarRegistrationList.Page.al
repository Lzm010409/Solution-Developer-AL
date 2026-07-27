page 123456713 "SMB Seminar Registration List"
{
    ApplicationArea = All;
    Caption = 'Seminar Registrations';
    PageType = List;
    SourceTable = "SMB Seminar Reg. Header";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "SMB Seminar Registration";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.") { }
                field("Starting Date"; Rec."Starting Date") { }
                field("Seminar No."; Rec."Seminar No.") { }
                field("Seminar Description"; Rec."Seminar Description") { }
                field("Instructor Code"; Rec."Instructor Code") { }
                field(Status; Rec.Status) { }
                field("Duration Days"; Rec."Duration Days") { }
                field("Seminar Price"; Rec."Seminar Price") { }
                field("Room Code"; Rec."Room Code") { }
                field("Room Name"; Rec."Room Name") { Visible = false; }
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
                        Codeunit.Run(Codeunit::"SMB Seminar-Post (Yes/No)", Rec);
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Registration';

                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }
            }
            group(Category_Process)
            {
                Caption = 'Process';
                
                actionref(Post_Promoted; Post)
                {
                }
            }
        }
    }
    views
    {
        view(PlanningReg)
        {
            Caption = 'Planning Registrations';
            Filters = where(Status = const(Planning));
        }
        view(RegReg)
        {
            Caption = 'Registration Registrations';
            Filters = where(Status = const(Registration));
        }
         view(ClosedReg)
        {
            Caption = 'Closed Registrations';
            Filters = where(Status = const(Closed));
        }
         view(CanceledReg)
        {
            Caption = 'Canceled Registrations';
            Filters = where(Status = const(Canceled));
        }
    }
}

