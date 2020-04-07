report 50209 "Employee Details Report"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employee Details Report.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(Picture_Employee;Employee.Picture)
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(No_Employee;Employee."No.")
            {
            }
            column(Title_Employee;Employee.Title)
            {
            }
            column(SearchName_Employee;Employee."Search Name")
            {
            }
            column(Gender_Employee;Employee.Gender)
            {
            }
            column(Address_Employee;Employee.Address)
            {
            }
            column(Address2_Employee;Employee."Address 2")
            {
            }
            column(City_Employee;Employee.City)
            {
            }
            column(PostCode_Employee;Employee."Post Code")
            {
            }
            column(County_Employee;Employee.County)
            {
            }
            column(PhoneNo_Employee;Employee."Phone No.")
            {
            }
            column(MobilePhoneNo_Employee;Employee."Mobile Phone No.")
            {
            }
            column(EMail_Employee;Employee."E-Mail")
            {
            }
            column(EmploymentDate_Employee;Employee."Employment Date")
            {
            }
            column(Status_Employee;Employee.Status)
            {
            }
            column(BirthDate_Employee;Employee."Birth Date")
            {
            }
            column(InactiveDate_Employee;Employee."Inactive Date")
            {
            }
            column(TerminationDate_Employee;Employee."Termination Date")
            {
            }
            column(GlobalDimension1Code_Employee;Employee."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_Employee;Employee."Global Dimension 2 Code")
            {
            }
            column(Pager_Employee;Employee.Pager)
            {
            }
            column(FaxNo_Employee;Employee."Fax No.")
            {
            }
            column(CompanyEMail_Employee;Employee."Company E-Mail")
            {
            }
            column(SalespersPurchCode_Employee;Employee."Salespers./Purch. Code")
            {
            }
            column(BranchCode_Employee;Employee."Branch Code")
            {
            }
            column(ShiftCode_Employee;Employee."Shift Code")
            {
            }
            column(CalendarCode_Employee;Employee."Calendar Code")
            {
            }
            column(StatisticsGroup_Employee;Employee."Statistics Group")
            {
            }
            dataitem("Employee Pay Details";"Employee Pay Details")
            {
                DataItemLink = No.=FIELD(No.);
                column(GrossStandardPay_Employee;"Employee Pay Details"."Gross Standard Pay")
                {
                }
                column(AnnualPay_Employee;"Employee Pay Details"."Annual Pay")
                {
                }
                column(EmployeeRate_Employee;"Employee Pay Details"."Employee Rate")
                {
                }
                column(Units_Employee;"Employee Pay Details".Units)
                {
                }
                column(RunsPerCalendar_Employee;"Employee Pay Details"."Runs Per Calendar")
                {
                }
                column(ResidentialNonResidential_Employee;"Employee Pay Details"."Residential/Non-Residential")
                {
                }
                column(TaxCode_Employee;"Employee Pay Details"."Tax Code")
                {
                }
                column(OccupationCode_Employee;"Employee Pay Details"."Occupation Code")
                {
                }
                column(ByPassFNPF_Employee;"Employee Pay Details"."By Pass FNPF")
                {
                }
                column(EmployeeFNPF_Employee;"Employee Pay Details"."Employee FNPF")
                {
                }
                column(EmployeeTIN_Employee;"Employee Pay Details"."Employee TIN")
                {
                }
                column(EmployeeFNPFAdditionalCont_Employee;"Employee Pay Details"."Employee FNPF Additional Cont.")
                {
                }
                column(EmployerFNPFAdditionalCont_Employee;"Employee Pay Details"."Employer FNPF Additional Cont.")
                {
                }
                column(EmployeeSecondaryTax_Employee;"Employee Pay Details"."Employee Secondary Tax")
                {
                }
                column(IncrementDate1;IncrementDate[1])
                {
                }
                column(IncrementDate2;IncrementDate[2])
                {
                }
                column(IncrementDate3;IncrementDate[3])
                {
                }
                column(IncrementDate4;IncrementDate[4])
                {
                }
                column(IncrementDate5;IncrementDate[5])
                {
                }
                column(IncrementDate6;IncrementDate[6])
                {
                }
                column(IncrementDate7;IncrementDate[7])
                {
                }
                column(IncrementDate8;IncrementDate[8])
                {
                }
                column(IncrementDate9;IncrementDate[9])
                {
                }
                column(IncrementDate10;IncrementDate[10])
                {
                }
                column(IncrementDate11;IncrementDate[11])
                {
                }
                column(IncrementDate12;IncrementDate[12])
                {
                }
                column(IncrementDate13;IncrementDate[13])
                {
                }
                column(IncrementDate14;IncrementDate[14])
                {
                }
                column(IncrementDate15;IncrementDate[15])
                {
                }
                column(IncrementDate16;IncrementDate[16])
                {
                }
                column(IncrementDate17;IncrementDate[17])
                {
                }
                column(IncrementDate18;IncrementDate[18])
                {
                }
                column(IncrementDate19;IncrementDate[19])
                {
                }
                column(IncrementDate20;IncrementDate[20])
                {
                }
                column(AnnualPay1;AnnualPay[1])
                {
                }
                column(AnnualPay2;AnnualPay[2])
                {
                }
                column(AnnualPay3;AnnualPay[3])
                {
                }
                column(AnnualPay4;AnnualPay[4])
                {
                }
                column(AnnualPay5;AnnualPay[5])
                {
                }
                column(AnnualPay6;AnnualPay[6])
                {
                }
                column(AnnualPay7;AnnualPay[7])
                {
                }
                column(AnnualPay8;AnnualPay[8])
                {
                }
                column(AnnualPay9;AnnualPay[9])
                {
                }
                column(AnnualPay10;AnnualPay[10])
                {
                }
                column(AnnualPay11;AnnualPay[11])
                {
                }
                column(AnnualPay12;AnnualPay[12])
                {
                }
                column(AnnualPay13;AnnualPay[13])
                {
                }
                column(AnnualPay14;AnnualPay[14])
                {
                }
                column(AnnualPay15;AnnualPay[15])
                {
                }
                column(AnnualPay16;AnnualPay[16])
                {
                }
                column(AnnualPay17;AnnualPay[17])
                {
                }
                column(AnnualPay18;AnnualPay[18])
                {
                }
                column(AnnualPay19;AnnualPay[19])
                {
                }
                column(AnnualPay20;AnnualPay[20])
                {
                }
                column(Rate1;Rate[1])
                {
                }
                column(Rate2;Rate[2])
                {
                }
                column(Rate3;Rate[3])
                {
                }
                column(Rate4;Rate[4])
                {
                }
                column(Rate5;Rate[5])
                {
                }
                column(Rate6;Rate[6])
                {
                }
                column(Rate7;Rate[7])
                {
                }
                column(Rate8;Rate[8])
                {
                }
                column(Rate9;Rate[9])
                {
                }
                column(Rate10;Rate[10])
                {
                }
                column(Rate11;Rate[11])
                {
                }
                column(Rate12;Rate[12])
                {
                }
                column(Rate13;Rate[13])
                {
                }
                column(Rate14;Rate[14])
                {
                }
                column(Rate15;Rate[15])
                {
                }
                column(Rate16;Rate[16])
                {
                }
                column(Rate17;Rate[17])
                {
                }
                column(Rate18;Rate[18])
                {
                }
                column(Rate19;Rate[19])
                {
                }
                column(Rate20;Rate[20])
                {
                }
                column(Unit1;Unit[1])
                {
                }
                column(Unit2;Unit[2])
                {
                }
                column(Unit3;Unit[3])
                {
                }
                column(Unit4;Unit[4])
                {
                }
                column(Unit5;Unit[5])
                {
                }
                column(Unit6;Unit[6])
                {
                }
                column(Unit7;Unit[7])
                {
                }
                column(Unit8;Unit[8])
                {
                }
                column(Unit9;Unit[9])
                {
                }
                column(Unit10;Unit[10])
                {
                }
                column(Unit11;Unit[11])
                {
                }
                column(Unit12;Unit[12])
                {
                }
                column(Unit13;Unit[13])
                {
                }
                column(Unit14;Unit[14])
                {
                }
                column(Unit15;Unit[15])
                {
                }
                column(Unit16;Unit[16])
                {
                }
                column(Unit17;Unit[17])
                {
                }
                column(Unit18;Unit[18])
                {
                }
                column(Unit19;Unit[19])
                {
                }
                column(Unit20;Unit[20])
                {
                }
                column(BankCode1;BankCode[1])
                {
                }
                column(BankCode2;BankCode[2])
                {
                }
                column(BankCode3;BankCode[3])
                {
                }
                column(BankCode4;BankCode[4])
                {
                }
                column(BankCode5;BankCode[5])
                {
                }
                column(BankName1;BankName[1])
                {
                }
                column(BankName2;BankName[2])
                {
                }
                column(BankName3;BankName[3])
                {
                }
                column(BankName4;BankName[4])
                {
                }
                column(BankName5;BankName[5])
                {
                }
                column(IsDirect1;IsDirect[1])
                {
                }
                column(IsDirect2;IsDirect[2])
                {
                }
                column(IsDirect3;IsDirect[3])
                {
                }
                column(IsDirect4;IsDirect[4])
                {
                }
                column(IsDirect5;IsDirect[5])
                {
                }
                column(IsBalance1;IsBalance[1])
                {
                }
                column(IsBalance2;IsBalance[2])
                {
                }
                column(IsBalance3;IsBalance[3])
                {
                }
                column(IsBalance4;IsBalance[4])
                {
                }
                column(IsBalance5;IsBalance[5])
                {
                }
                column(DistributionPercentage1;DistributionPercentage[1])
                {
                }
                column(DistributionPercentage2;DistributionPercentage[2])
                {
                }
                column(DistributionPercentage3;DistributionPercentage[3])
                {
                }
                column(DistributionPercentage4;DistributionPercentage[4])
                {
                }
                column(DistributionPercentage5;DistributionPercentage[5])
                {
                }
                column(DistributionAmount1;DistributionAmount[1])
                {
                }
                column(DistributionAmount2;DistributionAmount[2])
                {
                }
                column(DistributionAmount3;DistributionAmount[3])
                {
                }
                column(DistributionAmount4;DistributionAmount[4])
                {
                }
                column(DistributionAmount5;DistributionAmount[5])
                {
                }
                column(BankAccountNo1;BankAccountNo[1])
                {
                }
                column(BankAccountNo2;BankAccountNo[2])
                {
                }
                column(BankAccountNo3;BankAccountNo[3])
                {
                }
                column(BankAccountNo4;BankAccountNo[4])
                {
                }
                column(BankAccountNo5;BankAccountNo[5])
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
                column(PrintPhoto_HRSETUP;HRSETUP."Print Photo")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                FOR i := 1 TO 20 DO
                  InitializePayHistoryArray();

                i := 1;

                EmployeePayHistory.INIT;
                EmployeePayHistory.RESET;
                EmployeePayHistory.SETRANGE("Employee No.", "No.");
                IF EmployeePayHistory.FINDFIRST() THEN REPEAT
                  IncrementDate[i] := EmployeePayHistory."Increment Date";
                  AnnualPay[i] := EmployeePayHistory."Annual Pay";
                  Rate[i] := EmployeePayHistory.Rate;
                  Unit[i] := EmployeePayHistory.Units;
                  i := i + 1;
                UNTIL EmployeePayHistory.NEXT = 0;


                FOR j := 1 TO 5 DO
                  InitializeMultipleBankArray;

                j := 1;

                MultipleBankDistribution.INIT;
                MultipleBankDistribution.RESET;
                MultipleBankDistribution.SETRANGE("Employee No.", "No.");
                MultipleBankDistribution.SETRANGE(Active, TRUE);
                IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                  BankCode[j] := MultipleBankDistribution."Bank Code";
                  BankName[j] := MultipleBankDistribution."Bank Name";
                  IsDirect[j] := MultipleBankDistribution."Is Direct";
                  IsBalance[j] := MultipleBankDistribution."Is Balance";
                  DistributionPercentage[j] := MultipleBankDistribution."Distribution Percentage";
                  DistributionAmount[j] := MultipleBankDistribution."Distribution Amount";
                  BankAccountNo[j] := MultipleBankDistribution."Employee Bank Account No.";
                  j := j + 1;
                UNTIL MultipleBankDistribution.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Show Employee Photo";"Show Employee Photo")
                {

                    trigger OnValidate();
                    begin
                        HRSETUP.GET();
                        HRSETUP."Print Photo" := FALSE;
                        HRSETUP.MODIFY;

                        IF "Show Employee Photo" = TRUE THEN BEGIN
                          HRSETUP."Print Photo" := TRUE;
                          HRSETUP.MODIFY;
                        END;
                    end;
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

    trigger OnInitReport();
    begin
        //IF "Show Employee Photo" = TRUE THEN BEGIN
        //  Employee.CALCFIELDS(Picture);
        //END;
    end;

    var
        IncrementDate : array [20] of Date;
        AnnualPay : array [20] of Decimal;
        Rate : array [20] of Decimal;
        Unit : array [20] of Decimal;
        i : Integer;
        EmployeePayHistory : Record "Employee Pay History";
        BankCode : array [5] of Code[10];
        BankName : array [5] of Text[30];
        IsDirect : array [5] of Boolean;
        IsBalance : array [5] of Boolean;
        DistributionPercentage : array [5] of Decimal;
        DistributionAmount : array [5] of Decimal;
        BankAccountNo : array [5] of Code[30];
        j : Integer;
        MultipleBankDistribution : Record "Multiple Bank Distribution";
        TEXT001 : TextConst ENU='Employee Details Report',ENA='Employee Timesheet';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        "Show Employee Photo" : Boolean;
        HRSETUP : Record "Human Resources Setup";

    local procedure InitializePayHistoryArray();
    begin
        IncrementDate[i] := 0D;
        AnnualPay[i] := 0;
        Rate[i] := 0;
        Unit[i] := 0;

        EXIT;
    end;

    local procedure InitializeMultipleBankArray();
    begin
        BankCode[j] := '';
        BankName[j] := '';
        IsDirect[j] := FALSE;
        IsBalance[j] := FALSE;
        DistributionPercentage[j] := 0;
        DistributionAmount[j] := 0;
        BankAccountNo[j] := '';

        EXIT;
    end;
}

