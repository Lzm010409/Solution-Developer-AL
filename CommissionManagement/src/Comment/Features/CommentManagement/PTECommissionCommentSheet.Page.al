page 63024 "PTE Commission Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Commission Comment Sheet', Comment = 'de-DE=Provisions Kommentarblatt';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "PTE Commission Comment Line";

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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine();
    end;
}

