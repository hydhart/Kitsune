page 46 "Sales Order Subform"
{
    // version NAVW110.00.00.17501

    AutoSplitKey = true;
    CaptionML = ENU='Lines',
                ENA='Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE(Document Type=FILTER(Order));

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
                        SetLocationCodeMandatory;

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

                        QuantityOnAfterValidate;
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

                    trigger OnValidate();
                    begin
                        VariantCodeOnAfterValidate;
                    end;
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies that a substitute is available for the item on the sales line.',
                                ENA='Specifies that a substitute is available for the item on the sales line.';
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    ToolTipML = ENU='Specifies the purchasing code for the item.',
                                ENA='Specifies the purchasing code for the item.';
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
                    ToolTipML = ENU='Specifies the code for the VAT product posting group of the item, resource, or general ledger account on this line.',
                                ENA='Specifies the code for the GST product posting group of the item, resource, or general ledger account on this line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
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
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies if your vendor will ship the items on the line directly to your customer.',
                                ENA='Specifies if your vendor will ship the items on the line directly to your customer.';
                    Visible = false;
                }
                field("Special Order";"Special Order")
                {
                    ToolTipML = ENU='Specifies that the item on the sales line is a special-order item.',
                                ENA='Specifies that the item on the sales line is a special-order item.';
                    Visible = false;
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ToolTipML = ENU='Specifies a code that explains why the item is returned.',
                                ENA='Specifies a code that explains why the item is returned.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    QuickEntry = false;
                    ShowMandatory = LocationCodeMandatory;
                    ToolTipML = ENU='Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.',
                                ENA='Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Visible = LocationCodeVisible;

                    trigger OnValidate();
                    begin
                        LocationCodeOnAfterValidate;
                    end;
                }
                field("Bin Code";"Bin Code")
                {
                    ToolTipML = ENU='Specifies the bin from where items on the sales order line are taken from when they are shipped.',
                                ENA='Specifies the bin from where items on the sales order line are taken from when they are shipped.';
                    Visible = false;
                }
                field(Reserve;Reserve)
                {
                    ToolTipML = ENU='Specifies whether a reservation can be made for items on this line.',
                                ENA='Specifies whether a reservation can be made for items on this line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        ReserveOnAfterValidate;
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies how many units are being sold.',
                                ENA='Specifies how many units are being sold.';

                    trigger OnValidate();
                    begin
                        QuantityOnAfterValidate;
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Qty. to Assemble to Order";"Qty. to Assemble to Order")
                {
                    BlankZero = true;
                    ToolTipML = ENU='Specifies how many units of the sales line quantity that you want to supply by assembly.',
                                ENA='Specifies how many units of the sales line quantity that you want to supply by assembly.';
                    Visible = false;

                    trigger OnDrillDown();
                    begin
                        ShowAsmToOrderLines;
                    end;

                    trigger OnValidate();
                    begin
                        QtyToAsmToOrderOnAfterValidate;
                    end;
                }
                field("Reserved Quantity";"Reserved Quantity")
                {
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies how many units of the item on the line have been reserved.',
                                ENA='Specifies how many units of the item on the line have been reserved.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.',
                                ENA='Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';

                    trigger OnValidate();
                    begin
                        UnitofMeasureCodeOnAfterValida;
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
                field(SalesPriceExist;PriceExists)
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
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ShowMandatory = "No." <> '';
                    ToolTipML = ENU='Specifies the price for one unit on the sales line.',
                                ENA='Specifies the price for one unit on the sales line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ToolTipML = ENU='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.',
                                ENA='Specifies the net amount (before subtracting the invoice discount amount) that must be paid for the items on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field(SalesLineDiscExists;LineDiscExists)
                {
                    CaptionML = ENU='Sales Line Disc. Exists',
                                ENA='Sales Line Disc. Exists';
                    Editable = false;
                    ToolTipML = ENU='Specifies that there is a specific discount for this customer.',
                                ENA='Specifies that there is a specific discount for this customer.';
                    Visible = false;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = RowIsNotText;
                    Enabled = RowIsNotText;
                    ToolTipML = ENU='Specifies the line discount percentage that is valid for the item quantity on the line.',
                                ENA='Specifies the line discount percentage that is valid for the item quantity on the line.';

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
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
                field("Prepayment %";"Prepayment %")
                {
                    ToolTipML = ENU='Specifies the prepayment percentage if a prepayment should apply to the sales line.',
                                ENA='Specifies the prepayment percentage if a prepayment should apply to the sales line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Line Amount";"Prepmt. Line Amount")
                {
                    ToolTipML = ENU='Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.',
                                ENA='Specifies the prepayment amount of the line in the currency of the sales document if a prepayment percentage is specified for the sales line.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        RedistributeTotalsOnAfterValidate;
                    end;
                }
                field("Prepmt. Amt. Inv.";"Prepmt. Amt. Inv.")
                {
                    ToolTipML = ENU='Specifies the prepayment amount that has already been invoiced to the customer for this sales line.',
                                ENA='Specifies the prepayment amount that has already been invoiced to the customer for this sales line.';
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
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies how many units of the item are to be shipped when the sales order is posted.',
                                ENA='Specifies how many units of the item are to be shipped when the sales order is posted.';

                    trigger OnValidate();
                    begin
                        IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
                          CurrPage.SAVERECORD;
                          CurrPage.UPDATE(FALSE);
                        END;
                    end;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the number of units of the ordered item that have been shipped.',
                                ENA='Specifies the number of units of the ordered item that have been shipped.';
                }
                field("Qty. to Invoice";"Qty. to Invoice")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies how much of the line should be invoiced.',
                                ENA='Specifies how much of the line should be invoiced.';
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    ToolTipML = ENU='Specifies how many units of the item on the line have already been invoiced.',
                                ENA='Specifies how many units of the item on the line have already been invoiced.';
                }
                field("Prepmt Amt to Deduct";"Prepmt Amt to Deduct")
                {
                    ToolTipML = ENU='Specifies the prepayment amount that will be deducted from the next ordinary invoice for this line.',
                                ENA='Specifies the prepayment amount that will be deducted from the next ordinary invoice for this line.';
                    Visible = false;
                }
                field("Prepmt Amt Deducted";"Prepmt Amt Deducted")
                {
                    ToolTipML = ENU='Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.',
                                ENA='Specifies the prepayment amount that has already been deducted from ordinary invoices posted for this sales order line.';
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
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line. You fill this field through the Qty. to Assign field in the Item Charge Assignment (Sales) window that you open with the Item Charge Assignment action on the Lines FastTab.',
                                ENA='Specifies the quantity of the item charge that will be assigned to a specified item when you post this sales line. You fill this field through the Qty. to Assign field in the Item Charge Assignment (Sales) window that you open with the Item Charge Assignment action on the Lines FastTab.';

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
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.',
                                ENA='Specifies the quantity of the item charge that was assigned to a specified item when you posted this sales line.';

                    trigger OnDrillDown();
                    begin
                        CurrPage.SAVERECORD;
                        ShowItemChargeAssgnt;
                        CurrPage.UPDATE(FALSE);
                    end;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTipML = ENU='Specifies the date that the customer has asked for the order to be delivered.',
                                ENA='Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        UpdateForm(TRUE);
                    end;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ToolTipML = ENU='Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.',
                                ENA='Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = false;

                    trigger OnValidate();
                    begin
                        UpdateForm(TRUE);
                    end;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the planned date that the shipment will be delivered at the customer''s address.',
                                ENA='Specifies the planned date that the shipment will be delivered at the customer''s address.';

                    trigger OnValidate();
                    begin
                        UpdateForm(TRUE);
                    end;
                }
                field("Planned Shipment Date";"Planned Shipment Date")
                {
                    ToolTipML = ENU='Specifies the date that the shipment should ship from the warehouse.',
                                ENA='Specifies the date that the shipment should ship from the warehouse.';

                    trigger OnValidate();
                    begin
                        UpdateForm(TRUE);
                    end;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    ToolTipML = ENU='Specifies the date that the items on the line are in inventory and available to be picked.',
                                ENA='Specifies the date that the items on the line are in inventory and available to be picked.';

                    trigger OnValidate();
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the code that represents the shipping agent.',
                                ENA='Specifies the code that represents the shipping agent.';
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Suite;
                    ToolTipML = ENU='Specifies the code that represents a shipping agent service.',
                                ENA='Specifies the code that represents a shipping agent service.';
                    Visible = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ToolTipML = ENU='Specifies how long it takes from when the sales order line is shipped from the warehouse to when the order is delivered.',
                                ENA='Specifies how long it takes from when the sales order line is shipped from the warehouse to when the order is delivered.';
                    Visible = false;
                }
                field("Work Type Code";"Work Type Code")
                {
                    ToolTipML = ENU='Belongs to the Job application area.',
                                ENA='Belongs to the Job application area.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty.";"Whse. Outstanding Qty.")
                {
                    ToolTipML = ENU='Specifies how many units on the sales order line remain to be handled in warehouse documents.',
                                ENA='Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("Whse. Outstanding Qty. (Base)";"Whse. Outstanding Qty. (Base)")
                {
                    ToolTipML = ENU='Specifies how many units on the sales order line remain to be handled in warehouse documents.',
                                ENA='Specifies how many units on the sales order line remain to be handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstanding Qty.";"ATO Whse. Outstanding Qty.")
                {
                    ToolTipML = ENU='Specifies how many assemble-to-order units on the sales order line need to be assembled and handled in warehouse documents.',
                                ENA='Specifies how many assemble-to-order units on the sales order line need to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("ATO Whse. Outstd. Qty. (Base)";"ATO Whse. Outstd. Qty. (Base)")
                {
                    ToolTipML = ENU='Specifies how many assemble-to-order units on the sales order line remain to be assembled and handled in warehouse documents.',
                                ENA='Specifies how many assemble-to-order units on the sales order line remain to be assembled and handled in warehouse documents.';
                    Visible = false;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ToolTipML = ENU='Specifies the outbound warehouse handling time.',
                                ENA='Specifies the outbound warehouse handling time.';
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
                    TableRelation = "Deferral Template"."Deferral Code";
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
            group(Control51)
            {
                group(Control45)
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
                group(Control28)
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
                    action(GetPrice)
                    {
                        AccessByPermission = TableData "Sales Price"=R;
                        CaptionML = ENU='Get Price',
                                    ENA='Get Price';
                        Ellipsis = true;
                        Image = Price;

                        trigger OnAction();
                        begin
                            ShowPrices;
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
                    action(ExplodeBOM_Functions)
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
                    action("Insert Ext. Texts")
                    {
                        AccessByPermission = TableData "Extended Text Header"=R;
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Insert &Ext. Texts',
                                    ENA='Insert &Ext. Texts';
                        Image = Text;
                        ToolTipML = ENU='Insert the extended item description that is set up for the item on the sales document line.',
                                    ENA='Insert the extended item description that is set up for the item on the sales document line.';

                        trigger OnAction();
                        begin
                            InsertExtendedText(TRUE);
                        end;
                    }
                    action(Reserve)
                    {
                        CaptionML = ENU='&Reserve',
                                    ENA='&Reserve';
                        Ellipsis = true;
                        Image = Reserve;

                        trigger OnAction();
                        begin
                            FIND;
                            ShowReservation;
                        end;
                    }
                    action(OrderTracking)
                    {
                        CaptionML = ENU='Order &Tracking',
                                    ENA='Order &Tracking';
                        Image = OrderTracking;

                        trigger OnAction();
                        begin
                            ShowTracking;
                        end;
                    }
                    action("Nonstoc&k Items")
                    {
                        AccessByPermission = TableData "Nonstock Item"=R;
                        ApplicationArea = Basic,Suite;
                        CaptionML = ENU='Nonstoc&k Items',
                                    ENA='Nonstoc&k Items';
                        Image = NonStockItem;

                        trigger OnAction();
                        begin
                            ShowNonstockItems;
                        end;
                    }
                }
                group("Item Availability by")
                {
                    CaptionML = ENU='Item Availability by',
                                ENA='Item Availability by';
                    Image = ItemAvailability;
                    action("<Action3>")
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
                    action("Reservation Entries")
                    {
                        AccessByPermission = TableData Item=R;
                        CaptionML = ENU='Reservation Entries',
                                    ENA='Reservation Entries';
                        Image = ReservationLedger;

                        trigger OnAction();
                        begin
                            ShowReservationEntries(TRUE);
                        end;
                    }
                    action(ItemTrackingLines)
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
                    action(SelectItemSubstitution)
                    {
                        AccessByPermission = TableData "Item Substitution"=R;
                        ApplicationArea = Suite;
                        CaptionML = ENU='Select Item Substitution',
                                    ENA='Select Item Substitution';
                        Image = SelectItemSubstitution;
                        ToolTipML = ENU='Select another item that has been set up to be sold instead of the original item if it is unavailable.',
                                    ENA='Select another item that has been set up to be sold instead of the original item if it is unavailable.';

                        trigger OnAction();
                        begin
                            CurrPage.SAVERECORD;
                            ShowItemSub;
                            CurrPage.UPDATE(TRUE);
                            AutoReserve;
                        end;
                    }
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension=R;
                        CaptionML = ENU='Dimensions',
                                    ENA='Dimensions';
                        Image = Dimensions;
                        ShortCutKey = 'Shift+Ctrl+D';

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
                            ItemChargeAssgnt;
                        end;
                    }
                    action(OrderPromising)
                    {
                        AccessByPermission = TableData "Order Promising Line"=R;
                        CaptionML = ENU='Order &Promising',
                                    ENA='Order &Promising';
                        Image = OrderPromising;

                        trigger OnAction();
                        begin
                            OrderPromisingLine;
                        end;
                    }
                    group("Assemble to Order")
                    {
                        CaptionML = ENU='Assemble to Order',
                                    ENA='Assemble to Order';
                        Image = AssemblyBOM;
                        action(AssembleToOrderLines)
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            CaptionML = ENU='Assemble-to-Order Lines',
                                        ENA='Assemble-to-Order Lines';

                            trigger OnAction();
                            begin
                                ShowAsmToOrderLines;
                            end;
                        }
                        action("Roll Up &Price")
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            CaptionML = ENU='Roll Up &Price',
                                        ENA='Roll Up &Price';
                            Ellipsis = true;

                            trigger OnAction();
                            begin
                                RollupAsmPrice;
                            end;
                        }
                        action("Roll Up &Cost")
                        {
                            AccessByPermission = TableData "BOM Component"=R;
                            CaptionML = ENU='Roll Up &Cost',
                                        ENA='Roll Up &Cost';
                            Ellipsis = true;

                            trigger OnAction();
                            begin
                                RollUpAsmCost;
                            end;
                        }
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
                            SalesHeader.GET("Document Type","Document No.");
                            ShowDeferrals(SalesHeader."Posting Date",SalesHeader."Currency Code");
                        end;
                    }
                }
            }
            group("O&rder")
            {
                CaptionML = ENU='O&rder',
                            ENA='O&rder';
                Image = "Order";
                group("Dr&op Shipment")
                {
                    CaptionML = ENU='Dr&op Shipment',
                                ENA='Dr&op Shipment';
                    Image = Delivery;
                    action("Purchase &Order")
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                        ApplicationArea = Suite;
                        CaptionML = ENU='Purchase &Order',
                                    ENA='Purchase &Order';
                        Image = Document;
                        ToolTipML = ENU='View the purchase order that is linked to the sales order, for drop shipment.',
                                    ENA='View the purchase order that is linked to the sales order, for drop shipment.';

                        trigger OnAction();
                        begin
                            OpenPurchOrderForm;
                        end;
                    }
                }
                group("Speci&al Order")
                {
                    CaptionML = ENU='Speci&al Order',
                                ENA='Speci&al Order';
                    Image = SpecialOrder;
                    action(OpenSpecialPurchaseOrder)
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Header"=R;
                        CaptionML = ENU='Purchase &Order',
                                    ENA='Purchase &Order';
                        Image = Document;

                        trigger OnAction();
                        begin
                            OpenSpecialPurchOrderForm;
                        end;
                    }
                }
                action(BlanketOrder)
                {
                    CaptionML = ENU='Blanket Order',
                                ENA='Blanket Order';
                    Image = BlanketOrder;
                    ToolTipML = ENU='View the blanket sales order.',
                                ENA='View the blanket sales order.';

                    trigger OnAction();
                    var
                        SalesHeader : Record "Sales Header";
                        BlanketSalesOrder : Page "Blanket Sales Order";
                    begin
                        TESTFIELD("Blanket Order No.");
                        SalesHeader.SETRANGE("No.","Blanket Order No.");
                        IF NOT SalesHeader.ISEMPTY THEN BEGIN
                          BlanketSalesOrder.SETTABLEVIEW(SalesHeader);
                          BlanketSalesOrder.EDITABLE := FALSE;
                          BlanketSalesOrder.RUN;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        CalculateTotals;
        SetLocationCodeMandatory;
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
        Currency : Record Currency;
        TotalSalesHeader : Record "Sales Header";
        TotalSalesLine : Record "Sales Line";
        SalesHeader : Record "Sales Header";
        ApplicationAreaSetup : Record "Application Area Setup";
        SalesSetup : Record "Sales & Receivables Setup";
        SalesPriceCalcMgt : Codeunit "Sales Price Calc. Mgt.";
        TransferExtendedText : Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt : Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscountByType : Codeunit "Sales - Calc Discount By Type";
        DocumentTotals : Codeunit "Document Totals";
        VATAmount : Decimal;
        ShortcutDimCode : array [8] of Code[20];
        Text001 : TextConst ENU='You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.',ENA='You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        LocationCodeMandatory : Boolean;
        InvDiscAmountEditable : Boolean;
        RowIsNotText : Boolean;
        UnitofMeasureCodeIsChangeable : Boolean;
        LocationCodeVisible : Boolean;
        InvoiceDiscountAmount : Decimal;
        InvoiceDiscountPct : Decimal;
        UpdateInvDiscountQst : TextConst ENU='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?',ENA='One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';

    procedure ApproveCalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Disc. (Yes/No)",Rec);
    end;

    local procedure ValidateInvoiceDiscountAmount();
    var
        SalesHeader : Record "Sales Header";
    begin
        SalesHeader.GET("Document Type","Document No.");
        IF SalesHeader.InvoicedLineExists THEN
          IF NOT CONFIRM(UpdateInvDiscountQst,FALSE) THEN
            EXIT;

        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount,SalesHeader);
        CurrPage.UPDATE(FALSE);
    end;

    procedure CalcInvDisc();
    begin
        CODEUNIT.RUN(CODEUNIT::"Sales-Calc. Discount",Rec);
    end;

    procedure ExplodeBOM();
    begin
        IF "Prepmt. Amt. Inv." <> 0 THEN
          ERROR(Text001);
        CODEUNIT.RUN(CODEUNIT::"Sales-Explode BOM",Rec);
    end;

    procedure OpenPurchOrderForm();
    var
        PurchHeader : Record "Purchase Header";
        PurchOrder : Page "Purchase Order";
    begin
        TESTFIELD("Purchase Order No.");
        PurchHeader.SETRANGE("No.","Purchase Order No.");
        PurchOrder.SETTABLEVIEW(PurchHeader);
        PurchOrder.EDITABLE := FALSE;
        PurchOrder.RUN;
    end;

    procedure OpenSpecialPurchOrderForm();
    var
        PurchHeader : Record "Purchase Header";
        PurchRcptHeader : Record "Purch. Rcpt. Header";
        PurchOrder : Page "Purchase Order";
    begin
        TESTFIELD("Special Order Purchase No.");
        PurchHeader.SETRANGE("No.","Special Order Purchase No.");
        IF NOT PurchHeader.ISEMPTY THEN BEGIN
          PurchOrder.SETTABLEVIEW(PurchHeader);
          PurchOrder.EDITABLE := FALSE;
          PurchOrder.RUN;
        END ELSE BEGIN
          PurchRcptHeader.SETRANGE("Order No.","Special Order Purchase No.");
          IF PurchRcptHeader.COUNT = 1 THEN
            PAGE.RUN(PAGE::"Posted Purchase Receipt",PurchRcptHeader)
          ELSE
            PAGE.RUN(PAGE::"Posted Purchase Receipts",PurchRcptHeader);
        END;
    end;

    procedure InsertExtendedText(Unconditionally : Boolean);
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,Unconditionally) THEN BEGIN
          CurrPage.SAVERECORD;
          COMMIT;
          TransferExtendedText.InsertSalesExtText(Rec);
        END;
        IF TransferExtendedText.MakeUpdate THEN
          UpdateForm(TRUE);
    end;

    procedure ShowNonstockItems();
    begin
        ShowNonstock;
    end;

    procedure ShowTracking();
    var
        TrackingForm : Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RUNMODAL;
    end;

    procedure ItemChargeAssgnt();
    begin
        ShowItemChargeAssgnt;
    end;

    procedure UpdateForm(SetSaveRecord : Boolean);
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;

    procedure ShowPrices();
    begin
        SalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLinePrice(SalesHeader,Rec);
    end;

    procedure ShowLineDisc();
    begin
        SalesHeader.GET("Document Type","Document No.");
        CLEAR(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetSalesLineLineDisc(SalesHeader,Rec);
    end;

    procedure OrderPromisingLine();
    var
        OrderPromisingLine : Record "Order Promising Line" temporary;
        OrderPromisingLines : Page "Order Promising Lines";
    begin
        OrderPromisingLine.SETRANGE("Source Type","Document Type");
        OrderPromisingLine.SETRANGE("Source ID","Document No.");
        OrderPromisingLine.SETRANGE("Source Line No.","Line No.");

        OrderPromisingLines.SetSourceType(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SETTABLEVIEW(OrderPromisingLine);
        OrderPromisingLines.RUNMODAL;
    end;

    local procedure NoOnAfterValidate();
    begin
        IF ApplicationAreaSetup.IsFoundationEnabled THEN
          TESTFIELD(Type,Type::Item);

        InsertExtendedText(FALSE);
        IF (Type = Type::"Charge (Item)") AND ("No." <> xRec."No.") AND
           (xRec."No." <> '')
        THEN
          CurrPage.SAVERECORD;

        SaveAndAutoAsmToOrder;

        IF Reserve = Reserve::Always THEN BEGIN
          CurrPage.SAVERECORD;
          IF ("Outstanding Qty. (Base)" <> 0) AND ("No." <> xRec."No.") THEN BEGIN
            AutoReserve;
            CurrPage.UPDATE(FALSE);
          END;
        END;
    end;

    local procedure VariantCodeOnAfterValidate();
    begin
        SaveAndAutoAsmToOrder;
    end;

    local procedure LocationCodeOnAfterValidate();
    begin
        SaveAndAutoAsmToOrder;

        IF (Reserve = Reserve::Always) AND
           ("Outstanding Qty. (Base)" <> 0) AND
           ("Location Code" <> xRec."Location Code")
        THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure ReserveOnAfterValidate();
    begin
        IF (Reserve = Reserve::Always) AND ("Outstanding Qty. (Base)" <> 0) THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure QuantityOnAfterValidate();
    var
        UpdateIsDone : Boolean;
    begin
        IF Type = Type::Item THEN
          CASE Reserve OF
            Reserve::Always:
              BEGIN
                CurrPage.SAVERECORD;
                AutoReserve;
                CurrPage.UPDATE(FALSE);
                UpdateIsDone := TRUE;
              END;
            Reserve::Optional:
              IF (Quantity < xRec.Quantity) AND (xRec.Quantity > 0) THEN BEGIN
                CurrPage.SAVERECORD;
                CurrPage.UPDATE(FALSE);
                UpdateIsDone := TRUE;
              END;
          END;

        IF (Type = Type::Item) AND
           (Quantity <> xRec.Quantity) AND
           NOT UpdateIsDone
        THEN
          CurrPage.UPDATE(TRUE);
    end;

    local procedure QtyToAsmToOrderOnAfterValidate();
    begin
        CurrPage.SAVERECORD;
        IF Reserve = Reserve::Always THEN
          AutoReserve;
        CurrPage.UPDATE(TRUE);
    end;

    local procedure UnitofMeasureCodeOnAfterValida();
    begin
        IF Reserve = Reserve::Always THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure ShipmentDateOnAfterValidate();
    begin
        IF (Reserve = Reserve::Always) AND
           ("Outstanding Qty. (Base)" <> 0) AND
           ("Shipment Date" <> xRec."Shipment Date")
        THEN BEGIN
          CurrPage.SAVERECORD;
          AutoReserve;
          CurrPage.UPDATE(FALSE);
        END ELSE
          CurrPage.UPDATE(TRUE);
    end;

    local procedure SaveAndAutoAsmToOrder();
    begin
        IF (Type = Type::Item) AND IsAsmToOrderRequired THEN BEGIN
          CurrPage.SAVERECORD;
          AutoAsmToOrder;
          CurrPage.UPDATE(FALSE);
        END;
    end;

    local procedure SetLocationCodeMandatory();
    var
        InventorySetup : Record "Inventory Setup";
    begin
        InventorySetup.GET;
        LocationCodeMandatory := InventorySetup."Location Mandatory" AND (Type = Type::Item);
    end;

    local procedure GetTotalSalesHeader();
    begin
        IF NOT TotalSalesHeader.GET("Document Type","Document No.") THEN
          CLEAR(TotalSalesHeader);
        IF Currency.Code <> TotalSalesHeader."Currency Code" THEN
          IF NOT Currency.GET(TotalSalesHeader."Currency Code") THEN BEGIN
            CLEAR(Currency);
            Currency.InitRoundingPrecision;
          END
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
        InvoiceDiscountPct := SalesCalcDiscountByType.GetCustInvoiceDiscountPct(Rec);
    end;

    local procedure RedistributeTotalsOnAfterValidate();
    begin
        CurrPage.SAVERECORD;

        SalesHeader.GET("Document Type","Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec,VATAmount,TotalSalesLine);
        CurrPage.UPDATE;
    end;

    local procedure ValidateSaveShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
        CurrPage.SAVERECORD;
    end;

    local procedure UpdateEditableOnRow();
    var
        SalesLine : Record "Sales Line";
    begin
        RowIsNotText := NOT (("No." = '') AND (Description <> ''));
        IF RowIsNotText THEN
          UnitofMeasureCodeIsChangeable := CanEditUnitOfMeasureCode
        ELSE
          UnitofMeasureCodeIsChangeable := FALSE;

        IF TotalSalesHeader."No." <> '' THEN BEGIN
          SalesLine.SETRANGE("Document No.",TotalSalesHeader."No.");
          SalesLine.SETRANGE("Document Type",TotalSalesHeader."Document Type");
          IF NOT SalesLine.ISEMPTY THEN
            InvDiscAmountEditable :=
              SalesCalcDiscountByType.InvoiceDiscIsAllowed(TotalSalesHeader."Invoice Disc. Code") AND CurrPage.EDITABLE;
        END;
    end;
}

