page 123456718 "SMB Contact Details Factbox"
{
    ApplicationArea = All;
    Caption = 'Contact Details';
    PageType = CardPart;
    SourceTable = Contact;

    layout
    {
        area(Content)
        {
            field("No."; Rec."No.")
            {
                Caption = 'Contact No.';
                ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                trigger OnDrillDown()
                begin
                    Page.Run(Page::"Contact Card",Rec);
                end;
            }
            field(Name; Rec.Name)
            {
                ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';
            }
            field(Address; Rec.Address)
            {
                ToolTip = 'Specifies the contact''s address.';
            }
            field("Address 2"; Rec."Address 2")
            {
                ToolTip = 'Specifies additional address information.';
            }
            field("Post Code"; Rec."Post Code")
            {
                ToolTip = 'Specifies the postal code.';
            }
            field(City; Rec.City)
            {
                ToolTip = 'Specifies the city where the contact is located.';
            }
            field("Phone No."; Rec."Phone No.")
            {
                ToolTip = 'Specifies the contact''s phone number.';
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ToolTip = 'Specifies the email address of the contact.';
            }
            field("Mobile Phone No."; Rec."Mobile Phone No.")
            {
                ToolTip = 'Specifies the contact''s mobile telephone number.';
            }
            field("Company No."; Rec."Company No.")
            {
                ToolTip = 'Specifies the number for the contact''s company.';
            }
            field("Company Name"; Rec."Company Name")
            {
                ToolTip = 'Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.';
            }
            field(Image; Rec.Image)
            {
                ToolTip = 'Specifies the picture of the contact, for example, a photograph if the contact is a person, or a logo if the contact is a company.';
            }
        }
    }
}

