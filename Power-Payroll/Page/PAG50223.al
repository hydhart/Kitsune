page 50223 "Pay To Date Adjustment"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = List;
    SourceTable = "Pay to Date Adjustment";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Total Earnings Paid";"Total Earnings Paid")
                {
                }
                field("Total PAYE Paid";"Total PAYE Paid")
                {
                }
                field("Total SRL Paid";"Total SRL Paid")
                {
                }
                field("Total ECAL Paid";"Total ECAL Paid")
                {
                }
                field("Total Bonus Paid";"Total Bonus Paid")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000007)
            {
                action("Record Entry")
                {

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        HRSETUP.GET();
                        PAYECode := HRSETUP.PAYE;
                        SRTCode := HRSETUP.SRT;
                        ECALCode := HRSETUP.ECAL;

                        IF "Total Earnings Paid" = 0 THEN BEGIN
                          ERROR('Total Earnings paid cannot be Zero');
                        END;



                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Employee No.", "Employee No.");
                        PAYRUN.SETRANGE("Pay Run No.", '0A');
                        PAYRUN.SETRANGE("Special Pay No.", '0A');
                        IF PAYRUN.FINDFIRST() THEN BEGIN
                          ERROR('Cannot record entry, Payrun exists for this employee');
                        END;


                        //PAYE
                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Employee No.", "Employee No.");
                        PAYRUN.SETRANGE("Pay Code", PAYECode);
                        IF NOT PAYRUN.FINDFIRST() THEN BEGIN
                          PAYRUN."Branch Code" := "Branch Code";
                          PAYRUN."Shift Code" := "Shift Code";
                          PAYRUN."Calendar Code" := "Calendar Code";
                          PAYRUN."Statistics Group" := "Statistics Group";
                          PAYRUN."Pay Run No." := '0A';
                          PAYRUN."Special Pay No." := '0A';
                          PAYRUN."Employee No." := "Employee No.";
                          PAYRUN."Pay Code" := PAYECode;
                          PAYRUN.TotalEarningsPaid := "Total Earnings Paid";
                          PAYRUN.TotalPAYEPaid := "Total PAYE Paid";
                          PAYRUN.Amount := "Total Bonus Paid";
                          PAYRUN.Bonus := TRUE;
                          PAYRUN.INSERT;
                        END;


                        //SRL
                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Employee No.", "Employee No.");
                        PAYRUN.SETRANGE("Pay Code", SRTCode);
                        IF NOT PAYRUN.FINDFIRST() THEN BEGIN
                          PAYRUN."Branch Code" := "Branch Code";
                          PAYRUN."Shift Code" := "Shift Code";
                          PAYRUN."Calendar Code" := "Calendar Code";
                          PAYRUN."Statistics Group" := "Statistics Group";
                          PAYRUN."Pay Run No." := '0A';
                          PAYRUN."Special Pay No." := '0A';
                          PAYRUN."Employee No." := "Employee No.";
                          PAYRUN."Pay Code" := SRTCode;
                          PAYRUN.TotalSRTPaid := "Total SRL Paid";
                          PAYRUN.Bonus := FALSE;
                          PAYRUN.INSERT;
                        END;

                        //ECAL
                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Employee No.", "Employee No.");
                        PAYRUN.SETRANGE("Pay Code", ECALCode);
                        IF NOT PAYRUN.FINDFIRST() THEN BEGIN
                          PAYRUN."Branch Code" := "Branch Code";
                          PAYRUN."Shift Code" := "Shift Code";
                          PAYRUN."Calendar Code" := "Calendar Code";
                          PAYRUN."Statistics Group" := "Statistics Group";
                          PAYRUN."Pay Run No." := '0A';
                          PAYRUN."Special Pay No." := '0A';
                          PAYRUN."Employee No." := "Employee No.";
                          PAYRUN."Pay Code" := ECALCode;
                          PAYRUN.TotalECALPaid := "Total ECAL Paid";
                          PAYRUN.Bonus := FALSE;
                          PAYRUN.INSERT;
                        END;

                        PAYRUN.INIT;
                        PAYRUN.RESET;
                        PAYRUN.SETRANGE("Branch Code", "Branch Code");
                        PAYRUN.SETRANGE("Shift Code", "Shift Code");
                        PAYRUN.SETRANGE("Calendar Code", "Calendar Code");
                        PAYRUN.SETRANGE("Statistics Group", "Statistics Group");
                        PAYRUN.SETRANGE("Employee No.", "Employee No.");
                        PAYRUN.SETRANGE("Pay Run No.", '0A');
                        PAYRUN.SETRANGE("Special Pay No.", '0A');
                        IF PAYRUN.FINDFIRST() THEN BEGIN
                          Recorded := TRUE;
                        END;

                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
        }
    }

    var
        PAYRUN : Record "Pay Run";
        HRSETUP : Record "Human Resources Setup";
        FNPFCode : Code[10];
        PAYECode : Code[10];
        SRTCode : Code[10];
        PASSONE : Boolean;
        ECALCode : Code[10];
}

