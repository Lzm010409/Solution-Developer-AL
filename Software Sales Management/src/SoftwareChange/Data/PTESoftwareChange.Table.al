table 63610 "PTE Software Change"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Description;
    Caption = 'Software Change', Comment = 'de-DE=Softwareanpassung';
    LookupPageId = "PTE Software Change List";
    DrillDownPageId = "PTE Software Change List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', Comment = 'de-DE=Nr.';
            ToolTip = 'This is the No. of the Software Change.', Comment = 'de-DE=Dies ist die Nr. der Softwareanpassung.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'This is the Description of the Software Change.', Comment = 'de-DE=Dies ist die Beschreibung der Softwareanpassung.';
        }
        field(20; "Software Change Template Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Software Change Template";
            Caption = 'Software Change Template Code', Comment = 'de-DE=Softwareanpassung Vorlagecode';
            ToolTip = 'This is the Software Change Template Code of the Software Change. Selecting a template copies its values into the Software Change.', Comment = 'de-DE=Dies ist der Vorlagecode der Softwareanpassung. Die Auswahl einer Vorlage überträgt deren Werte in die Softwareanpassung.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.ApplyTemplate(Rec);
                CalcFields("Software Change Template Desc.");
            end;
        }
        field(21; "Software Change Template Desc."; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PTE Software Change Template".Description where("Code" = field("Software Change Template Code")));
            Editable = false;
            Caption = 'Software Change Template Description', Comment = 'de-DE=Softwareanpassung Vorlagebeschreibung';
            ToolTip = 'This is the description of the template the Software Change was created from.', Comment = 'de-DE=Dies ist die Beschreibung der Vorlage, aus der die Softwareanpassung erstellt wurde.';
        }
        field(30; "Entry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry Date', Comment = 'de-DE=Erfassungsdatum';
            ToolTip = 'This is the Entry Date of the Software Change.', Comment = 'de-DE=Dies ist das Erfassungsdatum der Softwareanpassung.';

            trigger OnValidate()
            var
                EntryDateErr: Label 'Entry Date cannot be after Closing Date.', Comment = 'de-DE=Erfassungsdatum darf nicht nach dem Abschlussdatum liegen.';
            begin
                if ("Closing Date" <> 0D) and ("Entry Date" > "Closing Date") then
                    Error(EntryDateErr);
            end;
        }
        field(40; "Closing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Closing Date', Comment = 'de-DE=Abschlussdatum';
            ToolTip = 'This is the Closing Date of the Software Change.', Comment = 'de-DE=Dies ist das Abschlussdatum der Softwareanpassung.';

            trigger OnValidate()
            var
                ClosingDateErr: Label 'Closing Date cannot be before Entry Date.', Comment = 'de-DE=Abschlussdatum darf nicht vor dem Erfassungsdatum liegen.';
            begin
                if ("Entry Date" <> 0D) and ("Closing Date" <> 0D) and ("Closing Date" < "Entry Date") then
                    Error(ClosingDateErr);
            end;
        }
        field(50; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
            ToolTip = 'This is the Salesperson Code of the Software Change.', Comment = 'de-DE=Dies ist der Verkäufercode der Softwareanpassung.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.CheckSalespersonNotPrivacyBlocked("Salesperson Code");
                CalcFields("Salesperson Name");
            end;
        }
        field(51; "Salesperson Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where("Code" = field("Salesperson Code")));
            Editable = false;
            Caption = 'Salesperson Name', Comment = 'de-DE=Verkäufername';
            ToolTip = 'This is the name of the salesperson assigned to the Software Change.', Comment = 'de-DE=Dies ist der Name des Verkäufers, der der Softwareanpassung zugewiesen ist.';
        }
        field(60; Status; Enum "PTE Software Change Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', Comment = 'de-DE=Status';
            ToolTip = 'This is the Status of the Software Change.', Comment = 'de-DE=Dies ist der Status der Softwareanpassung.';
        }
        field(70; "Contact No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Contact;
            Caption = 'Contact No.', Comment = 'de-DE=Kontaktnr.';
            ToolTip = 'This is the Contact No. of the Software Change.', Comment = 'de-DE=Dies ist die Kontaktnr. der Softwareanpassung.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.UpdateContactDetails(Rec);
            end;
        }
        field(71; "Contact Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Name', Comment = 'de-DE=Kontaktname';
            ToolTip = 'This is the Contact Name of the Software Change.', Comment = 'de-DE=Dies ist der Kontaktname der Softwareanpassung.';
        }
        field(72; "Contact Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Caption = 'Contact Phone No.', Comment = 'de-DE=Kontakt Telefonnr.';
            ToolTip = 'This is the Contact Phone No. of the Software Change.', Comment = 'de-DE=Dies ist die Telefonnr. des Kontakts der Softwareanpassung.';
        }
        field(73; "Contact E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            Caption = 'Contact E-Mail', Comment = 'de-DE=Kontakt E-Mail';
            ToolTip = 'This is the Contact E-Mail of the Software Change.', Comment = 'de-DE=Dies ist die E-Mail des Kontakts der Softwareanpassung.';
        }
        field(80; Priority; Integer)
        {
            DataClassification = CustomerContent;
            MinValue = 0;
            Caption = 'Priority', Comment = 'de-DE=Priorität';
            ToolTip = 'This is the Priority of the Software Change.', Comment = 'de-DE=Dies ist die Priorität der Softwareanpassung.';
        }
        field(90; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Editable = false;
            Caption = 'No. Series', Comment = 'de-DE=Nummernkreis';
            ToolTip = 'This is the No. Series of the Software Change.', Comment = 'de-DE=Dies ist der Nummernkreis der Softwareanpassung.';
        }
        field(100; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.', Comment = 'de-DE=Debitorennr.';
            ToolTip = 'This is the Customer No. of the Software Change.', Comment = 'de-DE=Dies ist die Debitorennr. der Softwareanpassung.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.UpdateCustomerDetails(Rec);
                CalcFields("Customer Name");
            end;
        }
        field(101; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
            Caption = 'Customer Name', Comment = 'de-DE=Debitorenname';
            ToolTip = 'This is the name of the customer of the Software Change.', Comment = 'de-DE=Dies ist der Name des Debitors der Softwareanpassung.';
        }
        field(102; "Gen. Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
            Caption = 'Gen. Bus. Posting Group', Comment = 'de-DE=Geschäftsbuchungsgruppe';
            ToolTip = 'This is the Gen. Bus. Posting Group of the Software Change.', Comment = 'de-DE=Dies ist die Geschäftsbuchungsgruppe der Softwareanpassung.';
        }
        field(103; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
            Caption = 'VAT Bus. Posting Group', Comment = 'de-DE=MwSt.-Geschäftsbuchungsgruppe';
            ToolTip = 'This is the VAT Bus. Posting Group of the Software Change.', Comment = 'de-DE=Dies ist die MwSt.-Geschäftsbuchungsgruppe der Softwareanpassung.';
        }
        field(110; "Accounting Type"; Enum "PTE Accounting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Accounting Type', Comment = 'de-DE=Abrechnungsart';
            ToolTip = 'This is the Accounting Type of the Software Change. It controls whether the commission is taken from the commission contract or from this Software Change.', Comment = 'de-DE=Dies ist die Abrechnungsart der Softwareanpassung. Sie steuert, ob die Provision aus dem Provisionsvertrag oder aus dieser Softwareanpassung ermittelt wird.';
        }
        field(120; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provision Prozentsatz';
            ToolTip = 'This is the Commission Percentage of the Software Change. It is only used when the Accounting Type is Software Change.', Comment = 'de-DE=Dies ist der Provisions Prozentsatz der Softwareanpassung. Er wird nur verwendet, wenn die Abrechnungsart Software Change ist.';
        }
        field(130; "Developer Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource;
            Caption = 'Developer Resource No.', Comment = 'de-DE=Entwickler Ressourcennr.';
            ToolTip = 'This is the Developer Resource No. of the Software Change.', Comment = 'de-DE=Dies ist die Entwickler Ressourcennr. der Softwareanpassung.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.CheckResourceNotPrivacyBlocked("Developer Resource No.");
                CalcFields("Developer Resource Name");
            end;
        }
        field(131; "Developer Resource Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Developer Resource No.")));
            Editable = false;
            Caption = 'Developer Resource Name', Comment = 'de-DE=Entwickler Ressourcenname';
            ToolTip = 'This is the name of the developer resource of the Software Change.', Comment = 'de-DE=Dies ist der Name der Entwickler-Ressource der Softwareanpassung.';
        }
        field(150; "Quantity Implementation (hrs)"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            Caption = 'Quantity Implementation (hrs)', Comment = 'de-DE=Dauer Umsetzung (Std)';
            ToolTip = 'This is the implementation duration of the Software Change in hours. It is invoiced as the quantity of the resource line.', Comment = 'de-DE=Dies ist die Umsetzungsdauer der Softwareanpassung in Stunden. Sie wird als Menge der Ressourcenzeile fakturiert.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key01; "Salesperson Code", Status)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Customer No.")
        {
        }
    }

    trigger OnInsert()
    var
        Setup: Record "PTE Software Sales Mgt. Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            Setup.Get('');
            Setup.TestField("Software Change Nos.");
            "No. Series" := Setup."Software Change Nos.";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        if "Entry Date" = 0D then
            "Entry Date" := WorkDate();
    end;

    trigger OnDelete()
    var
        SoftwareChange: Codeunit "PTE Software Change";
    begin
        SoftwareChange.DeleteComments("No.");
    end;

    /// <summary>
    /// Lets the user pick a related number series and draws the next number from it. Returns
    /// false when the user leaves the selection without choosing.
    /// </summary>
    procedure AssistEditNoSeries(OldSoftwareChange: Record "PTE Software Change"): Boolean
    var
        Setup: Record "PTE Software Sales Mgt. Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('');
        Setup.TestField("Software Change Nos.");
        if not NoSeries.LookupRelatedNoSeries(Setup."Software Change Nos.", OldSoftwareChange."No. Series", "No. Series") then
            exit(false);

        "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        exit(true);
    end;

    procedure ShowComments()
    var
        SoftwareChange: Codeunit "PTE Software Change";
    begin
        SoftwareChange.ShowComments("Comment Line Table Name"::"PTE Software Change", "No.");
    end;
}
