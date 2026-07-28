page 63601 "PTE Software Change Templates"
{
    PageType = List;
    SourceTable = "PTE Software Change Template";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "PTE Softw. Change Templ. Card";
    Editable = false;
    Caption = 'Software Change Templates', Comment = 'de-DE=Softwareanpassungsvorlagen';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                }
                field("Commission Percentage"; Rec."Commission Percentage")
                {
                }
                field("Developer Resource No."; Rec."Developer Resource No.")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
            }
        }
    }
}
