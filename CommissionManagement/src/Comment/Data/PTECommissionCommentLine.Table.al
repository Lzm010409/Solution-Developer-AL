table 63021 "PTE Commission Comment Line"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Table Name"; Enum "PTE Comment Line Table Name")
        {
            DataClassification = CustomerContent;
            Caption = 'Table Name', Comment = 'de-DE=Tabellenname';
            ToolTip = 'Specifies the Table Name of the Commission Comment Line.', Comment = 'de-DE=Gibt den Tabellenname der Provisionskommentarzeile an.';
            NotBlank = true;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.', Comment = 'de-DE=Vertrags Nr.';
            ToolTip = 'Specifies the Contract No. of the Commission Comment Line.', Comment = 'de-DE=Gibt die Vertrags Nr. des Provisionskommentarzeile an.';
            NotBlank = true;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', Comment = 'de-DE=Zeilennr.';
            ToolTip = 'Specifies the Line No. of the Commission Comment Line.', Comment = 'de-DE=Gibt die Zeilennr. der Provisionskommentarzeile an.';
            NotBlank = true;
        }
        field(10; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', Comment = 'de-DE=Datum';
            ToolTip = 'Specifies the Date of the Commission Comment Line.', Comment = 'de-DE=Gibt das Datum der Provisionskommentarzeile an.';
        }
        field(20; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', Comment = 'de-DE=Code';
            ToolTip = 'Specifies the Code of the Commission Comment Line.', Comment = 'de-DE=Gibt den Code der Provisionskommentarzeile an.';
        }
        field(30; Comment; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', Comment = 'de-DE=Kommentar';
            ToolTip = 'Specifies the Comment of the Commission Comment Line.', Comment = 'de-DE=Gibt den Kommentar der Provisionskommentarzeile an.';
        }
    }
    
    keys
    {
        key(PK; "Table Name", "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure SetUpNewLine()
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetRange("Table Name", "Table Name");
        CommentLine.SetRange("No.", "No.");
        CommentLine.SetRange(Date, WorkDate());
        if not CommentLine.IsEmpty() then
            Date := WorkDate();
    end;
    
    
}