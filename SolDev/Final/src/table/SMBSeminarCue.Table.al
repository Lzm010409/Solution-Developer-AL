table 123456751 "SMB Seminar Cue"
{
    Caption = 'Seminar Cue';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            AllowInCustomizations = Never;
            Caption = 'Primary Key';
        }
        field(2; "Seminar Reg. - Planning"; integer)
        {
            Caption = 'Seminar Reg. - Planning';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Planning),
                                                                "Responsibility Center" = field("Responsibility Center Filter")));
            ToolTip = 'Specifies the number of.';
        }
        field(3; "Seminar Reg. - Registration"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Registration),
                                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Seminar Reg. - Registration';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of.';
        }
        field(4; "Seminar Reg. - Closed"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Closed),
                                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Seminar Reg. - Closed';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of.';
        }
        field(5; "Seminar Reg. - Canceled"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Canceled),
                                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Seminar Reg. - Canceled';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of.';
        }
        field(6; "Seminar Reg. - Today"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Closed),
                                                        "Starting Date" = field("Date Filter"),
                                                        "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Seminar Reg. - Today';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of.';
        }
         field(7; "Seminar Reg. - This Week"; Integer)
        {
            CalcFormula = count("SMB Seminar Reg. Header" where(Status = const(Closed),
                                                     "Starting Date" = Field("Date Filter2"),
                                                      "Responsibility Center" = field("Responsibility Center Filter")));
            Caption = 'Seminar Reg. - This Week';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Specifies the number of.';
        }


        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Date Filter2"; Date)
        {
            Caption = 'Date Filter 2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(22; "Responsibility Center Filter"; Code[10])
        {
            Caption = 'Responsibility Center Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(23; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }

    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetRespCenterFilter()
    var
        UserSetupMgt: Codeunit "User Setup Management";
        RespCenterCode: Code[10];
    begin
        RespCenterCode := UserSetupMgt.GetSalesFilter();
        if RespCenterCode <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center Filter", RespCenterCode);
            FilterGroup(0);
        end;

    end;




}

