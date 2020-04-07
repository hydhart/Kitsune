page 141 "Posted Purch. Cr. Memo Subform"
{
    // version NAVW110.00

    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ENA='Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Purch. Cr. Memo Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTipML = ENU='Specifies the line type.',
                                ENA='Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU='Specifies an item number that identifies the item or a general ledger account number that identifies the general ledger account used when posting the line.',
                                ENA='Specifies an item number that identifies the item or a general ledger account number that identifies the general ledger account used when posting the line.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.',
                                ENA='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ToolTipML = ENU='Specifies the code of the IC partner that the line has been distributed to.',
                                ENA='Specifies the code of the IC partner that the line has been distributed to.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ToolTipML = ENU='Specifies the variant code for the item.',
                                ENA='Specifies the variant code for the item.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies either the name of, or a description of, the item or general ledger account.',
                                ENA='Specifies either the name of, or a description of, the item or general ledger account.';
                }
                field(Narration;Narration)
                {
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ToolTipML = ENU='Specifies a code that explains why the item is returned.',
                                ENA='Specifies a code that explains why the item is returned.';
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the number of units of the item specified on the credit memo line.',
                                ENA='Specifies the number of units of the item specified on the CR/Adj note line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit of measure code for the item.',
                                ENA='Specifies the unit of measure code for the item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ToolTipML = ENU='Specifies the unit of measure for the item (bottle or piece, for example).',
                                ENA='Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the direct cost of one item unit.',
                                ENA='Specifies the direct cost of one item unit.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the percentage indirect cost for the item.',
                                ENA='Specifies the percentage indirect cost for the item.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit cost of the item on the line.',
                                ENA='Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the price for one unit of the item.',
                                ENA='Specifies the price for one unit of the item.';
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.',
                                ENA='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the line discount % granted on items on each individual line.',
                                ENA='Specifies the line discount % granted on items on each individual line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the discount amount that was granted on the line.',
                                ENA='Specifies the discount amount that was granted on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ToolTipML = ENU='Specifies whether the credit memo line could have been included in an invoice discount calculation.',
                                ENA='Specifies whether the CR/Adj note line could have been included in an invoice discount calculation.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ToolTipML = ENU='Specifies the job number the purchase invoice line is linked to.',
                                ENA='Specifies the job number the purchase invoice line is linked to.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ToolTipML = ENU='Specifies the production order number.',
                                ENA='Specifies the production order number.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ToolTipML = ENU='Specifies the insurance number on the purchase credit memo line.',
                                ENA='Specifies the insurance number on the purchase CR/Adj note line.';
                    Visible = false;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ToolTipML = ENU='Specifies the budgeted FA number on the purchase credit memo line.',
                                ENA='Specifies the budgeted FA number on the purchase CR/Adj note line.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ToolTipML = ENU='Specifies the FA posting type of the purchase credit memo line.',
                                ENA='Specifies the FA posting type of the purchase CR/Adj note line.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ToolTipML = ENU='Specifies whether depreciation was calculated until the FA posting date of the line.',
                                ENA='Specifies whether depreciation was calculated until the FA posting date of the line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ToolTipML = ENU='Specifies the depreciation book code on the purchase credit memo line.',
                                ENA='Specifies the depreciation book code on the purchase CR/Adj note line.';
                    Visible = false;
                }
                field("Depr. Acquisition Cost";"Depr. Acquisition Cost")
                {
                    ToolTipML = ENU='Specifies whether, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.',
                                ENA='Specifies whether, when this line was posted, the additional acquisition cost posted on the line was depreciated in proportion to the amount by which the fixed asset had already been depreciated.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of a particular item entry to which the credit memo was applied.',
                                ENA='Specifies the number of a particular item entry to which the CR/Adj Note was applied.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.',
                                ENA='Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
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
            }
            group(Control33)
            {
                group(Control23)
                {
                    field("Invoice Discount Amount";TotalPurchCrMemoHdr."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalPurchCrMemoHdr."Prices Including VAT");
                        CaptionML = ENU='Invoice Discount Amount',
                                    ENA='Invoice Discount Amount';
                        Editable = false;
                        ToolTipML = ENU='Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.',
                                    ENA='Specifies a discount amount that is deducted from the value in the Total Incl. GST field. You can enter or change the amount manually.';
                    }
                }
                group(Control9)
                {
                    field("Total Amount Excl. VAT";TotalPurchCrMemoHdr.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        CaptionML = ENU='Total Amount Excl. VAT',
                                    ENA='Total Amount Excl. GST';
                        DrillDown = false;
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.',
                                    ENA='Specifies the sum of the value in the Line Amount Excl. GST field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total VAT Amount";VATAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        CaptionML = ENU='Total VAT',
                                    ENA='Total GST';
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of VAT amounts on all lines in the document.',
                                    ENA='Specifies the sum of GST amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalPurchCrMemoHdr."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalPurchCrMemoHdr."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalPurchCrMemoHdr."Currency Code");
                        CaptionML = ENU='Total Amount Incl. VAT',
                                    ENA='Total Amount Incl. GST';
                        Editable = false;
                        Style = Strong;
                        StyleExpr = TRUE;
                        ToolTipML = ENU='Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.',
                                    ENA='Specifies the sum of the value in the Line Amount Incl. GST field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(DeferralSchedule)
            {
                ApplicationArea = Suite;
                CaptionML = ENU='Deferral Schedule',
                            ENA='Deferral Schedule';
                Image = PaymentPeriod;
                ToolTipML = ENU='View the deferral schedule that governs how expenses paid with this purchase document were deferred to different accounting periods when the document was posted.',
                            ENA='View the deferral schedule that governs how expenses paid with this purchase document were deferred to different accounting periods when the document was posted.';

                trigger OnAction();
                begin
                    ShowDeferrals;
                end;
            }
            group("&Line")
            {
                CaptionML = ENU='&Line',
                            ENA='&Line';
                Image = Line;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    CaptionML = ENU='Dimensions',
                                ENA='Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTipML = ENU='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                ENA='View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';

                    trigger OnAction();
                    begin
                        ShowDimensions;
                    end;
                }
                action(Comments)
                {
                    CaptionML = ENU='Co&mments',
                                ENA='Co&mments';
                    Image = ViewComments;

                    trigger OnAction();
                    begin
                        ShowLineComments;
                    end;
                }
                action(ItemTrackingEntries)
                {
                    CaptionML = ENU='Item &Tracking Entries',
                                ENA='Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction();
                    begin
                        ShowItemTrackingLines;
                    end;
                }
                action(ItemReturnShipmentLines)
                {
                    AccessByPermission = TableData "Return Shipment Header"=R;
                    CaptionML = ENU='Item Return Shipment &Lines',
                                ENA='Item Return Shipment &Lines';

                    trigger OnAction();
                    begin
                        IF NOT (Type IN [Type::Item,Type::"Charge (Item)"]) THEN
                          TESTFIELD(Type);
                        ShowItemReturnShptLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        DocumentTotals.CalculatePostedPurchCreditMemoTotals(TotalPurchCrMemoHdr,VATAmount,Rec);
    end;

    var
        TotalPurchCrMemoHdr : Record "Purch. Cr. Memo Hdr.";
        DocumentTotals : Codeunit "Document Totals";
        VATAmount : Decimal;
}

