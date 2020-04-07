table 50202 "Pay Element Master"
{
    // version ASHNEILCHANDRA_PAYROLL2017


    fields
    {
        field(1;"Pay Code";Code[10])
        {
        }
        field(2;"Pay Description";Text[60])
        {
        }
        field(3;"Pay Type";Option)
        {
            OptionMembers = Earnings,Deductions;

            trigger OnValidate();
            begin

                //ASHNEIL CHANDRA   13072017
                IF "Pay Type" = 0 THEN BEGIN
                  "Calculation Type" := 0;
                  MODIFY;
                END;

                IF "Pay Type" = 1 THEN BEGIN
                  "Calculation Type" := 1;
                  MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(7;"Include In Pay Slip";Boolean)
        {
        }
        field(8;"Is FNPF Base";Boolean)
        {
        }
        field(9;"Is FNPF Field";Boolean)
        {
        }
        field(10;"Is PAYE Base";Boolean)
        {
        }
        field(11;"Is PAYE Field";Boolean)
        {
        }
        field(12;"Is SRT Base";Boolean)
        {
        }
        field(13;"Is SRT Field";Boolean)
        {
        }
        field(14;"Lump Sum";Boolean)
        {
        }
        field(15;Redundancy;Boolean)
        {
        }
        field(16;Bonus;Boolean)
        {
        }
        field(17;"Tax Rate";Decimal)
        {
        }
        field(18;"Exempt Amount";Decimal)
        {
        }
        field(19;Release;Boolean)
        {
        }
        field(20;Endorsed;Boolean)
        {
        }
        field(21;"Quick Timesheet";Boolean)
        {

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                HRSETUP.GET;

                PayElementMaster.INIT;
                PayElementMaster.RESET;
                IF PayElementMaster.GET("Pay Code")  THEN BEGIN
                  IF PayElementMaster."Pay Code" = HRSETUP."Normal Hours" THEN BEGIN
                    IF "Quick Timesheet" = TRUE THEN BEGIN
                      ERROR(TEXT001 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.FNPF THEN BEGIN
                    IF "Quick Timesheet" = TRUE THEN BEGIN
                      ERROR(TEXT001 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.PAYE THEN BEGIN
                    IF "Quick Timesheet" = TRUE THEN BEGIN
                      ERROR(TEXT001 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.SRT THEN BEGIN
                    IF "Quick Timesheet" = TRUE THEN BEGIN
                      ERROR(TEXT001 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(22;"Rate Type";Option)
        {
            OptionMembers = "1","1.5","2";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                HRSETUP.GET;

                PayElementMaster.INIT;
                PayElementMaster.RESET;
                IF PayElementMaster.GET("Pay Code")  THEN BEGIN
                  IF PayElementMaster."Pay Code" = HRSETUP."Normal Hours" THEN BEGIN
                    IF "Rate Type" <> 0 THEN BEGIN
                      ERROR(TEXT002 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.FNPF THEN BEGIN
                    IF "Rate Type" <> 0 THEN BEGIN
                      ERROR(TEXT002 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.PAYE THEN BEGIN
                    IF "Rate Type" <> 0 THEN BEGIN
                      ERROR(TEXT002 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                  IF PayElementMaster."Pay Code" = HRSETUP.SRT THEN BEGIN
                    IF "Rate Type" <> 0 THEN BEGIN
                      ERROR(TEXT002 + '%1', PayElementMaster."Pay Code");
                    END;
                  END;

                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(23;"Calculation Type";Option)
        {
            OptionMembers = "1","-1";
        }
        field(28;"Use in Payroll Register";Boolean)
        {
        }
        field(29;"Earnings Combine Column";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(30;"Earnings Column Priority";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(31;"Earnings Column Name";Text[30])
        {
        }
        field(35;"Payslip Sequence";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(36;"Leave Type";Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(37;"Pay Category";Option)
        {
            OptionMembers = Taxable,"Non-Taxable";
        }
        field(38;"Leave Column Name";Text[30])
        {
        }
        field(39;"Leave Column Priority";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(40;"Use in Leave Report";Boolean)
        {
        }
        field(42;"Cash/Non Cash";Option)
        {
            OptionMembers = Cash,"Non-Cash";
        }
        field(43;"Is Leave";Boolean)
        {
        }
        field(44;"Is Old Rate";Boolean)
        {
        }
        field(45;"Standard Deductions";Boolean)
        {
        }
        field(46;"Is Leave Without Pay";Boolean)
        {
        }
        field(47;"Is ECAL Base";Boolean)
        {
        }
        field(48;"Is ECAL Field";Boolean)
        {
        }
        field(49;"Standard Elements";Boolean)
        {
        }
        field(50;"Deduction Combine Column";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(51;"Deduction Column Priority";Option)
        {
            OptionMembers = " ","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","72","73","74","75","76","77","78","79","80","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95","96","97","98","99","100";
        }
        field(52;"Deduction Column Name";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Pay Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRSETUP : Record "Human Resources Setup";
        TEXT001 : Label '"Quick Timesheet not allowed for Pay Code "';
        TEXT002 : Label '"Cannot change Rate Type for Pay Code "';
        PayElementMaster : Record "Pay Element Master";
}

