page 50205 "Branch Policy List"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    CardPageID = "Branch Policy";
    PageType = List;
    SourceTable = "Branch Policy";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code";"Branch Code")
                {
                }
                field("Shift Code";"Shift Code")
                {
                }
                field("Calendar Code";"Calendar Code")
                {
                }
                field("Statistics Group";"Statistics Group")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Pay Run Scheduler")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017

                    IF "First Pay From Date" = 0D THEN BEGIN
                      ERROR('First Pay From Date is blank');
                    END;

                    IF "First Pay To Date" = 0D THEN BEGIN
                      ERROR('First Pay To Date is blank');
                    END;

                    IF HRSETUP.GET() THEN BEGIN;
                      HRSETUP."Branch Code" := "Branch Code";
                      HRSETUP."Shift Code" := "Shift Code";
                      HRSETUP."Calendar Code" := "Calendar Code";
                      HRSETUP."Statistics Group" := "Statistics Group";
                      HRSETUP."Runs Per Calendar" := "Runs Per Calendar";
                      HRSETUP.MODIFY;
                    END;


                    TimeCode.INIT;
                    TimeCode.RESET;
                    TimeCode.SETRANGE("Branch Code","Branch Code");
                    TimeCode.SETRANGE("Shift Code","Shift Code");
                    TimeCode.SETRANGE("Calendar Code","Calendar Code");
                    TimeCode.SETRANGE("Statistics Group","Statistics Group");
                    IF NOT TimeCode.FINDFIRST() THEN BEGIN
                      ERROR('Time Code not setup');
                    END;

                    BranchCalendar.INIT;
                    BranchCalendar.RESET;
                    BranchCalendar.SETRANGE("Branch Code","Branch Code");
                    BranchCalendar.SETRANGE("Shift Code","Shift Code");
                    BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                    BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                    BranchCalendar.SETRANGE("Pay Run No.", '01');
                    IF NOT BranchCalendar.FINDFIRST() THEN BEGIN
                      ERROR('Branch Calendar not setup');
                    END;
                    IF BranchCalendar.FINDFIRST() THEN BEGIN
                      PayRunNo := FORMAT(BranchCalendar."Pay Run No.");
                      PayFrom :=  (BranchCalendar."Pay From Date");
                      PayTo := (BranchCalendar."Pay To Date");
                      TaxFrom := BranchCalendar."Tax Start Month";
                      TaxTo := BranchCalendar."Tax End Month";
                    END;

                    PayRunScheduler.INIT;
                    PayRunScheduler.RESET;
                    PayRunScheduler.SETRANGE("Branch Code","Branch Code");
                    PayRunScheduler.SETRANGE("Shift Code","Shift Code");
                    PayRunScheduler.SETRANGE("Calendar Code","Calendar Code");
                    PayRunScheduler.SETRANGE("Statistics Group","Statistics Group");
                    IF NOT PayRunScheduler.FINDFIRST() THEN BEGIN
                      PayRunScheduler."Branch Code" := "Branch Code";
                      PayRunScheduler."Shift Code" := "Shift Code";
                      PayRunScheduler."Calendar Code" := "Calendar Code";
                      PayRunScheduler."Statistics Group" := "Statistics Group";
                      PayRunScheduler."Pay From Date" := PayFrom;
                      PayRunScheduler."Pay To Date" := PayTo;
                      PayRunScheduler."Pay Run No." := PayRunNo;
                      PayRunScheduler."Special Pay No." := '00';
                      PayRunScheduler."Month Start Date" := TaxFrom;
                      PayRunScheduler."Month End Date" := TaxTo;
                      PayRunScheduler.INSERT;
                    END;

                    //Control Check
                    PayRunScheduler.INIT;
                    PayRunScheduler.RESET;
                    PayRunScheduler.SETRANGE("Branch Code","Branch Code");
                    PayRunScheduler.SETRANGE("Shift Code","Shift Code");
                    PayRunScheduler.SETRANGE("Calendar Code","Calendar Code");
                    PayRunScheduler.SETRANGE("Statistics Group","Statistics Group");
                    PayRunScheduler.SETRANGE("Pay Run No.", PayRunNo);
                    PayRunScheduler.SETRANGE("Special Pay No.", '00');
                    PayRunScheduler.SETRANGE("Pay From Date", PayFrom);
                    IF PayRunScheduler.FINDFIRST() THEN BEGIN
                      IF PayRunScheduler."Pay To Date" = 0D THEN BEGIN
                        ERROR('Pay To Date blank, delete pay run scheduler and re-process');
                      END;
                      IF PayRunScheduler."Month Start Date" = 0D THEN BEGIN
                        ERROR('Month Start Date blank, delete pay run scheduler and re-process');
                      END;
                      IF PayRunScheduler."Month End Date" = 0D THEN BEGIN
                        ERROR('Month End Date blank, delete pay run scheduler and re-process');
                      END;
                    END;

                    HRSETUP.GET();
                    //Control Check
                    PayRunScheduler.INIT;
                    PayRunScheduler.RESET;
                    PayRunScheduler.SETRANGE("Branch Code", "Branch Code");
                    PayRunScheduler.SETRANGE("Shift Code", "Shift Code");
                    PayRunScheduler.SETRANGE("Calendar Code", "Calendar Code");
                    PayRunScheduler.SETRANGE("Statistics Group", "Statistics Group");
                    PAGE.RUN(50210,PayRunScheduler);

                    //ASHNEIL CHANDRA  13072017
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        //ASHNEIL CHANDRA  17072017
        HRSETUP.GET();
        IF HRSETUP."Current Payroll Year" = 0 THEN BEGIN
          ERROR('Please create Payroll Year in Human Resources Setup');
        END;

        IF HRSETUP."Current Payroll Year" <> 0 THEN BEGIN
          HRCurrentPayrollYear := HRSETUP."Current Payroll Year";
          SystemCurrentDate := TODAY;
          SystemCurrentPayrollYear := DATE2DMY(SystemCurrentDate,3);
          IF HRCurrentPayrollYear  < SystemCurrentPayrollYear THEN BEGIN
            ERROR('Current Year is %1', SystemCurrentPayrollYear);
          END;
        END;
        //ASHNEIL CHANDRA  17072017
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        PayRunScheduler : Record "Pay Run Scheduler";
        BranchCalendar : Record "Branch Calendar";
        TimeCode : Record "Time Code";
        PayRunNo : Code[10];
        PayFrom : Date;
        PayTo : Date;
        TaxFrom : Date;
        TaxTo : Date;
        HRCurrentPayrollYear : Integer;
        SystemCurrentPayrollYear : Integer;
        SystemCurrentDate : Date;
}

