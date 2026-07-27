page 123456705 "SMB Seminar Room Card"
{
    Caption = 'Seminar Room Card';
    SourceTable = "SMB Seminar Room";
    UsageCategory = None;
    ApplicationArea = All;
    PageType = Card;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {                    
                    Importance = Promoted;
                }
                field(Name; Rec.Name)
                {                    
                    Importance = Promoted;
                    ShowMandatory = true;

                }
                field("Name 2"; Rec."Name 2")
                {                    
                    Visible = false;
                    Importance = Additional;
                }
                field(Address; Rec.Address)
                {
                    
                }
                field("Address 2"; Rec."Address 2")
                {                    
                    Visible = false;
                    Importance = Additional;
                }
                field("Post Code"; Rec."Post Code")
                {                    
                    Importance = Promoted;
                }
                field(City; Rec.City)
                {                    
                    Importance = Promoted;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    
                }
                field(Contact; Rec.Contact)
                {                    
                    Importance = Promoted;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    
                }
                field(Blocked; Rec.Blocked)
                {
                    
                    Importance = Additional;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; Rec."Phone No.")
                {
                    
                    Importance = Promoted;
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    
                    Importance = Additional;
                    Visible = false;
                }
                field("Fax No."; Rec."Fax No.")
                {
                    
                    Importance = Additional;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    
                    Importance = Promoted;
                }
                field("Home Page"; Rec."Home Page")
                {
                    
                }
                field("Responsible Contact No."; Rec."Responsible Contact No.")
                {
                    
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Resource No."; Rec."Resource No.")
                {
                    
                    Importance = Promoted;
                }
            }
            group(Planing)
            {
                Caption = 'Planing';
                field("Internal/External"; Rec."Internal/External")
                {
                    
                    Importance = Promoted;
                }
                field("Max. Participants"; Rec."Max. Participants")
                {
                    
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links) {  }
            systempart(Notes; Notes) {  }
        }
    }
}