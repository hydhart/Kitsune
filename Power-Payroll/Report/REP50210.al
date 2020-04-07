report 50210 "Tax Withholding Certificate"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Tax Withholding Certificate.rdlc';

    dataset
    {
        dataitem(Employee;"Employee Pay Details")
        {
            DataItemTableView = SORTING(No.) ORDER(Ascending);
            RequestFilterFields = "No.";
            column(TaxCode_Employee;Employee."Tax Code")
            {
            }
            column(EmployeeFNPF_Employee;Employee."Employee FNPF")
            {
            }
            column(EmployeeTIN_Employee;Employee."Employee TIN")
            {
            }
            column(GrossEarnings_Employee;Employee."Gross Earnings")
            {
            }
            column(DirectorsFees_Employee;Employee."Directors Fees")
            {
            }
            column(ManagementFees_Employee;Employee."Management Fees")
            {
            }
            column(RedundancyPayment_Employee;Employee."Redundancy Payment")
            {
            }
            column(PensionIncome_Employee;Employee."Pension Income")
            {
            }
            column(LumpSumPayment_Employee;Employee."Lump Sum Payment")
            {
            }
            column(FringeBenefits_Employee;Employee."Fringe Benefits")
            {
            }
            column(PAYEDeducted_Employee;Employee."PAYE Deducted")
            {
            }
            column(FNPFDeducted_Employee;Employee."FNPF Deducted")
            {
            }
            column(SRLDeducted_Employee;Employee."SRL Deducted")
            {
            }
            column(Comment1_Employee;Employee."Comment 1")
            {
            }
            column(Comment2_Employee;Employee."Comment 2")
            {
            }
            column(VATRegistrationNumber;HRSETUP."Employer TIN No.")
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(DisplayReportDate;DisplayReportDate)
            {
            }
            column(PeriodEmployed;PeriodEmployed)
            {
            }
            column(VATREG1;VATREG1)
            {
            }
            column(VATREG2;VATREG2)
            {
            }
            column(VATREG3;VATREG3)
            {
            }
            column(VATREG4;VATREG4)
            {
            }
            column(VATREG5;VATREG5)
            {
            }
            column(VATREG6;VATREG6)
            {
            }
            column(VATREG7;VATREG7)
            {
            }
            column(VATREG8;VATREG8)
            {
            }
            column(VATREG9;VATREG9)
            {
            }
            column(EMPTIN1;EMPTIN1)
            {
            }
            column(EMPTIN2;EMPTIN2)
            {
            }
            column(EMPTIN3;EMPTIN3)
            {
            }
            column(EMPTIN4;EMPTIN4)
            {
            }
            column(EMPTIN5;EMPTIN5)
            {
            }
            column(EMPTIN6;EMPTIN6)
            {
            }
            column(EMPTIN7;EMPTIN7)
            {
            }
            column(EMPTIN8;EMPTIN8)
            {
            }
            column(EMPTIN9;EMPTIN9)
            {
            }
            column(EMPFNPF1;EMPFNPF1)
            {
            }
            column(EMPFNPF2;EMPFNPF2)
            {
            }
            column(EMPFNPF3;EMPFNPF3)
            {
            }
            column(EMPFNPF4;EMPFNPF4)
            {
            }
            column(EMPFNPF5;EMPFNPF5)
            {
            }
            column(EMPFNPF6;EMPFNPF6)
            {
            }
            column(EMPFNPF7;EMPFNPF7)
            {
            }
            column(EMPFNPF8;EMPFNPF8)
            {
            }
            column(EMPFNPF9;EMPFNPF9)
            {
            }
            column(EMPFNPF10;EMPFNPF10)
            {
            }
            column(EMPFNPF11;EMPFNPF11)
            {
            }
            column(TEXT001;TEXT001)
            {
            }
            column(TEXT002;TEXT002)
            {
            }
            column(TEXT003;TEXT003)
            {
            }
            column(TEXT004;TEXT004)
            {
            }
            column(TEXT005;TEXT005)
            {
            }
            column(TEXT006;TEXT006)
            {
            }
            column(TEXT007;TEXT007)
            {
            }
            column(TEXT008;TEXT008)
            {
            }
            column(TEXT009;TEXT009)
            {
            }
            column(TEXT010;TEXT010)
            {
            }
            column(TEXT011;TEXT011)
            {
            }
            column(TEXT012;TEXT012)
            {
            }
            column(TEXT013;TEXT013)
            {
            }
            column(TEXT014;TEXT014)
            {
            }
            column(TEXT015;TEXT015)
            {
            }
            column(TEXT016;TEXT016)
            {
            }
            column(TEXT017;TEXT017)
            {
            }
            column(TEXT018;TEXT018)
            {
            }
            column(TEXT019;TEXT019)
            {
            }
            column(TEXT020;TEXT020)
            {
            }
            column(TEXT021;TEXT021)
            {
            }
            column(TEXT022;TEXT022)
            {
            }
            column(TEXT023;TEXT023)
            {
            }
            column(TEXT024;TEXT024)
            {
            }
            column(TEXT025;TEXT025)
            {
            }
            column(TEXT026;TEXT026)
            {
            }
            column(TEXT027;TEXT027)
            {
            }
            column(TEXT028;TEXT028)
            {
            }
            column(TEXT029;TEXT029)
            {
            }
            column(TEXT030;TEXT030)
            {
            }
            column(TEXT031;TEXT031)
            {
            }
            dataitem(EmployeeMaster;Employee)
            {
                DataItemLink = No.=FIELD(No.);
                column(FirstName_Employee;EmployeeMaster."First Name")
                {
                }
                column(MiddleName_Employee;EmployeeMaster."Middle Name")
                {
                }
                column(LastName_Employee;EmployeeMaster."Last Name")
                {
                }
                column(BirthDate_Employee;EmployeeMaster."Birth Date")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                SETRANGE("No.", EmployeeNo);
                IF FINDFIRST() THEN BEGIN
                EMPTIN1 := '';
                EMPTIN2 := '';
                EMPTIN3 := '';
                EMPTIN4 := '';
                EMPTIN5 := '';
                EMPTIN6 := '';
                EMPTIN7 := '';
                EMPTIN8 := '';
                EMPTIN9 := '';
                EMPFNPF1 := '';
                EMPFNPF2 := '';
                EMPFNPF3 := '';
                EMPFNPF4 := '';
                EMPFNPF5 := '';
                EMPFNPF6 := '';
                EMPFNPF7 := '';
                EMPFNPF8 := '';
                EMPFNPF9 := '';
                EMPFNPF10 := '';
                EMPFNPF11 := '';

                FromDate := 0D;
                ToDate := 0D;

                EMPTIN1 := COPYSTR("Employee TIN",1,1);
                EMPTIN2 := COPYSTR("Employee TIN",2,1);
                EMPTIN3 := COPYSTR("Employee TIN",3,1);
                EMPTIN4 := COPYSTR("Employee TIN",4,1);
                EMPTIN5 := COPYSTR("Employee TIN",5,1);
                EMPTIN6 := COPYSTR("Employee TIN",6,1);
                EMPTIN7 := COPYSTR("Employee TIN",7,1);
                EMPTIN8 := COPYSTR("Employee TIN",8,1);
                EMPTIN9 := COPYSTR("Employee TIN",9,1);

                EMPFNPF1 := COPYSTR("Employee FNPF",1,1);
                EMPFNPF2 := COPYSTR("Employee FNPF",2,1);
                EMPFNPF3 := COPYSTR("Employee FNPF",3,1);
                EMPFNPF4 := COPYSTR("Employee FNPF",4,1);
                EMPFNPF5 := COPYSTR("Employee FNPF",5,1);
                EMPFNPF6 := COPYSTR("Employee FNPF",6,1);
                EMPFNPF7 := COPYSTR("Employee FNPF",7,1);
                EMPFNPF8 := COPYSTR("Employee FNPF",8,1);
                EMPFNPF9 := COPYSTR("Employee FNPF",9,1);
                EMPFNPF10 := COPYSTR("Employee FNPF",10,1);
                EMPFNPF11 := COPYSTR("Employee FNPF",11,1);


                IF "Employment Start Date" = 0D THEN BEGIN
                  FromDate := mfrom;
                END;
                IF "Employment End Date" = 0D THEN BEGIN
                  ToDate := mto;
                END;
                IF "Employment Start Date" <> 0D THEN BEGIN
                  IF "Employment Start Date" >= mfrom THEN BEGIN
                    FromDate := "Employment Start Date";
                  END;
                END;
                IF "Employment Start Date" <> 0D THEN BEGIN
                  IF "Employment Start Date" < mfrom THEN BEGIN
                    FromDate := mfrom;
                  END;
                END;
                IF "Employment End Date" <> 0D THEN BEGIN
                  ToDate := "Employment End Date";
                END;

                PeriodEmployed := FORMAT(FromDate) + '   to  ' + FORMAT(ToDate);

                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        VATREG1 := '';
        VATREG2 := '';
        VATREG3 := '';
        VATREG4 := '';
        VATREG5 := '';
        VATREG6 := '';
        VATREG7 := '';
        VATREG8 := '';
        VATREG9 := '';
        DisplayReportDate := '';
    end;

    trigger OnPreReport();
    begin
        HRSETUP.GET();

        VATREG1 := COPYSTR(HRSETUP."Employer TIN No.",1,1);
        VATREG2 := COPYSTR(HRSETUP."Employer TIN No.",2,1);
        VATREG3 := COPYSTR(HRSETUP."Employer TIN No.",3,1);
        VATREG4 := COPYSTR(HRSETUP."Employer TIN No.",4,1);
        VATREG5 := COPYSTR(HRSETUP."Employer TIN No.",5,1);
        VATREG6 := COPYSTR(HRSETUP."Employer TIN No.",6,1);
        VATREG7 := COPYSTR(HRSETUP."Employer TIN No.",7,1);
        VATREG8 := COPYSTR(HRSETUP."Employer TIN No.",8,1);
        VATREG9 := COPYSTR(HRSETUP."Employer TIN No.",9,1);

        mfrom := HRSETUP."WHT Start Date";
        mto := HRSETUP."WHT End Date";
        EmployeeNo := HRSETUP."WHT Employee No.";


        mdate:=FORMAT(mfrom)+'..'+FORMAT(mto);
        DisplayReportDate :='For the year ended' + ' ' + FORMAT(mto,0,'<Day> <Month Text,8>')+ ' '+FORMAT(DATE2DMY(mto,3));

        Employee.INIT;
        Employee.RESET;
        IF Employee.FINDFIRST() THEN REPEAT
          PAYRUN.INIT;
          PAYRUN.RESET;
          PAYRUN.SETRANGE("Include In Pay Slip", TRUE);
          PAYRUN.SETRANGE("Employee No.", Employee."No.");
          //ASHNEIL CHANDRA   15032017
          //PAYRUN.SETRANGE("Calendar Code", Employee."Calendar Code");
          PAYRUN.SETRANGE("Shift Code", Employee."Shift Code");
          PAYRUN.SETRANGE("Branch Code", Employee."Branch Code");
          PAYRUN.SETFILTER("Pay To Date", mdate);
          MPAYE:=0;
          MFNPF:=0;
          MEARN:=0;
          MSRT:=0;

          IF PAYRUN.FIND('-') THEN REPEAT
            IF FORMAT(PAYRUN."Pay Type")='Earnings' THEN BEGIN
              IF PAYRUN."Is PAYE Base" = TRUE THEN BEGIN
                MEARN := MEARN + ROUND(PAYRUN.Amount, 0.01, '=');
              END;
            END;

            IF PAYRUN."Pay Code" = HRSETUP.FNPF THEN BEGIN
              MFNPF := MFNPF + PAYRUN.Amount;
            END;
            IF PAYRUN."Pay Code" = HRSETUP.PAYE THEN BEGIN
              MPAYE := MPAYE + PAYRUN.Amount;
            END;
            IF PAYRUN."Pay Code" = HRSETUP.SRT THEN BEGIN
              MSRT := MSRT + PAYRUN.Amount;
            END;
          UNTIL PAYRUN.NEXT=0;

          Employee."Gross Earnings":=MEARN;
          Employee."PAYE Deducted":=MPAYE;
          Employee."FNPF Deducted":=MFNPF;
          Employee."SRL Deducted" := MSRT;
          Employee.MODIFY;
        UNTIL Employee.NEXT = 0;
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        PAYRUN : Record "Pay Run";
        PAYRUNSCHEDULER : Record "Pay Run Scheduler";
        mfrom : Date;
        mto : Date;
        FromDate : Date;
        ToDate : Date;
        mdate : Text[30];
        MPAYE : Decimal;
        MFNPF : Decimal;
        MEARN : Decimal;
        MSRT : Decimal;
        FNPFCode : Code[10];
        PAYECode : Code[10];
        SRLCode : Code[10];
        DisplayReportDate : Text[100];
        PeriodEmployed : Text[100];
        VATREG1 : Text[1];
        VATREG2 : Text[1];
        VATREG3 : Text[1];
        VATREG4 : Text[1];
        VATREG5 : Text[1];
        VATREG6 : Text[1];
        VATREG7 : Text[1];
        VATREG8 : Text[1];
        VATREG9 : Text[1];
        EMPTIN1 : Text[1];
        EMPTIN2 : Text[1];
        EMPTIN3 : Text[1];
        EMPTIN4 : Text[1];
        EMPTIN5 : Text[1];
        EMPTIN6 : Text[1];
        EMPTIN7 : Text[1];
        EMPTIN8 : Text[1];
        EMPTIN9 : Text[1];
        EMPFNPF1 : Text[1];
        EMPFNPF2 : Text[1];
        EMPFNPF3 : Text[1];
        EMPFNPF4 : Text[1];
        EMPFNPF5 : Text[1];
        EMPFNPF6 : Text[1];
        EMPFNPF7 : Text[1];
        EMPFNPF8 : Text[1];
        EMPFNPF9 : Text[1];
        EMPFNPF10 : Text[1];
        EMPFNPF11 : Text[1];
        TEXT001 : Label 'ORIGINAL';
        TEXT002 : Label 'TAX WITHHOLDING CERTIFICATE';
        TEXT003 : Label 'EMPLOYER DETAILS';
        TEXT004 : Label 'Name:';
        TEXT005 : Label 'TIN';
        TEXT006 : Label 'EMPLOYEE DETAILS';
        TEXT007 : Label 'First Name:';
        TEXT008 : Label 'Middle Name:';
        TEXT009 : Label 'Last Name:';
        TEXT010 : Label 'Tax Code (P or S):';
        TEXT011 : Label 'Period Employed:';
        TEXT012 : Label 'Date of Birth:';
        TEXT013 : Label 'FNPF No.:';
        TEXT014 : Label 'to';
        TEXT015 : Label 'Gross Wages/Earnings';
        TEXT016 : Label 'Director Fees';
        TEXT017 : Label 'Management Fees';
        TEXT018 : Label 'Redundancy Payment';
        TEXT019 : Label 'Pension Income';
        TEXT020 : Label 'Lump Sum Payment';
        TEXT021 : Label 'Non-Cash Benefits (Specify in Comments)';
        TEXT022 : Label 'PAYE Tax Deducted';
        TEXT023 : Label 'SRT Deducted';
        TEXT024 : Label 'FNPF Deducted';
        TEXT025 : Label 'Comments';
        TEXT026 : Label 'Signature of the Employer/Authorised Person ______________________________________________';
        TEXT027 : Label 'Date:';
        TEXT028 : Label '_ _ /_ _ /_ _';
        TEXT029 : Label 'IRS452A [Revised: 23-Dec-2013]';
        TEXT030 : TextConst ENU='<_ _ _ _ _       _ _ _ _ _ >',ENA='_ _ _ _ _ _     _ _ _ _ _ _';
        TEXT031 : Label 'DUPLICATE';
        EmployeeNo : Code[10];
}

