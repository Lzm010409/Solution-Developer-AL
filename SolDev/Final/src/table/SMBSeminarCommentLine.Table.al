

table 123456704 "SMB Seminar Comment Line"
{
    Caption = 'Seminar Comment Line';
    DrillDownPageID = "SMB Seminar Comment List";
    LookupPageID = "SMB Seminar Comment List";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document Type"; Enum "SMB Sem. Comment Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
            ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Date"; Date)
        {
            Caption = 'Date';
            ToolTip = 'Specifies the date the comment was created.';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
            ToolTip = 'Specifies a code for the comment.';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
            ToolTip = 'Specifies the comment itself.';
        }
        field(7; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetUpNewLine()
    var
        SeminarCommentLine: Record "SMB Seminar Comment Line";
    begin
     
        SeminarCommentLine.SetRange("Document Type", "Document Type");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.SetRange("Document Line No.", "Document Line No.");
        SeminarCommentLine.SetRange(Date, WorkDate());
        if SeminarCommentLine.IsEmpty then
            Date := WorkDate();
      
    end;

    procedure CopyComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLine: Record "SMB Seminar Comment Line";
        SeminarCommentLine2: Record "SMB Seminar Comment Line";
      
    begin
       
        SeminarCommentLine.SetRange("Document Type", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet() then
            repeat
                SeminarCommentLine2 := SeminarCommentLine;
                SeminarCommentLine2."Document Type" := Enum::"SMB Sem. Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLine2."No." := ToNumber;
              
                SeminarCommentLine2.Insert();
            until SeminarCommentLine.Next() = 0;
    end;

    procedure CopyLineComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; FromDocumentLineNo: Integer; ToDocumentLineNo: Integer)
    var
        SeminarCommentLineSource: Record "SMB Seminar Comment Line";
        SeminarCommentLineTarget: Record "SMB Seminar Comment Line";
       
    begin
       

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", FromDocumentLineNo);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := Enum::"SMB Sem. Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget."Document Line No." := ToDocumentLineNo;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    procedure CopyLineCommentsFromSeminarLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]; var TempSeminarLineSource: Record "SMB Seminar Reg. Line" temporary)
    var
        SeminarCommentLineSource: Record "SMB Seminar Comment Line";
        SeminarCommentLineTarget: Record "SMB Seminar Comment Line";
      
        NextLineNo: Integer;
    begin       

        SeminarCommentLineTarget.SetRange("Document Type", ToDocumentType);
        SeminarCommentLineTarget.SetRange("No.", ToNumber);
        SeminarCommentLineTarget.SetRange("Document Line No.", 0);
        if SeminarCommentLineTarget.FindLast() then;
        NextLineNo := SeminarCommentLineTarget."Line No." + 10000;
        SeminarCommentLineTarget.Reset();

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        if TempSeminarLineSource.FindSet() then
            repeat
                SeminarCommentLineSource.SetRange("Document Line No.", TempSeminarLineSource."Line No.");
                if SeminarCommentLineSource.FindSet() then
                    repeat
                        SeminarCommentLineTarget := SeminarCommentLineSource;
                        SeminarCommentLineTarget."Document Type" := Enum::"SMB Sem. Comment Document Type".FromInteger(ToDocumentType);
                        SeminarCommentLineTarget."No." := ToNumber;
                        SeminarCommentLineTarget."Document Line No." := 0;
                        SeminarCommentLineTarget."Line No." := NextLineNo;
                        SeminarCommentLineTarget.Insert();
                        NextLineNo += 10000;
                    until SeminarCommentLineSource.Next() = 0;
            until TempSeminarLineSource.Next() = 0;
    end;

    procedure CopyHeaderComments(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    var
        SeminarCommentLineSource: Record "SMB Seminar Comment Line";
        SeminarCommentLineTarget: Record "SMB Seminar Comment Line";
        
    begin
       

        SeminarCommentLineSource.SetRange("Document Type", FromDocumentType);
        SeminarCommentLineSource.SetRange("No.", FromNumber);
        SeminarCommentLineSource.SetRange("Document Line No.", 0);
        if SeminarCommentLineSource.FindSet() then
            repeat
                SeminarCommentLineTarget := SeminarCommentLineSource;
                SeminarCommentLineTarget."Document Type" := Enum::"SMB Sem. Comment Document Type".FromInteger(ToDocumentType);
                SeminarCommentLineTarget."No." := ToNumber;
                SeminarCommentLineTarget.Insert();
            until SeminarCommentLineSource.Next() = 0;
    end;

    procedure DeleteComments(DocType: Enum "SMB Sem. Comment Document Type"; DocNo: Code[20])
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        if not IsEmpty() then
            DeleteAll();
    end;

    procedure ShowComments(DocType: Enum "SMB Sem. Comment Document Type"; DocNo: Code[20]; DocLineNo: Integer)
    var
        SeminarCommentSheet: Page "SMB Seminar Comment Sheet";
    begin
        SetRange("Document Type", DocType);
        SetRange("No.", DocNo);
        SetRange("Document Line No.", DocLineNo);
        Clear(SeminarCommentSheet);
        SeminarCommentSheet.SetTableView(Rec);
        SeminarCommentSheet.RunModal();
    end;

    
}

