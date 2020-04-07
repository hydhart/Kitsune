page 55 "Purch. Invoice Subform"
{
    // version NAVW110.00.00.17501,NAVAPAC10.00.00.17501

    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ENA='Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = WHERE(Document Type=FILTER(Invoice));

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

                    trigger OnValidate();
                    begin
                        NoOnAfterValidate;

                        IF xRec."No." <> '' THEN
                          RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTipML = ENU='Specifies the number of a general ledger account, an item, an additional cost or a fixed asset, depending on what you selected in the Type field.',
                                ENA='Specifies the number of a general ledger account, an item, an additional cost or a fixed asset, depending on what you selected in the Type field.';

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

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
                        InsertExtendedText(FALSE);
                        NoOnAfterValidate;
                    end;

                    trigger OnValidate();
                    begin
                        CrossReferenceNoOnAfterValidat;
                        NoOnAfterValidate;
                    end;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ToolTipML = ENU='Specifies the IC partner code of the partner to whom you want to distribute the cost of the line.',
                                ENA='Specifies the IC partner code of the partner to whom you want to distribute the cost of the line.';
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
                    ToolTipML = ENU='If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.',
                                ENA='If the line is being sent to one of your intercompany partners, this field is used together with the IC Partner Ref. Type field to indicate the item or account in your partner''s company that corresponds to the line.';
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
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ToolTipML = ENU='Specifies the code for the VAT product posting group of the item or general ledger account on this line.',
                                ENA='Specifies the code for the GST product posting group of the item or general ledger account on this line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("WHT Business Posting Group";"WHT Business Posting Group")
                {
                    ToolTipML = ENU='Specifies the WHT Business Posting Group is assigned from the Purchase Header Table and is used for all the WHT calculations.',
                                ENA='Specifies the WHT Business Posting Group is assigned from the Purchase Header Table and is used for all the WHT calculations.';
                    Visible = false;
                }
                field("WHT Product Posting Group";"WHT Product Posting Group")
                {
                    ToolTipML = ENU='Specifies the WHT Product Posting Group is assigned from the Product Entity selected in Purchase Line.',
                                ENA='Specifies the WHT Product Posting Group is assigned from the Product Entity selected in Purchase Line.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Description/Comment',
                                ENA='Description/Comment';
                    ShowMandatory = true;
                    ToolTipML = ENU='Specifies a description of the entry, which is based on the contents of the Type and No. fields.',
                                ENA='Specifies a description of the entry, which is based on the contents of the Type and No. fields.';

                    trigger OnValidate();
                    begin
                        UpdateEditableOnRow;

                        IF "No." = xRec."No." THEN
                          EXIT;

                        ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate;

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
                    ToolTipML = ENU='Specifies the code for the location where the items on the line will be located.',
                                ENA='Specifies the code for the location where the items on the line will be located.';
                }
                field("Bin Code";"Bin Code")
                {
                    ToolTipML = ENU='Specifies a bin code for the item.',
                                ENA='Specifies a bin code for the item.';
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies the number of units of the item that will be specified on the line.',
                                ENA='Specifies the number of units of the item that will be specified on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    ToolTipML = ENU='Specifies the unit of measure code that is valid for the purchase line.',
                                ENA='Specifies the unit of measure code that is valid for the purchase line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ToolTipML = ENU='Specifies the name of the unit of measure for the item, such as 1 bottle or 1 piece.',
                                ENA='Specifies the name of the unit of measure for the item, such as 1 bottle or 1 piece.';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies the direct unit cost of the item on the line.',
                                ENA='Specifies the direct unit cost of the item on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ToolTipML = ENU='Specifies the item''s indirect cost percentage.',
                                ENA='Specifies the item''s indirect cost percentage.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the unit cost of the item on the line.',
                                ENA='Specifies the unit cost of the item on the line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Unit Price (LCY)";"Unit Price (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the price for one unit of the item.',
                                ENA='Specifies the price for one unit of the item.';
                    Visible = false;

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
                field("WHT Absorb Base";"WHT Absorb Base")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the Amount when you want WHT to be calculated on the Amount other than the Line Amount.',
                                ENA='Specifies the Amount when you want WHT to be calculated on the Amount other than the Line Amount.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = NOT RowIsText;
                    Enabled = NOT RowIsText;
                    ToolTipML = ENU='Specifies the line discount percentage that is valid for the item on the line.',
                                ENA='Specifies the line discount percentage that is valid for the item on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the amount of the line discount that will be granted on the purchase line.',
                                ENA='Specifies the amount of the line discount that will be granted on the purchase line.';
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
                    ToolTipML = ENU='Specifies the quantity of the item charge that will be assigned when you post this line.',
                                ENA='Specifies the quantity of the item charge that will be assigned when you post this line.';

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                field("Qty. Assigned";"Qty. Assigned")
                {
                    BlankZero = true;
                    ToolTipML = ENU='Specifies how much of the item charge that has been assigned.',
                                ENA='Specifies how much of the item charge that has been assigned.';

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        UpdateForm(FALSE);
                    end;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the purchase order line.',
                                ENA='If you fill in this field and the Job Task No. field, then a job ledger entry will be posted together with the purchase order line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the number of the job task that corresponds to the purchase document (invoice or credit memo).',
                                ENA='Specifies the number of the job task that corresponds to the purchase document (invoice or CR/Adj note).';
                    Visible = false;
                }
                field("Job Line Type";"Job Line Type")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies a Job Planning Line together with the posting of a job ledger entry.',
                                ENA='Specifies a Job Planning Line together with the posting of a job ledger entry.';
                    Visible = false;
                }
                field("Job Unit Price";"Job Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.',
                                ENA='Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
                    Visible = false;
                }
                field("Job Line Amount";"Job Line Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the net amount of the line that the purchase line applies to.',
                                ENA='Specifies the net amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Discount Amount";"Job Line Discount Amount")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the amount of the discount that the purchase line applies to.',
                                ENA='Specifies the amount of the discount that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Discount %";"Job Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the line discount percent that applies to the item or general ledger expense.',
                                ENA='Specifies the line discount percent that applies to the item or general ledger expense.';
                    Visible = false;
                }
                field("Job Total Price";"Job Total Price")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the gross amount of the line that the purchase line applies to.',
                                ENA='Specifies the gross amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Unit Price (LCY)";"Job Unit Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.',
                                ENA='Specifies the sales price per unit that applies to the item or general ledger expense that will be posted.';
                    Visible = false;
                }
                field("Job Total Price (LCY)";"Job Total Price (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the gross amount of the line, in the local currency.',
                                ENA='Specifies the gross amount of the line, in the local currency.';
                    Visible = false;
                }
                field("Job Line Amount (LCY)";"Job Line Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the net amount of the line that the purchase line applies to.',
                                ENA='Specifies the net amount of the line that the purchase line applies to.';
                    Visible = false;
                }
                field("Job Line Disc. Amount (LCY)";"Job Line Disc. Amount (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTipML = ENU='Specifies the amount of the discount that the purchase line applies to.',
                                ENA='Specifies the amount of the discount that the purchase line applies to.';
                    Visible = false;
                }
                field("Prod. Order No.";"Prod. Order No.")
                {
                    ToolTipML = ENU='Specifies the number of the production order that the purchase order was created for.',
                                ENA='Specifies the number of the production order that the purchase order was created for.';
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ToolTipML = ENU='Specifies the document number of the blanket order from which this purchase line originates.',
                                ENA='Specifies the document number of the blanket order from which this purchase line originates.';
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ToolTipML = ENU='Specifies the line number of the blanket order line from which this purchase line originates.',
                                ENA='Specifies the line number of the blanket order line from which this purchase line originates.';
                    Visible = false;
                }
                field("Insurance No.";"Insurance No.")
                {
                    ToolTipML = ENU='Specifies an insurance number if you have selected the Acquisition Cost option in the FA Posting Type field.',
                                ENA='Specifies an insurance number if you have selected the Acquisition Cost option in the FA Posting Type field.';
                    Visible = false;
                }
                field("Budgeted FA No.";"Budgeted FA No.")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("FA Posting Type";"FA Posting Type")
                {
                    ToolTipML = ENU='Specifies the FA posting type if you have selected Fixed Asset in the Type field for this line.',
                                ENA='Specifies the FA posting type if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ToolTipML = ENU='Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.',
                                ENA='Specifies the code for the depreciation book to which the line will be posted if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Depr. Acquisition Cost";"Depr. Acquisition Cost")
                {
                    ToolTipML = ENU='This field is relevant when you post an additional acquisition cost and a possible salvage value to an already acquired asset.',
                                ENA='This field is relevant when you post an additional acquisition cost and a possible salvage value to an already acquired asset.';
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ToolTipML = ENU='You can use this field if you have selected Fixed Asset in the Type field for this line.',
                                ENA='You can use this field if you have selected Fixed Asset in the Type field for this line.';
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
                    TableRelation = "Deferral Template"."Deferral Code";
                    ToolTipML = ENU='Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.',
                                ENA='Specifies the deferral template that governs how expenses paid with this purchase document are deferred to the different accounting periods when the expenses were incurred.';
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
                    ToolTipML = ENU='Specifies the line''s number.',
                                ENA='Specifies the line''s number.';
                    Visible = false;
                }
            }
            group(Control39)
            {
                group(Control33)
                {
                    field(AmountBeforeDiscount;TotalPurchaseLine."Line Amount")
                    {
                        ApplicationArea = Basic,Suite;
                        AutoFormatExpression = Currency.Code;
                        AutoFormatType = 1;
                        CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code,TotalPurchaseHeader."Prices Including VAT");
                        CaptionML = ENU='Subtotal Excl. VAT',
                                    ENA='Subtotal Excl. GST';
                        Editable = false;
                        ToolTipML = ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.',
                                    ENA='Specifies the sum of the value in the Line Amount Excl. GST field on all lines in the document.';
                    }
                    field(InvoiceDiscountAmount;InvoiceDiscountAmount)
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
                        ToolTipML = ENU='Specifies a discount amount that is deducted from the value in the Total Incl. VAT field. You can enter or change the amount manually.',
                                    ENA='Specifies a discount amount that is deducted from the value in the Total Incl. GST field. You can enter or change the amount manually.';

                        trigger OnValidate();
                        begin
                            InvoiceDiscountAmount := ROUND(TotalPurchaseLine."Line Amount" * InvoiceDiscountPct / 100,Currency."Amount Rounding Precision");
                            ValidateInvoiceDiscountAmount;
                        end;
                    }
                }
                group(Control15)
                {
                    field("Total Amount Excl. VAT";TotalPurchaseLine.Amount)
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
                        ToolTipML = ENU='Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.',
                                    ENA='Specifies the sum of the value in the Line Amount Excl. GST field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
                    }
                    field("Total Amount Incl. VAT";TotalPurchaseLine."Amount Including VAT")
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
            group("F&unctions")
            {
                CaptionML = ENU='F&unctions',
                            ENA='F&unctions';
                Image = "Action";
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
                    ToolTipML = ENU='Insert the extended description that is set up.',
                                ENA='Insert the extended description that is set up.';

                    trigger OnAction();
                    begin
                        InsertExtendedText(TRUE);
                    end;
                }
                action(GetReceiptLines)
                {
                    AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                    CaptionML = ENU='&Get Receipt Lines',
                                ENA='&Get Receipt Lines';
                    Ellipsis = true;
                    Image = Receipt;

                    trigger OnAction();
                    begin
                        GetReceipt;
                    end;
                }
            }
            group("&Line")
            {
                CaptionML = ENU='&Line',
                            ENA='&Line';
                Image = Line;
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
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent)
                        end;
                    }
                    action(Period)
                    {
                        CaptionML = ENU='Period',
                                    ENA='Period';
                        Image = Period;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByPeriod)
                        end;
                    }
                    action(Variant)
                    {
                        CaptionML = ENU='Variant',
                                    ENA='Variant';
                        Image = ItemVariant;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByVariant)
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
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByLocation)
                        end;
                    }
                    action("BOM Level")
                    {
                        CaptionML = ENU='BOM Level',
                                    ENA='BOM Level';
                        Image = BOMLevel;

                        trigger OnAction();
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByBOM)
                        end;
                    }
                }
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
                action(ItemChargeAssignment)
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
                    ToolTipML = ENU='View or edit the deferral schedule that governs how expenses incurred with this purchase document is deferred to different accounting periods when the document is posted.',
                                ENA='View or edit the deferral schedule that governs how expenses incurred with this purchase document is deferred to different accounting periods when the document is posted.';

                    trigger OnAction();
                    var
                        PurchHeader : Record "Purchase Header";
                    begin
                        PurchHeader.GET("Document Type","Document No.");
                        ShowDeferrals(PurchHeader."Posting Date",PurchHeader."Currency Code");
                    end;
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
        ReservePurchLine : Codeunit "Purch. Line-Reserve";
    begin
        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          COMMIT;
          IF NOT ReservePurchLine.DeleteLineConfirm(Rec) THEN
            EXIT(FALSE);
          ReservePurchLine.DeleteLine(Rec);
        END;
    end;

    trigger OnInit();
    begin
        PurchasesPayablesSetup.GET;
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

    var
        Currency : Record Currency;
        PurchasesPayablesSetup : Record "Purchases & Payables Setup";
        TotalPurchaseHeader : Record "Purchase Header";
        TotalPurchaseLine : Record "Purchase Line";
        ApplicationAreaSetup : Record "Application Area Setup";
        TransferExtendedText : Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt : Codeunit "Item Availability Forms Mgt";
        PurchCalcDiscByType : Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals : Codeunit "Document Totals";
        ShortcutDimCode : array [8] of Code[20];
        VATAmount : Decimal;
        InvDiscAmountEditable : Boolean;
        RowIsText : Boolean;
        UnitofMeasureCodeIsChangeable : Boolean;
        InvoiceDiscountAmount : Decimal;
        InvoiceDiscountPct : Decimal;

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount();
    var
        PurchaseHeader : Record "Purchase Header";
    begin
        PurchaseHeader.GET("Document Type","Document No.");
        PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,PurchaseHeader);
        CurrPage.UPDATE(FALSE);
    end;

    local procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Calc.Discount",Rec);
    end;

    local procedure ExplodeBOM();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Explode BOM",Rec);
    end;

    local procedure GetReceipt();
    begin
        CODEUNIT.RUN(CODEUNIT::"Purch.-Get Receipt",Rec);
    end;

    local procedure InsertExtendedText(Unconditionally : Boolean);
    begin
        IF TransferExtendedText.PurchCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
          CurrPage.SAVERECORD;
          TransferExtendedText.InsertPurchExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
          UpdateForm(TRUE);
    end;

    procedure UpdateForm(SetSaveRecord : Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    local procedure NoOnAfterValidate();
    begin
        UpdateEditableOnRow;
        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
          CurrPage.SAVERECORD;
    end;

    local procedure CrossReferenceNoOnAfterValidat();
    begin
        InsertExtendedText(FALSE);
    end;

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalPurchaseLine);

        CurrPage.UPDATE;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    local procedure UpdateEditableOnRow();
    var
        PurchaseLine : Record "Purchase Line";
    begin
        RowIsText := ("No." = '') AND (Description <> '');
        IF NOT RowIsText THEN
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
          UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalPurchaseHeader."No." <> '' THEN BEGIN
          PurchaseLine.SETRANGE("Document No.",TotalPurchaseHeader."No.");
          PurchaseLine.SETRANGE("Document Type",TotalPurchaseHeader."Document Type");
          IF NOT PurchaseLine.ISEMPTY THEN
            InvDiscAmountEditable :=
              PurchCalcDiscByType.InvoiceDiscIsAllowed(TotalPurchaseHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    end;

    local procedure GetTotalPurchHeader();
    begin
        IF NOT TotalPurchaseHeader.GET("Document Type","Document No.") THEN
          CLEAR(TotalPurchaseHeader);
        IF Currency.Code <> TotalPurchaseHeader."Currency Code" THEN
          IF NOT Currency.GET(TotalPurchaseHeader."Currency Code") THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
          END;
    end;

    local procedure CalculateTotals();
    begin
        GetTotalPurchHeader;
        TotalPurchaseHeader.CALCFIELDS("Recalculate Invoice Disc.");

        IF PurchasesPayablesSetup."Calc. Inv. Discount" AND ("Document No." <> '') AND
           (TotalPurchaseHeader."Vendor Posting Group" <> '') AND TotalPurchaseHeader."Recalculate Invoice Disc."
        THEN
          IF FIND THEN
            CalcInvDisc;

        DocumentTotals.CalculatePurchaseTotals(TotalPurchaseLine,VATAmount,Rec);
        InvoiceDiscountAmount := TotalPurchaseLine."Inv. Discount Amount";
        InvoiceDiscountPct := PurchCalcDiscByType.GetVendInvoiceDiscountPct(Rec);
    end;
}

