table 50206 "Bank Pay Distribution"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Employee No.";Code[10])
        {
        }
        field(2;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(3;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(4;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(5;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(6;"Employee Name";Text[50])
        {
        }
        field(7;"Pay Run No.";Code[10])
        {
        }
        field(8;"Special Pay No.";Code[10])
        {
        }
        field(9;"Bank Code";Code[10])
        {
            TableRelation = "Payroll Banks"."Bank Code";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                PayrollBanks.INIT;
                PayrollBanks.RESET;
                IF PayrollBanks.GET("Bank Code") THEN BEGIN
                  "Bank Name" := PayrollBanks."Bank Name";
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(10;"Employee Bank Account No.";Code[30])
        {
        }
        field(11;"Bank Name";Text[30])
        {
        }
        field(12;"Sub Branch Code";Code[20])
        {
            TableRelation = "Sub Branch".Code;
        }
        field(13;Amount;Decimal)
        {
            CalcFormula = Sum("Bank Pay Distribution"."Pay Run Amount" WHERE (Employee No.=FIELD(Employee No.), Branch Code=FIELD(Branch Code), Calendar Code=FIELD(Calendar Code), Shift Code=FIELD(Shift Code), Statistics Group=FIELD(Statistics Group), Is Balance=FILTER(No), Is Direct=FILTER(No), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.)));
            FieldClass = FlowField;
        }
        field(14;"Pay Run Amount";Decimal)
        {
        }
        field(15;Sequence;Integer)
        {
        }
        field(17;"Is Balance";Boolean)
        {
        }
        field(18;"Is Direct";Boolean)
        {
        }
        field(19;"Pay Date";Date)
        {
        }
        field(20;"Net Pay";Decimal)
        {
        }
        field(21;Release;Boolean)
        {
        }
        field(22;"Bank Account No.";Code[30])
        {
        }
        field(24;"Payroll Reference";Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.",Sequence,"Is Balance","Employee Bank Account No.")
        {
        }
        key(Key2;"Bank Code","Employee No.","Bank Account No.")
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

    var
        PayrollBanks : Record "Payroll Banks";
}

