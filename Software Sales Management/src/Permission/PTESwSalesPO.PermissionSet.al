permissionset 63602 "PTE Sw. Sales PO"
{
    Assignable = true;
    Caption = 'Software Sales Posting', Comment = 'de-DE=Zugriff auf Softwareanpassung buchen';

    Permissions =
        tabledata "PTE Software Sales Mgt. Setup" = R,
        tabledata "PTE Software Change Template" = R,
        tabledata "PTE Software Change" = RIMD,
        tabledata "PTE Posted Software Change" = RI,

        page "PTE Software Change Templates" = X,
        page "PTE Software Change List" = X,
        page "PTE Software Change Card" = X,
        page "PTE Posted Softw. Change List" = X,
        page "PTE Posted Softw. Change Card" = X,

        report "PTE Copy Software Change" = X,

        codeunit "PTE Software Change" = X,
        codeunit "PTE Copy Software Change" = X,
        codeunit "PTE Software Change-Post" = X,
        codeunit "PTE Softw. Change-Post (Y/N)" = X,
        codeunit "PTE Sw. Change Commission" = X,
        codeunit "PTE Software Change Navigate" = X;
}
