permissionset 123456700 "SMB SMBSemRegistration"
{
    Assignable = true;
    Permissions = tabledata "SMB Instructor"=RIMD,
        tabledata "SMB Seminar"=RIMD,
        tabledata "SMB Seminar Reg. Header"=RIMD,
        tabledata "SMB Seminar Reg. Line"=RIMD,
        tabledata "SMB Seminar Room"=RIMD,
        tabledata "SMB Seminar Setup"=RIMD,
        table "SMB Instructor"=X,
        table "SMB Seminar"=X,
        table "SMB Seminar Reg. Header"=X,
        table "SMB Seminar Reg. Line"=X,
        table "SMB Seminar Room"=X,
        table "SMB Seminar Setup"=X,
        page "SMB Contact Details Factbox"=X,
        page "SMB Instructors"=X,
        page "SMB Seminar Card"=X,
        page "SMB Seminar Details FactBox"=X,
        page "SMB Seminar List"=X,
        page "SMB Seminar Picture"=X,
        page "SMB Seminar Reg. Lines Subpage"=X,
        page "SMB Seminar Registration"=X,
        page "SMB Seminar Registration List"=X,
        page "SMB Seminar Room Card"=X,
        page "SMB Seminar Room List"=X,
        page "SMB Seminar Setup"=X,
       
        tabledata "SMB Seminar Comment Line"=RIMD,
        table "SMB Seminar Comment Line"=X;
}