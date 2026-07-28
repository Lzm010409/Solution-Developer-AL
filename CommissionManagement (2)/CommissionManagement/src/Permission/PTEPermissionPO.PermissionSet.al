permissionset 63003 "PTE Permission PO"
{
    Assignable = true;
    Caption = 'Commission Posting', Comment = 'de-DE=Zugriff auf Provisionsbuchung';

    Permissions =
        tabledata "PTE Commission Ledger Entry" = RI,
        tabledata "PTE Commission Contract" = R,
        tabledata "PTE Commission Type" = R,
        tabledata "PTE Commission Comment Line"=RI,

        report "PTE Calc. Commissions" = X,
        codeunit "PTE Calculate Commission"=X,
        codeunit "PTE Com. Mgt. Validation"=X,
        codeunit "PTE Post Com. Ledger Entry"=X,

        page "PTE Commission Comment List"=X,
        page "PTE Com. Contract Factbox"=X,
        page "PTE Commission Comment Sheet"=X,
        page "PTE Commission Contract Card"=X,
        page "PTE Commission Contract List"=X,
        page "PTE Commission Ledger Entries"=X,
        page "PTE Commission Type List"=X;
}