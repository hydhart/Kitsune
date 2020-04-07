table 5200 Employee
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585

    CaptionML = ENU='Employee',
                ENA='Employee';
    DataCaptionFields = "No.","First Name","Middle Name","Last Name";
    DrillDownPageID = 5201;
    LookupPageID = 5201;

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU='No.',
                        ENA='No.';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  HumanResSetup.GET;
                  NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                  "No. Series" := '';
                END;
            end;
        }
        field(2;"First Name";Text[30])
        {
            CaptionML = ENU='First Name',
                        ENA='First Name';
        }
        field(3;"Middle Name";Text[30])
        {
            CaptionML = ENU='Middle Name',
                        ENA='Middle Name';
        }
        field(4;"Last Name";Text[30])
        {
            CaptionML = ENU='Last Name',
                        ENA='Last Name';
        }
        field(5;Initials;Text[30])
        {
            CaptionML = ENU='Initials',
                        ENA='Initials';

            trigger OnValidate();
            begin
                IF ("Search Name" = UPPERCASE(xRec.Initials)) OR ("Search Name" = '') THEN
                  "Search Name" := Initials;
            end;
        }
        field(6;"Job Title";Text[30])
        {
            CaptionML = ENU='Job Title',
                        ENA='Job Title';
        }
        field(7;"Search Name";Code[30])
        {
            CaptionML = ENU='Search Name',
                        ENA='Search Name';
        }
        field(8;Address;Text[50])
        {
            CaptionML = ENU='Address',
                        ENA='Address';

            trigger OnValidate();
            var
                Contact : Text[90];
            begin
                PostCodeCheck.ValidateAddress(
                  CurrFieldNo,DATABASE::Employee,GETPOSITION,0,
                  "First Name","Last Name",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(9;"Address 2";Text[50])
        {
            CaptionML = ENU='Address 2',
                        ENA='Address 2';

            trigger OnValidate();
            var
                Contact : Text[90];
            begin
                PostCodeCheck.ValidateAddress(
                  CurrFieldNo,DATABASE::Employee,GETPOSITION,0,
                  "First Name","Last Name",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(10;City;Text[30])
        {
            CaptionML = ENU='City',
                        ENA='City';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Contact : Text[90];
            begin
                PostCodeCheck.ValidateCity(
                  CurrFieldNo,DATABASE::Employee,GETPOSITION,0,
                  "First Name","Last Name",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(11;"Post Code";Code[20])
        {
            CaptionML = ENU='Post Code',
                        ENA='Postcode';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code" ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Contact : Text[90];
            begin
                PostCodeCheck.ValidatePostCode(
                  CurrFieldNo,DATABASE::Employee,GETPOSITION,0,
                  "First Name","Last Name",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(12;County;Text[30])
        {
            CaptionML = ENU='County',
                        ENA='State';
        }
        field(13;"Phone No.";Text[30])
        {
            CaptionML = ENU='Phone No.',
                        ENA='Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14;"Mobile Phone No.";Text[30])
        {
            CaptionML = ENU='Mobile Phone No.',
                        ENA='Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15;"E-Mail";Text[80])
        {
            CaptionML = ENU='Email',
                        ENA='Email';
            ExtendedDatatype = EMail;
        }
        field(16;"Alt. Address Code";Code[10])
        {
            CaptionML = ENU='Alt. Address Code',
                        ENA='Alt. Address Code';
            TableRelation = "Alternative Address".Code WHERE (Employee No.=FIELD(No.));
        }
        field(17;"Alt. Address Start Date";Date)
        {
            CaptionML = ENU='Alt. Address Start Date',
                        ENA='Alt. Address Start Date';
        }
        field(18;"Alt. Address End Date";Date)
        {
            CaptionML = ENU='Alt. Address End Date',
                        ENA='Alt. Address End Date';
        }
        field(19;Picture;BLOB)
        {
            CaptionML = ENU='Picture',
                        ENA='Picture';
            SubType = Bitmap;
        }
        field(20;"Birth Date";Date)
        {
            CaptionML = ENU='Birth Date',
                        ENA='Birth Date';
        }
        field(21;"Social Security No.";Text[30])
        {
            CaptionML = ENU='Social Security No.',
                        ENA='Tax File No.';
        }
        field(22;"Union Code";Code[10])
        {
            CaptionML = ENU='Union Code',
                        ENA='Union Code';
            TableRelation = Union;
        }
        field(23;"Union Membership No.";Text[30])
        {
            CaptionML = ENU='Union Membership No.',
                        ENA='Union Membership No.';
        }
        field(24;Gender;Option)
        {
            CaptionML = ENU='Gender',
                        ENA='Gender';
            OptionCaptionML = ENU=' ,Female,Male',
                              ENA=' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(25;"Country/Region Code";Code[10])
        {
            CaptionML = ENU='Country/Region Code',
                        ENA='Country/Region Code';
            TableRelation = Country/Region;
        }
        field(26;"Manager No.";Code[20])
        {
            CaptionML = ENU='Manager No.',
                        ENA='Manager No.';
            TableRelation = Employee;
        }
        field(27;"Emplymt. Contract Code";Code[10])
        {
            CaptionML = ENU='Emplymt. Contract Code',
                        ENA='Emplymt. Contract Code';
            TableRelation = "Employment Contract";
        }
        field(28;"Statistics Group Code";Code[10])
        {
            CaptionML = ENU='Statistics Group Code',
                        ENA='Statistics Group Code';
            TableRelation = "Employee Statistics Group";
        }
        field(29;"Employment Date";Date)
        {
            CaptionML = ENU='Employment Date',
                        ENA='Employment Date';

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  EmployeePayDetails."Employment Start Date" := "Employment Date";
                  EmployeePayDetails.MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(31;Status;Option)
        {
            CaptionML = ENU='Status',
                        ENA='Status';
            OptionCaptionML = ENU='Inactive,Active,On Leave,Terminated',
                              ENA='Inactive,Active,On Leave,Terminated';
            OptionMembers = Inactive,Active,"On Leave",Terminated;

            trigger OnValidate();
            begin
                EmployeeQualification.SETRANGE("Employee No.","No.");
                EmployeeQualification.MODIFYALL("Employee Status",Status);
                MODIFY;

                //ASHNEIL CHANDRA   13072017
                IF Status = 0 THEN BEGIN
                  //Terminated := FALSE;
                END;
                IF Status = 1 THEN BEGIN
                  //Terminated := FALSE;
                END;
                IF Status = 2 THEN BEGIN
                  //Terminated := FALSE;
                END;
                IF Status = 3 THEN BEGIN
                  //Terminated := TRUE;
                END;
                MODIFY;

                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  IF Status = 0 THEN BEGIN
                    EmployeePayDetails."Employment Status" :=2;
                    EmployeePayDetails.Terminated := FALSE;
                    EmployeePayDetails."Employment Status Date" := 0D;
                  END;
                  IF Status = 1 THEN BEGIN
                    EmployeePayDetails."Employment Status" := 1;
                    EmployeePayDetails.Terminated := FALSE;
                  END;
                  IF Status = 2 THEN BEGIN
                    EmployeePayDetails."Employment Status" := 2;
                    EmployeePayDetails.Terminated := FALSE;
                    EmployeePayDetails."Employment Status Date" := 0D;
                  END;
                  IF Status = 3 THEN BEGIN
                    EmployeePayDetails."Employment Status" := 3;
                    EmployeePayDetails.Terminated := TRUE;
                  END;
                  EmployeePayDetails.MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(32;"Inactive Date";Date)
        {
            CaptionML = ENU='Inactive Date',
                        ENA='Inactive Date';
        }
        field(33;"Cause of Inactivity Code";Code[10])
        {
            CaptionML = ENU='Cause of Inactivity Code',
                        ENA='Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(34;"Termination Date";Date)
        {
            CaptionML = ENU='Termination Date',
                        ENA='Termination Date';

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  EmployeePayDetails."Employment End Date" := "Termination Date";
                  MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(35;"Grounds for Term. Code";Code[10])
        {
            CaptionML = ENU='Grounds for Term. Code',
                        ENA='Grounds for Term. Code';
            TableRelation = "Grounds for Termination";
        }
        field(36;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU='Global Dimension 1 Code',
                        ENA='Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(37;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU='Global Dimension 2 Code',
                        ENA='Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(38;"Resource No.";Code[20])
        {
            CaptionML = ENU='Resource No.',
                        ENA='Resource No.';
            TableRelation = Resource WHERE (Type=CONST(Person));

            trigger OnValidate();
            begin
                IF ("Resource No." <> '') AND Res.WRITEPERMISSION THEN
                  EmployeeResUpdate.ResUpdate(Rec)
            end;
        }
        field(39;Comment;Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE (Table Name=CONST(Employee), No.=FIELD(No.)));
            CaptionML = ENU='Comment',
                        ENA='Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Last Date Modified";Date)
        {
            CaptionML = ENU='Last Date Modified',
                        ENA='Last Date Modified';
            Editable = false;
        }
        field(41;"Date Filter";Date)
        {
            CaptionML = ENU='Date Filter',
                        ENA='Date Filter';
            FieldClass = FlowFilter;
        }
        field(42;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU='Global Dimension 1 Filter',
                        ENA='Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(43;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU='Global Dimension 2 Filter',
                        ENA='Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(44;"Cause of Absence Filter";Code[10])
        {
            CaptionML = ENU='Cause of Absence Filter',
                        ENA='Cause of Absence Filter';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(45;"Total Absence (Base)";Decimal)
        {
            CalcFormula = Sum("Employee Absence"."Quantity (Base)" WHERE (Employee No.=FIELD(No.), Cause of Absence Code=FIELD(Cause of Absence Filter), From Date=FIELD(Date Filter)));
            CaptionML = ENU='Total Absence (Base)',
                        ENA='Total Absence (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(46;Extension;Text[30])
        {
            CaptionML = ENU='Extension',
                        ENA='Extension';
        }
        field(47;"Employee No. Filter";Code[20])
        {
            CaptionML = ENU='Employee No. Filter',
                        ENA='Employee No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(48;Pager;Text[30])
        {
            CaptionML = ENU='Pager',
                        ENA='Pager';
        }
        field(49;"Fax No.";Text[30])
        {
            CaptionML = ENU='Fax No.',
                        ENA='Fax No.';
        }
        field(50;"Company E-Mail";Text[80])
        {
            CaptionML = ENU='Company Email',
                        ENA='Company Email';
        }
        field(51;Title;Text[30])
        {
            CaptionML = ENU='Title',
                        ENA='Title';
        }
        field(52;"Salespers./Purch. Code";Code[10])
        {
            CaptionML = ENU='Salespers./Purch. Code',
                        ENA='Salespers./Purch. Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(53;"No. Series";Code[10])
        {
            CaptionML = ENU='No. Series',
                        ENA='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(140;Image;Media)
        {
            CaptionML = ENU='Image',
                        ENA='Image';
            ExtendedDatatype = Person;
        }
        field(1100;"Cost Center Code";Code[20])
        {
            CaptionML = ENU='Cost Center Code',
                        ENA='Cost Centre Code';
            TableRelation = "Cost Center";
        }
        field(1101;"Cost Object Code";Code[20])
        {
            CaptionML = ENU='Cost Object Code',
                        ENA='Cost Object Code';
            TableRelation = "Cost Object";
        }
        field(50000;"Accrued leave";Decimal)
        {
        }
        field(50200;"Branch Code";Code[20])
        {
            TableRelation = Branch.Code;

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  EmployeePayDetails."Branch Code" := "Branch Code";
                  EmployeePayDetails.MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(50201;"Shift Code";Option)
        {
            OptionMembers = First,Second,Third,Fourth,Fifth;

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  EmployeePayDetails."Shift Code" := "Shift Code";
                  EmployeePayDetails.MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(50202;"Calendar Code";Code[4])
        {
            TableRelation = "Payroll Calendar"."Calendar Code";

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                IF EmployeePayDetails.GET("No.") THEN BEGIN
                  EmployeePayDetails."Calendar Code" := "Calendar Code";
                  EmployeePayDetails.MODIFY;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(50203;"Statistics Group";Code[20])
        {
            TableRelation = "Statistics Group".Code;

            trigger OnValidate();
            begin
                //ASHNEIL CHANDRA   13072017
                StatisticsGroup.INIT;
                StatisticsGroup.RESET;
                IF StatisticsGroup.GET("Statistics Group") THEN BEGIN
                  IF EmployeePayDetails.GET("No.") THEN BEGIN
                    EmployeePayDetails."Runs Per Calendar" := StatisticsGroup."Runs Per Calendar";
                    EmployeePayDetails."Statistics Group" := "Statistics Group";

                    IF "Statistics Group" = 'WEEKLY' THEN BEGIN
                      EmployeePayDetails."Payment Frequency" := 1;
                    END;
                    IF "Statistics Group" = 'FORTNIGHTLY' THEN BEGIN
                      EmployeePayDetails."Payment Frequency" := 2;
                    END;
                    IF "Statistics Group" = 'BI-MONTHLY' THEN BEGIN
                      EmployeePayDetails."Payment Frequency" := 2;
                    END;
                    IF "Statistics Group" = 'MONTHLY' THEN BEGIN
                      EmployeePayDetails."Payment Frequency" := 3;
                    END;
                    EmployeePayDetails.MODIFY;
                  END;
                END;
                //ASHNEIL CHANDRA   13072017
            end;
        }
        field(50212;Terminated;Boolean)
        {
        }
        field(50213;"Azure Password";Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(50214;"Azure Admin";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;Status,"Union Code")
        {
        }
        key(Key4;Status,"Emplymt. Contract Code")
        {
        }
        key(Key5;"Last Name","First Name","Middle Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","First Name","Last Name",Initials,"Job Title")
        {
        }
        fieldgroup(Brick;"No.","First Name","Last Name","Job Title",Image)
        {
        }
    }

    trigger OnDelete();
    begin
        AlternativeAddr.SETRANGE("Employee No.","No.");
        AlternativeAddr.DELETEALL;

        EmployeeQualification.SETRANGE("Employee No.","No.");
        EmployeeQualification.DELETEALL;

        Relative.SETRANGE("Employee No.","No.");
        Relative.DELETEALL;

        EmployeeAbsence.SETRANGE("Employee No.","No.");
        EmployeeAbsence.DELETEALL;

        MiscArticleInformation.SETRANGE("Employee No.","No.");
        MiscArticleInformation.DELETEALL;

        ConfidentialInformation.SETRANGE("Employee No.","No.");
        ConfidentialInformation.DELETEALL;

        HumanResComment.SETRANGE("No.","No.");
        HumanResComment.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::Employee,"No.");

        PostCodeCheck.DeleteAllAddressID(DATABASE::Employee,GETPOSITION);

        //ASHNEIL CHANDRA   13072017
        IF EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.DELETE;
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Employee Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        DimMgt.UpdateDefaultDim(
          DATABASE::Employee,"No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");

        //ASHNEIL CHANDRA   13072017
        IF NOT EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.INSERT;
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
        IF Res.READPERMISSION THEN
          EmployeeResUpdate.HumanResToRes(xRec,Rec);
        IF SalespersonPurchaser.READPERMISSION THEN
          EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec,Rec);

        //ASHNEIL CHANDRA   13072017
        IF NOT EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.INSERT;
        END;
        IF EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.MODIFY;
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;

        PostCodeCheck.MoveAllAddressID(
          DATABASE::Employee,xRec.GETPOSITION,DATABASE::Employee,GETPOSITION);

        //ASHNEIL CHANDRA   13072017
        IF NOT EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.INSERT;
        END;
        IF EmployeePayDetails.GET("No.") THEN BEGIN
          EmployeePayDetails."No." := "No.";
          EmployeePayDetails.MODIFY;
        END;
        //ASHNEIL CHANDRA   13072017
    end;

    var
        HumanResSetup : Record "Human Resources Setup";
        Employee : Record Employee;
        Res : Record Resource;
        PostCode : Record "Post Code";
        AlternativeAddr : Record "Alternative Address";
        EmployeeQualification : Record "Employee Qualification";
        Relative : Record "Employee Relative";
        EmployeeAbsence : Record "Employee Absence";
        MiscArticleInformation : Record "Misc. Article Information";
        ConfidentialInformation : Record "Confidential Information";
        HumanResComment : Record "Human Resource Comment Line";
        SalespersonPurchaser : Record "Salesperson/Purchaser";
        NoSeriesMgt : Codeunit NoSeriesManagement;
        EmployeeResUpdate : Codeunit "Employee/Resource Update";
        EmployeeSalespersonUpdate : Codeunit "Employee/Salesperson Update";
        DimMgt : Codeunit DimensionManagement;
        Text000 : TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ENA='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        PostCodeCheck : Codeunit Codeunit28000;
        EmployeePayDetails : Record "Employee Pay Details";
        StatisticsGroup : Record "Statistics Group";

    procedure AssistEdit(OldEmployee : Record Employee) : Boolean;
    begin
        WITH Employee DO BEGIN
          Employee := Rec;
          HumanResSetup.GET;
          HumanResSetup.TESTFIELD("Employee Nos.");
          IF NoSeriesMgt.SelectSeries(HumanResSetup."Employee Nos.",OldEmployee."No. Series","No. Series") THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Employee Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Employee;
            EXIT(TRUE);
          END;
        END;
    end;

    procedure FullName() : Text[100];
    begin
        IF "Middle Name" = '' THEN
          EXIT("First Name" + ' ' + "Last Name");

        EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    local procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Employee,"No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;

    procedure DisplayMap();
    var
        MapPoint : Record "Online Map Setup";
        MapMgt : Codeunit "Online Map Management";
    begin
        IF MapPoint.FINDFIRST THEN
          MapMgt.MakeSelection(DATABASE::Employee,GETPOSITION)
        ELSE
          MESSAGE(Text000);
    end;
}

