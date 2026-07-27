page 123456702 "SMB Seminar Setup"
{

    Caption = 'Seminar Setup';
    PageType = Card;
    SourceTable = "SMB Seminar Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';              
                field("Copy Comments Reg. to Pst."; Rec."Copy Comments Reg. to Pst.")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Seminar Nos."; Rec."Seminar Nos.")
                {
                 
                }
                field("Seminar Registration Nos."; Rec."Seminar Registration Nos.")
                {
                   
                }
                field("Posted Seminar Reg. Nos."; Rec."Posted Seminar Reg. Nos.")
                {
                    
                }
                
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

}
