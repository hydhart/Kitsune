page 50202 "Pay Element Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Pay Element Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Code";"Pay Code")
                {
                }
                field("Pay Description";"Pay Description")
                {
                }
                field("Pay Type";"Pay Type")
                {
                }
                field("Pay Category";"Pay Category")
                {
                }
                field("Cash/Non Cash";"Cash/Non Cash")
                {
                }
                field("Rate Type";"Rate Type")
                {
                }
                field("Calculation Type";"Calculation Type")
                {
                }
                field("Is Leave";"Is Leave")
                {
                }
                field("Leave Type";"Leave Type")
                {
                }
                field("Include In Pay Slip";"Include In Pay Slip")
                {
                }
                field("Is FNPF Base";"Is FNPF Base")
                {
                }
                field("Is FNPF Field";"Is FNPF Field")
                {
                }
                field("Is PAYE Base";"Is PAYE Base")
                {
                }
                field("Is PAYE Field";"Is PAYE Field")
                {
                }
                field("Is SRT Base";"Is SRT Base")
                {
                }
                field("Is SRT Field";"Is SRT Field")
                {
                }
                field("Is ECAL Base";"Is ECAL Base")
                {
                }
                field("Is ECAL Field";"Is ECAL Field")
                {
                }
                field("Is Old Rate";"Is Old Rate")
                {
                }
                field("Is Leave Without Pay";"Is Leave Without Pay")
                {
                }
                field("Lump Sum";"Lump Sum")
                {
                }
                field(Redundancy;Redundancy)
                {
                }
                field(Bonus;Bonus)
                {
                }
                field("Tax Rate";"Tax Rate")
                {
                }
                field("Exempt Amount";"Exempt Amount")
                {
                }
                field(Release;Release)
                {
                }
                field(Endorsed;Endorsed)
                {
                }
                field("Quick Timesheet";"Quick Timesheet")
                {
                }
                field("Use in Payroll Register";"Use in Payroll Register")
                {
                }
                field("Earnings Combine Column";"Earnings Combine Column")
                {
                }
                field("Earnings Column Priority";"Earnings Column Priority")
                {
                }
                field("Earnings Column Name";"Earnings Column Name")
                {
                }
                field("Deduction Combine Column";"Deduction Combine Column")
                {
                }
                field("Deduction Column Priority";"Deduction Column Priority")
                {
                }
                field("Deduction Column Name";"Deduction Column Name")
                {
                }
                field("Payslip Sequence";"Payslip Sequence")
                {
                }
                field("Leave Column Name";"Leave Column Name")
                {
                }
                field("Leave Column Priority";"Leave Column Priority")
                {
                }
                field("Use in Leave Report";"Use in Leave Report")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000040)
            {
                action("Import Pay Element Master")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  20072017
                        XMLPORT.RUN(50205);
                        //ASHNEIL CHANDRA  20072017
                    end;
                }
            }
        }
    }
}

