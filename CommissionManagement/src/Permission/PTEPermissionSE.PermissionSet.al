permissionset 63004 "PTE Permission SE"
{
    Assignable = true;
    Caption = 'Commission Setup', Comment = 'de-DE=Zugriff auf Provisionssetup';

    Permissions =
        tabledata "PTE Commission Mgt. Setup" = RIMD,
        tabledata "PTE Commission Type" = RIMD,

        page "PTE Commission Mgt. Setup Card" = X,
        page "PTE Commission Type List" = X,

        codeunit "PTE Com. Mgt. Inst. Lib"=X;
}