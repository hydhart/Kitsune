page 50229 "Payroll Banks"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Payroll Banks";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Name";"Bank Name")
                {
                }
                field("Bank No.";"Bank No.")
                {
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

