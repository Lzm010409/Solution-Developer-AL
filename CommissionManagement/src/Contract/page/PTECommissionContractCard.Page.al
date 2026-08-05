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
                    ToolTip = 'Specifies the unique number of the Commission Contract.', Comment = 'de-DE=Gibt die eindeutige Nummer des Provisionsvertrags an.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEditNoSeries(xRec) then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description', Comment = 'de-DE=Beschreibung';
                    ToolTip = 'Specifies the description of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung des Provisionsvertrags an.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status', Comment = 'de-DE=Status';
                    ToolTip = 'Specifies the status of the Commission Contract.', Comment = 'de-DE=Gibt den Status des Provisionsvertrags an.';
                }
                field("Commission Type Code"; Rec."Commission Type Code")
                {
                    Caption = 'Commission Type', Comment = 'de-DE=Provisionsart';
                    ToolTip = 'Specifies the commission type of the Commission Contract.', Comment = 'de-DE=Gibt die Provisionsart des Provisionsvertrags an.';
                }
                field("Commission Type Description"; Rec."Commission Type Description")
                {
                    Caption = 'Commission Type Description', Comment = 'de-DE=Provisionsart Beschreibung';
                    ToolTip = 'Specifies the description of the commission type of the Commission Contract.', Comment = 'de-DE=Gibt die Beschreibung der Provisionsart des Provisionsvertrags an.';
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Caption = 'Starting Date', Comment = 'de-DE=Startdatum';
                    ToolTip = 'Specifies the starting date of the Commission Contract.', Comment = 'de-DE=Gibt das Startdatum des Provisionsvertrags an.';
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Caption = 'Ending Date', Comment = 'de-DE=Enddatum';
                    ToolTip = 'Specifies the ending date of the Commission Contract.', Comment = 'de-DE=Gibt das Enddatum des Provisionsvertrags an.';
                }
                field("Commission Comment"; Rec."Comment")
                {
                    Caption = 'Commission Comment', Comment = 'de-DE=Bemerkung';
                    ToolTip = 'Specifies whether there is a comment for the Commission Contract.', Comment = 'de-DE=Gibt an, ob ein Kommentar zum Provisionsvertrag vorhanden ist.';
                }
            }
            group(Payout)
            {
                Caption = 'Payout', Comment = 'de-DE=Auszahlung';

                field("Commission Percentage"; Rec."Commission Percentage")
                {
                    ShowMandatory = true;
                    Caption = 'Commission Percentage', Comment = 'de-DE=Provisionsprozentsatz';
                    ToolTip = 'Specifies the commission percentage of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsprozentsatz des Provisionsvertrags an.';
                }
                field("Pay Commission Bonus"; Rec."Pay Commission Bonus")
                {
                    Caption = 'Pay Commission Bonus', Comment = 'de-DE=Provisionsbonus auszahlen';
                    ToolTip = 'Specifies whether to Pay Commission Bonus for the Commission Contract.', Comment = 'de-DE=Gibt an, ob der Provisionsbonus für den Provisionsvertrag ausgezahlt werden soll.';
                }
                field("Target Achievement Amount"; Rec."Target Achievement Amount")
                {
                    Caption = 'Target Achievement Amount', Comment = 'de-DE=Zielerreichungsbetrag';
                    ToolTip = 'Specifies the target achievement amount of the Commission Contract.', Comment = 'de-DE=Gibt den Zielerreichungsbetrag des Provisionsvertrags an.';
                }
                field("Commission Bonus Amount"; Rec."Commission Bonus Amount")
                {
                    Caption = 'Commission Bonus Amount', Comment = 'de-DE=Provisionsbonusbetrag';
                    ToolTip = 'Specifies the commission bonus amount of the Commission Contract.', Comment = 'de-DE=Gibt den Provisionsbonusbetrag des Provisionsvertrags an.';
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
            group(Category_Category4)
            {
                Caption = 'Commission Contract', Comment = 'de-DE=Provisionsvertrag';

                actionref("CommentCommissionContractRef"; CommentCommissionContractAction)
                {
                }
                actionref("SalesPersonContractRef"; SalespersonContractAction)
                {
                }
            }
        }
    }

}