page 50217 "Quick Timesheet"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Quick Timesheet";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No.";"Employee No.")
                {
                }
                field("Pay Code";"Pay Code")
                {
                }
                field("Pay Description";"Pay Description")
                {
                }
                field("Rate Type";"Rate Type")
                {

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        EVALUATE(RateType, FORMAT("Rate Type"));

                        Amount := Rate * Units * RateType;
                        MODIFY;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Rate;Rate)
                {

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        EVALUATE(RateType, FORMAT("Rate Type"));

                        Amount := Rate * Units * RateType;
                        MODIFY;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Units;Units)
                {

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        EVALUATE(RateType, FORMAT("Rate Type"));

                        Amount := Rate * Units * RateType;
                        MODIFY;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Amount;Amount)
                {
                }
                field("From Date";"From Date")
                {
                }
                field("To Date";"To Date")
                {
                }
                field("From Time";"From Time")
                {
                }
                field("To Time";"To Time")
                {
                }
            }
            group(Control1000000026)
            {
                fixed("Branch Policy/Pay Details")
                {
                    Caption = 'Branch Policy/Pay Details';
                    group("Branch Code")
                    {
                        Caption = 'Branch Code';
                        field("Branch Code";"Branch Code")
                        {
                        }
                    }
                    group("Shift Code")
                    {
                        Caption = 'Shift Code';
                        field("Shift Code";"Shift Code")
                        {
                        }
                    }
                    group("Calendar Code")
                    {
                        Caption = 'Calendar Code';
                        field("Calendar Code";"Calendar Code")
                        {
                        }
                    }
                    group("Statistic Group")
                    {
                        Caption = 'Statistic Group';
                        field("Statistics Group";"Statistics Group")
                        {
                        }
                    }
                    group("Pay Run No.")
                    {
                        Caption = 'Pay Run No.';
                        field("Pay Run No.";"Pay Run No.")
                        {
                        }
                    }
                    group("Special Pay No.")
                    {
                        Caption = 'Special Pay No.';
                        field("Special Pay No.";"Special Pay No.")
                        {
                        }
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000010)
            {
                action("Update Timesheet")
                {
                    Promoted = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        HRSETUP.GET();
                        NormalHours := HRSETUP."Normal Hours";


                        EmployeeTimesheet.INIT;
                        EmployeeTimesheet.RESET;
                        EmployeeTimesheet.SETRANGE("Branch Code","Branch Code");
                        EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                        EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        EmployeeTimesheet.SETRANGE("Pay Run No.","Pay Run No.");
                        EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        EmployeeTimesheet.SETRANGE("Employee No.","Employee No.");
                        EmployeeTimesheet.SETRANGE("Quick Timesheet", TRUE);
                        EmployeeTimesheet.DELETEALL;


                        INIT;
                        RESET;
                        SETFILTER(Amount,'<>0');
                        IF FINDFIRST() THEN REPEAT
                          EmployeeTimesheet.INIT;
                          EmployeeTimesheet.RESET;
                          EmployeeTimesheet.SETRANGE("Branch Code","Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeeTimesheet.SETRANGE("Pay Run No.","Pay Run No.");
                          EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                          EmployeeTimesheet.SETRANGE("Employee No.","Employee No.");
                          IF EmployeeTimesheet.FINDFIRST() THEN BEGIN
                            EmployeeTimesheet."Branch Code" := "Branch Code";
                            EmployeeTimesheet."Shift Code" := "Shift Code";
                            EmployeeTimesheet."Calendar Code" := "Calendar Code";
                            EmployeeTimesheet."Statistics Group" := "Statistics Group";
                            EmployeeTimesheet."Pay Run No." := "Pay Run No.";
                            EmployeeTimesheet."Special Pay No." := "Special Pay No.";
                            EmployeeTimesheet."Employee No." := "Employee No.";
                            IF Employee.GET(EmployeeTimesheet."Employee No.") THEN BEGIN
                              EmployeeTimesheet."Sub Branch Code" := Employee."Sub Branch Code";
                            END;
                            IF EmployeeMaster.GET(EmployeeTimesheet."Employee No.") THEN BEGIN
                              EmployeeTimesheet."Employee Name" := EmployeeMaster."First Name" + '' + EmployeeMaster."Last Name";
                            END;
                            EmployeeTimesheet."Pay Code" := "Pay Code";
                            EmployeeTimesheet."Pay Description" := "Pay Description";
                            EmployeeTimesheet."Rate Type" := "Rate Type";
                            EmployeeTimesheet.Rate := Rate;
                            EmployeeTimesheet.Units := Units;
                            EmployeeTimesheet.Amount := Amount;
                            EmployeeTimesheet."Quick Timesheet" := "Quick Timesheet";
                            //ASHNEIL CHANDRA  21072017
                            EmployeeTimesheet."Is Leave Without Pay" := "Is Leave Without Pay";
                            //ASHNEIL CHANDRA  21072017
                            EmployeeTimesheet."Is Leave" := "Is Leave";
                            EmployeeTimesheet."From Date" := "From Date";
                            EmployeeTimesheet."To Date" := "To Date";
                            EmployeeTimesheet."From Time" := "From Time";
                            EmployeeTimesheet."To Time" := "To Time";
                            EmployeeTimesheet.INSERT;
                          END;
                        UNTIL NEXT=0;

                        //Normal Hours being Adjusted for Leave
                        Employee.INIT;
                        Employee.RESET;
                        IF Employee.FINDFIRST() THEN REPEAT
                          DefaultUnits := 0;
                          DefaultUnits := Employee.Units;
                          EmployeeTSNH.INIT;
                          EmployeeTSNH.RESET;
                          EmployeeTSNH.SETRANGE("Branch Code","Branch Code");
                          EmployeeTSNH.SETRANGE("Shift Code", "Shift Code");
                          EmployeeTSNH.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTSNH.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeeTSNH.SETRANGE("Pay Run No.","Pay Run No.");
                          EmployeeTSNH.SETRANGE("Special Pay No.", "Special Pay No.");
                          EmployeeTSNH.SETRANGE("Employee No.", Employee."No.");
                          EmployeeTSNH.SETRANGE("Pay Code", NormalHours);
                          IF EmployeeTSNH.FINDFIRST() THEN BEGIN
                            EmployeeTimesheet.INIT;
                            EmployeeTimesheet.RESET;
                            EmployeeTimesheet.SETRANGE("Branch Code","Branch Code");
                            EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                            EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                            EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                            EmployeeTimesheet.SETRANGE("Pay Run No.","Pay Run No.");
                            EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                            EmployeeTimesheet.SETRANGE("Employee No.", EmployeeTSNH."Employee No.");
                            EmployeeTimesheet.SETRANGE("Is Leave", TRUE);
                            IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                              EmployeeTSNH.Units := DefaultUnits - EmployeeTimesheet.Units;
                            UNTIL EmployeeTimesheet.NEXT = 0;
                            EmployeeTSNH.VALIDATE(Units);
                            EmployeeTSNH.MODIFY;
                          END;
                        UNTIL Employee.NEXT = 0;

                        CurrPage.CLOSE;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }

    var
        HRSETUP : Record "Human Resources Setup";
        EmployeeTimesheet : Record "Employee Timesheet";
        EmployeeTSNH : Record "Employee Timesheet";
        NormalHours : Code[10];
        MLine : Integer;
        Employee : Record "Employee Pay Details";
        EmployeeMaster : Record Employee;
        RateType : Decimal;
        DefaultUnits : Decimal;
}

