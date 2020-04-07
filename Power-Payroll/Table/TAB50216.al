table 50216 "Employee Timesheet"
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
        field(8;"Employee Name";Text[50])
        {
            Editable = false;
        }
        field(9;"Pay Code";Code[10])
        {
            Editable = false;
            TableRelation = "Pay Element Master"."Pay Code";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                PayElementMaster.INIT;
                PayElementMaster.RESET;
                IF PayElementMaster.GET("Pay Code") THEN BEGIN
                  "Pay Description" := PayElementMaster."Pay Description";
                  MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(10;"Pay Description";Text[60])
        {
            Editable = false;
        }
        field(11;"Pay Type";Option)
        {
            OptionMembers = Earnings,Deductions;
        }
        field(12;Rate;Decimal)
        {
            DecimalPlaces = 3:3;
            Editable = false;
        }
        field(13;Units;Decimal)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                EVALUATE(RateType, FORMAT("Rate Type"));

                Amount := Rate * Units * RateType;
                MODIFY;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(14;"Pay From Date";Date)
        {
        }
        field(15;"Pay To Date";Date)
        {
        }
        field(16;"Tax Start Month";Date)
        {
        }
        field(17;"Tax End Month";Date)
        {
        }
        field(18;"Date Processed";Date)
        {
        }
        field(19;"Basic Pay";Decimal)
        {
        }
        field(20;"Pay Calculation Type";Option)
        {
            Editable = false;
            OptionMembers = Hours,Days;
        }
        field(21;"Rate Type";Option)
        {
            Editable = false;
            OptionMembers = "1","1.5","2";
        }
        field(22;Amount;Decimal)
        {
            DecimalPlaces = 3:3;
            Editable = false;
        }
        field(23;"Quick Timesheet";Boolean)
        {
        }
        field(24;"Sub Branch Code";Code[20])
        {
        }
        field(25;"Payroll Reference";Text[50])
        {
        }
        field(26;"Pay Reference";Text[50])
        {
        }
        field(27;"Zero Normal Hours";Boolean)
        {
        }
        field(28;"From Date";Date)
        {
        }
        field(29;"To Date";Date)
        {
        }
        field(30;"From Time";Time)
        {
        }
        field(31;"To Time";Time)
        {
        }
        field(32;Release;Boolean)
        {
        }
        field(33;"Is Leave";Boolean)
        {
        }
        field(34;"Is Leave Without Pay";Boolean)
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

    trigger OnDelete();
    begin
        //ASHNEIL CHANDRA   13072017
        IF Release = TRUE THEN BEGIN
          ERROR('Pay Run released, can not delete');
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    var
        PayElementMaster : Record "Pay Element Master";
        RateType : Decimal;
}

