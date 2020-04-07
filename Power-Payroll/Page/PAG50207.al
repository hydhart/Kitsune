page 50207 "Statistics Group List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Statistics Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                }
                field("Runs Per Calendar";"Runs Per Calendar")
                {
                }
                field("Days Per Run";"Days Per Run")
                {
                }
                field("Unit Per Run";"Unit Per Run")
                {
                }
                field("Use Unit Globally";"Use Unit Globally")
                {
                }
            }
        }
    }

    actions
    {
    }
}

