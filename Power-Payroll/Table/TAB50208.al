table 50208 "Sub Branch"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DrillDownPageID = 50208;
    LookupPageID = 50208;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Name;Text[30])
        {
        }
        field(3;Release;Boolean)
        {
        }
        field(4;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
    }

    keys
    {
        key(Key1;"Branch Code","Code")
        {
        }
    }

    fieldgroups
    {
    }
}

