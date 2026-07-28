codeunit 63631 "PTE Softw. Change-Post (Y/N)"
{
    TableNo = "PTE Software Change";

    trigger OnRun()
    var
        SoftwareChange: Record "PTE Software Change";
    begin
        if not Rec.Find() then
            Error(DocumentErrorsMgt.GetNothingToPostErrorMsg());

        SoftwareChange.Copy(Rec);
        "Code"(SoftwareChange);
        Rec := SoftwareChange;
    end;

    var
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        PostSoftwareChangeQst: Label 'The software change is invoiced as a posted sales invoice and is replaced by a posted software change.\\Do you want to continue?', Comment = 'de-DE=Die Softwareanpassung wird als gebuchte Verkaufsrechnung fakturiert und durch eine gebuchte Softwareanpassung ersetzt.\\Möchten Sie fortfahren?';
        CanceledByUserErr: Label 'Canceled by user.', Comment = 'de-DE=Benutzerabbruch.';
        PostedMsg: Label 'The software change has been posted as the posted software change %1.', Comment = 'de-DE=Die Softwareanpassung wurde als gebuchte Softwareanpassung %1 gebucht.';

    local procedure "Code"(var SoftwareChange: Record "PTE Software Change")
    var
        PostedSoftwareChange: Record "PTE Posted Software Change";
        SoftwareChangePost: Codeunit "PTE Software Change-Post";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if not ConfirmManagement.GetResponseOrDefault(PostSoftwareChangeQst, true) then
            Error(CanceledByUserErr);

        SoftwareChangePost.Run(SoftwareChange);
        SoftwareChangePost.GetPostedSoftwareChange(PostedSoftwareChange);

        ShowPostedMessage(PostedSoftwareChange);
    end;

    local procedure ShowPostedMessage(PostedSoftwareChange: Record "PTE Posted Software Change")
    begin
        if not GuiAllowed() then
            exit;

        Message(PostedMsg, PostedSoftwareChange."No.");
    end;
}
