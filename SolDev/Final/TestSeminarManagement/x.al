codeunit 80152 "TestRunner Seminar"
{
    Subtype = TestRunner;
    TestIsolation = Disabled;
    
    trigger OnRun()
    begin
       Codeunit.Run(Codeunit::"SMT Test Seminar");
    end;
    
    var
        myInt: Integer;
}