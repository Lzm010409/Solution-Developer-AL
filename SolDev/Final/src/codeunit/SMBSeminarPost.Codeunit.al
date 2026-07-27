codeunit 123456700 "SMB Seminar-Post"
{
    // 0.2 Die Codeunit muss geb. Belege erstellen dürfen
    // Rechte vergeben
    Permissions = tabledata "SMB Posted Seminar Reg. Header" = rimd,
                  tabledata "SMB Posted Seminar Reg. Line" = rimd,
                  tabledata "SMB Seminar Reg. Header" = rimd,    // falls Teilbuchungen möglich sein sollen
                  tabledata "SMB Seminar Reg. Line" = rimd;     // falls Teilbuchungen möglich sein sollen
    TableNo = "SMB Seminar Reg. Header";

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;
    // 0.1 Erstellen einer leeren Prozedur "RunWithCheck" und aufrufen aus "OnRun"
    var
        SMBPostedSeminarRegHeader: Record "SMB Posted Seminar Reg. Header";
        GLSetup: Record "General Ledger Setup";
        TempSMBSeminarRegLineGlobal: Record "SMB Seminar Reg. Line" temporary;
        SMBSeminarSetup: Record "SMB Seminar Setup";
        SMBPostedSeminarRegLine: Record "SMB Posted Seminar Reg. Line";
        NothingToPostErr: Label 'There is nothing to post.';
        SrcCode: Code[10];
        PostingLinesMsg: Label 'Posting lines              #2######\', Comment = 'Counter %2';
        GLSetupRead: Boolean;
        SalesSetupRead: Boolean;
        Window: Dialog;

    internal procedure RunWithCheck(var SMBSeminarRegHeader2: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
    begin
        // 1.) Alle Variablen müssen initialisiert (Prozedur "ClearAllVariables") werden 
        ClearAllVariables();
        // 1.1) Notwendige Einrichtung(en) lesen
        GetSeminarSetup();
        // 1.2 Der Rec Parameter wird in eine lokale Var übernommen
        SMBSeminarRegHeader := SMBSeminarRegHeader2;
        // 2.) Zeilen in eine Temproräre (globale) Rec Var kopieren (FillTempLines)
        FillTempLines(SMBSeminarRegHeader, TempSMBSeminarRegLineGlobal);
        // 3.) Header: erstellen Sie die leere Prozedur "CheckAndUpdate" und rufen Sie diese auf

        // Header
        CheckAndUpdate(SMBSeminarRegHeader);

        // Lines
        // 17.) Prozedur: ProcessPostingLines
        // TempZeilen in einer Schleife lesen und die Prozedur PostSemRegLine(Kopf,Zeile) aufrufen
        ProcessPostingLines(SMBSeminarRegHeader);

        // 21.) Wenn alle Zeilen gebucht sind wird "EverythingPosted" gesetzt.
        // Prozedur EverythingPosted, welche eine Rückgabewert hat, wenn ale Zeilen Registered sind
        //  Kopf und Zeilen löschen inkl. Bemerkungen und Links
        // FinalizeSeminarRegistration
        FinalizeSeminarRegistration(SMBSeminarRegHeader);

        Commit();
    end;

    local procedure FinalizeSeminarRegistration(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
    begin
        if EverythingPosted() then begin
            SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
            SMBSeminarRegLine.DeleteAll();

            SMBSeminarCommentLine.DeleteComments(
                SMBSeminarCommentLine."Document Type"::"Seminar Registration",
                SMBSeminarRegHeader."No.");
            if SMBSeminarRegHeader.HasLinks then
                SMBSeminarRegHeader.DeleteLinks();
            SMBSeminarRegHeader.Delete();
        end;
    end;
    local procedure EverythingPosted(): Boolean
    begin
        TempSMBSeminarRegLineGlobal.Reset();
        TempSMBSeminarRegLineGlobal.SetRange(Registered, false);
        exit(TempSMBSeminarRegLineGlobal.IsEmpty);
    end;

    local procedure ProcessPostingLines(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        // SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        LineCount: Integer;
    begin
        TempSMBSeminarRegLineGlobal.FindSet();

        repeat
            LineCount := LineCount + 1;
            if GuiAllowed() then
                Window.Update(2, LineCount);
            PostSemRegLine(SMBSeminarRegHeader, TempSMBSeminarRegLineGlobal);
        until TempSMBSeminarRegLineGlobal.Next() = 0;

        //          // Wird nur benötigt, wenn es Teilbuchungen der Teilnehmer gibt.
        //         // Haben wir aktuell nicht, nur zur Demo
        //         TempSMBSeminarRegLineGlobal.SetRange(Registered, true);
        //         TempSMBSeminarRegLineGlobal.FindSet(); //Zweiter Durchlauf, damit Registered zurück geschrieben wird
        //         repeat
        //             SMBSeminarRegLine.Get(
        //                 TempSMBSeminarRegLineGlobal."Document No.",
        //                 TempSMBSeminarRegLineGlobal."Line No.");
        //             SMBSeminarRegLine := TempSMBSeminarRegLineGlobal;
        // #pragma warning disable AA0214
        //             SMBSeminarRegLine.Modify();
        // #pragma warning restore AA0214
        //         until TempSMBSeminarRegLineGlobal.Next() = 0;

    end;

    local procedure PostSemRegLine(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var SMBSeminarRegLine: Record "SMB Seminar Reg. Line")

    begin
        // 18.)
        // Prüfen ob die Pflichtfelder gefüllt sind
        // Ist die Zeile nicht "To Invoice" Betragsfelder auf 0 
        // TestAndUpdateSemRegLine(TempSMBSeminarRegLine);
        TestAndUpdateSemRegLine(SMBSeminarRegLine);

        // 19.)
        // Gebuchte Belegzeile einfügen  (Init, Transferfields, korrigieren.... einfügen)
        // InsertPstSemRegLine
        InsertPstSemRegLine(SMBSeminarRegLine, SMBSeminarRegHeader);
        //  20.)
        // Teilnehmerposten erstellen
        // PostSemJnlLine
        PostSemJnlLine("SMB Sem. Ledger Charge Type"::Participant, SMBSeminarRegHeader, SMBSeminarRegLine, 0);
    end;

    local procedure InsertPstSemRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line"; SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        SMBPostedSeminarRegLine.Init();
        SMBSeminarRegLine.Registered := true;
        SMBSeminarRegLine.Participated := true;
        SMBSeminarRegLine.Modify();
        SMBSeminarRegLine.CalcFields("Participant Name");
        SMBPostedSeminarRegLine.TransferFields(SMBSeminarRegLine);
        SMBPostedSeminarRegLine."Participant Name" := SMBSeminarRegLine."Participant Name";
        SMBPostedSeminarRegLine."Document No." := SMBSeminarRegHeader."Posting No.";
        SMBPostedSeminarRegLine.Insert();
    end;

    local procedure TestAndUpdateSemRegLine(var SMBSeminarRegLine: Record "SMB Seminar Reg. Line")
    begin
        SMBSeminarRegLine.TestField("Bill-to Customer No.");
        SMBSeminarRegLine.TestField("Participant Contact No.");
        SMBSeminarRegLine.TestField("Gen. Bus. Posting Group");
        SMBSeminarRegLine.TestField("VAT Bus. Posting Group");

        if not SMBSeminarRegLine."To Invoice" then begin
            SMBSeminarRegLine."Seminar Price (LCY)" := 0.0;
            SMBSeminarRegLine."Line Discount %" := 0.0;
            SMBSeminarRegLine."Line Discount Amount (LCY)" := 0.0;
            SMBSeminarRegLine."Line Amount (LCY)" := 0.0;
            SMBSeminarRegLine."Line Amount" := 0.0;
        end;
    end;

    local procedure ClearAllVariables()
    begin
        ClearAll();
        // es kommen noch TempRecord dazu
        TempSMBSeminarRegLineGlobal.DeleteAll();
    end;

    local procedure GetSeminarSetup()
    begin
        if not SalesSetupRead then
            SMBSeminarSetup.Get();

        SalesSetupRead := true;
    end;

    procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get();

        GLSetupRead := true;

    end;

    procedure FillTempLines(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var TempSMBSeminarRegLine: Record "SMB Seminar Reg. Line" temporary)
    begin
        TempSMBSeminarRegLine.Reset();
        if TempSMBSeminarRegLine.IsEmpty() then
            CopyToTempLines(SMBSeminarRegHeader, TempSMBSeminarRegLine);
    end;

    procedure CopyToTempLines(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var TempSMBSeminarRegLine: Record "SMB Seminar Reg. Line" temporary)
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    begin
        SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
        if SMBSeminarRegLine.FindSet() then
            repeat
                TempSMBSeminarRegLine := SMBSeminarRegLine;
                TempSMBSeminarRegLine.Insert();
            until SMBSeminarRegLine.Next() = 0;
    end;

    local procedure CheckAndUpdate(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SourceCodeSetup: Record "Source Code Setup";
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        LastResEntryNo: Integer;
        ModifyHeader: Boolean;
    begin
        // 4.) CheckSeminarDocument Procedure erstellen und aufrufen
        CheckSeminarDocument(SMBSeminarRegHeader);

        // 11.) UpdatePostingNos -> UpdatePostingNo
        // Wenn die Buchungsnummer leer ist, prüfen ob die Buchungsnummernserie gefüllt ist und dann die Nummer ziehen

        // ModifyHeader = True zurück geben
        ModifyHeader := UpdatePostingNos(SMBSeminarRegHeader);

        // 12.) Wenn eine Nummer gezogen wurde -> Modify, commit

        if ModifyHeader then begin
            SMBSeminarRegHeader.Modify();
            Commit();
        end;

        // 13.) Die Zeilentabelle, aktueller Kopf, Seminarposten und Ressourcenposten auf das Sperren vorbereiten 
        // Prozedur: LockTables
        LockTables(SMBSeminarRegHeader);

        // 14.) Alle Fragemnte welche erzeugt werden, müssen mit einer Herkunft gekennzeichnet werden.       
        // Lesen Sie die Einrichtung und weisen Sie der globalen Variablen SrcCode diesen Wert zu
        SourceCodeSetup.Get();
        SrcCode := SourceCodeSetup."SMB Seminar";

        // 15.) Aufruf der Funktion (Funktionen) welche den Gebuchten Kopf (Köpfe) erstellt
        // InsertPstHeaders -> InsertPstSemRegHeader
        // PstDocHeader.Init
        // PstDocHeader.TransferFieldsd
        // Felder korrigieren
        // Einfügen
        // Bemerkungen kopieren 
        InsertPostedHeaders(SMBSeminarRegHeader);

        // 16.) ) Erstellen der Ressourcenposten und Seminarposten für Trainer und Raum
        // Der Seminarposten wird über LastResEntryNo mit dem Ressourcenposten verbunden

        // Instructor
        LastResEntryNo := PostResJnlLine("SMB Sem. Ledger Charge Type"::Instructor, SMBSeminarRegHeader);
        PostSemJnlLine("SMB Sem. Ledger Charge Type"::Instructor, SMBSeminarRegHeader, SMBSeminarRegLine, LastResEntryNo);

        // Room
        LastResEntryNo := PostResJnlLine("SMB Sem. Ledger Charge Type"::Room, SMBSeminarRegHeader);
        PostSemJnlLine("SMB Sem. Ledger Charge Type"::Room, SMBSeminarRegHeader, SMBSeminarRegLine, LastResEntryNo);

    end;

    local procedure InsertPostedHeaders(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        InsertPstSemRegHeader(SMBSeminarRegHeader);
    end;

    local procedure InsertPstSemRegHeader(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarCommentLine: Record "SMB Seminar Comment Line";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        SMBPostedSeminarRegHeader.Init();
        SMBSeminarRegHeader.CalcFields("Instructor Name");

        SMBPostedSeminarRegHeader.TransferFields(SMBSeminarRegHeader);
        SMBPostedSeminarRegHeader."Instructor Name" := SMBSeminarRegHeader."Instructor Name";

        SMBPostedSeminarRegHeader."Registration No. Series" := SMBSeminarRegHeader."No. Series";
        SMBPostedSeminarRegHeader."Registration No." := SMBSeminarRegHeader."No.";
        SMBPostedSeminarRegHeader."No. Series" := SMBSeminarRegHeader."Posting No. Series";
        SMBPostedSeminarRegHeader."No." := SMBSeminarRegHeader."Posting No.";

        SMBPostedSeminarRegHeader."Source Code" := SrcCode;
        SMBPostedSeminarRegHeader."User ID" := CopyStr(UserId(), 1, MaxStrLen(SMBPostedSeminarRegHeader."User ID"));
        SMBPostedSeminarRegHeader."No. Printed" := 0;
        SMBPostedSeminarRegHeader.Insert(true);

        GetSeminarSetup();
        if SMBSeminarSetup."Copy Comments Reg. to Pst." then begin
            SMBSeminarCommentLine.CopyComments(
                SMBSeminarCommentLine."Document Type"::"Seminar Registration".AsInteger(),
                SMBSeminarCommentLine."Document Type"::"Posted Seminar Registration".AsInteger(),
                SMBSeminarRegHeader."No.", SMBPostedSeminarRegHeader."No.");
            RecordLinkManagement.CopyLinks(SMBSeminarRegHeader, SMBPostedSeminarRegHeader);
        end;
    end;

    local procedure LockTables(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
        SMBSeminarLedgerEntry: Record "SMB Seminar Ledger Entry";
        ResLedgerEntry: Record "Res. Ledger Entry";
    begin
        SMBSeminarRegHeader.LockTable();
        SMBSeminarRegHeader.Find();
        SMBSeminarRegLine.LockTable();
        SMBSeminarLedgerEntry.LockTable();
        ResLedgerEntry.LockTable();
    end;

    procedure CheckSeminarDocument(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        UserSetupManagement: Codeunit "User Setup Management";

    begin
        // 5.) Prüfen der "Pflichtfelder" im Kopf (evtl. Prozedur)
        // CheckMandatoryHeaderFields(SalesHeader);
        CheckMandatoryHeaderFields(SMBSeminarRegHeader);

        // 8.) Darf der User Heute buchen
        // UserSetupManagement.CheckAllowedPostingDate
        UserSetupManagement.CheckAllowedPostingDate(SMBSeminarRegHeader."Posting Date");

        // 9.) gibt es buchbare Zeilen zum Kopf?
        //  CheckSemRegLineExistToPost
        CheckSemRegLineExistToPost(SMBSeminarRegHeader);

        // 10.) Öffnen und aktualisieren Sie eine Anzeige
        // InitProgressWindow
        InitProgressWindow(SMBSeminarRegHeader);

    end;

    local procedure CheckSemRegLineExistToPost(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
    begin
        SMBSeminarRegLine.SetRange("Document No.", SMBSeminarRegHeader."No.");
        SMBSeminarRegLine.SetRange(Registered, false);
        SMBSeminarRegLine.SetFilter("Bill-to Customer No.", '<>%1', '');
        if SMBSeminarRegLine.IsEmpty then
            Error(NothingToPostErr);
    end;


    local procedure CheckMandatoryHeaderFields(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    var
        SMBInstructor: Record "SMB Instructor";
        SMBSeminarRoom: Record "SMB Seminar Room";
    begin
        // 6.) prüfen der Pflichtfelder im Kopf für die Posten
        SMBSeminarRegHeader.TestField("Seminar No.");
        SMBSeminarRegHeader.TestField("Posting Date");
        SMBSeminarRegHeader.TestField("Document Date");
        SMBSeminarRegHeader.TestField("Starting Date");
        SMBSeminarRegHeader.TestField("Instructor Code");
        SMBSeminarRegHeader.TestField("Room Code");
        SMBSeminarRegHeader.TestField(Status, SMBSeminarRegHeader.Status::Closed);
        // 6.1) Buchungsgruppen für die Fakturierung
        SMBSeminarRegHeader.TestField("Gen. Prod. Posting Group");
        SMBSeminarRegHeader.TestField("VAT Prod. Posting Group");
        // 7.) Prüfen ob die Ressourcen Nr. beim Trainer und Raum gefüllt ist
        SMBInstructor.Get(SMBSeminarRegHeader."Instructor Code");
        SMBInstructor.TestField("Resource No.");
        SMBSeminarRoom.Get(SMBSeminarRegHeader."Room Code");
        SMBSeminarRoom.TestField("Resource No.");
    end;

    procedure InitProgressWindow(SMBSeminarRegHeader: Record "SMB Seminar Reg. Header")
    begin
        Window.Open(
          '#1#################################\\' +
          PostingLinesMsg);

        Window.Update(1, StrSubstNo('%1', SMBSeminarRegHeader."No."));
    end;

    local procedure UpdatePostingNos(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header") ModifyHeader: Boolean
    begin

        UpdatePostingNo(SMBSeminarRegHeader, ModifyHeader);
        // Prozedur, falls es noch weitere Nummern zu erzeugen gibt...

    end;

    local procedure UpdatePostingNo(var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"; var ModifyHeader: Boolean)
    var
        NoSeries: Codeunit "No. Series";
    begin
        if (SMBSeminarRegHeader."Posting No." = '') then begin
            SMBSeminarRegHeader.TestField("Posting No. Series");
            SMBSeminarRegHeader."Posting No." := NoSeries.GetNextNo(SMBSeminarRegHeader."Posting No. Series", SMBSeminarRegHeader."Posting Date");
            ModifyHeader := true;
        end;
    end;

    local procedure PostResJnlLine(ChargeType: Enum "SMB Sem. Ledger Charge Type";
                                      var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header"): Integer
    var
        Resource: Record Resource;
        ResLedgerEntry: Record "Res. Ledger Entry";
        SMBInstructor: Record "SMB Instructor";
        SMBSeminarRoom: Record "SMB Seminar Room";
        ResJnlLine: Record "Res. Journal Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
    begin
        // Füllen der Buchblatt Zeile
        ResJnlLine.Init();

        // Füllen gemeinsamer Felder
        ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
        ResJnlLine."Document No." := SMBSeminarRegHeader."Posting No.";
        ResJnlLine."Posting Date" := SMBSeminarRegHeader."Posting Date";
        ResJnlLine.Description := SMBSeminarRegHeader."Seminar Description";
        ResJnlLine."Source Code" := SrcCode;
        ResJnlLine."Reason Code" := SMBSeminarRegHeader."Reason Code";
        ResJnlLine."Gen. Prod. Posting Group" := SMBSeminarRegHeader."Gen. Prod. Posting Group";
        ResJnlLine."Document Date" := SMBSeminarRegHeader."Document Date";
        ResJnlLine."Posting No. Series" := SMBSeminarRegHeader."Posting No. Series";
        // Füllen der Felder abhängig vom ChargeType

        // Aufruf der Res. Jnl Post Line

        case ChargeType of
            ChargeType::Instructor:
                begin
                    SMBInstructor.get(SMBSeminarRegHeader."Instructor Code");
                    SMBInstructor.TestField("Resource No.");
                    Resource.Get(SMBInstructor."Resource No.");
                    ResJnlLine."Resource No." := Resource."No.";
                    ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
                    ResJnlLine.Quantity := SMBSeminarRegHeader."Duration Days";
                    ResJnlLine."Qty. per Unit of Measure" := 1;
                    ResJnlLine."Unit Cost" := Resource."Unit Cost";
                    ResJnlLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
                end;
            ChargeType::Room:
                begin
                    SMBSeminarRoom.Get(SMBSeminarRegHeader."Room Code");
                    SMBSeminarRoom.TestField("Resource No.");
                    Resource.Get(SMBSeminarRoom."Resource No.");
                    ResJnlLine."Resource No." := Resource."No.";
                    ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
                    ResJnlLine.Quantity := SMBSeminarRegHeader."Duration Days";
                    ResJnlLine."Qty. per Unit of Measure" := 1;
                    ResJnlLine."Unit Cost" := Resource."Unit Cost";
                    ResJnlLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
                end;
        end;
        ResJnlPostLine.RunWithCheck(ResJnlLine);
        // letzten Ressourcenposten lesen und Lfd. Nr. holen
        // gelesene Nr. als Rückgabeweert in der Prozedur verwenden.
        ResLedgerEntry.FindLast();
        exit(ResLedgerEntry."Entry No.");

    end;

    local procedure PostSemJnlLine(ChargeType: Enum "SMB Sem. Ledger Charge Type";
                            var SMBSeminarRegHeader: Record "SMB Seminar Reg. Header";
                            var SMBSeminarRegLine: Record "SMB Seminar Reg. Line";
                            LastResLedgEntryNo: Integer)
    var
        SMBInstructor: Record "SMB Instructor";
        SMBSeminarRoom: Record "SMB Seminar Room";
        SMBSeminarJournalLine: Record "SMB Seminar Journal Line";
        SMBSemJnlPostLine: Codeunit "SMB Sem. Jnl.-Post Line";
    begin
        SMBSeminarJournalLine.Init();
        // Gemeinsame Felder        
        SMBSeminarJournalLine."Seminar No." := SMBSeminarRegHeader."Seminar No.";
        SMBSeminarJournalLine."Posting Date" := SMBSeminarRegHeader."Posting Date";
        SMBSeminarJournalLine."Document Date" := SMBSeminarRegHeader."Document Date";
        SMBSeminarJournalLine."Entry Type" := SMBSeminarJournalLine."Entry Type"::Registration;
        SMBSeminarJournalLine."Document No." := SMBSeminarRegHeader."Posting No.";
        SMBSeminarJournalLine."Starting Date" := SMBSeminarRegHeader."Starting Date";
        SMBSeminarJournalLine."Seminar Registration No." := SMBSeminarRegHeader."No.";
        SMBSeminarJournalLine."Source Type" := SMBSeminarJournalLine."Source Type"::Seminar;
        SMBSeminarJournalLine."Source No." := SMBSeminarRegHeader."Seminar No.";
        SMBSeminarJournalLine."Source Code" := SrcCode;
        SMBSeminarJournalLine."Reason Code" := SMBSeminarRegHeader."Reason Code";
        SMBSeminarJournalLine."Posting No. Series" := SMBSeminarRegHeader."Posting No. Series";
        SMBSeminarJournalLine."Res. Ledger Entry No." := LastResLedgEntryNo;
        LastResLedgEntryNo := 0;
        // Zusätzlich sollen die Buchungsgruppen in die Buchblattzeile übergeben werden
        // Anforderung für die Fakturierung, damit auf das Sachkonto aus der Buchungsmatrix gebucht werden kann
        SMBSeminarJournalLine."Gen. Prod. Posting Group" := SMBSeminarRegHeader."Gen. Prod. Posting Group";
        SMBSeminarJournalLine."VAT Prod. Posting Group" := SMBSeminarRegHeader."VAT Prod. Posting Group";

        case ChargeType of
            ChargeType::Instructor:
                begin
                    SMBSeminarJournalLine."Charge Type" := ChargeType;
                    SMBSeminarJournalLine.Chargeable := false;
                    SMBInstructor.Get(SMBSeminarRegHeader."Instructor Code");
                    SMBSeminarJournalLine."Instructor Code" := SMBInstructor.Code;
                    SMBSeminarJournalLine.Description := SMBInstructor.Name;
                    SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                    SMBSeminarJournalLine.Quantity := SMBSeminarRegHeader."Duration Days";
                    // Dimensionen aus dem Kopf
                    SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
                end;
            ChargeType::Room:
                begin
                    SMBSeminarJournalLine."Charge Type" := ChargeType;
                    SMBSeminarJournalLine.Chargeable := false;
                    SMBSeminarRoom.Get(SMBSeminarRegHeader."Room Code");
                    SMBSeminarJournalLine."Seminar Room Code" := SMBSeminarRoom.Code;
                    SMBSeminarJournalLine.Description := SMBSeminarRoom.Name;
                    SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                    SMBSeminarJournalLine.Quantity := SMBSeminarRegHeader."Duration Days";
                    // Dimensionen aus dem Kopf
                    SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegHeader."Dimension Set ID";
                end;
            ChargeType::Participant:
                begin
                    SMBSeminarJournalLine."Charge Type" := ChargeType;
                    SMBSeminarJournalLine.Chargeable := SMBSeminarRegLine."To Invoice";
                    SMBSeminarRegLine.CalcFields("Participant Name");
                    SMBSeminarJournalLine.Description := SMBSeminarRegLine."Participant Name";
                    SMBSeminarJournalLine."Participant Name" := SMBSeminarRegLine."Participant Name";
                    SMBSeminarJournalLine."Participant Contact No." := SMBSeminarRegLine."Participant Contact No.";
                    SMBSeminarJournalLine."Bill-to Customer No." := SMBSeminarRegLine."Bill-to Customer No.";
                    SMBSeminarJournalLine.Type := SMBSeminarJournalLine.Type::Resource;
                    SMBSeminarJournalLine.Quantity := 1;
                    SMBSeminarJournalLine."Unit Price" := SMBSeminarRegLine."Line Amount (LCY)"; //aktuell nur Mandantenwährung
                    SMBSeminarJournalLine."Total Price" := SMBSeminarRegLine."Line Amount (LCY)";//aktuell nur Mandantenwährung
                    SMBSeminarJournalLine.Chargeable := SMBSeminarRegLine."To Invoice";
                    SMBSeminarJournalLine."Instructor Code" := SMBSeminarRegHeader."Instructor Code";
                    // Zusätzlich sollen die Buchungsgruppen in die Buchblattzeile übergeben werden
                    // Anforderung für die Fakturierung, damit auf das Sachkonto aus der Buchungsmatrix gebucht werden kann
                    SMBSeminarJournalLine."Gen. Bus. Posting Group" := SMBSeminarRegLine."Gen. Bus. Posting Group";
                    SMBSeminarJournalLine."VAT Bus. Posting Group" := SMBSeminarRegLine."VAT Bus. Posting Group";
                    // Dimensionen aus der Zeile
                    SMBSeminarJournalLine."Dimension Set ID" := SMBSeminarRegLine."Dimension Set ID";
                end;

        end;
        SMBSemJnlPostLine.RunWithCheck(SMBSeminarJournalLine);
    end;


}