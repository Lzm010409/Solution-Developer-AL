page 63021 "PTE Commission Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "PTE Commission Contract";
    Caption = 'Commission Contract Card', Comment = 'de-DE=Provisionsvertrag Karte';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    Caption = 'Contract No.', Comment = 'de-DE=Vertragsnummer';
                    ToolTip = 'This is the unique number of the Commission Contract.', Comment = 'de-DE=Die eindeutige Nummer des Provisions Vertrags.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = 'de-DE=Beschreibung';
                    ToolTip = 'This is the description of the Commission Contract.', Comment = 'de-DE=Die Beschreibung des Provisions Vertrags.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status', Comment = 'de-DE=Status';
                    ToolTip = 'This is the status of the Commission Contract.', Comment = 'de-DE=Der Status des Provisions Vertrags.';
                }
                field("Commission Type Code"; Rec."Commission Type Code")
                {
                    Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
                    ToolTip = 'This is the commission type of the Commission Contract.', Comment = 'de-DE=Die Provisionsart des Provisions Vertrags.';
                }
                field("Commission Type Description"; Rec."Commission Type Description")
                {
                    Caption = 'Commission Type Description', Comment = 'de-DE=Provisionsart Beschreibung';
                    ToolTip = 'This is the description of the commission type of the Commission Contract.', Comment = 'de-DE=Die Beschreibung der Provisionsart des Provisions Vertrags.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                    ToolTip = 'This is the starting date of the Commission Contract.', Comment = 'de-DE=Das Startdatum des Provisions Vertrags.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                    ToolTip = 'This is the ending date of the Commission Contract.', Comment = 'de-DE=Das Enddatum des Provisions Vertrags.';
                }
                field("Commission Comment"; Rec."Comment")
                {
                    Caption = 'Commission Comment', Comment = 'de-DE=Bemerkung';
                    ToolTip = 'This indicates whether there is a comment for the Commission Contract.', Comment = 'de-DE=Ist ein Kommentar vorhanden.';
                    ;
                }
            }
            group(Payout)
            {
                Caption = 'Payout', Comment = 'de-DE=Auszahlung';

                field("Commission Percentage"; Rec."Commission Percentage")
                {
                    Caption = 'Commission Percentage', Comment = 'de-DE=Provisions Prozentsatz';
                    ToolTip = 'This is the commission percentage of the Commission Contract.', Comment = 'de-DE=Der Provisions Prozentsatz des Provisions Vertrags.';
                }
                field("Pay Commission Bonus"; Rec."Pay Commission Bonus")
                {
                    Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus auszahlen';
                    ToolTip = 'This indicates whether to Pay Commission Bonus for the Commission Contract.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus für den Provisions Vertrag ausgezahlt werden soll.';
                }
                field("Target Achievement Amount"; Rec."Target Achievement Amount")
                {
                    Caption = 'Target Achievement Amount', Comment = 'de-DE=Zielerreichungsbetrag';
                    ToolTip = 'This is the target achievement amount of the Commission Contract.', Comment = 'de-DE=Der Zielerreichungsbetrag des Provisions Vertrags.';
                }
                field("Commission Bonus Amount"; Rec."Commission Bonus Amount")
                {
                    Caption = 'Commission Bonus Amount', Comment = 'de-DE=Provisionsbonus Betrag';
                    ToolTip = 'This is the commission bonus amount of the Commission Contract.', Comment = 'de-DE=Der Provisionsbonus Betrag des Provisions Vertrags.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(CommissionContractGroup)
            {
                Caption = 'Commission Contract', Comment = 'de-DE=Provisionsvertrag';
                Image = Document;
                action(CommentCommissionContractAction)
                {
                    Caption = 'Comment on Commission Contract', Comment = 'de-DE=Kommentar zum Provisionsvertrag';
                    ToolTip = 'Comment on the Commission Contract.', Comment = 'de-DE=Kommentar zum Provisionsvertrag.';
                    Image = ViewComments;
                    RunObject = Page "PTE Commission Comment Sheet";
                    RunPageLink = "Table Name" = const("PTE Comment Line Table Name"::"Commission Contract"),
                                  "No." = field("No.");


                }
                action(SalespersonContractAction)
                {
                    Caption = 'Salesperson', Comment = 'de-DE=Verkäufer';
                    ToolTip = 'View and manage the salespersons.', Comment = 'de-DE=Hierüber lässt sich die Liste der Verkäufer öffnen.';
                    Image = SalesPerson;
                    RunObject = Page "Salespersons/Purchasers";
                    RunPageLink = "PTE Commission Contract No." = field ("No.");
                }
            }
        }
        area(Promoted)
        {
            actionref("CommentCommissionContractRef"; CommentCommissionContractAction)
            {
            }
            actionref("SalesPersonContractRef"; SalespersonContractAction)
            {
            }
        }
    }

}