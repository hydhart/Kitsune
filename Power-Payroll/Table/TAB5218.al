table 5218 "Human Resources Setup"
{
    // version NAVW110.00, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Human Resources Setup',
                ENA='Human Resources Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            CaptionML = ENU='Primary Key',
                        ENA='Primary Key';
        }
        field(2;"Employee Nos.";Code[10])
        {
            CaptionML = ENU='Employee Nos.',
                        ENA='Employee Nos.';
            TableRelation = "No. Series";
        }
        field(3;"Base Unit of Measure";Code[10])
        {
            CaptionML = ENU='Base Unit of Measure',
                        ENA='Base Unit of Measure';
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate();
            var
                ResUnitOfMeasure : Record "Resource Unit of Measure";
                EmployeeAbsence : Record "Employee Absence";
            begin
                IF "Base Unit of Measure" <> xRec."Base Unit of Measure" THEN BEGIN
                  IF NOT EmployeeAbsence.ISEMPTY THEN
                    ERROR(Text001,FIELDCAPTION("Base Unit of Measure"),EmployeeAbsence.TABLECAPTION);
                END;

                HumanResUnitOfMeasure.GET("Base Unit of Measure");
                ResUnitOfMeasure.TESTFIELD("Qty. per Unit of Measure",1);
                ResUnitOfMeasure.TESTFIELD("Related to Base Unit of Meas.");
            end;
        }
        field(50000;"Branch Code";Code[10])
        {
            TableRelation = Branch.Code;
        }
        field(50001;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(50002;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(50003;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(50004;"Pay Run No.";Code[10])
        {
        }
        field(50005;"Runs Per Calendar";Decimal)
        {
        }
        field(50006;"Employer TIN No.";Text[9])
        {
        }
        field(50007;"Employer Branch No.";Integer)
        {
        }
        field(50008;"New Payroll Year";Integer)
        {
        }
        field(50009;"Current Payroll Year";Integer)
        {
        }
        field(50010;Release;Boolean)
        {
        }
        field(50011;"Normal Hours";Code[10])
        {
            TableRelation = "Pay Element Master"."Pay Code" WHERE (Include In Pay Slip=FILTER(Yes), Is FNPF Base=FILTER(Yes), Is PAYE Base=FILTER(Yes), Is SRT Base=FILTER(Yes));
        }
        field(50012;FNPF;Code[10])
        {
            TableRelation = "Pay Element Master"."Pay Code" WHERE (Is FNPF Field=FILTER(Yes));
        }
        field(50013;PAYE;Code[10])
        {
            TableRelation = "Pay Element Master"."Pay Code" WHERE (Is PAYE Field=FILTER(Yes));
        }
        field(50014;SRT;Code[10])
        {
            TableRelation = "Pay Element Master"."Pay Code" WHERE (Is SRT Field=FILTER(Yes));
        }
        field(50015;"Payroll Bank Account";Code[20])
        {
            TableRelation = "Bank Account".No.;
        }
        field(50016;"Westpac Registration No.";Code[7])
        {
        }
        field(50017;"Special Pay No.";Code[10])
        {
        }
        field(50018;"Employer Reference No.";Text[30])
        {
        }
        field(50019;"Contribution Type";Option)
        {
            OptionMembers = Compulsory,Voluntary;
        }
        field(50020;"Trading Name";Text[50])
        {
        }
        field(50021;"Add to Timesheet";Boolean)
        {
        }
        field(50022;"Payroll Journal Template";Code[10])
        {
            TableRelation = "Gen. Journal Template".Name;
        }
        field(50023;"Payroll Journal Batch";Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Payroll Journal Template));
        }
        field(50024;"Payroll Journal Doc. No.";Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50025;"PAYE Output Directory";Text[250])
        {
        }
        field(50026;"FNPF Output Directory";Text[250])
        {
        }
        field(50027;"Global FNPF Contribution";Decimal)
        {
        }
        field(50028;"Employer FNPF Contribution";Decimal)
        {
        }
        field(50029;"Global Secondary Tax";Decimal)
        {
        }
        field(50030;"Payroll Bank Directory";Text[250])
        {
        }
        field(50031;"Account No.";Code[20])
        {
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Account Type=CONST(Customer)) Customer ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50032;"Encryption Directory";Text[250])
        {
        }
        field(50033;"Encryption Program";Text[30])
        {
        }
        field(50034;"Show 1.5x Hours";Boolean)
        {
        }
        field(50035;"Show 2.0x Hours";Boolean)
        {
        }
        field(50036;"Show 1.0x Hours";Boolean)
        {
        }
        field(50037;"Show Rate";Boolean)
        {
        }
        field(50038;"WHT Start Date";Date)
        {
        }
        field(50039;"WHT End Date";Date)
        {
        }
        field(50040;"WHT Employee No.";Code[20])
        {
        }
        field(50041;"Print Specific TWC";Boolean)
        {
        }
        field(50042;"Country/Region Code";Code[10])
        {
            CaptionML = ENU='Country/Region Code',
                        ENA='Country/Region Code';
            TableRelation = Country/Region;
        }
        field(50043;"Reporting Rate";Code[10])
        {
            TableRelation = "Human Resource Unit of Measure";
        }
        field(50044;"Print Photo";Boolean)
        {
        }
        field(50045;"Import Timesheet";Boolean)
        {
        }
        field(50046;"By Pass WBC Registration No.";Boolean)
        {
        }
        field(50047;"Pay Element Deletion";Option)
        {
            OptionMembers = Manual,Automatic,"Delete All";
        }
        field(50048;"Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50049;"By-Pass Payroll Account Use";Boolean)
        {
        }
        field(50050;"Bal. Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50051;"Bal. Account No.";Code[20])
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Bal. Account Type=CONST(Customer)) Customer ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50052;"GL Integration Dimension";Code[20])
        {
            TableRelation = Dimension.Code;
        }
        field(50053;"Payroll Clearing Account No.";Code[20])
        {
            TableRelation = "G/L Account".No. WHERE (Account Type=FILTER(Posting));
        }
        field(50054;"Employer FNPF Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50055;"Employer FNPF Account No.";Code[10])
        {
            TableRelation = IF (Employer FNPF Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Employer FNPF Account Type=CONST(Customer)) Customer ELSE IF (Employer FNPF Account Type=CONST(Vendor)) Vendor ELSE IF (Employer FNPF Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Employer FNPF Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Employer FNPF Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50056;"Employer FNPF Bal Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50057;"Employer FNPF Bal. Account No.";Code[10])
        {
            TableRelation = IF (Employer FNPF Bal Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Employer FNPF Bal Account Type=CONST(Customer)) Customer ELSE IF (Employer FNPF Bal Account Type=CONST(Vendor)) Vendor ELSE IF (Employer FNPF Bal Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Employer FNPF Bal Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Employer FNPF Bal Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50058;"Import Employee Pay Elements";Boolean)
        {
        }
        field(50059;"Enforce Schedule Release";Boolean)
        {
        }
        field(50060;"Enable FNTC Deduction";Option)
        {
            OptionMembers = " ","Per Payrun"," Per 6 Monthly";
        }
        field(50061;ECAL;Code[10])
        {
            TableRelation = "Pay Element Master"."Pay Code" WHERE (Is ECAL Field=FILTER(Yes));
        }
        field(50062;"FNTC Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50063;"FNTC Account No.";Code[10])
        {
            TableRelation = IF (FNTC Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (FNTC Account Type=CONST(Customer)) Customer ELSE IF (FNTC Account Type=CONST(Vendor)) Vendor ELSE IF (FNTC Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (FNTC Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (FNTC Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(50064;"FNTC Bal. Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50065;"FNTC Bal. Account No.";Code[10])
        {
            TableRelation = IF (FNTC Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (FNTC Bal. Account Type=CONST(Customer)) Customer ELSE IF (FNTC Bal. Account Type=CONST(Vendor)) Vendor ELSE IF (FNTC Bal. Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (FNTC Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (FNTC Bal. Account Type=CONST(IC Partner)) "IC Partner";
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HumanResUnitOfMeasure : Record "Human Resource Unit of Measure";
        Text001 : TextConst ENU='You cannot change %1 because there are %2.',ENA='You cannot change %1 because there are %2.';
}

