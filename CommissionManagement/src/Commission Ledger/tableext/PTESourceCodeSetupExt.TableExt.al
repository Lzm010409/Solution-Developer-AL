tableextension 63001 "PTE Source Code Setup Ext" extends "Source Code Setup"
{
    fields
    {
        field(63000; "PTE Commission"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Source Code";
            Caption = 'Commission', Comment = 'de-DE=Provision';
            ToolTip = 'Specifies the source code that is assigned to commission ledger entries when they are posted.', Comment = 'de-DE=Gibt den Herkunftscode an, der Provisionsposten beim Buchen zugewiesen wird.';
        }
    }
}
