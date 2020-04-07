page 5201 "Employee List"
{
    // version NAVW110.00.00.16585, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Employee List',
                ENA='Employee List';
    CardPageID = "Employee Card";
    Editable = false;
    PageType = List;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ToolTipML = ENU='Specifies a number for the employee.',
                                ENA='Specifies a number for the employee.';
                }
                field(FullName;FullName)
                {
                    CaptionML = ENU='Full Name',
                                ENA='Full Name';
                    ToolTipML = ENU='Specifies the full name of the employee.',
                                ENA='Specifies the full name of the employee.';
                }
                field("First Name";"First Name")
                {
                    ToolTipML = ENU='Specifies the employee''s first name.',
                                ENA='Specifies the employee''s first name.';
                    Visible = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ToolTipML = ENU='Specifies the employee''s middle name.',
                                ENA='Specifies the employee''s middle name.';
                    Visible = false;
                }
                field("Last Name";"Last Name")
                {
                    ToolTipML = ENU='Specifies the employee''s last name.',
                                ENA='Specifies the employee''s last name.';
                    Visible = false;
                }
                field(Initials;Initials)
                {
                    ToolTipML = ENU='Specifies the employee''s initials.',
                                ENA='Specifies the employee''s initials.';
                    Visible = false;
                }
                field("Job Title";"Job Title")
                {
                    ToolTipML = ENU='Specifies the employee''s job title.',
                                ENA='Specifies the employee''s job title.';
                }
                field("Post Code";"Post Code")
                {
                    ToolTipML = ENU='Specifies the postal code of the address.',
                                ENA='Specifies the postcode of the address.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ToolTipML = ENU='Specifies the country/region code.',
                                ENA='Specifies the country/region code.';
                    Visible = false;
                }
                field(Extension;Extension)
                {
                    ToolTipML = ENU='Specifies the employee''s telephone extension.',
                                ENA='Specifies the employee''s telephone extension.';
                }
                field("Phone No.";"Phone No.")
                {
                    ToolTipML = ENU='Specifies the employee''s telephone number.',
                                ENA='Specifies the employee''s telephone number.';
                    Visible = false;
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    ToolTipML = ENU='Specifies the employee''s mobile telephone number.',
                                ENA='Specifies the employee''s mobile telephone number.';
                    Visible = false;
                }
                field("E-Mail";"E-Mail")
                {
                    ToolTipML = ENU='Specifies the employee''s email address.',
                                ENA='Specifies the employee''s email address.';
                    Visible = false;
                }
                field("Statistics Group Code";"Statistics Group Code")
                {
                    ToolTipML = ENU='Specifies a statistics group code to assign to the employee for statistical purposes.',
                                ENA='Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field("Resource No.";"Resource No.")
                {
                    ToolTipML = ENU='Specifies a resource number for the employee, if the employee is a resource in Resources Planning.',
                                ENA='Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ToolTipML = ENU='Specifies a search name for the employee.',
                                ENA='Specifies a search name for the employee.';
                }
                field(Comment;Comment)
                {
                    ToolTipML = ENU='Specifies if a comment has been entered for this entry.',
                                ENA='Specifies if a comment has been entered for this entry.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                CaptionML = ENU='E&mployee',
                            ENA='E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    CaptionML = ENU='Co&mments',
                                ENA='Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = Table Name=CONST(Employee), No.=FIELD(No.);
                }
                group(Dimensions)
                {
                    CaptionML = ENU='Dimensions',
                                ENA='Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU='Dimensions-Single',
                                    ENA='Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = Table ID=CONST(5200), No.=FIELD(No.);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTipML = ENU='View or edit the single set of dimensions that are set up for the selected record.',
                                    ENA='View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        CaptionML = ENU='Dimensions-&Multiple',
                                    ENA='Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTipML = ENU='View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.',
                                    ENA='View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyse historical information.';

                        trigger OnAction();
                        var
                            Employee : Record Employee;
                            DefaultDimMultiple : Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("&Picture")
                {
                    CaptionML = ENU='&Picture',
                                ENA='&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = No.=FIELD(No.);
                }
                action(AlternativeAddresses)
                {
                    CaptionML = ENU='&Alternative Addresses',
                                ENA='&Alternative Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("&Relatives")
                {
                    CaptionML = ENU='&Relatives',
                                ENA='&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("Mi&sc. Article Information")
                {
                    CaptionML = ENU='Mi&sc. Article Information',
                                ENA='Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("Co&nfidential Information")
                {
                    CaptionML = ENU='Co&nfidential Information',
                                ENA='Co&nfidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("Q&ualifications")
                {
                    CaptionML = ENU='Q&ualifications',
                                ENA='Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                action("A&bsences")
                {
                    CaptionML = ENU='A&bsences',
                                ENA='A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = Employee No.=FIELD(No.);
                }
                separator(Separator51)
                {
                }
                action("Absences by Ca&tegories")
                {
                    CaptionML = ENU='Absences by Ca&tegories',
                                ENA='Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = No.=FIELD(No.), Employee No. Filter=FIELD(No.);
                }
                action("Misc. Articles &Overview")
                {
                    CaptionML = ENU='Misc. Articles &Overview',
                                ENA='Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                }
                action("Con&fidential Info. Overview")
                {
                    CaptionML = ENU='Con&fidential Info. Overview',
                                ENA='Con&fidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
            }
        }
        area(processing)
        {
            action("Absence Registration")
            {
                CaptionML = ENU='Absence Registration',
                            ENA='Absence Registration';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Absence Registration";
            }
            action("Import Employee Elements")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    HRSETUP.GET();
                    IF HRSETUP."Import Employee Pay Elements" = TRUE THEN BEGIN
                      XMLPORT.RUN(50201);
                    END;
                    IF HRSETUP."Import Employee Pay Elements" = FALSE THEN BEGIN
                      MESSAGE('Not setup for importing employee pay elements');
                    END;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Employee Pay Details")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    EmployeePayDetails.SETRANGE("No.", "No.");
                    PAGE.RUN(50226, EmployeePayDetails);
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Update Employees")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    HRSETUP.GET();
                    GlobalFNPFPercent := HRSETUP."Global FNPF Contribution";
                    IF HRSETUP."Global FNPF Contribution" <> 8.0 THEN BEGIN
                      HRSETUP."Global FNPF Contribution" := 8.0;
                      GlobalFNPFPercent := HRSETUP."Global FNPF Contribution";
                    END;

                    TaxRate := HRSETUP."Global Secondary Tax";

                    IF HRSETUP."Global Secondary Tax" <> 20.0 THEN BEGIN
                      HRSETUP."Global Secondary Tax" := 20.0;
                      TaxRate := HRSETUP."Global Secondary Tax";
                    END;

                    IF HRSETUP."Employer FNPF Contribution" <> 10.0 THEN BEGIN
                      HRSETUP."Employer FNPF Contribution" := 10.0;
                    END;

                    HRSETUP.MODIFY;

                    IF HRSETUP."Normal Hours" = '' THEN BEGIN
                      IF HRSETUP.FNPF = '' THEN BEGIN
                        IF HRSETUP.PAYE = '' THEN BEGIN
                          IF HRSETUP.SRT = '' THEN BEGIN
                            IF HRSETUP.ECAL = '' THEN BEGIN
                              ERROR('Please define primary pay codes in Human Resources Setup');
                            END;
                          END;
                        END;
                      END;
                    END;

                    NormalHours := HRSETUP."Normal Hours";
                    FNPF := HRSETUP.FNPF;
                    PAYE := HRSETUP.PAYE;
                    SRT := HRSETUP.SRT;

                    //ASHNEIL CHANDRA  20072017
                    ECAL := HRSETUP.ECAL;
                    //ASHNEIL CHANDRA  20072017

                    TaxCountryCode := HRSETUP."Country/Region Code";

                    INIT;
                    RESET;
                    SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF FINDFIRST() THEN REPEAT;
                      "Search Name" := "First Name" + ' ' + "Last Name";
                      MODIFY;
                      IF Status = 2 THEN BEGIN
                        IF "Termination Date" = 0D THEN BEGIN
                          MESSAGE(TEXT000 + '%1', "No.");
                        END;
                      END;
                      IF EmployeePayDetails.GET("No.") THEN BEGIN
                        IF EmployeePayDetails."Residential/Non-Residential" = 0 THEN BEGIN
                          MESSAGE(TEXT001 + '%1', "No.");
                        END;
                      END;

                      IF "Employment Date" = 0D THEN BEGIN
                        MESSAGE(TEXT002 + '%1', "No.");
                      END;

                      IF EmployeePayDetails.GET("No.") THEN BEGIN
                        IF EmployeePayDetails."Bank Account No." <> '' THEN BEGIN
                          MultipleBankDistribution.INIT;
                          MultipleBankDistribution.RESET;
                          MultipleBankDistribution.SETRANGE("Employee No.", EmployeePayDetails."No.");
                          MultipleBankDistribution.SETRANGE("Employee Bank Account No.", EmployeePayDetails."Bank Account No.");
                          IF NOT MultipleBankDistribution.FINDFIRST() THEN BEGIN
                            MultipleBankDistribution."Employee No." := EmployeePayDetails."No.";
                            MultipleBankDistribution."Employee Bank Account No." := EmployeePayDetails."Bank Account No.";
                            MultipleBankDistribution."Bank Code" := EmployeePayDetails."Bank Code";
                            MultipleBankDistribution."Branch Code" := EmployeePayDetails."Branch Code";
                            MultipleBankDistribution."Shift Code" := EmployeePayDetails."Shift Code";
                            MultipleBankDistribution."Calendar Code" := EmployeePayDetails."Calendar Code";
                            MultipleBankDistribution."Statistics Group" := EmployeePayDetails."Statistics Group";
                            MultipleBankDistribution.Sequence := 1;
                            MultipleBankDistribution.INSERT;
                          END;
                          IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                            MultipleBankDistribution."Bank Code" := EmployeePayDetails."Bank Code";
                            MultipleBankDistribution.VALIDATE("Bank Code");
                            MultipleBankDistribution."Branch Code" := EmployeePayDetails."Branch Code";
                            MultipleBankDistribution."Shift Code" := EmployeePayDetails."Shift Code";
                            MultipleBankDistribution."Calendar Code" := EmployeePayDetails."Calendar Code";
                            MultipleBankDistribution."Statistics Group" := EmployeePayDetails."Statistics Group";
                            MultipleBankDistribution.MODIFY;
                          UNTIL MultipleBankDistribution.NEXT = 0;
                        END;
                      END;
                    UNTIL NEXT = 0;

                    INIT;
                    RESET;
                    SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF FINDFIRST() THEN REPEAT
                      EmployeePayDetails.INIT;
                      EmployeePayDetails.RESET;
                      EmployeePayDetails.SETRANGE("No.", "No.");
                      IF EmployeePayDetails.FINDFIRST() THEN BEGIN
                        EmployeePayDetails."Employee Name" := "First Name" + ' ' + "Last Name";
                        EmployeePayDetails.MODIFY;
                      END;
                    UNTIL NEXT = 0;

                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      MultipleBankDistribution.INIT;
                      MultipleBankDistribution.RESET;
                      MultipleBankDistribution.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      IF MultipleBankDistribution.FINDFIRST() THEN REPEAT
                        MultipleBankDistribution.VALIDATE("Bank Code");
                        MultipleBankDistribution."Branch Code" := EmployeePayDetails."Branch Code";
                        MultipleBankDistribution."Shift Code" := EmployeePayDetails."Shift Code";
                        MultipleBankDistribution."Calendar Code" := EmployeePayDetails."Calendar Code";
                        MultipleBankDistribution."Statistics Group" := EmployeePayDetails."Statistics Group";
                        MultipleBankDistribution.MODIFY;
                      UNTIL MultipleBankDistribution.NEXT = 0;
                    UNTIL EmployeePayDetails.NEXT = 0;


                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT;
                      MultipleBankDistribution.INIT;
                      MultipleBankDistribution.RESET;
                      MultipleBankDistribution.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      IF MultipleBankDistribution.FINDFIRST() THEN BEGIN
                        MultipleBankDistribution.CALCFIELDS("Bank Count");
                        EmployeePayDetails."Bank Count" := MultipleBankDistribution."Bank Count";
                        IF MultipleBankDistribution."Bank Count" = 1 THEN BEGIN
                          EmployeePayDetails."Is Direct" := TRUE;
                        END;
                        IF MultipleBankDistribution."Bank Count" > 1 THEN BEGIN
                          EmployeePayDetails."Is Direct" := FALSE;
                        END;
                        EmployeePayDetails.MODIFY;
                      END;
                    UNTIL EmployeePayDetails.NEXT = 0;

                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    EmployeePayDetails.SETRANGE("Is Direct", TRUE);
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT;
                      MultipleBankDistribution.INIT;
                      MultipleBankDistribution.RESET;
                      MultipleBankDistribution.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      IF MultipleBankDistribution.FINDFIRST() THEN BEGIN;
                        MultipleBankDistribution."Is Direct" := TRUE;
                        MultipleBankDistribution.Active := TRUE;
                        MultipleBankDistribution.MODIFY;
                      END;
                    UNTIL EmployeePayDetails.NEXT = 0;


                    //-Insert PAYE------------------------------------
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      EmployeePayTable.SETRANGE("Pay Code", PAYE);
                      IF NOT EmployeePayTable.FINDFIRST() THEN BEGIN
                        EmployeePayTable."Employee No." := EmployeePayDetails."No.";
                        EmployeePayTable."Pay Code" := PAYE;
                        EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                        EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                        EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                        EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                        EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                        EmployeePayTable."Line No." := 99999;
                        EmployeePayTable.INSERT;
                      END;
                    UNTIL EmployeePayDetails.NEXT=0;

                    //-Insert SRT------------------------------------
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      EmployeePayTable.SETRANGE("Pay Code", SRT);
                      IF NOT EmployeePayTable.FINDFIRST() THEN BEGIN
                        EmployeePayTable."Employee No." := EmployeePayDetails."No.";
                        EmployeePayTable."Pay Code" := SRT;
                        EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                        EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                        EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                        EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                        EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                        EmployeePayTable."Line No." := 99998;
                        EmployeePayTable.INSERT;
                      END;
                    UNTIL EmployeePayDetails.NEXT=0;

                    //-Insert FNPF-----------------------------------
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      IF EmployeePayDetails."By Pass FNPF" <> TRUE THEN BEGIN
                        EmployeePayTable.INIT;
                        EmployeePayTable.RESET;
                        EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                        EmployeePayTable.SETRANGE("Pay Code", FNPF);
                        IF NOT EmployeePayTable.FIND('-') THEN BEGIN
                          EmployeePayTable."Employee No." := EmployeePayDetails."No.";
                          EmployeePayTable."Pay Code" := FNPF;
                          EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                          EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                          EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                          EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                          EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                          EmployeePayTable."Line No." := 99997;
                          EmployeePayTable.INSERT;
                        END;
                      END;
                    UNTIL EmployeePayDetails.NEXT=0;

                    //-Insert Normal Hours-----------------------------------
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      EmployeePayTable.SETRANGE("Pay Code", NormalHours);
                      IF NOT EmployeePayTable.FIND('-') THEN BEGIN
                        EmployeePayTable."Employee No." := EmployeePayDetails."No.";
                        EmployeePayTable."Pay Code" := NormalHours;
                        EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                        EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                        EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                        EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                        EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                        EmployeePayTable."Line No." := 99996;
                        EmployeePayTable.INSERT;
                      END;
                    UNTIL EmployeePayDetails.NEXT=0;

                    //ASHNEIL CHANDRA  20072017

                    //-Insert ECAL-----------------------------------
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      EmployeePayTable.SETRANGE("Pay Code", ECAL);
                      IF NOT EmployeePayTable.FIND('-') THEN BEGIN
                        EmployeePayTable."Employee No." := EmployeePayDetails."No.";
                        EmployeePayTable."Pay Code" := ECAL;
                        EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                        EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                        EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                        EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                        EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                        EmployeePayTable."Line No." := 99995;
                        EmployeePayTable.INSERT;
                      END;
                    UNTIL EmployeePayDetails.NEXT=0;
                    //ASHNEIL CHANDRA  20072017

                    //Remove Standard TAG
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := FALSE;
                      PayElementMaster."Standard Deductions" := FALSE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;

                    //TAG as Standard Elements
                    //Normal Hours
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    PayElementMaster.SETRANGE("Pay Code", NormalHours);
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := TRUE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;

                    //FNPF
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    PayElementMaster.SETRANGE("Pay Code", FNPF);
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := TRUE;
                      PayElementMaster."Standard Deductions" := TRUE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;

                    //PAYE
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    PayElementMaster.SETRANGE("Pay Code", PAYE);
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := TRUE;
                      PayElementMaster."Standard Deductions" := TRUE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;

                    //SRT
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    PayElementMaster.SETRANGE("Pay Code", SRT);
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := TRUE;
                      PayElementMaster."Standard Deductions" := TRUE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;

                    //ECAL
                    PayElementMaster.INIT;
                    PayElementMaster.RESET;
                    PayElementMaster.SETRANGE("Pay Code", ECAL);
                    IF PayElementMaster.FINDFIRST() THEN REPEAT
                      PayElementMaster."Standard Elements" := TRUE;
                      PayElementMaster."Standard Deductions" := TRUE;
                      PayElementMaster.MODIFY;
                    UNTIL PayElementMaster.NEXT = 0;


                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                      EmployeePayTable.INIT;
                      EmployeePayTable.RESET;
                      EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                      IF EmployeePayTable.FIND('-') THEN REPEAT
                        IF PayElementMaster.GET(EmployeePayTable."Pay Code") THEN BEGIN
                          EmployeePayTable."Pay Type" := PayElementMaster."Pay Type";
                          EmployeePayTable."Include In Pay Slip" := PayElementMaster."Include In Pay Slip";
                          EmployeePayTable."Is FNPF Field" := PayElementMaster."Is FNPF Field";
                          EmployeePayTable."Is FNPF Base" := PayElementMaster."Is FNPF Base";
                          EmployeePayTable."Is PAYE Field" := PayElementMaster."Is PAYE Field";
                          EmployeePayTable."Is PAYE Base" := PayElementMaster."Is PAYE Base";
                          EmployeePayTable."Is SRT Field" := PayElementMaster."Is SRT Field";
                          EmployeePayTable."Is SRT Base" := PayElementMaster."Is SRT Base";

                          //ASHNEIL CHANDRA  20072017
                          EmployeePayTable."Is ECAL Field" := PayElementMaster."Is ECAL Field";
                          EmployeePayTable."Is ECAL Base" := PayElementMaster."Is ECAL Base";
                          EmployeePayTable."Include Standard Elements" := PayElementMaster."Standard Elements";
                          //ASHNEIL CHANDRA  20072017

                          EmployeePayTable.Bonus := PayElementMaster.Bonus;
                          EmployeePayTable."Lump Sum" := PayElementMaster."Lump Sum";
                          EmployeePayTable.Redundancy := PayElementMaster.Redundancy;
                          EmployeePayTable."Exempt Amount" := PayElementMaster."Exempt Amount";
                          EmployeePayTable."Tax Rate" := PayElementMaster."Tax Rate";
                          EmployeePayTable."Pay Description" := PayElementMaster."Pay Description";
                          EmployeePayTable."Quick TimeSheet" := PayElementMaster."Quick Timesheet";

                          //ASHNEIL CHANDRA  17072017
                          EmployeePayTable."Is Old Rate" := PayElementMaster."Is Old Rate";
                          //ASHNEIL CHANDRA  17072017

                          IF PayElementMaster."Is Old Rate" = FALSE THEN BEGIN
                            EmployeePayTable."Rate Type" := PayElementMaster."Rate Type";
                            EVALUATE(EmployeePayTable.Rate, FORMAT(PayElementMaster."Calculation Type"));
                          END;

                          IF EmployeePayTable."Is FNPF Field" THEN BEGIN
                            EmployeePayTable.Amount := 0;
                            EmployeePayTable.Units := 0;
                          END;

                          IF EmployeePayTable."Is PAYE Field" THEN BEGIN
                            EmployeePayTable.Amount := 0;
                            EmployeePayTable.Units := 0;
                          END;

                          IF EmployeePayTable."Is SRT Field" THEN BEGIN
                            EmployeePayTable.Amount := 0;
                            EmployeePayTable.Units := 0;
                          END;

                          //ASHNEIL CHANDRA  20072017
                          IF EmployeePayTable."Is ECAL Field" THEN BEGIN
                            EmployeePayTable.Amount := 0;
                            EmployeePayTable.Units := 0;
                          END;
                          //ASHNEIL CHANDRA  20072017

                          EmployeePayTable.MODIFY;
                        END;
                      UNTIL EmployeePayTable.NEXT = 0;
                    UNTIL EmployeePayDetails.NEXT = 0;


                    IF TaxCountryCode = 'FJ' THEN BEGIN
                      EmployeePayDetails.INIT;
                      EmployeePayDetails.RESET;
                      EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                      IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                        MRUNS := 0;
                        EmployeeGrossStandardPay := 0;
                        TemporaryTaxCode := '';
                        Residential := 0;
                        MRUNS := EmployeePayDetails."Runs Per Calendar";
                        TemporaryTaxCode := FORMAT(EmployeePayDetails."Tax Code");
                        EVALUATE(Residential,FORMAT(EmployeePayDetails."Residential/Non-Residential"));
                        EmployeeGrossStandardPay := EmployeePayDetails."Gross Standard Pay";

                        EmployeePayTable.INIT;
                        EmployeePayTable.RESET;
                        EmployeePayTable.SETRANGE("Employee No.", EmployeePayDetails."No.");
                        MFNPFBASE := 0;
                        MPAYEBASE := 0;
                        MECALBASE := 0;
                        MSRTBASE := 0;
                        MREDUNDANCY := 0;
                        MLUMPSUM := 0;
                        MLUMPSUMEN := 0;
                        MFNPF := 0;
                        MENDORSED := 0;
                        MREDUND := 0;
                        EmployeeAdditionalFNPF := 0;
                        EmployerAdditionalFNPF := 0;

                        IF (EmployeePayDetails."Employee FNPF Additional Cont." + EmployeePayDetails."Employer FNPF Additional Cont.") > 12.0 THEN BEGIN
                          ERROR('Additional FNPF Contribution more than 12 Percent');
                        END;

                        IF (EmployeePayDetails."Employee FNPF Additional Cont." + EmployeePayDetails."Employer FNPF Additional Cont.") > 0.0 THEN BEGIN
                          IF (EmployeePayDetails."Employee FNPF Additional Cont." + EmployeePayDetails."Employer FNPF Additional Cont.") <= 12.0 THEN BEGIN
                            EmployeeAdditionalFNPF := EmployeePayDetails."Employee FNPF Additional Cont.";
                            EmployerAdditionalFNPF := EmployeePayDetails."Employer FNPF Additional Cont.";
                          END;
                        END;

                        IF EmployeePayDetails."Employee Secondary Tax" < 20.0 THEN BEGIN
                          IF EmployeePayDetails."Employee Secondary Tax" > 0.0 THEN BEGIN
                            TaxRate := EmployeePayDetails."Employee Secondary Tax";
                          END;
                        END;

                        IF EmployeePayTable.FINDFIRST() THEN REPEAT
                          IF EmployeePayTable."Pay Code" = NormalHours THEN BEGIN
                            EmployeePayTable.Amount := EmployeePayDetails."Gross Standard Pay";
                            EmployeePayTable.Units := EmployeePayDetails.Units;
                            EmployeePayTable.Rate := EmployeePayDetails."Employee Rate";
                            EmployeePayTable.MODIFY;
                          END;

                          EmployeePayTable."Branch Code" := EmployeePayDetails."Branch Code";
                          EmployeePayTable."Statistics Group" := EmployeePayDetails."Statistics Group";
                          EmployeePayTable."Shift Code" := EmployeePayDetails."Shift Code";
                          EmployeePayTable."Calendar Code" := EmployeePayDetails."Calendar Code";
                          EmployeePayTable."Currency Code" := EmployeePayDetails."Currency Code";
                          EmployeePayTable."Currency Exchange Rate" := EmployeePayDetails."Currency Exchange Rate";
                          EmployeePayTable."Foreign Currency" := EmployeePayDetails."Foreign Currency";
                          EmployeePayTable."Employee Name" := EmployeePayDetails."Employee Name";
                          EmployeePayTable."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";

                          IF EmployeePayTable."Is FNPF Base" = TRUE THEN BEGIN
                            MFNPFBASE := MFNPFBASE + EmployeePayTable.Amount;
                          END;

                          IF EmployeePayTable."Is PAYE Base" THEN BEGIN
                            IF EmployeePayTable."Lump Sum" = FALSE THEN BEGIN
                              IF EmployeePayTable.Redundancy = FALSE THEN BEGIN
                                MPAYEBASE := MPAYEBASE + EmployeePayTable.Amount;              //PRIMARY PAYE
                              END;
                            END;
                          END;

                          IF EmployeePayTable."Is SRT Base" = TRUE THEN BEGIN                  //SRT
                            MSRTBASE := MSRTBASE + EmployeePayTable.Amount;
                          END;

                          //ASHNEIL CHANDRA  20072017
                          IF EmployeePayTable."Is ECAL Base" = TRUE THEN BEGIN                 //ECAL
                            MECALBASE := MECALBASE + EmployeePayTable.Amount;
                          END;
                          //ASHNEIL CHANDRA  20072017


                          IF EmployeePayTable."Is FNPF Field" = TRUE THEN BEGIN
                            EmployeePayTable.Amount := (MFNPFBASE * (GlobalFNPFPercent + EmployeeAdditionalFNPF + EmployerAdditionalFNPF)) / 100 * -1;
                            EmployeePayTable.Units := (MFNPFBASE * (GlobalFNPFPercent + EmployeeAdditionalFNPF + EmployerAdditionalFNPF)) / 100;
                            MFNPF := (MFNPFBASE * (GlobalFNPFPercent + EmployeeAdditionalFNPF + EmployerAdditionalFNPF)) / 100;
                            EmployeePayTable.MODIFY;
                          END;

                          EmployeePayTable.Amount := EmployeePayTable.Rate * EmployeePayTable.Units;
                          EmployeePayTable.MODIFY;

                        UNTIL EmployeePayTable.NEXT=0;
                      UNTIL EmployeePayDetails.NEXT=0;
                    END;

                    MESSAGE('Update Completed');

                    IF TaxCountryCode <> 'FJ' THEN BEGIN
                      ERROR(TEXT003 + '%1', TaxCountryCode);
                      EXIT;
                    END;

                    INIT;
                    RESET;
                    FINDFIRST();
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Update Annual Pay for All Employees")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA  13072017
                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.FINDFIRST() THEN REPEAT
                       EmployeeRate := 0;
                       RunsPerCalendar := 0;
                      IF EmployeePayDetails."Statistics Group" <> '' THEN BEGIN
                        EmployeePayHistory.INIT;
                        EmployeePayHistory.RESET;
                        EmployeePayHistory.SETRANGE("Employee No.", EmployeePayDetails."No.");
                        IF EmployeePayHistory.FINDLAST() THEN BEGIN
                          EmployeePayDetails."Annual Pay" := EmployeePayHistory."Annual Pay";
                          EmployeePayDetails.VALIDATE("Annual Pay");
                          EmployeePayDetails.Units := EmployeePayHistory.Units;
                          EmployeePayDetails.VALIDATE(Units);
                          EmployeePayDetails."Increment Date" := EmployeePayHistory."Increment Date";
                          EmployeePayDetails.MODIFY;
                          EmployeeRate := EmployeePayDetails."Employee Rate";
                          RunsPerCalendar := EmployeePayDetails."Runs Per Calendar";
                          EmployeePayHistory.Rate := EmployeeRate;
                          EmployeePayHistory."Runs Per Calendar" := RunsPerCalendar;
                          EmployeePayHistory.MODIFY;
                        END;
                      END;
                      IF EmployeePayDetails."Statistics Group" = '' THEN BEGIN
                        MESSAGE('Employee %1 not updated, statistics group code missing', EmployeePayDetails."No.");
                      END;
                    UNTIL EmployeePayDetails.NEXT = 0;
                    //ASHNEIL CHANDRA  13072017
                end;
            }
            action("Leave Entitlement")
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    PAGE.RUN(50220);
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Add Employee To Timesheet")
            {

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    HRSETUP.GET();
                    PayRunNo := HRSETUP."Pay Run No.";
                    SpecialPayNo := HRSETUP."Special Pay No.";
                    NormalHours := HRSETUP."Normal Hours";
                    BranchCode := HRSETUP."Branch Code";
                    ShiftCode := HRSETUP."Shift Code";
                    CalendarCode := HRSETUP."Calendar Code";
                    StatisticsGroup := HRSETUP."Statistics Group";
                    AddtoEmployeeTag := HRSETUP."Add to Timesheet";

                    EmployeePayDetails.INIT;
                    EmployeePayDetails.RESET;
                    EmployeePayDetails.SETRANGE(Terminated, FALSE);  //ASHNEIL CHANDRA  21072017
                    IF EmployeePayDetails.GET("No.") THEN BEGIN
                      EmployeeNo := EmployeePayDetails."No.";
                    END;

                    BranchCalendar.INIT;
                    BranchCalendar.RESET;
                    BranchCalendar.SETRANGE("Branch Code", BranchCode);
                    BranchCalendar.SETRANGE("Shift Code", ShiftCode);
                    BranchCalendar.SETRANGE("Calendar Code", CalendarCode);
                    BranchCalendar.SETRANGE("Statistics Group", StatisticsGroup);
                    BranchCalendar.SETRANGE("Pay Run No.", PayRunNo);
                    IF BranchCalendar.FINDFIRST() THEN BEGIN
                      PayFrom := BranchCalendar."Pay From Date";
                      PayTo := BranchCalendar."Pay To Date";
                      TaxFrom := BranchCalendar."Tax Start Month";
                      TaxTo := BranchCalendar."Tax End Month";
                    END;

                    IF AddtoEmployeeTag = TRUE THEN BEGIN
                    EmployeeTimesheet.INIT;
                    EmployeeTimesheet.RESET;
                    EmployeeTimesheet.SETRANGE("Branch Code", BranchCode);
                    EmployeeTimesheet.SETRANGE("Shift Code", ShiftCode);
                    EmployeeTimesheet.SETRANGE("Calendar Code", CalendarCode);
                    EmployeeTimesheet.SETRANGE("Statistics Group", StatisticsGroup);
                    EmployeeTimesheet.SETRANGE("Employee No.", EmployeeNo);
                    EmployeeTimesheet.SETRANGE("Pay Run No.", PayRunNo);
                    EmployeeTimesheet.SETRANGE("Special Pay No.", SpecialPayNo);
                    IF NOT EmployeeTimesheet.FINDFIRST() THEN BEGIN
                      EmployeeTimesheet."Branch Code" := BranchCode;
                      EmployeeTimesheet."Shift Code" := ShiftCode;
                      EmployeeTimesheet."Statistics Group" := StatisticsGroup;
                      EmployeeTimesheet."Calendar Code" := CalendarCode;
                      EmployeeTimesheet."Employee No." := EmployeeNo;
                      EmployeeTimesheet."Sub Branch Code" := EmployeePayDetails."Sub Branch Code";
                      EmployeeTimesheet."Employee Name" := "First Name" + ' ' + "Last Name";
                      EmployeeTimesheet."Pay Run No." := PayRunNo;
                      EmployeeTimesheet."Special Pay No." := SpecialPayNo;
                      EmployeeTimesheet."Pay Code" := NormalHours;
                      EmployeeTimesheet.Rate := EmployeePayDetails."Employee Rate";
                      EmployeeTimesheet.Units := EmployeePayDetails.Units;
                      EmployeeTimesheet."Basic Pay" := EmployeePayDetails."Gross Standard Pay";
                      EmployeeTimesheet."Date Processed" := TODAY;
                      EmployeeTimesheet."Pay From Date" := PayFrom;
                      EmployeeTimesheet."Pay To Date" := PayTo;
                      EmployeeTimesheet."Tax Start Month" := TaxFrom;
                      EmployeeTimesheet."Tax End Month" := TaxTo;
                      EmployeeTimesheet."Rate Type" := EmployeePayDetails."Rate Type";
                      EVALUATE(RateType, FORMAT(EmployeeTimesheet."Rate Type"));
                      IF EmployeeTimesheet.Rate <> 0 THEN BEGIN
                        IF EmployeeTimesheet.Units <> 0 THEN BEGIN
                          EmployeeTimesheet.Amount := EmployeeTimesheet.Rate * EmployeeTimesheet.Units * RateType;
                        END;
                      END;

                      EmployeeTimesheet.INSERT;

                      EmployeeTimesheet.VALIDATE("Pay Code");
                      EmployeeTimesheet.MODIFY;
                    END;
                    END;


                    HRSETUP."Add to Timesheet" := FALSE;

                    CurrPage.CLOSE;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
        }
        area(reporting)
        {
            action("Tax Withholding Certificate")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017

                    HRSETUP.GET();
                    HRSETUP."WHT Employee No." := '';
                    HRSETUP.MODIFY;


                    IF HRSETUP."WHT Start Date" = 0D THEN BEGIN
                      ERROR('WHT Start Date is blank in the Human Resources Setup');
                    END;

                    IF HRSETUP."WHT End Date" = 0D THEN BEGIN
                      ERROR('WHT End Date is blank in the Human Resources Setup');
                    END;

                    IF HRSETUP."Print Specific TWC" = FALSE THEN BEGIN
                      ReportEmployee.INIT;
                      ReportEmployee.RESET;
                      IF ReportEmployee.FINDFIRST() THEN REPEAT
                        HRSETUP."WHT Employee No." := ReportEmployee."No.";
                        HRSETUP.MODIFY;
                        REPORT.RUN(50210,FALSE,TRUE,ReportEmployee);
                      UNTIL ReportEmployee.NEXT = 0;
                    END;

                    IF HRSETUP."Print Specific TWC" = TRUE THEN BEGIN
                      ReportEmployee.INIT;
                      ReportEmployee.RESET;
                      ReportEmployee.SETRANGE("Print TWC", TRUE);
                      IF ReportEmployee.FINDFIRST() THEN REPEAT
                        HRSETUP."WHT Employee No." := ReportEmployee."No.";
                        HRSETUP.MODIFY;
                        REPORT.RUN(50210,FALSE,TRUE,ReportEmployee);
                      UNTIL ReportEmployee.NEXT = 0;
                    END;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Tax Withholding Cert - New")
            {

                trigger OnAction();
                begin
                    HRSETUP.GET();
                    HRSETUP."WHT Employee No." := '';
                    HRSETUP.MODIFY;


                    IF HRSETUP."WHT Start Date" = 0D THEN BEGIN
                      ERROR('WHT Start Date is blank in the Human Resources Setup');
                    END;

                    IF HRSETUP."WHT End Date" = 0D THEN BEGIN
                      ERROR('WHT End Date is blank in the Human Resources Setup');
                    END;

                    IF HRSETUP."Print Specific TWC" = FALSE THEN BEGIN
                      ReportEmployee.INIT;
                      ReportEmployee.RESET;
                      IF ReportEmployee.FINDFIRST() THEN REPEAT
                        HRSETUP."WHT Employee No." := ReportEmployee."No.";
                        HRSETUP.MODIFY;
                        REPORT.RUN(50225,FALSE,TRUE,ReportEmployee);
                      UNTIL ReportEmployee.NEXT = 0;
                    END;

                    IF HRSETUP."Print Specific TWC" = TRUE THEN BEGIN
                      ReportEmployee.INIT;
                      ReportEmployee.RESET;
                      ReportEmployee.SETRANGE("Print TWC", TRUE);
                      IF ReportEmployee.FINDFIRST() THEN REPEAT
                        HRSETUP."WHT Employee No." := ReportEmployee."No.";
                        HRSETUP.MODIFY;
                        REPORT.RUN(50225,FALSE,TRUE,ReportEmployee);
                      UNTIL ReportEmployee.NEXT = 0;
                    END;
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Employee Detail Report")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    EmployeePayDetails.SETRANGE("No.", "No.");
                    REPORT.RUN(50209);
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("Employee Pay Summary")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    REPORT.RUN(50211);
                    //ASHNEIL CHANDRA   13072017
                end;
            }
            action("View Payroll Entries")
            {
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    //ASHNEIL CHANDRA   13072017
                    PayrollEntries.SETRANGE("Employee No.", "No.");
                    PAGE.RUN(50220,PayrollEntries);
                    //ASHNEIL CHANDRA   13072017
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        //ASHNEIL CHANDRA  13072017
        HRSETUP.GET();

        IF HRSETUP."Global FNPF Contribution" = 0 THEN BEGIN
          ERROR('Global FNPF Contribution Percentage not defined');
        END;

        IF HRSETUP."Employer FNPF Contribution" = 0 THEN BEGIN
          ERROR('Employer FNPF Contribution Percentage not defined');
        END;

        IF HRSETUP."Global Secondary Tax" = 0 THEN BEGIN
          ERROR('Global Secondary Percentage not defined');
        END;

        CurrencyExchangeRatePayroll.INIT;
        CurrencyExchangeRatePayroll.RESET;
        CurrencyExchangeRatePayroll.DELETEALL;

        CurrencyExchangeRate.INIT;
        CurrencyExchangeRate.RESET;
        IF CurrencyExchangeRate.FINDFIRST() THEN REPEAT
          CurrencyExchangeRatePayroll.TRANSFERFIELDS(CurrencyExchangeRate);
          CurrencyExchangeRatePayroll.INSERT;
        UNTIL CurrencyExchangeRate.NEXT = 0;

        IF FINDFIRST THEN BEGIN
          IF HRSETUP."Current Payroll Year" = 0 THEN BEGIN
            MESSAGE('Please create Payroll Year in Human Resources Setup');
          END;
          IF HRSETUP."Current Payroll Year" <> 0 THEN BEGIN
            HRCurrentPayrollYear := HRSETUP."Current Payroll Year";
            SystemCurrentDate := TODAY;
            SystemCurrentPayrollYear := DATE2DMY(SystemCurrentDate,3);
            IF HRCurrentPayrollYear  < SystemCurrentPayrollYear THEN BEGIN
              ERROR('Current Year is %1', SystemCurrentPayrollYear);
            END;
          END;

          IF HRSETUP."Country/Region Code" = '' THEN BEGIN
            MESSAGE('Country/Region Code is blank in Human Resources Setup');
            EXIT;
          END;

          IF HRSETUP."Employer Reference No." = '' THEN BEGIN
            MESSAGE('Employer Reference No. is blank in Human Resources Setup');
          END;
          IF HRSETUP."Employer TIN No." = '' THEN BEGIN
            MESSAGE('Employer TIN No. is blank in Human Resources Setup');
          END;
        END;


        INIT;
        RESET;
        IF FINDFIRST() THEN REPEAT
          VALIDATE("Statistics Group");
          VALIDATE(Status);
          MODIFY;

          EmployeePayDetails.INIT;
          EmployeePayDetails.RESET;
          IF EmployeePayDetails.GET("No.") THEN BEGIN;
            IF "Employment Date" <> 0D THEN BEGIN
              EmployeePayDetails."Employment Start Date" := "Employment Date";
              EmployeePayDetails.MODIFY;
            END;
            IF "Termination Date" <> 0D THEN BEGIN
              EmployeePayDetails."Employment End Date" := "Termination Date";
              EmployeePayDetails.MODIFY;
            END;
          END;
        UNTIL NEXT = 0;


        EmployeePayDetails.INIT;
        EmployeePayDetails.RESET;
        IF EmployeePayDetails.GET("No.") THEN BEGIN;
          IF EmployeePayDetails.FINDFIRST() THEN REPEAT
            IF EmployeePayDetails.Terminated = FALSE THEN BEGIN
              IF EmployeePayDetails."Employment Start Date" <> 0D THEN BEGIN
                IF EmployeePayDetails."Employment Status Date" = 0D THEN BEGIN
                  EmployeePayDetails."Employment Status Date" := EmployeePayDetails."Employment Start Date";
                END;
              END;
            END;
            IF EmployeePayDetails.Terminated = TRUE THEN BEGIN
              IF EmployeePayDetails."Employment End Date" <> 0D THEN BEGIN
                IF EmployeePayDetails."Employment Status Date" = 0D THEN BEGIN
                  EmployeePayDetails."Employment Status Date" := EmployeePayDetails."Employment End Date";
                END;
              END;
            END;

            IF EmployeePayDetails."Payment Frequency" = 0 THEN BEGIN
              IF EmployeePayDetails."Statistics Group" = 'WEEKLY' THEN BEGIN
                EmployeePayDetails."Payment Frequency" := 1;
              END;
              IF EmployeePayDetails."Statistics Group" = 'FORTNIGHT' THEN BEGIN
                EmployeePayDetails."Payment Frequency" := 2;
              END;
              IF EmployeePayDetails."Statistics Group" = 'BI-MONTHLY' THEN BEGIN
                EmployeePayDetails."Payment Frequency" := 2;
              END;
              IF EmployeePayDetails."Statistics Group" = 'MONTHLY' THEN BEGIN
                EmployeePayDetails."Payment Frequency" := 3;
              END;
            END;

            EmployeePayDetails.MODIFY;


          UNTIL EmployeePayDetails.NEXT = 0;
        END;

        INIT;
        RESET;
        IF FINDFIRST() THEN REPEAT
          IF Terminated = TRUE THEN BEGIN
            EmployeePayDetails.INIT;
            EmployeePayDetails.RESET;
            EmployeePayDetails.SETRANGE("No.", "No.");
            IF EmployeePayDetails.FINDFIRST() THEN BEGIN
              IF EmployeePayDetails."Employment End Date" <> 0D THEN BEGIN
                "Termination Date" := EmployeePayDetails."Employment End Date";
                MODIFY;
              END;
            END;
          END;
        UNTIL NEXT = 0;

        INIT;
        RESET;
        FINDFIRST();
        //ASHNEIL CHANDRA  13072017
    end;

    var
        HRSETUP : Record "Human Resources Setup";
        CurrencyExchangeRate : Record "Currency Exchange Rate";
        CurrencyExchangeRatePayroll : Record "Currency Exchange Rate Payroll";
        EmployeePayDetails : Record "Employee Pay Details";
        MultipleBankDistribution : Record "Multiple Bank Distribution";
        EmployeePayTable : Record "Employee Pay Table";
        PayElementMaster : Record "Pay Element Master";
        IncomeTaxMaster : Record "Income Tax Master";
        BranchCalendar : Record "Branch Calendar";
        EmployeeTimesheet : Record "Employee Timesheet";
        ReportEmployee : Record "Employee Pay Details";
        BranchPolicy : Record "Branch Policy";
        PayrollEntries : Record "Pay Run";
        CalendarCode2 : Code[10];
        GlobalFNPFPercent : Decimal;
        TaxRate : Decimal;
        NormalHours : Code[10];
        FNPF : Code[10];
        PAYE : Code[10];
        SRT : Code[10];
        ECAL : Code[10];
        TaxCountryCode : Code[10];
        MRUNS : Decimal;
        TemporaryTaxCode : Code[1];
        Residential : Option " ",Resident,"Non Resident";
        MFNPFBASE : Decimal;
        MPAYEBASE : Decimal;
        MREDUNDANCY : Decimal;
        MLUMPSUM : Decimal;
        MLUMPSUMEN : Decimal;
        MSRTBASE : Decimal;
        MECALBASE : Decimal;
        MFNPF : Decimal;
        MENDORSED : Decimal;
        MREDUND : Decimal;
        EmployeeAdditionalFNPF : Decimal;
        EmployerAdditionalFNPF : Decimal;
        MP1 : Decimal;
        MP2 : Decimal;
        PayRunNo : Code[10];
        SpecialPayNo : Code[10];
        BranchCode : Code[10];
        CalendarCode : Code[10];
        StatisticsGroup : Code[20];
        ShiftCode : Option First,Second,Third,Fourth,Fifth;
        AddtoEmployeeTag : Boolean;
        EmployeeNo : Code[20];
        PayFrom : Date;
        PayTo : Date;
        TaxFrom : Date;
        TaxTo : Date;
        RateType : Decimal;
        TEXT000 : Label '"Termination Date is not filled in for employee "';
        TEXT001 : Label '"Residential/Non-Residential not defined for employee "';
        TEXT002 : Label '"Employment Date is not defined for employee "';
        TEXT003 : Label '"Tax Calculation does not exist for country code "';
        HRCurrentPayrollYear : Integer;
        SystemCurrentPayrollYear : Integer;
        SystemCurrentDate : Date;
        EmployeeGrossStandardPay : Decimal;
        EmployeeRate : Decimal;
        RunsPerCalendar : Decimal;
        EmployeePayHistory : Record "Employee Pay History";
}

