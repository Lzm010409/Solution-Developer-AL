codeunit 123456701 "SMB Seminar-Post (Yes/No)"
{
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        if not Rec.Find() then
            Error(DocumentErrorsMgt.GetNothingToPostErrorMsg());

        SMBSeminarRegHeader.Copy(Rec);
        Code(SMBSeminarRegHeader);
        Rec := SMBSeminarRegHeader;
    end;

    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        WantToPostQst: Label 'Do you want to post the %1?',Comment = '%1';

    local procedure "Code"(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        if not Confirm(WantToPostQst,true,SMBSeminarRegHeader.TableCaption) then
            exit;

        Codeunit.Run(Codeunit::"SMB Seminar-Post",SMBSeminarRegHeader);
    end;
}