codeunit 63701 "PTE Softw. Change Test Lib"
{
    var
        SoftwareChangeNosTxt: Label 'TESTSC', Locked = true;
        PostedSoftwareChangeNosTxt: Label 'TESTPSC', Locked = true;
        SoftwareChangeStartingNoTxt: Label 'SC00001', Locked = true;
        PostedSoftwareChangeStartingNoTxt: Label 'PSC00001', Locked = true;

    procedure CreateSoftwareSalesSetup(var SoftwareSalesMgtSetup: Record "PTE Software Sales Mgt. Setup")
    begin
        CreateNoSeries(SoftwareChangeNosTxt, SoftwareChangeStartingNoTxt);
        CreateNoSeries(PostedSoftwareChangeNosTxt, PostedSoftwareChangeStartingNoTxt);

        if not SoftwareSalesMgtSetup.Get('') then begin
            SoftwareSalesMgtSetup.Init();
            SoftwareSalesMgtSetup."Primary Key" := '';
            SoftwareSalesMgtSetup.Insert();
        end;

        SoftwareSalesMgtSetup."Software Change Nos." := SoftwareChangeNosTxt;
        SoftwareSalesMgtSetup."Posted Software Change Nos." := PostedSoftwareChangeNosTxt;
        SoftwareSalesMgtSetup.Modify();
    end;

    local procedure CreateNoSeries(NoSeriesCode: Code[20]; StartingNo: Code[20])
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
    begin
        if NoSeries.Get(NoSeriesCode) then
            exit;

        NoSeries.Init();
        NoSeries.Code := NoSeriesCode;
        NoSeries.Description := NoSeriesCode;
        NoSeries."Default Nos." := true;
        NoSeries.Insert();

        NoSeriesLine.Init();
        NoSeriesLine."Series Code" := NoSeriesCode;
        NoSeriesLine."Line No." := 10000;
        NoSeriesLine."Starting No." := StartingNo;
        NoSeriesLine."Increment-by No." := 1;
        NoSeriesLine.Insert();
    end;

    procedure CreateSoftwareChangeTemplate(var SoftwareChangeTemplate: Record "PTE Software Change Template")
    var
        GenBusinessPostingGroup: Record "Gen. Business Posting Group";
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
        Resource: Record Resource;
    begin
        CreateGenBusPostingGroup(GenBusinessPostingGroup);
        CreateVATBusPostingGroup(VATBusinessPostingGroup);
        CreateResource(Resource);

        SoftwareChangeTemplate.Init();
        SoftwareChangeTemplate.Code := CopyStr(CreateUniqueCode('TMPL'), 1, MaxStrLen(SoftwareChangeTemplate.Code));
        SoftwareChangeTemplate.Description := CopyStr(CreateUniqueCode('Template'), 1, MaxStrLen(SoftwareChangeTemplate.Description));
        SoftwareChangeTemplate.Insert(true);

        SoftwareChangeTemplate.Validate("Accounting Type", SoftwareChangeTemplate."Accounting Type"::"Software Change");
        SoftwareChangeTemplate.Validate("Commission Percentage", 2);
        SoftwareChangeTemplate.Validate("Developer Resource No.", Resource."No.");
        SoftwareChangeTemplate.Validate("Gen. Bus. Posting Group", GenBusinessPostingGroup.Code);
        SoftwareChangeTemplate.Validate("VAT Bus. Posting Group", VATBusinessPostingGroup.Code);
        SoftwareChangeTemplate.Modify(true);
    end;

    procedure CreateSoftwareChange(var SoftwareChange: Record "PTE Software Change")
    begin
        SoftwareChange.Init();
        SoftwareChange."No." := '';
        SoftwareChange.Insert(true);
    end;

    procedure CreateFilledSoftwareChange(var SoftwareChange: Record "PTE Software Change")
    var
        Customer: Record Customer;
        Contact: Record Contact;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        Resource: Record Resource;
        GenBusinessPostingGroup: Record "Gen. Business Posting Group";
        VATBusinessPostingGroup: Record "VAT Business Posting Group";
    begin
        CreateCustomer(Customer);
        CreateContact(Contact);
        CreateSalespersonPurchaser(SalespersonPurchaser);
        CreateResource(Resource);
        CreateGenBusPostingGroup(GenBusinessPostingGroup);
        CreateVATBusPostingGroup(VATBusinessPostingGroup);

        CreateSoftwareChange(SoftwareChange);

        SoftwareChange.Description := CopyStr(CreateUniqueCode('Change'), 1, MaxStrLen(SoftwareChange.Description));
        SoftwareChange."Entry Date" := WorkDate();
        SoftwareChange."Closing Date" := CalcDate('<+7D>', WorkDate());
        SoftwareChange.Status := SoftwareChange.Status::"In Progress";
        SoftwareChange.Priority := 1;
        SoftwareChange."Salesperson Code" := SalespersonPurchaser.Code;
        SoftwareChange."Customer No." := Customer."No.";
        SoftwareChange."Gen. Bus. Posting Group" := GenBusinessPostingGroup.Code;
        SoftwareChange."VAT Bus. Posting Group" := VATBusinessPostingGroup.Code;
        SoftwareChange."Developer Resource No." := Resource."No.";
        SoftwareChange."Quantity Implementation (hrs)" := 10;
        SoftwareChange."Accounting Type" := SoftwareChange."Accounting Type"::"Software Change";
        SoftwareChange."Commission Percentage" := 2;
        SoftwareChange."Contact No." := Contact."No.";
        SoftwareChange."Contact Name" := Contact.Name;
        SoftwareChange."Contact Phone No." := '123456';
        SoftwareChange."Contact E-Mail" := 'test@contoso.com';
        SoftwareChange.Modify(true);
    end;

    procedure CreateCommentLine(TableName: Enum "Comment Line Table Name"; No: Code[20])
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.Init();
        CommentLine."Table Name" := TableName;
        CommentLine."No." := No;
        CommentLine."Line No." := GetNextCommentLineNo(TableName, No);
        CommentLine.Date := WorkDate();
        CommentLine.Comment := CopyStr(CreateUniqueCode('Comment'), 1, MaxStrLen(CommentLine.Comment));
        CommentLine.Insert();
    end;

    local procedure GetNextCommentLineNo(TableName: Enum "Comment Line Table Name"; No: Code[20]): Integer
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        if CommentLine.FindLast() then
            exit(CommentLine."Line No." + 10000);
        exit(10000);
    end;

    procedure CountCommentLines(TableName: Enum "Comment Line Table Name"; No: Code[20]): Integer
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        exit(CommentLine.Count());
    end;

    local procedure CreateCustomer(var Customer: Record Customer)
    begin
        Customer.Init();
        Customer."No." := CopyStr(CreateUniqueCode('CUST'), 1, MaxStrLen(Customer."No."));
        Customer.Name := Customer."No.";
        Customer.Insert();
    end;

    local procedure CreateContact(var Contact: Record Contact)
    begin
        Contact.Init();
        Contact."No." := CopyStr(CreateUniqueCode('CONT'), 1, MaxStrLen(Contact."No."));
        Contact.Name := Contact."No.";
        Contact.Insert();
    end;

    local procedure CreateSalespersonPurchaser(var SalespersonPurchaser: Record "Salesperson/Purchaser")
    begin
        SalespersonPurchaser.Init();
        SalespersonPurchaser.Code := CopyStr(CreateUniqueCode('SP'), 1, MaxStrLen(SalespersonPurchaser.Code));
        SalespersonPurchaser.Name := SalespersonPurchaser.Code;
        SalespersonPurchaser.Insert();
    end;

    local procedure CreateResource(var Resource: Record Resource)
    begin
        Resource.Init();
        Resource."No." := CopyStr(CreateUniqueCode('RES'), 1, MaxStrLen(Resource."No."));
        Resource.Name := Resource."No.";
        Resource.Insert();
    end;

    local procedure CreateGenBusPostingGroup(var GenBusinessPostingGroup: Record "Gen. Business Posting Group")
    begin
        GenBusinessPostingGroup.Init();
        GenBusinessPostingGroup.Code := CopyStr(CreateUniqueCode('GBPG'), 1, MaxStrLen(GenBusinessPostingGroup.Code));
        GenBusinessPostingGroup.Description := GenBusinessPostingGroup.Code;
        GenBusinessPostingGroup.Insert();
    end;

    local procedure CreateVATBusPostingGroup(var VATBusinessPostingGroup: Record "VAT Business Posting Group")
    begin
        VATBusinessPostingGroup.Init();
        VATBusinessPostingGroup.Code := CopyStr(CreateUniqueCode('VBPG'), 1, MaxStrLen(VATBusinessPostingGroup.Code));
        VATBusinessPostingGroup.Description := VATBusinessPostingGroup.Code;
        VATBusinessPostingGroup.Insert();
    end;

    local procedure CreateUniqueCode(Prefix: Text): Text
    begin
        exit(Prefix + Format(CurrentDateTime(), 0, '<Hours24><Minutes,2><Seconds,2><Thousands,3>') + Format(Random(999)));
    end;
}
