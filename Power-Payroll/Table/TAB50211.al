table 50211 "Time Code"
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
        field(5;"Line No.";Integer)
        {
        }
        field(6;Day;Text[30])
        {
        }
        field(7;"Day of the Week";Integer)
        {
        }
        field(8;"Start Time";Time)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "End Time" <> 0T THEN BEGIN
                  "Hours Per Day" := "End Time" - "Start Time";
                  "Hours Per Day" := "Hours Per Day" / 3600000;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(9;"End Time";Time)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "Start Time" <> 0T THEN BEGIN
                  "Hours Per Day" := "End Time" - "Start Time";
                  "Hours Per Day" := "Hours Per Day" / 3600000;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(10;"Hours Per Day";Decimal)
        {
            Editable = false;
        }
        field(11;"Day Off";Boolean)
        {
        }
        field(12;Release;Boolean)
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

