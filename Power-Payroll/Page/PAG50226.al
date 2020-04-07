page 50226 "Employee Pay Details"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    PageType = Card;
    SourceTable = "Employee Pay Details";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    Editable = false;
                    Importance = Promoted;
                }
                field("Employee Name";"Employee Name")
                {
                    Editable = false;
                }
                field(Terminated;Terminated)
                {
                    Editable = false;
                }
                field("Payment Frequency";"Payment Frequency")
                {
                    Editable = false;
                }
                field("Employment Status";"Employment Status")
                {
                    Editable = false;
                }
            }
            group("Branch Policy")
            {
                Caption = 'Branch Policy';
                field("Branch Code";"Branch Code")
                {
                    Editable = false;
                }
                field("Shift Code";"Shift Code")
                {
                    Editable = false;
                }
                field("Calendar Code";"Calendar Code")
                {
                    Editable = false;
                }
                field("Statistics Group";"Statistics Group")
                {
                    Editable = false;
                }
                field("Sub Branch Code";"Sub Branch Code")
                {
                }
            }
            group("Basic Pay")
            {
                Caption = 'Basic Pay';
                field("Annual Pay";"Annual Pay")
                {
                    Editable = false;
                }
                field("Gross Standard Pay";"Gross Standard Pay")
                {
                }
                field("Employee Rate";"Employee Rate")
                {
                }
                field(Units;Units)
                {
                    Editable = false;
                }
                field("Runs Per Calendar";"Runs Per Calendar")
                {
                }
            }
            group("Primary Bank")
            {
                Caption = 'Primary Bank';
                field("Bank Code";"Bank Code")
                {
                }
                field("Bank Account No.";"Bank Account No.")
                {
                }
                field("Payee Narrative";"Payee Narrative")
                {
                }
                field("Payee Code";"Payee Code")
                {
                }
                field("Payee Particulars";"Payee Particulars")
                {
                }
                field("Payment Method";"Payment Method")
                {
                }
            }
            group(PAYE)
            {
                Caption = 'PAYE';
                field("Employee TIN";"Employee TIN")
                {
                    Importance = Promoted;
                }
                field("Employment Start Date";"Employment Start Date")
                {
                    Editable = false;
                }
                field("Employment End Date";"Employment End Date")
                {
                    Editable = false;
                }
                field("Residential/Non-Residential";"Residential/Non-Residential")
                {
                }
                field("Tax Code";"Tax Code")
                {
                }
                field("Employee Secondary Tax";"Employee Secondary Tax")
                {
                }
            }
            group(FNPF)
            {
                Caption = 'FNPF';
                field("Employee FNPF";"Employee FNPF")
                {
                    Importance = Promoted;
                }
                field("Employee FNPF Additional Cont.";"Employee FNPF Additional Cont.")
                {
                }
                field("Employer FNPF Additional Cont.";"Employer FNPF Additional Cont.")
                {
                }
                field("Occupation Code";"Occupation Code")
                {
                }
                field("By Pass FNPF";"By Pass FNPF")
                {
                }
            }
            group("Foreign Currency")
            {
                Caption = 'Foreign Currency';
                field("Foreign Currency";"Foreign Currency")
                {
                }
                field("Currency Code";"Currency Code")
                {
                }
                field("Currency Date";"Currency Date")
                {
                }
                field("Currency Exchange Rate";"Currency Exchange Rate")
                {
                }
                field("FX Gross Standard Pay";"FX Gross Standard Pay")
                {
                }
            }
            group("GL Intergration")
            {
                CaptionML = ENU='GL Intergration',
                            ENA='GL Intergration';
                Visible = false;
                field("DR Account Type";"DR Account Type")
                {
                }
                field("DR Account No.";"DR Account No.")
                {
                }
                field("CR Account Type";"CR Account Type")
                {
                }
                field("CR Account No.";"CR Account No.")
                {
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Print TWC";"Print TWC")
                {
                }
                field("Comment 1";"Comment 1")
                {
                }
                field("Comment 2";"Comment 2")
                {
                }
            }
            part(Control1000000034;"Employee Pay Table CardPart")
            {
                SubPageLink = Employee No.=FIELD(No.);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Multiple Bank Distribution")
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    IF "Bank Account No." <> '' THEN BEGIN
                      MultipleBankDistribution.SETRANGE("Employee No.", "No.");
                      PAGE.RUN(50214,MultipleBankDistribution);
                    END;

                    IF "Bank Account No." = '' THEN BEGIN
                      ERROR('Bank Account No. cannot be blank.');
                    END;
                    //ASHNEIL CHANDRA  13072017
                end;
            }
            action("Record Pay to Date")
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    PayToDateAdjustment.SETRANGE("Branch Code", "Branch Code");
                    PayToDateAdjustment.SETRANGE("Shift Code", "Shift Code");
                    PayToDateAdjustment.SETRANGE("Calendar Code", "Calendar Code");
                    PayToDateAdjustment.SETRANGE("Statistics Group", "Statistics Group");
                    PayToDateAdjustment.SETRANGE("Employee No.", "No.");
                    PAGE.RUN(50223,PayToDateAdjustment);
                    //ASHNEIL CHANDRA  13072017
                end;
            }
            action("Employee Pay History")
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    EmployeePayHistory.SETRANGE("Employee No.", "No.");
                    PAGE.RUN(50224,EmployeePayHistory);
                    //ASHNEIL CHANDRA  13072017
                end;
            }
            action(Release)
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    IF Release = FALSE THEN BEGIN
                      Release := TRUE;
                      MODIFY;
                      MESSAGE('Released');
                    END;
                    //ASHNEIL CHANDRA  13072017
                end;
            }
            action(Reopen)
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    IF Release = TRUE THEN BEGIN
                      Release := FALSE;
                      MODIFY;
                      MESSAGE('Reopened');
                    END;
                    //ASHNEIL CHANDRA  13072017
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //ASHNEIL CHANDRA  13072017
        IF "Employee Name" = '' THEN BEGIN
          IF Employee.GET("No.") THEN BEGIN
            "Employee Name" :=  Employee."First Name" + ' ' + Employee."Last Name";
            MODIFY;
          END;
        END;
        //ASHNEIL CHANDRA  13072017
    end;

    var
        MultipleBankDistribution : Record "Multiple Bank Distribution";
        PayToDateAdjustment : Record "Pay to Date Adjustment";
        EmployeePayHistory : Record "Employee Pay History";
        Employee : Record Employee;
}

