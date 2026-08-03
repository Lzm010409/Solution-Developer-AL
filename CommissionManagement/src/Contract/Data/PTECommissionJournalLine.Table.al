table 63023 "PTE Commission Journal Line"
{
    DataClassification = CustomerContent;
    Caption = 'Commission Journal Line', Comment = 'de-DE=Provisions Buch.-Blattzeile';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Template Name', Comment = 'de-DE=Buch.-Blattvorlagenname';
            ToolTip = 'Specifies the Journal Template Name of the Commission Journal Line.', Comment = 'de-DE=Gibt den Buch.-Blattvorlagenname der Provisions Buch.-Blattzeile an.';
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name', Comment = 'de-DE=Buch.-Blattname';
            ToolTip = 'Specifies the Journal Batch Name of the Commission Journal Line.', Comment = 'de-DE=Gibt den Buch.-Blattname der Provisions Buch.-Blattzeile an.';
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', Comment = 'de-DE=Zeilennr.';
            ToolTip = 'Specifies the Line No. of the Commission Journal Line.', Comment = 'de-DE=Gibt die Zeilennr. der Provisions Buch.-Blattzeile an.';
        }
        field(10; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', Comment = 'de-DE=Buchungsdatum';
            ToolTip = 'Specifies the Posting Date of the Commission Journal Line.', Comment = 'de-DE=Gibt das Buchungsdatum der Provisions Buch.-Blattzeile an.';

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(11; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date', Comment = 'de-DE=Belegdatum';
            ToolTip = 'Specifies the Document Date of the Commission Journal Line.', Comment = 'de-DE=Gibt das Belegdatum der Provisions Buch.-Blattzeile an.';
        }
        field(20; "Document Type"; Enum "PTE Com. Led. Ent. Doc. Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type', Comment = 'de-DE=Belegart';
            ToolTip = 'Specifies the Document Type of the Commission Journal Line.', Comment = 'de-DE=Gibt die Belegart der Provisions Buch.-Blattzeile an.';
        }
        field(30; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', Comment = 'de-DE=Belegnr.';
            ToolTip = 'Specifies the Document No. of the Commission Journal Line.', Comment = 'de-DE=Gibt die Belegnr. der Provisions Buch.-Blattzeile an.';
        }
        field(40; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.', Comment = 'de-DE=Kundennr.';
            ToolTip = 'Specifies the Customer No. of the Commission Journal Line.', Comment = 'de-DE=Gibt die Kundennr. der Provisions Buch.-Blattzeile an.';
        }
        field(50; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Amount', Comment = 'de-DE=Betrag';
            ToolTip = 'Specifies the Amount of the Commission Journal Line.', Comment = 'de-DE=Gibt den Betrag der Provisions Buch.-Blattzeile an.';
        }
        field(60; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Amount (LCY)', Comment = 'de-DE=Betrag (Lokalwährung)';
            ToolTip = 'Specifies the Amount (LCY) of the Commission Journal Line.', Comment = 'de-DE=Gibt den Betrag (Lokalwährung) der Provisions Buch.-Blattzeile an.';
        }
        field(70; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
            ToolTip = 'Specifies the Salesperson Code of the Commission Journal Line.', Comment = 'de-DE=Gibt den Verkäufercode der Provisions Buch.-Blattzeile an.';
        }
        field(80; "Commission Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Commission Contract";
            Caption = 'Commission Contract No.', Comment = 'de-DE=Provisionsvertragsnr.';
            ToolTip = 'Specifies the Commission Contract No. of the Commission Journal Line.', Comment = 'de-DE=Gibt die Provisionsvertragsnr. der Provisions Buch.-Blattzeile an.';
        }
        field(90; "Posting Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Description', Comment = 'de-DE=Buchungsbeschreibung';
            ToolTip = 'Specifies the Posting Description of the Commission Journal Line.', Comment = 'de-DE=Gibt die Buchungsbeschreibung der Provisions Buch.-Blattzeile an.';
        }
        field(100; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Caption = 'Currency Code', Comment = 'de-DE=Währungscode';
            ToolTip = 'Specifies the Currency Code of the Commission Journal Line.', Comment = 'de-DE=Gibt den Währungscode der Provisions Buch.-Blattzeile an.';
        }
        field(110; "Commission Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Commission Amount (LCY)', Comment = 'de-DE=Provisionsbetrag (Lokalwährung)';
            ToolTip = 'Specifies the Commission Amount (LCY) of the Commission Journal Line.', Comment = 'de-DE=Gibt den Provisionsbetrag (Lokalwährung) der Provisions Buch.-Blattzeile an.';
        }
        field(111; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
            ToolTip = 'Specifies the Commission Percentage of the Commission Journal Line.', Comment = 'de-DE=Gibt den Provisions Prozentsatz der Provisions Buch.-Blattzeile an.';
        }
        field(120; "Commission Type"; Enum "PTE Commission Payment Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
            ToolTip = 'Specifies the Commission Type of the Commission Journal Line.', Comment = 'de-DE=Gibt die Provisionsart der Provisions Buch.-Blattzeile an.';
        }
        field(130; "Customer Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Cust. Ledger Entry";
            Caption = 'Customer Ledger Entry No.', Comment = 'de-DE=Kundenbuchungsnr.';
            ToolTip = 'Specifies the Customer Ledger Entry No. of the Commission Journal Line.', Comment = 'de-DE=Gibt die Kundenbuchungsnr. der Provisions Buch.-Blattzeile an.';
        }
        field(140; "Source Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            Caption = 'Source Code', Comment = 'de-DE=Herkunftscode';
            ToolTip = 'Specifies the Source Code of the Commission Journal Line.', Comment = 'de-DE=Gibt den Herkunftscode der Provisions Buch.-Blattzeile an.';
        }
        field(150; "Reason Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
            Caption = 'Reason Code', Comment = 'de-DE=Ursachencode';
            ToolTip = 'Specifies the Reason Code of the Commission Journal Line.', Comment = 'de-DE=Gibt den Ursachencode der Provisions Buch.-Blattzeile an.';
        }
    }

    keys
    {
        key(PK; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(Key01; "Salesperson Code", "Posting Date")
        {
        }
    }

    procedure EmptyLine(): Boolean
    begin
        exit(("Salesperson Code" = '') and ("Amount (LCY)" = 0));
    end;


    procedure SetUpNewLine(SalespersonPurchaser: Record "Salesperson/Purchaser"; CustomerLedgerEntry: Record "Cust. Ledger Entry")
    begin
        Init();
        Validate("Posting Date", WorkDate());
        "Document Type" := MapDocumentType(CustomerLedgerEntry."Document Type");
        "Document No." := CustomerLedgerEntry."Document No.";
        "Customer No." := CustomerLedgerEntry."Customer No.";
        Amount := CustomerLedgerEntry."Amount (LCY)";
        "Amount (LCY)" := CustomerLedgerEntry."Amount (LCY)";
        "Salesperson Code" := SalespersonPurchaser.Code;
        "Commission Contract No." := SalespersonPurchaser."PTE Commission Contract No.";
        "Currency Code" := CustomerLedgerEntry."Currency Code";
        "Customer Ledger Entry No." := CustomerLedgerEntry."Entry No.";
        "Commission Type" := "PTE Commission Payment Type"::"Commission Payment";
    end;

    procedure MapDocumentType(GenJournalDocumentType: Enum "Gen. Journal Document Type"): Enum "PTE Com. Led. Ent. Doc. Type"
    begin
        if GenJournalDocumentType = "Gen. Journal Document Type"::Invoice then
            exit("PTE Com. Led. Ent. Doc. Type"::Invoice);
        exit("PTE Com. Led. Ent. Doc. Type"::"Credit Memo");
    end;
}
