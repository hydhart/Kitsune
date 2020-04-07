xmlport 50205 "Import Pay Element Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Pay Element Master";"Pay Element Master")
            {
                XmlName = 'PayElementMaster';
                fieldelement(PayCode;"Pay Element Master"."Pay Code")
                {
                }
                fieldelement(PayDescription;"Pay Element Master"."Pay Description")
                {
                }
                fieldelement(PayType;"Pay Element Master"."Pay Type")
                {
                }
                fieldelement(IncludeInPaySlip;"Pay Element Master"."Include In Pay Slip")
                {
                }
                fieldelement(InFNPFBase;"Pay Element Master"."Is FNPF Base")
                {
                }
                fieldelement(InFNPFBase;"Pay Element Master"."Is FNPF Field")
                {
                }
                fieldelement(IsPAYEBase;"Pay Element Master"."Is PAYE Base")
                {
                }
                fieldelement(IsPAYEField;"Pay Element Master"."Is PAYE Field")
                {
                }
                fieldelement(IsSRTBase;"Pay Element Master"."Is SRT Base")
                {
                }
                fieldelement(IsSRTField;"Pay Element Master"."Is SRT Field")
                {
                }
                fieldelement(LumpSum;"Pay Element Master"."Lump Sum")
                {
                }
                fieldelement(Redundancy;"Pay Element Master".Redundancy)
                {
                }
                fieldelement(Bonus;"Pay Element Master".Bonus)
                {
                }
                fieldelement(TaxRate;"Pay Element Master"."Tax Rate")
                {
                }
                fieldelement(ExemptAmount;"Pay Element Master"."Exempt Amount")
                {
                }
                fieldelement(Release;"Pay Element Master".Release)
                {
                }
                fieldelement(Endorsed;"Pay Element Master".Endorsed)
                {
                }
                fieldelement(QuickTimesheet;"Pay Element Master"."Quick Timesheet")
                {
                }
                fieldelement(RateType;"Pay Element Master"."Rate Type")
                {
                }
                fieldelement(CalculationType;"Pay Element Master"."Calculation Type")
                {
                }
                fieldelement(UseInPayrollRegister;"Pay Element Master"."Use in Payroll Register")
                {
                }
                fieldelement(RegisterCombineColumn;"Pay Element Master"."Earnings Combine Column")
                {
                }
                fieldelement(RegisterColumnPriority;"Pay Element Master"."Earnings Column Priority")
                {
                }
                fieldelement(RegisterColumnName;"Pay Element Master"."Earnings Column Name")
                {
                }
                fieldelement(PaySlipSequence;"Pay Element Master"."Payslip Sequence")
                {
                }
                fieldelement(LeaveType;"Pay Element Master"."Leave Type")
                {
                }
                fieldelement(PayCategory;"Pay Element Master"."Pay Category")
                {
                }
                fieldelement(LeaveColumnName;"Pay Element Master"."Leave Column Name")
                {
                }
                fieldelement(LeaveColumnPriority;"Pay Element Master"."Leave Column Priority")
                {
                }
                fieldelement(UseInLeaveReport;"Pay Element Master"."Use in Leave Report")
                {
                }
                fieldelement(CashNonCash;"Pay Element Master"."Cash/Non Cash")
                {
                }
                fieldelement(IsLeave;"Pay Element Master"."Is Leave")
                {
                }
                fieldelement(IsOldRate;"Pay Element Master"."Is Old Rate")
                {
                }
                fieldelement(IsFNTCLevy;"Pay Element Master"."Standard Deductions")
                {
                }
                fieldelement(IsLeaveWithoutPay;"Pay Element Master"."Is Leave Without Pay")
                {
                }
                fieldelement(IsEcalBase;"Pay Element Master"."Is ECAL Base")
                {
                }
                fieldelement(IsEcalField;"Pay Element Master"."Is ECAL Field")
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
}

