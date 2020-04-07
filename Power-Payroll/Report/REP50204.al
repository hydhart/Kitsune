report 50204 "Payroll Register Dynamic"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Payroll Register Dynamic.rdlc';

    dataset
    {
        dataitem(Employee;"Employee Pay Details")
        {
            DataItemTableView = SORTING(No.) ORDER(Ascending) WHERE(Print in Payroll Register=FILTER(Yes));
            column(No_Employee;Employee."No.")
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PAGENO)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TEXT001;TEXT001)
            {
            }
            column(DisplayFilter;DisplayFilter)
            {
            }
            column(Rate;Rate)
            {
            }
            column(Hours10x;"Hours1.0x")
            {
            }
            column(Hours15x;"Hours1.5x")
            {
            }
            column(Hours20x;"Hours2.0x")
            {
            }
            column(DisplayAmount1;DisplayAmount[1])
            {
            }
            column(DisplayAmount2;DisplayAmount[2])
            {
            }
            column(DisplayAmount3;DisplayAmount[3])
            {
            }
            column(DisplayAmount4;DisplayAmount[4])
            {
            }
            column(DisplayAmount5;DisplayAmount[5])
            {
            }
            column(DisplayAmount6;DisplayAmount[6])
            {
            }
            column(DisplayAmount7;DisplayAmount[7])
            {
            }
            column(DisplayAmount8;DisplayAmount[8])
            {
            }
            column(DisplayAmount9;DisplayAmount[9])
            {
            }
            column(DisplayAmount10;DisplayAmount[10])
            {
            }
            column(DisplayAmount11;DisplayAmount[11])
            {
            }
            column(DisplayAmount12;DisplayAmount[12])
            {
            }
            column(DisplayAmount13;DisplayAmount[13])
            {
            }
            column(DisplayAmount14;DisplayAmount[14])
            {
            }
            column(DisplayAmount15;DisplayAmount[15])
            {
            }
            column(DisplayAmount16;DisplayAmount[16])
            {
            }
            column(DisplayAmount17;DisplayAmount[17])
            {
            }
            column(DisplayAmount18;DisplayAmount[18])
            {
            }
            column(DisplayAmount19;DisplayAmount[19])
            {
            }
            column(DisplayAmount20;DisplayAmount[20])
            {
            }
            column(DisplayAmount21;DisplayAmount[21])
            {
            }
            column(DisplayAmount22;DisplayAmount[22])
            {
            }
            column(DisplayAmount23;DisplayAmount[23])
            {
            }
            column(DisplayAmount24;DisplayAmount[24])
            {
            }
            column(DisplayAmount25;DisplayAmount[25])
            {
            }
            column(DisplayAmount26;DisplayAmount[26])
            {
            }
            column(DisplayAmount27;DisplayAmount[27])
            {
            }
            column(DisplayAmount28;DisplayAmount[28])
            {
            }
            column(DisplayAmount29;DisplayAmount[29])
            {
            }
            column(DisplayAmount30;DisplayAmount[30])
            {
            }
            column(DisplayAmount31;DisplayAmount[31])
            {
            }
            column(DisplayAmount32;DisplayAmount[32])
            {
            }
            column(DisplayAmount33;DisplayAmount[33])
            {
            }
            column(DisplayAmount34;DisplayAmount[34])
            {
            }
            column(DisplayAmount35;DisplayAmount[35])
            {
            }
            column(DisplayAmount36;DisplayAmount[36])
            {
            }
            column(DisplayAmount37;DisplayAmount[37])
            {
            }
            column(DisplayAmount38;DisplayAmount[38])
            {
            }
            column(DisplayAmount39;DisplayAmount[39])
            {
            }
            column(DisplayAmount40;DisplayAmount[40])
            {
            }
            column(DisplayAmount41;DisplayAmount[41])
            {
            }
            column(DisplayAmount42;DisplayAmount[42])
            {
            }
            column(DisplayAmount43;DisplayAmount[43])
            {
            }
            column(DisplayAmount44;DisplayAmount[44])
            {
            }
            column(DisplayAmount45;DisplayAmount[45])
            {
            }
            column(DisplayAmount46;DisplayAmount[46])
            {
            }
            column(DisplayAmount47;DisplayAmount[47])
            {
            }
            column(DisplayAmount48;DisplayAmount[48])
            {
            }
            column(DisplayAmount49;DisplayAmount[49])
            {
            }
            column(DisplayAmount50;DisplayAmount[50])
            {
            }
            column(DisplayHeader1;DisplayHeader[1])
            {
            }
            column(DisplayHeader2;DisplayHeader[2])
            {
            }
            column(DisplayHeader3;DisplayHeader[3])
            {
            }
            column(DisplayHeader4;DisplayHeader[4])
            {
            }
            column(DisplayHeader5;DisplayHeader[5])
            {
            }
            column(DisplayHeader6;DisplayHeader[6])
            {
            }
            column(DisplayHeader7;DisplayHeader[7])
            {
            }
            column(DisplayHeader8;DisplayHeader[8])
            {
            }
            column(DisplayHeader9;DisplayHeader[9])
            {
            }
            column(DisplayHeader10;DisplayHeader[10])
            {
            }
            column(DisplayHeader11;DisplayHeader[11])
            {
            }
            column(DisplayHeader12;DisplayHeader[12])
            {
            }
            column(DisplayHeader13;DisplayHeader[13])
            {
            }
            column(DisplayHeader14;DisplayHeader[14])
            {
            }
            column(DisplayHeader15;DisplayHeader[15])
            {
            }
            column(DisplayHeader16;DisplayHeader[16])
            {
            }
            column(DisplayHeader17;DisplayHeader[17])
            {
            }
            column(DisplayHeader18;DisplayHeader[18])
            {
            }
            column(DisplayHeader19;DisplayHeader[19])
            {
            }
            column(DisplayHeader20;DisplayHeader[20])
            {
            }
            column(DisplayHeader21;DisplayHeader[21])
            {
            }
            column(DisplayHeader22;DisplayHeader[22])
            {
            }
            column(DisplayHeader23;DisplayHeader[23])
            {
            }
            column(DisplayHeader24;DisplayHeader[24])
            {
            }
            column(DisplayHeader25;DisplayHeader[25])
            {
            }
            column(DisplayHeader26;DisplayHeader[26])
            {
            }
            column(DisplayHeader27;DisplayHeader[27])
            {
            }
            column(DisplayHeader28;DisplayHeader[28])
            {
            }
            column(DisplayHeader29;DisplayHeader[29])
            {
            }
            column(DisplayHeader30;DisplayHeader[30])
            {
            }
            column(DisplayHeader31;DisplayHeader[31])
            {
            }
            column(DisplayHeader32;DisplayHeader[32])
            {
            }
            column(DisplayHeader33;DisplayHeader[33])
            {
            }
            column(DisplayHeader34;DisplayHeader[34])
            {
            }
            column(DisplayHeader35;DisplayHeader[35])
            {
            }
            column(DisplayHeader36;DisplayHeader[36])
            {
            }
            column(DisplayHeader37;DisplayHeader[37])
            {
            }
            column(DisplayHeader38;DisplayHeader[38])
            {
            }
            column(DisplayHeader39;DisplayHeader[39])
            {
            }
            column(DisplayHeader40;DisplayHeader[40])
            {
            }
            column(DisplayHeader41;DisplayHeader[41])
            {
            }
            column(DisplayHeader42;DisplayHeader[42])
            {
            }
            column(DisplayHeader43;DisplayHeader[43])
            {
            }
            column(DisplayHeader44;DisplayHeader[44])
            {
            }
            column(DisplayHeader45;DisplayHeader[45])
            {
            }
            column(DisplayHeader46;DisplayHeader[46])
            {
            }
            column(DisplayHeader47;DisplayHeader[47])
            {
            }
            column(DisplayHeader48;DisplayHeader[48])
            {
            }
            column(DisplayHeader49;DisplayHeader[49])
            {
            }
            column(DisplayHeader50;DisplayHeader[50])
            {
            }
            column(DisplayBankHeader1;DisplayBankHeader[1])
            {
            }
            column(DisplayBankAmount1;DisplayBankAmount[1])
            {
            }
            dataitem(EmployeeMaster;Employee)
            {
                DataItemLink = No.=FIELD(No.);
                column(SearchName_Employee;EmployeeMaster."Search Name")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                TotalOtherEarningsTaxable := 0;
                TotalOtherEarningsNonTaxable := 0;
                TotalOtherDeductionsTaxable := 0;
                TotalOtherDeductionsNonTaxable := 0;
                GrossPayTaxable := 0;
                DeductionsTaxable := 0;
                GrossPayNonTaxable := 0;
                DeductionsNonTaxable := 0;
                Rate := 0;
                IncrementDate := 0D;
                ICount := 0;
                ICountGross := 0;
                ICountNet := 0;


                PAYRUN.INIT;
                PAYRUN.RESET;
                PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                PAYRUN.SETRANGE("Branch Code", BranchCode);
                PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                PAYRUN.SETRANGE("Shift Code", ShiftCode);
                PAYRUN.SETRANGE("Employee No.", "No.");
                IF PAYRUN.FINDFIRST() THEN BEGIN
                  IncrementDate := PAYRUN."Increment Date";
                END;

                IF HRSETUP."Show Rate" = TRUE THEN BEGIN
                  IF EmployeePayHistory.GET("No.", IncrementDate) THEN BEGIN
                    Rate := EmployeePayHistory.Rate;
                  END;
                END;

                "Hours1.0x" := 0;
                "Hours1.5x" := 0;
                "Hours2.0x" := 0;


                //GENERAL GROSS TAXABLE AND NON TAXABLE
                PAYRUN.INIT;
                PAYRUN.RESET;
                PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                PAYRUN.SETRANGE("Branch Code", BranchCode);
                PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                PAYRUN.SETRANGE("Shift Code", ShiftCode);
                PAYRUN.SETRANGE("Employee No.", "No.");
                IF PAYRUN.FINDFIRST() THEN REPEAT
                  IF PAYRUN."Pay Type" = 0 THEN BEGIN    //EARNINGS
                  //Taxable
                    IF PAYRUN."Pay Category" = 0 THEN BEGIN
                      IF PAYRUN."Is PAYE Base" = TRUE THEN BEGIN
                        GrossPayTaxable := GrossPayTaxable + PAYRUN.Amount;
                      END;
                    END;
                  //NonTaxable
                    IF PAYRUN."Pay Category" = 1 THEN BEGIN
                      IF PAYRUN."Is PAYE Base" = FALSE THEN BEGIN
                        GrossPayNonTaxable := GrossPayNonTaxable + PAYRUN.Amount;
                      END;
                    END;
                  END;

                  IF PAYRUN."Pay Type" = 1 THEN BEGIN    //DEDUCTIONS
                  //Taxable
                    IF PAYRUN."Pay Category" = 0 THEN BEGIN
                      IF PAYRUN."Is PAYE Base" = TRUE THEN BEGIN
                        DeductionsTaxable := DeductionsTaxable + PAYRUN.Amount;
                      END;
                    END;
                  //NonTaxable
                    IF PAYRUN."Pay Category" = 1 THEN BEGIN
                      IF PAYRUN."Is PAYE Base" = FALSE THEN BEGIN
                        DeductionsNonTaxable := DeductionsNonTaxable + PAYRUN.Amount;
                      END;
                    END;
                  END;
                UNTIL PAYRUN.NEXT = 0;


                //Taxable
                FOR i := 1 TO MAXPriorityEarningTaxable DO
                IF i <= MAXPriorityEarningTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Is PAYE Base", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 0);
                  PayElementMaster.SETRANGE("Pay Category", 0);
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayAmount[i] := 0;

                    PAYRUN.INIT;
                    PAYRUN.RESET;
                    PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                    PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                    PAYRUN.SETRANGE("Branch Code", BranchCode);
                    PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                    PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                    PAYRUN.SETRANGE("Shift Code", ShiftCode);
                    PAYRUN.SETRANGE("Employee No.", "No.");
                    PAYRUN.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                    IF PAYRUN.FINDFIRST() THEN BEGIN

                      IF HRSETUP."Show 1.5x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Pay Code" = NormalHours THEN BEGIN
                          "Hours1.0x" := "Hours1.0x" + PAYRUN.Units;
                        END;
                      END;

                      IF HRSETUP."Show 1.5x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Rate Type" = 1 THEN BEGIN
                          "Hours1.5x" := "Hours1.5x" + PAYRUN.Units;
                        END;
                      END;

                      IF HRSETUP."Show 2.0x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Rate Type" = 2 THEN BEGIN
                          "Hours2.0x" := "Hours2.0x" + PAYRUN.Units;
                        END;
                      END;


                      DisplayAmount[i] := 0;
                      DisplayAmount[i] := DisplayAmount[i] + PAYRUN.Amount;
                      TotalOtherEarningsTaxable := TotalOtherEarningsTaxable + PAYRUN.Amount;

                    END;
                  END;
                END;

                IF MAXPriorityEarningNonTaxable > 0 THEN BEGIN
                  ICount := MAXPriorityEarningTaxable + 1;
                END;

                //Non Taxable
                FOR i := ICount TO MAXPriorityEarningNonTaxable DO
                IF i <= MAXPriorityEarningNonTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Is PAYE Base", FALSE);
                  PayElementMaster.SETRANGE("Pay Type", 0);
                  PayElementMaster.SETRANGE("Pay Category", 1);
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayAmount[i] := 0;

                    PAYRUN.INIT;
                    PAYRUN.RESET;
                    PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                    PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                    PAYRUN.SETRANGE("Branch Code", BranchCode);
                    PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                    PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                    PAYRUN.SETRANGE("Shift Code", ShiftCode);
                    PAYRUN.SETRANGE("Employee No.", "No.");
                    PAYRUN.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                    IF PAYRUN.FINDFIRST() THEN BEGIN

                      IF HRSETUP."Show 1.5x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Pay Code" = NormalHours THEN BEGIN
                          "Hours1.0x" := "Hours1.0x" + PAYRUN.Units;
                        END;
                      END;

                      IF HRSETUP."Show 1.5x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Rate Type" = 1 THEN BEGIN
                          "Hours1.5x" := "Hours1.5x" + PAYRUN.Units;
                        END;
                      END;

                      IF HRSETUP."Show 2.0x Hours" = TRUE THEN BEGIN
                        IF PAYRUN."Rate Type" = 2 THEN BEGIN
                          "Hours2.0x" := "Hours2.0x" + PAYRUN.Units;
                        END;
                      END;

                      DisplayAmount[i] := 0;
                      DisplayAmount[i] := DisplayAmount[i] + PAYRUN.Amount;
                      TotalOtherEarningsNonTaxable := TotalOtherEarningsNonTaxable + PAYRUN.Amount;

                    END;
                  END;
                END;

                //PRINT TAXABLE HEADER ONLY
                FOR i := 1 TO MAXPriorityEarningTaxable DO
                IF i <= MAXPriorityEarningTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Is PAYE Base", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 0);
                  PayElementMaster.SETRANGE("Pay Category", 0);
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayHeader[i] := PayElementMaster."Pay Description";
                    IF PayElementMaster."Earnings Column Name" <> '' THEN BEGIN
                      DisplayHeader[i] := PayElementMaster."Earnings Column Name";
                    END;
                  END;
                END;

                //PRINT NOT TAXABLE HEADER ONLY
                FOR i := ICount TO MAXPriorityEarningNonTaxable DO
                IF i <= MAXPriorityEarningNonTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Is PAYE Base", FALSE);
                  PayElementMaster.SETRANGE("Pay Type", 0);
                  PayElementMaster.SETRANGE("Pay Category", 1);
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayHeader[i] := PayElementMaster."Pay Description";
                    IF PayElementMaster."Earnings Column Name" <> '' THEN BEGIN
                      DisplayHeader[i] := PayElementMaster."Earnings Column Name";
                    END;
                  END;
                END;


                IF MAXPriorityEarningTaxable > MAXPriorityEarningNonTaxable THEN BEGIN
                  ICountGross := (MAXPriorityEarningTaxable) + 1;
                END;

                IF MAXPriorityEarningTaxable < MAXPriorityEarningNonTaxable THEN BEGIN
                  ICountGross := (MAXPriorityEarningNonTaxable) + 1;
                END;

                DisplayHeader[ICountGross] := '';
                DisplayAmount[ICountGross] := 0;
                DisplayHeader[ICountGross] := 'Gross Pay';
                DisplayAmount[ICountGross] := (TotalOtherEarningsTaxable);


                IF (MAXPriorityEarningTaxable + MAXPriorityEarningNonTaxable) = 0 THEN BEGIN
                  DisplayHeader[1] := '';
                  DisplayAmount[1] := 0;
                  DisplayHeader[1] := 'Gross Pay';
                  DisplayAmount[1] := (GrossPayTaxable);
                  ICountGross := 1;
                END;

                //Taxable
                FOR i := (ICountGross + 1) TO MAXPriorityDeductionTaxable DO
                IF i <= MAXPriorityDeductionTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 1);                   //DEDUCTIONS
                  PayElementMaster.SETRANGE("Pay Category", 0);               //TAXABLE
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayAmount[i] := 0;

                    PAYRUN.INIT;
                    PAYRUN.RESET;
                    PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                    PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                    PAYRUN.SETRANGE("Branch Code", BranchCode);
                    PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                    PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                    PAYRUN.SETRANGE("Shift Code", ShiftCode);
                    PAYRUN.SETRANGE("Employee No.", "No.");
                    PAYRUN.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                    IF PAYRUN.FINDFIRST() THEN BEGIN
                      DisplayAmount[i] := 0;

                      DisplayAmount[i] := DisplayAmount[i] + PAYRUN.Amount;
                      TotalOtherDeductionsTaxable := TotalOtherDeductionsTaxable + PAYRUN.Amount;
                    END;
                  END;
                END;

                //Non Taxable
                FOR i := (MAXPriorityDeductionTaxable + 1) TO MAXPriorityDeductionNonTaxable DO
                IF i <= MAXPriorityDeductionNonTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 1);                   //DEDUCTION
                  PayElementMaster.SETRANGE("Pay Category", 1);               //NON-TAXABLE
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayAmount[i] := 0;

                    PAYRUN.INIT;
                    PAYRUN.RESET;
                    PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
                    PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
                    PAYRUN.SETRANGE("Branch Code", BranchCode);
                    PAYRUN.SETRANGE("Calendar Code", CalendarCode);
                    PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
                    PAYRUN.SETRANGE("Shift Code", ShiftCode);
                    PAYRUN.SETRANGE("Employee No.", "No.");
                    PAYRUN.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                    IF PAYRUN.FINDFIRST() THEN BEGIN
                      DisplayAmount[i] := 0;

                      DisplayAmount[i] := DisplayAmount[i] + PAYRUN.Amount;
                      TotalOtherDeductionsNonTaxable := TotalOtherDeductionsNonTaxable + PAYRUN.Amount;
                    END;
                  END;
                END;


                //PRINT TAXABLE HEADER ONLY
                FOR i := (ICountGross + 1) TO MAXPriorityDeductionTaxable DO
                IF i <= MAXPriorityDeductionTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 1);         //DEDUCTION
                  PayElementMaster.SETRANGE("Pay Category", 0);     //TAXABLE
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayHeader[i] := PayElementMaster."Pay Description";
                    IF PayElementMaster."Earnings Column Name" <> '' THEN BEGIN
                      DisplayHeader[i] := PayElementMaster."Earnings Column Name";
                    END;
                  END;
                END;

                //PRINT NOT TAXABLE HEADER ONLY
                FOR i := (MAXPriorityDeductionTaxable + 1) TO MAXPriorityDeductionNonTaxable DO
                IF i <= MAXPriorityDeductionNonTaxable THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
                  PayElementMaster.SETRANGE("Pay Type", 1);         //DEDUCTION
                  PayElementMaster.SETRANGE("Pay Category", 1);     //TAXABLE
                  PayElementMaster.SETRANGE("Earnings Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayHeader[i] := PayElementMaster."Pay Description";
                    IF PayElementMaster."Earnings Column Name" <> '' THEN BEGIN
                      DisplayHeader[i] := PayElementMaster."Earnings Column Name";
                    END;
                  END;
                END;


                IF MAXPriorityDeductionTaxable > MAXPriorityDeductionNonTaxable THEN BEGIN
                  ICountNet := (MAXPriorityEarningTaxable) + 1;
                END;

                IF  MAXPriorityDeductionTaxable < MAXPriorityDeductionNonTaxable THEN BEGIN
                  ICountNet := (MAXPriorityDeductionNonTaxable) + 1;
                END;

                DisplayHeader[ICountNet] := '';
                DisplayAmount[ICountNet] := 0;
                DisplayHeader[ICountNet] := 'Net Pay';
                DisplayAmount[ICountNet] := (GrossPayTaxable) - ABS(TotalOtherDeductionsTaxable) - ABS(TotalOtherDeductionsNonTaxable);

                IF (MAXPriorityDeductionTaxable + MAXPriorityDeductionNonTaxable) = 0 THEN BEGIN
                  DisplayHeader[ICountGross + 1] := '';
                  DisplayAmount[ICountGross + 1] := 0;
                  DisplayHeader[ICountGross + 1] := 'Net Pay';
                  DisplayAmount[ICountGross + 1] := GrossPayTaxable - ABS(DeductionsTaxable);
                  ICountNet := ICountGross + 1;
                END;

                DisplayBankAmount[1] := 0;

                BankPayDistribution.INIT;
                BankPayDistribution.RESET;
                BankPayDistribution.SETRANGE("Employee No.", "No.");
                BankPayDistribution.SETRANGE("Branch Code", BranchCode);
                BankPayDistribution.SETRANGE("Shift Code", ShiftCode);
                BankPayDistribution.SETRANGE("Calendar Code", CalendarCode);
                BankPayDistribution.SETRANGE("Statistics Group", StatisticsGroup);
                BankPayDistribution.SETFILTER("Pay Run No.", PayRunNo);
                BankPayDistribution.SETFILTER("Special Pay No.", SpecialPayRunNo);
                IF BankPayDistribution.FINDFIRST() THEN BEGIN
                  DisplayBankHeader[1] := 'Bank';
                  DisplayBankAmount[1] := DisplayBankAmount[1] + BankPayDistribution."Net Pay";
                END;
            end;

            trigger OnPreDataItem();
            begin
                DisplayFilter := GETFILTERS;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Branch Code";BranchCode)
                {
                }
                field("Calendar Code";CalendarCode)
                {
                }
                field("Statistics Group Code";StatisticsGroup)
                {
                }
                field("Shift Code";ShiftCode)
                {
                }
                field("Pay Date";PayDate)
                {

                    trigger OnValidate();
                    begin
                        PayRunScheduler.INIT;
                        PayRunScheduler.RESET;
                        PayRunScheduler.SETFILTER("Pay To Date", PayDate);
                        PayRunScheduler.SETRANGE("Branch Code", BranchCode);
                        PayRunScheduler.SETRANGE("Statistics Group", StatisticsGroup);
                        PayRunScheduler.SETRANGE("Shift Code", ShiftCode);
                        PayRunNo := '';
                        SpecialPayRunNo := '';
                        CharcntP := 0;
                        CharcntS := 0;

                        IF PayRunScheduler.FINDFIRST() THEN REPEAT
                          PayRunNo := PayRunNo + PayRunScheduler."Pay Run No." + '|';
                          SpecialPayRunNo := SpecialPayRunNo + PayRunScheduler."Special Pay No." + '|';
                        UNTIL PayRunScheduler.NEXT = 0;

                        CharcntP := STRLEN(PayRunNo);
                        CharcntS := STRLEN(SpecialPayRunNo);

                        PayRunNo := COPYSTR(PayRunNo,1,(CharcntP-1));
                        SpecialPayRunNo := COPYSTR(SpecialPayRunNo,1,(CharcntS-1))
                    end;
                }
                field("Pay Run No.";PayRunNo)
                {
                    Editable = false;
                }
                field("Special Pay Run No.";SpecialPayRunNo)
                {
                    Editable = false;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        HRSETUP.GET();
        NormalHours := HRSETUP."Normal Hours";
        MAXPriorityEarningTaxable := 0;
        MAXPriorityDeductionTaxable := 0;
        MAXPriorityEarningNonTaxable := 0;
        MAXPriorityDeductionNonTaxable := 0;


        Employee.INIT;
        Employee.RESET;
        Employee.SETRANGE("Calendar Code", FORMAT(HRSETUP."Current Payroll Year"));
        IF Employee.FINDFIRST() THEN REPEAT
          Employee."Print in Payroll Register" := FALSE;
          Employee.MODIFY;
        UNTIL Employee.NEXT = 0;

        PAYRUN.INIT;
        PAYRUN.RESET;
        PAYRUN.SETFILTER("Pay Run No.", PayRunNo);
        PAYRUN.SETFILTER("Special Pay No.", SpecialPayRunNo);
        PAYRUN.SETRANGE("Branch Code", BranchCode);
        PAYRUN.SETRANGE("Calendar Code", CalendarCode);
        PAYRUN.SETRANGE("Statistics Group", StatisticsGroup);
        PAYRUN.SETRANGE("Shift Code", ShiftCode);
        IF PAYRUN.FINDFIRST() THEN REPEAT
          Employee.INIT;
          Employee.RESET;
          Employee.SETRANGE("No.", PAYRUN."Employee No.");
          IF Employee.FINDFIRST() THEN BEGIN
            Employee."Print in Payroll Register" := TRUE;
            Employee.MODIFY;
          END;
        UNTIL PAYRUN.NEXT = 0;


        //Earning Count Taxable
        PayElementMaster.INIT;
        PayElementMaster.RESET;
        PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
        PayElementMaster.SETRANGE("Pay Type", 0);
        PayElementMaster.SETRANGE("Pay Category", 0);
        PayElementMaster.SETRANGE("Is PAYE Base", TRUE);
        IF PayElementMaster.FINDFIRST() THEN REPEAT
          TempMAXPriorityEarningTaxable := PayElementMaster."Earnings Column Priority";
          IF MAXPriorityEarningTaxable < TempMAXPriorityEarningTaxable THEN BEGIN
            MAXPriorityEarningTaxable := PayElementMaster."Earnings Column Priority";
          END;
        UNTIL PayElementMaster.NEXT = 0;

        //Earning Count NON Taxable
        PayElementMaster.INIT;
        PayElementMaster.RESET;
        PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
        PayElementMaster.SETRANGE("Pay Type", 0);
        PayElementMaster.SETRANGE("Pay Category", 1);
        PayElementMaster.SETRANGE("Is PAYE Base", FALSE);
        IF PayElementMaster.FINDFIRST() THEN REPEAT
          TempMAXPriorityEarningNonTaxable := PayElementMaster."Earnings Column Priority";
          IF MAXPriorityEarningNonTaxable < TempMAXPriorityEarningNonTaxable THEN BEGIN
            MAXPriorityEarningNonTaxable := PayElementMaster."Earnings Column Priority";
          END;
        UNTIL PayElementMaster.NEXT = 0;


        //Deduction Count Taxable
        PayElementMaster.INIT;
        PayElementMaster.RESET;
        PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
        PayElementMaster.SETRANGE("Pay Type", 1);
        PayElementMaster.SETRANGE("Pay Category", 0);
        IF PayElementMaster.FINDFIRST() THEN REPEAT
          MESSAGE('HELLO WORLD');
          TempMAXPriorityDeductionTaxable := PayElementMaster."Earnings Column Priority";
          IF MAXPriorityDeductionTaxable < TempMAXPriorityDeductionTaxable THEN BEGIN
            MAXPriorityDeductionTaxable := PayElementMaster."Earnings Column Priority";
          END;
        UNTIL PayElementMaster.NEXT = 0;

        //Deduction Count NON Taxable
        PayElementMaster.INIT;
        PayElementMaster.RESET;
        PayElementMaster.SETRANGE("Use in Payroll Register", TRUE);
        PayElementMaster.SETRANGE("Pay Type", 1);
        PayElementMaster.SETRANGE("Pay Category", 1);
        IF PayElementMaster.FINDFIRST() THEN REPEAT
          MESSAGE('GOODBYE WORLD');
          TempMAXPriorityDeductionNonTaxable := PayElementMaster."Earnings Column Priority";
          IF MAXPriorityDeductionNonTaxable < TempMAXPriorityDeductionNonTaxable THEN BEGIN
            MAXPriorityDeductionNonTaxable := PayElementMaster."Earnings Column Priority";
          END;
        UNTIL PayElementMaster.NEXT = 0;
    end;

    var
        TEXT001 : Label 'Payroll Register';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
        PAYRUN : Record "Pay Run";
        DeductionsTaxable : Decimal;
        GrossPayTaxable : Decimal;
        DeductionsNonTaxable : Decimal;
        GrossPayNonTaxable : Decimal;
        Rate : Decimal;
        HRSETUP : Record "Human Resources Setup";
        DateFilter : Text;
        PayRunScheduler : Record "Pay Run Scheduler";
        DisplayHeader : array [50] of Text;
        DisplayAmount : array [50] of Decimal;
        PayElementMaster : Record "Pay Element Master";
        DisplayBankHeader : array [1] of Text;
        DisplayBankAmount : array [1] of Decimal;
        EmployeeNo : Code[10];
        TempMAXPriorityEarningTaxable : Integer;
        MAXPriorityEarningTaxable : Integer;
        TempMAXPriorityDeductionTaxable : Integer;
        MAXPriorityDeductionTaxable : Integer;
        TempMAXPriorityEarningNonTaxable : Integer;
        MAXPriorityEarningNonTaxable : Integer;
        TempMAXPriorityDeductionNonTaxable : Integer;
        MAXPriorityDeductionNonTaxable : Integer;
        i : Integer;
        TotalOtherEarningsTaxable : Decimal;
        TotalOtherEarningsNonTaxable : Decimal;
        ICount : Integer;
        ICountGross : Integer;
        ICountNet : Integer;
        TotalOtherDeductionsTaxable : Decimal;
        TotalOtherDeductionsNonTaxable : Decimal;
        NormalHours : Code[10];
        "Hours1.0x" : Decimal;
        "Hours1.5x" : Decimal;
        "Hours2.0x" : Decimal;
        EmployeePayHistory : Record "Employee Pay History";
        BranchCode : Code[20];
        CalendarCode : Code[4];
        StatisticsGroup : Code[20];
        ShiftCode : Option First,Second,Third,Fourth,Fifth;
        PayRunNo : Code[250];
        SpecialPayRunNo : Code[250];
        IncrementDate : Date;
        PayDate : Text[30];
        CharcntP : Integer;
        CharcntS : Integer;
        BankPayDistribution : Record "Bank Pay Distribution";
}

