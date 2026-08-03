page 63023 "PTE Commission Comment List"
{
    AutoSplitKey = true;
    Caption = 'Commission Comment List', Comment = 'de-DE=Provisions Kommentarliste';
    DataCaptionFields = "No.";
    PageType = List;
    SourceTable = "PTE Commission Comment Line";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field("Date"; Rec.Date)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the date the comment was created.', Comment = 'de-DE=Gibt das Datum an, an dem der Kommentar erstellt wurde.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies the comment itself.', Comment = 'de-DE=Gibt den Kommentar selbst an.';
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Comments;
                    ToolTip = 'Specifies a code for the comment.', Comment = 'de-DE=Gibt einen Code für den Kommentar an.';
                    Visible = false;
                }
            }
        }
    }

}

