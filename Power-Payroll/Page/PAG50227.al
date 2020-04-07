page 50227 "Branch Policy Elements"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Branch Policy Elements";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Code";"Pay Code")
                {
                    Editable = false;
                }
                field("Pay Description";"Pay Description")
                {
                    Editable = false;
                }
                field("Pay Type";"Pay Type")
                {
                    Editable = false;
                }
                field("Pay Category";"Pay Category")
                {
                    Editable = false;
                }
                field("Cash/Non Cash";"Cash/Non Cash")
                {
                    Editable = false;
                }
                field("Is Leave";"Is Leave")
                {
                    Editable = false;
                }
                field("Post to GL";"Post to GL")
                {
                }
                field("GL Debit Code";"GL Debit Code")
                {
                }
                field("GL DR Account Type";"GL DR Account Type")
                {
                }
                field("GL Credit Code";"GL Credit Code")
                {
                }
                field("GL CR Account Type";"GL CR Account Type")
                {
                }
                field("Dimension Breakup";"Dimension Breakup")
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
                action("Import Branch Policy Elements")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  20072017
                        XMLPORT.RUN(50206);
                        //ASHNEIL CHANDRA  20072017
                    end;
                }
            }
        }
    }
}

