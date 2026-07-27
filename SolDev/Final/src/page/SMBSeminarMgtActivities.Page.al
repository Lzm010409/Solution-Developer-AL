page 123456751 "SMB Seminar Mgt. Activities"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "SMB Seminar Cue";
    Caption = 'Activities';
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            cuegroup(Registrations)
            {
                Caption = 'Registrations';

                field("Seminar Reg. - Planning"; Rec."Seminar Reg. - Planning")
                {
                    // DrillDownPageId = "SMB Seminar Registration";
                    ToolTip = 'Specifies the value of the seminar Reg. - Planning field.', Comment = '%';
                }
                field("Seminar Reg. - Registration"; Rec."Seminar Reg. - Registration")
                {
                    ToolTip = 'Specifies the value of the Seminar Reg. - Registration field.', Comment = '%';
                }
                field("Seminar Reg. - Closed"; Rec."Seminar Reg. - Closed")
                {
                    ToolTip = 'Specifies the value of the Seminar Reg. - Closed field.', Comment = '%';
                }
                field("Seminar Reg. - Canceled"; Rec."Seminar Reg. - Canceled")
                {
                    ToolTip = 'Specifies the value of the Seminar Reg. - Canceled field.', Comment = '%';
                }
            }
            cuegroup(CurrentRegistration)
            {
                Caption = 'Current Registraion';
                field("Seminar Reg. - Today"; Rec."Seminar Reg. - Today")
                {
                    ToolTip = 'Specifies the value of the Seminar Reg. - Today field.', Comment = '%';
                }
                field("Seminar Reg. - This Week"; Rec."Seminar Reg. - This Week")
                {
                    ToolTip = 'Specifies the value of the Seminar Reg. - This Week field.', Comment = '%';
                }
            }
        }

    }
    actions
    {
        area(processing)
        {
            action("Set Up Cues")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Set Up Cues';
                Image = Setup;
                ToolTip = 'Set up the cues (status tiles) related to the role.';

                trigger OnAction()
                var
                    CueRecordRef: RecordRef;
                begin
                    CueRecordRef.GetTable(Rec);
                    CuesAndKpis.OpenCustomizePageForCurrentUser(CueRecordRef.Number);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        StartDateFromWeek: Date;
        EndDateFromWeek: Date;
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        StartDateFromWeek := CalcDate('<-CW>', WorkDate());
        EndDateFromWeek := CalcDate('<-CW+6D>', WorkDate());

        Rec.SetRespCenterFilter();
        Rec.SetRange("Date Filter", WorkDate());
        Rec.SetRange("Date Filter2", StartDateFromWeek, EndDateFromWeek);
        Rec.SetRange("User ID Filter", UserId());
    end;

    var
        CuesAndKpis: Codeunit "Cues And KPIs";
}