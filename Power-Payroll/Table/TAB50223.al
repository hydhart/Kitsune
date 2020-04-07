table 50223 "Pay to Date Adjustment"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Employee No.";Code[10])
        {
        }
        field(2;"Total Earnings Paid";Decimal)
        {
        }
        field(3;"Total PAYE Paid";Decimal)
        {
        }
        field(4;"Total SRL Paid";Decimal)
        {
        }
        field(5;"Total Bonus Paid";Decimal)
        {
        }
        field(6;Recorded;Boolean)
        {
        }
        field(7;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(8;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(9;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(10;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(11;"Total ECAL Paid";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Branch Code","Shift Code","Statistics Group","Calendar Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //ASHNEIL CHANDRA  13072017
        IF Recorded = TRUE THEN BEGIN
          ERROR('Entry exist, cannot delete');
        END;
        //ASHNEIL CHANDRA  13072017
    end;
}

