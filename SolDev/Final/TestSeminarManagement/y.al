pageextension 80150 "test Role Center" extends "Test Role Center"
{
    layout
    {
        // Add changes to page layout here
    }
    
    actions
    {
        addlast(Processing)
        {
            action(Test)
            {
                ApplicationArea = All;
                RunObject = codeunit "TestRunner Seminar";
            }
        }
    }
    
    var
        myInt: Integer;
}