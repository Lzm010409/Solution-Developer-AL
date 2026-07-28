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
                    Caption = 'Entry No.', Comment = 'de-DE=Postennr.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Caption = 'Posting Date', Comment = 'de-DE=Belegdatum';
                }
                field("Document Type"; Rec."Document Type")
                {
                    Caption = 'Document Type', Comment = 'de-DE=Belegart';
                }
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Document No.', Comment = 'de-DE=Belegnr.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No.', Comment = 'de-DE=Kundennr.';
                }
                field(Amount; Rec."Amount")
                {
                    Caption = 'Amount', Comment = 'de-DE=Betrag';
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    Caption = 'Amount (LCY)', Comment = 'de-DE=Betrag (Lokalwährung)';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Caption = 'Salesperson Code', Comment = 'de-DE=Verkäufercode';
                }
                field("Commission Contract No."; Rec."Commission Contract No.")
                {
                    Caption = 'Commission Contract No.', Comment = 'de-DE=Provisionsvertragsnr.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    Caption = 'Posting Description', Comment = 'de-DE=Buchungsbeschreibung';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Caption = 'Currency Code', Comment = 'de-DE=Währungscode';
                }
                field("Commission Percentage"; Rec."Commission Percentage")
                {
                    Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
                }
                field("Commission Amount (LCY)"; Rec."Commission Amount (LCY)")
                {
                    Caption = 'Commission Amount (LCY)', Comment = 'de-DE=Provisionsbetrag (Lokalwährung)';
                }
                field("Commission Type"; Rec."Commission Type")
                {
                    Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
                }


            }
        }
    }
}