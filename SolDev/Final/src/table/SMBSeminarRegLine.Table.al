table 123456711 "SMB Seminar Reg. Line"
{
    Caption = 'Seminar Registration Line';
    DataCaptionFields = "Document No.", "Participant Name";
    DrillDownPageId = "SMB Seminar Reg. Line List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "SMB Seminar Reg. Header";
            ToolTip = 'Specifies the value of the Document No. field.', Comment = '%';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            ToolTip = 'Specifies the value of the Line No. field.', Comment = '%';
        }
        field(3; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer where(Blocked = const("Customer Blocked"::" "));
            ToolTip = 'Specifies the value of the Bill-to Customer No. field.', Comment = '%';
            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                // Das Feld Bill to Cust. No. ist das führende Feld, welches die Zeile initialisiert

                // Passt der Status zum auswählen
                TestStatusOpen();
                TestField("Participant Contact No.", '');

                // Daten vom Debitor in die Zeile
                Customer.Get("Bill-to Customer No.");
                Customer.TestField(Blocked, Customer.Blocked::" ");
                // Füllen der Felder vom Debitor
                Customer.TestField("Gen. Bus. Posting Group");
                "Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
                Customer.TestField("VAT Bus. Posting Group");
                "VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
                Validate("Currency Code", Customer."Currency Code");

                // Zeile initialisieren
                // Kopf holen und Felder übernehmen
                GetSemRegHeader();
                SMBSeminarRegHeader.TestField("Seminar No.");
                Validate("Seminar Price (LCY)", SMBSeminarRegHeader."Seminar Price");
                "Registration Date" := WorkDate();

            end;
        }
        field(4; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
            ToolTip = 'Specifies the value of the Participant Contact No. field.', Comment = '%';
            trigger OnLookup()
            var
                Contact: Record Contact;
                ContactBusinessRelation: Record "Contact Business Relation";
                SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
            begin
                // es sollen nur noch die Kontakte angezeigt werden, welche zum Debitor gehören
                TestField("Bill-to Customer No.");

                // ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
                // ContactBusinessRelation.SetRange("No.","Bill-to Customer No.");
                // if not ContactBusinessRelation.FindFirst() then
                //     Error('Es gibt keine Kontakte für diesen Debitor');

                if not ContactBusinessRelation.FindByRelation(
                    ContactBusinessRelation."Link to Table"::Customer,
                    "Bill-to Customer No.")
                then
                    Error(NoContactErr, Contact.TableCaption);

                SMBSeminarRegLine := Rec;
                Contact.FilterGroup(2);
                Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.");
                Contact.FilterGroup(0);
                Contact."No." := SMBSeminarRegLine."Participant Contact No.";
                Contact.SetCurrentKey(Name);

                if Page.RunModal(Page::"Contact List", Contact) = Action::LookupOK then begin
                    SMBSeminarRegLine.Validate("Participant Contact No.", Contact."No.");
                    Rec := SMBSeminarRegLine;
                end;

            end;

            trigger OnValidate()
            var
                SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
                Contact: Record Contact;
                ContactBusinessRelation: Record "Contact Business Relation";
            begin
                TestStatusOpen();
                TestField("Bill-to Customer No.");


                // gibt es den aktuell ausgewählten Kontakt schon in dieser Seminaranmeldung?
                SMBSeminarRegLine.SetRange("Document No.", "Document No.");
                SMBSeminarRegLine.SetRange("Participant Contact No.", "Participant Contact No.");
                SMBSeminarRegLine.SetFilter("Line No.", '<>%1', "Line No.");
                if not SMBSeminarRegLine.IsEmpty then
                    Error(ParticipantRegisteredErr, FieldCaption("Participant Contact No."));

                // passt der Kontakt zum Debitor?
                Contact.Get("Participant Contact No.");

                ContactBusinessRelation.SetRange("Link to Table", ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("Contact No.", Contact."Company No.");
                if not ContactBusinessRelation.FindFirst() then
                    Error(NoCompanyErr);

                if "Bill-to Customer No." <> ContactBusinessRelation."No." then
                    Error(WrongCustomerErr);

                CalcFields("Participant Name");
            end;
        }
        field(5; "Participant Name"; Text[100])
        {
            Caption = 'Participant Name';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = lookup(Contact.Name where("No." = field("Participant Contact No.")));
            ToolTip = 'Specifies the value of the Participant Name field.', Comment = '%';
        }
        field(6; "Registration Date"; Date)
        {
            Caption = 'Registration Date';
            Editable = false;
            ToolTip = 'Specifies the value of the Registration Date field.', Comment = '%';
        }
        field(7; "To Invoice"; Boolean)
        {
            Caption = 'To Invoice';
            InitValue = true;
            ToolTip = 'Specifies the value of the To Invoice field.', Comment = '%';
        }
        field(8; Participated; Boolean)
        {
            Caption = 'Participated';
            ToolTip = 'Specifies the value of the Participated field.', Comment = '%';
        }
        field(9; "Confirmation Date"; Date)
        {
            Caption = 'Confirmation Date';
            Editable = false;
            ToolTip = 'Specifies the value of the Confirmation Date field.', Comment = '%';
        }
        field(10; "Seminar Price (LCY)"; Decimal)
        {
            Caption = 'Seminar Price (LCY)';
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Seminar Price (LCY) field.', Comment = '%';
            trigger OnValidate()
            begin
                TestStatusOpen();
                Validate("Line Discount %");
            end;

        }
        field(11; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            ToolTip = 'Specifies the value of the Line Discount % field.', Comment = '%';
            trigger OnValidate()
            begin
                ValidateLineDiscountPercent();
            end;
        }
        field(12; "Line Discount Amount (LCY)"; Decimal)
        {
            Caption = 'Line Discount Amount (LCY)';
            AutoFormatType = 1;
            ToolTip = 'Specifies the value of the Line Discount Amount (LCY) field.', Comment = '%';
            trigger OnValidate()
            begin

                "Line Discount Amount (LCY)" := Round("Line Discount Amount (LCY)");
                TestStatusOpen();
                if xRec."Line Discount Amount (LCY)" <> "Line Discount Amount (LCY)" then
                    UpdateLineDiscPct();

                UpdateAmounts();

            end;
        }
        field(13; "Line Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
            ToolTip = 'Specifies the value of the Amount (LCY) field.', Comment = '%';
            trigger OnValidate()
            var
                MaxLineAmount: Decimal;
            begin
                TestField("Seminar Price (LCY)");
                MaxLineAmount := "Seminar Price (LCY)" - "Line Amount (LCY)";

                // CheckLineAmount(MaxLineAmount);

                Validate("Line Discount Amount (LCY)", MaxLineAmount);

            end;
        }
        field(14; Registered; Boolean)
        {
            Caption = 'Registered';
            ToolTip = 'Specifies the value of the Registered field.', Comment = '%';
            // TODO Editable = false;
        }
        field(15; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";


        }
        field(16; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(17; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
            trigger OnValidate()
            begin
                UpdateCurrencyFactor();
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

        }
        field(19; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
            AutoFormatType = 1;
            AutoFormatExpression = "Currency Code";
            ToolTip = 'Specifies the value of the Line Amount field.', Comment = '%';
            trigger OnValidate()
            begin
                if "Currency Code" <> '' then
                    Validate("Line Amount (LCY)",
                      Round(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          GetDate(), "Currency Code",
                          "Line Amount", "Currency Factor")))
                else
                    Validate("Line Amount (LCY)", "Line Amount");
            end;
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
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
    begin
        TestStatusOpen();

        SMBSeminarCommentLine.SetRange("Document Type", SMBSeminarCommentLine."Document Type"::"Seminar Registration");
        SMBSeminarCommentLine.SetRange("No.", "Document No.");
        SMBSeminarCommentLine.SetRange("Document Line No.", "Line No.");
        SMBSeminarCommentLine.DeleteAll();

    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
        NoContactErr: Label 'There are no related %1', Comment = '%1';
        ParticipantRegisteredErr: Label '%1 is already registered.', Comment = '%1';
        NoCompanyErr: Label 'There is no related Company';
        WrongCustomerErr: Label 'Wrong Customer';
        LineDiscountPctErr: Label 'The value in the Line Discount % field must be between 0 and 100.';
        // LineAmountInvalidErr: Label 'You have set the line amount to a value that results in a discount that is not valid. Consider increasing the unit price instead.';

    procedure ShowLineComments()
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        SMBSeminarCommentSheet: Page "SMB Seminar Comment Sheet";
    begin
        TestField("Document No.");
        TestField("Line No.");
        SMBSeminarCommentLine.SetRange("Document Type", SMBSeminarCommentLine."Document Type"::"Seminar Registration");
        SMBSeminarCommentLine.SetRange("No.", "Document No.");
        SMBSeminarCommentLine.SetRange("Document Line No.", "Line No.");
        SMBSeminarCommentSheet.SetTableView(SMBSeminarCommentLine);
        SMBSeminarCommentSheet.RunModal();
    end;

    local procedure TestStatusOpen()
    begin
        TestField(Registered, false);
        GetSemRegHeader();
        SMBSeminarRegHeader.TestStatusOpen();
    end;

    procedure GetSemRegHeader()
    begin
        if "Document No." <> SMBSeminarRegHeader."No." then
            SMBSeminarRegHeader.Get("Document No.");
    end;

    local procedure UpdateAmounts()
    begin
        "Line Amount (LCY)" := Round("Seminar Price (LCY)" - "Line Discount Amount (LCY)");

        if "Currency Code" <> '' then begin
            Currency.Get("Currency Code");
            Currency.TestField("Amount Rounding Precision");
            "Line Amount" :=
              Round(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  GetDate(), "Currency Code",
                  "Line Amount (LCY)", "Currency Factor"),
                Currency."Amount Rounding Precision")
        end else
            "Line Amount" := "Line Amount (LCY)";
    end;

    local procedure GetDate(): Date
    begin
        GetSemRegHeader();
        if SMBSeminarRegHeader."Posting Date" <> 0D then
            exit(SMBSeminarRegHeader."Posting Date");
        exit(WorkDate());
    end;

    procedure ValidateLineDiscountPercent()
    begin
        TestStatusOpen();

        "Line Discount Amount (LCY)" :=
          Round(
            Round("Seminar Price (LCY)") *
            "Line Discount %" / 100);

        UpdateAmounts();
    end;

    local procedure UpdateLineDiscPct()
    var
        LineDiscountPct: Decimal;

        IsOutOfStandardDiscPctRange: Boolean;
    begin


        if Round("Seminar Price (LCY)") <> 0 then begin
            LineDiscountPct := Round(
                "Line Discount Amount (LCY)" / Round("Seminar Price (LCY)") * 100,
                0.00001);
            IsOutOfStandardDiscPctRange := not (LineDiscountPct in [0 .. 100]);
            if IsOutOfStandardDiscPctRange then
                Error(LineDiscountPctErr);
            "Line Discount %" := LineDiscountPct;
        end else
            "Line Discount %" := 0;


    end;

    // local procedure CheckLineAmount(MaxLineAmount: Decimal)
    // begin
    //     if "Seminar Price (LCY)" < 0 then
    //         if "Line Amount (LCY)" < MaxLineAmount then
    //             Error(LineAmountInvalidErr);

    //     if "Seminar Price (LCY)" > 0 then
    //         if "Line Amount (LCY)" > MaxLineAmount then
    //             Error(LineAmountInvalidErr);
    // end;

    procedure UpdateCurrencyFactor()
    var
        UpdateCurrencyExchangeRates: Codeunit "Update Currency Exchange Rates";
        CurrencyDate: Date;
    begin
        if "Currency Code" <> '' then begin
            GetSemRegHeader();
            if SMBSeminarRegHeader."Posting Date" <> 0D then
                CurrencyDate := SMBSeminarRegHeader."Posting Date"
            else
                CurrencyDate := WorkDate();

            if UpdateCurrencyExchangeRates.ExchangeRatesForCurrencyExist(CurrencyDate, "Currency Code") then
                "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code")
            else
                UpdateCurrencyExchangeRates.ShowMissingExchangeRatesNotification("Currency Code");
        end else
            "Currency Factor" := 0;
    end;

}