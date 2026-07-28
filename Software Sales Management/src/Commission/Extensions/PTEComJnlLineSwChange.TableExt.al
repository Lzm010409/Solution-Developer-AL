tableextension 63603 "PTE Com. Jnl. Line Sw. Change" extends "PTE Commission Journal Line"
{
    fields
    {
        field(63610; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'This is the number of the posted software change the commission journal line originates from.', Comment = 'de-DE=Dies ist die Nummer der gebuchten Softwareanpassung, aus der die Provisions Buch.-Blattzeile stammt.';
        }
        field(63611; "PTE Accounting Type"; Enum "PTE Accounting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Accounting Type', Comment = 'de-DE=PTE Abrechnungsart';
            ToolTip = 'This is the accounting type taken from the software change. It controls whether the commission percentage of the commission contract or of the software change applies.', Comment = 'de-DE=Dies ist die aus der Softwareanpassung übernommene Abrechnungsart. Sie steuert, ob der Provisions Prozentsatz des Provisionsvertrags oder der Softwareanpassung gilt.';
        }
        field(63612; "PTE Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Caption = 'PTE Commission Percentage', Comment = 'de-DE=PTE Provision Prozentsatz';
            ToolTip = 'This is the deviating commission percentage taken from the software change.', Comment = 'de-DE=Dies ist der abweichende Provisions Prozentsatz aus der Softwareanpassung.';
        }
    }
}
