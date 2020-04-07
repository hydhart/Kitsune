page 50216 "Employee Timesheet CardPart"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    InsertAllowed = false;
    PageType = CardPart;
    SourceTable = "Employee Timesheet";

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                field("Employee No.";"Employee No.")
                {
                }
                field("Employee Name";"Employee Name")
                {
                }
                field("Pay Code";"Pay Code")
                {
                }
                field("Pay Description";"Pay Description")
                {
                }
                field("Pay Calculation Type";"Pay Calculation Type")
                {
                }
                field("Rate Type";"Rate Type")
                {
                }
                field(Rate;Rate)
                {
                }
                field(Units;Units)
                {
                }
                field(Amount;Amount)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000008)
            {
                action("Quick Timesheet")
                {

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        QuickTimesheet.INIT;
                        QuickTimesheet.RESET;
                        QuickTimesheet.DELETEALL;


                        QuickTimesheet.INIT;
                        QuickTimesheet.RESET;
                        QuickTimesheet.SETRANGE("Branch Code", "Branch Code");
                        QuickTimesheet.SETRANGE("Shift Code", "Shift Code");
                        QuickTimesheet.SETRANGE("Calendar Code", "Calendar Code");
                        QuickTimesheet.SETRANGE("Statistics Group", "Statistics Group");
                        QuickTimesheet.SETRANGE("Pay Run No.", "Pay Run No.");
                        QuickTimesheet.SETRANGE("Special Pay No.", "Special Pay No.");
                        QuickTimesheet.SETRANGE("Employee No.", "Employee No.");
                        IF NOT QuickTimesheet.FINDFIRST() THEN BEGIN
                          PayElementMaster.INIT;
                          PayElementMaster.RESET;
                          PayElementMaster.SETRANGE("Quick Timesheet", TRUE);
                          IF PayElementMaster.FINDFIRST() THEN REPEAT
                            QuickTimesheet."Branch Code" := "Branch Code";
                            QuickTimesheet."Shift Code" := "Shift Code";
                            QuickTimesheet."Calendar Code" := "Calendar Code";
                            QuickTimesheet."Statistics Group" := "Statistics Group";
                            QuickTimesheet."Pay Run No." := "Pay Run No.";
                            QuickTimesheet."Special Pay No." := "Special Pay No.";
                            QuickTimesheet."Employee No." := "Employee No.";
                            QuickTimesheet.Rate := Rate;
                            QuickTimesheet."Pay Code" := PayElementMaster."Pay Code";
                            QuickTimesheet."Pay Description" := PayElementMaster."Pay Description";
                            QuickTimesheet."Rate Type" := PayElementMaster."Rate Type";
                            QuickTimesheet."Quick Timesheet" := PayElementMaster."Quick Timesheet";
                            QuickTimesheet."Is Leave" := PayElementMaster."Is Leave";
                            //ASHNEIL CHANDRA  21072017
                            QuickTimesheet."Is Leave Without Pay" := PayElementMaster."Is Leave Without Pay";
                            //ASHNEIL CHANDRA  21072017
                            QuickTimesheet.INSERT;
                          UNTIL PayElementMaster.NEXT = 0;
                        END;
                        PAGE.RUN(50217,QuickTimesheet);
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }

    var
        QuickTimesheet : Record "Quick Timesheet";
        PayElementMaster : Record "Pay Element Master";
}

