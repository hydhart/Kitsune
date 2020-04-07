xmlport 50204 "Import Income Tax Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Income Tax Master";"Income Tax Master")
            {
                XmlName = 'IncomeTaxMaster';
                fieldelement(PeriodFrom;"Income Tax Master"."Period From")
                {
                }
                fieldelement(PeriodTo;"Income Tax Master"."Period To")
                {
                }
                fieldelement(Type;"Income Tax Master".Type)
                {
                }
                fieldelement(StartAmount;"Income Tax Master"."Start Amount")
                {
                }
                fieldelement(EndAmount;"Income Tax Master"."End Amount")
                {
                }
                fieldelement(LineNo;"Income Tax Master"."Line No.")
                {
                }
                fieldelement(PAYEAdditionalAmount;"Income Tax Master"."PAYE Additional Amount")
                {
                }
                fieldelement(PAYETaxPercentage;"Income Tax Master"."PAYE %")
                {
                }
                fieldelement(PAYEExcessAmount;"Income Tax Master"."PAYE Excess Amount")
                {
                }
                fieldelement(SRTAdditionalAmount;"Income Tax Master"."SRT Additional Amount")
                {
                }
                fieldelement(SRTPercentage;"Income Tax Master"."SRT %")
                {
                }
                fieldelement(SRTExcessAmount;"Income Tax Master"."SRT Excess Amount")
                {
                }
                fieldelement(ECALPercentage;"Income Tax Master"."ECAL %")
                {
                }
                fieldelement(ECALExcessAmount;"Income Tax Master"."ECAL Excess Amount")
                {
                }
                fieldelement(PayrollYear;"Income Tax Master"."Payroll Year")
                {
                }
                fieldelement(Releaase;"Income Tax Master".Release)
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

