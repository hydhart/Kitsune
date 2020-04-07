page 254 "Purchase Journal"
{
    // version NAVW110.00,NAVAPAC10.00

    AutoSplitKey = true;
    CaptionML = ENU='Purchase Journal',
                ENA='Purchase Journal';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName;CurrentJnlBatchName)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Batch Name',
                            ENA='Batch Name';
                Lookup = true;
                ToolTipML = ENU='Specifies the batch name on the purchase journal.',
                            ENA='Specifies the batch name on the purchase journal.';

                trigger OnLookup(Text : Text) : Boolean;
                begin
                    CurrPage.SAVERECORD;
                    GenJnlManagement.LookupName(CurrentJnlBatchName,Rec);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate();
                begin
                    GenJnlManagement.CheckName(CurrentJnlBatchName,Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the posting date for the entry.',
                                ENA='Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the date on the document that provides the basis for the entry on the journal line.',
                                ENA='Specifies the date on the document that provides the basis for the entry on the journal line.';
                    Visible = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the type of document that the entry on the journal line is.',
                                ENA='Specifies the type of document that the entry on the journal line is.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a document number for the journal line.',
                                ENA='Specifies a document number for the journal line.';
                }
                field("Incoming Document Entry No.";"Incoming Document Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of the incoming document that this general journal line is created for.',
                                ENA='Specifies the number of the incoming document that this general journal line is created for.';
                    Visible = false;

                    trigger OnAssistEdit();
                    begin
                        IF "Incoming Document Entry No." > 0 THEN
                          HYPERLINK(GetIncomingDocumentURL);
                    end;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a document number that refers to the customer''s or vendor''s numbering system.',
                                ENA='Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                    Visible = false;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the type of account that the entry on the journal line will be posted to.',
                                ENA='Specifies the type of account that the entry on the journal line will be posted to.';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                    end;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the account number that the entry on the journal line will be posted to.',
                                ENA='Specifies the account number that the entry on the journal line will be posted to.';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a description of the entry. The field is automatically filled when the Account No. field is filled.',
                                ENA='Specifies a description of the entry. The field is automatically filled when the Account No. field is filled.';
                }
                field(Narration;Narration)
                {
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    Visible = false;
                }
                field("WHT Business Posting Group";"WHT Business Posting Group")
                {
                    ToolTipML = ENU='Specifies that the WHT Business Posting Group will be assigned to this field based on the Account Type and Account No. selected.',
                                ENA='Specifies that the WHT Business Posting Group will be assigned to this field based on the Account Type and Account No. selected.';
                    Visible = false;
                }
                field("WHT Product Posting Group";"WHT Product Posting Group")
                {
                    ToolTipML = ENU='Specifies the WHT product posting group you want to use for your journal transactions.',
                                ENA='Specifies the WHT product posting group you want to use for your journal transactions.';
                    Visible = false;
                }
                field("WHT Absorb Base";"WHT Absorb Base")
                {
                    ToolTipML = ENU='Specifies an amount other than the Amount field in the journal, if you want WHT to be calculated on a different amount than Amount field.',
                                ENA='Specifies an amount other than the Amount field in the journal, if you want WHT to be calculated on a different amount than Amount field.';
                    Visible = false;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the salesperson or purchaser who is linked to the journal line.',
                                ENA='Specifies the salesperson or purchaser who is linked to the journal line.';
                    Visible = false;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ToolTipML = ENU='Specifies the number of the campaign the journal line is linked to.',
                                ENA='Specifies the number of the campaign the journal line is linked to.';
                    Visible = false;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    AssistEdit = true;
                    ToolTipML = ENU='Specifies the code of the currency for the amounts on the journal line.',
                                ENA='Specifies the code of the currency for the amounts on the journal line.';
                    Visible = false;

                    trigger OnAssistEdit();
                    begin
                        ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN
                          VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);

                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Gen. Posting Type";"Gen. Posting Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the general posting type that will be used when you post the entry on this journal line.',
                                ENA='Specifies the general posting type that will be used when you post the entry on this journal line.';
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.',
                                ENA='Specifies the vendor''s trade type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the vendor''s product type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.',
                                ENA='Specifies the vendor''s product type to link transactions made for this vendor with the appropriate general ledger account according to the general posting setup.';
                }
                field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
                {
                    ToolTipML = ENU='Specifies the VAT business posting group code that will be used when you post the entry on the journal line.',
                                ENA='Specifies the GST business posting group code that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the GST product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the total amount (including VAT) that the journal line consists of.',
                                ENA='Specifies the total amount (including GST) that the journal line consists of.';
                }
                field("Debit Amount";"Debit Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the total amount (including VAT) that the journal line consists of, if it is a debit amount.',
                                ENA='Specifies the total amount (including GST) that the journal line consists of, if it is a debit amount.';
                    Visible = false;
                }
                field("Credit Amount";"Credit Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the total amount (including VAT) that the journal line consists of, if it is a credit amount.',
                                ENA='Specifies the total amount (including GST) that the journal line consists of, if it is a credit amount.';
                    Visible = false;
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of VAT included in the total amount.',
                                ENA='Specifies the amount of GST included in the total amount.';
                    Visible = false;
                }
                field("VAT Difference";"VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.',
                                ENA='Specifies the difference between the calculate GST amount and the GST amount that you have entered manually.';
                    Visible = false;
                }
                field("Vendor Exchange Rate (ACY)";"Vendor Exchange Rate (ACY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Contains Exchange Rates (ACY) for vendor.',
                                ENA='Contains Exchange Rates (ACY) for vendor.';
                }
                field("Bal. VAT Amount";"Bal. VAT Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of Bal. VAT included in the total amount.',
                                ENA='Specifies the amount of Bal. GST included in the total amount.';
                    Visible = false;
                }
                field("Bal. VAT Difference";"Bal. VAT Difference")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the difference between the calculate VAT amount and the VAT amount that you have entered manually.',
                                ENA='Specifies the difference between the calculate GST amount and the GST amount that you have entered manually.';
                    Visible = false;
                }
                field("Bal. Account Type";"Bal. Account Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the code for the balancing account type that should be used in this journal line.',
                                ENA='Specifies the code for the balancing account type that should be used in this journal line.';
                }
                field("Bal. Account No.";"Bal. Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).',
                                ENA='Specifies the number of the general ledger, customer, vendor, or bank account to which a balancing entry for the journal line will posted (for example, a cash account for cash purchases).';

                    trigger OnValidate();
                    begin
                        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Bal. Gen. Posting Type";"Bal. Gen. Posting Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.',
                                ENA='Specifies the general posting type associated with the balancing account that will be used when you post the entry on the journal line.';
                }
                field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.',
                                ENA='Specifies the general business posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.',
                                ENA='Specifies the general product posting group code associated with the balancing account that will be used when you post the entry.';
                }
                field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the GST business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the GST product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bill-to/Pay-to No.";"Bill-to/Pay-to No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the address code of the bill-to customer or pay-to vendor that the entry is linked to.',
                                ENA='Specifies the address code of the bill-to customer or pay-to vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Ship-to/Order Address Code";"Ship-to/Order Address Code")
                {
                    ToolTipML = ENU='Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.',
                                ENA='Specifies the address code of the ship-to customer or order-from vendor that the entry is linked to.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the code for Shortcut Dimension 1.',
                                ENA='Specifies the code for Shortcut Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the code for Shortcut Dimension 2.',
                                ENA='Specifies the code for Shortcut Dimension 2.';
                    Visible = false;
                }
                field("ShortcutDimCode[3]";ShortcutDimCode[3])
                {
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(3), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(4), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(7), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(8), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Sales/Purch. (LCY)";"Sales/Purch. (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the line''s net amount (the amount excluding VAT) if you are using this journal line for an invoice.',
                                ENA='Specifies the line''s net amount (the amount excluding GST) if you are using this journal line for an invoice.';
                    Visible = false;
                }
                field("Inv. Discount (LCY)";"Inv. Discount (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of the invoice discount if you are using this journal line for an invoice.',
                                ENA='Specifies the amount of the invoice discount if you are using this journal line for an invoice.';
                    Visible = false;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the code that represents the payments terms that apply to the entry on the journal line.',
                                ENA='Specifies the code that represents the payments terms that apply to the entry on the journal line.';
                    Visible = false;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the due date on the entry.',
                                ENA='Specifies the due date on the entry.';
                    Visible = false;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the last date on which the amount in the journal line must be paid for the order to qualify for a payment discount.',
                                ENA='Specifies the last date on which the amount in the journal line must be paid for the order to qualify for a payment discount.';
                    Visible = false;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the possible payment discount percentage for the journal line.',
                                ENA='Specifies the possible payment discount percentage for the journal line.';
                    Visible = false;
                }
                field("Applies-to Doc. Type";"Applies-to Doc. Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.',
                                ENA='Specifies the type of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to Doc. No.";"Applies-to Doc. No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.',
                                ENA='Specifies the number of the posted document that this document or journal line will be applied to when you post, for example to register payment.';
                }
                field("Applies-to ID";"Applies-to ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the entries that will be applied to by the journal line if you use the Apply Entries facility.',
                                ENA='Specifies the entries that will be applied to by the journal line if you use the Apply Entries facility.';
                    Visible = false;
                }
                field("On Hold";"On Hold")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.',
                                ENA='Specifies if the journal line has been invoiced, and you execute the payment suggestions batch job, or you create a finance charge memo or reminder.';
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the reason code that has been entered on the journal lines.',
                                ENA='Specifies the reason code that has been entered on the journal lines.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ToolTipML = ENU='Specifies a comment related to registering a payment.',
                                ENA='Specifies a comment related to registering a payment.';
                    Visible = false;
                }
            }
            group(Control28)
            {
                fixed(Control1902205001)
                {
                    group("Account Name")
                    {
                        CaptionML = ENU='Account Name',
                                    ENA='Account Name';
                        field(AccName;AccName)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                            ToolTipML = ENU='Specifies the name of the account.',
                                        ENA='Specifies the name of the account.';
                        }
                    }
                    group("Bal. Account Name")
                    {
                        CaptionML = ENU='Bal. Account Name',
                                    ENA='Bal. Account Name';
                        field(BalAccName;BalAccName)
                        {
                            ApplicationArea = Basic,Suite;
                            CaptionML = ENU='Bal. Account Name',
                                        ENA='Bal. Account Name';
                            Editable = false;
                            ToolTipML = ENU='Specifies the name of the balancing account that has been entered on the journal line.',
                                        ENA='Specifies the name of the balancing account that has been entered on the journal line.';
                        }
                    }
                    group(Control1903866901)
                    {
                        CaptionML = ENU='Balance',
                                    ENA='Balance';
                        field(Balance;Balance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            CaptionML = ENU='Balance',
                                        ENA='Balance';
                            Editable = false;
                            ToolTipML = ENU='Specifies the balance that has accumulated in the purchase journal on the line where the cursor is.',
                                        ENA='Specifies the balance that has accumulated in the purchase journal on the line where the cursor is.';
                            Visible = BalanceVisible;
                        }
                    }
                    group("Total Balance")
                    {
                        CaptionML = ENU='Total Balance',
                                    ENA='Total Balance';
                        field(TotalBalance;TotalBalance + "Balance (LCY)" - xRec."Balance (LCY)")
                        {
                            ApplicationArea = All;
                            AutoFormatType = 1;
                            CaptionML = ENU='Total Balance',
                                        ENA='Total Balance';
                            Editable = false;
                            ToolTipML = ENU='Specifies the total balance in the purchase journal.',
                                        ENA='Specifies the total balance in the purchase journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(Control1900919607;"Dimension Set Entries FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Dimension Set ID=FIELD(Dimension Set ID);
            }
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic,Suite;
                ShowFilter = false;
            }
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
            group("&Line")
            {
                CaptionML = ENU='&Line',
                            ENA='&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
                    CaptionML = ENU='Dimensions',
                                ENA='Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTipML = ENU='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                ENA='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                        CurrPage.SAVERECORD;
                    end;
                }
            }
            group("A&ccount")
            {
                CaptionML = ENU='A&ccount',
                            ENA='A&ccount';
                Image = ChartOfAccounts;
                action(Card)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Card',
                                ENA='Card';
                    Image = EditLines;
                    RunObject = Codeunit "Gen. Jnl.-Show Card";
                    ShortCutKey = 'Shift+F7';
                    ToolTipML = ENU='View or change detailed information about the record that is being processed on the journal line.',
                                ENA='View or change detailed information about the record that is being processed on the journal line.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Ledger E&ntries',
                                ENA='Ledger E&ntries';
                    Image = GLRegisters;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Show Entries";
                    ShortCutKey = 'Ctrl+F7';
                    ToolTipML = ENU='View the history of transactions that have been posted for the selected record.',
                                ENA='View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU='F&unctions',
                            ENA='F&unctions';
                Image = "Action";
                action("Renumber Document Numbers")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Renumber Document Numbers',
                                ENA='Renumber Document Numbers';
                    Image = EditLines;
                    ToolTipML = ENU='Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.',
                                ENA='Resort the numbers in the Document No. column to avoid posting errors because the document numbers are not in sequence. Entry applications and line groupings are preserved.';

                    trigger OnAction();
                    begin
                        RenumberDocumentNo
                    end;
                }
                action("Apply Entries")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Apply Entries',
                                ENA='Apply Entries';
                    Ellipsis = true;
                    Image = ApplyEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Codeunit "Gen. Jnl.-Apply";
                    ShortCutKey = 'Shift+F11';
                    ToolTipML = ENU='Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.',
                                ENA='Select one or more ledger entries that you want to apply this record to so that the related posted documents are closed as paid or refunded.';
                }
                action("Insert Conv. LCY Rndg. Lines")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Insert Conv. LCY Rndg. Lines',
                                ENA='Insert Conv. LCY Rndg. Lines';
                    Image = InsertCurrency;
                    RunObject = Codeunit "Adjust Gen. Journal Balance";
                    ToolTipML = ENU='Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.',
                                ENA='Insert a rounding correction line in the journal. This rounding correction line will balance in LCY when amounts in the foreign currency also balance. You can then post the journal.';
                }
                group(IncomingDocument)
                {
                    CaptionML = ENU='Incoming Document',
                                ENA='Incoming Document';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='View Incoming Document',
                                    ENA='View Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;
                        ToolTipML = ENU='View any incoming document records and file attachments that exist for the entry or document.',
                                    ENA='View any incoming document records and file attachments that exist for the entry or document.';

                        trigger OnAction();
                        var
                            IncomingDocument : Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document"=R;
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Select Incoming Document',
                                    ENA='Select Incoming Document';
                        Image = SelectLineToApply;
                        ToolTipML = ENU='Select an incoming document record and file attachment that you want to link to the entry or document.',
                                    ENA='Select an incoming document record and file attachment that you want to link to the entry or document.';

                        trigger OnAction();
                        var
                            IncomingDocument : Record "Incoming Document";
                        begin
                            VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Create Incoming Document from File',
                                    ENA='Create Incoming Document from File';
                        Ellipsis = true;
                        Enabled = NOT HasIncomingDocument;
                        Image = Attach;
                        ToolTipML = ENU='Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.',
                                    ENA='Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                        trigger OnAction();
                        var
                            IncomingDocumentAttachment : Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromGenJnlLine(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Remove Incoming Document',
                                    ENA='Remove Incoming Document';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;
                        ToolTipML = ENU='Remove the link to an incoming document record and file attachment.',
                                    ENA='Remove the link to an incoming document record and file attachment.';

                        trigger OnAction();
                        var
                            IncomingDocument : Record "Incoming Document";
                        begin
                            IF IncomingDocument.GET("Incoming Document Entry No.") THEN
                              IncomingDocument.RemoveLinkToRelatedRecord;
                            "Incoming Document Entry No." := 0;
                            MODIFY(TRUE);
                        end;
                    }
                }
            }
            group("P&osting")
            {
                CaptionML = ENU='P&osting',
                            ENA='P&osting';
                Image = Post;
                action(Reconcile)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Reconcile',
                                ENA='Reconcile';
                    Image = Reconcile;
                    ShortCutKey = 'Ctrl+F11';
                    ToolTipML = ENU='View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.',
                                ENA='View the balances on bank accounts that are marked for reconciliation, usually liquid accounts.';

                    trigger OnAction();
                    begin
                        GLReconcile.SetGenJnlLine(Rec);
                        GLReconcile.RUN;
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Test Report',
                                ENA='Test Report';
                    Ellipsis = true;
                    Image = TestReport;
                    ToolTipML = ENU='View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.',
                                ENA='View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction();
                    begin
                        ReportPrint.PrintGenJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='P&ost',
                                ENA='P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTipML = ENU='Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.',
                                ENA='Finalise the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction();
                    begin
                        CheckAdjustmentAppliesto;
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        COMMIT;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Preview Posting',
                                ENA='Preview Posting';
                    Image = ViewPostedOrder;
                    ToolTipML = ENU='Review the different types of entries that will be created when you post the document or journal.',
                                ENA='Review the different types of entries that will be created when you post the document or journal.';

                    trigger OnAction();
                    var
                        GenJnlPost : Codeunit "Gen. Jnl.-Post";
                    begin
                        GenJnlPost.Preview(Rec);
                    end;
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Post and &Print',
                                ENA='Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTipML = ENU='Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.',
                                ENA='Finalise and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';

                    trigger OnAction();
                    begin
                        CheckAdjustmentAppliesto;
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post+Print",Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        COMMIT;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        UpdateBalance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnInit();
    begin
        TotalBalanceVisible := TRUE;
        BalanceVisible := TRUE;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        UpdateBalance;
        SetUpNewLine(xRec,Balance,BelowxRec);
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage();
    var
        JnlSelected : Boolean;
    begin
        BalAccName := '';
        IF IsOpenedFromBatch THEN BEGIN
          CurrentJnlBatchName := "Journal Batch Name";
          GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
          EXIT;
        END;
        GenJnlManagement.TemplateSelection(PAGE::"Purchase Journal",2,FALSE,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
    end;

    var
        GenJnlManagement : Codeunit GenJnlManagement;
        ReportPrint : Codeunit "Test Report-Print";
        ChangeExchangeRate : Page "Change Exchange Rate";
        GLReconcile : Page Reconciliation;
        CurrentJnlBatchName : Code[10];
        AccName : Text[50];
        BalAccName : Text[50];
        Balance : Decimal;
        TotalBalance : Decimal;
        ShowBalance : Boolean;
        ShowTotalBalance : Boolean;
        ShortcutDimCode : array [8] of Code[20];
        HasIncomingDocument : Boolean;
        [InDataSet]
        BalanceVisible : Boolean;
        [InDataSet]
        TotalBalanceVisible : Boolean;

    local procedure UpdateBalance();
    begin
        GenJnlManagement.CalcBalance(
          Rec,xRec,Balance,TotalBalance,ShowBalance,ShowTotalBalance);
        BalanceVisible := ShowBalance;
        TotalBalanceVisible := ShowTotalBalance;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali();
    begin
        CurrPage.SAVERECORD;
        GenJnlManagement.SetName(CurrentJnlBatchName,Rec);
        CurrPage.UPDATE(FALSE);
    end;
}

