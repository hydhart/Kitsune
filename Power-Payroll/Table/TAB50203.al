table 50203 "Employee Pay Table"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Employee No.";Code[10])
        {
        }
        field(2;"Pay Code";Code[20])
        {
            TableRelation = "Pay Element Master";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF PayElementMaster.GET("Pay Code") THEN BEGIN
                  "Pay Description" := PayElementMaster."Pay Description";
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Pay Description";Text[60])
        {
        }
        field(5;"Pay Type";Option)
        {
            OptionMembers = Earnings,Deductions;
        }
        field(6;"Calculation Type";Option)
        {
            OptionMembers = "1","-1";
        }
        field(7;"Include In Pay Slip";Boolean)
        {
        }
        field(8;"Is FNPF Base";Boolean)
        {
        }
        field(9;"Is FNPF Field";Boolean)
        {
        }
        field(10;"Is PAYE Base";Boolean)
        {
        }
        field(11;"Is PAYE Field";Boolean)
        {
        }
        field(12;"Is SRT Base";Boolean)
        {
        }
        field(13;"Is SRT Field";Boolean)
        {
        }
        field(14;"Lump Sum";Boolean)
        {
        }
        field(15;Redundancy;Boolean)
        {
        }
        field(16;Bonus;Boolean)
        {
        }
        field(17;"Tax Rate";Decimal)
        {
        }
        field(18;"Exempt Amount";Decimal)
        {
        }
        field(19;Endorsed;Boolean)
        {
        }
        field(20;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(21;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(22;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(23;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(24;Rate;Decimal)
        {
            DecimalPlaces = 3:3;
        }
        field(25;Units;Decimal)
        {
        }
        field(26;Amount;Decimal)
        {
            DecimalPlaces = 3:3;
        }
        field(27;"Pay Reference";Text[50])
        {
        }
        field(28;Release;Boolean)
        {
        }
        field(29;"Sub Branch Code";Code[20])
        {
            TableRelation = "Sub Branch".Code;
        }
        field(30;"Currency Code";Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(31;"Currency Exchange Rate";Decimal)
        {
            TableRelation = "Currency Exchange Rate"."Exchange Rate Amount" WHERE (Currency Code=FIELD(Currency Code));
        }
        field(32;"Foreign Currency";Boolean)
        {
        }
        field(33;"Rate Type";Option)
        {
            OptionMembers = "1","1.5","2";
        }
        field(34;"Quick TimeSheet";Boolean)
        {
        }
        field(35;"Employee Name";Text[50])
        {
        }
        field(36;"Process Payroll";Boolean)
        {
        }
        field(37;"Include Standard Elements";Boolean)
        {
        }
        field(38;"Valid From";Code[10])
        {
            TableRelation = "Branch Calendar"."Pay Run No." WHERE (Pay Run No.=FILTER(<>''));
        }
        field(39;"Valid To";Code[10])
        {
        }
        field(40;"Is Old Rate";Boolean)
        {
        }
        field(42;"Is ECAL Base";Boolean)
        {
        }
        field(43;"Is ECAL Field";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Pay Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        //ASHNEIL CHANDRA  13072017
        IF Employee.GET("Employee No.") THEN BEGIN
          "Branch Code" := Employee."Branch Code";
          "Shift Code" := Employee."Shift Code";
          "Calendar Code" := Employee."Calendar Code";
          "Statistics Group" := Employee."Statistics Group";
        END;
        //ASHNEIL CHANDRA  13072017
    end;

    var
        PayElementMaster : Record "Pay Element Master";
        Employee : Record Employee;
}

