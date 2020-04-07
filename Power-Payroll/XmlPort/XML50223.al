xmlport 50223 "Electronic Banking WBC"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    FileName = 'Electronic Banking WBC';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Electronic Banking";"Electronic Banking")
            {
                XmlName = 'ElectronicBanking';
                fieldelement(Print162;"Electronic Banking"."Print 162")
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

