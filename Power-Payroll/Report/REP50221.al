report 50221 "FNPF Contribution Schedule"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './FNPF Contribution Schedule.rdlc';

    dataset
    {
        dataitem(Employee;"Employee Pay Details")
        {
            DataItemTableView = ORDER(Ascending) WHERE(Print in FNPF=FILTER(Yes), By Pass FNPF=FILTER(No));
            column(EmployerReferenceNo;HRSETUP."Employer Reference No.")
            {
            }
            column(CompanyName;CompanyInfo.Name)
            {
            }
            column(CompanyTradingName;CompanyInfo."Name 2")
            {
            }
            column(CompanyAddress;CompanyInfo.Address)
            {
            }
            column(CompanyCity;CompanyInfo.City)
            {
            }
            column(CompanyContributionType;HRSETUP."Contribution Type")
            {
            }
            column(TotalContributionHeader;TotalContributionHeader)
            {
            }
            column(TotalWagesHeader;TotalWagesHeader)
            {
            }
            column(NoEmployee;NoEmployee)
            {
            }
            column(CSDueDate;CSDueDate)
            {
            }
            column(ContributionMonth;ContributionMonth)
            {
            }
            column(ContributionYear;ContributionYear)
            {
            }
            column(WagesMonth;WagesMonth)
            {
            }
            column(WagesYear;WagesYear)
            {
            }
            column(CSCode;CSCode)
            {
            }
            column(TEXT001;TEXT001)
            {
            }
            column(TEXT002;TEXT002)
            {
            }
            column(TEXT003;TEXT003)
            {
            }
            column(TEXT004;TEXT004)
            {
            }
            column(TEXT005;TEXT005)
            {
            }
            column(TEXT006;TEXT006)
            {
            }
            column(TEXT007;TEXT007)
            {
            }
            column(TEXT008;TEXT008)
            {
            }
            column(TEXT009;TEXT009)
            {
            }
            column(TEXT010;TEXT010)
            {
            }
            column(TEXT011;TEXT011)
            {
            }
            column(TEXT012;TEXT012)
            {
            }
            column(TEXT013;TEXT013)
            {
            }
            column(TEXT014;TEXT014)
            {
            }
            column(TEXT015;TEXT015)
            {
            }
            column(TEXT016;TEXT016)
            {
            }
            column(TEXT017;TEXT017)
            {
            }
            column(TEXT018;TEXT018)
            {
            }
            column(TEXT019;TEXT019)
            {
            }
            column(TEXT020;TEXT020)
            {
            }
            column(TEXT021;TEXT021)
            {
            }
            column(TEXT022;TEXT022)
            {
            }
            column(TEXT023;TEXT023)
            {
            }
            column(TEXT024;TEXT024)
            {
            }
            column(TEXT025;TEXT025)
            {
            }
            column(TEXT026;TEXT026)
            {
            }
            column(TEXT027;TEXT027)
            {
            }
            column(TEXT028;TEXT028)
            {
            }
            column(TEXT029;TEXT029)
            {
            }
            column(TEXT030;TEXT030)
            {
            }
            column(TEXT031;TEXT031)
            {
            }
            column(TEXT032;TEXT032)
            {
            }
            column(TEXT033;TEXT033)
            {
            }
            column(TEXT034;TEXT034)
            {
            }
            column(TEXT035;TEXT035)
            {
            }
            column(TEXT036;TEXT036)
            {
            }
            column(TEXT037;TEXT037)
            {
            }
            column(MemberNumber;MemberNumber)
            {
            }
            column(FirstName;FirstName)
            {
            }
            column(MiddleName;MiddleName)
            {
            }
            column(LastName;LastName)
            {
            }
            column(MemberTAX;MemberTAX)
            {
            }
            column(EmployerAdditional;EmployerAdditional)
            {
            }
            column(MemberAdditional;MemberAdditional)
            {
            }
            column(CompulsoryContribution;CompulsoryContribution)
            {
            }
            column(TotalContribution;TotalContribution)
            {
            }
            column(TotalWages;TotalWages)
            {
            }
            column(EmploymentStatus;EmploymentStatus)
            {
            }
            column(EmploymentStatusDate;EmploymentStatusDate)
            {
            }
            column(PaymentFrequency;PaymentFrequency)
            {
            }
            column(LineNo;LineNo)
            {
            }

            trigger OnAfterGetRecord();
            begin
                TotalWages := 0;
                CompulsoryContribution := 0;
                TotalContribution := 0;
                MemberAdditional := 0;
                EmployerAdditional := 0;
                LineNo := LineNo + 1;
                Employer10 := 0;
                Employee8 := 0;
                EmployerFNPFAdditional := 0;
                EmployeeFNPFAdditional := 0;


                PAYRUN.INIT;
                PAYRUN.RESET;
                PAYRUN.SETRANGE("Tax Start Month", StartDate);
                PAYRUN.SETRANGE("Tax End Month", EndDate);
                PAYRUN.SETRANGE("Employee No.", "No.");
                PAYRUN.SETRANGE("Include In Pay Slip", TRUE);
                PAYRUN.SETRANGE("By Pass FNPF", FALSE);
                IF PAYRUN.FINDFIRST() THEN REPEAT
                  IF PAYRUN."Pay Type" = 0 THEN BEGIN
                    IF PAYRUN."Is FNPF Base" = TRUE THEN BEGIN
                      TotalWages := TotalWages + ROUND((PAYRUN.Amount),0.01, '=');
                    END;
                  END;

                  IF PAYRUN."Is FNPF Field" = TRUE THEN BEGIN
                    Employer10 := Employer10 + (ROUND(PAYRUN."Employer 10 Percent", 0.01, '='));
                    Employee8 := Employee8 + (ROUND(PAYRUN."Employee 8 Percent", 0.01, '='));
                    EmployerFNPFAdditional := EmployerFNPFAdditional + (ROUND(PAYRUN."Employer FNPF Additional", 0.01, '='));
                    EmployeeFNPFAdditional := EmployeeFNPFAdditional + (ROUND(PAYRUN."Employee FNPF Additional", 0.01, '='));
                    CompulsoryContribution := Employer10 + Employee8;
                    EmployerAdditional := EmployerFNPFAdditional;
                    MemberAdditional := EmployeeFNPFAdditional;
                    TotalContribution := CompulsoryContribution + EmployerFNPFAdditional + EmployeeFNPFAdditional;

                    IF EmployeeMaster.GET("No.") THEN BEGIN
                      FirstName := EmployeeMaster."First Name";
                      MiddleName := EmployeeMaster."Middle Name";
                      LastName := EmployeeMaster."Last Name";
                    END;

                      MemberNumber := Employee."Employee FNPF";
                      MemberTAX := Employee."Employee TIN";
                      OccupationCode := Employee."Occupation Code";

                      EmploymentStatus := Employee."Employment Status";
                      IF EmploymentStatus = 0 THEN BEGIN
                        TempEmployeeStatus := 'LEAV';
                      END;
                      IF EmploymentStatus = 1 THEN BEGIN
                        TempEmployeeStatus := 'ACTV';
                      END;
                      IF EmploymentStatus = 2 THEN BEGIN
                        TempEmployeeStatus := 'LEAV';
                      END;
                      IF EmploymentStatus = 3 THEN BEGIN
                        TempEmployeeStatus := 'TRMD';
                      END;

                      EmploymentStatusDate := Employee."Employment Status Date";
                      IF Employee."Employment Status Date" = 0D THEN BEGIN
                        IF Employee.Terminated = FALSE THEN BEGIN
                          Employee."Employment Status Date" := Employee."Employment Start Date";
                        END;
                        IF Employee.Terminated = TRUE THEN BEGIN
                          Employee."Employment Status Date" := Employee."Employment End Date";
                        END;
                      END;


                      SEDay := DATE2DMY(EmploymentStatusDate, 1);
                      SEDayText := FORMAT(SEDay);
                      SEMonth := DATE2DMY(EmploymentStatusDate, 2);
                      SEmonthText := FORMAT(SEMonth);
                      SEYear := DATE2DMY(EmploymentStatusDate, 3);

                      IF SEDay = 1 THEN BEGIN
                        SEDayText := '01';
                      END;
                      IF SEDay = 2 THEN BEGIN
                        SEDayText := '02';
                      END;
                      IF SEDay = 3 THEN BEGIN
                        SEDayText := '03';
                      END;
                      IF SEDay = 4 THEN BEGIN
                        SEDayText := '04';
                      END;
                      IF SEDay = 5 THEN BEGIN
                        SEDayText := '05';
                      END;
                      IF SEDay = 6 THEN BEGIN
                        SEDayText := '06';
                      END;
                      IF SEDay = 7 THEN BEGIN
                        SEDayText := '07';
                      END;
                      IF SEDay = 8 THEN BEGIN
                        SEDayText := '08';
                      END;
                      IF SEDay = 9 THEN BEGIN
                        SEDayText := '09';
                      END;


                      IF SEMonth = 1 THEN BEGIN
                        SEmonthText := '01';
                      END;
                      IF SEMonth = 2 THEN BEGIN
                        SEmonthText := '02';
                      END;
                      IF SEMonth = 3 THEN BEGIN
                        SEmonthText := '03';
                      END;
                      IF SEMonth = 4 THEN BEGIN
                        SEmonthText := '04';
                      END;
                      IF SEMonth = 5 THEN BEGIN
                        SEmonthText := '05';
                      END;
                      IF SEMonth = 6 THEN BEGIN
                        SEmonthText := '06';
                      END;
                      IF SEMonth = 7 THEN BEGIN
                        SEmonthText := '07';
                      END;
                      IF SEMonth = 8 THEN BEGIN
                        SEmonthText := '08';
                      END;
                      IF SEMonth = 9 THEN BEGIN
                        SEmonthText := '09';
                      END;


                      PaymentFrequency := Employee."Payment Frequency";
                      IF PaymentFrequency = 1 THEN BEGIN
                        TempPaymentFrequency := 'WEEK';
                      END;
                      IF PaymentFrequency = 2 THEN BEGIN
                        TempPaymentFrequency := 'FRNT';
                      END;
                      IF PaymentFrequency = 3 THEN BEGIN
                        TempPaymentFrequency := 'MNTH';
                      END;
                  END;
                UNTIL PAYRUN.NEXT = 0;


                //REMOVE COMMA   TotalContributionHeader

                TEMPTotalContributionHeader := FORMAT(ABS(ROUND((TotalContributionHeader*100),0.01,'=')));

                TCHTEXT := '';
                X := '';
                Y := 0;
                L := 0;

                L := STRLEN(TEMPTotalContributionHeader);
                Y := 1;
                REPEAT;
                  X := COPYSTR(TEMPTotalContributionHeader,Y,1);
                  IF X <> ',' THEN BEGIN
                    TCHTEXT := TCHTEXT + X;
                  END;
                  Y := Y + 1;
                UNTIL Y > L - 2;


                TEMPTotalContributionHeader2 := FORMAT(ABS(ROUND((TotalContributionHeader*100),0.01,'=')));

                TCHTEXT2 := '';
                X2 := '';
                L2 := STRLEN(TEMPTotalContributionHeader2);
                Y2 := (L2 - 1);
                REPEAT;
                  X2 := COPYSTR(TEMPTotalContributionHeader2,Y2,1);
                    TCHTEXT2 := TCHTEXT2 + X2;
                  Y2 := Y2 + 1;
                UNTIL Y2 > L2;

                //REMOVE COMMA


                //REMOVE COMMA   TotalWagesHeader

                TEMPTotalWagesHeader := FORMAT(ABS(ROUND((TotalWagesHeader*100),0.01,'=')));

                TWHTEXT := '';
                X := '';
                Y := 0;
                L := 0;

                L := STRLEN(TEMPTotalWagesHeader);
                Y := 1;
                REPEAT;
                  X := COPYSTR(TEMPTotalWagesHeader,Y,1);
                  IF X <> ',' THEN BEGIN
                    TWHTEXT := TWHTEXT + X;
                  END;
                  Y := Y + 1;
                UNTIL Y > L - 2;


                TEMPTotalWagesHeader2 := FORMAT(ABS(ROUND((TotalWagesHeader*100),0.01,'=')));

                TWHTEXT2 := '';
                X2 := '';
                L2 := STRLEN(TEMPTotalWagesHeader2);
                Y2 := (L2 - 1);
                REPEAT;
                  X2 := COPYSTR(TEMPTotalWagesHeader2,Y2,1);
                    TWHTEXT2 := TWHTEXT2 + X2;
                  Y2 := Y2 + 1;
                UNTIL Y2 > L2;

                //REMOVE COMMA

                //HEADER-------------

                FNPFContributionSchedule.INIT;
                FNPFContributionSchedule.RESET;
                FNPFContributionSchedule.SETRANGE(Code, 'BHEADER');
                IF NOT FNPFContributionSchedule.FINDFIRST() THEN BEGIN
                  FNPFContributionSchedule.Code := 'BHEADER';
                  FNPFContributionSchedule.Print := '01' + TEXT002 + TempContributionMonth + TEXT002 + ContributionYear + TEXT002 + TempWagesMonth +
                                               TEXT002 + WagesYear + TEXT002 + FORMAT(HRSETUP."Contribution Type") +
                                               TEXT002 + HRSETUP."Employer Reference No." +TEXT002 + CompanyInfo.Name +
                                               TEXT002 + CompanyInfo."Name 2" + TEXT002 + CSCode + TEXT002 + SDayText + '/' + SmonthText +
                                               '/' + FORMAT(SYear) + TEXT002 + TCHTEXT  + '.' + TCHTEXT2 + TEXT002 + FORMAT(NoEmployee) +
                                               TEXT002 + TWHTEXT + '.' + TWHTEXT2;
                  FNPFContributionSchedule.INSERT;
                END;


                  IF "By Pass FNPF" = FALSE THEN BEGIN
                    //REMOVE COMMA   CompulsoryContribution

                    TEMPCompulsoryContribution := FORMAT(ABS(ROUND((CompulsoryContribution*100),0.01,'=')));
                    //MESSAGE('%1 %2', "No.", TEMPCompulsoryContribution);

                    CCHTEXT := '';
                    X := '';
                    Y := 0;
                    L := 0;

                    L := STRLEN(TEMPCompulsoryContribution);
                    Y := 1;
                    REPEAT;
                      X := COPYSTR(TEMPCompulsoryContribution,Y,1);
                      IF X <> ',' THEN BEGIN
                        CCHTEXT := CCHTEXT + X;
                      END;
                      Y := Y + 1;
                    UNTIL Y > L - 2;


                    TEMPCompulsoryContribution2 := FORMAT(ABS(ROUND((CompulsoryContribution*100),0.01,'=')));


                    CCHTEXT2 := '';
                    X2 := '';
                    L2 := STRLEN(TEMPCompulsoryContribution2);
                    Y2 := (L2 - 1);
                    REPEAT;
                      X2 := COPYSTR(TEMPCompulsoryContribution2,Y2,1);
                        CCHTEXT2 := CCHTEXT2 + X2;
                      Y2 := Y2 + 1;
                    UNTIL Y2 > L2;

                    //REMOVE COMMA


                    //REMOVE COMMA   TotalWages

                    TEMPTotalWages := FORMAT(ABS(ROUND((TotalWages*100),0.01,'=')));

                    TWTEXT := '';
                    X := '';
                    Y := 0;
                    L := 0;

                    L := STRLEN(TEMPTotalWages);
                    Y := 1;
                    REPEAT;
                      X := COPYSTR(TEMPTotalWages,Y,1);
                      IF X <> ',' THEN BEGIN
                        TWTEXT := TWTEXT + X;
                      END;
                      Y := Y + 1;
                    UNTIL Y > L - 2;


                    TEMPTotalWages2 := FORMAT(ABS(ROUND((TotalWages*100),0.01,'=')));

                    TWTEXT2 := '';
                    X2 := '';
                    L2 := STRLEN(TEMPTotalWages2);
                    Y2 := (L2 - 1);
                    REPEAT;
                      X2 := COPYSTR(TEMPTotalWages2,Y2,1);
                        TWTEXT2 := TWTEXT2 + X2;
                      Y2 := Y2 + 1;
                    UNTIL Y2 > L2;

                    //REMOVE COMMA


                    //REMOVE COMMA   TotalContribution

                    TEMPTotalContribution := FORMAT(ABS(ROUND((TotalContribution*100),0.01,'=')));

                    TCTEXT := '';
                    X := '';
                    Y := 0;
                    L := 0;

                    L := STRLEN(TEMPTotalContribution);
                    Y := 1;
                    REPEAT;
                      X := COPYSTR(TEMPTotalContribution,Y,1);
                      IF X <> ',' THEN BEGIN
                        TCTEXT := TCTEXT + X;
                      END;
                      Y := Y + 1;
                    UNTIL Y > L - 2;


                    TEMPTotalContribution2 := FORMAT(ABS(ROUND((TotalContribution*100),0.01,'=')));



                    TCTEXT2 := '';
                    X2 := '';
                    L2 := STRLEN(TEMPTotalContribution2);
                    Y2 := (L2 - 1);
                    REPEAT;
                      X2 := COPYSTR(TEMPTotalContribution2,Y2,1);
                        TCTEXT2 := TCTEXT2 + X2;
                      Y2 := Y2 + 1;
                    UNTIL Y2 > L2;


                    //REMOVE COMMA


                    //REMOVE COMMA   MemberAdditional

                    IF ABS(MemberAdditional) > 0 THEN BEGIN
                      TEMPMemberAdditional := FORMAT(ABS(ROUND((MemberAdditional*100),0.01,'=')));

                      MATEXT := '';
                      X := '';
                      Y := 0;
                      L := 0;

                      L := STRLEN(TEMPMemberAdditional);
                      Y := 1;
                      REPEAT;
                        X := COPYSTR(TEMPMemberAdditional,Y,1);
                        IF X <> ',' THEN BEGIN
                          MATEXT := MATEXT + X;
                        END;
                        Y := Y + 1;
                      UNTIL Y > L - 2;


                      TempMemberAdditional2 := FORMAT(ABS(ROUND((MemberAdditional*100),0.01,'=')));

                      MATEXT2 := '';
                      X2 := '';
                      L2 := STRLEN(TempMemberAdditional2);
                      Y2 := (L2 - 1);
                      REPEAT;
                        X2 := COPYSTR(TempMemberAdditional2,Y2,1);
                          MATEXT2 := MATEXT2 + X2;
                        Y2 := Y2 + 1;
                      UNTIL Y2 > L2;
                    END;

                    //REMOVE COMMA


                    //REMOVE COMMA   EmployerAdditional

                    IF ABS(EmployerAdditional) > 0 THEN BEGIN
                      TEMPEmployerAdditional := FORMAT(ABS(ROUND((EmployerAdditional*100),0.01,'=')));

                      EATEXT := '';
                      X := '';
                      Y := 0;
                      L := 0;

                      L := STRLEN(TEMPEmployerAdditional);
                      Y := 1;
                      REPEAT;
                        X := COPYSTR(TEMPEmployerAdditional,Y,1);
                        IF X <> ',' THEN BEGIN
                          EATEXT := EATEXT + X;
                        END;
                        Y := Y + 1;
                      UNTIL Y > L - 2;


                      TEMPEmployerAdditional2 := FORMAT(ABS(ROUND((EmployerAdditional*100),0.01,'=')));

                      EATEXT2 := '';
                      X2 := '';
                      L2 := STRLEN(TEMPEmployerAdditional2);
                      Y2 := (L2 - 1);
                      REPEAT;
                        X2 := COPYSTR(TEMPEmployerAdditional2,Y2,1);
                          EATEXT2 := EATEXT2 + X2;
                        Y2 := Y2 + 1;
                      UNTIL Y2 > L2;
                    END;

                    //REMOVE COMMA

                    IF MemberAdditional = 0 THEN BEGIN
                      MATEXT := '0';
                      MATEXT2 := '00'
                    END;
                    IF EmployerAdditional = 0 THEN BEGIN
                      EATEXT := '0';
                      EATEXT2 := '00';
                    END;

                    //DETAIL


                    FNPFContributionSchedule.INIT;
                    FNPFContributionSchedule.RESET;
                    FNPFContributionSchedule.SETRANGE(Code, ('C' + FORMAT(LineNo)));
                    IF NOT FNPFContributionSchedule.FINDFIRST() THEN BEGIN
                      FNPFContributionSchedule.Code := ('C' + FORMAT(LineNo));
                      FNPFContributionSchedule.Print := '02' +
                                               TEXT002 + MemberNumber +
                                               TEXT002 + FirstName +
                                               TEXT002 + MiddleName +
                                               TEXT002 + LastName +
                                               TEXT002 + MemberTAX +
                                               TEXT002 + CCHTEXT + '.' + CCHTEXT2 +
                                               TEXT002 + EATEXT + '.' + EATEXT2 +
                                               TEXT002 + MATEXT + '.' + MATEXT2 +
                                               TEXT002 + TCTEXT + '.' + TCTEXT2 +
                                               TEXT002 + TWTEXT + '.' + TWTEXT2 +
                                               TEXT002 + TempEmployeeStatus +
                                               TEXT002 + SEDayText + '/' + SEmonthText + '/' + FORMAT(SEYear) +
                                               TEXT002 + OccupationCode +
                                               TEXT002 + FORMAT(TempPaymentFrequency);
                      FNPFContributionSchedule.INSERT;
                    END;
                  END;
            end;

            trigger OnPostDataItem();
            begin
                FNPFContributionSchedule.INIT;
                FNPFContributionSchedule.RESET;
                FNPFContributionSchedule.SETRANGE(Code, 'DFOOTER');
                IF NOT FNPFContributionSchedule.FINDFIRST() THEN BEGIN
                  FNPFContributionSchedule.Code := 'DFOOTER';
                  FNPFContributionSchedule.Print := '09' + TEXT002 + FORMAT(1 + NoEmployee + 1);
                  FNPFContributionSchedule.INSERT;
                END;
            end;

            trigger OnPreDataItem();
            begin
                FNPFContributionSchedule.INIT;
                FNPFContributionSchedule.RESET;
                FNPFContributionSchedule.DELETEALL;

                PAYRUN.INIT;
                PAYRUN.RESET;
                PAYRUN.SETRANGE("Tax Start Month", StartDate);
                PAYRUN.SETRANGE("Tax End Month", EndDate);
                PAYRUN.SETRANGE("Include In Pay Slip", TRUE);
                PAYRUN.SETRANGE("By Pass FNPF", FALSE);
                IF PAYRUN.FINDFIRST() THEN REPEAT
                  IF PAYRUN."Pay Type" = 0 THEN BEGIN
                    IF PAYRUN."Is FNPF Base" = TRUE THEN BEGIN
                      TotalWagesHeader := TotalWagesHeader + ROUND((PAYRUN.Amount), 0.01, '=');
                    END;
                  END;

                  IF PAYRUN."Is FNPF Field" = TRUE THEN BEGIN
                    TotalContributionHeader := TotalContributionHeader
                                              + ROUND(PAYRUN."Employer 10 Percent", 0.01, '=')
                                              + ROUND(PAYRUN."Employee 8 Percent", 0.01, '=')
                                              + ROUND(PAYRUN."Employer FNPF Additional", 0.01, '=')
                                              + ROUND(PAYRUN."Employee FNPF Additional", 0.01, '=');
                  END;
                UNTIL PAYRUN.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Date Filter")
                {
                    field("Start Date";StartDate)
                    {
                    }
                    field("End Date";EndDate)
                    {
                    }
                }
                group(Options)
                {
                    field("CS Due Date";CSDueDate)
                    {
                    }
                    field("Submission Date";SubmissionDate)
                    {
                    }
                    field("Contribution Month";ContributionMonth)
                    {
                    }
                    field("Contribution Year";ContributionYear)
                    {
                    }
                    field("Wages Month";WagesMonth)
                    {
                    }
                    field("Wages Year";WagesYear)
                    {
                    }
                    field("CS Code";CSCode)
                    {
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport();
    begin
        TempFileName := 'CS' + '_' +  TempContributionMonth + ContributionYear + '_' +
                         HRSETUP."Employer Reference No." + '_' + CSCode + '.txt';


        IF EXISTS(Path + TempFileName) THEN BEGIN
          ERASE(Path + TempFileName);
        END;

        XMLPT.FILENAME(Path + TempFileName);
        XMLPT.RUN;

        MESSAGE('File Created as ' + TempFileName);
    end;

    trigger OnPreReport();
    begin
        IF StartDate = 0D THEN BEGIN
          ERROR('Start Date should not be blank');
        END;
        IF EndDate = 0D THEN BEGIN
          ERROR('Finished Date should not be blank');
        END;

        mdt := FORMAT(TODAY);
        Month := COPYSTR(mdt,4,2);
        Year := '20'+COPYSTR(mdt,7,2);


        IF CompanyInfo.GET() THEN BEGIN
          IF CompanyInfo.Name = '' THEN BEGIN
            ERROR('Company Name not defined in the Company Information');
          END;
          IF CompanyInfo."Name 2" = '' THEN BEGIN
            CompanyInfo."Name 2" := CompanyInfo.Name;
            CompanyInfo.MODIFY;
          END;
        END;

        IF HRSETUP.GET() THEN BEGIN
          IF HRSETUP."Employer Reference No." = '' THEN BEGIN
            ERROR('Employer Reference No. not defined in Human Resources Setup');
          END;
          IF HRSETUP."FNPF Output Directory" = '' THEN BEGIN
            ERROR('FNPF Output Directory not setup in the Human Resources Setup');
          END;
          IF HRSETUP."FNPF Output Directory" <> '' THEN BEGIN
            Path := HRSETUP."FNPF Output Directory";
          END;
          IF HRSETUP."Current Payroll Year" = 0 THEN BEGIN
            ERROR('Payroll Year not created in Human Resources Setup');
          END;
          IF HRSETUP."Current Payroll Year" <> 0 THEN BEGIN
            IF Year <> FORMAT(HRSETUP."Current Payroll Year") THEN BEGIN
              MESSAGE('Payroll Year not created, Please Update');
            END;
          END;
        END;


        IF CSDueDate = 0D THEN BEGIN
          CSDueDate := TODAY;
        END;
        IF SubmissionDate = 0D THEN BEGIN
          SubmissionDate := TODAY;
        END;

        //VICKY ASHNEIL CHANDRA   18102014
        DDDay := DATE2DMY(CSDueDate, 1);
        DDayText := FORMAT(DDDay);
        DDMonth := DATE2DMY(CSDueDate, 2);
        DMonthText := FORMAT(DDMonth);
        DDYear := DATE2DMY(CSDueDate, 3);

        IF DDDay = 1 THEN BEGIN
          DDayText := '01';
        END;
        IF DDDay = 2 THEN BEGIN
          DDayText := '02';
        END;
        IF DDDay = 3 THEN BEGIN
          DDayText := '03';
        END;
        IF DDDay = 4 THEN BEGIN
          DDayText := '04';
        END;
        IF DDDay = 5 THEN BEGIN
          DDayText := '05';
        END;
        IF DDDay = 6 THEN BEGIN
          DDayText := '06';
        END;
        IF DDDay = 7 THEN BEGIN
          DDayText := '07';
        END;
        IF DDDay = 8 THEN BEGIN
          DDayText := '08';
        END;
        IF DDDay = 9 THEN BEGIN
          DDayText := '09';
        END;


        IF DDMonth = 1 THEN BEGIN
          DMonthText := '01';
        END;
        IF DDMonth = 2 THEN BEGIN
          DMonthText := '02';
        END;
        IF DDMonth = 3 THEN BEGIN
          DMonthText := '03';
        END;
        IF DDMonth = 4 THEN BEGIN
          DMonthText := '04';
        END;
        IF DDMonth = 5 THEN BEGIN
          DMonthText := '05';
        END;
        IF DDMonth = 6 THEN BEGIN
          DMonthText := '06';
        END;
        IF DDMonth = 7 THEN BEGIN
          DMonthText := '07';
        END;
        IF DDMonth = 8 THEN BEGIN
          DMonthText := '08';
        END;
        IF DDMonth = 9 THEN BEGIN
          DMonthText := '09';
        END;


        IF ContributionMonth = 0 THEN BEGIN
          TempContributionMonth := '01';
        END;
        IF ContributionMonth = 1 THEN BEGIN
          TempContributionMonth := '02';
        END;
        IF ContributionMonth = 2 THEN BEGIN
          TempContributionMonth := '03';
        END;
        IF ContributionMonth = 3 THEN BEGIN
          TempContributionMonth := '04';
        END;
        IF ContributionMonth = 4 THEN BEGIN
          TempContributionMonth := '05';
        END;
        IF ContributionMonth = 5 THEN BEGIN
          TempContributionMonth := '06';
        END;
        IF ContributionMonth = 6 THEN BEGIN
          TempContributionMonth := '07';
        END;
        IF ContributionMonth = 7 THEN BEGIN
          TempContributionMonth := '08';
        END;
        IF ContributionMonth = 8 THEN BEGIN
          TempContributionMonth := '09';
        END;
        IF ContributionMonth = 9 THEN BEGIN
          TempContributionMonth := '10';
        END;
        IF ContributionMonth = 10 THEN BEGIN
          TempContributionMonth := '11';
        END;
        IF ContributionMonth = 11 THEN BEGIN
          TempContributionMonth := '12';
        END;

        IF WagesMonth = 0 THEN BEGIN
          TempWagesMonth := '01';
        END;
        IF WagesMonth = 1 THEN BEGIN
          TempWagesMonth := '02';
        END;
        IF WagesMonth = 2 THEN BEGIN
          TempWagesMonth := '03';
        END;
        IF WagesMonth = 3 THEN BEGIN
          TempWagesMonth := '04';
        END;
        IF WagesMonth = 4 THEN BEGIN
          TempWagesMonth := '05';
        END;
        IF WagesMonth = 5 THEN BEGIN
          TempWagesMonth := '06';
        END;
        IF WagesMonth = 6 THEN BEGIN
          TempWagesMonth := '07';
        END;
        IF WagesMonth = 7 THEN BEGIN
          TempWagesMonth := '08';
        END;
        IF WagesMonth = 8 THEN BEGIN
          TempWagesMonth := '09';
        END;
        IF WagesMonth = 9 THEN BEGIN
          TempWagesMonth := '10';
        END;
        IF WagesMonth = 10 THEN BEGIN
          TempWagesMonth := '11';
        END;
        IF WagesMonth = 11 THEN BEGIN
          TempWagesMonth := '12';
        END;

        SDay := DATE2DMY(SubmissionDate, 1);
        SDayText := FORMAT(SDay);
        SMonth := DATE2DMY(SubmissionDate, 2);
        SmonthText := FORMAT(SMonth);
        SYear := DATE2DMY(SubmissionDate, 3);

        IF SDay = 1 THEN BEGIN
          SDayText := '01';
        END;
        IF SDay = 2 THEN BEGIN
          SDayText := '02';
        END;
        IF SDay = 3 THEN BEGIN
          SDayText := '03';
        END;
        IF SDay = 4 THEN BEGIN
          SDayText := '04';
        END;
        IF SDay = 5 THEN BEGIN
          SDayText := '05';
        END;
        IF SDay = 6 THEN BEGIN
          SDayText := '06';
        END;
        IF SDay = 7 THEN BEGIN
          SDayText := '07';
        END;
        IF SDay = 8 THEN BEGIN
          SDayText := '08';
        END;
        IF SDay = 9 THEN BEGIN
          SDayText := '09';
        END;


        IF SMonth = 1 THEN BEGIN
          SmonthText := '01';
        END;
        IF SMonth = 2 THEN BEGIN
          SmonthText := '02';
        END;
        IF SMonth = 3 THEN BEGIN
          SmonthText := '03';
        END;
        IF SMonth = 4 THEN BEGIN
          SmonthText := '04';
        END;
        IF SMonth = 5 THEN BEGIN
          SmonthText := '05';
        END;
        IF SMonth = 6 THEN BEGIN
          SmonthText := '06';
        END;
        IF SMonth = 7 THEN BEGIN
          SmonthText := '07';
        END;
        IF SMonth = 8 THEN BEGIN
          SmonthText := '08';
        END;
        IF SMonth = 9 THEN BEGIN
          SmonthText := '09';
        END;


        Employee.INIT;
        Employee.RESET;
        IF Employee.FINDFIRST() THEN REPEAT
          Employee."Print in FNPF" := FALSE;
          Employee.MODIFY;
        UNTIL Employee.NEXT = 0;

        PAYRUN.INIT;
        PAYRUN.RESET;
        PAYRUN.SETRANGE("Tax Start Month", StartDate);
        PAYRUN.SETRANGE("Tax End Month", EndDate);
        IF PAYRUN.FINDFIRST() THEN REPEAT
          Employee.INIT;
          Employee.RESET;
          Employee.SETRANGE("No.", PAYRUN."Employee No.");
          IF Employee.FINDFIRST() THEN BEGIN
            Employee."Print in FNPF" := TRUE;
            Employee.MODIFY;
          END;
        UNTIL PAYRUN.NEXT = 0;

        NoEmployee := 0;

        Employee.INIT;
        Employee.RESET;
        Employee.SETRANGE("Print in FNPF", TRUE);
        Employee.SETRANGE("By Pass FNPF", FALSE);
        IF Employee.FINDFIRST() THEN REPEAT
          NoEmployee := NoEmployee + 1;
        UNTIL Employee.NEXT = 0;
    end;

    var
        CSDueDate : Date;
        ContributionMonth : Option January,February,March,April,May,June,July,August,September,October,November,December;
        ContributionYear : Code[4];
        WagesMonth : Option January,February,March,April,May,June,July,August,September,October,November,December;
        WagesYear : Code[4];
        CSCode : Code[10];
        SubmissionDate : Date;
        TempContributionMonth : Code[2];
        TempWagesMonth : Code[2];
        MemberNumber : Text[30];
        FirstName : Text[30];
        MiddleName : Text[30];
        LastName : Text[30];
        MemberTAX : Text[30];
        EmployerAdditional : Decimal;
        MemberAdditional : Decimal;
        CompulsoryContribution : Decimal;
        TotalContribution : Decimal;
        LineNo : Integer;
        CompanyInfo : Record "Company Information";
        HRSETUP : Record "Human Resources Setup";
        EmploymentStatus : Integer;
        EmploymentStatusDate : Date;
        PaymentFrequency : Integer;
        NoEmployee : Integer;
        TotalWagesHeader : Decimal;
        TotalContributionHeader : Decimal;
        TotalWages : Decimal;
        TempEmployeeStatus : Code[10];
        OccupationCode : Code[10];
        TempPaymentFrequency : Code[10];
        TEMPTotalContributionHeader : Text[30];
        TEMPTotalContribution : Text[30];
        TEMPCompulsoryContribution : Text[30];
        TEMPTotalWagesHeader : Text[30];
        TEMPTotalWages : Text[30];
        TEMPMemberAdditional : Text[30];
        TEMPEmployerAdditional : Text[30];
        TCHTEXT : Text[30];
        CCHTEXT : Text[30];
        TCTEXT : Text[30];
        TWHTEXT : Text[30];
        TWTEXT : Text[30];
        MATEXT : Text[30];
        EATEXT : Text[30];
        X : Text[30];
        Y : Integer;
        L : Integer;
        TempFileName : Text[250];
        Path : Text[250];
        CCHTEXT2 : Text[30];
        TEMPCompulsoryContribution2 : Text[30];
        X2 : Text[30];
        Y2 : Integer;
        L2 : Integer;
        TEMPTotalContribution2 : Text[30];
        TCTEXT2 : Text[30];
        TEMPTotalWages2 : Text[30];
        TWTEXT2 : Text[30];
        TempMemberAdditional2 : Text[30];
        MATEXT2 : Text[30];
        TEMPEmployerAdditional2 : Text[30];
        EATEXT2 : Text[30];
        TEMPTotalContributionHeader2 : Text[30];
        TCHTEXT2 : Text[30];
        TEMPTotalWagesHeader2 : Text[30];
        TWHTEXT2 : Text[30];
        PAYRUN : Record "Pay Run";
        PAYRUNFILTER : Text[30];
        CALENDARFILTER : Text[30];
        BRANCHFILTER : Text[30];
        EmployeeTotalWages : Decimal;
        SDay : Integer;
        SMonth : Integer;
        SYear : Integer;
        SDayText : Text[30];
        SmonthText : Text[30];
        FNPFContributionSchedule : Record "FNPF Contribution Schedule";
        TEXT001 : Label '...........................................................................................';
        TEXT002 : Label '~';
        XMLPT : XMLport "FNPF Contribution Schedule";
        Month : Text[2];
        Year : Text[4];
        mdt : Text[30];
        StartDate : Date;
        EndDate : Date;
        TEXT003 : Label 'FIJI NATIONAL PROVIDENT FUND';
        TEXT004 : Label 'CONTRIBUTION SCHEDULE FORM';
        TEXT005 : Label 'Employer Reference No   :';
        TEXT006 : Label 'Employer Name   :';
        TEXT007 : Label 'Employer Trading Name   :';
        TEXT008 : Label 'Postal Address   :';
        TEXT009 : Label 'City   :';
        TEXT010 : Label 'Contribution Type   :';
        TEXT011 : Label 'Total Contribution   :';
        TEXT012 : Label 'Total Wages   :';
        TEXT013 : Label 'Total no. of Employees   :';
        TEXT014 : Label 'C S Due Date   :';
        TEXT015 : Label 'Contribution Month   :';
        TEXT016 : Label 'Contribution Year   :';
        TEXT017 : Label 'Wages Month   :';
        TEXT018 : Label 'Wages Year   :';
        TEXT019 : Label 'C S Code   :';
        TEXT020 : Label 'Line No.';
        TEXT021 : Label 'Member Number';
        TEXT022 : Label 'MEMBER''S FIRST NAME';
        TEXT023 : Label 'MEMBER''S MIDDLE NAME';
        TEXT024 : Label 'MEMBER''S LAST NAME';
        TEXT025 : Label 'MEMBER''S TAX ID No.';
        TEXT026 : Label 'Compulsory Contribution Amount';
        TEXT027 : Label 'Employer Additional Contribution Amount';
        TEXT028 : Label 'Member Additional Contribution Amount';
        TEXT029 : Label 'Total Contribution Amount';
        TEXT030 : Label 'Monthly Gross Salary';
        TEXT031 : TextConst ENA='Employment Status (1 = Active, 2 = On Leave, 3 = Terminated)';
        TEXT032 : Label 'Employment Status Date';
        TEXT033 : TextConst ENA='Payment Frequency (1 = Weekly, 2 = Fortnightly, 3 = Monthly)';
        TEXT034 : Label 'Employer Rep. Name:';
        TEXT035 : Label 'Employer Rep. Signature:';
        TEXT036 : Label 'Designation:';
        TEXT037 : Label 'Date:';
        ShiftCode : Option First,Second,Third,Fourth,Fifth;
        StatisticsGroupCode : Code[10];
        "Calendar Code" : Code[20];
        Employer10 : Decimal;
        Employee8 : Decimal;
        EmployerFNPFAdditional : Decimal;
        EmployeeFNPFAdditional : Decimal;
        DDDay : Integer;
        DDMonth : Integer;
        DDYear : Integer;
        DDayText : Text;
        DMonthText : Text;
        SEDay : Integer;
        SEMonth : Integer;
        SEYear : Integer;
        SEDayText : Text[30];
        SEmonthText : Text[30];
        EmployeeMaster : Record Employee;
}

