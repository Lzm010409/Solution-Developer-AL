permissionset 63603 "PTE Sw. Sales SE"
{
    Assignable = true;
    Caption = 'Software Sales Setup', Comment = 'de-DE=Zugriff auf Einrichtung Software Verkaufsmanagement';

    Permissions =
        tabledata "PTE Software Sales Mgt. Setup" = RIMD,
        tabledata "PTE Software Change Template" = RIMD,

        page "PTE Softw. Sales Setup Card" = X,
        page "PTE Software Change Templates" = X,
        page "PTE Softw. Change Templ. Card" = X,

        codeunit "PTE Softw. Sales Inst. Lib" = X;
}
