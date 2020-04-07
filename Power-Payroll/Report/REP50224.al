report 50224 "Pay Slip - Customised"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Pay Slip - Customised.rdlc';

    dataset
    {
        dataitem("Pay Run";"Pay Run")
        {
            DataItemTableView = SORTING(Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Employee No.,Pay Code) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.","Pay To Date";
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
            column(Special_Pay_No_PayRun;"Pay Run"."Special Pay No.")
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
            column(Amount_PayRun;"Pay Run".Amount)
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
            column(Pay_Date;"Pay Run"."Pay To Date")
            {
            }
            column(IsLeaveWithoutPay_PayRun;"Pay Run"."Is Leave Without Pay")
            {
            }
            column(Address1;Address1)
            {
            }
            column(Address2;Address2)
            {
            }
            column(City;City)
            {
            }
            column(Position;Position)
            {
            }
            column(AnnualPay;AnnualPay)
            {
            }
            column(FNPFNumber;FNPFNumber)
            {
            }
            column(TINNumber;TINNumber)
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
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Picture_CompanyInfo;CompanyInfo.Picture)
            {
            }
            column(Address_CompanyInfo;CompanyInfo.Address)
            {
            }
            column(Address2_CompanyInfo;CompanyInfo."Address 2")
            {
            }
            column(City_CompanyInfo;CompanyInfo.City)
            {
            }
            column(County_CompanyInfo;CompanyInfo.County)
            {
            }
            column(AccruedLeave;AccruedLeave)
            {
            }
            column(ShowUnits;ShowUnits)
            {
            }
            column(ShowRates;ShowRates)
            {
            }
            column(ShowRateType;ShowRateType)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                  AnnualPay := Employee."Annual Pay";
                  TINNumber := Employee."Employee TIN";
                  FNPFNumber := Employee."Employee FNPF";
                END;

                IF EmployeeMaster.GET("Employee No.") THEN BEGIN
                  Address1 := EmployeeMaster.Address;
                  Address2 := EmployeeMaster."Address 2";
                  City := EmployeeMaster.City;
                  Position := EmployeeMaster."Job Title";
                  AccruedLeave := EmployeeMaster."Accrued leave";
                END;
            end;

            trigger OnPreDataItem();
            begin
                CompanyInfo.GET();
                CompanyInfo.CALCFIELDS(Picture);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field("Show Rate Type";ShowRateType)
                    {
                    }
                    field("Show Rate";ShowRates)
                    {
                    }
                    field("Show Units";ShowUnits)
                    {
                    }
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

    var
        TEXT001 : Label 'Pay Slip';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
        Address1 : Text[50];
        Address2 : Text[50];
        City : Code[10];
        Position : Text[50];
        AnnualPay : Decimal;
        TINNumber : Text[30];
        FNPFNumber : Text[30];
        CompanyInfo : Record "Company Information";
        Employee : Record "Employee Pay Details";
        EmployeeMaster : Record Employee;
        AccruedLeave : Decimal;
        ShowRates : Boolean;
        ShowUnits : Boolean;
        ShowRateType : Boolean;
}

