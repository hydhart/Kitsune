xmlport 50000 Globalreport
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
            tableelement("Global Table";"Global Table")
            {
                XmlName = 'GlobalReport';
                fieldelement(Description;"Global Table"."Global Description")
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

