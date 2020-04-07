page 5233 "Human Resources Setup"
{
    // version NAVW110.00, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Human Resources Setup',
                ENA='Human Resources Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategoriesML = ENU='New,Process,Report,Employee,Documents',
                                 ENA='New,Process,Report,Employee,Documents';
    SourceTable = "Human Resources Setup";

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                CaptionML = ENU='Numbering',
                            ENA='Numbering';
                field("Employee Nos.";"Employee Nos.")
                {
                    ToolTipML = ENU='Specifies the number series code to use when assigning numbers to employees.',
                                ENA='Specifies the number series code to use when assigning numbers to employees.';
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ToolTipML = ENU='Specifies the base unit of measure, such as hour or day.',
                                ENA='Specifies the base unit of measure, such as hour or day.';
                }
                field("Reporting Rate";"Reporting Rate")
                {
                }
                field("Country/Region Code";"Country/Region Code")
                {
                }
                field("Current Payroll Year";"Current Payroll Year")
                {
                    Editable = false;
                }
                field("New Payroll Year";"New Payroll Year")
                {
                }
                field("Import Timesheet";"Import Timesheet")
                {
                }
                field("Import Employee Pay Elements";"Import Employee Pay Elements")
                {
                }
                field("Enforce Schedule Release";"Enforce Schedule Release")
                {
                }
                field("Pay Element Deletion";"Pay Element Deletion")
                {
                }
            }
            group("Electronic Banking")
            {
                field("Payroll Bank Account";"Payroll Bank Account")
                {
                }
                field("Payroll Clearing Account No.";"Payroll Clearing Account No.")
                {
                }
                field("Westpac Registration No.";"Westpac Registration No.")
                {
                }
                field("By Pass WBC Registration No.";"By Pass WBC Registration No.")
                {
                }
            }
            group("PAYE Details")
            {
                field("Employer Branch No.";"Employer Branch No.")
                {
                }
                field("Employer TIN No.";"Employer TIN No.")
                {
                    Editable = false;
                }
                field("Global Secondary Tax";"Global Secondary Tax")
                {
                }
            }
            group("Master Pay Elements")
            {
                field("Normal Hours";"Normal Hours")
                {
                }
                field(FNPF;FNPF)
                {
                }
                field(PAYE;PAYE)
                {
                }
                field(SRT;SRT)
                {
                }
                field(ECAL;ECAL)
                {
                }
            }
            group("FNPF Details")
            {
                field("Employer Reference No.";"Employer Reference No.")
                {
                }
                field("Contribution Type";"Contribution Type")
                {
                }
                field("Global FNPF Contribution";"Global FNPF Contribution")
                {
                }
                field("Employer FNPF Contribution";"Employer FNPF Contribution")
                {
                }
            }
            group(Reporting)
            {
                group("GL Integration")
                {
                    field("Payroll Journal Template";"Payroll Journal Template")
                    {
                    }
                    field("Payroll Journal Batch";"Payroll Journal Batch")
                    {
                    }
                    field("Payroll Journal Doc. No.";"Payroll Journal Doc. No.")
                    {
                    }
                    field("GL Integration Dimension";"GL Integration Dimension")
                    {
                    }
                    field("Account Type";"Account Type")
                    {
                    }
                    field("Account No.";"Account No.")
                    {
                    }
                    field("Bal. Account Type";"Bal. Account Type")
                    {
                    }
                    field("Bal. Account No.";"Bal. Account No.")
                    {
                    }
                    field("By-Pass Payroll Account Use";"By-Pass Payroll Account Use")
                    {
                    }
                    group("FNPF Employer Posting")
                    {
                        field("Employer FNPF Account Type";"Employer FNPF Account Type")
                        {
                        }
                        field("Employer FNPF Account No.";"Employer FNPF Account No.")
                        {
                        }
                        field("Employer FNPF Bal Account Type";"Employer FNPF Bal Account Type")
                        {
                        }
                        field("Employer FNPF Bal. Account No.";"Employer FNPF Bal. Account No.")
                        {
                        }
                    }
                    group(Control1000000063)
                    {
                        field("Enable FNTC Deduction";"Enable FNTC Deduction")
                        {
                        }
                        field("FNTC Account Type";"FNTC Account Type")
                        {
                        }
                        field("FNTC Account No.";"FNTC Account No.")
                        {
                        }
                        field("FNTC Bal. Account Type";"FNTC Bal. Account Type")
                        {
                        }
                        field("FNTC Bal. Account No.";"FNTC Bal. Account No.")
                        {
                        }
                    }
                }
                group("Electronic Output Directory")
                {
                    field("PAYE Output Directory";"PAYE Output Directory")
                    {
                    }
                    field("FNPF Output Directory";"FNPF Output Directory")
                    {
                    }
                    field("Payroll Bank Directory";"Payroll Bank Directory")
                    {
                    }
                }
                group(Encryption)
                {
                    field("Encryption Program";"Encryption Program")
                    {
                    }
                    field("Encryption Directory";"Encryption Directory")
                    {
                    }
                }
                group("Payroll Register Dynamic")
                {
                    field("Show Rate";"Show Rate")
                    {
                    }
                    field("Show 1.0x Hours";"Show 1.0x Hours")
                    {
                    }
                    field("Show 1.5x Hours";"Show 1.5x Hours")
                    {
                    }
                    field("Show 2.0x Hours";"Show 2.0x Hours")
                    {
                    }
                }
                group("With Holding Tax Certificate")
                {
                    field("WHT Start Date";"WHT Start Date")
                    {
                    }
                    field("WHT End Date";"WHT End Date")
                    {
                    }
                    field("Print Specific TWC";"Print Specific TWC")
                    {

                        trigger OnValidate();
                        begin
                            //ASHNEIL CHANDRA   13072017
                            IF "Print Specific TWC" = FALSE THEN BEGIN
                              EmployeePayDetails.INIT;
                              EmployeePayDetails.RESET;
                              IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                                EmployeePayDetails."Print TWC" := FALSE;
                                EmployeePayDetails.MODIFY;
                              UNTIL EmployeePayDetails.NEXT = 0;
                            END;
                            //ASHNEIL CHANDRA   13072017
                        end;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Human Res. Units of Measure")
            {
                CaptionML = ENU='Human Res. Units of Measure',
                            ENA='Human Res. Units of Measure';
                Image = UnitOfMeasure;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Human Res. Units of Measure";
                ToolTipML = ENU='Set up the units of measure, such as DAY or HOUR, that you can select from in the Human Resources Setup window to define how employment time is recorded.',
                            ENA='Set up the units of measure, such as DAY or HOUR, that you can select from in the Human Resources Setup window to define how employment time is recorded.';
            }
            action("Causes of Absence")
            {
                CaptionML = ENU='Causes of Absence',
                            ENA='Causes of Absence';
                Image = AbsenceCategory;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Causes of Absence";
                ToolTipML = ENU='Set up reasons why an employee can be absent.',
                            ENA='Set up reasons why an employee can be absent.';
            }
            action("Causes of Inactivity")
            {
                CaptionML = ENU='Causes of Inactivity',
                            ENA='Causes of Inactivity';
                Image = InactivityDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Causes of Inactivity";
                ToolTipML = ENU='Set up reasons why an employee can be inactive.',
                            ENA='Set up reasons why an employee can be inactive.';
            }
            action("Grounds for Termination")
            {
                CaptionML = ENU='Grounds for Termination',
                            ENA='Grounds for Termination';
                Image = TerminationDescription;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Grounds for Termination";
                ToolTipML = ENU='Set up reasons why an employment can be terminated.',
                            ENA='Set up reasons why an employment can be terminated.';
            }
            action(Unions)
            {
                CaptionML = ENU='Unions',
                            ENA='Unions';
                Image = Union;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page Unions;
                ToolTipML = ENU='Set up different worker unions that employees may be members of, so that you can select it on the employee card.',
                            ENA='Set up different worker unions that employees may be members of, so that you can select it on the employee card.';
            }
            action("Employment Contracts")
            {
                CaptionML = ENU='Employment Contracts',
                            ENA='Employment Contracts';
                Image = EmployeeAgreement;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Employment Contracts";
                ToolTipML = ENU='Set up the different types of contracts that employees can be employed under, such as Administration or Production.',
                            ENA='Set up the different types of contracts that employees can be employed under, such as Administration or Production.';
            }
            action(Relatives)
            {
                CaptionML = ENU='Relatives',
                            ENA='Relatives';
                Image = Relatives;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page Relatives;
                ToolTipML = ENU='Set up the types of relatives that you can select from on employee cards.',
                            ENA='Set up the types of relatives that you can select from on employee cards.';
            }
            action("Misc. Articles")
            {
                CaptionML = ENU='Misc. Articles',
                            ENA='Misc. Articles';
                Image = Archive;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Misc. Articles";
                ToolTipML = ENU='Set up types of company assets that employees use, such as CAR or COMPUTER, that you can select from on employee cards.',
                            ENA='Set up types of company assets that employees use, such as CAR or COMPUTER, that you can select from on employee cards.';
            }
            action(Confidential)
            {
                CaptionML = ENU='Confidential',
                            ENA='Confidential';
                Image = ConfidentialOverview;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page Confidential;
                ToolTipML = ENU='Set up types of confidential information, such as SALARY or INSURANCE, that you can select from on employee cards.',
                            ENA='Set up types of confidential information, such as SALARY or INSURANCE, that you can select from on employee cards.';
            }
            action(Qualifications)
            {
                CaptionML = ENU='Qualifications',
                            ENA='Qualifications';
                Image = QualificationOverview;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page Qualifications;
                ToolTipML = ENU='Set up types of qualifications, such as DESIGN or ACCOUNTANT, that you can select from on employee cards.',
                            ENA='Set up types of qualifications, such as DESIGN or ACCOUNTANT, that you can select from on employee cards.';
            }
            action("Employee Statistics Groups")
            {
                CaptionML = ENU='Employee Statistics Groups',
                            ENA='Employee Statistics Groups';
                Image = StatisticsGroup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Employee Statistics Groups";
                ToolTipML = ENU='Set up salary types, such as HOURLY or MONTHLY, that you use for statistical purposes.',
                            ENA='Set up salary types, such as HOURLY or MONTHLY, that you use for statistical purposes.';
            }
        }
        area(processing)
        {
            action("Create New Payroll Year")
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   17072017
                    IF "New Payroll Year" = 0 THEN BEGIN
                      ERROR('New Year can not be Zero');
                    END;
                    //ASHNEIL CHANDRA   17072017

                    //ASHNEIL CHANDRA   13072017
                    CurrentDate := TODAY;
                    CurrentYear := DATE2DMY(CurrentDate,3);

                    //ASHNEIL CHANDRA   17072017
                    NewYear := "New Payroll Year";
                    IF NewYear > CurrentYear THEN BEGIN
                      ERROR('Current Year is %1', CurrentYear);
                    END;
                    //ASHNEIL CHANDRA   17072017

                    IF "Country/Region Code" = '' THEN BEGIN
                      ERROR('Country/Region Code is blank');
                      EXIT;
                    END;

                    IF "Current Payroll Year" = CurrentYear THEN BEGIN
                      ERROR('Payroll Year already exists');
                      EXIT;
                    END;

                    IF "Current Payroll Year" < CurrentYear THEN BEGIN

                      OldYear := FORMAT("Current Payroll Year");

                      IF NOT BranchPolicy.FINDFIRST() THEN BEGIN
                        ERROR('No Branch Policy record exist');
                        EXIT;
                      END;

                      IF NOT Employee.FINDFIRST() THEN BEGIN
                        ERROR('No Employee record exist');
                        EXIT;
                      END;

                      IF NOT IncomeTaxMaster.FINDFIRST() THEN BEGIN
                        ERROR('No Income Tax record exist');
                        EXIT;
                      END;

                      "Current Payroll Year" := "New Payroll Year";
                      MODIFY;

                      Employee.INIT;
                      Employee.RESET;
                      IF Employee.FIND('-') THEN REPEAT
                        IF Employee.Terminated = FALSE THEN BEGIN
                          Employee."Calendar Code" := FORMAT(CurrentYear);
                          Employee.MODIFY;
                        END;
                      UNTIL Employee.NEXT = 0;

                      EmployeePayDetails.INIT;
                      EmployeePayDetails.RESET;
                      IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                        IF EmployeePayDetails.Terminated = FALSE THEN BEGIN
                          EmployeePayDetails."Calendar Code" := FORMAT(CurrentYear);
                          EmployeePayDetails.MODIFY;
                        END;
                      UNTIL EmployeePayDetails.NEXT = 0;

                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      IF EmployeePayTable.FINDFIRST() THEN REPEAT
                        EmployeePayTable."Calendar Code" := FORMAT(CurrentYear);
                        EmployeePayTable.MODIFY;
                      UNTIL EmployeePayTable.NEXT = 0;

                      BEGINYEAR := '0101' + FORMAT("Current Payroll Year");
                      ENDYEAR := '3112' + FORMAT("Current Payroll Year");
                      EVALUATE(VARBEGINYEAR, BEGINYEAR);
                      EVALUATE(VARENDYEAR, ENDYEAR);

                      IncomeTaxMaster.INIT;
                      IncomeTaxMaster.RESET;
                      IF IncomeTaxMaster.FINDFIRST() THEN REPEAT
                        IncomeTaxMaster."Period From" := VARBEGINYEAR;
                        IncomeTaxMaster."Period To" := VARENDYEAR;
                        IncomeTaxMaster."Payroll Year" := "Current Payroll Year";
                        IncomeTaxMaster.MODIFY;
                      UNTIL IncomeTaxMaster.NEXT = 0;

                      MESSAGE('Payroll Year Created');

                      BranchPolicy.INIT;
                      BranchPolicy.RESET;
                      BranchPolicy.SETRANGE("Calendar Code", OldYear);
                      IF BranchPolicy.FINDFIRST() THEN REPEAT
                        TemporaryBranchPolicy.TRANSFERFIELDS(BranchPolicy);
                        BranchPolicy."Branch Code" := TemporaryBranchPolicy."Branch Code";
                        BranchPolicy."Shift Code" := TemporaryBranchPolicy."Shift Code";
                        BranchPolicy."Calendar Code" := FORMAT("Current Payroll Year");
                        BranchPolicy."Statistics Group" := TemporaryBranchPolicy."Statistics Group";
                        BranchPolicy."Branch Name" := TemporaryBranchPolicy."Branch Name";
                        BranchPolicy."Runs Per Calendar" := TemporaryBranchPolicy."Runs Per Calendar";
                        BranchPolicy."Pay Calculation Type" := TemporaryBranchPolicy."Pay Calculation Type";
                        BranchPolicy.Release := TemporaryBranchPolicy.Release;
                        BranchPolicy.INSERT;
                      UNTIL BranchPolicy.NEXT = 0;
                    END;

                    //ASHNEIL CHANDRA   02082017
                    IF CurrentYear = "New Payroll Year" THEN BEGIN
                    IF "Current Payroll Year" > CurrentYear THEN BEGIN

                      IF NOT BranchPolicy.FINDFIRST() THEN BEGIN
                        ERROR('No Branch Policy record exist');
                        EXIT;
                      END;

                      IF NOT Employee.FINDFIRST() THEN BEGIN
                        ERROR('No Employee record exist');
                        EXIT;
                      END;

                      IF NOT IncomeTaxMaster.FINDFIRST() THEN BEGIN
                        ERROR('No Income Tax record exist');
                        EXIT;
                      END;

                      "Current Payroll Year" := "New Payroll Year";
                      MODIFY;

                      Employee.INIT;
                      Employee.RESET;
                      IF Employee.FIND('-') THEN REPEAT
                        IF Employee.Terminated = FALSE THEN BEGIN
                          Employee."Calendar Code" := FORMAT(CurrentYear);
                          Employee.MODIFY;
                        END;
                      UNTIL Employee.NEXT = 0;

                      EmployeePayDetails.INIT;
                      EmployeePayDetails.RESET;
                      IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                        IF EmployeePayDetails.Terminated = FALSE THEN BEGIN
                          EmployeePayDetails."Calendar Code" := FORMAT(CurrentYear);
                          EmployeePayDetails.MODIFY;
                        END;
                      UNTIL EmployeePayDetails.NEXT = 0;

                      BEGINYEAR := '0101' + FORMAT("Current Payroll Year");
                      ENDYEAR := '3112' + FORMAT("Current Payroll Year");
                      EVALUATE(VARBEGINYEAR, BEGINYEAR);
                      EVALUATE(VARENDYEAR, ENDYEAR);

                      IncomeTaxMaster.INIT;
                      IncomeTaxMaster.RESET;
                      IF IncomeTaxMaster.FINDFIRST() THEN REPEAT
                        IncomeTaxMaster."Period From" := VARBEGINYEAR;
                        IncomeTaxMaster."Period To" := VARENDYEAR;
                        IncomeTaxMaster."Payroll Year" := "Current Payroll Year";
                        IncomeTaxMaster.MODIFY;
                      UNTIL IncomeTaxMaster.NEXT = 0;

                      MESSAGE('Payroll Year Updated');
                    END;
                    END;
                    //ASHNEIL CHANDRA   02082017

                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action(Release)
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    Release := TRUE;
                    MODIFY;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action(Reopen)
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    Release := FALSE;
                    MODIFY;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
        }
    }

    trigger OnClosePage();
    begin
        //ASHNEIL CHANDRA   17072017
        IF "Current Payroll Year" = 0 THEN BEGIN
          MESSAGE('Current Payroll Year not setup');
        END;
        //ASHNEIL CHANDRA   17072017
    end;

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
          INIT;
          INSERT;
        END;


        //ASHNEIL CHANDRA   13072017
        CompanyInfo.GET();
        IF CompanyInfo."VAT Registration No." <> '' THEN BEGIN
          "Employer TIN No." := CompanyInfo."VAT Registration No.";
          MODIFY;
        END;

        IF CompanyInfo."VAT Registration No." = '' THEN BEGIN
          ERROR('VAT Registration No. in Company Information not defined');
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    var
        Employee : Record Employee;
        CurrentYear : Integer;
        CurrentDate : Date;
        BEGINYEAR : Text[30];
        ENDYEAR : Text[30];
        VARBEGINYEAR : Date;
        VARENDYEAR : Date;
        IncomeTaxMaster : Record "Income Tax Master";
        BranchPolicy : Record "Branch Policy";
        NoSeries : Record "No. Series Line";
        OldYear : Code[4];
        TemporaryBranchPolicy : Record "Branch Policy" temporary;
        CompanyInfo : Record "Company Information";
        EmployeePayDetails : Record "Employee Pay Details";
        EmployeePayTable : Record "Employee Pay Table";
        NewYear : Integer;
}

