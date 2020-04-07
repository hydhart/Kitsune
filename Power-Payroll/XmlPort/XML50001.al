xmlport 50001 "Finance XMLPort"
{
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Finance Table";"Finance Table")
            {
                XmlName = 'FinanceReport';
                fieldelement(Description;"Finance Table"."Finance Description")
                {
                }

                trigger OnAfterInsertRecord();
                begin
                    MESSAGE ('Record Successfully inserted!');
                end;
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

