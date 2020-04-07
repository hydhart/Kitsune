page 50221 "Pay Run No. List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Branch Calendar";
    SourceTableView = SORTING(Branch Code,Shift Code,Calendar Code,Statistics Group,Line No.) ORDER(Ascending) WHERE(Pay Run No.=FILTER(<>''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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

