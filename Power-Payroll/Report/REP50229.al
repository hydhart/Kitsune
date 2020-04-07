report 50229 "Payroll Register Sum  - Nestle"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Payroll Register Sum  - Nestle.rdlc';

    dataset
    {
        dataitem("Pay Run";"Pay Run")
        {
            DataItemTableView = WHERE(Is Leave Without Pay=FILTER(No));
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.","Pay To Date";
            column(DisplayFilter;DisplayFilter)
            {
            }
            column(FNPFAmount;FNPFAmount)
            {
            }
            column(PAYEAmount;PAYEAmount)
            {
            }
            column(SRTAmount;SRTAmount)
            {
            }
            column(ECALAmount;ECALAmount)
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(Rate;Rate)
            {
            }
            column(GrossPay;GrossPay)
            {
            }
            column(NetPay;NetPay)
            {
            }
            column(BranchCode_PayRun;"Branch Code")
            {
            }
            column(EmployeeNo_PayRun;"Employee No.")
            {
            }
            column(EmployeeName_PayRun;"Employee Name")
            {
            }
            column(PayCode_PayRun;"Pay Code")
            {
            }
            column(PayDescription_PayRun;"Pay Description")
            {
            }
            column(Amount_PayRun;Amount)
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
            column(TotalOtherDeductions;TotalOtherDeductionsTaxable)
            {
            }
            column(TotalOtherEarnings;TotalOtherEarnings)
            {
            }
            column(OtherEarningsTaxable;OtherEarningsTaxable)
            {
            }
            column(OtherEarningsNonTaxable;OtherEarningsNonTaxable)
            {
            }
            column(OtherDeductionsTaxable;OtherDeductionsTaxable)
            {
            }
            column(OtherDeductionsNonTaxable;OtherDeductionsNonTaxable)
            {
            }
            column(GlobalDimension1;"Pay Run"."Global Dimension 1 Code")
            {
            }
            column(ByPassFNPF_PayRun;"Pay Run"."By Pass FNPF")
            {
            }
            column(Employer10Percent_PayRun;"Pay Run"."Employer 10 Percent")
            {
            }
            column(PayRunNo_PayRun;"Pay Run"."Pay Run No.")
            {
            }
            column(PayToDate_PayRun;"Pay Run"."Pay To Date")
            {
            }

            trigger OnAfterGetRecord();
            var
                DateFilter : Date;
            begin
                BasicPay := 0;
                FNPFAmount := 0;
                PAYEAmount := 0;
                SRTAmount := 0;
                ECALAmount := 0;
                NetPay := 0;
                OtherEarningsTaxable := 0;
                OtherEarningsNonTaxable := 0;
                OtherDeductionsTaxable := 0;
                OtherDeductionsNonTaxable := 0;
                TotalOtherDeductionsTaxable := 0;
                TotalOtherDeductionsNonTaxable := 0;
                TotalOtherEarnings := 0;

                HRSETUP.GET();
                NormalHours := HRSETUP."Normal Hours";

                IF EmployeePayHistory.GET("Employee No.", "Increment Date") THEN BEGIN
                  Rate := EmployeePayHistory.Rate;
                END;

                IF "Pay Type" = 0 THEN BEGIN                          //EARNING
                  IF "Pay Category" = 0 THEN BEGIN                    //TAXABLE
                    OtherEarningsTaxable := OtherEarningsTaxable + Amount;
                  END;
                  IF "Pay Category" = 1 THEN BEGIN                    //NONTAXABLE
                    OtherEarningsNonTaxable := OtherEarningsNonTaxable + Amount;
                  END;
                  IF "Pay Code" = NormalHours THEN BEGIN
                    BasicPay := BasicPay + Amount;
                  END;
                END;

                IF "Pay Type" = 1 THEN BEGIN                          //DEDUCTION
                  IF "Pay Category" = 0 THEN BEGIN                    //TAXABLE
                    IF "Pay Code" <> FNPFCode THEN BEGIN
                      IF "Pay Code" <> PAYECode THEN BEGIN
                        IF "Pay Code" <> SRTCode THEN BEGIN
                          IF "Pay Code" <> ECALCode THEN BEGIN
                            OtherDeductionsTaxable := OtherDeductionsTaxable + Amount;
                          END;
                        END;
                      END;
                    END;
                  END;
                  IF "Pay Category" = 1 THEN BEGIN                    //NONTAXABLE
                    IF "Pay Code" <> FNPFCode THEN BEGIN
                      IF "Pay Code" <> PAYECode THEN BEGIN
                        IF "Pay Code" <> SRTCode THEN BEGIN
                          IF "Pay Code" <> ECALCode THEN BEGIN
                            OtherDeductionsNonTaxable := OtherDeductionsNonTaxable + Amount;
                          END;
                        END;
                      END;
                    END;
                  END;

                  IF "Pay Code" = FNPFCode THEN BEGIN
                    FNPFAmount := FNPFAmount + Amount;
                  END;
                  IF "Pay Code" = PAYECode THEN BEGIN
                    PAYEAmount := PAYEAmount + Amount;
                  END;
                  IF "Pay Code" = SRTCode THEN BEGIN
                    SRTAmount := SRTAmount + Amount;
                  END;
                  IF "Pay Code" = ECALCode THEN BEGIN
                    ECALAmount := ECALAmount + Amount;
                  END;
                END;

                TotalOtherEarnings := OtherEarningsTaxable - BasicPay;
                TotalOtherDeductionsTaxable := OtherDeductionsTaxable;
                TotalOtherDeductionsNonTaxable := OtherDeductionsNonTaxable;
                GrossPay := BasicPay + TotalOtherEarnings + OtherEarningsNonTaxable;
                NetPay := GrossPay - (ABS(FNPFAmount) + ABS(PAYEAmount) + ABS(SRTAmount) + ABS(ECALAmount)+ ABS(TotalOtherDeductionsTaxable) + ABS(TotalOtherDeductionsNonTaxable));
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

    trigger OnPreReport();
    begin
        HRSETUP.GET();
        FNPFCode := HRSETUP.FNPF;
        PAYECode := HRSETUP.PAYE;
        SRTCode := HRSETUP.SRT;
        ECALCode := HRSETUP.ECAL;
    end;

    var
        TEXT001 : Label 'Payroll Register Summary';
        CurrReport_PAGENOCaptionLbl : Label 'Page';
        DisplayFilter : Text[250];
        FNPFAmount : Decimal;
        FNPFCode : Code[10];
        PAYEAmount : Decimal;
        PAYECode : Code[10];
        SRTAmount : Decimal;
        SRTCode : Code[10];
        ECALCode : Code[10];
        ECALAmount : Decimal;
        Rate : Decimal;
        HRSETUP : Record "Human Resources Setup";
        DateFilter : Text;
        NetPay : Decimal;
        GrossPay : Decimal;
        OtherDeductionsTaxable : Decimal;
        OtherDeductionsNonTaxable : Decimal;
        TotalOtherDeductionsTaxable : Decimal;
        TotalOtherDeductionsNonTaxable : Decimal;
        NormalHours : Code[10];
        BasicPay : Decimal;
        OtherEarningsTaxable : Decimal;
        OtherEarningsNonTaxable : Decimal;
        TotalOtherEarnings : Decimal;
        EmployeePayHistory : Record "Employee Pay History";
        IncrementDate : Date;
        GlobalDimension1 : Code[10];
        TEXT002 : Label 'Nestle (Fiji) Limited';
}

