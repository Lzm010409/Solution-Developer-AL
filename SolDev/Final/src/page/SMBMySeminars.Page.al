page 123456730 "SMB My Seminars"
{
    Caption = 'My Seminars';
    PageType = ListPart;
    SourceTable = "SMB My Seminar";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Seminar No."; Rec."Seminar No.")
                {
                    ApplicationArea = Basic, Suite;
                    Width = 4;

                    trigger OnValidate()
                    begin
                        SyncFieldsWithSeminar();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Lookup = false;
                    Width = 20;
                }
                field("Duration Days"; Rec."Duration Days")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Lookup = false;
                    Width = 8;
                }
                field("Seminar Price"; Rec."Seminar Price")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDown = false;
                    Lookup = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "SMB Seminar Card";
                RunPageLink = "No." = field("Seminar No.");
                RunPageMode = View;
                RunPageView = sorting("No.");
                Scope = Repeater;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SyncFieldsWithSeminar();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Clear(SMBSeminar)
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("User ID", UserId);
    end;

    protected var
        SMBSeminar: Record "SMB Seminar";

    local procedure SyncFieldsWithSeminar()
    begin
        Clear(SMBSeminar);

        SMBSeminar.ReadIsolation(IsolationLevel::ReadCommitted);
        SMBSeminar.SetLoadFields(Description,"Duration Days","Seminar Price");
        if SMBSeminar.Get(Rec."Seminar No.") then
            if (Rec.Description <> SMBSeminar.Description) or 
               (Rec."Duration Days" <> SMBSeminar."Duration Days") or
               (Rec."Seminar Price" <> SMBSeminar."Seminar Price") 
            then begin
                Rec.Description := SMBSeminar.Description;
                Rec."Duration Days" := SMBSeminar."Duration Days";
                Rec."Seminar Price" := SMBSeminar."Seminar Price";
                if not IsNullGuid(Rec.SystemId) then
                    Rec.Modify();
            end;
    end;
}

