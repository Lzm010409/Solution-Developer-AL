codeunit 63001 "PTE Com. Mgt. Inst. Lib"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterManualSetup', '', false, false)]
    local procedure RegisterCommissionSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertManualSetup(
            TitelTxt,
            ShortTitelTxt,
            DescriptionTxt,
            5,
            ObjectType::Page,
            page::"PTE Commission Mgt. Setup Card",
            Enum::"Manual Setup Category"::Sales,
            ''
            );
    end;

    var
        TitelTxt: Label 'Commission Management Setup', Comment = 'de-DE=Einrichtung Provisionsmanagement';
        ShortTitelTxt: Label 'Commission Management', Comment = 'de-DE=Provisionsmanagement';
        DescriptionTxt: Label 'Setup the Commission Management to manage and calculate commissions for salespersons.', Comment = 'de-DE=Richten sie das Provisionsmanagement ein, es dient der Berechnung von Provisionen für Verkäufer.';
}