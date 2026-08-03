codeunit 63601 "PTE Software Sales Mgt. Inst."
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
            page::"PTE Softw. Sales Setup Card",
            Enum::"Manual Setup Category"::Sales,
            ''
            );
    end;

    var
        TitelTxt: Label 'Software Sales Management Setup', Comment = 'de-DE=Einrichtung Softwareverkauf';
        ShortTitelTxt: Label 'Software Sales Management', Comment = 'de-DE=Softwareverkauf';
        DescriptionTxt: Label 'Setup the Software Sales Management to manage and calculate sales for software products.', Comment = 'de-DE=Richten sie das Softwareverkauf management ein, es dient der Verwaltung und Berechnung von Softwareverkäufen.';
}