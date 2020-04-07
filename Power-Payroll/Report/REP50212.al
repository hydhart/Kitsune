report 50212 "Employee Leave Status Detail"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employee Leave Status Detail.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(No_Employee;Employee."No.")
            {
            }
            column(Title_Employee;Employee.Title)
            {
            }
            column(SearchName_Employee;Employee."Search Name")
            {
            }
            column(JobTitle_Employee;Employee."Job Title")
            {
            }
            column(EmployeeRate_Employee;EMP."Employee Rate")
            {
            }
            dataitem("Employee Absence";"Employee Absence")
            {
                DataItemLink = Employee No.=FIELD(No.);
                column(FromDate_EmployeeAbsence;"Employee Absence"."From Date")
                {
                }
                column(ToDate_EmployeeAbsence;"Employee Absence"."To Date")
                {
                }
                column(CauseofAbsenceCode_EmployeeAbsence;"Employee Absence"."Cause of Absence Code")
                {
                }
                column(Description_EmployeeAbsence;"Employee Absence".Description)
                {
                }
                column(FromTime_EmployeeAbsence;"Employee Absence"."From Time")
                {
                }
                column(ToTime_EmployeeAbsence;"Employee Absence"."To Time")
                {
                }
                column(PayRunNo_EmployeeAbsence;"Employee Absence"."Pay Run No.")
                {
                }
                column(SpecialPayNo_EmployeeAbsence;"Employee Absence"."Special Pay No.")
                {
                }
                column(PayCode_EmployeeAbsence;"Employee Absence"."Pay Code")
                {
                }
                column(PrintUOM;PrintUOM)
                {
                }
                column(PrintQuantity;PrintQuantity)
                {
                }
                column(PrintAmount;PrintAmount)
                {
                }
                column(PrintRate;PrintRate)
                {
                }
                column(PrintQtyPerUnit;PrintQtyPerUnit)
                {
                }
                column(GetUOM;GetUOM)
                {
                }
                column(PriorYear_EmployeeAbsence;"Employee Absence"."Prior Year")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    PrintUOM := '';
                    PrintQuantity := 0;
                    PrintAmount := 0;
                    PrintRate := 0;
                    PrintQtyPerUnit := 0;

                    IF GetUOM = '' THEN BEGIN                   //No User Reporting UOM
                      PrintUOM := "Unit of Measure Code";
                      PrintQuantity := Quantity;
                      PrintAmount := Amount;
                      PrintRate := Rate;
                      PrintQtyPerUnit := "Qty. per Unit of Measure";
                    END;

                    IF GetUOM <> '' THEN BEGIN                  //User Reporting UOM Defined
                      IF GetUOM = BaseUOM THEN BEGIN            //User UOM is equal to Base Unit of Measure
                        IF GetUOMConversionRate > "Qty. per Unit of Measure" THEN BEGIN   //Where DAY > HOUR need to convert hours to day
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity * "Qty. per Unit of Measure";         //1 HOUR (0.125Day) to DAY (1*0.125)
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                        IF GetUOMConversionRate < "Qty. per Unit of Measure" THEN BEGIN   //Where DAY is < HOUR need to convert day to hours
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity / GetUOMConversionRate;               //1 DAY to Hour (0.125Day) (1/0.125)
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                        IF GetUOMConversionRate = "Qty. per Unit of Measure" THEN BEGIN   //Where Day = Day
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity * GetUOMConversionRate;               //1 DAY to 1 Day (1*1)
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                      END;

                      IF GetUOM <> BaseUOM THEN BEGIN           //User UOM is not equal to Base Unit of Measure
                        IF GetUOMConversionRate > "Qty. per Unit of Measure" THEN BEGIN   //
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity * GetUOMConversionRate;
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                        IF GetUOMConversionRate < "Qty. per Unit of Measure" THEN BEGIN
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity / GetUOMConversionRate;
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                        IF GetUOMConversionRate = "Qty. per Unit of Measure" THEN BEGIN
                          PrintUOM := GetUOM;
                          PrintQuantity := Quantity;
                          PrintAmount := Amount;
                          PrintRate := Rate;
                          PrintQtyPerUnit := "Qty. per Unit of Measure";
                        END;
                      END;
                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Reporting UOM";GetUOM)
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

    trigger OnPreReport();
    begin
        HRUOM.INIT;
        HRUOM.RESET;
        HRUOM.SETRANGE(Code, GetUOM);
        IF HRUOM.FINDFIRST() THEN BEGIN
          GetUOMConversionRate := HRUOM."Qty. per Unit of Measure";
        END;
        IF NOT HRUOM.FINDFIRST() THEN BEGIN
          IF GetUOM <> '' THEN BEGIN
            ERROR('Reporting UOM not available');
          END;
        END;

        HRSETUP.GET();
        BaseUOM := HRSETUP."Base Unit of Measure";
        ReportingRateCode := HRSETUP."Reporting Rate";
        CurrentYear := HRSETUP."Current Payroll Year";

        HRUOM.INIT;
        HRUOM.RESET;
        HRUOM.SETRANGE(Code, BaseUOM);
        IF HRUOM.FINDFIRST() THEN BEGIN
          BaseUOMRate := HRUOM."Qty. per Unit of Measure";
        END;

        HRUOM.INIT;
        HRUOM.RESET;
        HRUOM.SETRANGE(Code, ReportingRateCode);
        IF HRUOM.FINDFIRST() THEN BEGIN
          ReportingConversionRate := HRUOM."Qty. per Unit of Measure";
        END;


        EmployeeAbsence.INIT;
        EmployeeAbsence.RESET;
        IF EmployeeAbsence.FINDFIRST() THEN REPEAT
          EmployeeAbsence."Prior Year" := FALSE;
          Year := DATE2DMY(EmployeeAbsence."To Date",3);
          IF Year < CurrentYear THEN BEGIN
            EmployeeAbsence."Prior Year" := TRUE;
          END;
          EmployeeAbsence.MODIFY;
        UNTIL EmployeeAbsence.NEXT = 0;

        EMP.INIT;
        EMP.RESET;
        IF EMP.FINDFIRST() THEN REPEAT
          EmployeeAbsence.INIT;
          EmployeeAbsence.RESET;
          EmployeeAbsence.SETRANGE("Employee No.", EMP."No.");
          IF EmployeeAbsence.FINDFIRST() THEN REPEAT
            EmployeeAbsence.Rate := EMP."Employee Rate";
            IF EmployeeAbsence."Unit of Measure Code" = BaseUOM THEN BEGIN
              EmployeeAbsence.Amount := ((EmployeeAbsence.Rate * EmployeeAbsence.Quantity) / ReportingConversionRate);
            END;
            IF EmployeeAbsence."Unit of Measure Code" <> BaseUOM THEN BEGIN
              EmployeeAbsence.Amount := ((EmployeeAbsence.Rate * EmployeeAbsence.Quantity) * BaseUOMRate);
            END;
            EmployeeAbsence.MODIFY;
          UNTIL EmployeeAbsence.NEXT = 0;
        UNTIL EMP.NEXT = 0;
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        ReportingUOMConversion : Decimal;
        HRUOM : Record "Human Resource Unit of Measure";
        ReportingUOM : Code[10];
        GetUOM : Code[10];
        BaseUOM : Code[10];
        BaseUOMRate : Decimal;
        GetUOMConversionRate : Decimal;
        ReportingConversionRate : Decimal;
        ReportingRateCode : Code[10];
        PrintUOM : Code[10];
        PrintQuantity : Decimal;
        PrintAmount : Decimal;
        PrintRate : Decimal;
        PrintQtyPerUnit : Decimal;
        EmployeeAbsence : Record "Employee Absence";
        CurrentYear : Integer;
        Year : Integer;
        EMP : Record "Employee Pay Details";
}

