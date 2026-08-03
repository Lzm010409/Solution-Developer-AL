permissionset 63601 "PTE Sw. Sales RO"
{
    Assignable = true;
    Caption = 'Software Sales Read Only', Comment = 'de-DE=Nur-Lese-Zugriff auf Software Verkaufsmanagement';

    Permissions =
        tabledata "PTE Software Sales Mgt. Setup" = R,
        tabledata "PTE Software Change Template" = R,
        tabledata "PTE Software Change" = R,
        tabledata "PTE Posted Software Change" = R,

        page "PTE Software Change Templates" = X,
        page "PTE Software Change List" = X,
        page "PTE Software Change Card" = X,
        page "PTE Posted Softw. Change List" = X,
        page "PTE Posted Softw. Change Card" = X;
}
