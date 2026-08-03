tableextension 63600 "PTE Sales Header Sw. Change" extends "Sales Header"
{
    fields
    {
        field(63600; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'Specifies the PTE Software Change No. field added to the Sales Header table by the PTE Software Sales Management Extension. It carries no table relation because the software change is deleted when it is posted.', Comment = 'de-DE=Gibt das Feld PTE Softwareanpassungsnr. an, das die Erweiterung PTE Software Verkaufsmanagement zur Tabelle Verkaufskopf hinzufügt. Es hat keine Tabellenrelation, weil die Softwareanpassung beim Buchen gelöscht wird.';
        }
    }


    internal procedure UpdateSalesHeaderWithSoftwareChange(SoftwareChangeNo: Code[20])
    var
        SoftwareChange: Record "PTE Software Change";
        SalesLine: Record "Sales Line";
    begin
        "PTE Software Change No." := SoftwareChangeNo;
        if SoftwareChangeNo <> '' then
            if SoftwareChange.Get(SoftwareChangeNo) then
                if SoftwareChange."Customer No." <> '' then 
                    if Confirm(UpdateSalesHeaderQst, true) then begin
                        SalesLine.SetRange("Document Type", Rec."Document Type");
                        SalesLine.SetRange("Document No.", Rec."No.");
                        SalesLine.DeleteAll();
                        Rec.Validate("Sell-to Customer No.", SoftwareChange."Customer No.");
                        Rec.Validate("Posting Date", WorkDate());
                        Rec.Validate("Document Date", WorkDate());
                        Rec.Validate("Salesperson Code", SoftwareChange."Salesperson Code");
                        Rec.Validate("Gen. Bus. Posting Group", SoftwareChange."Gen. Bus. Posting Group");
                        Rec.Validate("VAT Bus. Posting Group", SoftwareChange."VAT Bus. Posting Group");
                        if SoftwareChange."Contact No." <> '' then
                            Rec.Validate("Sell-to Contact No.", SoftwareChange."Contact No.");
                        Rec.Modify();
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", Rec."Document Type");
                        SalesLine.Validate("Document No.", Rec."No.");
                        SalesLine."Line No." := 10000;
                        SalesLine.Insert(true);

                        SalesLine.Validate(Type, SalesLine.Type::Resource);
                        SalesLine.Validate("No.", SoftwareChange."Developer Resource No.");
                        SalesLine.Validate(Quantity, SoftwareChange."Quantity Implementation (hrs)");
                        SalesLine.Description := SoftwareChange.Description;
                        SalesLine.Modify(true);
                end;
    end;

    var 
        UpdateSalesHeaderQst: Label 'Do you want to update the sales header with the data from the software change?', Comment = 'de-DE=Möchten Sie den Verkaufskopf mit den Daten aus der Softwareanpassung aktualisieren?';
}
