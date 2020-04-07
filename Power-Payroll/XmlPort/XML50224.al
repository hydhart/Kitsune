xmlport 50224 "Electronic Banking PEX"
{
    // version ASHNEILCHANDRA_PAYROLL2017

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
                fieldelement(Print180;"Electronic Banking"."Print 180")
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

