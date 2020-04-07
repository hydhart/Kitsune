xmlport 50202 "Import Employee Timesheet"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement("Employee Timesheet";"Employee Timesheet")
            {
                XmlName = 'EmployeeTimesheet';
                UseTemporary = true;
                fieldelement(EmployeeNo;"Employee Timesheet"."Employee No.")
                {
                }
                fieldelement(PayCode;"Employee Timesheet"."Pay Code")
                {
                }
                fieldelement(Units;"Employee Timesheet".Units)
                {
                }

                trigger OnAfterInsertRecord();
                begin
                    HRSETUP.GET();
                    
                    "Employee Timesheet"."Branch Code" := HRSETUP."Branch Code";
                    "Employee Timesheet"."Shift Code" := HRSETUP."Shift Code";
                    "Employee Timesheet"."Calendar Code" := HRSETUP."Calendar Code";
                    "Employee Timesheet"."Statistics Group" := HRSETUP."Statistics Group";
                    "Employee Timesheet"."Pay Run No." := HRSETUP."Pay Run No.";
                    "Employee Timesheet"."Special Pay No." := HRSETUP."Special Pay No.";
                    "Employee Timesheet"."Employee No." := "Employee Timesheet"."Employee No.";
                    MESSAGE("Employee Timesheet"."Employee No.");
                    IF Employee.GET("Employee Timesheet"."Employee No.") THEN BEGIN
                      "Employee Timesheet"."Employee Name" := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name"
                    END;
                    "Employee Timesheet"."Pay Code" := "Employee Timesheet"."Pay Code";
                    IF PayElementMaster.GET("Employee Timesheet"."Pay Code") THEN BEGIN
                      "Employee Timesheet"."Pay Description" := PayElementMaster."Pay Description";
                      "Employee Timesheet"."Pay Calculation Type" := PayElementMaster."Calculation Type";
                      "Employee Timesheet"."Rate Type" := PayElementMaster."Rate Type";
                    END;
                    IF EmployeePayDetails.GET("Employee Timesheet"."Employee No.") THEN BEGIN
                      "Employee Timesheet"."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                      "Employee Timesheet".Rate := EmployeePayDetails."Employee Rate";
                      "Employee Timesheet"."Basic Pay" := EmployeePayDetails."Gross Standard Pay";
                      "Employee Timesheet"."Rate Type" := EmployeePayDetails."Rate Type";
                    END;
                    
                    "Employee Timesheet".Units := "Employee Timesheet".Units;
                    "Employee Timesheet".INSERT;
                    
                    PayRunScheduler.INIT;
                    PayRunScheduler.RESET;
                    PayRunScheduler.SETRANGE("Branch Code", "Employee Timesheet"."Branch Code");
                    PayRunScheduler.SETRANGE("Shift Code", "Employee Timesheet"."Shift Code");
                    PayRunScheduler.SETRANGE("Calendar Code", "Employee Timesheet"."Calendar Code");
                    PayRunScheduler.SETRANGE("Statistics Group", "Employee Timesheet"."Statistics Group");
                    PayRunScheduler.SETRANGE("Pay Run No.", "Employee Timesheet"."Pay Run No.");
                    PayRunScheduler.SETRANGE("Special Pay No.", "Employee Timesheet"."Special Pay No.");
                    IF PayRunScheduler.FINDFIRST() THEN BEGIN
                      "Employee Timesheet"."Payroll Reference" := PayRunScheduler."Payroll Reference";
                      "Employee Timesheet"."Pay From Date" := PayRunScheduler."Pay From Date";
                      "Employee Timesheet"."Pay To Date"  := PayRunScheduler."Pay To Date";
                      "Employee Timesheet"."Tax Start Month" := PayRunScheduler."Month Start Date";
                      "Employee Timesheet"."Tax End Month" := PayRunScheduler."Month End Date";
                      "Employee Timesheet"."Date Processed" := TODAY;
                      "Employee Timesheet"."Zero Normal Hours" := FALSE;
                      "Employee Timesheet".MODIFY;
                    END;
                    /*
                    EmployeeTimesheet.INIT;
                    EmployeeTimesheet.RESET;
                    EmployeeTimesheet.SETRANGE("Branch Code", "Employee Timesheet"."Branch Code");
                    EmployeeTimesheet.SETRANGE("Shift Code", "Employee Timesheet"."Shift Code");
                    EmployeeTimesheet.SETRANGE("Calendar Code", "Employee Timesheet"."Calendar Code");
                    EmployeeTimesheet.SETRANGE("Statistics Group", "Employee Timesheet"."Statistics Group");
                    EmployeeTimesheet.SETRANGE("Pay Run No.", "Employee Timesheet"."Pay Run No.");
                    EmployeeTimesheet.SETRANGE("Special Pay No.", "Employee Timesheet"."Special Pay No.");
                    IF NOT EmployeeTimesheet.FINDFIRST() THEN REPEAT
                      EmployeeTimesheet."Branch Code" := "Employee Timesheet"."Branch Code";
                      EmployeeTimesheet."Shift Code" := "Employee Timesheet"."Shift Code";
                      EmployeeTimesheet."Calendar Code" := "Employee Timesheet"."Calendar Code";
                      EmployeeTimesheet."Statistics Group" := "Employee Timesheet"."Statistics Group";
                      EmployeeTimesheet."Pay Run No." := "Employee Timesheet"."Pay Run No.";
                      EmployeeTimesheet."Special Pay No." := "Employee Timesheet"."Special Pay No.";
                      EmployeeTimesheet."Employee No." := "Employee Timesheet"."Employee No.";
                      EmployeeTimesheet."Employee Name" := "Employee Timesheet"."Employee Name";
                      EmployeeTimesheet."Pay Code" := "Employee Timesheet"."Pay Code";
                      EmployeeTimesheet."Pay Description" := "Employee Timesheet"."Pay Description";
                      EmployeeTimesheet."Pay Calculation Type" := "Employee Timesheet"."Pay Calculation Type";
                      EmployeeTimesheet."Rate Type" := "Employee Timesheet"."Rate Type";
                      EmployeeTimesheet.Units := "Employee Timesheet".Units;
                      EmployeeTimesheet."Payroll Reference" := "Employee Timesheet"."Payroll Reference";
                      EmployeeTimesheet."Pay From Date" := "Employee Timesheet"."Pay From Date";
                      EmployeeTimesheet."Pay To Date" := "Employee Timesheet"."Pay To Date";
                      EmployeeTimesheet."Tax Start Month" := "Employee Timesheet"."Tax Start Month";
                      EmployeeTimesheet."Tax End Month" := "Employee Timesheet"."Tax End Month";
                      EmployeeTimesheet."Date Processed" := "Employee Timesheet"."Date Processed";
                      EmployeeTimesheet."Zero Normal Hours" := "Employee Timesheet"."Zero Normal Hours";
                      EmployeeTimesheet.INSERT;
                    UNTIL EmployeeTimesheet.NEXT = 0;
                     */

                end;
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

    var
        HRSETUP : Record "Human Resources Setup";
        Employee : Record Employee;
        PayElementMaster : Record "Pay Element Master";
        PayRunScheduler : Record "Pay Run Scheduler";
        EmployeePayDetails : Record "Employee Pay Details";
        EmployeeTimesheet : Record "Employee Timesheet";
}

