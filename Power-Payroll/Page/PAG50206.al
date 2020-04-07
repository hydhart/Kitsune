page 50206 "Bank Pay Distribution CardPart"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Bank Pay Distribution";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                }
                field("Employee Name";"Employee Name")
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Employee Bank Account No.";"Employee Bank Account No.")
                {
                }
                field("Bank Name";"Bank Name")
                {
                }
                field(Amount;Amount)
                {
                }
                field("Pay Run Amount";"Pay Run Amount")
                {
                }
                field(Sequence;Sequence)
                {
                }
                field("Is Balance";"Is Balance")
                {
                }
                field("Is Direct";"Is Direct")
                {
                }
                field("Pay Date";"Pay Date")
                {
                }
                field("Net Pay";"Net Pay")
                {
                }
            }
        }
    }

    actions
    {
    }
}

