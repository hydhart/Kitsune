report 50000 "Global report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Global report.rdlc';

    dataset
    {
        dataitem("Pay Run";"Pay Run")
        {

            trigger OnAfterGetRecord();
            begin
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

                    "Detail Line_RcordType":= 'E';
                    PersonID:= "Employee No.";
                    PayElement:= "Pay Code";
                    IF FORMAT("Pay Type") = 'Earnings' THEN BEGIN
                    "Element Type":='P';
                      END;
                      IF FORMAT("Pay Type") = 'Deductions' THEN BEGIN
                         "Element Type":='D';
                      END;
                    "Element Type":= FORMAT("Pay Type");
                    Amounts:= FORMAT(ROUND(Amount,0.01,'='));
                    "ERs Amount":= '';
                    TAmount:= TAmount + (ROUND(Amount,0.01,'='));
                    TERAmount:= 0;
                    "Unit Type":= 'Hours';
                    Unit:= FORMAT(Units);




                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'BDETAIL' + FORMAT("Detail Line_RecordNo"));
                IF NOT "Global Report".FINDFIRST() THEN BEGIN

                  "Global Report".Code := 'BDETAIL' + FORMAT("Detail Line_RecordNo");
                  "Global Report"."Global Description" := "Detail Line_RecordNo" + ',' + "Detail Line_RcordType" + ',' + PersonID + ','+ PayElement + ',' + "Element Type" + ',' + Amounts + ',' + "ERs Amount" + ',' + "Unit Type" + ',' + Unit;
                  "Global Report".INSERT;

                  END;
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
                "Total Amount":= FORMAT(TAmount);
                "Total ERs Amount":= FORMAT(TERAmount);

                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'CFOOTER');
                IF NOT "Global Report".FINDFIRST() THEN BEGIN



                  "Global Report".Code := 'CFOOTER';
                  "Global Report"."Global Description" := Trailer_RecordNo + ',' + "Trailer_ RecordType" + ',' + RecordCount + ',' + "Total Amount" + ',' + "Total ERs Amount";
                  "Global Report".INSERT;
                END;
            end;

            trigger OnPreDataItem();
            begin
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

                rb:= "Calendar Code";
                PR:= "Pay Run No.";
                Header_RecordType:= 'H';
                PayGroupID:= COPYSTR(COMPANYNAME, 1, 3);
                PayrollPeriod:= "Calendar Code" + "Pay Run No.";
                CurrencyCode:= 'FJD';
                VersionCode:= '1';
                GCC:= 'Z05';
                LCC := 'FJ001';
                PayGroup:= 'FI';

                //-------------------------Header Record--------------
                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".DELETEALL;

                "Global Report".INIT;
                "Global Report".RESET;
                "Global Report".SETRANGE(Code, 'AHEADER');
                IF NOT "Global Report".FINDFIRST() THEN BEGIN



                  "Global Report".Code := 'AHEADER';
                  "Global Report"."Global Description" := Header_RecordNo + ',' + Header_RecordType + ',' + GCC + ',' + LCC + ',' + PayGroup + ',' + PayrollPeriod + ',' + CurrencyCode + ',' + VersionCode;
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

        GCC:= 'Z05';
        LCC := 'FJ001';
        PayGroup:= 'FI';
        Y:= 'rb';
        P:= 'PR';
        R:= 'PR';
        bhavik := GLREP + GCC + LCC + PayGroup + Y + P + R + '.CSV';


        IF EXISTS(GLREP + GCC + LCC + PayGroup + Y + P + R+'.CSV') THEN BEGIN
          ERASE(GLREP + GCC + LCC + PayGroup + Y + P + R);
        END;

        COMMIT;
        XMLPT.FILENAME(GLREP + GCC + LCC + PayGroup + Y + P + R+'.CSV');
        XMLPT.RUN;

        MESSAGE('File Created as %1', bhavik);
    end;

    trigger OnPreReport();
    begin
        LineNo := 0;
    end;

    var
        PR : Text[4];
        rb : Text[5];
        XMLPT : XMLport Globalreport;
        Header_RecordNo : Text[10];
        Header_RecordType : Text[1];
        Header_GCC : Text[3];
        Header_LCC : Text[5];
        "Global Report" : Record "Global Table";
        bhavik : Text[50];
        PayGroupID : Text[3];
        PayrollPeriod : Text[8];
        CurrencyCode : Text[3];
        VersionCode : Text[3];
        "Detail Line_RecordNo" : Text[10];
        "Detail Line_RcordType" : Text[1];
        PersonID : Text[10];
        PayElement : Text[20];
        "Element Type" : Text[10];
        Amounts : Text[20];
        "ERs Amount" : Text[10];
        "Unit Type" : Text[10];
        Unit : Text[10];
        Trailer_RecordNo : Text[10];
        "Trailer_ RecordType" : Text[1];
        RecordCount : Text[20];
        "Total Amount" : Text[20];
        "Total ERs Amount" : Text[20];
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
        TAmount : Decimal;
        TERAmount : Decimal;
        LineNo : Integer;
}

