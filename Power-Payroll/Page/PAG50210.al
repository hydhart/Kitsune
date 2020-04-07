page 50210 "Pay Run Scheduler"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Pay Run Scheduler";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Pay Run No.";"Pay Run No.")
                {
                    Editable = false;
                }
                field("Special Pay No.";"Special Pay No.")
                {
                    Editable = false;
                }
                field("Pay From Date";"Pay From Date")
                {
                    Editable = false;
                }
                field("Pay To Date";"Pay To Date")
                {
                    Editable = false;
                }
                field("Process Timesheet";"Process Timesheet")
                {
                    Editable = false;
                }
                field("Process Payroll";"Process Payroll")
                {
                    Editable = false;
                }
                field("Process Bank Distribution";"Process Bank Distribution")
                {
                    Editable = false;
                }
                field("Process GL Integration";"Process GL Integration")
                {
                    Editable = false;
                }
                field(Release;Release)
                {
                    Editable = false;
                }
            }
            group(Control1000000025)
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
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action("Normal Schedule")
                {
                    Promoted = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSETUP.GET();

                        RunsPerCalendar := HRSETUP."Runs Per Calendar";


                        IF FINDLAST THEN BEGIN
                          //ASHNEIL CHANDRA  18072017
                          IF HRSETUP."Enforce Schedule Release" = TRUE THEN BEGIN
                            IF Release = FALSE THEN BEGIN
                              ERROR('Last payrun not released');
                            END;
                          END;
                          //ASHNEIL CHANDRA  18072017

                          EVALUATE(NormalNo, "Pay Run No.");
                          NormalNo := NormalNo + 1;
                          IF STRLEN(FORMAT(NormalNo)) = 1 THEN BEGIN
                            TempPayRunNo := '0' + FORMAT(NormalNo);
                          END;
                          IF STRLEN(FORMAT(NormalNo)) = 2 THEN BEGIN
                            TempPayRunNo := FORMAT(NormalNo);
                          END;
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code", "Branch Code");
                        BranchCalendar.SETRANGE("Shift Code", "Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code", "Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group", "Statistics Group");
                        BranchCalendar.SETRANGE("Pay Run No.", TempPayRunNo);
                        IF BranchCalendar.FINDFIRST() THEN BEGIN
                          PayRunNo := FORMAT(BranchCalendar."Pay Run No.");
                          PayFrom := BranchCalendar."Pay From Date";
                          PayTo := BranchCalendar."Pay To Date";
                          TaxFrom := BranchCalendar."Tax Start Month";
                          TaxTo := BranchCalendar."Tax End Month";

                          IF NormalNo <= RunsPerCalendar THEN BEGIN
                            "Branch Code" := HRSETUP."Branch Code";
                            "Shift Code" := HRSETUP."Shift Code";
                            "Calendar Code" := HRSETUP."Calendar Code";
                            "Statistics Group" := HRSETUP."Statistics Group";
                            "Pay Run No." := PayRunNo;
                            "Special Pay No." := '00';
                            "Pay From Date" := PayFrom;
                            "Pay To Date" := PayTo;
                            "Month Start Date" := TaxFrom;
                            "Month End Date" := TaxTo;
                            "Payroll Reference" := '';
                            "Process GL Integration" := FALSE;
                            "Process Bank Distribution" := FALSE;
                            "Process Payroll" := FALSE;
                            "Process Timesheet" := FALSE;
                            Release := FALSE;
                            "Special Tag" := FALSE;
                            INSERT;
                          END;
                        END;

                        IF NormalNo > RunsPerCalendar THEN BEGIN
                          ERROR('Maximum Runs Per Calendar Reached');
                        END;

                        //ASHNEIL CHANDRA  21072017

                        //ASHNEIL CHANDRA   13072017
                    end;
                }
                action("Special Schedule")
                {
                    Promoted = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSETUP.GET();

                        IF FINDLAST THEN BEGIN
                          PayRunNo := "Pay Run No.";
                          SpecialPayRun := "Special Pay No.";
                          //ASHNEIL CHANDRA  18072017
                          IF HRSETUP."Enforce Schedule Release" = TRUE THEN BEGIN
                            IF Release = FALSE THEN BEGIN
                              ERROR('Last payrun not released');
                            END;
                          END;
                          //ASHNEIL CHANDRA  18072017
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code", "Branch Code");
                        BranchCalendar.SETRANGE("Shift Code", "Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code", "Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group", "Statistics Group");
                        BranchCalendar.SETRANGE("Pay Run No.", PayRunNo);
                        IF BranchCalendar.FINDFIRST() THEN BEGIN
                          PayRunNo := FORMAT(BranchCalendar."Pay Run No.");
                          PayFrom := BranchCalendar."Pay From Date";
                          PayTo := BranchCalendar."Pay To Date";
                          TaxFrom := BranchCalendar."Tax Start Month";
                          TaxTo := BranchCalendar."Tax End Month";
                        END;

                        SPNO := 0;
                        "Branch Code" := HRSETUP."Branch Code";
                        "Shift Code" := HRSETUP."Shift Code";
                        "Calendar Code" := HRSETUP."Calendar Code";
                        "Statistics Group" := HRSETUP."Statistics Group";
                        "Pay Run No." := PayRunNo;
                        IF SpecialPayRun = '00' THEN BEGIN
                          "Special Pay No." := FORMAT(PayRunNo + 'SP' + '1');
                        END;
                        IF SpecialPayRun <> '00' THEN BEGIN
                          EVALUATE(SPNO,FORMAT(COPYSTR(SpecialPayRun,5,1)));
                          SPNO := SPNO + 1;
                          "Special Pay No." := FORMAT(PayRunNo) + 'SP' + FORMAT(SPNO);
                        END;
                        "Pay From Date" := PayFrom;
                        "Pay To Date" := PayTo;
                        "Month Start Date" := TaxFrom;
                        "Month End Date" := TaxTo;
                        "Payroll Reference" := '';
                        "Process GL Integration" := FALSE;
                        "Process Bank Distribution" := FALSE;
                        "Process Payroll" := FALSE;
                        "Process Timesheet" := FALSE;
                        Release := FALSE;
                        "Special Tag" := FALSE;
                        INSERT;

                        INIT;
                        RESET;
                        SETRANGE("Branch Code", "Branch Code");
                        SETRANGE("Shift Code", "Shift Code");
                        SETRANGE("Calendar Code", "Calendar Code");
                        SETRANGE("Statistics Group", "Statistics Group");
                        SETRANGE("Pay Run No.", PayRunNo);
                        IF FINDFIRST() THEN REPEAT
                          "Special Tag" := TRUE;
                          MODIFY;
                        UNTIL NEXT = 0;

                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Pay Run No.", PayRunNo);
                        IF PAYRUN.FINDFIRST() THEN REPEAT
                          PAYRUN."Special Tag" := TRUE;
                          PAYRUN.MODIFY;
                        UNTIL PAYRUN.NEXT = 0;


                        INIT;
                        RESET;
                        SETRANGE("Branch Code", "Branch Code");
                        SETRANGE("Shift Code", "Shift Code");
                        SETRANGE("Calendar Code", "Calendar Code");
                        SETRANGE("Statistics Group", "Statistics Group");
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
                action("Process Payroll")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSETUP.GET();
                        HRSETUP."Pay Run No." := "Pay Run No.";
                        HRSETUP."Special Pay No." := "Special Pay No.";
                        HRSETUP.MODIFY;

                        PayRunScheduler.INIT;
                        PayRunScheduler.RESET;
                        PayRunScheduler.SETRANGE("Branch Code", "Branch Code");
                        PayRunScheduler.SETRANGE("Shift Code", "Shift Code");
                        PayRunScheduler.SETRANGE("Calendar Code", "Calendar Code");
                        PayRunScheduler.SETRANGE("Statistics Group", "Statistics Group");
                        PayRunScheduler.SETRANGE("Pay Run No.", "Pay Run No.");
                        PayRunScheduler.SETRANGE("Special Pay No.", "Special Pay No.");
                        PayRunScheduler.SETRANGE("Pay From Date", "Pay From Date");
                        PAGE.RUN(50215,PayRunScheduler);
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
            }
            group("Close Pay Run")
            {
                CaptionML = ENU='Close Pay Run',
                            ENA='Close Pay Run';
                action("Release Pay Run")
                {
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSETUP.GET();

                        IF Release = TRUE THEN BEGIN
                          MESSAGE('Pay Run %1 already closed', "Pay Run No.");
                          EXIT;
                        END;

                        IF Release = FALSE THEN BEGIN
                          OK := CONFIRM(TEXT001 ,FALSE, "Pay Run No.");

                          IF OK = FALSE THEN BEGIN
                            MESSAGE('Closing of Pay Run %1 aborted', "Pay Run No.");
                            EXIT;
                          END;

                          IF OK = TRUE THEN BEGIN

                            IF "Process Timesheet" = FALSE THEN BEGIN
                              ERROR('Closing of Pay Run %1 aborted. Timesheet has not been processed.', "Pay Run No.");
                            END;

                            IF "Process Payroll" = FALSE THEN BEGIN
                              ERROR('Closing of Pay Run %1 aborted. Payroll has not been processed.', "Pay Run No.");
                            END;

                            IF "Process Bank Distribution" = FALSE THEN BEGIN
                              ERROR('Closing of Pay Run %1 aborted. Bank Distribution has not been processed.', "Pay Run No.");
                            END;

                            IF "Process GL Integration" = FALSE THEN BEGIN
                              ERROR('Closing of Pay Run %1 aborted. GL Integration has not been processed.', "Pay Run No.");
                            END;


                            IF "Process GL Integration" = TRUE THEN BEGIN
                              GenJnlLine.INIT;
                              GenJnlLine.RESET;
                              GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                              GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                              IF GenJnlLine.FINDFIRST() THEN BEGIN
                                ERROR('Payroll Entries exist in Journal Template Name %1, and Journal Batch Name %2, please posted the entries \before releasing the pay run.', HRSETUP."Payroll Journal Template", HRSETUP."Payroll Journal Batch");
                              END;
                            END;

                            Release := TRUE;
                            MODIFY;

                            IF Release = TRUE THEN BEGIN
                              EmployeePayDetails.INIT;
                              EmployeePayDetails.RESET;
                              EmployeePayDetails.SETRANGE("Branch Code", "Branch Code");
                              EmployeePayDetails.SETRANGE("Shift Code", "Shift Code");
                              EmployeePayDetails.SETRANGE("Calendar Code", "Calendar Code");
                              EmployeePayDetails.SETRANGE("Statistics Group", "Statistics Group");
                              IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                                EmployeePayDetails."Last Released Pay Run No." := "Pay Run No.";
                                EmployeePayDetails.MODIFY;
                              UNTIL EmployeePayDetails.NEXT = 0;

                              EmployeeTimesheet.INIT;
                              EmployeeTimesheet.RESET;
                              EmployeeTimesheet.SETRANGE("Branch Code", "Branch Code");
                              EmployeeTimesheet.SETRANGE("Shift Code", "Shift Code");
                              EmployeeTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                              EmployeeTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                              EmployeeTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                              EmployeeTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                              IF EmployeeTimesheet.FINDFIRST() THEN REPEAT
                                EmployeeTimesheet.Release := TRUE;
                                EmployeeTimesheet.MODIFY;
                              UNTIL EmployeeTimesheet.NEXT = 0;

                              PAYRUN.INIT;
                              PAYRUN.RESET;
                              PAYRUN.SETRANGE("Branch Code", "Branch Code");
                              PAYRUN.SETRANGE("Shift Code", "Shift Code");
                              PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                              PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                              PAYRUN.SETRANGE("Pay Run No.", "Pay Run No.");
                              PAYRUN.SETRANGE("Special Pay No.", "Special Pay No.");
                              IF PAYRUN.FINDFIRST() THEN REPEAT
                                PAYRUN.Release := TRUE;
                                PAYRUN.MODIFY;
                              UNTIL PAYRUN.NEXT = 0;

                              BankDistribution.INIT;
                              BankDistribution.RESET;
                              BankDistribution.SETRANGE("Branch Code", "Branch Code");
                              BankDistribution.SETRANGE("Shift Code", "Shift Code");
                              BankDistribution.SETRANGE("Calendar Code", "Calendar Code");
                              BankDistribution.SETRANGE("Statistics Group", "Statistics Group");
                              BankDistribution.SETRANGE("Pay Run No.", "Pay Run No.");
                              BankDistribution.SETRANGE("Special Pay No.", "Special Pay No.");
                              IF BankDistribution.FINDFIRST() THEN REPEAT
                                BankDistribution.Release := TRUE;
                                BankDistribution.MODIFY;
                              UNTIL BankDistribution.NEXT = 0;

                              IF HRSETUP."Pay Element Deletion" = 0 THEN BEGIN  //MANUAL
                                MESSAGE('Please manually delete all expired pay elements from the\Employee Pay Details page before processing the next pay.');
                              END;

                              IF HRSETUP."Pay Element Deletion" = 1 THEN BEGIN  //AUTOMATIC
                                EmployeePayDetails.INIT;
                                EmployeePayDetails.RESET;
                                IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                                  EmployeePayTable.INIT;
                                  EmployeePayTable.RESET;
                                  EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                                  EmployeePayTable.SETRANGE("Include Standard Elements", FALSE);
                                  EmployeePayTable.SETRANGE("Valid To",EmployeePayDetails."Last Released Pay Run No.");
                                  IF EmployeePayTable.FINDFIRST() THEN REPEAT
                                    EmployeePayTable.DELETE;
                                  UNTIL EmployeePayTable.NEXT = 0;
                                UNTIL EmployeePayDetails.NEXT = 0;

                                EmployeePayDetails.INIT;
                                EmployeePayDetails.RESET;
                                IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                                  EmployeePayTable.INIT;
                                  EmployeePayTable.RESET;
                                  EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                                  EmployeePayTable.SETRANGE("Include Standard Elements", FALSE);
                                  EmployeePayTable.SETRANGE("Valid To", '');
                                  IF EmployeePayTable.FINDFIRST() THEN REPEAT
                                    EmployeePayTable.DELETE;
                                  UNTIL EmployeePayTable.NEXT = 0;
                                UNTIL EmployeePayDetails.NEXT = 0;

                                //ASHNEIL CHANDRA  21072017
                                MESSAGE('Expired employee pay elements have been deleted');
                                //ASHNEIL CHANDRA  21072017
                              END;

                              IF HRSETUP."Pay Element Deletion" = 2 THEN BEGIN  //Delete All
                                EmployeePayTable.INIT;
                                EmployeePayTable.RESET;
                                IF EmployeePayTable.FINDFIRST() THEN REPEAT
                                  EmployeePayTable.DELETE;
                                UNTIL EmployeePayTable.NEXT = 0;
                                //ASHNEIL CHANDRA  21072017
                                MESSAGE('All employee pay elements have been deleted');
                                //ASHNEIL CHANDRA  21072017
                              END;
                            END;
                          END;
                        END;
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
                action("Open Payroll Journal")
                {
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSETUP.GET();

                        GenJnlLine.INIT;
                        GenJnlLine.RESET;
                        GenJnlLine.SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                        GenJnlLine.SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                        PAGE.RUN(39,GenJnlLine);
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
            }
            group(Reports)
            {
                Caption = 'Reports';
                action(Timesheet)
                {

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        REPORT.RUN(REPORT::"Employee Timesheet");
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
            }
        }
    }

    var
        PayRunScheduler : Record "Pay Run Scheduler";
        PAYRUN : Record "Pay Run";
        EmployeePayDetails : Record "Employee Pay Details";
        BankDistribution : Record "Bank Pay Distribution";
        EmployeeTimesheet : Record "Employee Timesheet";
        HRSETUP : Record "Human Resources Setup";
        BranchCalendar : Record "Branch Calendar";
        EmployeePayTable : Record "Employee Pay Table";
        NormalNo : Integer;
        RunsPerCalendar : Decimal;
        PayRunNo : Code[10];
        PayFrom : Date;
        PayTo : Date;
        TempPayRunNo : Code[20];
        TaxFrom : Date;
        TaxTo : Date;
        SpecialPayRun : Code[10];
        SPNO : Integer;
        OK : Boolean;
        TEXT001 : Label 'Do you want to close Pay Run %1?. Once closed, the Pay Run cannot be opened again.';
        GenJnlLine : Record "Gen. Journal Line";
        TEXT002 : Label '<>''''';
}

