codeunit 63600 "PTE Softw. Sales Inst. Lib"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterManualSetup', '', false, false)]
    local procedure RegisterSoftwareSalesSetup()
    begin
        InsertManualSetup();
    end;

    local procedure InsertManualSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
    begin
        GuidedExperience.InsertManualSetup(
            TitelTxt,
            ShortTitelTxt,
            DescriptionTxt,
            5,
            ObjectType::Page,
            Page::"PTE Softw. Sales Setup Card",
            Enum::"Manual Setup Category"::Sales,
            '');
    end;

    var
        TitelTxt: Label 'Software Sales Management Setup', Comment = 'de-DE=Einrichtung Software Verkaufsmanagement';
        ShortTitelTxt: Label 'Software Sales Management', Comment = 'de-DE=Software Verkaufsmanagement';
        DescriptionTxt: Label 'Setup the Software Sales Management to record and invoice software changes.', Comment = 'de-DE=Richten Sie das Software Verkaufsmanagement ein, es dient der Erfassung und Abrechnung von Softwareanpassungen.';
}
