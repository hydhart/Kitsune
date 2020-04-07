table 50213 "Branch Calendar"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(2;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(3;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(4;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(5;"Calendar Date";Date)
        {
        }
        field(6;Description;Text[30])
        {
        }
        field(7;"Off Day";Boolean)
        {
        }
        field(8;Holiday;Boolean)
        {
        }
        field(9;"Hours Per Day";Decimal)
        {
        }
        field(10;Day;Text[30])
        {
        }
        field(11;Month;Text[30])
        {
        }
        field(12;"Line No.";Integer)
        {
        }
        field(13;"Pay From Date";Date)
        {
        }
        field(14;"Pay To Date";Date)
        {
        }
        field(15;"Pay Run No.";Code[10])
        {
        }
        field(16;Payroll;Boolean)
        {
        }
        field(17;"Tax Start Month";Date)
        {
        }
        field(18;"Tax End Month";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

