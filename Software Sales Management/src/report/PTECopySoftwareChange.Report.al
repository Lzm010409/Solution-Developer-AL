report 63620 "PTE Copy Software Change"
{
    Caption = 'Copy Software Change', Comment = 'de-DE=Softwareanpassung kopieren';
    ApplicationArea = All;
    UsageCategory = None;
    ProcessingOnly = true;
    UseRequestPage = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'de-DE=Optionen';
                    InstructionalText = 'Specify the parameters used to copy the software change.', Comment = 'de-DE=Geben Sie die Parameter an, die zum Kopieren der Softwareanpassung herangezogen werden sollen.';

                    field(CopyComments; CopyComments)
                    {
                        ApplicationArea = All;
                        Caption = 'Copy Comments', Comment = 'de-DE=Kopiere Bemerkungen';
                        ToolTip = 'Specifies whether the comments of the original software change are copied.', Comment = 'de-DE=Gibt an, ob die Bemerkungen der ursprünglichen Softwareanpassung kopiert werden.';
                    }
                    group(CopyGroups)
                    {
                        Caption = 'Copy data of group:', Comment = 'de-DE=Kopiere Daten der Gruppe:';

                        field(CopyGeneral; CopyGeneral)
                        {
                            ApplicationArea = All;
                            Caption = 'General', Comment = 'de-DE=Allgemein';
                            ToolTip = 'Specifies whether the fields of the General group are copied.', Comment = 'de-DE=Gibt an, ob die Felder der Gruppe Allgemein kopiert werden.';
                        }
                        field(CopyInvoicing; CopyInvoicing)
                        {
                            ApplicationArea = All;
                            Caption = 'Invoicing', Comment = 'de-DE=Fakturierung';
                            ToolTip = 'Specifies whether the fields of the Invoicing group are copied.', Comment = 'de-DE=Gibt an, ob die Felder der Gruppe Fakturierung kopiert werden.';
                        }
                        field(CopyContactPerson; CopyContactPerson)
                        {
                            ApplicationArea = All;
                            Caption = 'Contact Person', Comment = 'de-DE=Kontaktperson';
                            ToolTip = 'Specifies whether the fields of the Contact Person group are copied.', Comment = 'de-DE=Gibt an, ob die Felder der Gruppe Kontaktperson kopiert werden.';
                        }
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            CopyGeneral := true;
            CopyInvoicing := true;
            CopyContactPerson := true;
        end;
    }

    var
        FromSoftwareChange: Record "PTE Software Change";
        CopyComments: Boolean;
        CopyGeneral: Boolean;
        CopyInvoicing: Boolean;
        CopyContactPerson: Boolean;
        CopiedMsg: Label 'The software change %1 has been copied to the new software change %2.', Comment = 'de-DE=Die Softwareanpassung %1 wurde in die neue Softwareanpassung %2 kopiert.';


    procedure SetSourceSoftwareChange(SoftwareChange: Record "PTE Software Change")
    begin
        FromSoftwareChange := SoftwareChange;
    end;

    trigger OnPostReport()
    var
        ToSoftwareChange: Record "PTE Software Change";
        CopySoftwareChange: Codeunit "PTE Copy Software Change";
    begin
        FromSoftwareChange.TestField("No.");
        CopySoftwareChange.CopySoftwareChange(
            FromSoftwareChange, ToSoftwareChange, CopyComments, CopyGeneral, CopyInvoicing, CopyContactPerson);

        if GuiAllowed() then
            Message(CopiedMsg, FromSoftwareChange."No.", ToSoftwareChange."No.");
    end;
}
