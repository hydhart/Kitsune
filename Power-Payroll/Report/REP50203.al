report 50203 "FNPF Contribution"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './FNPF Contribution.rdlc';

    dataset
    {
        dataitem("Pay Run";"Pay Run")
        {
            DataItemTableView = SORTING(Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Employee No.,Pay Code) ORDER(Ascending) WHERE(Pay Code=FILTER(601));
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.";
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
            column(TaxStartMonth_PayRun;"Pay Run"."Tax Start Month")
            {
            }
            column(TaxEndMonth_PayRun;"Pay Run"."Tax End Month")
            {
            }
            column(Amount_PayRun;"Pay Run".Amount)
            {
            }
            column(Employer10Percent_PayRun;"Pay Run"."Employer 10 Percent")
            {
            }
            column(Employee8Percent_PayRun;"Pay Run"."Employee 8 Percent")
            {
            }
            column(EmployerFNPFAdditional_PayRun;"Pay Run"."Employer FNPF Additional")
            {
            }
            column(EmployeeFNPFAdditional_PayRun;"Pay Run"."Employee FNPF Additional")
            {
            }
            column(GrossPay_PayRun;"Pay Run"."Gross Pay")
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
        TEXT001 : Label 'FNPF Contribution';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
}

