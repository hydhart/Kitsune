report 50220 "Employer Monthly Schedule"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employer Monthly Schedule.rdlc';

    dataset
    {
        dataitem(Employee;"Employee Pay Details")
        {
            DataItemTableView = ORDER(Ascending) WHERE(Print in EMS=FILTER(Yes));
            column(EmployeeTIN_Employee;Employee."Employee TIN")
            {
            }
            column(TaxCode_Employee;Employee."Tax Code")
            {
            }
            column(EmploymentStartDate_Employee;Employee."Employment Start Date")
            {
            }
            column(EmployeeName;EmployeeName)
            {
            }
            column(EmploymentEndDate;EmploymentEndDate)
            {
            }
            column(GrossAmount;GrossAmount)
            {
            }
            column(PAYEAmount;PAYEAmount)
            {
            }
            column(SRLAmount;SRLAmount)
            {
            }
            column(ECALAmount;ECALAmount)
            {
            }
            column(LumpSum;LumpSum)
            {
            }
            column(Redundancy;Redundancy)
            {
            }
            column(OtherPAYE;OtherPAYE)
            {
            }
            column(Allowance;Allowance)
            {
            }
            column(TotalPAYE;TotalPAYE)
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
            column(EmployerTIN;EmployerTIN)
            {
            }
            column(EmployerName;EmployerName)
            {
            }
            column(EmployerBranchNo;EmployerBranchNo)
            {
            }
            column(EndDate;EndDate)
            {
            }
            column(Today;TODAY)
            {
            }

            trigger OnAfterGetRecord();
            begin
                //VICKY ASHNEIL CHANDRA   10/11/2014
                IF EmployeeMaster.GET("No.") THEN BEGIN
                  EmployeeName := EmployeeMaster."First Name" + ' ' + EmployeeMaster."Middle Name" + ' ' + EmployeeMaster."Last Name";
                END;

                GrossAmount := 0;
                OtherPAYE := 0;
                PAYEAmount := 0;
                SRLAmount := 0;
                ECALAmount := 0;
                LumpSum := 0;
                Redundancy := 0;
                TotalPAYE := 0;

                IF "Employment End Date" = 0D THEN BEGIN
                  EmploymentEndDate := EndDate;
                  GrossAmount := 0;
                  OtherPAYE := 0;
                  PAYEAmount := 0;
                  SRLAmount := 0;
                  ECALAmount := 0;
                  LumpSum := 0;
                  Redundancy := 0;
                  TotalPAYE := 0;
                END;

                PayRun.INIT;
                PayRun.RESET;
                PayRun.SETRANGE("Tax Start Month", StartDate);
                PayRun.SETRANGE("Tax End Month", EndDate);
                PayRun.SETRANGE("Employee No.", "No.");
                IF PayRun.FINDFIRST() THEN REPEAT
                  IF FORMAT(PayRun."Pay Type") = 'Earnings' THEN BEGIN
                    GrossAmount := GrossAmount + (ROUND(PayRun.Amount, 0.01, '='));
                  END;

                  OtherPAYE := OtherPAYE + ABS(ROUND(PayRun."Other PAYE", 0.01, '='));

                  IF PayRun."Is PAYE Field" = TRUE THEN BEGIN
                    PAYEAmount := PAYEAmount + ABS(ROUND(PayRun.Amount, 0.01, '='));
                  END;
                  IF PayRun."Is SRT Field" = TRUE THEN BEGIN
                    SRLAmount := SRLAmount + ABS(ROUND(PayRun.Amount, 0.01, '='));
                  END;
                  IF PayRun."Is ECAL Field" = TRUE THEN BEGIN
                    ECALAmount := ECALAmount + ABS(ROUND(PayRun.Amount, 0.01, '='));
                  END;
                  IF PayRun."Lump Sum" = TRUE THEN BEGIN
                    LumpSum := LumpSum + ABS(ROUND(PayRun.Amount, 0.01, '='));
                  END;
                  IF PayRun.Redundancy = TRUE THEN BEGIN
                    Redundancy := Redundancy + ABS(ROUND(PayRun.Amount, 0.01, '='));
                  END;
                UNTIL PayRun.NEXT = 0;


                //-------------------------PAYE DETAILED BODY------------------
                EmployerMonthlySummary.INIT;
                EmployerMonthlySummary.RESET;
                EmployerMonthlySummary.SETRANGE(Code, 'BDETAIL' + FORMAT(LineNo));
                IF NOT EmployerMonthlySummary.FINDFIRST() THEN BEGIN
                  Counter := Counter + 1;
                  IF "Employee TIN" = '' THEN BEGIN
                    ERROR('Please Define TIN for Employee ' + "No.");
                  END;

                  IF "Employee TIN" <> '' THEN BEGIN

                    //---------------------------------------------------------
                    //----------------EMPLOYEE TIN-------------------
                    //----------------Remove HYPHEN-------------

                    TEMPEMPLOYEETINE := "Employee TIN";

                    MAMT := '';
                    X := '';
                    Y := 0;
                    L := 0;

                    L := STRLEN(TEMPEMPLOYEETINE);
                    Y := 1;
                    REPEAT;
                      X := COPYSTR(TEMPEMPLOYEETINE,Y,1);
                      IF X <> '-' THEN BEGIN
                        IF X <> '' THEN BEGIN
                          MAMT := MAMT + X;
                        END
                      END;
                      Y := Y + 1;
                    UNTIL Y > L;

                    TEMPEMPLOYEETINE := MAMT;
                    //----------------Remove HYPHEN-------------
                    //----------------Employee TIN ---------------------
                    //---------------------------------------------------------


                    //Employee FNPF
                    IF "Employee FNPF" <> '' THEN BEGIN
                      TempFNPFNo := "Employee FNPF";
                    END;

                    IF "Employee FNPF" = '' THEN BEGIN
                      TempFNPFNo := '00000000000';
                    END;

                    TempTaxCode := 'S';
                    EmploymentDate := 0D;
                    TerminatedDate := 0D;

                    IF "Tax Code" = 0 THEN BEGIN
                      TempTaxCode := 'S';
                    END;

                    IF "Tax Code" = 2 THEN BEGIN
                      TempTaxCode := 'S';
                    END;

                    IF "Tax Code" = 1  THEN BEGIN
                      TempTaxCode := 'P';
                    END;

                    IF "Employment Start Date" = 0D THEN BEGIN
                      ERROR('Please Define Employment Start Date for Employee ' + "No.");
                    END;

                    IF "Employment Start Date" <> 0D THEN BEGIN
                      EmploymentDate := "Employment Start Date";
                    END;

                    IF "Employment End Date" <> 0D THEN BEGIN
                      TerminatedDate := "Employment End Date";
                    END;

                    IF EmploymentDate <> 0D THEN BEGIN
                      IF EmploymentDate >= StartDate THEN BEGIN
                        IF EmploymentDate <= EndDate THEN BEGIN
                          Smdt:=FORMAT(EmploymentDate);
                          Smdt2:=COPYSTR(Smdt,1,2)+COPYSTR(Smdt,4,2)+'20'+COPYSTR(Smdt,7,2);
                          Smdt3 := COPYSTR(Smdt,1,2)+'/'+COPYSTR(Smdt,4,2)+'/20'+COPYSTR(Smdt,7,2);
                          TempEmploymentDate :=  Smdt2 ;
                        END;
                      END;
                      IF EmploymentDate < StartDate THEN BEGIN
                        Smdt:=FORMAT(StartDate);
                        Smdt2:=COPYSTR(Smdt,1,2)+COPYSTR(Smdt,4,2)+'20'+COPYSTR(Smdt,7,2);
                        Smdt3 := COPYSTR(Smdt,1,2)+'/'+COPYSTR(Smdt,4,2)+'/20'+COPYSTR(Smdt,7,2);
                        TempEmploymentDate :=  Smdt2 ;
                      END;
                      IF EmploymentDate > EndDate THEN BEGIN
                        ERROR('Incorrect Employment End Date for Employee ' + "No.");
                      END;
                    END;

                    IF TerminatedDate <> 0D THEN BEGIN
                      Emdt:=FORMAT(TerminatedDate);
                      Emdt2:=COPYSTR(Emdt,1,2)+COPYSTR(Emdt,4,2)+'20'+COPYSTR(Emdt,7,2);
                      Emdt3 := COPYSTR(Emdt,1,2)+'/'+COPYSTR(Emdt,4,2)+'/20'+COPYSTR(Emdt,7,2);
                      TempTerminatedDate :=  Emdt2 ;
                      EmploymentEndDate := TerminatedDate;
                    END;

                    IF TerminatedDate = 0D THEN BEGIN
                      Emdt:=FORMAT(EndDate);
                      Emdt2:=COPYSTR(Emdt,1,2)+COPYSTR(Emdt,4,2)+'20'+COPYSTR(Emdt,7,2);
                      Emdt3 := COPYSTR(Emdt,1,2)+'/'+COPYSTR(Emdt,4,2)+'/20'+COPYSTR(Emdt,7,2);
                      TempTerminatedDate :=  Emdt2 ;
                    END;
                  END;


                  //----------------FNPF Length Check---------------------

                  LengthAmount := STRLEN(TempFNPFNo);
                  IF LengthAmount = 11 THEN BEGIN
                    EmployeeFNPFNo := TempFNPFNo;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    EmployeeFNPFNo := '0' + TempFNPFNo;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    EmployeeFNPFNo := '00' + TempFNPFNo;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    EmployeeFNPFNo := '000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    EmployeeFNPFNo := '0000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    EmployeeFNPFNo := '00000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    EmployeeFNPFNo := '000000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    EmployeeFNPFNo := '0000000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    EmployeeFNPFNo := '00000000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    EmployeeFNPFNo := '000000000' + TempFNPFNo;
                  END;
                  IF LengthAmount = 1 THEN BEGIN
                    EmployeeFNPFNo := '0000000000' + TempFNPFNo;
                  END;
                  //------------------------------------------------------

                  //----------------Gross Amount-------------------
                  //----------------Remove Comma-------------

                  TempGrossAmount := FORMAT(ROUND(GrossAmount, 0.01, '=') * 100);
                  GGRossAmount :=  GGRossAmount + (ROUND(GrossAmount, 0.01));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempGrossAmount);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempGrossAmount,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------Gross Amount Length Check---------------------

                  TempGrossAmount := MAMT;


                  LengthAmount := STRLEN(TempGrossAmount);
                  IF LengthAmount = 1 THEN BEGIN
                    EmploymentIncome := '0000000000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    EmploymentIncome := '000000000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    EmploymentIncome := '00000000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    EmploymentIncome := '0000000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    EmploymentIncome := '000000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    EmploymentIncome := '00000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    EmploymentIncome := '0000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    EmploymentIncome := '000' + TempGrossAmount;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    EmploymentIncome := '00' + TempGrossAmount;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    EmploymentIncome := '0' + TempGrossAmount;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    EmploymentIncome := TempGrossAmount;
                  END;


                  //----------------Gross Amount Length Check---------------------


                  //----------------PAYE Amount-------------------
                  //----------------Remove Comma-------------

                  TempPAYE := FORMAT(ABS(ROUND(PAYEAmount, 0.01, '=') * 100));
                  TotalPAYE := TotalPAYE + (ABS(ROUND((PAYEAmount + OtherPAYE),0.01)));
                  GPAYE :=  GPAYE + ABS(ROUND((PAYEAmount), 0.01));


                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------PAYE Length Check---------------------

                  TempPAYE := MAMT;


                  LengthAmount := STRLEN(TempPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    PAYEFINAL := '0000000000' + TempPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    PAYEFINAL := '000000000' + TempPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    PAYEFINAL := '00000000' + TempPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    PAYEFINAL := '0000000' + TempPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    PAYEFINAL := '000000' + TempPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    PAYEFINAL := '00000' + TempPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    PAYEFINAL := '0000' + TempPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    PAYEFINAL := '000' + TempPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    PAYEFINAL := '00' + TempPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    PAYEFINAL := '0' + TempPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    PAYEFINAL := TempPAYE;
                  END;

                  //----------------PAYE Length Check---------------------


                  //----------------SLEVY Amount-------------------
                  //----------------Remove Comma-------------

                  TempSLEVY := FORMAT(ABS(ROUND(SRLAmount, 0.01, '=') * 100));
                  GSLEVY := GSLEVY + ABS(ROUND(SRLAmount,0.01));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempSLEVY);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempSLEVY,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------SLEVY Length Check---------------------
                  TempSLEVY := MAMT;

                  LengthAmount := STRLEN(TempSLEVY);
                  IF LengthAmount = 1 THEN BEGIN
                    SocialResponsibilityLevy := '0000000000' + TempSLEVY;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    SocialResponsibilityLevy := '000000000' + TempSLEVY;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    SocialResponsibilityLevy := '00000000' + TempSLEVY;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    SocialResponsibilityLevy := '0000000' + TempSLEVY;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    SocialResponsibilityLevy := '000000' + TempSLEVY;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    SocialResponsibilityLevy := '00000' + TempSLEVY;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    SocialResponsibilityLevy := '0000' + TempSLEVY;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    SocialResponsibilityLevy := '000' + TempSLEVY;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    SocialResponsibilityLevy := '00' + TempSLEVY;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    SocialResponsibilityLevy := '0' + TempSLEVY;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    SocialResponsibilityLevy := TempSLEVY;
                  END;
                  //----------------SLEVY Length Check---------------------


                  //----------------ECAL Amount-------------------
                  //----------------Remove Comma-------------

                  TempECAL := FORMAT(ABS(ROUND(ECALAmount, 0.01, '=') * 100));
                  GECAL := GECAL + ABS(ROUND(ECALAmount,0.01));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempECAL);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempECAL,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------ECAL Length Check---------------------
                  TempECAL := MAMT;

                  LengthAmount := STRLEN(TempECAL);
                  IF LengthAmount = 1 THEN BEGIN
                    EnvironmentClimateLevy := '0000000000' + TempECAL;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    EnvironmentClimateLevy := '000000000' + TempECAL;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    EnvironmentClimateLevy := '00000000' + TempECAL;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    EnvironmentClimateLevy := '0000000' + TempECAL;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    EnvironmentClimateLevy := '000000' + TempECAL;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    EnvironmentClimateLevy := '00000' + TempECAL;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    EnvironmentClimateLevy := '0000' + TempECAL;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    EnvironmentClimateLevy := '000' + TempECAL;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    EnvironmentClimateLevy := '00' + TempECAL;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    EnvironmentClimateLevy := '0' + TempECAL;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    EnvironmentClimateLevy := TempECAL;
                  END;
                  //----------------ECAL Length Check---------------------
                  //----------------Redundancy Amount-------------------
                  //----------------Remove Comma-------------

                  TempRedundancy := FORMAT(ABS(ROUND(Redundancy, 0.01, '=') * 100));
                  TotalOtherPAYE := TotalOtherPAYE + ABS(ROUND(Redundancy,0.01));
                  GRedundancy := GRedundancy + ABS(ROUND(Redundancy,0.01));


                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempRedundancy);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempRedundancy,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------Redundancy Length Check---------------------

                  TempRedundancy := MAMT;


                  LengthAmount := STRLEN(TempRedundancy);
                  IF LengthAmount = 1 THEN BEGIN
                    RedundancyFinal := '0000000000' + TempRedundancy;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    RedundancyFinal := '000000000' + TempRedundancy;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    RedundancyFinal := '00000000' + TempRedundancy;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    RedundancyFinal := '0000000' + TempRedundancy;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    RedundancyFinal := '000000' + TempRedundancy;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    RedundancyFinal := '00000' + TempRedundancy;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    RedundancyFinal := '0000' + TempRedundancy;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    RedundancyFinal := '000' + TempRedundancy;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    RedundancyFinal := '00' + TempRedundancy;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    RedundancyFinal := '0' + TempRedundancy;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    RedundancyFinal := TempRedundancy;
                  END;

                  //----------------Redundancy Length Check---------------------


                  //----------------Lump Sum Amount-------------------
                  //----------------Remove Comma-------------

                  TempLump := FORMAT(ABS(ROUND(LumpSum, 0.01, '=') * 100));
                  TotalOtherPAYE := TotalOtherPAYE + ABS(ROUND(LumpSum, 0.01));
                  GLump := GLump + ABS(ROUND(LumpSum, 0.01));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempLump);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempLump,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------Lump Sum Length Check---------------------

                  TempLump := MAMT;


                  LengthAmount := STRLEN(TempLump);
                  IF LengthAmount = 1 THEN BEGIN
                    LumpSumFinal := '0000000000' + TempLump;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    LumpSumFinal := '000000000' + TempLump;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    LumpSumFinal := '00000000' + TempLump;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    LumpSumFinal := '0000000' + TempLump;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    LumpSumFinal := '000000' + TempLump;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    LumpSumFinal := '00000' + TempLump;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    LumpSumFinal := '0000' + TempLump;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    LumpSumFinal := '000' + TempLump;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    LumpSumFinal := '00' + TempLump;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    LumpSumFinal := '0' + TempLump;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    LumpSumFinal := TempLump;
                  END;

                  //----------------Lump Sum Length Check---------------------


                  //----------------Other PAYE Amount-------------------
                  //----------------Remove Comma-------------

                  TempTotalOtherPAYE := FORMAT(ABS(ROUND(OtherPAYE, 0.01, '=') * 100));
                  TotalPAYE := TotalPAYE;
                  GTotalOtherPAYE := GTotalOtherPAYE + ABS(ROUND(OtherPAYE,0.01));


                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempTotalOtherPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempTotalOtherPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------Other PAYE Length Check---------------------

                  TempTotalOtherPAYE := MAMT;


                  LengthAmount := STRLEN(TempTotalOtherPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    OtherPAYEFinal := '0000000000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    OtherPAYEFinal := '000000000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    OtherPAYEFinal := '00000000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    OtherPAYEFinal := '0000000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    OtherPAYEFinal := '000000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    OtherPAYEFinal := '00000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    OtherPAYEFinal := '0000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    OtherPAYEFinal := '000' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    OtherPAYEFinal := '00' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    OtherPAYEFinal := '0' + TempTotalOtherPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    OtherPAYEFinal := TempTotalOtherPAYE;
                  END;

                  //----------------Total Other PAYE Length Check---------------------

                  //----------------Total PAYE Amount-------------------
                  //----------------Remove Comma-------------

                  TempTotalPAYE := FORMAT(ABS(ROUND(TotalPAYE, 0.01, '=') * 100));
                  GTotalPAYE := GTotalPAYE + ABS(ROUND(TotalPAYE,0.01));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(TempTotalPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TempTotalPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                  //----------------Remove Comma-------------

                  //----------------Total PAYE Length Check---------------------

                  TempTotalPAYE := MAMT;

                  LengthAmount := STRLEN(TempTotalPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalPAYEFinal := '0000000000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalPAYEFinal := '000000000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalPAYEFinal := '00000000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalPAYEFinal := '0000000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalPAYEFinal := '000000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalPAYEFinal := '00000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalPAYEFinal := '0000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalPAYEFinal := '000' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalPAYEFinal := '00' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalPAYEFinal := '0' + TempTotalPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalPAYEFinal := TempTotalPAYE;
                  END;

                  //----------------Total PAYE Length Check---------------------
                  EmployerMonthlySummary.Code := 'BDETAIL' + FORMAT(LineNo);
                  EmployerMonthlySummary.Print := 'D' + TEMPEMPLOYEETINE + EmployeeFNPFNo + TempTaxCode + TempEmploymentDate + TempTerminatedDate
                                  + TEXT016 + EmploymentIncome + PAYEFINAL + SocialResponsibilityLevy + RedundancyFinal + LumpSumFinal
                                  + OtherPAYEFinal + TotalPAYEFinal + EnvironmentClimateLevy + TEXT009 + TEXT008;
                  LineNo := LineNo + 1;
                  EmployerMonthlySummary.INSERT;


                  //-------------------------PAYE DETAILED BODY------------------

                END;
                //VICKY ASHNEIL CHANDRA   10/11/2014
            end;

            trigger OnPostDataItem();
            begin

                //-------------------------PAYE FOOTER-------------

                EmployerMonthlySummary.INIT;
                EmployerMonthlySummary.RESET;
                EmployerMonthlySummary.SETRANGE(Code, 'CFOOTER');
                IF NOT EmployerMonthlySummary.FINDFIRST() THEN BEGIN

                //----------------Counter Length Check---------------------
                  TempCounter := FORMAT(Counter);

                  LengthAmount := STRLEN(TempCounter);
                  IF LengthAmount = 1 THEN BEGIN
                    CountDetails  := '000000' + TempCounter;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    CountDetails  := '00000' + TempCounter;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    CountDetails  := '0000' + TempCounter;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    CountDetails  := '000' + TempCounter;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    CountDetails  := '00' + TempCounter;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    CountDetails  := '0' + TempCounter;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    CountDetails  := TempCounter;
                  END;
                //----------------Counter Length Check---------------------


                //----------------Grand Gross Amount-------------------
                //----------------Remove Comma-------------

                GTempGrossAmount := FORMAT(ABS(ROUND(GGRossAmount, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempGrossAmount);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempGrossAmount,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand Gross Length Check---------------------

                  GTempGrossAmount := MAMT;


                  LengthAmount := STRLEN(GTempGrossAmount);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalEmploymentIncome := '0000000000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalEmploymentIncome := '000000000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalEmploymentIncome := '00000000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalEmploymentIncome := '0000000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalEmploymentIncome := '000000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalEmploymentIncome := '00000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalEmploymentIncome := '0000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalEmploymentIncome := '000' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalEmploymentIncome := '00' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalEmploymentIncome := '0' + GTempGrossAmount;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalEmploymentIncome := GTempGrossAmount;
                  END;

                //----------------Grand Gross Length Check---------------------


                //----------------Grand PAYE Amount-------------------
                //----------------Remove Comma-------------

                GTempPAYE := FORMAT(ABS(ROUND(GPAYE, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand PAYE Length Check---------------------

                  GTempPAYE := MAMT;


                  LengthAmount := STRLEN(GTempPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    PAYEDeducted := '0000000000' + GTempPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    PAYEDeducted := '000000000' + GTempPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    PAYEDeducted := '00000000' + GTempPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    PAYEDeducted := '0000000' + GTempPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    PAYEDeducted := '000000' + GTempPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    PAYEDeducted := '00000' + GTempPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    PAYEDeducted := '0000' + GTempPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    PAYEDeducted := '000' + GTempPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    PAYEDeducted := '00' + GTempPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    PAYEDeducted := '0' + GTempPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    PAYEDeducted := GTempPAYE;
                  END;

                //----------------Grand PAYE Length Check---------------------


                //----------------Grand SLEVY Amount-------------------
                //----------------Remove Comma-------------

                GTempSLEVY := FORMAT(ABS(ROUND(GSLEVY, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempSLEVY);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempSLEVY,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand SLEVY Length Check---------------------

                  GTempSLEVY := MAMT;


                  LengthAmount := STRLEN(GTempSLEVY);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalSocialRespLevy := '0000000000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalSocialRespLevy := '000000000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalSocialRespLevy := '00000000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalSocialRespLevy := '0000000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalSocialRespLevy := '000000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalSocialRespLevy := '00000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalSocialRespLevy := '0000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalSocialRespLevy := '000' + GTempSLEVY;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalSocialRespLevy := '00' + GTempSLEVY;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalSocialRespLevy := '0' + GTempSLEVY;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalSocialRespLevy := GTempSLEVY;
                  END;

                //----------------Grand Redundancy Length Check---------------------


                //----------------Grand ECAL Amount-------------------
                //----------------Remove Comma-------------

                GTempECAL := FORMAT(ABS(ROUND(GECAL, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempECAL);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempECAL,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand SLEVY Length Check---------------------

                  GTempECAL := MAMT;


                  LengthAmount := STRLEN(GTempECAL);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalEnvironmentClimateLevy := '0000000000' + GTempECAL;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalEnvironmentClimateLevy := '000000000' + GTempECAL;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalEnvironmentClimateLevy := '00000000' + GTempECAL;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalEnvironmentClimateLevy := '0000000' + GTempECAL;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalEnvironmentClimateLevy := '000000' + GTempECAL;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalEnvironmentClimateLevy := '00000' + GTempECAL;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalEnvironmentClimateLevy := '0000' + GTempECAL;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalEnvironmentClimateLevy := '000' + GTempECAL;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalEnvironmentClimateLevy := '00' + GTempECAL;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalEnvironmentClimateLevy := '0' + GTempECAL;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalEnvironmentClimateLevy := GTempECAL;
                  END;

                //----------------Grand SLEVY Length Check---------------------

                //----------------Grand Redundancy Length Check---------------------

                //----------------Grand Redundancy Amount-------------------
                //----------------Remove Comma-------------

                GTempRedundancy := FORMAT(ABS(ROUND(Redundancy, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempRedundancy);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempRedundancy,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand Redundancy Length Check---------------------

                  GTempRedundancy := MAMT;


                  LengthAmount := STRLEN(GTempRedundancy);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalRedundancy := '0000000000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalRedundancy := '000000000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalRedundancy := '00000000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalRedundancy := '0000000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalRedundancy := '000000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalRedundancy := '00000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalRedundancy := '0000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalRedundancy := '000' + GTempRedundancy;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalRedundancy := '00' + GTempRedundancy;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalRedundancy := '0' + GTempRedundancy;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalRedundancy := GTempRedundancy;
                  END;

                //----------------Grand Redundancy Length Check---------------------


                //----------------Grand Lump Sum Amount-------------------
                //----------------Remove Comma-------------

                GTempLump := FORMAT(ABS(ROUND(GLump, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempLump);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempLump,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand Lump Sum Length Check---------------------

                  GTempLump := MAMT;


                  LengthAmount := STRLEN(GTempLump);
                  IF LengthAmount = 1 THEN BEGIN
                    TotalLumpSum := '0000000000' + GTempLump;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TotalLumpSum := '000000000' + GTempLump;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TotalLumpSum := '00000000' + GTempLump;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TotalLumpSum := '0000000' + GTempLump;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TotalLumpSum := '000000' + GTempLump;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TotalLumpSum := '00000' + GTempLump;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TotalLumpSum := '0000' + GTempLump;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TotalLumpSum := '000' + GTempLump;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TotalLumpSum := '00' + GTempLump;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    TotalLumpSum := '0' + GTempLump;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    TotalLumpSum := GTempLump;
                  END;

                //----------------Grand Lump Sum Length Check---------------------


                //----------------Grand Other PAYE Sum Amount-------------------
                //----------------Remove Comma-------------

                GTempOtherPAYE := FORMAT(ABS(ROUND(GTotalOtherPAYE, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempOtherPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempOtherPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand Other PAYE Length Check---------------------

                  GTempOtherPAYE := MAMT;


                  LengthAmount := STRLEN(GTempOtherPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    FOtherPAYE := '0000000000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    FOtherPAYE := '000000000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    FOtherPAYE := '00000000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    FOtherPAYE := '0000000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    FOtherPAYE := '000000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    FOtherPAYE := '00000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    FOtherPAYE := '0000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    FOtherPAYE := '000' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    FOtherPAYE := '00' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    FOtherPAYE := '0' + GTempOtherPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    FOtherPAYE := GTempOtherPAYE;
                  END;

                //----------------Grand Other PAYE Length Check---------------------


                //----------------Grand Total PAYE Sum Amount-------------------
                //----------------Remove Comma-------------

                GTempTotalPAYE := FORMAT(ABS(ROUND(GTotalPAYE, 0.01, '=') * 100));

                  MAMT := '';
                  X := '';
                  Y := 0;
                  L := 0;

                  L := STRLEN(GTempTotalPAYE);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(GTempTotalPAYE,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                //----------------Grand Total PAYE Length Check---------------------

                  GTempTotalPAYE := MAMT;


                  LengthAmount := STRLEN(GTempTotalPAYE);
                  IF LengthAmount = 1 THEN BEGIN
                    FTotalPAYE := '0000000000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    FTotalPAYE := '000000000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    FTotalPAYE := '00000000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    FTotalPAYE := '0000000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    FTotalPAYE := '000000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    FTotalPAYE := '00000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    FTotalPAYE := '0000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    FTotalPAYE := '000' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    FTotalPAYE := '00' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    FTotalPAYE := '0' + GTempTotalPAYE;
                  END;
                  IF LengthAmount = 11 THEN BEGIN
                    FTotalPAYE := GTempTotalPAYE;
                  END;

                //----------------Grand Total PAYE Length Check---------------------

                  EmployerMonthlySummary.Code := 'CFOOTER';
                  EmployerMonthlySummary.Print := 'T' + CountDetails + TotalEmploymentIncome + PAYEDeducted + TotalSocialRespLevy + TotalRedundancy +
                                                 TotalLumpSum + FOtherPAYE + FTotalPAYE + TotalEnvironmentClimateLevy + TEXT007 + TEXT008;

                  EmployerMonthlySummary.INSERT;
                END;
                //-------------------------PAYE FOOTER-------------
            end;

            trigger OnPreDataItem();
            begin
                LineNo := 1;
                Counter := 0;
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
                    field("Sequence No.";SequenceNo)
                    {
                        CaptionML = ENU='Sequence No.',
                                    ENA='Sequence No.';
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
        DPDate := EndDate;

        mdt := FORMAT(DPDate);
        Month := COPYSTR(mdt,4,2);
        Year := '20'+COPYSTR(mdt,7,2);

        TempFileName := EmployerTIN + '-' + FileBranch + '-' + Year + '-' + Month + '-' + FORMAT(SequenceNo) +'.TXT';

        IF EXISTS(Path + TempFileName) THEN BEGIN
          ERASE(Path + TempFileName);
        END;

        XMLPT.FILENAME(Path + TempFileName);
        XMLPT.RUN;

        MESSAGE('File Created as ' + TempFileName);
    end;

    trigger OnPreReport();
    begin
        //VICKY ASHNEIL CHANDRA   10/11/2014

        //VICKY ASHNEIL CHANDRA   11/11/201
        EmployerBranchNo := '';
        EmployerName := '';
        EmployerTIN := '';
        DPDate := EndDate;
        //VICKY ASHNEIL CHANDRA   11/11/201

        IF SequenceNo = 0 THEN BEGIN
          ERROR('Sequence No. should not be blank');
        END;

        IF StartDate = 0D THEN BEGIN
          ERROR('Start Date should not be blank');
        END;
        IF EndDate = 0D THEN BEGIN
          ERROR('Finished Date should not be blank');
        END;

        IF CompanyInfo.GET() THEN BEGIN
          IF CompanyInfo.Name = '' THEN BEGIN
            ERROR('Company Name not defined in the Company Information');
          END;
          IF CompanyInfo."VAT Registration No." = '' THEN BEGIN
            ERROR('Employer TIN No. not setup in the Company Information');
          END;
          IF CompanyInfo.Name <> '' THEN BEGIN
            EmployerName := CompanyInfo.Name;
          END;
        END;

        IF HRSETUP.GET() THEN BEGIN
          IF HRSETUP."Employer Branch No." = 0 THEN BEGIN
            ERROR('Employer Branch No. not setup in the Human Resources Setup');
          END;
          IF HRSETUP."PAYE Output Directory" = '' THEN BEGIN
            ERROR('PAYE Output Directory not setup in the Human Resources Setup');
          END;
          //VICKY ASHNEIL CHANDRA   11/11/2014
          IF HRSETUP."Employer TIN No." <> '' THEN BEGIN
            EmployerTIN := HRSETUP."Employer TIN No.";
          END;
          IF HRSETUP."Employer Branch No." <> 0 THEN BEGIN
            EmployerBranchNo := FORMAT(HRSETUP."Employer Branch No.");
          END;
          IF HRSETUP."PAYE Output Directory" <> '' THEN BEGIN
            Path := HRSETUP."PAYE Output Directory";
          END;
        END;

        mdt := FORMAT(DPDate);
        Month := COPYSTR(mdt,4,2);
        Year := '20'+COPYSTR(mdt,7,2);

        IF HRSETUP."Current Payroll Year" = 0 THEN BEGIN
          ERROR('Payroll Year not created in Human Resources Setup');
        END;

        IF HRSETUP."Current Payroll Year" <> 0 THEN BEGIN
          IF Year <> FORMAT(HRSETUP."Current Payroll Year") THEN BEGIN
            MESSAGE('Payroll Year not created, Please Update');
          END;
        END;


        Employee.INIT;
        Employee.RESET;
        IF Employee.FINDFIRST() THEN REPEAT
          Employee."Print in EMS" := FALSE;
          Employee.MODIFY;
        UNTIL Employee.NEXT = 0;

        PayRun.INIT;
        PayRun.RESET;
        PayRun.SETRANGE("Tax Start Month", StartDate);
        PayRun.SETRANGE("Tax End Month", EndDate);
        IF PayRun.FINDFIRST() THEN REPEAT
          Employee.INIT;
          Employee.RESET;
          Employee.SETRANGE("No.", PayRun."Employee No.");
          IF Employee.FINDFIRST() THEN BEGIN
            Employee."Print in EMS" := TRUE;
            Employee.MODIFY;
          END;
        UNTIL PayRun.NEXT = 0;



        //-------------------------PAYE Header-------------
        EmployerMonthlySummary.INIT;
        EmployerMonthlySummary.RESET;
        EmployerMonthlySummary.DELETEALL;

        EmployerMonthlySummary.INIT;
        EmployerMonthlySummary.RESET;
        EmployerMonthlySummary.SETRANGE(Code, 'AHEADER');
        IF NOT EmployerMonthlySummary.FINDFIRST() THEN BEGIN

          //----------------Employer Branch No. Length Check---------------------
          "TempBranchNo." := FORMAT(EmployerBranchNo);

          LengthAmount := STRLEN("TempBranchNo.");
          IF LengthAmount = 1 THEN BEGIN
            FileBranch := '00' + "TempBranchNo.";
          END;
          IF LengthAmount = 2 THEN BEGIN
            FileBranch := '0' + "TempBranchNo.";
          END;
          IF LengthAmount = 3 THEN BEGIN
            FileBranch := "TempBranchNo.";
          END;

          //----------------Employer Branch No. Length Check---------------------
          EmployerMonthlySummary.Code := 'AHEADER';
          EmployerMonthlySummary.Print := 'H' + 'PAYE' + Year + Month + EmployerTIN + FileBranch + TEXT006 + TEXT008;
          EmployerMonthlySummary.INSERT;
        END;
          //-------------------------PAYE Header-------------

        //VICKY ASHNEIL CHANDRA   11/11/2014

        //VICKY ASHNEIL CHANDRA   10/11/2014
    end;

    var
        PayRun : Record "Pay Run";
        EmployeeName : Text[100];
        EmploymentEndDate : Date;
        StartDate : Date;
        EndDate : Date;
        GrossAmount : Decimal;
        PAYEAmount : Decimal;
        SRLAmount : Decimal;
        ECALAmount : Decimal;
        Redundancy : Decimal;
        LumpSum : Decimal;
        OtherPAYE : Decimal;
        Allowance : Decimal;
        TotalPAYE : Decimal;
        TotalDeduction : Decimal;
        CompanyInfo : Record "Company Information";
        HRSETUP : Record "Human Resources Setup";
        EmployerTIN : Text[9];
        EmployerName : Text[50];
        EmployerBranchNo : Text[3];
        TEXT001 : Label 'EMPLOYER MONTHLY SUMMARY';
        TEXT002 : Label 'TIN:';
        TEXT003 : Label 'NAME:';
        TEXT004 : Label 'BRANCH NO:';
        TEXT005 : Label 'PERIOD ENDING:';
        TEXT006 : TextConst ENU='                                                                                                                                                                                                                                  ',ENA='                                                                                                     ';
        TEXT007 : TextConst ENU='                                                                                                                                                         ',ENA='                                       ';
        TEXT008 : Label '0';
        TEXT009 : TextConst ENU='                                                                                                                          ',ENA='       ';
        TEXT010 : Label 'TOTAL';
        TEXT011 : Label 'DECLARATION';
        TEXT012 : Label 'I declare that the information given in this return is true and correct.';
        TEXT013 : Label 'Signature';
        TEXT014 : Label 'Date';
        TEXT015 : Label '(ACCOUNTABLE PERSON)';
        DPDate : Date;
        Month : Text[2];
        Year : Text[4];
        mdt : Text[30];
        EmployerMonthlySummary : Record "Employer Monthly Summary";
        TEXT016 : Label '" "';
        "TempBranchNo." : Text[3];
        LengthAmount : Integer;
        FileBranch : Text[3];
        TEMPEMPLOYEETINE : Text[30];
        MAMT : Text[30];
        L : Integer;
        Y : Integer;
        X : Text[30];
        TempFNPFNo : Text[11];
        TempTaxCode : Text[1];
        EmploymentDate : Date;
        TerminatedDate : Date;
        Smdt : Text[30];
        Smdt2 : Text[30];
        Smdt3 : Text[30];
        Emdt : Text[30];
        Emdt2 : Text[30];
        Emdt3 : Text[30];
        TempEmploymentDate : Text[8];
        TempTerminatedDate : Text[8];
        EmployeeFNPFNo : Text[11];
        GGRossAmount : Decimal;
        TempGrossAmount : Text[11];
        EmploymentIncome : Text[11];
        TempPAYE : Text[11];
        TempECAL : Text;
        TempSLEVY : Text[11];
        TempRedundancy : Text[11];
        TempLump : Text[11];
        PAYEFINAL : Text[11];
        SocialResponsibilityLevy : Text[11];
        EnvironmentClimateLevy : Text;
        RedundancyFinal : Text[11];
        LumpSumFinal : Text[11];
        TempTotalOtherPAYE : Text[11];
        OtherPAYEFinal : Text[11];
        TempTotalPAYE : Text[11];
        TotalPAYEFinal : Text[11];
        LineNo : Integer;
        TempCounter : Text[7];
        CountDetails : Text[7];
        TotalEmploymentIncome : Text[11];
        Counter : Integer;
        GTempGrossAmount : Text[11];
        GTempPAYE : Text[11];
        GTempSLEVY : Text[11];
        GTempECAL : Text;
        GTempRedundancy : Text[11];
        GTempLump : Text[11];
        GTempOtherPAYE : Text[11];
        GTempTotalPAYE : Text[11];
        GPAYE : Decimal;
        GSLEVY : Decimal;
        GECAL : Decimal;
        GRedundancy : Decimal;
        GLump : Decimal;
        GTotalOtherPAYE : Decimal;
        GTotalPAYE : Decimal;
        PAYEDeducted : Text[11];
        TotalSocialRespLevy : Text[11];
        TotalEnvironmentClimateLevy : Text;
        TotalRedundancy : Text[11];
        TotalLumpSum : Text[11];
        FOtherPAYE : Text[11];
        FTotalPAYE : Text[11];
        TotalOtherPAYE : Decimal;
        SequenceNo : Integer;
        Path : Text[250];
        TempFileName : Text[250];
        XMLPT : XMLport "Employer Monthly Schedule";
        EmployeeMaster : Record Employee;
}

