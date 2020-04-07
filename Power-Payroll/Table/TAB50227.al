table 50227 "Branch Policy Elements"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;
        }
        field(2;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;
        }
        field(3;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";
        }
        field(4;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;
        }
        field(5;"Pay Code";Code[10])
        {
        }
        field(6;"Pay Description";Text[60])
        {
        }
        field(7;"Pay Type";Option)
        {
            OptionMembers = Earnings,Deductions;
        }
        field(8;"Pay Category";Option)
        {
            OptionMembers = Taxable,"Non-Taxable";
        }
        field(9;"Post to GL";Boolean)
        {
        }
        field(10;"GL Debit Code";Code[20])
        {
            TableRelation = IF (GL DR Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (GL DR Account Type=CONST(Customer)) Customer ELSE IF (GL DR Account Type=CONST(Vendor)) Vendor ELSE IF (GL DR Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (GL DR Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (GL DR Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(11;"GL DR Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(12;"GL Credit Code";Code[20])
        {
            TableRelation = IF (GL CR Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (GL CR Account Type=CONST(Customer)) Customer ELSE IF (GL CR Account Type=CONST(Vendor)) Vendor ELSE IF (GL CR Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (GL CR Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (GL CR Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(13;"GL CR Account Type";Option)
        {
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(14;"GL Posting Date";Date)
        {
        }
        field(15;"Employer 10 Percent";Decimal)
        {
        }
        field(16;"Employer Additional FNPF";Decimal)
        {
        }
        field(17;"Employee Additional FNPF";Decimal)
        {
        }
        field(18;"GL Amount";Decimal)
        {
            DecimalPlaces = 3:3;
        }
        field(19;"Is FNPF Field";Boolean)
        {
        }
        field(20;"Cash/Non Cash";Option)
        {
            OptionMembers = Cash,"Non-Cash";
        }
        field(21;"Is Leave";Boolean)
        {
        }
        field(22;"Dimension Breakup";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRSETUP : Record "Human Resources Setup";
        PayCode : Record "Pay Element Master";
        TEXT001 : Label '"Quick Timesheet not allowed for Pay Code "';
        TEXT002 : Label '"Cannot change Rate Type for Pay Code "';
}

