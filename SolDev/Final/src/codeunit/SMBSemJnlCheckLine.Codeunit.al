codeunit 123456731 "SMB Sem. Jnl.-Check Line"
{
    TableNo = "SMB Seminar Journal Line";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        // DimMgt: Codeunit DimensionManagement;

#pragma warning disable AA0074
        Text000: Label 'cannot be a closing date';
#pragma warning disable AA0470
        // Text002: Label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        // Text003: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
#pragma warning restore AA0470
#pragma warning restore AA0074

    procedure RunCheck(var SMBSeminarJnlLine: Record "SMB Seminar Journal Line")

    begin

        GLSetup.Get();

        if SMBSeminarJnlLine.EmptyLine() then
            exit;

        SMBSeminarJnlLine.TestField("Seminar No.", ErrorInfo.Create());
        SMBSeminarJnlLine.TestField("Posting Date", ErrorInfo.Create());
        

        case SMBSeminarJnlLine."Charge Type" of
            SMBSeminarJnlLine."Charge Type"::Instructor:
                SMBSeminarJnlLine.TestField("Instructor Code");
            SMBSeminarJnlLine."Charge Type"::Room:
                SMBSeminarJnlLine.TestField("Seminar Room Code");
            SMBSeminarJnlLine."Charge Type"::Participant:
                begin
                    SMBSeminarJnlLine.TestField("Bill-to Customer No.");
                    SMBSeminarJnlLine.TestField("Participant Contact No.");
                end;
        end;

        if SMBSeminarJnlLine.Chargeable then begin
            SMBSeminarJnlLine.TestField("Bill-to Customer No.");
            SMBSeminarJnlLine.TestField("Gen. Prod. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("VAT Prod. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("Gen. Bus. Posting Group", ErrorInfo.Create());
            SMBSeminarJnlLine.TestField("VAT Bus. Posting Group", ErrorInfo.Create());
        end;

        CheckPostingDate(SMBSeminarJnlLine);

        if SMBSeminarJnlLine."Document Date" <> 0D then
            if SMBSeminarJnlLine."Document Date" <> NormalDate(SMBSeminarJnlLine."Document Date") then
                SMBSeminarJnlLine.FieldError("Document Date", ErrorInfo.Create(Text000, true));

        // CheckDimensions(SMBSeminarJnlLine);

    end;

    local procedure CheckPostingDate(SMBSeminarJnlLine: Record "SMB Seminar Journal Line")
    var
        UserSetupManagement: Codeunit "User Setup Management";

    begin
        if SMBSeminarJnlLine."Posting Date" <> NormalDate(SMBSeminarJnlLine."Posting Date") then
            SMBSeminarJnlLine.FieldError("Posting Date", ErrorInfo.Create(Text000, true));

        UserSetupManagement.CheckAllowedPostingDate(SMBSeminarJnlLine."Posting Date");
    end;

    // local procedure CheckDimensions(ResJnlLine: Record "Res. Journal Line")
    // var
    //     TableID: array[10] of Integer;
    //     No: array[10] of Code[20];
    //     IsHandled: Boolean;
    // begin
    //     IsHandled := false;
    //     OnBeforeCheckDimensions(ResJnlLine, IsHandled);
    //     if IsHandled then
    //         exit;

    //     if not DimMgt.CheckDimIDComb(ResJnlLine."Dimension Set ID") then
    //         Error(
    //             Text002,
    //             ResJnlLine.TableCaption(), ResJnlLine."Journal Template Name", ResJnlLine."Journal Batch Name", ResJnlLine."Line No.",
    //             DimMgt.GetDimCombErr());

    //     TableID[1] := DATABASE::Resource;
    //     No[1] := ResJnlLine."Resource No.";
    //     TableID[2] := DATABASE::"Resource Group";
    //     No[2] := ResJnlLine."Resource Group No.";
    //     TableID[3] := DATABASE::Job;
    //     No[3] := ResJnlLine."Job No.";
    //     OnCheckDimensionsOnAfterAssignDimTableIDs(ResJnlLine, TableID, No);
    //     if not DimMgt.CheckDimValuePosting(TableID, No, ResJnlLine."Dimension Set ID") then
    //         if ResJnlLine."Line No." <> 0 then
    //             Error(
    //                 Text003,
    //                 ResJnlLine.TableCaption(), ResJnlLine."Journal Template Name", ResJnlLine."Journal Batch Name", ResJnlLine."Line No.",
    //                 DimMgt.GetDimValuePostingErr())
    //         else
    //             Error(DimMgt.GetDimValuePostingErr());
    // end;

}

