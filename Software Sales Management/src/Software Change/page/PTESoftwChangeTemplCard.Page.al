page 63602 "PTE Softw. Change Templ. Card"
{
    PageType = Card;
    SourceTable = "PTE Software Change Template";
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Software Change Template', Comment = 'de-DE=Softwareanpassungsvorlage';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'de-DE=Allgemein';

                field("Code"; Rec."Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing', Comment = 'de-DE=Fakturierung';

                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("Developer Resource No."; Rec."Developer Resource No.")
                {
                }
                field("Accounting Type"; Rec."Accounting Type")
                {
                }
                field("Commission Percentage"; Rec."Commission Percentage")
                {
                }
            }
        }
    }
}
