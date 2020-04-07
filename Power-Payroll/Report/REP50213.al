report 50213 "Employee Leave Status Summary"
{
    // version ASHNEILCHANDRA_PAYROLL

    DefaultLayout = RDLC;
    RDLCLayout = './Employee Leave Status Summary.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(No_Employee;Employee."No.")
            {
            }
            column(SearchName_Employee;Employee."Search Name")
            {
            }
            column(DisplayHeader1;DisplayHeader[1])
            {
            }
            column(DisplayHeader2;DisplayHeader[2])
            {
            }
            column(DisplayHeader3;DisplayHeader[3])
            {
            }
            column(DisplayHeader4;DisplayHeader[4])
            {
            }
            column(DisplayHeader5;DisplayHeader[5])
            {
            }
            column(DisplayHeader6;DisplayHeader[6])
            {
            }
            column(DisplayHeader7;DisplayHeader[7])
            {
            }
            column(DisplayHeader8;DisplayHeader[8])
            {
            }
            column(DisplayHeader9;DisplayHeader[9])
            {
            }
            column(DisplayHeader10;DisplayHeader[10])
            {
            }
            column(DisplayHeader11;DisplayHeader[11])
            {
            }
            column(DisplayHeader12;DisplayHeader[12])
            {
            }
            column(DisplayHeader13;DisplayHeader[13])
            {
            }
            column(DisplayHeader14;DisplayHeader[14])
            {
            }
            column(DisplayHeader15;DisplayHeader[15])
            {
            }
            column(DisplayHeader16;DisplayHeader[16])
            {
            }
            column(DisplayHeader17;DisplayHeader[17])
            {
            }
            column(DisplayHeader18;DisplayHeader[18])
            {
            }
            column(DisplayHeader19;DisplayHeader[19])
            {
            }
            column(DisplayHeader20;DisplayHeader[20])
            {
            }
            column(DisplayAmount1;DisplayAmount[1])
            {
            }
            column(DisplayAmount2;DisplayAmount[2])
            {
            }
            column(DisplayAmount3;DisplayAmount[3])
            {
            }
            column(DisplayAmount4;DisplayAmount[4])
            {
            }
            column(DisplayAmount5;DisplayAmount[5])
            {
            }
            column(DisplayAmount6;DisplayAmount[6])
            {
            }
            column(DisplayAmount7;DisplayAmount[7])
            {
            }
            column(DisplayAmount8;DisplayAmount[8])
            {
            }
            column(DisplayAmount9;DisplayAmount[9])
            {
            }
            column(DisplayAmount10;DisplayAmount[10])
            {
            }
            column(DisplayAmount11;DisplayAmount[11])
            {
            }
            column(DisplayAmount12;DisplayAmount[12])
            {
            }
            column(DisplayAmount13;DisplayAmount[13])
            {
            }
            column(DisplayAmount14;DisplayAmount[14])
            {
            }
            column(DisplayAmount15;DisplayAmount[15])
            {
            }
            column(DisplayAmount16;DisplayAmount[16])
            {
            }
            column(DisplayAmount17;DisplayAmount[17])
            {
            }
            column(DisplayAmount18;DisplayAmount[18])
            {
            }
            column(DisplayAmount19;DisplayAmount[19])
            {
            }
            column(DisplayAmount20;DisplayAmount[20])
            {
            }

            trigger OnAfterGetRecord();
            begin
                FOR i := 1 TO MAXPriority DO
                IF i <= MAXPriority THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Leave Report", TRUE);
                  PayElementMaster.SETRANGE("Leave Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayAmount[i] := 0;

                    EmployeeAbsence.INIT;
                    EmployeeAbsence.RESET;
                    EmployeeAbsence.SETRANGE("Employee No.", "No.");
                    EmployeeAbsence.SETRANGE("Pay Code", PayElementMaster."Pay Code");
                    IF EmployeeAbsence.FINDFIRST() THEN BEGIN
                      DisplayAmount[i] := 0;
                      DisplayAmount[i] := EmployeeAbsence.Amount;
                    END;
                  END;
                END;

                FOR i := 1 TO MAXPriority DO
                IF i <= MAXPriority THEN BEGIN
                  PayElementMaster.INIT;
                  PayElementMaster.RESET;
                  PayElementMaster.SETRANGE("Use in Leave Report", TRUE);
                  PayElementMaster.SETRANGE("Leave Column Priority", i);
                  IF PayElementMaster.FINDFIRST() THEN BEGIN
                    DisplayHeader[i] := PayElementMaster."Leave Column Name";
                    IF PayElementMaster."Leave Column Name" = '' THEN BEGIN
                      DisplayHeader[i] := PayElementMaster."Pay Description";
                    END;
                  END;
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

    trigger OnPreReport();
    begin
        MAXPriority := 0;
        Priority := 0;

        PayElementMaster.INIT;
        PayElementMaster.RESET;
        PayElementMaster.SETRANGE("Use in Leave Report", TRUE);
        IF PayElementMaster.FINDFIRST() THEN REPEAT
          MAXPriority := PayElementMaster."Leave Column Priority";
          IF Priority < MAXPriority THEN BEGIN
            Priority := PayElementMaster."Leave Column Priority";
          END;
        UNTIL PayElementMaster.NEXT = 0;
    end;

    var
        DisplayHeader : array [20] of Text[30];
        DisplayAmount : array [20] of Decimal;
        PayCode : array [20] of Code[10];
        PayElementMaster : Record "Pay Element Master";
        MAXPriority : Integer;
        Priority : Integer;
        i : Integer;
        EmployeeAbsence : Record "Employee Absence";
}

