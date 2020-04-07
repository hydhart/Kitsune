table 50217 "Quick Timesheet"
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
            Editable = false;
        }
        field(6;"Special Pay No.";Code[10])
        {
            Editable = false;
        }
        field(7;"Employee No.";Code[10])
        {
            Editable = false;
            TableRelation = Employee.No.;
        }
        field(8;"Pay Code";Code[10])
        {
            Editable = false;
        }
        field(9;"Pay Description";Text[60])
        {
            Editable = false;
        }
        field(10;Rate;Decimal)
        {
            DecimalPlaces = 3:3;
            Editable = false;
        }
        field(11;Units;Decimal)
        {
        }
        field(12;Amount;Decimal)
        {
            DecimalPlaces = 3:3;
            Editable = false;
        }
        field(13;"Rate Type";Option)
        {
            Editable = false;
            OptionMembers = "1","1.5","2";
        }
        field(14;"Quick Timesheet";Boolean)
        {
        }
        field(15;"Calculation Type";Option)
        {
            OptionMembers = "1","-1";
        }
        field(16;"From Date";Date)
        {
        }
        field(17;"To Date";Date)
        {
        }
        field(18;"From Time";Time)
        {
        }
        field(19;"To Time";Time)
        {
        }
        field(20;"Is Leave";Boolean)
        {
        }
        field(21;"Is Leave Without Pay";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.","Pay Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayElementMaster : Record "Pay Element Master";
        RateType : Decimal;
}

