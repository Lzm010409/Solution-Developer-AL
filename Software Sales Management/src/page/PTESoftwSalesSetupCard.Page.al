page 63600 "PTE Softw. Sales Setup Card"
{
    PageType = Card;
    SourceTable = "PTE Software Sales Mgt. Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'Software Sales Management Setup', Comment = 'de-DE=Software Verkaufsmanagement Einrichtung';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'de-DE=Allgemein';

                group(NumberSeries)
                {
                    Caption = 'Number Series', Comment = 'de-DE=Nummernserie';

                    field("Software Change Nos."; Rec."Software Change Nos.")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Posted Software Change Nos."; Rec."Posted Software Change Nos.")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            group(PTESoftwareChange)
            {
                Caption = 'Software Change', Comment = 'de-DE=Softwareanpassung';
                ToolTip = 'Navigate to software sales management related pages.', Comment = 'de-DE=Hierüber lässt sich zu den Seiten rund um das Software Verkaufsmanagement navigieren.';

                action(PTESoftwareChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Software Changes', Comment = 'de-DE=Softwareanpassungen';
                    ToolTip = 'View and manage software changes.', Comment = 'de-DE=Hierüber lassen sich die Softwareanpassungen anzeigen und verwalten.';
                    Image = List;
                    RunObject = page "PTE Software Change List";
                }
                action(PTESoftwareChangeTemplates)
                {
                    ApplicationArea = All;
                    Caption = 'Software Change Templates', Comment = 'de-DE=Softwareanpassungsvorlagen';
                    ToolTip = 'View and manage software change templates.', Comment = 'de-DE=Hierüber lassen sich die Softwareanpassungsvorlagen anzeigen und verwalten.';
                    Image = Template;
                    RunObject = page "PTE Software Change Templates";
                }
                action(PTEPostedSoftwareChanges)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Software Changes', Comment = 'de-DE=Geb. Softwareanpassungen';
                    ToolTip = 'View the posted software changes.', Comment = 'de-DE=Hierüber lassen sich die gebuchten Softwareanpassungen anzeigen.';
                    Image = PostedOrder;
                    RunObject = page "PTE Posted Softw. Change List";
                }
            }
        }
        area(Promoted)
        {
            group(Category_Category4)
            {
                Caption = 'Software Change', Comment = 'de-DE=Software Anpassung';

                actionref(PTESoftwareChangesRef; PTESoftwareChanges)
                {
                }
                actionref(PTESoftwareChangeTemplatesRef; PTESoftwareChangeTemplates)
                {
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        Setup: Record "PTE Software Sales Mgt. Setup";
    begin
        if not Setup.Get() then begin
            Setup.Init();
            Setup."Primary Key" := '';
            Setup.Insert();
        end;
    end;
}
