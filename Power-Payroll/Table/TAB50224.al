table 50224 "Employee Pay History"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Employee No.";Code[10])
        {
        }
        field(2;"Increment Date";Date)
        {
        }
        field(3;"Annual Pay";Decimal)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                Employee.INIT;
                Employee.RESET;
                IF Employee.GET("Employee No.") THEN BEGIN
                  TempStatsCode := Employee."Statistics Group";
                END;

                StatisticsGroup.INIT;
                StatisticsGroup.RESET;
                StatisticsGroup.SETRANGE(Code, TempStatsCode);
                IF StatisticsGroup.FINDFIRST() THEN BEGIN
                  IF StatisticsGroup."Use Unit Globally" = TRUE THEN BEGIN
                    Units := StatisticsGroup."Unit Per Run";
                    MODIFY;
                  END;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(4;Units;Decimal)
        {
        }
        field(5;Rate;Decimal)
        {
            DecimalPlaces = 5:5;
        }
        field(6;"Runs Per Calendar";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Increment Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        StatisticsGroup : Record "Statistics Group";
        Employee : Record Employee;
        TempStatsCode : Code[10];
}

