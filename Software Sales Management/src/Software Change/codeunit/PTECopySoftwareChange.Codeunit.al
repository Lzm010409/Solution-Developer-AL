codeunit 63612 "PTE Copy Software Change"
{
    procedure CopySoftwareChange(FromSoftwareChange: Record "PTE Software Change"; var ToSoftwareChange: Record "PTE Software Change"; CopyComments: Boolean; CopyGeneral: Boolean; CopyInvoicing: Boolean; CopyContactPerson: Boolean)
    begin
        ToSoftwareChange.Init();
        ToSoftwareChange."No." := '';
        ToSoftwareChange.Insert(true);

        if CopyGeneral then
            CopyGeneralGroup(FromSoftwareChange, ToSoftwareChange);
        if CopyInvoicing then
            CopyInvoicingGroup(FromSoftwareChange, ToSoftwareChange);
        if CopyContactPerson then
            CopyContactPersonGroup(FromSoftwareChange, ToSoftwareChange);

        ToSoftwareChange.Modify(true);

        if CopyComments then
            CopyCommentLines(FromSoftwareChange, ToSoftwareChange);
    end;

    local procedure CopyGeneralGroup(FromSoftwareChange: Record "PTE Software Change"; var ToSoftwareChange: Record "PTE Software Change")
    begin
        ToSoftwareChange."Software Change Template Code" := FromSoftwareChange."Software Change Template Code";
        ToSoftwareChange.Description := FromSoftwareChange.Description;
        ToSoftwareChange."Entry Date" := FromSoftwareChange."Entry Date";
        ToSoftwareChange."Closing Date" := FromSoftwareChange."Closing Date";
        ToSoftwareChange.Status := FromSoftwareChange.Status;
        ToSoftwareChange.Priority := FromSoftwareChange.Priority;
    end;

    local procedure CopyInvoicingGroup(FromSoftwareChange: Record "PTE Software Change"; var ToSoftwareChange: Record "PTE Software Change")
    begin
        ToSoftwareChange."Salesperson Code" := FromSoftwareChange."Salesperson Code";
        ToSoftwareChange."Customer No." := FromSoftwareChange."Customer No.";
        ToSoftwareChange."Gen. Bus. Posting Group" := FromSoftwareChange."Gen. Bus. Posting Group";
        ToSoftwareChange."VAT Bus. Posting Group" := FromSoftwareChange."VAT Bus. Posting Group";
        ToSoftwareChange."Developer Resource No." := FromSoftwareChange."Developer Resource No.";
        ToSoftwareChange."Quantity Implementation (hrs)" := FromSoftwareChange."Quantity Implementation (hrs)";
        ToSoftwareChange."Accounting Type" := FromSoftwareChange."Accounting Type";
        ToSoftwareChange."Commission Percentage" := FromSoftwareChange."Commission Percentage";
    end;

    local procedure CopyContactPersonGroup(FromSoftwareChange: Record "PTE Software Change"; var ToSoftwareChange: Record "PTE Software Change")
    begin
        ToSoftwareChange."Contact No." := FromSoftwareChange."Contact No.";
        ToSoftwareChange."Contact Name" := FromSoftwareChange."Contact Name";
        ToSoftwareChange."Contact Phone No." := FromSoftwareChange."Contact Phone No.";
        ToSoftwareChange."Contact E-Mail" := FromSoftwareChange."Contact E-Mail";
    end;

    local procedure CopyCommentLines(FromSoftwareChange: Record "PTE Software Change"; ToSoftwareChange: Record "PTE Software Change")
    var
        SoftwareChange: Codeunit "PTE Software Change";
    begin
        SoftwareChange.CopyComments(
            "Comment Line Table Name"::"PTE Software Change",
            "Comment Line Table Name"::"PTE Software Change",
            FromSoftwareChange."No.",
            ToSoftwareChange."No.");
    end;
}
