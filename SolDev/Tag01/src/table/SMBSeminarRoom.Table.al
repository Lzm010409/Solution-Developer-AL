table 123456702 "SMB Seminar Room"
{
    DataClassification = CustomerContent;
    Caption = 'Seminar Room';
    DataCaptionFields = Code, Name;
    LookupPageId = "SMB Seminar Room List";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = Customercontent;
            Caption = 'Code';
            NotBlank = true;
            ToolTip = 'Specifies the value of the Code field.';
        }
        field(2; Name; Text[100])
        {
            DataClassification = Customercontent;
            Caption = 'Name';
            ToolTip = 'Specifies the value of the Name field.';
        }
        field(4; "Name 2"; Text[50])
        {
            DataClassification = Customercontent;
            Caption = 'Name 2';
            ToolTip = 'Specifies the value of the Name 2 field.';
        }
        field(5; Address; Text[100])
        {
            DataClassification = Customercontent;
            Caption = 'Address';
            ToolTip = 'Specifies the value of the Address field.';
        }
        field(6; "Address 2"; Text[50])
        {
            DataClassification = Customercontent;
            Caption = 'Address 2';
            ToolTip = 'Specifies the value of the Address 2 field.';
        }
        field(7; City; Text[30])
        {
            DataClassification = Customercontent;
            Caption = 'City';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code".City
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the value of the City field.';
            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;

            trigger OnLookup()
            var
                City2: Text;
                County2: Text;
            begin
                City2 := City;
                County2 := County;

                PostCode.LookupPostCode(City2, "Post Code", County2, "Country/Region Code");

                City := CopyStr(City2, 1, MaxStrLen(City));
                County := CopyStr(County2, 1, MaxStrLen(County));
                // Müsste auch noch für County gemacht werden
                // Oder "suppressWarnings": ['AA0139']
            end;
        }


        field(8; Contact; Text[50])

        {
            DataClassification = Customercontent;
            Caption = 'Contact';
            ToolTip = 'Specifies the value of the Contact field.';
        }
        field(9; "Phone No."; Text[30])

        {
            DataClassification = Customercontent;
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
                i: Integer;

            begin
                for i := 1 to StrLen("Phone No.") do
                    if UpperCase("Phone No."[i]) in ['A' .. 'Z', 'Ä', 'Ö', 'Ü', 'ß', 'ẞ'] then
                        FieldError("Phone No.", PhoneNoCannotContainLettersErr);
            end;
        }
        field(10; "Telex No."; Text[20])

        {
            DataClassification = Customercontent;
            Caption = 'Telex No.';
        }
        field(11; "Country/Region Code"; Code[10])
        {
            DataClassification = Customercontent;
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
            ToolTip = 'Specifies the value of the Country/Region Code field.';
            trigger OnValidate()
            begin
                PostCode.CheckClearPostCodeCityCounty(City, "Post Code", County, "Country/Region Code", xRec."Country/Region Code");
            end;
        }
        field(12; "Fax No."; Text[30])
        {
            DataClassification = Customercontent;
            Caption = 'Fax No.';
            ToolTip = 'Specifies the value of the Fax No. field.';
        }
        field(13; "Telex Answer Back"; Text[20])
        {
            DataClassification = Customercontent;
            Caption = 'Telex Answer Back';
        }
        field(14; "Post Code"; Code[20])
        {
            DataClassification = Customercontent;
            Caption = 'Post Code';
            TableRelation = if ("Country/Region Code" = const('')) "Post Code"
            else
            if ("Country/Region Code" = filter(<> '')) "Post Code" where("Country/Region Code" = field("Country/Region Code"));
            ValidateTableRelation = false;
            ToolTip = 'Specifies the value of the Post Code field.';
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;

            trigger OnLookup()
            var
                CityTxt: Text;
            begin
                CityTxt := City;
                PostCode.LookupPostCode(CityTxt, "Post Code", County, "Country/Region Code");

                City := CopyStr(CityTxt,0,MaxStrLen(City));
            end;
        }
        field(15; County; Text[30])
        {
            DataClassification = Customercontent;
            Caption = 'County';
            CaptionClass = '5,1,' + "Country/Region Code";

        }
        field(16; "E-Mail"; Text[80])
        {
            DataClassification = Customercontent;
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
            ToolTip = 'Specifies the value of the E-Mail field.';
            trigger OnValidate()
            begin
                ValidateEmail();
            end;
        }
        field(17; "Home Page"; Text[80])

        {
            DataClassification = Customercontent;
            Caption = 'Home Page';
            ExtendedDatatype = URL;
            ToolTip = 'Specifies the value of the Home Page field.';
        }

        field(26; "Salesperson Code"; Code[20])
        {
            DataClassification = Customercontent;
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
            ToolTip = 'Specifies the value of the Salesperson Code field.';
            trigger OnValidate()
            begin
                ValidateSalesPersonCode();
            end;
        }
        field(39; Blocked; Boolean)
        {
            DataClassification = Customercontent;
            Caption = 'Blocked';
            ToolTip = 'Specifies the value of the Blocked field.';
        }
        field(40; "Resource No."; Code[20])
        {
            DataClassification = Customercontent;
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Machine), Blocked = const(false));
            ToolTip = 'Specifies the value of the Resource No. field.';
            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if "Resource No." = '' then
                    exit;

                Resource.Get("Resource No.");
                Resource.TestField(Blocked, false);

                if Name = '' then
                    Name := Resource.Name;
            end;
        }
        field(41; "Internal/External"; Enum "SMB Internal/External")
        {
            DataClassification = CustomerContent;
            ToolTip = 'Specifies the value of the Internal/External field.';
        }
        field(42; "Max. Participants"; Integer)
        {
            DataClassification = Customercontent;
            Caption = 'Max. Participants';
            MinValue = 0;
            ToolTip = 'Specifies the value of the Max. Participants field.';
        }
        field(43; "Responsible Contact No."; Code[20])
        {
            DataClassification = Customercontent;
            Caption = 'Responsible Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the value of the Responsible Contact No. field.';
        }
        field(50; "Global Dimension 1 Code"; Code[20])
        {
            DataClassification = Customercontent;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            // trigger OnValidate()
            // begin
            //     ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            // end;
        }
        field(51; "Global Dimension 2 Code"; Code[20])

        {
            DataClassification = Customercontent;
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

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
        fieldgroup(DropDown; Code, Name, "Max. Participants", "Internal/External") { }
        fieldgroup(Brick; Code, Name) { }
    }


    var

        PostCode: Record "Post Code";
        PhoneNoCannotContainLettersErr: Label 'must not contain letters';

    procedure TestBlocked()

    begin
        TestField(Blocked, false);
    end;

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