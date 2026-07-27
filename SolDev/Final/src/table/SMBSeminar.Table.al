table 123456700 "SMB Seminar"
{
    DataClassification = CustomerContent;
    Caption = 'Seminar';
    DataCaptionFields = "No.", Description;
    LookupPageId = "SMB Seminar List";
    DrillDownPageId = "SMB Seminar List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the No. field.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SMBSemSetup.Get();
                    NoSeries.TestManual(SMBSemSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Description field.';
            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, MaxStrLen("Search Description"));
            end;
        }
        field(4; "Search Description"; Code[100])
        {
            Caption = 'Search Description';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Search Description field.';
        }
        field(5; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Description 2 field.';
        }
        field(20; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Blocked field.';
        }

        field(22; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Last Date Modified field.';
        }

        field(24; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(27; Comment; Boolean)
        {
            CalcFormula = exist("Comment Line" WHERE("Table Name" = CONST("SMB Seminar"),
                                                      "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(31; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
            trigger OnValidate()
            begin
                // ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;

        }
        field(32; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(33; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
        }
        field(40; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Duration (Days) field.';
        }
        field(41; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Minimum Participants field.';
            trigger OnValidate()
            begin
                if ("Minimum Participants" > "Maximum Participants") and
                    ("Minimum Participants" > 0) and
                    ("Maximum Participants" > 0)
                then
                    FieldError(
                        "Minimum Participants",
                        StrSubstNo(
                            MustBeLEErr,
                            FieldCaption("Maximum Participants")));
            end;
        }
        field(42; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Maximum Participants field.';
            trigger OnValidate()
            begin
                if ("Maximum Participants" < "Minimum Participants") and
                    ("Minimum Participants" > 0) and
                    ("Maximum Participants" > 0)
                then
                    FieldError(
                        "Maximum Participants",
                        StrSubstNo(
                            MustBeGEErr,
                            FieldCaption("Minimum Participants")));
            end;
        }
        field(43; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Language Code field.';
        }
        field(44; "Seminar Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Seminar Price';
            MinValue = 0;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Seminar Price field.';
        }

        field(140; Image; Media)
        {
            Caption = 'Image';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the picture that has been inserted for the resource.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Language Code", "Duration Days") { }
        fieldgroup(Brick; "No.", Description, "Language Code", "Duration Days", Image) { }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SMBSemSetup.Get();
            SMBSemSetup.TestField("Seminar Nos.");
            // ALT: NoSeriesMgt.InitSeries(SemSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "No. Series" := SMBSemSetup."Seminar Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            SMBSem.ReadIsolation(IsolationLevel::ReadUncommitted);
            SMBSem.SetLoadFields("No.");
            while SMBSem.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today();
    end;

    trigger OnDelete()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        SMBSeminarRegHeader.SetRange("Seminar No.","No.");
        if not SMBSeminarRegHeader.IsEmpty then
            Error(CannotDeleteErr,TableCaption,SMBSeminarRegHeader.TableCaption);

        CommentLine.SetRange("Table Name", CommentLine."Table Name"::"SMB Seminar");
        CommentLine.SetRange("No.", "No.");
        CommentLine.DeleteAll();


       
    end;

    trigger OnRename()
    begin
        CommentLine.RenameCommentLine(CommentLine."Table Name"::"SMB Seminar", xRec."No.", "No.");
        "Last Date Modified" := Today();
    end;

    var
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        CommentLine: Record "Comment Line";
        SMBSemSetup: Record "SMB Seminar Setup";
        SMBSem: Record "SMB Seminar";
        // NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        MustBeLEErr: Label 'must be less or equal %1', Comment = '%1 = Fieldcaption Max Amount';
        MustBeGEErr: Label 'must be greater or equal %1', Comment = '%1 Fieldname';
        CannotDeleteErr: Label 'You cannot delete the %1 because there is one or more %2.', Comment = '%1%2';

    procedure TestBlocked()
    begin
        TestField(Blocked, false);
    end;

 procedure AssistEdit(OldSem: Record "SMB Seminar") Result: Boolean
    begin
        SMBSem := Rec;
        SMBSemSetup.Get();
        SMBSemSetup.TestField("Seminar Nos.");
        if NoSeries.LookupRelatedNoSeries(
                SMBSemSetup."Seminar Nos.",
                OldSem."No. Series",
                SMBSem."No. Series")
        then begin
            SMBSem."No." := NoSeries.GetNextNo(SMBSem."No. Series");
            Rec := SMBSem;
            exit(true);
        end;
    end;
}
