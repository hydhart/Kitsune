table 50228 "GL Integration Per Dimension"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Pay Code";Code[10])
        {
        }
        field(2;"Dimension Value";Code[20])
        {
        }
        field(3;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Pay Code","Dimension Value")
        {
        }
    }

    fieldgroups
    {
    }
}

