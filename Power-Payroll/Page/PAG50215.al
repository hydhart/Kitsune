page 50215 "Process Payroll"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Pay Run Scheduler";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Pay Run No.";"Pay Run No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Special Pay No.";"Special Pay No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Pay From Date";"Pay From Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Pay To Date";"Pay To Date")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Payroll Reference";"Payroll Reference")
                {
                }
            }
            part(Control1000000013;"Employee Timesheet CardPart")
            {
                SubPageLink = Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Calendar Code=FIELD(Calendar Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Pay From Date=FIELD(Pay From Date);
            }
            part(Control1000000029;"Pay Run CardPart")
            {
                SubPageLink = Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Calendar Code=FIELD(Calendar Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.), Pay From Date=FIELD(Pay From Date);
            }
            part(Control1000000014;"Bank Pay Distribution CardPart")
            {
                SubPageLink = Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Calendar Code=FIELD(Calendar Code), Statistics Group=FIELD(Statistics Group), Pay Run No.=FIELD(Pay Run No.), Special Pay No.=FIELD(Special Pay No.);
            }
            group(Control1000000028)
            {
                fixed("Branch Policy Details")
                {
                    Caption = 'Branch Policy Details';
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
                    group("Tax Start Month")
                    {
                        Caption = 'Tax Start Month';
                        field("Month Start Date";"Month Start Date")
                        {
                        }
                    }
                    group("Tax End Month")
                    {
                        Caption = 'Tax End Month';
                        field("Month End Date";"Month End Date")
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
            group(Timesheet)
            {
                Caption = 'Timesheet';
                action("Process Timesheet")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF Release = TRUE THEN BEGIN
                          ERROR('Pay Run released, can not reprocess');
                        END;

                        HRSETUP.GET();
                        NormalHours := HRSETUP."Normal Hours";

                        IF Release = FALSE THEN BEGIN
                          IF "Process Timesheet" = TRUE THEN BEGIN
                            EmployeeTimesheet.INIT;
                            EmployeeTimesheet.RESET;
                            EmployeeTimesheet.SETRANGE("Branch Code","Branch Code");
                            EmployeeTimesheet.SETRANGE("Shift Code","Shift Code");
                            EmployeeTimesheet.SETRANGE("Calendar Code","Calendar Code");
                            EmployeeTimesheet.SETRANGE("Statistics Group","Statistics Group");
                            EmployeeTimesheet.SETRANGE("Pay Run No.","Pay Run No.");
                            EmployeeTimesheet.SETRANGE("Special Pay No.","Special Pay No.");
                            Reprocess := CONFIRM('WARNING!! Reprocessing Timesheet will delete the existing one',TRUE);
                            IF Reprocess = TRUE THEN BEGIN
                              EmployeeTimesheet.DELETEALL;
                              COMMIT;
                              "Process Timesheet" := FALSE;
                              MODIFY;
                            END;
                            IF Reprocess = FALSE THEN BEGIN
                              MESSAGE('Reprocessing aborted');
                              "Process Timesheet" := TRUE;
                              MODIFY;
                              EXIT;
                            END;
                          END;
                        END;


                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE("Branch Code", "Branch Code");
                        Employee.SETRANGE("Shift Code", "Shift Code");
                        Employee.SETRANGE("Statistics Group", "Statistics Group");
                        Employee.SETRANGE("Calendar Code", "Calendar Code");
                        Employee.SETRANGE(Terminated,FALSE);
                        IF Employee.FINDFIRST() THEN REPEAT
                          Employee."Zero Normal Hours" := FALSE;
                          Employee.MODIFY;
                          EmployeeTimesheet.SETRANGE("Branch Code", Employee."Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", Employee."Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", Employee."Statistics Group");
                          EmployeeTimesheet.SETRANGE("Employee No.", Employee."No.");
                          EmployeeTimesheet.SETRANGE("Pay Run No." , "Pay Run No.");
                          EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF NOT EmployeeTimesheet.FINDFIRST() THEN BEGIN
                            EmployeeTimesheet."Branch Code" := "Branch Code";
                            EmployeeTimesheet."Shift Code" := "Shift Code";
                            EmployeeTimesheet."Statistics Group" := "Statistics Group";
                            EmployeeTimesheet."Employee No." := Employee."No.";
                            IF EmployeeMaster.GET(EmployeeTimesheet."Employee No.") THEN BEGIN
                              EmployeeTimesheet."Employee Name" := EmployeeMaster."First Name" + ' ' + EmployeeMaster."Last Name";
                            END;
                            EmployeeTimesheet."Sub Branch Code" := Employee."Sub Branch Code";
                            EmployeeTimesheet."Payroll Reference" := "Payroll Reference";
                            EmployeeTimesheet."Calendar Code" := "Calendar Code";
                            EmployeeTimesheet."Pay Run No." := "Pay Run No.";
                            EmployeeTimesheet."Special Pay No." := "Special Pay No.";
                            EmployeeTimesheet."Pay Code" := NormalHours;
                            EmployeeTimesheet.Rate := Employee."Employee Rate";
                            EmployeeTimesheet.Units := Employee.Units;
                            EmployeeTimesheet."Pay From Date" := "Pay From Date";
                            EmployeeTimesheet."Pay To Date" := "Pay To Date";
                            EmployeeTimesheet."Tax Start Month" := "Month Start Date";
                            EmployeeTimesheet."Tax End Month" := "Month End Date";
                            EmployeeTimesheet."Basic Pay" := Employee."Gross Standard Pay";
                            EmployeeTimesheet."Date Processed" := TODAY;
                            EmployeeTimesheet."Zero Normal Hours" := FALSE;
                            EmployeeTimesheet."Rate Type" := Employee."Rate Type";
                            EVALUATE(RateType, FORMAT(EmployeeTimesheet."Rate Type"));
                            IF  EmployeeTimesheet.Rate <> 0 THEN BEGIN
                              IF EmployeeTimesheet.Units <> 0 THEN BEGIN
                                EmployeeTimesheet.Amount := EmployeeTimesheet.Rate * EmployeeTimesheet.Units * RateType;
                              END;
                            END;
                            EmployeeTimesheet.INSERT;

                            EmployeeTimesheet.VALIDATE("Pay Code");
                            IF EmployeeTimesheet."Pay Code" = HRSETUP."Normal Hours" THEN BEGIN
                              IF EmployeeTimesheet.Amount = 0 THEN BEGIN
                                EmployeeTimesheet."Zero Normal Hours" := TRUE;
                              END;
                            END;
                            EmployeeTimesheet.MODIFY;
                          END;
                        UNTIL Employee.NEXT=0;

                        EmployeeTimesheet.INIT;
                        EmployeeTimesheet.RESET;
                        EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                        EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                        EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        EmployeeTimesheet.SETRANGE("Pay Run No." , "Pay Run No.");
                        EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        EmployeeTimesheet.SETRANGE("Zero Normal Hours", TRUE);
                        IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                          Employee.INIT;
                          Employee.RESET;
                          Employee.SETRANGE("No.", EmployeeTimesheet."Employee No.");
                          IF Employee.FINDFIRST() THEN BEGIN
                            Employee."Zero Normal Hours" := TRUE;
                            Employee.MODIFY;
                          END;
                        UNTIL EmployeeTimesheet.NEXT=0;

                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE("Branch Code", "Branch Code");
                        Employee.SETRANGE("Shift Code", "Shift Code");
                        Employee.SETRANGE("Statistics Group", "Statistics Group");
                        Employee.SETRANGE("Calendar Code", "Calendar Code");
                        Employee.SETRANGE("Zero Normal Hours", TRUE);
                        IF Employee.FINDFIRST() THEN REPEAT
                          EmployeeTimesheet.SETRANGE("Branch Code", Employee."Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", Employee."Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", Employee."Statistics Group");
                          EmployeeTimesheet.SETRANGE("Employee No.", Employee."No.");
                          EmployeeTimesheet.SETRANGE("Pay Run No." , "Pay Run No.");
                          EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                            EmployeeTimesheet."Zero Normal Hours" := Employee."Zero Normal Hours";
                            EmployeeTimesheet.MODIFY;
                          UNTIL EmployeeTimesheet.NEXT = 0;
                        UNTIL Employee.NEXT=0;


                        EmployeeTimesheet.INIT;
                        EmployeeTimesheet.RESET;
                        EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                        EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                        EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        EmployeeTimesheet.SETRANGE("Pay Run No." , "Pay Run No.");
                        EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                          BranchPolicies.INIT;
                          BranchPolicies.RESET;
                          BranchPolicies.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicies.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicies.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicies.SETRANGE("Statistics Group", "Statistics Group");
                          IF BranchPolicies.FINDFIRST() THEN BEGIN
                            EmployeeTimesheet."Pay Calculation Type" := BranchPolicies."Pay Calculation Type";
                            EmployeeTimesheet.MODIFY;
                          END;
                        UNTIL EmployeeTimesheet.NEXT=0;


                        EmployeeTimesheet.INIT;
                        EmployeeTimesheet.RESET;
                        EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                        EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                        EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        EmployeeTimesheet.SETRANGE("Pay Run No." , "Pay Run No.");
                        EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                          EmployeePayTable.INIT;
                          EmployeePayTable.RESET;
                          EmployeePayTable.SETRANGE("Branch Code", "Branch Code");
                          EmployeePayTable.SETRANGE("Shift Code", "Shift Code");
                          EmployeePayTable.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeePayTable.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeePayTable.SETRANGE("Employee No.", EmployeeTimesheet."Employee No.");
                          IF EmployeePayTable.FINDFIRST() THEN BEGIN
                            EmployeeTimesheet."Pay Reference" := EmployeePayTable."Pay Reference";
                            EmployeeTimesheet.MODIFY;
                          END;
                        UNTIL EmployeeTimesheet.NEXT=0;

                          "Process Timesheet" := TRUE;
                          MESSAGE('Timesheet Created');
                          MODIFY;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Import Quick Timesheet")
                {
                    Promoted = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017

                        //ASHNEIL CHANDRA  18072017
                        HRSETUP.GET();
                        IF HRSETUP."Import Timesheet" = TRUE THEN BEGIN
                          EmployeeTimesheet.INIT;
                          EmployeeTimesheet.RESET;
                          EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeeTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                          EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF NOT EmployeeTimesheet.FINDFIRST() THEN BEGIN
                            ERROR('Timesheet does not exist, please process');
                          END;

                          IF EmployeeTimesheet.FINDFIRST() THEN BEGIN
                            QuickTimesheet.INIT;
                            QuickTimesheet.RESET;
                            QuickTimesheet.SETRANGE("Branch Code", "Branch Code");
                            QuickTimesheet.SETRANGE("Shift Code", "Shift Code");
                            QuickTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                            QuickTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                            QuickTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                            QuickTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                            PAGE.RUN(50222,QuickTimesheet);
                          END;
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Add Employee")
                {
                    Promoted = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF Release = TRUE THEN BEGIN
                          ERROR('Pay Run released, can not add additional employee');
                        END;

                        IF Release = FALSE THEN BEGIN
                          IF HRSETUP.GET() THEN BEGIN;
                            HRSETUP."Branch Code" := "Branch Code";
                            HRSETUP."Shift Code" := "Shift Code";
                            HRSETUP."Calendar Code" := "Calendar Code";
                            HRSETUP."Statistics Group" := "Statistics Group";
                            HRSETUP."Pay Run No." := "Pay Run No.";
                            HRSETUP."Special Pay No." := "Special Pay No.";
                            HRSETUP."Add to Timesheet" := TRUE;
                            HRSETUP.MODIFY;
                          END;

                          EmployeeMaster.INIT;
                          EmployeeMaster.RESET;
                          EmployeeMaster.SETRANGE("Branch Code", "Branch Code");
                          EmployeeMaster.SETRANGE("Shift Code", "Shift Code");
                          EmployeeMaster.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeMaster.SETRANGE("Statistics Group", "Statistics Group");
                          PAGE.RUN(5201,EmployeeMaster);
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
            group(Process)
            {
                Caption = 'Process';
                action("Process Payroll")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF Release = TRUE THEN BEGIN
                          ERROR('Pay Run released, can not reprocess');
                        END;

                        EmployeeTimesheet.INIT;
                        EmployeeTimesheet.RESET;
                        EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                        EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                        EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        EmployeeTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                        EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        IF EmployeeTimesheet.FINDFIRST() THEN BEGIN
                          Reprocess := TRUE;
                        END;
                        IF NOT EmployeeTimesheet.FINDFIRST() THEN BEGIN
                          Reprocess := FALSE;
                          ERROR('Timesheet does not exist, please process');
                          EXIT;
                        END;

                        Employee.INIT;
                        Employee.RESET;
                        IF Employee.FINDFIRST() THEN REPEAT
                          Employee."Process Payroll" := FALSE;
                          Employee.MODIFY;
                        UNTIL Employee.NEXT = 0;

                        EmployeePayTable.INIT;
                        EmployeePayTable.RESET;
                        IF EmployeePayTable.FINDFIRST() THEN REPEAT
                          EmployeePayTable."Process Payroll" := FALSE;
                          EmployeePayTable.MODIFY;
                        UNTIL EmployeePayTable.NEXT = 0;

                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                        IF Employee.FINDFIRST() THEN REPEAT
                          EmployeeTimesheet.INIT;
                          EmployeeTimesheet.RESET;
                          EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeeTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                          EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                          EmployeeTimesheet.SETRANGE("Employee No.", Employee."No.");
                          IF EmployeeTimesheet.FINDFIRST() THEN BEGIN
                            Employee."Process Payroll" := TRUE;
                            Employee.MODIFY;
                          END;
                        UNTIL Employee.NEXT = 0;

                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE("Process Payroll", TRUE);
                        IF Employee.FINDFIRST() THEN REPEAT
                          EmployeePayTable.INIT;
                          EmployeePayTable.RESET;
                          EmployeePayTable.SETRANGE("Employee No.", Employee."No.");
                          IF EmployeePayTable.FINDFIRST() THEN REPEAT
                            EmployeePayTable."Process Payroll" := TRUE;
                            EmployeePayTable.MODIFY;
                          UNTIL EmployeePayTable.NEXT = 0;
                        UNTIL Employee.NEXT = 0;

                        IF Release = FALSE THEN BEGIN
                          IF "Process Payroll" = FALSE THEN BEGIN
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code","Branch Code");
                            PAYRUN.SETRANGE("Shift Code","Shift Code");
                            PAYRUN.SETRANGE("Calendar Code","Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group","Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.","Pay Run No.");
                            PAYRUN.SETRANGE("Special Pay No.","Special Pay No.");
                            IF PAYRUN.FINDFIRST() THEN BEGIN
                              PAYRUN.DELETEALL;
                              COMMIT;
                            END;
                          END;
                          IF "Process Payroll" = TRUE THEN BEGIN
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code","Branch Code");
                            PAYRUN.SETRANGE("Shift Code","Shift Code");
                            PAYRUN.SETRANGE("Calendar Code","Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group","Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.","Pay Run No.");
                            PAYRUN.SETRANGE("Special Pay No.","Special Pay No.");
                            Reprocess := CONFIRM('WARNING!! Reprocessing a Pay Run will delete the existing one',TRUE);
                            IF Reprocess = TRUE THEN BEGIN
                              PAYRUN.DELETEALL;
                              COMMIT;
                              "Process Payroll" := FALSE;
                              MODIFY;
                            END;
                            IF Reprocess = FALSE THEN BEGIN
                              MESSAGE('Reprocessing aborted');
                              "Process Payroll" := TRUE;
                              MODIFY;
                              EXIT;
                            END;
                          END;
                        END;


                        HRSETUP.GET();

                        NormalHours := HRSETUP."Normal Hours";
                        MyFNPF := HRSETUP.FNPF;
                        MyPAYE := HRSETUP.PAYE;
                        MySRT := HRSETUP.SRT;
                        MyECAL := HRSETUP.ECAL;


                        TAXCountryCode := HRSETUP."Country/Region Code";
                        RunsPerCalendar := HRSETUP."Runs Per Calendar";

                        GlobalFNPFPercent := HRSETUP."Global FNPF Contribution";
                        IF HRSETUP."Global FNPF Contribution" <> 8.0 THEN BEGIN
                          HRSETUP."Global FNPF Contribution" := 8.0;
                          GlobalFNPFPercent := HRSETUP."Global FNPF Contribution";
                          HRSETUP.MODIFY;;
                        END;

                        TaxRate := HRSETUP."Global Secondary Tax";
                        IF HRSETUP."Global Secondary Tax" <> 20.0 THEN BEGIN
                          HRSETUP."Global Secondary Tax" := 20.0;
                          TaxRate := HRSETUP."Global Secondary Tax";
                          HRSETUP.MODIFY;;
                        END;

                        IF HRSETUP."Employer FNPF Contribution" <> 10.0 THEN BEGIN
                          HRSETUP."Employer FNPF Contribution" := 10.0;
                          HRSETUP.MODIFY;
                        END;

                        IF Reprocess = TRUE THEN BEGIN
                          //ADD Employee Pay Table Details
                          EmployeePayTable.RESET;
                          EmployeePayTable.INIT;
                          EmployeePayTable.SETRANGE("Branch Code", "Branch Code");
                          EmployeePayTable.SETRANGE("Shift Code", "Shift Code");
                          EmployeePayTable.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeePayTable.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeePayTable.SETRANGE("Process Payroll", TRUE);
                          IF EmployeePayTable.FINDFIRST() THEN REPEAT
                            PAYRUN."Employee No." := EmployeePayTable."Employee No.";
                            PAYRUN."Employee Name" := EmployeePayTable."Employee Name";
                            PAYRUN."Sub Branch Code" := EmployeePayTable."Sub Branch Code";
                            PAYRUN."Pay Reference" := EmployeePayTable."Pay Reference";
                            IF Employee.GET(EmployeePayTable."Employee No.") THEN BEGIN
                              PAYRUN."By Pass FNPF" := Employee."By Pass FNPF";
                              PAYRUN."Increment Date" := Employee."Increment Date";
                            END;
                            IF EmployeeMaster.GET(EmployeePayTable."Employee No.") THEN BEGIN
                              PAYRUN."Global Dimension 1 Code" := EmployeeMaster."Global Dimension 1 Code";
                              PAYRUN."Global Dimension 2 Code" := EmployeeMaster."Global Dimension 2 Code";
                            END;
                            PAYRUN.F := RunsPerCalendar;
                            PAYRUN."Pay Code" := EmployeePayTable."Pay Code";
                            PAYRUN."Pay Description" := EmployeePayTable."Pay Description";
                            PAYRUN.Amount := EmployeePayTable.Amount;
                            PAYRUN.Rate := EmployeePayTable.Rate;
                            PAYRUN."Pay Type" := EmployeePayTable."Pay Type";
                            PAYRUN.Units := EmployeePayTable.Units;
                            PAYRUN."Branch Code" := EmployeePayTable."Branch Code";
                            PAYRUN."Shift Code" := EmployeePayTable."Shift Code";
                            PAYRUN."Calendar Code" := EmployeePayTable."Calendar Code";
                            PAYRUN."Statistics Group" := EmployeePayTable."Statistics Group";
                            PAYRUN."Include In Pay Slip" := EmployeePayTable."Include In Pay Slip";
                            PAYRUN."Is FNPF Base" := EmployeePayTable."Is FNPF Base";
                            PAYRUN."Is PAYE Base" := EmployeePayTable."Is PAYE Base";
                            PAYRUN."Pay Run No." := "Pay Run No.";
                            PAYRUN."Payroll Reference" := "Payroll Reference";
                            PayRunNo := "Pay Run No.";
                            EVALUATE(PAYRUN.G, PAYRUN."Pay Run No.");
                            PAYRUN."Special Pay No." := "Special Pay No.";
                            SpecialPayRunNo := "Special Pay No.";
                            PAYRUN."Is FNPF Field" := EmployeePayTable."Is FNPF Field";
                            PAYRUN."Is PAYE Field" := EmployeePayTable."Is PAYE Field";
                            PAYRUN."Is SRT Field" := EmployeePayTable."Is SRT Field";
                            PAYRUN."Is SRT Base" := EmployeePayTable."Is SRT Base";
                            //ASHNEIL CHANDRA  21072017
                            PAYRUN."Is ECAL Field" := EmployeePayTable."Is ECAL Field";
                            PAYRUN."Is ECAL Base" := EmployeePayTable."Is ECAL Base";
                            PAYRUN."Is Old Rate" := EmployeePayTable."Is Old Rate";
                            //ASHNEIL CHANDRA  21072017
                            PAYRUN."Lump Sum" := EmployeePayTable."Lump Sum";
                            PAYRUN.Redundancy := EmployeePayTable.Redundancy;
                            PAYRUN."Exempt Amount" := EmployeePayTable."Exempt Amount";
                            PAYRUN."Tax Rate" := EmployeePayTable."Tax Rate";
                            PAYRUN.Endorsed := EmployeePayTable.Endorsed;
                            PAYRUN.Bonus := EmployeePayTable.Bonus;
                            PAYRUN."Quick Timesheet" := EmployeePayTable."Quick TimeSheet";
                            PAYRUN."Tax Start Month" := "Month Start Date";
                            PAYRUN."Tax End Month" := "Month End Date";
                            PAYRUN."Pay From Date" := "Pay From Date";
                            PAYRUN."Pay To Date" := "Pay To Date";
                            PAYRUN."Special Tag" := "Special Tag";
                            PAYRUN.INSERT;

                            IF PAYRUN."Pay Code" = NormalHours THEN BEGIN
                              PAYRUN.DELETE;
                            END;

                          UNTIL EmployeePayTable.NEXT=0;


                          //ADD Employee Timesheet Details
                          EmployeeTimesheet.INIT;
                          EmployeeTimesheet.RESET;
                          EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                          EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                          EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                          EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                          EmployeeTimesheet.SETRANGE("Pay Run No.", PayRunNo);
                          EmployeeTimesheet.SETRANGE("Special Pay No.", SpecialPayRunNo);
                          IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                            PAYRUN."Employee No." := EmployeeTimesheet."Employee No.";
                            PAYRUN."Employee Name" := EmployeeTimesheet."Employee Name";
                            PAYRUN."Sub Branch Code" := EmployeeTimesheet."Sub Branch Code";
                            IF Employee.GET(EmployeeTimesheet."Employee No.") THEN BEGIN
                              PAYRUN."By Pass FNPF" := Employee."By Pass FNPF";
                              PAYRUN."Increment Date" := Employee."Increment Date";
                            END;
                            IF EmployeeMaster.GET(EmployeeTimesheet."Employee No.") THEN BEGIN
                              PAYRUN."Global Dimension 1 Code" := EmployeeMaster."Global Dimension 1 Code";
                              PAYRUN."Global Dimension 2 Code" := EmployeeMaster."Global Dimension 2 Code";
                            END;
                            PAYRUN.F := RunsPerCalendar;
                            PAYRUN."Pay Code" := EmployeeTimesheet."Pay Code";
                            PAYRUN."Pay Description" := EmployeeTimesheet."Pay Description";
                            PAYRUN.Amount := EmployeeTimesheet.Amount;
                            PAYRUN.Rate := EmployeeTimesheet.Rate;
                            PAYRUN.Units := EmployeeTimesheet.Units;
                            PAYRUN."Zero Normal Hours" := EmployeeTimesheet."Zero Normal Hours";
                            PAYRUN."Branch Code" := EmployeeTimesheet."Branch Code";
                            PAYRUN."Shift Code" := EmployeeTimesheet."Shift Code";
                            PAYRUN."Calendar Code" := EmployeeTimesheet."Calendar Code";
                            PAYRUN."Statistics Group" := EmployeeTimesheet."Statistics Group";
                            PAYRUN."Pay Run No." := EmployeeTimesheet."Pay Run No.";
                            EVALUATE(PAYRUN.G, PAYRUN."Pay Run No.");
                            PAYRUN."Special Pay No." := EmployeeTimesheet."Special Pay No.";
                            PAYRUN."Tax Start Month" := EmployeeTimesheet."Tax Start Month";
                            PAYRUN."Tax End Month" := EmployeeTimesheet."Tax End Month";
                            PAYRUN."Pay From Date" := EmployeeTimesheet."Pay From Date";
                            PAYRUN."Pay To Date" := EmployeeTimesheet."Pay To Date";
                            PAYRUN."Rate Type" := EmployeeTimesheet."Rate Type";
                            PAYRUN."Include In Pay Slip" := FALSE;
                            PAYRUN."Is FNPF Base" := FALSE;
                            PAYRUN."Is PAYE Base" := FALSE;
                            PAYRUN."Is FNPF Field" := FALSE;
                            PAYRUN."Is PAYE Field" := FALSE;
                            PAYRUN."Is SRT Field" := FALSE;
                            PAYRUN."Is SRT Base" := FALSE;
                            //ASHNEIL CHANDRA  21072017
                            PAYRUN."Is ECAL Base" := FALSE;
                            PAYRUN."Is ECAL Field" := FALSE;
                            PAYRUN."Is Leave" := FALSE;
                            PAYRUN."Is Old Rate" := FALSE;
                            PAYRUN."Is Leave Without Pay" := FALSE;
                            PAYRUN."Standard Deductions" := FALSE;
                            //ASHNEIL CHANDRA  21072017
                            PAYRUN."Lump Sum" := FALSE;
                            PAYRUN.Redundancy := FALSE;
                            PAYRUN."Exempt Amount" := 0;
                            PAYRUN."Tax Rate" := 0;
                            PAYRUN.Endorsed := FALSE;
                            PAYRUN.Bonus := FALSE;
                            PAYRUN."Quick Timesheet" := FALSE;
                            PAYRUN."From Date" := EmployeeTimesheet."From Date";
                            PAYRUN."To Date" := EmployeeTimesheet."To Date";
                            PAYRUN."From Time" := EmployeeTimesheet."From Time";
                            PAYRUN."To Time" := EmployeeTimesheet."To Time";
                            PAYRUN.INSERT;
                          UNTIL EmployeeTimesheet.NEXT = 0;

                          //Update Pay Element Details
                          PAYRUN.INIT;
                          PAYRUN.RESET;
                          PAYRUN.SETRANGE("Branch Code", "Branch Code");
                          PAYRUN.SETRANGE("Shift Code", "Shift Code");
                          PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                          PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                          PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                          PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                          IF PAYRUN.FINDFIRST() THEN REPEAT
                            PayElementMaster.INIT;
                            PayElementMaster.RESET;
                            PayElementMaster.SETRANGE("Pay Code",PAYRUN."Pay Code");
                            IF PayElementMaster.FINDFIRST() THEN BEGIN
                              PAYRUN."Is FNPF Base" := PayElementMaster."Is FNPF Base";
                              PAYRUN."Is PAYE Base" := PayElementMaster."Is PAYE Base";
                              PAYRUN."Is FNPF Field" := PayElementMaster."Is FNPF Field";
                              PAYRUN."Is PAYE Field" := PayElementMaster."Is PAYE Field";
                              PAYRUN."Is SRT Field" := PayElementMaster."Is SRT Field";
                              PAYRUN."Is SRT Base" := PayElementMaster."Is SRT Base";
                              PAYRUN."Lump Sum" := PayElementMaster."Lump Sum";
                              PAYRUN.Redundancy := PayElementMaster.Redundancy;
                              PAYRUN."Exempt Amount" := PayElementMaster."Exempt Amount";
                              PAYRUN."Tax Rate" := PayElementMaster."Tax Rate";
                              PAYRUN.Bonus := PayElementMaster.Bonus;
                              PAYRUN."Quick Timesheet" := PayElementMaster."Quick Timesheet";
                              PAYRUN."Include In Pay Slip" := PayElementMaster."Include In Pay Slip";
                              PAYRUN."Pay Description" := PayElementMaster."Pay Description";
                              PAYRUN."Rate Type" := PayElementMaster."Rate Type";
                              PAYRUN."Pay Type" := PayElementMaster."Pay Type";
                              PAYRUN."Calculation Type" := PayElementMaster."Calculation Type";
                              PAYRUN."Leave Type" := PayElementMaster."Leave Type";
                              PAYRUN."Pay Category" := PayElementMaster."Pay Category";
                              PAYRUN."Cash/Non Cash" := PayElementMaster."Cash/Non Cash";
                              PAYRUN."Is Leave" := PayElementMaster."Is Leave";
                              //ASHNEIL CHANDRA  21072017
                              PAYRUN."Is ECAL Base" := PayElementMaster."Is ECAL Base";
                              PAYRUN."Is ECAL Field" := PayElementMaster."Is ECAL Field";
                              PAYRUN."Is Leave Without Pay" := PayElementMaster."Is Leave Without Pay";
                              PAYRUN."Standard Deductions" := PayElementMaster."Standard Deductions";
                              PAYRUN."Is Old Rate" := PayElementMaster."Is Old Rate";
                              //ASHNEIL CHANDRA  21072017
                              PAYRUN.MODIFY;
                            END;
                          UNTIL PAYRUN.NEXT=0;

                          //PAYROLL ENGINE
                          //PAYROLL CALCULATION
                          Employee.INIT;
                          Employee.RESET;
                          Employee.SETRANGE("Branch Code", "Branch Code");
                          Employee.SETRANGE("Shift Code", "Shift Code");
                          Employee.SETRANGE("Calendar Code", "Calendar Code");
                          Employee.SETRANGE("Statistics Group", "Statistics Group");
                          Employee.SETRANGE("Process Payroll", TRUE);
                          IF Employee.FINDFIRST() THEN REPEAT;
                            TaxCodeTemp := '';
                            TaxCodeTemp := FORMAT(Employee."Tax Code");
                            MFNPFBASE := 0;
                            MPAYEBASE := 0;
                            MSRTBASE := 0;
                            //ASHNEIL CHANDRA  21072017
                            Adjustment := 0;
                            TempGRPAYEAmount := 0;
                            TempLSPAYEAmount := 0;
                            MECALBASE := 0;
                            ECALTAX := 0;
                            //ASHNEIL CHANDRA  21072017
                            MLUMPSUM := 0;
                            MLUMPSUMEN := 0;
                            MREDUNDANCY := 0;
                            MENDORSED := 0;
                            MREDUND := 0;
                            MBONUS := 0;
                            MP1 := 0;
                            MP2 := 0;
                            MP6 := 0;
                            MP7 := 0;
                            MC2 := 0;
                            SRTTAX := 0;
                            PAYETAX := 0;
                            TLUMPSUM := 0;
                            LumpSumPAYE := 0;
                            EmployerAdditionalFNPF := 0;
                            EmployeeAdditionalFNPF := 0;
                            TotalEarnings := 0;
                            Employee8Percent := 0;

                            IF (Employee."Employee FNPF Additional Cont." + Employee."Employer FNPF Additional Cont.") > 0.0 THEN BEGIN
                              IF (Employee."Employee FNPF Additional Cont." + Employee."Employer FNPF Additional Cont.") <= 12.0 THEN BEGIN
                                EmployeeAdditionalFNPF := Employee."Employee FNPF Additional Cont.";
                                EmployerAdditionalFNPF := Employee."Employer FNPF Additional Cont.";
                              END;
                            END;

                            IF Employee."Employee Secondary Tax" < 20.0 THEN BEGIN
                              IF Employee."Employee Secondary Tax" > 0.0 THEN BEGIN
                                TaxRate := Employee."Employee Secondary Tax";
                              END;
                            END;

                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is Leave Without Pay", FALSE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              IF PAYRUN."Is FNPF Base" THEN BEGIN
                                MFNPFBASE := MFNPFBASE + PAYRUN.Amount;
                              END;

                              IF PAYRUN."Is PAYE Base" THEN BEGIN
                                IF PAYRUN."Lump Sum" = FALSE THEN BEGIN
                                  IF PAYRUN.Redundancy = FALSE THEN BEGIN
                                    IF PAYRUN.Bonus = FALSE THEN BEGIN
                                      MPAYEBASE := MPAYEBASE + PAYRUN.Amount;             //PRIMARY PAYE
                                    END;
                                  END;
                                END;

                                IF PAYRUN.Bonus = TRUE THEN BEGIN
                                  MBONUS := MBONUS + PAYRUN.Amount;                      //BONUS
                                END;

                                IF PAYRUN.Redundancy = TRUE THEN BEGIN
                                  MREDUNDANCY := MREDUNDANCY + PAYRUN.Amount;            //REDUNDANCY PAYE
                                END;

                                IF PAYRUN."Lump Sum" = TRUE THEN BEGIN
                                  IF PAYRUN.Endorsed = FALSE THEN BEGIN
                                    MLUMPSUM := MLUMPSUM + PAYRUN.Amount;                //LUMP SUM PAYE, ENDORSED FALSE
                                  END;
                                END;

                                IF PAYRUN."Lump Sum" = TRUE THEN BEGIN
                                  IF PAYRUN.Endorsed = TRUE THEN BEGIN
                                    MLUMPSUMEN := MLUMPSUMEN + PAYRUN.Amount;            //LUMP SUM PAYE, ENDORSED TRUE
                                  END;
                                END;
                              END;

                              IF PAYRUN.Redundancy = TRUE THEN BEGIN
                                IF MREDUNDANCY > PAYRUN."Exempt Amount" THEN BEGIN
                                  MREDUND := (MREDUNDANCY - PAYRUN."Exempt Amount") * (PAYRUN."Tax Rate"/100);
                                END;

                                IF MREDUNDANCY <= PAYRUN."Exempt Amount" THEN BEGIN
                                  MREDUND := 0;
                                END;
                              END;

                              IF PAYRUN."Lump Sum" = TRUE THEN BEGIN
                                IF PAYRUN.Endorsed = TRUE THEN BEGIN
                                  MENDORSED := (MLUMPSUMEN - PAYRUN."Exempt Amount") * (PAYRUN."Tax Rate"/100);
                                END;
                              END;

                              IF PAYRUN."Is SRT Base" THEN BEGIN
                                IF PAYRUN.Bonus = FALSE THEN BEGIN
                                  MSRTBASE := MSRTBASE + PAYRUN.Amount;
                                END;
                              END;

                              //ASHNEIL CHANDRA  21072017
                              IF PAYRUN."Is ECAL Base" THEN BEGIN
                                IF PAYRUN.Bonus = FALSE THEN BEGIN
                                  MECALBASE := MECALBASE + PAYRUN.Amount;
                                END;
                              END;
                              //ASHNEIL CHANDRA  21072017
                            UNTIL PAYRUN.NEXT=0;

                            //FNPF CALCULATION BEGINS
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is FNPF Field", TRUE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              PAYRUN.Amount := ROUND(((MFNPFBASE * (GlobalFNPFPercent + EmployeeAdditionalFNPF)) / 100 * -1), 0.01, '=');
                              PAYRUN."Employer 10 Percent" := ROUND(((MFNPFBASE * HRSETUP."Employer FNPF Contribution") / 100 * -1), 0.01, '=');
                              PAYRUN."Employee 8 Percent" := ROUND(((MFNPFBASE * HRSETUP."Global FNPF Contribution") / 100 * -1), 0.01, '=');
                              Employee8Percent := ABS(ROUND(((MFNPFBASE * HRSETUP."Global FNPF Contribution") / 100 * -1), 0.01, '='));
                              PAYRUN."Employer FNPF Additional" := ROUND(((MFNPFBASE * EmployerAdditionalFNPF) / 100 * -1), 0.01, '=');
                              PAYRUN."Employee FNPF Additional" := ROUND(((MFNPFBASE * EmployeeAdditionalFNPF) / 100 * -1), 0.01, '=');
                              PAYRUN.Units := ROUND(((MFNPFBASE * (GlobalFNPFPercent + EmployeeAdditionalFNPF)) / 100), 0.01, '=');
                              PAYRUN.Rate := -1;
                              PAYRUN.MODIFY;
                            UNTIL PAYRUN.NEXT=0;
                             //FNPF CALCULATION ENDS

                            //SRT CALCULATION BEGINS
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is SRT Field", TRUE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              PAYRUN.CALCFIELDS(E,B1,B2,B3,H);
                              MP1 := ROUND((MSRTBASE * (PAYRUN.F - (PAYRUN.G) + 1) + PAYRUN.E), 0.01, '=');                     //C1 CALCULATIONS
                              IncomeTaxMaster.INIT;
                              IncomeTaxMaster.RESET;
                              IF IncomeTaxMaster.FIND('-') THEN REPEAT
                                IF IncomeTaxMaster.Type = Employee."Residential/Non-Residential" THEN BEGIN
                                  IF (MP1 + PAYRUN.H) >= IncomeTaxMaster."Start Amount" THEN BEGIN
                                    IF (MP1 + PAYRUN.H) <= IncomeTaxMaster."End Amount" THEN BEGIN
                                      MP2 := ROUND((((MP1 + PAYRUN.H) - IncomeTaxMaster."SRT Excess Amount") * (IncomeTaxMaster."SRT %" / 100) + IncomeTaxMaster."SRT Additional Amount"), 0.01, '=');
                                    END;
                                  END;
                                END;
                              UNTIL IncomeTaxMaster.NEXT=0;

                              IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B2)) < 0 THEN BEGIN
                                SRTTAX := 0;
                              END;

                              IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B2)) > 0 THEN BEGIN
                                SRTTAX := ROUND(((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B2)), 0.01, '=');
                              END;

                              PAYRUN.Amount := ROUND((SRTTAX * -1), 0.01, '=');
                              PAYRUN.TotalSRTPaid := SRTTAX;
                              PAYRUN.Units := SRTTAX;
                              PAYRUN.Rate := -1;
                              PAYRUN.MODIFY;
                            UNTIL PAYRUN.NEXT=0;
                            //SRT CALCULATION ENDS

                            //ECAL CALCULATION BEGINS
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is ECAL Field", TRUE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              PAYRUN.CALCFIELDS(E,B1,B2,B3,H);
                              MP1 := ROUND((MECALBASE * (PAYRUN.F - (PAYRUN.G) + 1) + PAYRUN.E), 0.01, '=');                     //C1 CALCULATIONS

                              IncomeTaxMaster.INIT;
                              IncomeTaxMaster.RESET;
                              IF IncomeTaxMaster.FIND('-') THEN REPEAT
                                IF IncomeTaxMaster.Type = Employee."Residential/Non-Residential" THEN BEGIN
                                  IF (MP1) >= IncomeTaxMaster."Start Amount" THEN BEGIN
                                    IF (MP1) <= IncomeTaxMaster."End Amount" THEN BEGIN
                                      MP2 := ROUND((((MP1 + PAYRUN.H) - IncomeTaxMaster."ECAL Excess Amount") * (IncomeTaxMaster."ECAL %" / 100)), 0.01, '=');
                                    END;
                                  END;
                                END;
                              UNTIL IncomeTaxMaster.NEXT=0;

                              IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B3)) < 0 THEN BEGIN
                                ECALTAX := 0;
                              END;

                              IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B3)) > 0 THEN BEGIN
                                ECALTAX := ROUND(((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B3)), 0.01, '=');
                              END;

                              PAYRUN.Amount := ROUND((ECALTAX * -1), 0.01, '=');
                              PAYRUN.TotalECALPaid := ECALTAX;
                              PAYRUN.Units := ECALTAX;
                              PAYRUN.Rate := -1;
                              PAYRUN.MODIFY;
                            UNTIL PAYRUN.NEXT=0;
                            //ECAL CALCULATION ENDS

                            //PAYE CALCULATION BEGINS
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is PAYE Field", TRUE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                            //------------------------------------------------------------Tax Code <> P-------------------------
                              IF TaxCodeTemp <> 'P' THEN BEGIN
                                PAYRUN.CALCFIELDS(E,B1,B2,B3,H);
                                TLUMPSUM := ROUND(MLUMPSUM, 0.01, '=');
                                TotalEarnings := ROUND(MPAYEBASE, 0.01, '=') + ROUND(TLUMPSUM, 0.01, '=');
                                MP1 := TotalEarnings;
                                //----------------------------------C1------ASHNEIL CHANDRA-----------
                                MP2 := ROUND(MP1 * (TaxRate/100), 0.01, '=');

                                PAYRUN.C1 := MP1;
                                PAYRUN."Gross Pay" := TotalEarnings;
                                PAYRUN.MODIFY;
                                //----------------------------------C1------ASHNEIL CHANDRA-----------

                                //----------------------------------C2------ASHNEIL CHANDRA-----------
                                MC2 := ROUND(((MP1 + PAYRUN.H) * (TaxRate / 100)), 0.01, '=');

                                PAYRUN.C2 := MP1 + PAYRUN.H;
                                PAYRUN."Half of Gross Pay" := (PAYRUN.TotalEarningsPaid + PAYRUN.H) * 0.5;
                                PAYRUN.MODIFY;
                                //----------------------------------C2------ASHNEIL CHANDRA-----------

                                IF TLUMPSUM > 0 THEN BEGIN
                                  TotalEarnings := ROUND(MPAYEBASE, 0.01, '=');

                                  MP6 := TotalEarnings;

                                  MP7 := ROUND((MP6 * (TaxRate / 100)), 0.01, '=');

                                  LumpSumPAYE := MP2 - MP7;
                                END;

                                IF MP2 < 0 THEN BEGIN
                                  PAYETAX := 0;
                                END;

                                IF MP2 > 0 THEN BEGIN
                                  PAYETAX := MP2;
                                END;


                                PAYRUN.Amount := ROUND((PAYETAX * -1), 0.01, '=');
                                PAYRUN.TotalPAYEPaid := PAYETAX;
                                PAYRUN."Other PAYE" := ROUND(MREDUND, 0.01, '=') + ROUND((LumpSumPAYE / PAYRUN.F), 0.01, '=') + ROUND(MENDORSED, 0.01, '=');
                                PAYRUN.Units := PAYETAX;
                                PAYRUN.Rate := -1;
                                PAYRUN.MODIFY;
                              END;

                              //--------------------------------------------------------Tax Code P--------------------------------
                              IF TaxCodeTemp = 'P' THEN BEGIN
                                PAYRUN.CALCFIELDS(E,B1,B2,B3,H);
                                TLUMPSUM := ROUND(MLUMPSUM, 0.01, '=');
                                TotalEarnings := MPAYEBASE + TLUMPSUM;
                                MP1 := (TotalEarnings * (PAYRUN.F - (PAYRUN.G) + 1) + PAYRUN.E);               //C1 CALCULATIONS

                                //----------------------------------C1------ASHNEIL CHANDRA-----------
                                IncomeTaxMaster.INIT;
                                IncomeTaxMaster.RESET;
                                IF IncomeTaxMaster.FINDFIRST() THEN REPEAT
                                  IF IncomeTaxMaster.Type = Employee."Residential/Non-Residential" THEN BEGIN
                                    IF MP1 >= IncomeTaxMaster."Start Amount" THEN BEGIN
                                      IF MP1 <= IncomeTaxMaster."End Amount" THEN BEGIN
                                        IF TaxCodeTemp = 'P' THEN BEGIN
                                          MP2 := ROUND(((MP1 - IncomeTaxMaster."PAYE Excess Amount") * (IncomeTaxMaster."PAYE %" / 100) + IncomeTaxMaster."PAYE Additional Amount"), 0.01, '=');
                                        END;
                                      END;
                                    END;
                                  END;
                                UNTIL IncomeTaxMaster.NEXT=0;

                                PAYRUN.C1 := MP1;
                                PAYRUN."Tax on C1" := MP2;
                                PAYRUN.TotalEarningsPaid := TotalEarnings;
                                PAYRUN.MODIFY;
                                //----------------------------------C1------ASHNEIL CHANDRA-----------


                                //----------------------------------C2------ASHNEIL CHANDRA-----------
                                IncomeTaxMaster.INIT;
                                IncomeTaxMaster.RESET;
                                IF IncomeTaxMaster.FINDFIRST() THEN REPEAT
                                  IF IncomeTaxMaster.Type = Employee."Residential/Non-Residential" THEN BEGIN
                                    IF (MP1 + PAYRUN.H) >= IncomeTaxMaster."Start Amount" THEN BEGIN
                                      IF (MP1 + PAYRUN.H) <= IncomeTaxMaster."End Amount" THEN BEGIN
                                        IF TaxCodeTemp = 'P' THEN BEGIN
                                          MC2 := ROUND((((MP1 + PAYRUN.H) - IncomeTaxMaster."PAYE Excess Amount") * (IncomeTaxMaster."PAYE %" / 100) + IncomeTaxMaster."PAYE Additional Amount"), 0.01, '=');
                                        END;
                                      END;
                                    END;
                                  END;
                                UNTIL IncomeTaxMaster.NEXT=0;

                                PAYRUN.C2 := MP1 + PAYRUN.H;
                                PAYRUN."Half of Gross Pay" := (PAYRUN.TotalEarningsPaid + PAYRUN.H) * 0.5;
                                PAYRUN."Tax on C2" := MC2;
                                PAYRUN.MODIFY;
                                //----------------------------------C2------ASHNEIL CHANDRA-----------


                                IF TLUMPSUM > 0 THEN BEGIN
                                  TotalEarnings := MPAYEBASE;

                                  MP6 := (TotalEarnings * (PAYRUN.F - (PAYRUN.G) + 1) + PAYRUN.E);

                                  IncomeTaxMaster.INIT;
                                  IncomeTaxMaster.RESET;
                                  IF IncomeTaxMaster.FINDFIRST() THEN REPEAT
                                    IF IncomeTaxMaster.Type = Employee."Residential/Non-Residential" THEN BEGIN
                                      IF MP6 >= IncomeTaxMaster."Start Amount" THEN BEGIN
                                        IF MP6 <= IncomeTaxMaster."End Amount" THEN BEGIN
                                          IF TaxCodeTemp = 'P' THEN BEGIN
                                            MP7 := ROUND(((MP6 - IncomeTaxMaster."PAYE Excess Amount") * (IncomeTaxMaster."PAYE %" / 100) + IncomeTaxMaster."PAYE Additional Amount"), 0.01, '=');
                                          END;
                                        END;
                                      END;
                                    END;
                                  UNTIL IncomeTaxMaster.NEXT=0;

                                  LumpSumPAYE := MP2 - MP7;
                                END;


                                IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B1) + (PAYRUN."Tax on C2" - PAYRUN."Tax on C1")) < 0 THEN BEGIN
                                  PAYETAX := 0;
                                END;

                                IF ((((MP2/PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B1) + (PAYRUN."Tax on C2" - PAYRUN."Tax on C1")) > 0 THEN BEGIN
                                  PAYETAX := ROUND(((((MP2 / PAYRUN.F) * (PAYRUN.G)) - PAYRUN.B1) + (PAYRUN."Tax on C2" - PAYRUN."Tax on C1")), 0.01, '=');
                                END;

                                PAYRUN.Amount := ROUND((PAYETAX * -1), 0.01, '=');
                                PAYRUN.TotalPAYEPaid := PAYETAX;
                                PAYRUN."Other PAYE" := ROUND(MREDUND, 0.01, '=') + ROUND((LumpSumPAYE / PAYRUN.F), 0.01, '=') + ROUND(MENDORSED, 0.01, '=');
                                PAYRUN.Units := PAYETAX;
                                PAYRUN.Rate := -1;
                                PAYRUN.MODIFY;
                              END;
                            UNTIL PAYRUN.NEXT=0;
                            //PAYE CALCULATION ENDS

                            //O.5 Adjustment
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                            PAYRUN.SETRANGE("Special Pay No.", SpecialPayRunNo);
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            PAYRUN.SETRANGE("Is PAYE Field", TRUE);
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              PAYRUN.CALCFIELDS("Total Standard Deduction");
                              IF PAYRUN."Total Standard Deduction" > PAYRUN."Half of Gross Pay" THEN BEGIN
                                Adjustment := ROUND((PAYRUN."Total Standard Deduction" - PAYRUN."Half of Gross Pay"), 0.01, '=');
                                //PAYE GREATER
                                IF PAYRUN.TotalPAYEPaid > Adjustment THEN BEGIN
                                  PAYRUNPAYEADJ.INIT;
                                  PAYRUNPAYEADJ.RESET;
                                  PAYRUNPAYEADJ.SETRANGE("Branch Code", PAYRUN."Branch Code");
                                  PAYRUNPAYEADJ.SETRANGE("Shift Code", PAYRUN."Shift Code");
                                  PAYRUNPAYEADJ.SETRANGE("Calendar Code", PAYRUN."Calendar Code");
                                  PAYRUNPAYEADJ.SETRANGE("Statistics Group", PAYRUN."Statistics Group");
                                  PAYRUNPAYEADJ.SETRANGE("Pay Run No.", PAYRUN."Pay Run No.");
                                  PAYRUNPAYEADJ.SETRANGE("Special Pay No.", PAYRUN."Special Pay No.");
                                  PAYRUNPAYEADJ.SETRANGE("Employee No.", PAYRUN."Employee No.");
                                  PAYRUNPAYEADJ.SETRANGE("Is PAYE Field", TRUE);
                                  IF PAYRUNPAYEADJ.FINDFIRST() THEN BEGIN
                                    TempGRPAYEAmount := PAYRUNPAYEADJ.Amount;
                                    PAYRUNPAYEADJ."PAYE Adjusted" := TRUE;
                                    PAYRUNPAYEADJ.Amount := (ABS(TempGRPAYEAmount) - ABS(Adjustment)) * -1;
                                    PAYRUNPAYEADJ.TotalPAYEPaid := ABS(TempGRPAYEAmount) - ABS(Adjustment) ;
                                    PAYRUNPAYEADJ.Units := ABS(TempGRPAYEAmount) - ABS(Adjustment);
                                    PAYRUNPAYEADJ.Rate := -1;
                                    PAYRUNPAYEADJ.MODIFY;
                                  END;
                                END;
                                //PAYE LESSER
                                IF PAYRUN.TotalPAYEPaid < Adjustment THEN BEGIN
                                  PAYRUNPAYEADJ.INIT;
                                  PAYRUNPAYEADJ.RESET;
                                  PAYRUNPAYEADJ.SETRANGE("Branch Code", PAYRUN."Branch Code");
                                  PAYRUNPAYEADJ.SETRANGE("Shift Code", PAYRUN."Shift Code");
                                  PAYRUNPAYEADJ.SETRANGE("Calendar Code", PAYRUN."Calendar Code");
                                  PAYRUNPAYEADJ.SETRANGE("Statistics Group", PAYRUN."Statistics Group");
                                  PAYRUNPAYEADJ.SETRANGE("Pay Run No.", PAYRUN."Pay Run No.");
                                  PAYRUNPAYEADJ.SETRANGE("Special Pay No.", PAYRUN."Special Pay No.");
                                  PAYRUNPAYEADJ.SETRANGE("Employee No.", PAYRUN."Employee No.");
                                  PAYRUNPAYEADJ.SETRANGE("Is PAYE Field", TRUE);
                                  IF PAYRUNPAYEADJ.FINDFIRST() THEN BEGIN
                                    TempLSPAYEAmount :=  ABS(PAYRUN.Amount);
                                    Adjustment := Adjustment - ABS(TempLSPAYEAmount);
                                    PAYRUNPAYEADJ.Amount := (ABS(PAYRUNPAYEADJ.Amount) - ABS(TempLSPAYEAmount));
                                    PAYRUNPAYEADJ."PAYE Adjusted" := TRUE;
                                    PAYRUNPAYEADJ.TotalPAYEPaid := 0;
                                    PAYRUNPAYEADJ.Units := 0;
                                    PAYRUNPAYEADJ.Rate := -1;
                                    PAYRUNPAYEADJ.MODIFY;
                                  END;
                                END;
                              END;
                            UNTIL PAYRUN.NEXT=0;
                            //PAYROLL ENGINE ENDS
                          UNTIL Employee.NEXT = 0;
                        END;


                        "Process Payroll" := TRUE;
                        MODIFY;
                        MESSAGE('Payroll Process Completed');
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Process Bank Distribution")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF Release = TRUE THEN BEGIN
                          ERROR('Pay Run released, can not reprocess');
                        END;

                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                        PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                        IF PAYRUN.FINDFIRST() THEN BEGIN
                          Reprocess := TRUE;
                        END;
                        IF NOT PAYRUN.FINDFIRST() THEN BEGIN
                          Reprocess := FALSE;
                          ERROR('Payroll does not exist, please process');
                          EXIT;
                        END;

                        Employee.INIT;
                        Employee.RESET;
                        IF Employee.FINDFIRST() THEN REPEAT
                          Employee."Process Bank Distribution" := FALSE;
                          Employee.MODIFY;
                        UNTIL Employee.NEXT = 0;

                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE(Terminated, FALSE);
                        IF Employee.FINDFIRST() THEN REPEAT
                          PAYRUN.INIT;
                          PAYRUN.RESET;
                          PAYRUN.SETRANGE("Branch Code", "Branch Code");
                          PAYRUN.SETRANGE("Shift Code", "Shift Code");
                          PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                          PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                          PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                          PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                          PAYRUN.SETRANGE("Employee No.", Employee."No.");
                          IF PAYRUN.FINDFIRST() THEN BEGIN
                            Employee."Process Bank Distribution" := TRUE;
                            Employee.MODIFY;
                          END;
                        UNTIL Employee.NEXT = 0;


                        IF Release = FALSE THEN BEGIN
                          IF "Process Bank Distribution" = FALSE THEN BEGIN
                            BankPayDistribution.INIT;
                            BankPayDistribution.RESET;
                            BankPayDistribution.SETRANGE("Branch Code","Branch Code");
                            BankPayDistribution.SETRANGE("Shift Code","Shift Code");
                            BankPayDistribution.SETRANGE("Calendar Code","Calendar Code");
                            BankPayDistribution.SETRANGE("Statistics Group","Statistics Group");
                            BankPayDistribution.SETRANGE("Pay Run No.","Pay Run No.");
                            BankPayDistribution.SETRANGE("Special Pay No.","Special Pay No.");
                            IF BankPayDistribution.FINDFIRST() THEN BEGIN
                              BankPayDistribution.DELETEALL;
                              COMMIT;
                            END;
                          END;
                          IF "Process Bank Distribution" = TRUE THEN BEGIN
                            BankPayDistribution.INIT;
                            BankPayDistribution.RESET;
                            BankPayDistribution.SETRANGE("Branch Code","Branch Code");
                            BankPayDistribution.SETRANGE("Shift Code","Shift Code");
                            BankPayDistribution.SETRANGE("Calendar Code","Calendar Code");
                            BankPayDistribution.SETRANGE("Statistics Group","Statistics Group");
                            BankPayDistribution.SETRANGE("Pay Run No.","Pay Run No.");
                            BankPayDistribution.SETRANGE("Special Pay No.","Special Pay No.");
                            Reprocess := CONFIRM('WARNING!! Reprocessing a Bank Pay Distribution will delete the existing one',TRUE);
                            IF Reprocess = TRUE THEN BEGIN
                              BankPayDistribution.DELETEALL;
                              COMMIT;
                              "Process Bank Distribution" := FALSE;
                              MODIFY;
                            END;
                            IF Reprocess = FALSE THEN BEGIN
                              MESSAGE('Reprocessing aborted');
                              "Process Bank Distribution" := TRUE;
                              MODIFY;
                              EXIT;
                            END;
                          END;
                        END;

                        IF Reprocess = TRUE THEN BEGIN
                          Employee.INIT;
                          Employee.RESET;
                          Employee.SETRANGE("Process Bank Distribution", TRUE);
                          IF Employee.FINDFIRST() THEN REPEAT
                            BankPayDistribution.INIT;
                            BankPayDistribution.RESET;
                            BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                            BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                            BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                            BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                            BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                            BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                            BankPayDistribution.SETRANGE("Employee No.", Employee."No.");
                            IF NOT BankPayDistribution.FINDFIRST() THEN BEGIN
                              MultipleBankDistribution.INIT;
                              MultipleBankDistribution.RESET;
                              MultipleBankDistribution.SETRANGE("Branch Code", "Branch Code");
                              MultipleBankDistribution.SETRANGE("Shift Code", "Shift Code");
                              MultipleBankDistribution.SETRANGE("Calendar Code", "Calendar Code");
                              MultipleBankDistribution.SETRANGE("Statistics Group", "Statistics Group");
                              MultipleBankDistribution.SETRANGE("Employee No.", Employee."No.");
                              MultipleBankDistribution.SETRANGE(Active, TRUE);
                              IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                                BankPayDistribution."Employee No." := MultipleBankDistribution."Employee No.";
                                IF EmployeeMaster.GET(BankPayDistribution."Employee No.") THEN BEGIN
                                  BankPayDistribution."Employee Name" :=  EmployeeMaster."First Name" + ' ' + EmployeeMaster."Last Name";
                                END;
                                BankPayDistribution."Employee Bank Account No." := MultipleBankDistribution."Employee Bank Account No.";
                                BankPayDistribution.Sequence := MultipleBankDistribution.Sequence;
                                BankPayDistribution."Bank Code" := MultipleBankDistribution."Bank Code";
                                BankPayDistribution."Branch Code" := MultipleBankDistribution."Branch Code";
                                BankPayDistribution."Shift Code" := MultipleBankDistribution."Shift Code";
                                BankPayDistribution."Calendar Code" := MultipleBankDistribution."Calendar Code";
                                BankPayDistribution."Statistics Group" := MultipleBankDistribution."Statistics Group";
                                BankPayDistribution."Is Balance" := MultipleBankDistribution."Is Balance";
                                BankPayDistribution."Bank Name" := MultipleBankDistribution."Bank Name";
                                BankPayDistribution."Bank Account No." := MultipleBankDistribution."Bank Account No.";
                                BankPayDistribution."Is Direct" := MultipleBankDistribution."Is Direct";
                                BankPayDistribution."Pay Run No." := "Pay Run No.";
                                BankPayDistribution."Special Pay No." := "Special Pay No.";
                                BankPayDistribution.INSERT;
                              UNTIL MultipleBankDistribution.NEXT = 0;
                            END;

                            IF BankPayDistribution.FINDFIRST() THEN BEGIN
                              MultipleBankDistribution.INIT;
                              MultipleBankDistribution.RESET;
                              MultipleBankDistribution.SETRANGE("Branch Code", "Branch Code");
                              MultipleBankDistribution.SETRANGE("Shift Code", "Shift Code");
                              MultipleBankDistribution.SETRANGE("Calendar Code", "Calendar Code");
                              MultipleBankDistribution.SETRANGE("Statistics Group", "Statistics Group");
                              MultipleBankDistribution.SETRANGE("Employee No.", Employee."No.");
                              MultipleBankDistribution.SETRANGE(Active, TRUE);
                              IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                                BankPayDistribution.INIT;
                                BankPayDistribution.RESET;
                                BankPayDistribution.SETRANGE("Employee No.", MultipleBankDistribution."Employee No.");
                                BankPayDistribution.SETRANGE("Employee Bank Account No.", MultipleBankDistribution."Employee Bank Account No.");
                                BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                                BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                                BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                                BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                                BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                                BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                                IF NOT BankPayDistribution.FINDFIRST() THEN BEGIN
                                  BankPayDistribution."Employee No." := MultipleBankDistribution."Employee No.";
                                  IF EmployeeMaster.GET(BankPayDistribution."Employee No.") THEN BEGIN
                                    BankPayDistribution."Employee Name" :=  EmployeeMaster."First Name" + ' ' + EmployeeMaster."Last Name";
                                  END;
                                  BankPayDistribution."Employee Bank Account No." := MultipleBankDistribution."Employee Bank Account No.";
                                  BankPayDistribution.Sequence := MultipleBankDistribution.Sequence;
                                  BankPayDistribution."Bank Code" := MultipleBankDistribution."Bank Code";
                                  BankPayDistribution."Branch Code" := MultipleBankDistribution."Branch Code";
                                  BankPayDistribution."Shift Code" := MultipleBankDistribution."Shift Code";
                                  BankPayDistribution."Calendar Code" := MultipleBankDistribution."Calendar Code";
                                  BankPayDistribution."Statistics Group" := MultipleBankDistribution."Statistics Group";
                                  BankPayDistribution."Is Balance" := MultipleBankDistribution."Is Balance";
                                  BankPayDistribution."Bank Name" := MultipleBankDistribution."Bank Name";
                                  BankPayDistribution."Bank Account No." := MultipleBankDistribution."Bank Account No.";
                                  BankPayDistribution."Is Direct" := MultipleBankDistribution."Is Direct";
                                  BankPayDistribution."Pay Run No." := "Pay Run No.";
                                  BankPayDistribution."Special Pay No." := "Special Pay No.";
                                  BankPayDistribution.INSERT;
                                END;
                                IF BankPayDistribution.FINDFIRST() THEN BEGIN
                                  BankPayDistribution."Employee Bank Account No." := MultipleBankDistribution."Employee Bank Account No.";
                                  BankPayDistribution.Sequence := MultipleBankDistribution.Sequence;
                                  IF EmployeeMaster.GET(BankPayDistribution."Employee No.") THEN BEGIN
                                    BankPayDistribution."Employee Name" := EmployeeMaster."First Name" + ' ' + EmployeeMaster."Last Name";
                                  END;
                                  BankPayDistribution."Is Balance" := MultipleBankDistribution."Is Balance";
                                  BankPayDistribution."Bank Name" := MultipleBankDistribution."Bank Name";
                                  BankPayDistribution."Bank Account No." := MultipleBankDistribution."Bank Account No.";
                                  BankPayDistribution."Is Direct" := MultipleBankDistribution."Is Direct";
                                  BankPayDistribution.MODIFY;
                                END;
                              UNTIL MultipleBankDistribution.NEXT = 0;
                            END;
                          UNTIL Employee.NEXT = 0;

                          Employee.INIT;
                          Employee.RESET;
                          Employee.SETRANGE("Process Bank Distribution", TRUE);
                          IF Employee.FINDFIRST() THEN REPEAT
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                            PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                            PAYRUN.SETRANGE("Employee No.", Employee."No.");
                            IF PAYRUN.FINDFIRST() THEN BEGIN
                              PAYRUN.CALCFIELDS("Net Pay");
                              BankPayDistribution.INIT;
                              BankPayDistribution.RESET;
                              BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                              BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                              BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                              BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                              BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                              BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                              BankPayDistribution.SETRANGE("Employee No.", PAYRUN."Employee No.");
                              IF BankPayDistribution.FINDFIRST() THEN REPEAT
                                BankPayDistribution."Net Pay" := PAYRUN."Net Pay";
                                BankPayDistribution."Pay Date" := PAYRUN."Pay To Date";
                                BankPayDistribution."Sub Branch Code" := PAYRUN."Sub Branch Code";
                                BankPayDistribution."Payroll Reference" := PAYRUN."Payroll Reference";
                                BankPayDistribution."Net Pay" := PAYRUN."Net Pay";
                                BankPayDistribution.MODIFY;
                              UNTIL BankPayDistribution.NEXT = 0;
                            END;
                          UNTIL Employee.NEXT = 0;

                          BankPayDistribution.INIT;
                          BankPayDistribution.RESET;
                          BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                          BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                          BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                          BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                          BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                          BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF BankPayDistribution.FINDFIRST() THEN REPEAT
                            MultipleBankDistribution.INIT;
                            MultipleBankDistribution.RESET;
                            MultipleBankDistribution.SETRANGE("Employee No.", BankPayDistribution."Employee No.");
                            MultipleBankDistribution.SETRANGE("Employee Bank Account No.", BankPayDistribution."Employee Bank Account No.");
                            MultipleBankDistribution.SETRANGE("Is Direct", FALSE);
                            MultipleBankDistribution.SETRANGE("Is Balance", FALSE);
                            MultipleBankDistribution.SETRANGE(Active, TRUE);
                            IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                              IF MultipleBankDistribution."Distribution Percentage" = 0 THEN BEGIN
                                IF MultipleBankDistribution."Distribution Amount" = 0 THEN BEGIN
                                  ERROR('Distribution Percentage/Amount not defined for %1, %2', BankPayDistribution."Employee No.", BankPayDistribution."Employee Bank Account No.");
                                END;
                              END;
                              IF MultipleBankDistribution."Distribution Percentage" <> 0 THEN BEGIN
                                IF MultipleBankDistribution."Distribution Amount" = 0 THEN BEGIN
                                  BankPayDistribution."Pay Run Amount" := BankPayDistribution."Net Pay" * ((MultipleBankDistribution."Distribution Percentage")/100);
                                  BankPayDistribution.Amount := BankPayDistribution.Amount + BankPayDistribution."Net Pay" * ((MultipleBankDistribution."Distribution Percentage")/100);
                                  BankPayDistribution.MODIFY;
                                END;
                              END;
                              IF MultipleBankDistribution."Distribution Percentage" = 0 THEN BEGIN
                                IF MultipleBankDistribution."Distribution Amount" <> 0 THEN BEGIN
                                  BankPayDistribution."Pay Run Amount" := MultipleBankDistribution."Distribution Amount";
                                  BankPayDistribution.Amount := BankPayDistribution.Amount + MultipleBankDistribution."Distribution Amount";
                                  BankPayDistribution.MODIFY;
                                END;
                              END;
                            UNTIL MultipleBankDistribution.NEXT = 0;
                          UNTIL BankPayDistribution.NEXT = 0;

                          BankPayDistribution.INIT;
                          BankPayDistribution.RESET;
                          BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                          BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                          BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                          BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                          BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                          BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF BankPayDistribution.FINDFIRST() THEN REPEAT
                            MultipleBankDistribution.INIT;
                            MultipleBankDistribution.RESET;
                            MultipleBankDistribution.SETRANGE("Employee No.", BankPayDistribution."Employee No.");
                            MultipleBankDistribution.SETRANGE("Employee Bank Account No.", BankPayDistribution."Employee Bank Account No.");
                            MultipleBankDistribution.SETRANGE("Is Direct", FALSE);
                            MultipleBankDistribution.SETRANGE("Is Balance", TRUE);
                            MultipleBankDistribution.SETRANGE(Active, TRUE);
                            IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                              IF MultipleBankDistribution."Distribution Percentage" = 0 THEN BEGIN
                                IF MultipleBankDistribution."Distribution Amount" = 0 THEN BEGIN
                                  BankPayDistribution.CALCFIELDS(Amount);
                                  BankPayDistribution."Pay Run Amount" := BankPayDistribution."Net Pay" - BankPayDistribution.Amount;
                                  BankPayDistribution.MODIFY;
                                END;
                              END;
                            UNTIL MultipleBankDistribution.NEXT = 0;
                          UNTIL BankPayDistribution.NEXT = 0;

                          BankPayDistribution.INIT;
                          BankPayDistribution.RESET;
                          BankPayDistribution.SETRANGE("Branch Code", "Branch Code");
                          BankPayDistribution.SETRANGE("Shift Code", "Shift Code");
                          BankPayDistribution.SETRANGE("Calendar Code", "Calendar Code");
                          BankPayDistribution.SETRANGE("Statistics Group", "Statistics Group");
                          BankPayDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                          BankPayDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                          IF BankPayDistribution.FINDFIRST() THEN REPEAT
                            MultipleBankDistribution.INIT;
                            MultipleBankDistribution.RESET;
                            MultipleBankDistribution.SETRANGE("Employee No.", BankPayDistribution."Employee No.");
                            MultipleBankDistribution.SETRANGE("Employee Bank Account No.", BankPayDistribution."Employee Bank Account No.");
                            MultipleBankDistribution.SETRANGE("Is Direct", TRUE);
                            MultipleBankDistribution.SETRANGE("Is Balance", FALSE);
                            MultipleBankDistribution.SETRANGE(Active, TRUE);
                            IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                              IF MultipleBankDistribution."Distribution Percentage" = 0 THEN BEGIN
                                IF MultipleBankDistribution."Distribution Amount" = 0 THEN BEGIN
                                  BankPayDistribution.CALCFIELDS(Amount);
                                  BankPayDistribution."Pay Run Amount" := BankPayDistribution."Net Pay" - BankPayDistribution.Amount;
                                  BankPayDistribution.MODIFY;
                                END;
                              END;
                            UNTIL MultipleBankDistribution.NEXT = 0;
                          UNTIL BankPayDistribution.NEXT = 0;

                          "Process Bank Distribution" := TRUE;
                          MODIFY;
                          MESSAGE('Bank Schedule Created');

                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Sent to General Ledger")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF Release = TRUE THEN BEGIN
                          ERROR('Pay Run released, can not reprocess');
                        END;

                        HRSETUP.GET();
                        GLSETUP.GET();
                        GD1 := FALSE;
                        GD2 := FALSE;

                        GLDimension.INIT;
                        GLDimension.RESET;
                        GLDimension.DELETEALL;
                        COMMIT;

                        IF HRSETUP."Payroll Bank Account" = '' THEN BEGIN
                          ERROR('Payroll Bank Account not defined in Human Resources Setup');
                        END;

                        //ASHNEIL CHANDRA  18072017
                        IF HRSETUP."Employer FNPF Account No." = '' THEN BEGIN
                          ERROR('Employer FNPF Account No. not defined in Human Resources Setup');
                        END;
                        IF HRSETUP."Employer FNPF Bal. Account No." = '' THEN BEGIN
                          ERROR('Employer FNPF Bal. Account No. not defined in Human Resources Setup');
                        END;
                        //ASHNEIL CHANDRA  18072017

                        IF HRSETUP."By-Pass Payroll Account Use" = TRUE THEN BEGIN    //ASHNEIL CHANDRA   18072017
                          ByPassAccount := TRUE;
                          IF HRSETUP."Payroll Clearing Account No." = '' THEN BEGIN
                            ERROR('Payroll Clearing Account No. not defined in Human Resources Setup');
                          END;
                        END;                                                          //ASHNEIL CHANDRA   18072017

                        IF HRSETUP."By-Pass Payroll Account Use" = FALSE THEN BEGIN
                          ByPassAccount := FALSE;
                          IF HRSETUP."Account No." = '' THEN BEGIN
                            ERROR('Payroll Account No. not defined in Human Resources Setup');
                          END;
                          IF HRSETUP."Bal. Account No." = '' THEN BEGIN
                            ERROR('Payroll Bal. Account No. not defined in Human Resources Setup');
                          END;
                        END;

                        IF HRSETUP."GL Integration Dimension" <> '' THEN BEGIN
                          IF GLSETUP."Global Dimension 1 Code" = HRSETUP."GL Integration Dimension" THEN BEGIN
                            GD1 := TRUE;
                            GD2 := FALSE;   //ASHNEIL CHANDRA   18072017
                          END;
                          IF GLSETUP."Global Dimension 2 Code" = HRSETUP."GL Integration Dimension" THEN BEGIN
                            GD2 := TRUE;
                            GD1 := FALSE;   //ASHNEIL CHANDRA   18072017
                          END
                        END;

                        MyFNPF := HRSETUP.FNPF;
                        TotalDeduction := 0;
                        TotalClearing := 0;
                        PaymentDate := 0D;
                        PaymentReference := '';
                        TempPayRunNo := '';
                        TempSpecialPayNo := '';
                        TempBranch := '';
                        TempStats := '';
                        TempShiftCode := 1;
                        TempCalendar := '';
                        "TempDocNo." := '';

                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                        PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                        IF PAYRUN.FINDFIRST() THEN BEGIN
                          Reprocess := TRUE;
                        END;
                        IF NOT PAYRUN.FINDFIRST() THEN BEGIN
                          Reprocess := FALSE;
                          ERROR('Payroll does not exist, please process');
                          EXIT;
                        END;

                        IF Release = FALSE THEN BEGIN
                          IF "Process GL Integration" = FALSE THEN BEGIN
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            IF GenJnlLine.FINDFIRST() THEN BEGIN
                              GenJnlLine.DELETEALL;
                              COMMIT;
                            END;
                          END;

                          IF "Process GL Integration" = TRUE THEN BEGIN
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            Reprocess := CONFIRM('WARNING!! Reprocessing a GL Integration may result in duplicated entries being posted',TRUE);
                            IF Reprocess = TRUE THEN BEGIN
                              GenJnlLine.DELETEALL;
                              COMMIT;
                              "Process GL Integration" := FALSE;
                              MODIFY;
                            END;
                            IF Reprocess = FALSE THEN BEGIN
                              MESSAGE('Reprocessing aborted');
                              "Process GL Integration" := TRUE;
                              MODIFY;
                              EXIT;
                            END;
                          END;
                        END;


                        IF Reprocess = TRUE THEN BEGIN
                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            BranchPolicyElements."GL Amount" := 0;
                            BranchPolicyElements.MODIFY;
                          UNTIL BranchPolicyElements.NEXT = 0;


                          HRSETUP.GET();
                          IF HRSETUP."Payroll Journal Template" = '' THEN BEGIN
                            ERROR('Payroll Journal Template not setup in Human Resources Setup');
                          END;
                          IF HRSETUP."Payroll Journal Batch" = '' THEN BEGIN
                            ERROR('Payroll Journal Batch not setup in Human Resources Setup');
                          END;
                          IF HRSETUP."Payroll Journal Doc. No." = '' THEN BEGIN
                            ERROR('Payroll Journal Document No. not setup in Human Resources Setup');
                          END;
                          IF HRSETUP."Normal Hours" <> '' THEN BEGIN
                            TempNormalHours := HRSETUP."Normal Hours";
                          END;

                          BranchPolicyElements.INIT;       //ALL ELEMENTS IGNORING FNPF
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                            PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                            PAYRUN.SETRANGE("Pay Code", BranchPolicyElements."Pay Code");
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              BranchPolicyElements."GL Amount" := BranchPolicyElements."GL Amount" + ROUND(PAYRUN.Amount, 0.01, '=');
                              BranchPolicyElements."Employee Additional FNPF" := 0;   //FNPF 0
                              BranchPolicyElements."Employer Additional FNPF" := 0;   //FNPF 0
                              BranchPolicyElements."Employer 10 Percent" := 0;        //FNPF 0
                              PaymentDate := PAYRUN."Pay To Date";
                              PaymentReference := PAYRUN."Payroll Reference";
                              TempPayRunNo := PAYRUN."Pay Run No.";
                              TempSpecialPayNo := PAYRUN."Special Pay No.";
                              TempBranch := PAYRUN."Branch Code";
                              TempStats := PAYRUN."Statistics Group";
                              TempShiftCode := PAYRUN."Shift Code";
                              TempCalendar := PAYRUN."Calendar Code";
                              BranchPolicyElements.MODIFY;
                            UNTIL PAYRUN.NEXT = 0;
                          UNTIL BranchPolicyElements.NEXT = 0;

                          IF GD1 = TRUE THEN BEGIN
                            BranchPolicyElements.INIT;       //ALL ELEMENTS IGNORING FNPF DIMENSION BREAK DOWN FOR GLOBAL DIMENSION 1 CODE
                            BranchPolicyElements.RESET;
                            BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                            BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                            BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                            BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                            BranchPolicyElements.SETRANGE("Dimension Breakup", TRUE);
                            IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                              DimensionValue.INIT;
                              DimensionValue.RESET;
                              DimensionValue.SETRANGE("Dimension Code", HRSETUP."GL Integration Dimension");
                              IF DimensionValue.FINDFIRST() THEN REPEAT
                                PAYRUN.INIT;
                                PAYRUN.RESET;
                                PAYRUN.SETRANGE("Branch Code", "Branch Code");
                                PAYRUN.SETRANGE("Shift Code", "Shift Code");
                                PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                                PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                                PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                                PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                                PAYRUN.SETRANGE("Pay Code", BranchPolicyElements."Pay Code");
                                PAYRUN.SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                                IF PAYRUN.FINDFIRST() THEN REPEAT
                                  GLDimension.INIT;
                                  GLDimension.RESET;
                                  GLDimension.SETRANGE("Pay Code", PAYRUN."Pay Code");
                                  GLDimension.SETRANGE("Dimension Value", PAYRUN."Global Dimension 1 Code");
                                  IF NOT GLDimension.FINDFIRST() THEN BEGIN
                                    GLDimension."Pay Code" := BranchPolicyElements."Pay Code";
                                    GLDimension."Dimension Value" := DimensionValue.Code;
                                    GLDimension.INSERT;
                                  END;
                                  IF GLDimension.FINDFIRST() THEN BEGIN
                                    GLDimension.Amount := GLDimension.Amount + ROUND(PAYRUN.Amount, 0.01, '=');
                                    GLDimension.MODIFY;
                                  END;
                                UNTIL PAYRUN.NEXT = 0;
                              UNTIL DimensionValue.NEXT = 0;
                            UNTIL BranchPolicyElements.NEXT = 0;
                          END;

                          IF GD2 = TRUE THEN BEGIN
                            BranchPolicyElements.INIT;       //ALL ELEMENTS IGNORING FNPF DIMENSION BREAK DOWN FOR GLOBAL DIMENSION 2 CODE
                            BranchPolicyElements.RESET;
                            BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                            BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                            BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                            BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                            BranchPolicyElements.SETRANGE("Dimension Breakup", TRUE);
                            IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                              DimensionValue.INIT;
                              DimensionValue.RESET;
                              DimensionValue.SETRANGE("Dimension Code", HRSETUP."GL Integration Dimension");
                              IF DimensionValue.FINDFIRST() THEN REPEAT
                                PAYRUN.INIT;
                                PAYRUN.RESET;
                                PAYRUN.SETRANGE("Branch Code", "Branch Code");
                                PAYRUN.SETRANGE("Shift Code", "Shift Code");
                                PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                                PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                                PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                                PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                                PAYRUN.SETRANGE("Pay Code", BranchPolicyElements."Pay Code");
                                PAYRUN.SETRANGE("Global Dimension 2 Code", DimensionValue.Code);
                                IF PAYRUN.FINDFIRST() THEN REPEAT
                                  GLDimension.INIT;
                                  GLDimension.RESET;
                                  GLDimension.SETRANGE("Pay Code", PAYRUN."Pay Code");
                                  GLDimension.SETRANGE("Dimension Value", PAYRUN."Global Dimension 2 Code");
                                  IF NOT GLDimension.FINDFIRST() THEN BEGIN
                                    GLDimension."Pay Code" := BranchPolicyElements."Pay Code";
                                    GLDimension."Dimension Value" := DimensionValue.Code;
                                    GLDimension.INSERT;
                                  END;
                                  IF GLDimension.FINDFIRST() THEN BEGIN
                                    GLDimension.Amount := GLDimension.Amount + ROUND(PAYRUN.Amount, 0.01, '=');
                                    GLDimension.MODIFY;
                                  END;
                                UNTIL PAYRUN.NEXT = 0;
                              UNTIL DimensionValue.NEXT = 0;
                            UNTIL BranchPolicyElements.NEXT = 0;
                          END;

                          BranchPolicyElements.INIT;      //FNPF ELEMENTS IGNORING OTHERS
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Is FNPF Field", TRUE);
                          IF BranchPolicyElements.FINDFIRST() THEN BEGIN
                            PAYRUN.INIT;
                            PAYRUN.RESET;
                            PAYRUN.SETRANGE("Branch Code", "Branch Code");
                            PAYRUN.SETRANGE("Shift Code", "Shift Code");
                            PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                            PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                            PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                            PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                            PAYRUN.SETRANGE("Pay Code", BranchPolicyElements."Pay Code");
                            IF PAYRUN.FINDFIRST() THEN REPEAT
                              BranchPolicyElements."Employee Additional FNPF" := BranchPolicyElements."Employee Additional FNPF" + ROUND(PAYRUN."Employee FNPF Additional", 0.01, '=');
                              BranchPolicyElements."Employer Additional FNPF" := BranchPolicyElements."Employer Additional FNPF" + ROUND(PAYRUN."Employer FNPF Additional", 0.01, '=');
                              BranchPolicyElements."Employer 10 Percent" := BranchPolicyElements."Employer 10 Percent" + ROUND(PAYRUN."Employer 10 Percent", 0.01, '=');
                              PaymentDate := PAYRUN."Pay To Date";
                              PaymentReference := PAYRUN."Payroll Reference";
                              TempPayRunNo := PAYRUN."Pay Run No.";
                              TempSpecialPayNo := PAYRUN."Special Pay No.";
                              TempBranch := PAYRUN."Branch Code";
                              TempStats := PAYRUN."Statistics Group";
                              TempShiftCode := PAYRUN."Shift Code";
                              TempCalendar := PAYRUN."Calendar Code";
                              BranchPolicyElements.MODIFY;
                            UNTIL PAYRUN.NEXT = 0;
                          END;

                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Pay Type", 0);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            TotalClearing := TotalClearing + BranchPolicyElements."GL Amount";
                          UNTIL BranchPolicyElements.NEXT = 0;

                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Pay Type", 1);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            TotalDeduction := TotalDeduction + BranchPolicyElements."GL Amount";
                          UNTIL BranchPolicyElements.NEXT = 0;

                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Post to GL", TRUE);
                          BranchPolicyElements.SETFILTER("GL Amount", NOTEQUAL2ZERO);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            IF BranchPolicyElements."GL Debit Code" = '' THEN BEGIN
                              ERROR('GL Debit Code not setup for Pay Code %1', BranchPolicyElements."Pay Code");
                            END;
                            IF BranchPolicyElements."GL Credit Code" = '' THEN BEGIN
                              ERROR('GL Credit Code not setup for Pay Code %1', BranchPolicyElements."Pay Code");
                            END;
                          UNTIL BranchPolicyElements.NEXT = 0;

                          LineNo := 1000;


                          IF NoSeries.GET(HRSETUP."Payroll Journal Doc. No.") THEN BEGIN
                            NoSeriesLine.INIT;
                            NoSeriesLine.RESET;
                            NoSeriesLine.SETRANGE("Series Code", NoSeries.Code);
                            IF NoSeriesLine.FINDLAST() THEN BEGIN
                              "TempDocNo." := NoSeriesLine."Last No. Used";
                              "TempDocNo." := INCSTR("TempDocNo.");
                            END;
                          END;

                          BranchPolicyElements.INIT;       //Removing GL Dimension Break Down Amount from GL Amount
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Dimension Breakup", TRUE);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            GLDimension.INIT;
                            GLDimension.RESET;
                            GLDimension.SETRANGE("Pay Code", BranchPolicyElements."Pay Code");
                            IF GLDimension.FINDFIRST() THEN REPEAT
                              BranchPolicyElements."GL Amount" := BranchPolicyElements."GL Amount" - GLDimension.Amount;
                              BranchPolicyElements.MODIFY;
                            UNTIL GLDimension.NEXT = 0;
                          UNTIL BranchPolicyElements.NEXT = 0;

                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Post to GL", TRUE);
                          BranchPolicyElements.SETFILTER("GL Amount", NOTEQUAL2ZERO);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            IF GenJnlLine.FINDFIRST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;
                              IF ByPassAccount = TRUE THEN BEGIN
                                GenJnlLine."Account Type" := BranchPolicyElements."GL DR Account Type";
                                GenJnlLine."Account No." := BranchPolicyElements."GL Debit Code";
                                GenJnlLine."Bal. Account Type" := BranchPolicyElements."GL CR Account Type";
                                GenJnlLine."Bal. Account No." := BranchPolicyElements."GL Credit Code";
                              END;
                              IF ByPassAccount = FALSE THEN BEGIN
                                GenJnlLine."Account Type" := HRSETUP."Account Type";
                                GenJnlLine."Account No." := HRSETUP."Account No.";
                                GenJnlLine."Bal. Account Type" := HRSETUP."Bal. Account Type";
                                GenJnlLine."Bal. Account No." := HRSETUP."Bal. Account No.";
                              END;
                              GenJnlLine.Description := COPYSTR(('PAYROLL ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo + ' ' + BranchPolicyElements."Pay Code"), 1, 50);
                              GenJnlLine.Comment := BranchPolicyElements."Pay Code";
                              GenJnlLine.Amount := ABS(BranchPolicyElements."GL Amount");
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;
                            IF NOT GenJnlLine.FINDFIRST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;
                              IF ByPassAccount = TRUE THEN BEGIN
                                GenJnlLine."Account Type" := BranchPolicyElements."GL DR Account Type";
                                GenJnlLine."Account No." := BranchPolicyElements."GL Debit Code";
                                GenJnlLine."Bal. Account Type" := BranchPolicyElements."GL CR Account Type";
                                GenJnlLine."Bal. Account No." := BranchPolicyElements."GL Credit Code";
                              END;
                              IF ByPassAccount = FALSE THEN BEGIN
                                GenJnlLine."Account Type" := HRSETUP."Account Type";
                                GenJnlLine."Account No." := HRSETUP."Account No.";
                                GenJnlLine."Bal. Account Type" := HRSETUP."Bal. Account Type";
                                GenJnlLine."Bal. Account No." := HRSETUP."Bal. Account No.";
                              END;
                              GenJnlLine.Description := COPYSTR(('PAYROLL ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo + ' ' + BranchPolicyElements."Pay Code"), 1, 50);
                              GenJnlLine.Comment := BranchPolicyElements."Pay Code";
                              GenJnlLine.Amount := ABS(BranchPolicyElements."GL Amount");
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;
                          UNTIL BranchPolicyElements.NEXT = 0;

                          GLDimension.INIT;
                          GLDimension.RESET;
                          IF GLDimension.FINDFIRST() THEN REPEAT
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            IF GenJnlLine.FINDFIRST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;
                              IF ByPassAccount = TRUE THEN BEGIN
                                BranchPolicyElements.INIT;
                                BranchPolicyElements.RESET;
                                BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                                BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                                BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                                BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                                BranchPolicyElements.SETRANGE("Pay Code", GLDimension."Pay Code");
                                IF BranchPolicyElements.FINDFIRST() THEN BEGIN
                                  GenJnlLine."Account Type" := BranchPolicyElements."GL DR Account Type";
                                  GenJnlLine."Account No." := BranchPolicyElements."GL Debit Code";
                                  GenJnlLine."Bal. Account Type" := BranchPolicyElements."GL CR Account Type";
                                  GenJnlLine."Bal. Account No." := BranchPolicyElements."GL Credit Code";
                                END;
                              END;
                              IF ByPassAccount = FALSE THEN BEGIN
                                GenJnlLine."Account Type" := HRSETUP."Account Type";
                                GenJnlLine."Account No." := HRSETUP."Account No.";
                                GenJnlLine."Bal. Account Type" := HRSETUP."Bal. Account Type";
                                GenJnlLine."Bal. Account No." := HRSETUP."Bal. Account No.";
                              END;
                              GenJnlLine.Description := COPYSTR(('PAYROLL ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo + ' ' + BranchPolicyElements."Pay Code"), 1, 50);
                              GenJnlLine.Comment :=  GLDimension."Pay Code" + '_' + GLDimension."Dimension Value";
                              GenJnlLine.Amount :=  ABS(GLDimension.Amount);
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;
                            IF NOT GenJnlLine.FINDFIRST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;
                              IF ByPassAccount = TRUE THEN BEGIN
                                BranchPolicyElements.INIT;
                                BranchPolicyElements.RESET;
                                BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                                BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                                BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                                BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                                BranchPolicyElements.SETRANGE("Pay Code", GLDimension."Pay Code");
                                IF BranchPolicyElements.FINDFIRST() THEN BEGIN
                                  GenJnlLine."Account Type" := BranchPolicyElements."GL DR Account Type";
                                  GenJnlLine."Account No." := BranchPolicyElements."GL Debit Code";
                                  GenJnlLine."Bal. Account Type" := BranchPolicyElements."GL CR Account Type";
                                  GenJnlLine."Bal. Account No." := BranchPolicyElements."GL Credit Code";
                                END;
                              END;
                              IF ByPassAccount = FALSE THEN BEGIN
                                GenJnlLine."Account Type" := HRSETUP."Account Type";
                                GenJnlLine."Account No." := HRSETUP."Account No.";
                                GenJnlLine."Bal. Account Type" := HRSETUP."Bal. Account Type";
                                GenJnlLine."Bal. Account No." := HRSETUP."Bal. Account No.";
                              END;
                              GenJnlLine.Description := COPYSTR(('PAYROLL ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo + ' ' + BranchPolicyElements."Pay Code"), 1, 50);
                              GenJnlLine.Comment :=  GLDimension."Pay Code" + '_' + GLDimension."Dimension Value";
                              GenJnlLine.Amount := ABS(GLDimension.Amount);
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;
                          UNTIL GLDimension.NEXT = 0;


                          BranchPolicyElements.INIT;  //EMPLOYER FNPF
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                          BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                          BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                          BranchPolicyElements.SETRANGE("Post to GL", TRUE);
                          BranchPolicyElements.SETFILTER("GL Amount", NOTEQUAL2ZERO);
                          BranchPolicyElements.SETRANGE("Is FNPF Field", TRUE);
                          IF BranchPolicyElements.FINDFIRST() THEN REPEAT
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            IF GenJnlLine.FINDLAST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo + 10;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;

                              //ASHNEIL CHANDRA  18072017
                              GenJnlLine."Account Type" := HRSETUP."Employer FNPF Account Type";
                              GenJnlLine."Account No." := HRSETUP."Employer FNPF Account No.";
                              GenJnlLine."Bal. Account Type" := HRSETUP."Employer FNPF Bal Account Type";
                              GenJnlLine."Bal. Account No." := HRSETUP."Employer FNPF Bal. Account No.";
                              //ASHNEIL CHANDRA  18072017

                              GenJnlLine.Description := COPYSTR(('PAYROLL ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo + ' ' + BranchPolicyElements."Pay Code"), 1,50);
                              GenJnlLine.Comment := BranchPolicyElements."Pay Code";
                              GenJnlLine.Amount := ABS(BranchPolicyElements."Employer Additional FNPF" + BranchPolicyElements."Employer 10 Percent");
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;
                          UNTIL BranchPolicyElements.NEXT = 0;


                        //Direct Credit and Payroll Clearing Account Insert
                            GenJnlLine.INIT;
                            GenJnlLine.RESET;
                            GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                            GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                            IF GenJnlLine.FINDLAST() THEN BEGIN
                              GenJnlLine."Journal Template Name" := HRSETUP."Payroll Journal Template";
                              GenJnlLine."Journal Batch Name" := HRSETUP."Payroll Journal Batch";
                              GenJnlLine."Line No." := LineNo + 10;
                              LineNo := LineNo + 10;
                              GenJnlLine."Document No." := "TempDocNo.";
                              GenJnlLine."Posting Date" := PaymentDate;
                              GenJnlLine."Document Type" := 0;
                              GenJnlLine."Account Type" := 0;     // G_LAcount
                              GenJnlLine."Account No." := HRSETUP."Payroll Clearing Account No.";
                              GenJnlLine.Amount := ABS(TotalClearing) - ABS(TotalDeduction);
                              GenJnlLine."Bal. Account Type" := 3;     // Bank Account
                              GenJnlLine."Bal. Account No." := HRSETUP."Payroll Bank Account";
                              GenJnlLine.Description := COPYSTR(('Direct Credit ' + TempBranch + '_' + FORMAT(TempShiftCode) + '_' + TempStats + '_' + TempCalendar + ' ' + TempPayRunNo + '/' + TempSpecialPayNo), 1, 50);
                              GenJnlLine.Comment := 'Direct Credit and Payroll Clearing Account Entry';
                              GenJnlLine."Gen. Posting Type" := 0;
                              GenJnlLine."Gen. Bus. Posting Group" := '';
                              GenJnlLine."Gen. Prod. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Posting Type" := 0;
                              GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
                              GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
                              GenJnlLine."VAT Bus. Posting Group" := '';
                              GenJnlLine."VAT Prod. Posting Group" := '';
                              GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                              GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                              GenJnlLine."Source Code" := 'GENJNL';
                              GenJnlLine.INSERT;
                            END;


                          MESSAGE('Journal Entries Created');
                          "Process GL Integration" := TRUE;
                          MODIFY;

                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Open Payroll Journal")
                {
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        HRSETUP.GET();

                        GenJnlLine.INIT;
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                        GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                        PAGE.RUN(39,GenJnlLine);
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        //ASHNEIL CHANDRA  13072017
        HRSETUP.GET();
        HRSETUP."Add to Timesheet" := FALSE;
        HRSETUP.MODIFY;
        //ASHNEIL CHANDRA  13072017
    end;

    var
        EmployeeTimesheet : Record "Employee Timesheet";
        BranchPolicies : Record "Branch Policy";
        Employee : Record "Employee Pay Details";
        EmployeeMaster : Record Employee;
        HRSETUP : Record "Human Resources Setup";
        EmployeePayTable : Record "Employee Pay Table";
        PayElementMaster : Record "Pay Element Master";
        QuickTimesheet : Record "Quick Timesheet";
        PAYRUN : Record "Pay Run";
        IncomeTaxMaster : Record "Income Tax Master";
        BankPayDistribution : Record "Bank Pay Distribution";
        PAYRUNPAYEADJ : Record "Pay Run";
        PAYRUNSRTADJ : Record "Pay Run";
        PAYRUNECALADJ : Record "Pay Run";
        NormalHours : Code[10];
        RateType : Decimal;
        Reprocess : Boolean;
        MyFNPF : Code[10];
        MyPAYE : Code[10];
        MySRT : Code[10];
        MyECAL : Code[10];
        TAXCountryCode : Code[10];
        RunsPerCalendar : Decimal;
        TaxRate : Decimal;
        PayRunNo : Code[10];
        SpecialPayRunNo : Code[10];
        TaxCodeTemp : Text[30];
        MP1 : Decimal;
        MP2 : Decimal;
        MP6 : Decimal;
        MP7 : Decimal;
        MFNPFBASE : Decimal;
        MPAYEBASE : Decimal;
        MSRTBASE : Decimal;
        MECALBASE : Decimal;
        MLUMPSUM : Decimal;
        MLUMPSUMEN : Decimal;
        MREDUNDANCY : Decimal;
        MENDORSED : Decimal;
        MREDUND : Decimal;
        MBONUS : Decimal;
        SRTTAX : Decimal;
        PAYETAX : Decimal;
        ECALTAX : Decimal;
        TLUMPSUM : Decimal;
        TotalEarnings : Decimal;
        MC2 : Decimal;
        LumpSumPAYE : Decimal;
        MultipleBankDistribution : Record "Multiple Bank Distribution";
        TempAmount : Decimal;
        TempPercentageAmount : Decimal;
        BalanceAmount : Decimal;
        GenJnlLine : Record "Gen. Journal Line";
        LineNo : Integer;
        NoSeriesLine : Record "No. Series Line";
        "TempDocNo." : Code[20];
        PaymentDate : Date;
        PaymentReference : Text[50];
        TempPayRunNo : Code[10];
        TempSpecialPayNo : Code[10];
        NoSeries : Record "No. Series";
        TempBranch : Code[20];
        TempStats : Code[20];
        TempShiftCode : Option First,Second,Third,Fourth,Fifth;
        TempCalendar : Code[10];
        TempNormalHours : Code[10];
        TotalDeduction : Decimal;
        GlobalFNPFPercent : Decimal;
        EmployeeAdditionalFNPF : Decimal;
        EmployerAdditionalFNPF : Decimal;
        TotalEarning : Decimal;
        Employee8Percent : Decimal;
        ByPassAccount : Boolean;
        BranchPolicyElements : Record "Branch Policy Elements";
        TotalClearing : Decimal;
        GLDimension : Record "GL Integration Per Dimension";
        DimensionValue : Record "Dimension Value";
        GLSETUP : Record "General Ledger Setup";
        GD1 : Boolean;
        GD2 : Boolean;
        NOTEQUAL2ZERO : Label '<>0';
        Adjustment : Decimal;
        TempGRPAYEAmount : Decimal;
        TempLSPAYEAmount : Decimal;
}

