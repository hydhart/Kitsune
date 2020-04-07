table 5207 "Employee Absence"
{
    // version NAVW17.00, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Employee Absence',
                ENA='Employee Absence';
    DataCaptionFields = "Employee No.";
    DrillDownPageID = 5211;
    LookupPageID = 5211;

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            CaptionML = ENU='Employee No.',
                        ENA='Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate();
            begin
                Employee.GET("Employee No.");
            end;
        }
        field(2;"Entry No.";Integer)
        {
            CaptionML = ENU='Entry No.',
                        ENA='Entry No.';
        }
        field(3;"From Date";Date)
        {
            CaptionML = ENU='From Date',
                        ENA='From Date';
        }
        field(4;"To Date";Date)
        {
            CaptionML = ENU='To Date',
                        ENA='To Date';
        }
        field(5;"Cause of Absence Code";Code[10])
        {
            CaptionML = ENU='Cause of Absence Code',
                        ENA='Cause of Absence Code';
            TableRelation = "Cause of Absence";

            trigger OnValidate();
            begin
                CauseOfAbsence.GET("Cause of Absence Code");
                Description := CauseOfAbsence.Description;
                VALIDATE("Unit of Measure Code",CauseOfAbsence."Unit of Measure Code");
            end;
        }
        field(6;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
        }
        field(7;Quantity;Decimal)
        {
            CaptionML = ENU='Quantity',
                        ENA='Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                "Quantity (Base)" := CalcBaseQty(Quantity);
            end;
        }
        field(8;"Unit of Measure Code";Code[10])
        {
            CaptionML = ENU='Unit of Measure Code',
                        ENA='Unit of Measure Code';
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate();
            begin
                HumanResUnitOfMeasure.GET("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                VALIDATE(Quantity);
            end;
        }
        field(11;Comment;Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee Absence), Table Line No.=FIELD(Entry No.)));
            CaptionML = ENU='Comment',
                        ENA='Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Quantity (Base)";Decimal)
        {
            CaptionML = ENU='Quantity (Base)',
                        ENA='Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE(Quantity,"Quantity (Base)");
            end;
        }
        field(13;"Qty. per Unit of Measure";Decimal)
        {
            CaptionML = ENU='Qty. per Unit of Measure',
                        ENA='Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(50000;"From Time";Time)
        {
        }
        field(50001;"To Time";Time)
        {
        }
        field(50002;Rate;Decimal)
        {
            DecimalPlaces = 3:3;
        }
        field(50003;Amount;Decimal)
        {
        }
        field(50004;"Pay Run No.";Code[10])
        {
            Editable = false;
        }
        field(50006;"Special Pay No.";Code[10])
        {
            Editable = false;
        }
        field(50007;"Pay Code";Code[10])
        {
        }
        field(50008;Tag;Code[10])
        {
        }
        field(50009;"Prior Year";Boolean)
        {
        }
        field(50010;Year;Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"Employee No.","From Date")
        {
            SumIndexFields = Quantity,"Quantity (Base)";
        }
        key(Key3;"Employee No.","Cause of Absence Code","From Date")
        {
            SumIndexFields = Quantity,"Quantity (Base)";
        }
        key(Key4;"Cause of Absence Code","From Date")
        {
            SumIndexFields = Quantity,"Quantity (Base)";
        }
        key(Key5;"From Date","To Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        EmployeeAbsence.SETCURRENTKEY("Entry No.");
        IF EmployeeAbsence.FINDLAST THEN
          "Entry No." := EmployeeAbsence."Entry No." + 1
        ELSE
          "Entry No." := 1;
    end;

    var
        CauseOfAbsence : Record "Cause of Absence";
        Employee : Record Employee;
        EmployeeAbsence : Record "Employee Absence";
        HumanResUnitOfMeasure : Record "Human Resource Unit of Measure";

    local procedure CalcBaseQty(Qty : Decimal) : Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;
}

