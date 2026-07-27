pagecustomization "SMB Seminar Registration List" customizes "SMB Seminar Registration List"
{
    layout
    {
        modify("Instructor Code")
        {
            Visible = false;
        }
    }

    views
    {
        addlast
        {
            view(Myseminars)
            {
                Caption = 'My Seminars';
                Filters = where("Seminar No." = const('%MYSEMINAR'));
                SharedLayout = false;
                layout
                {
                    modify("Seminar Description")
                    {
                        Visible = false;
                    }
                }
            }
        }
    }
}