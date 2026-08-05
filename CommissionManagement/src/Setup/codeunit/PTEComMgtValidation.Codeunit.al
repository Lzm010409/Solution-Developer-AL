codeunit 63000 "PTE Com. Mgt. Validation"
{
    trigger OnRun()
    begin
        if not PTECommissionManagement.FindFirst() then
            Error(PTECommissionManagementSetupNotPresentErr);
    end;

    var
        PTECommissionManagement: Record "PTE Commission Mgt. Setup";
        PTECommissionManagementSetupNotPresentErr: Label 'PTE Commission Management Setup record is not present. Please run the setup to initialize the setup record.', Comment = 'de-DE=Der Einrichtungsdatensatz für die Provisionsverwaltung ist nicht vorhanden. Bitte führen Sie die Einrichtung aus, um den Einrichtungsdatensatz zu initialisieren.';
}