codeunit 123456730 "SMB MySeminar Filter Token"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Filter Tokens", 'OnResolveTextFilterToken', '', true, true)]
    local procedure FilterMyAccounts(TextToken: Text; var TextFilter: Text; var Handled: Boolean)
    var
        SMBMySeminar: Record "SMB My Seminar";
        MaxCount: Integer;
        MyTokenTxt: Label 'MYSEMINAR', Comment = 'Must be uppercase';
    begin
        if StrLen(TextToken) < 3 then
            exit;

        if StrPos(UpperCase(MyTokenTxt), UpperCase(TextToken)) = 0 then
            exit;

       Handled := true;

        MaxCount := 20;
        SMBMySeminar.SetRange("User ID", UserId());

        if SMBMySeminar.FindSet() then begin
            MaxCount -= 1;
            TextFilter := SMBMySeminar."Seminar No.";

            if SMBMySeminar.Next() <> 0 then
                repeat
                    MaxCount -= 1;
                    TextFilter += '|' + SMBMySeminar."Seminar No.";
                until (SMBMySeminar.Next() = 0) or (MaxCount <= 0);
        end;
    end;

}