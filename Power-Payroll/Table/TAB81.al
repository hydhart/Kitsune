table 81 "Gen. Journal Line"
{
    // version NAVW110.00.00.16996,NAVAPAC10.00.00.16996

    CaptionML = ENU='Gen. Journal Line',
                ENA='Gen. Journal Line';
    Permissions = TableData "Data Exch. Field"=rimd;

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            CaptionML = ENU='Journal Template Name',
                        ENA='Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2;"Line No.";Integer)
        {
            CaptionML = ENU='Line No.',
                        ENA='Line No.';
        }
        field(3;"Account Type";Option)
        {
            CaptionML = ENU='Account Type',
                        ENA='Account Type';
            OptionCaptionML = ENU='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner',
                              ENA='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate();
            begin
                IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset",
                                       "Account Type"::"IC Partner"]) AND
                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset",
                                            "Bal. Account Type"::"IC Partner"])
                THEN
                  ERROR(
                    Text000,
                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));
                VALIDATE("Account No.",'');
                VALIDATE(Description,'');
                VALIDATE("IC Partner G/L Acc. No.",'');
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN BEGIN
                  VALIDATE("Gen. Posting Type","Gen. Posting Type"::" ");
                  VALIDATE("Gen. Bus. Posting Group",'');
                  VALIDATE("Gen. Prod. Posting Group",'');
                END ELSE
                  IF "Bal. Account Type" IN [
                                             "Bal. Account Type"::"G/L Account","Account Type"::"Bank Account","Bal. Account Type"::"Fixed Asset"]
                  THEN
                    VALIDATE("Payment Terms Code",'');
                UpdateSource;

                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                  "Depreciation Book Code" := '';
                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                END;
                IF xRec."Account Type" IN
                   [xRec."Account Type"::Customer,xRec."Account Type"::Vendor]
                THEN BEGIN
                  "Bill-to/Pay-to No." := '';
                  "Ship-to/Order Address Code" := '';
                  "Sell-to/Buy-from No." := '';
                  "VAT Registration No." := '';
                END;

                IF "Journal Template Name" <> '' THEN
                  IF "Account Type" = "Account Type"::"IC Partner" THEN BEGIN
                    GetTemplate;
                    IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                      FIELDERROR("Account Type");
                  END;
                IF "Account Type" <> "Account Type"::Customer THEN
                  VALIDATE("Credit Card No.",'');

                VALIDATE("Deferral Code",'');
            end;
        }
        field(4;"Account No.";Code[20])
        {
            CaptionML = ENU='Account No.',
                        ENA='Account No.';
            TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Account Type=CONST(Customer)) Customer ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";

            trigger OnValidate();
            begin
                IF "Account No." <> xRec."Account No." THEN BEGIN
                  ClearAppliedAutomatically;
                  VALIDATE("Job No.",'');
                END;

                "Customer/Vendor Bank" := '';
                "Bank Branch No." := '';
                "Bank Account No." := '';

                IF xRec."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] THEN
                  "IC Partner Code" := '';

                IF "Account No." = '' THEN BEGIN
                  CleanLine;
                  EXIT;
                END;

                CASE "Account Type" OF
                  "Account Type"::"G/L Account":
                    GetGLAccount;
                  "Account Type"::Customer:
                    GetCustomerAccount;
                  "Account Type"::Vendor:
                    GetVendorAccount;
                  "Account Type"::"Bank Account":
                    GetBankAccount;
                  "Account Type"::"Fixed Asset":
                    GetFAAccount;
                  "Account Type"::"IC Partner":
                    GetICPartnerAccount;
                END;

                VALIDATE("Currency Code");
                VALIDATE("VAT Prod. Posting Group");
                UpdateLineBalance;
                UpdateSource;
                CreateDim(
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::Job,"Job No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");

                VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
                ValidateApplyRequirements(Rec);
            end;
        }
        field(5;"Posting Date";Date)
        {
            CaptionML = ENU='Posting Date',
                        ENA='Posting Date';
            ClosingDates = true;

            trigger OnValidate();
            begin
                VALIDATE("Document Date","Posting Date");
                VALIDATE("Currency Code");

                IF ("Posting Date" <> xRec."Posting Date") AND (Amount <> 0) THEN
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);

                ValidateApplyRequirements(Rec);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;

                IF "Deferral Code" <> '' THEN
                  VALIDATE("Deferral Code");
            end;
        }
        field(6;"Document Type";Option)
        {
            CaptionML = ENU='Document Type',
                        ENA='Document Type';
            OptionCaptionML = ENU=' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund',
                              ENA=' ,Payment,Invoice,CR/Adj Note,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnValidate();
            var
                Cust : Record Customer;
                Vend : Record Vendor;
            begin
                VALIDATE("Payment Terms Code");
                IF "Account No." <> '' THEN
                  CASE "Account Type" OF
                    "Account Type"::Customer:
                      BEGIN
                        Cust.GET("Account No.");
                        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
                      END;
                    "Account Type"::Vendor:
                      BEGIN
                        Vend.GET("Account No.");
                        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
                      END;
                  END;
                IF "Bal. Account No." <> '' THEN
                  CASE "Bal. Account Type" OF
                    "Account Type"::Customer:
                      BEGIN
                        Cust.GET("Bal. Account No.");
                        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
                      END;
                    "Account Type"::Vendor:
                      BEGIN
                        Vend.GET("Bal. Account No.");
                        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
                      END;
                  END;
                UpdateSalesPurchLCY;
                ValidateApplyRequirements(Rec);
                IF NOT ("Document Type" IN ["Document Type"::Payment,"Document Type"::Refund]) THEN
                  VALIDATE("Credit Card No.",'');
            end;
        }
        field(7;"Document No.";Code[20])
        {
            CaptionML = ENU='Document No.',
                        ENA='Document No.';
        }
        field(8;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
        }
        field(10;"VAT %";Decimal)
        {
            CaptionML = ENU='VAT %',
                        ENA='GST %';
            DecimalPlaces = 0:5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                GetCurrency;
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "VAT Amount" :=
                        ROUND(Amount * "VAT %" / (100 + "VAT %"),Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "VAT Base Amount" :=
                        ROUND(Amount - "VAT Amount",Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    "VAT Amount" := Amount;
                  "VAT Calculation Type"::"Sales Tax":
                    IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                       "Use Tax"
                    THEN BEGIN
                      "VAT Amount" := 0;
                      "VAT %" := 0;
                    END ELSE BEGIN
                      "VAT Amount" :=
                        Amount -
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",
                          "Posting Date",Amount,Quantity,"Currency Factor");
                      IF Amount - "VAT Amount" <> 0 THEN
                        "VAT %" := ROUND(100 * "VAT Amount" / (Amount - "VAT Amount"),0.00001)
                      ELSE
                        "VAT %" := 0;
                      "VAT Amount" :=
                        ROUND("VAT Amount",Currency."Amount Rounding Precision");
                    END;
                END;
                "VAT Base Amount" := Amount - "VAT Amount";
                "VAT Difference" := 0;

                IF "Currency Code" = '' THEN
                  "VAT Amount (LCY)" := "VAT Amount"
                ELSE
                  "VAT Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "VAT Amount","Currency Factor"));
                "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

                UpdateSalesPurchLCY;

                IF "Deferral Code" <> '' THEN
                  VALIDATE("Deferral Code");
            end;
        }
        field(11;"Bal. Account No.";Code[20])
        {
            CaptionML = ENU='Bal. Account No.',
                        ENA='Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Bal. Account Type=CONST(Customer)) Customer ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";

            trigger OnValidate();
            begin
                VALIDATE("Job No.",'');

                IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
                                                "Bal. Account Type"::"IC Partner"]
                THEN
                  "IC Partner Code" := '';

                IF "Bal. Account No." = '' THEN BEGIN
                  UpdateLineBalance;
                  UpdateSource;
                  CreateDim(
                    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                    DimMgt.TypeToTableID1("Account Type"),"Account No.",
                    DATABASE::Job,"Job No.",
                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                    DATABASE::Campaign,"Campaign No.");
                  IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
                    "Recipient Bank Account" := '';
                  IF xRec."Bal. Account No." <> '' THEN BEGIN
                    ClearBalancePostingGroups;
                    "Bal. Tax Area Code" := '';
                    "Bal. Tax Liable" := FALSE;
                    "Bal. Tax Group Code" := '';
                  END;
                  EXIT;
                END;

                CASE "Bal. Account Type" OF
                  "Bal. Account Type"::"G/L Account":
                    GetGLBalAccount;
                  "Bal. Account Type"::Customer:
                    GetCustomerBalAccount;
                  "Bal. Account Type"::Vendor:
                    GetVendorBalAccount;
                  "Bal. Account Type"::"Bank Account":
                    GetBankBalAccount;
                  "Bal. Account Type"::"Fixed Asset":
                    GetFABalAccount;
                  "Bal. Account Type"::"IC Partner":
                    GetICPartnerBalAccount;
                END;

                VALIDATE("Currency Code");
                VALIDATE("Bal. VAT Prod. Posting Group");
                UpdateLineBalance;
                UpdateSource;
                CreateDim(
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DATABASE::Job,"Job No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");

                VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
                ValidateApplyRequirements(Rec);
            end;
        }
        field(12;"Currency Code";Code[10])
        {
            CaptionML = ENU='Currency Code',
                        ENA='Currency Code';
            TableRelation = Currency;

            trigger OnValidate();
            var
                BankAcc : Record "Bank Account";
            begin
                IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc.GET("Bal. Account No.") AND (BankAcc."Currency Code" <> '')THEN
                    BankAcc.TESTFIELD("Currency Code","Currency Code");
                END;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                  IF BankAcc.GET("Account No.") AND (BankAcc."Currency Code" <> '') THEN
                    BankAcc.TESTFIELD("Currency Code","Currency Code");
                END;
                IF ("Recurring Method" IN
                    ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]) AND
                   ("Currency Code" <> '')
                THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Currency Code"),FIELDCAPTION("Recurring Method"),"Recurring Method");

                IF "Currency Code" <> '' THEN BEGIN
                  GetCurrency;
                  ReadGLSetup;
                  IF ("Currency Code" <> xRec."Currency Code") OR
                     ("Posting Date" <> xRec."Posting Date") OR
                     (CurrFieldNo = FIELDNO("Currency Code")) OR
                     ("Currency Factor" = 0)
                  THEN
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Posting Date","Currency Code");
                  IF "Vendor Exchange Rate (ACY)" <> 0 THEN
                    "Currency Factor" := CurrExchRate.ExchangeRateFRS21("Posting Date","Currency Code",
                        GLSetup."Additional Reporting Currency","Vendor Exchange Rate (ACY)");
                END ELSE
                  "Currency Factor" := 0;
                VALIDATE("Currency Factor");

                IF NOT CustVendAccountNosModified THEN
                  IF ("Currency Code" <> xRec."Currency Code") AND (Amount <> 0) THEN
                    PaymentToleranceMgt.PmtTolGenJnl(Rec);
            end;
        }
        field(13;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Amount',
                        ENA='Amount';

            trigger OnValidate();
            begin
                GetCurrency;
                IF "Currency Code" = '' THEN
                  "Amount (LCY)" := Amount
                ELSE
                  "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        Amount,"Currency Factor"));

                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                IF (CurrFieldNo <> 0) AND
                   (CurrFieldNo <> FIELDNO("Applies-to Doc. No.")) AND
                   ((("Account Type" = "Account Type"::Customer) AND
                     ("Account No." <> '') AND (Amount > 0) AND
                     (CurrFieldNo <> FIELDNO("Bal. Account No."))) OR
                    (("Bal. Account Type" = "Bal. Account Type"::Customer) AND
                     ("Bal. Account No." <> '') AND (Amount < 0) AND
                     (CurrFieldNo <> FIELDNO("Account No."))))
                THEN
                  CustCheckCreditLimit.GenJnlLineCheck(Rec);

                VALIDATE("VAT %");
                VALIDATE("Bal. VAT %");
                UpdateLineBalance;
                IF "Deferral Code" <> '' THEN
                  VALIDATE("Deferral Code");

                IF (Amount <> xRec.Amount) AND (CurrFieldNo <> 0) THEN BEGIN
                  IF ("Applies-to Doc. No." <> '') OR ("Applies-to ID" <> '') THEN
                    SetApplyToAmount;
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                END;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(14;"Debit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Debit Amount',
                        ENA='Debit Amount';

            trigger OnValidate();
            begin
                GetCurrency;
                "Debit Amount" := ROUND("Debit Amount",Currency."Amount Rounding Precision");
                Correction := "Debit Amount" < 0;
                Amount := "Debit Amount";
                VALIDATE(Amount);
            end;
        }
        field(15;"Credit Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Credit Amount',
                        ENA='Credit Amount';

            trigger OnValidate();
            begin
                GetCurrency;
                "Credit Amount" := ROUND("Credit Amount",Currency."Amount Rounding Precision");
                Correction := "Credit Amount" < 0;
                Amount := -"Credit Amount";
                VALIDATE(Amount);
            end;
        }
        field(16;"Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Amount (LCY)',
                        ENA='Amount (LCY)';

            trigger OnValidate();
            begin
                IF "Currency Code" = '' THEN BEGIN
                  Amount := "Amount (LCY)";
                  VALIDATE(Amount);
                END ELSE BEGIN
                  IF CheckFixedCurrency THEN BEGIN
                    GetCurrency;
                    Amount := ROUND(
                        CurrExchRate.ExchangeAmtLCYToFCY(
                          "Posting Date","Currency Code",
                          "Amount (LCY)","Currency Factor"),
                        Currency."Amount Rounding Precision")
                  END ELSE BEGIN
                    TESTFIELD("Amount (LCY)");
                    TESTFIELD(Amount);
                    "Currency Factor" := Amount / "Amount (LCY)";
                  END;

                  VALIDATE("VAT %");
                  VALIDATE("Bal. VAT %");
                  UpdateLineBalance;
                END;
            end;
        }
        field(17;"Balance (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Balance (LCY)',
                        ENA='Balance (LCY)';
            Editable = false;
        }
        field(18;"Currency Factor";Decimal)
        {
            CaptionML = ENU='Currency Factor',
                        ENA='Currency Factor';
            DecimalPlaces = 0:15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                IF ("Currency Code" = '') AND ("Currency Factor" <> 0) THEN
                  FIELDERROR("Currency Factor",STRSUBSTNO(Text002,FIELDCAPTION("Currency Code")));
                VALIDATE(Amount);
            end;
        }
        field(19;"Sales/Purch. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Sales/Purch. (LCY)',
                        ENA='Sales/Purch. (LCY)';
        }
        field(20;"Profit (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Profit (LCY)',
                        ENA='Profit (LCY)';
        }
        field(21;"Inv. Discount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Discount (LCY)',
                        ENA='Inv. Discount (LCY)';
        }
        field(22;"Bill-to/Pay-to No.";Code[20])
        {
            CaptionML = ENU='Bill-to/Pay-to No.',
                        ENA='Bill-to/Pay-to No.';
            Editable = false;
            TableRelation = IF (Account Type=CONST(Customer)) Customer ELSE IF (Bal. Account Type=CONST(Customer)) Customer ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;

            trigger OnValidate();
            begin
                IF "Bill-to/Pay-to No." <> xRec."Bill-to/Pay-to No." THEN
                  "Ship-to/Order Address Code" := '';
                ReadGLSetup;
                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN
                  UpdateCountryCodeAndVATRegNo("Bill-to/Pay-to No.");
            end;
        }
        field(23;"Posting Group";Code[10])
        {
            CaptionML = ENU='Posting Group',
                        ENA='Posting Group';
            Editable = false;
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Posting Group" ELSE IF (Account Type=CONST(Vendor)) "Vendor Posting Group" ELSE IF (Account Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        field(24;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU='Shortcut Dimension 1 Code',
                        ENA='Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(25;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU='Shortcut Dimension 2 Code',
                        ENA='Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(26;"Salespers./Purch. Code";Code[10])
        {
            CaptionML = ENU='Salespers./Purch. Code',
                        ENA='Salespers./Purch. Code';
            TableRelation = Salesperson/Purchaser;

            trigger OnValidate();
            begin
                CreateDim(
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::Job,"Job No.",
                  DATABASE::Campaign,"Campaign No.");
            end;
        }
        field(29;"Source Code";Code[10])
        {
            CaptionML = ENU='Source Code',
                        ENA='Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(30;"System-Created Entry";Boolean)
        {
            CaptionML = ENU='System-Created Entry',
                        ENA='System-Created Entry';
            Editable = false;
        }
        field(34;"On Hold";Code[3])
        {
            CaptionML = ENU='On Hold',
                        ENA='On Hold';
        }
        field(35;"Applies-to Doc. Type";Option)
        {
            CaptionML = ENU='Applies-to Doc. Type',
                        ENA='Applies-to Doc. Type';
            OptionCaptionML = ENU=' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund',
                              ENA=' ,Payment,Invoice,CR/Adj Note,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;

            trigger OnValidate();
            begin
                IF "Applies-to Doc. Type" <> xRec."Applies-to Doc. Type" THEN
                  VALIDATE("Applies-to Doc. No.",'');
            end;
        }
        field(36;"Applies-to Doc. No.";Code[20])
        {
            CaptionML = ENU='Applies-to Doc. No.',
                        ENA='Applies-to Doc. No.';

            trigger OnLookup();
            var
                PaymentToleranceMgt : Codeunit "Payment Tolerance Management";
                AccType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo : Code[20];
            begin
                xRec.Amount := Amount;
                xRec."Currency Code" := "Currency Code";
                xRec."Posting Date" := "Posting Date";

                GetAccTypeAndNo(Rec,AccType,AccNo);
                CLEAR(CustLedgEntry);
                CLEAR(VendLedgEntry);

                CASE AccType OF
                  AccType::Customer:
                    LookUpAppliesToDocCust(AccNo);
                  AccType::Vendor:
                    LookUpAppliesToDocVend(AccNo);
                END;
                SetJournalLineFieldsFromApplication;

                IF xRec.Amount <> 0 THEN
                  IF NOT PaymentToleranceMgt.PmtTolGenJnl(Rec) THEN
                    EXIT;
            end;

            trigger OnValidate();
            var
                CustLedgEntry : Record "Cust. Ledger Entry";
                VendLedgEntry : Record "Vendor Ledger Entry";
                TempGenJnlLine : Record "Gen. Journal Line" temporary;
            begin
                IF "Applies-to Doc. No." <> xRec."Applies-to Doc. No." THEN
                  ClearCustVendApplnEntry;

                IF ("Applies-to Doc. No." = '') AND (xRec."Applies-to Doc. No." <> '') THEN BEGIN
                  PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");

                  TempGenJnlLine := Rec;
                  IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
                     (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor)
                  THEN
                    CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);

                  IF TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Customer THEN BEGIN
                    CustLedgEntry.SETCURRENTKEY("Document No.");
                    CustLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                    IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                      CustLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                    CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
                    CustLedgEntry.SETRANGE(Open,TRUE);
                    IF CustLedgEntry.FINDFIRST THEN BEGIN
                      IF CustLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                        CustLedgEntry."Amount to Apply" := 0;
                        CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                      END;
                      "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                      "Applies-to Ext. Doc. No." := '';
                    END;
                  END ELSE
                    IF TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Vendor THEN BEGIN
                      VendLedgEntry.SETCURRENTKEY("Document No.");
                      VendLedgEntry.SETRANGE("Document No.",xRec."Applies-to Doc. No.");
                      IF NOT (xRec."Applies-to Doc. Type" = "Document Type"::" ") THEN
                        VendLedgEntry.SETRANGE("Document Type",xRec."Applies-to Doc. Type");
                      VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                      VendLedgEntry.SETRANGE(Open,TRUE);
                      IF VendLedgEntry.FINDFIRST THEN BEGIN
                        IF VendLedgEntry."Amount to Apply" <> 0 THEN  BEGIN
                          VendLedgEntry."Amount to Apply" := 0;
                          CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                        END;
                        "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                      END;
                      "Applies-to Ext. Doc. No." := '';
                    END;
                END;

                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (Amount <> 0) THEN BEGIN
                  IF xRec."Applies-to Doc. No." <> '' THEN
                    PaymentToleranceMgt.DelPmtTolApllnDocNo(Rec,xRec."Applies-to Doc. No.");
                  SetApplyToAmount;
                  PaymentToleranceMgt.PmtTolGenJnl(Rec);
                  xRec.ClearAppliedGenJnlLine;
                END;

                CASE "Account Type" OF
                  "Account Type"::Customer:
                    GetCustLedgerEntry;
                  "Account Type"::Vendor:
                    GetVendLedgerEntry;
                END;

                ValidateApplyRequirements(Rec);
                SetJournalLineFieldsFromApplication;
            end;
        }
        field(38;"Due Date";Date)
        {
            CaptionML = ENU='Due Date',
                        ENA='Due Date';
        }
        field(39;"Pmt. Discount Date";Date)
        {
            CaptionML = ENU='Pmt. Discount Date',
                        ENA='Pmt. Discount Date';
        }
        field(40;"Payment Discount %";Decimal)
        {
            CaptionML = ENU='Payment Discount %',
                        ENA='Payment Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(42;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            TableRelation = Job;

            trigger OnValidate();
            begin
                IF "Job No." = xRec."Job No." THEN
                  EXIT;

                SourceCodeSetup.GET;
                IF "Source Code" <> SourceCodeSetup."Job G/L WIP" THEN
                  VALIDATE("Job Task No.",'');
                IF "Job No." = '' THEN BEGIN
                  CreateDim(
                    DATABASE::Job,"Job No.",
                    DimMgt.TypeToTableID1("Account Type"),"Account No.",
                    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                    DATABASE::Campaign,"Campaign No.");
                  EXIT;
                END;

                TESTFIELD("Account Type","Account Type"::"G/L Account");

                IF "Bal. Account No." <> '' THEN
                  IF NOT ("Bal. Account Type" IN ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"]) THEN
                    ERROR(Text016,FIELDCAPTION("Bal. Account Type"));

                Job.GET("Job No.");
                Job.TestBlocked;
                "Job Currency Code" := Job."Currency Code";

                CreateDim(
                  DATABASE::Job,"Job No.",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
                  DATABASE::Campaign,"Campaign No.");
            end;
        }
        field(43;Quantity;Decimal)
        {
            CaptionML = ENU='Quantity',
                        ENA='Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                VALIDATE(Amount);
            end;
        }
        field(44;"VAT Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='VAT Amount',
                        ENA='GST Amount';

            trigger OnValidate();
            begin
                GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                GenJnlBatch.TESTFIELD("Allow VAT Difference",TRUE);
                IF NOT ("VAT Calculation Type" IN
                        ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"])
                THEN
                  ERROR(
                    Text010,FIELDCAPTION("VAT Calculation Type"),
                    "VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT");
                IF "VAT Amount" <> 0 THEN BEGIN
                  TESTFIELD("VAT %");
                  TESTFIELD(Amount);
                END;

                GetCurrency;
                "VAT Amount" := ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);

                IF "VAT Amount" * Amount < 0 THEN
                  IF "VAT Amount" > 0 THEN
                    ERROR(Text011,FIELDCAPTION("VAT Amount"))
                  ELSE
                    ERROR(Text012,FIELDCAPTION("VAT Amount"));

                "VAT Base Amount" := Amount - "VAT Amount";

                "VAT Difference" :=
                  "VAT Amount" -
                  ROUND(
                    Amount * "VAT %" / (100 + "VAT %"),
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                IF ABS("VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
                  ERROR(Text013,FIELDCAPTION("VAT Difference"),Currency."Max. VAT Difference Allowed");

                IF "Currency Code" = '' THEN
                  "VAT Amount (LCY)" := "VAT Amount"
                ELSE
                  "VAT Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "VAT Amount","Currency Factor"));
                "VAT Base Amount (LCY)" := "Amount (LCY)" - "VAT Amount (LCY)";

                UpdateSalesPurchLCY;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;

                IF "Deferral Code" <> '' THEN
                  VALIDATE("Deferral Code");
            end;
        }
        field(45;"VAT Posting";Option)
        {
            CaptionML = ENU='VAT Posting',
                        ENA='GST Posting';
            Editable = false;
            OptionCaptionML = ENU='Automatic VAT Entry,Manual VAT Entry',
                              ENA='Automatic GST Entry,Manual GST Entry';
            OptionMembers = "Automatic VAT Entry","Manual VAT Entry";
        }
        field(47;"Payment Terms Code";Code[10])
        {
            CaptionML = ENU='Payment Terms Code',
                        ENA='Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate();
            begin
                "Due Date" := 0D;
                "Pmt. Discount Date" := 0D;
                "Payment Discount %" := 0;
                IF ("Account Type" <> "Account Type"::"G/L Account") OR
                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account")
                THEN
                  CASE "Document Type" OF
                    "Document Type"::Invoice:
                      IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                        PaymentTerms.GET("Payment Terms Code");
                        "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                        "Pmt. Discount Date" := CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                        "Payment Discount %" := PaymentTerms."Discount %";
                      END;
                    "Document Type"::"Credit Memo":
                      IF ("Payment Terms Code" <> '') AND ("Document Date" <> 0D) THEN BEGIN
                        PaymentTerms.GET("Payment Terms Code");
                        IF PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" THEN BEGIN
                          "Due Date" := CALCDATE(PaymentTerms."Due Date Calculation","Document Date");
                          "Pmt. Discount Date" :=
                            CALCDATE(PaymentTerms."Discount Date Calculation","Document Date");
                          "Payment Discount %" := PaymentTerms."Discount %";
                        END ELSE
                          "Due Date" := "Document Date";
                      END;
                    ELSE
                      "Due Date" := "Document Date";
                  END;
            end;
        }
        field(48;"Applies-to ID";Code[50])
        {
            CaptionML = ENU='Applies-to ID',
                        ENA='Applies-to ID';

            trigger OnValidate();
            begin
                IF ("Applies-to ID" <> xRec."Applies-to ID") AND (xRec."Applies-to ID" <> '') THEN
                  ClearCustVendApplnEntry;
                SetJournalLineFieldsFromApplication;
            end;
        }
        field(50;"Business Unit Code";Code[10])
        {
            CaptionML = ENU='Business Unit Code',
                        ENA='Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(51;"Journal Batch Name";Code[10])
        {
            CaptionML = ENU='Journal Batch Name',
                        ENA='Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE (Journal Template Name=FIELD(Journal Template Name));
        }
        field(52;"Reason Code";Code[10])
        {
            CaptionML = ENU='Reason Code',
                        ENA='Reason Code';
            TableRelation = "Reason Code";
        }
        field(53;"Recurring Method";Option)
        {
            BlankZero = true;
            CaptionML = ENU='Recurring Method',
                        ENA='Recurring Method';
            OptionCaptionML = ENU=' ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance',
                              ENA=' ,F  Fixed,V  Variable,B  Balance,RF Reversing Fixed,RV Reversing Variable,RB Reversing Balance';
            OptionMembers = " ","F  Fixed","V  Variable","B  Balance","RF Reversing Fixed","RV Reversing Variable","RB Reversing Balance";

            trigger OnValidate();
            begin
                IF "Recurring Method" IN
                   ["Recurring Method"::"B  Balance","Recurring Method"::"RB Reversing Balance"]
                THEN
                  TESTFIELD("Currency Code",'');
            end;
        }
        field(54;"Expiration Date";Date)
        {
            CaptionML = ENU='Expiration Date',
                        ENA='Expiration Date';
        }
        field(55;"Recurring Frequency";DateFormula)
        {
            CaptionML = ENU='Recurring Frequency',
                        ENA='Recurring Frequency';
        }
        field(56;"Allocated Amt. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Gen. Jnl. Allocation".Amount WHERE (Journal Template Name=FIELD(Journal Template Name), Journal Batch Name=FIELD(Journal Batch Name), Journal Line No.=FIELD(Line No.)));
            CaptionML = ENU='Allocated Amt. (LCY)',
                        ENA='Allocated Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57;"Gen. Posting Type";Option)
        {
            CaptionML = ENU='Gen. Posting Type',
                        ENA='Gen. Posting Type';
            OptionCaptionML = ENU=' ,Purchase,Sale,Settlement',
                              ENA=' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                  TESTFIELD("Gen. Posting Type","Gen. Posting Type"::" ");
                IF ("Gen. Posting Type" = "Gen. Posting Type"::Settlement) AND (CurrFieldNo <> 0) THEN
                  ERROR(Text006,"Gen. Posting Type");
                CheckVATInAlloc;
                IF "Gen. Posting Type" > 0 THEN
                  VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(58;"Gen. Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Bus. Posting Group',
                        ENA='Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                  TESTFIELD("Gen. Bus. Posting Group",'');
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(59;"Gen. Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Prod. Posting Group',
                        ENA='Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                  TESTFIELD("Gen. Prod. Posting Group",'');
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(60;"VAT Calculation Type";Option)
        {
            CaptionML = ENU='VAT Calculation Type',
                        ENA='GST Calculation Type';
            Editable = false;
            OptionCaptionML = ENU='Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax',
                              ENA='Normal GST,Reverse Charge GST,Full GST,US Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(61;"EU 3-Party Trade";Boolean)
        {
            CaptionML = ENU='EU 3-Party Trade',
                        ENA='EU 3-Party Trade';
            Editable = false;
        }
        field(62;"Allow Application";Boolean)
        {
            CaptionML = ENU='Allow Application',
                        ENA='Allow Application';
            InitValue = true;
        }
        field(63;"Bal. Account Type";Option)
        {
            CaptionML = ENU='Bal. Account Type',
                        ENA='Bal. Account Type';
            OptionCaptionML = ENU='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner',
                              ENA='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate();
            begin
                IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset",
                                       "Account Type"::"IC Partner"]) AND
                   ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset",
                                            "Bal. Account Type"::"IC Partner"])
                THEN
                  ERROR(
                    Text000,
                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));
                VALIDATE("Bal. Account No.",'');
                VALIDATE("IC Partner G/L Acc. No.",'');
                IF "Bal. Account Type" IN
                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                THEN BEGIN
                  VALIDATE("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::" ");
                  VALIDATE("Bal. Gen. Bus. Posting Group",'');
                  VALIDATE("Bal. Gen. Prod. Posting Group",'');
                END ELSE
                  IF "Account Type" IN [
                                        "Bal. Account Type"::"G/L Account","Account Type"::"Bank Account","Account Type"::"Fixed Asset"]
                  THEN
                    VALIDATE("Payment Terms Code",'');
                UpdateSource;
                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                  "Depreciation Book Code" := '';
                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                END;
                IF xRec."Bal. Account Type" IN
                   [xRec."Bal. Account Type"::Customer,xRec."Bal. Account Type"::Vendor]
                THEN BEGIN
                  "Bill-to/Pay-to No." := '';
                  "Ship-to/Order Address Code" := '';
                  "Sell-to/Buy-from No." := '';
                  "VAT Registration No." := '';
                END;
                IF ("Account Type" IN [
                                       "Account Type"::"G/L Account","Account Type"::"Bank Account","Account Type"::"Fixed Asset"]) AND
                   ("Bal. Account Type" IN [
                                            "Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account","Bal. Account Type"::"Fixed Asset"])
                THEN
                  VALIDATE("Payment Terms Code",'');

                IF "Bal. Account Type" = "Bal. Account Type"::"IC Partner" THEN BEGIN
                  GetTemplate;
                  IF GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany THEN
                    FIELDERROR("Bal. Account Type");
                END;
                IF "Bal. Account Type" <> "Bal. Account Type"::"Bank Account" THEN
                  VALIDATE("Credit Card No.",'');
            end;
        }
        field(64;"Bal. Gen. Posting Type";Option)
        {
            CaptionML = ENU='Bal. Gen. Posting Type',
                        ENA='Bal. Gen. Posting Type';
            OptionCaptionML = ENU=' ,Purchase,Sale,Settlement',
                              ENA=' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;

            trigger OnValidate();
            begin
                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                  TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::" ");
                IF ("Bal. Gen. Posting Type" = "Gen. Posting Type"::Settlement) AND (CurrFieldNo <> 0) THEN
                  ERROR(Text006,"Bal. Gen. Posting Type");
                IF "Bal. Gen. Posting Type" > 0 THEN
                  VALIDATE("Bal. VAT Prod. Posting Group");

                IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                  "Depreciation Book Code" := '';
                  VALIDATE("FA Posting Type","FA Posting Type"::" ");
                END;
            end;
        }
        field(65;"Bal. Gen. Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Bal. Gen. Bus. Posting Group',
                        ENA='Bal. Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate();
            begin
                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                  TESTFIELD("Bal. Gen. Bus. Posting Group",'');
                IF xRec."Bal. Gen. Bus. Posting Group" <> "Bal. Gen. Bus. Posting Group" THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Bal. Gen. Bus. Posting Group") THEN
                    VALIDATE("Bal. VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(66;"Bal. Gen. Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Bal. Gen. Prod. Posting Group',
                        ENA='Bal. Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate();
            begin
                IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"] THEN
                  TESTFIELD("Bal. Gen. Prod. Posting Group",'');
                IF xRec."Bal. Gen. Prod. Posting Group" <> "Bal. Gen. Prod. Posting Group" THEN
                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Bal. Gen. Prod. Posting Group") THEN
                    VALIDATE("Bal. VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(67;"Bal. VAT Calculation Type";Option)
        {
            CaptionML = ENU='Bal. VAT Calculation Type',
                        ENA='Bal. GST Calculation Type';
            Editable = false;
            OptionCaptionML = ENU='Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax',
                              ENA='Normal GST,Reverse Charge GST,Full GST,US Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(68;"Bal. VAT %";Decimal)
        {
            CaptionML = ENU='Bal. VAT %',
                        ENA='Bal. GST %';
            DecimalPlaces = 0:5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                GetCurrency;
                CASE "Bal. VAT Calculation Type" OF
                  "Bal. VAT Calculation Type"::"Normal VAT",
                  "Bal. VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "Bal. VAT Amount" :=
                        ROUND(-Amount * "Bal. VAT %" / (100 + "Bal. VAT %"),Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Bal. VAT Base Amount" :=
                        ROUND(-Amount - "Bal. VAT Amount",Currency."Amount Rounding Precision");
                    END;
                  "Bal. VAT Calculation Type"::"Full VAT":
                    "Bal. VAT Amount" := -Amount;
                  "Bal. VAT Calculation Type"::"Sales Tax":
                    IF ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) AND
                       "Bal. Use Tax"
                    THEN BEGIN
                      "Bal. VAT Amount" := 0;
                      "Bal. VAT %" := 0;
                    END ELSE BEGIN
                      "Bal. VAT Amount" :=
                        -(Amount -
                          SalesTaxCalculate.ReverseCalculateTax(
                            "Bal. Tax Area Code","Bal. Tax Group Code","Bal. Tax Liable",
                            "Posting Date",Amount,Quantity,"Currency Factor"));
                      IF Amount + "Bal. VAT Amount" <> 0 THEN
                        "Bal. VAT %" := ROUND(100 * -"Bal. VAT Amount" / (Amount + "Bal. VAT Amount"),0.00001)
                      ELSE
                        "Bal. VAT %" := 0;
                      "Bal. VAT Amount" :=
                        ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision");
                    END;
                END;
                "Bal. VAT Base Amount" := -(Amount + "Bal. VAT Amount");
                "Bal. VAT Difference" := 0;

                IF "Currency Code" = '' THEN
                  "Bal. VAT Amount (LCY)" := "Bal. VAT Amount"
                ELSE
                  "Bal. VAT Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "Bal. VAT Amount","Currency Factor"));
                "Bal. VAT Base Amount (LCY)" := -("Amount (LCY)" + "Bal. VAT Amount (LCY)");

                UpdateSalesPurchLCY;
            end;
        }
        field(69;"Bal. VAT Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Bal. VAT Amount',
                        ENA='Bal. GST Amount';

            trigger OnValidate();
            begin
                GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
                GenJnlBatch.TESTFIELD("Allow VAT Difference",TRUE);
                IF NOT ("Bal. VAT Calculation Type" IN
                        ["Bal. VAT Calculation Type"::"Normal VAT","Bal. VAT Calculation Type"::"Reverse Charge VAT"])
                THEN
                  ERROR(
                    Text010,FIELDCAPTION("Bal. VAT Calculation Type"),
                    "Bal. VAT Calculation Type"::"Normal VAT","Bal. VAT Calculation Type"::"Reverse Charge VAT");
                IF "Bal. VAT Amount" <> 0 THEN BEGIN
                  TESTFIELD("Bal. VAT %");
                  TESTFIELD(Amount);
                END;

                GetCurrency;
                "Bal. VAT Amount" :=
                  ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);

                IF "Bal. VAT Amount" * Amount > 0 THEN
                  IF "Bal. VAT Amount" > 0 THEN
                    ERROR(Text011,FIELDCAPTION("Bal. VAT Amount"))
                  ELSE
                    ERROR(Text012,FIELDCAPTION("Bal. VAT Amount"));

                "Bal. VAT Base Amount" := -(Amount + "Bal. VAT Amount");

                "Bal. VAT Difference" :=
                  "Bal. VAT Amount" -
                  ROUND(
                    -Amount * "Bal. VAT %" / (100 + "Bal. VAT %"),
                    Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                IF ABS("Bal. VAT Difference") > Currency."Max. VAT Difference Allowed" THEN
                  ERROR(
                    Text013,FIELDCAPTION("Bal. VAT Difference"),Currency."Max. VAT Difference Allowed");

                IF "Currency Code" = '' THEN
                  "Bal. VAT Amount (LCY)" := "Bal. VAT Amount"
                ELSE
                  "Bal. VAT Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "Bal. VAT Amount","Currency Factor"));
                "Bal. VAT Base Amount (LCY)" := -("Amount (LCY)" + "Bal. VAT Amount (LCY)");

                UpdateSalesPurchLCY;
            end;
        }
        field(70;"Bank Payment Type";Option)
        {
            AccessByPermission = TableData "Bank Account"=R;
            CaptionML = ENU='Bank Payment Type',
                        ENA='Bank Payment Type';
            OptionCaptionML = ENU=' ,Computer Check,Manual Check',
                              ENA=' ,Computer Cheque,Manual Cheque';
            OptionMembers = " ","Computer Check","Manual Check";

            trigger OnValidate();
            begin
                IF ("Bank Payment Type" <> "Bank Payment Type"::" ") AND
                   ("Account Type" <> "Account Type"::"Bank Account") AND
                   ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account")
                THEN
                  ERROR(
                    Text007,
                    FIELDCAPTION("Account Type"),FIELDCAPTION("Bal. Account Type"));
                IF ("Account Type" = "Account Type"::"Fixed Asset") AND
                   ("Bank Payment Type" <> "Bank Payment Type"::" ")
                THEN
                  FIELDERROR("Account Type");
            end;
        }
        field(71;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='VAT Base Amount',
                        ENA='GST Base Amount';

            trigger OnValidate();
            begin
                GetCurrency;
                "VAT Base Amount" := ROUND("VAT Base Amount",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    Amount :=
                      ROUND(
                        "VAT Base Amount" * (1 + "VAT %" / 100),
                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "VAT Calculation Type"::"Full VAT":
                    IF "VAT Base Amount" <> 0 THEN
                      FIELDERROR(
                        "VAT Base Amount",
                        STRSUBSTNO(
                          Text008,FIELDCAPTION("VAT Calculation Type"),
                          "VAT Calculation Type"));
                  "VAT Calculation Type"::"Sales Tax":
                    IF ("Gen. Posting Type" = "Gen. Posting Type"::Purchase) AND
                       "Use Tax"
                    THEN BEGIN
                      "VAT Amount" := 0;
                      "VAT %" := 0;
                      Amount := "VAT Base Amount" + "VAT Amount";
                    END ELSE BEGIN
                      "VAT Amount" :=
                        SalesTaxCalculate.CalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable","Posting Date",
                          "VAT Base Amount",Quantity,"Currency Factor");
                      IF "VAT Base Amount" <> 0 THEN
                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base Amount",0.00001)
                      ELSE
                        "VAT %" := 0;
                      "VAT Amount" :=
                        ROUND("VAT Amount",Currency."Amount Rounding Precision");
                      Amount := "VAT Base Amount" + "VAT Amount";
                    END;
                END;
                VALIDATE(Amount);
            end;
        }
        field(72;"Bal. VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Bal. VAT Base Amount',
                        ENA='Bal. GST Base Amount';

            trigger OnValidate();
            begin
                GetCurrency;
                "Bal. VAT Base Amount" := ROUND("Bal. VAT Base Amount",Currency."Amount Rounding Precision");
                CASE "Bal. VAT Calculation Type" OF
                  "Bal. VAT Calculation Type"::"Normal VAT",
                  "Bal. VAT Calculation Type"::"Reverse Charge VAT":
                    Amount :=
                      ROUND(
                        -"Bal. VAT Base Amount" * (1 + "Bal. VAT %" / 100),
                        Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                  "Bal. VAT Calculation Type"::"Full VAT":
                    IF "Bal. VAT Base Amount" <> 0 THEN
                      FIELDERROR(
                        "Bal. VAT Base Amount",
                        STRSUBSTNO(
                          Text008,FIELDCAPTION("Bal. VAT Calculation Type"),
                          "Bal. VAT Calculation Type"));
                  "Bal. VAT Calculation Type"::"Sales Tax":
                    IF ("Bal. Gen. Posting Type" = "Bal. Gen. Posting Type"::Purchase) AND
                       "Bal. Use Tax"
                    THEN BEGIN
                      "Bal. VAT Amount" := 0;
                      "Bal. VAT %" := 0;
                      Amount := -"Bal. VAT Base Amount" - "Bal. VAT Amount";
                    END ELSE BEGIN
                      "Bal. VAT Amount" :=
                        SalesTaxCalculate.CalculateTax(
                          "Bal. Tax Area Code","Bal. Tax Group Code","Bal. Tax Liable",
                          "Posting Date","Bal. VAT Base Amount",Quantity,"Currency Factor");
                      IF "Bal. VAT Base Amount" <> 0 THEN
                        "Bal. VAT %" := ROUND(100 * "Bal. VAT Amount" / "Bal. VAT Base Amount",0.00001)
                      ELSE
                        "Bal. VAT %" := 0;
                      "Bal. VAT Amount" :=
                        ROUND("Bal. VAT Amount",Currency."Amount Rounding Precision");
                      Amount := -"Bal. VAT Base Amount" - "Bal. VAT Amount";
                    END;
                END;
                VALIDATE(Amount);
            end;
        }
        field(73;Correction;Boolean)
        {
            CaptionML = ENU='Correction',
                        ENA='Correction';

            trigger OnValidate();
            begin
                VALIDATE(Amount);
            end;
        }
        field(75;"Check Printed";Boolean)
        {
            AccessByPermission = TableData "Check Ledger Entry"=R;
            CaptionML = ENU='Check Printed',
                        ENA='Cheque Printed';
            Editable = false;
        }
        field(76;"Document Date";Date)
        {
            CaptionML = ENU='Document Date',
                        ENA='Document Date';
            ClosingDates = true;

            trigger OnValidate();
            begin
                VALIDATE("Payment Terms Code");
            end;
        }
        field(77;"External Document No.";Code[35])
        {
            CaptionML = ENU='External Document No.',
                        ENA='External Document No.';
        }
        field(78;"Source Type";Option)
        {
            CaptionML = ENU='Source Type',
                        ENA='Source Type';
            OptionCaptionML = ENU=' ,Customer,Vendor,Bank Account,Fixed Asset',
                              ENA=' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";

            trigger OnValidate();
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '') OR
                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '')
                THEN
                  UpdateSource
                ELSE
                  "Source No." := '';
            end;
        }
        field(79;"Source No.";Code[20])
        {
            CaptionML = ENU='Source No.',
                        ENA='Source No.';
            TableRelation = IF (Source Type=CONST(Customer)) Customer ELSE IF (Source Type=CONST(Vendor)) Vendor ELSE IF (Source Type=CONST(Bank Account)) "Bank Account" ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";

            trigger OnValidate();
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '') OR
                   ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '')
                THEN
                  UpdateSource;
            end;
        }
        field(80;"Posting No. Series";Code[10])
        {
            CaptionML = ENU='Posting No. Series',
                        ENA='Posting No. Series';
            TableRelation = "No. Series";
        }
        field(82;"Tax Area Code";Code[20])
        {
            CaptionML = ENU='Tax Area Code',
                        ENA='US Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate();
            begin
                VALIDATE("VAT %");
            end;
        }
        field(83;"Tax Liable";Boolean)
        {
            CaptionML = ENU='Tax Liable',
                        ENA='US Tax Liable';

            trigger OnValidate();
            begin
                VALIDATE("VAT %");
            end;
        }
        field(84;"Tax Group Code";Code[10])
        {
            CaptionML = ENU='Tax Group Code',
                        ENA='US Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate();
            begin
                VALIDATE("VAT %");
            end;
        }
        field(85;"Use Tax";Boolean)
        {
            CaptionML = ENU='Use Tax',
                        ENA='Use US Tax';

            trigger OnValidate();
            begin
                TESTFIELD("Gen. Posting Type","Gen. Posting Type"::Purchase);
                VALIDATE("VAT %");
            end;
        }
        field(86;"Bal. Tax Area Code";Code[20])
        {
            CaptionML = ENU='Bal. Tax Area Code',
                        ENA='Bal. US Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate();
            begin
                VALIDATE("Bal. VAT %");
            end;
        }
        field(87;"Bal. Tax Liable";Boolean)
        {
            CaptionML = ENU='Bal. Tax Liable',
                        ENA='Bal. US Tax Liable';

            trigger OnValidate();
            begin
                VALIDATE("Bal. VAT %");
            end;
        }
        field(88;"Bal. Tax Group Code";Code[10])
        {
            CaptionML = ENU='Bal. Tax Group Code',
                        ENA='Bal. US Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate();
            begin
                VALIDATE("Bal. VAT %");
            end;
        }
        field(89;"Bal. Use Tax";Boolean)
        {
            CaptionML = ENU='Bal. Use Tax',
                        ENA='Bal. Use US Tax';

            trigger OnValidate();
            begin
                TESTFIELD("Bal. Gen. Posting Type","Bal. Gen. Posting Type"::Purchase);
                VALIDATE("Bal. VAT %");
            end;
        }
        field(90;"VAT Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Bus. Posting Group',
                        ENA='GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                  TESTFIELD("VAT Bus. Posting Group",'');

                VALIDATE("VAT Prod. Posting Group");

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END
            end;
        }
        field(91;"VAT Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Prod. Posting Group',
                        ENA='GST Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin
                IF "Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Bank Account"] THEN
                  TESTFIELD("VAT Prod. Posting Group",'');

                CheckVATInAlloc;

                "VAT %" := 0;
                "VAT Calculation Type" := "VAT Calculation Type"::"Normal VAT";
                IF "Gen. Posting Type" <> 0 THEN BEGIN
                  IF NOT VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
                    VATPostingSetup.INIT;
                  "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                  CASE "VAT Calculation Type" OF
                    "VAT Calculation Type"::"Normal VAT":
                      "VAT %" := VATPostingSetup."VAT %";
                    "VAT Calculation Type"::"Full VAT":
                      CASE "Gen. Posting Type" OF
                        "Gen. Posting Type"::Sale:
                          BEGIN
                            VATPostingSetup.TESTFIELD("Sales VAT Account");
                            TESTFIELD("Account No.",VATPostingSetup."Sales VAT Account");
                          END;
                        "Gen. Posting Type"::Purchase:
                          BEGIN
                            VATPostingSetup.TESTFIELD("Purchase VAT Account");
                            TESTFIELD("Account No.",VATPostingSetup."Purchase VAT Account");
                          END;
                      END;
                  END;
                END;
                VALIDATE("VAT %");

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END
            end;
        }
        field(92;"Bal. VAT Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Bal. VAT Bus. Posting Group',
                        ENA='Bal. GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                IF "Bal. Account Type" IN
                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                THEN
                  TESTFIELD("Bal. VAT Bus. Posting Group",'');

                VALIDATE("Bal. VAT Prod. Posting Group");
            end;
        }
        field(93;"Bal. VAT Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Bal. VAT Prod. Posting Group',
                        ENA='Bal. GST Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin
                IF "Bal. Account Type" IN
                   ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Bank Account"]
                THEN
                  TESTFIELD("Bal. VAT Prod. Posting Group",'');

                "Bal. VAT %" := 0;
                "Bal. VAT Calculation Type" := "Bal. VAT Calculation Type"::"Normal VAT";
                IF "Bal. Gen. Posting Type" <> 0 THEN BEGIN
                  IF NOT VATPostingSetup.GET("Bal. VAT Bus. Posting Group","Bal. VAT Prod. Posting Group") THEN
                    VATPostingSetup.INIT;
                  "Bal. VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                  CASE "Bal. VAT Calculation Type" OF
                    "Bal. VAT Calculation Type"::"Normal VAT":
                      "Bal. VAT %" := VATPostingSetup."VAT %";
                    "Bal. VAT Calculation Type"::"Full VAT":
                      CASE "Bal. Gen. Posting Type" OF
                        "Bal. Gen. Posting Type"::Sale:
                          BEGIN
                            VATPostingSetup.TESTFIELD("Sales VAT Account");
                            TESTFIELD("Bal. Account No.",VATPostingSetup."Sales VAT Account");
                          END;
                        "Bal. Gen. Posting Type"::Purchase:
                          BEGIN
                            VATPostingSetup.TESTFIELD("Purchase VAT Account");
                            TESTFIELD("Bal. Account No.",VATPostingSetup."Purchase VAT Account");
                          END;
                      END;
                  END;
                END;
                VALIDATE("Bal. VAT %");
            end;
        }
        field(95;"Additional-Currency Posting";Option)
        {
            CaptionML = ENU='Additional-Currency Posting',
                        ENA='Additional-Currency Posting';
            Editable = false;
            OptionCaptionML = ENU='None,Amount Only,Additional-Currency Amount Only',
                              ENA='None,Amount Only,Additional-Currency Amount Only';
            OptionMembers = "None","Amount Only","Additional-Currency Amount Only";
        }
        field(98;"FA Add.-Currency Factor";Decimal)
        {
            CaptionML = ENU='FA Add.-Currency Factor',
                        ENA='FA Add.-Currency Factor';
            DecimalPlaces = 0:15;
            MinValue = 0;
        }
        field(99;"Source Currency Code";Code[10])
        {
            CaptionML = ENU='Source Currency Code',
                        ENA='Source Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(100;"Source Currency Amount";Decimal)
        {
            AccessByPermission = TableData Currency=R;
            AutoFormatType = 1;
            CaptionML = ENU='Source Currency Amount',
                        ENA='Source Currency Amount';
            Editable = false;
        }
        field(101;"Source Curr. VAT Base Amount";Decimal)
        {
            AccessByPermission = TableData Currency=R;
            AutoFormatType = 1;
            CaptionML = ENU='Source Curr. VAT Base Amount',
                        ENA='Source Curr. GST Base Amount';
            Editable = false;
        }
        field(102;"Source Curr. VAT Amount";Decimal)
        {
            AccessByPermission = TableData Currency=R;
            AutoFormatType = 1;
            CaptionML = ENU='Source Curr. VAT Amount',
                        ENA='Source Curr. GST Amount';
            Editable = false;
        }
        field(103;"VAT Base Discount %";Decimal)
        {
            CaptionML = ENU='VAT Base Discount %',
                        ENA='GST Base Discount %';
            DecimalPlaces = 0:5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;
        }
        field(104;"VAT Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Amount (LCY)',
                        ENA='GST Amount (LCY)';
            Editable = false;
        }
        field(105;"VAT Base Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Base Amount (LCY)',
                        ENA='GST Base Amount (LCY)';
            Editable = false;
        }
        field(106;"Bal. VAT Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Bal. VAT Amount (LCY)',
                        ENA='Bal. GST Amount (LCY)';
            Editable = false;
        }
        field(107;"Bal. VAT Base Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Bal. VAT Base Amount (LCY)',
                        ENA='Bal. GST Base Amount (LCY)';
            Editable = false;
        }
        field(108;"Reversing Entry";Boolean)
        {
            CaptionML = ENU='Reversing Entry',
                        ENA='Reversing Entry';
            Editable = false;
        }
        field(109;"Allow Zero-Amount Posting";Boolean)
        {
            CaptionML = ENU='Allow Zero-Amount Posting',
                        ENA='Allow Zero-Amount Posting';
            Editable = false;
        }
        field(110;"Ship-to/Order Address Code";Code[10])
        {
            CaptionML = ENU='Ship-to/Order Address Code',
                        ENA='Ship-to/Order Address Code';
            TableRelation = IF (Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.)) ELSE IF (Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.)) ELSE IF (Bal. Account Type=CONST(Customer)) "Ship-to Address".Code WHERE (Customer No.=FIELD(Bill-to/Pay-to No.)) ELSE IF (Bal. Account Type=CONST(Vendor)) "Order Address".Code WHERE (Vendor No.=FIELD(Bill-to/Pay-to No.));
        }
        field(111;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='VAT Difference',
                        ENA='GST Difference';
            Editable = false;
        }
        field(112;"Bal. VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Bal. VAT Difference',
                        ENA='Bal. GST Difference';
            Editable = false;
        }
        field(113;"IC Partner Code";Code[20])
        {
            CaptionML = ENU='IC Partner Code',
                        ENA='IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(114;"IC Direction";Option)
        {
            CaptionML = ENU='IC Direction',
                        ENA='IC Direction';
            OptionCaptionML = ENU='Outgoing,Incoming',
                              ENA='Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(116;"IC Partner G/L Acc. No.";Code[20])
        {
            CaptionML = ENU='IC Partner G/L Acc. No.',
                        ENA='IC Partner G/L Acc. No.';
            TableRelation = "IC G/L Account";

            trigger OnValidate();
            var
                ICGLAccount : Record "IC G/L Account";
            begin
                IF "Journal Template Name" <> '' THEN
                  IF "IC Partner G/L Acc. No." <> '' THEN BEGIN
                    GetTemplate;
                    GenJnlTemplate.TESTFIELD(Type,GenJnlTemplate.Type::Intercompany);
                    IF ICGLAccount.GET("IC Partner G/L Acc. No.") THEN
                      ICGLAccount.TESTFIELD(Blocked,FALSE);
                  END
            end;
        }
        field(117;"IC Partner Transaction No.";Integer)
        {
            CaptionML = ENU='IC Partner Transaction No.',
                        ENA='IC Partner Transaction No.';
            Editable = false;
        }
        field(118;"Sell-to/Buy-from No.";Code[20])
        {
            CaptionML = ENU='Sell-to/Buy-from No.',
                        ENA='Sell-to/Buy-from No.';
            TableRelation = IF (Account Type=CONST(Customer)) Customer ELSE IF (Bal. Account Type=CONST(Customer)) Customer ELSE IF (Account Type=CONST(Vendor)) Vendor ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor;

            trigger OnValidate();
            begin
                ReadGLSetup;
                IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Sell-to/Buy-from No." THEN
                  UpdateCountryCodeAndVATRegNo("Sell-to/Buy-from No.");
            end;
        }
        field(119;"VAT Registration No.";Text[20])
        {
            CaptionML = ENU='VAT Registration No.',
                        ENA='Exemption Certificate No.';

            trigger OnValidate();
            var
                VATRegNoFormat : Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.","Country/Region Code",'',0);
            end;
        }
        field(120;"Country/Region Code";Code[10])
        {
            CaptionML = ENU='Country/Region Code',
                        ENA='Country/Region Code';
            TableRelation = Country/Region;

            trigger OnValidate();
            begin
                VALIDATE("VAT Registration No.");
            end;
        }
        field(121;Prepayment;Boolean)
        {
            CaptionML = ENU='Prepayment',
                        ENA='Prepayment';
        }
        field(122;"Financial Void";Boolean)
        {
            CaptionML = ENU='Financial Void',
                        ENA='Financial Void';
            Editable = false;
        }
        field(165;"Incoming Document Entry No.";Integer)
        {
            CaptionML = ENU='Incoming Document Entry No.',
                        ENA='Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate();
            var
                IncomingDocument : Record "Incoming Document";
            begin
                IF Description = '' THEN
                  Description := COPYSTR(IncomingDocument.Description,1,MAXSTRLEN(Description));
                IF "Incoming Document Entry No." = xRec."Incoming Document Entry No." THEN
                  EXIT;

                IF "Incoming Document Entry No." = 0 THEN
                  IncomingDocument.RemoveReferenceToWorkingDocument(xRec."Incoming Document Entry No.")
                ELSE
                  IncomingDocument.SetGenJournalLine(Rec);
            end;
        }
        field(170;"Creditor No.";Code[20])
        {
            CaptionML = ENU='Creditor No.',
                        ENA='Creditor No.';
            Numeric = true;
        }
        field(171;"Payment Reference";Code[50])
        {
            CaptionML = ENU='Payment Reference',
                        ENA='Payment Reference';
            Numeric = true;

            trigger OnValidate();
            begin
                IF "Payment Reference" <> '' THEN
                  TESTFIELD("Creditor No.");
            end;
        }
        field(172;"Payment Method Code";Code[10])
        {
            CaptionML = ENU='Payment Method Code',
                        ENA='Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(173;"Applies-to Ext. Doc. No.";Code[35])
        {
            CaptionML = ENU='Applies-to Ext. Doc. No.',
                        ENA='Applies-to Ext. Doc. No.';
        }
        field(288;"Recipient Bank Account";Code[10])
        {
            CaptionML = ENU='Recipient Bank Account',
                        ENA='Recipient Bank Account';
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.)) ELSE IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.)) ELSE IF (Bal. Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Bal. Account No.)) ELSE IF (Bal. Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Bal. Account No.));

            trigger OnValidate();
            begin
                IF "Recipient Bank Account" = '' THEN
                  EXIT;
                IF ("Document Type" = "Document Type"::Invoice) AND
                   (("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) OR
                    ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]))
                THEN
                  "Recipient Bank Account" := '';
            end;
        }
        field(289;"Message to Recipient";Text[140])
        {
            CaptionML = ENU='Message to Recipient',
                        ENA='Message to Recipient';
        }
        field(290;"Exported to Payment File";Boolean)
        {
            CaptionML = ENU='Exported to Payment File',
                        ENA='Exported to Payment File';
            Editable = false;
        }
        field(291;"Has Payment Export Error";Boolean)
        {
            CalcFormula = Exist("Payment Jnl. Export Error Text" WHERE (Journal Template Name=FIELD(Journal Template Name), Journal Batch Name=FIELD(Journal Batch Name), Journal Line No.=FIELD(Line No.)));
            CaptionML = ENU='Has Payment Export Error',
                        ENA='Has Payment Export Error';
            Editable = false;
            FieldClass = FlowField;
        }
        field(480;"Dimension Set ID";Integer)
        {
            CaptionML = ENU='Dimension Set ID',
                        ENA='Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup();
            begin
                ShowDimensions;
            end;
        }
        field(827;"Credit Card No.";Code[20])
        {
            CaptionML = ENU='Credit Card No.',
                        ENA='Credit Card No.';
        }
        field(1001;"Job Task No.";Code[20])
        {
            CaptionML = ENU='Job Task No.',
                        ENA='Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));

            trigger OnValidate();
            begin
                IF "Job Task No." <> xRec."Job Task No." THEN
                  VALIDATE("Job Planning Line No.",0);
                IF "Job Task No." = '' THEN BEGIN
                  "Job Quantity" := 0;
                  "Job Currency Factor" := 0;
                  "Job Currency Code" := '';
                  "Job Unit Price" := 0;
                  "Job Total Price" := 0;
                  "Job Line Amount" := 0;
                  "Job Line Discount Amount" := 0;
                  "Job Unit Cost" := 0;
                  "Job Total Cost" := 0;
                  "Job Line Discount %" := 0;

                  "Job Unit Price (LCY)" := 0;
                  "Job Total Price (LCY)" := 0;
                  "Job Line Amount (LCY)" := 0;
                  "Job Line Disc. Amount (LCY)" := 0;
                  "Job Unit Cost (LCY)" := 0;
                  "Job Total Cost (LCY)" := 0;
                  EXIT;
                END;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  CopyDimensionsFromJobTaskLine;
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1002;"Job Unit Price (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 2;
            CaptionML = ENU='Job Unit Price (LCY)',
                        ENA='Job Unit Price (LCY)';
            Editable = false;
        }
        field(1003;"Job Total Price (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            CaptionML = ENU='Job Total Price (LCY)',
                        ENA='Job Total Price (LCY)';
            Editable = false;
        }
        field(1004;"Job Quantity";Decimal)
        {
            AccessByPermission = TableData Job=R;
            CaptionML = ENU='Job Quantity',
                        ENA='Job Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  IF "Job Planning Line No." <> 0 THEN
                    VALIDATE("Job Planning Line No.");
                  CreateTempJobJnlLine;
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1005;"Job Unit Cost (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 2;
            CaptionML = ENU='Job Unit Cost (LCY)',
                        ENA='Job Unit Cost (LCY)';
            Editable = false;
        }
        field(1006;"Job Line Discount %";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            CaptionML = ENU='Job Line Discount %',
                        ENA='Job Line Discount %';

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Line Discount %","Job Line Discount %");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1007;"Job Line Disc. Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Job Line Disc. Amount (LCY)',
                        ENA='Job Line Disc. Amount (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Line Discount Amount (LCY)","Job Line Disc. Amount (LCY)");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1008;"Job Unit Of Measure Code";Code[10])
        {
            CaptionML = ENU='Job Unit Of Measure Code',
                        ENA='Job Unit Of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(1009;"Job Line Type";Option)
        {
            AccessByPermission = TableData Job=R;
            CaptionML = ENU='Job Line Type',
                        ENA='Job Line Type';
            OptionCaptionML = ENU=' ,Budget,Billable,Both Budget and Billable',
                              ENA=' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";

            trigger OnValidate();
            begin
                IF "Job Planning Line No." <> 0 THEN
                  ERROR(Text019,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
            end;
        }
        field(1010;"Job Unit Price";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 2;
            CaptionML = ENU='Job Unit Price',
                        ENA='Job Unit Price';

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Unit Price","Job Unit Price");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1011;"Job Total Price";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Job Total Price',
                        ENA='Job Total Price';
            Editable = false;
        }
        field(1012;"Job Unit Cost";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 2;
            CaptionML = ENU='Job Unit Cost',
                        ENA='Job Unit Cost';
            Editable = false;
        }
        field(1013;"Job Total Cost";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Job Total Cost',
                        ENA='Job Total Cost';
            Editable = false;
        }
        field(1014;"Job Line Discount Amount";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Job Line Discount Amount',
                        ENA='Job Line Discount Amount';

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Line Discount Amount","Job Line Discount Amount");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1015;"Job Line Amount";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Job Line Amount',
                        ENA='Job Line Amount';

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Line Amount","Job Line Amount");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1016;"Job Total Cost (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            CaptionML = ENU='Job Total Cost (LCY)',
                        ENA='Job Total Cost (LCY)';
            Editable = false;
        }
        field(1017;"Job Line Amount (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            CaptionML = ENU='Job Line Amount (LCY)',
                        ENA='Job Line Amount (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine;
                  TempJobJnlLine.VALIDATE("Line Amount (LCY)","Job Line Amount (LCY)");
                  UpdatePricesFromJobJnlLine;
                END;
            end;
        }
        field(1018;"Job Currency Factor";Decimal)
        {
            CaptionML = ENU='Job Currency Factor',
                        ENA='Job Currency Factor';
        }
        field(1019;"Job Currency Code";Code[10])
        {
            CaptionML = ENU='Job Currency Code',
                        ENA='Job Currency Code';

            trigger OnValidate();
            begin
                IF ("Job Currency Code" <> xRec."Job Currency Code") OR ("Job Currency Code" <> '') THEN
                  IF JobTaskIsSet THEN BEGIN
                    CreateTempJobJnlLine;
                    UpdatePricesFromJobJnlLine;
                  END;
            end;
        }
        field(1020;"Job Planning Line No.";Integer)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Planning Line No.',
                        ENA='Job Planning Line No.';

            trigger OnLookup();
            var
                JobPlanningLine : Record "Job Planning Line";
            begin
                JobPlanningLine.SETRANGE("Job No.","Job No.");
                JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                JobPlanningLine.SETRANGE("No.","Account No.");
                JobPlanningLine.SETRANGE("Usage Link",TRUE);
                JobPlanningLine.SETRANGE("System-Created Entry",FALSE);

                IF PAGE.RUNMODAL(0,JobPlanningLine) = ACTION::LookupOK THEN
                  VALIDATE("Job Planning Line No.",JobPlanningLine."Line No.");
            end;

            trigger OnValidate();
            var
                JobPlanningLine : Record "Job Planning Line";
            begin
                IF "Job Planning Line No." <> 0 THEN BEGIN
                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                  JobPlanningLine.TESTFIELD("Job No.","Job No.");
                  JobPlanningLine.TESTFIELD("Job Task No.","Job Task No.");
                  JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                  JobPlanningLine.TESTFIELD("No.","Account No.");
                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Job Quantity");
                END ELSE
                  VALIDATE("Job Remaining Qty.",0);
            end;
        }
        field(1030;"Job Remaining Qty.";Decimal)
        {
            AccessByPermission = TableData Job=R;
            CaptionML = ENU='Job Remaining Qty.',
                        ENA='Job Remaining Qty.';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            var
                JobPlanningLine : Record "Job Planning Line";
            begin
                IF ("Job Remaining Qty." <> 0) AND ("Job Planning Line No." = 0) THEN
                  ERROR(Text018,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

                IF "Job Planning Line No." <> 0 THEN BEGIN
                  JobPlanningLine.GET("Job No.","Job Task No.","Job Planning Line No.");
                  IF JobPlanningLine.Quantity >= 0 THEN BEGIN
                    IF "Job Remaining Qty." < 0 THEN
                      "Job Remaining Qty." := 0;
                  END ELSE BEGIN
                    IF "Job Remaining Qty." > 0 THEN
                      "Job Remaining Qty." := 0;
                  END;
                END;
            end;
        }
        field(1200;"Direct Debit Mandate ID";Code[35])
        {
            CaptionML = ENU='Direct Debit Mandate ID',
                        ENA='Direct Debit Mandate ID';
            TableRelation = IF (Account Type=CONST(Customer)) "SEPA Direct Debit Mandate" WHERE (Customer No.=FIELD(Account No.));

            trigger OnValidate();
            var
                SEPADirectDebitMandate : Record "SEPA Direct Debit Mandate";
            begin
                IF "Direct Debit Mandate ID" = '' THEN
                  EXIT;
                TESTFIELD("Account Type","Account Type"::Customer);
                SEPADirectDebitMandate.GET("Direct Debit Mandate ID");
                SEPADirectDebitMandate.TESTFIELD("Customer No.","Account No.");
                "Recipient Bank Account" := SEPADirectDebitMandate."Customer Bank Account Code";
            end;
        }
        field(1220;"Data Exch. Entry No.";Integer)
        {
            CaptionML = ENU='Data Exch. Entry No.',
                        ENA='Data Exch. Entry No.';
            Editable = false;
            TableRelation = "Data Exch.";
        }
        field(1221;"Payer Information";Text[50])
        {
            CaptionML = ENU='Payer Information',
                        ENA='Payer Information';
        }
        field(1222;"Transaction Information";Text[100])
        {
            CaptionML = ENU='Transaction Information',
                        ENA='Transaction Information';
        }
        field(1223;"Data Exch. Line No.";Integer)
        {
            CaptionML = ENU='Data Exch. Line No.',
                        ENA='Data Exch. Line No.';
            Editable = false;
        }
        field(1224;"Applied Automatically";Boolean)
        {
            CaptionML = ENU='Applied Automatically',
                        ENA='Applied Automatically';
        }
        field(1700;"Deferral Code";Code[10])
        {
            CaptionML = ENU='Deferral Code',
                        ENA='Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate();
            var
                DeferralUtilities : Codeunit "Deferral Utilities";
            begin
                IF "Deferral Code" <> '' THEN
                  TESTFIELD("Account Type","Account Type"::"G/L Account");

                DeferralUtilities.DeferralCodeOnValidate("Deferral Code",DeferralDocType::"G/L","Journal Template Name","Journal Batch Name",
                  0,'',"Line No.",GetDeferralAmount,"Posting Date",Description,"Currency Code");
            end;
        }
        field(1701;"Deferral Line No.";Integer)
        {
            CaptionML = ENU='Deferral Line No.',
                        ENA='Deferral Line No.';
        }
        field(5050;"Campaign No.";Code[20])
        {
            CaptionML = ENU='Campaign No.',
                        ENA='Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate();
            begin
                CreateDim(
                  DATABASE::Campaign,"Campaign No.",
                  DimMgt.TypeToTableID1("Account Type"),"Account No.",
                  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
                  DATABASE::Job,"Job No.",
                  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code");
            end;
        }
        field(5400;"Prod. Order No.";Code[20])
        {
            CaptionML = ENU='Prod. Order No.',
                        ENA='Prod. Order No.';
            Editable = false;
        }
        field(5600;"FA Posting Date";Date)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Posting Date',
                        ENA='FA Posting Date';
        }
        field(5601;"FA Posting Type";Option)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Posting Type',
                        ENA='FA Posting Type';
            OptionCaptionML = ENU=' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance',
                              ENA=' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;

            trigger OnValidate();
            begin
                IF  NOT (("Account Type" = "Account Type"::"Fixed Asset") OR
                         ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")) AND
                   ("FA Posting Type" = "FA Posting Type"::" ")
                THEN BEGIN
                  "FA Posting Date" := 0D;
                  "Salvage Value" := 0;
                  "No. of Depreciation Days" := 0;
                  "Depr. until FA Posting Date" := FALSE;
                  "Depr. Acquisition Cost" := FALSE;
                  "Maintenance Code" := '';
                  "Insurance No." := '';
                  "Budgeted FA No." := '';
                  "Duplicate in Depreciation Book" := '';
                  "Use Duplication List" := FALSE;
                  "FA Reclassification Entry" := FALSE;
                  "FA Error Entry No." := 0;
                END;

                IF "FA Posting Type" <> "FA Posting Type"::"Acquisition Cost" THEN
                  TESTFIELD("Insurance No.",'');
                IF "FA Posting Type" <> "FA Posting Type"::Maintenance THEN
                  TESTFIELD("Maintenance Code",'');
                GetFAVATSetup;
                GetFAAddCurrExchRate;
            end;
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            CaptionML = ENU='Depreciation Book Code',
                        ENA='Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate();
            var
                FADeprBook : Record "FA Depreciation Book";
            begin
                IF "Depreciation Book Code" = '' THEN
                  EXIT;

                IF ("Account No." <> '') AND
                   ("Account Type" = "Account Type"::"Fixed Asset")
                THEN BEGIN
                  FADeprBook.GET("Account No.","Depreciation Book Code");
                  "Posting Group" := FADeprBook."FA Posting Group";
                END;

                IF ("Bal. Account No." <> '') AND
                   ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset")
                THEN BEGIN
                  FADeprBook.GET("Bal. Account No.","Depreciation Book Code");
                  "Posting Group" := FADeprBook."FA Posting Group";
                END;
                GetFAVATSetup;
                GetFAAddCurrExchRate;
            end;
        }
        field(5603;"Salvage Value";Decimal)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            AutoFormatType = 1;
            CaptionML = ENU='Salvage Value',
                        ENA='Salvage Value';
        }
        field(5604;"No. of Depreciation Days";Integer)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            BlankZero = true;
            CaptionML = ENU='No. of Depreciation Days',
                        ENA='No. of Depreciation Days';
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='Depr. until FA Posting Date',
                        ENA='Depr. until FA Posting Date';
        }
        field(5606;"Depr. Acquisition Cost";Boolean)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='Depr. Acquisition Cost',
                        ENA='Depr. Acquisition Cost';
        }
        field(5609;"Maintenance Code";Code[10])
        {
            CaptionML = ENU='Maintenance Code',
                        ENA='Maintenance Code';
            TableRelation = Maintenance;

            trigger OnValidate();
            begin
                IF "Maintenance Code" <> '' THEN
                  TESTFIELD("FA Posting Type","FA Posting Type"::Maintenance);
            end;
        }
        field(5610;"Insurance No.";Code[20])
        {
            CaptionML = ENU='Insurance No.',
                        ENA='Insurance No.';
            TableRelation = Insurance;

            trigger OnValidate();
            begin
                IF "Insurance No." <> '' THEN
                  TESTFIELD("FA Posting Type","FA Posting Type"::"Acquisition Cost");
            end;
        }
        field(5611;"Budgeted FA No.";Code[20])
        {
            CaptionML = ENU='Budgeted FA No.',
                        ENA='Budgeted FA No.';
            TableRelation = "Fixed Asset";

            trigger OnValidate();
            var
                FA : Record "Fixed Asset";
            begin
                IF "Budgeted FA No." <> '' THEN BEGIN
                  FA.GET("Budgeted FA No.");
                  FA.TESTFIELD("Budgeted Asset",TRUE);
                END;
            end;
        }
        field(5612;"Duplicate in Depreciation Book";Code[10])
        {
            CaptionML = ENU='Duplicate in Depreciation Book',
                        ENA='Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";

            trigger OnValidate();
            begin
                "Use Duplication List" := FALSE;
            end;
        }
        field(5613;"Use Duplication List";Boolean)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='Use Duplication List',
                        ENA='Use Duplication List';

            trigger OnValidate();
            begin
                "Duplicate in Depreciation Book" := '';
            end;
        }
        field(5614;"FA Reclassification Entry";Boolean)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Reclassification Entry',
                        ENA='FA Reclassification Entry';
        }
        field(5615;"FA Error Entry No.";Integer)
        {
            BlankZero = true;
            CaptionML = ENU='FA Error Entry No.',
                        ENA='FA Error Entry No.';
            TableRelation = "FA Ledger Entry";
        }
        field(5616;"Index Entry";Boolean)
        {
            CaptionML = ENU='Index Entry',
                        ENA='Index Entry';
        }
        field(5617;"Source Line No.";Integer)
        {
            CaptionML = ENU='Source Line No.',
                        ENA='Source Line No.';
        }
        field(5618;Comment;Text[250])
        {
            CaptionML = ENU='Comment',
                        ENA='Comment';
        }
        field(11620;Adjustment;Boolean)
        {
            CaptionML = ENU='Adjustment',
                        ENA='Adjustment';
        }
        field(11621;"BAS Adjustment";Boolean)
        {
            CaptionML = ENU='BAS Adjustment',
                        ENA='BAS Adjustment';
        }
        field(11626;"Adjustment Applies-to";Code[20])
        {
            CaptionML = ENU='Adjustment Applies-to',
                        ENA='Adjustment Applies-to';

            trigger OnLookup();
            begin
                LookupAdjmtAppliesTo;
            end;

            trigger OnValidate();
            begin
                ValidateAdjmtAppliesTo;
            end;
        }
        field(11627;"Adjmt. Entry No.";Integer)
        {
            CaptionML = ENU='Adjmt. Entry No.',
                        ENA='Adjmt. Entry No.';
            Editable = false;
        }
        field(11629;"BAS Doc. No.";Code[11])
        {
            CaptionML = ENU='BAS Doc. No.',
                        ENA='BAS Doc. No.';
        }
        field(11630;"BAS Version";Integer)
        {
            CaptionML = ENU='BAS Version',
                        ENA='BAS Version';
        }
        field(11631;"Financially Voided Cheque";Boolean)
        {
            CaptionML = ENU='Financially Voided Cheque',
                        ENA='Financially Voided Cheque';
        }
        field(11632;"EFT Journal No.";Integer)
        {
            CaptionML = ENU='EFT Journal No.',
                        ENA='EFT Journal No.';
            Description = 'EFT';
            Editable = false;
        }
        field(11633;"EFT Payment";Boolean)
        {
            CaptionML = ENU='EFT Payment',
                        ENA='EFT Payment';
            Description = 'EFT';
            Editable = false;
        }
        field(11634;"EFT Ledger Entry No.";Integer)
        {
            CaptionML = ENU='EFT Ledger Entry No.',
                        ENA='EFT Ledger Entry No.';
            Description = 'EFT';
            Editable = false;
        }
        field(11635;"EFT Bank Account No.";Code[10])
        {
            CaptionML = ENU='EFT Bank Account No.',
                        ENA='EFT Bank Account No.';
            Description = 'EFT';

            trigger OnLookup();
            begin
                VendBankAcc.RESET;
                VendBankAcc.SETRANGE("Vendor No.","Account No.");
                IF PAGE.RUNMODAL(426,VendBankAcc) = ACTION::LookupOK THEN
                  "EFT Bank Account No." := VendBankAcc.Code;
            end;
        }
        field(28021;"Bank Branch No.";Text[20])
        {
            CaptionML = ENU='Bank Branch No.',
                        ENA='Bank Branch No.';
        }
        field(28022;"Bank Account No.";Text[30])
        {
            CaptionML = ENU='Bank Account No.',
                        ENA='Bank Account No.';
        }
        field(28023;"Customer/Vendor Bank";Code[10])
        {
            CaptionML = ENU='Customer/Vendor Bank',
                        ENA='Customer/Vendor Bank';
            TableRelation = IF (Account Type=CONST(Customer)) "Customer Bank Account".Code WHERE (Customer No.=FIELD(Account No.)) ELSE IF (Account Type=CONST(Vendor)) "Vendor Bank Account".Code WHERE (Vendor No.=FIELD(Account No.));

            trigger OnValidate();
            begin
                CASE "Account Type" OF
                  "Account Type"::Customer:
                    BEGIN
                      IF CustBankAcc.GET("Account No.","Customer/Vendor Bank") THEN BEGIN
                        "Bank Branch No." := CustBankAcc."Bank Branch No.";
                        "Bank Account No." := CustBankAcc."Bank Account No.";
                      END ELSE BEGIN
                        "Bank Branch No." := '';
                        "Bank Account No." := '';
                      END;
                    END;
                  "Account Type"::Vendor:
                    BEGIN
                      IF VendBankAcc.GET("Account No.","Customer/Vendor Bank") THEN BEGIN
                        "Bank Branch No." := VendBankAcc."Bank Branch No.";
                        "Bank Account No." := VendBankAcc."Bank Account No.";
                      END ELSE BEGIN
                        "Bank Branch No." := '';
                        "Bank Account No." := '';
                      END;
                    END;
                END;
            end;
        }
        field(28040;"WHT Business Posting Group";Code[10])
        {
            CaptionML = ENU='WHT Business Posting Group',
                        ENA='WHT Business Posting Group';
            TableRelation = "WHT Business Posting Group";
        }
        field(28041;"WHT Product Posting Group";Code[10])
        {
            CaptionML = ENU='WHT Product Posting Group',
                        ENA='WHT Product Posting Group';
            TableRelation = "WHT Product Posting Group";
        }
        field(28042;"WHT Absorb Base";Decimal)
        {
            CaptionML = ENU='WHT Absorb Base',
                        ENA='WHT Absorb Base';
        }
        field(28043;"WHT Entry No.";Integer)
        {
            CaptionML = ENU='WHT Entry No.',
                        ENA='WHT Entry No.';
        }
        field(28044;"WHT Report Line No.";Code[10])
        {
            CaptionML = ENU='WHT Report Line No.',
                        ENA='WHT Report Line No.';
        }
        field(28045;"Skip WHT";Boolean)
        {
            CaptionML = ENU='Skip WHT',
                        ENA='Skip WHT';
        }
        field(28046;"Certificate Printed";Boolean)
        {
            CaptionML = ENU='Certificate Printed',
                        ENA='Certificate Printed';
        }
        field(28047;"WHT Payment";Boolean)
        {
            CaptionML = ENU='WHT Payment',
                        ENA='WHT Payment';

            trigger OnValidate();
            begin
                ReadGLSetup;
                IF NOT GLSetup."Manual Sales WHT Calc." THEN
                  "WHT Payment" := FALSE;
            end;
        }
        field(28048;"Actual Vendor No.";Code[20])
        {
            CaptionML = ENU='Actual Vendor No.',
                        ENA='Actual Vendor No.';
            TableRelation = Vendor;
        }
        field(28049;"Is WHT";Boolean)
        {
            CaptionML = ENU='Is WHT',
                        ENA='Is WHT';
        }
        field(28081;"VAT Base (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Base (ACY)',
                        ENA='GST Base (ACY)';
            Editable = false;
        }
        field(28082;"VAT Amount (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Amount (ACY)',
                        ENA='GST Amount (ACY)';
        }
        field(28083;"Amount Including VAT (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Amount Including VAT (ACY)',
                        ENA='Amount Including GST (ACY)';
            Editable = false;
        }
        field(28084;"Amount (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Amount (ACY)',
                        ENA='Amount (ACY)';
            Editable = false;
        }
        field(28085;"VAT Difference (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Difference (ACY)',
                        ENA='GST Difference (ACY)';
            Editable = false;
        }
        field(28087;"Vendor Exchange Rate (ACY)";Decimal)
        {
            CaptionML = ENU='Vendor Exchange Rate (ACY)',
                        ENA='Vendor Exchange Rate (ACY)';
            DecimalPlaces = 0:15;

            trigger OnValidate();
            begin
                VALIDATE("Currency Code");
            end;
        }
        field(28088;"Line Discount Amt. (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Line Discount Amt. (ACY)',
                        ENA='Line Discount Amt. (ACY)';
        }
        field(28089;"Inv. Discount Amt. (ACY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Discount Amt. (ACY)',
                        ENA='Inv. Discount Amt. (ACY)';
        }
        field(28090;"Post Dated Check";Boolean)
        {
            CaptionML = ENU='Post Dated Check',
                        ENA='Post Dated Cheque';
        }
        field(28091;"Check No.";Code[20])
        {
            CaptionML = ENU='Check No.',
                        ENA='Cheque No.';
        }
        field(28092;"Interest Amount";Decimal)
        {
            CaptionML = ENU='Interest Amount',
                        ENA='Interest Amount';

            trigger OnValidate();
            begin
                IF "Currency Code" = '' THEN
                  "Interest Amount (LCY)" := "Interest Amount"
                ELSE
                  "Interest Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "Interest Amount","Currency Factor"));
            end;
        }
        field(28093;"Interest Amount (LCY)";Decimal)
        {
            CaptionML = ENU='Interest Amount (LCY)',
                        ENA='Interest Amount (LCY)';
        }
        field(28160;"Entry Type";Option)
        {
            CaptionML = ENU='Entry Type',
                        ENA='Entry Type',
                        ENZ='Entry Type';
            OptionCaptionML = ENU='Definitive,Simulation',
                              ENA='Definitive,Simulation',
                              ENZ='Definitive,Simulation';
            OptionMembers = Definitive,Simulation;
        }
        field(28161;"Entry No.";Integer)
        {
            CaptionML = ENU='Entry No.',
                        ENA='Entry No.',
                        ENZ='Entry No.';
            Editable = false;
        }
        field(50000;Narration;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Balance (LCY)";
        }
        key(Key2;"Journal Template Name","Journal Batch Name","Posting Date","Document No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key3;"Account Type","Account No.","Applies-to Doc. Type","Applies-to Doc. No.")
        {
        }
        key(Key4;"Document No.")
        {
            MaintainSQLIndex = false;
        }
        key(Key5;"Account Type","Account No.","Document Type","Document No.")
        {
        }
        key(Key6;"Incoming Document Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ApprovalsMgmt.OnCancelGeneralJournalLineApprovalRequest(Rec);

        TESTFIELD("Check Printed",FALSE);

        ClearCustVendApplnEntry;
        ClearAppliedGenJnlLine;
        DeletePaymentFileErrors;
        ClearDataExchangeEntries(FALSE);

        GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
        GenJnlAlloc.DELETEALL;

        TempWHTEntry.SETRANGE("Document Type","Document Type");
        TempWHTEntry.SETRANGE("Original Document No.","Document No.");
        IF TempWHTEntry.FINDFIRST THEN
          TempWHTEntry.DELETEALL;

        DeferralUtilities.DeferralCodeOnDelete(
          DeferralDocType::"G/L",
          "Journal Template Name",
          "Journal Batch Name",0,'',"Line No.");

        VALIDATE("Incoming Document Entry No.",0);
    end;

    trigger OnInsert();
    begin
        GenJnlAlloc.LOCKTABLE;
        LOCKTABLE;
        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        "Posting No. Series" := GenJnlBatch."Posting No. Series";
        IF NOT "Post Dated Check" THEN BEGIN
          "Check Printed" := FALSE;

          ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
          ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        END;
    end;

    trigger OnModify();
    begin
        TESTFIELD("Check Printed",FALSE);
        IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
          ClearCustVendApplnEntry;
    end;

    trigger OnRename();
    begin
        ApprovalsMgmt.RenameApprovalEntries(xRec.RECORDID,RECORDID);

        TESTFIELD("Check Printed",FALSE);
    end;

    var
        Text000 : TextConst Comment='%1=Account Type,%2=Balance Account Type',ENU='%1 or %2 must be a G/L Account or Bank Account.',ENA='%1 or %2 must be a G/L Account or Bank Account.';
        Text001 : TextConst ENU='You must not specify %1 when %2 is %3.',ENA='You must not specify %1 when %2 is %3.';
        Text002 : TextConst ENU='cannot be specified without %1',ENA='cannot be specified without %1';
        Text003 : TextConst Comment='%1=Caption of Currency Code field, %2=Caption of table Gen Journal, %3=FromCurrencyCode, %4=ToCurrencyCode',ENU='The %1 in the %2 will be changed from %3 to %4.\\Do you want to continue?',ENA='The %1 in the %2 will be changed from %3 to %4.\\Do you want to continue?';
        Text005 : TextConst ENU='The update has been interrupted to respect the warning.',ENA='The update has been interrupted to respect the warning.';
        Text006 : TextConst ENU='The %1 option can only be used internally in the system.',ENA='The %1 option can only be used internally in the system.';
        Text007 : TextConst Comment='%1=Account Type,%2=Balance Account Type',ENU='%1 or %2 must be a bank account.',ENA='%1 or %2 must be a bank account.';
        Text008 : TextConst ENU=' must be 0 when %1 is %2.',ENA=' must be 0 when %1 is %2.';
        Text009 : TextConst ENU='LCY',ENA='LCY';
        Text010 : TextConst ENU='%1 must be %2 or %3.',ENA='%1 must be %2 or %3.';
        Text011 : TextConst ENU='%1 must be negative.',ENA='%1 must be negative.';
        Text012 : TextConst ENU='%1 must be positive.',ENA='%1 must be positive.';
        Text013 : TextConst ENU='The %1 must not be more than %2.',ENA='The %1 must not be more than %2.';
        GenJnlTemplate : Record "Gen. Journal Template";
        GenJnlBatch : Record "Gen. Journal Batch";
        GenJnlLine : Record "Gen. Journal Line";
        Currency : Record Currency;
        CurrExchRate : Record "Currency Exchange Rate";
        PaymentTerms : Record "Payment Terms";
        CustLedgEntry : Record "Cust. Ledger Entry";
        VendLedgEntry : Record "Vendor Ledger Entry";
        GenJnlAlloc : Record "Gen. Jnl. Allocation";
        VATPostingSetup : Record "VAT Posting Setup";
        GenBusPostingGrp : Record "Gen. Business Posting Group";
        GenProdPostingGrp : Record "Gen. Product Posting Group";
        GLSetup : Record "General Ledger Setup";
        Job : Record Job;
        SourceCodeSetup : Record "Source Code Setup";
        TempJobJnlLine : Record "Job Journal Line" temporary;
        NoSeriesMgt : Codeunit NoSeriesManagement;
        CustCheckCreditLimit : Codeunit "Cust-Check Cr. Limit";
        SalesTaxCalculate : Codeunit "Sales Tax Calculate";
        GenJnlApply : Codeunit "Gen. Jnl.-Apply";
        GenJnlShowCTEntries : Codeunit "Gen. Jnl.-Show CT Entries";
        CustEntrySetApplID : Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID : Codeunit "Vend. Entry-SetAppl.ID";
        DimMgt : Codeunit DimensionManagement;
        PaymentToleranceMgt : Codeunit "Payment Tolerance Management";
        DeferralUtilities : Codeunit "Deferral Utilities";
        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
        Window : Dialog;
        DeferralDocType : Option Purchase,Sales,"G/L";
        FromCurrencyCode : Code[10];
        ToCurrencyCode : Code[10];
        CurrencyCode : Code[10];
        Text014 : TextConst Comment='%1=Caption of Table Customer, %2=Customer No, %3=Caption of field Bill-to Customer No, %4=Value of Bill-to customer no.',ENU='The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?',ENA='The %1 %2 has a %3 %4.\\Do you still want to use %1 %2 in this journal line?';
        TemplateFound : Boolean;
        Text015 : TextConst ENU='You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.',ENA='You are not allowed to apply and post an entry to an entry with an earlier posting date.\\Instead, post %1 %2 and then apply it to %3 %4.';
        CurrencyDate : Date;
        Text016 : TextConst ENU='%1 must be G/L Account or Bank Account.',ENA='%1 must be G/L Account or Bank Account.';
        HideValidationDialog : Boolean;
        Text018 : TextConst ENU='%1 can only be set when %2 is set.',ENA='%1 can only be set when %2 is set.';
        Text019 : TextConst ENU='%1 cannot be changed when %2 is set.',ENA='%1 cannot be changed when %2 is set.';
        GLSetupRead : Boolean;
        BASManagement : Codeunit Codeunit11601;
        DocDate : Date;
        CustBankAcc : Record "Customer Bank Account";
        VendBankAcc : Record "Vendor Bank Account";
        TempWHTEntry : Record Table28046;
        Text1500001 : TextConst ENU='%1 and %2 must be identical or %1 must be Blank.',ENA='%1 and %2 must be identical or %1 must be Blank.';
        Text020 : TextConst ENU='You have not selected the Adjustment Applies-to, Do you still want to continue with the Document.',ENA='You have not selected the Adjustment Applies-to, Do you still want to continue with the Document.';
        Text021 : TextConst ENU='The posting has been interrupted to respect the warning.',ENA='The posting has been interrupted to respect the warning.';
        ExportAgainQst : TextConst ENU='One or more of the selected lines have already been exported. Do you want to export them again?',ENA='One or more of the selected lines have already been exported. Do you want to export them again?';
        NothingToExportErr : TextConst ENU='There is nothing to export.',ENA='There is nothing to export.';
        NotExistErr : TextConst Comment='%1=Document number',ENU='Document number %1 does not exist or is already closed.',ENA='Document number %1 does not exist or is already closed.';
        DocNoFilterErr : TextConst ENU='The document numbers cannot be renumbered while there is an active filter on the Document No. field.',ENA='The document numbers cannot be renumbered while there is an active filter on the Document No. field.';
        DueDateMsg : TextConst ENU='This posting date will cause an overdue payment.',ENA='This posting date will cause an overdue payment.';
        CalcPostDateMsg : TextConst ENU='Processing payment journal lines #1##########',ENA='Processing payment journal lines #1##########';

    procedure EmptyLine() : Boolean;
    begin
        EXIT(
          ("Account No." = '') AND (Amount = 0) AND
          (("Bal. Account No." = '') OR NOT "System-Created Entry"));
    end;

    procedure UpdateLineBalance();
    begin
        IF ((Amount > 0) AND (NOT Correction)) OR
           ((Amount < 0) AND Correction)
        THEN BEGIN
          "Debit Amount" := Amount;
          "Credit Amount" := 0
        END ELSE BEGIN
          "Debit Amount" := 0;
          "Credit Amount" := -Amount;
        END;
        IF "Currency Code" = '' THEN
          "Amount (LCY)" := Amount;
        CASE TRUE OF
          ("Account No." <> '') AND ("Bal. Account No." <> ''):
            "Balance (LCY)" := 0;
          "Bal. Account No." <> '':
            "Balance (LCY)" := -"Amount (LCY)";
          ELSE
            "Balance (LCY)" := "Amount (LCY)";
        END;

        CLEAR(GenJnlAlloc);
        GenJnlAlloc.UpdateAllocations(Rec);

        UpdateSalesPurchLCY;

        IF ("Deferral Code" <> '') AND (Amount <> xRec.Amount) AND ((Amount <> 0) AND (xRec.Amount <> 0)) THEN
          VALIDATE("Deferral Code");
    end;

    procedure SetUpNewLine(LastGenJnlLine : Record "Gen. Journal Line";Balance : Decimal;BottomLine : Boolean);
    begin
        GenJnlTemplate.GET("Journal Template Name");
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        IF GenJnlLine.FINDFIRST THEN BEGIN
          "Posting Date" := LastGenJnlLine."Posting Date";
          "Document Date" := LastGenJnlLine."Posting Date";
          "Document No." := LastGenJnlLine."Document No.";
          IF BottomLine AND
             (Balance - LastGenJnlLine."Balance (LCY)" = 0) AND
             NOT LastGenJnlLine.EmptyLine
          THEN
            IncrementDocumentNo;
        END ELSE BEGIN
          "Posting Date" := WORKDATE;
          "Document Date" := WORKDATE;
          IF GenJnlBatch."No. Series" <> '' THEN BEGIN
            CLEAR(NoSeriesMgt);
            "Document No." := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
          END;
        END;
        IF GenJnlTemplate.Recurring THEN
          "Recurring Method" := LastGenJnlLine."Recurring Method";
        CASE GenJnlTemplate.Type OF
          GenJnlTemplate.Type::Payments:
            BEGIN
              "Account Type" := "Account Type"::Vendor;
              "Document Type" := "Document Type"::Payment;
            END;
          ELSE BEGIN
            "Account Type" := LastGenJnlLine."Account Type";
            "Document Type" := LastGenJnlLine."Document Type";
          END;
        END;
        "Source Code" := GenJnlTemplate."Source Code";
        "Reason Code" := GenJnlBatch."Reason Code";
        "Posting No. Series" := GenJnlBatch."Posting No. Series";
        "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
        IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"Fixed Asset"]) AND
           ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,"Bal. Account Type"::"Fixed Asset"])
        THEN
          "Account Type" := "Account Type"::"G/L Account";
        VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
        Description := '';
        IF GenJnlBatch."Suggest Balancing Amount" THEN
          SuggestBalancingAmount(LastGenJnlLine,BottomLine);
    end;

    procedure InitNewLine(PostingDate : Date;DocumentDate : Date;PostingDescription : Text[50];ShortcutDim1Code : Code[20];ShortcutDim2Code : Code[20];DimSetID : Integer;ReasonCode : Code[10]);
    begin
        INIT;
        "Posting Date" := PostingDate;
        "Document Date" := DocumentDate;
        Description := PostingDescription;
        "Shortcut Dimension 1 Code" := ShortcutDim1Code;
        "Shortcut Dimension 2 Code" := ShortcutDim2Code;
        "Dimension Set ID" := DimSetID;
        "Reason Code" := ReasonCode;
    end;

    procedure CheckDocNoOnLines();
    var
        GenJnlBatch : Record "Gen. Journal Batch";
        GenJnlLine : Record "Gen. Journal Line";
        LastDocNo : Code[20];
    begin
        GenJnlLine.COPYFILTERS(Rec);

        IF NOT GenJnlLine.FINDSET THEN
          EXIT;
        GenJnlBatch.GET(GenJnlLine."Journal Template Name",GenJnlLine."Journal Batch Name");
        IF GenJnlBatch."No. Series" = '' THEN
          EXIT;

        CLEAR(NoSeriesMgt);
        REPEAT
          GenJnlLine.CheckDocNoBasedOnNoSeries(LastDocNo,GenJnlBatch."No. Series",NoSeriesMgt);
          LastDocNo := GenJnlLine."Document No.";
        UNTIL GenJnlLine.NEXT = 0;
    end;

    procedure CheckDocNoBasedOnNoSeries(LastDocNo : Code[20];NoSeriesCode : Code[10];var NoSeriesMgtInstance : Codeunit NoSeriesManagement);
    begin
        IF NoSeriesCode = '' THEN
          EXIT;

        IF (LastDocNo = '') OR ("Document No." <> LastDocNo) THEN
          TESTFIELD("Document No.",NoSeriesMgtInstance.GetNextNo(NoSeriesCode,"Posting Date",FALSE));
    end;

    procedure RenumberDocumentNo();
    var
        GenJnlLine2 : Record "Gen. Journal Line";
        DocNo : Code[20];
        FirstDocNo : Code[20];
        FirstTempDocNo : Code[20];
        LastTempDocNo : Code[20];
    begin
        TESTFIELD("Check Printed",FALSE);

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        IF GenJnlBatch."No. Series" = '' THEN
          EXIT;
        IF GETFILTER("Document No.") <> '' THEN
          ERROR(DocNoFilterErr);
        CLEAR(NoSeriesMgt);
        FirstDocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series","Posting Date");
        FirstTempDocNo := 'RENUMBERED-000000001';
        // step1 - renumber to non-existing document number
        DocNo := FirstTempDocNo;
        GenJnlLine2 := Rec;
        GenJnlLine2.RESET;
        RenumberDocNoOnLines(DocNo,GenJnlLine2);
        LastTempDocNo := DocNo;

        // step2 - renumber to real document number (within Filter)
        DocNo := FirstDocNo;
        GenJnlLine2.COPYFILTERS(Rec);
        GenJnlLine2 := Rec;
        RenumberDocNoOnLines(DocNo,GenJnlLine2);

        // step3 - renumber to real document number (outside filter)
        DocNo := INCSTR(DocNo);
        GenJnlLine2.RESET;
        GenJnlLine2.SETRANGE("Document No.",FirstTempDocNo,LastTempDocNo);
        RenumberDocNoOnLines(DocNo,GenJnlLine2);

        GET("Journal Template Name","Journal Batch Name","Line No.");
    end;

    local procedure RenumberDocNoOnLines(var DocNo : Code[20];var GenJnlLine2 : Record "Gen. Journal Line");
    var
        LastGenJnlLine : Record "Gen. Journal Line";
        GenJnlLine3 : Record "Gen. Journal Line";
        PrevDocNo : Code[20];
        FirstDocNo : Code[20];
        First : Boolean;
    begin
        FirstDocNo := DocNo;
        WITH GenJnlLine2 DO BEGIN
          SETCURRENTKEY("Journal Template Name","Journal Batch Name","Document No.");
          SETRANGE("Journal Template Name","Journal Template Name");
          SETRANGE("Journal Batch Name","Journal Batch Name");
          LastGenJnlLine.INIT;
          First := TRUE;
          IF FINDSET THEN BEGIN
            REPEAT
              IF "Document No." = FirstDocNo THEN
                EXIT;
              IF NOT First AND (("Document No." <> PrevDocNo) OR ("Bal. Account No." <> '')) AND NOT LastGenJnlLine.EmptyLine THEN
                DocNo := INCSTR(DocNo);
              PrevDocNo := "Document No.";
              IF "Document No." <> '' THEN BEGIN
                IF "Applies-to ID" = "Document No." THEN
                  RenumberAppliesToID(GenJnlLine2,"Document No.",DocNo);
                RenumberAppliesToDocNo(GenJnlLine2,"Document No.",DocNo);
              END;
              GenJnlLine3.GET("Journal Template Name","Journal Batch Name","Line No.");
              GenJnlLine3."Document No." := DocNo;
              GenJnlLine3.MODIFY;
              First := FALSE;
              LastGenJnlLine := GenJnlLine2
            UNTIL NEXT = 0
          END
        END
    end;

    local procedure RenumberAppliesToID(GenJnlLine2 : Record "Gen. Journal Line";OriginalAppliesToID : Code[50];NewAppliesToID : Code[50]);
    var
        CustLedgEntry : Record "Cust. Ledger Entry";
        CustLedgEntry2 : Record "Cust. Ledger Entry";
        VendLedgEntry : Record "Vendor Ledger Entry";
        VendLedgEntry2 : Record "Vendor Ledger Entry";
        AccType : Option;
        AccNo : Code[20];
    begin
        GetAccTypeAndNo(GenJnlLine2,AccType,AccNo);
        CASE AccType OF
          "Account Type"::Customer:
            BEGIN
              CustLedgEntry.SETRANGE("Customer No.",AccNo);
              CustLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
              IF CustLedgEntry.FINDSET THEN
                REPEAT
                  CustLedgEntry2.GET(CustLedgEntry."Entry No.");
                  CustLedgEntry2."Applies-to ID" := NewAppliesToID;
                  CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry2);
                UNTIL CustLedgEntry.NEXT = 0;
            END;
          "Account Type"::Vendor:
            BEGIN
              VendLedgEntry.SETRANGE("Vendor No.",AccNo);
              VendLedgEntry.SETRANGE("Applies-to ID",OriginalAppliesToID);
              IF VendLedgEntry.FINDSET THEN
                REPEAT
                  VendLedgEntry2.GET(VendLedgEntry."Entry No.");
                  VendLedgEntry2."Applies-to ID" := NewAppliesToID;
                  CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry2);
                UNTIL VendLedgEntry.NEXT = 0;
            END;
          ELSE
            EXIT
        END;
        GenJnlLine2."Applies-to ID" := NewAppliesToID;
        GenJnlLine2.MODIFY;
    end;

    local procedure RenumberAppliesToDocNo(GenJnlLine2 : Record "Gen. Journal Line";OriginalAppliesToDocNo : Code[20];NewAppliesToDocNo : Code[20]);
    begin
        GenJnlLine2.RESET;
        GenJnlLine2.SETRANGE("Journal Template Name",GenJnlLine2."Journal Template Name");
        GenJnlLine2.SETRANGE("Journal Batch Name",GenJnlLine2."Journal Batch Name");
        GenJnlLine2.SETRANGE("Applies-to Doc. Type",GenJnlLine2."Document Type");
        GenJnlLine2.SETRANGE("Applies-to Doc. No.",OriginalAppliesToDocNo);
        GenJnlLine2.MODIFYALL("Applies-to Doc. No.",NewAppliesToDocNo);
    end;

    local procedure CheckVATInAlloc();
    begin
        IF "Gen. Posting Type" <> 0 THEN BEGIN
          GenJnlAlloc.RESET;
          GenJnlAlloc.SETRANGE("Journal Template Name","Journal Template Name");
          GenJnlAlloc.SETRANGE("Journal Batch Name","Journal Batch Name");
          GenJnlAlloc.SETRANGE("Journal Line No.","Line No.");
          IF GenJnlAlloc.FIND('-') THEN
            REPEAT
              GenJnlAlloc.CheckVAT(Rec);
            UNTIL GenJnlAlloc.NEXT = 0;
        END;
    end;

    local procedure SetCurrencyCode(AccType2 : Option "G/L Account",Customer,Vendor,"Bank Account";AccNo2 : Code[20]) : Boolean;
    var
        BankAcc : Record "Bank Account";
    begin
        "Currency Code" := '';
        IF AccNo2 <> '' THEN
          IF AccType2 = AccType2::"Bank Account" THEN
            IF BankAcc.GET(AccNo2) THEN
              "Currency Code" := BankAcc."Currency Code";
        EXIT("Currency Code" <> '');
    end;

    procedure SetCurrencyFactor(CurrencyCode : Code[10];CurrencyFactor : Decimal);
    begin
        "Currency Code" := CurrencyCode;
        IF "Currency Code" = '' THEN
          "Currency Factor" := 1
        ELSE
          "Currency Factor" := CurrencyFactor;
    end;

    local procedure GetCurrency();
    begin
        IF "Additional-Currency Posting" =
           "Additional-Currency Posting"::"Additional-Currency Amount Only"
        THEN BEGIN
          IF GLSetup."Additional Reporting Currency" = '' THEN
            ReadGLSetup;
          CurrencyCode := GLSetup."Additional Reporting Currency";
        END ELSE
          CurrencyCode := "Currency Code";

        IF CurrencyCode = '' THEN BEGIN
          CLEAR(Currency);
          Currency.InitRoundingPrecision
        END ELSE
          IF CurrencyCode <> Currency.Code THEN BEGIN
            Currency.GET(CurrencyCode);
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
    end;

    procedure UpdateSource();
    var
        SourceExists1 : Boolean;
        SourceExists2 : Boolean;
    begin
        SourceExists1 := ("Account Type" <> "Account Type"::"G/L Account") AND ("Account No." <> '');
        SourceExists2 := ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND ("Bal. Account No." <> '');
        CASE TRUE OF
          SourceExists1 AND NOT SourceExists2:
            BEGIN
              "Source Type" := "Account Type";
              "Source No." := "Account No.";
            END;
          SourceExists2 AND NOT SourceExists1:
            BEGIN
              "Source Type" := "Bal. Account Type";
              "Source No." := "Bal. Account No.";
            END;
          ELSE BEGIN
            "Source Type" := "Source Type"::" ";
            "Source No." := '';
          END;
        END;
    end;

    local procedure CheckGLAcc(GLAcc : Record "G/L Account");
    begin
        GLAcc.CheckGLAcc;
        IF GLAcc."Direct Posting" OR ("Journal Template Name" = '') OR "System-Created Entry" THEN
          EXIT;
        IF "Posting Date" <> 0D THEN
          IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
            EXIT;
        GLAcc.TESTFIELD("Direct Posting",TRUE);
    end;

    local procedure CheckICPartner(ICPartnerCode : Code[20];AccountType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";AccountNo : Code[20]);
    var
        ICPartner : Record "IC Partner";
    begin
        IF ICPartnerCode <> '' THEN BEGIN
          IF GenJnlTemplate.GET("Journal Template Name") THEN;
          IF (ICPartnerCode <> '') AND ICPartner.GET(ICPartnerCode) THEN BEGIN
            ICPartner.CheckICPartnerIndirect(FORMAT(AccountType),AccountNo);
            "IC Partner Code" := ICPartnerCode;
          END;
        END;
    end;

    procedure GetFAAddCurrExchRate();
    var
        DeprBook : Record "Depreciation Book";
        FADeprBook : Record "FA Depreciation Book";
        FANo : Code[20];
        UseFAAddCurrExchRate : Boolean;
    begin
        "FA Add.-Currency Factor" := 0;
        IF ("FA Posting Type" <> "FA Posting Type"::" ") AND
           ("Depreciation Book Code" <> '')
        THEN BEGIN
          IF "Account Type" = "Account Type"::"Fixed Asset" THEN
            FANo := "Account No.";
          IF "Bal. Account Type" = "Bal. Account Type"::"Fixed Asset" THEN
            FANo := "Bal. Account No.";
          IF FANo <> '' THEN BEGIN
            DeprBook.GET("Depreciation Book Code");
            CASE "FA Posting Type" OF
              "FA Posting Type"::"Acquisition Cost":
                UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate - Acq. Cost";
              "FA Posting Type"::Depreciation:
                UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Depr.";
              "FA Posting Type"::"Write-Down":
                UseFAAddCurrExchRate := DeprBook."Add-Curr Exch Rate -Write-Down";
              "FA Posting Type"::Appreciation:
                UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch. Rate - Apprec.";
              "FA Posting Type"::"Custom 1":
                UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 1";
              "FA Posting Type"::"Custom 2":
                UseFAAddCurrExchRate := DeprBook."Add-Curr. Exch Rate - Custom 2";
              "FA Posting Type"::Disposal:
                UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Disp.";
              "FA Posting Type"::Maintenance:
                UseFAAddCurrExchRate := DeprBook."Add.-Curr. Exch. Rate - Maint.";
            END;
            IF UseFAAddCurrExchRate THEN BEGIN
              FADeprBook.GET(FANo,"Depreciation Book Code");
              FADeprBook.TESTFIELD("FA Add.-Currency Factor");
              "FA Add.-Currency Factor" := FADeprBook."FA Add.-Currency Factor";
            END;
          END;
        END;
    end;

    procedure GetShowCurrencyCode(CurrencyCode : Code[10]) : Code[10];
    begin
        IF CurrencyCode <> '' THEN
          EXIT(CurrencyCode);

        EXIT(Text009);
    end;

    procedure ClearCustVendApplnEntry();
    var
        TempCustLedgEntry : Record "Cust. Ledger Entry" temporary;
        TempVendLedgEntry : Record "Vendor Ledger Entry" temporary;
        AccType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo : Code[20];
    begin
        GetAccTypeAndNo(Rec,AccType,AccNo);
        CASE AccType OF
          AccType::Customer:
            IF xRec."Applies-to ID" <> '' THEN BEGIN
              IF FindFirstCustLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") THEN BEGIN
                ClearCustApplnEntryFields;
                TempCustLedgEntry.DELETEALL;
                CustEntrySetApplID.SetApplId(CustLedgEntry,TempCustLedgEntry,'');
              END
            END ELSE
              IF xRec."Applies-to Doc. No." <> '' THEN
                IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") THEN BEGIN
                  ClearCustApplnEntryFields;
                  CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
                END;
          AccType::Vendor:
            IF xRec."Applies-to ID" <> '' THEN BEGIN
              IF FindFirstVendLedgEntryWithAppliesToID(AccNo,xRec."Applies-to ID") THEN BEGIN
                ClearVendApplnEntryFields;
                TempVendLedgEntry.DELETEALL;
                VendEntrySetApplID.SetApplId(VendLedgEntry,TempVendLedgEntry,'');
              END
            END ELSE
              IF xRec."Applies-to Doc. No." <> '' THEN
                IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,xRec."Applies-to Doc. No.") THEN BEGIN
                  ClearVendApplnEntryFields;
                  CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
                END;
        END;
        IF "Document Date" = 0D THEN
          DocDate := 0D
        ELSE
          DocDate := "Document Date";
        ReadGLSetup;
        IF GLSetup.GSTEnabled(DocDate) THEN
          CASE AccType OF
            AccType::Customer:
              IF CustLedgEntry.GET("Adjmt. Entry No.") THEN
                BASManagement.CustLedgEntryReplReasonCodes(CustLedgEntry);
            AccType::Vendor:
              IF VendLedgEntry.GET("Adjmt. Entry No.") THEN
                BASManagement.VendLedgEntryReplReasonCodes(VendLedgEntry);
          END;
    end;

    local procedure ClearCustApplnEntryFields();
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields();
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := FALSE;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    procedure CheckFixedCurrency() : Boolean;
    var
        CurrExchRate : Record "Currency Exchange Rate";
    begin
        CurrExchRate.SETRANGE("Currency Code","Currency Code");
        CurrExchRate.SETRANGE("Starting Date",0D,"Posting Date");

        IF NOT CurrExchRate.FINDLAST THEN
          EXIT(FALSE);

        IF CurrExchRate."Relational Currency Code" = '' THEN
          EXIT(
            CurrExchRate."Fix Exchange Rate Amount" =
            CurrExchRate."Fix Exchange Rate Amount"::Both);

        IF CurrExchRate."Fix Exchange Rate Amount" <>
           CurrExchRate."Fix Exchange Rate Amount"::Both
        THEN
          EXIT(FALSE);

        CurrExchRate.SETRANGE("Currency Code",CurrExchRate."Relational Currency Code");
        IF CurrExchRate.FINDLAST THEN
          EXIT(
            CurrExchRate."Fix Exchange Rate Amount" =
            CurrExchRate."Fix Exchange Rate Amount"::Both);

        EXIT(FALSE);
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20];Type2 : Integer;No2 : Code[20];Type3 : Integer;No3 : Code[20];Type4 : Integer;No4 : Code[20];Type5 : Integer;No5 : Code[20]);
    var
        TableID : array [10] of Integer;
        No : array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,"Source Code","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        TESTFIELD("Check Printed",FALSE);
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        TESTFIELD("Check Printed",FALSE);
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode : array [8] of Code[20]);
    begin
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        ShortcutDimCode[1] := "Shortcut Dimension 1 Code";
        ShortcutDimCode[2] := "Shortcut Dimension 2 Code";
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Journal Template Name","Journal Batch Name","Line No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure GetFAVATSetup();
    var
        LocalGlAcc : Record "G/L Account";
        FAPostingGr : Record "FA Posting Group";
        FABalAcc : Boolean;
    begin
        IF CurrFieldNo = 0 THEN
          EXIT;
        IF ("Account Type" <> "Account Type"::"Fixed Asset") AND
           ("Bal. Account Type" <> "Bal. Account Type"::"Fixed Asset")
        THEN
          EXIT;
        FABalAcc := ("Bal. Account Type" = "Bal. Account Type"::"Fixed Asset");
        IF NOT FABalAcc THEN BEGIN
          ClearPostingGroups;
          "Tax Group Code" := '';
        END;
        IF FABalAcc THEN BEGIN
          ClearBalancePostingGroups;
          "Bal. Tax Group Code" := '';
        END;
        IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
           GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        THEN
          IF (("FA Posting Type" = "FA Posting Type"::"Acquisition Cost") OR
              ("FA Posting Type" = "FA Posting Type"::Disposal) OR
              ("FA Posting Type" = "FA Posting Type"::Maintenance)) AND
             ("Posting Group" <> '')
          THEN
            IF FAPostingGr.GET("Posting Group") THEN BEGIN
              IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN BEGIN
                FAPostingGr.TESTFIELD("Acquisition Cost Account");
                LocalGlAcc.GET(FAPostingGr."Acquisition Cost Account");
              END;
              IF "FA Posting Type" = "FA Posting Type"::Disposal THEN BEGIN
                FAPostingGr.TESTFIELD("Acq. Cost Acc. on Disposal");
                LocalGlAcc.GET(FAPostingGr."Acq. Cost Acc. on Disposal");
              END;
              IF "FA Posting Type" = "FA Posting Type"::Maintenance THEN BEGIN
                FAPostingGr.TESTFIELD("Maintenance Expense Account");
                LocalGlAcc.GET(FAPostingGr."Maintenance Expense Account");
              END;
              LocalGlAcc.CheckGLAcc;
              IF NOT FABalAcc THEN BEGIN
                "Gen. Posting Type" := LocalGlAcc."Gen. Posting Type";
                "Gen. Bus. Posting Group" := LocalGlAcc."Gen. Bus. Posting Group";
                "Gen. Prod. Posting Group" := LocalGlAcc."Gen. Prod. Posting Group";
                "VAT Bus. Posting Group" := LocalGlAcc."VAT Bus. Posting Group";
                "VAT Prod. Posting Group" := LocalGlAcc."VAT Prod. Posting Group";
                "Tax Group Code" := LocalGlAcc."Tax Group Code";
              END ELSE BEGIN;
                "Bal. Gen. Posting Type" := LocalGlAcc."Gen. Posting Type";
                "Bal. Gen. Bus. Posting Group" := LocalGlAcc."Gen. Bus. Posting Group";
                "Bal. Gen. Prod. Posting Group" := LocalGlAcc."Gen. Prod. Posting Group";
                "Bal. VAT Bus. Posting Group" := LocalGlAcc."VAT Bus. Posting Group";
                "Bal. VAT Prod. Posting Group" := LocalGlAcc."VAT Prod. Posting Group";
                "Bal. Tax Group Code" := LocalGlAcc."Tax Group Code";
              END;
            END;
    end;

    local procedure GetFADeprBook();
    var
        FASetup : Record "FA Setup";
        FADeprBook : Record "FA Depreciation Book";
        DefaultFADeprBook : Record "FA Depreciation Book";
    begin
        IF "Depreciation Book Code" = '' THEN BEGIN
          FASetup.GET;

          DefaultFADeprBook.SETRANGE("FA No.","Account No.");
          DefaultFADeprBook.SETRANGE("Default FA Depreciation Book",TRUE);

          CASE TRUE OF
            DefaultFADeprBook.FINDFIRST:
              "Depreciation Book Code" := DefaultFADeprBook."Depreciation Book Code";
            FADeprBook.GET("Account No.",FASetup."Default Depr. Book"):
              "Depreciation Book Code" := FASetup."Default Depr. Book";
            ELSE
              "Depreciation Book Code" := '';
          END;
        END;

        IF "Depreciation Book Code" <> '' THEN BEGIN
          FADeprBook.GET("Account No.","Depreciation Book Code");
          "Posting Group" := FADeprBook."FA Posting Group";
        END;
    end;

    procedure GetTemplate();
    begin
        IF NOT TemplateFound THEN
          GenJnlTemplate.GET("Journal Template Name");
        TemplateFound := TRUE;
    end;

    local procedure UpdateSalesPurchLCY();
    begin
        "Sales/Purch. (LCY)" := 0;
        IF (NOT "System-Created Entry") AND ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) THEN BEGIN
          IF ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) AND ("Bal. Account No." <> '') THEN
            "Sales/Purch. (LCY)" := "Amount (LCY)" + "Bal. VAT Amount (LCY)";
          IF ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) AND ("Account No." <> '') THEN
            "Sales/Purch. (LCY)" := -("Amount (LCY)" - "VAT Amount (LCY)");
        END;
    end;

    procedure LookUpAppliesToDocCust(AccNo : Code[20]);
    var
        ApplyCustEntries : Page "Apply Customer Entries";
    begin
        CLEAR(CustLedgEntry);
        CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF CustLedgEntry.ISEMPTY THEN BEGIN
            CustLedgEntry.SETRANGE("Document Type");
            CustLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE("Document Type");
        END;
        IF Amount <> 0 THEN BEGIN
          CustLedgEntry.SETRANGE(Positive,Amount < 0);
          IF CustLedgEntry.ISEMPTY THEN
            CustLedgEntry.SETRANGE(Positive);
        END;
        ApplyCustEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
        ApplyCustEntries.SETRECORD(CustLedgEntry);
        ApplyCustEntries.LOOKUPMODE(TRUE);
        IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyCustEntries.GETRECORD(CustLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := CustLedgEntry."Customer No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          SetAmountWithCustLedgEntry;
          "Applies-to Doc. Type" := CustLedgEntry."Document Type";
          "Applies-to Doc. No." := CustLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
    end;

    procedure LookUpAppliesToDocVend(AccNo : Code[20]);
    var
        ApplyVendEntries : Page "Apply Vendor Entries";
    begin
        CLEAR(VendLedgEntry);
        VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
        IF AccNo <> '' THEN
          VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN BEGIN
            VendLedgEntry.SETRANGE("Document Type");
            VendLedgEntry.SETRANGE("Document No.");
          END;
        END;
        IF "Applies-to ID" <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Applies-to ID");
        END;
        IF "Applies-to Doc. Type" <> "Applies-to Doc. Type"::" " THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document Type");
        END;
        IF  "Applies-to Doc. No." <> ''THEN BEGIN
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.ISEMPTY THEN
            VendLedgEntry.SETRANGE("Document No.");
        END;
        IF Amount <> 0 THEN BEGIN
          VendLedgEntry.SETRANGE(Positive,Amount < 0);
          IF VendLedgEntry.ISEMPTY THEN;
          VendLedgEntry.SETRANGE(Positive);
        END;
        ApplyVendEntries.SetGenJnlLine(Rec,GenJnlLine.FIELDNO("Applies-to Doc. No."));
        ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
        ApplyVendEntries.SETRECORD(VendLedgEntry);
        ApplyVendEntries.LOOKUPMODE(TRUE);
        IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
          ApplyVendEntries.GETRECORD(VendLedgEntry);
          IF AccNo = '' THEN BEGIN
            AccNo := VendLedgEntry."Vendor No.";
            IF "Bal. Account Type" = "Bal. Account Type"::Vendor THEN
              VALIDATE("Bal. Account No.",AccNo)
            ELSE
              VALIDATE("Account No.",AccNo);
          END;
          SetAmountWithVendLedgEntry;
          "Applies-to Doc. Type" := VendLedgEntry."Document Type";
          "Applies-to Doc. No." := VendLedgEntry."Document No.";
          "Applies-to ID" := '';
        END;
    end;

    procedure SetApplyToAmount();
    begin
        IF "Account Type" = "Account Type"::Customer THEN BEGIN
          CustLedgEntry.SETCURRENTKEY("Document No.");
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          CustLedgEntry.SETRANGE("Customer No.","Account No.");
          CustLedgEntry.SETRANGE(Open,TRUE);
          IF CustLedgEntry.FIND('-') THEN
            IF CustLedgEntry."Amount to Apply" = 0 THEN BEGIN
              CustLedgEntry.CALCFIELDS("Remaining Amount");
              CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
              CODEUNIT.RUN(CODEUNIT::"Cust. Entry-Edit",CustLedgEntry);
            END;
        END ELSE
          IF "Account Type" = "Account Type"::Vendor THEN BEGIN
            VendLedgEntry.SETCURRENTKEY("Document No.");
            VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
            VendLedgEntry.SETRANGE("Vendor No.","Account No.");
            VendLedgEntry.SETRANGE(Open,TRUE);
            IF VendLedgEntry.FIND('-') THEN
              IF VendLedgEntry."Amount to Apply" = 0 THEN  BEGIN
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                CODEUNIT.RUN(CODEUNIT::"Vend. Entry-Edit",VendLedgEntry);
              END;
          END;
    end;

    procedure ValidateApplyRequirements(TempGenJnlLine : Record "Gen. Journal Line" temporary);
    begin
        IF (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Customer) OR
           (TempGenJnlLine."Bal. Account Type" = TempGenJnlLine."Bal. Account Type"::Vendor)
        THEN
          CODEUNIT.RUN(CODEUNIT::"Exchange Acc. G/L Journal Line",TempGenJnlLine);

        IF TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Customer THEN BEGIN
          IF TempGenJnlLine."Applies-to ID" <> '' THEN BEGIN
            CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
            CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
            CustLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
            CustLedgEntry.SETRANGE(Open,TRUE);
            IF CustLedgEntry.FIND('-') THEN
              REPEAT
                IF TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    CustLedgEntry."Document Type",CustLedgEntry."Document No.");
              UNTIL CustLedgEntry.NEXT = 0;
          END ELSE
            IF TempGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
              CustLedgEntry.SETCURRENTKEY("Document No.");
              CustLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
              IF TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " THEN
                CustLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
              CustLedgEntry.SETRANGE("Customer No.",TempGenJnlLine."Account No.");
              CustLedgEntry.SETRANGE(Open,TRUE);
              IF CustLedgEntry.FIND('-') THEN
                IF TempGenJnlLine."Posting Date" < CustLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    CustLedgEntry."Document Type",CustLedgEntry."Document No.");
            END;
        END ELSE
          IF TempGenJnlLine."Account Type" = TempGenJnlLine."Account Type"::Vendor THEN
            IF TempGenJnlLine."Applies-to ID" <> '' THEN BEGIN
              VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
              VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
              VendLedgEntry.SETRANGE("Applies-to ID",TempGenJnlLine."Applies-to ID");
              VendLedgEntry.SETRANGE(Open,TRUE);
              REPEAT
                IF TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" THEN
                  ERROR(
                    Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                    VendLedgEntry."Document Type",VendLedgEntry."Document No.");
              UNTIL VendLedgEntry.NEXT = 0;
              IF VendLedgEntry.FIND('-') THEN
                ;
            END ELSE
              IF TempGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                VendLedgEntry.SETCURRENTKEY("Document No.");
                VendLedgEntry.SETRANGE("Document No.",TempGenJnlLine."Applies-to Doc. No.");
                IF TempGenJnlLine."Applies-to Doc. Type" <> TempGenJnlLine."Applies-to Doc. Type"::" " THEN
                  VendLedgEntry.SETRANGE("Document Type",TempGenJnlLine."Applies-to Doc. Type");
                VendLedgEntry.SETRANGE("Vendor No.",TempGenJnlLine."Account No.");
                VendLedgEntry.SETRANGE(Open,TRUE);
                IF VendLedgEntry.FIND('-') THEN
                  IF TempGenJnlLine."Posting Date" < VendLedgEntry."Posting Date" THEN
                    ERROR(
                      Text015,TempGenJnlLine."Document Type",TempGenJnlLine."Document No.",
                      VendLedgEntry."Document Type",VendLedgEntry."Document No.");
              END;
    end;

    local procedure UpdateCountryCodeAndVATRegNo(No : Code[20]);
    var
        Cust : Record Customer;
        Vend : Record Vendor;
    begin
        IF No = '' THEN BEGIN
          "Country/Region Code" := '';
          "VAT Registration No." := '';
          EXIT;
        END;

        ReadGLSetup;
        CASE TRUE OF
          ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer):
            BEGIN
              Cust.GET(No);
              "Country/Region Code" := Cust."Country/Region Code";
              "VAT Registration No." := Cust."VAT Registration No.";
            END;
          ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor):
            BEGIN
              Vend.GET(No);
              "Country/Region Code" := Vend."Country/Region Code";
              "VAT Registration No." := Vend."VAT Registration No.";
            END;
        END;
    end;

    procedure JobTaskIsSet() : Boolean;
    begin
        EXIT(("Job No." <> '') AND ("Job Task No." <> '') AND ("Account Type" = "Account Type"::"G/L Account"));
    end;

    procedure CreateTempJobJnlLine();
    var
        TmpJobJnlOverallCurrencyFactor : Decimal;
    begin
        TESTFIELD("Posting Date");
        CLEAR(TempJobJnlLine);
        TempJobJnlLine.DontCheckStdCost;
        TempJobJnlLine.VALIDATE("Job No.","Job No.");
        TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
        IF CurrFieldNo <> FIELDNO("Posting Date") THEN
          TempJobJnlLine.VALIDATE("Posting Date","Posting Date")
        ELSE
          TempJobJnlLine.VALIDATE("Posting Date",xRec."Posting Date");
        TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account");
        IF "Job Currency Code" <> '' THEN BEGIN
          IF "Posting Date" = 0D THEN
            CurrencyDate := WORKDATE
          ELSE
            CurrencyDate := "Posting Date";

          IF "Currency Code" = "Job Currency Code" THEN
            "Job Currency Factor" := "Currency Factor"
          ELSE
            "Job Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Job Currency Code");
          TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
        END;
        TempJobJnlLine.VALIDATE("No.","Account No.");
        TempJobJnlLine.VALIDATE(Quantity,"Job Quantity");

        IF "Currency Factor" = 0 THEN BEGIN
          IF "Job Currency Factor" = 0 THEN
            TmpJobJnlOverallCurrencyFactor := 1
          ELSE
            TmpJobJnlOverallCurrencyFactor := "Job Currency Factor";
        END ELSE BEGIN
          IF "Job Currency Factor" = 0 THEN
            TmpJobJnlOverallCurrencyFactor := 1 / "Currency Factor"
          ELSE
            TmpJobJnlOverallCurrencyFactor := "Job Currency Factor" / "Currency Factor"
        END;

        IF "Job Quantity" <> 0 THEN
          TempJobJnlLine.VALIDATE("Unit Cost",((Amount - "VAT Amount") * TmpJobJnlOverallCurrencyFactor) / "Job Quantity");

        IF (xRec."Account No." = "Account No.") AND (xRec."Job Task No." = "Job Task No.") AND ("Job Unit Price" <> 0) THEN BEGIN
          IF TempJobJnlLine."Cost Factor" = 0 THEN
            TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
          TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
          TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
          TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
          TempJobJnlLine.VALIDATE("Unit Price");
        END;
    end;

    procedure UpdatePricesFromJobJnlLine();
    begin
        "Job Unit Price" := TempJobJnlLine."Unit Price";
        "Job Total Price" := TempJobJnlLine."Total Price";
        "Job Line Amount" := TempJobJnlLine."Line Amount";
        "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
        "Job Unit Cost" := TempJobJnlLine."Unit Cost";
        "Job Total Cost" := TempJobJnlLine."Total Cost";
        "Job Line Discount %" := TempJobJnlLine."Line Discount %";

        "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
        "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
        "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
        "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
        "Job Unit Cost (LCY)" := TempJobJnlLine."Unit Cost (LCY)";
        "Job Total Cost (LCY)" := TempJobJnlLine."Total Cost (LCY)";
    end;

    procedure SetHideValidation(NewHideValidationDialog : Boolean);
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure GetDefaultICPartnerGLAccNo() : Code[20];
    var
        GLAcc : Record "G/L Account";
        GLAccNo : Code[20];
    begin
        IF "IC Partner Code" <> '' THEN BEGIN
          IF "Account Type" = "Account Type"::"G/L Account" THEN
            GLAccNo := "Account No."
          ELSE
            GLAccNo := "Bal. Account No.";
          IF GLAcc.GET(GLAccNo) THEN
            EXIT(GLAcc."Default IC Partner G/L Acc. No")
        END;
    end;

    procedure IsApplied() : Boolean;
    begin
        IF "Applies-to Doc. No." <> '' THEN
          EXIT(TRUE);
        IF "Applies-to ID" <> '' THEN
          EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure DataCaption() : Text[250];
    var
        GenJnlBatch : Record "Gen. Journal Batch";
    begin
        IF GenJnlBatch.GET("Journal Template Name","Journal Batch Name") THEN
          EXIT(GenJnlBatch.Name + '-' + GenJnlBatch.Description);
    end;

    local procedure ReadGLSetup();
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
        END;
    end;

    procedure ValidateAdjmtAppliesTo();
    begin
        CASE TRUE OF
          "Account Type" = "Account Type"::Customer, "Bal. Account Type" = "Bal. Account Type"::Customer:
            BEGIN
              CustLedgEntry.RESET;
              CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
              IF "Account Type" = "Account Type"::Customer THEN
                CustLedgEntry.SETRANGE("Customer No.","Account No.")
              ELSE
                CustLedgEntry.SETRANGE("Customer No.","Bal. Account No.");
              IF "Applies-to Doc. No." <> '' THEN BEGIN
                CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                IF CustLedgEntry.FIND('-') THEN;
                CustLedgEntry.SETRANGE("Document Type");
                CustLedgEntry.SETRANGE("Document No.");
              END ELSE
                IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                  CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  IF CustLedgEntry.FIND('-') THEN;
                  CustLedgEntry.SETRANGE("Document Type");
                END ELSE
                  IF Amount <> 0 THEN BEGIN
                    IF "Account Type" = "Account Type"::Customer THEN
                      CustLedgEntry.SETRANGE(Positive,Amount < 0)
                    ELSE
                      CustLedgEntry.SETRANGE(Positive,-Amount < 0);
                    IF CustLedgEntry.FIND('-') THEN;
                    CustLedgEntry.SETRANGE(Positive);
                  END;
              CustLedgEntry.SETRANGE("Document No.","Adjustment Applies-to");
              IF CustLedgEntry.FIND('+') THEN BEGIN
                "Adjustment Applies-to" := CustLedgEntry."Document No.";
                IF ("Applies-to Doc. No." <> "Adjustment Applies-to") AND
                   ("Applies-to Doc. No." <> '')
                THEN
                  ERROR(
                    Text1500001,
                    FIELDNAME("Applies-to Doc. No."),FIELDNAME("Adjustment Applies-to"));
                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                "BAS Adjustment" := BASManagement.CheckBASPeriod("Document Date",CustLedgEntry."Document Date");
              END ELSE
                "BAS Adjustment" := FALSE;
            END;
          "Account Type" = "Account Type"::Vendor, "Bal. Account Type" = "Bal. Account Type"::Vendor:
            BEGIN
              VendLedgEntry.RESET;
              VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
              IF "Account Type" = "Account Type"::Vendor THEN
                VendLedgEntry.SETRANGE("Vendor No.","Account No.")
              ELSE
                VendLedgEntry.SETRANGE("Vendor No.","Bal. Account No.");
              IF "Applies-to Doc. No." <> '' THEN BEGIN
                VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                IF VendLedgEntry.FIND('-') THEN;
                VendLedgEntry.SETRANGE("Document Type");
                VendLedgEntry.SETRANGE("Document No.");
              END ELSE
                IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                  VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  IF VendLedgEntry.FIND('-') THEN;
                  VendLedgEntry.SETRANGE("Document Type");
                END ELSE
                  IF Amount <> 0 THEN BEGIN
                    IF "Account Type" = "Account Type"::Vendor THEN
                      VendLedgEntry.SETRANGE(Positive,Amount < 0)
                    ELSE
                      VendLedgEntry.SETRANGE(Positive,-Amount < 0);
                    IF VendLedgEntry.FIND('-') THEN;
                    VendLedgEntry.SETRANGE(Positive);
                  END;
              VendLedgEntry.SETRANGE("Document No.","Adjustment Applies-to");
              IF VendLedgEntry.FIND('+') THEN BEGIN
                "Adjustment Applies-to" := VendLedgEntry."Document No.";
                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                "BAS Adjustment" := BASManagement.CheckBASPeriod("Document Date",VendLedgEntry."Document Date");
              END ELSE
                "BAS Adjustment" := FALSE;
            END;
        END;
    end;

    procedure CheckAdjustmentAppliesto();
    var
        SourceCodeSetup : Record "Source Code Setup";
        GenJournalLine2 : Record "Gen. Journal Line";
    begin
        ReadGLSetup;
        SourceCodeSetup.GET;
        WITH GenJournalLine2 DO BEGIN
          IF GLSetup."Adjustment Mandatory" THEN BEGIN
            SETRANGE("Journal Template Name",Rec."Journal Template Name");
            SETRANGE("Journal Batch Name",Rec."Journal Batch Name");
            SETFILTER("Document Type",'%1|%2',"Document Type"::"Credit Memo","Document Type"::Refund);
            IF FINDSET THEN
              REPEAT
                IF GLSetup.GSTEnabled("Document Date") AND
                   (("Account Type" IN ["Account Type"::Vendor,"Account Type"::Customer]) OR
                    ("Bal. Account Type" IN ["Bal. Account Type"::Vendor,"Bal. Account Type"::Customer]))
                THEN
                  IF ("Source Code" <> SourceCodeSetup."Service Management") AND ("Adjustment Applies-to" = '') THEN
                    IF NOT CONFIRM(Text020) THEN
                      ERROR(Text021);
              UNTIL NEXT = 0;
          END;
        END;
    end;

    procedure GetCustLedgerEntry();
    begin
        IF ("Account Type" = "Account Type"::Customer) AND ("Account No." = '') AND
           ("Applies-to Doc. No." <> '') AND (Amount = 0)
        THEN BEGIN
          CustLedgEntry.RESET;
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          CustLedgEntry.SETRANGE(Open,TRUE);
          IF NOT CustLedgEntry.FINDFIRST THEN
            ERROR(NotExistErr,"Applies-to Doc. No.");

          VALIDATE("Account No.",CustLedgEntry."Customer No.");
          CustLedgEntry.CALCFIELDS("Remaining Amount");

          IF "Posting Date" <= CustLedgEntry."Pmt. Discount Date" THEN
            Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
          ELSE
            Amount := -CustLedgEntry."Remaining Amount";

          IF "Currency Code" <> CustLedgEntry."Currency Code" THEN BEGIN
            FromCurrencyCode := GetShowCurrencyCode("Currency Code");
            ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
            IF NOT
               CONFIRM(
                 Text003,TRUE,
                 FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,
                 ToCurrencyCode)
            THEN
              ERROR(Text005);
            VALIDATE("Currency Code",CustLedgEntry."Currency Code");
          END;

          "Document Type" := "Document Type"::Payment;
          "Applies-to Doc. Type" := CustLedgEntry."Document Type";
          "Applies-to Doc. No." := CustLedgEntry."Document No.";
          "Applies-to ID" := '';
          IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) AND
             ("Document Type" = "Document Type"::Payment)
          THEN
            "External Document No." := CustLedgEntry."External Document No.";
          "Bal. Account Type" := "Bal. Account Type"::"G/L Account";

          GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
          IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
            "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
          END ELSE
            VALIDATE(Amount);
        END;
    end;

    procedure GetVendLedgerEntry();
    begin
        IF ("Account Type" = "Account Type"::Vendor) AND ("Account No." = '') AND
           ("Applies-to Doc. No." <> '') AND (Amount = 0)
        THEN BEGIN
          VendLedgEntry.RESET;
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          VendLedgEntry.SETRANGE(Open,TRUE);
          IF NOT VendLedgEntry.FINDFIRST THEN
            ERROR(NotExistErr,"Applies-to Doc. No.");

          VALIDATE("Account No.",VendLedgEntry."Vendor No.");
          VendLedgEntry.CALCFIELDS("Remaining Amount");

          IF "Posting Date" <= VendLedgEntry."Pmt. Discount Date" THEN
            Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
          ELSE
            Amount := -VendLedgEntry."Remaining Amount";

          IF "Currency Code" <> VendLedgEntry."Currency Code" THEN BEGIN
            FromCurrencyCode := GetShowCurrencyCode("Currency Code");
            ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
            IF NOT
               CONFIRM(
                 Text003,
                 TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
            THEN
              ERROR(Text005);
            VALIDATE("Currency Code",VendLedgEntry."Currency Code");
          END;

          "Document Type" := "Document Type"::Payment;
          "Applies-to Doc. Type" := VendLedgEntry."Document Type";
          "Applies-to Doc. No." := VendLedgEntry."Document No.";
          "Applies-to ID" := '';
          IF ("Applies-to Doc. Type" = "Applies-to Doc. Type"::Invoice) AND
             ("Document Type" = "Document Type"::Payment)
          THEN
            "External Document No." := VendLedgEntry."External Document No.";
          "Bal. Account Type" := "Bal. Account Type"::"G/L Account";

          GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
          IF GenJnlBatch."Bal. Account No." <> '' THEN BEGIN
            "Bal. Account Type" := GenJnlBatch."Bal. Account Type";
            VALIDATE("Bal. Account No.",GenJnlBatch."Bal. Account No.");
          END ELSE
            VALIDATE(Amount);
        END;
    end;

    local procedure CustVendAccountNosModified() : Boolean;
    begin
        EXIT(
          (("Bal. Account No." <> xRec."Bal. Account No.") AND
           ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor])) OR
          (("Account No." <> xRec."Account No.") AND
           ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor])))
    end;

    local procedure CheckPaymentTolerance();
    begin
        IF Amount <> 0 THEN
          IF ("Bal. Account No." <> xRec."Bal. Account No.") OR ("Account No." <> xRec."Account No.") THEN
            PaymentToleranceMgt.PmtTolGenJnl(Rec);
    end;

    procedure IncludeVATAmount() : Boolean;
    begin
        EXIT(
          ("VAT Posting" = "VAT Posting"::"Manual VAT Entry") AND
          ("VAT Calculation Type" <> "VAT Calculation Type"::"Reverse Charge VAT"));
    end;

    procedure ConvertAmtFCYToLCYForSourceCurrency(Amount : Decimal) : Decimal;
    var
        Currency : Record Currency;
        CurrExchRate : Record "Currency Exchange Rate";
        CurrencyFactor : Decimal;
    begin
        IF (Amount = 0) OR ("Source Currency Code" = '') THEN
          EXIT(Amount);

        Currency.GET("Source Currency Code");
        CurrencyFactor := CurrExchRate.ExchangeRate("Posting Date","Source Currency Code");
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              "Posting Date","Source Currency Code",Amount,CurrencyFactor),
            Currency."Amount Rounding Precision"));
    end;

    procedure MatchSingleLedgerEntry();
    begin
        CODEUNIT.RUN(CODEUNIT::"Match General Journal Lines",Rec);
    end;

    procedure GetStyle() : Text;
    begin
        IF "Applied Automatically" THEN
          EXIT('Favorable')
    end;

    procedure GetOverdueDateInteractions(var OverdueWarningText : Text) : Text;
    var
        DueDate : Date;
    begin
        DueDate := GetAppliesToDocDueDate;
        OverdueWarningText := '';
        IF (DueDate <> 0D) AND (DueDate < "Posting Date") THEN BEGIN
          OverdueWarningText := DueDateMsg;
          EXIT('Unfavorable');
        END;
        EXIT('');
    end;

    procedure ClearDataExchangeEntries(DeleteHeaderEntries : Boolean);
    var
        DataExchField : Record "Data Exch. Field";
        GenJournalLine : Record "Gen. Journal Line";
    begin
        DataExchField.DeleteRelatedRecords("Data Exch. Entry No.","Data Exch. Line No.");

        GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJournalLine.SETRANGE("Data Exch. Entry No.","Data Exch. Entry No.");
        GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
        IF GenJournalLine.ISEMPTY OR DeleteHeaderEntries THEN
          DataExchField.DeleteRelatedRecords("Data Exch. Entry No.",0);
    end;

    procedure ClearAppliedGenJnlLine();
    var
        GenJournalLine : Record "Gen. Journal Line";
    begin
        IF "Applies-to Doc. No." = '' THEN
          EXIT;
        GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        GenJournalLine.SETFILTER("Line No.",'<>%1',"Line No.");
        GenJournalLine.SETRANGE("Document Type","Applies-to Doc. Type");
        GenJournalLine.SETRANGE("Document No.","Applies-to Doc. No.");
        GenJournalLine.MODIFYALL("Applied Automatically",FALSE);
        GenJournalLine.MODIFYALL("Account Type",GenJournalLine."Account Type"::"G/L Account");
        GenJournalLine.MODIFYALL("Account No.",'');
    end;

    procedure GetIncomingDocumentURL() : Text[1000];
    var
        IncomingDocument : Record "Incoming Document";
    begin
        IF "Incoming Document Entry No." = 0 THEN
          EXIT('');

        IncomingDocument.GET("Incoming Document Entry No.");
        EXIT(IncomingDocument.GetURL);
    end;

    procedure InsertPaymentFileError(Text : Text);
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        PaymentJnlExportErrorText.CreateNew(Rec,Text,'','');
    end;

    procedure InsertPaymentFileErrorWithDetails(ErrorText : Text;AddnlInfo : Text;ExtSupportInfo : Text);
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        PaymentJnlExportErrorText.CreateNew(Rec,ErrorText,AddnlInfo,ExtSupportInfo);
    end;

    procedure DeletePaymentFileBatchErrors();
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        PaymentJnlExportErrorText.DeleteJnlBatchErrors(Rec);
    end;

    procedure DeletePaymentFileErrors();
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        PaymentJnlExportErrorText.DeleteJnlLineErrors(Rec);
    end;

    procedure HasPaymentFileErrors() : Boolean;
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        EXIT(PaymentJnlExportErrorText.JnlLineHasErrors(Rec));
    end;

    procedure HasPaymentFileErrorsInBatch() : Boolean;
    var
        PaymentJnlExportErrorText : Record "Payment Jnl. Export Error Text";
    begin
        EXIT(PaymentJnlExportErrorText.JnlBatchHasErrors(Rec));
    end;

    local procedure UpdateDescription(Name : Text[50]);
    begin
        IF NOT IsAdHocDescription THEN
          Description := Name;
    end;

    local procedure IsAdHocDescription() : Boolean;
    var
        GLAccount : Record "G/L Account";
        Customer : Record Customer;
        Vendor : Record Vendor;
        BankAccount : Record "Bank Account";
        FixedAsset : Record "Fixed Asset";
        ICPartner : Record "IC Partner";
    begin
        IF Description = '' THEN
          EXIT(FALSE);
        IF xRec."Account No." = '' THEN
          EXIT(TRUE);

        CASE xRec."Account Type" OF
          xRec."Account Type"::"G/L Account":
            EXIT(GLAccount.GET(xRec."Account No.") AND (GLAccount.Name <> Description));
          xRec."Account Type"::Customer:
            EXIT(Customer.GET(xRec."Account No.") AND (Customer.Name <> Description));
          xRec."Account Type"::Vendor:
            EXIT(Vendor.GET(xRec."Account No.") AND (Vendor.Name <> Description));
          xRec."Account Type"::"Bank Account":
            EXIT(BankAccount.GET(xRec."Account No.") AND (BankAccount.Name <> Description));
          xRec."Account Type"::"Fixed Asset":
            EXIT(FixedAsset.GET(xRec."Account No.") AND (FixedAsset.Description <> Description));
          xRec."Account Type"::"IC Partner":
            EXIT(ICPartner.GET(xRec."Account No.") AND (ICPartner.Name <> Description));
        END;
        EXIT(FALSE);
    end;

    procedure GetAppliesToDocEntryNo() : Integer;
    var
        CustLedgEntry : Record "Cust. Ledger Entry";
        VendLedgEntry : Record "Vendor Ledger Entry";
        AccType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo : Code[20];
    begin
        GetAccTypeAndNo(Rec,AccType,AccNo);
        CASE AccType OF
          AccType::Customer:
            BEGIN
              GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
              EXIT(CustLedgEntry."Entry No.");
            END;
          AccType::Vendor:
            BEGIN
              GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
              EXIT(VendLedgEntry."Entry No.");
            END;
        END;
    end;

    procedure GetAppliesToDocDueDate() : Date;
    var
        CustLedgEntry : Record "Cust. Ledger Entry";
        VendLedgEntry : Record "Vendor Ledger Entry";
        AccType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo : Code[20];
    begin
        GetAccTypeAndNo(Rec,AccType,AccNo);
        CASE AccType OF
          AccType::Customer:
            BEGIN
              GetAppliesToDocCustLedgEntry(CustLedgEntry,AccNo);
              EXIT(CustLedgEntry."Due Date");
            END;
          AccType::Vendor:
            BEGIN
              GetAppliesToDocVendLedgEntry(VendLedgEntry,AccNo);
              EXIT(VendLedgEntry."Due Date");
            END;
        END;
    end;

    local procedure GetAppliesToDocCustLedgEntry(var CustLedgEntry : Record "Cust. Ledger Entry";AccNo : Code[20]);
    begin
        CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF CustLedgEntry.FINDFIRST THEN;
        END ELSE
          IF "Applies-to ID" <> '' THEN BEGIN
            CustLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
            IF CustLedgEntry.FINDFIRST THEN;
          END;
    end;

    local procedure GetAppliesToDocVendLedgEntry(var VendLedgEntry : Record "Vendor Ledger Entry";AccNo : Code[20]);
    begin
        VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        IF "Applies-to Doc. No." <> '' THEN BEGIN
          VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
          VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
          IF VendLedgEntry.FINDFIRST THEN;
        END ELSE
          IF "Applies-to ID" <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Applies-to ID","Applies-to ID");
            IF VendLedgEntry.FINDFIRST THEN;
          END;
    end;

    local procedure SetJournalLineFieldsFromApplication();
    var
        AccType : Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo : Code[20];
    begin
        "Exported to Payment File" := FALSE;
        GetAccTypeAndNo(Rec,AccType,AccNo);
        CASE AccType OF
          AccType::Customer:
            IF "Applies-to ID" <> '' THEN BEGIN
              IF FindFirstCustLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
                CustLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                "Exported to Payment File" := CustLedgEntry.FINDFIRST;
              END
            END ELSE
              IF "Applies-to Doc. No." <> '' THEN
                IF FindFirstCustLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN BEGIN
                  "Exported to Payment File" := CustLedgEntry."Exported to Payment File";
                  "Applies-to Ext. Doc. No." := CustLedgEntry."External Document No.";
                END;
          AccType::Vendor:
            IF "Applies-to ID" <> '' THEN BEGIN
              IF FindFirstVendLedgEntryWithAppliesToID(AccNo,"Applies-to ID") THEN BEGIN
                VendLedgEntry.SETRANGE("Exported to Payment File",TRUE);
                "Exported to Payment File" := VendLedgEntry.FINDFIRST;
              END
            END ELSE
              IF "Applies-to Doc. No." <> '' THEN
                IF FindFirstVendLedgEntryWithAppliesToDocNo(AccNo,"Applies-to Doc. No.") THEN BEGIN
                  "Exported to Payment File" := VendLedgEntry."Exported to Payment File";
                  "Applies-to Ext. Doc. No." := VendLedgEntry."External Document No.";
                END;
        END;
    end;

    local procedure GetAccTypeAndNo(GenJnlLine2 : Record "Gen. Journal Line";var AccType : Option;var AccNo : Code[20]);
    begin
        IF GenJnlLine2."Bal. Account Type" IN
           [GenJnlLine2."Bal. Account Type"::Customer,GenJnlLine2."Bal. Account Type"::Vendor]
        THEN BEGIN
          AccType := GenJnlLine2."Bal. Account Type";
          AccNo := GenJnlLine2."Bal. Account No.";
        END ELSE BEGIN
          AccType := GenJnlLine2."Account Type";
          AccNo := GenJnlLine2."Account No.";
        END;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo : Code[20];AppliesToID : Code[50]) : Boolean;
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Customer No.","Applies-to ID",Open);
        CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
        CustLedgEntry.SETRANGE(Open,TRUE);
        EXIT(CustLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo : Code[20];AppliestoDocNo : Code[20]) : Boolean;
    begin
        CustLedgEntry.RESET;
        CustLedgEntry.SETCURRENTKEY("Document No.");
        CustLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
        CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        CustLedgEntry.SETRANGE("Customer No.",AccNo);
        CustLedgEntry.SETRANGE(Open,TRUE);
        EXIT(CustLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo : Code[20];AppliesToID : Code[50]) : Boolean;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Vendor No.","Applies-to ID",Open);
        VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE("Applies-to ID",AppliesToID);
        VendLedgEntry.SETRANGE(Open,TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo : Code[20];AppliestoDocNo : Code[20]) : Boolean;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETCURRENTKEY("Document No.");
        VendLedgEntry.SETRANGE("Document No.",AppliestoDocNo);
        VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
        VendLedgEntry.SETRANGE("Vendor No.",AccNo);
        VendLedgEntry.SETRANGE(Open,TRUE);
        EXIT(VendLedgEntry.FINDFIRST)
    end;

    local procedure ClearPostingGroups();
    begin
        "Gen. Posting Type" := "Gen. Posting Type"::" ";
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
    end;

    local procedure ClearBalancePostingGroups();
    begin
        "Bal. Gen. Posting Type" := "Bal. Gen. Posting Type"::" ";
        "Bal. Gen. Bus. Posting Group" := '';
        "Bal. Gen. Prod. Posting Group" := '';
        "Bal. VAT Bus. Posting Group" := '';
        "Bal. VAT Prod. Posting Group" := '';
    end;

    local procedure CleanLine();
    begin
        UpdateLineBalance;
        UpdateSource;
        CreateDim(
          DimMgt.TypeToTableID1("Account Type"),"Account No.",
          DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
          DATABASE::Job,"Job No.",
          DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
          DATABASE::Campaign,"Campaign No.");
        IF NOT ("Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor]) THEN
          "Recipient Bank Account" := '';
        IF xRec."Account No." <> '' THEN BEGIN
          ClearPostingGroups;
          "WHT Business Posting Group" := '';
          "WHT Product Posting Group" := '';
          "Tax Area Code" := '';
          "Tax Liable" := FALSE;
          "Tax Group Code" := '';
          "Bill-to/Pay-to No." := '';
          "Ship-to/Order Address Code" := '';
          "Sell-to/Buy-from No." := '';
          UpdateCountryCodeAndVATRegNo('');
        END;
    end;

    local procedure ReplaceDescription() : Boolean;
    begin
        IF "Bal. Account No." = '' THEN
          EXIT(TRUE);
        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        EXIT(GenJnlBatch."Bal. Account No." <> '');
    end;

    procedure IsExportedToPaymentFile() : Boolean;
    begin
        EXIT(IsPaymentJournallLineExported OR IsAppliedToVendorLedgerEntryExported);
    end;

    procedure IsPaymentJournallLineExported() : Boolean;
    var
        GenJnlLine : Record "Gen. Journal Line";
        OldFilterGroup : Integer;
        HasExportedLines : Boolean;
    begin
        WITH GenJnlLine DO BEGIN
          COPYFILTERS(Rec);
          OldFilterGroup := FILTERGROUP;
          FILTERGROUP := 10;
          SETRANGE("Exported to Payment File",TRUE);
          HasExportedLines := NOT ISEMPTY;
          SETRANGE("Exported to Payment File");
          FILTERGROUP := OldFilterGroup;
        END;
        EXIT(HasExportedLines);
    end;

    procedure IsAppliedToVendorLedgerEntryExported() : Boolean;
    var
        GenJnlLine : Record "Gen. Journal Line";
        VendLedgerEntry : Record "Vendor Ledger Entry";
    begin
        GenJnlLine.COPYFILTERS(Rec);

        IF GenJnlLine.FINDSET THEN
          REPEAT
            IF GenJnlLine.IsApplied THEN BEGIN
              VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
              IF GenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                VendLedgerEntry.SETRANGE("Document Type",GenJnlLine."Applies-to Doc. Type");
                VendLedgerEntry.SETRANGE("Document No.",GenJnlLine."Applies-to Doc. No.");
              END;
              IF GenJnlLine."Applies-to ID" <> '' THEN
                VendLedgerEntry.SETRANGE("Applies-to ID",GenJnlLine."Applies-to ID");
              VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
              IF NOT VendLedgerEntry.ISEMPTY THEN
                EXIT(TRUE);
            END;

            VendLedgerEntry.RESET;
            VendLedgerEntry.SETRANGE("Vendor No.",GenJnlLine."Account No.");
            VendLedgerEntry.SETRANGE("Applies-to Doc. Type",GenJnlLine."Document Type");
            VendLedgerEntry.SETRANGE("Applies-to Doc. No.",GenJnlLine."Document No.");
            VendLedgerEntry.SETRANGE("Exported to Payment File",TRUE);
            IF NOT VendLedgerEntry.ISEMPTY THEN
              EXIT(TRUE);
          UNTIL GenJnlLine.NEXT = 0;

        EXIT(FALSE);
    end;

    local procedure ClearAppliedAutomatically();
    begin
        IF CurrFieldNo <> 0 THEN
          "Applied Automatically" := FALSE;
    end;

    procedure SetPostingDateAsDueDate(DueDate : Date;DateOffset : DateFormula) : Boolean;
    var
        NewPostingDate : Date;
    begin
        IF DueDate = 0D THEN
          EXIT(FALSE);

        NewPostingDate := CALCDATE(DateOffset,DueDate);
        IF NewPostingDate < WORKDATE THEN BEGIN
          VALIDATE("Posting Date",WORKDATE);
          EXIT(TRUE);
        END;

        VALIDATE("Posting Date",NewPostingDate);
        EXIT(FALSE);
    end;

    procedure CalculatePostingDate();
    var
        GenJnlLine : Record "Gen. Journal Line";
        EmptyDateFormula : DateFormula;
    begin
        GenJnlLine.COPY(Rec);
        GenJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");

        IF GenJnlLine.FINDSET THEN BEGIN
          Window.OPEN(CalcPostDateMsg);
          REPEAT
            EVALUATE(EmptyDateFormula,'<0D>');
            GenJnlLine.SetPostingDateAsDueDate(GenJnlLine.GetAppliesToDocDueDate,EmptyDateFormula);
            GenJnlLine.MODIFY(TRUE);
            Window.UPDATE(1,GenJnlLine."Document No.");
          UNTIL GenJnlLine.NEXT = 0;
          Window.CLOSE;
        END;
    end;

    procedure ImportBankStatement();
    var
        ProcessGenJnlLines : Codeunit "Process Gen. Journal  Lines";
    begin
        ProcessGenJnlLines.ImportBankStatement(Rec);
    end;

    procedure ExportPaymentFile();
    var
        BankAcc : Record "Bank Account";
    begin
        IF NOT FINDSET THEN
          ERROR(NothingToExportErr);
        SETRANGE("Journal Template Name","Journal Template Name");
        SETRANGE("Journal Batch Name","Journal Batch Name");
        TESTFIELD("Check Printed",FALSE);

        GenJnlBatch.GET("Journal Template Name","Journal Batch Name");
        GenJnlBatch.TESTFIELD("Bal. Account Type",GenJnlBatch."Bal. Account Type"::"Bank Account");
        GenJnlBatch.TESTFIELD("Bal. Account No.");

        CheckDocNoOnLines;
        IF IsExportedToPaymentFile THEN
          IF NOT CONFIRM(ExportAgainQst) THEN
            EXIT;
        BankAcc.GET(GenJnlBatch."Bal. Account No.");
        IF BankAcc.GetPaymentExportCodeunitID > 0 THEN
          CODEUNIT.RUN(BankAcc.GetPaymentExportCodeunitID,Rec)
        ELSE
          CODEUNIT.RUN(CODEUNIT::"Exp. Launcher Gen. Jnl.",Rec);
    end;

    procedure TotalExportedAmount() : Decimal;
    var
        CreditTransferEntry : Record "Credit Transfer Entry";
    begin
        IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
          EXIT(0);
        GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
        CreditTransferEntry.CALCSUMS("Transfer Amount");
        EXIT(CreditTransferEntry."Transfer Amount");
    end;

    procedure DrillDownExportedAmount();
    var
        CreditTransferEntry : Record "Credit Transfer Entry";
    begin
        IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
          EXIT;
        GenJnlShowCTEntries.SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);
        PAGE.RUN(PAGE::"Credit Transfer Reg. Entries",CreditTransferEntry);
    end;

    local procedure CopyDimensionsFromJobTaskLine();
    begin
        "Dimension Set ID" := TempJobJnlLine."Dimension Set ID";
        "Shortcut Dimension 1 Code" := TempJobJnlLine."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := TempJobJnlLine."Shortcut Dimension 2 Code";
    end;

    procedure CopyDocumentFields(DocType : Option;DocNo : Code[20];ExtDocNo : Text[35];SourceCode : Code[10];NoSeriesCode : Code[10]);
    begin
        "Document Type" := DocType;
        "Document No." := DocNo;
        "External Document No." := ExtDocNo;
        "Source Code" := SourceCode;
        IF NoSeriesCode <> '' THEN
          "Posting No. Series" := NoSeriesCode;
    end;

    procedure CopyCustLedgEntry(CustLedgerEntry : Record "Cust. Ledger Entry");
    begin
        "Document Type" := CustLedgerEntry."Document Type";
        Description := CustLedgerEntry.Description;
        "Shortcut Dimension 1 Code" := CustLedgerEntry."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := CustLedgerEntry."Global Dimension 2 Code";
        "Dimension Set ID" := CustLedgerEntry."Dimension Set ID";
        "Posting Group" := CustLedgerEntry."Customer Posting Group";
        "Source Type" := "Source Type"::Customer;
        "Source No." := CustLedgerEntry."Customer No.";
    end;

    procedure CopyFromGenJnlAllocation(GenJnlAlloc : Record "Gen. Jnl. Allocation");
    begin
        "Account No." := GenJnlAlloc."Account No.";
        "Shortcut Dimension 1 Code" := GenJnlAlloc."Shortcut Dimension 1 Code";
        "Shortcut Dimension 2 Code" := GenJnlAlloc."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlAlloc."Dimension Set ID";
        "Gen. Posting Type" := GenJnlAlloc."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GenJnlAlloc."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GenJnlAlloc."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GenJnlAlloc."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GenJnlAlloc."VAT Prod. Posting Group";
        "Tax Area Code" := GenJnlAlloc."Tax Area Code";
        "Tax Liable" := GenJnlAlloc."Tax Liable";
        "Tax Group Code" := GenJnlAlloc."Tax Group Code";
        "Use Tax" := GenJnlAlloc."Use Tax";
        "VAT Calculation Type" := GenJnlAlloc."VAT Calculation Type";
        "VAT Amount" := GenJnlAlloc."VAT Amount";
        "VAT Base Amount" := GenJnlAlloc.Amount - GenJnlAlloc."VAT Amount";
        "VAT %" := GenJnlAlloc."VAT %";
        "Source Currency Amount" := GenJnlAlloc."Additional-Currency Amount";
        Amount := GenJnlAlloc.Amount;
        "Amount (LCY)" := GenJnlAlloc.Amount;
    end;

    procedure CopyFromInvoicePostBuffer(InvoicePostBuffer : Record "Invoice Post. Buffer");
    begin
        "Account No." := InvoicePostBuffer."G/L Account";
        "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
        "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := InvoicePostBuffer."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := InvoicePostBuffer."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := InvoicePostBuffer."VAT Prod. Posting Group";
        "Tax Area Code" := InvoicePostBuffer."Tax Area Code";
        "Tax Liable" := InvoicePostBuffer."Tax Liable";
        "Tax Group Code" := InvoicePostBuffer."Tax Group Code";
        "Use Tax" := InvoicePostBuffer."Use Tax";
        Quantity := InvoicePostBuffer.Quantity;
        "VAT %" := InvoicePostBuffer."VAT %";
        "VAT Calculation Type" := InvoicePostBuffer."VAT Calculation Type";
        "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
        "Job No." := InvoicePostBuffer."Job No.";
        "Deferral Code" := InvoicePostBuffer."Deferral Code";
        "Deferral Line No." := InvoicePostBuffer."Deferral Line No.";
        Amount := InvoicePostBuffer.Amount;
        "Source Currency Amount" := InvoicePostBuffer."Amount (ACY)";
        "VAT Base Amount" := InvoicePostBuffer."VAT Base Amount";
        "Source Curr. VAT Base Amount" := InvoicePostBuffer."VAT Base Amount (ACY)";
        "VAT Amount" := InvoicePostBuffer."VAT Amount";
        "Source Curr. VAT Amount" := InvoicePostBuffer."VAT Amount (ACY)";
        "VAT Difference" := InvoicePostBuffer."VAT Difference";
    end;

    procedure CopyFromInvoicePostBufferFA(InvoicePostBuffer : Record "Invoice Post. Buffer");
    begin
        "Account Type" := "Account Type"::"Fixed Asset";
        "FA Posting Date" := InvoicePostBuffer."FA Posting Date";
        "Depreciation Book Code" := InvoicePostBuffer."Depreciation Book Code";
        "Salvage Value" := InvoicePostBuffer."Salvage Value";
        "Depr. until FA Posting Date" := InvoicePostBuffer."Depr. until FA Posting Date";
        "Depr. Acquisition Cost" := InvoicePostBuffer."Depr. Acquisition Cost";
        "Maintenance Code" := InvoicePostBuffer."Maintenance Code";
        "Insurance No." := InvoicePostBuffer."Insurance No.";
        "Budgeted FA No." := InvoicePostBuffer."Budgeted FA No.";
        "Duplicate in Depreciation Book" := InvoicePostBuffer."Duplicate in Depreciation Book";
        "Use Duplication List" := InvoicePostBuffer."Use Duplication List";
    end;

    procedure CopyFromPrepmtInvoiceBuffer(PrepmtInvLineBuffer : Record "Prepayment Inv. Line Buffer");
    begin
        "Account No." := PrepmtInvLineBuffer."G/L Account No.";
        "Gen. Bus. Posting Group" := PrepmtInvLineBuffer."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := PrepmtInvLineBuffer."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := PrepmtInvLineBuffer."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := PrepmtInvLineBuffer."VAT Prod. Posting Group";
        "Tax Area Code" := PrepmtInvLineBuffer."Tax Area Code";
        "Tax Liable" := PrepmtInvLineBuffer."Tax Liable";
        "Tax Group Code" := PrepmtInvLineBuffer."Tax Group Code";
        "Use Tax" := FALSE;
        "VAT Calculation Type" := PrepmtInvLineBuffer."VAT Calculation Type";
        "Job No." := PrepmtInvLineBuffer."Job No.";
        Amount := PrepmtInvLineBuffer.Amount;
        "Source Currency Amount" := PrepmtInvLineBuffer."Amount (ACY)";
        "VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount";
        "Source Curr. VAT Base Amount" := PrepmtInvLineBuffer."VAT Base Amount (ACY)";
        "VAT Amount" := PrepmtInvLineBuffer."VAT Amount";
        "Source Curr. VAT Amount" := PrepmtInvLineBuffer."VAT Amount (ACY)";
        "VAT Difference" := PrepmtInvLineBuffer."VAT Difference";
    end;

    procedure CopyFromPurchHeader(PurchHeader : Record "Purchase Header");
    begin
        "Source Currency Code" := PurchHeader."Currency Code";
        "Currency Factor" := PurchHeader."Currency Factor";
        Correction := PurchHeader.Correction;
        "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
        "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
        "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
        "Country/Region Code" := PurchHeader."VAT Country/Region Code";
        "VAT Registration No." := PurchHeader."VAT Registration No.";
        "Source Type" := "Source Type"::Vendor;
        "Source No." := PurchHeader."Pay-to Vendor No.";
        "Posting No. Series" := PurchHeader."Posting No. Series";
        "IC Partner Code" := PurchHeader."Pay-to IC Partner Code";
        "Ship-to/Order Address Code" := PurchHeader."Order Address Code";
        "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
        "On Hold" := PurchHeader."On Hold";
        IF "Account Type" = "Account Type"::Vendor THEN
          "Posting Group" := PurchHeader."Vendor Posting Group";
    end;

    procedure CopyFromPurchHeaderPrepmt(PurchHeader : Record "Purchase Header");
    begin
        "Source Currency Code" := PurchHeader."Currency Code";
        "VAT Base Discount %" := PurchHeader."VAT Base Discount %";
        "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
        "Country/Region Code" := PurchHeader."VAT Country/Region Code";
        "VAT Registration No." := PurchHeader."VAT Registration No.";
        "Source Type" := "Source Type"::Vendor;
        "Source No." := PurchHeader."Pay-to Vendor No.";
        "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
        "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
        "System-Created Entry" := TRUE;
        Prepayment := TRUE;
    end;

    procedure CopyFromPurchHeaderPrepmtPost(PurchHeader : Record "Purchase Header";UsePmtDisc : Boolean);
    begin
        "Account Type" := "Account Type"::Vendor;
        "Account No." := PurchHeader."Pay-to Vendor No.";
        SetCurrencyFactor(PurchHeader."Currency Code",PurchHeader."Currency Factor");
        "Source Currency Code" := PurchHeader."Currency Code";
        "Bill-to/Pay-to No." := PurchHeader."Pay-to Vendor No.";
        "Sell-to/Buy-from No." := PurchHeader."Buy-from Vendor No.";
        "Salespers./Purch. Code" := PurchHeader."Purchaser Code";
        "Source Type" := "Source Type"::Customer;
        "Source No." := PurchHeader."Pay-to Vendor No.";
        "IC Partner Code" := PurchHeader."Buy-from IC Partner Code";
        "System-Created Entry" := TRUE;
        Prepayment := TRUE;
        "Due Date" := PurchHeader."Prepayment Due Date";
        "Payment Terms Code" := PurchHeader."Payment Terms Code";
        IF UsePmtDisc THEN BEGIN
          "Pmt. Discount Date" := PurchHeader."Prepmt. Pmt. Discount Date";
          "Payment Discount %" := PurchHeader."Prepmt. Payment Discount %";
        END;
    end;

    procedure CopyFromPurchHeaderApplyTo(PurchHeader : Record "Purchase Header");
    begin
        "Applies-to Doc. Type" := PurchHeader."Applies-to Doc. Type";
        "Applies-to Doc. No." := PurchHeader."Applies-to Doc. No.";
        "Applies-to ID" := PurchHeader."Applies-to ID";
        "Allow Application" := PurchHeader."Bal. Account No." = '';
    end;

    procedure CopyFromPurchHeaderPayment(PurchHeader : Record "Purchase Header");
    begin
        "Due Date" := PurchHeader."Due Date";
        "Payment Terms Code" := PurchHeader."Payment Terms Code";
        "Pmt. Discount Date" := PurchHeader."Pmt. Discount Date";
        "Payment Discount %" := PurchHeader."Payment Discount %";
        "Creditor No." := PurchHeader."Creditor No.";
        "Payment Reference" := PurchHeader."Payment Reference";
        "Payment Method Code" := PurchHeader."Payment Method Code";
    end;

    procedure CopyFromSalesHeader(SalesHeader : Record "Sales Header");
    begin
        "Source Currency Code" := SalesHeader."Currency Code";
        "Currency Factor" := SalesHeader."Currency Factor";
        "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
        Correction := SalesHeader.Correction;
        "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
        "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
        "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
        "Country/Region Code" := SalesHeader."VAT Country/Region Code";
        "VAT Registration No." := SalesHeader."VAT Registration No.";
        "Source Type" := "Source Type"::Customer;
        "Source No." := SalesHeader."Bill-to Customer No.";
        "Posting No. Series" := SalesHeader."Posting No. Series";
        "Ship-to/Order Address Code" := SalesHeader."Ship-to Code";
        "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
        "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
        "On Hold" := SalesHeader."On Hold";
        IF "Account Type" = "Account Type"::Customer THEN
          "Posting Group" := SalesHeader."Customer Posting Group";
    end;

    procedure CopyFromSalesHeaderPrepmt(SalesHeader : Record "Sales Header");
    begin
        "Source Currency Code" := SalesHeader."Currency Code";
        "VAT Base Discount %" := SalesHeader."VAT Base Discount %";
        "EU 3-Party Trade" := SalesHeader."EU 3-Party Trade";
        "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
        "Country/Region Code" := SalesHeader."VAT Country/Region Code";
        "VAT Registration No." := SalesHeader."VAT Registration No.";
        "Source Type" := "Source Type"::Customer;
        "Source No." := SalesHeader."Bill-to Customer No.";
        "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
        "VAT Posting" := "VAT Posting"::"Manual VAT Entry";
        "System-Created Entry" := TRUE;
        Prepayment := TRUE;
    end;

    procedure CopyFromSalesHeaderPrepmtPost(SalesHeader : Record "Sales Header";UsePmtDisc : Boolean);
    begin
        "Account Type" := "Account Type"::Customer;
        "Account No." := SalesHeader."Bill-to Customer No.";
        SetCurrencyFactor(SalesHeader."Currency Code",SalesHeader."Currency Factor");
        "Source Currency Code" := SalesHeader."Currency Code";
        "Sell-to/Buy-from No." := SalesHeader."Sell-to Customer No.";
        "Bill-to/Pay-to No." := SalesHeader."Bill-to Customer No.";
        "Salespers./Purch. Code" := SalesHeader."Salesperson Code";
        "Source Type" := "Source Type"::Customer;
        "Source No." := SalesHeader."Bill-to Customer No.";
        "IC Partner Code" := SalesHeader."Sell-to IC Partner Code";
        "System-Created Entry" := TRUE;
        Prepayment := TRUE;
        "Due Date" := SalesHeader."Prepayment Due Date";
        "Payment Terms Code" := SalesHeader."Prepmt. Payment Terms Code";
        IF UsePmtDisc THEN BEGIN
          "Pmt. Discount Date" := SalesHeader."Prepmt. Pmt. Discount Date";
          "Payment Discount %" := SalesHeader."Prepmt. Payment Discount %";
        END;
    end;

    procedure CopyFromSalesHeaderApplyTo(SalesHeader : Record "Sales Header");
    begin
        "Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type";
        "Applies-to Doc. No." := SalesHeader."Applies-to Doc. No.";
        "Applies-to ID" := SalesHeader."Applies-to ID";
        "Allow Application" := SalesHeader."Bal. Account No." = '';
    end;

    procedure CopyFromSalesHeaderPayment(SalesHeader : Record "Sales Header");
    begin
        "Due Date" := SalesHeader."Due Date";
        "Payment Terms Code" := SalesHeader."Payment Terms Code";
        "Payment Method Code" := SalesHeader."Payment Method Code";
        "Pmt. Discount Date" := SalesHeader."Pmt. Discount Date";
        "Payment Discount %" := SalesHeader."Payment Discount %";
        "Direct Debit Mandate ID" := SalesHeader."Direct Debit Mandate ID";
    end;

    procedure CopyFromServiceHeader(ServiceHeader : Record "Service Header");
    begin
        "Source Currency Code" := ServiceHeader."Currency Code";
        Correction := ServiceHeader.Correction;
        "VAT Base Discount %" := ServiceHeader."VAT Base Discount %";
        "Sell-to/Buy-from No." := ServiceHeader."Customer No.";
        "Bill-to/Pay-to No." := ServiceHeader."Bill-to Customer No.";
        "Country/Region Code" := ServiceHeader."VAT Country/Region Code";
        "VAT Registration No." := ServiceHeader."VAT Registration No.";
        "Source Type" := "Source Type"::Customer;
        "Source No." := ServiceHeader."Bill-to Customer No.";
        "Posting No. Series" := ServiceHeader."Posting No. Series";
        "Ship-to/Order Address Code" := ServiceHeader."Ship-to Code";
        "EU 3-Party Trade" := ServiceHeader."EU 3-Party Trade";
    end;

    procedure CopyFromServiceHeaderApplyTo(ServiceHeader : Record "Service Header");
    begin
        "Applies-to Doc. Type" := ServiceHeader."Applies-to Doc. Type";
        "Applies-to Doc. No." := ServiceHeader."Applies-to Doc. No.";
        "Applies-to ID" := ServiceHeader."Applies-to ID";
        "Allow Application" := ServiceHeader."Bal. Account No." = '';
    end;

    procedure CopyFromServiceHeaderPayment(ServiceHeader : Record "Service Header");
    begin
        "Due Date" := ServiceHeader."Due Date";
        "Payment Terms Code" := ServiceHeader."Payment Terms Code";
        "Payment Method Code" := ServiceHeader."Payment Method Code";
        "Pmt. Discount Date" := ServiceHeader."Pmt. Discount Date";
        "Payment Discount %" := ServiceHeader."Payment Discount %";
    end;

    local procedure SetAmountWithCustLedgEntry();
    begin
        IF "Currency Code" <> CustLedgEntry."Currency Code" THEN
          CheckModifyCurrencyCode(GenJnlLine."Account Type"::Customer,CustLedgEntry."Currency Code");
        IF Amount = 0 THEN BEGIN
          CustLedgEntry.CALCFIELDS("Remaining Amount");
          SetAmountWithRemaining(
            PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,FALSE),
            CustLedgEntry."Amount to Apply",CustLedgEntry."Remaining Amount",CustLedgEntry."Remaining Pmt. Disc. Possible");
        END;
    end;

    local procedure SetAmountWithVendLedgEntry();
    begin
        IF "Currency Code" <> VendLedgEntry."Currency Code" THEN
          CheckModifyCurrencyCode("Account Type"::Vendor,VendLedgEntry."Currency Code");
        IF Amount = 0 THEN BEGIN
          VendLedgEntry.CALCFIELDS("Remaining Amount");
          SetAmountWithRemaining(
            PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,FALSE),
            VendLedgEntry."Amount to Apply",VendLedgEntry."Remaining Amount",VendLedgEntry."Remaining Pmt. Disc. Possible");
        END;
    end;

    procedure CheckModifyCurrencyCode(AccountType : Option;CustVendLedgEntryCurrencyCode : Code[10]);
    begin
        IF Amount = 0 THEN BEGIN
          FromCurrencyCode := GetShowCurrencyCode("Currency Code");
          ToCurrencyCode := GetShowCurrencyCode(CustVendLedgEntryCurrencyCode);
          IF NOT
             CONFIRM(
               Text003,TRUE,FIELDCAPTION("Currency Code"),TABLECAPTION,FromCurrencyCode,ToCurrencyCode)
          THEN
            ERROR(Text005);
          VALIDATE("Currency Code",CustVendLedgEntryCurrencyCode);
        END ELSE
          GenJnlApply.CheckAgainstApplnCurrency(
            "Currency Code",CustVendLedgEntryCurrencyCode,AccountType,TRUE);
    end;

    local procedure SetAmountWithRemaining(CalcPmtDisc : Boolean;AmountToApply : Decimal;RemainingAmount : Decimal;RemainingPmtDiscPossible : Decimal);
    begin
        IF AmountToApply <> 0 THEN
          IF CalcPmtDisc AND (ABS(AmountToApply) >= ABS(RemainingAmount - RemainingPmtDiscPossible)) THEN
            Amount := -(RemainingAmount - RemainingPmtDiscPossible)
          ELSE
            Amount := -AmountToApply
        ELSE
          IF CalcPmtDisc THEN
            Amount := -(RemainingAmount - RemainingPmtDiscPossible)
          ELSE
            Amount := -RemainingAmount;
        IF "Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor] THEN
          Amount := -Amount;
        VALIDATE(Amount);
    end;

    procedure IsOpenedFromBatch() : Boolean;
    var
        GenJournalBatch : Record "Gen. Journal Batch";
        TemplateFilter : Text;
        BatchFilter : Text;
    begin
        BatchFilter := GETFILTER("Journal Batch Name");
        IF BatchFilter <> '' THEN BEGIN
          TemplateFilter := GETFILTER("Journal Template Name");
          IF TemplateFilter <> '' THEN
            GenJournalBatch.SETFILTER("Journal Template Name",TemplateFilter);
          GenJournalBatch.SETFILTER(Name,BatchFilter);
          GenJournalBatch.FINDFIRST;
        END;

        EXIT((("Journal Batch Name" <> '') AND ("Journal Template Name" = '')) OR (BatchFilter <> ''));
    end;

    procedure GetDeferralAmount() DeferralAmount : Decimal;
    begin
        IF "VAT Base Amount" <> 0 THEN
          DeferralAmount := "VAT Base Amount"
        ELSE
          DeferralAmount := Amount;
    end;

    procedure ShowDeferrals(PostingDate : Date;CurrencyCode : Code[10]) : Boolean;
    var
        DeferralUtilities : Codeunit "Deferral Utilities";
    begin
        EXIT(
          DeferralUtilities.OpenLineScheduleEdit(
            "Deferral Code",GetDeferralDocType,"Journal Template Name","Journal Batch Name",0,'',"Line No.",
            GetDeferralAmount,PostingDate,Description,CurrencyCode));
    end;

    procedure GetDeferralDocType() : Integer;
    begin
        EXIT(DeferralDocType::"G/L");
    end;

    procedure IsForPurchase() : Boolean;
    begin
        IF ("Account Type" = "Account Type"::Vendor) OR ("Bal. Account Type" = "Bal. Account Type"::Vendor) THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure IsForSales() : Boolean;
    begin
        IF ("Account Type" = "Account Type"::Customer) OR ("Bal. Account Type" = "Bal. Account Type"::Customer) THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCheckGenJournalLinePostRestrictions();
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCheckGenJournalLinePrintCheckRestrictions();
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnMoveGenJournalLine(ToRecordID : RecordID);
    begin
    end;

    local procedure LookupAdjmtAppliesTo();
    var
        ApplyCustEntries : Page "Apply Customer Entries";
        ApplyVendEntries : Page "Apply Vendor Entries";
    begin
        CASE TRUE OF
          "Account Type" = "Account Type"::Customer, "Bal. Account Type" = "Bal. Account Type"::Customer:
            BEGIN
              CustLedgEntry.RESET;
              CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
              IF "Account Type" = "Account Type"::Customer THEN
                CustLedgEntry.SETRANGE("Customer No.","Account No.")
              ELSE
                CustLedgEntry.SETRANGE("Customer No.","Bal. Account No.");
              IF "Applies-to Doc. No." <> '' THEN BEGIN
                CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                IF CustLedgEntry.FIND('-') THEN;
                CustLedgEntry.SETRANGE("Document Type");
                CustLedgEntry.SETRANGE("Document No.");
              END ELSE
                IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                  CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  IF CustLedgEntry.FIND('-') THEN;
                  CustLedgEntry.SETRANGE("Document Type");
                END ELSE
                  IF Amount <> 0 THEN BEGIN
                    IF "Account Type" = "Account Type"::Customer THEN
                      CustLedgEntry.SETRANGE(Positive,Amount < 0)
                    ELSE
                      CustLedgEntry.SETRANGE(Positive,-Amount < 0);
                    IF CustLedgEntry.FIND('-') THEN;
                    CustLedgEntry.SETRANGE(Positive);
                  END;
              ApplyCustEntries.SetGenJnlLine(Rec,FIELDNO("Applies-to Doc. No."));
              ApplyCustEntries.LOOKUPMODE(TRUE);
              ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
              IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                "Adjustment Applies-to" := CustLedgEntry."Document No.";
                IF ("Applies-to Doc. No." <> "Adjustment Applies-to") AND
                   ("Applies-to Doc. No." <> '')
                THEN
                  ERROR(
                    Text1500001,
                    FIELDNAME("Applies-to Doc. No."),FIELDNAME("Adjustment Applies-to"));
                "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                "BAS Adjustment" := BASManagement.CheckBASPeriod("Document Date",CustLedgEntry."Document Date");
              END;
              CLEAR(ApplyCustEntries);
            END;
          "Account Type" = "Account Type"::Vendor, "Bal. Account Type" = "Bal. Account Type"::Vendor:
            BEGIN
              VendLedgEntry.RESET;
              VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive,"Due Date");
              IF "Account Type" = "Account Type"::Vendor THEN
                VendLedgEntry.SETRANGE("Vendor No.","Account No.")
              ELSE
                VendLedgEntry.SETRANGE("Vendor No.","Bal. Account No.");
              IF "Applies-to Doc. No." <> '' THEN BEGIN
                VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                VendLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                IF VendLedgEntry.FIND('-') THEN;
                VendLedgEntry.SETRANGE("Document Type");
                VendLedgEntry.SETRANGE("Document No.");
              END ELSE
                IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                  VendLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  IF VendLedgEntry.FIND('-') THEN;
                  VendLedgEntry.SETRANGE("Document Type");
                END ELSE
                  IF Amount <> 0 THEN BEGIN
                    IF "Account Type" = "Account Type"::Vendor THEN
                      VendLedgEntry.SETRANGE(Positive,Amount < 0)
                    ELSE
                      VendLedgEntry.SETRANGE(Positive,-Amount < 0);
                    IF VendLedgEntry.FIND('-') THEN;
                    VendLedgEntry.SETRANGE(Positive);
                  END;
              ApplyVendEntries.SetGenJnlLine(Rec,FIELDNO("Applies-to Doc. No."));
              ApplyVendEntries.LOOKUPMODE(TRUE);
              ApplyVendEntries.SETTABLEVIEW(VendLedgEntry);
              IF ApplyVendEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                ApplyVendEntries.GetVendLedgEntry(VendLedgEntry);
                "Adjustment Applies-to" := VendLedgEntry."Document No.";
                "Applies-to Doc. Type" := VendLedgEntry."Document Type";
                "BAS Adjustment" := BASManagement.CheckBASPeriod("Document Date",VendLedgEntry."Document Date");
              END;
              CLEAR(ApplyVendEntries);
            END;
        END;
    end;

    local procedure IncrementDocumentNo();
    var
        NoSeriesLine : Record "No. Series Line";
    begin
        IF GenJnlBatch."No. Series" <> '' THEN BEGIN
          NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine,GenJnlBatch."No. Series","Posting Date");
          IF NoSeriesLine."Increment-by No." > 1 THEN
            NoSeriesMgt.IncrementNoText("Document No.",NoSeriesLine."Increment-by No.")
          ELSE
            "Document No." := INCSTR("Document No.");
        END ELSE
          "Document No." := INCSTR("Document No.");
    end;

    procedure NeedCheckZeroAmount() : Boolean;
    begin
        EXIT(
          ("Account No." <> '') AND
          NOT "System-Created Entry" AND
          NOT "Allow Zero-Amount Posting" AND
          ("Account Type" <> "Account Type"::"Fixed Asset"));
    end;

    procedure IsRecurring() : Boolean;
    var
        GenJournalTemplate : Record "Gen. Journal Template";
    begin
        IF "Journal Template Name" <> '' THEN
          IF GenJournalTemplate.GET("Journal Template Name") THEN
            EXIT(GenJournalTemplate.Recurring);

        EXIT(FALSE);
    end;

    local procedure SuggestBalancingAmount(LastGenJnlLine : Record "Gen. Journal Line";BottomLine : Boolean);
    var
        GenJournalLine : Record "Gen. Journal Line";
    begin
        IF "Document No." = '' THEN
          EXIT;
        IF GETFILTERS <> '' THEN
          EXIT;

        GenJournalLine.SETRANGE("Journal Template Name",LastGenJnlLine."Journal Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name",LastGenJnlLine."Journal Batch Name");
        IF BottomLine THEN
          GenJournalLine.SETFILTER("Line No.",'<=%1',LastGenJnlLine."Line No.")
        ELSE
          GenJournalLine.SETFILTER("Line No.",'<%1',LastGenJnlLine."Line No.");

        IF GenJournalLine.FINDLAST THEN BEGIN
          IF BottomLine THEN BEGIN
            GenJournalLine.SETRANGE("Document No.",LastGenJnlLine."Document No.");
            GenJournalLine.SETRANGE("Posting Date",LastGenJnlLine."Posting Date");
          END ELSE BEGIN
            GenJournalLine.SETRANGE("Document No.",GenJournalLine."Document No.");
            GenJournalLine.SETRANGE("Posting Date",GenJournalLine."Posting Date");
          END;
          GenJournalLine.SETRANGE("Bal. Account No.",'');
          IF GenJournalLine.FINDFIRST THEN BEGIN
            GenJournalLine.CALCSUMS(Amount);
            "Document No." := GenJournalLine."Document No.";
            "Posting Date" := GenJournalLine."Posting Date";
            VALIDATE(Amount,-GenJournalLine.Amount);
          END;
        END;
    end;

    local procedure GetGLAccount();
    var
        GLAcc : Record "G/L Account";
    begin
        GLAcc.GET("Account No.");
        CheckGLAcc(GLAcc);
        IF ReplaceDescription AND (NOT GLAcc."Omit Default Descr. in Jnl.") THEN
          UpdateDescription(GLAcc.Name)
        ELSE
          IF GLAcc."Omit Default Descr. in Jnl." THEN
            Description := '';
        IF ("Bal. Account No." = '') OR
           ("Bal. Account Type" IN
            ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
        THEN BEGIN
          "Posting Group" := '';
          "Salespers./Purch. Code" := '';
          "Payment Terms Code" := '';
        END;
        IF "Bal. Account No." = '' THEN
          "Currency Code" := '';
        IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
           GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        THEN BEGIN
          "Gen. Posting Type" := GLAcc."Gen. Posting Type";
          "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
          "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
          "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
          "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
          "WHT Business Posting Group" := GLAcc."WHT Business Posting Group";
          "WHT Product Posting Group" := GLAcc."WHT Product Posting Group";
        END;
        "Tax Area Code" := GLAcc."Tax Area Code";
        "Tax Liable" := GLAcc."Tax Liable";
        "Tax Group Code" := GLAcc."Tax Group Code";
        IF "Posting Date" <> 0D THEN
          IF "Posting Date" = CLOSINGDATE("Posting Date") THEN BEGIN
            ClearPostingGroups;
            "WHT Business Posting Group" := '';
            "WHT Product Posting Group" := '';
          END;
        VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
    end;

    local procedure GetGLBalAccount();
    var
        GLAcc : Record "G/L Account";
    begin
        GLAcc.GET("Bal. Account No.");
        CheckGLAcc(GLAcc);
        IF "Account No." = '' THEN BEGIN
          Description := GLAcc.Name;
          "Currency Code" := '';
        END;
        IF ("Account No." = '') OR
           ("Account Type" IN
            ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        THEN BEGIN
          "Posting Group" := '';
          "Salespers./Purch. Code" := '';
          "Payment Terms Code" := '';
        END;
        IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
           GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        THEN BEGIN
          "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
          "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
          "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
          "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
          "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        END;
        "Bal. Tax Area Code" := GLAcc."Tax Area Code";
        "Bal. Tax Liable" := GLAcc."Tax Liable";
        "Bal. Tax Group Code" := GLAcc."Tax Group Code";
        IF "Posting Date" <> 0D THEN
          IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
            ClearBalancePostingGroups;
    end;

    local procedure GetCustomerAccount();
    var
        Cust : Record Customer;
    begin
        Cust.GET("Account No.");
        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        CheckICPartner(Cust."IC Partner Code","Account Type","Account No.");
        UpdateDescription(Cust.Name);
        "Payment Method Code" := Cust."Payment Method Code";
        VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account Code");
        "Posting Group" := Cust."Customer Posting Group";
        "Salespers./Purch. Code" := Cust."Salesperson Code";
        "Payment Terms Code" := Cust."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.","Account No.");
        VALIDATE("Sell-to/Buy-from No.","Account No.");
        IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
          "Currency Code" := Cust."Currency Code";
        ClearPostingGroups;
        "WHT Business Posting Group" := Cust."WHT Business Posting Group";
        "WHT Product Posting Group" := '';
        IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") AND
           NOT HideValidationDialog
        THEN
          IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
               Cust."Bill-to Customer No.")
          THEN
            ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;
    end;

    local procedure GetCustomerBalAccount();
    var
        Cust : Record Customer;
    begin
        Cust.GET("Bal. Account No.");
        Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        CheckICPartner(Cust."IC Partner Code","Bal. Account Type","Bal. Account No.");
        IF "Account No." = '' THEN
          Description := Cust.Name;
        "Payment Method Code" := Cust."Payment Method Code";
        VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account Code");
        "Posting Group" := Cust."Customer Posting Group";
        "Salespers./Purch. Code" := Cust."Salesperson Code";
        "Payment Terms Code" := Cust."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
          "Currency Code" := Cust."Currency Code";
        IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
          "Currency Code" := Cust."Currency Code";
        ClearBalancePostingGroups;
        IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
          IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
               Cust."Bill-to Customer No.")
          THEN
            ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;
    end;

    local procedure GetVendorAccount();
    var
        Vend : Record Vendor;
    begin
        Vend.GET("Account No.");
        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        CheckICPartner(Vend."IC Partner Code","Account Type","Account No.");
        "Skip WHT" := Vend.ABN <> '';
        UpdateDescription(Vend.Name);
        "Payment Method Code" := Vend."Payment Method Code";
        "Creditor No." := Vend."Creditor No.";
        VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account Code");
        "Posting Group" := Vend."Vendor Posting Group";
        "Salespers./Purch. Code" := Vend."Purchaser Code";
        "Payment Terms Code" := Vend."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.","Account No.");
        VALIDATE("Sell-to/Buy-from No.","Account No.");
        IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
          "Currency Code" := Vend."Currency Code";
        ClearPostingGroups;
        "WHT Business Posting Group" := Vend."WHT Business Posting Group";
        "WHT Product Posting Group" := '';
        IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Account No.") AND
           NOT HideValidationDialog
        THEN
          IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
               Vend."Pay-to Vendor No.")
          THEN
            ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;
    end;

    local procedure GetVendorBalAccount();
    var
        Vend : Record Vendor;
    begin
        Vend.GET("Bal. Account No.");
        Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        CheckICPartner(Vend."IC Partner Code","Bal. Account Type","Bal. Account No.");
        IF "Account No." = '' THEN
          Description := Vend.Name;
        "Payment Method Code" := Vend."Payment Method Code";
        VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account Code");
        "Posting Group" := Vend."Vendor Posting Group";
        "Salespers./Purch. Code" := Vend."Purchaser Code";
        "Payment Terms Code" := Vend."Payment Terms Code";
        VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
          "Currency Code" := Vend."Currency Code";
        IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
          "Currency Code" := Vend."Currency Code";
        ClearBalancePostingGroups;
        IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") AND
           NOT HideValidationDialog
        THEN
          IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
               Vend."Pay-to Vendor No.")
          THEN
            ERROR('');
        VALIDATE("Payment Terms Code");
        CheckPaymentTolerance;
    end;

    local procedure GetBankAccount();
    var
        BankAcc : Record "Bank Account";
    begin
        BankAcc.GET("Account No.");
        BankAcc.TESTFIELD(Blocked,FALSE);
        IF ReplaceDescription THEN
          UpdateDescription(BankAcc.Name);
        IF ("Bal. Account No." = '') OR
           ("Bal. Account Type" IN
            ["Bal. Account Type"::"G/L Account","Bal. Account Type"::"Bank Account"])
        THEN BEGIN
          "Posting Group" := '';
          "Salespers./Purch. Code" := '';
          "Payment Terms Code" := '';
        END;
        IF BankAcc."Currency Code" = '' THEN BEGIN
          IF "Bal. Account No." = '' THEN
            "Currency Code" := '';
        END ELSE
          IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
            BankAcc.TESTFIELD("Currency Code","Currency Code")
          ELSE
            "Currency Code" := BankAcc."Currency Code";
        ClearPostingGroups;
    end;

    local procedure GetBankBalAccount();
    var
        BankAcc : Record "Bank Account";
    begin
        BankAcc.GET("Bal. Account No.");
        BankAcc.TESTFIELD(Blocked,FALSE);
        IF "Account No." = '' THEN
          Description := BankAcc.Name;

        IF ("Account No." = '') OR
           ("Account Type" IN
            ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        THEN BEGIN
          "Posting Group" := '';
          "Salespers./Purch. Code" := '';
          "Payment Terms Code" := '';
        END;
        IF BankAcc."Currency Code" = '' THEN BEGIN
          IF "Account No." = '' THEN
            "Currency Code" := '';
        END ELSE
          IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
            BankAcc.TESTFIELD("Currency Code","Currency Code")
          ELSE
            "Currency Code" := BankAcc."Currency Code";
        ClearBalancePostingGroups;
    end;

    local procedure GetFAAccount();
    var
        FA : Record "Fixed Asset";
    begin
        FA.GET("Account No.");
        FA.TESTFIELD(Blocked,FALSE);
        FA.TESTFIELD(Inactive,FALSE);
        FA.TESTFIELD("Budgeted Asset",FALSE);
        UpdateDescription(FA.Description);
        GetFADeprBook;
        GetFAVATSetup;
        GetFAAddCurrExchRate;
    end;

    local procedure GetFABalAccount();
    var
        FA : Record "Fixed Asset";
    begin
        FA.GET("Bal. Account No.");
        FA.TESTFIELD(Blocked,FALSE);
        FA.TESTFIELD(Inactive,FALSE);
        FA.TESTFIELD("Budgeted Asset",FALSE);
        IF "Account No." = '' THEN
          Description := FA.Description;
        GetFADeprBook;
        GetFAVATSetup;
        GetFAAddCurrExchRate;
    end;

    local procedure GetICPartnerAccount();
    var
        ICPartner : Record "IC Partner";
    begin
        ICPartner.GET("Account No.");
        ICPartner.CheckICPartner;
        UpdateDescription(ICPartner.Name);
        IF ("Bal. Account No." = '') OR ("Bal. Account Type" = "Bal. Account Type"::"G/L Account") THEN
          "Currency Code" := ICPartner."Currency Code";
        IF ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
          "Currency Code" := ICPartner."Currency Code";
        ClearPostingGroups;
        "IC Partner Code" := "Account No.";
    end;

    local procedure GetICPartnerBalAccount();
    var
        ICPartner : Record "IC Partner";
    begin
        ICPartner.GET("Bal. Account No.");
        IF "Account No." = '' THEN
          Description := ICPartner.Name;

        IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
          "Currency Code" := ICPartner."Currency Code";
        IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
          "Currency Code" := ICPartner."Currency Code";
        ClearBalancePostingGroups;
        "IC Partner Code" := "Bal. Account No.";
    end;

    procedure CreateFAAcquisitionLines(var FAGenJournalLine : Record "Gen. Journal Line");
    var
        BalancingGenJnlLine : Record "Gen. Journal Line";
        LocalGlAcc : Record "G/L Account";
        FAPostingGr : Record "FA Posting Group";
    begin
        TESTFIELD("Journal Template Name");
        TESTFIELD("Journal Batch Name");
        TESTFIELD("Posting Date");
        TESTFIELD("Account Type");
        TESTFIELD("Account No.");
        TESTFIELD("Posting Date");

        // Creating Fixed Asset Line
        FAGenJournalLine.INIT;
        FAGenJournalLine.VALIDATE("Journal Template Name","Journal Template Name");
        FAGenJournalLine.VALIDATE("Journal Batch Name","Journal Batch Name");
        FAGenJournalLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
        FAGenJournalLine.VALIDATE("Document Type","Document Type");
        FAGenJournalLine.VALIDATE("Document No.",GenerateLineDocNo("Journal Batch Name","Posting Date","Journal Template Name"));
        FAGenJournalLine.VALIDATE("Account Type","Account Type");
        FAGenJournalLine.VALIDATE("Account No.","Account No.");
        FAGenJournalLine.VALIDATE(Amount,Amount);
        FAGenJournalLine.VALIDATE("Posting Date","Posting Date");
        FAGenJournalLine.VALIDATE("FA Posting Type","FA Posting Type"::"Acquisition Cost");
        FAGenJournalLine.VALIDATE("External Document No.","External Document No.");
        FAGenJournalLine.INSERT(TRUE);

        // Creating Balancing Line
        BalancingGenJnlLine.COPY(FAGenJournalLine);
        BalancingGenJnlLine.VALIDATE("Account Type","Bal. Account Type");
        BalancingGenJnlLine.VALIDATE("Account No.","Bal. Account No.");
        BalancingGenJnlLine.VALIDATE(Amount,-Amount);
        BalancingGenJnlLine.VALIDATE("Line No.",GetNewLineNo("Journal Template Name","Journal Batch Name"));
        BalancingGenJnlLine.INSERT(TRUE);

        FAGenJournalLine.TESTFIELD("Posting Group");

        // Inserting additional fields in Fixed Asset line required for acquisition
        IF FAPostingGr.GET(FAGenJournalLine."Posting Group") THEN BEGIN
          LocalGlAcc.GET(FAPostingGr."Acquisition Cost Account");
          LocalGlAcc.CheckGLAcc;
          FAGenJournalLine.VALIDATE("Gen. Posting Type",LocalGlAcc."Gen. Posting Type");
          FAGenJournalLine.VALIDATE("Gen. Bus. Posting Group",LocalGlAcc."Gen. Bus. Posting Group");
          FAGenJournalLine.VALIDATE("Gen. Prod. Posting Group",LocalGlAcc."Gen. Prod. Posting Group");
          FAGenJournalLine.VALIDATE("VAT Bus. Posting Group",LocalGlAcc."VAT Bus. Posting Group");
          FAGenJournalLine.VALIDATE("VAT Prod. Posting Group",LocalGlAcc."VAT Prod. Posting Group");
          FAGenJournalLine.VALIDATE("Tax Group Code",LocalGlAcc."Tax Group Code");
          FAGenJournalLine.VALIDATE("VAT Prod. Posting Group");
          FAGenJournalLine.MODIFY(TRUE)
        END;

        // Inserting Source Code
        IF "Source Code" = '' THEN BEGIN
          GenJnlTemplate.GET("Journal Template Name");
          FAGenJournalLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
          FAGenJournalLine.MODIFY(TRUE);
          BalancingGenJnlLine.VALIDATE("Source Code",GenJnlTemplate."Source Code");
          BalancingGenJnlLine.MODIFY(TRUE);
        END;
    end;

    local procedure GenerateLineDocNo(BatchName : Code[10];PostingDate : Date;TemplateName : Code[20]) DocumentNo : Code[20];
    var
        GenJournalBatch : Record "Gen. Journal Batch";
        NoSeriesManagement : Codeunit NoSeriesManagement;
    begin
        GenJournalBatch.GET(TemplateName,BatchName);
        IF GenJournalBatch."No. Series" <> '' THEN
          DocumentNo := NoSeriesManagement.TryGetNextNo(GenJournalBatch."No. Series",PostingDate);
    end;

    local procedure GetFilterAccountNo() : Code[20];
    begin
        IF GETFILTER("Account No.") <> '' THEN
          IF GETRANGEMIN("Account No.") = GETRANGEMAX("Account No.") THEN
            EXIT(GETRANGEMAX("Account No."));
    end;

    procedure SetAccountNoFromFilter();
    var
        AccountNo : Code[20];
    begin
        AccountNo := GetFilterAccountNo;
        IF AccountNo = '' THEN BEGIN
          FILTERGROUP(2);
          AccountNo := GetFilterAccountNo;
          FILTERGROUP(0);
        END;
        IF AccountNo <> '' THEN
          "Account No." := AccountNo;
    end;

    procedure GetNewLineNo(TemplateName : Code[10];BatchName : Code[10]) : Integer;
    var
        GenJournalLine : Record "Gen. Journal Line";
    begin
        GenJournalLine.VALIDATE("Journal Template Name",TemplateName);
        GenJournalLine.VALIDATE("Journal Batch Name",BatchName);
        GenJournalLine.SETRANGE("Journal Template Name",TemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name",BatchName);
        IF GenJournalLine.FINDLAST THEN
          EXIT(GenJournalLine."Line No." + 10000);
        EXIT(10000);
    end;
}

