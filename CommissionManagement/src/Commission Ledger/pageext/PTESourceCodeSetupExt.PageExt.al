pageextension 63003 "PTE Source Code Setup Ext" extends "Source Code Setup"
{
    layout
    {
        addlast(Content)
        {
            group(PTECommissionGroup)
            {
                Caption = 'Commission Management', Comment = 'de-DE=Provisionsmanagement';

                field("PTE Commission"; Rec."PTE Commission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code that is assigned to commission ledger entries when they are posted.', Comment = 'de-DE=Gibt den Herkunftscode an, der Provisionsposten beim Buchen zugewiesen wird.';
                }
            }
        }
    }
}
