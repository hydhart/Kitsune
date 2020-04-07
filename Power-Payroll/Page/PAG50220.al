page 50220 "Leave Entitlement"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = Card;
    SourceTable = "Integer";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No.";"Employee No.")
                {
                    TableRelation = Employee;

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        EmployeeAbsence.INIT;
                        EmployeeAbsence.RESET;
                        IF EmployeeAbsence.FINDLAST() THEN BEGIN
                          "EntryNo." := EmployeeAbsence."Entry No.";
                        END;
                        IF NOT EmployeeAbsence.FINDLAST() THEN BEGIN
                          "EntryNo." := 0;
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field("From Date";"From Date")
                {
                }
                field("To Date";"To Date")
                {
                }
                field("Pay Code";"Pay Code")
                {
                    TableRelation = "Pay Element Master";

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        PayElementMaster.INIT;
                        PayElementMaster.RESET;
                        PayElementMaster.SETRANGE("Pay Code", "Pay Code");
                        IF PayElementMaster.FINDFIRST() THEN BEGIN
                          IF PayElementMaster."Leave Type" = '' THEN BEGIN
                            ERROR('Leave Type is blank for pay code %1', PayElementMaster."Pay Code");
                          END;
                          IF PayElementMaster."Leave Type" <> '' THEN BEGIN
                            Description := PayElementMaster."Pay Description";
                            CauseOfAbsense := PayElementMaster."Leave Type";
                          END;
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Description;Description)
                {
                }
                field("Unit of Measure Code";"Unit Of Measure Code")
                {
                    TableRelation = "Human Resource Unit of Measure";

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        HRSETUP.GET();
                        BaseUOM := HRSETUP."Base Unit of Measure";
                        ReportingRateCode := HRSETUP."Reporting Rate";

                        HRUOM.INIT;
                        HRUOM.RESET;
                        IF HRUOM.GET(BaseUOM) THEN BEGIN
                          HRUOMRate := HRUOM."Qty. per Unit of Measure";
                        END;

                        HRUOM.INIT;
                        HRUOM.RESET;
                        IF HRUOM.GET(ReportingRateCode) THEN BEGIN
                          ReportingRateConversion := HRUOM."Qty. per Unit of Measure";
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Units;Units)
                {

                    trigger OnValidate();
                    begin
                        //ASHNEIL CHANDRA  13072017
                        EmployeePayDetails.INIT;
                        EmployeePayDetails.RESET;
                        EmployeePayDetails.SETRANGE("No.", "Employee No.");
                        IF EmployeePayDetails.FINDFIRST() THEN BEGIN
                          Rate := EmployeePayDetails."Employee Rate";
                          IF "Unit Of Measure Code" = BaseUOM THEN BEGIN
                            Amount := (Rate * Units) / ReportingRateConversion;
                          END;
                          IF "Unit Of Measure Code" <> BaseUOM THEN BEGIN
                            Amount := (Rate * Units) * HRUOMRate;
                          END;
                        END;
                        //ASHNEIL CHANDRA  13072017
                    end;
                }
                field(Rate;Rate)
                {
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Add Record")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    EmployeeAbsence.INIT;
                    EmployeeAbsence.RESET;
                    EmployeeAbsence.SETRANGE("Entry No.", "EntryNo." + 1);
                    IF NOT EmployeeAbsence.FINDFIRST() THEN BEGIN
                      EmployeeAbsence."Entry No." := "EntryNo." + 1;
                      EmployeeAbsence."Employee No." := "Employee No.";
                      EmployeeAbsence."From Date" := "From Date";
                      EmployeeAbsence."To Date" := "To Date";
                      EmployeeAbsence."Pay Code" := "Pay Code";
                      EmployeeAbsence.Description := Description;
                      EmployeeAbsence."Cause of Absence Code" := CauseOfAbsense;
                      EmployeeAbsence."Unit of Measure Code" := "Unit Of Measure Code";
                      EmployeeAbsence.Quantity := Units;
                      EmployeeAbsence.Rate := Rate;
                      EmployeeAbsence.Amount := Amount;
                      EmployeeAbsence.Tag := 'Entitled';
                      EmployeeAbsence.INSERT;
                    END;
                    //ASHNEIL CHANDRA  13072017
                end;
            }
        }
    }

    var
        "From Date" : Date;
        "To Date" : Date;
        "Pay Code" : Code[10];
        Description : Text[50];
        CauseOfAbsense : Code[10];
        "Unit Of Measure Code" : Code[10];
        Units : Decimal;
        Rate : Decimal;
        Amount : Decimal;
        PayElementMaster : Record "Pay Element Master";
        "Employee No." : Code[20];
        EmployeeAbsence : Record "Employee Absence";
        "EntryNo." : Integer;
        HRUOM : Record "Human Resource Unit of Measure";
        HRSETUP : Record "Human Resources Setup";
        BaseUOM : Code[10];
        ReportingRateConversion : Decimal;
        ReportingRateCode : Code[10];
        HRUOMRate : Decimal;
        EmployeePayDetails : Record "Employee Pay Details";
}

