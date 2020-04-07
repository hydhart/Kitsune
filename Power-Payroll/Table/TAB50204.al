table 50204 "Branch Policy"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DrillDownPageID = 50205;
    LookupPageID = 50205;

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
        field(5;"Branch Name";Text[50])
        {
        }
        field(7;"Runs Per Calendar";Decimal)
        {
            Editable = false;
        }
        field(8;"Pay Calculation Type";Option)
        {
            OptionMembers = Hours,Days;
        }
        field(9;Release;Boolean)
        {
            Editable = false;
        }
        field(10;"First Pay From Date";Date)
        {
        }
        field(11;"First Pay To Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Calculation Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        //ASHNEIL CHANDRA   13072017
          IF Release = TRUE THEN BEGIN
            ERROR('Record Released, changes not saved');
          END;
        //ASHNEIL CHANDRA   13072017
    end;
}

