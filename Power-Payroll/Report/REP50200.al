report 50200 "Employee Timesheet"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employee Timesheet.rdlc';

    dataset
    {
        dataitem("Employee Timesheet";"Employee Timesheet")
        {
            DataItemTableView = SORTING(Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Employee No.,Pay Code) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.";
            column(BranchCode_EmployeeTimesheet;"Employee Timesheet"."Branch Code")
            {
            }
            column(ShiftCode_EmployeeTimesheet;"Employee Timesheet"."Shift Code")
            {
            }
            column(CalendarCode_EmployeeTimesheet;"Employee Timesheet"."Calendar Code")
            {
            }
            column(StatisticsGroup_EmployeeTimesheet;"Employee Timesheet"."Statistics Group")
            {
            }
            column(PayRunNo_EmployeeTimesheet;"Employee Timesheet"."Pay Run No.")
            {
            }
            column(SpecialPayNo_EmployeeTimesheet;"Employee Timesheet"."Special Pay No.")
            {
            }
            column(EmployeeNo_EmployeeTimesheet;"Employee Timesheet"."Employee No.")
            {
            }
            column(EmployeeName_EmployeeTimesheet;"Employee Timesheet"."Employee Name")
            {
            }
            column(PayCode_EmployeeTimesheet;"Employee Timesheet"."Pay Code")
            {
            }
            column(PayDescription_EmployeeTimesheet;"Employee Timesheet"."Pay Description")
            {
            }
            column(Rate_EmployeeTimesheet;"Employee Timesheet".Rate)
            {
            }
            column(Quantity_EmployeeTimesheet;"Employee Timesheet".Units)
            {
            }
            column(BasicPay_EmployeeTimesheet;"Employee Timesheet"."Basic Pay")
            {
            }
            column(Amount_EmployeeTimesheet;"Employee Timesheet".Amount)
            {
            }
            column(PayReference_EmployeeTimesheet;"Employee Timesheet"."Pay Reference")
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
            column(RateType_EmployeeTimesheet;"Employee Timesheet"."Rate Type")
            {
            }

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
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        TEXT001 : Label 'Employee Timesheet';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
}

