page 50200 "Payroll Calendar"
{
    PageType = List;
    SourceTable = "Payroll Calendar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Calendar Code";"Calendar Code")
                {
                }
                field(Release;Release)
                {
                }
            }
        }
    }

    actions
    {
    }
}

