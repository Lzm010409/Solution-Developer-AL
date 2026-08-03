codeunit 63699 "PTE Softw. Sales Mgt. Test"
{
    // [FEATURE] [PTE Software Sales Management]
    Subtype = Test;
    TestPermissions = Disabled;

    var
        SoftwChangeTestLib: Codeunit "PTE Softw. Change Test Lib";
        ConfirmQuestion: Text;

    [Test]
    procedure TestTemplateValuesAreCopiedIntoSoftwareChange()
    var
        SoftwareSalesMgtSetup: Record "PTE Software Sales Mgt. Setup";
        SoftwareChangeTemplate: Record "PTE Software Change Template";
        SoftwareChange: Record "PTE Software Change";
        Assert: Codeunit Assert;
    begin
        // [Scenario] A software change is created with a software change template

        // [Given] A software sales management setup with number series
        SoftwChangeTestLib.CreateSoftwareSalesSetup(SoftwareSalesMgtSetup);
        // [Given] A software change template carrying invoicing and commission defaults
        SoftwChangeTestLib.CreateSoftwareChangeTemplate(SoftwareChangeTemplate);
        // [Given] A new empty software change
        SoftwChangeTestLib.CreateSoftwareChange(SoftwareChange);

        // [When] The template code is entered on the software change
        SoftwareChange.Validate("Software Change Template Code", SoftwareChangeTemplate.Code);

        // [Then] The description of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate.Description, SoftwareChange.Description,
            'Description was not taken over from the software change template.');
        // [Then] The accounting type of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate."Accounting Type", SoftwareChange."Accounting Type",
            'Accounting Type was not taken over from the software change template.');
        // [Then] The commission percentage of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate."Commission Percentage", SoftwareChange."Commission Percentage",
            'Commission Percentage was not taken over from the software change template.');
        // [Then] The developer resource of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate."Developer Resource No.", SoftwareChange."Developer Resource No.",
            'Developer Resource No. was not taken over from the software change template.');
        // [Then] The general business posting group of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate."Gen. Bus. Posting Group", SoftwareChange."Gen. Bus. Posting Group",
            'Gen. Bus. Posting Group was not taken over from the software change template.');
        // [Then] The VAT business posting group of the template is taken over
        Assert.AreEqual(
            SoftwareChangeTemplate."VAT Bus. Posting Group", SoftwareChange."VAT Bus. Posting Group",
            'VAT Bus. Posting Group was not taken over from the software change template.');
    end;

    [Test]
    procedure TestCopySoftwareChangeCopiesAllGroupsAndComments()
    var
        SoftwareSalesMgtSetup: Record "PTE Software Sales Mgt. Setup";
        FromSoftwareChange: Record "PTE Software Change";
        ToSoftwareChange: Record "PTE Software Change";
        CopySoftwareChange: Codeunit "PTE Copy Software Change";
        Assert: Codeunit Assert;
    begin
        // [Scenario] A software change is copied including all groups and its comments

        // [Given] A software sales management setup with number series
        SoftwChangeTestLib.CreateSoftwareSalesSetup(SoftwareSalesMgtSetup);
        // [Given] A completely filled software change with a comment
        SoftwChangeTestLib.CreateFilledSoftwareChange(FromSoftwareChange);
        SoftwChangeTestLib.CreateCommentLine("Comment Line Table Name"::"PTE Software Change", FromSoftwareChange."No.");

        // [When] The software change is copied with all copy options switched on
        CopySoftwareChange.CopySoftwareChange(FromSoftwareChange, ToSoftwareChange, true, true, true, true);

        // [Then] The new software change has a number of its own
        Assert.AreNotEqual(
            FromSoftwareChange."No.", ToSoftwareChange."No.",
            'The copied software change must not reuse the number of the original one.');
        // [Then] The fields of the group General are copied
        Assert.AreEqual(
            FromSoftwareChange.Description, ToSoftwareChange.Description,
            'Description was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Closing Date", ToSoftwareChange."Closing Date",
            'Closing Date was not copied.');
        Assert.AreEqual(
            FromSoftwareChange.Priority, ToSoftwareChange.Priority,
            'Priority was not copied.');
        // [Then] The fields of the group Invoicing are copied
        Assert.AreEqual(
            FromSoftwareChange."Salesperson Code", ToSoftwareChange."Salesperson Code",
            'Salesperson Code was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Customer No.", ToSoftwareChange."Customer No.",
            'Customer No. was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Developer Resource No.", ToSoftwareChange."Developer Resource No.",
            'Developer Resource No. was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Quantity Implementation (hrs)", ToSoftwareChange."Quantity Implementation (hrs)",
            'Quantity Implementation (hrs) was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Commission Percentage", ToSoftwareChange."Commission Percentage",
            'Commission Percentage was not copied.');
        // [Then] The fields of the group Contact Person are copied
        Assert.AreEqual(
            FromSoftwareChange."Contact No.", ToSoftwareChange."Contact No.",
            'Contact No. was not copied.');
        Assert.AreEqual(
            FromSoftwareChange."Contact E-Mail", ToSoftwareChange."Contact E-Mail",
            'Contact E-Mail was not copied.');
        // [Then] The comments of the original software change are copied
        Assert.AreEqual(
            SoftwChangeTestLib.CountCommentLines("Comment Line Table Name"::"PTE Software Change", FromSoftwareChange."No."),
            SoftwChangeTestLib.CountCommentLines("Comment Line Table Name"::"PTE Software Change", ToSoftwareChange."No."),
            'The comments were not copied to the new software change.');
    end;

    [Test]
    [HandlerFunctions('PostSoftwareChangeConfirmHandler')]
    procedure TestPostingAsksTheUserForConfirmation()
    var
        SoftwareSalesMgtSetup: Record "PTE Software Sales Mgt. Setup";
        SoftwareChange: Record "PTE Software Change";
        SoftwChangePostYesNo: Codeunit "PTE Softw. Change-Post (Y/N)";
        Assert: Codeunit Assert;
        CanceledByUserErr: Label 'Canceled by user.', Locked = true;
    begin
        // [Scenario] The posting routine is started for a software change

        // [Given] A software sales management setup with number series
        SoftwChangeTestLib.CreateSoftwareSalesSetup(SoftwareSalesMgtSetup);
        // [Given] A completely filled software change
        SoftwChangeTestLib.CreateFilledSoftwareChange(SoftwareChange);
        Clear(ConfirmQuestion);

        // [When] The posting routine is started and the user declines
        asserterror SoftwChangePostYesNo.Run(SoftwareChange);

        // [Then] The user was asked whether the software change should be posted
        Assert.AreNotEqual(
            '', ConfirmQuestion,
            'The user was not asked for confirmation before posting.');
        // [Then] Posting is canceled with the standard cancellation error
        Assert.ExpectedError(CanceledByUserErr);
    end;

    [ConfirmHandler]
    procedure PostSoftwareChangeConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        ConfirmQuestion := Question;
        Reply := false;
    end;
}
