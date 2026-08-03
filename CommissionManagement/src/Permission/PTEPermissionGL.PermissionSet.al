permissionset 63000 "PTE Permission GL"
{
    Assignable = true;
    Caption = 'Commission Full Access' , Comment = 'de-DE=Vollzugriff auf Provisionsmanagement';
    Permissions = tabledata "PTE Commission Comment Line"=RIMD,
        tabledata "PTE Commission Contract"=RIMD,
        tabledata "PTE Commission Ledger Entry"=Ri,
        tabledata "PTE Commission Journal Line"=Rimd,
        tabledata "PTE Commission Mgt. Setup"=RIMD,
        tabledata "PTE Commission Type"=RIMD,
        table "PTE Commission Comment Line"=X,
        table "PTE Commission Contract"=X,
        table "PTE Commission Ledger Entry"=X,
        table "PTE Commission Journal Line"=X,
        table "PTE Commission Mgt. Setup"=X,
        table "PTE Commission Type"=X,
        report "PTE Calc. Commissions"=X,
        codeunit "PTE Calculate Commission"=X,
        codeunit "PTE Com. Mgt. Validation"=X,
        codeunit "PTE Post Com. Ledger Entry"=X,
        codeunit "PTE Commis. Jnl.-Check Line"=X,
        codeunit "PTE Commis. Jnl.-Post Line"=X,
        codeunit "PTE Commission Navigate"=X,
        codeunit "PTE Com. Mgt. Inst. Lib"=X,
        page "PTE Com. Contract Factbox"=X,
        page "PTE Commission Comment List"=X,
        page "PTE Commission Comment Sheet"=X,
        page "PTE Commission Contract Card"=X,
        page "PTE Commission Contract List"=X,
        page "PTE Commission Ledger Entries"=X,
        page "PTE Commission Mgt. Setup Card"=X,
        page "PTE Commission Type List"=X;
}