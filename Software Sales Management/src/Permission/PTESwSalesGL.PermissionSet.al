permissionset 63600 "PTE Sw. Sales GL"
{
    Assignable = true;
    Caption = 'Software Sales Full Access', Comment = 'de-DE=Vollzugriff auf Software Verkaufsmanagement';

    Permissions =
        tabledata "PTE Software Sales Mgt. Setup" = RIMD,
        tabledata "PTE Software Change Template" = RIMD,
        tabledata "PTE Software Change" = RIMD,
        tabledata "PTE Posted Software Change" = Ri,
        tabledata "Source Code Setup" = R,

        table "PTE Software Sales Mgt. Setup" = X,
        table "PTE Software Change Template" = X,
        table "PTE Software Change" = X,
        table "PTE Posted Software Change" = X,

        page "PTE Softw. Sales Setup Card" = X,
        page "PTE Software Change Templates" = X,
        page "PTE Softw. Change Templ. Card" = X,
        page "PTE Software Change List" = X,
        page "PTE Software Change Card" = X,
        page "PTE Posted Softw. Change List" = X,
        page "PTE Posted Softw. Change Card" = X,

        report "PTE Copy Software Change" = X,

        codeunit "PTE Softw. Sales Inst. Lib" = X,
        codeunit "PTE Software Change" = X,
        codeunit "PTE Copy Software Change" = X,
        codeunit "PTE Software Change-Post" = X,
        codeunit "PTE Softw. Change-Post (Y/N)" = X,
        codeunit "PTE Sw. Change Commission" = X,
        codeunit "PTE Software Change Navigate" = X;
}
