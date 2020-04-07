page 50204 "Branch Policy"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = Card;
    SourceTable = "Branch Policy";

    layout
    {
        area(content)
        {
            group(General)
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
                field("Branch Name";"Branch Name")
                {
                }
                field("Runs Per Calendar";"Runs Per Calendar")
                {
                }
                field("Pay Calculation Type";"Pay Calculation Type")
                {
                }
                field("First Pay From Date";"First Pay From Date")
                {
                }
                field("First Pay To Date";"First Pay To Date")
                {
                }
                field(Release;Release)
                {
                }
            }
            part(Control1000000017;"Time Code CartPart")
            {
                SubPageLink = Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Calendar Code=FIELD(Calendar Code), Statistics Group=FIELD(Statistics Group);
            }
            part(Control1000000018;"Branch Calendar CartPart")
            {
                SubPageLink = Branch Code=FIELD(Branch Code), Shift Code=FIELD(Shift Code), Calendar Code=FIELD(Calendar Code), Statistics Group=FIELD(Statistics Group);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup1000000023)
            {
                action(Update)
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        StatisticsGroup.INIT;
                        StatisticsGroup.RESET;
                        IF StatisticsGroup.GET("Statistics Group") THEN BEGIN
                          "Runs Per Calendar" := StatisticsGroup."Runs Per Calendar";
                          MODIFY;
                        END;

                        MESSAGE('Update Completed');
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Generate Time Codes")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        TimeCode.INIT;
                        TimeCode.RESET;
                        TimeCode.SETRANGE("Branch Code","Branch Code");
                        TimeCode.SETRANGE("Shift Code","Shift Code");
                        TimeCode.SETRANGE("Calendar Code","Calendar Code");
                        TimeCode.SETRANGE("Statistics Group","Statistics Group");
                        IF TimeCode.FINDFIRST() THEN BEGIN
                          ERROR('Time Codes Exists, Cannot Generate.');
                        END;

                        TimeCode."Branch Code" := "Branch Code";
                        TimeCode."Shift Code" := "Shift Code";
                        TimeCode."Calendar Code" := "Calendar Code";
                        TimeCode."Statistics Group" := "Statistics Group";

                        TimeCode.Day := 'Sunday';
                        TimeCode."Line No." := 10;
                        TimeCode."Day of the Week" := 7;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Monday';
                        TimeCode."Line No." := 20;
                        TimeCode."Day of the Week" := 1;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Tuesday';
                        TimeCode."Line No." := 30;
                        TimeCode."Day of the Week" := 2;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Wednesday';
                        TimeCode."Line No." := 40;
                        TimeCode."Day of the Week" := 3;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Thursday';
                        TimeCode."Line No." := 50;
                        TimeCode."Day of the Week" := 4;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Friday';
                        TimeCode."Line No." := 60;
                        TimeCode."Day of the Week" := 5;
                        TimeCode.INSERT;

                        TimeCode.Day := 'Saturday';
                        TimeCode."Line No." := 70;
                        TimeCode."Day of the Week" := 6;
                        TimeCode.INSERT;

                        MESSAGE('Time Code Generated');
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Generate Branch Calendar")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        HRSETUP.GET();

                        CurrentDate := TODAY;
                        CurrentYear := DATE2DMY(CurrentDate,3);
                        IF HRSETUP."Current Payroll Year" <> CurrentYear THEN BEGIN
                          ERROR('Current Year does not match Payroll Year');
                        END;

                        IF "First Pay From Date" = 0D THEN BEGIN
                          ERROR('First Pay From Date is blank');
                        END;

                        IF "First Pay To Date" = 0D THEN BEGIN
                          ERROR('First Pay To Date is blank');
                        END;

                        TimeCode.INIT;
                        TimeCode.RESET;
                        TimeCode.SETRANGE("Branch Code","Branch Code");
                        TimeCode.SETRANGE("Shift Code","Shift Code");
                        TimeCode.SETRANGE("Calendar Code","Calendar Code");
                        TimeCode.SETRANGE("Statistics Group","Statistics Group");
                        IF NOT TimeCode.FINDFIRST() THEN BEGIN
                          ERROR('Time Codes does not Exists');
                        END;


                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        IF BranchCalendar.FINDFIRST() THEN BEGIN
                          ERROR('Branch Calendar Exists, Cannot Generate.');
                        END;


                        MFLG := TRUE;
                        MLine := 10000;

                        BEGINYEAR := '0101' + FORMAT(HRSETUP."Current Payroll Year");
                        ENDYEAR := '3112' + FORMAT(HRSETUP."Current Payroll Year");
                        EVALUATE(VARBEGINYEAR, BEGINYEAR);
                        EVALUATE(VARENDYEAR, ENDYEAR);


                        IF MFLG THEN REPEAT
                          BranchCalendar."Branch Code" := "Branch Code";
                          BranchCalendar."Calendar Date" := VARBEGINYEAR;
                          BranchCalendar."Shift Code" := "Shift Code";
                          BranchCalendar."Calendar Code" := "Calendar Code";
                          BranchCalendar."Statistics Group" := "Statistics Group";
                          BranchCalendar."Line No." := MLine;
                          BranchCalendar.Description := FORMAT(VARBEGINYEAR,0,4);
                          BranchCalendar.Month := FORMAT(DATE2DMY(VARBEGINYEAR, 2));
                          BranchCalendar.Holiday := FALSE;

                          TimeCode.INIT;
                          TimeCode.RESET;
                          TimeCode.SETRANGE("Branch Code","Branch Code");
                          TimeCode.SETRANGE("Shift Code","Shift Code");
                          TimeCode.SETRANGE("Calendar Code","Calendar Code");
                          TimeCode.SETRANGE("Statistics Group","Statistics Group");
                          TimeCode.SETRANGE("Day of the Week",DATE2DWY(VARBEGINYEAR,1));
                          IF TimeCode.FINDFIRST() THEN BEGIN
                            BranchCalendar."Hours Per Day" := TimeCode."Hours Per Day";
                            BranchCalendar.Day := TimeCode.Day;
                            BranchCalendar."Off Day" := TimeCode."Day Off";
                            BranchCalendar.Holiday := TimeCode."Day Off";
                          END;

                          Holiday.INIT;
                          Holiday.RESET;
                          Holiday.SETRANGE("Holiday Date", BranchCalendar."Calendar Date");
                          IF Holiday.FINDFIRST() THEN BEGIN
                            BranchCalendar.Holiday:=TRUE;
                          END;

                          BranchCalendar.INSERT;
                          VARBEGINYEAR := VARBEGINYEAR + 1;
                          MLine := MLine + 10;
                        UNTIL VARBEGINYEAR > VARENDYEAR;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '1');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month1 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '2');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month2 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '3');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month3 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '4');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month4 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '5');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month5 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '6');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month6 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '7');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month7 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '8');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month8 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '9');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month9 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '10');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month10 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '11');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month11 := BranchCalendar."Calendar Date";
                        END;

                        BranchCalendar.INIT;
                        BranchCalendar.RESET;
                        BranchCalendar.SETRANGE("Branch Code","Branch Code");
                        BranchCalendar.SETRANGE("Shift Code","Shift Code");
                        BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                        BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                        BranchCalendar.SETRANGE(Month, '12');
                        IF BranchCalendar.FINDLAST() THEN BEGIN
                          Month12 := BranchCalendar."Calendar Date";
                        END;


                        StatisticsGroup.INIT;
                        StatisticsGroup.RESET;
                        IF StatisticsGroup.GET("Statistics Group") THEN BEGIN
                          DaysPerRun := StatisticsGroup."Days Per Run";
                        END;

                        PayFrom := "First Pay From Date";
                        PayTo := "First Pay To Date";
                        PayRunNo := 1;

                        IF "Statistics Group" <> 'MONTHLY' THEN BEGIN
                          BranchCalendar.INIT;
                          BranchCalendar.RESET;
                          BranchCalendar.SETRANGE("Branch Code","Branch Code");
                          BranchCalendar.SETRANGE("Shift Code","Shift Code");
                          BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                          BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                          IF BranchCalendar.FINDFIRST() THEN REPEAT
                            IF BranchCalendar."Calendar Date" = PayTo THEN BEGIN
                               IF STRLEN(FORMAT(PayRunNo)) = 1 THEN BEGIN
                                BranchCalendar."Pay Run No." := '0' + FORMAT(PayRunNo);
                              END;
                              IF STRLEN(FORMAT(PayRunNo)) = 2 THEN BEGIN
                                BranchCalendar."Pay Run No." := FORMAT(PayRunNo);
                              END;

                              BranchCalendar."Pay From Date" := PayFrom;
                              BranchCalendar."Pay To Date" := PayTo;
                              BranchCalendar.Payroll := TRUE;
                              PayFrom := PayFrom + DaysPerRun;
                              PayTo := PayTo + DaysPerRun;
                              PayRunNo := PayRunNo + 1;

                              BranchCalendar.MODIFY;
                            END;
                          UNTIL BranchCalendar.NEXT = 0;
                        END;

                        IF "Statistics Group" = 'MONTHLY' THEN BEGIN
                          BranchCalendar.INIT;
                          BranchCalendar.RESET;
                          BranchCalendar.SETRANGE("Branch Code","Branch Code");
                          BranchCalendar.SETRANGE("Shift Code","Shift Code");
                          BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                          BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                          IF BranchCalendar.FINDFIRST() THEN REPEAT
                            IF BranchCalendar."Calendar Date" = PayTo THEN BEGIN
                               IF STRLEN(FORMAT(PayRunNo)) = 1 THEN BEGIN
                                BranchCalendar."Pay Run No." := '0' + FORMAT(PayRunNo);
                              END;
                              IF STRLEN(FORMAT(PayRunNo)) = 2 THEN BEGIN
                                BranchCalendar."Pay Run No." := FORMAT(PayRunNo);
                              END;
                              IF BranchCalendar.Month = '1' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0101' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month1;
                                PayTo := Month2;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '2' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0102' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month2;
                                PayTo := Month3;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '3' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0103' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month3;
                                PayTo := Month4;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '4' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0104' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month4;
                                PayTo := Month5;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '5' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0105' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month5;
                                PayTo := Month6;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '6' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0106' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month6;
                                PayTo := Month7;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '7' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0107' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month7;
                                PayTo := Month8;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '8' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0108' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month8;
                                PayTo := Month9;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '9' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0109' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month9;
                                PayTo := Month10;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '10' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0110' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month10;
                                PayTo := Month11;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '11' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0111' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month11;
                                PayTo := Month12;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              IF BranchCalendar.Month = '12' THEN BEGIN
                                EVALUATE(BranchCalendar."Pay From Date", '0112' + FORMAT(HRSETUP."Current Payroll Year"));
                                BranchCalendar."Pay To Date" := Month12;
                                BranchCalendar.Payroll := TRUE;
                              END;
                              PayRunNo := PayRunNo + 1;

                              BranchCalendar.MODIFY;
                            END;
                          UNTIL BranchCalendar.NEXT = 0;
                        END;

                          BranchCalendar.INIT;
                          BranchCalendar.RESET;
                          BranchCalendar.SETRANGE("Branch Code","Branch Code");
                          BranchCalendar.SETRANGE("Shift Code","Shift Code");
                          BranchCalendar.SETRANGE("Calendar Code","Calendar Code");
                          BranchCalendar.SETRANGE("Statistics Group","Statistics Group");
                          BranchCalendar.SETRANGE(Payroll, TRUE);
                          IF BranchCalendar.FINDFIRST() THEN REPEAT
                            IF BranchCalendar.Month = '1' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0101' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month1;
                            END;
                            IF BranchCalendar.Month = '2' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0102' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month2;
                            END;
                            IF BranchCalendar.Month = '3' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0103' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month3;
                            END;
                            IF BranchCalendar.Month = '4' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0104' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month4;
                            END;
                            IF BranchCalendar.Month = '5' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0105' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month5;
                            END;
                            IF BranchCalendar.Month = '6' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0106' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month6;
                            END;
                            IF BranchCalendar.Month = '7' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0107' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month7;
                            END;
                            IF BranchCalendar.Month = '8' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0108' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month8;
                            END;
                            IF BranchCalendar.Month = '9' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0109' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month9;
                            END;
                            IF BranchCalendar.Month = '10' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0110' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month10;
                            END;
                            IF BranchCalendar.Month = '11' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0111' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month11;
                            END;
                            IF BranchCalendar.Month = '12' THEN BEGIN
                              EVALUATE(BranchCalendar."Tax Start Month", '0112' + FORMAT(HRSETUP."Current Payroll Year"));
                              BranchCalendar."Tax End Month" := Month12;
                            END;
                            BranchCalendar.MODIFY;
                          UNTIL BranchCalendar.NEXT = 0;

                        MESSAGE('Branch Calendar Generated');
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                action("Generate Branch Policy Elements")
                {
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        PayElementMaster.INIT;
                        PayElementMaster.RESET;
                        IF PayElementMaster.FINDFIRST() THEN REPEAT
                          BranchPolicyElements.INIT;
                          BranchPolicyElements.RESET;
                          BranchPolicyElements.SETRANGE("Branch Code","Branch Code");
                          BranchPolicyElements.SETRANGE("Shift Code","Shift Code");
                          BranchPolicyElements.SETRANGE("Calendar Code","Calendar Code");
                          BranchPolicyElements.SETRANGE("Statistics Group","Statistics Group");
                          BranchPolicyElements.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                          IF BranchPolicyElements.FINDFIRST() THEN BEGIN
                            BranchPolicyElements."Pay Code" := PayElementMaster."Pay Code";
                            BranchPolicyElements."Pay Description" := PayElementMaster."Pay Description";
                            BranchPolicyElements."Pay Type" := PayElementMaster."Pay Type";
                            BranchPolicyElements."Pay Category" := PayElementMaster."Pay Category";
                            BranchPolicyElements."Cash/Non Cash" := PayElementMaster."Cash/Non Cash";
                            BranchPolicyElements."Is Leave" := PayElementMaster."Is Leave";
                            BranchPolicyElements."Is FNPF Field" := PayElementMaster."Is FNPF Field";
                            BranchPolicyElements.MODIFY;
                          END;
                          IF NOT BranchPolicyElements.FINDFIRST() THEN BEGIN
                            BranchPolicyElements."Branch Code" := "Branch Code";
                            BranchPolicyElements."Shift Code" := "Shift Code";
                            BranchPolicyElements."Calendar Code" := "Calendar Code";
                            BranchPolicyElements."Statistics Group" := "Statistics Group";
                            BranchPolicyElements."Pay Code" := PayElementMaster."Pay Code";
                            BranchPolicyElements."Pay Description" := PayElementMaster."Pay Description";
                            BranchPolicyElements."Pay Type" := PayElementMaster."Pay Type";
                            BranchPolicyElements."Pay Category" := PayElementMaster."Pay Category";
                            BranchPolicyElements."Cash/Non Cash" := PayElementMaster."Cash/Non Cash";
                            BranchPolicyElements."Is Leave" := PayElementMaster."Is Leave";
                            BranchPolicyElements."Is FNPF Field" := PayElementMaster."Is FNPF Field";
                            BranchPolicyElements."Post to GL" := FALSE;
                            BranchPolicyElements."GL Debit Code" := '';
                            BranchPolicyElements."GL DR Account Type" := 0;
                            BranchPolicyElements."GL Credit Code" := '';
                            BranchPolicyElements."GL CR Account Type" := 0;
                            BranchPolicyElements.INSERT;
                          END;
                        UNTIL PayElementMaster.NEXT = 0;

                        MESSAGE('Branch Policy Element Generated');
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
            }
            group(ActionGroup1000000013)
            {
                action("Apply to all active Employees")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  20072017
                        Employee.INIT;
                        Employee.RESET;
                        Employee.SETRANGE(Terminated, FALSE);
                        IF Employee.FINDFIRST() THEN REPEAT
                          Employee."Branch Code" := "Branch Code";
                          Employee.VALIDATE("Branch Code");
                          Employee.MODIFY;
                        UNTIL Employee.NEXT = 0;
                        //ASHNEIL CHANDRA  20072017
                    end;
                }
                action("Open Branch Policy Elements")
                {
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        //ASHNEIL CHANDRA  22072017
                        BranchPolicyElements.INIT;
                        BranchPolicyElements.RESET;
                        BranchPolicyElements.SETRANGE("Branch Code", "Branch Code");
                        BranchPolicyElements.SETRANGE("Shift Code", "Shift Code");
                        BranchPolicyElements.SETRANGE("Calendar Code", "Calendar Code");
                        BranchPolicyElements.SETRANGE("Statistics Group", "Statistics Group");
                        PAGE.RUN(50227, BranchPolicyElements);
                        //ASHNEIL CHANDRA  22072017
                    end;
                }
            }
        }
    }

    var
        HRSETUP : Record "Human Resources Setup";
        PayRunScheduler : Record "Pay Run Scheduler";
        TimeCode : Record "Time Code";
        BranchCalendar : Record "Branch Calendar";
        BranchPolicyElements : Record "Branch Policy Elements";
        PayElementMaster : Record "Pay Element Master";
        MFLG : Boolean;
        MLine : Integer;
        BEGINYEAR : Text;
        ENDYEAR : Text;
        VARBEGINYEAR : Date;
        VARENDYEAR : Date;
        Holiday : Record Holiday;
        StatisticsGroup : Record "Statistics Group";
        DaysPerRun : Decimal;
        PayRunNo : Integer;
        PayFrom : Date;
        PayTo : Date;
        Month1 : Date;
        Month2 : Date;
        Month3 : Date;
        Month4 : Date;
        Month5 : Date;
        Month6 : Date;
        Month7 : Date;
        Month8 : Date;
        Month9 : Date;
        Month10 : Date;
        Month11 : Date;
        Month12 : Date;
        Employee : Record Employee;
        CurrentDate : Date;
        CurrentYear : Integer;
}

