table 37 "Sales Line"
{
    // version NAVW110.00.00.17501,NAVAPAC10.00.00.17501

    CaptionML = ENU='Sales Line',
                ENA='Sales Line';
    DrillDownPageID = 516;
    LookupPageID = 516;

    fields
    {
        field(1;"Document Type";Option)
        {
            CaptionML = ENU='Document Type',
                        ENA='Document Type';
            OptionCaptionML = ENU='Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order',
                              ENA='Quote,Order,Invoice,CR/Adj Note,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2;"Sell-to Customer No.";Code[20])
        {
            CaptionML = ENU='Sell-to Customer No.',
                        ENA='Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(3;"Document No.";Code[20])
        {
            CaptionML = ENU='Document No.',
                        ENA='Document No.';
            TableRelation = "Sales Header".No. WHERE (Document Type=FIELD(Document Type));
        }
        field(4;"Line No.";Integer)
        {
            CaptionML = ENU='Line No.',
                        ENA='Line No.';
        }
        field(5;Type;Option)
        {
            CaptionML = ENU='Type',
                        ENA='Type';
            OptionCaptionML = ENU=' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)',
                              ENA=' ,G/L Account,Item,Resource,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)";

            trigger OnValidate();
            var
                TempSalesLine : Record "Sales Line" temporary;
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                GetSalesHeader;

                TESTFIELD("Qty. Shipped Not Invoiced",0);
                TESTFIELD("Quantity Shipped",0);
                TESTFIELD("Shipment No.",'');

                TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                TESTFIELD("Return Qty. Received",0);
                TESTFIELD("Return Receipt No.",'');

                TESTFIELD("Prepmt. Amt. Inv.",0);

                CheckAssocPurchOrder(FIELDCAPTION(Type));

                IF Type <> xRec.Type THEN BEGIN
                  CASE xRec.Type OF
                    Type::Item:
                      BEGIN
                        ATOLink.DeleteAsmFromSalesLine(Rec);
                        IF Quantity <> 0 THEN BEGIN
                          SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
                          CALCFIELDS("Reserved Qty. (Base)");
                          TESTFIELD("Reserved Qty. (Base)",0);
                          ReserveSalesLine.VerifyChange(Rec,xRec);
                          WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                        END;
                      END;
                    Type::"Fixed Asset":
                      IF Quantity <> 0 THEN
                        SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
                    Type::"Charge (Item)":
                      DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                  END;
                  IF xRec."Deferral Code" <> '' THEN
                    DeferralUtilities.RemoveOrSetDeferralSchedule('',
                      DeferralUtilities.GetSalesDeferralDocType,'','',
                      xRec."Document Type",xRec."Document No.",xRec."Line No.",
                      xRec.GetDeferralAmount,xRec."Posting Date",'',xRec."Currency Code",TRUE);
                END;
                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                TempSalesLine := Rec;
                INIT;
                IF xRec."Line Amount" <> 0 THEN
                  "Recalculate Invoice Disc." := TRUE;

                Type := TempSalesLine.Type;
                "System-Created Entry" := TempSalesLine."System-Created Entry";
                "Currency Code" := SalesHeader."Currency Code";

                IF Type = Type::Item THEN
                  "Allow Item Charge Assignment" := TRUE
                ELSE
                  "Allow Item Charge Assignment" := FALSE;
                IF Type = Type::Item THEN BEGIN
                  IF SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                    ERROR(Text056,SalesHeader."Shipping Advice");
                  IF SalesHeader.WhseShpmntConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
                    ERROR(Text052,SalesHeader."Shipping Advice");
                END;
            end;
        }
        field(6;"No.";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            CaptionML = ENU='No.',
                        ENA='No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text" ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes), Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(Yes)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                TempSalesLine : Record "Sales Line" temporary;
                StandardText : Record "Standard Text";
                FixedAsset : Record "Fixed Asset";
                PrepaymentMgt : Codeunit "Prepayment Mgt.";
                TypeHelper : Codeunit "Type Helper";
            begin
                "No." := TypeHelper.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

                TestJobPlanningLine;
                TestStatusOpen;
                CheckItemAvailable(FIELDNO("No."));

                IF (xRec."No." <> "No.") AND (Quantity <> 0) THEN BEGIN
                  TESTFIELD("Qty. to Asm. to Order (Base)",0);
                  CALCFIELDS("Reserved Qty. (Base)");
                  TESTFIELD("Reserved Qty. (Base)",0);
                  IF Type = Type::Item THEN
                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;

                TESTFIELD("Qty. Shipped Not Invoiced",0);
                TESTFIELD("Quantity Shipped",0);
                TESTFIELD("Shipment No.",'');

                TESTFIELD("Prepmt. Amt. Inv.",0);

                TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                TESTFIELD("Return Qty. Received",0);
                TESTFIELD("Return Receipt No.",'');

                IF "No." = '' THEN
                  ATOLink.DeleteAsmFromSalesLine(Rec);
                CheckAssocPurchOrder(FIELDCAPTION("No."));
                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                TempSalesLine := Rec;
                INIT;
                IF xRec."Line Amount" <> 0 THEN
                  "Recalculate Invoice Disc." := TRUE;
                Type := TempSalesLine.Type;
                "No." := TempSalesLine."No.";
                IF "No." = '' THEN
                  EXIT;
                IF Type <> Type::" " THEN
                  Quantity := TempSalesLine.Quantity;

                "System-Created Entry" := TempSalesLine."System-Created Entry";
                GetSalesHeader;
                InitHeaderDefaults(SalesHeader);
                CALCFIELDS("Substitution Available");

                "Promised Delivery Date" := SalesHeader."Promised Delivery Date";
                "Requested Delivery Date" := SalesHeader."Requested Delivery Date";
                "Shipment Date" :=
                  CalendarMgmt.CalcDateBOC(
                    '',
                    SalesHeader."Shipment Date",
                    CalChange."Source Type"::Location,
                    "Location Code",
                    '',
                    CalChange."Source Type"::"Shipping Agent",
                    "Shipping Agent Code",
                    "Shipping Agent Service Code",
                    FALSE);
                UpdateDates;

                CASE Type OF
                  Type::" ":
                    BEGIN
                      StandardText.GET("No.");
                      Description := StandardText.Description;
                      "Allow Item Charge Assignment" := FALSE;
                    END;
                  Type::"G/L Account":
                    BEGIN
                      GLAcc.GET("No.");
                      GLAcc.CheckGLAcc;
                      IF NOT "System-Created Entry" THEN
                        GLAcc.TESTFIELD("Direct Posting",TRUE);
                      Description := GLAcc.Name;
                      "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                      "WHT Product Posting Group" := GLAcc."WHT Product Posting Group";
                      "Tax Group Code" := GLAcc."Tax Group Code";
                      "Allow Invoice Disc." := FALSE;
                      "Allow Item Charge Assignment" := FALSE;
                      InitDeferralCode;
                    END;
                  Type::Item:
                    BEGIN
                      GetItem;
                      Item.TESTFIELD(Blocked,FALSE);
                      Item.TESTFIELD("Gen. Prod. Posting Group");
                      IF Item.Type = Item.Type::Inventory THEN BEGIN
                        Item.TESTFIELD("Inventory Posting Group");
                        "Posting Group" := Item."Inventory Posting Group";
                      END;
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      GetUnitCost;
                      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
                      "Units per Parcel" := Item."Units per Parcel";
                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                      "WHT Product Posting Group" := Item."WHT Product Posting Group";
                      "Tax Group Code" := Item."Tax Group Code";
                      "Item Category Code" := Item."Item Category Code";
                      "Product Group Code" := Item."Product Group Code";
                      Nonstock := Item."Created From Nonstock Item";
                      "Profit %" := Item."Profit %";
                      "Allow Item Charge Assignment" := TRUE;
                      PrepaymentMgt.SetSalesPrepaymentPct(Rec,SalesHeader."Posting Date");

                      IF SalesHeader."Language Code" <> '' THEN
                        GetItemTranslation;

                      IF Item.Reserve = Item.Reserve::Optional THEN
                        Reserve := SalesHeader.Reserve
                      ELSE
                        Reserve := Item.Reserve;

                      "Unit of Measure Code" := Item."Sales Unit of Measure";
                      InitDeferralCode;
                      SetDefaultItemQuantity;
                    END;
                  Type::Resource:
                    BEGIN
                      Res.GET("No.");
                      Res.TESTFIELD(Blocked,FALSE);
                      Res.TESTFIELD("Gen. Prod. Posting Group");
                      Description := Res.Name;
                      "Description 2" := Res."Name 2";
                      "Unit of Measure Code" := Res."Base Unit of Measure";
                      "Unit Cost (LCY)" := Res."Unit Cost";
                      "Gen. Prod. Posting Group" := Res."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := Res."VAT Prod. Posting Group";
                      "WHT Product Posting Group" := Res."WHT Product Posting Group";
                      "Tax Group Code" := Res."Tax Group Code";
                      "Allow Item Charge Assignment" := FALSE;
                      FindResUnitCost;
                      InitDeferralCode;
                    END;
                  Type::"Fixed Asset":
                    BEGIN
                      FixedAsset.GET("No.");
                      FixedAsset.TESTFIELD(Inactive,FALSE);
                      FixedAsset.TESTFIELD(Blocked,FALSE);
                      GetFAPostingGroup;
                      Description := FixedAsset.Description;
                      "Description 2" := FixedAsset."Description 2";
                      "Allow Invoice Disc." := FALSE;
                      "Allow Item Charge Assignment" := FALSE;
                    END;
                  Type::"Charge (Item)":
                    BEGIN
                      ItemCharge.GET("No.");
                      Description := ItemCharge.Description;
                      "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                      "WHT Product Posting Group" := ItemCharge."WHT Product Posting Group";
                      "Tax Group Code" := ItemCharge."Tax Group Code";
                      "Allow Invoice Disc." := FALSE;
                      "Allow Item Charge Assignment" := FALSE;
                    END;
                END;

                IF Type <> Type::" " THEN BEGIN
                  IF Type <> Type::"Fixed Asset" THEN
                    VALIDATE("VAT Prod. Posting Group");
                  VALIDATE("WHT Product Posting Group");
                END;

                UpdatePrepmtSetupFields;

                IF Type <> Type::" " THEN BEGIN
                  VALIDATE("Unit of Measure Code");
                  IF Quantity <> 0 THEN BEGIN
                    InitOutstanding;
                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                      InitQtyToReceive
                    ELSE
                      InitQtyToShip;
                    InitQtyToAsm;
                    UpdateWithWarehouseShip;
                  END;
                  UpdateUnitPrice(FIELDNO("No."));
                END;

                IF NOT ISTEMPORARY THEN
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                    DATABASE::Job,"Job No.",
                    DATABASE::"Responsibility Center","Responsibility Center");

                IF "No." <> xRec."No." THEN BEGIN
                  IF Type = Type::Item THEN
                    IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                      ReserveSalesLine.VerifyChange(Rec,xRec);
                      WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                    END;
                  GetDefaultBin;
                  AutoAsmToOrder;
                  DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                  IF Type = Type::"Charge (Item)" THEN
                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                END;

                UpdateItemCrossRef;
            end;
        }
        field(7;"Location Code";Code[10])
        {
            CaptionML = ENU='Location Code',
                        ENA='Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                CheckAssocPurchOrder(FIELDCAPTION("Location Code"));
                IF "Location Code" <> '' THEN
                  IF IsServiceItem THEN
                    Item.TESTFIELD(Type,Item.Type::Inventory);
                IF xRec."Location Code" <> "Location Code" THEN BEGIN
                  IF NOT FullQtyIsForAsmToOrder THEN BEGIN
                    CALCFIELDS("Reserved Qty. (Base)");
                    TESTFIELD("Reserved Qty. (Base)","Qty. to Asm. to Order (Base)");
                  END;
                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                  TESTFIELD("Shipment No.",'');
                  TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                  TESTFIELD("Return Receipt No.",'');
                END;

                GetSalesHeader;
                "Shipment Date" :=
                  CalendarMgmt.CalcDateBOC(
                    '',
                    SalesHeader."Shipment Date",
                    CalChange."Source Type"::Location,
                    "Location Code",
                    '',
                    CalChange."Source Type"::"Shipping Agent",
                    "Shipping Agent Code",
                    "Shipping Agent Service Code",
                    FALSE);

                CheckItemAvailable(FIELDNO("Location Code"));

                IF NOT "Drop Shipment" THEN BEGIN
                  IF "Location Code" = '' THEN BEGIN
                    IF InvtSetup.GET THEN
                      "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                  END ELSE
                    IF Location.GET("Location Code") THEN
                      "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                END ELSE
                  EVALUATE("Outbound Whse. Handling Time",'<0D>');

                IF "Location Code" <> xRec."Location Code" THEN BEGIN
                  InitItemAppl(TRUE);
                  GetDefaultBin;
                  InitQtyToAsm;
                  AutoAsmToOrder;
                  IF Quantity <> 0 THEN BEGIN
                    IF NOT "Drop Shipment" THEN
                      UpdateWithWarehouseShip;
                    IF NOT FullReservedQtyIsForAsmToOrder THEN
                      ReserveSalesLine.VerifyChange(Rec,xRec);
                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                  END;
                END;

                UpdateDates;

                IF (Type = Type::Item) AND ("No." <> '') THEN
                  GetUnitCost;

                CheckWMS;

                IF "Document Type" = "Document Type"::"Return Order" THEN
                  ValidateReturnReasonCode(FIELDNO("Location Code"));
            end;
        }
        field(8;"Posting Group";Code[10])
        {
            CaptionML = ENU='Posting Group',
                        ENA='Posting Group';
            Editable = false;
            TableRelation = IF (Type=CONST(Item)) "Inventory Posting Group" ELSE IF (Type=CONST(Fixed Asset)) "FA Posting Group";
        }
        field(10;"Shipment Date";Date)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Shipment Date',
                        ENA='Shipment Date';

            trigger OnValidate();
            var
                CheckDateConflict : Codeunit "Reservation-Check Date Confl.";
            begin
                TestStatusOpen;
                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                IF CurrFieldNo <> 0 THEN
                  AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                IF "Shipment Date" <> 0D THEN BEGIN
                  IF CurrFieldNo IN [
                                     FIELDNO("Planned Shipment Date"),
                                     FIELDNO("Planned Delivery Date"),
                                     FIELDNO("Shipment Date"),
                                     FIELDNO("Shipping Time"),
                                     FIELDNO("Outbound Whse. Handling Time"),
                                     FIELDNO("Requested Delivery Date")]
                  THEN
                    CheckItemAvailable(FIELDNO("Shipment Date"));

                  IF ("Shipment Date" < WORKDATE) AND (Type <> Type::" ") THEN
                    IF NOT (HideValidationDialog OR HasBeenShown) AND GUIALLOWED THEN BEGIN
                      MESSAGE(
                        Text014,
                        FIELDCAPTION("Shipment Date"),"Shipment Date",WORKDATE);
                      HasBeenShown := TRUE;
                    END;
                END;

                AutoAsmToOrder;
                IF (xRec."Shipment Date" <> "Shipment Date") AND
                   (Quantity <> 0) AND
                   NOT StatusCheckSuspended
                THEN
                  CheckDateConflict.SalesLineCheck(Rec,CurrFieldNo <> 0);

                IF NOT PlannedShipmentDateCalculated THEN
                  "Planned Shipment Date" := CalcPlannedShptDate(FIELDNO("Shipment Date"));
                IF NOT PlannedDeliveryDateCalculated THEN
                  "Planned Delivery Date" := CalcPlannedDeliveryDate(FIELDNO("Shipment Date"));
            end;
        }
        field(11;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
            TableRelation = IF (Type=CONST(" ")) "Standard Text" ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes), Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(Yes)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Item : Record Item;
                TypeHelper : Codeunit "Type Helper";
                ReturnValue : Text[50];
                ItemDescriptionIsNo : Boolean;
                DefaultCreate : Boolean;
            begin
                IF Type = Type::" " THEN
                  EXIT;

                CASE Type OF
                  Type::Item:
                    BEGIN
                      IF (STRLEN(Description) <= MAXSTRLEN(Item."No.")) AND ("No." <> '') THEN
                        ItemDescriptionIsNo := Item.GET(Description)
                      ELSE
                        ItemDescriptionIsNo := FALSE;

                      IF ("No." <> '') AND (NOT ItemDescriptionIsNo) AND (Description <> '') THEN BEGIN
                        Item.SETFILTER(Description,'''@' + CONVERTSTR(Description,'''','?') + '*''');
                        IF NOT Item.FINDFIRST THEN
                          EXIT;
                        IF Item."No." = "No." THEN
                          EXIT;
                        IF CONFIRM(AnotherItemWithSameDescrQst,FALSE,Item."No.",Item.Description) THEN
                          VALIDATE("No.",Item."No.");
                        EXIT;
                      END;

                      GetSalesSetup;
                      DefaultCreate := ("No." = '') AND SalesSetup."Create Item from Description";
                      IF Item.TryGetItemNoOpenCard(ReturnValue,Description,DefaultCreate,NOT HideValidationDialog) THEN
                        CASE ReturnValue OF
                          '':
                            BEGIN
                              LookupRequested := TRUE;
                              Description := xRec.Description;
                            END;
                          "No.":
                            Description := xRec.Description;
                          ELSE BEGIN
                            CurrFieldNo := FIELDNO("No.");
                            VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN(Item."No.")));
                          END;
                        END;
                    END;
                  ELSE
                    IF "No." = '' THEN
                      IF TypeHelper.FindRecordByDescription(ReturnValue,Type,Description) = 1 THEN BEGIN
                        CurrFieldNo := FIELDNO("No.");
                        VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN("No.")));
                      END;
                END;
            end;
        }
        field(12;"Description 2";Text[50])
        {
            CaptionML = ENU='Description 2',
                        ENA='Description 2';
        }
        field(13;"Unit of Measure";Text[10])
        {
            CaptionML = ENU='Unit of Measure',
                        ENA='Unit of Measure';
        }
        field(15;Quantity;Decimal)
        {
            CaptionML = ENU='Quantity',
                        ENA='Quantity';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            var
                ItemLedgEntry : Record "Item Ledger Entry";
            begin
                TestJobPlanningLine;
                TestStatusOpen;

                CheckAssocPurchOrder(FIELDCAPTION(Quantity));

                IF "Shipment No." <> '' THEN
                  CheckShipmentRelation
                ELSE
                  IF "Return Receipt No." <> '' THEN
                    CheckRetRcptRelation;

                "Quantity (Base)" := CalcBaseQty(Quantity);

                IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                  IF (Quantity * "Return Qty. Received" < 0) OR
                     ((ABS(Quantity) < ABS("Return Qty. Received")) AND ("Return Receipt No." = ''))
                  THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Return Qty. Received")));
                  IF ("Quantity (Base)" * "Return Qty. Received (Base)" < 0) OR
                     ((ABS("Quantity (Base)") < ABS("Return Qty. Received (Base)")) AND ("Return Receipt No." = ''))
                  THEN
                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Return Qty. Received (Base)")));
                END ELSE BEGIN
                  IF (Quantity * "Quantity Shipped" < 0) OR
                     ((ABS(Quantity) < ABS("Quantity Shipped")) AND ("Shipment No." = ''))
                  THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Quantity Shipped")));
                  IF ("Quantity (Base)" * "Qty. Shipped (Base)" < 0) OR
                     ((ABS("Quantity (Base)") < ABS("Qty. Shipped (Base)")) AND ("Shipment No." = ''))
                  THEN
                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text003,FIELDCAPTION("Qty. Shipped (Base)")));
                END;

                IF (Type = Type::"Charge (Item)") AND (CurrFieldNo <> 0) THEN BEGIN
                  IF (Quantity = 0) AND ("Qty. to Assign" <> 0) THEN
                    FIELDERROR("Qty. to Assign",STRSUBSTNO(Text009,FIELDCAPTION(Quantity),Quantity));
                  IF (Quantity * "Qty. Assigned" < 0) OR (ABS(Quantity) < ABS("Qty. Assigned")) THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text003,FIELDCAPTION("Qty. Assigned")));
                END;

                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                  InitOutstanding;
                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                    InitQtyToReceive
                  ELSE
                    InitQtyToShip;
                  InitQtyToAsm;
                  SetDefaultQuantity;
                END;

                CheckItemAvailable(FIELDNO(Quantity));

                IF (Quantity * xRec.Quantity < 0) OR (Quantity = 0) THEN
                  InitItemAppl(FALSE);

                IF Type = Type::Item THEN BEGIN
                  UpdateUnitPrice(FIELDNO(Quantity));
                  IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                    ReserveSalesLine.VerifyQuantity(Rec,xRec);
                    IF NOT "Drop Shipment" THEN
                      UpdateWithWarehouseShip;
                    WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                    IF ("Quantity (Base)" * xRec."Quantity (Base)" <= 0) AND ("No." <> '') THEN BEGIN
                      GetItem;
                      IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN
                        GetUnitCost;
                    END;
                  END;
                  VALIDATE("Qty. to Assemble to Order");
                  IF (Quantity = "Quantity Invoiced") AND (CurrFieldNo <> 0) THEN
                    CheckItemChargeAssgnt;
                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                END ELSE
                  VALIDATE("Line Discount %");

                IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
                   ((Amount <> 0) OR ("Amount Including VAT" <> 0) OR ("VAT Base Amount" <> 0))
                THEN BEGIN
                  Amount := 0;
                  "Amount Including VAT" := 0;
                  "VAT Base Amount" := 0;
                END;

                UpdatePrePaymentAmounts;

                CheckWMS;

                UpdatePlanned;
            end;
        }
        field(16;"Outstanding Quantity";Decimal)
        {
            CaptionML = ENU='Outstanding Quantity',
                        ENA='Outstanding Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(17;"Qty. to Invoice";Decimal)
        {
            CaptionML = ENU='Qty. to Invoice',
                        ENA='Qty. to Invoice';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                IF "Qty. to Invoice" = MaxQtyToInvoice THEN
                  InitQtyToInvoice
                ELSE
                  "Qty. to Invoice (Base)" := CalcBaseQty("Qty. to Invoice");
                IF ("Qty. to Invoice" * Quantity < 0) OR
                   (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice))
                THEN
                  ERROR(
                    Text005,
                    MaxQtyToInvoice);
                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR
                   (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase))
                THEN
                  ERROR(
                    Text006,
                    MaxQtyToInvoiceBase);
                "VAT Difference" := 0;
                CalcInvDiscToInvoice;
                CalcPrepaymentToDeduct;
            end;
        }
        field(18;"Qty. to Ship";Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Qty. to Ship',
                        ENA='Qty. to Ship';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            var
                ItemLedgEntry : Record "Item Ledger Entry";
            begin
                GetLocation("Location Code");
                IF (CurrFieldNo <> 0) AND
                   (Type = Type::Item) AND
                   (NOT "Drop Shipment")
                THEN BEGIN
                  IF Location."Require Shipment" AND
                     ("Qty. to Ship" <> 0)
                  THEN
                    CheckWarehouse;
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;

                IF "Qty. to Ship" = "Outstanding Quantity" THEN
                  InitQtyToShip
                ELSE BEGIN
                  "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");
                  CheckServItemCreation;
                  InitQtyToInvoice;
                END;
                IF ((("Qty. to Ship" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Qty. to Ship" <> 0)) OR
                   (ABS("Qty. to Ship") > ABS("Outstanding Quantity")) OR
                   (((Quantity < 0) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                THEN
                  ERROR(
                    Text007,
                    "Outstanding Quantity");
                IF ((("Qty. to Ship (Base)" < 0) XOR ("Quantity (Base)" < 0)) AND ("Qty. to Ship (Base)" <> 0) AND ("Quantity (Base)" <> 0)) OR
                   (ABS("Qty. to Ship (Base)") > ABS("Outstanding Qty. (Base)")) OR
                   ((("Quantity (Base)" < 0) XOR ("Outstanding Qty. (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Outstanding Qty. (Base)" <> 0))
                THEN
                  ERROR(
                    Text008,
                    "Outstanding Qty. (Base)");

                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Qty. to Ship" < 0) THEN
                  CheckApplFromItemLedgEntry(ItemLedgEntry);

                ATOLink.UpdateQtyToAsmFromSalesLine(Rec);
            end;
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            CaptionML = ENU='Unit Price',
                        ENA='Unit Price';

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                VALIDATE("Line Discount %");
            end;
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU='Unit Cost (LCY)',
                        ENA='Unit Cost (LCY)';

            trigger OnValidate();
            begin
                IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                   ("Unit Cost (LCY)" <> xRec."Unit Cost (LCY)")
                THEN
                  CheckAssocPurchOrder(FIELDCAPTION("Unit Cost (LCY)"));

                IF (CurrFieldNo = FIELDNO("Unit Cost (LCY)")) AND
                   (Type = Type::Item) AND ("No." <> '') AND ("Quantity (Base)" <> 0)
                THEN BEGIN
                  TestJobPlanningLine;
                  GetItem;
                  IF (Item."Costing Method" = Item."Costing Method"::Standard) AND NOT IsShipment THEN BEGIN
                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                      ERROR(
                        Text037,
                        FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),
                        Item."Costing Method",FIELDCAPTION(Quantity));
                    ERROR(
                      Text038,
                      FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),
                      Item."Costing Method",FIELDCAPTION(Quantity));
                  END;
                END;

                GetSalesHeader;
                IF SalesHeader."Currency Code" <> '' THEN BEGIN
                  Currency.TESTFIELD("Unit-Amount Rounding Precision");
                  "Unit Cost" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        GetDate,SalesHeader."Currency Code",
                        "Unit Cost (LCY)",SalesHeader."Currency Factor"),
                      Currency."Unit-Amount Rounding Precision")
                END ELSE
                  "Unit Cost" := "Unit Cost (LCY)";
            end;
        }
        field(25;"VAT %";Decimal)
        {
            CaptionML = ENU='VAT %',
                        ENA='GST %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(27;"Line Discount %";Decimal)
        {
            CaptionML = ENU='Line Discount %',
                        ENA='Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100,Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Line Discount Amount',
                        ENA='Line Discount Amount';

            trigger OnValidate();
            begin
                GetSalesHeader;
                "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
                TestJobPlanningLine;
                TestStatusOpen;
                TESTFIELD(Quantity);
                IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
                  IF ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") <> 0 THEN
                    "Line Discount %" :=
                      ROUND(
                        "Line Discount Amount" / ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") * 100,
                        0.00001)
                  ELSE
                    "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
            end;
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Amount',
                        ENA='Amount';
            Editable = false;

            trigger OnValidate();
            begin
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                      "Amount Including VAT" :=
                        ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    IF Amount <> 0 THEN
                      FIELDERROR(Amount,
                        STRSUBSTNO(
                          Text009,FIELDCAPTION("VAT Calculation Type"),
                          "VAT Calculation Type"));
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      SalesHeader.TESTFIELD("VAT Base Discount %",0);
                      "VAT Base Amount" := ROUND(Amount,Currency."Amount Rounding Precision");
                      "Amount Including VAT" :=
                        Amount +
                        SalesTaxCalculate.CalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                          "VAT Base Amount","Quantity (Base)",SalesHeader."Currency Factor");
                      IF "VAT Base Amount" <> 0 THEN
                        "VAT %" :=
                          ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                      ELSE
                        "VAT %" := 0;
                      "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                    END;
                END;

                InitOutstandingAmount;
            end;
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Amount Including VAT',
                        ENA='Amount Including GST';
            Editable = false;

            trigger OnValidate();
            begin
                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      Amount :=
                        ROUND(
                          "Amount Including VAT" /
                          (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      Amount := 0;
                      "VAT Base Amount" := 0;
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      SalesHeader.TESTFIELD("VAT Base Discount %",0);
                      Amount :=
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                          "Amount Including VAT","Quantity (Base)",SalesHeader."Currency Factor");
                      IF Amount <> 0 THEN
                        "VAT %" :=
                          ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                      ELSE
                        "VAT %" := 0;
                      Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                      "VAT Base Amount" := Amount;
                    END;
                END;

                InitOutstandingAmount;
            end;
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            CaptionML = ENU='Allow Invoice Disc.',
                        ENA='Allow Invoice Disc.';
            InitValue = true;

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF ("Allow Invoice Disc." <> xRec."Allow Invoice Disc.") AND
                   (NOT "Allow Invoice Disc.")
                THEN BEGIN
                  "Inv. Discount Amount" := 0;
                  "Inv. Disc. Amount to Invoice" := 0;
                  UpdateAmounts;
                END;
            end;
        }
        field(34;"Gross Weight";Decimal)
        {
            CaptionML = ENU='Gross Weight',
                        ENA='Gross Weight';
            DecimalPlaces = 0:5;
        }
        field(35;"Net Weight";Decimal)
        {
            CaptionML = ENU='Net Weight',
                        ENA='Net Weight';
            DecimalPlaces = 0:5;
        }
        field(36;"Units per Parcel";Decimal)
        {
            CaptionML = ENU='Units per Parcel',
                        ENA='Units per Parcel';
            DecimalPlaces = 0:5;
        }
        field(37;"Unit Volume";Decimal)
        {
            CaptionML = ENU='Unit Volume',
                        ENA='Unit Volume';
            DecimalPlaces = 0:5;
        }
        field(38;"Appl.-to Item Entry";Integer)
        {
            AccessByPermission = TableData Item=R;
            CaptionML = ENU='Appl.-to Item Entry',
                        ENA='Appl.-to Item Entry';

            trigger OnLookup();
            begin
                SelectItemEntry(FIELDNO("Appl.-to Item Entry"));
            end;

            trigger OnValidate();
            var
                ItemLedgEntry : Record "Item Ledger Entry";
                ItemTrackingLines : Page "Item Tracking Lines";
            begin
                IF "Appl.-to Item Entry" <> 0 THEN BEGIN
                  AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);

                  TESTFIELD(Type,Type::Item);
                  TESTFIELD(Quantity);
                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                    IF Quantity > 0 THEN
                      FIELDERROR(Quantity,Text030);
                  END ELSE BEGIN
                    IF Quantity < 0 THEN
                      FIELDERROR(Quantity,Text029);
                  END;
                  ItemLedgEntry.GET("Appl.-to Item Entry");
                  ItemLedgEntry.TESTFIELD(Positive,TRUE);
                  IF ItemLedgEntry.TrackingExists THEN
                    ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-to Item Entry"));
                  IF ABS("Qty. to Ship (Base)") > ItemLedgEntry.Quantity THEN
                    ERROR(ShippingMoreUnitsThanReceivedErr,ItemLedgEntry.Quantity,ItemLedgEntry."Document No.");

                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));

                  "Location Code" := ItemLedgEntry."Location Code";
                  IF NOT ItemLedgEntry.Open THEN
                    MESSAGE(Text042,"Appl.-to Item Entry");
                END;
            end;
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU='Shortcut Dimension 1 Code',
                        ENA='Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU='Shortcut Dimension 2 Code',
                        ENA='Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(42;"Customer Price Group";Code[10])
        {
            CaptionML = ENU='Customer Price Group',
                        ENA='Customer Price Group';
            Editable = false;
            TableRelation = "Customer Price Group";

            trigger OnValidate();
            begin
                IF Type = Type::Item THEN
                  UpdateUnitPrice(FIELDNO("Customer Price Group"));
            end;
        }
        field(45;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            Editable = false;
            TableRelation = Job;
        }
        field(52;"Work Type Code";Code[10])
        {
            CaptionML = ENU='Work Type Code',
                        ENA='Work Type Code';
            TableRelation = "Work Type";

            trigger OnValidate();
            var
                WorkType : Record "Work Type";
            begin
                IF Type = Type::Resource THEN BEGIN
                  TestStatusOpen;
                  IF WorkType.GET("Work Type Code") THEN
                    VALIDATE("Unit of Measure Code",WorkType."Unit of Measure Code");
                  UpdateUnitPrice(FIELDNO("Work Type Code"));
                  VALIDATE("Unit Price");
                  FindResUnitCost;
                END;
            end;
        }
        field(56;"Recalculate Invoice Disc.";Boolean)
        {
            CaptionML = ENU='Recalculate Invoice Disc.',
                        ENA='Recalculate Invoice Disc.';
            Editable = false;
        }
        field(57;"Outstanding Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Outstanding Amount',
                        ENA='Outstanding Amount';
            Editable = false;

            trigger OnValidate();
            var
                Currency2 : Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                IF SalesHeader."Currency Code" <> '' THEN
                  "Outstanding Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Outstanding Amount",SalesHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Outstanding Amount (LCY)" :=
                    ROUND("Outstanding Amount",Currency2."Amount Rounding Precision");
            end;
        }
        field(58;"Qty. Shipped Not Invoiced";Decimal)
        {
            CaptionML = ENU='Qty. Shipped Not Invoiced',
                        ENA='Qty. Shipped Not Invoiced';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(59;"Shipped Not Invoiced";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Shipped Not Invoiced',
                        ENA='Shipped Not Invoiced';
            Editable = false;

            trigger OnValidate();
            var
                Currency2 : Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                IF SalesHeader."Currency Code" <> '' THEN
                  "Shipped Not Invoiced (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Shipped Not Invoiced",SalesHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Shipped Not Invoiced (LCY)" :=
                    ROUND("Shipped Not Invoiced",Currency2."Amount Rounding Precision");
            end;
        }
        field(60;"Quantity Shipped";Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Quantity Shipped',
                        ENA='Quantity Shipped';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(61;"Quantity Invoiced";Decimal)
        {
            CaptionML = ENU='Quantity Invoiced',
                        ENA='Quantity Invoiced';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(63;"Shipment No.";Code[20])
        {
            CaptionML = ENU='Shipment No.',
                        ENA='Shipment No.';
            Editable = false;
        }
        field(64;"Shipment Line No.";Integer)
        {
            CaptionML = ENU='Shipment Line No.',
                        ENA='Shipment Line No.';
            Editable = false;
        }
        field(67;"Profit %";Decimal)
        {
            CaptionML = ENU='Profit %',
                        ENA='Profit %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(68;"Bill-to Customer No.";Code[20])
        {
            CaptionML = ENU='Bill-to Customer No.',
                        ENA='Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Inv. Discount Amount"));
            CaptionML = ENU='Inv. Discount Amount',
                        ENA='Inv. Discount Amount';
            Editable = false;

            trigger OnValidate();
            begin
                CalcInvDiscToInvoice;
                UpdateAmounts;
            end;
        }
        field(71;"Purchase Order No.";Code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Purchase Order No.',
                        ENA='Purchase Order No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate();
            begin
                IF (xRec."Purchase Order No." <> "Purchase Order No.") AND (Quantity <> 0) THEN BEGIN
                  ReserveSalesLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;
            end;
        }
        field(72;"Purch. Order Line No.";Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Purch. Order Line No.',
                        ENA='Purch. Order Line No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order), Document No.=FIELD(Purchase Order No.));

            trigger OnValidate();
            begin
                IF (xRec."Purch. Order Line No." <> "Purch. Order Line No.") AND (Quantity <> 0) THEN BEGIN
                  ReserveSalesLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;
            end;
        }
        field(73;"Drop Shipment";Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Drop Shipment',
                        ENA='Drop Shipment';
            Editable = true;

            trigger OnValidate();
            begin
                TESTFIELD("Document Type","Document Type"::Order);
                TESTFIELD(Type,Type::Item);
                TESTFIELD("Quantity Shipped",0);
                TESTFIELD("Job No.",'');
                TESTFIELD("Qty. to Asm. to Order (Base)",0);

                IF "Drop Shipment" THEN
                  TESTFIELD("Special Order",FALSE);

                CheckAssocPurchOrder(FIELDCAPTION("Drop Shipment"));

                IF "Special Order" THEN
                  Reserve := Reserve::Never
                ELSE
                IF "Drop Shipment" THEN BEGIN
                  Reserve := Reserve::Never;
                  VALIDATE(Quantity,Quantity);
                  IF "Drop Shipment" THEN BEGIN
                    EVALUATE("Outbound Whse. Handling Time",'<0D>');
                    EVALUATE("Shipping Time",'<0D>');
                    UpdateDates;
                    "Bin Code" := '';
                  END;
                  END ELSE
                    SetReserveWithoutPurchasingCode;

                CheckItemAvailable(FIELDNO("Drop Shipment"));

                AddOnIntegrMgt.CheckReceiptOrderStatus(Rec);
                IF (xRec."Drop Shipment" <> "Drop Shipment") AND (Quantity <> 0) THEN BEGIN
                  IF NOT "Drop Shipment" THEN BEGIN
                    InitQtyToAsm;
                    AutoAsmToOrder;
                    UpdateWithWarehouseShip
                  END ELSE
                    InitQtyToShip;
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                  IF NOT FullReservedQtyIsForAsmToOrder THEN
                    ReserveSalesLine.VerifyChange(Rec,xRec);
                END;
            end;
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Bus. Posting Group',
                        ENA='Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate();
            begin
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Prod. Posting Group',
                        ENA='Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
            end;
        }
        field(77;"VAT Calculation Type";Option)
        {
            CaptionML = ENU='VAT Calculation Type',
                        ENA='GST Calculation Type';
            Editable = false;
            OptionCaptionML = ENU='Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax',
                              ENA='Normal GST,Reverse Charge GST,Full GST,US Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(78;"Transaction Type";Code[10])
        {
            CaptionML = ENU='Transaction Type',
                        ENA='Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(79;"Transport Method";Code[10])
        {
            CaptionML = ENU='Transport Method',
                        ENA='Transport Method';
            TableRelation = "Transport Method";
        }
        field(80;"Attached to Line No.";Integer)
        {
            CaptionML = ENU='Attached to Line No.',
                        ENA='Attached to Line No.';
            Editable = false;
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.));
        }
        field(81;"Exit Point";Code[10])
        {
            CaptionML = ENU='Exit Point',
                        ENA='Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(82;"Area";Code[10])
        {
            CaptionML = ENU='Area',
                        ENA='Area';
            TableRelation = Area;
        }
        field(83;"Transaction Specification";Code[10])
        {
            CaptionML = ENU='Transaction Specification',
                        ENA='Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(84;"Tax Category";Code[10])
        {
            CaptionML = ENU='Tax Category',
                        ENA='Tax Category';
        }
        field(85;"Tax Area Code";Code[20])
        {
            CaptionML = ENU='Tax Area Code',
                        ENA='US Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate();
            begin
                UpdateAmounts;
            end;
        }
        field(86;"Tax Liable";Boolean)
        {
            CaptionML = ENU='Tax Liable',
                        ENA='US Tax Liable';

            trigger OnValidate();
            begin
                UpdateAmounts;
            end;
        }
        field(87;"Tax Group Code";Code[10])
        {
            CaptionML = ENU='Tax Group Code',
                        ENA='US Tax Group Code';
            TableRelation = "Tax Group";
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                TestStatusOpen;
                ValidateTaxGroupCode;
                UpdateAmounts;
            end;
        }
        field(88;"VAT Clause Code";Code[10])
        {
            CaptionML = ENU='VAT Clause Code',
                        ENA='GST Clause Code';
            TableRelation = "VAT Clause";
        }
        field(89;"VAT Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Bus. Posting Group',
                        ENA='GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate();
            begin
                VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Prod. Posting Group',
                        ENA='GST Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate();
            begin
                TestStatusOpen;
                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                "VAT Difference" := 0;
                "VAT %" := VATPostingSetup."VAT %";
                "VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                "VAT Identifier" := VATPostingSetup."VAT Identifier";
                "VAT Clause Code" := VATPostingSetup."VAT Clause Code";
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"Sales Tax":
                    "VAT %" := 0;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      TESTFIELD(Type,Type::"G/L Account");
                      VATPostingSetup.TESTFIELD("Sales VAT Account");
                      TESTFIELD("No.",VATPostingSetup."Sales VAT Account");
                    END;
                END;
                IF SalesHeader."Prices Including VAT" AND (Type IN [Type::Item,Type::Resource]) THEN
                  "Unit Price" :=
                    ROUND(
                      "Unit Price" * (100 + "VAT %") / (100 + xRec."VAT %"),
                      Currency."Unit-Amount Rounding Precision");
                UpdateAmounts;
            end;
        }
        field(91;"Currency Code";Code[10])
        {
            CaptionML = ENU='Currency Code',
                        ENA='Currency Code';
            Editable = false;
            TableRelation = Currency;
        }
        field(92;"Outstanding Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Outstanding Amount (LCY)',
                        ENA='Outstanding Amount (LCY)';
            Editable = false;
        }
        field(93;"Shipped Not Invoiced (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Shipped Not Invoiced (LCY)',
                        ENA='Shipped Not Invoiced (LCY)';
            Editable = false;
        }
        field(95;"Reserved Quantity";Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CalcFormula = -Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.), Source Ref. No.=FIELD(Line No.), Source Type=CONST(37), Source Subtype=FIELD(Document Type), Reservation Status=CONST(Reservation)));
            CaptionML = ENU='Reserved Quantity',
                        ENA='Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(96;Reserve;Option)
        {
            AccessByPermission = TableData Item=R;
            CaptionML = ENU='Reserve',
                        ENA='Reserve';
            OptionCaptionML = ENU='Never,Optional,Always',
                              ENA='Never,Optional,Always';
            OptionMembers = Never,Optional,Always;

            trigger OnValidate();
            begin
                IF Reserve <> Reserve::Never THEN BEGIN
                  TESTFIELD(Type,Type::Item);
                  TESTFIELD("No.");
                END;
                CALCFIELDS("Reserved Qty. (Base)");
                IF (Reserve = Reserve::Never) AND ("Reserved Qty. (Base)" > 0) THEN
                  TESTFIELD("Reserved Qty. (Base)",0);

                IF "Drop Shipment" OR "Special Order" THEN
                  TESTFIELD(Reserve,Reserve::Never);
                IF xRec.Reserve = Reserve::Always THEN BEGIN
                  GetItem;
                  IF Item.Reserve = Item.Reserve::Always THEN
                    TESTFIELD(Reserve,Reserve::Always);
                END;
            end;
        }
        field(97;"Blanket Order No.";Code[20])
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Blanket Order No.',
                        ENA='Blanket Order No.';
            TableRelation = "Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            begin
                BlanketOrderLookup;
            end;

            trigger OnValidate();
            begin
                TESTFIELD("Quantity Shipped",0);
                IF "Blanket Order No." = '' THEN
                  "Blanket Order Line No." := 0
                ELSE
                  VALIDATE("Blanket Order Line No.");
            end;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CaptionML = ENU='Blanket Order Line No.',
                        ENA='Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order), Document No.=FIELD(Blanket Order No.));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            begin
                BlanketOrderLookup;
            end;

            trigger OnValidate();
            begin
                TESTFIELD("Quantity Shipped",0);
                IF "Blanket Order Line No." <> 0 THEN BEGIN
                  SalesLine2.GET("Document Type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.");
                  SalesLine2.TESTFIELD(Type,Type);
                  SalesLine2.TESTFIELD("No.","No.");
                  SalesLine2.TESTFIELD("Bill-to Customer No.","Bill-to Customer No.");
                  SalesLine2.TESTFIELD("Sell-to Customer No.","Sell-to Customer No.");
                  VALIDATE("Variant Code",SalesLine2."Variant Code");
                  VALIDATE("Location Code",SalesLine2."Location Code");
                  VALIDATE("Unit of Measure Code",SalesLine2."Unit of Measure Code");
                  VALIDATE("Unit Price",SalesLine2."Unit Price");
                  VALIDATE("Line Discount %",SalesLine2."Line Discount %");
                END;
            end;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='VAT Base Amount',
                        ENA='GST Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionML = ENU='Unit Cost',
                        ENA='Unit Cost';
            Editable = false;
        }
        field(101;"System-Created Entry";Boolean)
        {
            CaptionML = ENU='System-Created Entry',
                        ENA='System-Created Entry';
            Editable = false;
        }
        field(103;"Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            CaptionML = ENU='Line Amount',
                        ENA='Line Amount';

            trigger OnValidate();
            begin
                TESTFIELD(Type);
                TESTFIELD(Quantity);
                TESTFIELD("Unit Price");
                GetSalesHeader;
                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                VALIDATE(
                  "Line Discount Amount",ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Amount");
            end;
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='VAT Difference',
                        ENA='GST Difference';
            Editable = false;
        }
        field(105;"Inv. Disc. Amount to Invoice";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Disc. Amount to Invoice',
                        ENA='Inv. Disc. Amount to Invoice';
            Editable = false;
        }
        field(106;"VAT Identifier";Code[10])
        {
            CaptionML = ENU='VAT Identifier',
                        ENA='GST Identifier';
            Editable = false;
        }
        field(107;"IC Partner Ref. Type";Option)
        {
            AccessByPermission = TableData "IC G/L Account"=R;
            CaptionML = ENU='IC Partner Ref. Type',
                        ENA='IC Partner Ref. Type';
            OptionCaptionML = ENU=' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.',
                              ENA=' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross Reference","Common Item No.";

            trigger OnValidate();
            begin
                IF "IC Partner Code" <> '' THEN
                  "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
                IF "IC Partner Ref. Type" <> xRec."IC Partner Ref. Type" THEN
                  "IC Partner Reference" := '';
                IF "IC Partner Ref. Type" = "IC Partner Ref. Type"::"Common Item No." THEN BEGIN
                  IF Item."No." <> "No." THEN
                    Item.GET("No.");
                  Item.TESTFIELD("Common Item No.");
                  "IC Partner Reference" := Item."Common Item No.";
                END;
            end;
        }
        field(108;"IC Partner Reference";Code[20])
        {
            AccessByPermission = TableData "IC G/L Account"=R;
            CaptionML = ENU='IC Partner Reference',
                        ENA='IC Partner Reference';

            trigger OnLookup();
            var
                ICGLAccount : Record "IC G/L Account";
                ItemCrossReference : Record "Item Cross Reference";
            begin
                IF "No." <> '' THEN
                  CASE "IC Partner Ref. Type" OF
                    "IC Partner Ref. Type"::"G/L Account":
                      BEGIN
                        IF ICGLAccount.GET("IC Partner Reference") THEN;
                        IF PAGE.RUNMODAL(PAGE::"IC G/L Account List",ICGLAccount) = ACTION::LookupOK THEN
                          VALIDATE("IC Partner Reference",ICGLAccount."No.");
                      END;
                    "IC Partner Ref. Type"::Item:
                      BEGIN
                        IF Item.GET("IC Partner Reference") THEN;
                        IF PAGE.RUNMODAL(PAGE::"Item List",Item) = ACTION::LookupOK THEN
                          VALIDATE("IC Partner Reference",Item."No.");
                      END;
                    "IC Partner Ref. Type"::"Cross Reference":
                      BEGIN
                        ItemCrossReference.RESET;
                        ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
                        ItemCrossReference.SETFILTER(
                          "Cross-Reference Type",'%1|%2',
                          ItemCrossReference."Cross-Reference Type"::Customer,
                          ItemCrossReference."Cross-Reference Type"::" ");
                        ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',"Sell-to Customer No.",'');
                        IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN
                          VALIDATE("IC Partner Reference",ItemCrossReference."Cross-Reference No.");
                      END;
                  END;
            end;
        }
        field(109;"Prepayment %";Decimal)
        {
            CaptionML = ENU='Prepayment %',
                        ENA='Prepayment %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                TestStatusOpen;
                UpdatePrepmtSetupFields;

                IF Type <> Type::" " THEN
                  UpdateAmounts;
            end;
        }
        field(110;"Prepmt. Line Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Line Amount"));
            CaptionML = ENU='Prepmt. Line Amount',
                        ENA='Prepmt. Line Amount';
            MinValue = 0;

            trigger OnValidate();
            begin
                TestStatusOpen;
                PrePaymentLineAmountEntered := TRUE;
                TESTFIELD("Line Amount");
                IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text044,"Prepmt. Amt. Inv."));
                IF "Prepmt. Line Amount" > "Line Amount" THEN
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,"Line Amount"));
                IF "System-Created Entry" THEN
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
                VALIDATE("Prepayment %",ROUND("Prepmt. Line Amount" * 100 / "Line Amount",0.00001));
            end;
        }
        field(111;"Prepmt. Amt. Inv.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt. Amt. Inv."));
            CaptionML = ENU='Prepmt. Amt. Inv.',
                        ENA='Prepmt. Amt. Inv.';
            Editable = false;
        }
        field(112;"Prepmt. Amt. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt. Amt. Incl. VAT',
                        ENA='Prepmt. Amt. Incl. GST';
            Editable = false;
        }
        field(113;"Prepayment Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepayment Amount',
                        ENA='Prepayment Amount';
            Editable = false;
        }
        field(114;"Prepmt. VAT Base Amt.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt. VAT Base Amt.',
                        ENA='Prepmt. GST Base Amt.';
            Editable = false;
        }
        field(115;"Prepayment VAT %";Decimal)
        {
            CaptionML = ENU='Prepayment VAT %',
                        ENA='Prepayment GST %';
            DecimalPlaces = 0:5;
            Editable = false;
            MinValue = 0;
        }
        field(116;"Prepmt. VAT Calc. Type";Option)
        {
            CaptionML = ENU='Prepmt. VAT Calc. Type',
                        ENA='Prepmt. GST Calc. Type';
            Editable = false;
            OptionCaptionML = ENU='Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax',
                              ENA='Normal GST,Reverse Charge GST,Full GST,US Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(117;"Prepayment VAT Identifier";Code[10])
        {
            CaptionML = ENU='Prepayment VAT Identifier',
                        ENA='Prepayment GST Identifier';
            Editable = false;
        }
        field(118;"Prepayment Tax Area Code";Code[20])
        {
            CaptionML = ENU='Prepayment Tax Area Code',
                        ENA='Prepayment US Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate();
            begin
                UpdateAmounts;
            end;
        }
        field(119;"Prepayment Tax Liable";Boolean)
        {
            CaptionML = ENU='Prepayment Tax Liable',
                        ENA='Prepayment US Tax Liable';

            trigger OnValidate();
            begin
                UpdateAmounts;
            end;
        }
        field(120;"Prepayment Tax Group Code";Code[10])
        {
            CaptionML = ENU='Prepayment Tax Group Code',
                        ENA='Prepayment US Tax Group Code';
            TableRelation = "Tax Group";

            trigger OnValidate();
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(121;"Prepmt Amt to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt to Deduct"));
            CaptionML = ENU='Prepmt Amt to Deduct',
                        ENA='Prepmt Amt to Deduct';
            MinValue = 0;

            trigger OnValidate();
            begin
                IF "Prepmt Amt to Deduct" > "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text045,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                IF "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Unit Price" THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text045,"Qty. to Invoice" * "Unit Price"));

                IF ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"
                THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text044,
                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" - (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Unit Price"));
            end;
        }
        field(122;"Prepmt Amt Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Prepmt Amt Deducted"));
            CaptionML = ENU='Prepmt Amt Deducted',
                        ENA='Prepmt Amt Deducted';
            Editable = false;
        }
        field(123;"Prepayment Line";Boolean)
        {
            CaptionML = ENU='Prepayment Line',
                        ENA='Prepayment Line';
            Editable = false;
        }
        field(124;"Prepmt. Amount Inv. Incl. VAT";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt. Amount Inv. Incl. VAT',
                        ENA='Prepmt. Amount Inv. Incl. GST';
            Editable = false;
        }
        field(129;"Prepmt. Amount Inv. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt. Amount Inv. (LCY)',
                        ENA='Prepmt. Amount Inv. (LCY)';
            Editable = false;
        }
        field(130;"IC Partner Code";Code[20])
        {
            CaptionML = ENU='IC Partner Code',
                        ENA='IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate();
            begin
                IF "IC Partner Code" <> '' THEN BEGIN
                  TESTFIELD(Type,Type::"G/L Account");
                  GetSalesHeader;
                  SalesHeader.TESTFIELD("Sell-to IC Partner Code",'');
                  SalesHeader.TESTFIELD("Bill-to IC Partner Code",'');
                  VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"G/L Account");
                END;
            end;
        }
        field(132;"Prepmt. VAT Amount Inv. (LCY)";Decimal)
        {
            CaptionML = ENU='Prepmt. VAT Amount Inv. (LCY)',
                        ENA='Prepmt. GST Amount Inv. (LCY)';
            Editable = false;
        }
        field(135;"Prepayment VAT Difference";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepayment VAT Difference',
                        ENA='Prepayment GST Difference';
            Editable = false;
        }
        field(136;"Prepmt VAT Diff. to Deduct";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt VAT Diff. to Deduct',
                        ENA='Prepmt GST Diff. to Deduct';
            Editable = false;
        }
        field(137;"Prepmt VAT Diff. Deducted";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Prepmt VAT Diff. Deducted',
                        ENA='Prepmt GST Diff. Deducted';
            Editable = false;
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
        field(900;"Qty. to Assemble to Order";Decimal)
        {
            AccessByPermission = TableData "BOM Component"=R;
            CaptionML = ENU='Qty. to Assemble to Order',
                        ENA='Qty. to Assemble to Order';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            var
                SalesLineReserve : Codeunit "Sales Line-Reserve";
            begin
                WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);

                "Qty. to Asm. to Order (Base)" := CalcBaseQty("Qty. to Assemble to Order");

                IF "Qty. to Asm. to Order (Base)" <> 0 THEN BEGIN
                  TESTFIELD("Drop Shipment",FALSE);
                  TESTFIELD("Special Order",FALSE);
                  IF "Qty. to Asm. to Order (Base)" < 0 THEN
                    FIELDERROR("Qty. to Assemble to Order",STRSUBSTNO(Text009,FIELDCAPTION("Quantity (Base)"),"Quantity (Base)"));
                  TESTFIELD("Appl.-to Item Entry",0);

                  CASE "Document Type" OF
                    "Document Type"::"Blanket Order",
                    "Document Type"::Quote:
                      IF ("Quantity (Base)" = 0) OR ("Qty. to Asm. to Order (Base)" <= 0) OR SalesLineReserve.ReservEntryExist(Rec) THEN
                        TESTFIELD("Qty. to Asm. to Order (Base)",0)
                      ELSE
                        IF "Quantity (Base)" <> "Qty. to Asm. to Order (Base)" THEN
                          FIELDERROR("Qty. to Assemble to Order",STRSUBSTNO(Text031,0,"Quantity (Base)"));
                    "Document Type"::Order:
                      ;
                    ELSE
                      TESTFIELD("Qty. to Asm. to Order (Base)",0);
                  END;
                END;

                CheckItemAvailable(FIELDNO("Qty. to Assemble to Order"));
                IF NOT (CurrFieldNo IN [FIELDNO(Quantity),FIELDNO("Qty. to Assemble to Order")]) THEN
                  GetDefaultBin;
                AutoAsmToOrder;
            end;
        }
        field(901;"Qty. to Asm. to Order (Base)";Decimal)
        {
            CaptionML = ENU='Qty. to Asm. to Order (Base)',
                        ENA='Qty. to Asm. to Order (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Qty. to Assemble to Order","Qty. to Asm. to Order (Base)");
            end;
        }
        field(902;"ATO Whse. Outstanding Qty.";Decimal)
        {
            AccessByPermission = TableData "BOM Component"=R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE (Source Type=CONST(37), Source Subtype=FIELD(Document Type), Source No.=FIELD(Document No.), Source Line No.=FIELD(Line No.), Assemble to Order=FILTER(Yes)));
            CaptionML = ENU='ATO Whse. Outstanding Qty.',
                        ENA='ATO Whse. Outstanding Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(903;"ATO Whse. Outstd. Qty. (Base)";Decimal)
        {
            AccessByPermission = TableData "BOM Component"=R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(37), Source Subtype=FIELD(Document Type), Source No.=FIELD(Document No.), Source Line No.=FIELD(Line No.), Assemble to Order=FILTER(Yes)));
            CaptionML = ENU='ATO Whse. Outstd. Qty. (Base)',
                        ENA='ATO Whse. Outstd. Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(1001;"Job Task No.";Code[20])
        {
            CaptionML = ENU='Job Task No.',
                        ENA='Job Task No.';
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
        }
        field(1002;"Job Contract Entry No.";Integer)
        {
            AccessByPermission = TableData Job=R;
            CaptionML = ENU='Job Contract Entry No.',
                        ENA='Job Contract Entry No.';
            Editable = false;

            trigger OnValidate();
            var
                JobPlanningLine : Record "Job Planning Line";
            begin
                JobPlanningLine.SETCURRENTKEY("Job Contract Entry No.");
                JobPlanningLine.SETRANGE("Job Contract Entry No.","Job Contract Entry No.");
                JobPlanningLine.FINDFIRST;
                CreateDim(
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::Job,JobPlanningLine."Job No.",
                  DATABASE::"Responsibility Center","Responsibility Center");
            end;
        }
        field(1300;"Posting Date";Date)
        {
            CalcFormula = Lookup("Sales Header"."Posting Date" WHERE (Document Type=FIELD(Document Type), No.=FIELD(Document No.)));
            CaptionML = ENU='Posting Date',
                        ENA='Posting Date';
            FieldClass = FlowField;
        }
        field(1700;"Deferral Code";Code[10])
        {
            CaptionML = ENU='Deferral Code',
                        ENA='Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate();
            begin
                GetSalesHeader;
                DeferralPostDate := SalesHeader."Posting Date";

                DeferralUtilities.DeferralCodeOnValidate(
                  "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
                  "Document Type","Document No.","Line No.",
                  GetDeferralAmount,DeferralPostDate,
                  Description,SalesHeader."Currency Code");

                IF "Document Type" = "Document Type"::"Return Order" THEN
                  "Returns Deferral Start Date" :=
                    DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetSalesDeferralDocType,
                      "Document Type","Document No.","Line No.","Deferral Code",SalesHeader."Posting Date");
            end;
        }
        field(1702;"Returns Deferral Start Date";Date)
        {
            CaptionML = ENU='Returns Deferral Start Date',
                        ENA='Returns Deferral Start Date';

            trigger OnValidate();
            var
                DeferralHeader : Record "Deferral Header";
            begin
                GetSalesHeader;
                IF DeferralHeader.GET(DeferralUtilities.GetSalesDeferralDocType,'','',"Document Type","Document No.","Line No.") THEN
                  DeferralUtilities.CreateDeferralSchedule("Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
                    "Document Type","Document No.","Line No.",GetDeferralAmount,
                    DeferralHeader."Calc. Method","Returns Deferral Start Date",
                    DeferralHeader."No. of Periods",TRUE,
                    DeferralHeader."Schedule Description",FALSE,
                    SalesHeader."Currency Code");
            end;
        }
        field(5402;"Variant Code";Code[10])
        {
            CaptionML = ENU='Variant Code',
                        ENA='Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                IF "Variant Code" <> '' THEN
                  TESTFIELD(Type,Type::Item);
                TestStatusOpen;
                CheckAssocPurchOrder(FIELDCAPTION("Variant Code"));

                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                  TESTFIELD("Qty. Shipped Not Invoiced",0);
                  TESTFIELD("Shipment No.",'');

                  TESTFIELD("Return Qty. Rcd. Not Invd.",0);
                  TESTFIELD("Return Receipt No.",'');
                  InitItemAppl(FALSE);
                END;

                CheckItemAvailable(FIELDNO("Variant Code"));

                IF Type = Type::Item THEN BEGIN
                  GetUnitCost;
                  UpdateUnitPrice(FIELDNO("Variant Code"));
                END;

                GetDefaultBin;
                InitQtyToAsm;
                AutoAsmToOrder;
                IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
                  IF NOT FullReservedQtyIsForAsmToOrder THEN
                    ReserveSalesLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                END;

                UpdateItemCrossRef;
            end;
        }
        field(5403;"Bin Code";Code[20])
        {
            CaptionML = ENU='Bin Code',
                        ENA='Bin Code';
            TableRelation = IF (Document Type=FILTER(Order|Invoice), Quantity=FILTER(>=0), Qty. to Asm. to Order (Base)=CONST(0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code), Item No.=FIELD(No.), Variant Code=FIELD(Variant Code)) ELSE IF (Document Type=FILTER(Return Order|Credit Memo), Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code), Item No.=FIELD(No.), Variant Code=FIELD(Variant Code)) ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));

            trigger OnLookup();
            var
                WMSManagement : Codeunit "WMS Management";
                BinCode : Code[20];
            begin
                IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
                  BinCode := WMSManagement.BinContentLookUp("Location Code","No.","Variant Code",'',"Bin Code")
                ELSE
                  BinCode := WMSManagement.BinLookUp("Location Code","No.","Variant Code",'');

                IF BinCode <> '' THEN
                  VALIDATE("Bin Code",BinCode);
            end;

            trigger OnValidate();
            var
                WMSManagement : Codeunit "WMS Management";
            begin
                IF "Bin Code" <> '' THEN BEGIN
                  IF NOT IsInbound AND ("Quantity (Base)" <> 0) AND ("Qty. to Asm. to Order (Base)" = 0) THEN
                    WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                  ELSE
                    WMSManagement.FindBin("Location Code","Bin Code",'');
                END;

                IF "Drop Shipment" THEN
                  CheckAssocPurchOrder(FIELDCAPTION("Bin Code"));

                TESTFIELD(Type,Type::Item);
                TESTFIELD("Location Code");

                IF (Type = Type::Item) AND ("Bin Code" <> '') THEN BEGIN
                  TESTFIELD("Drop Shipment",FALSE);
                  GetLocation("Location Code");
                  Location.TESTFIELD("Bin Mandatory");
                  CheckWarehouse;
                END;
                ATOLink.UpdateAsmBinCodeFromSalesLine(Rec);
            end;
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            CaptionML = ENU='Qty. per Unit of Measure',
                        ENA='Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(5405;Planned;Boolean)
        {
            CaptionML = ENU='Planned',
                        ENA='Planned';
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            CaptionML = ENU='Unit of Measure Code',
                        ENA='Unit of Measure Code';

            trigger OnLookup();
            begin
                LookupUnitOfMeasureCode;
            end;

            trigger OnValidate();
            var
                UnitOfMeasureTranslation : Record "Unit of Measure Translation";
                ResUnitofMeasure : Record "Resource Unit of Measure";
            begin
                TestJobPlanningLine;
                TestStatusOpen;
                TESTFIELD("Quantity Shipped",0);
                TESTFIELD("Qty. Shipped (Base)",0);
                TESTFIELD("Return Qty. Received",0);
                TESTFIELD("Return Qty. Received (Base)",0);
                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                  TESTFIELD("Shipment No.",'');
                  TESTFIELD("Return Receipt No.",'');
                END;

                CheckAssocPurchOrder(FIELDCAPTION("Unit of Measure Code"));

                IF "Unit of Measure Code" = '' THEN
                  "Unit of Measure" := ''
                ELSE BEGIN
                  IF NOT UnitOfMeasure.GET("Unit of Measure Code") THEN
                    UnitOfMeasure.INIT;
                  "Unit of Measure" := UnitOfMeasure.Description;
                  GetSalesHeader;
                  IF SalesHeader."Language Code" <> '' THEN BEGIN
                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                    UnitOfMeasureTranslation.SETRANGE("Language Code",SalesHeader."Language Code");
                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                  END;
                END;
                DistIntegration.EnterSalesItemCrossRef(Rec);
                CASE Type OF
                  Type::Item:
                    BEGIN
                      GetItem;
                      GetUnitCost;
                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                      CheckItemAvailable(FIELDNO("Unit of Measure Code"));
                      "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                      "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                      "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                      "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                      IF (xRec."Unit of Measure Code" <> "Unit of Measure Code") AND (Quantity <> 0) THEN
                        WhseValidateSourceLine.SalesLineVerifyChange(Rec,xRec);
                      IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                        InitItemAppl(FALSE);
                    END;
                  Type::Resource:
                    BEGIN
                      IF "Unit of Measure Code" = '' THEN BEGIN
                        GetResource;
                        "Unit of Measure Code" := Resource."Base Unit of Measure";
                      END;
                      ResUnitofMeasure.GET("No.","Unit of Measure Code");
                      "Qty. per Unit of Measure" := ResUnitofMeasure."Qty. per Unit of Measure";
                      UpdateUnitPrice(FIELDNO("Unit of Measure Code"));
                      FindResUnitCost;
                    END;
                  Type::"G/L Account",Type::"Fixed Asset",Type::"Charge (Item)",Type::" ":
                    "Qty. per Unit of Measure" := 1;
                END;
                VALIDATE(Quantity);
            end;
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            CaptionML = ENU='Quantity (Base)',
                        ENA='Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TestJobPlanningLine;
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE(Quantity,"Quantity (Base)");
                UpdateUnitPrice(FIELDNO("Quantity (Base)"));
            end;
        }
        field(5416;"Outstanding Qty. (Base)";Decimal)
        {
            CaptionML = ENU='Outstanding Qty. (Base)',
                        ENA='Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5417;"Qty. to Invoice (Base)";Decimal)
        {
            CaptionML = ENU='Qty. to Invoice (Base)',
                        ENA='Qty. to Invoice (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Qty. to Invoice","Qty. to Invoice (Base)");
            end;
        }
        field(5418;"Qty. to Ship (Base)";Decimal)
        {
            CaptionML = ENU='Qty. to Ship (Base)',
                        ENA='Qty. to Ship (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Qty. to Ship","Qty. to Ship (Base)");
            end;
        }
        field(5458;"Qty. Shipped Not Invd. (Base)";Decimal)
        {
            CaptionML = ENU='Qty. Shipped Not Invd. (Base)',
                        ENA='Qty. Shipped Not Invd. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5460;"Qty. Shipped (Base)";Decimal)
        {
            CaptionML = ENU='Qty. Shipped (Base)',
                        ENA='Qty. Shipped (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5461;"Qty. Invoiced (Base)";Decimal)
        {
            CaptionML = ENU='Qty. Invoiced (Base)',
                        ENA='Qty. Invoiced (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5495;"Reserved Qty. (Base)";Decimal)
        {
            AccessByPermission = TableData "Sales Shipment Header"=R;
            CalcFormula = -Sum("Reservation Entry"."Quantity (Base)" WHERE (Source ID=FIELD(Document No.), Source Ref. No.=FIELD(Line No.), Source Type=CONST(37), Source Subtype=FIELD(Document Type), Reservation Status=CONST(Reservation)));
            CaptionML = ENU='Reserved Qty. (Base)',
                        ENA='Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5600;"FA Posting Date";Date)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Posting Date',
                        ENA='FA Posting Date';
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            CaptionML = ENU='Depreciation Book Code',
                        ENA='Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate();
            begin
                GetFAPostingGroup;
            end;
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='Depr. until FA Posting Date',
                        ENA='Depr. until FA Posting Date';
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
        field(5700;"Responsibility Center";Code[10])
        {
            CaptionML = ENU='Responsibility Center',
                        ENA='Responsibility Centre';
            Editable = false;
            TableRelation = "Responsibility Center";

            trigger OnValidate();
            begin
                CreateDim(
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::Job,"Job No.");
            end;
        }
        field(5701;"Out-of-Stock Substitution";Boolean)
        {
            CaptionML = ENU='Out-of-Stock Substitution',
                        ENA='Out-of-Stock Substitution';
            Editable = false;
        }
        field(5702;"Substitution Available";Boolean)
        {
            CalcFormula = Exist("Item Substitution" WHERE (Type=CONST(Item), No.=FIELD(No.), Substitute Type=CONST(Item)));
            CaptionML = ENU='Substitution Available',
                        ENA='Substitution Available';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5703;"Originally Ordered No.";Code[20])
        {
            AccessByPermission = TableData "Item Substitution"=R;
            CaptionML = ENU='Originally Ordered No.',
                        ENA='Originally Ordered No.';
            TableRelation = IF (Type=CONST(Item)) Item;
        }
        field(5704;"Originally Ordered Var. Code";Code[10])
        {
            AccessByPermission = TableData "Item Substitution"=R;
            CaptionML = ENU='Originally Ordered Var. Code',
                        ENA='Originally Ordered Var. Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(Originally Ordered No.));
        }
        field(5705;"Cross-Reference No.";Code[20])
        {
            AccessByPermission = TableData "Item Cross Reference"=R;
            CaptionML = ENU='Cross-Reference No.',
                        ENA='Cross-Reference No.';

            trigger OnLookup();
            begin
                CrossReferenceNoLookUp;
            end;

            trigger OnValidate();
            var
                ReturnedCrossRef : Record "Item Cross Reference";
            begin
                GetSalesHeader;
                "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                ReturnedCrossRef.INIT;
                IF "Cross-Reference No." <> '' THEN BEGIN
                  DistIntegration.ICRLookupSalesItem(Rec,ReturnedCrossRef);
                  IF "No." <> ReturnedCrossRef."Item No." THEN
                    VALIDATE("No.",ReturnedCrossRef."Item No.");
                  IF ReturnedCrossRef."Variant Code" <> '' THEN
                    VALIDATE("Variant Code",ReturnedCrossRef."Variant Code");

                  IF ReturnedCrossRef."Unit of Measure" <> '' THEN
                    VALIDATE("Unit of Measure Code",ReturnedCrossRef."Unit of Measure");
                END;

                "Unit of Measure (Cross Ref.)" := ReturnedCrossRef."Unit of Measure";
                "Cross-Reference Type" := ReturnedCrossRef."Cross-Reference Type";
                "Cross-Reference Type No." := ReturnedCrossRef."Cross-Reference Type No.";
                "Cross-Reference No." := ReturnedCrossRef."Cross-Reference No.";

                IF ReturnedCrossRef.Description <> '' THEN
                  Description := ReturnedCrossRef.Description;

                UpdateUnitPrice(FIELDNO("Cross-Reference No."));
                UpdateICPartner;
            end;
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
            AccessByPermission = TableData "Item Cross Reference"=R;
            CaptionML = ENU='Unit of Measure (Cross Ref.)',
                        ENA='Unit of Measure (Cross Ref.)';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.));
        }
        field(5707;"Cross-Reference Type";Option)
        {
            CaptionML = ENU='Cross-Reference Type',
                        ENA='Cross-Reference Type';
            OptionCaptionML = ENU=' ,Customer,Vendor,Bar Code',
                              ENA=' ,Customer,Vendor,Bar Code';
            OptionMembers = " ",Customer,Vendor,"Bar Code";
        }
        field(5708;"Cross-Reference Type No.";Code[30])
        {
            CaptionML = ENU='Cross-Reference Type No.',
                        ENA='Cross-Reference Type No.';
        }
        field(5709;"Item Category Code";Code[20])
        {
            CaptionML = ENU='Item Category Code',
                        ENA='Item Category Code';
            TableRelation = "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            AccessByPermission = TableData "Nonstock Item"=R;
            CaptionML = ENU='Nonstock',
                        ENA='Nonstock';
            Editable = false;
        }
        field(5711;"Purchasing Code";Code[10])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Purchasing Code',
                        ENA='Purchasing Code';
            TableRelation = Purchasing;

            trigger OnValidate();
            var
                PurchasingCode : Record Purchasing;
                ShippingAgentServices : Record "Shipping Agent Services";
            begin
                TestStatusOpen;
                TESTFIELD(Type,Type::Item);
                CheckAssocPurchOrder(FIELDCAPTION(Type));

                IF PurchasingCode.GET("Purchasing Code") THEN BEGIN
                  "Drop Shipment" := PurchasingCode."Drop Shipment";
                  "Special Order" := PurchasingCode."Special Order";
                  IF "Drop Shipment" OR "Special Order" THEN BEGIN
                    TESTFIELD("Qty. to Asm. to Order (Base)",0);
                    CALCFIELDS("Reserved Qty. (Base)");
                    TESTFIELD("Reserved Qty. (Base)",0);
                    ReserveSalesLine.VerifyChange(Rec,xRec);

                    IF (Quantity <> 0) AND (Quantity = "Quantity Shipped") THEN
                      ERROR(SalesLineCompletelyShippedErr);
                    Reserve := Reserve::Never;
                    VALIDATE(Quantity,Quantity);
                    IF "Drop Shipment" THEN BEGIN
                      EVALUATE("Outbound Whse. Handling Time",'<0D>');
                      EVALUATE("Shipping Time",'<0D>');
                      UpdateDates;
                      "Bin Code" := '';
                    END;
                  END ELSE
                    SetReserveWithoutPurchasingCode;
                END ELSE BEGIN
                  "Drop Shipment" := FALSE;
                  "Special Order" := FALSE;
                  SetReserveWithoutPurchasingCode;
                END;

                IF ("Purchasing Code" <> xRec."Purchasing Code") AND
                   (NOT "Drop Shipment") AND
                   ("Drop Shipment" <> xRec."Drop Shipment")
                THEN BEGIN
                  IF "Location Code" = '' THEN BEGIN
                    IF InvtSetup.GET THEN
                      "Outbound Whse. Handling Time" := InvtSetup."Outbound Whse. Handling Time";
                  END ELSE
                    IF Location.GET("Location Code") THEN
                      "Outbound Whse. Handling Time" := Location."Outbound Whse. Handling Time";
                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                  ELSE BEGIN
                    GetSalesHeader;
                    "Shipping Time" := SalesHeader."Shipping Time";
                  END;
                  UpdateDates;
                END;
            end;
        }
        field(5712;"Product Group Code";Code[10])
        {
            CaptionML = ENU='Product Group Code',
                        ENA='Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
            ValidateTableRelation = false;
        }
        field(5713;"Special Order";Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Special Order',
                        ENA='Special Order';
            Editable = false;
        }
        field(5714;"Special Order Purchase No.";Code[20])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Special Order Purchase No.',
                        ENA='Special Order Purchase No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Header".No. WHERE (Document Type=CONST(Order));
        }
        field(5715;"Special Order Purch. Line No.";Integer)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Special Order Purch. Line No.',
                        ENA='Special Order Purch. Line No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Purchase Line"."Line No." WHERE (Document Type=CONST(Order), Document No.=FIELD(Special Order Purchase No.));
        }
        field(5749;"Whse. Outstanding Qty.";Decimal)
        {
            AccessByPermission = TableData Location=R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding" WHERE (Source Type=CONST(37), Source Subtype=FIELD(Document Type), Source No.=FIELD(Document No.), Source Line No.=FIELD(Line No.)));
            CaptionML = ENU='Whse. Outstanding Qty.',
                        ENA='Whse. Outstanding Qty.';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5750;"Whse. Outstanding Qty. (Base)";Decimal)
        {
            AccessByPermission = TableData Location=R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Shipment Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(37), Source Subtype=FIELD(Document Type), Source No.=FIELD(Document No.), Source Line No.=FIELD(Line No.)));
            CaptionML = ENU='Whse. Outstanding Qty. (Base)',
                        ENA='Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752;"Completely Shipped";Boolean)
        {
            CaptionML = ENU='Completely Shipped',
                        ENA='Completely Shipped';
            Editable = false;
        }
        field(5790;"Requested Delivery Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Requested Delivery Date',
                        ENA='Requested Delivery Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF ("Requested Delivery Date" <> xRec."Requested Delivery Date") AND
                   ("Promised Delivery Date" <> 0D)
                THEN
                  ERROR(
                    Text028,
                    FIELDCAPTION("Requested Delivery Date"),
                    FIELDCAPTION("Promised Delivery Date"));

                IF "Requested Delivery Date" <> 0D THEN
                  VALIDATE("Planned Delivery Date","Requested Delivery Date")
                ELSE BEGIN
                  GetSalesHeader;
                  VALIDATE("Shipment Date",SalesHeader."Shipment Date");
                END;
            end;
        }
        field(5791;"Promised Delivery Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Promised Delivery Date',
                        ENA='Promised Delivery Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Promised Delivery Date" <> 0D THEN
                  VALIDATE("Planned Delivery Date","Promised Delivery Date")
                ELSE
                  VALIDATE("Requested Delivery Date");
            end;
        }
        field(5792;"Shipping Time";DateFormula)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Shipping Time',
                        ENA='Shipping Time';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Drop Shipment" THEN
                  DateFormularZero("Shipping Time",FIELDNO("Shipping Time"),FIELDCAPTION("Shipping Time"));
                UpdateDates;
            end;
        }
        field(5793;"Outbound Whse. Handling Time";DateFormula)
        {
            AccessByPermission = TableData Location=R;
            CaptionML = ENU='Outbound Whse. Handling Time',
                        ENA='Outbound Whse. Handling Time';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Drop Shipment" THEN
                  DateFormularZero("Outbound Whse. Handling Time",
                    FIELDNO("Outbound Whse. Handling Time"),FIELDCAPTION("Outbound Whse. Handling Time"));
                UpdateDates;
            end;
        }
        field(5794;"Planned Delivery Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Planned Delivery Date',
                        ENA='Planned Delivery Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Planned Delivery Date" <> 0D THEN BEGIN
                  PlannedDeliveryDateCalculated := TRUE;

                  IF FORMAT("Shipping Time") <> '' THEN
                    VALIDATE("Planned Shipment Date",CalcPlannedDeliveryDate(FIELDNO("Planned Delivery Date")))
                  ELSE
                    VALIDATE("Planned Shipment Date",CalcPlannedShptDate(FIELDNO("Planned Delivery Date")));

                  IF "Planned Shipment Date" > "Planned Delivery Date" THEN
                    "Planned Delivery Date" := "Planned Shipment Date";
                END;
            end;
        }
        field(5795;"Planned Shipment Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Planned Shipment Date',
                        ENA='Planned Shipment Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Planned Shipment Date" <> 0D THEN BEGIN
                  PlannedShipmentDateCalculated := TRUE;

                  IF FORMAT("Outbound Whse. Handling Time") <> '' THEN
                    VALIDATE(
                      "Shipment Date",
                      CalendarMgmt.CalcDateBOC2(
                        FORMAT("Outbound Whse. Handling Time"),
                        "Planned Shipment Date",
                        CalChange."Source Type"::Location,
                        "Location Code",
                        '',
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        FALSE))
                  ELSE
                    VALIDATE(
                      "Shipment Date",
                      CalendarMgmt.CalcDateBOC(
                        FORMAT(FORMAT('')),
                        "Planned Shipment Date",
                        CalChange."Source Type"::"Shipping Agent",
                        "Shipping Agent Code",
                        "Shipping Agent Service Code",
                        CalChange."Source Type"::Location,
                        "Location Code",
                        '',
                        FALSE));
                END;
            end;
        }
        field(5796;"Shipping Agent Code";Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services"=R;
            CaptionML = ENU='Shipping Agent Code',
                        ENA='Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Shipping Agent Code" <> xRec."Shipping Agent Code" THEN
                  VALIDATE("Shipping Agent Service Code",'');
            end;
        }
        field(5797;"Shipping Agent Service Code";Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services"=R;
            CaptionML = ENU='Shipping Agent Service Code',
                        ENA='Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code WHERE (Shipping Agent Code=FIELD(Shipping Agent Code));

            trigger OnValidate();
            var
                ShippingAgentServices : Record "Shipping Agent Services";
            begin
                TestStatusOpen;
                IF "Shipping Agent Service Code" <> xRec."Shipping Agent Service Code" THEN
                  EVALUATE("Shipping Time",'<>');

                IF "Drop Shipment" THEN BEGIN
                  EVALUATE("Shipping Time",'<0D>');
                  UpdateDates;
                END ELSE
                  IF ShippingAgentServices.GET("Shipping Agent Code","Shipping Agent Service Code") THEN
                    "Shipping Time" := ShippingAgentServices."Shipping Time"
                  ELSE BEGIN
                    GetSalesHeader;
                    "Shipping Time" := SalesHeader."Shipping Time";
                  END;

                IF ShippingAgentServices."Shipping Time" <> xRec."Shipping Time" THEN
                  VALIDATE("Shipping Time","Shipping Time");
            end;
        }
        field(5800;"Allow Item Charge Assignment";Boolean)
        {
            AccessByPermission = TableData "Item Charge"=R;
            CaptionML = ENU='Allow Item Charge Assignment',
                        ENA='Allow Item Charge Assignment';
            InitValue = true;

            trigger OnValidate();
            begin
                CheckItemChargeAssgnt;
            end;
        }
        field(5801;"Qty. to Assign";Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. to Assign" WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.), Document Line No.=FIELD(Line No.)));
            CaptionML = ENU='Qty. to Assign',
                        ENA='Qty. to Assign';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802;"Qty. Assigned";Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Sales)"."Qty. Assigned" WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.), Document Line No.=FIELD(Line No.)));
            CaptionML = ENU='Qty. Assigned',
                        ENA='Qty. Assigned';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803;"Return Qty. to Receive";Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header"=R;
            CaptionML = ENU='Return Qty. to Receive',
                        ENA='Return Qty. to Receive';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            var
                ItemLedgEntry : Record "Item Ledger Entry";
            begin
                IF (CurrFieldNo <> 0) AND
                   (Type = Type::Item) AND
                   ("Return Qty. to Receive" <> 0) AND
                   (NOT "Drop Shipment")
                THEN
                  CheckWarehouse;

                IF "Return Qty. to Receive" = Quantity - "Return Qty. Received" THEN
                  InitQtyToReceive
                ELSE BEGIN
                  "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");
                  InitQtyToInvoice;
                END;
                IF ("Return Qty. to Receive" * Quantity < 0) OR
                   (ABS("Return Qty. to Receive") > ABS("Outstanding Quantity")) OR
                   (Quantity * "Outstanding Quantity" < 0)
                THEN
                  ERROR(
                    Text020,
                    "Outstanding Quantity");
                IF ("Return Qty. to Receive (Base)" * "Quantity (Base)" < 0) OR
                   (ABS("Return Qty. to Receive (Base)") > ABS("Outstanding Qty. (Base)")) OR
                   ("Quantity (Base)" * "Outstanding Qty. (Base)" < 0)
                THEN
                  ERROR(
                    Text021,
                    "Outstanding Qty. (Base)");

                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Return Qty. to Receive" > 0) THEN
                  CheckApplFromItemLedgEntry(ItemLedgEntry);
            end;
        }
        field(5804;"Return Qty. to Receive (Base)";Decimal)
        {
            CaptionML = ENU='Return Qty. to Receive (Base)',
                        ENA='Return Qty. to Receive (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Return Qty. to Receive","Return Qty. to Receive (Base)");
            end;
        }
        field(5805;"Return Qty. Rcd. Not Invd.";Decimal)
        {
            CaptionML = ENU='Return Qty. Rcd. Not Invd.',
                        ENA='Return Qty. Rcd. Not Invd.';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5806;"Ret. Qty. Rcd. Not Invd.(Base)";Decimal)
        {
            CaptionML = ENU='Ret. Qty. Rcd. Not Invd.(Base)',
                        ENA='Ret. Qty. Rcd. Not Invd.(Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5807;"Return Rcd. Not Invd.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Return Rcd. Not Invd.',
                        ENA='Return Rcd. Not Invd.';
            Editable = false;

            trigger OnValidate();
            var
                Currency2 : Record Currency;
            begin
                GetSalesHeader;
                Currency2.InitRoundingPrecision;
                IF SalesHeader."Currency Code" <> '' THEN
                  "Return Rcd. Not Invd. (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Return Rcd. Not Invd.",SalesHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Return Rcd. Not Invd. (LCY)" :=
                    ROUND("Return Rcd. Not Invd.",Currency2."Amount Rounding Precision");
            end;
        }
        field(5808;"Return Rcd. Not Invd. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Return Rcd. Not Invd. (LCY)',
                        ENA='Return Rcd. Not Invd. (LCY)';
            Editable = false;
        }
        field(5809;"Return Qty. Received";Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header"=R;
            CaptionML = ENU='Return Qty. Received',
                        ENA='Return Qty. Received';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5810;"Return Qty. Received (Base)";Decimal)
        {
            CaptionML = ENU='Return Qty. Received (Base)',
                        ENA='Return Qty. Received (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5811;"Appl.-from Item Entry";Integer)
        {
            AccessByPermission = TableData Item=R;
            CaptionML = ENU='Appl.-from Item Entry',
                        ENA='Appl.-from Item Entry';
            MinValue = 0;

            trigger OnLookup();
            begin
                SelectItemEntry(FIELDNO("Appl.-from Item Entry"));
            end;

            trigger OnValidate();
            var
                ItemLedgEntry : Record "Item Ledger Entry";
            begin
                IF "Appl.-from Item Entry" <> 0 THEN BEGIN
                  CheckApplFromItemLedgEntry(ItemLedgEntry);
                  VALIDATE("Unit Cost (LCY)",CalcUnitCost(ItemLedgEntry));
                END;
            end;
        }
        field(5909;"BOM Item No.";Code[20])
        {
            CaptionML = ENU='BOM Item No.',
                        ENA='BOM Item No.';
            TableRelation = Item;
        }
        field(6600;"Return Receipt No.";Code[20])
        {
            CaptionML = ENU='Return Receipt No.',
                        ENA='Return Receipt No.';
            Editable = false;
        }
        field(6601;"Return Receipt Line No.";Integer)
        {
            CaptionML = ENU='Return Receipt Line No.',
                        ENA='Return Receipt Line No.';
            Editable = false;
        }
        field(6608;"Return Reason Code";Code[10])
        {
            CaptionML = ENU='Return Reason Code',
                        ENA='Return Reason Code';
            TableRelation = "Return Reason";

            trigger OnValidate();
            begin
                ValidateReturnReasonCode(FIELDNO("Return Reason Code"));
            end;
        }
        field(7001;"Allow Line Disc.";Boolean)
        {
            CaptionML = ENU='Allow Line Disc.',
                        ENA='Allow Line Disc.';
            InitValue = true;
        }
        field(7002;"Customer Disc. Group";Code[20])
        {
            CaptionML = ENU='Customer Disc. Group',
                        ENA='Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate();
            begin
                IF Type = Type::Item THEN
                  UpdateUnitPrice(FIELDNO("Customer Disc. Group"))
            end;
        }
        field(28006;"Prepmt. VAT Amount Deducted";Decimal)
        {
            CaptionML = ENU='Prepmt. VAT Amount Deducted',
                        ENA='Prepmt. GST Amount Deducted';
            Editable = false;
        }
        field(28007;"Prepmt. VAT Base Deducted";Decimal)
        {
            CaptionML = ENU='Prepmt. VAT Base Deducted',
                        ENA='Prepmt. GST Base Deducted';
            Editable = false;
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
        field(50000;Narration;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            SumIndexFields = Amount,"Amount Including VAT","Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)";
        }
        key(Key2;"Document No.","Line No.","Document Type")
        {
            Enabled = false;
        }
        key(Key3;"Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key4;"Document Type","Bill-to Customer No.","Currency Code")
        {
            SumIndexFields = "Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)","Return Rcd. Not Invd. (LCY)";
        }
        key(Key5;"Document Type",Type,"No.","Variant Code","Drop Shipment","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Location Code","Shipment Date")
        {
            Enabled = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key6;"Document Type","Bill-to Customer No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Currency Code")
        {
            Enabled = false;
            SumIndexFields = "Outstanding Amount","Shipped Not Invoiced","Outstanding Amount (LCY)","Shipped Not Invoiced (LCY)";
        }
        key(Key7;"Document Type","Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key8;"Document Type","Document No.","Location Code")
        {
            Enabled = false;
        }
        key(Key9;"Document Type","Shipment No.","Shipment Line No.")
        {
        }
        key(Key10;Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type","Shipment Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key11;"Document Type","Sell-to Customer No.","Shipment No.")
        {
            SumIndexFields = "Outstanding Amount (LCY)";
        }
        key(Key12;"Job Contract Entry No.")
        {
        }
        key(Key13;"Document Type","Document No.","Qty. Shipped Not Invoiced")
        {
            Enabled = false;
        }
        key(Key14;"Document Type","Document No.",Type,"No.")
        {
            Enabled = false;
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;Quantity,Description,"Unit Price",Amount,"Amount Including VAT")
        {
        }
    }

    trigger OnDelete();
    var
        SalesCommentLine : Record "Sales Comment Line";
        CapableToPromise : Codeunit "Capable to Promise";
        JobCreateInvoice : Codeunit "Job Create-Invoice";
    begin
        TestStatusOpen;
        IF NOT StatusCheckSuspended AND (SalesHeader.Status = SalesHeader.Status::Released) AND
           (Type IN [Type::"G/L Account",Type::"Charge (Item)",Type::Resource])
        THEN
          VALIDATE(Quantity,0);

        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          ReserveSalesLine.DeleteLine(Rec);
          CALCFIELDS("Reserved Qty. (Base)");
          TESTFIELD("Reserved Qty. (Base)",0);
          IF "Shipment No." = '' THEN
            TESTFIELD("Qty. Shipped Not Invoiced",0);
          IF "Return Receipt No." = '' THEN
            TESTFIELD("Return Qty. Rcd. Not Invd.",0);
          WhseValidateSourceLine.SalesLineDelete(Rec);
        END;

        IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
          TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

        CleanSpecialOrderFieldsAndCheckAssocPurchOrder;
        NonstockItemMgt.DelNonStockSales(Rec);

        IF "Document Type" = "Document Type"::"Blanket Order" THEN BEGIN
          SalesLine2.RESET;
          SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
          SalesLine2.SETRANGE("Blanket Order No.","Document No.");
          SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
          IF SalesLine2.FINDFIRST THEN
            SalesLine2.TESTFIELD("Blanket Order Line No.",0);
        END;

        IF Type = Type::Item THEN BEGIN
          ATOLink.DeleteAsmFromSalesLine(Rec);
          DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
        END;

        IF Type = Type::"Charge (Item)" THEN
          DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

        CapableToPromise.RemoveReqLines("Document No.","Line No.",0,FALSE);

        IF "Line No." <> 0 THEN BEGIN
          SalesLine2.RESET;
          SalesLine2.SETRANGE("Document Type","Document Type");
          SalesLine2.SETRANGE("Document No.","Document No.");
          SalesLine2.SETRANGE("Attached to Line No.","Line No.");
          SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
          SalesLine2.DELETEALL(TRUE);
        END;

        IF "Job Contract Entry No." <> 0 THEN
          JobCreateInvoice.DeleteSalesLine(Rec);

        SalesCommentLine.SETRANGE("Document Type","Document Type");
        SalesCommentLine.SETRANGE("No.","Document No.");
        SalesCommentLine.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesCommentLine.ISEMPTY THEN
          SalesCommentLine.DELETEALL;

        IF ("Line No." <> 0) AND ("Attached to Line No." = 0) THEN BEGIN
          SalesLine2.COPY(Rec);
          IF SalesLine2.FIND('<>') THEN BEGIN
            SalesLine2.VALIDATE("Recalculate Invoice Disc.",TRUE);
            SalesLine2.MODIFY;
          END;
        END;

        IF "Deferral Code" <> '' THEN
          DeferralUtilities.DeferralCodeOnDelete(
            DeferralUtilities.GetSalesDeferralDocType,'','',
            "Document Type","Document No.","Line No.");
    end;

    trigger OnInsert();
    begin
        TestStatusOpen;
        IF Quantity <> 0 THEN
          ReserveSalesLine.VerifyQuantity(Rec,xRec);
        LOCKTABLE;
        SalesHeader."No." := '';
        IF Type = Type::Item THEN
          IF SalesHeader.InventoryPickConflict("Document Type","Document No.",SalesHeader."Shipping Advice") THEN
            ERROR(Text056,SalesHeader."Shipping Advice");
        IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
          UpdateDeferralAmounts;
    end;

    trigger OnModify();
    begin
        IF ("Document Type" = "Document Type"::"Blanket Order") AND
           ((Type <> xRec.Type) OR ("No." <> xRec."No."))
        THEN BEGIN
          SalesLine2.RESET;
          SalesLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
          SalesLine2.SETRANGE("Blanket Order No.","Document No.");
          SalesLine2.SETRANGE("Blanket Order Line No.","Line No.");
          IF SalesLine2.FINDSET THEN
            REPEAT
              SalesLine2.TESTFIELD(Type,Type);
              SalesLine2.TESTFIELD("No.","No.");
            UNTIL SalesLine2.NEXT = 0;
        END;

        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") AND NOT FullReservedQtyIsForAsmToOrder THEN
          ReserveSalesLine.VerifyChange(Rec,xRec);
    end;

    trigger OnRename();
    begin
        ERROR(Text001,TABLECAPTION);
    end;

    var
        Text000 : TextConst ENU='You cannot delete the order line because it is associated with purchase order %1 line %2.',ENA='You cannot delete the order line because it is associated with purchase order %1 line %2.';
        Text001 : TextConst ENU='You cannot rename a %1.',ENA='You cannot rename a %1.';
        Text002 : TextConst ENU='You cannot change %1 because the order line is associated with purchase order %2 line %3.',ENA='You cannot change %1 because the order line is associated with purchase order %2 line %3.';
        Text003 : TextConst ENU='must not be less than %1',ENA='must not be less than %1';
        Text005 : TextConst ENU='You cannot invoice more than %1 units.',ENA='You cannot invoice more than %1 units.';
        Text006 : TextConst ENU='You cannot invoice more than %1 base units.',ENA='You cannot invoice more than %1 base units.';
        Text007 : TextConst ENU='You cannot ship more than %1 units.',ENA='You cannot ship more than %1 units.';
        Text008 : TextConst ENU='You cannot ship more than %1 base units.',ENA='You cannot ship more than %1 base units.';
        Text009 : TextConst ENU=' must be 0 when %1 is %2',ENA=' must be 0 when %1 is %2';
        Text011 : TextConst ENU='Automatic reservation is not possible.\Do you want to reserve items manually?',ENA='Automatic reservation is not possible.\Do you want to reserve items manually?';
        Text014 : TextConst ENU='%1 %2 is before work date %3',ENA='%1 %2 is before work date %3';
        Text016 : TextConst ENU='%1 is required for %2 = %3.',ENA='%1 is required for %2 = %3.';
        Text017 : TextConst ENU='\The entered information may be disregarded by warehouse operations.',ENA='\The entered information may be disregarded by warehouse operations.';
        Text020 : TextConst ENU='You cannot return more than %1 units.',ENA='You cannot return more than %1 units.';
        Text021 : TextConst ENU='You cannot return more than %1 base units.',ENA='You cannot return more than %1 base units.';
        Text026 : TextConst ENU='You cannot change %1 if the item charge has already been posted.',ENA='You cannot change %1 if the item charge has already been posted.';
        CurrExchRate : Record "Currency Exchange Rate";
        SalesHeader : Record "Sales Header";
        SalesLine2 : Record "Sales Line";
        GLAcc : Record "G/L Account";
        Item : Record Item;
        Resource : Record Resource;
        Currency : Record Currency;
        Res : Record Resource;
        ResCost : Record "Resource Cost";
        VATPostingSetup : Record "VAT Posting Setup";
        GenBusPostingGrp : Record "Gen. Business Posting Group";
        GenProdPostingGrp : Record "Gen. Product Posting Group";
        UnitOfMeasure : Record "Unit of Measure";
        NonstockItem : Record "Nonstock Item";
        SKU : Record "Stockkeeping Unit";
        ItemCharge : Record "Item Charge";
        InvtSetup : Record "Inventory Setup";
        Location : Record Location;
        ATOLink : Record "Assemble-to-Order Link";
        SalesSetup : Record "Sales & Receivables Setup";
        ApplicationAreaSetup : Record "Application Area Setup";
        TempItemTemplate : Record "Item Template" temporary;
        CalChange : Record "Customized Calendar Change";
        ConfigTemplateHeader : Record "Config. Template Header";
        PriceCalcMgt : Codeunit "Sales Price Calc. Mgt.";
        CustCheckCreditLimit : Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail : Codeunit "Item-Check Avail.";
        SalesTaxCalculate : Codeunit "Sales Tax Calculate";
        ReserveSalesLine : Codeunit "Sales Line-Reserve";
        UOMMgt : Codeunit "Unit of Measure Management";
        AddOnIntegrMgt : Codeunit AddOnIntegrManagement;
        DimMgt : Codeunit DimensionManagement;
        ItemSubstitutionMgt : Codeunit "Item Subst.";
        DistIntegration : Codeunit "Dist. Integration";
        NonstockItemMgt : Codeunit "Nonstock Item Management";
        WhseValidateSourceLine : Codeunit "Whse. Validate Source Line";
        TransferExtendedText : Codeunit "Transfer Extended Text";
        DeferralUtilities : Codeunit "Deferral Utilities";
        CalendarMgmt : Codeunit "Calendar Management";
        FullAutoReservation : Boolean;
        StatusCheckSuspended : Boolean;
        HasBeenShown : Boolean;
        PlannedShipmentDateCalculated : Boolean;
        PlannedDeliveryDateCalculated : Boolean;
        Text028 : TextConst ENU='You cannot change the %1 when the %2 has been filled in.',ENA='You cannot change the %1 when the %2 has been filled in.';
        Text029 : TextConst ENU='must be positive',ENA='must be positive';
        Text030 : TextConst ENU='must be negative',ENA='must be negative';
        Text031 : TextConst ENU='You must either specify %1 or %2.',ENA='You must either specify %1 or %2.';
        Text034 : TextConst ENU='The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.',ENA='The value of %1 field must be a whole number for the item included in the service item group if the %2 field in the Service Item Groups window contains a check mark.';
        Text035 : TextConst ENU='Warehouse ',ENA='Warehouse ';
        Text036 : TextConst ENU='Inventory ',ENA='Inventory ';
        HideValidationDialog : Boolean;
        Text037 : TextConst ENU='You cannot change %1 when %2 is %3 and %4 is positive.',ENA='You cannot change %1 when %2 is %3 and %4 is positive.';
        Text038 : TextConst ENU='You cannot change %1 when %2 is %3 and %4 is negative.',ENA='You cannot change %1 when %2 is %3 and %4 is negative.';
        Text039 : TextConst ENU='%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.',ENA='%1 units for %2 %3 have already been returned. Therefore, only %4 units can be returned.';
        Text040 : TextConst ENU='You must use form %1 to enter %2, if item tracking is used.',ENA='You must use form %1 to enter %2, if item tracking is used.';
        Text042 : TextConst ENU='When posting the Applied to Ledger Entry %1 will be opened first',ENA='When posting the Applied to Ledger Entry %1 will be opened first';
        ShippingMoreUnitsThanReceivedErr : TextConst ENU='You cannot ship more than the %1 units that you have received for document no. %2.',ENA='You cannot ship more than the %1 units that you have received for document no. %2.';
        Text044 : TextConst ENU='cannot be less than %1',ENA='cannot be less than %1';
        Text045 : TextConst ENU='cannot be more than %1',ENA='cannot be more than %1';
        Text046 : TextConst ENU='You cannot return more than the %1 units that you have shipped for %2 %3.',ENA='You cannot return more than the %1 units that you have shipped for %2 %3.';
        Text047 : TextConst ENU='must be positive when %1 is not 0.',ENA='must be positive when %1 is not 0.';
        Text048 : TextConst ENU='You cannot use item tracking on a %1 created from a %2.',ENA='You cannot use item tracking on a %1 created from a %2.';
        Text049 : TextConst ENU='cannot be %1.',ENA='cannot be %1.';
        Text051 : TextConst ENU='You cannot use %1 in a %2.',ENA='You cannot use %1 in a %2.';
        PrePaymentLineAmountEntered : Boolean;
        Text052 : TextConst ENU='You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.',ENA='You cannot add an item line because an open warehouse shipment exists for the sales header and Shipping Advice is %1.\\You must add items as new lines to the existing warehouse shipment or change Shipping Advice to Partial.';
        Text053 : TextConst ENU='You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?',ENA='You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text054 : TextConst ENU='Cancelled.',ENA='Cancelled.';
        Text055 : TextConst Comment='Quantity Invoiced must not be greater than the sum of Qty. Assigned and Qty. to Assign.',ENU='%1 must not be greater than the sum of %2 and %3.',ENA='%1 must not be greater than the sum of %2 and %3.';
        Text056 : TextConst ENU='You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.',ENA='You cannot add an item line because an open inventory pick exists for the Sales Header and because Shipping Advice is %1.\\You must first post or delete the inventory pick or change Shipping Advice to Partial.';
        Text057 : TextConst ENU='must have the same sign as the shipment',ENA='must have the same sign as the shipment';
        Text058 : TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in shipment %1.',ENA='The quantity that you are trying to invoice is greater than the quantity in shipment %1.';
        Text059 : TextConst ENU='must have the same sign as the return receipt',ENA='must have the same sign as the return receipt';
        Text060 : TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in return receipt %1.',ENA='The quantity that you are trying to invoice is greater than the quantity in return receipt %1.';
        Text1500000 : TextConst ENU='ONE',ENA='ONE';
        Text1500001 : TextConst ENU='TWO',ENA='TWO';
        Text1500002 : TextConst ENU='THREE',ENA='THREE';
        Text1500003 : TextConst ENU='FOUR',ENA='FOUR';
        Text1500004 : TextConst ENU='FIVE',ENA='FIVE';
        Text1500005 : TextConst ENU='SIX',ENA='SIX';
        Text1500006 : TextConst ENU='SEVEN',ENA='SEVEN';
        Text1500007 : TextConst ENU='EIGHT',ENA='EIGHT';
        Text1500008 : TextConst ENU='NINE',ENA='NINE';
        Text1500009 : TextConst ENU='TEN',ENA='TEN';
        Text1500010 : TextConst ENU='ELEVEN',ENA='ELEVEN';
        Text1500011 : TextConst ENU='TWELVE',ENA='TWELVE';
        Text1500012 : TextConst ENU='THIRTEEN',ENA='THIRTEEN';
        Text1500013 : TextConst ENU='FOURTEEN',ENA='FOURTEEN';
        Text1500014 : TextConst ENU='FIFTEEN',ENA='FIFTEEN';
        Text1500015 : TextConst ENU='SIXTEEN',ENA='SIXTEEN';
        Text1500016 : TextConst ENU='SEVENTEEN',ENA='SEVENTEEN';
        Text1500017 : TextConst ENU='EIGHTEEN',ENA='EIGHTEEN';
        Text1500018 : TextConst ENU='NINETEEN',ENA='NINETEEN';
        Text1500019 : TextConst ENU='TWENTY',ENA='TWENTY';
        Text1500020 : TextConst ENU='THIRTY',ENA='THIRTY';
        Text1500021 : TextConst ENU='FORTY',ENA='FORTY';
        Text1500022 : TextConst ENU='FIFTY',ENA='FIFTY';
        Text1500023 : TextConst ENU='SIXTY',ENA='SIXTY';
        Text1500024 : TextConst ENU='SEVENTY',ENA='SEVENTY';
        Text1500025 : TextConst ENU='EIGHTY',ENA='EIGHTY';
        Text1500026 : TextConst ENU='NINETY',ENA='NINETY';
        Text1500027 : TextConst ENU='THOUSAND',ENA='THOUSAND';
        Text1500028 : TextConst ENU='MILLION',ENA='MILLION';
        Text1500029 : TextConst ENU='BILLION',ENA='BILLION';
        OnesText : array [20] of Text[30];
        TensText : array [10] of Text[30];
        ExponentText : array [5] of Text[30];
        Text1500030 : TextConst ENU='NUENG',ENA='NUENG';
        Text1500031 : TextConst ENU='SAWNG',ENA='SAWNG';
        Text1500032 : TextConst ENU='SARM',ENA='SARM';
        Text1500033 : TextConst ENU='SI',ENA='SI';
        Text1500034 : TextConst ENU='HA',ENA='HA';
        Text1500035 : TextConst ENU='HOK',ENA='HOK';
        Text1500036 : TextConst ENU='CHED',ENA='CHED';
        Text1500037 : TextConst ENU='PAED',ENA='PAED';
        Text1500038 : TextConst ENU='KOW',ENA='KOW';
        Text1500039 : TextConst ENU='SIB',ENA='SIB';
        Text1500040 : TextConst ENU='SIB-ED',ENA='SIB-ED';
        Text1500041 : TextConst ENU='SIB-SAWNG',ENA='SIB-SAWNG';
        Text1500042 : TextConst ENU='SIB-SARM',ENA='SIB-SARM';
        Text1500043 : TextConst ENU='SIB-SI',ENA='SIB-SI';
        Text1500044 : TextConst ENU='SIB-HA',ENA='SIB-HA';
        Text1500045 : TextConst ENU='SIB-HOK',ENA='SIB-HOK';
        Text1500046 : TextConst ENU='SIB-CHED',ENA='SIB-CHED';
        Text1500047 : TextConst ENU='SIB-PAED',ENA='SIB-PAED';
        Text1500048 : TextConst ENU='SIB-KOW',ENA='SIB-KOW';
        Text1500049 : TextConst ENU='YI-SIB',ENA='YI-SIB';
        Text1500050 : TextConst ENU='SARM-SIB',ENA='SARM-SIB';
        Text1500051 : TextConst ENU='SI-SIB',ENA='SI-SIB';
        Text1500052 : TextConst ENU='HA-SIB',ENA='HA-SIB';
        Text1500053 : TextConst ENU='HOK-SIB',ENA='HOK-SIB';
        Text1500054 : TextConst ENU='CHED-SIB',ENA='CHED-SIB';
        Text1500055 : TextConst ENU='PAED-SIB',ENA='PAED-SIB';
        Text1500056 : TextConst ENU='KOW-SIB',ENA='KOW-SIB';
        Text1500057 : TextConst ENU='PHAN',ENA='PHAN';
        Text1500058 : TextConst ENU='LAAN?',ENA='LAAN?';
        Text1500059 : TextConst ENU='PHAN-LAAN?',ENA='PHAN-LAAN?';
        Text1500060 : TextConst ENU='HUNDRED',ENA='HUNDRED';
        Text1500061 : TextConst ENU='ZERO',ENA='ZERO';
        Text1500062 : TextConst ENU='AND',ENA='AND';
        VATBase : Decimal;
        VATAmt : Decimal;
        GLSetup : Record "General Ledger Setup";
        GLSetupRead : Boolean;
        AnotherItemWithSameDescrQst : TextConst Comment='%1=Item no., %2=item description',ENU='We found an item with the description "%2" (No. %1).\Did you mean to change the current item to %1?',ENA='We found an item with the description "%2" (No. %1).\Did you mean to change the current item to %1?';
        SalesLineCompletelyShippedErr : TextConst ENU='You cannot change the purchasing code for a sales line that has been completely shipped.',ENA='You cannot change the purchasing code for a sales line that has been completely shipped.';
        SalesSetupRead : Boolean;
        LookupRequested : Boolean;
        DeferralPostDate : Date;
        ItemNoFieldCaptionTxt : TextConst ENU='Item',ENA='Item';
        FreightLineDescriptionTxt : TextConst ENU='Freight Amount',ENA='Freight Amount';

    procedure InitOutstanding();
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          "Outstanding Quantity" := Quantity - "Return Qty. Received";
          "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Received (Base)";
          "Return Qty. Rcd. Not Invd." := "Return Qty. Received" - "Quantity Invoiced";
          "Ret. Qty. Rcd. Not Invd.(Base)" := "Return Qty. Received (Base)" - "Qty. Invoiced (Base)";
        END ELSE BEGIN
          "Outstanding Quantity" := Quantity - "Quantity Shipped";
          "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
          "Qty. Shipped Not Invoiced" := "Quantity Shipped" - "Quantity Invoiced";
          "Qty. Shipped Not Invd. (Base)" := "Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
        END;
        UpdatePlanned;
        "Completely Shipped" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
        InitOutstandingAmount;
    end;

    procedure InitOutstandingAmount();
    var
        AmountInclVAT : Decimal;
    begin
        IF Quantity = 0 THEN BEGIN
          "Outstanding Amount" := 0;
          "Outstanding Amount (LCY)" := 0;
          "Shipped Not Invoiced" := 0;
          "Shipped Not Invoiced (LCY)" := 0;
          "Return Rcd. Not Invd." := 0;
          "Return Rcd. Not Invd. (LCY)" := 0;
        END ELSE BEGIN
          GetSalesHeader;
          AmountInclVAT := "Amount Including VAT";
          VALIDATE(
            "Outstanding Amount",
            ROUND(
              AmountInclVAT * "Outstanding Quantity" / Quantity,
              Currency."Amount Rounding Precision"));
          IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
            VALIDATE(
              "Return Rcd. Not Invd.",
              ROUND(
                AmountInclVAT * "Return Qty. Rcd. Not Invd." / Quantity,
                Currency."Amount Rounding Precision"))
          ELSE
            VALIDATE(
              "Shipped Not Invoiced",
              ROUND(
                AmountInclVAT * "Qty. Shipped Not Invoiced" / Quantity,
                Currency."Amount Rounding Precision"));
        END;
    end;

    procedure InitQtyToShip();
    begin
        GetSalesSetup;
        IF (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) OR
           ("Document Type" = "Document Type"::Invoice)
        THEN BEGIN
          "Qty. to Ship" := "Outstanding Quantity";
          "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
        END ELSE
          IF "Qty. to Ship" <> 0 THEN
            "Qty. to Ship (Base)" := CalcBaseQty("Qty. to Ship");

        CheckServItemCreation;

        InitQtyToInvoice;
    end;

    procedure InitQtyToReceive();
    begin
        GetSalesSetup;
        IF (SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Remainder) OR
           ("Document Type" = "Document Type"::"Credit Memo")
        THEN BEGIN
          "Return Qty. to Receive" := "Outstanding Quantity";
          "Return Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
        END ELSE
          IF "Return Qty. to Receive" <> 0 THEN
            "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");

        InitQtyToInvoice;
    end;

    procedure InitQtyToInvoice();
    begin
        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;
        CalcInvDiscToInvoice;
        IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN
          CalcPrepaymentToDeduct;
    end;

    local procedure InitItemAppl(OnlyApplTo : Boolean);
    begin
        "Appl.-to Item Entry" := 0;
        IF NOT OnlyApplTo THEN
          "Appl.-from Item Entry" := 0;
    end;

    procedure MaxQtyToInvoice() : Decimal;
    begin
        IF "Prepayment Line" THEN
          EXIT(1);
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT("Return Qty. Received" + "Return Qty. to Receive" - "Quantity Invoiced");

        EXIT("Quantity Shipped" + "Qty. to Ship" - "Quantity Invoiced");
    end;

    procedure MaxQtyToInvoiceBase() : Decimal;
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT("Return Qty. Received (Base)" + "Return Qty. to Receive (Base)" - "Qty. Invoiced (Base)");

        EXIT("Qty. Shipped (Base)" + "Qty. to Ship (Base)" - "Qty. Invoiced (Base)");
    end;

    local procedure CalcBaseQty(Qty : Decimal) : Decimal;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    local procedure SelectItemEntry(CurrentFieldNo : Integer);
    var
        ItemLedgEntry : Record "Item Ledger Entry";
        SalesLine3 : Record "Sales Line";
    begin
        ItemLedgEntry.SETRANGE("Item No.","No.");
        IF "Location Code" <> '' THEN
          ItemLedgEntry.SETRANGE("Location Code","Location Code");
        ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

        IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
          ItemLedgEntry.SETRANGE(Positive,TRUE);
          ItemLedgEntry.SETRANGE(Open,TRUE);
        END ELSE BEGIN
          ItemLedgEntry.SETCURRENTKEY("Item No.",Positive);
          ItemLedgEntry.SETRANGE(Positive,FALSE);
          ItemLedgEntry.SETFILTER("Shipped Qty. Not Returned",'<0');
        END;
        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN BEGIN
          SalesLine3 := Rec;
          IF CurrentFieldNo = FIELDNO("Appl.-to Item Entry") THEN
            SalesLine3.VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.")
          ELSE
            SalesLine3.VALIDATE("Appl.-from Item Entry",ItemLedgEntry."Entry No.");
          CheckItemAvailable(CurrentFieldNo);
          Rec := SalesLine3;
        END;
    end;

    procedure SetSalesHeader(NewSalesHeader : Record "Sales Header");
    begin
        SalesHeader := NewSalesHeader;

        IF SalesHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          SalesHeader.TESTFIELD("Currency Factor");
          Currency.GET(SalesHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    local procedure GetSalesHeader();
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> SalesHeader."Document Type") OR ("Document No." <> SalesHeader."No.") THEN BEGIN
          SalesHeader.GET("Document Type","Document No.");
          IF SalesHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            SalesHeader.TESTFIELD("Currency Factor");
            Currency.GET(SalesHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
    end;

    local procedure GetItem();
    begin
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
    end;

    local procedure GetResource();
    begin
        TESTFIELD("No.");
        IF "No." <> Resource."No." THEN
          Resource.GET("No.");
    end;

    local procedure UpdateUnitPrice(CalledByFieldNo : Integer);
    begin
        IF (CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0) THEN
          EXIT;

        GetSalesHeader;
        TESTFIELD("Qty. per Unit of Measure");

        CASE Type OF
          Type::Item,Type::Resource:
            BEGIN
              PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
              PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,CalledByFieldNo);
            END;
        END;
        VALIDATE("Unit Price");
    end;

    local procedure FindResUnitCost();
    begin
        ResCost.INIT;
        ResCost.Code := "No.";
        ResCost."Work Type Code" := "Work Type Code";
        CODEUNIT.RUN(CODEUNIT::"Resource-Find Cost",ResCost);
        VALIDATE("Unit Cost (LCY)",ResCost."Unit Cost" * "Qty. per Unit of Measure");
    end;

    procedure UpdatePrepmtSetupFields();
    var
        GenPostingSetup : Record "General Posting Setup";
        GLAcc : Record "G/L Account";
    begin
        IF ("Prepayment %" <> 0) AND (Type <> Type::" ") THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          TESTFIELD("No.");
          IF CurrFieldNo = FIELDNO("Prepayment %") THEN
            IF "System-Created Entry" THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,0));
          IF "System-Created Entry" THEN
            "Prepayment %" := 0;
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
          IF GenPostingSetup."Sales Prepayments Account" <> '' THEN BEGIN
            GLAcc.GET(GenPostingSetup."Sales Prepayments Account");
            GetGLSetup;
            IF GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
              GLAcc.TESTFIELD("VAT Prod. Posting Group","VAT Prod. Posting Group");
            VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            VATPostingSetup.TESTFIELD("VAT Calculation Type","VAT Calculation Type");
          END ELSE
            CLEAR(VATPostingSetup);
          "Prepayment VAT %" := VATPostingSetup."VAT %";
          "Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
          "Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
          IF "Prepmt. VAT Calc. Type" IN
             ["Prepmt. VAT Calc. Type"::"Reverse Charge VAT","Prepmt. VAT Calc. Type"::"Sales Tax"]
          THEN
            "Prepayment VAT %" := 0;
          "Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        END;
    end;

    procedure UpdateAmounts();
    var
        RemLineAmountToInvoice : Decimal;
        VATBaseAmount : Decimal;
        LineAmountChanged : Boolean;
    begin
        IF CurrFieldNo <> FIELDNO("Allow Invoice Disc.") THEN
          TESTFIELD(Type);
        GetSalesHeader;
        VATBaseAmount := "VAT Base Amount";
        "Recalculate Invoice Disc." := TRUE;

        IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
        END;
        IF "Line Amount" <> ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
          "Line Amount" := ROUND(Quantity * "Unit Price",Currency."Amount Rounding Precision") - "Line Discount Amount";
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
        END;
        UpdateVATAmounts;
        IF NOT "Prepayment Line" THEN BEGIN
          IF "Prepayment %" <> 0 THEN BEGIN
            IF Quantity < 0 THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
            IF "Unit Price" < 0 THEN
              FIELDERROR("Unit Price",STRSUBSTNO(Text047,FIELDCAPTION("Prepayment %")));
          END;
          IF SalesHeader."Document Type" <> SalesHeader."Document Type"::Invoice THEN BEGIN
            "Prepayment VAT Difference" := 0;
            IF NOT PrePaymentLineAmountEntered THEN
              IF NOT CalculateFullGST("Prepmt. Line Amount") THEN
                "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
            IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text049,"Prepmt. Amt. Inv."));
            PrePaymentLineAmountEntered := FALSE;
            IF "Prepmt. Line Amount" <> 0 THEN BEGIN
              RemLineAmountToInvoice :=
                ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
              IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
                FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text045,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
            END;
          END ELSE
            IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
               ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
            THEN BEGIN
              IF "Line Amount" < xRec."Line Amount" THEN
                FIELDERROR("Line Amount",STRSUBSTNO(Text044,xRec."Line Amount"));
              FIELDERROR("Line Amount",STRSUBSTNO(Text045,xRec."Line Amount"));
            END;
        END;
        InitOutstandingAmount;
        IF (CurrFieldNo <> 0) AND
           NOT ((Type = Type::Item) AND (CurrFieldNo = FIELDNO("No.")) AND (Quantity <> 0) AND
                // a write transaction may have been started
                ("Qty. per Unit of Measure" <> xRec."Qty. per Unit of Measure")) AND // ...continued condition
           ("Document Type" <= "Document Type"::Invoice) AND
           (("Outstanding Amount" + "Shipped Not Invoiced") > 0) AND
           (CurrFieldNo <> FIELDNO("Blanket Order No."))
        THEN
          CustCheckCreditLimit.SalesLineCheck(Rec);

        IF Type = Type::"Charge (Item)" THEN
          UpdateItemChargeAssgnt;

        CalcPrepaymentToDeduct;
        IF VATBaseAmount <> "VAT Base Amount" THEN
          LineAmountChanged := TRUE;

        IF LineAmountChanged THEN BEGIN
          UpdateDeferralAmounts;
          LineAmountChanged := FALSE;
        END;
    end;

    local procedure UpdateVATAmounts();
    var
        SalesLine2 : Record "Sales Line";
        TotalLineAmount : Decimal;
        TotalInvDiscAmount : Decimal;
        TotalAmount : Decimal;
        TotalAmountInclVAT : Decimal;
        TotalQuantityBase : Decimal;
    begin
        GetSalesHeader;
        SalesLine2.SETRANGE("Document Type","Document Type");
        SalesLine2.SETRANGE("Document No.","Document No.");
        SalesLine2.SETFILTER("Line No.",'<>%1',"Line No.");
        IF "Line Amount" = 0 THEN
          IF xRec."Line Amount" >= 0 THEN
            SalesLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            SalesLine2.SETFILTER(Amount,'<%1',0)
        ELSE
          IF "Line Amount" > 0 THEN
            SalesLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            SalesLine2.SETFILTER(Amount,'<%1',0);
        SalesLine2.SETRANGE("VAT Identifier","VAT Identifier");
        SalesLine2.SETRANGE("Tax Group Code","Tax Group Code");

        IF "Line Amount" = "Inv. Discount Amount" THEN BEGIN
          Amount := 0;
          "VAT Base Amount" := 0;
          "Amount Including VAT" := 0;
        END ELSE BEGIN
          TotalLineAmount := 0;
          TotalInvDiscAmount := 0;
          TotalAmount := 0;
          TotalAmountInclVAT := 0;
          TotalQuantityBase := 0;
          IF ("VAT Calculation Type" = "VAT Calculation Type"::"Sales Tax") OR
             (("VAT Calculation Type" IN
               ["VAT Calculation Type"::"Normal VAT","VAT Calculation Type"::"Reverse Charge VAT"]) AND ("VAT %" <> 0))
          THEN
            IF NOT SalesLine2.ISEMPTY THEN BEGIN
              SalesLine2.CALCSUMS("Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT","Quantity (Base)");
              TotalLineAmount := SalesLine2."Line Amount";
              TotalInvDiscAmount := SalesLine2."Inv. Discount Amount";
              TotalAmount := SalesLine2.Amount;
              TotalAmountInclVAT := SalesLine2."Amount Including VAT";
              TotalQuantityBase := SalesLine2."Quantity (Base)";
            END;

          IF SalesHeader."Prices Including VAT" THEN
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  Amount :=
                    ROUND(
                      (TotalLineAmount - TotalInvDiscAmount + "Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                      Currency."Amount Rounding Precision") -
                    TotalAmount;
                  "VAT Base Amount" :=
                    ROUND(
                      Amount * (1 - SalesHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalLineAmount + "Line Amount" -
                    ROUND(
                      (TotalAmount + Amount) * (SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT - TotalInvDiscAmount - "Inv. Discount Amount";
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  SalesHeader.TESTFIELD("VAT Base Discount %",0);
                  Amount :=
                    SalesTaxCalculate.ReverseCalculateTax(
                      "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                      TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                      SalesHeader."Currency Factor") -
                    TotalAmount;
                  IF Amount <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - Amount) / Amount,0.00001)
                  ELSE
                    "VAT %" := 0;
                  Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                END;
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" :=
                    ROUND(Amount * (1 - SalesHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      (TotalAmount + Amount) * (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                END;
              "VAT Calculation Type"::"Full VAT":
                BEGIN
                  Amount := 0;
                  "VAT Base Amount" := 0;
                  "Amount Including VAT" := "Line Amount" - "Inv. Discount Amount";
                END;
              "VAT Calculation Type"::"Sales Tax":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" := Amount;
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      SalesTaxCalculate.CalculateTax(
                        "Tax Area Code","Tax Group Code","Tax Liable",SalesHeader."Posting Date",
                        TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                        SalesHeader."Currency Factor"),Currency."Amount Rounding Precision") -
                    TotalAmountInclVAT;
                  IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                  ELSE
                    "VAT %" := 0;
                END;
            END;
        END;
    end;

    local procedure CheckItemAvailable(CalledByFieldNo : Integer);
    begin
        IF Reserve = Reserve::Always THEN
          EXIT;

        IF "Shipment Date" = 0D THEN BEGIN
          GetSalesHeader;
          IF SalesHeader."Shipment Date" <> 0D THEN
            VALIDATE("Shipment Date",SalesHeader."Shipment Date")
          ELSE
            VALIDATE("Shipment Date",WORKDATE);
        END;

        IF ((CalledByFieldNo = CurrFieldNo) OR (CalledByFieldNo = FIELDNO("Shipment Date"))) AND GUIALLOWED AND
           ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
           (Type = Type::Item) AND ("No." <> '') AND
           ("Outstanding Quantity" > 0) AND
           ("Job Contract Entry No." = 0) AND
           NOT (Nonstock OR "Special Order")
        THEN BEGIN
          IF ItemCheckAvail.SalesLineCheck(Rec) THEN
            ItemCheckAvail.RaiseUpdateInterruptedError;
        END;
    end;

    procedure ShowReservation();
    var
        Reservation : Page Reservation;
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD(Reserve);
        CLEAR(Reservation);
        Reservation.SetSalesLine(Rec);
        Reservation.RUNMODAL;
        UpdatePlanned;
    end;

    procedure ShowReservationEntries(Modal : Boolean);
    var
        ReservEntry : Record "Reservation Entry";
        ReservEngineMgt : Codeunit "Reservation Engine Mgt.";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        ReserveSalesLine.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    procedure AutoReserve();
    var
        ReservMgt : Codeunit "Reservation Management";
        QtyToReserve : Decimal;
        QtyToReserveBase : Decimal;
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");

        ReserveSalesLine.ReservQuantity(Rec,QtyToReserve,QtyToReserveBase);
        IF QtyToReserveBase <> 0 THEN BEGIN
          ReservMgt.SetSalesLine(Rec);
          TESTFIELD("Shipment Date");
          ReservMgt.AutoReserve(FullAutoReservation,'',"Shipment Date",QtyToReserve,QtyToReserveBase);
          FIND;
          IF NOT FullAutoReservation THEN BEGIN
            COMMIT;
            IF CONFIRM(Text011,TRUE) THEN BEGIN
              ShowReservation;
              FIND;
            END;
          END;
        END;
    end;

    procedure AutoAsmToOrder();
    begin
        ATOLink.UpdateAsmFromSalesLine(Rec);
    end;

    local procedure GetDate() : Date;
    begin
        IF SalesHeader."Posting Date" <> 0D THEN
          EXIT(SalesHeader."Posting Date");
        EXIT(WORKDATE);
    end;

    procedure CalcPlannedDeliveryDate(CurrFieldNo : Integer) : Date;
    begin
        IF "Shipment Date" = 0D THEN
          EXIT("Planned Delivery Date");

        CASE CurrFieldNo OF
          FIELDNO("Shipment Date"):
            EXIT(CalendarMgmt.CalcDateBOC(
                FORMAT("Shipping Time"),
                "Planned Shipment Date",
                CalChange."Source Type"::"Shipping Agent",
                "Shipping Agent Code",
                "Shipping Agent Service Code",
                CalChange."Source Type"::Customer,
                "Sell-to Customer No.",
                '',
                TRUE));
          FIELDNO("Planned Delivery Date"):
            EXIT(CalendarMgmt.CalcDateBOC2(
                FORMAT("Shipping Time"),
                "Planned Delivery Date",
                CalChange."Source Type"::Customer,
                "Sell-to Customer No.",
                '',
                CalChange."Source Type"::"Shipping Agent",
                "Shipping Agent Code",
                "Shipping Agent Service Code",
                TRUE))
        END;
    end;

    procedure CalcPlannedShptDate(CurrFieldNo : Integer) : Date;
    begin
        IF "Shipment Date" = 0D THEN
          EXIT("Planned Shipment Date");

        CASE CurrFieldNo OF
          FIELDNO("Shipment Date"):
            EXIT(CalendarMgmt.CalcDateBOC(
                FORMAT("Outbound Whse. Handling Time"),
                "Shipment Date",
                CalChange."Source Type"::Location,
                "Location Code",
                '',
                CalChange."Source Type"::"Shipping Agent",
                "Shipping Agent Code",
                "Shipping Agent Service Code",
                TRUE));
          FIELDNO("Planned Delivery Date"):
            EXIT(CalendarMgmt.CalcDateBOC(
                FORMAT(''),
                "Planned Delivery Date",
                CalChange."Source Type"::Customer,
                "Sell-to Customer No.",
                '',
                CalChange."Source Type"::"Shipping Agent",
                "Shipping Agent Code",
                "Shipping Agent Service Code",
                TRUE));
        END;
    end;

    procedure CalcShipmentDate() : Date;
    begin
        IF "Planned Shipment Date" = 0D THEN
          EXIT("Shipment Date");

        IF FORMAT("Outbound Whse. Handling Time") <> '' THEN
          EXIT(
            CalendarMgmt.CalcDateBOC2(
              FORMAT("Outbound Whse. Handling Time"),
              "Planned Shipment Date",
              CalChange."Source Type"::Location,
              "Location Code",
              '',
              CalChange."Source Type"::"Shipping Agent",
              "Shipping Agent Code",
              "Shipping Agent Service Code",
              FALSE));

        EXIT(
          CalendarMgmt.CalcDateBOC(
            FORMAT(FORMAT('')),
            "Planned Shipment Date",
            CalChange."Source Type"::"Shipping Agent",
            "Shipping Agent Code",
            "Shipping Agent Service Code",
            CalChange."Source Type"::Location,
            "Location Code",
            '',
            FALSE));
    end;

    procedure SignedXX(Value : Decimal) : Decimal;
    begin
        CASE "Document Type" OF
          "Document Type"::Quote,
          "Document Type"::Order,
          "Document Type"::Invoice,
          "Document Type"::"Blanket Order":
            EXIT(-Value);
          "Document Type"::"Return Order",
          "Document Type"::"Credit Memo":
            EXIT(Value);
        END;
    end;

    local procedure BlanketOrderLookup();
    begin
        SalesLine2.RESET;
        SalesLine2.SETCURRENTKEY("Document Type",Type,"No.");
        SalesLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
        SalesLine2.SETRANGE(Type,Type);
        SalesLine2.SETRANGE("No.","No.");
        SalesLine2.SETRANGE("Bill-to Customer No.","Bill-to Customer No.");
        SalesLine2.SETRANGE("Sell-to Customer No.","Sell-to Customer No.");
        IF PAGE.RUNMODAL(PAGE::"Sales Lines",SalesLine2) = ACTION::LookupOK THEN BEGIN
          SalesLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
          "Blanket Order No." := SalesLine2."Document No.";
          VALIDATE("Blanket Order Line No.",SalesLine2."Line No.");
        END;
    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
        VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;

    procedure OpenItemTrackingLines();
    var
        Job : Record Job;
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        TESTFIELD("Quantity (Base)");
        IF "Job Contract Entry No." <> 0 THEN
          ERROR(Text048,TABLECAPTION,Job.TABLECAPTION);
        ReserveSalesLine.CallItemTracking(Rec);
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20];Type2 : Integer;No2 : Code[20];Type3 : Integer;No3 : Code[20]);
    var
        SourceCodeSetup : Record "Source Code Setup";
        TableID : array [10] of Integer;
        No : array [10] of Code[20];
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetSalesHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Sales,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID",DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        ATOLink.UpdateAsmDimFromSalesLine(Rec);
    end;

    procedure ValidateShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        VerifyItemLineDim;
    end;

    procedure LookupShortcutDimCode(FieldNumber : Integer;var ShortcutDimCode : Code[20]);
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode : array [8] of Code[20]);
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    procedure ShowItemSub();
    begin
        CLEAR(SalesHeader);
        TestStatusOpen;
        ItemSubstitutionMgt.ItemSubstGet(Rec);
        IF TransferExtendedText.SalesCheckIfAnyExtText(Rec,TRUE) THEN
          TransferExtendedText.InsertSalesExtText(Rec);
    end;

    procedure ShowNonstock();
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.",'');
        IF PAGE.RUNMODAL(PAGE::"Nonstock Item List",NonstockItem) = ACTION::LookupOK THEN BEGIN
          NonstockItem.TESTFIELD("Item Template Code");
          ConfigTemplateHeader.SETRANGE(Code,NonstockItem."Item Template Code");
          ConfigTemplateHeader.FINDFIRST;
          TempItemTemplate.InitializeTempRecordFromConfigTemplate(TempItemTemplate,ConfigTemplateHeader);
          TempItemTemplate.TESTFIELD("Gen. Prod. Posting Group");
          TempItemTemplate.TESTFIELD("Inventory Posting Group");

          "No." := NonstockItem."Entry No.";
          NonstockItemMgt.NonStockSales(Rec);
          VALIDATE("No.","No.");
          VALIDATE("Unit Price",NonstockItem."Unit Price");
        END;
    end;

    local procedure GetSalesSetup();
    begin
        IF NOT SalesSetupRead THEN
          SalesSetup.GET;
        SalesSetupRead := TRUE;
    end;

    local procedure GetFAPostingGroup();
    var
        LocalGLAcc : Record "G/L Account";
        FASetup : Record "FA Setup";
        FAPostingGr : Record "FA Posting Group";
        FADeprBook : Record "FA Depreciation Book";
    begin
        IF (Type <> Type::"Fixed Asset") OR ("No." = '') THEN
          EXIT;
        IF "Depreciation Book Code" = '' THEN BEGIN
          FASetup.GET;
          "Depreciation Book Code" := FASetup."Default Depr. Book";
          IF NOT FADeprBook.GET("No.","Depreciation Book Code") THEN
            "Depreciation Book Code" := '';
          IF "Depreciation Book Code" = '' THEN
            EXIT;
        END;
        FADeprBook.GET("No.","Depreciation Book Code");
        FADeprBook.TESTFIELD("FA Posting Group");
        FAPostingGr.GET(FADeprBook."FA Posting Group");
        FAPostingGr.TESTFIELD("Acq. Cost Acc. on Disposal");
        LocalGLAcc.GET(FAPostingGr."Acq. Cost Acc. on Disposal");
        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        VALIDATE("VAT Prod. Posting Group",LocalGLAcc."VAT Prod. Posting Group");
    end;

    local procedure GetFieldCaption(FieldNumber : Integer) : Text[100];
    var
        "Field" : Record "Field";
    begin
        Field.GET(DATABASE::"Sales Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber : Integer) : Text[80];
    var
        SalesHeader2 : Record "Sales Header";
    begin
        IF SalesHeader2.GET("Document Type","Document No.") THEN;
        CASE FieldNumber OF
          FIELDNO("No."):
            BEGIN
              IF ApplicationAreaSetup.IsFoundationEnabled THEN
                EXIT(STRSUBSTNO('3,%1',ItemNoFieldCaptionTxt));
              EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
            END;
          ELSE BEGIN
            IF SalesHeader2."Prices Including VAT" THEN
              EXIT('2,1,' + GetFieldCaption(FieldNumber));
            EXIT('2,0,' + GetFieldCaption(FieldNumber));
          END;
        END;
    end;

    local procedure GetSKU() : Boolean;
    begin
        IF (SKU."Location Code" = "Location Code") AND
           (SKU."Item No." = "No.") AND
           (SKU."Variant Code" = "Variant Code")
        THEN
          EXIT(TRUE);
        IF SKU.GET("Location Code","No.","Variant Code") THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure GetUnitCost();
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        GetItem;
        "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
        IF GetSKU THEN
          VALIDATE("Unit Cost (LCY)",SKU."Unit Cost" * "Qty. per Unit of Measure")
        ELSE
          VALIDATE("Unit Cost (LCY)",Item."Unit Cost" * "Qty. per Unit of Measure");
    end;

    local procedure CalcUnitCost(ItemLedgEntry : Record "Item Ledger Entry") : Decimal;
    var
        ValueEntry : Record "Value Entry";
        UnitCost : Decimal;
    begin
        WITH ValueEntry DO BEGIN
          SETCURRENTKEY("Item Ledger Entry No.");
          SETRANGE("Item Ledger Entry No.",ItemLedgEntry."Entry No.");
          IF IsServiceItem THEN BEGIN
            CALCSUMS("Cost Amount (Non-Invtbl.)");
            UnitCost := "Cost Amount (Non-Invtbl.)" / ItemLedgEntry.Quantity;
          END ELSE BEGIN
            CALCSUMS("Cost Amount (Actual)","Cost Amount (Expected)");
            UnitCost :=
              ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
          END;
        END;

        EXIT(ABS(UnitCost * "Qty. per Unit of Measure"));
    end;

    procedure ShowItemChargeAssgnt();
    var
        ItemChargeAssgntSales : Record "Item Charge Assignment (Sales)";
        AssignItemChargeSales : Codeunit "Item Charge Assgnt. (Sales)";
        ItemChargeAssgnts : Page "Item Charge Assignment (Sales)";
        ItemChargeAssgntLineAmt : Decimal;
    begin
        GET("Document Type","Document No.","Line No.");
        TESTFIELD(Type,Type::"Charge (Item)");
        TESTFIELD("No.");
        TESTFIELD(Quantity);

        GetSalesHeader;
        IF SalesHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(SalesHeader."Currency Code");
        IF ("Inv. Discount Amount" = 0) AND
           ("Line Discount Amount" = 0) AND
           (NOT SalesHeader."Prices Including VAT")
        THEN
          ItemChargeAssgntLineAmt := "Line Amount"
        ELSE
          IF SalesHeader."Prices Including VAT" THEN
            ItemChargeAssgntLineAmt :=
              ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                Currency."Amount Rounding Precision")
          ELSE
            ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
        ItemChargeAssgntSales.SETRANGE("Item Charge No.","No.");
        IF NOT ItemChargeAssgntSales.FINDLAST THEN BEGIN
          ItemChargeAssgntSales."Document Type" := "Document Type";
          ItemChargeAssgntSales."Document No." := "Document No.";
          ItemChargeAssgntSales."Document Line No." := "Line No.";
          ItemChargeAssgntSales."Item Charge No." := "No.";
          ItemChargeAssgntSales."Unit Cost" :=
            ROUND(ItemChargeAssgntLineAmt / Quantity,
              Currency."Unit-Amount Rounding Precision");
        END;

        ItemChargeAssgntLineAmt :=
          ROUND(
            ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
            Currency."Amount Rounding Precision");

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Return Receipt No.")
        ELSE
          AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales,"Shipment No.");
        CLEAR(AssignItemChargeSales);
        COMMIT;

        ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
        ItemChargeAssgnts.RUNMODAL;
        CALCFIELDS("Qty. to Assign");
    end;

    procedure UpdateItemChargeAssgnt();
    var
        ItemChargeAssgntSales : Record "Item Charge Assignment (Sales)";
        ShareOfVAT : Decimal;
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
    begin
        IF "Document Type" = "Document Type"::"Blanket Order" THEN
          EXIT;

        CALCFIELDS("Qty. Assigned","Qty. to Assign");
        IF ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) THEN
          ERROR(Text055,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntSales.SETRANGE("Document Line No.","Line No.");
        ItemChargeAssgntSales.CALCSUMS("Qty. to Assign");
        TotalQtyToAssign := ItemChargeAssgntSales."Qty. to Assign";
        IF (CurrFieldNo <> 0) AND (Amount <> xRec.Amount) AND
           NOT ((Quantity <> xRec.Quantity) AND (TotalQtyToAssign = 0))
        THEN BEGIN
          ItemChargeAssgntSales.SETFILTER("Qty. Assigned",'<>0');
          IF NOT ItemChargeAssgntSales.ISEMPTY THEN
            ERROR(Text026,
              FIELDCAPTION(Amount));
          ItemChargeAssgntSales.SETRANGE("Qty. Assigned");
        END;

        IF ItemChargeAssgntSales.FINDSET THEN BEGIN
          GetSalesHeader;
          TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
          REPEAT
            ShareOfVAT := 1;
            IF SalesHeader."Prices Including VAT" THEN
              ShareOfVAT := 1 + "VAT %" / 100;
            IF Quantity <> 0 THEN
              IF ItemChargeAssgntSales."Unit Cost" <> ROUND(
                   ("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                   Currency."Unit-Amount Rounding Precision")
              THEN
                ItemChargeAssgntSales."Unit Cost" :=
                  ROUND(("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                    Currency."Unit-Amount Rounding Precision");
            IF TotalQtyToAssign <> 0 THEN BEGIN
              ItemChargeAssgntSales."Amount to Assign" :=
                ROUND(ItemChargeAssgntSales."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                  Currency."Amount Rounding Precision");
              TotalQtyToAssign -= ItemChargeAssgntSales."Qty. to Assign";
              TotalAmtToAssign -= ItemChargeAssgntSales."Amount to Assign";
            END;
            ItemChargeAssgntSales.MODIFY;
          UNTIL ItemChargeAssgntSales.NEXT = 0;
          CALCFIELDS("Qty. to Assign");
        END;
    end;

    local procedure DeleteItemChargeAssgnt(DocType : Option;DocNo : Code[20];DocLineNo : Integer);
    var
        ItemChargeAssgntSales : Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type",DocType);
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.",DocNo);
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
        IF NOT ItemChargeAssgntSales.ISEMPTY THEN
          ItemChargeAssgntSales.DELETEALL(TRUE);
    end;

    local procedure DeleteChargeChargeAssgnt(DocType : Option;DocNo : Code[20];DocLineNo : Integer);
    var
        ItemChargeAssgntSales : Record "Item Charge Assignment (Sales)";
    begin
        IF DocType <> "Document Type"::"Blanket Order" THEN
          IF "Quantity Invoiced" <> 0 THEN BEGIN
            CALCFIELDS("Qty. Assigned");
            TESTFIELD("Qty. Assigned","Quantity Invoiced");
          END;

        ItemChargeAssgntSales.RESET;
        ItemChargeAssgntSales.SETRANGE("Document Type",DocType);
        ItemChargeAssgntSales.SETRANGE("Document No.",DocNo);
        ItemChargeAssgntSales.SETRANGE("Document Line No.",DocLineNo);
        IF NOT ItemChargeAssgntSales.ISEMPTY THEN
          ItemChargeAssgntSales.DELETEALL;
    end;

    local procedure CheckItemChargeAssgnt();
    var
        ItemChargeAssgntSales : Record "Item Charge Assignment (Sales)";
    begin
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. No.","Document No.");
        ItemChargeAssgntSales.SETRANGE("Applies-to Doc. Line No.","Line No.");
        ItemChargeAssgntSales.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntSales.SETRANGE("Document No.","Document No.");
        IF ItemChargeAssgntSales.FINDSET THEN BEGIN
          TESTFIELD("Allow Item Charge Assignment");
          REPEAT
            ItemChargeAssgntSales.TESTFIELD("Qty. to Assign",0);
          UNTIL ItemChargeAssgntSales.NEXT = 0;
        END;
    end;

    local procedure TestStatusOpen();
    begin
        IF StatusCheckSuspended THEN
          EXIT;
        GetSalesHeader;
        IF NOT "System-Created Entry" THEN
          IF Type <> Type::" " THEN
            SalesHeader.TESTFIELD(Status,SalesHeader.Status::Open);
    end;

    procedure SuspendStatusCheck(Suspend : Boolean);
    begin
        StatusCheckSuspended := Suspend;
    end;

    procedure UpdateVATOnLines(QtyType : Option General,Invoicing,Shipping;var SalesHeader : Record "Sales Header";var SalesLine : Record "Sales Line";var VATAmountLine : Record "VAT Amount Line") LineWasModified : Boolean;
    var
        TempVATAmountLineRemainder : Record "VAT Amount Line" temporary;
        Currency : Record Currency;
        NewAmount : Decimal;
        NewAmountIncludingVAT : Decimal;
        NewVATBaseAmount : Decimal;
        VATAmount : Decimal;
        VATDifference : Decimal;
        InvDiscAmount : Decimal;
        LineAmountToInvoice : Decimal;
        FullGST : Boolean;
        LineAmountToInvoiceDiscounted : Decimal;
        DeferralAmount : Decimal;
    begin
        GetGLSetup;
        LineWasModified := FALSE;
        IF QtyType = QtyType::Shipping THEN
          EXIT;
        IF SalesHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(SalesHeader."Currency Code");

        TempVATAmountLineRemainder.DELETEALL;

        WITH SalesLine DO BEGIN
          SETRANGE("Document Type",SalesHeader."Document Type");
          SETRANGE("Document No.",SalesHeader."No.");
          LOCKTABLE;
          IF FINDSET THEN
            REPEAT
              IF NOT ZeroAmountLine(QtyType) THEN BEGIN
                FullGST :=
                  ("Prepayment Line" OR ("Prepmt. Line Amount" <> 0)) AND
                  GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
                DeferralAmount := GetDeferralAmount;
                VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0,FullGST);
                IF VATAmountLine.Modified THEN BEGIN
                  IF NOT TempVATAmountLineRemainder.GET(
                       "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0,FullGST)
                  THEN BEGIN
                    TempVATAmountLineRemainder := VATAmountLine;
                    TempVATAmountLineRemainder.INIT;
                    TempVATAmountLineRemainder.INSERT;
                  END;

                  IF QtyType = QtyType::General THEN
                    LineAmountToInvoice := "Line Amount"
                  ELSE
                    LineAmountToInvoice :=
                      ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");

                  IF "Allow Invoice Disc." THEN BEGIN
                    IF (VATAmountLine."Inv. Disc. Base Amount" = 0) OR (LineAmountToInvoice = 0) THEN
                      InvDiscAmount := 0
                    ELSE BEGIN
                      LineAmountToInvoiceDiscounted :=
                        VATAmountLine."Invoice Discount Amount" * LineAmountToInvoice /
                        VATAmountLine."Inv. Disc. Base Amount";
                      TempVATAmountLineRemainder."Invoice Discount Amount" :=
                        TempVATAmountLineRemainder."Invoice Discount Amount" + LineAmountToInvoiceDiscounted;
                      InvDiscAmount :=
                        ROUND(
                          TempVATAmountLineRemainder."Invoice Discount Amount",Currency."Amount Rounding Precision");
                      TempVATAmountLineRemainder."Invoice Discount Amount" :=
                        TempVATAmountLineRemainder."Invoice Discount Amount" - InvDiscAmount;
                    END;
                    IF QtyType = QtyType::General THEN BEGIN
                      "Inv. Discount Amount" := InvDiscAmount;
                      CalcInvDiscToInvoice;
                      IF "Inv. Disc. Amount to Invoice" <> 0 THEN
                        IF FullGST THEN
                          UpdateAmounts;
                    END ELSE
                      "Inv. Disc. Amount to Invoice" := InvDiscAmount;
                  END ELSE
                    InvDiscAmount := 0;

                  IF QtyType = QtyType::General THEN
                    IF SalesHeader."Prices Including VAT" THEN BEGIN
                      IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount" = 0) OR
                         ("Line Amount" = 0)
                      THEN BEGIN
                        VATAmount := 0;
                        NewAmountIncludingVAT := 0;
                      END ELSE BEGIN
                        VATAmount :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          VATAmountLine."VAT Amount" *
                          ("Line Amount" - "Inv. Discount Amount") /
                          (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                        NewAmountIncludingVAT :=
                          TempVATAmountLineRemainder."Amount Including VAT" +
                          VATAmountLine."Amount Including VAT" *
                          ("Line Amount" - "Inv. Discount Amount") /
                          (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                      END;
                      NewAmount :=
                        ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                        ROUND(VATAmount,Currency."Amount Rounding Precision");
                      NewVATBaseAmount :=
                        ROUND(
                          NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                    END ELSE BEGIN
                      IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                        VATAmount := "Line Amount" - "Inv. Discount Amount";
                        NewAmount := 0;
                        NewVATBaseAmount := 0;
                      END ELSE BEGIN
                        NewAmount := "Line Amount" - "Inv. Discount Amount";
                        NewVATBaseAmount :=
                          ROUND(
                            NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision");
                        IF VATAmountLine."VAT Base" = 0 THEN
                          VATAmount := 0
                        ELSE
                          VATAmount :=
                            TempVATAmountLineRemainder."VAT Amount" +
                            VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                      END;
                      NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                    END
                  ELSE BEGIN
                    IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 THEN
                      VATDifference := 0
                    ELSE
                      VATDifference :=
                        TempVATAmountLineRemainder."VAT Difference" +
                        VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                    IF LineAmountToInvoice = 0 THEN
                      "VAT Difference" := 0
                    ELSE
                      "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                  END;
                  IF QtyType = QtyType::General THEN BEGIN
                    Amount := NewAmount;
                    "Amount Including VAT" := ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                    "VAT Base Amount" := NewVATBaseAmount;
                  END;
                  InitOutstanding;
                  IF Type = Type::"Charge (Item)" THEN
                    UpdateItemChargeAssgnt;
                  MODIFY;
                  LineWasModified := TRUE;

                  IF ("Deferral Code" <> '') AND (DeferralAmount <> GetDeferralAmount) THEN
                    UpdateDeferralAmounts;

                  TempVATAmountLineRemainder."Amount Including VAT" :=
                    NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                  TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                  TempVATAmountLineRemainder."VAT Difference" := VATDifference - "VAT Difference";
                  TempVATAmountLineRemainder.MODIFY;
                END;
              END;
            UNTIL NEXT = 0;
        END;
    end;

    procedure CalcVATAmountLines(QtyType : Option General,Invoicing,Shipping;var SalesHeader : Record "Sales Header";var SalesLine : Record "Sales Line";var VATAmountLine : Record "VAT Amount Line");
    var
        PrevVatAmountLine : Record "VAT Amount Line";
        Currency : Record Currency;
        SalesTaxCalculate : Codeunit "Sales Tax Calculate";
        TotalVATAmount : Decimal;
        QtyToHandle : Decimal;
        AmtToHandle : Decimal;
        RoundingLineInserted : Boolean;
        TotalVATBase : Decimal;
        FullGST : Boolean;
    begin
        GetGLSetup;
        Currency.Initialize(SalesHeader."Currency Code");

        VATAmountLine.DELETEALL;

        WITH SalesLine DO BEGIN
          SETRANGE("Document Type",SalesHeader."Document Type");
          SETRANGE("Document No.",SalesHeader."No.");
          IF FINDSET THEN
            REPEAT
              IF NOT ZeroAmountLine(QtyType) THEN BEGIN
                IF (Type = Type::"G/L Account") AND NOT "Prepayment Line" THEN
                  RoundingLineInserted := ("No." = GetCPGInvRoundAcc(SalesHeader)) OR RoundingLineInserted;
                IF "VAT Calculation Type" IN
                   ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
                THEN
                  "VAT %" := 0;
                FullGST :=
                  ("Prepayment Line" OR ("Prepmt. Line Amount" <> 0)) AND
                  GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
                IF NOT VATAmountLine.GET(
                     "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"Line Amount" >= 0,FullGST)
                THEN
                  VATAmountLine.InsertNewLine(
                    "VAT Identifier","VAT Calculation Type","Tax Group Code",FALSE,"VAT %","Line Amount" >= 0,FALSE,FullGST);

                CASE QtyType OF
                  QtyType::General:
                    BEGIN
                      VATAmountLine.Quantity += "Quantity (Base)";
                      VATAmountLine.SumLine(
                        "Line Amount","Inv. Discount Amount","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                    END;
                  QtyType::Invoicing:
                    BEGIN
                      CASE TRUE OF
                        ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
                        (NOT SalesHeader.Ship) AND SalesHeader.Invoice AND (NOT "Prepayment Line"):
                          IF "Shipment No." = '' THEN BEGIN
                            QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Shipped Not Invoiced");
                            VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Shipped Not Invd. (Base)");
                          END ELSE BEGIN
                            QtyToHandle := "Qty. to Invoice";
                            VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                          END;
                        ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                        (NOT SalesHeader.Receive) AND SalesHeader.Invoice:
                          IF "Return Receipt No." = '' THEN BEGIN
                            QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Rcd. Not Invd.");
                            VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Rcd. Not Invd.(Base)");
                          END ELSE BEGIN
                            QtyToHandle := "Qty. to Invoice";
                            VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                          END;
                        ELSE
                          BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      END;
                      AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                      IF SalesHeader."Invoice Discount Calculation" <> SalesHeader."Invoice Discount Calculation"::Amount THEN
                        VATAmountLine.SumLine(
                          AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                          "VAT Difference","Allow Invoice Disc.","Prepayment Line")
                      ELSE
                        VATAmountLine.SumLine(
                          AmtToHandle,"Inv. Disc. Amount to Invoice","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                    END;
                  QtyType::Shipping:
                    BEGIN
                      IF "Document Type" IN
                         ["Document Type"::"Return Order","Document Type"::"Credit Memo"]
                      THEN BEGIN
                        QtyToHandle := "Return Qty. to Receive";
                        VATAmountLine.Quantity += "Return Qty. to Receive (Base)";
                      END ELSE BEGIN
                        QtyToHandle := "Qty. to Ship";
                        VATAmountLine.Quantity += "Qty. to Ship (Base)";
                      END;
                      AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                      VATAmountLine.SumLine(
                        AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        "VAT Difference","Allow Invoice Disc.","Prepayment Line");
                    END;
                END;
                TotalVATAmount += "Amount Including VAT" - Amount;
                TotalVATBase += Amount;
              END;
            UNTIL NEXT = 0;
        END;

        WITH VATAmountLine DO
          IF FINDSET THEN
            REPEAT
              IF (PrevVatAmountLine."VAT Identifier" <> "VAT Identifier") OR
                 (PrevVatAmountLine."VAT Calculation Type" <> "VAT Calculation Type") OR
                 (PrevVatAmountLine."Tax Group Code" <> "Tax Group Code") OR
                 (PrevVatAmountLine."Use Tax" <> "Use Tax")
              THEN
                PrevVatAmountLine.INIT;
              IF SalesHeader."Prices Including VAT" THEN BEGIN
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      IF "Full GST on Prepayment" AND "Includes Prepayment" THEN  BEGIN
                        "VAT Amount" := "VAT Difference" +
                          ROUND(
                            PrevVatAmountLine."VAT Amount" +
                            "VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        "Amount Including VAT" := "Line Amount";
                      END ELSE BEGIN
                        "VAT Base" :=
                          ROUND(
                            ("Line Amount" - "Invoice Discount Amount") / (1 + "VAT %" / 100),
                            Currency."Amount Rounding Precision") - "VAT Difference";
                        "VAT Amount" :=
                          "VAT Difference" +
                          ROUND(
                            PrevVatAmountLine."VAT Amount" +
                            ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                            (1 - SalesHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        "Amount Including VAT" := "VAT Base" + "VAT Amount";
                      END;
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        PrevVatAmountLine := VATAmountLine;
                        PrevVatAmountLine."VAT Amount" :=
                          ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                          (1 - SalesHeader."VAT Base Discount %" / 100);
                        PrevVatAmountLine."VAT Amount" :=
                          PrevVatAmountLine."VAT Amount" -
                          ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        IF "Full GST on Prepayment" THEN
                          CalcFullGSTValues(VATAmountLine,SalesLine,SalesHeader."Prices Including VAT");
                      END;
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      "VAT Base" := 0;
                      "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                      "Amount Including VAT" := "VAT Amount";
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Base" :=
                        ROUND(
                          SalesTaxCalculate.ReverseCalculateTax(
                            SalesHeader."Tax Area Code","Tax Group Code",SalesHeader."Tax Liable",
                            SalesHeader."Posting Date","Amount Including VAT",Quantity,SalesHeader."Currency Factor"),
                          Currency."Amount Rounding Precision");
                      "VAT Amount" := "VAT Difference" + "Amount Including VAT" - "VAT Base";
                      IF "VAT Base" = 0 THEN
                        "VAT %" := 0
                      ELSE
                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                    END;
                END;
              END ELSE
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      IF NOT ("Full GST on Prepayment" AND "Includes Prepayment") THEN
                        "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Amount" :=
                        "VAT Difference" +
                        ROUND(
                          PrevVatAmountLine."VAT Amount" +
                          "VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "VAT Base" :=
                        ROUND(
                          "VAT Base" * (1 - SalesHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        IF NOT "Includes Prepayment" THEN BEGIN
                          PrevVatAmountLine := VATAmountLine;
                          PrevVatAmountLine."VAT Amount" :=
                            "VAT Base" * "VAT %" / 100 * (1 - SalesHeader."VAT Base Discount %" / 100);
                          PrevVatAmountLine."VAT Amount" :=
                            PrevVatAmountLine."VAT Amount" -
                            ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        END;
                        IF "Full GST on Prepayment" THEN
                          CalcFullGSTValues(VATAmountLine,SalesLine,SalesHeader."Prices Including VAT");
                      END;
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      "VAT Base" := 0;
                      "VAT Amount" := "VAT Difference" + "Line Amount" - "Invoice Discount Amount";
                      "Amount Including VAT" := "VAT Amount";
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      "VAT Base" := "Line Amount" - "Invoice Discount Amount";
                      "VAT Amount" :=
                        SalesTaxCalculate.CalculateTax(
                          SalesHeader."Tax Area Code","Tax Group Code",SalesHeader."Tax Liable",
                          SalesHeader."Posting Date","VAT Base",Quantity,SalesHeader."Currency Factor");
                      IF "VAT Base" = 0 THEN
                        "VAT %" := 0
                      ELSE
                        "VAT %" := ROUND(100 * "VAT Amount" / "VAT Base",0.00001);
                      "VAT Amount" :=
                        "VAT Difference" +
                        ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "VAT Base" + "VAT Amount";
                    END;
                END;

              IF RoundingLineInserted THEN BEGIN
                TotalVATAmount := TotalVATAmount - "VAT Amount";
                TotalVATBase := TotalVATBase - "VAT Base";
              END;
              "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
              MODIFY;
            UNTIL NEXT = 0;

        IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
          IF VATAmountLine.GET(SalesLine."VAT Identifier",SalesLine."VAT Calculation Type",
               SalesLine."Tax Group Code",FALSE,SalesLine."Line Amount" >= 0)
          THEN BEGIN
            VATAmountLine."VAT Amount" += TotalVATAmount;
            VATAmountLine."VAT Base" += TotalVATBase;
            VATAmountLine."Amount Including VAT" += TotalVATAmount;
            VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
            VATAmountLine.MODIFY;
          END;
    end;

    procedure GetCPGInvRoundAcc(var SalesHeader : Record "Sales Header") : Code[20];
    var
        Cust : Record Customer;
        CustTemplate : Record "Customer Template";
        CustPostingGroup : Record "Customer Posting Group";
    begin
        GetSalesSetup;
        IF SalesSetup."Invoice Rounding" THEN
          IF Cust.GET(SalesHeader."Bill-to Customer No.") THEN
            CustPostingGroup.GET(Cust."Customer Posting Group")
          ELSE
            IF CustTemplate.GET(SalesHeader."Sell-to Customer Template Code") THEN
              CustPostingGroup.GET(CustTemplate."Customer Posting Group");

        EXIT(CustPostingGroup."Invoice Rounding Account");
    end;

    local procedure CalcInvDiscToInvoice();
    var
        OldInvDiscAmtToInv : Decimal;
    begin
        GetSalesHeader;
        OldInvDiscAmtToInv := "Inv. Disc. Amount to Invoice";
        IF Quantity = 0 THEN
          VALIDATE("Inv. Disc. Amount to Invoice",0)
        ELSE
          VALIDATE(
            "Inv. Disc. Amount to Invoice",
            ROUND(
              "Inv. Discount Amount" * "Qty. to Invoice" / Quantity,
              Currency."Amount Rounding Precision"));

        IF OldInvDiscAmtToInv <> "Inv. Disc. Amount to Invoice" THEN BEGIN
          "Amount Including VAT" := "Amount Including VAT" - "VAT Difference";
          "VAT Difference" := 0;
        END;
    end;

    procedure UpdateWithWarehouseShip();
    begin
        IF Type = Type::Item THEN
          CASE TRUE OF
            ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity >= 0):
              IF Location.RequireShipment("Location Code") THEN
                VALIDATE("Qty. to Ship",0)
              ELSE
                VALIDATE("Qty. to Ship","Outstanding Quantity");
            ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity < 0):
              IF Location.RequireReceive("Location Code") THEN
                VALIDATE("Qty. to Ship",0)
              ELSE
                VALIDATE("Qty. to Ship","Outstanding Quantity");
            ("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0):
              IF Location.RequireReceive("Location Code") THEN
                VALIDATE("Return Qty. to Receive",0)
              ELSE
                VALIDATE("Return Qty. to Receive","Outstanding Quantity");
            ("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0):
              IF Location.RequireShipment("Location Code") THEN
                VALIDATE("Return Qty. to Receive",0)
              ELSE
                VALIDATE("Return Qty. to Receive","Outstanding Quantity");
          END;
        SetDefaultQuantity;
    end;

    local procedure CheckWarehouse();
    var
        Location2 : Record Location;
        WhseSetup : Record "Warehouse Setup";
        ShowDialog : Option " ",Message,Error;
        DialogText : Text[50];
    begin
        GetLocation("Location Code");
        IF "Location Code" = '' THEN BEGIN
          WhseSetup.GET;
          Location2."Require Shipment" := WhseSetup."Require Shipment";
          Location2."Require Pick" := WhseSetup."Require Pick";
          Location2."Require Receive" := WhseSetup."Require Receive";
          Location2."Require Put-away" := WhseSetup."Require Put-away";
        END ELSE
          Location2 := Location;

        DialogText := Text035;
        IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
           Location2."Directed Put-away and Pick"
        THEN BEGIN
          ShowDialog := ShowDialog::Error;
          IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0)) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0))
          THEN
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
          ELSE
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"));
        END ELSE BEGIN
          IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0) AND
              (Location2."Require Shipment" OR Location2."Require Pick")) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0) AND
              (Location2."Require Shipment" OR Location2."Require Pick"))
          THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(
                 DATABASE::"Sales Line",
                 "Document Type",
                 "Document No.",
                 "Line No.",
                 0,
                 Quantity)
            THEN
              ShowDialog := ShowDialog::Error
            ELSE
              IF Location2."Require Shipment" THEN
                ShowDialog := ShowDialog::Message;
            IF Location2."Require Shipment" THEN
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"))
            ELSE BEGIN
              DialogText := Text036;
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
            END;
          END;

          IF (("Document Type" = "Document Type"::Order) AND (Quantity < 0) AND
              (Location2."Require Receive" OR Location2."Require Put-away")) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0) AND
              (Location2."Require Receive" OR Location2."Require Put-away"))
          THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(
                 DATABASE::"Sales Line",
                 "Document Type",
                 "Document No.",
                 "Line No.",
                 0,
                 Quantity)
            THEN
              ShowDialog := ShowDialog::Error
            ELSE
              IF Location2."Require Receive" THEN
                ShowDialog := ShowDialog::Message;
            IF Location2."Require Receive" THEN
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
            ELSE BEGIN
              DialogText := Text036;
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
            END;
          END;
        END;

        CASE ShowDialog OF
          ShowDialog::Message:
            MESSAGE(Text016 + Text017,DialogText,FIELDCAPTION("Line No."),"Line No.");
          ShowDialog::Error:
            ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
        END;

        HandleDedicatedBin(TRUE);
    end;

    local procedure UpdateDates();
    begin
        IF CurrFieldNo = 0 THEN BEGIN
          PlannedShipmentDateCalculated := FALSE;
          PlannedDeliveryDateCalculated := FALSE;
        END;
        IF "Promised Delivery Date" <> 0D THEN
          VALIDATE("Promised Delivery Date")
        ELSE
          IF "Requested Delivery Date" <> 0D THEN
            VALIDATE("Requested Delivery Date")
          ELSE
            VALIDATE("Shipment Date");
    end;

    procedure GetItemTranslation();
    var
        ItemTranslation : Record "Item Translation";
    begin
        GetSalesHeader;
        IF ItemTranslation.GET("No.","Variant Code",SalesHeader."Language Code") THEN BEGIN
          Description := ItemTranslation.Description;
          "Description 2" := ItemTranslation."Description 2";
        END;
    end;

    local procedure GetLocation(LocationCode : Code[10]);
    begin
        IF LocationCode = '' THEN
          CLEAR(Location)
        ELSE
          IF Location.Code <> LocationCode THEN
            Location.GET(LocationCode);
    end;

    procedure PriceExists() : Boolean;
    begin
        IF "Document No." <> '' THEN BEGIN
          GetSalesHeader;
          EXIT(PriceCalcMgt.SalesLinePriceExists(SalesHeader,Rec,TRUE));
        END;
        EXIT(FALSE);
    end;

    procedure LineDiscExists() : Boolean;
    begin
        IF "Document No." <> '' THEN BEGIN
          GetSalesHeader;
          EXIT(PriceCalcMgt.SalesLineLineDiscExists(SalesHeader,Rec,TRUE));
        END;
        EXIT(FALSE);
    end;

    procedure RowID1() : Text[250];
    var
        ItemTrackingMgt : Codeunit "Item Tracking Management";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Line","Document Type",
            "Document No.",'',0,"Line No."));
    end;

    local procedure UpdateItemCrossRef();
    begin
        DistIntegration.EnterSalesItemCrossRef(Rec);
        UpdateICPartner;
    end;

    local procedure GetDefaultBin();
    var
        WMSManagement : Codeunit "WMS Management";
    begin
        IF Type <> Type::Item THEN
          EXIT;

        "Bin Code" := '';
        IF "Drop Shipment" THEN
          EXIT;

        IF ("Location Code" <> '') AND ("No." <> '') THEN BEGIN
          GetLocation("Location Code");
          IF Location."Bin Mandatory" AND NOT Location."Directed Put-away and Pick" THEN BEGIN
            IF ("Qty. to Assemble to Order" > 0) OR IsAsmToOrderRequired THEN
              IF GetATOBin(Location,"Bin Code") THEN
                EXIT;

            WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
            HandleDedicatedBin(FALSE);
          END;
        END;
    end;

    procedure GetATOBin(Location : Record Location;var BinCode : Code[20]) : Boolean;
    var
        AsmHeader : Record "Assembly Header";
    begin
        IF NOT Location."Require Shipment" THEN
          BinCode := Location."Asm.-to-Order Shpt. Bin Code";
        IF BinCode <> '' THEN
          EXIT(TRUE);

        IF AsmHeader.GetFromAssemblyBin(Location,BinCode) THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure IsInbound() : Boolean;
    begin
        CASE "Document Type" OF
          "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
            EXIT("Quantity (Base)" < 0);
          "Document Type"::"Return Order","Document Type"::"Credit Memo":
            EXIT("Quantity (Base)" > 0);
        END;

        EXIT(FALSE);
    end;

    local procedure HandleDedicatedBin(IssueWarning : Boolean);
    var
        WhseIntegrationMgt : Codeunit "Whse. Integration Management";
    begin
        IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
          WhseIntegrationMgt.CheckIfBinDedicatedOnSrcDoc("Location Code","Bin Code",IssueWarning);
    end;

    local procedure CheckAssocPurchOrder(TheFieldCaption : Text[250]);
    begin
        IF TheFieldCaption = '' THEN BEGIN // If sales line is being deleted
          IF "Purch. Order Line No." <> 0 THEN
            ERROR(
              Text000,
              "Purchase Order No.",
              "Purch. Order Line No.");
          IF "Special Order Purch. Line No." <> 0 THEN
            ERROR(
              Text000,
              "Special Order Purchase No.",
              "Special Order Purch. Line No.");
        END;
        IF "Purch. Order Line No." <> 0 THEN
          ERROR(
            Text002,
            TheFieldCaption,
            "Purchase Order No.",
            "Purch. Order Line No.");
        IF "Special Order Purch. Line No." <> 0 THEN
          ERROR(
            Text002,
            TheFieldCaption,
            "Special Order Purchase No.",
            "Special Order Purch. Line No.");
    end;

    procedure CrossReferenceNoLookUp();
    var
        ItemCrossReference : Record "Item Cross Reference";
        ICGLAcc : Record "IC G/L Account";
    begin
        CASE Type OF
          Type::Item:
            BEGIN
              GetSalesHeader;
              ItemCrossReference.RESET;
              ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
              ItemCrossReference.SETFILTER(
                "Cross-Reference Type",'%1|%2',
                ItemCrossReference."Cross-Reference Type"::Customer,
                ItemCrossReference."Cross-Reference Type"::" ");
              ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',SalesHeader."Sell-to Customer No.",'');
              IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN BEGIN
                VALIDATE("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
                PriceCalcMgt.FindSalesLineLineDisc(SalesHeader,Rec);
                PriceCalcMgt.FindSalesLinePrice(SalesHeader,Rec,FIELDNO("Cross-Reference No."));
                VALIDATE("Unit Price");
              END;
            END;
          Type::"G/L Account",Type::Resource:
            BEGIN
              GetSalesHeader;
              SalesHeader.TESTFIELD("Sell-to IC Partner Code");
              IF PAGE.RUNMODAL(PAGE::"IC G/L Account List",ICGLAcc) = ACTION::LookupOK THEN
                "Cross-Reference No." := ICGLAcc."No.";
            END;
        END;
    end;

    local procedure CheckServItemCreation();
    var
        ServItemGroup : Record "Service Item Group";
    begin
        IF CurrFieldNo = 0 THEN
          EXIT;
        IF Type <> Type::Item THEN
          EXIT;
        Item.GET("No.");
        IF Item."Service Item Group" = '' THEN
          EXIT;
        IF ServItemGroup.GET(Item."Service Item Group") THEN
          IF ServItemGroup."Create Service Item" THEN
            IF "Qty. to Ship (Base)" <> ROUND("Qty. to Ship (Base)",1) THEN
              ERROR(
                Text034,
                FIELDCAPTION("Qty. to Ship (Base)"),
                ServItemGroup.FIELDCAPTION("Create Service Item"));
    end;

    procedure ItemExists(ItemNo : Code[20]) : Boolean;
    var
        Item2 : Record Item;
    begin
        IF Type = Type::Item THEN
          IF NOT Item2.GET(ItemNo) THEN
            EXIT(FALSE);
        EXIT(TRUE);
    end;

    procedure IsShipment() : Boolean;
    begin
        EXIT(SignedXX("Quantity (Base)") < 0);
    end;

    local procedure GetAbsMin(QtyToHandle : Decimal;QtyHandled : Decimal) : Decimal;
    begin
        IF ABS(QtyHandled) < ABS(QtyToHandle) THEN
          EXIT(QtyHandled);

        EXIT(QtyToHandle);
    end;

    procedure SetHideValidationDialog(NewHideValidationDialog : Boolean);
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry : Record "Item Ledger Entry");
    var
        ItemTrackingLines : Page "Item Tracking Lines";
        QtyNotReturned : Decimal;
        QtyReturned : Decimal;
    begin
        IF "Appl.-from Item Entry" = 0 THEN
          EXIT;

        IF "Shipment No." <> '' THEN
          EXIT;

        TESTFIELD(Type,Type::Item);
        TESTFIELD(Quantity);
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,Text029);
        END ELSE BEGIN
          IF Quantity > 0 THEN
            FIELDERROR(Quantity,Text030);
        END;

        ItemLedgEntry.GET("Appl.-from Item Entry");
        ItemLedgEntry.TESTFIELD(Positive,FALSE);
        ItemLedgEntry.TESTFIELD("Item No.","No.");
        ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");
        IF ItemLedgEntry.TrackingExists THEN
          ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-from Item Entry"));

        IF ABS("Quantity (Base)") > -ItemLedgEntry.Quantity THEN
          ERROR(
            Text046,
            -ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.");

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          IF ABS("Outstanding Qty. (Base)") > -ItemLedgEntry."Shipped Qty. Not Returned" THEN BEGIN
            QtyNotReturned := ItemLedgEntry."Shipped Qty. Not Returned";
            QtyReturned := ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned";
            IF "Qty. per Unit of Measure" <> 0 THEN BEGIN
              QtyNotReturned :=
                ROUND(ItemLedgEntry."Shipped Qty. Not Returned" / "Qty. per Unit of Measure",0.00001);
              QtyReturned :=
                ROUND(
                  (ItemLedgEntry.Quantity - ItemLedgEntry."Shipped Qty. Not Returned") /
                  "Qty. per Unit of Measure",0.00001);
            END;
            ERROR(
              Text039,
              -QtyReturned,ItemLedgEntry.FIELDCAPTION("Document No."),
              ItemLedgEntry."Document No.",-QtyNotReturned);
          END;
    end;

    procedure CalcPrepaymentToDeduct();
    begin
        IF ("Qty. to Invoice" <> 0) AND ("Prepmt. Amt. Inv." <> 0) THEN BEGIN
          GetSalesHeader;
          IF ("Prepayment %" = 100) AND NOT IsFinalInvoice THEN
            "Prepmt Amt to Deduct" := GetLineAmountToHandle("Qty. to Invoice")
          ELSE
            "Prepmt Amt to Deduct" :=
              ROUND(
                ("Prepmt. Amt. Inv." - "Prepmt Amt Deducted") *
                "Qty. to Invoice" / (Quantity - "Quantity Invoiced"),Currency."Amount Rounding Precision")
        END ELSE
          "Prepmt Amt to Deduct" := 0
    end;

    procedure IsFinalInvoice() : Boolean;
    begin
        EXIT("Qty. to Invoice" = Quantity - "Quantity Invoiced");
    end;

    procedure GetLineAmountToHandle(QtyToHandle : Decimal) : Decimal;
    var
        LineAmount : Decimal;
        LineDiscAmount : Decimal;
    begin
        IF "Line Discount %" = 100 THEN
          EXIT(0);

        GetSalesHeader;
        LineAmount := ROUND(QtyToHandle * "Unit Price",Currency."Amount Rounding Precision");
        LineDiscAmount := ROUND("Line Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision");
        EXIT(LineAmount - LineDiscAmount);
    end;

    procedure SetHasBeenShown();
    begin
        HasBeenShown := TRUE;
    end;

    local procedure TestJobPlanningLine();
    var
        JobPostLine : Codeunit "Job Post-Line";
    begin
        IF "Job Contract Entry No." = 0 THEN
          EXIT;

        JobPostLine.TestSalesLine(Rec);
    end;

    procedure BlockDynamicTracking(SetBlock : Boolean);
    begin
        ReserveSalesLine.Block(SetBlock);
    end;

    procedure InitQtyToShip2();
    begin
        "Qty. to Ship" := "Outstanding Quantity";
        "Qty. to Ship (Base)" := "Outstanding Qty. (Base)";

        ATOLink.UpdateQtyToAsmFromSalesLine(Rec);

        CheckServItemCreation;

        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;

        CalcInvDiscToInvoice;

        CalcPrepaymentToDeduct;
    end;

    procedure ShowLineComments();
    var
        SalesCommentLine : Record "Sales Comment Line";
        SalesCommentSheet : Page "Sales Comment Sheet";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        SalesCommentLine.SETRANGE("Document Type","Document Type");
        SalesCommentLine.SETRANGE("No.","Document No.");
        SalesCommentLine.SETRANGE("Document Line No.","Line No.");
        SalesCommentSheet.SETTABLEVIEW(SalesCommentLine);
        SalesCommentSheet.RUNMODAL;
    end;

    procedure SetDefaultQuantity();
    begin
        GetSalesSetup;
        IF SalesSetup."Default Quantity to Ship" = SalesSetup."Default Quantity to Ship"::Blank THEN BEGIN
          IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) THEN BEGIN
            "Qty. to Ship" := 0;
            "Qty. to Ship (Base)" := 0;
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          END;
          IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
            "Return Qty. to Receive" := 0;
            "Return Qty. to Receive (Base)" := 0;
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          END;
        END;
    end;

    local procedure SetReserveWithoutPurchasingCode();
    begin
        GetItem;
        IF Item.Reserve = Item.Reserve::Optional THEN BEGIN
          GetSalesHeader;
          Reserve := SalesHeader.Reserve;
        END ELSE
          Reserve := Item.Reserve;
    end;

    local procedure SetDefaultItemQuantity();
    begin
        GetSalesSetup;
        IF SalesSetup."Default Item Quantity" THEN BEGIN
          VALIDATE(Quantity,1);
          CheckItemAvailable(CurrFieldNo);
        END;
    end;

    procedure UpdatePrePaymentAmounts();
    var
        ShipmentLine : Record "Sales Shipment Line";
        SalesOrderLine : Record "Sales Line";
        SalesOrderHeader : Record "Sales Header";
    begin
        IF ("Document Type" <> "Document Type"::Invoice) OR ("Prepayment %" = 0) THEN
          EXIT;

        IF NOT ShipmentLine.GET("Shipment No.","Shipment Line No.") THEN BEGIN
          "Prepmt Amt to Deduct" := 0;
          "Prepmt VAT Diff. to Deduct" := 0;
        END ELSE BEGIN
          IF SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,ShipmentLine."Order No.",ShipmentLine."Order Line No.") THEN BEGIN
            IF ("Prepayment %" = 100) AND (Quantity <> SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced") THEN
              "Prepmt Amt to Deduct" := "Line Amount"
            ELSE
              "Prepmt Amt to Deduct" :=
                ROUND((SalesOrderLine."Prepmt. Amt. Inv." - SalesOrderLine."Prepmt Amt Deducted") *
                  Quantity / (SalesOrderLine.Quantity - SalesOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
            "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
            SalesOrderHeader.GET(SalesOrderHeader."Document Type"::Order,SalesOrderLine."Document No.");
          END ELSE BEGIN
            "Prepmt Amt to Deduct" := 0;
            "Prepmt VAT Diff. to Deduct" := 0;
          END;
        END;

        GetSalesHeader;
        SalesHeader.TESTFIELD("Prices Including VAT",SalesOrderHeader."Prices Including VAT");
        IF SalesHeader."Prices Including VAT" THEN BEGIN
          "Prepmt. Amt. Incl. VAT" := "Prepmt Amt to Deduct";
          "Prepayment Amount" :=
            ROUND(
              "Prepmt Amt to Deduct" / (1 + ("Prepayment VAT %" / 100)),
              Currency."Amount Rounding Precision");
        END ELSE BEGIN
          "Prepmt. Amt. Incl. VAT" :=
            ROUND(
              "Prepmt Amt to Deduct" * (1 + ("Prepayment VAT %" / 100)),
              Currency."Amount Rounding Precision");
          "Prepayment Amount" := "Prepmt Amt to Deduct";
        END;
        "Prepmt. Line Amount" := "Prepmt Amt to Deduct";
        "Prepmt. Amt. Inv." := "Prepmt. Line Amount";
        "Prepmt. VAT Base Amt." := "Prepayment Amount";
        "Prepmt. Amount Inv. Incl. VAT" := "Prepmt. Amt. Incl. VAT";
        "Prepmt Amt Deducted" := 0;
    end;

    procedure ZeroAmountLine(QtyType : Option General,Invoicing,Shipping) : Boolean;
    begin
        IF Type = Type::" " THEN
          EXIT(TRUE);
        IF Quantity = 0 THEN
          EXIT(TRUE);
        IF "Unit Price" = 0 THEN
          EXIT(TRUE);
        IF QtyType = QtyType::Invoicing THEN
          IF "Qty. to Invoice" = 0 THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure FilterLinesWithItemToPlan(var Item : Record Item;DocumentType : Option);
    begin
        RESET;
        SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date");
        SETRANGE("Document Type",DocumentType);
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",Item."No.");
        SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
        SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
        SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
        SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
        SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
        SETFILTER("Shipment Date",Item.GETFILTER("Date Filter"));
        SETFILTER("Outstanding Qty. (Base)",'<>0');
    end;

    procedure FindLinesWithItemToPlan(var Item : Record Item;DocumentType : Option) : Boolean;
    begin
        FilterLinesWithItemToPlan(Item,DocumentType);
        EXIT(FIND('-'));
    end;

    procedure LinesWithItemToPlanExist(var Item : Record Item;DocumentType : Option) : Boolean;
    begin
        FilterLinesWithItemToPlan(Item,DocumentType);
        EXIT(NOT ISEMPTY);
    end;

    local procedure DateFormularZero(var DateFormularValue : DateFormula;CalledByFieldNo : Integer;CalledByFieldCaption : Text[250]);
    var
        DateFormularZero : DateFormula;
    begin
        EVALUATE(DateFormularZero,'<0D>');
        IF (DateFormularValue <> DateFormularZero) AND (CalledByFieldNo = CurrFieldNo) THEN
          ERROR(Text051,CalledByFieldCaption,FIELDCAPTION("Drop Shipment"));
        EVALUATE(DateFormularValue,'<0D>');
    end;

    local procedure InitQtyToAsm();
    begin
        IF NOT IsAsmToOrderAllowed THEN BEGIN
          "Qty. to Assemble to Order" := 0;
          "Qty. to Asm. to Order (Base)" := 0;
          EXIT;
        END;

        IF ((xRec."Qty. to Asm. to Order (Base)" = 0) AND IsAsmToOrderRequired AND ("Qty. Shipped (Base)" = 0)) OR
           ((xRec."Qty. to Asm. to Order (Base)" <> 0) AND
            (xRec."Qty. to Asm. to Order (Base)" = xRec."Quantity (Base)")) OR
           ("Qty. to Asm. to Order (Base)" > "Quantity (Base)")
        THEN BEGIN
          "Qty. to Assemble to Order" := Quantity;
          "Qty. to Asm. to Order (Base)" := "Quantity (Base)";
        END;
    end;

    procedure AsmToOrderExists(var AsmHeader : Record "Assembly Header") : Boolean;
    var
        ATOLink : Record "Assemble-to-Order Link";
    begin
        IF NOT ATOLink.AsmExistsForSalesLine(Rec) THEN
          EXIT(FALSE);
        EXIT(AsmHeader.GET(ATOLink."Assembly Document Type",ATOLink."Assembly Document No."));
    end;

    procedure FullQtyIsForAsmToOrder() : Boolean;
    begin
        IF "Qty. to Asm. to Order (Base)" = 0 THEN
          EXIT(FALSE);
        EXIT("Quantity (Base)" = "Qty. to Asm. to Order (Base)");
    end;

    local procedure FullReservedQtyIsForAsmToOrder() : Boolean;
    begin
        IF "Qty. to Asm. to Order (Base)" = 0 THEN
          EXIT(FALSE);
        CALCFIELDS("Reserved Qty. (Base)");
        EXIT("Reserved Qty. (Base)" = "Qty. to Asm. to Order (Base)");
    end;

    procedure QtyBaseOnATO() : Decimal;
    var
        AsmHeader : Record "Assembly Header";
    begin
        IF AsmToOrderExists(AsmHeader) THEN
          EXIT(AsmHeader."Quantity (Base)");
        EXIT(0);
    end;

    procedure QtyAsmRemainingBaseOnATO() : Decimal;
    var
        AsmHeader : Record "Assembly Header";
    begin
        IF AsmToOrderExists(AsmHeader) THEN
          EXIT(AsmHeader."Remaining Quantity (Base)");
        EXIT(0);
    end;

    procedure QtyToAsmBaseOnATO() : Decimal;
    var
        AsmHeader : Record "Assembly Header";
    begin
        IF AsmToOrderExists(AsmHeader) THEN
          EXIT(AsmHeader."Quantity to Assemble (Base)");
        EXIT(0);
    end;

    procedure IsAsmToOrderAllowed() : Boolean;
    begin
        IF NOT ("Document Type" IN ["Document Type"::Quote,"Document Type"::"Blanket Order","Document Type"::Order]) THEN
          EXIT(FALSE);
        IF Quantity < 0 THEN
          EXIT(FALSE);
        IF Type <> Type::Item THEN
          EXIT(FALSE);
        IF "No." = '' THEN
          EXIT(FALSE);
        IF "Drop Shipment" OR "Special Order" THEN
          EXIT(FALSE);
        EXIT(TRUE)
    end;

    procedure IsAsmToOrderRequired() : Boolean;
    begin
        IF (Type <> Type::Item) OR ("No." = '') THEN
          EXIT(FALSE);
        GetItem;
        IF GetSKU THEN
          EXIT(SKU."Assembly Policy" = SKU."Assembly Policy"::"Assemble-to-Order");
        EXIT(Item."Assembly Policy" = Item."Assembly Policy"::"Assemble-to-Order");
    end;

    procedure CheckAsmToOrder(AsmHeader : Record "Assembly Header");
    begin
        TESTFIELD("Qty. to Assemble to Order",AsmHeader.Quantity);
        TESTFIELD("Document Type",AsmHeader."Document Type");
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.",AsmHeader."Item No.");
        TESTFIELD("Location Code",AsmHeader."Location Code");
        TESTFIELD("Unit of Measure Code",AsmHeader."Unit of Measure Code");
        TESTFIELD("Variant Code",AsmHeader."Variant Code");
        TESTFIELD("Shipment Date",AsmHeader."Due Date");
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          AsmHeader.CALCFIELDS("Reserved Qty. (Base)");
          AsmHeader.TESTFIELD("Reserved Qty. (Base)",AsmHeader."Remaining Quantity (Base)");
        END;
        TESTFIELD("Qty. to Asm. to Order (Base)",AsmHeader."Quantity (Base)");
        IF "Outstanding Qty. (Base)" < AsmHeader."Remaining Quantity (Base)" THEN
          AsmHeader.FIELDERROR("Remaining Quantity (Base)",STRSUBSTNO(Text045,AsmHeader."Remaining Quantity (Base)"));
    end;

    procedure ShowAsmToOrderLines();
    var
        ATOLink : Record "Assemble-to-Order Link";
    begin
        ATOLink.ShowAsmToOrderLines(Rec);
    end;

    procedure FindOpenATOEntry(LotNo : Code[20];SerialNo : Code[20]) : Integer;
    var
        PostedATOLink : Record "Posted Assemble-to-Order Link";
        ItemLedgEntry : Record "Item Ledger Entry";
    begin
        TESTFIELD("Document Type","Document Type"::Order);
        IF PostedATOLink.FindLinksFromSalesLine(Rec) THEN
          REPEAT
            ItemLedgEntry.SETRANGE("Document Type",ItemLedgEntry."Document Type"::"Posted Assembly");
            ItemLedgEntry.SETRANGE("Document No.",PostedATOLink."Assembly Document No.");
            ItemLedgEntry.SETRANGE("Document Line No.",0);
            ItemLedgEntry.SETRANGE("Serial No.",SerialNo);
            ItemLedgEntry.SETRANGE("Lot No.",LotNo);
            ItemLedgEntry.SETRANGE(Open,TRUE);
            IF ItemLedgEntry.FINDFIRST THEN
              EXIT(ItemLedgEntry."Entry No.");
          UNTIL PostedATOLink.NEXT = 0;
    end;

    procedure RollUpAsmCost();
    begin
        ATOLink.RollUpCost(Rec);
    end;

    procedure RollupAsmPrice();
    begin
        GetSalesHeader;
        ATOLink.RollUpPrice(SalesHeader,Rec);
    end;

    local procedure UpdateICPartner();
    var
        ICPartner : Record "IC Partner";
        ItemCrossReference : Record "Item Cross Reference";
    begin
        IF SalesHeader."Send IC Document" AND
           (SalesHeader."IC Direction" = SalesHeader."IC Direction"::Outgoing) AND
           (SalesHeader."Bill-to IC Partner Code" <> '')
        THEN
          CASE Type OF
            Type::" ",Type::"Charge (Item)":
              BEGIN
                "IC Partner Ref. Type" := Type;
                "IC Partner Reference" := "No.";
              END;
            Type::"G/L Account":
              BEGIN
                "IC Partner Ref. Type" := Type;
                "IC Partner Reference" := GLAcc."Default IC Partner G/L Acc. No";
              END;
            Type::Item:
              BEGIN
                IF SalesHeader."Sell-to IC Partner Code" <> '' THEN
                  ICPartner.GET(SalesHeader."Sell-to IC Partner Code")
                ELSE
                  ICPartner.GET(SalesHeader."Bill-to IC Partner Code");
                CASE ICPartner."Outbound Sales Item No. Type" OF
                  ICPartner."Outbound Sales Item No. Type"::"Common Item No.":
                    VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                  ICPartner."Outbound Sales Item No. Type"::"Internal No.",
                  ICPartner."Outbound Sales Item No. Type"::"Cross Reference":
                    BEGIN
                      IF ICPartner."Outbound Sales Item No. Type" = ICPartner."Outbound Sales Item No. Type"::"Internal No." THEN
                        VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                      ELSE
                        VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                      ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Customer);
                      ItemCrossReference.SETRANGE("Cross-Reference Type No.","Sell-to Customer No.");
                      ItemCrossReference.SETRANGE("Item No.","No.");
                      ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                      ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                      IF ItemCrossReference.FINDFIRST THEN
                        "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                      ELSE
                        "IC Partner Reference" := "No.";
                    END;
                END;
              END;
            Type::"Fixed Asset":
              BEGIN
                "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
                "IC Partner Reference" := '';
              END;
            Type::Resource:
              BEGIN
                Resource.GET("No.");
                "IC Partner Ref. Type" := "IC Partner Ref. Type"::"G/L Account";
                "IC Partner Reference" := Resource."IC Partner Purch. G/L Acc. No.";
              END;
          END;
    end;

    procedure OutstandingInvoiceAmountFromShipment(SellToCustomerNo : Code[20]) : Decimal;
    var
        SalesLine : Record "Sales Line";
    begin
        SalesLine.SETCURRENTKEY("Document Type","Sell-to Customer No.","Shipment No.");
        SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Invoice);
        SalesLine.SETRANGE("Sell-to Customer No.",SellToCustomerNo);
        SalesLine.SETFILTER("Shipment No.",'<>%1','');
        SalesLine.CALCSUMS("Outstanding Amount (LCY)");
        EXIT(SalesLine."Outstanding Amount (LCY)");
    end;

    local procedure CheckShipmentRelation();
    var
        SalesShptLine : Record "Sales Shipment Line";
    begin
        SalesShptLine.GET("Shipment No.","Shipment Line No.");
        IF (Quantity * SalesShptLine."Qty. Shipped Not Invoiced") < 0 THEN
          FIELDERROR("Qty. to Invoice",Text057);
        IF ABS(Quantity) > ABS(SalesShptLine."Qty. Shipped Not Invoiced") THEN
          ERROR(Text058,SalesShptLine."Document No.");
    end;

    local procedure CheckRetRcptRelation();
    var
        ReturnRcptLine : Record "Return Receipt Line";
    begin
        ReturnRcptLine.GET("Return Receipt No.","Return Receipt Line No.");
        IF (Quantity * (ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced")) < 0 THEN
          FIELDERROR("Qty. to Invoice",Text059);
        IF ABS(Quantity) > ABS(ReturnRcptLine.Quantity - ReturnRcptLine."Quantity Invoiced") THEN
          ERROR(Text060,ReturnRcptLine."Document No.");
    end;

    local procedure VerifyItemLineDim();
    begin
        IF IsShippedReceivedItemDimChanged THEN
          ConfirmShippedReceivedItemDimChange;
    end;

    procedure IsShippedReceivedItemDimChanged() : Boolean;
    begin
        EXIT(("Dimension Set ID" <> xRec."Dimension Set ID") AND (Type = Type::Item) AND
          (("Qty. Shipped Not Invoiced" <> 0) OR ("Return Rcd. Not Invd." <> 0)));
    end;

    procedure ConfirmShippedReceivedItemDimChange() : Boolean;
    begin
        IF NOT CONFIRM(Text053,TRUE,TABLECAPTION) THEN
          ERROR(Text054);

        EXIT(TRUE);
    end;

    procedure InitType();
    begin
        IF "Document No." <> '' THEN BEGIN
          SalesHeader.GET("Document Type","Document No.");
          IF (SalesHeader.Status = SalesHeader.Status::Released) AND
             (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
          THEN
            Type := Type::" "
          ELSE
            Type := xRec.Type;
        END;
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text1500000;
        OnesText[2] := Text1500001;
        OnesText[3] := Text1500002;
        OnesText[4] := Text1500003;
        OnesText[5] := Text1500004;
        OnesText[6] := Text1500005;
        OnesText[7] := Text1500006;
        OnesText[8] := Text1500007;
        OnesText[9] := Text1500008;
        OnesText[10] := Text1500009;
        OnesText[11] := Text1500010;
        OnesText[12] := Text1500011;
        OnesText[13] := Text1500012;
        OnesText[14] := Text1500013;
        OnesText[15] := Text1500014;
        OnesText[16] := Text1500015;
        OnesText[17] := Text1500016;
        OnesText[18] := Text1500017;
        OnesText[19] := Text1500018;

        TensText[1] := '';
        TensText[2] := Text1500019;
        TensText[3] := Text1500020;
        TensText[4] := Text1500021;
        TensText[5] := Text1500022;
        TensText[6] := Text1500023;
        TensText[7] := Text1500024;
        TensText[8] := Text1500025;
        TensText[9] := Text1500026;

        ExponentText[1] := '';
        ExponentText[2] := Text1500027;
        ExponentText[3] := Text1500028;
        ExponentText[4] := Text1500029;
    end;

    procedure InitTextVariableTH();
    begin
        OnesText[1] := Text1500030;
        OnesText[2] := Text1500031;
        OnesText[3] := Text1500032;
        OnesText[4] := Text1500033;
        OnesText[5] := Text1500034;
        OnesText[6] := Text1500035;
        OnesText[7] := Text1500036;
        OnesText[8] := Text1500037;
        OnesText[9] := Text1500038;
        OnesText[10] := Text1500039;
        OnesText[11] := Text1500040;
        OnesText[12] := Text1500041;
        OnesText[13] := Text1500042;
        OnesText[14] := Text1500043;
        OnesText[15] := Text1500044;
        OnesText[16] := Text1500045;
        OnesText[17] := Text1500046;
        OnesText[18] := Text1500047;
        OnesText[19] := Text1500048;

        TensText[1] := '';
        TensText[2] := Text1500049;
        TensText[3] := Text1500050;
        TensText[4] := Text1500051;
        TensText[5] := Text1500052;
        TensText[6] := Text1500053;
        TensText[7] := Text1500054;
        TensText[8] := Text1500055;
        TensText[9] := Text1500056;

        ExponentText[1] := '';
        ExponentText[2] := Text1500057;
        ExponentText[3] := Text1500058;
        ExponentText[4] := Text1500059;
    end;

    procedure FormatNoText(var NoText : array [2] of Text[80];No : Decimal;CurrencyCode : Code[10]);
    var
        PrintExponent : Boolean;
        Ones : Integer;
        Tens : Integer;
        Hundreds : Integer;
        Exponent : Integer;
        NoTextIndex : Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500061)
        ELSE
          FOR Exponent := 4 DOWNTO 1 DO BEGIN
            PrintExponent := FALSE;
            Ones := No DIV POWER(1000,Exponent - 1);
            Hundreds := Ones DIV 100;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            IF Hundreds > 0 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500060);
            END;
            IF Tens >= 2 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              IF Ones > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            END ELSE
              IF (Tens * 10 + Ones) > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            IF PrintExponent AND (Exponent > 1) THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          END;

        AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500062);
        AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,CurrencyCode);
    end;

    procedure FormatNoTextTH(var NoText : array [2] of Text[80];No : Decimal;CurrencyCode : Code[10]);
    var
        PrintExponent : Boolean;
        Ones : Integer;
        Tens : Integer;
        Hundreds : Integer;
        Exponent : Integer;
        NoTextIndex : Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500061)
        ELSE
          FOR Exponent := 4 DOWNTO 1 DO BEGIN
            PrintExponent := FALSE;
            Ones := No DIV POWER(1000,Exponent - 1);
            Hundreds := Ones DIV 100;
            Tens := (Ones MOD 100) DIV 10;
            Ones := Ones MOD 10;
            IF Hundreds > 0 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Hundreds]);
              AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500060);
            END;
            IF Tens >= 2 THEN BEGIN
              AddToNoText(NoText,NoTextIndex,PrintExponent,TensText[Tens]);
              IF Ones > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Ones]);
            END ELSE
              IF (Tens * 10 + Ones) > 0 THEN
                AddToNoText(NoText,NoTextIndex,PrintExponent,OnesText[Tens * 10 + Ones]);
            IF PrintExponent AND (Exponent > 1) THEN
              AddToNoText(NoText,NoTextIndex,PrintExponent,ExponentText[Exponent]);
            No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000,Exponent - 1);
          END;

        AddToNoText(NoText,NoTextIndex,PrintExponent,Text1500062);
        AddToNoText(NoText,NoTextIndex,PrintExponent,FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
          AddToNoText(NoText,NoTextIndex,PrintExponent,CurrencyCode);
    end;

    local procedure AddToNoText(var NoText : array [2] of Text[80];var NoTextIndex : Integer;var PrintExponent : Boolean;AddText : Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
          NoTextIndex := NoTextIndex + 1;
          IF NoTextIndex > ARRAYLEN(NoText) THEN
            ERROR(Text029,AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText,'<');
    end;

    local procedure CalculateFullGST(var PrepmtLineAmount : Decimal) : Boolean;
    var
        BaseAmount : Decimal;
    begin
        GetGLSetup;
        IF NOT GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
          EXIT(FALSE);

        UpdateVATAmounts;
        IF "Prepayment %" <> 0 THEN BEGIN
          IF SalesHeader."Prices Including VAT" THEN
            BaseAmount := Amount
          ELSE
            BaseAmount := "Line Amount";
          PrepmtLineAmount :=
            ROUND(BaseAmount * "Prepayment %" / 100,Currency."Amount Rounding Precision") +
            FullGSTAmount;
        END ELSE
          PrepmtLineAmount := 0;
        EXIT(TRUE);
    end;

    local procedure FullGSTAmount() : Decimal;
    begin
        IF SalesHeader."Prices Including VAT" THEN
          EXIT("Amount Including VAT" - Amount)
          ;
        EXIT(0);
    end;

    procedure GetGLSetup();
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    procedure CalcFullGSTValues(var VATAmountLine : Record "VAT Amount Line";var SalesLine : Record "Sales Line";PriceIncludingVAT : Boolean);
    var
        RecSalesLine : Record "Sales Line";
    begin
        WITH VATAmountLine DO BEGIN
          "VAT Base" := 0;
          "VAT Amount" := 0;
          "Inv. Discount Amount" := 0;
          RecSalesLine.RESET;
          RecSalesLine.SETFILTER("Document No.",SalesLine."Document No.");
          RecSalesLine.SETFILTER(Type,'<>%1',SalesLine.Type::" ");
          RecSalesLine.SETFILTER("VAT Identifier",'%1',"VAT Identifier");
          IF RecSalesLine.FINDSET THEN BEGIN
            REPEAT
              IF PriceIncludingVAT THEN BEGIN
                VATBase :=
                  ROUND(
                    ((RecSalesLine."Line Amount" - RecSalesLine."Inv. Discount Amount") /
                     (1 + RecSalesLine."Prepayment VAT %" / 100) - RecSalesLine."VAT Difference"),Currency."Amount Rounding Precision");
                VATAmt :=
                  "VAT Difference" +
                  (RecSalesLine."Line Amount" - RecSalesLine."Inv. Discount Amount" - VATBase - "VAT Difference") *
                  (1 - SalesHeader."VAT Base Discount %" / 100);
                "VAT Base" := "VAT Base" + VATBase * (RecSalesLine."Qty. to Invoice" / RecSalesLine.Quantity);
                "VAT Amount" := "VAT Amount" + VATAmt * (RecSalesLine."Qty. to Invoice" / RecSalesLine.Quantity);
                "Invoice Discount Amount" := "Invoice Discount Amount" + ("Inv. Discount Amount" * RecSalesLine."Prepayment %" / 100);
              END ELSE BEGIN
                VATBase :=
                  ROUND(
                    (RecSalesLine."Line Amount" - RecSalesLine."Inv. Discount Amount") *
                    (RecSalesLine."Qty. to Invoice" / RecSalesLine.Quantity),
                    Currency."Amount Rounding Precision");
                "VAT Base" := "VAT Base" + VATBase;
                "VAT Amount" := "VAT Amount" + (VATBase * RecSalesLine."Prepayment VAT %" / 100);
                "Invoice Discount Amount" :=
                  "Invoice Discount Amount" + RecSalesLine."Inv. Discount Amount" * RecSalesLine."Prepayment %" / 100;
              END;
            UNTIL RecSalesLine.NEXT = 0;
            "VAT Base" := -1 * ROUND("VAT Base",Currency."Amount Rounding Precision");
            "VAT Amount" := -1 * ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
            "Invoice Discount Amount" := -1 * ROUND("Invoice Discount Amount",Currency."Amount Rounding Precision");
            IF PriceIncludingVAT THEN
              "Amount Including VAT" := ROUND("Line Amount",Currency."Amount Rounding Precision")
            ELSE BEGIN
              IF NOT Positive THEN
                "Amount Including VAT" := "Line Amount" - SalesLine."Inv. Discount Amount" + "VAT Amount"
              ELSE
                "Amount Including VAT" := "VAT Base" - SalesLine."Inv. Discount Amount" + "VAT Amount";
            END;
          END;
        END;
    end;

    local procedure CheckWMS();
    begin
        IF CurrFieldNo <> 0 THEN
          CheckLocationOnWMS;
    end;

    procedure CheckLocationOnWMS();
    var
        DialogText : Text;
    begin
        IF Type = Type::Item THEN BEGIN
          DialogText := Text035;
          IF "Quantity (Base)" <> 0 THEN
            CASE "Document Type" OF
              "Document Type"::Invoice:
                IF "Shipment No." = '' THEN
                  IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                    DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
                    ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                  END;
              "Document Type"::"Credit Memo":
                IF "Return Receipt No." = '' THEN
                  IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                    DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                    ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                  END;
            END;
        END;
    end;

    procedure IsServiceItem() : Boolean;
    begin
        IF Type <> Type::Item THEN
          EXIT(FALSE);
        IF "No." = '' THEN
          EXIT(FALSE);
        GetItem;
        EXIT(Item.Type = Item.Type::Service);
    end;

    local procedure ValidateReturnReasonCode(CallingFieldNo : Integer);
    var
        ReturnReason : Record "Return Reason";
    begin
        IF CallingFieldNo = 0 THEN
          EXIT;
        IF "Return Reason Code" = '' THEN
          UpdateUnitPrice(CallingFieldNo);

        IF ReturnReason.GET("Return Reason Code") THEN BEGIN
          IF (CallingFieldNo <> FIELDNO("Location Code")) AND (ReturnReason."Default Location Code" <> '') THEN
            VALIDATE("Location Code",ReturnReason."Default Location Code");
          IF ReturnReason."Inventory Value Zero" THEN
            VALIDATE("Unit Cost (LCY)",0)
          ELSE
            IF "Unit Price" = 0 THEN
              UpdateUnitPrice(CallingFieldNo);
        END;
    end;

    procedure HasTypeToFillMandatotyFields() : Boolean;
    begin
        EXIT(Type <> Type::" ");
    end;

    procedure GetDeferralAmount() DeferralAmount : Decimal;
    begin
        IF "VAT Base Amount" <> 0 THEN
          DeferralAmount := "VAT Base Amount"
        ELSE
          DeferralAmount := "Line Amount" - "Inv. Discount Amount";
    end;

    local procedure UpdateDeferralAmounts();
    var
        AdjustStartDate : Boolean;
    begin
        GetSalesHeader;
        DeferralPostDate := SalesHeader."Posting Date";
        AdjustStartDate := TRUE;
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          IF "Returns Deferral Start Date" = 0D THEN
            "Returns Deferral Start Date" := SalesHeader."Posting Date";
          DeferralPostDate := "Returns Deferral Start Date";
          AdjustStartDate := FALSE;
        END;

        DeferralUtilities.RemoveOrSetDeferralSchedule(
          "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
          "Document Type","Document No.","Line No.",
          GetDeferralAmount,DeferralPostDate,Description,SalesHeader."Currency Code",AdjustStartDate);
    end;

    procedure ShowDeferrals(PostingDate : Date;CurrencyCode : Code[10]) : Boolean;
    begin
        EXIT(DeferralUtilities.OpenLineScheduleEdit(
            "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
            "Document Type","Document No.","Line No.",
            GetDeferralAmount,PostingDate,Description,CurrencyCode));
    end;

    local procedure InitHeaderDefaults(SalesHeader : Record "Sales Header");
    begin
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN BEGIN
          IF (SalesHeader."Sell-to Customer No." = '') AND
             (SalesHeader."Sell-to Customer Template Code" = '')
          THEN
            ERROR(
              Text031,
              SalesHeader.FIELDCAPTION("Sell-to Customer No."),
              SalesHeader.FIELDCAPTION("Sell-to Customer Template Code"));
          IF (SalesHeader."Bill-to Customer No." = '') AND
             (SalesHeader."Bill-to Customer Template Code" = '')
          THEN
            ERROR(
              Text031,
              SalesHeader.FIELDCAPTION("Bill-to Customer No."),
              SalesHeader.FIELDCAPTION("Bill-to Customer Template Code"));
        END ELSE
          SalesHeader.TESTFIELD("Sell-to Customer No.");

        "Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
        "Currency Code" := SalesHeader."Currency Code";
        IF NOT IsServiceItem THEN
          "Location Code" := SalesHeader."Location Code";
        "Customer Price Group" := SalesHeader."Customer Price Group";
        "Customer Disc. Group" := SalesHeader."Customer Disc. Group";
        "Allow Line Disc." := SalesHeader."Allow Line Disc.";
        "Transaction Type" := SalesHeader."Transaction Type";
        "Transport Method" := SalesHeader."Transport Method";
        "Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
        "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
        "WHT Business Posting Group" := SalesHeader."WHT Business Posting Group";
        "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";
        "Exit Point" := SalesHeader."Exit Point";
        Area := SalesHeader.Area;
        "Transaction Specification" := SalesHeader."Transaction Specification";
        "Tax Area Code" := SalesHeader."Tax Area Code";
        "Tax Liable" := SalesHeader."Tax Liable";
        IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND (Type <> Type::" ") THEN
          "Prepayment %" := SalesHeader."Prepayment %";
        "Prepayment Tax Area Code" := SalesHeader."Tax Area Code";
        "Prepayment Tax Liable" := SalesHeader."Tax Liable";
        "Responsibility Center" := SalesHeader."Responsibility Center";

        "Shipping Agent Code" := SalesHeader."Shipping Agent Code";
        "Shipping Agent Service Code" := SalesHeader."Shipping Agent Service Code";
        "Outbound Whse. Handling Time" := SalesHeader."Outbound Whse. Handling Time";
        "Shipping Time" := SalesHeader."Shipping Time";
    end;

    local procedure InitDeferralCode();
    begin
        IF "Document Type" IN
           ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Credit Memo","Document Type"::"Return Order"]
        THEN
          CASE Type OF
            Type::"G/L Account":
              VALIDATE("Deferral Code",GLAcc."Default Deferral Template Code");
            Type::Item:
              VALIDATE("Deferral Code",Item."Default Deferral Template Code");
            Type::Resource:
              VALIDATE("Deferral Code",Res."Default Deferral Template Code");
          END;
    end;

    procedure DefaultDeferralCode();
    begin
        CASE Type OF
          Type::"G/L Account":
            BEGIN
              GLAcc.GET("No.");
              InitDeferralCode;
            END;
          Type::Item:
            BEGIN
              GetItem;
              InitDeferralCode;
            END;
          Type::Resource:
            BEGIN
              Res.GET("No.");
              InitDeferralCode;
            END;
        END;
    end;

    procedure IsCreditDocType() : Boolean;
    begin
        EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    end;

    local procedure IsFullyInvoiced() : Boolean;
    begin
        EXIT(("Qty. Shipped Not Invd. (Base)" = 0) AND ("Qty. Shipped (Base)" = "Quantity (Base)"))
    end;

    local procedure CleanSpecialOrderFieldsAndCheckAssocPurchOrder();
    begin
        IF ("Special Order Purch. Line No." <> 0) AND IsFullyInvoiced THEN
          IF CleanPurchaseLineSpecialOrderFields THEN BEGIN
            "Special Order Purchase No." := '';
            "Special Order Purch. Line No." := 0;
          END;
        CheckAssocPurchOrder('');
    end;

    local procedure CleanPurchaseLineSpecialOrderFields() : Boolean;
    var
        PurchaseLine : Record "Purchase Line";
    begin
        IF PurchaseLine.GET(PurchaseLine."Document Type"::Order,"Special Order Purchase No.","Special Order Purch. Line No.") THEN BEGIN
          IF PurchaseLine."Qty. Received (Base)" < "Qty. Shipped (Base)" THEN
            EXIT(FALSE);

          PurchaseLine."Special Order" := FALSE;
          PurchaseLine."Special Order Sales No." := '';
          PurchaseLine."Special Order Sales Line No." := 0;
          PurchaseLine.MODIFY;
        END;

        EXIT(TRUE);
    end;

    procedure CanEditUnitOfMeasureCode() : Boolean;
    var
        ItemUnitOfMeasure : Record "Item Unit of Measure";
    begin
        IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
          ItemUnitOfMeasure.SETRANGE("Item No.","No.");
          EXIT(ItemUnitOfMeasure.COUNT > 1);
        END;
        EXIT(TRUE);
    end;

    procedure LookupUnitOfMeasureCode();
    var
        ItemUnitOfMeasure : Record "Item Unit of Measure";
        ResourceUnitOfMeasure : Record "Resource Unit of Measure";
        UnitOfMeasure : Record "Unit of Measure";
    begin
        IF NOT CanEditUnitOfMeasureCode THEN
          EXIT;

        CASE TRUE OF
          (Type = Type::Item) AND ("No." <> ''):
            BEGIN
              ItemUnitOfMeasure.SETRANGE("Item No.","No.");
              IF PAGE.RUNMODAL(0,ItemUnitOfMeasure) = ACTION::LookupOK THEN
                VALIDATE("Unit of Measure Code",ItemUnitOfMeasure.Code);
            END;
          (Type = Type::Resource) AND ("No." <> ''):
            BEGIN
              ResourceUnitOfMeasure.SETRANGE("Resource No.","No.");
              IF PAGE.RUNMODAL(0,ResourceUnitOfMeasure) = ACTION::LookupOK THEN
                VALIDATE("Unit of Measure Code",ResourceUnitOfMeasure.Code);
            END;
          ELSE
            IF PAGE.RUNMODAL(0,UnitOfMeasure) = ACTION::LookupOK THEN
              VALIDATE("Unit of Measure Code",UnitOfMeasure.Code);
        END;
    end;

    local procedure ValidateTaxGroupCode();
    var
        TaxGroup : Record "Tax Group";
        TaxDetail : Record "Tax Detail";
    begin
        IF "Tax Group Code" = '' THEN
          EXIT;
        IF NOT TaxGroup.GET("Tax Group Code") THEN BEGIN
          TaxGroup.SETFILTER(Code,"Tax Group Code" + '*');
          IF TaxGroup.FINDFIRST THEN
            "Tax Group Code" := TaxGroup.Code
          ELSE
            TaxGroup.CreateTaxGroup("Tax Group Code");
        END;
        IF "Tax Area Code" <> '' THEN
          TaxDetail.ValidateTaxSetup("Tax Area Code","Tax Group Code");
    end;

    procedure InsertFreightLine(var FreightAmount : Decimal);
    var
        SalesLine : Record "Sales Line";
    begin
        IF FreightAmount <= 0 THEN BEGIN
          FreightAmount := 0;
          EXIT;
        END;

        SalesSetup.GET;
        SalesSetup.TESTFIELD("Freight G/L Acc. No.");

        TESTFIELD("Document Type");
        TESTFIELD("Document No.");

        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","Document No.");

        SalesLine.SETRANGE(Type,SalesLine.Type::"G/L Account");
        SalesLine.SETRANGE("No.",SalesSetup."Freight G/L Acc. No.");
        IF SalesLine.FINDFIRST THEN BEGIN
          SalesLine.VALIDATE(Quantity,1);
          SalesLine.VALIDATE("Unit Price",FreightAmount);
          SalesLine.MODIFY;
        END ELSE BEGIN
          SalesLine.SETRANGE(Type);
          SalesLine.SETRANGE("No.");
          SalesLine.FINDLAST;
          SalesLine."Line No." += 10000;

          SalesLine.INIT;
          SalesLine.VALIDATE(Type,SalesLine.Type::"G/L Account");
          SalesLine.VALIDATE("No.",SalesSetup."Freight G/L Acc. No.");
          SalesLine.VALIDATE(Description,FreightLineDescriptionTxt);
          SalesLine.VALIDATE(Quantity,1);
          SalesLine.VALIDATE("Unit Price",FreightAmount);
          SalesLine.INSERT;
        END;
    end;

    local procedure CalcTotalAmtToAssign(TotalQtyToAssign : Decimal) TotalAmtToAssign : Decimal;
    begin
        TotalAmtToAssign := ("Line Amount" - "Inv. Discount Amount") * TotalQtyToAssign / Quantity;
        IF SalesHeader."Prices Including VAT" THEN
          TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

        TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
    end;

    procedure IsLookupRequested() Result : Boolean;
    begin
        Result := LookupRequested;
        LookupRequested := FALSE;
    end;

    procedure ClearSalesHeader();
    begin
        CLEAR(SalesHeader);
    end;

    procedure RenameNo(LineType : Option;OriginalNo : Code[20];NewNo : Code[20]);
    begin
        RESET;
        SETRANGE(Type,LineType);
        SETRANGE("No.",OriginalNo);
        MODIFYALL("No.",NewNo);
    end;

    procedure UpdatePlanned() : Boolean;
    begin
        TESTFIELD("Qty. per Unit of Measure");
        CALCFIELDS("Reserved Quantity");
        IF Planned = ("Reserved Quantity" = "Outstanding Quantity") THEN
          EXIT(FALSE);
        Planned := NOT Planned;
        EXIT(TRUE);
    end;
}

