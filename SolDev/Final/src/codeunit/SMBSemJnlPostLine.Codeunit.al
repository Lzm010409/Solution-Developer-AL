codeunit 123456732 "SMB Sem. Jnl.-Post Line"
{
    Permissions = TableData "SMB Seminar Ledger Entry" = rimd,
                  TableData "SMB Seminar Register" = rimd;
    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        SMBSeminarJournalLineGlobal: Record "SMB Seminar Journal Line";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
        SMBSeminar: Record "SMB Seminar";
        SMBSeminarRegister: Record "SMB Seminar Register";
        SMBSemJnlCheckLine: Codeunit "SMB Sem. Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var SMBSeminarJournalLine: Record "SMB Seminar Journal Line")
    begin
        SMBSeminarJournalLineGlobal.Copy(SMBSeminarJournalLine);
        Code();
        SMBSeminarJournalLine := SMBSeminarJournalLineGlobal;
    end;

    local procedure "Code"()
    begin
        if SMBSeminarJournalLineGlobal.EmptyLine() then
            exit;

        SMBSemJnlCheckLine.RunCheck(SMBSeminarJournalLineGlobal);
        if (NextEntryNo = 0) then begin
            SMBSeminarLedgerEntry.LockTable();
            NextEntryNo := SMBSeminarLedgerEntry.GetLastEntryNo() + 1;
        end;

        if SMBSeminarJournalLineGlobal."Document Date" = 0D then
            SMBSeminarJournalLineGlobal."Document Date" := SMBSeminarJournalLineGlobal."Posting Date";

        SMBSeminar.Get(SMBSeminarJournalLineGlobal."Seminar No.");
        SMBSeminar.TestField(Blocked, false);

        SMBSeminarLedgerEntry.Init();
        SMBSeminarLedgerEntry.CopyFromSemJnlLine(SMBSeminarJournalLineGlobal);
        SMBSeminarLedgerEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBSeminarLedgerEntry."User ID"));
        SMBSeminarLedgerEntry."Entry No." := NextEntryNo;
        InsertRegister(SMBSeminarLedgerEntry."Entry No.");
        SMBSeminarLedgerEntry.Insert(true);

        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure InsertRegister(SemLedgEntryNo: Integer)
    begin
        if SMBSeminarRegister."No." = 0 then begin
            SMBSeminarRegister.LockTable();
            SMBSeminarRegister."No." := SMBSeminarRegister.GetLastEntryNo() + 1;
            SMBSeminarRegister.Init();
            SMBSeminarRegister."From Entry No." := NextEntryNo;
            SMBSeminarRegister."To Entry No." := NextEntryNo;
            SMBSeminarRegister."Creation Date" := Today();
            SMBSeminarRegister."Creation Time" := Time();
            SMBSeminarRegister."Source Code" := SMBSeminarJournalLineGlobal."Source Code";
            SMBSeminarRegister."Journal Batch Name" := SMBSeminarJournalLineGlobal."Journal Batch Name";
            SMBSeminarRegister."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBSeminarRegister."User ID"));
            SMBSeminarRegister.Insert();
        end else begin
            if ((SemLedgEntryNo < SMBSeminarRegister."From Entry No.") and (SemLedgEntryNo <> 0)) or
               ((SMBSeminarRegister."From Entry No." = 0) and (SemLedgEntryNo > 0))
            then
                SMBSeminarRegister."From Entry No." := SemLedgEntryNo;
            if SemLedgEntryNo > SMBSeminarRegister."To Entry No." then
                SMBSeminarRegister."To Entry No." := SemLedgEntryNo;
            SMBSeminarRegister.Modify();
        end;
    end;
}







// codeunit 123456732 "SMB Sem. Jnl.-Post Line"
// {
//     Permissions = TableData "SMB Seminar Ledger Entry" = rimd,
//                   TableData "SMB Seminar Register" = rimd;

//     TableNo = "SMB Seminar Journal Line";

//     trigger OnRun()
//     begin
//         GetGLSetup();
//         RunWithCheck(Rec);
//     end;

//     var
//         GeneralLedgerSetup: Record "General Ledger Setup";
//         SMBSeminarJournalLineGlobal: Record "SMB Seminar Journal Line";
//         SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
//         SMBSeminar: Record "SMB Seminar";
//         SMBSeminarRegister: Record "SMB Seminar Register";
//         SMBSemJnlCheckLine: Codeunit "SMB Sem. Jnl.-Check Line";
//         NextEntryNo: Integer;
//         GLSetupRead: Boolean;

//     procedure RunWithCheck(var SMBSeminarJournalLine: Record "SMB Seminar Journal Line")
//     var
//         SequenceNoMgt: Codeunit "Sequence No. Mgt.";
//     begin
//         SMBSeminarJournalLineGlobal.Copy(SMBSeminarJournalLine);
//         // SequenceNoMgt.ClearSequenceNoCheck();
//         Code();
//         SMBSeminarJournalLine := SMBSeminarJournalLineGlobal;
//     end;

//     local procedure "Code"()
//     var
//         xNextEntryNo: Integer;

//     begin
//         // xNextEntryNo := NextEntryNo;


