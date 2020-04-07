report 50222 "Electronic Banking ANZ"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Electronic Banking ANZ.rdlc';

    dataset
    {
        dataitem("Bank Pay Distribution";"Bank Pay Distribution")
        {
            DataItemTableView = SORTING(Employee No.,Branch Code,Shift Code,Calendar Code,Statistics Group,Pay Run No.,Special Pay No.,Sequence,Is Balance,Employee Bank Account No.) ORDER(Ascending);
            RequestFilterFields = "Branch Code","Shift Code","Calendar Code","Statistics Group","Pay Run No.","Special Pay No.";

            trigger OnAfterGetRecord();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                  IF PayrollBankMaster.GET(Employee."Bank Code") THEN BEGIN
                    BankNumber :=PayrollBankMaster."Bank No.";
                  END;
                  Narrative := Employee."Payee Narrative";
                  IF Narrative = '' THEN BEGIN;
                    Narrative := Spare12;
                  END;
                  PayeeCode := Spare12;
                  PayeeParticulars := Employee."Payee Particulars";
                  IF PayeeParticulars = '' THEN BEGIN
                    PayeeParticulars := Spare12;
                  END;
                END;

                IF STRLEN(BankNumber) <> 2 THEN BEGIN
                  ERROR('Bank number in Detail should be 2 digits long');
                END;


                //----------------Bank Account No. Length Check---------------------
                  LengthBankAccount := STRLEN(TempBankAccountNo);
                  IF LengthBankAccount = 1 THEN BEGIN
                    BankAccountNo := '0000000'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 2 THEN BEGIN
                    BankAccountNo := '000000'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 3 THEN BEGIN
                    BankAccountNo := '00000'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 4 THEN BEGIN
                    BankAccountNo := '0000'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 5 THEN BEGIN
                    BankAccountNo := '000'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 6 THEN BEGIN
                    BankAccountNo := '00'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 7 THEN BEGIN
                    BankAccountNo := '0'+"Bank Account No.";
                  END;
                  IF LengthBankAccount = 8 THEN BEGIN
                    BankAccountNo := "Bank Account No.";
                  END;

                //----------------Bank Account No. Length Check---------------------

                  First6Digits := COPYSTR("Employee Bank Account No.", 1,6);
                  Last2Digits := COPYSTR("Employee Bank Account No.", 7,8);


                  TotalAmount := TotalAmount + "Pay Run Amount";
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
                    DetailAmount := '000000000' + AmountTemp;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    DetailAmount := '00000000' + AmountTemp;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    DetailAmount := '0000000' + AmountTemp;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    DetailAmount := '000000' + AmountTemp;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    DetailAmount := '00000' + AmountTemp;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    DetailAmount := '0000' + AmountTemp;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    DetailAmount := '000' + AmountTemp;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    DetailAmount := '00' + AmountTemp;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    DetailAmount := '0' + AmountTemp;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    DetailAmount := AmountTemp;
                  END;
                //----------------Amount Length Check---------------------


                  TempName := COPYSTR("Employee Name",1,20);

                //----------------Name Length Check---------------------
                  NameLength := STRLEN(TempName);
                  IF NameLength = 20 THEN BEGIN
                    EmployeeName := TempName;
                  END;
                  IF NameLength = 19 THEN BEGIN
                    EmployeeName := TempName + ' ';
                  END;
                  IF NameLength = 18 THEN BEGIN
                    EmployeeName := TempName + '  ';
                  END;
                  IF NameLength = 17 THEN BEGIN
                    EmployeeName := TempName + '   ';
                  END;
                  IF NameLength = 16 THEN BEGIN
                    EmployeeName := TempName + '    ';
                  END;
                  IF NameLength = 15 THEN BEGIN
                    EmployeeName := TempName + '     ';
                  END;
                  IF NameLength = 14 THEN BEGIN
                    EmployeeName := TempName + '      ';
                  END;
                  IF NameLength = 13 THEN BEGIN
                    EmployeeName := TempName + '       ';
                  END;
                  IF NameLength = 12 THEN BEGIN
                    EmployeeName := TempName + '        ';
                  END;
                  IF NameLength = 11 THEN BEGIN
                    EmployeeName := TempName + '         ';
                  END;
                  IF NameLength = 10 THEN BEGIN
                    EmployeeName := TempName + '          ';
                  END;
                  IF NameLength = 9 THEN BEGIN
                    EmployeeName := TempName + '           ';
                  END;
                  IF NameLength = 8 THEN BEGIN
                    EmployeeName := TempName + '            ';
                  END;
                  IF NameLength = 7 THEN BEGIN
                    EmployeeName := TempName + '             ';
                  END;
                  IF NameLength = 6 THEN BEGIN
                    EmployeeName := TempName + '              ';
                  END;
                  IF NameLength = 5 THEN BEGIN
                    EmployeeName := TempName + '               ';
                  END;
                  IF NameLength = 4 THEN BEGIN
                    EmployeeName := TempName + '                ';
                  END;
                  IF NameLength = 3 THEN BEGIN
                    EmployeeName := TempName + '                 ';
                  END;
                  IF NameLength = 2 THEN BEGIN
                    EmployeeName := TempName + '                  ';
                  END;
                  IF NameLength = 1 THEN BEGIN
                    EmployeeName := TempName + '                   ';
                  END;
                  IF NameLength = 0 THEN BEGIN
                    EmployeeName := TempName + '                    ';
                  END;

                //----------------Name Length Check---------------------

                  NarrativeTemp := Narrative;

                //----------------Payee Narrative Length Check---------------------
                  NarrativeLength := STRLEN(NarrativeTemp);
                  IF NarrativeLength = 12 THEN BEGIN
                    Narrative := NarrativeTemp;
                  END;
                  IF NarrativeLength = 11 THEN BEGIN
                    Narrative := '0'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 10 THEN BEGIN
                    Narrative := '00'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 9 THEN BEGIN
                    Narrative := '000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 8 THEN BEGIN
                    Narrative := '0000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 7 THEN BEGIN
                    Narrative := '00000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 6 THEN BEGIN
                    Narrative := '000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 5 THEN BEGIN
                    Narrative := '0000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 4 THEN BEGIN
                    Narrative := '00000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 3 THEN BEGIN
                    Narrative := '000000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 2 THEN BEGIN
                    Narrative := '0000000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 1 THEN BEGIN
                    Narrative := '00000000000'+ NarrativeTemp;
                  END;
                  IF NarrativeLength = 0 THEN BEGIN
                    Narrative := '000000000000';
                  END;

                  PayeeParticularsTemp := PayeeParticulars;

                //----------------Payee Narrative Length Check---------------------
                  NarrativeLength := STRLEN(PayeeParticularsTemp);
                  IF NarrativeLength = 12 THEN BEGIN
                    PayeeParticulars := PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 11 THEN BEGIN
                    PayeeParticulars := '0'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 10 THEN BEGIN
                    PayeeParticulars := '00'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 9 THEN BEGIN
                    PayeeParticulars := '000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 8 THEN BEGIN
                    PayeeParticulars := '0000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 7 THEN BEGIN
                    PayeeParticulars := '00000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 6 THEN BEGIN
                    PayeeParticulars := '000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 5 THEN BEGIN
                    PayeeParticulars := '0000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 4 THEN BEGIN
                    PayeeParticulars := '00000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 3 THEN BEGIN
                    PayeeParticulars := '000000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 2 THEN BEGIN
                    PayeeParticulars := '0000000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 1 THEN BEGIN
                    PayeeParticulars := '00000000000'+ PayeeParticularsTemp;
                  END;
                  IF NarrativeLength = 0 THEN BEGIN
                    PayeeParticulars := '000000000000';
                  END;


                  LineNo := LineNo + 1;
                  DueDate := mdt3;


                //----------------Payee Narrative Length Check---------------------

                ElectronicBanking.INIT;
                ElectronicBanking.RESET;
                ElectronicBanking.SETRANGE(Code, 'BDETAIL' + FORMAT(LineNo));
                IF NOT ElectronicBanking.FINDFIRST() THEN BEGIN
                  ElectronicBanking.Code := 'BDETAIL' + FORMAT(LineNo);
                  ElectronicBanking."Print 160" := DetailRecordType + BankNumber + BranchNumber + Spare1 + First6Digits + Spare1 + Last2Digits + Spare1 + DRTransactionCode
                                       + DetailAmount + EmployeeName + Spare12 + PayeeParticulars + PayeeCode + Narrative + Spare60 + DETEOR;
                  ElectronicBanking.INSERT;

                  END;
                //-------------------------DiskPay Body-------------
            end;

            trigger OnPostDataItem();
            begin

                //-------------------------Footer Record-------------

                  TotalAmountTemp := FORMAT(ROUND(TotalAmount,0.01) * 100);


                //----------------Remove Comma-------------
                  MAMT := '';
                  L := STRLEN(TotalAmountTemp);
                  Y := 1;
                  REPEAT;
                    X := COPYSTR(TotalAmountTemp,Y,1);
                    IF X <> ',' THEN BEGIN
                      IF X <> '' THEN BEGIN
                        MAMT := MAMT + X;
                      END
                    END;
                    Y := Y + 1;
                  UNTIL Y > L;
                //----------------Remove Comma-------------

                  TotalAmountTemp := MAMT;

                //----------------Amount Length Check---------------------
                  LengthAmount := STRLEN(TotalAmountTemp);
                  IF LengthAmount = 1 THEN BEGIN
                    BatchTotal := '000000000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 2 THEN BEGIN
                    BatchTotal := '00000000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 3 THEN BEGIN
                    BatchTotal := '0000000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 4 THEN BEGIN
                    BatchTotal := '000000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 5 THEN BEGIN
                    BatchTotal := '00000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 6 THEN BEGIN
                    BatchTotal := '0000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 7 THEN BEGIN
                    BatchTotal := '000' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 8 THEN BEGIN
                    BatchTotal := '00' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 9 THEN BEGIN
                    BatchTotal  := '0' + TotalAmountTemp;
                  END;
                  IF LengthAmount = 10 THEN BEGIN
                    BatchTotal  := TotalAmountTemp;
                  END;
                //----------------Amount Length Check---------------------

                ElectronicBanking.INIT;
                ElectronicBanking.RESET;
                ElectronicBanking.SETRANGE(Code, 'CFOOTER');
                IF NOT ElectronicBanking.FINDFIRST() THEN BEGIN
                  ElectronicBanking.Code := 'CFOOTER';
                  ElectronicBanking."Print 160" := TrailerRecordType + TrailerBank + HashTotal + Spare6 + BatchTotal + Spare128 + TRLEOR;
                  ElectronicBanking.INSERT;
                END;
                //-------------------------Footer Record-------------
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
                field("Electronic Banking Date";ElectronicBankingDate)
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

        IF EXISTS(Path + TempFileName) THEN BEGIN
          ERASE(Path + TempFileName);
        END;

        XMLPT.FILENAME(Path + TempFileName);
        XMLPT.RUN;

        MESSAGE('File Created as ' + TempFileName);
    end;

    trigger OnPreReport();
    begin
        HRSETUP.GET();
        PayrollBank := HRSETUP."Payroll Bank Account";

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
          IF BankAccount."DR Transaction Code" = '' THEN BEGIN
            ERROR('DR Transaction code is not setup in Bank Account');
          END;
          IF BankAccount."Electronic File Name" = '' THEN BEGIN
            ERROR('Electronic File Name not defined in Bank Account');
          END;
          IF BankAccount."E-Banking Customer Name" <> '' THEN BEGIN
            HeaderCustomerName := BankAccount."E-Banking Customer Name";
          END;
          IF BankAccount."Bank Account No." <> '' THEN BEGIN
            HeaderAccountNumber := BankAccount."Bank Account No.";
          END;
          IF BankAccount."DR Transaction Code" <> '' THEN BEGIN
            DRTransactionCode := BankAccount."DR Transaction Code";
          END;
          IF BankAccount."Electronic File Name" <> '' THEN BEGIN
            TempFileName := BankAccount."Electronic File Name";
          END
        END;


         TempName := HeaderAccountNumber;

        //----------------Name Length Check---------------------
          NameLength := STRLEN(TempName);
          IF NameLength = 8 THEN BEGIN
            HeaderAccountNumber := TempName;
          END;
          IF NameLength = 7 THEN BEGIN
            HeaderAccountNumber := TempName + ' ';
          END;
          IF NameLength = 6 THEN BEGIN
            HeaderAccountNumber := TempName + '  ';
          END;
          IF NameLength = 5 THEN BEGIN
            HeaderAccountNumber := TempName + '   ';
          END;
          IF NameLength = 4 THEN BEGIN
            HeaderAccountNumber := TempName + '    ';
          END;
          IF NameLength = 3 THEN BEGIN
            HeaderAccountNumber := TempName + '     ';
          END;
          IF NameLength = 2 THEN BEGIN
            HeaderAccountNumber := TempName + '      ';
          END;
          IF NameLength = 1 THEN BEGIN
            HeaderAccountNumber := TempName + '       ';
          END;
          IF NameLength = 0 THEN BEGIN
            HeaderAccountNumber := '        ';
          END;

        //----------------Name Length Check---------------------


         TempName := HeaderCustomerName;

        //----------------Name Length Check---------------------
          NameLength := STRLEN(TempName);
          IF NameLength = 20 THEN BEGIN
            HeaderCustomerName := TempName;
          END;
          IF NameLength = 19 THEN BEGIN
            HeaderCustomerName := TempName + ' ';
          END;
          IF NameLength = 18 THEN BEGIN
            HeaderCustomerName := TempName + '  ';
          END;
          IF NameLength = 17 THEN BEGIN
            HeaderCustomerName := TempName + '   ';
          END;
          IF NameLength = 16 THEN BEGIN
            HeaderCustomerName := TempName + '    ';
          END;
          IF NameLength = 15 THEN BEGIN
            HeaderCustomerName := TempName + '     ';
          END;
          IF NameLength = 14 THEN BEGIN
            HeaderCustomerName := TempName + '      ';
          END;
          IF NameLength = 13 THEN BEGIN
            HeaderCustomerName := TempName + '       ';
          END;
          IF NameLength = 12 THEN BEGIN
            HeaderCustomerName := TempName + '        ';
          END;
          IF NameLength = 11 THEN BEGIN
            HeaderCustomerName := TempName + '         ';
          END;
          IF NameLength = 10 THEN BEGIN
            HeaderCustomerName := TempName + '          ';
          END;
          IF NameLength = 9 THEN BEGIN
            HeaderCustomerName := TempName + '           ';
          END;
          IF NameLength = 8 THEN BEGIN
            HeaderCustomerName := TempName + '            ';
          END;
          IF NameLength = 7 THEN BEGIN
            HeaderCustomerName := TempName + '             ';
          END;
          IF NameLength = 6 THEN BEGIN
            HeaderCustomerName := TempName + '              ';
          END;
          IF NameLength = 5 THEN BEGIN
            HeaderCustomerName := TempName + '               ';
          END;
          IF NameLength = 4 THEN BEGIN
            HeaderCustomerName := TempName + '                ';
          END;
          IF NameLength = 3 THEN BEGIN
            HeaderCustomerName := TempName + '                 ';
          END;
          IF NameLength = 2 THEN BEGIN
            HeaderCustomerName := TempName + '                  ';
          END;
          IF NameLength = 1 THEN BEGIN
            HeaderCustomerName := TempName + '                   ';
          END;
        //----------------Name Length Check---------------------

        //-------------------------Header Record-------------
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
          HeaderValueDate :=  mdt2 ;

          ElectronicBanking.Code := 'AHEADER';
          ElectronicBanking."Print 160" := HeaderRecordType + HeaderBank + HeaderBranch + Spare1 + HeaderAccountNumber + Spare1
                              + HeaderValueDate + Filler5 + HeaderCustomerName + Filler108 + HDREOR;
          ElectronicBanking.INSERT;

        END;
          //-------------------------Header Record-------------
    end;

    var
        HeaderRecordType : Label '12';
        HeaderBank : Label '02';
        HeaderBranch : Label '0000';
        Spare1 : Label '0';
        HeaderAccountNumber : Text[8];
        HeaderValueDate : Text[8];
        Filler5 : Label '"     "';
        Filler108 : Label '"                                                                                                            "';
        HDREOR : Label '0';
        DetailRecordType : Label '13';
        BranchNumber : Label '0000';
        HeaderCustomerName : Text[20];
        BankNumber : Text[2];
        First6Digits : Text[6];
        Last2Digits : Text[2];
        DRTransactionCode : Text[2];
        CRTransactionCode : Text[2];
        DetailAmount : Text[10];
        EmployeeName : Text[20];
        Spare12 : Label '"            "';
        Spare60 : Label '"                                                            "';
        PayeeParticulars : Text[12];
        PayeeCode : Text[12];
        Narrative : Text[12];
        DETEOR : Label '0';
        TrailerRecordType : Label '13';
        TrailerBank : Label '99';
        HashTotal : Label '00000000000';
        Spare6 : Label '"      "';
        BatchTotal : Text[10];
        Spare128 : Label '"                                                                                                                                "';
        TRLEOR : Label '0';
        ElectronicBanking : Record "Electronic Banking";
        BankAccount : Record "Bank Account";
        BankPayDistribution : Record "Bank Pay Distribution";
        HRSETUP : Record "Human Resources Setup";
        Employee : Record "Employee Pay Details";
        ElectronicBankingDate : Date;
        mdt : Text[30];
        mdt2 : Text[30];
        mdt3 : Text[30];
        LineNo : Integer;
        EmployeeNo : Text[20];
        TotalAmount : Decimal;
        TotalAmountTemp : Text[30];
        MAMT : Text[30];
        L : Integer;
        Y : Integer;
        X : Text[30];
        LengthAmount : Integer;
        TempName : Text[20];
        PayeeName : Text[20];
        DueDate : Text[30];
        NameLength : Integer;
        NarrativeTemp : Text[30];
        NarrativeLength : Integer;
        LengthBankAccount : Integer;
        AmountTemp : Text[30];
        Amount : Decimal;
        BankName : Text[30];
        BankCode : Text[30];
        TEXT001 : Label 'Bank Pay Distribution';
        CurrReport_PAGENOCaptionLbl : TextConst ENU='Page',ENA='Page';
        DisplayFilter : Text[250];
        BankBranchCode : Text[2];
        BankAccountNo : Text[8];
        TempBankAccountNo : Text[8];
        PayrollBank : Text[20];
        PayeeParticularsTemp : Text[30];
        Path : Text[250];
        TempFileName : Text[250];
        XMLPT : XMLport "Electronic Banking ANZ";
        PayrollBankMaster : Record "Payroll Banks";
}

