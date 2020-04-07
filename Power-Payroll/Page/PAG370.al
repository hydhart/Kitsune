page 370 "Bank Account Card"
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585, ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Bank Account Card',
                ENA='Bank Account Card';
    PageType = Card;
    PromotedActionCategoriesML = ENU='New,Process,Report,Bank Statement Service,Bank Account',
                                 ENA='New,Process,Report,Bank Statement Service,Bank Account';
    SourceTable = "Bank Account";

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
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the number of the bank account.',
                                ENA='Specifies the number of the bank account.';

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                          CurrPage.UPDATE;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the name of the bank where you have the bank account.',
                                ENA='Specifies the name of the bank where you have the bank account.';
                }
                field("Bank Branch No.";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Bank Branch No.',
                                ENA='Bank Branch No.';
                    ToolTipML = ENU='Specifies a number of the bank branch.',
                                ENA='Specifies a number of the bank branch.';
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Bank Account No.',
                                ENA='Bank Account No.';
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the number used by the bank for the bank account.',
                                ENA='Specifies the number used by the bank for the bank account.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a search name for the bank account.',
                                ENA='Specifies a search name for the bank account.';
                    Visible = false;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the bank account''s current balance denominated in the applicable foreign currency.',
                                ENA='Specifies the bank account''s current balance denominated in the applicable foreign currency.';
                }
                field("Balance (LCY)";"Balance (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the bank account''s current balance in LCY.',
                                ENA='Specifies the bank account''s current balance in LCY.';
                }
                field("Min. Balance";"Min. Balance")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a minimum balance for the bank account.',
                                ENA='Specifies a minimum balance for the bank account.';
                    Visible = false;
                }
                field("Our Contact Code";"Our Contact Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies a code to specify the employee who is responsible for this bank account.',
                                ENA='Specifies a code to specify the employee who is responsible for this bank account.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies that transactions with the bank account cannot be posted.',
                                ENA='Specifies that transactions with the bank account cannot be posted.';
                }
                field("SEPA Direct Debit Exp. Format";"SEPA Direct Debit Exp. Format")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the SEPA format of the bank file that will be exported when you choose the Create Direct Debit File button in the Direct Debit Collect. Entries window.',
                                ENA='Specifies the SEPA format of the bank file that will be exported when you choose the Create Direct Debit File button in the Direct Debit Collect. Entries window.';
                }
                field("Credit Transfer Msg. Nos.";"Credit Transfer Msg. Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the number series for bank instruction messages that are created with the export file that you create from the Direct Debit Collect. Entries window.',
                                ENA='Specifies the number series for bank instruction messages that are created with the export file that you create from the Direct Debit Collect. Entries window.';
                }
                field("Direct Debit Msg. Nos.";"Direct Debit Msg. Nos.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the number series that will be used on the direct debit file that you export for a direct-debit collection entry in the Direct Debit Collect. Entries window.',
                                ENA='Specifies the number series that will be used on the direct debit file that you export for a direct-debit collection entry in the Direct Debit Collect. Entries window.';
                }
                field("Creditor No.";"Creditor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies your company as the creditor in connection with payment collection from customers using SEPA Direct Debit.',
                                ENA='Specifies your company as the creditor in connection with payment collection from customers using SEPA Direct Debit.';
                }
                field("Bank Name - Data Conversion";"Bank Name - Data Conversion")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies your bank''s data format to enable conversion of bank data by a service provider when you import and export bank files.',
                                ENA='Specifies your bank''s data format to enable conversion of bank data by a service provider when you import and export bank files.';
                }
                field("Bank Clearing Standard";"Bank Clearing Standard")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.',
                                ENA='Specifies the format standard to be used in bank transfers if you use the Bank Clearing Code field to identify you as the sender.';
                }
                field("Bank Clearing Code";"Bank Clearing Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.',
                                ENA='Specifies the code for bank clearing that is required according to the format standard you selected in the Bank Clearing Standard field.';
                }
                group(Control45)
                {
                    Visible = ShowBankLinkingActions;
                    field(OnlineFeedStatementStatus;OnlineFeedStatementStatus)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Bank Account Linking Status',
                                    ENA='Bank Account Linking Status';
                        Editable = false;
                        ToolTipML = ENU='Specifies if the bank account is linked to an online bank account through the bank statement service.',
                                    ENA='Specifies if the bank account is linked to an online bank account through the bank statement service.';

                        trigger OnValidate();
                        begin
                            IF NOT Linked THEN
                              UnlinkStatementProvider
                            ELSE
                              ERROR(OnlineBankAccountLinkingErr);
                        end;
                    }
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTipML = ENU='Specifies the date when the Bank Account card was last modified.',
                                ENA='Specifies the date when the Bank Account card was last modified.';
                }
                group("Payment Match Tolerance")
                {
                    CaptionML = ENU='Payment Match Tolerance',
                                ENA='Payment Match Tolerance';
                    field("Match Tolerance Type";"Match Tolerance Type")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTipML = ENU='Specifies by which tolerance the automatic payment application function will apply the Amount Incl. Tolerance Matched rule for this bank account.',
                                    ENA='Specifies by which tolerance the automatic payment application function will apply the Amount Incl. Tolerance Matched rule for this bank account.';
                    }
                    field("Match Tolerance Value";"Match Tolerance Value")
                    {
                        ApplicationArea = Basic,Suite;
                        DecimalPlaces = 0:2;
                        Importance = Additional;
                        ToolTipML = ENU='Specifies if the automatic payment application function will apply the Amount Incl. Tolerance Matched rule by Percentage or Amount.',
                                    ENA='Specifies if the automatic payment application function will apply the Amount Incl. Tolerance Matched rule by Percentage or Amount.';
                    }
                }
            }
            group(Communication)
            {
                CaptionML = ENU='Communication',
                            ENA='Communication';
                field(Address;Address)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the address of the bank where you have the bank account.',
                                ENA='Specifies the address of the bank where you have the bank account.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies additional address information.',
                                ENA='Specifies additional address information.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the postal code.',
                                ENA='Specifies the postcode.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the city of the bank where you have the bank account.',
                                ENA='Specifies the city of the bank where you have the bank account.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the country/region of the address.',
                                ENA='Specifies the country/region of the address.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the telephone number of the bank where you have the bank account.',
                                ENA='Specifies the telephone number of the bank where you have the bank account.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the name of the bank employee regularly contacted in connection with this bank account.',
                                ENA='Specifies the name of the bank employee regularly contacted in connection with this bank account.';
                }
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Phone No.',
                                ENA='Phone No.';
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the telephone number of the bank where you have the bank account.',
                                ENA='Specifies the telephone number of the bank where you have the bank account.';
                    Visible = false;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the fax number of the bank where you have the bank account.',
                                ENA='Specifies the fax number of the bank where you have the bank account.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the email address associated with the bank account.',
                                ENA='Specifies the email address associated with the bank account.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the home page address associated with the bank account.',
                                ENA='Specifies the home page address associated with the bank account.';
                }
            }
            group(Posting)
            {
                CaptionML = ENU='Posting',
                            ENA='Posting';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the relevant currency code for the bank account.',
                                ENA='Specifies the relevant currency code for the bank account.';
                }
                field("Last Check No.";"Last Check No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the check number of the last check issued from the bank account.',
                                ENA='Specifies the cheque number of the last cheque issued from the bank account.';
                }
                field("Transit No.";"Transit No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies a bank identification number of your own choice.',
                                ENA='Specifies a bank identification number of your own choice.';
                }
                field("Last Statement No.";"Last Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the number of the last bank account statement that was reconciled with this bank account.',
                                ENA='Specifies the number of the last bank account statement that was reconciled with this bank account.';
                }
                field("Last Payment Statement No.";"Last Payment Statement No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the last bank statement that was imported.',
                                ENA='Specifies the last bank statement that was imported.';
                }
                field("Balance Last Statement";"Balance Last Statement")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the balance amount of the last statement reconciliation on the bank account.',
                                ENA='Specifies the balance amount of the last statement reconciliation on the bank account.';

                    trigger OnValidate();
                    begin
                        IF "Balance Last Statement" <> xRec."Balance Last Statement" THEN
                          IF NOT CONFIRM(Text001,FALSE,"No.") THEN
                            ERROR(Text002);
                    end;
                }
                field("Bank Acc. Posting Group";"Bank Acc. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies a code for the bank account posting group for the bank account.',
                                ENA='Specifies a code for the bank account posting group for the bank account.';
                }
            }
            group(Transfer)
            {
                CaptionML = ENU='Transfer',
                            ENA='Transfer';
                field("Bank Branch No.2";"Bank Branch No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Bank Branch No.',
                                ENA='Bank Branch No.';
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies a number of the bank branch.',
                                ENA='Specifies a number of the bank branch.';
                    Visible = false;
                }
                field("Bank Account No.2";"Bank Account No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Bank Account No.',
                                ENA='Bank Account No.';
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the number used by the bank for the bank account.',
                                ENA='Specifies the number used by the bank for the bank account.';
                    Visible = false;
                }
                field("Transit No.2";"Transit No.")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Transit No.',
                                ENA='Transit No.';
                    ToolTipML = ENU='Specifies a bank identification number of your own choice.',
                                ENA='Specifies a bank identification number of your own choice.';
                }
                field("SWIFT Code";"SWIFT Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the international bank identifier code (SWIFT) of the bank where you have the account.',
                                ENA='Specifies the international bank identifier code (SWIFT) of the bank where you have the account.';
                }
                field(IBAN;IBAN)
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTipML = ENU='Specifies the bank account''s international bank account number.',
                                ENA='Specifies the bank account''s international bank account number.';
                }
                field("EFT Bank Code";"EFT Bank Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the bank code for the electronic funds transfer (EFT).',
                                ENA='Specifies the bank code for the electronic funds transfer (EFT).';
                }
                field("EFT BSB No.";"EFT BSB No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the bank, state, and branch number for electronic funds transfer (EFT).',
                                ENA='Specifies the bank, state, and branch number for electronic funds transfer (EFT).';
                }
                field("EFT Security No.";"EFT Security No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the security number for the electronic funds transfer (EFT).',
                                ENA='Specifies the security number for the electronic funds transfer (EFT).';
                }
                field("EFT Security Name";"EFT Security Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the security name for the electronic funds transfer (EFT).',
                                ENA='Specifies the security name for the electronic funds transfer (EFT).';
                }
                field("EFT Balancing Record Required";"EFT Balancing Record Required")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies if you want to create the electronic funds transfer (EFT) file in the self-balancing format.',
                                ENA='Specifies if you want to create the electronic funds transfer (EFT) file in the self-balancing format.';
                }
                field("Bank Statement Import Format";"Bank Statement Import Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the format of the bank statement file that can be imported into this bank account.',
                                ENA='Specifies the format of the bank statement file that can be imported into this bank account.';
                }
                field("Payment Export Format";"Payment Export Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the format of the bank file that will be exported when you choose the Export Payments to File button in the Payment Journal window.',
                                ENA='Specifies the format of the bank file that will be exported when you choose the Export Payments to File button in the Payment Journal window.';
                }
                field("Positive Pay Export Code";"Positive Pay Export Code")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = "Bank Export/Import Setup";
                    ToolTipML = ENU='Specifies a code for the data exchange definition that manages the export of positive-pay files.',
                                ENA='Specifies a code for the data exchange definition that manages the export of positive-pay files.';
                    Visible = false;
                }
            }
            group("Electronic Banking")
            {
                field("E-Banking Customer Name";"E-Banking Customer Name")
                {
                }
                field("DR Transaction Code";"DR Transaction Code")
                {
                }
                field("CR Transaction Code";"CR Transaction Code")
                {
                }
                field("Electronic File Name";"Electronic File Name")
                {
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bank Acc.")
            {
                CaptionML = ENU='&Bank Acc.',
                            ENA='&Bank Acc.';
                Image = Bank;
                action(Statistics)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Statistics',
                                ENA='Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Bank Account Statistics";
                    RunPageLink = No.=FIELD(No.), Date Filter=FIELD(Date Filter), Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter), Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                    ShortCutKey = 'F7';
                    ToolTipML = ENU='View statistical information, such as the value of posted entries, for the record.',
                                ENA='View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    CaptionML = ENU='Co&mments',
                                ENA='Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = Table Name=CONST(Bank Account), No.=FIELD(No.);
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU='Dimensions',
                                ENA='Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = Table ID=CONST(270), No.=FIELD(No.);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTipML = ENU='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                ENA='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';
                }
                action(Balance)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Balance',
                                ENA='Balance';
                    Image = Balance;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "Bank Account Balance";
                    RunPageLink = No.=FIELD(No.), Global Dimension 1 Filter=FIELD(Global Dimension 1 Filter), Global Dimension 2 Filter=FIELD(Global Dimension 2 Filter);
                    ToolTipML = ENU='View a summary of the bank account balance at different periods.',
                                ENA='View a summary of the bank account balance at different periods.';
                }
                action(Statements)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='St&atements',
                                ENA='St&atements';
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = Page "Bank Account Statement List";
                    RunPageLink = Bank Account No.=FIELD(No.);
                    ToolTipML = ENU='View posted bank statements and reconciliations.',
                                ENA='View posted bank statements and reconciliations.';
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Ledger E&ntries',
                                ENA='Ledger E&ntries';
                    Image = BankAccountLedger;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Bank Account Ledger Entries";
                    RunPageLink = Bank Account No.=FIELD(No.);
                    RunPageView = SORTING(Bank Account No.) ORDER(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTipML = ENU='View the history of transactions that have been posted for the selected record.',
                                ENA='View the history of transactions that have been posted for the selected record.';
                }
                action("Chec&k Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Chec&k Ledger Entries',
                                ENA='Che&que Ledger Entries';
                    Image = CheckLedger;
                    RunObject = Page "Check Ledger Entries";
                    RunPageLink = Bank Account No.=FIELD(No.);
                    RunPageView = SORTING(Bank Account No.) ORDER(Descending);
                    ToolTipML = ENU='View check ledger entries that result from posting transactions in a payment journal for the relevant bank account.',
                                ENA='View cheque ledger entries that result from posting transactions in a payment journal for the relevant bank account.';
                }
                action("C&ontact")
                {
                    ApplicationArea = All;
                    CaptionML = ENU='C&ontact',
                                ENA='C&ontact';
                    Image = ContactPerson;
                    ToolTipML = ENU='Open the list of business contacts.',
                                ENA='Open the list of business contacts.';
                    Visible = ContactActionVisible;

                    trigger OnAction();
                    begin
                        ShowContact;
                    end;
                }
                separator(Separator81)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Online Map',
                                ENA='Online Map';
                    Image = Map;
                    ToolTipML = ENU='View the address on an online map.',
                                ENA='View the address on an online map.';

                    trigger OnAction();
                    begin
                        DisplayMap;
                    end;
                }
                action(PagePositivePayEntries)
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU='Positive Pay Entries',
                                ENA='Positive Pay Entries';
                    Image = CheckLedger;
                    RunObject = Page "Positive Pay Entries";
                    RunPageLink = Bank Account No.=FIELD(No.);
                    RunPageView = SORTING(Bank Account No.,Upload Date-Time) ORDER(Descending);
                    ToolTipML = ENU='View the bank ledger entries that are related to Positive Pay transactions.',
                                ENA='View the bank ledger entries that are related to Positive Pay transactions.';
                    Visible = false;
                }
            }
            action(BankAccountReconciliations)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Payment Reconciliation Journals',
                            ENA='Payment Reconciliation Journals';
                Image = BankAccountRec;
                RunObject = Page "Pmt. Reconciliation Journals";
                RunPageLink = Bank Account No.=FIELD(No.);
                RunPageView = SORTING(Bank Account No.);
                ToolTipML = ENU='Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.',
                            ENA='Reconcile your bank account by importing transactions and applying them, automatically or manually, to open customer ledger entries, open vendor ledger entries, or open bank account ledger entries.';
            }
            action("Receivables-Payables")
            {
                CaptionML = ENU='Receivables-Payables',
                            ENA='Receivables-Payables';
                Image = ReceivablesPayables;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Receivables-Payables Lines";
                ToolTipML = ENU='View a summary of receivables for customers and payables for vendors.',
                            ENA='View a summary of receivables for customers and payables for vendors.';
            }
            action(LinkToOnlineBankAccount)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Link to Online Bank Account',
                            ENA='Link to Online Bank Account';
                Enabled = NOT Linked;
                Image = LinkAccount;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTipML = ENU='Create a link to an online bank account from the selected bank account.',
                            ENA='Create a link to an online bank account from the selected bank account.';
                Visible = ShowBankLinkingActions;

                trigger OnAction();
                begin
                    LinkStatementProvider(Rec);
                end;
            }
            action(UnlinkOnlineBankAccount)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Unlink Online Bank Account',
                            ENA='Unlink Online Bank Account';
                Enabled = Linked;
                Image = UnLinkAccount;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTipML = ENU='Remove a link to an online bank account from the selected bank account.',
                            ENA='Remove a link to an online bank account from the selected bank account.';
                Visible = ShowBankLinkingActions;

                trigger OnAction();
                begin
                    UnlinkStatementProvider;
                    CurrPage.UPDATE(TRUE);
                end;
            }
            action(AutomaticBankStatementImportSetup)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Automatic Bank Statement Import Setup',
                            ENA='Automatic Bank Statement Import Setup';
                Enabled = Linked;
                Image = ElectronicBanking;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Auto. Bank Stmt. Import Setup";
                RunPageOnRec = true;
                ToolTipML = ENU='Set up the information for importing bank statement files.',
                            ENA='Set up the information for importing bank statement files.';
                Visible = ShowBankLinkingActions;
            }
        }
        area(processing)
        {
            action("Cash Receipt Journals")
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Cash Receipt Journals',
                            ENA='Cash Receipt Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Cash Receipt Journal";
                ToolTipML = ENU='Create a cash receipt journal line for the bank account, for example, to post a payment receipt.',
                            ENA='Create a cash receipt journal line for the bank account, for example, to post a payment receipt.';
            }
            action("Payment Journals")
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Payment Journals',
                            ENA='Payment Journals';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "Payment Journal";
                ToolTipML = ENU='Create a payment journal line for the bank account, for example, to post a payment.',
                            ENA='Create a payment journal line for the bank account, for example, to post a payment.';
            }
            action(PagePosPayExport)
            {
                ApplicationArea = Suite;
                CaptionML = ENU='Positive Pay Export',
                            ENA='Positive Pay Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Positive Pay Export";
                RunPageLink = No.=FIELD(No.);
                ToolTipML = ENU='Export a Positive Pay file with relevant payment information that you then send to the bank for reference when you process payments to make sure that your bank only clears validated checks and amounts.',
                            ENA='Export a Positive Pay file with relevant payment information that you then send to the bank for reference when you process payments to make sure that your bank only clears validated cheques and amounts.';
                Visible = false;
            }
        }
        area(reporting)
        {
            action(List)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='List',
                            ENA='List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Bank Account - List";
                ToolTipML = ENU='View a list of general information about bank accounts, such as posting group, currency code, minimum balance, and balance.',
                            ENA='View a list of general information about bank accounts, such as posting group, currency code, minimum balance, and balance.';
            }
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Detail Trial Balance',
                            ENA='Detail Trial Balance';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Bank Acc. - Detail Trial Bal.";
                ToolTipML = ENU='View a detailed trial balance for selected checks.',
                            ENA='View a detailed trial balance for selected cheques.';
            }
            action(Action1906306806)
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Receivables-Payables',
                            ENA='Receivables-Payables';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Receivables-Payables";
                ToolTipML = ENU='View a summary of receivables for customers and payables for vendors.',
                            ENA='View a summary of receivables for customers and payables for vendors.';
            }
            action("Check Details")
            {
                ApplicationArea = Basic,Suite;
                CaptionML = ENU='Check Details',
                            ENA='Cheque Details';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Bank Account - Check Details";
                ToolTipML = ENU='View a detailed trial balance for selected checks.',
                            ENA='View a detailed trial balance for selected cheques.';
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        ShowBankLinkingActions := StatementProvidersExist;
    end;

    trigger OnAfterGetRecord();
    begin
        GetOnlineFeedStatementStatus(OnlineFeedStatementStatus,Linked);
        CALCFIELDS("Check Report Name");
    end;

    trigger OnOpenPage();
    var
        Contact : Record Contact;
    begin
        ContactActionVisible := Contact.READPERMISSION;
    end;

    var
        Text001 : TextConst ENU='There may be a statement using the %1.\\Do you want to change Balance Last Statement?',ENA='There may be a statement using the %1.\\Do you want to change Balance Last Statement?';
        Text002 : TextConst ENU='Canceled.',ENA='Cancelled.';
        [InDataSet]
        ContactActionVisible : Boolean;
        Linked : Boolean;
        OnlineBankAccountLinkingErr : TextConst ENU='You must link the bank account to an online bank account.\\Choose the Link to Online Bank Account action.',ENA='You must link the bank account to an online bank account.\\Choose the Link to Online Bank Account action.';
        ShowBankLinkingActions : Boolean;
        OnlineFeedStatementStatus : Option "Not Linked",Linked,"Linked and Auto. Bank Statement Enabled";
}

