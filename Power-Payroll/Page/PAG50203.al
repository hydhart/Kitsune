page 50203 "Employee Pay Table CardPart"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = CardPart;
    SourceTable = "Employee Pay Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Code";"Pay Code")
                {
                }
                field("Pay Description";"Pay Description")
                {
                }
                field("Pay Type";"Pay Type")
                {
                }
                field("Pay Reference";"Pay Reference")
                {
                }
                field(Rate;Rate)
                {
                }
                field(Units;Units)
                {
                }
                field(Amount;Amount)
                {
                }
                field("Valid From";"Valid From")
                {
                    TableRelation = "Branch Calendar"."Pay Run No." WHERE (Pay Run No.=FILTER(<>''));
                }
                field("Valid To";"Valid To")
                {
                    TableRelation = "Branch Calendar"."Pay Run No." WHERE (Pay Run No.=FILTER(<>''));
                }
                field("Is Old Rate";"Is Old Rate")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field("Currency Exchange Rate";"Currency Exchange Rate")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        BranchCalendar : Record "Branch Calendar";
}

