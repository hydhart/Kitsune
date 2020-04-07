table 270 "Bank Account"
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585

    CaptionML = ENU='Bank Account',
                ENA='Bank Account';
    DataCaptionFields = "No.",Name;
    DrillDownPageID = 371;
    LookupPageID = 371;
    Permissions = TableData "Bank Account Ledger Entry"=r;

    fields
    {
        field(1;"No.";Code[20])
        {
            CaptionML = ENU='No.',
                        ENA='No.';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                  GLSetup.GET;
                  NoSeriesMgt.TestManual(GLSetup."Bank Account Nos.");
                  "No. Series" := '';
                END;
            end;
        }
        field(2;Name;Text[50])
        {
            CaptionML = ENU='Name',
                        ENA='Name';

            trigger OnValidate();
            begin
                IF ("Search Name" = UPPERCASE(xRec.Name)) OR ("Search Name" = '') THEN
                  "Search Name" := Name;
            end;
        }
        field(3;"Search Name";Code[50])
        {
            CaptionML = ENU='Search Name',
                        ENA='Search Name';
        }
        field(4;"Name 2";Text[50])
        {
            CaptionML = ENU='Name 2',
                        ENA='Name 2';
        }
        field(5;Address;Text[50])
        {
            CaptionML = ENU='Address',
                        ENA='Address';

            trigger OnValidate();
            begin
                PostCodeCheck.ValidateAddress(
                  CurrFieldNo,DATABASE::"Bank Account",Rec.GETPOSITION,0,
                  Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(6;"Address 2";Text[50])
        {
            CaptionML = ENU='Address 2',
                        ENA='Address 2';

            trigger OnValidate();
            begin
                PostCodeCheck.ValidateAddress(
                  CurrFieldNo,DATABASE::"Bank Account",Rec.GETPOSITION,0,
                  Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(7;City;Text[30])
        {
            CaptionML = ENU='City',
                        ENA='City';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code".City ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCodeCheck.ValidateCity(
                  CurrFieldNo,DATABASE::"Bank Account",Rec.GETPOSITION,0,
                  Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(8;Contact;Text[50])
        {
            CaptionML = ENU='Contact',
                        ENA='Contact';
        }
        field(9;"Phone No.";Text[30])
        {
            CaptionML = ENU='Phone No.',
                        ENA='Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10;"Telex No.";Text[20])
        {
            CaptionML = ENU='Telex No.',
                        ENA='Telex No.';
        }
        field(13;"Bank Account No.";Text[30])
        {
            CaptionML = ENU='Bank Account No.',
                        ENA='Bank Account No.';
        }
        field(14;"Transit No.";Text[20])
        {
            CaptionML = ENU='Transit No.',
                        ENA='Transit No.';
        }
        field(15;"Territory Code";Code[10])
        {
            CaptionML = ENU='Territory Code',
                        ENA='Territory Code';
            TableRelation = Territory;
        }
        field(16;"Global Dimension 1 Code";Code[20])
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
        field(17;"Global Dimension 2 Code";Code[20])
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
        field(18;"Chain Name";Code[10])
        {
            CaptionML = ENU='Chain Name',
                        ENA='Chain Name';
        }
        field(20;"Min. Balance";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Min. Balance',
                        ENA='Min. Balance';
        }
        field(21;"Bank Acc. Posting Group";Code[10])
        {
            CaptionML = ENU='Bank Acc. Posting Group',
                        ENA='Bank Acc. Posting Group';
            TableRelation = "Bank Account Posting Group";
        }
        field(22;"Currency Code";Code[10])
        {
            CaptionML = ENU='Currency Code',
                        ENA='Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            begin
                IF "Currency Code" = xRec."Currency Code" THEN
                  EXIT;

                BankAcc.RESET;
                BankAcc := Rec;
                BankAcc.CALCFIELDS(Balance,"Balance (LCY)");
                BankAcc.TESTFIELD(Balance,0);
                BankAcc.TESTFIELD("Balance (LCY)",0);

                IF NOT BankAccLedgEntry.SETCURRENTKEY("Bank Account No.",Open) THEN
                  BankAccLedgEntry.SETCURRENTKEY("Bank Account No.");
                BankAccLedgEntry.SETRANGE("Bank Account No.","No.");
                BankAccLedgEntry.SETRANGE(Open,TRUE);
                IF BankAccLedgEntry.FINDLAST THEN
                  ERROR(
                    Text000,
                    FIELDCAPTION("Currency Code"));
            end;
        }
        field(24;"Language Code";Code[10])
        {
            CaptionML = ENU='Language Code',
                        ENA='Language Code';
            TableRelation = Language;
        }
        field(26;"Statistics Group";Integer)
        {
            CaptionML = ENU='Statistics Group',
                        ENA='Statistics Group';
        }
        field(29;"Our Contact Code";Code[10])
        {
            CaptionML = ENU='Our Contact Code',
                        ENA='Our Contact Code';
            TableRelation = Salesperson/Purchaser;
        }
        field(35;"Country/Region Code";Code[10])
        {
            CaptionML = ENU='Country/Region Code',
                        ENA='Country/Region Code';
            TableRelation = Country/Region;
        }
        field(37;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Amount',
                        ENA='Amount';
        }
        field(38;Comment;Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE (Table Name=CONST(Bank Account), No.=FIELD(No.)));
            CaptionML = ENU='Comment',
                        ENA='Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39;Blocked;Boolean)
        {
            CaptionML = ENU='Blocked',
                        ENA='Blocked';
        }
        field(41;"Last Statement No.";Code[20])
        {
            CaptionML = ENU='Last Statement No.',
                        ENA='Last Statement No.';
        }
        field(42;"Last Payment Statement No.";Code[20])
        {
            CaptionML = ENU='Last Payment Statement No.',
                        ENA='Last Payment Statement No.';

            trigger OnValidate();
            var
                TextManagement : Codeunit TextManagement;
            begin
                TextManagement.EvaluateIncStr("Last Payment Statement No.",FIELDCAPTION("Last Payment Statement No."));
            end;
        }
        field(54;"Last Date Modified";Date)
        {
            CaptionML = ENU='Last Date Modified',
                        ENA='Last Date Modified';
            Editable = false;
        }
        field(55;"Date Filter";Date)
        {
            CaptionML = ENU='Date Filter',
                        ENA='Date Filter';
            FieldClass = FlowFilter;
        }
        field(56;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            CaptionML = ENU='Global Dimension 1 Filter',
                        ENA='Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(57;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            CaptionML = ENU='Global Dimension 2 Filter',
                        ENA='Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(58;Balance;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            CaptionML = ENU='Balance',
                        ENA='Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59;"Balance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter)));
            CaptionML = ENU='Balance (LCY)',
                        ENA='Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60;"Net Change";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Net Change',
                        ENA='Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61;"Net Change (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Net Change (LCY)',
                        ENA='Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62;"Total on Checks";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Check Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.), Entry Status=FILTER(Posted), Statement Status=FILTER(<>Closed)));
            CaptionML = ENU='Total on Checks',
                        ENA='Total on Cheques';
            Editable = false;
            FieldClass = FlowField;
        }
        field(84;"Fax No.";Text[30])
        {
            CaptionML = ENU='Fax No.',
                        ENA='Fax No.';
        }
        field(85;"Telex Answer Back";Text[20])
        {
            CaptionML = ENU='Telex Answer Back',
                        ENA='Telex Answer Back';
        }
        field(89;Picture;BLOB)
        {
            CaptionML = ENU='Picture',
                        ENA='Picture';
            SubType = Bitmap;
        }
        field(91;"Post Code";Code[20])
        {
            CaptionML = ENU='Post Code',
                        ENA='Postcode';
            TableRelation = IF (Country/Region Code=CONST()) "Post Code" ELSE IF (Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Country/Region Code));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCodeCheck.ValidatePostCode(
                  CurrFieldNo,DATABASE::"Bank Account",Rec.GETPOSITION,0,
                  Name,"Name 2",Contact,Address,"Address 2",City,"Post Code",County,"Country/Region Code");
            end;
        }
        field(92;County;Text[30])
        {
            CaptionML = ENU='County',
                        ENA='State';
        }
        field(93;"Last Check No.";Code[20])
        {
            AccessByPermission = TableData "Check Ledger Entry"=R;
            CaptionML = ENU='Last Check No.',
                        ENA='Last Cheque No.';
        }
        field(94;"Balance Last Statement";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Balance Last Statement',
                        ENA='Balance Last Statement';
        }
        field(95;"Balance at Date";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry".Amount WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(UPPERLIMIT(Date Filter))));
            CaptionML = ENU='Balance at Date',
                        ENA='Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(96;"Balance at Date (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Bank Account Ledger Entry"."Amount (LCY)" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(UPPERLIMIT(Date Filter))));
            CaptionML = ENU='Balance at Date (LCY)',
                        ENA='Balance at Date (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(97;"Debit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Bank Account Ledger Entry"."Debit Amount" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Debit Amount',
                        ENA='Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98;"Credit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Bank Account Ledger Entry"."Credit Amount" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Credit Amount',
                        ENA='Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99;"Debit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Bank Account Ledger Entry"."Debit Amount (LCY)" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Debit Amount (LCY)',
                        ENA='Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100;"Credit Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Bank Account Ledger Entry"."Credit Amount (LCY)" WHERE (Bank Account No.=FIELD(No.), Global Dimension 1 Code=FIELD(Global Dimension 1 Filter), Global Dimension 2 Code=FIELD(Global Dimension 2 Filter), Posting Date=FIELD(Date Filter)));
            CaptionML = ENU='Credit Amount (LCY)',
                        ENA='Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Bank Branch No.";Text[20])
        {
            CaptionML = ENU='Bank Branch No.',
                        ENA='Bank Branch No.';
        }
        field(102;"E-Mail";Text[80])
        {
            CaptionML = ENU='Email',
                        ENA='Email';
            ExtendedDatatype = EMail;
        }
        field(103;"Home Page";Text[80])
        {
            CaptionML = ENU='Home Page',
                        ENA='Home Page';
            ExtendedDatatype = URL;
        }
        field(107;"No. Series";Code[10])
        {
            CaptionML = ENU='No. Series',
                        ENA='No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Check Report ID";Integer)
        {
            CaptionML = ENU='Check Report ID',
                        ENA='Cheque Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE (Object Type=CONST(Report));
        }
        field(109;"Check Report Name";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Name" WHERE (Object Type=CONST(Report), Object ID=FIELD(Check Report ID)));
            CaptionML = ENU='Check Report Name',
                        ENA='Cheque Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110;IBAN;Code[50])
        {
            CaptionML = ENU='IBAN',
                        ENA='IBAN';

            trigger OnValidate();
            var
                CompanyInfo : Record "Company Information";
            begin
                CompanyInfo.CheckIBAN(IBAN);
            end;
        }
        field(111;"SWIFT Code";Code[20])
        {
            CaptionML = ENU='SWIFT Code',
                        ENA='SWIFT Code';
        }
        field(113;"Bank Statement Import Format";Code[20])
        {
            CaptionML = ENU='Bank Statement Import Format',
                        ENA='Bank Statement Import Format';
            TableRelation = "Bank Export/Import Setup".Code WHERE (Direction=CONST(Import));
        }
        field(115;"Credit Transfer Msg. Nos.";Code[10])
        {
            CaptionML = ENU='Credit Transfer Msg. Nos.',
                        ENA='Credit Transfer Msg. Nos.';
            TableRelation = "No. Series";
        }
        field(116;"Direct Debit Msg. Nos.";Code[10])
        {
            CaptionML = ENU='Direct Debit Msg. Nos.',
                        ENA='Direct Debit Msg. Nos.';
            TableRelation = "No. Series";
        }
        field(117;"SEPA Direct Debit Exp. Format";Code[20])
        {
            CaptionML = ENU='SEPA Direct Debit Exp. Format',
                        ENA='SEPA Direct Debit Exp. Format';
            TableRelation = "Bank Export/Import Setup".Code WHERE (Direction=CONST(Export));
        }
        field(121;"Bank Stmt. Service Record ID";RecordID)
        {
            CaptionML = ENU='Bank Stmt. Service Record ID',
                        ENA='Bank Stmt. Service Record ID';

            trigger OnValidate();
            var
                Handled : Boolean;
            begin
                IF FORMAT("Bank Stmt. Service Record ID") = '' THEN
                  OnUnlinkStatementProviderEvent(Rec,Handled);
            end;
        }
        field(123;"Transaction Import Timespan";Integer)
        {
            CaptionML = ENU='Transaction Import Timespan',
                        ENA='Transaction Import Timespan';

            trigger OnValidate();
            begin
                IF NOT ("Transaction Import Timespan" IN [0..9999]) THEN
                  ERROR(TransactionImportTimespanMustBePositiveErr);
            end;
        }
        field(124;"Automatic Stmt. Import Enabled";Boolean)
        {
            CaptionML = ENU='Automatic Stmt. Import Enabled',
                        ENA='Automatic Stmt. Import Enabled';

            trigger OnValidate();
            begin
                IF "Automatic Stmt. Import Enabled" THEN BEGIN
                  IF NOT IsAutoLogonPossible THEN
                    ERROR(MFANotSupportedErr);

                  IF NOT ("Transaction Import Timespan" IN [0..9999]) THEN
                    ERROR(TransactionImportTimespanMustBePositiveErr);
                  ScheduleBankStatementDownload
                END ELSE
                  UnscheduleBankStatementDownload;
            end;
        }
        field(140;Image;Media)
        {
            CaptionML = ENU='Image',
                        ENA='Image';
            ExtendedDatatype = Person;
        }
        field(170;"Creditor No.";Code[35])
        {
            CaptionML = ENU='Creditor No.',
                        ENA='Creditor No.';
        }
        field(1210;"Payment Export Format";Code[20])
        {
            CaptionML = ENU='Payment Export Format',
                        ENA='Payment Export Format';
            TableRelation = "Bank Export/Import Setup".Code WHERE (Direction=CONST(Export));
        }
        field(1211;"Bank Clearing Code";Text[50])
        {
            CaptionML = ENU='Bank Clearing Code',
                        ENA='Bank Clearing Code';
        }
        field(1212;"Bank Clearing Standard";Text[50])
        {
            CaptionML = ENU='Bank Clearing Standard',
                        ENA='Bank Clearing Standard';
            TableRelation = "Bank Clearing Standard";
        }
        field(1213;"Bank Name - Data Conversion";Text[50])
        {
            CaptionML = ENU='Bank Name - Data Conversion',
                        ENA='Bank Name - Data Conversion';
            TableRelation = "Bank Data Conv. Bank" WHERE (Country/Region Code=FIELD(Country/Region Code));
            ValidateTableRelation = false;
        }
        field(1250;"Match Tolerance Type";Option)
        {
            CaptionML = ENU='Match Tolerance Type',
                        ENA='Match Tolerance Type';
            OptionCaptionML = ENU='Percentage,Amount',
                              ENA='Percentage,Amount';
            OptionMembers = Percentage,Amount;

            trigger OnValidate();
            begin
                IF "Match Tolerance Type" <> xRec."Match Tolerance Type" THEN
                  "Match Tolerance Value" := 0;
            end;
        }
        field(1251;"Match Tolerance Value";Decimal)
        {
            CaptionML = ENU='Match Tolerance Value',
                        ENA='Match Tolerance Value';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                IF "Match Tolerance Value" < 0 THEN
                  ERROR(InvalidValueErr);

                IF "Match Tolerance Type" = "Match Tolerance Type"::Percentage THEN
                  IF "Match Tolerance Value" > 99 THEN
                    ERROR(InvalidPercentageValueErr,FIELDCAPTION("Match Tolerance Type"),
                      FORMAT("Match Tolerance Type"::Percentage));
            end;
        }
        field(1260;"Positive Pay Export Code";Code[20])
        {
            CaptionML = ENU='Positive Pay Export Code',
                        ENA='Positive Pay Export Code';
            TableRelation = "Bank Export/Import Setup".Code WHERE (Direction=CONST(Export-Positive Pay));
        }
        field(11600;"EFT Bank Code";Code[10])
        {
            CaptionML = ENU='EFT Bank Code',
                        ENA='EFT Bank Code';
        }
        field(11601;"EFT BSB No.";Code[10])
        {
            CaptionML = ENU='EFT BSB No.',
                        ENA='EFT BSB No.';
        }
        field(11602;"EFT Security No.";Text[30])
        {
            CaptionML = ENU='EFT Security No.',
                        ENA='EFT Security No.';
        }
        field(11603;"EFT Balancing Record Required";Boolean)
        {
            CaptionML = ENU='EFT Balancing Record Required',
                        ENA='EFT Balancing Record Required';
        }
        field(11604;"EFT Security Name";Text[50])
        {
            CaptionML = ENU='EFT Security Name',
                        ENA='EFT Security Name';
        }
        field(50200;"E-Banking Customer Name";Code[20])
        {
        }
        field(50201;"DR Transaction Code";Code[3])
        {
        }
        field(50202;"CR Transaction Code";Code[3])
        {
        }
        field(50203;"Electronic File Name";Text[30])
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
        key(Key3;"Bank Acc. Posting Group")
        {
        }
        key(Key4;"Currency Code")
        {
        }
        key(Key5;"Country/Region Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,"Bank Account No.","Currency Code")
        {
        }
        fieldgroup(Brick;"No.",Name,"Bank Account No.","Currency Code",Image)
        {
        }
    }

    trigger OnDelete();
    begin
        MoveEntries.MoveBankAccEntries(Rec);

        CommentLine.SETRANGE("Table Name",CommentLine."Table Name"::"Bank Account");
        CommentLine.SETRANGE("No.","No.");
        CommentLine.DELETEALL;

        UpdateContFromBank.OnDelete(Rec);

        DimMgt.DeleteDefaultDim(DATABASE::"Bank Account","No.");

        PostCodeCheck.DeleteAllAddressID(DATABASE::"Bank Account",Rec.GETPOSITION);
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
          GLSetup.GET;
          GLSetup.TESTFIELD("Bank Account Nos.");
          NoSeriesMgt.InitSeries(GLSetup."Bank Account Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;

        IF NOT InsertFromContact THEN
          UpdateContFromBank.OnInsert(Rec);

        DimMgt.UpdateDefaultDim(
          DATABASE::"Bank Account","No.",
          "Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;

        IF (Name <> xRec.Name) OR
           ("Search Name" <> xRec."Search Name") OR
           ("Name 2" <> xRec."Name 2") OR
           (Address <> xRec.Address) OR
           ("Address 2" <> xRec."Address 2") OR
           (City <> xRec.City) OR
           ("Phone No." <> xRec."Phone No.") OR
           ("Telex No." <> xRec."Telex No.") OR
           ("Territory Code" <> xRec."Territory Code") OR
           ("Currency Code" <> xRec."Currency Code") OR
           ("Language Code" <> xRec."Language Code") OR
           ("Our Contact Code" <> xRec."Our Contact Code") OR
           ("Country/Region Code" <> xRec."Country/Region Code") OR
           ("Fax No." <> xRec."Fax No.") OR
           ("Telex Answer Back" <> xRec."Telex Answer Back") OR
           ("Post Code" <> xRec."Post Code") OR
           (County <> xRec.County) OR
           ("E-Mail" <> xRec."E-Mail") OR
           ("Home Page" <> xRec."Home Page")
        THEN BEGIN
          MODIFY;
          UpdateContFromBank.OnModify(Rec);
          IF NOT FIND THEN BEGIN
            RESET;
            IF FIND THEN;
          END;
        END;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;

        PostCodeCheck.MoveAllAddressID(
          DATABASE::"Bank Account",xRec.GETPOSITION,DATABASE::"Bank Account",Rec.GETPOSITION);
    end;

    var
        Text000 : TextConst ENU='You cannot change %1 because there are one or more open ledger entries for this bank account.',ENA='You cannot change %1 because there are one or more open ledger entries for this bank account.';
        Text003 : TextConst ENU='Do you wish to create a contact for %1 %2?',ENA='Do you wish to create a contact for %1 %2?';
        GLSetup : Record "General Ledger Setup";
        BankAcc : Record "Bank Account";
        BankAccLedgEntry : Record "Bank Account Ledger Entry";
        CommentLine : Record "Comment Line";
        PostCode : Record "Post Code";
        NoSeriesMgt : Codeunit NoSeriesManagement;
        MoveEntries : Codeunit MoveEntries;
        UpdateContFromBank : Codeunit "BankCont-Update";
        DimMgt : Codeunit DimensionManagement;
        PostCodeCheck : Codeunit Codeunit28000;
        InsertFromContact : Boolean;
        Text004 : TextConst ENU='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.',ENA='Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        BankAccIdentifierIsEmptyErr : TextConst ENU='You must specify either a %1 or an %2.',ENA='You must specify either a %1 or an %2.';
        InvalidPercentageValueErr : TextConst Comment='%1 is "field caption and %2 is "Percentage"',ENU='If %1 is %2, then the value must be between 0 and 99.',ENA='If %1 is %2, then the value must be between 0 and 99.';
        InvalidValueErr : TextConst ENU='The value must be positive.',ENA='The value must be positive.';
        DataExchNotSetErr : TextConst ENU='The Data Exchange Code field must be filled.',ENA='The Data Exchange Code field must be filled.';
        BankStmtScheduledDownloadDescTxt : TextConst Comment='%1 - Bank Account name',ENU='%1 Bank Statement Import',ENA='%1 Bank Statement Import';
        JobQEntriesCreatedQst : TextConst ENU='A job queue entry for import of bank statements has been created.\\Do you want to open the Job Queue Entry window?',ENA='A job queue entry for import of bank statements has been created.\\Do you want to open the Job Queue Entry window?';
        TransactionImportTimespanMustBePositiveErr : TextConst ENU='The value in the Number of Days Included field must be a positive number not greater than 9999.',ENA='The value in the Number of Days Included field must be a positive number not greater than 9999.';
        MFANotSupportedErr : TextConst ENU='Cannot setup automatic bank statement import because the selected bank requires multi-factor authentication.',ENA='Cannot setup automatic bank statement import because the selected bank requires multi-factor authentication.';
        BankAccNotLinkedErr : TextConst ENU='This bank account is not linked to an online bank account.',ENA='This bank account is not linked to an online bank account.';
        AutoLogonNotPossibleErr : TextConst ENU='Automatic logon is not possible for this bank account.',ENA='Automatic logon is not possible for this bank account.';
        CancelTxt : TextConst ENU='Cancel',ENA='Cancel';
        OnlineFeedStatementStatus : Option "Not Linked",Linked,"Linked and Auto. Bank Statement Enabled";

    procedure AssistEdit(OldBankAcc : Record "Bank Account") : Boolean;
    begin
        WITH BankAcc DO BEGIN
          BankAcc := Rec;
          GLSetup.GET;
          GLSetup.TESTFIELD("Bank Account Nos.");
          IF NoSeriesMgt.SelectSeries(GLSetup."Bank Account Nos.",OldBankAcc."No. Series","No. Series") THEN BEGIN
            GLSetup.GET;
            GLSetup.TESTFIELD("Bank Account Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := BankAcc;
            EXIT(TRUE);
          END;
        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Bank Account","No.",FieldNumber,ShortcutDimCode);
        MODIFY;
    end;

    procedure ShowContact();
    var
        ContBusRel : Record "Contact Business Relation";
        Cont : Record Contact;
    begin
        IF "No." = '' THEN
          EXIT;

        ContBusRel.SETCURRENTKEY("Link to Table","No.");
        ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::"Bank Account");
        ContBusRel.SETRANGE("No.","No.");
        IF NOT ContBusRel.FINDFIRST THEN BEGIN
          IF NOT CONFIRM(Text003,FALSE,TABLECAPTION,"No.") THEN
            EXIT;
          UpdateContFromBank.InsertNewContact(Rec,FALSE);
          ContBusRel.FINDFIRST;
        END;
        COMMIT;

        Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
        Cont.SETRANGE("Company No.",ContBusRel."Contact No.");
        PAGE.RUN(PAGE::"Contact List",Cont);
    end;

    procedure SetInsertFromContact(FromContact : Boolean);
    begin
        InsertFromContact := FromContact;
    end;

    procedure GetPaymentExportCodeunitID() : Integer;
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
    begin
        GetBankExportImportSetup(BankExportImportSetup);
        EXIT(BankExportImportSetup."Processing Codeunit ID");
    end;

    procedure GetPaymentExportXMLPortID() : Integer;
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
    begin
        GetBankExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TESTFIELD("Processing XMLport ID");
        EXIT(BankExportImportSetup."Processing XMLport ID");
    end;

    procedure GetDDExportCodeunitID() : Integer;
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
    begin
        GetDDExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TESTFIELD("Processing Codeunit ID");
        EXIT(BankExportImportSetup."Processing Codeunit ID");
    end;

    procedure GetDDExportXMLPortID() : Integer;
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
    begin
        GetDDExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TESTFIELD("Processing XMLport ID");
        EXIT(BankExportImportSetup."Processing XMLport ID");
    end;

    procedure GetBankExportImportSetup(var BankExportImportSetup : Record "Bank Export/Import Setup");
    begin
        TESTFIELD("Payment Export Format");
        BankExportImportSetup.GET("Payment Export Format");
    end;

    procedure GetDDExportImportSetup(var BankExportImportSetup : Record "Bank Export/Import Setup");
    begin
        TESTFIELD("SEPA Direct Debit Exp. Format");
        BankExportImportSetup.GET("SEPA Direct Debit Exp. Format");
    end;

    procedure GetCreditTransferMessageNo() : Code[20];
    var
        NoSeriesManagement : Codeunit NoSeriesManagement;
    begin
        TESTFIELD("Credit Transfer Msg. Nos.");
        EXIT(NoSeriesManagement.GetNextNo("Credit Transfer Msg. Nos.",TODAY,TRUE));
    end;

    procedure GetDirectDebitMessageNo() : Code[20];
    var
        NoSeriesManagement : Codeunit NoSeriesManagement;
    begin
        TESTFIELD("Direct Debit Msg. Nos.");
        EXIT(NoSeriesManagement.GetNextNo("Direct Debit Msg. Nos.",TODAY,TRUE));
    end;

    procedure DisplayMap();
    var
        MapPoint : Record "Online Map Setup";
        MapMgt : Codeunit "Online Map Management";
    begin
        IF MapPoint.FINDFIRST THEN
          MapMgt.MakeSelection(DATABASE::"Bank Account",GETPOSITION)
        ELSE
          MESSAGE(Text004);
    end;

    procedure GetDataExchDef(var DataExchDef : Record "Data Exch. Def");
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
        DataExchDefCodeResponse : Code[20];
        Handled : Boolean;
    begin
        OnGetDataExchangeDefinitionEvent(DataExchDefCodeResponse,Handled);
        IF NOT Handled THEN BEGIN
          TESTFIELD("Bank Statement Import Format");
          DataExchDefCodeResponse := "Bank Statement Import Format";
        END;

        IF DataExchDefCodeResponse = '' THEN
          ERROR(DataExchNotSetErr);

        BankExportImportSetup.GET(DataExchDefCodeResponse);
        BankExportImportSetup.TESTFIELD("Data Exch. Def. Code");

        DataExchDef.GET(BankExportImportSetup."Data Exch. Def. Code");
        DataExchDef.TESTFIELD(Type,DataExchDef.Type::"Bank Statement Import");
    end;

    procedure GetBankAccountNoWithCheck() AccountNo : Text;
    begin
        AccountNo := GetBankAccountNo;
        IF AccountNo = '' THEN
          ERROR(BankAccIdentifierIsEmptyErr,FIELDCAPTION("Bank Account No."),FIELDCAPTION(IBAN));
    end;

    procedure GetBankAccountNo() : Text;
    begin
        IF IBAN <> '' THEN
          EXIT(DELCHR(IBAN,'=<>'));

        IF "Bank Account No." <> '' THEN
          EXIT("Bank Account No.");
    end;

    procedure IsInLocalCurrency() : Boolean;
    var
        GeneralLedgerSetup : Record "General Ledger Setup";
    begin
        IF "Currency Code" = '' THEN
          EXIT(TRUE);

        GeneralLedgerSetup.GET;
        EXIT("Currency Code" = GeneralLedgerSetup.GetCurrencyCode(''));
    end;

    procedure GetPosPayExportCodeunitID() : Integer;
    var
        BankExportImportSetup : Record "Bank Export/Import Setup";
    begin
        TESTFIELD("Positive Pay Export Code");
        BankExportImportSetup.GET("Positive Pay Export Code");
        EXIT(BankExportImportSetup."Processing Codeunit ID");
    end;

    procedure IsLinkedToBankStatementServiceProvider() : Boolean;
    var
        IsBankAccountLinked : Boolean;
    begin
        OnCheckLinkedToStatementProviderEvent(Rec,IsBankAccountLinked);
        EXIT(IsBankAccountLinked);
    end;

    procedure StatementProvidersExist() : Boolean;
    var
        TempNameValueBuffer : Record "Name/Value Buffer" temporary;
    begin
        OnGetStatementProvidersEvent(TempNameValueBuffer);
        EXIT(NOT TempNameValueBuffer.ISEMPTY);
    end;

    procedure LinkStatementProvider(var BankAccount : Record "Bank Account");
    var
        StatementProvider : Text;
    begin
        StatementProvider := SelectBankLinkingService;

        IF StatementProvider <> '' THEN
          OnLinkStatementProviderEvent(BankAccount,StatementProvider);
    end;

    procedure SimpleLinkStatementProvider(var OnlineBankAccLink : Record "Online Bank Acc. Link");
    var
        StatementProvider : Text;
    begin
        StatementProvider := SelectBankLinkingService;

        IF StatementProvider <> '' THEN
          OnSimpleLinkStatementProviderEvent(OnlineBankAccLink,StatementProvider);
    end;

    procedure UnlinkStatementProvider();
    var
        Handled : Boolean;
    begin
        OnUnlinkStatementProviderEvent(Rec,Handled);
    end;

    procedure UpdateBankAccountLinking();
    var
        StatementProvider : Text;
    begin
        StatementProvider := SelectBankLinkingService;

        IF StatementProvider <> '' THEN
          OnUpdateBankAccountLinkingEvent(Rec,StatementProvider);
    end;

    procedure GetUnlinkedBankAccounts(var TempUnlinkedBankAccount : Record "Bank Account" temporary);
    var
        BankAccount : Record "Bank Account";
    begin
        IF BankAccount.FINDSET THEN
          REPEAT
            IF NOT BankAccount.IsLinkedToBankStatementServiceProvider THEN BEGIN
              TempUnlinkedBankAccount := BankAccount;
              TempUnlinkedBankAccount.INSERT;
            END;
          UNTIL BankAccount.NEXT = 0;
    end;

    procedure GetLinkedBankAccounts(var TempUnlinkedBankAccount : Record "Bank Account" temporary);
    var
        BankAccount : Record "Bank Account";
    begin
        IF BankAccount.FINDSET THEN
          REPEAT
            IF BankAccount.IsLinkedToBankStatementServiceProvider THEN BEGIN
              TempUnlinkedBankAccount := BankAccount;
              TempUnlinkedBankAccount.INSERT;
            END;
          UNTIL BankAccount.NEXT = 0;
    end;

    local procedure SelectBankLinkingService() : Text;
    var
        TempNameValueBuffer : Record "Name/Value Buffer" temporary;
        OptionStr : Text;
        OptionNo : Integer;
    begin
        OnGetStatementProvidersEvent(TempNameValueBuffer);

        IF TempNameValueBuffer.ISEMPTY THEN
          EXIT(''); // Action should not be visible in this case so should not occur

        IF (TempNameValueBuffer.COUNT = 1) OR (NOT GUIALLOWED) THEN
          EXIT(TempNameValueBuffer.Name);

        TempNameValueBuffer.FINDSET;
        REPEAT
          OptionStr += STRSUBSTNO('%1,',TempNameValueBuffer.Value);
        UNTIL TempNameValueBuffer.NEXT = 0;
        OptionStr += CancelTxt;

        OptionNo := STRMENU(OptionStr);
        IF (OptionNo = 0) OR (OptionNo = TempNameValueBuffer.COUNT + 1) THEN
          EXIT;

        TempNameValueBuffer.SETRANGE(Value,SELECTSTR(OptionNo,OptionStr));
        TempNameValueBuffer.FINDFIRST;

        EXIT(TempNameValueBuffer.Name);
    end;

    procedure IsAutoLogonPossible() : Boolean;
    var
        AutoLogonPossible : Boolean;
    begin
        AutoLogonPossible := TRUE;
        OnCheckAutoLogonPossibleEvent(Rec,AutoLogonPossible);
        EXIT(AutoLogonPossible)
    end;

    local procedure ScheduleBankStatementDownload();
    var
        JobQueueEntry : Record "Job Queue Entry";
    begin
        IF NOT IsLinkedToBankStatementServiceProvider THEN
          ERROR(BankAccNotLinkedErr);
        IF NOT IsAutoLogonPossible THEN
          ERROR(AutoLogonNotPossibleErr);

        JobQueueEntry.ScheduleRecurrentJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit,
          CODEUNIT::"Automatic Import of Bank Stmt.",RECORDID);
        JobQueueEntry."Timeout (sec.)" := 1800;
        JobQueueEntry.Description :=
          COPYSTR(STRSUBSTNO(BankStmtScheduledDownloadDescTxt,Name),1,MAXSTRLEN(JobQueueEntry.Description));
        JobQueueEntry."Notify On Success" := FALSE;
        JobQueueEntry."No. of Minutes between Runs" := 121;
        JobQueueEntry.MODIFY;
        IF CONFIRM(JobQEntriesCreatedQst) THEN
          ShowBankStatementDownloadJobQueueEntry;
    end;

    local procedure UnscheduleBankStatementDownload();
    var
        JobQueueEntry : Record "Job Queue Entry";
    begin
        SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
        IF NOT JobQueueEntry.ISEMPTY THEN
          JobQueueEntry.DELETEALL;
    end;

    procedure CreateNewAccount(OnlineBankAccLink : Record "Online Bank Acc. Link");
    begin
        INIT;
        VALIDATE("Bank Account No.",OnlineBankAccLink."Bank Account No.");
        VALIDATE(Name,OnlineBankAccLink.Name);
        VALIDATE("Currency Code",OnlineBankAccLink."Currency Code");
        VALIDATE(Contact,OnlineBankAccLink.Contact);
    end;

    local procedure ShowBankStatementDownloadJobQueueEntry();
    var
        JobQueueEntry : Record "Job Queue Entry";
    begin
        SetAutomaticImportJobQueueEntryFilters(JobQueueEntry);
        IF JobQueueEntry.FINDFIRST THEN
          PAGE.RUN(PAGE::"Job Queue Entry Card",JobQueueEntry);
    end;

    local procedure SetAutomaticImportJobQueueEntryFilters(var JobQueueEntry : Record "Job Queue Entry");
    begin
        JobQueueEntry.SETRANGE("Object Type to Run",JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SETRANGE("Object ID to Run",CODEUNIT::"Automatic Import of Bank Stmt.");
        JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
    end;

    procedure GetOnlineFeedStatementStatus(var OnlineFeedStatus : Option;var Linked : Boolean);
    begin
        Linked := FALSE;
        OnlineFeedStatus := OnlineFeedStatementStatus::"Not Linked";
        IF IsLinkedToBankStatementServiceProvider THEN BEGIN
          Linked := TRUE;
          OnlineFeedStatus := OnlineFeedStatementStatus::Linked;
          IF IsScheduledBankStatement THEN
            OnlineFeedStatus := OnlineFeedStatementStatus::"Linked and Auto. Bank Statement Enabled";
        END;
    end;

    local procedure IsScheduledBankStatement() : Boolean;
    var
        JobQueueEntry : Record "Job Queue Entry";
    begin
        JobQueueEntry.SETRANGE("Record ID to Process",RECORDID);
        EXIT(JobQueueEntry.FINDFIRST);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckLinkedToStatementProviderEvent(var BankAccount : Record "Bank Account";var IsLinked : Boolean);
    begin
        // The subscriber of this event should answer whether the bank account is linked to a bank statement provider service
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckAutoLogonPossibleEvent(var BankAccount : Record "Bank Account";var AutoLogonPossible : Boolean);
    begin
        // The subscriber of this event should answer whether the bank account can be logged on to without multi-factor authentication
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnlinkStatementProviderEvent(var BankAccount : Record "Bank Account";var Handled : Boolean);
    begin
        // The subscriber of this event should unlink the bank account from a bank statement provider service
    end;

    [IntegrationEvent(false, false)]
    procedure OnMarkAccountLinkedEvent(var OnlineBankAccLink : Record "Online Bank Acc. Link";var BankAccount : Record "Bank Account");
    begin
        // The subscriber of this event should Mark the account linked to a bank statement provider service
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSimpleLinkStatementProviderEvent(var OnlineBankAccLink : Record "Online Bank Acc. Link";var StatementProvider : Text);
    begin
        // The subscriber of this event should link the bank account to a bank statement provider service
    end;

    [IntegrationEvent(false, false)]
    local procedure OnLinkStatementProviderEvent(var BankAccount : Record "Bank Account";var StatementProvider : Text);
    begin
        // The subscriber of this event should link the bank account to a bank statement provider service
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnGetDataExchangeDefinitionEvent(var DataExchDefCodeResponse : Code[20];var Handled : Boolean);
    begin
        // This event should retrieve the data exchange definition format for processing the online feeds
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdateBankAccountLinkingEvent(var BankAccount : Record "Bank Account";var StatementProvider : Text);
    begin
        // This event should handle updating of the single or multiple bank accounts
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetStatementProvidersEvent(var TempNameValueBuffer : Record "Name/Value Buffer" temporary);
    begin
        // The subscriber of this event should insert a unique identifier (Name) and friendly name of the provider (Value)
    end;
}

