report 50206 "Bank Pay Distribution"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Bank Pay Distribution.rdlc';

    dataset
    {
        dataitem("Bank Pay Distribution";"Bank Pay Distribution")
        {
            DataItemTableView = SORTING(Bank Code,Employee No.,Bank Account No.) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Bank Code","Pay Run No.","Special Pay No.";
            column(EmployeeNo_BankPayDistribution;"Bank Pay Distribution"."Employee No.")
            {
            }
            column(BranchCode_BankPayDistribution;"Bank Pay Distribution"."Branch Code")
            {
            }
            column(ShiftCode_BankPayDistribution;"Bank Pay Distribution"."Shift Code")
            {
            }
            column(CalendarCode_BankPayDistribution;"Bank Pay Distribution"."Calendar Code")
            {
            }
            column(StatisticsGroup_BankPayDistribution;"Bank Pay Distribution"."Statistics Group")
            {
            }
            column(EmployeeName_BankPayDistribution;"Bank Pay Distribution"."Employee Name")
            {
            }
            column(PayRunNo_BankPayDistribution;"Bank Pay Distribution"."Pay Run No.")
            {
            }
            column(SpecialPayNo_BankPayDistribution;"Bank Pay Distribution"."Special Pay No.")
            {
            }
            column(BankCode_BankPayDistribution;"Bank Pay Distribution"."Bank Code")
            {
            }
            column(EmployeeBankAccountNo_BankPayDistribution;"Bank Pay Distribution"."Employee Bank Account No.")
            {
            }
            column(BankName_BankPayDistribution;"Bank Pay Distribution"."Bank Name")
            {
            }
            column(SubBranchCode_BankPayDistribution;"Bank Pay Distribution"."Sub Branch Code")
            {
            }
            column(PayRunAmount_BankPayDistribution;ROUND("Bank Pay Distribution"."Pay Run Amount", 0.01, '='))
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
        TEXT001 : Label 'Bank Pay Distribution';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
}

