page 255 "Cash Receipt Journal"
{
    // version NAVW110.00.00.16177,NAVAPAC10.00.00.16177

    AutoSplitKey = true;
    CaptionML = ENU='Cash Receipt Journal',
                ENA='Cash Receipt Journal';
    DataCaptionExpression = DataCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    PromotedActionCategoriesML = ENU='New,Process,Report,Approve',
                                 ENA='New,Process,Report,Approve';
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
                ToolTipML = ENU='Specifies the batch name on the cash receipt journal.',
                            ENA='Specifies the batch name on the cash receipt journal.';

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
                    ToolTipML = ENU='Specifies the general posting type that will be used when you post the entry on this journal line.',
                                ENA='Specifies the general posting type that will be used when you post the entry on this journal line.';
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the general business posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the general product posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
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
                field("WHT Payment";"WHT Payment")
                {
                    ToolTipML = ENU='Specifies during manual calculation of WHT that the cash receipt is only for WHT and no VAT calculation shall be done for this transaction.',
                                ENA='Specifies during manual calculation of WHT that the cash receipt is only for WHT and no GST calculation shall be done for this transaction.';
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
                    ToolTipML = ENU='Specifies the general posting type that will be used when you post the entry on the journal line.',
                                ENA='Specifies the general posting type that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Bus. Posting Group";"Bal. Gen. Bus. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the general business posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the general business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. Gen. Prod. Posting Group";"Bal. Gen. Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the general product posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the general product posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Bal. VAT Bus. Posting Group";"Bal. VAT Bus. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the VAT business posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the GST business posting group that will be used when you post the entry on the journal line.';
                    Visible = false;
                }
                field("Customer/Vendor Bank";"Customer/Vendor Bank")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the customer or vendor bank for the electronic funds transfer (EFT) journal line.',
                                ENA='Specifies the customer or vendor bank for the electronic funds transfer (EFT) journal line.';
                    Visible = true;
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the Customer BSB or Bank Branch Number.',
                                ENA='Specifies the Customer BSB or Bank Branch Number.';
                    Visible = true;
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the Customer Bank Account Number.',
                                ENA='Specifies the Customer Bank Account Number.';
                    Visible = true;
                }
                field("Bal. VAT Prod. Posting Group";"Bal. VAT Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code of the VAT product posting group that will be used when you post the entry on the journal line.',
                                ENA='Specifies the code of the GST product posting group that will be used when you post the entry on the journal line.';
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
                field("Applied (Yes/No)";IsApplied)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Applied (Yes/No)',
                                ENA='Applied (Yes/No)';
                    ToolTipML = ENU='Specifies if the payment has been applied.',
                                ENA='Specifies if the payment has been applied.';
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
                field("Direct Debit Mandate ID";"Direct Debit Mandate ID")
                {
                    ToolTipML = ENU='Specifies the identification of the direct-debit mandate that is being used on the journal lines to process a direct debit collection.',
                                ENA='Specifies the identification of the direct-debit mandate that is being used on the journal lines to process a direct debit collection.';
                    Visible = false;
                }
            }
            group(Control24)
            {
                fixed(Control1903561801)
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
                    group(Control1900545401)
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
                            ToolTipML = ENU='Specifies the balance that has accumulated in the cash receipt journal on the line where the cursor is.',
                                        ENA='Specifies the balance that has accumulated in the cash receipt journal on the line where the cursor is.';
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
                            ToolTipML = ENU='Specifies the total balance in the cash receipt journal.',
                                        ENA='Specifies the total balance in the cash receipt journal.';
                            Visible = TotalBalanceVisible;
                        }
                    }
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox;"Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic,Suite;
                ShowFilter = false;
            }
            part(Control1900919607;"Dimension Set Entries FactBox")
            {
                SubPageLink = Dimension Set ID=FIELD(Dimension Set ID);
                Visible = false;
            }
            part(WorkflowStatusBatch;"Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                CaptionML = ENU='Batch Workflows',
                            ENA='Batch Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnBatch;
            }
            part(WorkflowStatusLine;"Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                CaptionML = ENU='Line Workflows',
                            ENA='Line Workflows';
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatusOnLine;
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
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document"=R;
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Incoming Document',
                                ENA='Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTipML = ENU='View or create an incoming document record that is linked to the entry or document.',
                                ENA='View or create an incoming document record that is linked to the entry or document.';

                    trigger OnAction();
                    var
                        IncomingDocument : Record "Incoming Document";
                    begin
                        VALIDATE("Incoming Document Entry No.",IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.",RECORDID));
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
            action(Approvals)
            {
                AccessByPermission = TableData "Approval Entry"=R;
                ApplicationArea = Suite;
                CaptionML = ENU='Approvals',
                            ENA='Approvals';
                Image = Approvals;
                ToolTipML = ENU='View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.',
                            ENA='View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction();
                var
                    GenJournalLine : Record "Gen. Journal Line";
                    ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                begin
                    GetCurrentlySelectedLines(GenJournalLine);
                    ApprovalsMgmt.ShowJournalApprovalEntries(GenJournalLine);
                end;
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
                separator(Separator1500002)
                {
                }
                action(CancelPostDatedCheck)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Cancel Post Dated Check',
                                ENA='Cancel Post Dated Cheque';
                    Image = VoidExpiredCheck;

                    trigger OnAction();
                    begin
                        PostDatedCheckMgt.CancelCheck(Rec);
                    end;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
                action("Print &Deposit Slip")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Print &Deposit Slip',
                                ENA='Print &Deposit Slip';
                    Image = PrintCheck;

                    trigger OnAction();
                    var
                        GenJournalLine : Record "Gen. Journal Line";
                        DepositSlip : Report Report28023;
                    begin
                        GenJournalLine.SETRANGE("Journal Template Name","Journal Template Name");
                        GenJournalLine.SETRANGE("Journal Batch Name","Journal Batch Name");
                        DepositSlip.SETTABLEVIEW(GenJournalLine);
                        DepositSlip.RUNMODAL;
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
            group("Request Approval")
            {
                CaptionML = ENU='Request Approval',
                            ENA='Request Approval';
                group(SendApprovalRequest)
                {
                    CaptionML = ENU='Send Approval Request',
                                ENA='Send Approval Request';
                    Image = SendApprovalRequest;
                    action(SendApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Suite;
                        CaptionML = ENU='Journal Batch',
                                    ENA='Journal Batch';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrAnyJnlLineExist;
                        Image = SendApprovalRequest;
                        ToolTipML = ENU='Send all journal lines for approval, also those that you may not see because of filters.',
                                    ENA='Send all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction();
                        var
                            ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TrySendJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                        end;
                    }
                    action(SendApprovalRequestJournalLine)
                    {
                        ApplicationArea = Suite;
                        CaptionML = ENU='Selected Journal Lines',
                                    ENA='Selected Journal Lines';
                        Enabled = NOT OpenApprovalEntriesOnBatchOrCurrJnlLineExist;
                        Image = SendApprovalRequest;
                        ToolTipML = ENU='Send selected journal lines for approval.',
                                    ENA='Send selected journal lines for approval.';

                        trigger OnAction();
                        var
                            GenJournalLine : Record "Gen. Journal Line";
                            ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TrySendJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
                group(CancelApprovalRequest)
                {
                    CaptionML = ENU='Cancel Approval Request',
                                ENA='Cancel Approval Request';
                    Image = Cancel;
                    action(CancelApprovalRequestJournalBatch)
                    {
                        ApplicationArea = Suite;
                        CaptionML = ENU='Journal Batch',
                                    ENA='Journal Batch';
                        Enabled = CanCancelApprovalForJnlBatch;
                        Image = CancelApprovalRequest;
                        ToolTipML = ENU='Cancel sending all journal lines for approval, also those that you may not see because of filters.',
                                    ENA='Cancel sending all journal lines for approval, also those that you may not see because of filters.';

                        trigger OnAction();
                        var
                            ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.TryCancelJournalBatchApprovalRequest(Rec);
                            SetControlAppearance;
                        end;
                    }
                    action(CancelApprovalRequestJournalLine)
                    {
                        ApplicationArea = Suite;
                        CaptionML = ENU='Selected Journal Lines',
                                    ENA='Selected Journal Lines';
                        Enabled = CanCancelApprovalForJnlLine;
                        Image = CancelApprovalRequest;
                        ToolTipML = ENU='Cancel sending selected journal lines for approval.',
                                    ENA='Cancel sending selected journal lines for approval.';

                        trigger OnAction();
                        var
                            GenJournalLine : Record "Gen. Journal Line";
                            ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                        begin
                            GetCurrentlySelectedLines(GenJournalLine);
                            ApprovalsMgmt.TryCancelJournalLineApprovalRequests(GenJournalLine);
                        end;
                    }
                }
            }
            group(Approval)
            {
                CaptionML = ENU='Approval',
                            ENA='Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    CaptionML = ENU='Approve',
                                ENA='Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTipML = ENU='Approve the requested changes.',
                                ENA='Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveGenJournalLineRequest(Rec);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    CaptionML = ENU='Reject',
                                ENA='Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTipML = ENU='Reject the approval request.',
                                ENA='Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectGenJournalLineRequest(Rec);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    CaptionML = ENU='Delegate',
                                ENA='Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTipML = ENU='Delegate the approval to a substitute approver.',
                                ENA='Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateGenJournalLineRequest(Rec);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    CaptionML = ENU='Comments',
                                ENA='Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTipML = ENU='View or add comments.',
                                ENA='View or add comments.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        GenJournalBatch : Record "Gen. Journal Batch";
                        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
                    begin
                        IF OpenApprovalEntriesOnJnlLineExist THEN
                          ApprovalsMgmt.GetApprovalComment(Rec)
                        ELSE
                          IF OpenApprovalEntriesOnJnlBatchExist THEN
                            IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
                              ApprovalsMgmt.GetApprovalComment(GenJournalBatch);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        GenJournalBatch : Record "Gen. Journal Batch";
    begin
        SetControlAppearance;
        GenJnlManagement.GetAccounts(Rec,AccName,BalAccName);
        UpdateBalance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);

        IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN
          ShowWorkflowStatusOnBatch := CurrPage.WorkflowStatusBatch.PAGE.SetFilterOnWorkflowRecord(GenJournalBatch.RECORDID);
        ShowWorkflowStatusOnLine := CurrPage.WorkflowStatusLine.PAGE.SetFilterOnWorkflowRecord(RECORDID);
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
          SetControlAppearance;
          EXIT;
        END;
        GenJnlManagement.TemplateSelection(PAGE::"Cash Receipt Journal",3,FALSE,Rec,JnlSelected);
        IF NOT JnlSelected THEN
          ERROR('');
        GenJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        SetControlAppearance;
    end;

    var
        GenJnlManagement : Codeunit GenJnlManagement;
        ReportPrint : Codeunit "Test Report-Print";
        PostDatedCheckMgt : Codeunit Codeunit28090;
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
        [InDataSet]
        BalanceVisible : Boolean;
        [InDataSet]
        TotalBalanceVisible : Boolean;
        OpenApprovalEntriesExistForCurrUser : Boolean;
        OpenApprovalEntriesOnJnlBatchExist : Boolean;
        OpenApprovalEntriesOnJnlLineExist : Boolean;
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist : Boolean;
        OpenApprovalEntriesOnBatchOrAnyJnlLineExist : Boolean;
        ShowWorkflowStatusOnBatch : Boolean;
        ShowWorkflowStatusOnLine : Boolean;
        CanCancelApprovalForJnlBatch : Boolean;
        CanCancelApprovalForJnlLine : Boolean;

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

    local procedure GetCurrentlySelectedLines(var GenJournalLine : Record "Gen. Journal Line") : Boolean;
    begin
        CurrPage.SETSELECTIONFILTER(GenJournalLine);
        EXIT(GenJournalLine.FINDSET);
    end;

    local procedure SetControlAppearance();
    var
        GenJournalBatch : Record "Gen. Journal Batch";
        ApprovalsMgmt : Codeunit "Approvals Mgmt.";
    begin
        IF GenJournalBatch.GET("Journal Template Name","Journal Batch Name") THEN;
        OpenApprovalEntriesExistForCurrUser :=
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(GenJournalBatch.RECORDID) OR
          ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);

        OpenApprovalEntriesOnJnlBatchExist := ApprovalsMgmt.HasOpenApprovalEntries(GenJournalBatch.RECORDID);
        OpenApprovalEntriesOnJnlLineExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        OpenApprovalEntriesOnBatchOrCurrJnlLineExist := OpenApprovalEntriesOnJnlBatchExist OR OpenApprovalEntriesOnJnlLineExist;

        OpenApprovalEntriesOnBatchOrAnyJnlLineExist :=
          OpenApprovalEntriesOnJnlBatchExist OR
          ApprovalsMgmt.HasAnyOpenJournalLineApprovalEntries("Journal Template Name","Journal Batch Name");

        CanCancelApprovalForJnlBatch := ApprovalsMgmt.CanCancelApprovalForRecord(GenJournalBatch.RECORDID);
        CanCancelApprovalForJnlLine := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
    end;
}

