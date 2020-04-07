page 133 "Posted Sales Invoice Subform"
{
    // version NAVW110.00

    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ENA='Lines';
    Editable = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ToolTipML = ENU='Specifies the line type.',
                                ENA='Specifies the line type.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.',
                                ENA='Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.',
                                ENA='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ToolTipML = ENU='Specifies the code of the IC partner that the line has been distributed to.',
                                ENA='Specifies the code of the IC partner that the line has been distributed to.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ToolTipML = ENU='Specifies the variant number of the items sold.',
                                ENA='Specifies the variant number of the items sold.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the name of the item or general ledger account, or some descriptive text.',
                                ENA='Specifies the name of the item or general ledger account, or some descriptive text.';
                }
                field(Narration;Narration)
                {
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ToolTipML = ENU='Specifies a code that explains why the item is returned.',
                                ENA='Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the number of units of the item specified on the line.',
                                ENA='Specifies the number of units of the item specified on the line.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit of measure code for the items sold.',
                                ENA='Specifies the unit of measure code for the items sold.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ToolTipML = ENU='Specifies the unit of measure for the item (bottle or piece, for example).',
                                ENA='Specifies the unit of measure for the item (bottle or piece, for example).';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit cost of the item on the invoice line.',
                                ENA='Specifies the unit cost of the item on the invoice line.';
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the price of one unit of the item on the invoice line.',
                                ENA='Specifies the price of one unit of the item on the invoice line.';
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
                    ToolTipML = ENU='Specifies the line discount % that was given on the line.',
                                ENA='Specifies the line discount % that was given on the line.';
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of the discount given on the line.',
                                ENA='Specifies the amount of the discount given on the line.';
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ToolTipML = ENU='Specifies whether the invoice line could have been included in a possible invoice discount calculation.',
                                ENA='Specifies whether the invoice line could have been included in a possible invoice discount calculation.';
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the job number that the sales invoice line is linked to.',
                                ENA='Specifies the job number that the sales invoice line is linked to.';
                    Visible = false;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the number of the job task that the sales line is linked to.',
                                ENA='Specifies the number of the job task that the sales line is linked to.';
                    Visible = false;
                }
                field("Job Contract Entry No.";"Job Contract Entry No.")
                {
                    ToolTipML = ENU='Specifies the entry number of the job planning line that the sales line is linked to.',
                                ENA='Specifies the entry number of the job planning line that the sales line is linked to.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of the item ledger entry this invoice line was applied to.',
                                ENA='Specifies the number of the item ledger entry this invoice line was applied to.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.',
                                ENA='Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
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
            group(Control28)
            {
                group(Control23)
                {
                    field("Invoice Discount Amount";TotalSalesInvoiceHeader."Invoice Discount Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATCaption(TotalSalesInvoiceHeader."Prices Including VAT");
                        CaptionML = ENU='Invoice Discount Amount',
                                    ENA='Invoice Discount Amount';
                        Editable = false;
                        ToolTipML = ENU='Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.',
                                    ENA='Specifies a discount amount that is deducted from the value in the Total Incl. GST field. You can enter or change the amount manually.';
                    }
                }
                group(Control9)
                {
                    field("Total Amount Excl. VAT";TotalSalesInvoiceHeader.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(TotalSalesInvoiceHeader."Currency Code");
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
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(TotalSalesInvoiceHeader."Currency Code");
                        CaptionML = ENU='Total VAT',
                                    ENA='Total GST';
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of VAT amounts on all lines in the document.',
                                    ENA='Specifies the sum of GST amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalSalesInvoiceHeader."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = TotalSalesInvoiceHeader."Currency Code";
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(TotalSalesInvoiceHeader."Currency Code");
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
                action(ItemShipmentLines)
                {
                    CaptionML = ENU='Item Shipment &Lines',
                                ENA='Item Shipment &Lines';
                    Image = ShipmentLines;

                    trigger OnAction();
                    begin
                        IF NOT (Type IN [Type::Item,Type::"Charge (Item)"]) THEN
                          TESTFIELD(Type);
                        ShowItemShipmentLines;
                    end;
                }
                action(DeferralSchedule)
                {
                    ApplicationArea = Suite;
                    CaptionML = ENU='Deferral Schedule',
                                ENA='Deferral Schedule';
                    Enabled = "Deferral Code" <> '';
                    Image = PaymentPeriod;
                    ToolTipML = ENU='View the deferral schedule that governs how revenue made with this sales document was deferred to different accounting periods when the document was posted.',
                                ENA='View the deferral schedule that governs how revenue made with this sales document was deferred to different accounting periods when the document was posted.';

                    trigger OnAction();
                    begin
                        ShowDeferrals;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        DocumentTotals.CalculatePostedSalesInvoiceTotals(TotalSalesInvoiceHeader,VATAmount,Rec);
    end;

    var
        TotalSalesInvoiceHeader : Record "Sales Invoice Header";
        DocumentTotals : Codeunit "Document Totals";
        VATAmount : Decimal;
}

