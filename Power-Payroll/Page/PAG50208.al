page 50208 "Sub Branch List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Sub Branch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code";"Branch Code")
                {
                }
                field("Code";Code)
                {
                }
                field(Name;Name)
                {
                }
            }
        }
    }

    actions
    {
    }
}

