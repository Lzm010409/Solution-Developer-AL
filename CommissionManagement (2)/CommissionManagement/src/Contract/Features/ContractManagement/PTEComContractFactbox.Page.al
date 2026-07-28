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
                ToolTip = 'This is the description of the Commission Contract.', Comment = 'de-DE=Die Beschreibung des Provisions Vertrags.';
            }
            field("Commission Type Description"; InformationArr[2])
            {
                Caption = 'Commission Type Description', Comment = 'de-DE=Provisionsart Beschreibung';
                ToolTip = 'This is the description of the commission type of the Commission Contract.', Comment = 'de-DE=Die Beschreibung der Provisionsart des Provisions Vertrags.';
            }
            field("Starting Date"; InformationArr[3])
            {
                Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                ToolTip = 'This is the starting date of the Commission Contract.', Comment = 'de-DE=Das Startdatum des Provisions Vertrags.';
            }
            field("Ending Date"; InformationArr[4])
            {
                Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                ToolTip = 'This is the ending date of the Commission Contract.', Comment = 'de-DE=Das Enddatum des Provisions Vertrags.';
            }
            field("Commission Percentage"; InformationArr[5])
            {
                Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
                ToolTip = 'This is the commission percentage of the Commission Contract.', Comment = 'de-DE=Der Provisionsprozentsatz des Provisions Vertrags.';
            }
            field("Pay Commission Bonus"; InformationArr[6])
            {
                Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus zahlen';
                ToolTip = 'This indicates whether the commission bonus should be paid.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus gezahlt werden soll.';
            }
            field(Status; InformationArr[7])
            {
                Caption = 'Status', Comment = 'de-DE=Status';
                ToolTip = 'This is the status of the Commission Contract.', Comment = 'de-DE=Der Status des Provisions Vertrags.';
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
