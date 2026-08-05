codeunit 63031 "PTE Commis. Jnl.-Check Line"
{
    TableNo = "PTE Commission Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        ClosingDateErr: Label 'cannot be a closing date', Comment = 'de-DE=darf kein Abschlussdatum sein';


    procedure RunCheck(var CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        if CommissionJournalLine.EmptyLine() then
            exit;

        CommissionJournalLine.TestField("Posting Date", ErrorInfo.Create());
        CommissionJournalLine.TestField("Document No.", ErrorInfo.Create());
        CommissionJournalLine.TestField("Salesperson Code", ErrorInfo.Create());
        CommissionJournalLine.TestField("Commission Contract No.", ErrorInfo.Create());

        CheckPostingDate(CommissionJournalLine);
        CheckDocumentDate(CommissionJournalLine);
    end;

    local procedure CheckPostingDate(CommissionJournalLine: Record "PTE Commission Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";
    begin
        if CommissionJournalLine."Posting Date" <> NormalDate(CommissionJournalLine."Posting Date") then
            CommissionJournalLine.FieldError("Posting Date", ErrorInfo.Create(ClosingDateErr, true));

        UserSetupManagement.CheckAllowedPostingDate(CommissionJournalLine."Posting Date");
    end;

    local procedure CheckDocumentDate(CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        if CommissionJournalLine."Document Date" = 0D then
            exit;

        if CommissionJournalLine."Document Date" <> NormalDate(CommissionJournalLine."Document Date") then
            CommissionJournalLine.FieldError("Document Date", ErrorInfo.Create(ClosingDateErr, true));
    end;
}
