xmlport 50206 ImportBranchPolicyElements
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TransactionType = Update;

    schema
    {
        textelement(Root)
        {
            tableelement("Branch Policy Elements";"Branch Policy Elements")
            {
                AutoUpdate = true;
                XmlName = 'BranchPolicyElements';
                SourceTableView = SORTING(Field1,Field2,Field3,Field4,Field5);
                fieldelement(BranchCode;"Branch Policy Elements"."Branch Code")
                {
                }
                fieldelement(ShiftCode;"Branch Policy Elements"."Shift Code")
                {
                }
                fieldelement(CalendarCode;"Branch Policy Elements"."Calendar Code")
                {
                }
                fieldelement(StatisticsGroup;"Branch Policy Elements"."Statistics Group")
                {
                }
                fieldelement(PayCode;"Branch Policy Elements"."Pay Code")
                {
                }
                fieldelement(PosttoGL;"Branch Policy Elements"."Post to GL")
                {
                }
                fieldelement(GLDebitType;"Branch Policy Elements"."GL DR Account Type")
                {
                }
                fieldelement(GLDebitCode;"Branch Policy Elements"."GL Debit Code")
                {
                }
                fieldelement(GLCreditType;"Branch Policy Elements"."GL CR Account Type")
                {
                }
                fieldelement(GLCreditCode;"Branch Policy Elements"."GL Credit Code")
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

    trigger OnPostXmlPort();
    begin
        MESSAGE('Branch Policy Elements Imported');
    end;
}

