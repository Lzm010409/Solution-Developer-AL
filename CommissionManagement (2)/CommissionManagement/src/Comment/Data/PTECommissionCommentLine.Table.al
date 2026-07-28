table 63021 "PTE Commission Comment Line"
{
    DataClassification = CustomerContent;
    
    fields
    {
        field(1; "Table Name"; Enum "PTE Comment Line Table Name")
        {
            DataClassification = CustomerContent;
            Caption = 'Table Name', Comment = 'de-DE=Tabellenname';
            ToolTip = 'This is the Table Name of the Commission Comment Line.', Comment = 'de-DE=Dies ist der Tabellenname der Provisionskommentarzeile.';
            NotBlank = true;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.', Comment = 'de-DE=Vertrags Nr.';
            ToolTip = 'This is the Contract No. of the Commission Comment Line.', Comment = 'de-DE=Dies ist die Vertrags Nr. des Provisionskommentarzeile.';
            NotBlank = true;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.', Comment = 'de-DE=Zeilennr.';
            ToolTip = 'This is the Line No. of the Commission Comment Line.', Comment = 'de-DE=Dies ist die Zeilennr. der Provisionskommentarzeile.';
            NotBlank = true;
        }
        field(10; "Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date', Comment = 'de-DE=Datum';
            ToolTip = 'This is the Date of the Commission Comment Line.', Comment = 'de-DE=Dies ist das Datum der Provisionskommentarzeile.';
        }
        field(20; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Code', Comment = 'de-DE=Code';
            ToolTip = 'This is the Code of the Commission Comment Line.', Comment = 'de-DE=Dies ist der Code der Provisionskommentarzeile.';
        }
        field(30; Comment; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment', Comment = 'de-DE=Kommentar';
            ToolTip = 'This is the Comment of the Commission Comment Line.', Comment = 'de-DE=Dies ist der Kommentar der Provisionskommentarzeile.';
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