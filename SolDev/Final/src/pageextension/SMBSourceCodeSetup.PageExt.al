pageextension 123456700 "SMB Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        addlast(Content)
        {
            group("SMB Seminar Group")
            {
                Caption = 'Seminar';
                field("SMB Seminar"; Rec."SMB Seminar")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}