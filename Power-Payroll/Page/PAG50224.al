page 50224 "Employee Pay History"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    DeleteAllowed = false;
    PageType = List;
    SourceTable = "Employee Pay History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Increment Date";"Increment Date")
                {
                }
                field("Annual Pay";"Annual Pay")
                {
                }
                field(Units;Units)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000005)
            {
                action("Update Annual Pay")
                {

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        IF FINDLAST() THEN BEGIN
                          EmployeePayDetails.INIT;
                          EmployeePayDetails.RESET;
                          EmployeePayDetails.SETRANGE("No.", "Employee No.");
                          IF EmployeePayDetails.FINDFIRST() THEN BEGIN
                            IF EmployeePayDetails."Statistics Group" <> '' THEN BEGIN
                              EmployeePayDetails."Annual Pay" := "Annual Pay";
                              EmployeePayDetails.VALIDATE("Annual Pay");
                              EmployeePayDetails.Units := Units;
                              EmployeePayDetails.VALIDATE(Units);
                              EmployeePayDetails."Increment Date" := "Increment Date";
                              EmployeePayDetails.MODIFY;
                              EmployeeRate := EmployeePayDetails."Employee Rate";
                              RunsPerCalendar := EmployeePayDetails."Runs Per Calendar";
                            END;
                            IF EmployeePayDetails."Statistics Group" = '' THEN BEGIN
                              ERROR('Employee Statistics Group cannot be blank');
                            END;
                          END;
                          Rate := EmployeeRate;
                          "Runs Per Calendar" := RunsPerCalendar;
                          MODIFY;
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }

    var
        EmployeePayDetails : Record "Employee Pay Details";
        EmployeeRate : Decimal;
        RunsPerCalendar : Decimal;
        StatisticsGroup : Record "Statistics Group";
        EmployeePayHistory : Record "Employee Pay History";
}

