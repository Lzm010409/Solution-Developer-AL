page 63025 "PTE Commission Ledger Entries"
{
    ApplicationArea = All;
    Caption = 'Commission Ledger Entries', Comment = 'de-DE=Provisionsposten';
    Editable = false;
    PageType = List;
    SourceTable = "PTE Commission Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the Entry No. of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Postennr. des Provisionspostens an.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the Posting Date of the Commission Ledger Entry.', Comment = 'de-DE=Gibt das Buchungsdatum des Provisionspostens an.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the Document Type of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Belegart des Provisionspostens an.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the Document No. of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Belegnr. des Provisionspostens an.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the Customer No. of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Kundennr. des Provisionspostens an.';
                }
                field(Amount; Rec."Amount")
                {
                    ToolTip = 'Specifies the Amount of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Betrag des Provisionspostens an.';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ToolTip = 'Specifies the Amount (LCY) of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Betrag (Lokalwährung) des Provisionspostens an.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ToolTip = 'Specifies the Salesperson Code of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Verkäufercode des Provisionspostens an.';
                }
                field("Commission Contract No."; Rec."Commission Contract No.")
                {
                    ToolTip = 'Specifies the Commission Contract No. of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Provisionsvertragsnr. des Provisionspostens an.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ToolTip = 'Specifies the Posting Description of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Buchungsbeschreibung des Provisionspostens an.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the Currency Code of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Währungscode des Provisionspostens an.';
                }
                field("Commission Percentage"; Rec."Commission Percentage")
                {
                    ToolTip = 'Specifies the Commission Percentage of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Provisionsprozentsatz des Provisionspostens an.';
                }
                field("Commission Amount (LCY)"; Rec."Commission Amount (LCY)")
                {
                    ToolTip = 'Specifies the Commission Amount (LCY) of the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Provisionsbetrag (Lokalwährung) des Provisionspostens an.';
                }
                field("Commission Type"; Rec."Commission Type")
                {
                    ToolTip = 'Specifies the Commission Type of the Commission Ledger Entry.', Comment = 'de-DE=Gibt die Provisionsart des Provisionspostens an.';
                }
                field("Source Code"; Rec."Source Code")
                {
                    ToolTip = 'Specifies the process that created the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Vorgang an, der den Provisionsposten erzeugt hat.';
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ToolTip = 'Specifies the reason the Commission Ledger Entry was posted for.', Comment = 'de-DE=Gibt die Ursache an, aus der der Provisionsposten gebucht wurde.';
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the user who posted the Commission Ledger Entry.', Comment = 'de-DE=Gibt den Benutzer an, der den Provisionsposten gebucht hat.';
                }
            }
        }
    }
}
