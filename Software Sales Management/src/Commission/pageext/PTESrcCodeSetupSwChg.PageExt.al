pageextension 63606 "PTE Src. Code Setup Sw. Chg." extends "Source Code Setup"
{
    layout
    {
        addlast(Content)
        {
            group(PTESoftwareSalesGroup)
            {
                Caption = 'Software Sales Management', Comment = 'de-DE=Software-Verkaufsmanagement';

                field("PTE Software Change"; Rec."PTE Software Change")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source code that is assigned to commission ledger entries that originate from a software change.', Comment = 'de-DE=Gibt den Herkunftscode an, der Provisionsposten aus einer Softwareanpassung zugewiesen wird.';
                }
            }
        }
    }
}
