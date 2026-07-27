codeunit 80150 "SMT Test Seminar"
{
    Subtype = Test;
    TestPermissions = Disabled;

    // [FEATURE] [Seminar Management] 

    [Test]
    procedure TestseminarSetup()
    var
        SMBSeminarSetup: Record "SMB Seminar Setup";
        SMTLibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
    begin
        // [Scenario] First setup seminar registration
        // [Given] New Company and empty Seminarsetuptable
        // [When] Open the Setup Page 
        SMTLibrarySeminarManagement.CreateSeminarSetup(SMBSeminarSetup);
        // [Then] Seminar Setup is ready 
    end;

    [Test]
    procedure TestInstructor()
    var
        SMBInstructor: Record "SMB Instructor";
        SMTLibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
    begin
        // [Scenario] First instructor
        // [Given] New Company and empty instructor
        // [When] Open the instructor list 
        SMTLibrarySeminarManagement.CreateInstructor(SMBInstructor);
        // [Then] New instructor 
    end;

    [Test]
    procedure TestSeminar()
    var
        SMBSeminar: Record "SMB Seminar";
        SMTLibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
        Assert: Codeunit Assert;
        Any: Codeunit Any;
    begin

        // [Scenario] Create new seminar
        // [Given] New Company 
        // [When] Add new seminar and fill fields
        SMTLibrarySeminarManagement.CreateSeminar(SMBSeminar);

        SMBSeminar.Validate(Description, LowerCase(Any.AlphabeticText(100)));
        Assert.AreEqual(
            SMBSeminar."Search Description",
            UpperCase(CopyStr(SMBSeminar.Description, 1, MaxStrLen(SMBSeminar."Search Description"))),
             'Suchbegriff ist falsch oder nicht gefüllt');

        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);

        SMBSeminar.Validate("Minimum Participants", Any.IntegerInRange(5));
        SMBSeminar.Validate("Maximum Participants", SMBSeminar."Minimum Participants" + Any.IntegerInRange(5));

        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);

        SMBSeminar.Validate("Minimum Participants", 5);
        asserterror SMBSeminar.Validate("Maximum Participants", SMBSeminar."Minimum Participants" - 1);

        SMBSeminar.Validate("Minimum Participants", 0);
        SMBSeminar.Validate("Maximum Participants", 0);

        SMBSeminar.Validate("Maximum Participants", 5);
        asserterror SMBSeminar.Validate("Minimum Participants", SMBSeminar."Maximum Participants" + 1);
    end;

    [Test]
    [HandlerFunctions('StartingDateMessageHandler,SeminarPostConfirmHandler')]
    procedure TestSeminarRegistration()
    // [FEATURE] Seminar Management
    // [SCENARIO] Enter a new seminar registration with values and post it
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        LibrarySeminarManagement: Codeunit "SMT Library - Seminar Mgt.";
        SMBSeminarPostYesNo: Codeunit "SMB Seminar-Post (Yes/No)";
    begin
        // [GIVEN] A new seminar registration with defaults
        // [WHEN] enter varius values
        // [THEN] Post the registration
        LibrarySeminarManagement.CreateSeminarRegHeader(SMBSeminarRegHeader);

        SMBSeminarRegHeader.Validate("Starting Date", WorkDate() - 1);

        LibrarySeminarManagement.CreateSeminarRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);
        LibrarySeminarManagement.CreateSeminarRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);

        
        SMBSeminarRegHeader.Validate(Status, SMBSeminarRegHeader.Status::Closed);
        SMBSeminarRegHeader.Modify(true);

        SMBSeminarPostYesNo.Run(SMBSeminarRegHeader);

    end;
    [ConfirmHandler]
    procedure SeminarPostConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        
        Reply := true;
    end;

    [MessageHandler]
    procedure StartingDateMessageHandler(MessageText: Text[1024])
    begin

    end;
}