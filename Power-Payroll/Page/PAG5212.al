page 5212 "Absence Registration"
{
    // version NAVW110.00, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Absence Registration',
                ENA='Absence Registration';
    DataCaptionFields = "Employee No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Employee Absence";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Employee No.";"Employee No.")
                {
                    ToolTipML = ENU='Specifies a number for the employee.',
                                ENA='Specifies a number for the employee.';
                }
                field("From Date";"From Date")
                {
                    ToolTipML = ENU='Specifies the first day of the employee''s absence registered on this line.',
                                ENA='Specifies the first day of the employee''s absence registered on this line.';
                }
                field("Pay Run No.";"Pay Run No.")
                {
                }
                field("Special Pay No.";"Special Pay No.")
                {
                }
                field("To Date";"To Date")
                {
                    ToolTipML = ENU='Specifies the last day of the employee''s absence registered on this line.',
                                ENA='Specifies the last day of the employee''s absence registered on this line.';
                }
                field("From Time";"From Time")
                {
                }
                field("To Time";"To Time")
                {
                }
                field("Cause of Absence Code";"Cause of Absence Code")
                {
                    ToolTipML = ENU='Specifies a cause of absence code to define the type of absence.',
                                ENA='Specifies a cause of absence code to define the type of absence.';
                }
                field(Description;Description)
                {
                    ToolTipML = ENU='Specifies a description of the absence.',
                                ENA='Specifies a description of the absence.';
                }
                field(Quantity;Quantity)
                {
                    ToolTipML = ENU='Specifies the quantity associated with absences, in hours or days.',
                                ENA='Specifies the quantity associated with absences, in hours or days.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ToolTipML = ENU='Specifies the unit of measure for the absence.',
                                ENA='Specifies the unit of measure for the absence.';
                }
                field(Rate;Rate)
                {
                }
                field(Amount;Amount)
                {
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ToolTipML = ENU='Specifies the quantity associated with absences, in hours or days.',
                                ENA='Specifies the quantity associated with absences, in hours or days.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ToolTipML = ENU='Specifies if a comment is associated with this entry.',
                                ENA='Specifies if a comment is associated with this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("A&bsence")
            {
                CaptionML = ENU='A&bsence',
                            ENA='A&bsence';
                Image = Absence;
                action("Co&mments")
                {
                    CaptionML = ENU='Co&mments',
                                ENA='Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = Table Name=CONST(Employee Absence), Table Line No.=FIELD(Entry No.);
                }
                separator(Separator31)
                {
                }
                action("Overview by &Categories")
                {
                    CaptionML = ENU='Overview by &Categories',
                                ENA='Overview by &Categories';
                    Image = AbsenceCategory;
                    RunObject = Page "Absence Overview by Categories";
                    RunPageLink = Employee No. Filter=FIELD(Employee No.);
                }
                action("Overview by &Periods")
                {
                    CaptionML = ENU='Overview by &Periods',
                                ENA='Overview by &Periods';
                    Image = AbsenceCalendar;
                    RunObject = Page "Absence Overview by Periods";
                }
                action("Sync Leave Data")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA   13072017
                        HRSetup.GET();
                        BASEUOM := HRSetup."Base Unit of Measure";
                        ReportingRateCode := HRSetup."Reporting Rate";

                        HRUOM.INIT;
                        HRUOM.RESET;
                        HRUOM.SETRANGE(Code, ReportingRateCode);
                        IF HRUOM.FINDFIRST() THEN BEGIN
                          ReportingRateConversion := HRUOM."Qty. per Unit of Measure";
                        END;

                        Employee.INIT;
                        Employee.RESET;
                        IF Employee.FINDFIRST() THEN REPEAT
                          INIT;
                          RESET;
                          IF NOT FINDLAST() THEN BEGIN
                            "EntryNo." := 0;
                          END;
                          IF FINDLAST() THEN BEGIN
                            "EntryNo." := "Entry No.";
                          END;

                          PAYRUN.INIT;
                          PAYRUN.RESET;
                          PAYRUN.SETRANGE("Employee No.", Employee."No.");
                          PAYRUN.SETFILTER("Leave Type", '<>%1', '');
                          IF PAYRUN.FINDFIRST() THEN REPEAT
                            INIT;
                            RESET;
                            SETRANGE("Employee No.", PAYRUN."Employee No.");
                            SETRANGE("Pay Run No.", PAYRUN."Pay Run No.");
                            SETRANGE("Special Pay No.", PAYRUN."Special Pay No.");
                            SETRANGE("Cause of Absence Code", PAYRUN."Leave Type");
                            IF NOT FINDFIRST() THEN BEGIN
                              "EntryNo." := "EntryNo." + 1;
                              "Entry No." := "EntryNo.";
                              "Employee No." := PAYRUN."Employee No.";
                              "From Date" := PAYRUN."From Date";
                              "To Date" := PAYRUN."To Date";
                              "From Time" := PAYRUN."From Time";
                              "To Time" := PAYRUN."To Time";
                              "Cause of Absence Code" := PAYRUN."Leave Type";
                              "Pay Code" := PAYRUN."Pay Code";
                              VALIDATE("Cause of Absence Code");
                              "Pay Run No." := PAYRUN."Pay Run No.";
                              "Special Pay No." := PAYRUN."Special Pay No.";
                              Rate := PAYRUN.Rate;
                              Amount := PAYRUN.Amount * -1;
                              Quantity := PAYRUN.Units * -1;
                              Tag := 'Absences';
                              IF "Unit of Measure Code" = BASEUOM THEN BEGIN
                                Quantity := PAYRUN.Units *  ReportingRateConversion * -1;
                              END;
                              INSERT;
                            END;
                          UNTIL PAYRUN.NEXT = 0;
                        UNTIL Employee.NEXT = 0;

                        INIT;
                        RESET;
                        MESSAGE('Sync Completed');
                        //ASHNEIL CHANDRA   13072017
                    end;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        EXIT(Employee.GET("Employee No."));
    end;

    var
        Employee : Record Employee;
        PAYRUN : Record "Pay Run";
        "EntryNo." : Integer;
        HRSetup : Record "Human Resources Setup";
        BASEUOM : Code[10];
        ReportingRateCode : Code[10];
        HRUOM : Record "Human Resource Unit of Measure";
        ReportingRateConversion : Decimal;
}

