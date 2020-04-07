xmlport 50221 "FNPF Contribution Schedule"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    FileName = 'FNPF Contribution Schedule';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("FNPF Contribution Schedule";"FNPF Contribution Schedule")
            {
                XmlName = 'FNPFContributionSchedule';
                fieldelement(Print;"FNPF Contribution Schedule".Print)
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

