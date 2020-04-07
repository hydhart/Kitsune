report 50211 "Employee Pay Summary"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employee Pay Summary.rdlc';

    dataset
    {
        dataitem(Employee;"Employee Pay Details")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Branch Code","Shift Code","Calendar Code","Statistics Group";
            column(No_Employee;Employee."No.")
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
            column(GrossStandardPay_Employee;Employee."Gross Standard Pay")
            {
            }
            column(AnnualPay_Employee;Employee."Annual Pay")
            {
            }
            column(EmployeeRate_Employee;Employee."Employee Rate")
            {
            }
            column(Units_Employee;Employee.Units)
            {
            }
            column(RunsPerCalendar_Employee;Employee."Runs Per Calendar")
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
            dataitem(EmployeeMaster;Employee)
            {
                DataItemLink = No.=FIELD(No.);
                column(SearchName_Employee;EmployeeMaster."Search Name")
                {
                }
            }
            dataitem("Employee Pay Table";"Employee Pay Table")
            {
                DataItemLink = Employee No.=FIELD(No.);
                RequestFilterFields = "Pay Code","Pay Type","Include Standard Elements";
                column(PayReference_EmployeePayTable;"Employee Pay Table"."Pay Reference")
                {
                }
                column(Rate_EmployeePayTable;"Employee Pay Table".Rate)
                {
                }
                column(Units_EmployeePayTable;"Employee Pay Table".Units)
                {
                }
                column(Amount_EmployeePayTable;"Employee Pay Table".Amount)
                {
                }
                column(PayCode_EmployeePayTable;"Employee Pay Table"."Pay Code")
                {
                }
                column(PayDescription_EmployeePayTable;"Employee Pay Table"."Pay Description")
                {
                }
                column(PayType_EmployeePayTable;"Employee Pay Table"."Pay Type")
                {
                }
            }
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

    trigger OnPreReport();
    begin
        HRSETUP.GET();
        NormalHours := HRSETUP."Normal Hours";
        FNPF := HRSETUP.FNPF;
        PAYE := HRSETUP.PAYE;
        SRL := HRSETUP.SRT;

        EmployeePayTable.INIT;
        EmployeePayTable.RESET;
        EmployeePayTable.SETRANGE("Pay Code", NormalHours);
        IF EmployeePayTable.FINDFIRST() THEN REPEAT
          EmployeePayTable."Include Standard Elements" := TRUE;
          EmployeePayTable.MODIFY;
        UNTIL EmployeePayTable.NEXT = 0;

        EmployeePayTable.INIT;
        EmployeePayTable.RESET;
        EmployeePayTable.SETRANGE("Pay Code", FNPF);
        IF EmployeePayTable.FINDFIRST() THEN REPEAT
          EmployeePayTable."Include Standard Elements" := TRUE;
          EmployeePayTable.MODIFY;
        UNTIL EmployeePayTable.NEXT = 0;

        EmployeePayTable.INIT;
        EmployeePayTable.RESET;
        EmployeePayTable.SETRANGE("Pay Code", PAYE);
        IF EmployeePayTable.FINDFIRST() THEN REPEAT
          EmployeePayTable."Include Standard Elements" := TRUE;
          EmployeePayTable.MODIFY;
        UNTIL EmployeePayTable.NEXT = 0;

        EmployeePayTable.INIT;
        EmployeePayTable.RESET;
        EmployeePayTable.SETRANGE("Pay Code", SRL);
        IF EmployeePayTable.FINDFIRST() THEN REPEAT
          EmployeePayTable."Include Standard Elements" := TRUE;
          EmployeePayTable.MODIFY;
        UNTIL EmployeePayTable.NEXT = 0;
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        NormalHours : Code[10];
        FNPF : Code[10];
        PAYE : Code[10];
        SRL : Code[10];
        EmployeePayTable : Record "Employee Pay Table";
        TEXT001 : TextConst ENU='Employee Pay Summary',ENA='Employee Timesheet';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
}

