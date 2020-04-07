page 50214 "Multiple Bank Distribution"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Multiple Bank Distribution";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                }
                field("Employee Bank Account No.";"Employee Bank Account No.")
                {
                }
                field(Sequence;Sequence)
                {
                }
                field("Bank Code";"Bank Code")
                {
                }
                field("Is Direct";"Is Direct")
                {
                }
                field("Is Balance";"Is Balance")
                {
                }
                field("Distribution Percentage";"Distribution Percentage")
                {
                }
                field("Distribution Amount";"Distribution Amount")
                {
                }
                field(Active;Active)
                {
                }
            }
        }
    }

    actions
    {
    }
}

