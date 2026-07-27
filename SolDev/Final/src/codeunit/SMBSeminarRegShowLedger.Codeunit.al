codeunit 123456745 "SMB Seminar Reg.-Show Ledger"
{
    TableNo = "SMB Seminar Register";

    trigger OnRun()
    begin
        SeminarLedgerEntry.SetRange("Entry No.", rec."From Entry No.", rec."To Entry No.");
        Page.Run(Page::"SMB Seminar Ledger Entries", SeminarLedgerEntry);
    end;

    var
        SeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
}

