table 50226 "Employee Pay Details"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"No.";Code[20])
        {
        }
        field(2;"Employee Name";Text[50])
        {
        }
        field(50200;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(50201;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(50202;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(50203;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                StatisticsGroup.INIT;
                StatisticsGroup.RESET;
                IF StatisticsGroup.GET("Statistics Group") THEN BEGIN
                  "Runs Per Calendar" := StatisticsGroup."Runs Per Calendar";
                  MODIFY;
                END;

                IF "Statistics Group" = 'WEEKLY' THEN BEGIN
                  "Payment Frequency" := 1;
                END;
                IF "Statistics Group" = 'FORTNIGHTLY' THEN BEGIN
                  "Payment Frequency" := 2;
                END;
                IF "Statistics Group" = 'BI-MONTHLY' THEN BEGIN
                  "Payment Frequency" := 2;
                END;
                IF "Statistics Group" = 'MONTHLY' THEN BEGIN
                  "Payment Frequency" := 3;
                END;
                MODIFY;

                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(50204;"Gross Standard Pay";Decimal)
        {
            DecimalPlaces = 5:5;
            Editable = false;
        }
        field(50205;"Annual Pay";Decimal)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "Runs Per Calendar" = 0 THEN BEGIN
                  ERROR('Statistics Group not defined');
                END;
                IF "Runs Per Calendar" <> 0 THEN BEGIN
                  "Gross Standard Pay" := "Annual Pay" / "Runs Per Calendar";
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(50206;"Employee Rate";Decimal)
        {
            DecimalPlaces = 5:5;
            Editable = false;
        }
        field(50207;Units;Decimal)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "Gross Standard Pay" = 0 THEN BEGIN
                  ERROR('Annual Pay not defined');
                END;

                IF "Gross Standard Pay" <> 0 THEN BEGIN
                  "Employee Rate" := "Gross Standard Pay" / Units;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(50208;"Runs Per Calendar";Decimal)
        {
            Editable = false;
        }
        field(50209;"Bank Code";Code[20])
        {
            TableRelation = "Payroll Banks"."Bank Code";
        }
        field(50211;"Bank Account No.";Code[30])
        {
        }
        field(50212;Terminated;Boolean)
        {
        }
        field(50213;"Residential/Non-Residential";Option)
        {
            OptionMembers = " ",Resident,"Non Resident";
        }
        field(50214;"Tax Code";Option)
        {
            OptionMembers = " ",P,S;
        }
        field(50215;"Employment Start Date";Date)
        {
        }
        field(50216;"Employment End Date";Date)
        {
        }
        field(50217;"Payment Method";Option)
        {
            OptionMembers = Bank,Cash;
        }
        field(50218;Release;Boolean)
        {
            Editable = false;
        }
        field(50219;"Occupation Code";Code[10])
        {
        }
        field(50220;"By Pass FNPF";Boolean)
        {
        }
        field(50221;"Employee FNPF";Text[11])
        {
        }
        field(50222;"Employee TIN";Text[9])
        {
        }
        field(50223;"Gross Earnings";Decimal)
        {
        }
        field(50224;"Directors Fees";Decimal)
        {
        }
        field(50225;"Management Fees";Decimal)
        {
        }
        field(50226;"Redundancy Payment";Decimal)
        {
        }
        field(50227;"Pension Income";Decimal)
        {
        }
        field(50228;"Fringe Benefits";Decimal)
        {
        }
        field(50229;"PAYE Deducted";Decimal)
        {
        }
        field(50230;"FNPF Deducted";Decimal)
        {
        }
        field(50231;"SRL Deducted";Decimal)
        {
        }
        field(50232;"Comment 1";Text[200])
        {
        }
        field(50233;"Comment 2";Text[200])
        {
        }
        field(50234;"Sub Branch Code";Code[10])
        {
            TableRelation = "Sub Branch".Code;
        }
        field(50235;"Currency Code";Code[10])
        {
            TableRelation = Currency.Code;
        }
        field(50236;"Currency Exchange Rate";Decimal)
        {
            DecimalPlaces = 4:4;
            TableRelation = "Currency Exchange Rate Payroll"."Exchange Rate Amount" WHERE (Currency Code=FIELD(Currency Code), Starting Date=FIELD(Currency Date));
        }
        field(50237;"Foreign Currency";Boolean)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "Foreign Currency" = TRUE THEN BEGIN;
                  "Currency Code" := '';
                  "Currency Exchange Rate" := 0;
                  "Gross Standard Pay" := 0;
                  "FX Gross Standard Pay" := 0;
                  "Employee Rate" := 0;
                  MODIFY;
                END;

                IF "Foreign Currency" = FALSE THEN BEGIN;
                  "Currency Code" := '';
                  "Currency Exchange Rate" := 0;
                  "Gross Standard Pay" := 0;
                  "FX Gross Standard Pay" := 0;
                  "Employee Rate" := 0;
                  IF "Runs Per Calendar" <> 0 THEN BEGIN
                    "Gross Standard Pay" := "Annual Pay" / "Runs Per Calendar";
                  END;
                  IF "Gross Standard Pay" <> 0 THEN BEGIN
                    "Employee Rate" := "Gross Standard Pay" / Units;
                  END;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(50238;"FX Gross Standard Pay";Decimal)
        {
            DecimalPlaces = 4:4;

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA  13072017
                IF "Currency Exchange Rate" <> 0 THEN BEGIN
                  "Gross Standard Pay" := "FX Gross Standard Pay" * "Currency Exchange Rate";
                  MODIFY;
                END;

                IF "FX Gross Standard Pay" <> 0 THEN BEGIN
                  "Employee Rate" := "Gross Standard Pay" / Units;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA  13072017
            end;
        }
        field(50239;"Is Direct";Boolean)
        {
        }
        field(50240;"Rate Type";Option)
        {
            OptionMembers = "1","1.5","2";
            ValuesAllowed = 1;
        }
        field(50241;"Print in EMS";Boolean)
        {
        }
        field(50242;"Process Payroll";Boolean)
        {
        }
        field(50243;"Payment Frequency";Integer)
        {
        }
        field(50244;"Employment Status";Integer)
        {
        }
        field(50245;"Employment Status Date";Date)
        {
        }
        field(50246;"Currency Date";Date)
        {
        }
        field(50247;"Bank Count";Integer)
        {
        }
        field(50248;"Print in FNPF";Boolean)
        {
        }
        field(50249;"Employee FNPF Additional Cont.";Decimal)
        {
        }
        field(50250;"Employer FNPF Additional Cont.";Decimal)
        {
        }
        field(50251;"Employee Secondary Tax";Decimal)
        {
        }
        field(50254;"Payee Narrative";Text[12])
        {
        }
        field(50255;"Payee Code";Text[12])
        {
        }
        field(50256;"Payee Particulars";Text[12])
        {
        }
        field(50257;"Zero Normal Hours";Boolean)
        {
        }
        field(50258;"Process Bank Distribution";Boolean)
        {
        }
        field(50259;"Print in Payroll Register";Boolean)
        {
        }
        field(50260;"Lump Sum Payment";Decimal)
        {
        }
        field(50261;"Print in Payslip";Boolean)
        {
        }
        field(50262;"Increment Date";Date)
        {
        }
        field(50263;"Print TWC";Boolean)
        {
        }
        field(50264;"Print Report Name";Text[250])
        {
        }
        field(50265;"Last Released Pay Run No.";Code[10])
        {
        }
        field(50266;"DR Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50267;"DR Account No.";Code[20])
        {
            TableRelation = IF (DR Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (DR Account Type=CONST(Customer)) Customer ELSE IF (DR Account Type=CONST(Vendor)) Vendor ELSE IF (DR Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (DR Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (DR Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50268;"CR Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50269;"CR Account No.";Code[20])
        {
            TableRelation = IF (CR Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (CR Account Type=CONST(Customer)) Customer ELSE IF (CR Account Type=CONST(Vendor)) Vendor ELSE IF (CR Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (CR Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (CR Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50270;"ECAL Deducted";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        StatisticsGroup : Record "Statistics Group";
        BankAccount : Record "Bank Account";
}

