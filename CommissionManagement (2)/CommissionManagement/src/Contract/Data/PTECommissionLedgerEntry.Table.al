table 63022 "PTE Commission Ledger Entry"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.', Comment = 'de-DE=Belegnr.';
            ToolTip = 'This is the Entry No. of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Belegnr. des Provisionsbuchungseintrags.';
            NotBlank = true;
            Editable = false;
            AutoIncrement = true;
        }
        field(10; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date', Comment = 'de-DE=Buchungsdatum';
            ToolTip = 'This is the Posting Date of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist das Buchungsdatum des Provisionsbuchungseintrags.';
        }
        field(20; "Document Type"; Enum "PTE Com. Led. Ent. Doc. Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type', Comment = 'de-DE=Belegart';
            ToolTip = 'This is the Document Type of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Belegart des Provisionsbuchungseintrags.';
        }
        field(30; "Document No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.', Comment = 'de-DE=Belegnr.';
            ToolTip = 'This is the Document No. of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Belegnr. des Provisionsbuchungseintrags.';
        }
        field(40; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer;
            Caption = 'Customer No.', Comment = 'de-DE=Kundennr.';
            ToolTip = 'This is the Customer No. of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Kundennr. des Provisionsbuchungseintrags.';
        }
        field(50; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount', Comment = 'de-DE=Betrag';
            ToolTip = 'This is the Amount of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist der Betrag des Provisionsbuchungseintrags.';
        }
        field(60; "Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount (LCY)', Comment = 'de-DE=Betrag (Lokalwährung)';
            ToolTip = 'This is the Amount (LCY) of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist der Betrag (Lokalwährung) des Provisionsbuchungseintrags.';
        }
        field(70; "Salesperson Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Salesperson/Purchaser";
            Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
            ToolTip = 'This is the Salesperson Code of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist der Verkäufercode des Provisionsbuchungseintrags.';
        }
        field(80; "Commission Contract No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Commission Contract";
            Caption = 'Commission Contract No.', Comment = 'de-DE=Provisionsvertragsnr.';
            ToolTip = 'This is the Commission Contract No. of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Provisionsvertragsnr. des Provisionsbuchungseintrags.';
        }
        field(90; "Posting Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Description', Comment = 'de-DE=Buchungsbeschreibung';
            ToolTip = 'This is the Posting Description of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Buchungsbeschreibung des Provisionsbuchungseintrags.';
        }
        field(100; "Currency Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Currency;
            Caption = 'Currency Code', Comment = 'de-DE=Währungscode';
            ToolTip = 'This is the Currency Code of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist der Währungscode des Provisionsbuchungseintrags.';
        }
        field(110; "Commission Amount (LCY)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Amount (LCY)', Comment = 'de-DE=Provisionsbetrag (Lokalwährung)';
            ToolTip = 'This is the Commission Amount (LCY) of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist der Provisionsbetrag (Lokalwährung) des Provisionsbuchungseintrags.';
        }
        field(120; "Commission Type"; Enum "PTE Commission Payment Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
            ToolTip = 'This is the Commission Type of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Provisionsart des Provisionsbuchungseintrags.';
        }
        field(130; "Customer Ledger Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            TableRelation = "Cust. Ledger Entry";        
            Caption = 'Customer Ledger Entry No.', Comment = 'de-DE=Kundenbuchungsnr.';
            ToolTip = 'This is the Customer Ledger Entry No. of the Commission Ledger Entry.', Comment = 'de-DE=Dies ist die Kundenbuchungsnr. des Provisionsbuchungseintrags.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK1; "Salesperson Code")
        {
            SumIndexFields = "Commission Amount (LCY)";
        }
    }

}