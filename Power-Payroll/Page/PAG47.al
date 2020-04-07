page 47 "Sales Invoice Subform"
{
    // version NAVW110.00.00.17501,NAVAPAC10.00.00.17501

    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ENA='Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE(Document Type=FILTER(Invoice));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ToolTipML = ENU='Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.',
                                ENA='Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;

                        IF xRec."No." <> '' THEN
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.',
                                ENA='Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;
                        UpdateEditableOnRow;
                        ShowShortcutDimCode(ShortcutDimCode);
                        IF xRec."No." <> '' THEN
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.',
                                ENA='Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                    Visible = false;

                    trigger OnLookup(Text : Text) : Boolean;
                    begin
                        CrossReferenceNoLookUp;
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;
                    end;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ToolTipML = ENU='Specifies the IC partner code of the partner to whom you want to distribute the revenue of the sales line.',
                                ENA='Specifies the IC partner code of the partner to whom you want to distribute the revenue of the sales line.';
                    Visible = false;
                }
                field("IC Partner Ref. Type";"IC Partner Ref. Type")
                {
                    ToolTipML = ENU='Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.',
                                ENA='Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
                    Visible = false;
                }
                field("IC Partner Reference";"IC Partner Reference")
                {
                    ToolTipML = ENU='Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.',
                                ENA='Specifies the item or account in your IC partner''s company that corresponds to the item or account on the line.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ToolTipML = ENU='Specifies a variant code for the item.',
                                ENA='Specifies a variant code for the item.';
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies that this item is a nonstock item.',
                                ENA='Specifies that this item is a nonstock item.';
                    Visible = false;
                }
                field("WHT Business Posting Group";"WHT Business Posting Group")
                {
                    ToolTipML = ENU='Specifies that the WHT Business Posting Group is assigned from the Sales Header Table and is used for all the WHT Calculations.',
                                ENA='Specifies that the WHT Business Posting Group is assigned from the Sales Header Table and is used for all the WHT Calculations.';
                    Visible = false;
                }
                field("WHT Product Posting Group";"WHT Product Posting Group")
                {
                    ToolTipML = ENU='pecifies that the WHT Product Posting Group is assigned from the Product Entity selected in Sales Line.',
                                ENA='pecifies that the WHT Product Posting Group is assigned from the Product Entity selected in Sales Line.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code for the VAT product posting group of the item, resource, or general ledger account on this line.',
                                ENA='Specifies the code for the GST product posting group of the item, resource, or general ledger account on this line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("VAT %";"VAT %")
                {
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                    ToolTipML = ENU='Specifies a description of the entry, which is based on the contents of the Type and No. fields.',
                                ENA='Specifies a description of the entry, which is based on the contents of the Type and No. fields.';

                    trigger OnValidate();
                    begin
                        UpdateEditableOnRow;

                        IF "No." = xRec."No." THEN
                          EXIT;

                        NoOnAfterValidate;
                        ShowShortcutDimCode(ShortcutDimCode);
                        IF xRec."No." <> '' THEN
                          RedistributeTotalsOnAfterValidate;
                    end;
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
                field("Location Code";"Location Code")
                {
                    ToolTipML = ENU='Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.',
                                ENA='Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = LocationCodeVisible;
                }
                field("Bin Code";"Bin Code")
                {
                    ToolTipML = ENU='Specifies the bin from where items on the sales order line are taken from when they are shipped.',
                                ENA='Specifies the bin from where items on the sales order line are taken from when they are shipped.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies how many units are being sold.',
                                ENA='Specifies how many units are being sold.';

                    trigger OnValidate();
                    begin
                        ValidateAutoReserve;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTipML = ENU='Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.',
                                ENA='Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';

                    trigger OnValidate();
                    begin
                        ValidateAutoReserve;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ToolTipML = ENU='Specifies the unit of measure for the item or resource on the sales line.',
                                ENA='Specifies the unit of measure for the item or resource on the sales line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit cost of the item on the line.',
                                ENA='Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field(PriceExists;PriceExists)
                {
                    CaptionML = ENU='Sales Price Exists',
                                ENA='Sales Price Exists';
                    Editable = false;
                    ToolTipML = ENU='Specifies that there is a specific price for this customer.',
                                ENA='Specifies that there is a specific price for this customer.';
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies the price for one unit on the sales line.',
                                ENA='Specifies the price for one unit on the sales line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ToolTipML = ENU='Specifies the line discount percentage that is valid for the item quantity on the line.',
                                ENA='Specifies the line discount percentage that is valid for the item quantity on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ToolTipML = ENU='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.',
                                ENA='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(LineDiscExists;LineDiscExists)
                {
                    CaptionML = ENU='Sales Line Disc. Exists',
                                ENA='Sales Line Disc. Exists';
                    Editable = false;
                    ToolTipML = ENU='Specifies that there is a specific discount for this customer.',
                                ENA='Specifies that there is a specific discount for this customer.';
                    Visible = false;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of the discount that will be given on the invoice line.',
                                ENA='Specifies the amount of the discount that will be given on the invoice line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ToolTipML = ENU='Specifies whether the invoice line is included when the invoice discount is calculated.',
                                ENA='Specifies whether the invoice line is included when the invoice discount is calculated.';
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the invoice discount amount for the line.',
                                ENA='Specifies the invoice discount amount for the line.';
                    Visible = false;
                }
                field("Allow Item Charge Assignment";"Allow Item Charge Assignment")
                {
                    ToolTipML = ENU='Specifies that you can assign item charges to this line.',
                                ENA='Specifies that you can assign item charges to this line.';
                    Visible = false;
                }
                field("Qty. to Assign";"Qty. to Assign")
                {
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line.',
                                ENA='Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdatePage(FALSE);
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    BlankZero = true;
                    ToolTipML = ENU='Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.',
                                ENA='Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdatePage(FALSE);
                    end;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTipML = ENU='Specifies the job number that the sales line is linked to.',
                                ENA='Specifies the job number that the sales line is linked to.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTipML = ENU='Specifies the number of the job task that the sales line is linked to.',
                                ENA='Specifies the number of the job task that the sales line is linked to.';
                    Visible = false;
                }
                field("Job Contract Entry No.";"Job Contract Entry No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTipML = ENU='Specifies the entry number of the job planning line that the sales line is linked to.',
                                ENA='Specifies the entry number of the job planning line that the sales line is linked to.';
                    Visible = false;
                }
                field("Tax Category";"Tax Category")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the VAT category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate several fields, such as the ClassifiedTaxCategory element in the Item group. It is also used to populate the TaxCategory element in both the TaxSubtotal and AllowanceCharge group. The number is based on the UNCL5305 standard.',
                                ENA='Specifies the GST category in connection with electronic document sending. For example, when you send sales documents through the PEPPOL service, the value in this field is used to populate several fields, such as the ClassifiedTaxCategory element in the Item group. It is also used to populate the TaxCategory element in both the TaxSubtotal and AllowanceCharge group. The number is based on the UNCL5305 standard.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies which shipping agent is used to transport the items on the sales document to the customer.',
                                ENA='Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies which shipping agent service is used to transport the items on the sales document to the customer.',
                                ENA='Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ToolTipML = ENU='Belongs to the Job application area.',
                                ENA='Belongs to the Job application area.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ToolTipML = ENU='Specifies the document number of the blanket order from which this sales line originates.',
                                ENA='Specifies the document number of the blanket order from which this sales line originates.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ToolTipML = ENU='Specifies the line number of the blanket order line from which this sales line originates.',
                                ENA='Specifies the line number of the blanket order line from which this sales line originates.';
                    Visible = false;
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ToolTipML = ENU='Specifies the date that will be used as the FA posting date on FA ledger entries.',
                                ENA='Specifies the date that will be used as the FA posting date on FA ledger entries.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ToolTipML = ENU='Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.',
                                ENA='Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the number of the item ledger entry that the sales credit memo line is applied from.',
                                ENA='Specifies the number of the item ledger entry that the sales CR/Adj note line is applied from.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the item ledger entry number the line should be applied to.',
                                ENA='Specifies the item ledger entry number the line should be applied to.';
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Suite;
                    Enabled = (Type <> Type::"Fixed Asset") AND (Type <> Type::" ");
                    ToolTipML = ENU='Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.',
                                ENA='Specifies the deferral template that governs how revenue earned with this sales document is deferred to the different accounting periods when the good or service was delivered.';
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
                        ValidateSaveShortcutDimCode(3,ShortcutDimCode[3]);
                    end;
                }
                field("ShortcutDimCode[4]";ShortcutDimCode[4])
                {
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(4), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(4,ShortcutDimCode[4]);
                    end;
                }
                field("ShortcutDimCode[5]";ShortcutDimCode[5])
                {
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(5), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(5,ShortcutDimCode[5]);
                    end;
                }
                field("ShortcutDimCode[6]";ShortcutDimCode[6])
                {
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(6), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(6,ShortcutDimCode[6]);
                    end;
                }
                field("ShortcutDimCode[7]";ShortcutDimCode[7])
                {
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(7), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(7,ShortcutDimCode[7]);
                    end;
                }
                field("ShortcutDimCode[8]";ShortcutDimCode[8])
                {
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(8), Dimension Value Type=CONST(Standard), Blocked=CONST(No));
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ValidateSaveShortcutDimCode(8,ShortcutDimCode[8]);
                    end;
                }
                field("Document No.";"Document No.")
                {
                    Editable = false;
                    ToolTipML = ENU='Specifies the document number.',
                                ENA='Specifies the document number.';
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    Editable = false;
                    ToolTipML = ENU='Specifies the line number.',
                                ENA='Specifies the line number.';
                    Visible = false;
                }
            }
            group(Control39)
            {
                group(Control33)
                {
                    field("TotalSalesLine.""Line Amount""";TotalSalesLine."Line Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalSalesHeader."Prices Including VAT");
                        CaptionML = ENU='Subtotal Excl. VAT',
                                    ENA='Subtotal Excl. GST';
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.',
                                    ENA='Specifies the sum of the value in the Line Amount Excl. GST field on all lines in the document.';
                    }
                    field("Invoice Discount Amount";InvoiceDiscountAmount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(FIELDCAPTION("Inv. Discount Amount"),Currency.Code);
                        CaptionML = ENU='Invoice Discount Amount',
                                    ENA='Invoice Discount Amount';
                        Editable = InvDiscAmountEditable;
                        ToolTipML = ENU='Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.',
                                    ENA='Specifies a discount amount that is deducted from the value in the Total Incl. GST field. You can enter or change the amount manually.';

                        trigger OnValidate();
                        begin
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                    field("Invoice Disc. Pct.";InvoiceDiscountPct)
                    {
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Invoice Discount %',
                                    ENA='Invoice Discount %';
                        DecimalPlaces = 0:2;
                        Editable = InvDiscAmountEditable;
                        ToolTipML = ENU='Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.',
                                    ENA='Specifies a discount percentage that is granted if criteria that you have set up for the customer are met.';

                        trigger OnValidate();
                        begin
                            InvoiceDiscountAmount := ROUND(TotalSalesLine."Line Amount" * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control15)
                {
                    field("Total Amount Excl. VAT";TotalSalesLine.Amount)
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
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
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
                        CaptionML = ENU='Total VAT',
                                    ENA='Total GST';
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of VAT amounts on all lines in the document.',
                                    ENA='Specifies the sum of GST amounts on all lines in the document.';
                    }
                    field("Total Amount Incl. VAT";TotalSalesLine."Amount Including VAT")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                        CaptionML = ENU='Total Amount Incl. VAT',
                                    ENA='Total Amount Incl. GST';
                        Editable = false;
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
                group("F&unctions")
                {
                    CaptionML = ENU='F&unctions',
                                ENA='F&unctions';
                    Image = "Action";
                    action("Get &Price")
                    {
                        AccessByPermission = TableData "Sales Price"=R;
                        CaptionML = ENU='Get &Price',
                                    ENA='Get &Price';
                        Ellipsis = true;
                        Image = Price;

                        trigger OnAction();
                        begin
                            ShowPrices
                        end;
                    }
                    action("Get Li&ne Discount")
                    {
                        AccessByPermission = TableData "Sales Line Discount"=R;
                        CaptionML = ENU='Get Li&ne Discount',
                                    ENA='Get Li&ne Discount';
                        Ellipsis = true;
                        Image = LineDiscount;

                        trigger OnAction();
                        begin
                            ShowLineDisc
                        end;
                    }
                    action("E&xplode BOM")
                    {
                        AccessByPermission = TableData "BOM Component"=R;
                        CaptionML = ENU='E&xplode BOM',
                                    ENA='E&xplode BOM';
                        Image = ExplodeBOM;

                        trigger OnAction();
                        begin
                            ExplodeBOM;
                        end;
                    }
                    action(InsertExtTexts)
                    {
                        AccessByPermission = TableData "Extended Text Header"=R;
                        ApplicationArea = Suite;
                        CaptionML = ENU='Insert &Ext. Texts',
                                    ENA='Insert &Ext. Texts';
                        Image = Text;
                        Scope = Repeater;
                        ToolTipML = ENU='Insert the extended item description that is set up for the item on the sales document line.',
                                    ENA='Insert the extended item description that is set up for the item on the sales document line.';

                        trigger OnAction();
                        begin
                            InsertExtendedText(TRUE);
                        end;
                    }
                    action(GetShipmentLines)
                    {
                        AccessByPermission = TableData "Sales Shipment Header"=R;
                        CaptionML = ENU='Get &Shipment Lines',
                                    ENA='Get &Shipment Lines';
                        Ellipsis = true;
                        Image = Shipment;

                        trigger OnAction();
                        begin
                            GetShipment;
                        end;
                    }
                }
                group("Item Availability by")
                {
                    CaptionML = ENU='Item Availability by',
                                ENA='Item Availability by';
                    Image = ItemAvailability;
                    action("Event")
                    {
                        CaptionML = ENU='Event',
                                    ENA='Event';
                        Image = "Event";

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU='Period',
                                    ENA='Period';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU='Variant',
                                    ENA='Variant';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByVariant)
                        end;
                    }
                    action(Location)
                    {
                        AccessByPermission = TableData Location=R;
                        CaptionML = ENU='Location',
                                    ENA='Location';
                        Image = Warehouse;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU='BOM Level',
                                    ENA='BOM Level';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
                group("Related Information")
                {
                    CaptionML = ENU='Related Information',
                                ENA='Related Information';
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Suite;
                        CaptionML = ENU='Dimensions',
                                    ENA='Dimensions';
                        Image = Dimensions;
                        Scope = Repeater;
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTipML = ENU='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.',
                                    ENA='View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyse transaction history.';

                        trigger OnAction();
                        begin
                            ShowDimensions;
                        end;
                    }
                    action("Co&mments")
                    {
                        CaptionML = ENU='Co&mments',
                                    ENA='Co&mments';
                        Image = ViewComments;

                        trigger OnAction();
                        begin
                            ShowLineComments;
                        end;
                    }
                    action("Item Charge &Assignment")
                    {
                        AccessByPermission = TableData "Item Charge"=R;
                        CaptionML = ENU='Item Charge &Assignment',
                                    ENA='Item Charge &Assignment';
                        Image = ItemCosts;

                        trigger OnAction();
                        begin
                            ShowItemChargeAssgnt;
                        end;
                    }
                    action("Item &Tracking Lines")
                    {
                        CaptionML = ENU='Item &Tracking Lines',
                                    ENA='Item &Tracking Lines';
                        Image = ItemTrackingLines;
                        ShortCutKey = 'Shift+Ctrl+I';

                        trigger OnAction();
                        begin
                            OpenItemTrackingLines;
                        end;
                    }
                    action(DeferralSchedule)
                    {
                        ApplicationArea = Suite;
                        CaptionML = ENU='Deferral Schedule',
                                    ENA='Deferral Schedule';
                        Enabled = "Deferral Code" <> '';
                        Image = PaymentPeriod;
                        ToolTipML = ENU='View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.',
                                    ENA='View or edit the deferral schedule that governs how revenue made with this sales document is deferred to different accounting periods when the document is posted.';

                        trigger OnAction();
                        begin
                            TotalSalesHeader.GET("Document Type","Document No.");
                            ShowDeferrals(TotalSalesHeader."Posting Date",TotalSalesHeader."Currency Code");
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        CalculateTotals;
        UpdateEditableOnRow;
    end;

    trigger OnAfterGetRecord();
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnDeleteRecord() : Boolean;
    var
        ReserveSalesLine : Codeunit "Sales Line-Reserve";
    begin
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT ReserveSalesLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          ReserveSalesLine.DeleteLine(Rec);
        END;
    end;

    trigger OnInit();
    begin
        SalesSetup.GET;
        Currency.InitRoundingPrecision;
    end;

    trigger OnInsertRecord(BelowxRec : Boolean) : Boolean;
    begin
        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          Type := Type::Item;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          Type := Type::Item
        ELSE
          InitType;
        CLEAR(ShortcutDimCode);
    end;

    trigger OnOpenPage();
    var
        Location : Record Location;
    begin
        IF Location.READPERMISSION THEN
          LocationCodeVisible := NOT Location.ISEMPTY;
    end;

    var
        TotalSalesHeader : Record "Sales Header";
        TotalSalesLine : Record "Sales Line";
        Currency : Record Currency;
        SalesSetup : Record "Sales & Receivables Setup";
        ApplicationAreaSetup : Record "Application Area Setup";
        TransferExtendedText : Codeunit "Transfer Extended Text";
        SalesPriceCalcMgt : Codeunit "Sales Price Calc. Mgt.";
        ItemAvailFormsMgt : Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscByType : Codeunit "Sales - Calc Discount By Type";
        DocumentTotals : Codeunit "Document Totals";
        VATAmount : Decimal;
        InvoiceDiscountAmount : Decimal;
        InvoiceDiscountPct : Decimal;
        ShortcutDimCode : array [8] of Code[20];
        UpdateAllowedVar : Boolean;
        Text000 : TextConst ENU='Unable to run this function while in View mode.',ENA='Unable to run this function while in View mode.';
        LocationCodeVisible : Boolean;
        InvDiscAmountEditable : Boolean;
        RowIsText : Boolean;
        UnitofMeasureCodeIsChangeable : Boolean;

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount();
    var
        SalesHeader : Record "Sales Header";
    begin
        SalesHeader.GET("Document Type","Document No.");
        SalesCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        CurrPage.UPDATE(FALSE);
    end;

    procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
    end;

    procedure ExplodeBOM();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    end;

    procedure GetShipment();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Get Shipment",Rec);
    end;

    procedure InsertExtendedText(Unconditionally : Boolean);
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
          CurrPage.SAVERECORD;
          COMMIT;
          TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
          UpdatePage(TRUE);
    end;

    procedure UpdatePage(SetSaveRecord : Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure ShowPrices();
    begin
        TotalSalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(TotalSalesHeader,Rec);
    end;

    procedure ShowLineDisc();
    begin
        TotalSalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(TotalSalesHeader,Rec);
    end;

    procedure SetUpdateAllowed(UpdateAllowed : Boolean);
    begin
        UpdateAllowedVar := UpdateAllowed;
    end;

    procedure UpdateAllowed() : Boolean;
    begin
        IF UpdateAllowedVar = FALSE THEN BEGIN
          MESSAGE(Text000);
          EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    local procedure NoOnAfterValidate();
    begin
        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          TESTFIELD(Type,Type::Item);
        InsertExtendedText(FALSE);

        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND (xRec."No." <> '') THEN
          CurrPage.SAVERECORD;
    end;

    local procedure UpdateEditableOnRow();
    var
        SalesLine : Record "Sales Line";
    begin
        RowIsText := ("No." = '') AND (Description <> '');
        IF NOT RowIsText THEN
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
          UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalSalesHeader."No." <> '' THEN BEGIN
          SalesLine.SETRANGE("Document No.",TotalSalesHeader."No.");
          SalesLine.SETRANGE("Document Type",TotalSalesHeader."Document Type");
          IF NOT SalesLine.ISEMPTY THEN
            InvDiscAmountEditable :=
              SalesCalcDiscByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    end;

    local procedure ValidateAutoReserve();
    begin
        IF Reserve = Reserve::Always THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
        END;
    end;

    local procedure GetTotalSalesHeader();
    begin
        IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
          CLEAR(TotalSalesHeader);
        IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
          IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
          END;
    end;

    local procedure CalculateTotals();
    begin
        GetTotalSalesHeader;
        TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");

        IF SalesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND (TotalSalesHeader."Customer Posting Group" <> '') AND
           TotalSalesHeader."Recalculate Invoice Disc."
        THEN
          IF FIND THEN
            CalcInvDisc;

        DocumentTotals.CalculateSalesTotals(TotalSalesLine,VATAmount,Rec);
        InvoiceDiscountAmount := TotalSalesLine."Inv. Discount Amount";
        InvoiceDiscountPct := SalesCalcDiscByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        TotalSalesHeader.GET("Document Type","Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.UPDATE;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;
}

