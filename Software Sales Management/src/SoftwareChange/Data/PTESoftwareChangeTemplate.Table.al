table 63601 "PTE Software Change Template"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "Code", Description;
    Caption = 'Software Change Template', Comment = 'de-DE=Softwareanpassungsvorlage';
    LookupPageId = "PTE Software Change Templates";
    DrillDownPageId = "PTE Software Change Templates";

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = CustomerContent;
            NotBlank = true;
            Caption = 'Code', Comment = 'de-DE=Code';
            ToolTip = 'Specifies the Code of the Software Change Template.', Comment = 'de-DE=Gibt den Code der Softwareanpassungsvorlage an.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'Specifies the Description of the Software Change Template.', Comment = 'de-DE=Gibt die Beschreibung der Softwareanpassungsvorlage an.';
        }
        field(20; "Accounting Type"; Enum "PTE Accounting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Accounting Type', Comment = 'de-DE=Abrechnungsart';
            ToolTip = 'Specifies the Accounting Type of the Software Change Template. It controls whether the commission is taken from the commission contract or from the software change.', Comment = 'de-DE=Gibt die Abrechnungsart der Softwareanpassungsvorlage. Sie steuert an, ob die Provision aus dem Provisionsvertrag oder aus der Softwareanpassung ermittelt wird.';
        }
        field(30; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provision Prozentsatz';
            ToolTip = 'Specifies the Commission Percentage of the Software Change Template.', Comment = 'de-DE=Gibt den Provisions Prozentsatz der Softwareanpassungsvorlage an.';
        }
        field(40; "Developer Resource No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Resource;
            Caption = 'Developer Resource No.', Comment = 'de-DE=Entwickler Ressourcennr.';
            ToolTip = 'Specifies the Developer Resource No. of the Software Change Template.', Comment = 'de-DE=Gibt die Entwickler Ressourcennr. der Softwareanpassungsvorlage an.';

            trigger OnValidate()
            var
                SoftwareChange: Codeunit "PTE Software Change";
            begin
                SoftwareChange.CheckResourceNotPrivacyBlocked("Developer Resource No.");
            end;
        }
        field(50; "Gen. Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
            Caption = 'Gen. Bus. Posting Group', Comment = 'de-DE=Geschäftsbuchungsgruppe';
            ToolTip = 'Specifies the Gen. Bus. Posting Group of the Software Change Template.', Comment = 'de-DE=Gibt die Geschäftsbuchungsgruppe der Softwareanpassungsvorlage an.';
        }
        field(60; "VAT Bus. Posting Group"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
            Caption = 'VAT Bus. Posting Group', Comment = 'de-DE=MwSt.-Geschäftsbuchungsgruppe';
            ToolTip = 'Specifies the VAT Bus. Posting Group of the Software Change Template.', Comment = 'de-DE=Gibt die MwSt.-Geschäftsbuchungsgruppe der Softwareanpassungsvorlage an.';
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}
