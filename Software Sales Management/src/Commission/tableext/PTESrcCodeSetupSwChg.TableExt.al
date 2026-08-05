tableextension 63605 "PTE Src. Code Setup Sw. Chg." extends "Source Code Setup"
{
    fields
    {
        field(63600; "PTE Software Change"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            Caption = 'Software Change', Comment = 'de-DE=Softwareanpassung';
            ToolTip = 'Specifies the source code that is assigned to commission ledger entries that originate from a software change.', Comment = 'de-DE=Gibt den Herkunftscode an, der Provisionsposten aus einer Softwareanpassung zugewiesen wird.';
        }
    }
}
