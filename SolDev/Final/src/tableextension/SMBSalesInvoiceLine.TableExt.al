tableextension 123456702 "SMB Sales Invoice Line" extends "Sales Invoice Line"
{
    fields
    {
        field(123456700; "SMB Apply-to Seminar Entry"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Apply-to seminar Entry';
            TableRelation = "SMB Seminar Reg. Header";
        }
    }  
}