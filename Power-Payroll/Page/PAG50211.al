page 50211 "Time Code CartPart"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = CardPart;
    SourceTable = "Time Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Day;Day)
                {
                }
                field("Start Time";"Start Time")
                {
                }
                field("End Time";"End Time")
                {
                }
                field("Hours Per Day";"Hours Per Day")
                {
                }
                field("Day Off";"Day Off")
                {
                }
            }
        }
    }

    actions
    {
    }
}

