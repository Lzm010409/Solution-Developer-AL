codeunit 63610 "PTE Software Change"
{
    procedure ApplyTemplate(var SoftwareChange: Record "PTE Software Change")
    var
        SoftwareChangeTemplate: Record "PTE Software Change Template";
    begin
        if SoftwareChange."Software Change Template Code" = '' then
            exit;

        SoftwareChangeTemplate.Get(SoftwareChange."Software Change Template Code");
        SoftwareChange.Description := SoftwareChangeTemplate.Description;
        SoftwareChange.Validate("Accounting Type", SoftwareChangeTemplate."Accounting Type");
        SoftwareChange.Validate("Commission Percentage", SoftwareChangeTemplate."Commission Percentage");
        SoftwareChange.Validate("Developer Resource No.", SoftwareChangeTemplate."Developer Resource No.");
        SoftwareChange.Validate("Gen. Bus. Posting Group", SoftwareChangeTemplate."Gen. Bus. Posting Group");
        SoftwareChange.Validate("VAT Bus. Posting Group", SoftwareChangeTemplate."VAT Bus. Posting Group");
    end;

    procedure UpdateCustomerDetails(var SoftwareChange: Record "PTE Software Change")
    var
        Customer: Record Customer;
    begin
        if SoftwareChange."Customer No." = '' then
            exit;

        Customer.Get(SoftwareChange."Customer No.");
        CheckNotPrivacyBlocked(Customer."Privacy Blocked", Customer.TableCaption(), Customer."No.");
        SoftwareChange.Validate("Gen. Bus. Posting Group", Customer."Gen. Bus. Posting Group");
        SoftwareChange.Validate("VAT Bus. Posting Group", Customer."VAT Bus. Posting Group");
    end;

    procedure UpdateContactDetails(var SoftwareChange: Record "PTE Software Change")
    var
        Contact: Record Contact;
    begin
        if SoftwareChange."Contact No." = '' then begin
            Clear(SoftwareChange."Contact Name");
            Clear(SoftwareChange."Contact Phone No.");
            Clear(SoftwareChange."Contact E-Mail");
            exit;
        end;

        Contact.Get(SoftwareChange."Contact No.");
        CheckNotPrivacyBlocked(Contact."Privacy Blocked", Contact.TableCaption(), Contact."No.");
        SoftwareChange."Contact Name" := Contact.Name;
        SoftwareChange."Contact Phone No." := Contact."Phone No.";
        SoftwareChange."Contact E-Mail" := Contact."E-Mail";
    end;

    procedure CheckSalespersonNotPrivacyBlocked(SalespersonCode: Code[20])
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if SalespersonCode = '' then
            exit;

        SalespersonPurchaser.Get(SalespersonCode);
        CheckNotPrivacyBlocked(SalespersonPurchaser."Privacy Blocked", SalespersonPurchaser.TableCaption(), SalespersonPurchaser.Code);
    end;

    procedure CheckResourceNotPrivacyBlocked(ResourceNo: Code[20])
    var
        Resource: Record Resource;
    begin
        if ResourceNo = '' then
            exit;

        Resource.Get(ResourceNo);
        CheckNotPrivacyBlocked(Resource."Privacy Blocked", Resource.TableCaption(), Resource."No.");
    end;

    local procedure CheckNotPrivacyBlocked(PrivacyBlocked: Boolean; RecordCaption: Text; RecordNo: Code[20])
    var
        PrivacyBlockedErr: Label 'The %1 %2 is blocked for privacy reasons and cannot be used in a software change.', Comment = 'de-DE=%1 %2 ist aus Datenschutzgründen gesperrt und kann in einer Softwareanpassung nicht verwendet werden.';
    begin
        if not PrivacyBlocked then
            exit;

        Error(PrivacyBlockedErr, RecordCaption, RecordNo);
    end;

    procedure ShowComments(TableName: Enum "Comment Line Table Name"; No: Code[20])
    var
        CommentLine: Record "Comment Line";
        CommentSheet: Page "Comment Sheet";
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        Clear(CommentSheet);
        CommentSheet.SetTableView(CommentLine);
        CommentSheet.RunModal();
    end;

    procedure CopyComments(FromTableName: Enum "Comment Line Table Name"; ToTableName: Enum "Comment Line Table Name"; FromNo: Code[20]; ToNo: Code[20])
    var
        CommentLineSource: Record "Comment Line";
        CommentLineTarget: Record "Comment Line";
    begin
        CommentLineSource.SetRange("Table Name", FromTableName);
        CommentLineSource.SetRange("No.", FromNo);
        if CommentLineSource.FindSet() then
            repeat
                CommentLineTarget := CommentLineSource;
                CommentLineTarget."Table Name" := ToTableName;
                CommentLineTarget."No." := ToNo;
                CommentLineTarget.Insert();
            until CommentLineSource.Next() = 0;
    end;

    procedure DeleteComments(No: Code[20])
    begin
        DeleteCommentsForTableName("Comment Line Table Name"::"PTE Software Change", No);
    end;

    procedure DeletePostedComments(No: Code[20])
    begin
        DeleteCommentsForTableName("Comment Line Table Name"::"PTE Posted Software Change", No);
    end;

    local procedure DeleteCommentsForTableName(TableName: Enum "Comment Line Table Name"; No: Code[20])
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", TableName);
        CommentLine.SetRange("No.", No);
        if not CommentLine.IsEmpty() then
            CommentLine.DeleteAll();
    end;
}
