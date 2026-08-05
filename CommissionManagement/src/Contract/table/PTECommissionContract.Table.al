table 63020 "PTE Commission Contract"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Description;

    Caption = 'Commission Contract', Comment = 'de-DE=Provisionsvertrag';

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', Comment = 'de-DE=Nr.';
            ToolTip = 'Specifies the No. of the Commission Contract.', Comment = 'de-DE=Gibt die Nr. des Provisionsvertrags an.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'Specifies the Description of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung des Provisionsvertrags an.';
        }
        field(20; "Commission Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Commission Type";
            Caption = 'Commission Type Code', Comment = 'de-DE=Provisionsartcode';
            ToolTip = 'Specifies the Commission Type Code of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsartcode des Provisionsvertrags an.';
            trigger onValidate()
            begin
                CalcFields("Commission Type Description");
            end;
        }
        field(21; "Commission Type Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PTE Commission Type".Description where(Code = field("Commission Type Code")));
            Caption = 'Commission Type Description', Comment = 'de-DE=Provisionsartbeschreibung';
            ToolTip = 'Specifies the Commission Type Description of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung der Provisionsart des Provisionsvertrags an.';
            Editable = false;
        }
        field(30; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
            ToolTip = 'Specifies the Starting Date of the Commission Contract.', Comment = 'de-DE=Gibt das Startdatum des Provisionsvertrags an.';
            trigger OnValidate()
            var
                StartingDateErr: Label 'Starting Date cannot be after Ending Date.', Comment = 'de-DE=Startdatum darf nicht nach Enddatum liegen.';
            begin
                if ("Ending Date" <> 0D) and ("Starting Date" > "Ending Date") then
                    Error(StartingDateErr);
            end;
        }
        field(40; "Ending Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
            ToolTip = 'Specifies the Ending Date of the Commission Contract.', Comment = 'de-DE=Gibt das Enddatum des Provisionsvertrags an.';
            trigger OnValidate()
            var
                EndingDateErr: Label 'Ending Date cannot be before Starting Date.', Comment = 'de-DE=Enddatum darf nicht vor Startdatum liegen.';
            begin
                if ("Starting Date" = 0D) then
                    "Starting Date" := WorkDate();
                if ("Starting Date" <> 0D) and ("Ending Date" < "Starting Date") then
                    Error(EndingDateErr);
            end;
        }
        field(50; Status; Enum "PTE Commission Contract Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', Comment = 'de-DE=Status';
            ToolTip = 'Specifies the Status of the Commission Contract.', Comment = 'de-DE=Gibt den Status des Provisionsvertrags an.';
        }
        field(60; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
            MaxValue = 100;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provisionsprozentsatz';
            ToolTip = 'Specifies the Commission Percentage of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsprozentsatz des Provisionsvertrags an.';
        }
        field(70; "Pay Commission Bonus"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus auszahlen';
            ToolTip = 'Specifies whether to Pay Commission Bonus for the Commission Contract.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus für den Provisionsvertrag ausgezahlt werden soll.';
        }
        field(71; "Target Achievement Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            MinValue = 0;
            Caption = 'Target Achievement Amount', Comment = 'de-DE=Zielerreichungsbetrag';
            ToolTip = 'Specifies the Target Achievement Amount of the Commission Contract.', Comment = 'de-DE=Gibt den Zielerreichungsbetrag des Provisionsvertrags an.';
        }
        field(72; "Commission Bonus Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            AutoFormatType = 1;
            MinValue = 0;
            Caption = 'Commission Bonus Amount', Comment = 'de-DE=Provisionsbonusbetrag';
            ToolTip = 'Specifies the Commission Bonus Amount of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsbonusbetrag des Provisionsvertrags an.';
        }
        field(80; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("PTE Commission Comment Line" where("No." = field("No."), "Table Name" = const("PTE Comment Line Table Name"::"Commission Contract")));
            Caption = 'Comment', Comment = 'de-DE=Kommentar';
            ToolTip = 'Specifies whether there is a comment for this Commission Contract.', Comment = 'de-DE=Gibt an, ob es einen Kommentar für diesen Provisionsvertrag gibt.';
            Editable = false;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', Comment = 'de-DE=Nummernkreis';
            ToolTip = 'Specifies the No. Series of the Commission Contract.', Comment = 'de-DE=Gibt den Nummernkreis des Provisionsvertrags an.';
        }

    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        PTECommissionContractCodeunit: Codeunit "PTE Commission Contract";
    begin
        if PTECommissionContractCodeunit.HasRemainingSalesman(Rec."No.") then
            Error(OnDeleteRemainingSalespersonsErr);
        if PTECommissionContractCodeunit.HasLedgerEntries(Rec."No.") then
            Error(OnDeleteRemainingLedgerEntriesErr);
        PTECommissionContractCodeunit.DeleteCommentsForContract(Rec."No.");
    end;

    trigger OnInsert()
    var
        Setup: Record "PTE Commission Mgt. Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            Setup.Get('');
            Setup.TestField("Contract Nos.");
            "No. Series" := Setup."Contract Nos.";
            if NoSeries.AreRelated("No. Series", xrec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        end;

        if "Starting Date" = 0D then
            "Starting Date" := WorkDate();
    end;

    procedure AssistEditNoSeries(OldCommissionContract: Record "PTE Commission Contract"): Boolean
    var
        Setup: Record "PTE Commission Mgt. Setup";
        NoSeries: Codeunit "No. Series";
    begin
        Setup.Get('');
        Setup.TestField("Contract Nos.");
        if not NoSeries.LookupRelatedNoSeries(Setup."Contract Nos.", OldCommissionContract."No. Series", "No. Series") then
            exit(false);

        "No." := NoSeries.GetNextNo("No. Series", WorkDate());
        exit(true);
    end;

    var
        OnDeleteRemainingSalespersonsErr: Label 'There are still salespersons related to this commission contract. Please remove them from the contract first.', Comment = 'de-DE=Es gibt noch Vertriebsmitarbeiter, die mit diesem Provisionsvertrag verbunden sind. Bitte entferne diese von dem Vertrag zuerst.';
        OnDeleteRemainingLedgerEntriesErr: Label 'There are still commission ledger entries related to this commission contract. Commission ledger entries are never changed or deleted, so the contract cannot be deleted.', Comment = 'de-DE=Es gibt noch Provisionsposten, die zu diesem Provisionsvertrag gehören. Provisionsposten werden nie geändert oder gelöscht, daher lässt sich der Vertrag nicht löschen.';
}