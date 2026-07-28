table 63615 "PTE Posted Software Change"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Description;
    Caption = 'Posted Software Change', Comment = 'de-DE=Geb. Softwareanpassung';
    LookupPageId = "PTE Posted Softw. Change List";
    DrillDownPageId = "PTE Posted Softw. Change List";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', Comment = 'de-DE=Nr.';
            ToolTip = 'This is the No. of the Posted Software Change.', Comment = 'de-DE=Dies ist die Nr. der gebuchten Softwareanpassung.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'This is the Description of the Posted Software Change.', Comment = 'de-DE=Dies ist die Beschreibung der gebuchten Softwareanpassung.';
        }
        field(20; "Software Change Template Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Software Change Template";
            Caption = 'Software Change Template Code', Comment = 'de-DE=Softwareanpassung Vorlagecode';
            ToolTip = 'This is the Software Change Template Code of the Posted Software Change.', Comment = 'de-DE=Dies ist der Vorlagecode der gebuchten Softwareanpassung.';
        }
        field(21; "Software Change Template Desc."; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PTE Software Change Template".Description where("Code" = field("Software Change Template Code")));
            Editable = false;
            Caption = 'Software Change Template Description', Comment = 'de-DE=Softwareanpassung Vorlagebeschreibung';
            ToolTip = 'This is the description of the template the Posted Software Change was created from.', Comment = 'de-DE=Dies ist die Beschreibung der Vorlage, aus der die gebuchte Softwareanpassung erstellt wurde.';
        }
        field(30; "Entry Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry Date', Comment = 'de-DE=Erfassungsdatum';
            ToolTip = 'This is the Entry Date of the Posted Software Change.', Comment = 'de-DE=Dies ist das Erfassungsdatum der gebuchten Softwareanpassung.';
        }
        field(40; "Closing Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Closing Date', Comment = 'de-DE=Abschlussdatum';
            ToolTip = 'This is the Closing Date of the Posted Software Change.', Comment = 'de-DE=Dies ist das Abschlussdatum der gebuchten Softwareanpassung.';
        }
        field(50; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
            ToolTip = 'This is the Salesperson Code of the Posted Software Change.', Comment = 'de-DE=Dies ist der Verkäufercode der gebuchten Softwareanpassung.';
        }
        field(51; "Salesperson Name"; Text[50])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Salesperson/Purchaser".Name where("Code" = field("Salesperson Code")));
            Editable = false;
            Caption = 'Salesperson Name', Comment = 'de-DE=Verkäufername';
            ToolTip = 'This is the name of the salesperson assigned to the Posted Software Change.', Comment = 'de-DE=Dies ist der Name des Verkäufers, der der gebuchten Softwareanpassung zugewiesen ist.';
        }
        field(60; Status; Enum "PTE Software Change Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', Comment = 'de-DE=Status';
            ToolTip = 'This is the Status of the Posted Software Change.', Comment = 'de-DE=Dies ist der Status der gebuchten Softwareanpassung.';
        }
        field(70; "Contact No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Contact;
            Caption = 'Contact No.', Comment = 'de-DE=Kontaktnr.';
            ToolTip = 'This is the Contact No. of the Posted Software Change.', Comment = 'de-DE=Dies ist die Kontaktnr. der gebuchten Softwareanpassung.';
        }
        field(71; "Contact Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Contact Name', Comment = 'de-DE=Kontaktname';
            ToolTip = 'This is the Contact Name of the Posted Software Change.', Comment = 'de-DE=Dies ist der Kontaktname der gebuchten Softwareanpassung.';
        }
        field(72; "Contact Phone No."; Text[30])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Caption = 'Contact Phone No.', Comment = 'de-DE=Kontakt Telefonnr.';
            ToolTip = 'This is the Contact Phone No. of the Posted Software Change.', Comment = 'de-DE=Dies ist die Telefonnr. des Kontakts der gebuchten Softwareanpassung.';
        }
        field(73; "Contact E-Mail"; Text[80])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            Caption = 'Contact E-Mail', Comment = 'de-DE=Kontakt E-Mail';
            ToolTip = 'This is the Contact E-Mail of the Posted Software Change.', Comment = 'de-DE=Dies ist die E-Mail des Kontakts der gebuchten Softwareanpassung.';
        }
        field(80; Priority; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Priority', Comment = 'de-DE=Priorität';
            ToolTip = 'This is the Priority of the Posted Software Change.', Comment = 'de-DE=Dies ist die Priorität der gebuchten Softwareanpassung.';
        }
        field(90; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Editable = false;
            Caption = 'No. Series', Comment = 'de-DE=Nummernkreis';
            ToolTip = 'This is the No. Series of the Posted Software Change.', Comment = 'de-DE=Dies ist der Nummernkreis der gebuchten Softwareanpassung.';
        }
        field(100; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.', Comment = 'de-DE=Debitorennr.';
            ToolTip = 'This is the Customer No. of the Posted Software Change.', Comment = 'de-DE=Dies ist die Debitorennr. der gebuchten Softwareanpassung.';
        }
        field(101; "Customer Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Editable = false;
            Caption = 'Customer Name', Comment = 'de-DE=Debitorenname';
            ToolTip = 'This is the name of the customer of the Posted Software Change.', Comment = 'de-DE=Dies ist der Name des Debitors der gebuchten Softwareanpassung.';
        }
        field(102; "Gen. Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
            Caption = 'Gen. Bus. Posting Group', Comment = 'de-DE=Geschäftsbuchungsgruppe';
            ToolTip = 'This is the Gen. Bus. Posting Group of the Posted Software Change.', Comment = 'de-DE=Dies ist die Geschäftsbuchungsgruppe der gebuchten Softwareanpassung.';
        }
        field(103; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
            Caption = 'VAT Bus. Posting Group', Comment = 'de-DE=MwSt.-Geschäftsbuchungsgruppe';
            ToolTip = 'This is the VAT Bus. Posting Group of the Posted Software Change.', Comment = 'de-DE=Dies ist die MwSt.-Geschäftsbuchungsgruppe der gebuchten Softwareanpassung.';
        }
        field(110; "Accounting Type"; Enum "PTE Accounting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Accounting Type', Comment = 'de-DE=Abrechnungsart';
            ToolTip = 'This is the Accounting Type that was used when the Posted Software Change was posted.', Comment = 'de-DE=Dies ist die Abrechnungsart, die beim Buchen der gebuchten Softwareanpassung verwendet wurde.';
        }
        field(120; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provision Prozentsatz';
            ToolTip = 'This is the Commission Percentage that was used when the Posted Software Change was posted.', Comment = 'de-DE=Dies ist der Provisions Prozentsatz, der beim Buchen der gebuchten Softwareanpassung verwendet wurde.';
        }
        field(130; "Developer Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource;
            Caption = 'Developer Resource No.', Comment = 'de-DE=Entwickler Ressourcennr.';
            ToolTip = 'This is the Developer Resource No. of the Posted Software Change.', Comment = 'de-DE=Dies ist die Entwickler Ressourcennr. der gebuchten Softwareanpassung.';
        }
        field(131; "Developer Resource Name"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Resource.Name where("No." = field("Developer Resource No.")));
            Editable = false;
            Caption = 'Developer Resource Name', Comment = 'de-DE=Entwickler Ressourcenname';
            ToolTip = 'This is the name of the developer resource of the Posted Software Change.', Comment = 'de-DE=Dies ist der Name der Entwickler-Ressource der gebuchten Softwareanpassung.';
        }
        field(150; "Quantity Implementation (hrs)"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Caption = 'Quantity Implementation (hrs)', Comment = 'de-DE=Dauer Umsetzung (Std)';
            ToolTip = 'This is the implementation duration of the Posted Software Change in hours.', Comment = 'de-DE=Dies ist die Umsetzungsdauer der gebuchten Softwareanpassung in Stunden.';
        }
        field(160; "Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Software Change No.', Comment = 'de-DE=Softwareanpassungsnr.';
            ToolTip = 'This is the number of the original Software Change that was deleted when this document was posted.', Comment = 'de-DE=Dies ist die Nummer der ursprünglichen Softwareanpassung, die beim Buchen dieses Belegs gelöscht wurde.';
        }
        field(170; "Sales Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Header";
            Editable = false;
            Caption = 'Sales Invoice No.', Comment = 'de-DE=Verkaufsrechnungsnr.';
            ToolTip = 'This is the number of the posted sales invoice that was created when this document was posted.', Comment = 'de-DE=Dies ist die Nummer der gebuchten Verkaufsrechnung, die beim Buchen dieses Belegs erstellt wurde.';
        }
        field(180; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Posting Date', Comment = 'de-DE=Buchungsdatum';
            ToolTip = 'This is the Posting Date of the Posted Software Change.', Comment = 'de-DE=Dies ist das Buchungsdatum der gebuchten Softwareanpassung.';
        }
        field(190; "User ID"; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            Editable = false;
            Caption = 'User ID', Comment = 'de-DE=Benutzer-ID';
            ToolTip = 'This is the ID of the user who posted the Software Change.', Comment = 'de-DE=Dies ist die ID des Benutzers, der die Softwareanpassung gebucht hat.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(Key01; "Software Change No.")
        {
        }
        key(Key02; "Salesperson Code", "Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description, "Customer No.")
        {
        }
    }

    trigger OnDelete()
    var
        SoftwareChange: Codeunit "PTE Software Change";
    begin
        SoftwareChange.DeletePostedComments("No.");
    end;

    procedure ShowComments()
    var
        SoftwareChange: Codeunit "PTE Software Change";
    begin
        SoftwareChange.ShowComments("Comment Line Table Name"::"PTE Posted Software Change", "No.");
    end;

    /// <summary>
    /// Opens the standard search for all entries and documents that were created when this
    /// document was posted.
    /// </summary>
    procedure ShowEntries()
    var
        Navigate: Page Navigate;
    begin
        TestField("Sales Invoice No.");
        Navigate.SetDoc("Posting Date", "Sales Invoice No.");
        Navigate.Run();
    end;
}
