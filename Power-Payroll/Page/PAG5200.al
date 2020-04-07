page 5200 "Employee Card"
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Employee Card',
                ENA='Employee Card';
    PageType = Card;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General',
                            ENA='General';
                field("No.";"No.")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies a number for the employee.',
                                ENA='Specifies a number for the employee.';

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field("Job Title";"Job Title")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s job title.',
                                ENA='Specifies the employee''s job title.';
                }
                field("First Name";"First Name")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s first name.',
                                ENA='Specifies the employee''s first name.';
                }
                field("Last Name";"Last Name")
                {
                    ToolTipML = ENU='Specifies the employee''s last name.',
                                ENA='Specifies the employee''s last name.';
                }
                field("Middle Name";"Middle Name")
                {
                    CaptionML = ENU='Middle Name/Initials',
                                ENA='Middle Name/Initials';
                    ToolTipML = ENU='Specifies the employee''s middle name.',
                                ENA='Specifies the employee''s middle name.';
                }
                field(Initials;Initials)
                {
                    ToolTipML = ENU='Specifies the employee''s initials.',
                                ENA='Specifies the employee''s initials.';
                }
                field(Address;Address)
                {
                    ToolTipML = ENU='Specifies the employee''s address.',
                                ENA='Specifies the employee''s address.';
                }
                field("Address 2";"Address 2")
                {
                    ToolTipML = ENU='Specifies another line of the address.',
                                ENA='Specifies another line of the address.';
                }
                field("Post Code";"Post Code")
                {
                    ToolTipML = ENU='Specifies the postal code of the address.',
                                ENA='Specifies the postcode of the address.';
                }
                field(City;City)
                {
                    ToolTipML = ENU='Specifies the city of the address.',
                                ENA='Specifies the city of the address.';
                }
                field(County;County)
                {
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ToolTipML = ENU='Specifies the country/region code.',
                                ENA='Specifies the country/region code.';
                }
                field("Phone No.";"Phone No.")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s telephone number.',
                                ENA='Specifies the employee''s telephone number.';
                }
                field("Search Name";"Search Name")
                {
                    ToolTipML = ENU='Specifies a search name for the employee.',
                                ENA='Specifies a search name for the employee.';
                }
                field(Gender;Gender)
                {
                    ToolTipML = ENU='Specifies the employee''s gender.',
                                ENA='Specifies the employee''s gender.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the last day this entry was modified.',
                                ENA='Specifies the last day this entry was modified.';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                }
            }
            group(Communication)
            {
                CaptionML = ENU='Communication',
                            ENA='Communication';
                field(Extension;Extension)
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s telephone extension.',
                                ENA='Specifies the employee''s telephone extension.';
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s mobile telephone number.',
                                ENA='Specifies the employee''s mobile telephone number.';
                }
                field(Pager;Pager)
                {
                    ToolTipML = ENU='Specifies the employee''s pager number.',
                                ENA='Specifies the employee''s pager number.';
                }
                field("Phone No.2";"Phone No.")
                {
                    ToolTipML = ENU='Specifies the employee''s telephone number.',
                                ENA='Specifies the employee''s telephone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s email address.',
                                ENA='Specifies the employee''s email address.';
                }
                field("Company E-Mail";"Company E-Mail")
                {
                    ToolTipML = ENU='Specifies the employee''s email address at the company.',
                                ENA='Specifies the employee''s email address at the company.';
                }
                field("Alt. Address Code";"Alt. Address Code")
                {
                    ToolTipML = ENU='Specifies a code for an alternate address.',
                                ENA='Specifies a code for an alternate address.';
                    Visible = false;
                }
                field("Alt. Address Start Date";"Alt. Address Start Date")
                {
                    ToolTipML = ENU='Specifies the starting date when the alternate address is valid.',
                                ENA='Specifies the starting date when the alternate address is valid.';
                    Visible = false;
                }
                field("Alt. Address End Date";"Alt. Address End Date")
                {
                    ToolTipML = ENU='Specifies the last day when the alternate address is valid.',
                                ENA='Specifies the last day when the alternate address is valid.';
                    Visible = false;
                }
            }
            group(Administration)
            {
                CaptionML = ENU='Administration',
                            ENA='Administration';
                field("Employment Date";"Employment Date")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the date when the employee began to work for the company.',
                                ENA='Specifies the date when the employee began to work for the company.';
                }
                field(Status;Status)
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employment status of the employee.',
                                ENA='Specifies the employment status of the employee.';
                }
                field("Inactive Date";"Inactive Date")
                {
                    ToolTipML = ENU='Specifies the date when the employee became inactive, due to disability or maternity leave, for example.',
                                ENA='Specifies the date when the employee became inactive, due to disability or maternity leave, for example.';
                }
                field("Cause of Inactivity Code";"Cause of Inactivity Code")
                {
                    ToolTipML = ENU='Specifies a code for the cause of inactivity by the employee.',
                                ENA='Specifies a code for the cause of inactivity by the employee.';
                }
                field("Termination Date";"Termination Date")
                {
                    ToolTipML = ENU='Specifies the date when the employee was terminated, due to retirement or dismissal, for example.',
                                ENA='Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                }
                field("Grounds for Term. Code";"Grounds for Term. Code")
                {
                    ToolTipML = ENU='Specifies a termination code for the employee who has been terminated.',
                                ENA='Specifies a termination code for the employee who has been terminated.';
                }
                field("Emplymt. Contract Code";"Emplymt. Contract Code")
                {
                    ToolTipML = ENU='Specifies the employment contract code for the employee.',
                                ENA='Specifies the employment contract code for the employee.';
                }
                field("Statistics Group Code";"Statistics Group Code")
                {
                    ToolTipML = ENU='Specifies a statistics group code to assign to the employee for statistical purposes.',
                                ENA='Specifies a statistics group code to assign to the employee for statistical purposes.';
                }
                field("Resource No.";"Resource No.")
                {
                    ToolTipML = ENU='Specifies a resource number for the employee, if the employee is a resource in Resources Planning.',
                                ENA='Specifies a resource number for the employee, if the employee is a resource in Resources Planning.';
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ToolTipML = ENU='Specifies a salesperson or purchaser code for the employee, if the employee is a salesperson or purchaser in the company.',
                                ENA='Specifies a salesperson or purchaser code for the employee, if the employee is a salesperson or purchaser in the company.';
                }
                field("Accrued leave";"Accrued leave")
                {
                }
            }
            group(Personal)
            {
                CaptionML = ENU='Personal',
                            ENA='Personal';
                field("Birth Date";"Birth Date")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the employee''s date of birth.',
                                ENA='Specifies the employee''s date of birth.';
                }
                field("Social Security No.";"Social Security No.")
                {
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the Social Security number of the employee.',
                                ENA='Specifies the Social Security number of the employee.';
                    Visible = false;
                }
                field("Union Code";"Union Code")
                {
                    ToolTipML = ENU='Specifies the employee''s labor union membership code.',
                                ENA='Specifies the employee''s labour union membership code.';
                }
                field("Union Membership No.";"Union Membership No.")
                {
                    ToolTipML = ENU='Specifies the employee''s labor union membership number.',
                                ENA='Specifies the employee''s labour union membership number.';
                }
            }
            group("Branch Policy")
            {
                Caption = 'Branch Policy';
                field("Branch Code";"Branch Code")
                {
                }
                field("Shift Code";"Shift Code")
                {
                }
                field("Calendar Code";"Calendar Code")
                {
                }
                field("Statistics Group";"Statistics Group")
                {
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"Employee Picture")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = No.=FIELD(No.);
            }
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
                action(Dimensions)
                {
                    CaptionML = ENU='Dimensions',
                                ENA='Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = Table ID=CONST(5200), No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTipML = ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                ENA='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';
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
                action("&Confidential Information")
                {
                    CaptionML = ENU='&Confidential Information',
                                ENA='&Confidential Information';
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
                separator(Separator23)
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
                action("Co&nfidential Info. Overview")
                {
                    CaptionML = ENU='Co&nfidential Info. Overview',
                                ENA='Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                }
                separator(Separator61)
                {
                }
                action("Online Map")
                {
                    CaptionML = ENU='Online Map',
                                ENA='Online Map';
                    Image = Map;

                    trigger OnAction();
                    begin
                        DisplayMap;
                    end;
                }
            }
        }
    }
}

