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
            ToolTip = 'This is the Journal Template Name of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Buch.-Blattvorlagenname der Provisions Buch.-Blattzeile.';
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Journal Batch Name', Comment = 'de-DE=Buch.-Blattname';
            ToolTip = 'This is the Journal Batch Name of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Buch.-Blattname der Provisions Buch.-Blattzeile.';
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', Comment = 'de-DE=Zeilennr.';
            ToolTip = 'This is the Line No. of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Zeilennr. der Provisions Buch.-Blattzeile.';
        }
        field(10; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', Comment = 'de-DE=Buchungsdatum';
            ToolTip = 'This is the Posting Date of the Commission Journal Line.', Comment = 'de-DE=Dies ist das Buchungsdatum der Provisions Buch.-Blattzeile.';

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(11; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date', Comment = 'de-DE=Belegdatum';
            ToolTip = 'This is the Document Date of the Commission Journal Line.', Comment = 'de-DE=Dies ist das Belegdatum der Provisions Buch.-Blattzeile.';
        }
        field(20; "Document Type"; Enum "PTE Com. Led. Ent. Doc. Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type', Comment = 'de-DE=Belegart';
            ToolTip = 'This is the Document Type of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Belegart der Provisions Buch.-Blattzeile.';
        }
        field(30; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', Comment = 'de-DE=Belegnr.';
            ToolTip = 'This is the Document No. of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Belegnr. der Provisions Buch.-Blattzeile.';
        }
        field(40; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.', Comment = 'de-DE=Kundennr.';
            ToolTip = 'This is the Customer No. of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Kundennr. der Provisions Buch.-Blattzeile.';
        }
        field(50; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Amount', Comment = 'de-DE=Betrag';
            ToolTip = 'This is the Amount of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Betrag der Provisions Buch.-Blattzeile.';
        }
        field(60; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Amount (LCY)', Comment = 'de-DE=Betrag (Lokalwährung)';
            ToolTip = 'This is the Amount (LCY) of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Betrag (Lokalwährung) der Provisions Buch.-Blattzeile.';
        }
        field(70; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
            ToolTip = 'This is the Salesperson Code of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Verkäufercode der Provisions Buch.-Blattzeile.';
        }
        field(80; "Commission Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Commission Contract";
            Caption = 'Commission Contract No.', Comment = 'de-DE=Provisionsvertragsnr.';
            ToolTip = 'This is the Commission Contract No. of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Provisionsvertragsnr. der Provisions Buch.-Blattzeile.';
        }
        field(90; "Posting Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Description', Comment = 'de-DE=Buchungsbeschreibung';
            ToolTip = 'This is the Posting Description of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Buchungsbeschreibung der Provisions Buch.-Blattzeile.';
        }
        field(100; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Caption = 'Currency Code', Comment = 'de-DE=Währungscode';
            ToolTip = 'This is the Currency Code of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Währungscode der Provisions Buch.-Blattzeile.';
        }
        field(110; "Commission Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            Caption = 'Commission Amount (LCY)', Comment = 'de-DE=Provisionsbetrag (Lokalwährung)';
            ToolTip = 'This is the Commission Amount (LCY) of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Provisionsbetrag (Lokalwährung) der Provisions Buch.-Blattzeile.';
        }
        field(111; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
            ToolTip = 'This is the Commission Percentage of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Provisions Prozentsatz der Provisions Buch.-Blattzeile.';
        }
        field(120; "Commission Type"; Enum "PTE Commission Payment Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
            ToolTip = 'This is the Commission Type of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Provisionsart der Provisions Buch.-Blattzeile.';
        }
        field(130; "Customer Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Cust. Ledger Entry";
            Caption = 'Customer Ledger Entry No.', Comment = 'de-DE=Kundenbuchungsnr.';
            ToolTip = 'This is the Customer Ledger Entry No. of the Commission Journal Line.', Comment = 'de-DE=Dies ist die Kundenbuchungsnr. der Provisions Buch.-Blattzeile.';
        }
        field(140; "Source Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            Caption = 'Source Code', Comment = 'de-DE=Herkunftscode';
            ToolTip = 'This is the Source Code of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Herkunftscode der Provisions Buch.-Blattzeile.';
        }
        field(150; "Reason Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Reason Code";
            Caption = 'Reason Code', Comment = 'de-DE=Ursachencode';
            ToolTip = 'This is the Reason Code of the Commission Journal Line.', Comment = 'de-DE=Dies ist der Ursachencode der Provisions Buch.-Blattzeile.';
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
