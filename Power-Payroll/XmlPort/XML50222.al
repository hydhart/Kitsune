xmlport 50222 "Electronic Banking ANZ"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    FileName = 'Electronic Banking ANZ';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Electronic Banking";"Electronic Banking")
            {
                XmlName = 'ElectronicBanking';
                fieldelement(Print160;"Electronic Banking"."Print 160")
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

