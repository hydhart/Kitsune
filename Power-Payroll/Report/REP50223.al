report 50223 "Electronic Banking WBC"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Electronic Banking WBC.rdlc';

    dataset
    {
        dataitem("Bank Pay Distribution";"Bank Pay Distribution")
        {
            DataItemTableView = SORTING(Employee No.,Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Sequence,Is Balance,Employee Bank Account No.) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.";

            trigger OnAfterGetRecord();
            begin
                //-------------------------Body Record----------------
                IF Employee.GET("Employee No.") THEN BEGIN
                  IF PayrollBankMaster.GET("Bank Code") THEN BEGIN
                    DBank := PayrollBankMaster."Bank No.";
                    DBranch := PayrollBankMaster."Bank Branch No.";
                  END;
                END;

                IF STRLEN(DBank) <> 2 THEN BEGIN
                  ERROR('Bank number in Detail should be 2 digits long');
                END;

                IF STRLEN(DBranch) <> 3 THEN BEGIN
                  ERROR('Branch number in Detail should be 3 digits long');
                END;


                DAccount := "Employee Bank Account No.";

                 TempName := DAccount;

                //----------------Name Length Check---------------------
                  Namelength := STRLEN(TempName);
                  IF Namelength = 12 THEN BEGIN
                    DAccount := TempName;
                  END;
                  IF Namelength = 11 THEN BEGIN
                    DAccount := '0' + TempName;
                  END;
                  IF Namelength = 10 THEN BEGIN
                    DAccount := '00' + TempName;
                  END;
                  IF Namelength = 9 THEN BEGIN
                    DAccount := '000' + TempName;
                  END;
                  IF Namelength = 8 THEN BEGIN
                    DAccount := '0000' + TempName;
                  END;
                  IF Namelength = 7 THEN BEGIN
                    DAccount := '00000' + TempName;
                  END;
                  IF Namelength = 6 THEN BEGIN
                    DAccount := '000000' + TempName;
                  END;
                  IF Namelength = 5 THEN BEGIN
                    DAccount := '0000000' + TempName;
                  END;
                  IF Namelength = 4 THEN BEGIN
                    DAccount := '00000000' + TempName;
                  END;
                  IF Namelength = 3 THEN BEGIN
                    DAccount := '000000000' + TempName;
                  END;
                  IF Namelength = 2 THEN BEGIN
                    DAccount := '000000000' + TempName;
                  END;
                  IF Namelength = 1 THEN BEGIN
                    DAccount := '0000000000' + TempName;
                  END;
                //----------------Name Length Check---------------------

                  NetAmount := NetAmount + ROUND("Pay Run Amount", 0.01, '=');;

                  AmountTemp := FORMAT(ROUND("Pay Run Amount",0.01) * 100);

                //----------------Remove Comma-------------
                  MAMT := '';
                  L := STRLEN(AmountTemp);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(AmountTemp,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------


                  AmountTemp := MAMT;

                //----------------Amount Length Check---------------------
                  LengthAmount := STRLEN(AmountTemp);
                  IF LengthAmount = 1 THEN BEGIN
                    DAmount := '000000000' + AmountTemp;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    DAmount := '00000000' + AmountTemp;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    DAmount := '0000000' + AmountTemp;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    DAmount := '000000' + AmountTemp;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    DAmount := '00000' + AmountTemp;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    DAmount := '0000' + AmountTemp;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    DAmount := '000' + AmountTemp;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    DAmount := '00' + AmountTemp;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    DAmount := '0' + AmountTemp;
                  END;
                //----------------Amount Length Check---------------------

                 TempName := COPYSTR("Employee Name",1,20);

                //----------------Name Length Check---------------------
                  Namelength := STRLEN(TempName);
                  IF Namelength = 20 THEN BEGIN
                    DTPName := TempName;
                  END;
                  IF Namelength = 19 THEN BEGIN
                    DTPName := TempName + ' ';
                  END;
                  IF Namelength = 18 THEN BEGIN
                    DTPName := TempName + '  ';
                  END;
                  IF Namelength = 17 THEN BEGIN
                    DTPName := TempName + '   ';
                  END;
                  IF Namelength = 16 THEN BEGIN
                    DTPName := TempName + '    ';
                  END;
                  IF Namelength = 15 THEN BEGIN
                    DTPName := TempName + '     ';
                  END;
                  IF Namelength = 14 THEN BEGIN
                    DTPName := TempName + '      ';
                  END;
                  IF Namelength = 13 THEN BEGIN
                    DTPName := TempName + '       ';
                  END;
                  IF Namelength = 12 THEN BEGIN
                    DTPName := TempName + '        ';
                  END;
                  IF Namelength = 11 THEN BEGIN
                    DTPName := TempName + '         ';
                  END;
                  IF Namelength = 10 THEN BEGIN
                    DTPName := TempName + '          ';
                  END;
                  IF Namelength = 9 THEN BEGIN
                    DTPName := TempName + '           ';
                  END;
                  IF Namelength = 8 THEN BEGIN
                    DTPName := TempName + '            ';
                  END;
                  IF Namelength = 7 THEN BEGIN
                    DTPName := TempName + '             ';
                  END;
                  IF Namelength = 6 THEN BEGIN
                    DTPName := TempName + '              ';
                  END;
                  IF Namelength = 5 THEN BEGIN
                    DTPName := TempName + '               ';
                  END;
                  IF Namelength = 4 THEN BEGIN
                    DTPName := TempName + '                ';
                  END;
                  IF Namelength = 3 THEN BEGIN
                    DTPName := TempName + '                 ';
                  END;
                  IF Namelength = 2 THEN BEGIN
                    DTPName := TempName + '                  ';
                  END;
                  IF Namelength = 1 THEN BEGIN
                    DTPName := TempName + '                   ';
                  END;
                //----------------Name Length Check---------------------


                LineNo := LineNo + 1;



                L := STRLEN(FORMAT(LineNo));
                IF L=1 THEN BEGIN
                  DTPReference1 := '00000000000' + FORMAT(LineNo);
                END;
                IF L=2 THEN BEGIN
                  DTPReference1 := '0000000000' + FORMAT(LineNo);
                END;
                IF L=3 THEN BEGIN
                  DTPReference1 := '000000000' + FORMAT(LineNo);
                END;
                IF L=4 THEN BEGIN
                  DTPReference1 := '00000000' + FORMAT(LineNo);
                END;
                IF L=5 THEN BEGIN
                  DTPReference1 := '0000000' + FORMAT(LineNo);
                END;
                IF L=6 THEN BEGIN
                  DTPReference1 := '000000' + FORMAT(LineNo);
                END;
                IF L=7 THEN BEGIN
                  DTPReference1 := '00000' + FORMAT(LineNo);
                END;
                IF L=8 THEN BEGIN
                  DTPReference1 := '0000' + FORMAT(LineNo);
                END;
                IF L=9 THEN BEGIN
                  DTPReference1 := '000' + FORMAT(LineNo);
                END;
                IF L=10 THEN BEGIN
                  DTPReference1 := '00' + FORMAT(LineNo);
                END;
                IF L=11 THEN BEGIN
                  DTPReference1 := '0' + FORMAT(LineNo);
                END;
                IF L=12 THEN BEGIN
                  DTPReference1 := FORMAT(LineNo);
                END;


                DOPName := HName;

                ElectronicBanking.INIT;
                ElectronicBanking.RESET;
                ElectronicBanking.SETRANGE(Code, 'BDETAIL' + FORMAT(LineNo));
                IF NOT ElectronicBanking.FINDFIRST() THEN BEGIN

                  ElectronicBanking.Code := 'BDETAIL' + FORMAT(LineNo);
                  ElectronicBanking."Print 162" := DRecordType + DBank + DState + DBranch + DAccount + DTransactionCode + DAmount + DTPName + DTPReference1
                                       + TEXT001 + TEXT001 + TEXT001 + Filler1 + DOPName + Filler12 + TEXT001 + TEXT001 + Filler4;
                  ElectronicBanking.INSERT;

                  END;
                //-------------------------Body Record----------------
            end;

            trigger OnPostDataItem();
            begin

                TBatchNumber := HBatch;


                  AmountTemp := FORMAT(ROUND(NetAmount,0.01) * 100);

                //----------------Remove Comma-------------
                  MAMT := '';
                  L := STRLEN(AmountTemp);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(AmountTemp,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------


                  AmountTemp := MAMT;

                //----------------Amount Length Check---------------------
                  LengthAmount := STRLEN(AmountTemp);
                  IF LengthAmount = 1 THEN BEGIN
                    TBatchValue := '000000000' + AmountTemp;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    TBatchValue := '00000000' + AmountTemp;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    TBatchValue := '0000000' + AmountTemp;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    TBatchValue := '000000' + AmountTemp;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    TBatchValue := '00000' + AmountTemp;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    TBatchValue := '0000' + AmountTemp;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    TBatchValue := '000' + AmountTemp;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    TBatchValue := '00' + AmountTemp;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    TBatchValue := '0' + AmountTemp;
                  END;
                //----------------Amount Length Check---------------------

                //-------------------------Footer Record--------------

                ElectronicBanking.INIT;
                ElectronicBanking.RESET;
                ElectronicBanking.SETRANGE(Code, 'CFOOTER');
                IF NOT ElectronicBanking.FINDFIRST() THEN BEGIN



                  ElectronicBanking.Code := 'CFOOTER';
                  ElectronicBanking."Print 162" := TRecordType + THashTotal + TBatchNumber + Filler3 + TBatchValue + Filler131;
                  ElectronicBanking.INSERT;
                END;
                //-------------------------Footer Record--------------
            end;

            trigger OnPreDataItem();
            begin
                LineNo := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Batch Number";HBatch)
                {
                }
                field("Batch Due Date";ElectronicBankingDate)
                {
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
        HRSETUP.GET();
        Path := HRSETUP."Payroll Bank Directory";
        EncryptPath :=HRSETUP."Encryption Directory";
        EncryptProgram := HRSETUP."Encryption Program";


        IF EXISTS(Path + TempFileName + '.PC1') THEN BEGIN
          ERASE(Path + TempFileName);
        END;

        XMLPT.FILENAME(Path + TempFileName + '.PC1');
        XMLPT.RUN;

        MESSAGE('File Created as ' + TempFileName + '.PC1');


        CREATE (WshShell,FALSE,TRUE);
        WshShell.Run(EncryptPath + EncryptProgram);
    end;

    trigger OnPreReport();
    begin
        HRSETUP.GET();
        PayrollBank := HRSETUP."Payroll Bank Account";
        IF HRSETUP."By Pass WBC Registration No." = FALSE THEN BEGIN
          HRegistrationNo := HRSETUP."Westpac Registration No.";
          IF HRegistrationNo = '' THEN BEGIN
            ERROR('Westpac Registration Number not setup in Company Information');
          END;
        END;

        IF PayrollBank = '' THEN BEGIN
          ERROR('Payroll Bank Account not setup in Company Information');
        END;

        BankAccount.INIT;
        BankAccount.RESET;
        BankAccount.SETRANGE("No.", PayrollBank);
        IF BankAccount.FINDFIRST() THEN BEGIN
          IF BankAccount."E-Banking Customer Name" = '' THEN BEGIN
            ERROR('E-Banking Customer Name not setup in Bank Account');
          END;
          IF BankAccount."Bank Account No." = '' THEN BEGIN
            ERROR('Bank Account No. not setup in Bank Account');
          END;
          IF BankAccount."Bank Branch No." = '' THEN BEGIN
            ERROR('Bank Branch No. not setup in Bank Account');
          END;
          IF BankAccount."DR Transaction Code" = '' THEN BEGIN
            ERROR('DR Transaction code is not setup in Bank Account');
          END;
          IF BankAccount."Electronic File Name" = '' THEN BEGIN
            ERROR('Electronic File Name not defined in Bank Account');
          END;
          IF BankAccount."E-Banking Customer Name" <> '' THEN BEGIN
            HName := BankAccount."E-Banking Customer Name";
          END;
          IF BankAccount."Bank Account No." <> '' THEN BEGIN
            HAccount := BankAccount."Bank Account No.";
          END;
          IF BankAccount."Bank Branch No." <> '' THEN BEGIN
            HBranch := BankAccount."Bank Branch No.";
          END;
          IF BankAccount."DR Transaction Code" <> '' THEN BEGIN
            DTransactionCode := BankAccount."DR Transaction Code";
          END;
          IF BankAccount."Electronic File Name" <> '' THEN BEGIN
            TempFileName := BankAccount."Electronic File Name";
          END;
        END;


        IF STRLEN(HBranch) <> 3 THEN BEGIN
          ERROR('Branch number should be three digits long in Bank Account');
        END;
        IF STRLEN(HBatch) <> 3 THEN BEGIN
          ERROR('Batch number in header should be three digits long');
        END;
        IF STRLEN(DTransactionCode) <> 3 THEN BEGIN
          ERROR('Transaction Code should be three digits long in Bank Account');
        END;


         TempName := HRegistrationNo;

        //----------------Name Length Check---------------------
          Namelength := STRLEN(TempName);
          IF Namelength = 7 THEN BEGIN
            HRegistrationNo := TempName;
          END;
          IF Namelength = 6 THEN BEGIN
            HRegistrationNo := TempName + ' ';
          END;
          IF Namelength = 5 THEN BEGIN
            HRegistrationNo := TempName + '  ';
          END;
          IF Namelength = 4 THEN BEGIN
            HRegistrationNo := TempName + '   ';
          END;
          IF Namelength = 3 THEN BEGIN
            HRegistrationNo := TempName + '    ';
          END;
          IF Namelength = 2 THEN BEGIN
            HRegistrationNo := TempName + '     ';
          END;
          IF Namelength = 1 THEN BEGIN
            HRegistrationNo := TempName + '      ';
          END;



         TempName := HAccount;

        //----------------Name Length Check---------------------
          Namelength := STRLEN(TempName);
          IF Namelength = 12 THEN BEGIN
            HAccount := TempName;
          END;
          IF Namelength = 11 THEN BEGIN
            HAccount := '0' + TempName;
          END;
          IF Namelength = 10 THEN BEGIN
            HAccount := '00' + TempName;
          END;
          IF Namelength = 9 THEN BEGIN
            HAccount := '000' + TempName;
          END;
          IF Namelength = 8 THEN BEGIN
            HAccount := '0000' + TempName;
          END;
          IF Namelength = 7 THEN BEGIN
            HAccount := '00000' + TempName;
          END;
          IF Namelength = 6 THEN BEGIN
            HAccount := '000000' + TempName;
          END;
          IF Namelength = 5 THEN BEGIN
            HAccount := '0000000' + TempName;
          END;
          IF Namelength = 4 THEN BEGIN
            HAccount := '00000000' + TempName;
          END;
          IF Namelength = 3 THEN BEGIN
            HAccount := '000000000' + TempName;
          END;
          IF Namelength = 2 THEN BEGIN
            HAccount := '0000000000' + TempName;
          END;
          IF Namelength = 1 THEN BEGIN
            HAccount := '00000000000' + TempName;
          END;
        //----------------Name Length Check---------------------


         TempName := HName;

        //----------------Name Length Check---------------------
          Namelength := STRLEN(TempName);
          IF Namelength = 20 THEN BEGIN
            HName := TempName;
          END;
          IF Namelength = 19 THEN BEGIN
            HName := TempName + ' ';
          END;
          IF Namelength = 18 THEN BEGIN
            HName := TempName + '  ';
          END;
          IF Namelength = 17 THEN BEGIN
            HName := TempName + '   ';
          END;
          IF Namelength = 16 THEN BEGIN
            HName := TempName + '    ';
          END;
          IF Namelength = 15 THEN BEGIN
            HName := TempName + '     ';
          END;
          IF Namelength = 14 THEN BEGIN
            HName := TempName + '      ';
          END;
          IF Namelength = 13 THEN BEGIN
            HName := TempName + '       ';
          END;
          IF Namelength = 12 THEN BEGIN
            HName := TempName + '        ';
          END;
          IF Namelength = 11 THEN BEGIN
            HName := TempName + '         ';
          END;
          IF Namelength = 10 THEN BEGIN
            HName := TempName + '          ';
          END;
          IF Namelength = 9 THEN BEGIN
            HName := TempName + '           ';
          END;
          IF Namelength = 8 THEN BEGIN
            HName := TempName + '            ';
          END;
          IF Namelength = 7 THEN BEGIN
            HName := TempName + '             ';
          END;
          IF Namelength = 6 THEN BEGIN
            HName := TempName + '              ';
          END;
          IF Namelength = 5 THEN BEGIN
            HName := TempName + '               ';
          END;
          IF Namelength = 4 THEN BEGIN
            HName := TempName + '                ';
          END;
          IF Namelength = 3 THEN BEGIN
            HName := TempName + '                 ';
          END;
          IF Namelength = 2 THEN BEGIN
            HName := TempName + '                  ';
          END;
          IF Namelength = 1 THEN BEGIN
            HName := TempName + '                   ';
          END;
        //----------------Name Length Check---------------------



        //-------------------------Header Record--------------
        ElectronicBanking.INIT;
        ElectronicBanking.RESET;
        ElectronicBanking.DELETEALL;

        ElectronicBanking.INIT;
        ElectronicBanking.RESET;
        ElectronicBanking.SETRANGE(Code, 'AHEADER');
        IF NOT ElectronicBanking.FINDFIRST() THEN BEGIN

          mdt := FORMAT(ElectronicBankingDate);
          mdt2 := COPYSTR(mdt,1,2) + COPYSTR(mdt,4,2) + '20' + COPYSTR(mdt,7,2);
          mdt3 := COPYSTR(mdt,1,2) + '/' + COPYSTR(mdt,4,2) + '/20' + COPYSTR(mdt,7,2);
          HBatchDueDate :=  mdt2 ;

          ElectronicBanking.Code := 'AHEADER';
          ElectronicBanking."Print 162" := HRecordType + HBank + HState + HBranch + HAccount + HBatch + Filler1
                              + HBatchDueDate + HRegistrationNo + HName + Filler103;
          ElectronicBanking.INSERT;

        END;
        //-------------------------Header Record--------------
    end;

    var
        HState : TextConst ENU='9',ENA='9';
        HBranch : Text[3];
        HAccount : Text[12];
        HBatch : Text[3];
        Filler1 : TextConst ENU=' ',ENA=' ';
        HBatchDueDate : Text[8];
        HRegistrationNo : Text[7];
        HName : Text[20];
        Filler103 : TextConst ENU='                                                                                                       ',ENA='                                                                                                       ';
        HRecordType : TextConst ENU='12',ENA='13';
        DRecordType : TextConst ENU='13',ENA='13';
        DBank : Text[2];
        DState : TextConst ENU='9',ENA='9';
        DBranch : Text[3];
        DAccount : Text[12];
        DTransactionCode : Text[3];
        DAmount : Text[10];
        DTPName : Text[20];
        DTPAnalysis : Text[12];
        DTPReference1 : Text[12];
        DTPReference2 : Text[12];
        DTPParticulars : Text[12];
        DOPName : Text[20];
        Filler12 : TextConst ENU='            ',ENA='            ';
        DOPReference : Text[12];
        DOPParticulars : Text[12];
        Filler4 : TextConst ENU='    ',ENA='    ';
        TRecordType : TextConst ENU='1399',ENA='1399';
        TBatchNumber : Text[30];
        Filler3 : TextConst ENU='   ',ENA='   ';
        TBatchValue : Text[10];
        Filler131 : TextConst ENU='                                                                                                                                   ',ENA='                                                                                                                                   ';
        ElectronicBanking : Record "Electronic Banking";
        HRSETUP : Record "Human Resources Setup";
        BankAccount : Record "Bank Account";
        Employee : Record "Employee Pay Details";
        mdt : Text[30];
        ElectronicBankingDate : Date;
        mdt2 : Text[30];
        mdt3 : Text[30];
        LineNo : Integer;
        PayrollBank : Text[20];
        THashTotal : TextConst ENU='00000000000',ENA='00000000000';
        L : Integer;
        TEXT001 : TextConst ENU='            ',ENA='            ';
        AmountTemp : Text[30];
        MAMT : Text[30];
        Y : Integer;
        X : Text[30];
        LengthAmount : Integer;
        TempName : Text[30];
        Namelength : Integer;
        NetAmount : Decimal;
        Path : Text[250];
        TempFileName : Text[250];
        XMLPT : XMLport "Electronic Banking WBC";
        HBank : Label '03';
        WshShell : Automation "'{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B}' 1.0:'{72C24DD5-D70A-438B-8A42-98424B88AFB8}':''{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B}' 1.0'.WshShell";
        EncryptPath : Text[250];
        EncryptProgram : Text[30];
        PayrollBankMaster : Record "Payroll Banks";
}

