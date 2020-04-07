table 50214 "Multiple Bank Distribution"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Employee No.";Code[10])
        {
        }
        field(2;Sequence;Integer)
        {
            MinValue = 1;
            ValuesAllowed = 1;2;3;4;5;6;7;8;9;
        }
        field(3;"Bank Code";Code[10])
        {
            TableRelation = "Payroll Banks"."Bank Code";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                PayrollBanks.INIT;
                PayrollBanks.RESET;
                IF PayrollBanks.GET("Bank Code") THEN BEGIN
                  "Bank Name" := PayrollBanks."Bank Name";
                  MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(4;"Distribution Percentage";Decimal)
        {
        }
        field(5;"Distribution Amount";Decimal)
        {
        }
        field(6;"Employee Bank Account No.";Code[30])
        {
        }
        field(7;"Branch Code";Code[20])
        {
        }
        field(8;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(9;"Calendar Code";Code[10])
        {
        }
        field(10;"Statistics Group";Code[20])
        {
        }
        field(11;"Is Balance";Boolean)
        {
        }
        field(12;"Bank Name";Text[30])
        {
        }
        field(13;"Bank Account No.";Code[30])
        {
        }
        field(14;"Is Direct";Boolean)
        {
        }
        field(15;Active;Boolean)
        {
        }
        field(16;"Bank Count";Integer)
        {
            CalcFormula = Count("Multiple Bank Distribution" WHERE (Employee No.=FIELD(Employee No.)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Employee No.","Employee Bank Account No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayrollBanks : Record "Payroll Banks";
}

