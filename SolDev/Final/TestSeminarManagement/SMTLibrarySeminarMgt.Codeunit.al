codeunit 80151 "SMT Library - Seminar Mgt."
{
    trigger OnRun()
    begin

    end;


    procedure CreateSeminarSetup(var SMBSeminarSetup: Record "SMB Seminar Setup")
    var
        LibraryNoSeries: Codeunit "Library - No. Series";
        NoseriesCodeSemTxt: Label 'TESTSM';
        NoseriesCodeSemRegTxt: Label 'TESTSMREG';
        NoseriesCodePostedSemRegTxt: Label 'TESTPSMREG';
        NoSeriesLineStaringNoSemTxt: Label 'SM00001';
        NoSeriesLineStaringNoSemRegTxt: Label 'SMREG00001';
        NoSeriesLineStaringNoPostedSemRegTxt: Label 'PSMREG00001';
    begin
        LibraryNoSeries.CreateNoSeries(NoseriesCodeSemTxt);
        LibraryNoSeries.CreateNoSeriesLine(NoseriesCodeSemTxt, 1, NoSeriesLineStaringNoSemTxt, '');
        LibraryNoSeries.CreateNoSeries(NoseriesCodeSemRegTxt);
        LibraryNoSeries.CreateNoSeriesLine(NoseriesCodeSemRegTxt, 1, NoSeriesLineStaringNoSemRegTxt, '');
        LibraryNoSeries.CreateNoSeries(NoseriesCodePostedSemRegTxt);
        LibraryNoSeries.CreateNoSeriesLine(NoseriesCodePostedSemRegTxt, 1, NoSeriesLineStaringNoPostedSemRegTxt, '');

        Clear(SMBSeminarSetup);

        if SMBSeminarSetup.get() then
            SMBSeminarSetup.Delete();

        if not SMBSeminarSetup.Get() then begin
            SMBSeminarSetup.Init();
            SMBSeminarSetup."Primary Key" := '';
            SMBSeminarSetup.Insert();
        end;

        SMBSeminarSetup."Seminar Nos." := NoseriesCodeSemTxt;
        SMBSeminarSetup."Seminar Registration Nos." := NoseriesCodeSemRegTxt;
        SMBSeminarSetup."Posted Seminar Reg. Nos." := NoseriesCodePostedSemRegTxt;
        SMBSeminarSetup.Modify();


    end;

    procedure CreateInstructor(var SMBInstructor: Record "SMB Instructor")
    var
        Resource: Record Resource;
        LibraryResource: Codeunit "Library - Resource";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        Clear(SMBInstructor);
        SMBInstructor.Init();
        SMBInstructor.Validate(
            Code,
            LibraryUtility.GenerateRandomCode20(
                SMBInstructor.FieldNo(Code),
                Database::"SMB Instructor"));
        SMBInstructor.Insert(true);
        SMBInstructor.Validate(Name, SMBInstructor.Code);
        LibraryResource.CreateResourceNew(Resource);
        Resource.Validate(Type, Resource.Type::Person);
        Resource.Modify();

        SMBInstructor.Validate(
            "Resource No.",
            Resource."No.");
        SMBInstructor.Modify();
    end;

    procedure CreateSeminarRoom(var SMBSeminarRoom: Record "SMB Seminar Room")
    var
        Resource: Record Resource;
        LibraryResource: Codeunit "Library - Resource";
        LibraryUtility: Codeunit "Library - Utility";
    begin
        Clear(SMBSeminarRoom);
        SMBSeminarRoom.Init();
        SMBSeminarRoom.Validate(
            Code,
            LibraryUtility.GenerateRandomCode20(
                SMBSeminarRoom.FieldNo(Code),
                Database::"SMB Instructor"));
        SMBSeminarRoom.Insert(true);
        SMBSeminarRoom.Validate(Name, SMBSeminarRoom.Code);
        LibraryResource.CreateResourceNew(Resource);
        Resource.Validate(Type, Resource.Type::Machine);
        Resource.Modify();

        SMBSeminarRoom.Validate(
            "Resource No.",
            Resource."No.");
        SMBSeminarRoom.Modify();

    end;

    procedure CreateSeminar(var SMBSeminar: Record "SMB Seminar")
    var
        GeneralPostingSetup: Record "General Posting Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        LibraryERM: Codeunit "Library - ERM";
        Any: Codeunit Any;

    begin
        Clear(SMBSeminar);
        SMBSeminar.Init();
        SMBSeminar."No." := '';
        SMBSeminar.Insert(true);
        SMBSeminar.Validate(Description, SMBSeminar."No.");
        SMBSeminar.Validate("Duration Days", Any.IntegerInRange(5));
        SMBSeminar.Validate("Seminar Price", Any.DecimalInRange(1000, 2));
        SMBSeminar.Validate("Minimum Participants", Any.IntegerInRange(5));
        SMBSeminar.Validate("Maximum Participants", SMBSeminar."Minimum Participants" + Any.IntegerInRange(5));

        LibraryERM.FindGeneralPostingSetupInvtFull(GeneralPostingSetup);
        LibraryERM.FindVATPostingSetupInvt(VATPostingSetup);

        SMBSeminar.Validate("Gen. Prod. Posting Group", GeneralPostingSetup."Gen. Prod. Posting Group");
        SMBSeminar.Validate("VAT Prod. Posting Group", VATPostingSetup."VAT Prod. Posting Group");

        SMBSeminar.Modify();
    end;

    procedure CreateSeminarRegHeader(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminar: Record "SMB Seminar";
        SMBInstructor: Record "SMB Instructor";
        SMBSeminarRoom: Record "SMB Seminar Room";
    begin
        Clear(SMBSeminarRegHeader);
        SMBSeminarRegHeader.Init();
        SMBSeminarRegHeader."No." := '';
        SMBSeminarRegHeader.Insert(true);
        SMBSeminarRegHeader.Validate("Starting Date", WorkDate());
        CreateSeminar(SMBSeminar);
        SMBSeminarRegHeader.Validate("Seminar No.", SMBSeminar."No.");
        CreateInstructor(SMBInstructor);
        SMBSeminarRegHeader.Validate("Instructor Code", SMBInstructor.Code);
        CreateSeminarRoom(SMBSeminarRoom);
        SMBSeminarRegHeader.Validate("Room Code", SMBSeminarRoom.Code);
        SMBSeminarRegHeader.Modify();
    end;

    procedure CreateSeminarRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
                                    SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        Customer: Record Customer;
        Contact: Record Contact;
        LibraryUtility: Codeunit "Library - Utility";
        LibraryMarketing: Codeunit "Library - Marketing";
        RecRef: RecordRef;
    begin
        Clear(SMBSeminarRegLine);
        SMBSeminarRegLine.Init();
        SMBSeminarRegLine."Document No." := SMBSeminarRegHeader."No.";
        RecRef.GetTable(SMBSeminarRegLine);
        SMBSeminarRegLine."Line No." := LibraryUtility.GetNewLineNo(RecRef, SMBSeminarRegLine.FieldNo("Line No."));
        SMBSeminarRegLine.Insert(true);

        LibraryMarketing.CreateContactWithCustomer(Contact, Customer);
        SMBSeminarRegLine.Validate("Bill-to Customer No.", Customer."No.");
        SMBSeminarRegLine.Validate("Participant Contact No.", Contact."No.");
        SMBSeminarRegLine.Modify(true);

    end;
}
