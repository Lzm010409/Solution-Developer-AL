permissionset 63001 "PTE Permission RO"
{
    Assignable = true;
    Caption = 'Commission Read Only', Comment = 'de-DE=Nur-Lese-Zugriff auf Provisionsmanagement';

    Permissions =
        tabledata "PTE Commission Comment Line" = R,
        tabledata "PTE Commission Contract" = R,
        tabledata "PTE Commission Ledger Entry" = R,
        tabledata "PTE Commission Journal Line" = R,
        tabledata "PTE Commission Type" = R,

        page "PTE Commission Contract List" = X,
        page "PTE Commission Ledger Entries" = X,
        page "PTE Commission Type List" = X,
        page "PTE Com. Contract Factbox"=X,
        page "PTE Commission Comment List"=X,
        page "PTE Commission Contract Card"=X;
}