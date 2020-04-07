table 50201 "Income Tax Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Period From";Date)
        {
        }
        field(2;"Period To";Date)
        {
        }
        field(3;Type;Option)
        {
            OptionMembers = " ",Resident,"Non Resident";
        }
        field(4;"Start Amount";Decimal)
        {
        }
        field(5;"End Amount";Decimal)
        {
        }
        field(6;"Line No.";Integer)
        {
        }
        field(7;"PAYE Additional Amount";Decimal)
        {
        }
        field(8;"PAYE %";Decimal)
        {
        }
        field(9;"PAYE Excess Amount";Decimal)
        {
        }
        field(10;"SRT Additional Amount";Decimal)
        {
        }
        field(11;"SRT %";Decimal)
        {
        }
        field(12;"SRT Excess Amount";Decimal)
        {
        }
        field(13;"Payroll Year";Integer)
        {
        }
        field(14;Release;Boolean)
        {
        }
        field(16;"ECAL %";Decimal)
        {
        }
        field(17;"ECAL Excess Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

