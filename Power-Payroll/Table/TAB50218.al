table 50218 "Pay Run"
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
        field(5;"Pay Run No.";Code[10])
        {
            Editable = false;
        }
        field(6;"Special Pay No.";Code[10])
        {
            Editable = false;
        }
        field(7;"Employee No.";Code[10])
        {
            Editable = false;
            TableRelation = Employee.No.;
        }
        field(8;"Employee Name";Text[50])
        {
            Editable = false;
        }
        field(9;"Pay Code";Code[10])
        {
            Editable = false;
            TableRelation = "Pay Element Master"."Pay Code";
        }
        field(10;"Pay Description";Text[60])
        {
            Editable = false;
        }
        field(11;"Calculation Type";Option)
        {
            OptionMembers = "1","-1";
        }
        field(12;Rate;Decimal)
        {
            DecimalPlaces = 3:3;
            Editable = false;
        }
        field(13;Units;Decimal)
        {
        }
        field(14;"Pay From Date";Date)
        {
        }
        field(15;"Pay To Date";Date)
        {
        }
        field(16;"Tax Start Month";Date)
        {
        }
        field(17;"Tax End Month";Date)
        {
        }
        field(18;"Include In Pay Slip";Boolean)
        {
        }
        field(19;"Is FNPF Base";Boolean)
        {
        }
        field(20;"Is FNPF Field";Boolean)
        {
        }
        field(21;"Is PAYE Base";Boolean)
        {
        }
        field(22;"Is PAYE Field";Boolean)
        {
        }
        field(23;"Is SRT Base";Boolean)
        {
        }
        field(24;"Is SRT Field";Boolean)
        {
        }
        field(25;"Lump Sum";Boolean)
        {
        }
        field(26;Redundancy;Boolean)
        {
        }
        field(27;Bonus;Boolean)
        {
        }
        field(28;"Tax Rate";Decimal)
        {
        }
        field(29;"Exempt Amount";Decimal)
        {
        }
        field(30;Release;Boolean)
        {
        }
        field(31;Endorsed;Boolean)
        {
        }
        field(32;"Quick Timesheet";Boolean)
        {
        }
        field(33;"Rate Type";Option)
        {
            OptionMembers = "1","1.5","2";
        }
        field(34;F;Integer)
        {
            Description = 'Number of Payment Periods in the Tax Year';
        }
        field(35;Amount;Decimal)
        {
        }
        field(36;"Pay Type";Option)
        {
            OptionMembers = Earnings,Deductions;
        }
        field(37;G;Integer)
        {
            Description = 'Number of Completed Pay Periods including current period';
        }
        field(38;E;Decimal)
        {
            CalcFormula = Sum("Pay Run".TotalEarningsPaid WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code)));
            Description = 'CALC, Total Amount of Employment Income Paid by the employer to the employee in the previous payment periods in the tax year';
            FieldClass = FlowField;
        }
        field(39;TotalEarningsPaid;Decimal)
        {
        }
        field(40;TotalPAYEPaid;Decimal)
        {
        }
        field(41;TotalSRTPaid;Decimal)
        {
        }
        field(42;B1;Decimal)
        {
            CalcFormula = Sum("Pay Run".TotalPAYEPaid WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code)));
            Description = 'CALC, PAYE withheld to Date';
            FieldClass = FlowField;
        }
        field(43;C1;Decimal)
        {
        }
        field(44;C2;Decimal)
        {
        }
        field(45;B2;Decimal)
        {
            CalcFormula = Sum("Pay Run".TotalSRTPaid WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code)));
            Description = 'CALC, SRL withheld to Date';
            FieldClass = FlowField;
        }
        field(46;H;Decimal)
        {
            CalcFormula = Sum("Pay Run".Amount WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Bonus=FILTER(Yes), Branch Code=FIELD(Branch Code)));
            Description = 'CALC, Total Bonuses Paid to date including that paid in the current period';
            FieldClass = FlowField;
        }
        field(47;"Other PAYE";Decimal)
        {
        }
        field(48;"Sub Branch Code";Code[20])
        {
        }
        field(49;"Pay Reference";Text[50])
        {
        }
        field(50;"Payroll Reference";Text[50])
        {
        }
        field(51;"Net Pay";Decimal)
        {
            CalcFormula = Sum("Pay Run".Amount WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Include In Pay Slip=FILTER(Yes), Is Leave Without Pay=FILTER(No)));
            DecimalPlaces = 3:3;
            FieldClass = FlowField;
        }
        field(52;"Gross Pay";Decimal)
        {
            CalcFormula = Sum("Pay Run".Amount WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Include In Pay Slip=FILTER(Yes), Pay Type=FILTER(Earnings), Is Leave Without Pay=FILTER(No)));
            DecimalPlaces = 3:3;
            FieldClass = FlowField;
        }
        field(53;"Total Deduction";Decimal)
        {
            CalcFormula = -Sum("Pay Run".Amount WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Include In Pay Slip=FILTER(Yes), Pay Type=FILTER(Deductions), Is Leave Without Pay=FILTER(No)));
            DecimalPlaces = 3:3;
            FieldClass = FlowField;
        }
        field(54;"By Pass FNPF";Boolean)
        {
        }
        field(55;"Employer 10 Percent";Decimal)
        {
        }
        field(56;"Employee 8 Percent";Decimal)
        {
        }
        field(57;"Employer FNPF Additional";Decimal)
        {
        }
        field(58;"Employee FNPF Additional";Decimal)
        {
        }
        field(59;"Tax on C1";Decimal)
        {
        }
        field(60;"Tax on C2";Decimal)
        {
        }
        field(61;"Zero Normal Hours";Boolean)
        {
        }
        field(62;"Special Tag";Boolean)
        {
            Editable = false;
        }
        field(63;TotalBonus;Decimal)
        {
        }
        field(64;"Increment Date";Date)
        {
        }
        field(65;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU='Global Dimension 1 Code',
                        ENA='Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(66;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU='Global Dimension 2 Code',
                        ENA='Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(67;"Leave Type";Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(68;"From Date";Date)
        {
        }
        field(69;"To Date";Date)
        {
        }
        field(70;"From Time";Time)
        {
        }
        field(71;"To Time";Time)
        {
        }
        field(72;"Pay Category";Option)
        {
            OptionMembers = Taxable,"Non-Taxable";
        }
        field(73;"Cash/Non Cash";Option)
        {
            OptionMembers = Cash,"Non-Cash";
        }
        field(74;"Is Leave";Boolean)
        {
        }
        field(75;"Is Old Rate";Boolean)
        {
        }
        field(76;"Standard Deductions";Boolean)
        {
        }
        field(77;"Is Leave Without Pay";Boolean)
        {
        }
        field(78;"Is ECAL Base";Boolean)
        {
        }
        field(79;"Is ECAL Field";Boolean)
        {
        }
        field(80;TotalECALPaid;Decimal)
        {
        }
        field(81;B3;Decimal)
        {
            CalcFormula = Sum("Pay Run".TotalECALPaid WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code)));
            Description = 'CALC,ECAL withheld to Date';
            FieldClass = FlowField;
        }
        field(82;"Half of Gross Pay";Decimal)
        {
        }
        field(83;"Total Standard Deduction";Decimal)
        {
            CalcFormula = -Sum("Pay Run".Amount WHERE (Employee No.=FIELD(Employee No.), Calendar Code=FIELD(Calendar Code), Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Include In Pay Slip=FILTER(Yes), Pay Type=FILTER(Deductions), Standard Deductions=FILTER(Yes), Is Leave Without Pay=FILTER(No)));
            Description = 'CALC';
            FieldClass = FlowField;
        }
        field(84;"PAYE Adjusted";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.","Employee No.","Pay Code")
        {
        }
        key(Key2;"Employee No.","Calendar Code","Branch Code","Shift Code","Statistics Group",Bonus)
        {
            SumIndexFields = TotalEarningsPaid,TotalPAYEPaid,TotalSRTPaid,Amount;
        }
        key(Key3;"Employee No.","Calendar Code","Branch Code","Shift Code","Statistics Group")
        {
            SumIndexFields = TotalEarningsPaid,TotalPAYEPaid,TotalSRTPaid,Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //ASHNEIL CHANDRA   13072017
        IF Release = TRUE THEN BEGIN
          ERROR('Pay Run released, can not delete');
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    var
        PayElementMaster : Record "Pay Element Master";
        DimMgt : Codeunit DimensionManagement;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee,"Employee No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;
}

