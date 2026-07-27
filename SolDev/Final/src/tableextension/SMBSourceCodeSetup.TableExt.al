tableextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    fields
    {
#pragma warning disable PTE0002
        field(123456700; "SMB Seminar"; code[10])
#pragma warning restore PTE0002
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
            Caption = 'Seminar';
            ToolTip = 'Bla bla.';
        }
    }
}