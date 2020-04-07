report 50001 GLReporting
{
    DefaultLayout = RDLC;
    RDLCLayout = './GLReporting.rdlc';

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {

            trigger OnAfterGetRecord();
            begin
                HRSETUP.GET();

                INIT;
                RESET;
                SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                IF FINDFIRST() THEN REPEAT
                    LineNo := LineNo + 1;
                    L := STRLEN(FORMAT(LineNo));
                    IF L=1 THEN BEGIN
                      "Detail Line_RecordNo" := '000000000' + FORMAT(LineNo);
                    END;
                    IF L=2 THEN BEGIN
                      "Detail Line_RecordNo" := '00000000' + FORMAT(LineNo);
                    END;
                    IF L=3 THEN BEGIN
                      "Detail Line_RecordNo" := '0000000' + FORMAT(LineNo);
                    END;
                    IF L=4 THEN BEGIN
                      "Detail Line_RecordNo" := '000000' + FORMAT(LineNo);
                    END;
                    IF L=5 THEN BEGIN
                      "Detail Line_RecordNo" := '00000' + FORMAT(LineNo);
                    END;
                    IF L=6 THEN BEGIN
                      "Detail Line_RecordNo" := '0000' + FORMAT(LineNo);
                    END;
                    IF L=7 THEN BEGIN
                      "Detail Line_RecordNo" := '000' + FORMAT(LineNo);
                    END;
                    IF L=8 THEN BEGIN
                      "Detail Line_RecordNo" := '00' + FORMAT(LineNo);
                    END;
                    IF L=9 THEN BEGIN
                      "Detail Line_RecordNo" := '0' + FORMAT(LineNo);
                    END;
                    IF L=10 THEN BEGIN
                      "Detail Line_RecordNo" := FORMAT(LineNo);
                    END;

                    "Detail Line_RcordType":= 'D';
                    GLAccount := "Account No.";
                    GLAccountDescription := Description;
                    CostCenter := "Shortcut Dimension 1 Code";
                    PayElement := Narration;
                    PayServerID := '';
                    HRISID := '';
                    DebitAmount := FORMAT("Debit Amount");
                    CreditAmount := FORMAT("Credit Amount");
                    TDRAmount := TDRAmount + "Debit Amount";
                    TCRAmount := TCRAmount + "Credit Amount";
                    Hours := '';
                    "Posting Date" := PostingDate;

                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'BDETAIL' + FORMAT("Detail Line_RecordNo"));
                IF NOT "Global Report".FINDFIRST() THEN BEGIN
                  "Global Report".Code := 'BDETAIL' + FORMAT("Detail Line_RecordNo");
                  "Global Report"."Finance Description" := "Detail Line_RecordNo" + ',' + "Detail Line_RcordType" + ',' + GLAccount + ',' + GLAccountDescription + ',' + CostCenter + ',' + PayElement + ',' + PayServerID + ',' + HRISID + ',' + DebitAmount
                  + ',' + CreditAmount + ',' + Hours + ',' + FORMAT("Posting Date");
                  "Global Report".INSERT;
                END;

                UNTIL NEXT = 0;
            end;

            trigger OnPostDataItem();
            begin
                    LineNo := LineNo + 1;
                    L := STRLEN(FORMAT(LineNo));
                    IF L=1 THEN BEGIN
                      Trailer_RecordNo := '000000000' + FORMAT(LineNo);
                    END;
                    IF L=2 THEN BEGIN
                      Trailer_RecordNo := '00000000' + FORMAT(LineNo);
                    END;
                    IF L=3 THEN BEGIN
                      Trailer_RecordNo := '0000000' + FORMAT(LineNo);
                    END;
                    IF L=4 THEN BEGIN
                      Trailer_RecordNo := '000000' + FORMAT(LineNo);
                    END;
                    IF L=5 THEN BEGIN
                      Trailer_RecordNo := '00000' + FORMAT(LineNo);
                    END;
                    IF L=6 THEN BEGIN
                      Trailer_RecordNo := '0000' + FORMAT(LineNo);
                    END;
                    IF L=7 THEN BEGIN
                      Trailer_RecordNo := '000' + FORMAT(LineNo);
                    END;
                    IF L=8 THEN BEGIN
                      Trailer_RecordNo := '00' + FORMAT(LineNo);
                    END;
                    IF L=9 THEN BEGIN
                      Trailer_RecordNo := '0' + FORMAT(LineNo);
                    END;
                    IF L=10 THEN BEGIN
                      Trailer_RecordNo := FORMAT(LineNo);
                    END;

                "Trailer_ RecordType":= 'T';
                RecordCount:= Trailer_RecordNo;
                TotalDebitAmount:= FORMAT(TDRAmount);
                TotalCreditAmount:= FORMAT(TCRAmount);

                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'CFOOTER');
                IF NOT "Global Report".FINDFIRST() THEN BEGIN



                  "Global Report".Code := 'CFOOTER';
                  "Global Report"."Finance Description" := Trailer_RecordNo + ',' + "Trailer_ RecordType" + ',' + RecordCount + ',' + TotalDebitAmount + ',' + TotalCreditAmount;
                  "Global Report".INSERT;
                END;
            end;

            trigger OnPreDataItem();
            begin
                HRSETUP.GET();

                INIT;
                RESET;
                SETRANGE("Journal Template Name", HRSETUP."Payroll Journal Template");
                SETRANGE("Journal Batch Name", HRSETUP."Payroll Journal Batch");
                IF FINDFIRST() THEN BEGIN
                  PostingDate := "Posting Date";

                    LineNo := LineNo + 1;
                    L := STRLEN(FORMAT(LineNo));
                    IF L=1 THEN BEGIN
                      Header_RecordNo := '000000000' + FORMAT(LineNo);
                    END;
                    IF L=2 THEN BEGIN
                      Header_RecordNo := '00000000' + FORMAT(LineNo);
                    END;
                    IF L=3 THEN BEGIN
                      Header_RecordNo := '0000000' + FORMAT(LineNo);
                    END;
                    IF L=4 THEN BEGIN
                      Header_RecordNo := '000000' + FORMAT(LineNo);
                    END;
                    IF L=5 THEN BEGIN
                      Header_RecordNo := '00000' + FORMAT(LineNo);
                    END;
                    IF L=6 THEN BEGIN
                      Header_RecordNo := '0000' + FORMAT(LineNo);
                    END;
                    IF L=7 THEN BEGIN
                      Header_RecordNo := '000' + FORMAT(LineNo);
                    END;
                    IF L=8 THEN BEGIN
                      Header_RecordNo := '00' + FORMAT(LineNo);
                    END;
                    IF L=9 THEN BEGIN
                      Header_RecordNo := '0' + FORMAT(LineNo);
                    END;
                    IF L=10 THEN BEGIN
                      Header_RecordNo := FORMAT(LineNo);
                    END;

                Header_RecordType:= 'H';
                Header_GCC := COPYSTR(COMPANYNAME, 1, 3);
                Header_LCC := 'FJ001';
                PayGroupID:= COPYSTR(COMPANYNAME, 1, 3);

                Day := DATE2DMY(PostingDate, 1);
                Month := DATE2DMY(PostingDate, 2);
                Year := DATE2DMY(PostingDate, 3);
                PayrollPeriod:= 'Y' + FORMAT(Year);
                CurrencyCode:= 'FJ';
                END;

                //-------------------------Header Record--------------
                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".DELETEALL;

                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'AHEADER');
                IF NOT "Global Report".FINDFIRST() THEN BEGIN
                  "Global Report".Code := 'AHEADER';
                  "Global Report"."Finance Description" := Header_RecordNo + ',' + Header_RecordType + ',' + Header_GCC +',' + Header_LCC + ',' + PayGroupID + ',' + PayrollPeriod + ',' + CurrencyCode;
                  "Global Report".INSERT;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        Path := HRSETUP."Payroll Bank Directory";
        GCC:= COPYSTR(COMPANYNAME, 1, 3);
        LCC := 'FJ';
        PayGroup:= 'M';
        Y:= 'rb';
        P:= 'PR';
        R:= 'PR';
        FileName := 'Finance' + '.CSV';


        IF EXISTS(Path + FileName) THEN BEGIN
          ERASE(Path + FileName);
        END;

        COMMIT;
        XMLPT.FILENAME(Path + FileName);
        XMLPT.RUN;

        MESSAGE('File Created as %1', FileName);
    end;

    trigger OnPreReport();
    begin
        LineNo := 0;
    end;

    var
        Path : Text[30];
        FileName : Text;
        HRSETUP : Record "Human Resources Setup";
        PostingDate : Date;
        XMLPT : XMLport "Finance XMLPort";
        Header_RecordNo : Text[10];
        Header_RecordType : Text[1];
        Header_GCC : Text[3];
        Header_LCC : Text[5];
        "Global Report" : Record "Finance Table";
        PayGroupID : Text[3];
        PayrollPeriod : Text[8];
        CurrencyCode : Text[3];
        VersionCode : Text[3];
        "Detail Line_RecordNo" : Text[10];
        "Detail Line_RcordType" : Text[1];
        GLAccount : Text;
        GLAccountDescription : Text[50];
        CostCenter : Text[30];
        PayElement : Text[20];
        "Element Type" : Text[10];
        PayServerID : Text[10];
        HRISID : Text[30];
        DebitAmount : Text[20];
        CreditAmount : Text[10];
        Hours : Text[10];
        "Posting Date" : Text[8];
        Trailer_RecordNo : Text[10];
        "Trailer_ RecordType" : Text[1];
        RecordCount : Text[20];
        TotalDebitAmount : Text[20];
        TotalCreditAmount : Text[20];
        GLREP : Text[4];
        GCC : Text[3];
        PayGroup : Text[5];
        Y : Text[2];
        P : Text[4];
        R : Text[2];
        O : Text[2];
        D : Text[8];
        L : Integer;
        LCC : Text[5];
        TDRAmount : Decimal;
        TCRAmount : Decimal;
        LineNo : Integer;
        Day : Integer;
        Month : Integer;
        Year : Integer;
}

