table 63600 "PTE Software Sales Mgt. Setup"
{
    DataClassification = CustomerContent;
    Caption = 'Software Sales Management Setup', Comment = 'de-DE=Software Verkaufsmanagement Einrichtung';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary Key', Comment = 'de-DE=Primärschlüssel';
            ToolTip = 'Specifies the Primary Key of the Datapoint.', Comment = 'de-DE=Gibt Primärschlüssel des Datensatzes an.';
        }
        field(10; "Software Change Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Software Change Nos.', Comment = 'de-DE=Softwareanpassung Nummernkreis';
            ToolTip = 'Specifies the code for the number series that will be used to assign numbers to software changes.', Comment = 'de-DE=Gibt den Code für den Nummernkreis an, der verwendet wird, um Nummern für Softwareanpassungen zu vergeben.';
        }
        field(20; "Posted Software Change Nos."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'Posted Software Change Nos.', Comment = 'de-DE=Geb. Softwareanpassung Nummernkreis';
            ToolTip = 'Specifies the code for the number series that will be used to assign numbers to posted software changes.', Comment = 'de-DE=Gibt den Code für den Nummernkreis an, der verwendet wird, um Nummern für gebuchte Softwareanpassungen zu vergeben.';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
