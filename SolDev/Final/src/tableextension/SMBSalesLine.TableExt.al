tableextension 123456701 "SMB Sales Line" extends "Sales Line"
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