//         // ValidateSequenceNo(NextEntryNo, xNextEntryNo, Database::"Res. Ledger Entry");
//         if SMBSeminarJournalLineGlobal.EmptyLine() then
//             exit;

//         SMBSemJnlCheckLine.RunCheck(SMBSeminarJournalLineGlobal);


//         // if (NextEntryNo = 0) and ResourcesSetup.UseLegacyPosting() then begin
//         if (NextEntryNo = 0) then begin
//             SMBSeminarLedgerEntry.LockTable();
//             NextEntryNo := SMBSeminarLedgerEntry.GetLastEntryNo() + 1;
//         end;

//         if SMBSeminarJournalLineGlobal."Document Date" = 0D then
//             SMBSeminarJournalLineGlobal."Document Date" := SMBSeminarJournalLineGlobal."Posting Date";

//         SMBSeminar.Get(SMBSeminarJournalLineGlobal."Seminar No.");

//         SMBSeminar.TestField(Blocked, false);

//         // if not ResourcesSetup.UseLegacyPosting() then
//         //     NextEntryNo := SMBSeminarLedgerEntry.GetNextEntryNo();

//         SMBSeminarLedgerEntry.Init();
//         SMBSeminarLedgerEntry.CopyFromSemJnlLine(SMBSeminarJournalLineGlobal);



//         SMBSeminarLedgerEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBSeminarLedgerEntry."User ID"));
//         SMBSeminarLedgerEntry."Entry No." := NextEntryNo;


//         // if SMBSeminarLedgerEntry."Entry Type" = SMBSeminarLedgerEntry."Entry Type"::Usage then begin
//         //     PostTimeSheetDetail(SMBSeminarJournalLineGlobal, SMBSeminarLedgerEntry."Quantity (Base)");
//         //     SMBSeminarLedgerEntry.Chargeable := IsChargable(SMBSeminarJournalLineGlobal, SMBSeminarLedgerEntry.Chargeable);
//         // end;     

//         InsertRegister(SMBSeminarLedgerEntry."Entry No.");

//         SMBSeminarLedgerEntry.Insert(true);

//         // if ResourcesSetup.UseLegacyPosting() then
//         NextEntryNo := NextEntryNo + 1;
//     end;

//         // xNextEntryNo := NextEntryNo;

//         // ValidateSequenceNo(NextEntryNo, xNextEntryNo, Database::"Res. Ledger Entry");
//     // end;

//     local procedure GetGLSetup()
//     begin
//         if not GLSetupRead then
//             GeneralLedgerSetup.Get();
//         GLSetupRead := true;
//     end;


//     local procedure InsertRegister(SemLedgEntryNo: Integer)
//     begin
//         if SMBSeminarRegister."No." = 0 then begin
//             // SMBSeminarRegister."No." := SMBSeminarRegister.GetNextEntryNo(ResourcesSetup.UseLegacyPosting());

//             // SMBSeminarRegister.LockTable();
//             // if SMBSeminarRegister.FindLast() then
//             //     SMBSeminarRegister."No." := SMBSeminarRegister."No." + 1
//             // else
//             //     SMBSeminarRegister."No." := 1;
//             SMBSeminarRegister."No." := SMBSeminarRegister.GetLastEntryNo() + 1;
//             SMBSeminarRegister.Init();
//             SMBSeminarRegister."From Entry No." := NextEntryNo;
//             SMBSeminarRegister."To Entry No." := NextEntryNo;
//             SMBSeminarRegister."Creation Date" := Today();
//             SMBSeminarRegister."Creation Time" := Time();
//             SMBSeminarRegister."Source Code" := SMBSeminarJournalLineGlobal."Source Code";
//             SMBSeminarRegister."Journal Batch Name" := SMBSeminarJournalLineGlobal."Journal Batch Name";
//             SMBSeminarRegister."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBSeminarRegister."User ID"));

//             SMBSeminarRegister.Insert();
//         end else begin
//             if ((SemLedgEntryNo < SMBSeminarRegister."From Entry No.") and (SemLedgEntryNo <> 0)) or
//                ((SMBSeminarRegister."From Entry No." = 0) and (SemLedgEntryNo > 0))
//             then
//                 SMBSeminarRegister."From Entry No." := SemLedgEntryNo;
//             if SemLedgEntryNo > SMBSeminarRegister."To Entry No." then
//                 SMBSeminarRegister."To Entry No." := SemLedgEntryNo;
//             SMBSeminarRegister.Modify();
//         end;
//     end;

//     // [InherentPermissions(PermissionObjectType::TableData, Database::"Res. Ledger Entry", 'r')]
//     // local procedure ValidateSequenceNo(LedgEntryNo: Integer; xLedgEntryNo: Integer; TableNo: Integer)
//     // var
//     //     SequenceNoMgt: Codeunit "Sequence No. Mgt.";
//     // begin
//     //     if LedgEntryNo = xLedgEntryNo then
//     //         exit;
//     //     if ResourcesSetup.UseLegacyPosting() then
//     //         exit;
//     //     SequenceNoMgt.ValidateSeqNo(TableNo);
//     // end;

// }

