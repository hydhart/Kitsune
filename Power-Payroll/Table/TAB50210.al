table 50210 "Pay Run Scheduler"
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
        field(5;"Pay Run No.";Code[10])
        {
        }
        field(6;"Special Pay No.";Code[10])
        {
        }
        field(8;"Pay From Date";Date)
        {
        }
        field(9;"Pay To Date";Date)
        {
        }
        field(10;"Process Timesheet";Boolean)
        {
        }
        field(11;"Process Payroll";Boolean)
        {
        }
        field(13;"Process Bank Distribution";Boolean)
        {
        }
        field(14;Release;Boolean)
        {
        }
        field(15;"Process GL Integration";Boolean)
        {
        }
        field(17;"Payroll Reference";Text[50])
        {
        }
        field(18;"Month Start Date";Date)
        {
        }
        field(19;"Month End Date";Date)
        {
        }
        field(20;"Special Tag";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Pay From Date","Pay Run No.","Special Pay No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //ASHNEIL CHANDRA  13072017
        IF Release = TRUE THEN BEGIN
          ERROR('Pay Run released, can not delete');
        END;
        //ASHNEIL CHANDRA  13072017
    end;
}

