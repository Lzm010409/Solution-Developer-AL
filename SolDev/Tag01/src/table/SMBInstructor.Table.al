table 123456703 "SMB Instructor"
{
    DataClassification = CustomerContent;
    Caption = 'Instructor';
    DataCaptionFields = Code, Name;
    LookupPageId = "SMB Instructors";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the value of the Code field.';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Name field.';
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Blocked field.';
        }
        field(10; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            ToolTip = 'Specifies the value of the Email field.';
            trigger OnValidate()
            begin
                ValidateEmail();
            end;
        }
        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            ToolTip = 'Specifies the value of the Phone No. field.';
            // trigger OnValidate()
            // var
            //     Char: DotNet Char;
            //     i: Integer;
            // begin
            //     for i := 1 to StrLen("Phone No.") do
            //         if Char.IsLetter("Phone No."[i]) then
            //             FieldError("Phone No.", PhoneNoCannotContainLettersErr);
            // end;


            trigger OnValidate()
            var
                TypeHelper: Codeunit "Type Helper";
            begin
                // for i := 1 to StrLen("Phone No.") do
                //     if UpperCase("Phone No."[i]) in ['A' .. 'Z', 'Ä', 'Ö', 'Ü', 'ß', 'ẞ'] then
                //         FieldError("Phone No.", PhoneNoCannotContainLettersErr);
                if not TypeHelper.IsPhoneNumber("Phone No.") then
                    FieldError("Phone No.", PhoneNoCannotContainLettersErr);
            end;
        }
        field(30; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Contact No. field.';
            trigger OnValidate()
            var
                Contact: Record Contact;

            begin
                Contact.Get("Contact No.");

                if Name = '' then
                    Name := Contact.Name;

                if "E-Mail" = '' then
                    "E-Mail" := Contact."E-Mail";

                if "Phone No." = '' then
                    "Phone No." := Contact."Phone No.";

                if "Salesperson Code" = '' then
                    "Salesperson Code" := Contact."Salesperson Code";

                if "Language Code" = '' then
                    "Language Code" := Contact."Language Code";

            end;
        }
        field(31; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person),
                                            Blocked = const(false));
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Resource No. field.';
            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                Resource.Get("Resource No.");
                Resource.TestField(Blocked, false);
                if Name = '' then
                    Name := Resource.Name;
            end;
        }
        field(32; "Internal/External"; Enum "SMB Internal/External")
        {
            Caption = 'Internal/External';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Intern/Extern field.';
        }
        field(34; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Salesperson Code field.';
            trigger OnValidate()
            begin
                ValidateSalesPersonCode();
            end;
        }
        field(35; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Language Code field.';
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
            ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
            ToolTip = 'Specifies the value of the Global Dimension 2 Code field';

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            // end;
        }
    }
    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Name, "Internal/External") { }
        fieldgroup(Brick; Code, Name) { }
    }
    var
        PhoneNoCannotContainLettersErr: Label 'must not contain letters';

    local procedure ValidateEmail()
    var
        MailManagement: Codeunit "Mail Management";

    begin
        if "E-Mail" = '' then
            exit;
        MailManagement.CheckValidEmailAddresses("E-Mail");
    end;

    local procedure ValidateSalesPersonCode()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        if "Salesperson Code" <> '' then
            if SalespersonPurchaser.Get("Salesperson Code") then
                if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                    Error(SalespersonPurchaser.GetPrivacyBlockedGenericText(SalespersonPurchaser, true))
    end;
}