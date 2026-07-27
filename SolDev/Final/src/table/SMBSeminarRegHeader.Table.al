table 123456710 "SMB Seminar Reg. Header"
{
    Caption = 'Seminar Registration';
    DataCaptionFields = "No.", "Starting Date", "Seminar Description";
    LookupPageID = "SMB Seminar Registration List";
    DrillDownPageID = "SMB Seminar Registration List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the value of the No. field.';
            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    SMBSeminarSetup.Get();
                    NoSeries.TestManual(SMBSeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            ToolTip = 'Specifies the value of the Starting Date field.';
            trigger OnValidate()
            begin
                TestStatusPlanning();
                TestNoLine();

                if ("Starting Date" < WorkDate()) and ("Starting Date" > 0D) then
                    Message(DateInPastMsg, FieldCaption("Starting Date"));
            end;
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "SMB Seminar" where(Blocked = const(false));
            ToolTip = 'Specifies the value of the Seminar No. field.';

            trigger OnValidate()
            begin
                // Ein Seminar darf nur ausgewählt werden, wenn der Staus Planning ist und
                // es noch keine Anmeldungen gibt


                // wenn der dazugehörige Stammdatensatz gelesen wurde
                // Stammdatensatz lesen
                // prüfen ob er verwendet werden darf
                // alle dazugehörigen Felder füllen

                TestStatusPlanning();
                TestNoLine();

                SMBSeminar.Get("Seminar No.");
                SMBSeminar.TestBlocked();
                // SMBSeminar.TestField(Blocked,false);

                FillHeaderFieldsFromMaster();

            end;
        }
        field(4; "Seminar Description"; Text[100])
        {
            Caption = 'Seminar Description';
            ToolTip = 'Specifies the value of the Seminar Description field.';
        }
        field(5; "Instructor Code"; Code[20])
        {
            Caption = 'Instructor Code';
            TableRelation = "SMB Instructor" where(Blocked = const(false));
            ToolTip = 'Specifies the value of the Instructor Code field.';
            trigger OnValidate()
            var
                SMBInstructor: Record "SMB Instructor";
            begin
                SMBInstructor.Get("Instructor Code");
                SMBInstructor.TestField(Blocked, false);
                CalcFields("Instructor Name");
            end;
        }
        field(6; "Instructor Name"; Text[100])
        {
            Caption = 'Instructor Name';
            ToolTip = 'Specifies the value of the Instructor Name field.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup("SMB Instructor".Name where(Code = field("Instructor Code")));

        }
        field(7; Status; Enum "SMB Seminar Reg. Status")
        {
            Caption = 'Status';
            ToolTip = 'Specifies the value of the Status field.';
        }
        field(9; "Duration Days"; Integer)
        {
            Caption = 'Duration (Days)';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Duration (Days) field.';
            trigger OnValidate()
            begin
                TestStatusPlanning();
                TestNoLine();
            end;
        }
        field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Minimum Participants field.';
            // Prüfung Min < Max
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
        field(11; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Maximum Participants field.';
            // Prüfung Min < Max
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
        field(12; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            ToolTip = 'Specifies the value of the Language Code field.';
            trigger OnValidate()
            begin
                TestStatusPlanning();
                TestNoLine();
            end;
        }
        field(13; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the value of the Salesperson Code field.';
        }
        field(14; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            MinValue = 0;
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Seminar Price field.';
            trigger OnValidate()
            var
            // SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
            begin
                // Wenn sich der Seminarpreis tatsächlich ändert
                // Soll gefragt (Confirm) werden (aber nur wenn es änderbare Zeilen gibt Registered = false)
                // ob diese geändert werden sollen
                // -> ja -> alle dazugehörigen änderbare Zeilen einzeln lesen
                //             pro Zeile den Preis validieren

                // if "Seminar Price" <> xRec."Seminar Price" then begin
                //     SMBSeminarRegLine.SetRange("Document No.","No.");
                //     SMBSeminarRegLine.SetRange(Registered,false);
                //     if not SMBSeminarRegLine.IsEmpty then
                //         if Confirm('Do you want to change the %1?',true,FieldCaption("Seminar Price"))then begin 
                //             SMBSeminarRegLine.FindSet(true);
                //             repeat
                //                 SMBSeminarRegLine.Validate("Seminar Price (LCY)","Seminar Price");
                //                 SMBSeminarRegLine.Modify();
                //             until SMBSeminarRegLine.Next() = 0;
                //         end;
                // end;

                UpdateSMBSeminarRegLinesByFieldNo(FieldNo("Seminar Price"), CurrFieldNo <> 0, true);
            end;
        }
        field(15; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            ToolTip = 'Specifies the value of the Gen. Prod. Posting Group field.';
            // füllen von VAT
            trigger OnValidate()
            begin
                if xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" then
                    if GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;

        }
        field(16; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            ToolTip = 'Specifies the value of the VAT Prod. Posting Group field.';
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

        }
        field(20; "Room Code"; Code[20])
        {
            Caption = 'Room Code';
            TableRelation = "SMB Seminar Room" where(Blocked = const(false));
            ToolTip = 'Specifies the value of the Room Code field.';
            trigger OnValidate()
            begin
                if "Room Code" <> '' then begin
                    SMBSeminarRoom.Get("Room Code");
                    SMBSeminarRoom.TestBlocked();

                end else
                    SMBSeminarRoom.Init();

                FillRoomFields();
            end;
        }
        field(21; "Room Name"; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the value of the Name field.';
        }
        field(22; "Room Name 2"; Text[50])
        {
            Caption = 'Name 2';
            ToolTip = 'Specifies the value of the Name 2 field.';
        }
        field(23; "Room Address"; Text[100])
        {
            Caption = 'Address';
            ToolTip = 'Specifies the value of the Address field.';
        }
        field(24; "Room Address 2"; Text[50])
        {
            Caption = 'Address 2';
            ToolTip = 'Specifies the value of the Address 2 field.';
        }
        field(25; "Room City"; Text[30])
        {
            Caption = 'City';
            ToolTip = 'Specifies the value of the City field.';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code".City
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code");
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("Room City", "Room Post Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;

        }
        field(26; "Room Contact"; Text[50])
        {
            Caption = 'Contact';
            ToolTip = 'Specifies the value of the Contact field.';
        }
        field(27; "Room Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the value of the Country/Region Code field.';
        }
        field(28; "Room Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = if ("Room Country/Region Code" = const('')) "Post Code"
            else
            if ("Room Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Room Country/Region Code"));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the value of the Post Code field.';
            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code");
            end;

            trigger OnValidate()

            begin
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;


        }
        field(29; "Room County"; Text[30])
        {
            Caption = 'County';
            ToolTip = 'Specifies the value of the County field.';
        }
        field(42; Comment; Boolean)
        {
            Caption = 'Comment';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = exist("SMB Seminar Comment Line" where("Document Type" = const("SMB Sem. Comment Document Type"::"Seminar Registration"),
                                                                "No." = field("No."),
                                                                "Line No." = const(0)));

        }
        field(52; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            ToolTip = 'Specifies the value of the Posting Date field.';
            trigger OnValidate()
            begin
                // ist bereits eine Buchungsnummer gezogen und es wird nachträglich das Buchungsdatum geändert, wird geprüft,
                // ob die hinterlegte Buchungsnummernserie das zu lässt (Chronologisch)

                TestField("Posting Date");
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FieldCaption("Posting No."), FieldCaption("Posting No. Series"));

                UpdateCurrFactorInLines();
            end;
        }
        field(53; "Document Date"; Date)
        {
            Caption = 'Document Date';
            ToolTip = 'Specifies the value of the Document Date field.';
        }
        field(54; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(56; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(61; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(62; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
            trigger OnLookup()
            var
                NoSeries: Codeunit "No. Series";
            begin
                SMBSeminarRegHeader := Rec;
                SMBSeminarSetup.Get();
                SMBSeminarRegHeader.TestField("No. Series");
                if NoSeries.LookupRelatedNoSeries(SMBSeminarSetup."Posted Seminar Reg. Nos.", SMBSeminarRegHeader."Posting No. Series") then
                    SMBSeminarRegHeader.Validate("Posting No. Series");
                Rec := SMBSeminarRegHeader;
            end;

            trigger OnValidate()
            var
                NoSeries: Codeunit "No. Series";
            begin
                if "Posting No. Series" <> '' then begin
                    SMBSeminarSetup.Get();
                    TestField("No. Series");
                    NoSeries.TestAreRelated(SMBSeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;

        }
        field(63; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(100; "No. of Participants"; Integer)
        {
            Caption = 'No. of Participants';
            ToolTip = 'Specifies the value of the No. of Participants field.';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = count("SMB Seminar Reg. Line" where("Document No." = field("No.")));
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";


        }
        field(490; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));


        }
        field(491; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));


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
        fieldgroup(DropDown; "No.", "Starting Date", "Seminar No.", "Seminar Description", "Room Code") { }
        fieldgroup(Brick; "No.", "Seminar Description") { }
    }

    trigger OnInsert()
    begin
        InitInsert();

        // Neue Prozedur InitInsert
        // Numernserie nach InitInsert und InitRecord aufrufen
        // Neue Prozedur "InitRecord"
        // Buchungsnummernserie füllen:
        //  Wenn die Posting Nos = leer ist, soll aus der Einrichtung die Buchungsnummernserie
        //  geholt werden.
        // Füllen von PostingDate
        // DocumentDate füllen
        // Buchungsbeschreibung füllen

        if GetFilter("Seminar No.") <> '' then
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
                Validate("Seminar No.", GetRangeMin("Seminar No."));



    end;

    trigger OnDelete()
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    begin
        TestStatusFinished();

        SMBSeminarRegLine.SetRange("Document No.", "No.");
        SMBSeminarRegLine.SetRange(Registered, true);
        if not SMBSeminarRegLine.IsEmpty then begin
            SMBSeminarRegLine.SetRange(Registered, false);
            if not SMBSeminarRegLine.IsEmpty then
                Error(MixedLineExistErr, TableCaption);
        end;
        SMBSeminarRegLine.SetRange(Registered);

        // SMBSeminarRegLine.SetRange("Document No.", "No."); gelöscht weil oben schon gefiltert wurde
        SMBSeminarRegLine.DeleteAll();

        SMBSeminarCommentLine.DeleteComments(SMBSeminarCommentLine."Document Type"::"Seminar Registration", "No.");


    end;

    trigger OnRename()
    begin
        Error(CannotRenameErr, TableCaption);
    end;

    var
        PostCode: Record "Post Code";
        GenProdPostingGrp: Record "Gen. Product Posting Group";
        SMBSeminarRoom: Record "SMB Seminar Room";
        SMBSeminar: Record "SMB Seminar";
        SMBSeminarSetup: Record "SMB Seminar Setup";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        GlobalNoSeries: Record "No. Series";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeries: Codeunit "No. Series";
        CannotRenameErr: Label 'You cannot rename a %1.', Comment = '%1';
        CannotChangeFieldErr: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.', Comment = '%1%2%3%4%5%6%7%8';
        MustBeErr: Label 'must be %1 or %2', Comment = '%1%2';
        MixedLineExistErr: Label 'You cannot delete the %1 because there are mixed lines', Comment = '%1%2';
        StatusMustBeErr: Label 'must be %1', Comment = '%1';
        LineExistErr: Label 'There are one or more %1 for the %2.', Comment = '%1%2';
        DateInPastMsg: Label '%1 is in the past.', Comment = '%1%2';
        MustBeLEErr: Label 'must be less or equal %1', Comment = '%1 = Fieldcaption Max Amount';
        MustBeGEErr: Label 'must be greater or equal %1', Comment = '%1 Fieldname';
        CurrExRateQst: Label 'The posting date has changed. The exchange rates may need to be updated. Do you want to update the line items?';

    procedure AssistEdit(OldSeminarRegHeader: Record "SMB Seminar Reg. Header") Result: Boolean
    begin
        SMBSeminarRegHeader := Rec;
        SMBSeminarSetup.Get();
        SMBSeminarSetup.TestField("Seminar Registration Nos.");
        if NoSeries.LookupRelatedNoSeries(
                SMBSeminarSetup."Seminar Nos.",
                OldSeminarRegHeader."No. Series",
                SMBSeminarRegHeader."No. Series")
        then begin
            SMBSeminarRegHeader."No." := NoSeries.GetNextNo(SMBSeminarRegHeader."No. Series");
            Rec := SMBSeminarRegHeader;
            exit(true);
        end;
    end;

    local procedure InitInsert()

    begin
        if "No." = '' then begin
            SMBSeminarSetup.Get();
            SMBSeminarSetup.TestField("Seminar Registration Nos.");
            "No. Series" := SMBSeminarSetup."Seminar Registration Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", "Posting Date");   // Achtung PostingDate bei Belegen
            SMBSeminarRegHeader.ReadIsolation(IsolationLevel::ReadUncommitted);
            SMBSeminarRegHeader.SetLoadFields("No.");
            while SMBSeminarRegHeader.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series", "Posting Date"); // Achtung PostingDate bei Belegen
        end;

        InitRecord();

    end;

    local procedure InitRecord()

    begin
        // Buchungsnummernserie füllen:
        //  Wenn die Posting Nos = leer ist, soll aus der Einrichtung die Buchungsnummernserie
        //  geholt werden.
        // if "Posting No. Series" = '' then
        //     "Posting No. Series" := 
        SMBSeminarSetup.Get();
        if "Posting No. Series" = '' then
            if NoSeries.IsAutomatic(SMBSeminarSetup."Posted Seminar Reg. Nos.") then
                "Posting No. Series" := SMBSeminarSetup."Posted Seminar Reg. Nos.";

        // Füllen von PostingDate
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate();

        // DocumentDate füllen
        "Document Date" := WorkDate();

        // Buchungsbeschreibung füllen  
        "Posting Description" := TableCaption + ' ' + "No.";

        // Füllen der Zuständigkeitsheinheit
        "Responsibility Center" := UserSetupMgt.GetRespCenter(0, "Responsibility Center");
    end;

    local procedure TestStatusFinished()
    begin
        if (Status = Status::Planning) or (Status = Status::Registration) then
            FieldError(Status, StrSubstNo(MustBeErr, Status::Canceled, Status::Closed));
    end;

    local procedure FillHeaderFieldsFromMaster()
    begin
        "Seminar Description" := SMBSeminar.Description;
        "Duration Days" := SMBSeminar."Duration Days";
        "Minimum Participants" := SMBSeminar."Minimum Participants";
        "Maximum Participants" := SMBSeminar."Maximum Participants";
        "Language Code" := SMBSeminar."Language Code";
        Validate("Seminar Price", SMBSeminar."Seminar Price");
        SMBSeminar.TestField("Gen. Prod. Posting Group");
        "Gen. Prod. Posting Group" := SMBSeminar."Gen. Prod. Posting Group";
        SMBSeminar.TestField("VAT Prod. Posting Group");
        "VAT Prod. Posting Group" := SMBSeminar."VAT Prod. Posting Group";
        "Shortcut Dimension 1 Code" := SMBSeminar."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := SMBSeminar."Global Dimension 2 Code";
    end;

    procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[20]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            GlobalNoSeries.Get(NoSeriesCode);
            if GlobalNoSeries."Date Order" then
                Error(
                  CannotChangeFieldErr,
                  FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  GlobalNoSeries.FieldCaption("Date Order"), GlobalNoSeries."Date Order", TableCaption,
                  NoCapt, No);
        end;
    end;

    local procedure TestStatusPlanning()
    begin
        if Status <> Status::Planning then
            FieldError(Status, StrSubstNo(StatusMustBeErr, Status::Planning));
    end;

    procedure TestStatusOpen()
    begin
        if Status in [Status::Canceled, Status::Closed] then
            FieldError(Status);
    end;

    local procedure TestNoLine()
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    begin
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        if not SMBSeminarRegLine.IsEmpty then
            Error(LineExistErr, SMBSeminarRegLine.TableCaption, TableCaption);
    end;

    local procedure FillRoomFields()
    begin
        "Room Name" := SMBSeminarRoom.Name;
        "Room Name 2" := SMBSeminarRoom."Name 2";
        "Room Address" := SMBSeminarRoom.Address;
        "Room Address 2" := SMBSeminarRoom."Address 2";
        "Room City" := SMBSeminarRoom.City;
        "Room Contact" := SMBSeminarRoom.Contact;
        "Room Country/Region Code" := SMBSeminarRoom."Country/Region Code";
        "Room Post Code" := SMBSeminarRoom."Post Code";
        "Room County" := SMBSeminarRoom.County;
    end;

    local procedure UpdateCurrFactorInLines()
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    begin
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        SMBSeminarRegLine.SetRange(Registered, false);
        SMBSeminarRegLine.SetFilter("Currency Code", '<>%1', '');

        if not SMBSeminarRegLine.IsEmpty then
            if Confirm(CurrExRateQst, true) then begin
                SMBSeminarRegLine.FindSet(true);
                repeat
                    SMBSeminarRegLine.UpdateCurrencyFactor();
                    SMBSeminarRegLine.Modify();
                until SMBSeminarRegLine.Next() = 0;
            end;
    end;

    procedure UpdateSMBSeminarRegLinesByFieldNo(ChangedFieldNo: Integer; AskQuestion: Boolean; UnregisteredLinesOnly: Boolean)
    var
        "Field": Record "Field";
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        Question: Text[250];

        ConfirmUpdateLinesQst: Label 'You have modified %1.\\Do you want to update the lines?', Comment = '%1';

    begin

        SMBSeminarRegLine.Reset();
        SMBSeminarRegLine.SetRange("Document No.", "No.");
        if UnregisteredLinesOnly then
            SMBSeminarRegLine.SetRange(Registered, false);

        if SMBSeminarRegLine.IsEmpty then
            exit;

        if not Field.Get(DATABASE::"SMB Seminar Reg. Header", ChangedFieldNo) then
            Field.Get(DATABASE::"SMB Seminar Reg. Line", ChangedFieldNo);


        if AskQuestion then begin
            Question := StrSubstNo(ConfirmUpdateLinesQst, Field."Field Caption");
            if GuiAllowed() then
                if not DIALOG.Confirm(Question, true) then
                    exit;
        end;

        SMBSeminarRegLine.LockTable();
        Modify();

        if SMBSeminarRegLine.FindSet() then
            repeat
                case ChangedFieldNo of
                    FieldNo("Seminar Price"):
                        SMBSeminarRegLine.Validate("Seminar Price (LCY)", "Seminar Price");
                end;

                SMBSeminarRegLine.Modify(true);
            until SMBSeminarRegLine.Next() = 0;
    end;
}


