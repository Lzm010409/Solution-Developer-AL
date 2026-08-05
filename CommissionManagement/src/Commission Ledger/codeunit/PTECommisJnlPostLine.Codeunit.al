codeunit 63032 "PTE Commis. Jnl.-Post Line"
{
    Permissions = tabledata "PTE Commission Ledger Entry" = RI;
    TableNo = "PTE Commission Journal Line";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        CommissionJournalLineGlobal: Record "PTE Commission Journal Line";
        CommissionMgtSetup: Record "PTE Commission Mgt. Setup";
        SourceCodeSetup: Record "Source Code Setup";
        CommisJnlCheckLine: Codeunit "PTE Commis. Jnl.-Check Line";
        SetupRead: Boolean;
        SourceCodeSetupRead: Boolean;

    procedure RunWithCheck(var CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        CommissionJournalLineGlobal.Copy(CommissionJournalLine);
        "Code"();
        CommissionJournalLine := CommissionJournalLineGlobal;
    end;

    procedure RunWithoutCheck(var CommissionJournalLine: Record "PTE Commission Journal Line")
    begin
        CommissionJournalLineGlobal.Copy(CommissionJournalLine);
        "Code"(false);
        CommissionJournalLine := CommissionJournalLineGlobal;
    end;

    local procedure "Code"(Check: Boolean)
    begin
        if Check then begin
            "Code"();
            exit;
        end;

        if CommissionJournalLineGlobal.EmptyLine() then
            exit;

        if CommissionJournalLineGlobal."Document Date" = 0D then
            CommissionJournalLineGlobal."Document Date" := CommissionJournalLineGlobal."Posting Date";

        CheckSalespersonNotBlocked();
        UpdateSourceCode();
        UpdateCommissionAmount();
        InsertCommissionLedgerEntry();
    end;

    local procedure "Code"()
    begin
        if CommissionJournalLineGlobal.EmptyLine() then
            exit;

        CommisJnlCheckLine.RunCheck(CommissionJournalLineGlobal);

        if CommissionJournalLineGlobal."Document Date" = 0D then
            CommissionJournalLineGlobal."Document Date" := CommissionJournalLineGlobal."Posting Date";

        CheckSalespersonNotBlocked();
        UpdateSourceCode();
        UpdateCommissionAmount();
        InsertCommissionLedgerEntry();
    end;

    local procedure UpdateSourceCode()
    begin
        if CommissionJournalLineGlobal."Source Code" <> '' then
            exit;

        GetSourceCodeSetup();
        CommissionJournalLineGlobal."Source Code" := SourceCodeSetup."PTE Commission";
    end;

    local procedure CheckSalespersonNotBlocked()
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        SalespersonPurchaser.Get(CommissionJournalLineGlobal."Salesperson Code");
        SalespersonPurchaser.TestField(Blocked, false);
    end;

    local procedure UpdateCommissionAmount()
    var
        CalculateCommission: Codeunit "PTE Calculate Commission";
        CommissionAmount: Decimal;
    begin
        GetSetup();

        CommissionJournalLineGlobal."Commission Percentage" :=
            CalculateCommission.GetCommissionPercentage(CommissionJournalLineGlobal);

        CommissionAmount :=
            CalculateCommission.CalculateCommissionAmount(
                CommissionJournalLineGlobal,
                CommissionJournalLineGlobal."Commission Percentage",
                CommissionJournalLineGlobal."Amount (LCY)");

        CommissionJournalLineGlobal."Commission Amount (LCY)" :=
            Round(CommissionAmount, CommissionMgtSetup."Rounding Precision");
    end;

    local procedure InsertCommissionLedgerEntry()
    var
        CommissionLedgerEntry: Record "PTE Commission Ledger Entry";
    begin
        CommissionLedgerEntry.Init();
        CommissionLedgerEntry.CopyFromJnlLine(CommissionJournalLineGlobal);
        CommissionLedgerEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(CommissionLedgerEntry."User ID"));
        CommissionLedgerEntry.Insert(true);
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
            exit;

        CommissionMgtSetup.Get();
        CommissionMgtSetup.TestField("Rounding Precision");
        SetupRead := true;
    end;

    local procedure GetSourceCodeSetup()
    begin
        if SourceCodeSetupRead then
            exit;

        if not SourceCodeSetup.Get() then
            Clear(SourceCodeSetup);
        SourceCodeSetupRead := true;
    end;
}
