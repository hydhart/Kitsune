xmlport 50220 "Employer Monthly Schedule"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    FileName = 'Employer Monthly Schedule';
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Employer Monthly Summary";"Employer Monthly Summary")
            {
                XmlName = 'EmployerMonthlySummry';
                fieldelement(Print;"Employer Monthly Summary".Print)
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

