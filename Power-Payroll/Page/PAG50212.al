page 50212 "Holiday List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = Holiday;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Holiday Date";"Holiday Date")
                {
                }
                field("Holiday Name";"Holiday Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

