page 50213 "Branch Calendar CartPart"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;
    SourceTable = "Branch Calendar";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Calendar Date";"Calendar Date")
                {
                    Editable = false;
                }
                field(Description;Description)
                {
                    Editable = false;
                }
                field("Off Day";"Off Day")
                {
                    Editable = false;
                }
                field(Holiday;Holiday)
                {
                    Editable = false;
                }
                field("Hours Per Day";"Hours Per Day")
                {
                    Editable = false;
                }
                field(Day;Day)
                {
                    Editable = false;
                }
                field("Pay Run No.";"Pay Run No.")
                {
                }
                field("Pay From Date";"Pay From Date")
                {
                }
                field("Pay To Date";"Pay To Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

