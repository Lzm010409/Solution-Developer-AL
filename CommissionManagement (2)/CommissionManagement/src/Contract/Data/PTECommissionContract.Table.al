table 63020 "PTE Commission Contract"
{
    DataClassification = CustomerContent;
    DataCaptionFields = "No.", Description;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.', Comment = 'de-DE=Nr.';
            ToolTip = 'This is the No. of the Commission Contract.', Comment = 'de-DE=Die Nr. des Provisions Vertrags.';
        }
        field(10; Description; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description', Comment = 'de-DE=Beschreibung';
            ToolTip = 'This is the Description of the Commission Contract.', Comment = 'de-DE=Die Beschreibung des Provisions Vertrags.';
        }
        field(20; "Commission Type Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "PTE Commission Type";
            Caption = 'Commission Type Code', Comment = 'de-DE=Provisions Typ Code';
            ToolTip = 'This is the Commission Type Code of the Commission Contract.', Comment = 'de-DE=Der Provisions Typ Code des Provisions Vertrags.';
            trigger onValidate()
            begin
                CalcFields("Commission Type Description");
            end;
        }
        field(21; "Commission Type Description"; Text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("PTE Commission Type".Description where(Code = field("Commission Type Code")));
            Caption = 'Commission Type Description', Comment = 'de-DE=Provisions Typ Beschreibung';
            ToolTip = 'This is the Commission Type Description of the Commission Contract.', Comment = 'de-DE=Die Beschreibung des Provisions Typs des Provisions Vertrags.';
            Editable = false;
        }
        field(30; "Starting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
            ToolTip = 'This is the Starting Date of the Commission Contract.', Comment = 'de-DE=Das Startdatum des Provisions Vertrags.';
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
            ToolTip = 'This is the Ending Date of the Commission Contract.', Comment = 'de-DE=Das Enddatum des Provisions Vertrags.';
            trigger OnValidate()
            var
                EndingDateErr: Label 'Ending Date cannot be before Starting Date.', Comment = 'de-DE=Enddatum darf nicht vor Startdatum liegen.';
            begin
                if("Starting Date" = 0D) then
                    "Starting Date" := Today;
                if ("Starting Date" <> 0D) and ("Ending Date" < "Starting Date") then
                    Error(EndingDateErr);
            end;
        }
        field(50; Status; Enum "PTE Commission Contract Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Status', Comment = 'de-DE=Status';
            ToolTip = 'This is the Status of the Commission Contract.', Comment = 'de-DE=Der Status des Provisions Vertrags.';
        }
        field(60; "Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
            ToolTip = 'This is the Commission Percentage of the Commission Contract.', Comment = 'de-DE=Der Provisions Prozentsatz des Provisions Vertrags.';
        }
        field(70; "Pay Commission Bonus"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus auszahlen';
            ToolTip = 'This indicates whether to Pay Commission Bonus for the Commission Contract.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus für den Provisions Vertrag ausgezahlt werden soll.';
        }
        field(71; "Target Achievement Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Target Achievement Amount', Comment = 'de-DE=Zielerreichungsbetrag';
            ToolTip = 'This is the Target Achievement Amount of the Commission Contract.', Comment = 'de-DE=Dies ist der Zielerreichungsbetrag des Provisions Vertrags.';
        }
        field(72; "Commission Bonus Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Commission Bonus Amount', Comment = 'de-DE=Provisionsbonus Betrag';
            ToolTip = 'This is the Commission Bonus Amount of the Commission Contract.', Comment = 'de-DE=Dies ist der Provisionsbonus Betrag des Provisions Vertrags.';
        }
        field(80; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist("PTE Commission Comment Line" where("No." = field("No."), "Table Name" = const("PTE Comment Line Table Name"::"Commission Contract")));
            Caption = 'Comment', Comment = 'de-DE=Kommentar';
            ToolTip = 'This indicates whether there is a comment for this Commission Contract.', Comment = 'de-DE=Gibt an, ob es einen Kommentar für diesen Provisions Vertrag gibt.';
            Editable = false;
        }
        field(107; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No. Series', Comment = 'de-DE=Nummernkreis';
            ToolTip = 'This is the No. Series of the Commission Contract.', Comment = 'de-DE=Dies ist der Nummernkreis des Provisions Vertrags.';
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
        PTECommissionContractCodeunit.ClearLedgerEntriesForContract(Rec."No.");
        if PTECommissionContractCodeunit.HasRemainingSalesman(Rec."No.") then
            Error(OnDeleteRemainingSalespersonsErr);
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
    end;

    /// <summary>
    /// Lets the user pick a related number series and draws the next number from it. Returns
    /// false when the user leaves the selection without choosing.
    /// </summary>
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
        OnDeleteRemainingSalespersonsErr: Label 'There are still salespersons related to this commission contract. Please remove them from the contract first.', Comment = 'de-DE=Es gibt noch Vertriebsmitarbeiter, die mit diesem Provisions Vertrag verbunden sind. Bitte entferne diese von dem Vertrag zuerst.';


}