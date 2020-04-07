page 50201 "Income Tax Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Income Tax Master";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period From";"Period From")
                {
                }
                field("Period To";"Period To")
                {
                }
                field(Type;Type)
                {
                }
                field("Start Amount";"Start Amount")
                {
                }
                field("End Amount";"End Amount")
                {
                }
                field("Line No.";"Line No.")
                {
                }
                field("PAYE Additional Amount";"PAYE Additional Amount")
                {
                }
                field("PAYE %";"PAYE %")
                {
                }
                field("PAYE Excess Amount";"PAYE Excess Amount")
                {
                }
                field("SRT Additional Amount";"SRT Additional Amount")
                {
                }
                field("SRT %";"SRT %")
                {
                }
                field("SRT Excess Amount";"SRT Excess Amount")
                {
                }
                field("ECAL %";"ECAL %")
                {
                }
                field("ECAL Excess Amount";"ECAL Excess Amount")
                {
                }
                field("Payroll Year";"Payroll Year")
                {
                }
                field(Release;Release)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000016)
            {
                action("Import Income Tax Master")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        XMLPORT.RUN(50204);
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }
}

