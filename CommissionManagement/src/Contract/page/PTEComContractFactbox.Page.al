page 63022 "PTE Com. Contract Factbox"
{
    ApplicationArea = All;
    Caption = 'Commission Contract Details', Comment = 'de-DE=Provisionsvertrag Details';
    PageType = CardPart;
    SourceTable = "PTE Commission Contract";

    layout
    {
        area(Content)
        {

            field(Description; InformationArr[1])
            {
                Caption = 'Description', Comment = 'de-DE=Beschreibung';
                ToolTip = 'Specifies the description of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung des Provisions Vertrags an.';
            }
            field("Commission Type Description"; InformationArr[2])
            {
                Caption = 'Commission Type Description', Comment = 'de-DE=Provisionsart Beschreibung';
                ToolTip = 'Specifies the description of the commission type of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung der Provisionsart des Provisions Vertrags an.';
            }
            field("Starting Date"; InformationArr[3])
            {
                Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                ToolTip = 'Specifies the starting date of the Commission Contract.', Comment = 'de-DE=Gibt das Startdatum des Provisions Vertrags an.';
            }
            field("Ending Date"; InformationArr[4])
            {
                Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                ToolTip = 'Specifies the ending date of the Commission Contract.', Comment = 'de-DE=Gibt das Enddatum des Provisions Vertrags an.';
            }
            field("Commission Percentage"; InformationArr[5])
            {
                Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
                ToolTip = 'Specifies the commission percentage of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsprozentsatz des Provisions Vertrags an.';
            }
            field("Pay Commission Bonus"; InformationArr[6])
            {
                Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus zahlen';
                ToolTip = 'Specifies whether the commission bonus should be paid.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus gezahlt werden soll.';
            }
            field(Status; InformationArr[7])
            {
                Caption = 'Status', Comment = 'de-DE=Status';
                ToolTip = 'Specifies the status of the Commission Contract.', Comment = 'de-DE=Gibt den Status des Provisions Vertrags an.';
             }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.Validate("Commission Type Code");
        InformationArr[1] := Rec.Description;
        InformationArr[2] := Rec."Commission Type Description";
        InformationArr[3] := Format(Rec."Starting Date");
        InformationArr[4] := Format(Rec."Ending Date");
        InformationArr[5] := Format(Rec."Commission Percentage");
        InformationArr[6] := Format(Rec."Pay Commission Bonus");
        InformationArr[7] := Format(Rec.Status);
    end;

    var
        InformationArr: array[7] of Text[100];
}
