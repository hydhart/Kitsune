page 50219 "Currency Exchange Rates Payrol"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Currency Exchange Rates Payrol',
                ENA='Currency Exchange Rates Payrol';
    DataCaptionFields = "Currency Code";
    PageType = List;
    SourceTable = "Currency Exchange Rate Payroll";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Starting Date";"Starting Date")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field("Relational Currency Code";"Relational Currency Code")
                {
                }
                field("Exchange Rate Amount";"Exchange Rate Amount")
                {
                }
                field("Relational Exch. Rate Amount";"Relational Exch. Rate Amount")
                {
                }
                field("Adjustment Exch. Rate Amount";"Adjustment Exch. Rate Amount")
                {
                }
                field("Relational Adjmt Exch Rate Amt";"Relational Adjmt Exch Rate Amt")
                {
                }
                field("Settlement Rate Amount";"Settlement Rate Amount")
                {
                }
                field("Relational Sett. Rate Amount";"Relational Sett. Rate Amount")
                {
                }
                field("Fix Exchange Rate Amount";"Fix Exchange Rate Amount")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    var
        CurrExchRate : Record "Currency Exchange Rate";
    begin
    end;
}

