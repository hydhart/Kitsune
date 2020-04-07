report 50214 "Component Summary Report"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Component Summary Report.rdlc';

    dataset
    {
        dataitem("Pay Run";"Pay Run")
        {
            DataItemTableView = SORTING(Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Employee No.,Pay Code) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Pay Code";
            column(BranchCode_PayRun;"Pay Run"."Branch Code")
            {
            }
            column(ShiftCode_PayRun;"Pay Run"."Shift Code")
            {
            }
            column(CalendarCode_PayRun;"Pay Run"."Calendar Code")
            {
            }
            column(StatisticsGroup_PayRun;"Pay Run"."Statistics Group")
            {
            }
            column(PayRunNo_PayRun;"Pay Run"."Pay Run No.")
            {
            }
            column(SpecialPayNo_PayRun;"Pay Run"."Special Pay No.")
            {
            }
            column(EmployeeNo_PayRun;"Pay Run"."Employee No.")
            {
            }
            column(EmployeeName_PayRun;"Pay Run"."Employee Name")
            {
            }
            column(PayCode_PayRun;"Pay Run"."Pay Code")
            {
            }
            column(PayDescription_PayRun;"Pay Run"."Pay Description")
            {
            }
            column(Rate_PayRun;"Pay Run".Rate)
            {
            }
            column(Quantity_PayRun;"Pay Run".Units)
            {
            }
            column(RateType_PayRun;"Pay Run"."Rate Type")
            {
            }
            column(Amount_PayRun;ROUND("Pay Run".Amount, 0.01, '='))
            {
            }
            column(PayReference_PayRun;"Pay Run"."Pay Reference")
            {
            }
            column(PayrollReference_PayRun;"Pay Run"."Payroll Reference")
            {
            }
            column(PayType_PayRun;"Pay Run"."Pay Type")
            {
            }
            column(PayCategory_PayRun;"Pay Run"."Pay Category")
            {
            }
            column(CashNonCash_PayRun;"Pay Run"."Cash/Non Cash")
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
        TEXT001 : TextConst ENU='Component Summary Report',ENA='Component Report';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
}

