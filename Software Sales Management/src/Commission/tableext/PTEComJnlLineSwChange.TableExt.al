tableextension 63603 "PTE Com. Jnl. Line Sw. Change" extends "PTE Commission Journal Line"
{
    fields
    {
        field(63610; "PTE Software Change No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Software Change No.', Comment = 'de-DE=PTE Softwareanpassungsnr.';
            ToolTip = 'Specifies the number of the posted software change the commission journal line originates from.', Comment = 'de-DE=Gibt die Nummer der gebuchten Softwareanpassung an, aus der die Provisions Buch.-Blattzeile stammt.';
        }
        field(63611; "PTE Accounting Type"; Enum "PTE Accounting Type")
        {
            DataClassification = CustomerContent;
            Caption = 'PTE Accounting Type', Comment = 'de-DE=PTE Abrechnungsart';
            ToolTip = 'Specifies the accounting type taken from the software change. It controls whether the commission percentage of the commission contract or of the software change applies.', Comment = 'de-DE=Gibt die aus der Softwareanpassung übernommene Abrechnungsart. Sie steuert an, ob der Provisions Prozentsatz des Provisionsvertrags oder der Softwareanpassung gilt.';
        }
        field(63612; "PTE Commission Percentage"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Caption = 'PTE Commission Percentage', Comment = 'de-DE=PTE Provision Prozentsatz';
            ToolTip = 'Specifies the deviating commission percentage taken from the software change.', Comment = 'de-DE=Gibt den abweichende Provisions Prozentsatz aus der Softwareanpassung an.';
        }
    }
}
