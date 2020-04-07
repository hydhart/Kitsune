table 39 "Purchase Line"
{
    // version NAVW110.00.00.17501,NAVAPAC10.00.00.17501

    CaptionML = ENU='Purchase Line',
                ENA='Purchase Line';
    DrillDownPageID = 518;
    LookupPageID = 518;

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
        field(2;"Buy-from Vendor No.";Code[20])
        {
            CaptionML = ENU='Buy-from Vendor No.',
                        ENA='Buy-from Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(3;"Document No.";Code[20])
        {
            CaptionML = ENU='Document No.',
                        ENA='Document No.';
            TableRelation = "Purchase Header".No. WHERE (Document Type=FIELD(Document Type));
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
            OptionCaptionML = ENU=' ,G/L Account,Item,,Fixed Asset,Charge (Item)',
                              ENA=' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";

            trigger OnValidate();
            var
                TempPurchLine : Record "Purchase Line" temporary;
            begin
                GetPurchHeader;
                TestStatusOpen;

                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                TESTFIELD("Quantity Received",0);
                TESTFIELD("Receipt No.",'');

                TESTFIELD("Return Qty. Shipped Not Invd.",0);
                TESTFIELD("Return Qty. Shipped",0);
                TESTFIELD("Return Shipment No.",'');

                TESTFIELD("Prepmt. Amt. Inv.",0);

                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION(Type),"Sales Order No.");
                IF "Special Order" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION(Type),"Special Order Sales No.");
                IF "Prod. Order No." <> '' THEN
                  ERROR(
                    Text044,
                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

                IF Type <> xRec.Type THEN BEGIN
                  IF Quantity <> 0 THEN BEGIN
                    ReservePurchLine.VerifyChange(Rec,xRec);
                    CALCFIELDS("Reserved Qty. (Base)");
                    TESTFIELD("Reserved Qty. (Base)",0);
                    WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                  END;
                  IF xRec.Type IN [Type::Item,Type::"Fixed Asset"] THEN BEGIN
                    IF Quantity <> 0 THEN
                      PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                  END;
                  IF xRec.Type = Type::"Charge (Item)" THEN
                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                  IF xRec."Deferral Code" <> '' THEN
                    DeferralUtilities.RemoveOrSetDeferralSchedule('',
                      DeferralUtilities.GetPurchDeferralDocType,'','',
                      xRec."Document Type",xRec."Document No.",xRec."Line No.",
                      xRec.GetDeferralAmount,PurchHeader."Posting Date",'',xRec."Currency Code",TRUE);
                END;
                TempPurchLine := Rec;
                INIT;

                IF xRec."Line Amount" <> 0 THEN
                  "Recalculate Invoice Disc." := TRUE;

                Type := TempPurchLine.Type;
                "System-Created Entry" := TempPurchLine."System-Created Entry";
                VALIDATE("FA Posting Type");

                IF Type = Type::Item THEN
                  "Allow Item Charge Assignment" := TRUE
                ELSE
                  "Allow Item Charge Assignment" := FALSE;
            end;
        }
        field(6;"No.";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            CaptionML = ENU='No.',
                        ENA='No.';
            TableRelation = IF (Type=CONST(" ")) "Standard Text" ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes), Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(Yes)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                TempPurchLine : Record "Purchase Line" temporary;
                StandardText : Record "Standard Text";
                FixedAsset : Record "Fixed Asset";
                PrepmtMgt : Codeunit "Prepayment Mgt.";
                TypeHelper : Codeunit "Type Helper";
            begin
                "No." := TypeHelper.FindNoFromTypedValue(Type,"No.",NOT "System-Created Entry");

                TestStatusOpen;
                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                TESTFIELD("Quantity Received",0);
                TESTFIELD("Receipt No.",'');

                TESTFIELD("Prepmt. Amt. Inv.",0);

                TestReturnFieldsZero;

                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("No."),"Sales Order No.");

                IF "Special Order" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("No."),"Special Order Sales No.");

                IF "Prod. Order No." <> '' THEN
                  ERROR(
                    Text044,
                    FIELDCAPTION(Type),FIELDCAPTION("Prod. Order No."),"Prod. Order No.");

                IF "No." <> xRec."No." THEN BEGIN
                  IF (Quantity <> 0) AND ItemExists(xRec."No.") THEN BEGIN
                    ReservePurchLine.VerifyChange(Rec,xRec);
                    CALCFIELDS("Reserved Qty. (Base)");
                    TESTFIELD("Reserved Qty. (Base)",0);
                    IF Type = Type::Item THEN
                      WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                  END;
                  IF Type = Type::Item THEN
                    DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");
                  IF Type = Type::"Charge (Item)" THEN
                    DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");
                END;
                TempPurchLine := Rec;
                INIT;
                IF xRec."Line Amount" <> 0 THEN
                  "Recalculate Invoice Disc." := TRUE;
                Type := TempPurchLine.Type;
                "No." := TempPurchLine."No.";
                IF "No." = '' THEN
                  EXIT;
                IF Type <> Type::" " THEN BEGIN
                  Quantity := TempPurchLine.Quantity;
                  "Outstanding Qty. (Base)" := TempPurchLine."Outstanding Qty. (Base)";
                END;

                "System-Created Entry" := TempPurchLine."System-Created Entry";
                GetPurchHeader;
                PurchHeader.TESTFIELD("Buy-from Vendor No.");

                "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";
                "Currency Code" := PurchHeader."Currency Code";
                "Expected Receipt Date" := PurchHeader."Expected Receipt Date";
                "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                IF NOT IsServiceItem THEN
                  "Location Code" := PurchHeader."Location Code";
                "Transaction Type" := PurchHeader."Transaction Type";
                "Transport Method" := PurchHeader."Transport Method";
                "Pay-to Vendor No." := PurchHeader."Pay-to Vendor No.";
                "Gen. Bus. Posting Group" := PurchHeader."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := PurchHeader."VAT Bus. Posting Group";
                "WHT Business Posting Group" := PurchHeader."WHT Business Posting Group";
                "Entry Point" := PurchHeader."Entry Point";
                Area := PurchHeader.Area;
                "Transaction Specification" := PurchHeader."Transaction Specification";
                "Tax Area Code" := PurchHeader."Tax Area Code";
                "Tax Liable" := PurchHeader."Tax Liable";
                IF NOT "System-Created Entry" AND ("Document Type" = "Document Type"::Order) AND (Type <> Type::" ") THEN
                  "Prepayment %" := PurchHeader."Prepayment %";
                "Prepayment Tax Area Code" := PurchHeader."Tax Area Code";
                "Prepayment Tax Liable" := PurchHeader."Tax Liable";
                "Responsibility Center" := PurchHeader."Responsibility Center";

                "Requested Receipt Date" := PurchHeader."Requested Receipt Date";
                "Promised Receipt Date" := PurchHeader."Promised Receipt Date";
                "Inbound Whse. Handling Time" := PurchHeader."Inbound Whse. Handling Time";
                "Order Date" := PurchHeader."Order Date";
                UpdateLeadTimeFields;
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
                      GetGLSetup;
                      Item.TESTFIELD(Blocked,FALSE);
                      Item.TESTFIELD("Gen. Prod. Posting Group");
                      IF Item.Type = Item.Type::Inventory THEN BEGIN
                        Item.TESTFIELD("Inventory Posting Group");
                        "Posting Group" := Item."Inventory Posting Group";
                      END;
                      Description := Item.Description;
                      "Description 2" := Item."Description 2";
                      "Unit Price (LCY)" := Item."Unit Price";
                      "Units per Parcel" := Item."Units per Parcel";
                      "Indirect Cost %" := Item."Indirect Cost %";
                      "Overhead Rate" := Item."Overhead Rate";
                      "Allow Invoice Disc." := Item."Allow Invoice Disc.";
                      "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                      "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                      "WHT Product Posting Group" := Item."WHT Product Posting Group";
                      "Tax Group Code" := Item."Tax Group Code";
                      Nonstock := Item."Created From Nonstock Item";
                      "Item Category Code" := Item."Item Category Code";
                      "Product Group Code" := Item."Product Group Code";
                      "Allow Item Charge Assignment" := TRUE;
                      PrepmtMgt.SetPurchPrepaymentPct(Rec,PurchHeader."Posting Date");

                      IF Item."Price Includes VAT" THEN BEGIN
                        IF NOT VATPostingSetup.GET(
                             Item."VAT Bus. Posting Gr. (Price)",Item."VAT Prod. Posting Group")
                        THEN
                          VATPostingSetup.INIT;
                        CASE VATPostingSetup."VAT Calculation Type" OF
                          VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            VATPostingSetup."VAT %" := 0;
                          VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            ERROR(
                              Text002,
                              VATPostingSetup.FIELDCAPTION("VAT Calculation Type"),
                              VATPostingSetup."VAT Calculation Type");
                        END;
                        "Unit Price (LCY)" :=
                          ROUND("Unit Price (LCY)" / (1 + VATPostingSetup."VAT %" / 100),
                            GLSetup."Unit-Amount Rounding Precision");
                      END;

                      IF PurchHeader."Language Code" <> '' THEN
                        GetItemTranslation;

                      "Unit of Measure Code" := Item."Purch. Unit of Measure";
                      InitDeferralCode;
                    END;
                  Type::"3":
                    ERROR(Text003);
                  Type::"Fixed Asset":
                    BEGIN
                      FixedAsset.GET("No.");
                      FixedAsset.TESTFIELD(Inactive,FALSE);
                      FixedAsset.TESTFIELD(Blocked,FALSE);
                      GetFAPostingGroup;
                      "WHT Product Posting Group" := FixedAsset."WHT Product Posting Group";
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
                      "Indirect Cost %" := 0;
                      "Overhead Rate" := 0;
                    END;
                END;

                IF Type <> Type::" " THEN BEGIN
                  IF NOT BASManagement.VendorRegistered("Buy-from Vendor No.") THEN
                    "VAT Prod. Posting Group" := BASManagement.GetUnregGSTProdPostGroup("VAT Bus. Posting Group","Buy-from Vendor No.");
                  IF Type <> Type::"Fixed Asset" THEN
                    VALIDATE("VAT Prod. Posting Group");
                  VALIDATE("WHT Product Posting Group");
                END;

                UpdatePrepmtSetupFields;

                IF Type <> Type::" " THEN BEGIN
                  Quantity := xRec.Quantity;
                  VALIDATE("Unit of Measure Code");
                  IF Quantity <> 0 THEN BEGIN
                    InitOutstanding;
                    IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                      InitQtyToShip
                    ELSE
                      InitQtyToReceive;
                  END;
                  UpdateWithWarehouseReceive;
                  UpdateDirectUnitCost(FIELDNO("No."));
                  IF xRec."Job No." <> '' THEN
                    VALIDATE("Job No.",xRec."Job No.");
                  "Job Line Type" := xRec."Job Line Type";
                  IF xRec."Job Task No." <> '' THEN BEGIN
                    VALIDATE("Job Task No.",xRec."Job Task No.");
                    IF "No." = xRec."No." THEN
                      VALIDATE("Job Planning Line No.",xRec."Job Planning Line No.");
                  END;
                END;

                IF NOT ISTEMPORARY THEN
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                    DATABASE::Job,"Job No.",
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Work Center","Work Center No.");

                PurchHeader.GET("Document Type","Document No.");
                UpdateItemReference;

                GetDefaultBin;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(TRUE);
                  UpdateJobPrices;
                END
            end;
        }
        field(7;"Location Code";Code[10])
        {
            CaptionML = ENU='Location Code',
                        ENA='Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));

            trigger OnValidate();
            begin
                TestStatusOpen;

                IF "Location Code" <> '' THEN
                  IF IsServiceItem THEN
                    Item.TESTFIELD(Type,Item.Type::Inventory);
                IF xRec."Location Code" <> "Location Code" THEN BEGIN
                  IF "Prepmt. Amt. Inv." <> 0 THEN
                    IF NOT CONFIRM(Text046,FALSE,FIELDCAPTION("Direct Unit Cost"),FIELDCAPTION("Location Code"),PRODUCTNAME.FULL) THEN BEGIN
                      "Location Code" := xRec."Location Code";
                      EXIT;
                    END;
                  TESTFIELD("Qty. Rcd. Not Invoiced",0);
                  TESTFIELD("Receipt No.",'');

                  TESTFIELD("Return Qty. Shipped Not Invd.",0);
                  TESTFIELD("Return Shipment No.",'');
                END;

                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Location Code"),"Sales Order No.");
                IF "Special Order" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Location Code"),"Special Order Sales No.");

                IF "Location Code" <> xRec."Location Code" THEN
                  InitItemAppl;

                IF (xRec."Location Code" <> "Location Code") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                  UpdateWithWarehouseReceive;
                END;
                "Bin Code" := '';

                IF Type = Type::Item THEN
                  UpdateDirectUnitCost(FIELDNO("Location Code"));

                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE
                  IF Location.GET("Location Code") THEN
                    "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";

                UpdateLeadTimeFields;
                UpdateDates;

                GetDefaultBin;
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
        field(10;"Expected Receipt Date";Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Expected Receipt Date',
                        ENA='Expected Receipt Date';

            trigger OnValidate();
            begin
                IF NOT TrackingBlocked THEN
                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);

                CheckReservationDateConflict(FIELDNO("Expected Receipt Date"));

                IF "Expected Receipt Date" <> 0D THEN
                  VALIDATE(
                    "Planned Receipt Date",
                    CalendarMgmt.CalcDateBOC2(InternalLeadTimeDays("Expected Receipt Date"),"Expected Receipt Date",
                      CalChange."Source Type"::Location,"Location Code",'',
                      CalChange."Source Type"::Location,"Location Code",'',FALSE))
                ELSE
                  VALIDATE("Planned Receipt Date","Expected Receipt Date");
            end;
        }
        field(11;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
            TableRelation = IF (Type=CONST(" ")) "Standard Text" ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(No)) "G/L Account" WHERE (Direct Posting=CONST(Yes), Account Type=CONST(Posting), Blocked=CONST(No)) ELSE IF (Type=CONST(G/L Account), System-Created Entry=CONST(Yes)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
            ValidateTableRelation = false;

            trigger OnValidate();
            var
                Item : Record Item;
                TypeHelper : Codeunit "Type Helper";
                ReturnValue : Text[50];
            begin
                IF Type = Type::" " THEN
                  EXIT;

                IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                  Item.SETFILTER(Description,'''@' + CONVERTSTR(Description,'''','?') + '''');
                  IF NOT Item.FINDFIRST THEN
                    EXIT;
                  IF Item."No." = "No." THEN
                    EXIT;
                  IF IsReceivedFromOcr THEN
                    EXIT;
                  IF CONFIRM(AnotherItemWithSameDescrQst,FALSE,Item."No.",Item.Description) THEN
                    VALIDATE("No.",Item."No.");
                END ELSE
                  IF "No." = '' THEN
                    IF TypeHelper.FindRecordByDescription(ReturnValue,Type,Description) = 1 THEN BEGIN
                      CurrFieldNo := FIELDNO("No.");
                      VALIDATE("No.",COPYSTR(ReturnValue,1,MAXSTRLEN("No.")));
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
            begin
                TestStatusOpen;

                IF "Drop Shipment" AND ("Document Type" <> "Document Type"::Invoice) THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION(Quantity),"Sales Order No.");
                "Quantity (Base)" := CalcBaseQty(Quantity);
                IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
                  IF (Quantity * "Return Qty. Shipped" < 0) OR
                     ((ABS(Quantity) < ABS("Return Qty. Shipped")) AND ("Return Shipment No." = ''))
                  THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Return Qty. Shipped")));
                  IF ("Quantity (Base)" * "Return Qty. Shipped (Base)" < 0) OR
                     ((ABS("Quantity (Base)") < ABS("Return Qty. Shipped (Base)")) AND ("Return Shipment No." = ''))
                  THEN
                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text004,FIELDCAPTION("Return Qty. Shipped (Base)")));
                END ELSE BEGIN
                  IF (Quantity * "Quantity Received" < 0) OR
                     ((ABS(Quantity) < ABS("Quantity Received")) AND ("Receipt No." = ''))
                  THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Quantity Received")));
                  IF ("Quantity (Base)" * "Qty. Received (Base)" < 0) OR
                     ((ABS("Quantity (Base)") < ABS("Qty. Received (Base)")) AND ("Receipt No." = ''))
                  THEN
                    FIELDERROR("Quantity (Base)",STRSUBSTNO(Text004,FIELDCAPTION("Qty. Received (Base)")));
                END;

                IF (Type = Type::"Charge (Item)") AND (CurrFieldNo <> 0) THEN BEGIN
                  IF (Quantity = 0) AND ("Qty. to Assign" <> 0) THEN
                    FIELDERROR("Qty. to Assign",STRSUBSTNO(Text011,FIELDCAPTION(Quantity),Quantity));
                  IF (Quantity * "Qty. Assigned" < 0) OR (ABS(Quantity) < ABS("Qty. Assigned")) THEN
                    FIELDERROR(Quantity,STRSUBSTNO(Text004,FIELDCAPTION("Qty. Assigned")));
                END;

                IF "Receipt No." <> '' THEN
                  CheckReceiptRelation
                ELSE
                  IF "Return Shipment No." <> '' THEN
                    CheckRetShptRelation;

                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") OR
                   ("No." = xRec."No.")
                THEN BEGIN
                  InitOutstanding;
                  IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
                    InitQtyToShip
                  ELSE
                    InitQtyToReceive;
                END;
                IF (Quantity * xRec.Quantity < 0) OR (Quantity = 0) THEN
                  InitItemAppl;

                IF Type = Type::Item THEN
                  UpdateDirectUnitCost(FIELDNO(Quantity))
                ELSE
                  VALIDATE("Line Discount %");

                UpdateWithWarehouseReceive;
                IF (xRec.Quantity <> Quantity) OR (xRec."Quantity (Base)" <> "Quantity (Base)") THEN BEGIN
                  ReservePurchLine.VerifyQuantity(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                  CheckApplToItemLedgEntry;
                END;

                IF (xRec.Quantity <> Quantity) AND (Quantity = 0) AND
                   ((Amount <> 0) OR ("Amount Including VAT" <> 0) OR ("VAT Base Amount" <> 0))
                THEN BEGIN
                  Amount := 0;
                  "Amount Including VAT" := 0;
                  "VAT Base Amount" := 0;
                END;

                UpdatePrePaymentAmounts;

                IF "Job Planning Line No." <> 0 THEN
                  VALIDATE("Job Planning Line No.");

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(TRUE);
                  UpdateJobPrices;
                END;

                CheckWMS;
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
                IF ("Qty. to Invoice" * Quantity < 0) OR (ABS("Qty. to Invoice") > ABS(MaxQtyToInvoice)) THEN
                  ERROR(
                    Text006,
                    MaxQtyToInvoice);
                IF ("Qty. to Invoice (Base)" * "Quantity (Base)" < 0) OR (ABS("Qty. to Invoice (Base)") > ABS(MaxQtyToInvoiceBase)) THEN
                  ERROR(
                    Text007,
                    MaxQtyToInvoiceBase);
                "VAT Difference" := 0;
                CalcInvDiscToInvoice;
                CalcPrepaymentToDeduct;

                IF "Job Planning Line No." <> 0 THEN
                  VALIDATE("Job Planning Line No.");
            end;
        }
        field(18;"Qty. to Receive";Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Qty. to Receive',
                        ENA='Qty. to Receive';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                GetLocation("Location Code");
                IF (CurrFieldNo <> 0) AND
                   (Type = Type::Item) AND
                   (NOT "Drop Shipment")
                THEN BEGIN
                  IF Location."Require Receive" AND
                     ("Qty. to Receive" <> 0)
                  THEN
                    CheckWarehouse;
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                END;

                IF "Qty. to Receive" = Quantity - "Quantity Received" THEN
                  InitQtyToReceive
                ELSE BEGIN
                  "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");
                  InitQtyToInvoice;
                END;
                IF ((("Qty. to Receive" < 0) XOR (Quantity < 0)) AND (Quantity <> 0) AND ("Qty. to Receive" <> 0)) OR
                   (ABS("Qty. to Receive") > ABS("Outstanding Quantity")) OR
                   (((Quantity < 0 ) XOR ("Outstanding Quantity" < 0)) AND (Quantity <> 0) AND ("Outstanding Quantity" <> 0))
                THEN
                  ERROR(
                    Text008,
                    "Outstanding Quantity");
                IF ((("Qty. to Receive (Base)" < 0) XOR ("Quantity (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Qty. to Receive (Base)" <> 0)) OR
                   (ABS("Qty. to Receive (Base)") > ABS("Outstanding Qty. (Base)")) OR
                   ((("Quantity (Base)" < 0) XOR ("Outstanding Qty. (Base)" < 0)) AND ("Quantity (Base)" <> 0) AND ("Outstanding Qty. (Base)" <> 0))
                THEN
                  ERROR(
                    Text009,
                    "Outstanding Qty. (Base)");

                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Qty. to Receive" < 0) THEN
                  CheckApplToItemLedgEntry;

                IF "Job Planning Line No." <> 0 THEN
                  VALIDATE("Job Planning Line No.");
            end;
        }
        field(22;"Direct Unit Cost";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Direct Unit Cost"));
            CaptionML = ENU='Direct Unit Cost',
                        ENA='Direct Unit Cost';

            trigger OnValidate();
            begin
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
                TestStatusOpen;
                TESTFIELD("No.");
                TESTFIELD(Quantity);

                IF "Prod. Order No." <> '' THEN
                  ERROR(
                    Text99000000,
                    FIELDCAPTION("Unit Cost (LCY)"));

                IF CurrFieldNo = FIELDNO("Unit Cost (LCY)") THEN
                  IF Type = Type::Item THEN BEGIN
                    GetItem;
                    IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                      ERROR(
                        Text010,
                        FIELDCAPTION("Unit Cost (LCY)"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                  END;

                UnitCostCurrency := "Unit Cost (LCY)";
                GetPurchHeader;
                IF PurchHeader."Currency Code" <> '' THEN BEGIN
                  PurchHeader.TESTFIELD("Currency Factor");
                  GetGLSetup;
                  UnitCostCurrency :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        GetDate,"Currency Code",
                        "Unit Cost (LCY)",PurchHeader."Currency Factor"),
                      GLSetup."Unit-Amount Rounding Precision");
                END;

                IF ("Direct Unit Cost" <> 0) AND
                   ("Direct Unit Cost" <> ("Line Discount Amount" / Quantity))
                THEN
                  "Indirect Cost %" :=
                    ROUND(
                      (UnitCostCurrency - "Direct Unit Cost" + "Line Discount Amount" / Quantity) /
                      ("Direct Unit Cost" - "Line Discount Amount" / Quantity) * 100,0.00001)
                ELSE
                  "Indirect Cost %" := 0;

                UpdateSalesCost;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
                  UpdateJobPrices;
                END
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
                TestStatusOpen;
                GetPurchHeader;
                "Line Discount Amount" :=
                  ROUND(
                    ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") *
                    "Line Discount %" / 100,
                    Currency."Amount Rounding Precision");
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
                UpdateUnitCost;
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
                GetPurchHeader;
                "Line Discount Amount" := ROUND("Line Discount Amount",Currency."Amount Rounding Precision");
                TestStatusOpen;
                TESTFIELD(Quantity);
                IF xRec."Line Discount Amount" <> "Line Discount Amount" THEN
                  IF ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") <> 0 THEN
                    "Line Discount %" :=
                      ROUND(
                        "Line Discount Amount" /
                        ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") * 100,
                        0.00001)
                  ELSE
                    "Line Discount %" := 0;
                "Inv. Discount Amount" := 0;
                "Inv. Disc. Amount to Invoice" := 0;
                UpdateAmounts;
                UpdateUnitCost;
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
                GetPurchHeader;
                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                      "Amount Including VAT" :=
                        ROUND(Amount + "VAT Base Amount" * "VAT %" / 100,Currency."Amount Rounding Precision");
                      "VAT Base (ACY)" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            PurchHeader."Posting Date",GLSetup."Additional Reporting Currency",
                            ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                PurchHeader."Posting Date","Currency Code","VAT Base Amount",
                                PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                          AddCurrency."Amount Rounding Precision");
                      "Amount Including VAT (ACY)" :=
                        ROUND("Amount (ACY)" + "VAT Base (ACY)" * "VAT %" / 100,
                          AddCurrency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    IF Amount <> 0 THEN
                      FIELDERROR(Amount,
                        STRSUBSTNO(
                          Text011,FIELDCAPTION("VAT Calculation Type"),
                          "VAT Calculation Type"));
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      PurchHeader.TESTFIELD("VAT Base Discount %",0);
                      "VAT Base Amount" := Amount;
                      IF "Use Tax" THEN
                        "Amount Including VAT" := "VAT Base Amount"
                      ELSE BEGIN
                        "Amount Including VAT" :=
                          Amount +
                          ROUND(
                            SalesTaxCalculate.CalculateTax(
                              "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                              "VAT Base Amount","Quantity (Base)",PurchHeader."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        IF "VAT Base Amount" <> 0 THEN
                          "VAT %" :=
                            ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                        ELSE
                          "VAT %" := 0;
                      END;
                    END;
                END;

                InitOutstandingAmount;
                UpdateUnitCost;
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
                GetPurchHeader;
                "Amount Including VAT" := ROUND("Amount Including VAT",Currency."Amount Rounding Precision");
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      Amount :=
                        ROUND(
                          "Amount Including VAT" /
                          (1 + (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base Amount" :=
                        ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                    END;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      Amount := 0;
                      "VAT Base Amount" := 0;
                    END;
                  "VAT Calculation Type"::"Sales Tax":
                    BEGIN
                      PurchHeader.TESTFIELD("VAT Base Discount %",0);
                      IF "Use Tax" THEN BEGIN
                        Amount := "Amount Including VAT";
                        "VAT Base Amount" := Amount;
                      END ELSE BEGIN
                        Amount :=
                          ROUND(
                            SalesTaxCalculate.ReverseCalculateTax(
                              "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                              "Amount Including VAT","Quantity (Base)",PurchHeader."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        "VAT Base Amount" := Amount;
                        IF "VAT Base Amount" <> 0 THEN
                          "VAT %" :=
                            ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                        ELSE
                          "VAT %" := 0;
                      END;
                    END;
                END;

                InitOutstandingAmount;
                UpdateUnitCost;
            end;
        }
        field(31;"Unit Price (LCY)";Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU='Unit Price (LCY)',
                        ENA='Unit Price (LCY)';
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
                  UpdateUnitCost;
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
                SelectItemEntry;
            end;

            trigger OnValidate();
            begin
                IF "Appl.-to Item Entry" <> 0 THEN
                  "Location Code" := CheckApplToItemLedgEntry;
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
            end;
        }
        field(45;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            TableRelation = Job;

            trigger OnValidate();
            var
                Job : Record Job;
            begin
                TESTFIELD("Drop Shipment",FALSE);
                TESTFIELD("Special Order",FALSE);
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF ReservEntryExist THEN
                  TESTFIELD("Job No.",'');

                IF "Job No." <> xRec."Job No." THEN BEGIN
                  VALIDATE("Job Task No.",'');
                  VALIDATE("Job Planning Line No.",0);
                END;

                IF "Job No." = '' THEN BEGIN
                  CreateDim(
                    DATABASE::Job,"Job No.",
                    DimMgt.TypeToTableID3(Type),"No.",
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Work Center","Work Center No.");
                  EXIT;
                END;

                IF NOT (Type IN [Type::Item,Type::"G/L Account"]) THEN
                  FIELDERROR("Job No.",STRSUBSTNO(Text012,FIELDCAPTION(Type),Type));
                Job.GET("Job No.");
                Job.TestBlocked;
                "Job Currency Code" := Job."Currency Code";

                CreateDim(
                  DATABASE::Job,"Job No.",
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::"Work Center","Work Center No.");
            end;
        }
        field(54;"Indirect Cost %";Decimal)
        {
            CaptionML = ENU='Indirect Cost %',
                        ENA='Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;

            trigger OnValidate();
            begin
                TESTFIELD("No.");
                TestStatusOpen;

                IF Type = Type::"Charge (Item)" THEN
                  TESTFIELD("Indirect Cost %",0);

                IF (Type = Type::Item) AND ("Prod. Order No." = '') THEN BEGIN
                  GetItem;
                  IF Item."Costing Method" = Item."Costing Method"::Standard THEN
                    ERROR(
                      Text010,
                      FIELDCAPTION("Indirect Cost %"),Item.FIELDCAPTION("Costing Method"),Item."Costing Method");
                END;

                UpdateUnitCost;
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
                GetPurchHeader;
                Currency2.InitRoundingPrecision;
                IF PurchHeader."Currency Code" <> '' THEN
                  "Outstanding Amount (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Outstanding Amount",PurchHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Outstanding Amount (LCY)" :=
                    ROUND("Outstanding Amount",Currency2."Amount Rounding Precision");

                "Outstanding Amt. Ex. VAT (LCY)" :=
                  ROUND("Outstanding Amount (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
            end;
        }
        field(58;"Qty. Rcd. Not Invoiced";Decimal)
        {
            CaptionML = ENU='Qty. Rcd. Not Invoiced',
                        ENA='Qty. Rcd. Not Invoiced';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(59;"Amt. Rcd. Not Invoiced";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Amt. Rcd. Not Invoiced',
                        ENA='Amt. Rcd. Not Invoiced';
            Editable = false;

            trigger OnValidate();
            var
                Currency2 : Record Currency;
            begin
                GetPurchHeader;
                Currency2.InitRoundingPrecision;
                IF PurchHeader."Currency Code" <> '' THEN
                  "Amt. Rcd. Not Invoiced (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Amt. Rcd. Not Invoiced",PurchHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Amt. Rcd. Not Invoiced (LCY)" :=
                    ROUND("Amt. Rcd. Not Invoiced",Currency2."Amount Rounding Precision");

                "A. Rcd. Not Inv. Ex. VAT (LCY)" :=
                  ROUND("Amt. Rcd. Not Invoiced (LCY)" / (1 + "VAT %" / 100),Currency2."Amount Rounding Precision");
            end;
        }
        field(60;"Quantity Received";Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Quantity Received',
                        ENA='Quantity Received';
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
        field(63;"Receipt No.";Code[20])
        {
            CaptionML = ENU='Receipt No.',
                        ENA='Receipt No.';
            Editable = false;
        }
        field(64;"Receipt Line No.";Integer)
        {
            CaptionML = ENU='Receipt Line No.',
                        ENA='Receipt Line No.';
            Editable = false;
        }
        field(67;"Profit %";Decimal)
        {
            CaptionML = ENU='Profit %',
                        ENA='Profit %';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(68;"Pay-to Vendor No.";Code[20])
        {
            CaptionML = ENU='Pay-to Vendor No.',
                        ENA='Pay-to Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Discount Amount',
                        ENA='Inv. Discount Amount';
            Editable = false;

            trigger OnValidate();
            begin
                UpdateAmounts;
                UpdateUnitCost;
                CalcInvDiscToInvoice;
            end;
        }
        field(70;"Vendor Item No.";Text[20])
        {
            CaptionML = ENU='Vendor Item No.',
                        ENA='Vendor Item No.';

            trigger OnValidate();
            begin
                IF PurchHeader."Send IC Document" AND
                   ("IC Partner Ref. Type" = "IC Partner Ref. Type"::"Vendor Item No.")
                THEN
                  "IC Partner Reference" := "Vendor Item No.";
            end;
        }
        field(71;"Sales Order No.";Code[20])
        {
            CaptionML = ENU='Sales Order No.',
                        ENA='Sales Order No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate();
            begin
                IF (xRec."Sales Order No." <> "Sales Order No.") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                END;
            end;
        }
        field(72;"Sales Order Line No.";Integer)
        {
            CaptionML = ENU='Sales Order Line No.',
                        ENA='Sales Order Line No.';
            Editable = false;
            TableRelation = IF (Drop Shipment=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order), Document No.=FIELD(Sales Order No.));

            trigger OnValidate();
            begin
                IF (xRec."Sales Order Line No." <> "Sales Order Line No.") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                END;
            end;
        }
        field(73;"Drop Shipment";Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Drop Shipment',
                        ENA='Drop Shipment';
            Editable = false;

            trigger OnValidate();
            begin
                IF (xRec."Drop Shipment" <> "Drop Shipment") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                END;
                IF "Drop Shipment" THEN BEGIN
                  "Bin Code" := '';
                  EVALUATE("Inbound Whse. Handling Time",'<0D>');
                  VALIDATE("Inbound Whse. Handling Time");
                  InitOutstanding;
                  InitQtyToReceive;
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
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.));
        }
        field(81;"Entry Point";Code[10])
        {
            CaptionML = ENU='Entry Point',
                        ENA='Entry Point';
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

            trigger OnValidate();
            begin
                TestStatusOpen;
                UpdateAmounts;
            end;
        }
        field(88;"Use Tax";Boolean)
        {
            CaptionML = ENU='Use Tax',
                        ENA='Use US Tax';

            trigger OnValidate();
            begin
                UpdateAmounts;
            end;
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
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Reverse Charge VAT",
                  "VAT Calculation Type"::"Sales Tax":
                    "VAT %" := 0;
                  "VAT Calculation Type"::"Full VAT":
                    BEGIN
                      TESTFIELD(Type,Type::"G/L Account");
                      VATPostingSetup.TESTFIELD("Purchase VAT Account");
                      TESTFIELD("No.",VATPostingSetup."Purchase VAT Account");
                    END;
                END;
                IF PurchHeader."Prices Including VAT" AND (Type = Type::Item) THEN
                  "Direct Unit Cost" :=
                    ROUND(
                      "Direct Unit Cost" * (100 + "VAT %") / (100 + xRec."VAT %"),
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
        field(93;"Amt. Rcd. Not Invoiced (LCY)";Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            AutoFormatType = 1;
            CaptionML = ENU='Amt. Rcd. Not Invoiced (LCY)',
                        ENA='Amt. Rcd. Not Invoiced (LCY)';
            Editable = false;
        }
        field(95;"Reserved Quantity";Decimal)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CalcFormula = Sum("Reservation Entry".Quantity WHERE (Source ID=FIELD(Document No.), Source Ref. No.=FIELD(Line No.), Source Type=CONST(39), Source Subtype=FIELD(Document Type), Reservation Status=CONST(Reservation)));
            CaptionML = ENU='Reserved Quantity',
                        ENA='Reserved Quantity';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(97;"Blanket Order No.";Code[20])
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Blanket Order No.',
                        ENA='Blanket Order No.';
            TableRelation = "Purchase Header".No. WHERE (Document Type=CONST(Blanket Order));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            begin
                TESTFIELD("Quantity Received",0);
                BlanketOrderLookup;
            end;

            trigger OnValidate();
            begin
                TESTFIELD("Quantity Received",0);
                IF "Blanket Order No." = '' THEN
                  "Blanket Order Line No." := 0
                ELSE
                  VALIDATE("Blanket Order Line No.");
            end;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Blanket Order Line No.',
                        ENA='Blanket Order Line No.';
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order), Document No.=FIELD(Blanket Order No.));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            begin
                BlanketOrderLookup;
            end;

            trigger OnValidate();
            begin
                TESTFIELD("Quantity Received",0);
                IF "Blanket Order Line No." <> 0 THEN BEGIN
                  PurchLine2.GET("Document Type"::"Blanket Order","Blanket Order No.","Blanket Order Line No.");
                  PurchLine2.TESTFIELD(Type,Type);
                  PurchLine2.TESTFIELD("No.","No.");
                  PurchLine2.TESTFIELD("Pay-to Vendor No.","Pay-to Vendor No.");
                  PurchLine2.TESTFIELD("Buy-from Vendor No.","Buy-from Vendor No.");
                  VALIDATE("Variant Code",PurchLine2."Variant Code");
                  VALIDATE("Location Code",PurchLine2."Location Code");
                  VALIDATE("Unit of Measure Code",PurchLine2."Unit of Measure Code");
                  VALIDATE("Direct Unit Cost",PurchLine2."Direct Unit Cost");
                  VALIDATE("Line Discount %",PurchLine2."Line Discount %");
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
                TESTFIELD("Direct Unit Cost");

                GetPurchHeader;
                "Line Amount" := ROUND("Line Amount",Currency."Amount Rounding Precision");
                GetGLSetup;
                IF PurchHeader."Currency Code" = GLSetup."Additional Reporting Currency" THEN
                  "Amount (ACY)" := "Line Amount"
                ELSE
                  "Amount (ACY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        PurchHeader."Posting Date",GLSetup."Additional Reporting Currency",
                        ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            PurchHeader."Posting Date","Currency Code","Line Amount",
                            PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                      AddCurrency."Amount Rounding Precision");
                VALIDATE(
                  "Line Discount Amount",ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Amount");
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
            OptionCaptionML = ENU=' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.',
                              ENA=' ,G/L Account,Item,,,Charge (Item),Cross Reference,Common Item No.,Vendor Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross Reference","Common Item No.","Vendor Item No.";

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
                ItemVendorCatalog : Record "Item Vendor";
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
                        GetPurchHeader;
                        ItemCrossReference.RESET;
                        ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
                        ItemCrossReference.SETFILTER(
                          "Cross-Reference Type",'%1|%2',
                          ItemCrossReference."Cross-Reference Type"::Vendor,
                          ItemCrossReference."Cross-Reference Type"::" ");
                        ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',PurchHeader."Buy-from Vendor No.",'');
                        IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN
                          VALIDATE("IC Partner Reference",ItemCrossReference."Cross-Reference No.");
                      END;
                    "IC Partner Ref. Type"::"Vendor Item No.":
                      BEGIN
                        GetPurchHeader;
                        ItemVendorCatalog.SETCURRENTKEY("Vendor No.");
                        ItemVendorCatalog.SETRANGE("Vendor No.",PurchHeader."Buy-from Vendor No.");
                        IF PAGE.RUNMODAL(PAGE::"Vendor Item Catalog",ItemVendorCatalog) = ACTION::LookupOK THEN
                          VALIDATE("IC Partner Reference",ItemVendorCatalog."Vendor Item No.");
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
                  FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text038,"Prepmt. Amt. Inv."));
                IF UpdateGSTAmounts THEN
                  IF PrepmtLineAmtExclFullGST > LineAmountExclFullGST THEN
                    FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,"Line Amount" - "Inv. Discount Amount"))
                  ELSE
                    IF "Prepmt. Line Amount" > "Line Amount" THEN
                      FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,"Line Amount"));
                VALIDATE("Prepayment %",ROUND(PrepmtLineAmtExclFullGST * 100 / LineAmountExclFullGST,0.00001));
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
                    STRSUBSTNO(Text039,"Prepmt. Amt. Inv." - "Prepmt Amt Deducted"));

                IF "Prepmt Amt to Deduct" > "Qty. to Invoice" * "Direct Unit Cost" THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text039,"Qty. to Invoice" * "Direct Unit Cost"));
                IF ("Prepmt. Amt. Inv." - "Prepmt Amt to Deduct" - "Prepmt Amt Deducted") >
                   (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"
                THEN
                  FIELDERROR(
                    "Prepmt Amt to Deduct",
                    STRSUBSTNO(Text038,
                      "Prepmt. Amt. Inv." - "Prepmt Amt Deducted" -
                      (Quantity - "Qty. to Invoice" - "Quantity Invoiced") * "Direct Unit Cost"));
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
                  GetPurchHeader;
                  PurchHeader.TESTFIELD("Buy-from IC Partner Code",'');
                  PurchHeader.TESTFIELD("Pay-to IC Partner Code",'');
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
        field(140;"Outstanding Amt. Ex. VAT (LCY)";Decimal)
        {
            CaptionML = ENU='Outstanding Amt. Ex. VAT (LCY)',
                        ENA='Outstanding Amt. Ex. GST (LCY)';
        }
        field(141;"A. Rcd. Not Inv. Ex. VAT (LCY)";Decimal)
        {
            CaptionML = ENU='A. Rcd. Not Inv. Ex. VAT (LCY)',
                        ENA='A. Rcd. Not Inv. Ex. GST (LCY)';
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
        field(1001;"Job Task No.";Code[20])
        {
            CaptionML = ENU='Job Task No.',
                        ENA='Job Task No.';
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');

                IF "Job Task No." <> xRec."Job Task No." THEN BEGIN
                  VALIDATE("Job Planning Line No.",0);
                  IF "Document Type" = "Document Type"::Order THEN
                    TESTFIELD("Quantity Received",0);
                END;

                IF "Job Task No." = '' THEN BEGIN
                  CLEAR(TempJobJnlLine);
                  "Job Line Type" := "Job Line Type"::" ";
                  UpdateJobPrices;
                  CreateDim(
                    DimMgt.TypeToTableID3(Type),"No.",
                    DATABASE::Job,"Job No.",
                    DATABASE::"Responsibility Center","Responsibility Center",
                    DATABASE::"Work Center","Work Center No.");
                  EXIT;
                END;

                JobSetCurrencyFactor;
                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(TRUE);
                  UpdateJobPrices;
                END;
                UpdateDimensionsFromJobTask;
            end;
        }
        field(1002;"Job Line Type";Option)
        {
            AccessByPermission = TableData Job=R;
            CaptionML = ENU='Job Line Type',
                        ENA='Job Line Type';
            OptionCaptionML = ENU=' ,Budget,Billable,Both Budget and Billable',
                              ENA=' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF "Job Planning Line No." <> 0 THEN
                  ERROR(Text048,FIELDCAPTION("Job Line Type"),FIELDCAPTION("Job Planning Line No."));
            end;
        }
        field(1003;"Job Unit Price";Decimal)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Unit Price',
                        ENA='Job Unit Price';

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Unit Price","Job Unit Price");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1004;"Job Total Price";Decimal)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Total Price',
                        ENA='Job Total Price';
            Editable = false;
        }
        field(1005;"Job Line Amount";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Amount',
                        ENA='Job Line Amount';

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Amount","Job Line Amount");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1006;"Job Line Discount Amount";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Discount Amount',
                        ENA='Job Line Discount Amount';

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount Amount","Job Line Discount Amount");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1007;"Job Line Discount %";Decimal)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Line Discount %',
                        ENA='Job Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount %","Job Line Discount %");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1008;"Job Unit Price (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Unit Price (LCY)',
                        ENA='Job Unit Price (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Unit Price (LCY)","Job Unit Price (LCY)");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1009;"Job Total Price (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            BlankZero = true;
            CaptionML = ENU='Job Total Price (LCY)',
                        ENA='Job Total Price (LCY)';
            Editable = false;
        }
        field(1010;"Job Line Amount (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Amount (LCY)',
                        ENA='Job Line Amount (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Amount (LCY)","Job Line Amount (LCY)");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1011;"Job Line Disc. Amount (LCY)";Decimal)
        {
            AccessByPermission = TableData Job=R;
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Disc. Amount (LCY)',
                        ENA='Job Line Disc. Amount (LCY)';
            Editable = false;

            trigger OnValidate();
            begin
                TESTFIELD("Receipt No.",'');
                IF "Document Type" = "Document Type"::Order THEN
                  TESTFIELD("Quantity Received",0);

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(FALSE);
                  TempJobJnlLine.VALIDATE("Line Discount Amount (LCY)","Job Line Disc. Amount (LCY)");
                  UpdateJobPrices;
                END;
            end;
        }
        field(1012;"Job Currency Factor";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Currency Factor',
                        ENA='Job Currency Factor';
        }
        field(1013;"Job Currency Code";Code[20])
        {
            CaptionML = ENU='Job Currency Code',
                        ENA='Job Currency Code';
        }
        field(1019;"Job Planning Line No.";Integer)
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
                CASE Type OF
                  Type::"G/L Account":
                    JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::"G/L Account");
                  Type::Item:
                    JobPlanningLine.SETRANGE(Type,JobPlanningLine.Type::Item);
                END;
                JobPlanningLine.SETRANGE("No.","No.");
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
                  CASE Type OF
                    Type::"G/L Account":
                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::"G/L Account");
                    Type::Item:
                      JobPlanningLine.TESTFIELD(Type,JobPlanningLine.Type::Item);
                  END;
                  JobPlanningLine.TESTFIELD("No.","No.");
                  JobPlanningLine.TESTFIELD("Usage Link",TRUE);
                  JobPlanningLine.TESTFIELD("System-Created Entry",FALSE);
                  "Job Line Type" := JobPlanningLine."Line Type" + 1;
                  VALIDATE("Job Remaining Qty.",JobPlanningLine."Remaining Qty." - "Qty. to Invoice");
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
                  ERROR(Text047,FIELDCAPTION("Job Remaining Qty."),FIELDCAPTION("Job Planning Line No."));

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
                "Job Remaining Qty. (Base)" := CalcBaseQty("Job Remaining Qty.");
            end;
        }
        field(1031;"Job Remaining Qty. (Base)";Decimal)
        {
            CaptionML = ENU='Job Remaining Qty. (Base)',
                        ENA='Job Remaining Qty. (Base)';
        }
        field(1700;"Deferral Code";Code[10])
        {
            CaptionML = ENU='Deferral Code',
                        ENA='Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";

            trigger OnValidate();
            var
                DeferralPostDate : Date;
            begin
                GetPurchHeader;
                DeferralPostDate := PurchHeader."Posting Date";

                DeferralUtilities.DeferralCodeOnValidate(
                  "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
                  "Document Type","Document No.","Line No.",
                  GetDeferralAmount,DeferralPostDate,
                  Description,PurchHeader."Currency Code");

                IF "Document Type" = "Document Type"::"Return Order" THEN
                  "Returns Deferral Start Date" :=
                    DeferralUtilities.GetDeferralStartDate(DeferralUtilities.GetPurchDeferralDocType,
                      "Document Type","Document No.","Line No.","Deferral Code",PurchHeader."Posting Date");
            end;
        }
        field(1702;"Returns Deferral Start Date";Date)
        {
            CaptionML = ENU='Returns Deferral Start Date',
                        ENA='Returns Deferral Start Date';

            trigger OnValidate();
            var
                DeferralHeader : Record "Deferral Header";
                DeferralUtilities : Codeunit "Deferral Utilities";
            begin
                GetPurchHeader;
                IF DeferralHeader.GET(DeferralUtilities.GetPurchDeferralDocType,'','',"Document Type","Document No.","Line No.") THEN
                  DeferralUtilities.CreateDeferralSchedule("Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
                    "Document Type","Document No.","Line No.",GetDeferralAmount,
                    DeferralHeader."Calc. Method","Returns Deferral Start Date",
                    DeferralHeader."No. of Periods",TRUE,
                    DeferralHeader."Schedule Description",FALSE,
                    PurchHeader."Currency Code");
            end;
        }
        field(5401;"Prod. Order No.";Code[20])
        {
            AccessByPermission = TableData "Machine Center"=R;
            CaptionML = ENU='Prod. Order No.',
                        ENA='Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order".No. WHERE (Status=CONST(Released));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Prod. Order No."),"Sales Order No.");

                AddOnIntegrMgt.ValidateProdOrderOnPurchLine(Rec);
            end;
        }
        field(5402;"Variant Code";Code[10])
        {
            CaptionML = ENU='Variant Code',
                        ENA='Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));

            trigger OnValidate();
            begin
                IF "Variant Code" <> '' THEN
                  TESTFIELD(Type,Type::Item);
                TestStatusOpen;

                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                  TESTFIELD("Qty. Rcd. Not Invoiced",0);
                  TESTFIELD("Receipt No.",'');

                  TESTFIELD("Return Qty. Shipped Not Invd.",0);
                  TESTFIELD("Return Shipment No.",'');
                END;

                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Variant Code"),"Sales Order No.");

                IF Type = Type::Item THEN
                  UpdateDirectUnitCost(FIELDNO("Variant Code"));

                IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                  InitItemAppl;
                END;

                UpdateLeadTimeFields;
                UpdateDates;
                GetDefaultBin;
                UpdateItemReference;

                IF JobTaskIsSet THEN BEGIN
                  CreateTempJobJnlLine(TRUE);
                  UpdateJobPrices;
                END;
            end;
        }
        field(5403;"Bin Code";Code[20])
        {
            CaptionML = ENU='Bin Code',
                        ENA='Bin Code';
            TableRelation = IF (Document Type=FILTER(Order|Invoice), Quantity=FILTER(<0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code), Item No.=FIELD(No.), Variant Code=FIELD(Variant Code)) ELSE IF (Document Type=FILTER(Return Order|Credit Memo), Quantity=FILTER(>=0)) "Bin Content"."Bin Code" WHERE (Location Code=FIELD(Location Code), Item No.=FIELD(No.), Variant Code=FIELD(Variant Code)) ELSE Bin.Code WHERE (Location Code=FIELD(Location Code));

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
                  IF NOT IsInbound AND ("Quantity (Base)" <> 0) THEN
                    WMSManagement.FindBinContent("Location Code","Bin Code","No.","Variant Code",'')
                  ELSE
                    WMSManagement.FindBin("Location Code","Bin Code",'');
                END;

                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Bin Code"),"Sales Order No.");

                TESTFIELD(Type,Type::Item);
                TESTFIELD("Location Code");

                IF "Bin Code" <> '' THEN BEGIN
                  GetLocation("Location Code");
                  Location.TESTFIELD("Bin Mandatory");
                  CheckWarehouse;
                END;
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
            begin
                TestStatusOpen;
                TESTFIELD("Quantity Received",0);
                TESTFIELD("Qty. Received (Base)",0);
                TESTFIELD("Qty. Rcd. Not Invoiced",0);
                TESTFIELD("Return Qty. Shipped",0);
                TESTFIELD("Return Qty. Shipped (Base)",0);
                IF "Unit of Measure Code" <> xRec."Unit of Measure Code" THEN BEGIN
                  TESTFIELD("Receipt No.",'');
                  TESTFIELD("Return Shipment No.",'');
                END;
                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Unit of Measure Code"),"Sales Order No.");
                IF (xRec."Unit of Measure" <> "Unit of Measure") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
                IF "Unit of Measure Code" = '' THEN
                  "Unit of Measure" := ''
                ELSE BEGIN
                  UnitOfMeasure.GET("Unit of Measure Code");
                  "Unit of Measure" := UnitOfMeasure.Description;
                  GetPurchHeader;
                  IF PurchHeader."Language Code" <> '' THEN BEGIN
                    UnitOfMeasureTranslation.SETRANGE(Code,"Unit of Measure Code");
                    UnitOfMeasureTranslation.SETRANGE("Language Code",PurchHeader."Language Code");
                    IF UnitOfMeasureTranslation.FINDFIRST THEN
                      "Unit of Measure" := UnitOfMeasureTranslation.Description;
                  END;
                END;
                UpdateItemReference;
                IF "Prod. Order No." = '' THEN BEGIN
                  IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
                    GetItem;
                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
                    "Gross Weight" := Item."Gross Weight" * "Qty. per Unit of Measure";
                    "Net Weight" := Item."Net Weight" * "Qty. per Unit of Measure";
                    "Unit Volume" := Item."Unit Volume" * "Qty. per Unit of Measure";
                    "Units per Parcel" := ROUND(Item."Units per Parcel" / "Qty. per Unit of Measure",0.00001);
                    IF "Qty. per Unit of Measure" > xRec."Qty. per Unit of Measure" THEN
                      InitItemAppl;
                    UpdateUOMQtyPerStockQty;
                  END ELSE
                    "Qty. per Unit of Measure" := 1;
                END ELSE
                  "Qty. per Unit of Measure" := 0;

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
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE(Quantity,"Quantity (Base)");
                UpdateDirectUnitCost(FIELDNO("Quantity (Base)"));
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
        field(5418;"Qty. to Receive (Base)";Decimal)
        {
            CaptionML = ENU='Qty. to Receive (Base)',
                        ENA='Qty. to Receive (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Qty. to Receive","Qty. to Receive (Base)");
            end;
        }
        field(5458;"Qty. Rcd. Not Invoiced (Base)";Decimal)
        {
            CaptionML = ENU='Qty. Rcd. Not Invoiced (Base)',
                        ENA='Qty. Rcd. Not Invoiced (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5460;"Qty. Received (Base)";Decimal)
        {
            CaptionML = ENU='Qty. Received (Base)',
                        ENA='Qty. Received (Base)';
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
            CalcFormula = Sum("Reservation Entry"."Quantity (Base)" WHERE (Source Type=CONST(39), Source Subtype=FIELD(Document Type), Source ID=FIELD(Document No.), Source Ref. No.=FIELD(Line No.), Reservation Status=CONST(Reservation)));
            CaptionML = ENU='Reserved Qty. (Base)',
                        ENA='Reserved Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5600;"FA Posting Date";Date)
        {
            CaptionML = ENU='FA Posting Date',
                        ENA='FA Posting Date';
        }
        field(5601;"FA Posting Type";Option)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Posting Type',
                        ENA='FA Posting Type';
            OptionCaptionML = ENU=' ,Acquisition Cost,Maintenance',
                              ENA=' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;

            trigger OnValidate();
            begin
                IF Type = Type::"Fixed Asset" THEN BEGIN
                  TESTFIELD("Job No.",'');
                  IF "FA Posting Type" = "FA Posting Type"::" " THEN
                    "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
                  GetFAPostingGroup
                END ELSE BEGIN
                  "Depreciation Book Code" := '';
                  "FA Posting Date" := 0D;
                  "Salvage Value" := 0;
                  "Depr. until FA Posting Date" := FALSE;
                  "Depr. Acquisition Cost" := FALSE;
                  "Maintenance Code" := '';
                  "Insurance No." := '';
                  "Budgeted FA No." := '';
                  "Duplicate in Depreciation Book" := '';
                  "Use Duplication List" := FALSE;
                END;
            end;
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
        field(5603;"Salvage Value";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Salvage Value',
                        ENA='Salvage Value';
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
        }
        field(5610;"Insurance No.";Code[20])
        {
            CaptionML = ENU='Insurance No.',
                        ENA='Insurance No.';
            TableRelation = Insurance;
        }
        field(5611;"Budgeted FA No.";Code[20])
        {
            CaptionML = ENU='Budgeted FA No.',
                        ENA='Budgeted FA No.';
            TableRelation = "Fixed Asset";

            trigger OnValidate();
            var
                FixedAsset : Record "Fixed Asset";
            begin
                IF "Budgeted FA No." <> '' THEN BEGIN
                  FixedAsset.GET("Budgeted FA No.");
                  FixedAsset.TESTFIELD("Budgeted Asset",TRUE);
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
                  DATABASE::Job,"Job No.",
                  DATABASE::"Work Center","Work Center No.");
            end;
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
                GetPurchHeader;
                "Buy-from Vendor No." := PurchHeader."Buy-from Vendor No.";

                ReturnedCrossRef.INIT;
                IF "Cross-Reference No." <> '' THEN BEGIN
                  DistIntegration.ICRLookupPurchaseItem(Rec,ReturnedCrossRef);
                  VALIDATE("No.",ReturnedCrossRef."Item No.");
                  SetVendorItemNo;
                  IF ReturnedCrossRef."Variant Code" <> '' THEN
                    VALIDATE("Variant Code",ReturnedCrossRef."Variant Code");
                  IF ReturnedCrossRef."Unit of Measure" <> '' THEN
                    VALIDATE("Unit of Measure Code",ReturnedCrossRef."Unit of Measure");
                  UpdateDirectUnitCost(FIELDNO("Cross-Reference No."));
                END;

                "Unit of Measure (Cross Ref.)" := ReturnedCrossRef."Unit of Measure";
                "Cross-Reference Type" := ReturnedCrossRef."Cross-Reference Type";
                "Cross-Reference Type No." := ReturnedCrossRef."Cross-Reference Type No.";
                "Cross-Reference No." := ReturnedCrossRef."Cross-Reference No.";

                IF ReturnedCrossRef.Description <> '' THEN
                  Description := ReturnedCrossRef.Description;

                UpdateICPartner;
            end;
        }
        field(5706;"Unit of Measure (Cross Ref.)";Code[10])
        {
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
        }
        field(5711;"Purchasing Code";Code[10])
        {
            CaptionML = ENU='Purchasing Code',
                        ENA='Purchasing Code';
            Editable = false;
            TableRelation = Purchasing;

            trigger OnValidate();
            var
                PurchasingCode : Record Purchasing;
            begin
                IF PurchasingCode.GET("Purchasing Code") THEN BEGIN
                  "Drop Shipment" := PurchasingCode."Drop Shipment";
                  "Special Order" := PurchasingCode."Special Order";
                END ELSE
                  "Drop Shipment" := FALSE;
                VALIDATE("Drop Shipment","Drop Shipment");
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
            CaptionML = ENU='Special Order',
                        ENA='Special Order';

            trigger OnValidate();
            begin
                IF (xRec."Special Order" <> "Special Order") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
            end;
        }
        field(5714;"Special Order Sales No.";Code[20])
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Special Order Sales No.',
                        ENA='Special Order Sales No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Sales Header".No. WHERE (Document Type=CONST(Order));

            trigger OnValidate();
            begin
                IF (xRec."Special Order Sales No." <> "Special Order Sales No.") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
            end;
        }
        field(5715;"Special Order Sales Line No.";Integer)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Special Order Sales Line No.',
                        ENA='Special Order Sales Line No.';
            TableRelation = IF (Special Order=CONST(Yes)) "Sales Line"."Line No." WHERE (Document Type=CONST(Order), Document No.=FIELD(Special Order Sales No.));

            trigger OnValidate();
            begin
                IF (xRec."Special Order Sales Line No." <> "Special Order Sales Line No.") AND (Quantity <> 0) THEN
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
            end;
        }
        field(5750;"Whse. Outstanding Qty. (Base)";Decimal)
        {
            AccessByPermission = TableData Location=R;
            BlankZero = true;
            CalcFormula = Sum("Warehouse Receipt Line"."Qty. Outstanding (Base)" WHERE (Source Type=CONST(39), Source Subtype=FIELD(Document Type), Source No.=FIELD(Document No.), Source Line No.=FIELD(Line No.)));
            CaptionML = ENU='Whse. Outstanding Qty. (Base)',
                        ENA='Whse. Outstanding Qty. (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5752;"Completely Received";Boolean)
        {
            CaptionML = ENU='Completely Received',
                        ENA='Completely Received';
            Editable = false;
        }
        field(5790;"Requested Receipt Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Requested Receipt Date',
                        ENA='Requested Receipt Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF (CurrFieldNo <> 0) AND
                   ("Promised Receipt Date" <> 0D)
                THEN
                  ERROR(
                    Text023,
                    FIELDCAPTION("Requested Receipt Date"),
                    FIELDCAPTION("Promised Receipt Date"));

                IF "Requested Receipt Date" <> 0D THEN
                  VALIDATE("Order Date",
                    CalendarMgmt.CalcDateBOC2(AdjustDateFormula("Lead Time Calculation"),"Requested Receipt Date",
                      CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                      CalChange."Source Type"::Location,"Location Code",'',TRUE))
                ELSE
                  IF "Requested Receipt Date" <> xRec."Requested Receipt Date" THEN
                    GetUpdateBasicDates;
            end;
        }
        field(5791;"Promised Receipt Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Promised Receipt Date',
                        ENA='Promised Receipt Date';

            trigger OnValidate();
            begin
                IF CurrFieldNo <> 0 THEN
                  IF "Promised Receipt Date" <> 0D THEN
                    VALIDATE("Planned Receipt Date","Promised Receipt Date")
                  ELSE
                    VALIDATE("Requested Receipt Date")
                ELSE
                  VALIDATE("Planned Receipt Date","Promised Receipt Date");
            end;
        }
        field(5792;"Lead Time Calculation";DateFormula)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Lead Time Calculation',
                        ENA='Lead Time Calculation';

            trigger OnValidate();
            begin
                TestStatusOpen;
                LeadTimeMgt.CheckLeadTimeIsNotNegative("Lead Time Calculation");

                IF "Requested Receipt Date" <> 0D THEN BEGIN
                  VALIDATE("Planned Receipt Date");
                END ELSE
                  GetUpdateBasicDates;
            end;
        }
        field(5793;"Inbound Whse. Handling Time";DateFormula)
        {
            AccessByPermission = TableData Location=R;
            CaptionML = ENU='Inbound Whse. Handling Time',
                        ENA='Inbound Whse. Handling Time';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF ("Promised Receipt Date" <> 0D) OR
                   ("Requested Receipt Date" <> 0D)
                THEN
                  VALIDATE("Planned Receipt Date")
                ELSE
                  VALIDATE("Expected Receipt Date");
            end;
        }
        field(5794;"Planned Receipt Date";Date)
        {
            AccessByPermission = TableData "Order Promising Line"=R;
            CaptionML = ENU='Planned Receipt Date',
                        ENA='Planned Receipt Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF "Promised Receipt Date" <> 0D THEN BEGIN
                  IF "Planned Receipt Date" <> 0D THEN
                    "Expected Receipt Date" :=
                      CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                        CalChange."Source Type"::Location,"Location Code",'',
                        CalChange."Source Type"::Location,"Location Code",'',FALSE)
                  ELSE
                    "Expected Receipt Date" := "Planned Receipt Date";
                END ELSE
                  IF "Planned Receipt Date" <> 0D THEN BEGIN
                    "Order Date" :=
                      CalendarMgmt.CalcDateBOC2(AdjustDateFormula("Lead Time Calculation"),"Planned Receipt Date",
                        CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                        CalChange."Source Type"::Location,"Location Code",'',TRUE);
                    "Expected Receipt Date" :=
                      CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                        CalChange."Source Type"::Location,"Location Code",'',
                        CalChange."Source Type"::Location,"Location Code",'',FALSE)
                  END ELSE
                    GetUpdateBasicDates;

                IF NOT TrackingBlocked THEN
                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);
                CheckReservationDateConflict(FIELDNO("Planned Receipt Date"));
            end;
        }
        field(5795;"Order Date";Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header"=R;
            CaptionML = ENU='Order Date',
                        ENA='Order Date';

            trigger OnValidate();
            begin
                TestStatusOpen;
                IF (CurrFieldNo <> 0) AND
                   ("Document Type" = "Document Type"::Order) AND
                   ("Order Date" < WORKDATE) AND
                   ("Order Date" <> 0D)
                THEN
                  MESSAGE(
                    Text018,
                    FIELDCAPTION("Order Date"),"Order Date",WORKDATE);

                IF "Order Date" <> 0D THEN
                  "Planned Receipt Date" :=
                    CalendarMgmt.CalcDateBOC(AdjustDateFormula("Lead Time Calculation"),"Order Date",
                      CalChange."Source Type"::Vendor,"Buy-from Vendor No.",'',
                      CalChange."Source Type"::Location,"Location Code",'',TRUE);

                IF "Planned Receipt Date" <> 0D THEN
                  "Expected Receipt Date" :=
                    CalendarMgmt.CalcDateBOC(InternalLeadTimeDays("Planned Receipt Date"),"Planned Receipt Date",
                      CalChange."Source Type"::Location,"Location Code",'',
                      CalChange."Source Type"::Location,"Location Code",'',FALSE)
                ELSE
                  "Expected Receipt Date" := "Planned Receipt Date";

                IF NOT TrackingBlocked THEN
                  CheckDateConflict.PurchLineCheck(Rec,CurrFieldNo <> 0);
                CheckReservationDateConflict(FIELDNO("Order Date"));
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
            CalcFormula = Sum("Item Charge Assignment (Purch)"."Qty. to Assign" WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.), Document Line No.=FIELD(Line No.)));
            CaptionML = ENU='Qty. to Assign',
                        ENA='Qty. to Assign';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5802;"Qty. Assigned";Decimal)
        {
            CalcFormula = Sum("Item Charge Assignment (Purch)"."Qty. Assigned" WHERE (Document Type=FIELD(Document Type), Document No.=FIELD(Document No.), Document Line No.=FIELD(Line No.)));
            CaptionML = ENU='Qty. Assigned',
                        ENA='Qty. Assigned';
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5803;"Return Qty. to Ship";Decimal)
        {
            AccessByPermission = TableData "Return Shipment Header"=R;
            CaptionML = ENU='Return Qty. to Ship',
                        ENA='Return Qty. to Ship';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                IF (CurrFieldNo <> 0) AND
                   (Type = Type::Item) AND
                   ("Return Qty. to Ship" <> 0) AND
                   (NOT "Drop Shipment")
                THEN
                  CheckWarehouse;

                IF "Return Qty. to Ship" = Quantity - "Return Qty. Shipped" THEN
                  InitQtyToShip
                ELSE BEGIN
                  "Return Qty. to Ship (Base)" := CalcBaseQty("Return Qty. to Ship");
                  InitQtyToInvoice;
                END;
                IF ("Return Qty. to Ship" * Quantity < 0) OR
                   (ABS("Return Qty. to Ship") > ABS("Outstanding Quantity")) OR
                   (Quantity * "Outstanding Quantity" < 0)
                THEN
                  ERROR(
                    Text020,
                    "Outstanding Quantity");
                IF ("Return Qty. to Ship (Base)" * "Quantity (Base)" < 0) OR
                   (ABS("Return Qty. to Ship (Base)") > ABS("Outstanding Qty. (Base)")) OR
                   ("Quantity (Base)" * "Outstanding Qty. (Base)" < 0)
                THEN
                  ERROR(
                    Text021,
                    "Outstanding Qty. (Base)");

                IF (CurrFieldNo <> 0) AND (Type = Type::Item) AND ("Return Qty. to Ship" > 0) THEN
                  CheckApplToItemLedgEntry;
            end;
        }
        field(5804;"Return Qty. to Ship (Base)";Decimal)
        {
            CaptionML = ENU='Return Qty. to Ship (Base)',
                        ENA='Return Qty. to Ship (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                TESTFIELD("Qty. per Unit of Measure",1);
                VALIDATE("Return Qty. to Ship","Return Qty. to Ship (Base)");
            end;
        }
        field(5805;"Return Qty. Shipped Not Invd.";Decimal)
        {
            CaptionML = ENU='Return Qty. Shipped Not Invd.',
                        ENA='Return Qty. Shipped Not Invd.';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5806;"Ret. Qty. Shpd Not Invd.(Base)";Decimal)
        {
            CaptionML = ENU='Ret. Qty. Shpd Not Invd.(Base)',
                        ENA='Ret. Qty. Shpd Not Invd.(Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5807;"Return Shpd. Not Invd.";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CaptionML = ENU='Return Shpd. Not Invd.',
                        ENA='Return Shpd. Not Invd.';
            Editable = false;

            trigger OnValidate();
            var
                Currency2 : Record Currency;
            begin
                GetPurchHeader;
                Currency2.InitRoundingPrecision;
                IF PurchHeader."Currency Code" <> '' THEN
                  "Return Shpd. Not Invd. (LCY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        GetDate,"Currency Code",
                        "Return Shpd. Not Invd.",PurchHeader."Currency Factor"),
                      Currency2."Amount Rounding Precision")
                ELSE
                  "Return Shpd. Not Invd. (LCY)" :=
                    ROUND("Return Shpd. Not Invd.",Currency2."Amount Rounding Precision");
            end;
        }
        field(5808;"Return Shpd. Not Invd. (LCY)";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Return Shpd. Not Invd. (LCY)',
                        ENA='Return Shpd. Not Invd. (LCY)';
            Editable = false;
        }
        field(5809;"Return Qty. Shipped";Decimal)
        {
            AccessByPermission = TableData "Return Shipment Header"=R;
            CaptionML = ENU='Return Qty. Shipped',
                        ENA='Return Qty. Shipped';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5810;"Return Qty. Shipped (Base)";Decimal)
        {
            CaptionML = ENU='Return Qty. Shipped (Base)',
                        ENA='Return Qty. Shipped (Base)';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(6600;"Return Shipment No.";Code[20])
        {
            CaptionML = ENU='Return Shipment No.',
                        ENA='Return Shipment No.';
            Editable = false;
        }
        field(6601;"Return Shipment Line No.";Integer)
        {
            CaptionML = ENU='Return Shipment Line No.',
                        ENA='Return Shipment Line No.';
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
        field(50000;Narration;Text[250])
        {
        }
        field(99000750;"Routing No.";Code[20])
        {
            CaptionML = ENU='Routing No.',
                        ENA='Routing No.';
            TableRelation = "Routing Header";
        }
        field(99000751;"Operation No.";Code[10])
        {
            CaptionML = ENU='Operation No.',
                        ENA='Operation No.';
            Editable = false;
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=CONST(Released), Prod. Order No.=FIELD(Prod. Order No.), Routing No.=FIELD(Routing No.));

            trigger OnValidate();
            var
                ProdOrderRtngLine : Record "Prod. Order Routing Line";
            begin
                IF "Operation No." = '' THEN
                  EXIT;

                TESTFIELD(Type,Type::Item);
                TESTFIELD("Prod. Order No.");
                TESTFIELD("Routing No.");

                ProdOrderRtngLine.GET(
                  ProdOrderRtngLine.Status::Released,
                  "Prod. Order No.",
                  "Routing Reference No.",
                  "Routing No.",
                  "Operation No.");

                ProdOrderRtngLine.TESTFIELD(
                  Type,
                  ProdOrderRtngLine.Type::"Work Center");

                "Expected Receipt Date" := ProdOrderRtngLine."Ending Date";
                VALIDATE("Work Center No.",ProdOrderRtngLine."No.");
                VALIDATE("Direct Unit Cost",ProdOrderRtngLine."Direct Unit Cost");
            end;
        }
        field(99000752;"Work Center No.";Code[20])
        {
            CaptionML = ENU='Work Center No.',
                        ENA='Work Centre No.';
            Editable = false;
            TableRelation = "Work Center";

            trigger OnValidate();
            begin
                IF Type = Type::"Charge (Item)" THEN
                  TESTFIELD("Work Center No.",'');
                IF "Work Center No." = '' THEN
                  EXIT;

                WorkCenter.GET("Work Center No.");
                "Gen. Prod. Posting Group" := WorkCenter."Gen. Prod. Posting Group";
                "VAT Prod. Posting Group" := '';
                IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                  "VAT Prod. Posting Group" := GenProdPostingGrp."Def. VAT Prod. Posting Group";
                VALIDATE("VAT Prod. Posting Group");

                "Overhead Rate" := WorkCenter."Overhead Rate";
                VALIDATE("Indirect Cost %",WorkCenter."Indirect Cost %");

                CreateDim(
                  DATABASE::"Work Center","Work Center No.",
                  DimMgt.TypeToTableID3(Type),"No.",
                  DATABASE::Job,"Job No.",
                  DATABASE::"Responsibility Center","Responsibility Center");
            end;
        }
        field(99000753;Finished;Boolean)
        {
            CaptionML = ENU='Finished',
                        ENA='Finished';
        }
        field(99000754;"Prod. Order Line No.";Integer)
        {
            CaptionML = ENU='Prod. Order Line No.',
                        ENA='Prod. Order Line No.';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..), Prod. Order No.=FIELD(Prod. Order No.));
        }
        field(99000755;"Overhead Rate";Decimal)
        {
            CaptionML = ENU='Overhead Rate',
                        ENA='Overhead Rate';
            DecimalPlaces = 0:5;

            trigger OnValidate();
            begin
                VALIDATE("Indirect Cost %");
            end;
        }
        field(99000756;"MPS Order";Boolean)
        {
            CaptionML = ENU='MPS Order',
                        ENA='MPS Order';
        }
        field(99000757;"Planning Flexibility";Option)
        {
            CaptionML = ENU='Planning Flexibility',
                        ENA='Planning Flexibility';
            OptionCaptionML = ENU='Unlimited,None',
                              ENA='Unlimited,None';
            OptionMembers = Unlimited,"None";

            trigger OnValidate();
            begin
                IF "Planning Flexibility" <> xRec."Planning Flexibility" THEN
                  ReservePurchLine.UpdatePlanningFlexibility(Rec);
            end;
        }
        field(99000758;"Safety Lead Time";DateFormula)
        {
            CaptionML = ENU='Safety Lead Time',
                        ENA='Safety Lead Time';

            trigger OnValidate();
            begin
                VALIDATE("Inbound Whse. Handling Time");
            end;
        }
        field(99000759;"Routing Reference No.";Integer)
        {
            CaptionML = ENU='Routing Reference No.',
                        ENA='Routing Reference No.';
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;"Document No.","Line No.","Document Type")
        {
            Enabled = false;
        }
        key(Key3;"Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key4;"Document Type","Pay-to Vendor No.","Currency Code")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Outstanding Amount","Amt. Rcd. Not Invoiced","Outstanding Amount (LCY)","Amt. Rcd. Not Invoiced (LCY)";
        }
        key(Key5;"Document Type",Type,"No.","Variant Code","Drop Shipment","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Location Code","Expected Receipt Date")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
        key(Key6;"Document Type","Pay-to Vendor No.","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code","Currency Code")
        {
            Enabled = false;
            MaintainSIFTIndex = false;
            MaintainSQLIndex = false;
            SumIndexFields = "Outstanding Amount","Amt. Rcd. Not Invoiced","Outstanding Amount (LCY)","Amt. Rcd. Not Invoiced (LCY)";
        }
        key(Key7;"Document Type","Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key8;"Document Type",Type,"Prod. Order No.","Prod. Order Line No.","Routing No.","Operation No.")
        {
        }
        key(Key9;"Document Type","Document No.","Location Code")
        {
            Enabled = false;
        }
        key(Key10;"Document Type","Receipt No.","Receipt Line No.")
        {
        }
        key(Key11;Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type","Expected Receipt Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key12;"Document Type","Buy-from Vendor No.")
        {
        }
        key(Key13;"Document Type","Job No.","Job Task No.")
        {
            SumIndexFields = "Outstanding Amt. Ex. VAT (LCY)","A. Rcd. Not Inv. Ex. VAT (LCY)";
        }
        key(Key14;"Document Type","Document No.",Type,"No.")
        {
            Enabled = false;
        }
        key(Key15;"Document Type","Document No.","WHT Business Posting Group","WHT Product Posting Group")
        {
            SumIndexFields = "Prepmt. Amt. Inv.","Prepmt Amt to Deduct";
        }
        key(Key16;"Document Type",Type,"No.")
        {
            Enabled = false;
            SumIndexFields = "Outstanding Qty. (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        PurchCommentLine : Record "Purch. Comment Line";
        SalesOrderLine : Record "Sales Line";
    begin
        TestStatusOpen;
        IF NOT StatusCheckSuspended AND (PurchHeader.Status = PurchHeader.Status::Released) AND
           (Type IN [Type::"G/L Account",Type::"Charge (Item)"])
        THEN
          VALIDATE(Quantity,0);

        IF (Quantity <> 0) AND ItemExists("No.") THEN BEGIN
          ReservePurchLine.DeleteLine(Rec);
          IF "Receipt No." = '' THEN
            TESTFIELD("Qty. Rcd. Not Invoiced",0);
          IF "Return Shipment No." = '' THEN
            TESTFIELD("Return Qty. Shipped Not Invd.",0);

          CALCFIELDS("Reserved Qty. (Base)");
          TESTFIELD("Reserved Qty. (Base)",0);
          WhseValidateSourceLine.PurchaseLineDelete(Rec);
        END;

        IF ("Document Type" = "Document Type"::Order) AND (Quantity <> "Quantity Invoiced") THEN
          TESTFIELD("Prepmt. Amt. Inv.","Prepmt Amt Deducted");

        IF "Sales Order Line No." <> 0 THEN BEGIN
          LOCKTABLE;
          SalesOrderLine.LOCKTABLE;
          SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
          SalesOrderLine."Purchase Order No." := '';
          SalesOrderLine."Purch. Order Line No." := 0;
          SalesOrderLine.MODIFY;
        END;

        IF "Special Order Sales Line No." <> 0 THEN BEGIN
          LOCKTABLE;
          SalesOrderLine.LOCKTABLE;
          IF "Document Type" = "Document Type"::Order THEN BEGIN
            SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.");
            SalesOrderLine."Special Order Purchase No." := '';
            SalesOrderLine."Special Order Purch. Line No." := 0;
            SalesOrderLine.MODIFY;
          END ELSE
            IF SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.") THEN
              BEGIN
              SalesOrderLine."Special Order Purchase No." := '';
              SalesOrderLine."Special Order Purch. Line No." := 0;
              SalesOrderLine.MODIFY;
            END;
        END;

        NonstockItemMgt.DelNonStockPurch(Rec);

        IF "Document Type" = "Document Type"::"Blanket Order" THEN BEGIN
          PurchLine2.RESET;
          PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
          PurchLine2.SETRANGE("Blanket Order No.","Document No.");
          PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
          IF PurchLine2.FINDFIRST THEN
            PurchLine2.TESTFIELD("Blanket Order Line No.",0);
        END;

        IF Type = Type::Item THEN
          DeleteItemChargeAssgnt("Document Type","Document No.","Line No.");

        IF Type = Type::"Charge (Item)" THEN
          DeleteChargeChargeAssgnt("Document Type","Document No.","Line No.");

        IF "Line No." <> 0 THEN BEGIN
          PurchLine2.RESET;
          PurchLine2.SETRANGE("Document Type","Document Type");
          PurchLine2.SETRANGE("Document No.","Document No.");
          PurchLine2.SETRANGE("Attached to Line No.","Line No.");
          PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
          PurchLine2.DELETEALL(TRUE);
        END;

        PurchCommentLine.SETRANGE("Document Type","Document Type");
        PurchCommentLine.SETRANGE("No.","Document No.");
        PurchCommentLine.SETRANGE("Document Line No.","Line No.");
        IF NOT PurchCommentLine.ISEMPTY THEN
          PurchCommentLine.DELETEALL;

        IF ("Line No." <> 0) AND ("Attached to Line No." = 0) THEN BEGIN
          PurchLine2.COPY(Rec);
          IF PurchLine2.FIND('<>') THEN BEGIN
            PurchLine2.VALIDATE("Recalculate Invoice Disc.",TRUE);
            PurchLine2.MODIFY;
          END;
        END;

        IF "Deferral Code" <> '' THEN
          DeferralUtilities.DeferralCodeOnDelete(
            DeferralUtilities.GetPurchDeferralDocType,'','',
            "Document Type","Document No.","Line No.");
    end;

    trigger OnInsert();
    begin
        TestStatusOpen;
        IF Quantity <> 0 THEN
          ReservePurchLine.VerifyQuantity(Rec,xRec);

        LOCKTABLE;
        PurchHeader."No." := '';
        IF ("Deferral Code" <> '') AND (GetDeferralAmount <> 0) THEN
          UpdateDeferralAmounts;
    end;

    trigger OnModify();
    begin
        IF ("Document Type" = "Document Type"::"Blanket Order") AND
           ((Type <> xRec.Type) OR ("No." <> xRec."No."))
        THEN BEGIN
          PurchLine2.RESET;
          PurchLine2.SETCURRENTKEY("Document Type","Blanket Order No.","Blanket Order Line No.");
          PurchLine2.SETRANGE("Blanket Order No.","Document No.");
          PurchLine2.SETRANGE("Blanket Order Line No.","Line No.");
          IF PurchLine2.FINDSET THEN
            REPEAT
              PurchLine2.TESTFIELD(Type,Type);
              PurchLine2.TESTFIELD("No.","No.");
            UNTIL PurchLine2.NEXT = 0;
        END;

        IF ((Quantity <> 0) OR (xRec.Quantity <> 0)) AND ItemExists(xRec."No.") THEN
          ReservePurchLine.VerifyChange(Rec,xRec);
    end;

    trigger OnRename();
    begin
        ERROR(Text000,TABLECAPTION);
    end;

    var
        Text000 : TextConst ENU='You cannot rename a %1.',ENA='You cannot rename a %1.';
        Text001 : TextConst ENU='You cannot change %1 because the order line is associated with sales order %2.',ENA='You cannot change %1 because the order line is associated with sales order %2.';
        Text002 : TextConst ENU='Prices including VAT cannot be calculated when %1 is %2.',ENA='Prices including GST cannot be calculated when %1 is %2.';
        Text003 : TextConst ENU='You cannot purchase resources.',ENA='You cannot purchase resources.';
        Text004 : TextConst ENU='must not be less than %1',ENA='must not be less than %1';
        Text006 : TextConst ENU='You cannot invoice more than %1 units.',ENA='You cannot invoice more than %1 units.';
        Text007 : TextConst ENU='You cannot invoice more than %1 base units.',ENA='You cannot invoice more than %1 base units.';
        Text008 : TextConst ENU='You cannot receive more than %1 units.',ENA='You cannot receive more than %1 units.';
        Text009 : TextConst ENU='You cannot receive more than %1 base units.',ENA='You cannot receive more than %1 base units.';
        Text010 : TextConst ENU='You cannot change %1 when %2 is %3.',ENA='You cannot change %1 when %2 is %3.';
        Text011 : TextConst ENU=' must be 0 when %1 is %2',ENA=' must be 0 when %1 is %2';
        Text012 : TextConst ENU='must not be specified when %1 = %2',ENA='must not be specified when %1 = %2';
        Text016 : TextConst ENU='%1 is required for %2 = %3.',ENA='%1 is required for %2 = %3.';
        Text017 : TextConst ENU='\The entered information may be disregarded by warehouse operations.',ENA='\The entered information may be disregarded by warehouse operations.';
        Text018 : TextConst ENU='%1 %2 is earlier than the work date %3.',ENA='%1 %2 is earlier than the work date %3.';
        Text020 : TextConst ENU='You cannot return more than %1 units.',ENA='You cannot return more than %1 units.';
        Text021 : TextConst ENU='You cannot return more than %1 base units.',ENA='You cannot return more than %1 base units.';
        Text022 : TextConst ENU='You cannot change %1, if item charge is already posted.',ENA='You cannot change %1, if item charge is already posted.';
        Text023 : TextConst ENU='You cannot change the %1 when the %2 has been filled in.',ENA='You cannot change the %1 when the %2 has been filled in.';
        Text029 : TextConst ENU='must be positive.',ENA='must be positive.';
        Text030 : TextConst ENU='must be negative.',ENA='must be negative.';
        Text031 : TextConst ENU='You cannot define item tracking on this line because it is linked to production order %1.',ENA='You cannot define item tracking on this line because it is linked to production order %1.';
        Text032 : TextConst ENU='%1 must not be greater than the sum of %2 and %3.',ENA='%1 must not be greater than the sum of %2 and %3.';
        Text033 : TextConst ENU='Warehouse ',ENA='Warehouse ';
        Text034 : TextConst ENU='Inventory ',ENA='Inventory ';
        Text035 : TextConst ENU='%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.',ENA='%1 units for %2 %3 have already been returned or transferred. Therefore, only %4 units can be returned.';
        Text037 : TextConst ENU='cannot be %1.',ENA='cannot be %1.';
        Text038 : TextConst ENU='cannot be less than %1.',ENA='cannot be less than %1.';
        Text039 : TextConst ENU='cannot be more than %1.',ENA='cannot be more than %1.';
        Text040 : TextConst ENU='You must use form %1 to enter %2, if item tracking is used.',ENA='You must use form %1 to enter %2, if item tracking is used.';
        Text99000000 : TextConst ENU='You cannot change %1 when the purchase order is associated to a production order.',ENA='You cannot change %1 when the purchase order is associated to a production order.';
        PurchHeader : Record "Purchase Header";
        PurchLine2 : Record "Purchase Line";
        GLAcc : Record "G/L Account";
        Item : Record Item;
        Currency : Record Currency;
        CurrExchRate : Record "Currency Exchange Rate";
        VATPostingSetup : Record "VAT Posting Setup";
        GenBusPostingGrp : Record "Gen. Business Posting Group";
        GenProdPostingGrp : Record "Gen. Product Posting Group";
        UnitOfMeasure : Record "Unit of Measure";
        ItemCharge : Record "Item Charge";
        SKU : Record "Stockkeeping Unit";
        WorkCenter : Record "Work Center";
        InvtSetup : Record "Inventory Setup";
        Location : Record Location;
        GLSetup : Record "General Ledger Setup";
        CalChange : Record "Customized Calendar Change";
        TempJobJnlLine : Record "Job Journal Line" temporary;
        PurchSetup : Record "Purchases & Payables Setup";
        ApplicationAreaSetup : Record "Application Area Setup";
        SalesTaxCalculate : Codeunit "Sales Tax Calculate";
        ReservEngineMgt : Codeunit "Reservation Engine Mgt.";
        ReservePurchLine : Codeunit "Purch. Line-Reserve";
        UOMMgt : Codeunit "Unit of Measure Management";
        AddOnIntegrMgt : Codeunit AddOnIntegrManagement;
        DimMgt : Codeunit DimensionManagement;
        DistIntegration : Codeunit "Dist. Integration";
        NonstockItemMgt : Codeunit "Nonstock Item Management";
        WhseValidateSourceLine : Codeunit "Whse. Validate Source Line";
        LeadTimeMgt : Codeunit "Lead-Time Management";
        PurchPriceCalcMgt : Codeunit "Purch. Price Calc. Mgt.";
        CalendarMgmt : Codeunit "Calendar Management";
        CheckDateConflict : Codeunit "Reservation-Check Date Confl.";
        DeferralUtilities : Codeunit "Deferral Utilities";
        TrackingBlocked : Boolean;
        StatusCheckSuspended : Boolean;
        GLSetupRead : Boolean;
        UnitCostCurrency : Decimal;
        UpdateFromVAT : Boolean;
        Text042 : TextConst ENU='You cannot return more than the %1 units that you have received for %2 %3.',ENA='You cannot return more than the %1 units that you have received for %2 %3.';
        Text043 : TextConst ENU='must be positive when %1 is not 0.',ENA='must be positive when %1 is not 0.';
        Text044 : TextConst ENU='You cannot change %1 because this purchase order is associated with %2 %3.',ENA='You cannot change %1 because this purchase order is associated with %2 %3.';
        Text046 : TextConst Comment='%1 - product name',ENU='%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?',ENA='%3 will not update %1 when changing %2 because a prepayment invoice has been posted. Do you want to continue?';
        Text047 : TextConst ENU='%1 can only be set when %2 is set.',ENA='%1 can only be set when %2 is set.';
        Text048 : TextConst ENU='%1 cannot be changed when %2 is set.',ENA='%1 cannot be changed when %2 is set.';
        PrePaymentLineAmountEntered : Boolean;
        Text049 : TextConst ENU='You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?',ENA='You have changed one or more dimensions on the %1, which is already shipped. When you post the line with the changed dimension to General Ledger, amounts on the Inventory Interim account will be out of balance when reported per dimension.\\Do you want to keep the changed dimension?';
        Text050 : TextConst ENU='Cancelled.',ENA='Cancelled.';
        Text051 : TextConst ENU='must have the same sign as the receipt',ENA='must have the same sign as the receipt';
        Text052 : TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in receipt %1.',ENA='The quantity that you are trying to invoice is greater than the quantity in receipt %1.';
        Text053 : TextConst ENU='must have the same sign as the return shipment',ENA='must have the same sign as the return shipment';
        Text054 : TextConst ENU='The quantity that you are trying to invoice is greater than the quantity in return shipment %1.',ENA='The quantity that you are trying to invoice is greater than the quantity in return shipment %1.';
        AddCurrency : Record Currency;
        BASManagement : Codeunit Codeunit11601;
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
        OnesText : array [20] of Text[30];
        TensText : array [10] of Text[30];
        ExponentText : array [5] of Text[30];
        CurrencyFactor : Decimal;
        VATAmt : Decimal;
        VATBase : Decimal;
        AnotherItemWithSameDescrQst : TextConst Comment='%1=Item no., %2=item description',ENU='Item No. %1 also has the description "%2".\Do you want to change the current item no. to %1?',ENA='Item No. %1 also has the description "%2".\Do you want to change the current item no. to %1?';
        DataConflictQst : TextConst ENU='The change creates a date conflict with existing reservations. Do you want to continue?',ENA='The change creates a date conflict with existing reservations. Do you want to continue?';
        PurchSetupRead : Boolean;
        ItemNoFieldCaptionTxt : TextConst ENU='Item',ENA='Item';

    procedure InitOutstanding();
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          "Outstanding Quantity" := Quantity - "Return Qty. Shipped";
          "Outstanding Qty. (Base)" := "Quantity (Base)" - "Return Qty. Shipped (Base)";
          "Return Qty. Shipped Not Invd." := "Return Qty. Shipped" - "Quantity Invoiced";
          "Ret. Qty. Shpd Not Invd.(Base)" := "Return Qty. Shipped (Base)" - "Qty. Invoiced (Base)";
        END ELSE BEGIN
          "Outstanding Quantity" := Quantity - "Quantity Received";
          "Outstanding Qty. (Base)" := "Quantity (Base)" - "Qty. Received (Base)";
          "Qty. Rcd. Not Invoiced" := "Quantity Received" - "Quantity Invoiced";
          "Qty. Rcd. Not Invoiced (Base)" := "Qty. Received (Base)" - "Qty. Invoiced (Base)";
        END;
        "Completely Received" := (Quantity <> 0) AND ("Outstanding Quantity" = 0);
        InitOutstandingAmount;
    end;

    procedure InitOutstandingAmount();
    var
        AmountInclVAT : Decimal;
        AmountInclVATACY : Decimal;
    begin
        IF Quantity = 0 THEN BEGIN
          "Outstanding Amount" := 0;
          "Outstanding Amount (LCY)" := 0;
          "Outstanding Amt. Ex. VAT (LCY)" := 0;
          "Amt. Rcd. Not Invoiced" := 0;
          "Amt. Rcd. Not Invoiced (LCY)" := 0;
          "Return Shpd. Not Invd." := 0;
          "Return Shpd. Not Invd. (LCY)" := 0;
        END ELSE BEGIN
          GetPurchHeader;
          AmountInclVAT := "Amount Including VAT";
          AmountInclVATACY := "Amount Including VAT (ACY)";
          VALIDATE(
            "Outstanding Amount",
            ROUND(
              AmountInclVAT * "Outstanding Quantity" / Quantity,
              Currency."Amount Rounding Precision"));
          IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
            VALIDATE(
              "Return Shpd. Not Invd.",
              ROUND(
                AmountInclVAT * "Return Qty. Shipped Not Invd." / Quantity,
                Currency."Amount Rounding Precision"))
          ELSE
            VALIDATE(
              "Amt. Rcd. Not Invoiced",
              ROUND(
                AmountInclVAT * "Qty. Rcd. Not Invoiced" / Quantity,
                Currency."Amount Rounding Precision"));
        END;
    end;

    procedure InitQtyToReceive();
    begin
        GetPurchSetup;
        IF (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) OR
           ("Document Type" = "Document Type"::Invoice)
        THEN BEGIN
          "Qty. to Receive" := "Outstanding Quantity";
          "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";
        END ELSE
          IF "Qty. to Receive" <> 0 THEN
            "Qty. to Receive (Base)" := CalcBaseQty("Qty. to Receive");

        InitQtyToInvoice;
    end;

    procedure InitQtyToShip();
    begin
        GetPurchSetup;
        IF (PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Remainder) OR
           ("Document Type" = "Document Type"::"Credit Memo")
        THEN BEGIN
          "Return Qty. to Ship" := "Outstanding Quantity";
          "Return Qty. to Ship (Base)" := "Outstanding Qty. (Base)";
        END ELSE
          IF "Return Qty. to Ship" <> 0 THEN
            "Return Qty. to Ship (Base)" := CalcBaseQty("Return Qty. to Ship");

        InitQtyToInvoice;
    end;

    procedure InitQtyToInvoice();
    begin
        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;
        CalcInvDiscToInvoice;
        IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN
          CalcPrepaymentToDeduct;
    end;

    local procedure InitItemAppl();
    begin
        "Appl.-to Item Entry" := 0;
    end;

    procedure MaxQtyToInvoice() : Decimal;
    begin
        IF "Prepayment Line" THEN
          EXIT(1);
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT("Return Qty. Shipped" + "Return Qty. to Ship" - "Quantity Invoiced");

        EXIT("Quantity Received" + "Qty. to Receive" - "Quantity Invoiced");
    end;

    procedure MaxQtyToInvoiceBase() : Decimal;
    begin
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          EXIT("Return Qty. Shipped (Base)" + "Return Qty. to Ship (Base)" - "Qty. Invoiced (Base)");

        EXIT("Qty. Received (Base)" + "Qty. to Receive (Base)" - "Qty. Invoiced (Base)");
    end;

    procedure CalcInvDiscToInvoice();
    var
        OldInvDiscAmtToInv : Decimal;
    begin
        GetPurchHeader;
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
          "Amount Including VAT (ACY)" := "Amount Including VAT (ACY)" - "VAT Difference (ACY)";
          "VAT Difference" := 0;
          "VAT Difference (ACY)" := 0;
        END;
    end;

    local procedure CalcBaseQty(Qty : Decimal) : Decimal;
    begin
        IF "Prod. Order No." = '' THEN
          TESTFIELD("Qty. per Unit of Measure");
        EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    local procedure SelectItemEntry();
    var
        ItemLedgEntry : Record "Item Ledger Entry";
    begin
        TESTFIELD("Prod. Order No.",'');
        ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SETRANGE("Item No.","No.");
        ItemLedgEntry.SETRANGE(Open,TRUE);
        ItemLedgEntry.SETRANGE(Positive,TRUE);
        IF "Location Code" <> '' THEN
          ItemLedgEntry.SETRANGE("Location Code","Location Code");
        ItemLedgEntry.SETRANGE("Variant Code","Variant Code");

        IF PAGE.RUNMODAL(PAGE::"Item Ledger Entries",ItemLedgEntry) = ACTION::LookupOK THEN
          VALIDATE("Appl.-to Item Entry",ItemLedgEntry."Entry No.");
    end;

    procedure SetPurchHeader(NewPurchHeader : Record "Purchase Header");
    begin
        PurchHeader := NewPurchHeader;

        IF PurchHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE BEGIN
          PurchHeader.TESTFIELD("Currency Factor");
          Currency.GET(PurchHeader."Currency Code");
          Currency.TESTFIELD("Amount Rounding Precision");
        END;
    end;

    local procedure GetPurchHeader();
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> PurchHeader."Document Type") OR ("Document No." <> PurchHeader."No.") THEN BEGIN
          PurchHeader.GET("Document Type","Document No.");
          IF PurchHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            PurchHeader.TESTFIELD("Currency Factor");
            Currency.GET(PurchHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
          GetGLSetup;
          CLEAR(CurrencyFactor);
          IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            AddCurrency.GET(GLSetup."Additional Reporting Currency");
            IF (PurchHeader."Vendor Exchange Rate (ACY)" <> 0) AND (PurchHeader."Currency Code" = '') THEN
              CurrencyFactor :=
                CurrExchRate.ExchangeRateFactorFRS21(
                  GetDate,GLSetup."Additional Reporting Currency",PurchHeader."Vendor Exchange Rate (ACY)")
            ELSE
              CurrencyFactor :=
                CurrExchRate.ExchangeRate(
                  GetDate,GLSetup."Additional Reporting Currency");
          END;
        END;
    end;

    local procedure GetItem();
    begin
        TESTFIELD("No.");
        IF Item."No." <> "No." THEN
          Item.GET("No.");
    end;

    local procedure UpdateDirectUnitCost(CalledByFieldNo : Integer);
    begin
        IF (CurrFieldNo <> 0) AND ("Prod. Order No." <> '') THEN
          UpdateAmounts;

        IF ((CalledByFieldNo <> CurrFieldNo) AND (CurrFieldNo <> 0)) OR
           ("Prod. Order No." <> '')
        THEN
          EXIT;

        IF Type = Type::Item THEN BEGIN
          GetPurchHeader;
          PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,CalledByFieldNo);
          PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
          VALIDATE("Direct Unit Cost");

          IF CalledByFieldNo IN [FIELDNO("No."),FIELDNO("Variant Code"),FIELDNO("Location Code")] THEN
            UpdateItemReference;
        END;
    end;

    procedure UpdateUnitCost();
    var
        DiscountAmountPerQty : Decimal;
    begin
        GetPurchHeader;
        GetGLSetup;
        IF Quantity = 0 THEN
          DiscountAmountPerQty := 0
        ELSE
          DiscountAmountPerQty :=
            ROUND(("Line Discount Amount" + "Inv. Discount Amount") / Quantity,
              GLSetup."Unit-Amount Rounding Precision");

        IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN
          "Unit Cost" := 0
        ELSE
          IF PurchHeader."Prices Including VAT" THEN
            "Unit Cost" :=
              ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) / (1 + "VAT %" / 100) +
              GetOverheadRateFCY - "VAT Difference"
          ELSE
            "Unit Cost" :=
              ("Direct Unit Cost" - DiscountAmountPerQty) * (1 + "Indirect Cost %" / 100) +
              GetOverheadRateFCY;

        IF PurchHeader."Currency Code" <> '' THEN BEGIN
          PurchHeader.TESTFIELD("Currency Factor");
          "Unit Cost (LCY)" :=
            CurrExchRate.ExchangeAmtFCYToLCY(
              GetDate,"Currency Code",
              "Unit Cost",PurchHeader."Currency Factor");
        END ELSE
          "Unit Cost (LCY)" := "Unit Cost";

        IF (Type = Type::Item) AND ("Prod. Order No." = '') THEN BEGIN
          GetItem;
          IF Item."Costing Method" = Item."Costing Method"::Standard THEN BEGIN
            IF GetSKU THEN
              "Unit Cost (LCY)" := SKU."Unit Cost" * "Qty. per Unit of Measure"
            ELSE
              "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
          END;
        END;

        "Unit Cost (LCY)" := ROUND("Unit Cost (LCY)",GLSetup."Unit-Amount Rounding Precision");
        IF PurchHeader."Currency Code" <> '' THEN
          Currency.TESTFIELD("Unit-Amount Rounding Precision");
        "Unit Cost" := ROUND("Unit Cost",Currency."Unit-Amount Rounding Precision");

        UpdateSalesCost;

        IF JobTaskIsSet AND NOT UpdateFromVAT AND NOT "Prepayment Line" THEN BEGIN
          CreateTempJobJnlLine(FALSE);
          TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
          UpdateJobPrices;
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
        GetPurchHeader;

        VATBaseAmount := "VAT Base Amount";
        "Recalculate Invoice Disc." := TRUE;

        IF "Line Amount" <> xRec."Line Amount" THEN BEGIN
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
        END;
        IF "Line Amount" <> ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount" THEN BEGIN
          "Line Amount" :=
            ROUND(Quantity * "Direct Unit Cost",Currency."Amount Rounding Precision") - "Line Discount Amount";
          IF (PurchHeader."Vendor Exchange Rate (ACY)" <> 0) OR
             ((PurchHeader."Vendor Exchange Rate (ACY)" = 1) AND
              (PurchHeader."Currency Code" <> GLSetup."Additional Reporting Currency"))
          THEN
            "Amount (ACY)" :=
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCY(
                  PurchHeader."Posting Date",GLSetup."Additional Reporting Currency",
                  ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                      PurchHeader."Posting Date",PurchHeader."Currency Code","Line Amount",
                      PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                AddCurrency."Amount Rounding Precision");
          "VAT Difference" := 0;
          LineAmountChanged := TRUE;
          "VAT Difference (ACY)" := 0;
        END;

        IF NOT "Prepayment Line" THEN BEGIN
          IF "Prepayment %" <> 0 THEN BEGIN
            IF Quantity < 0 THEN
              FIELDERROR(Quantity,STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
            IF "Direct Unit Cost" < 0 THEN
              FIELDERROR("Direct Unit Cost",STRSUBSTNO(Text043,FIELDCAPTION("Prepayment %")));
          END;
          IF PurchHeader."Document Type" <> PurchHeader."Document Type"::Invoice THEN BEGIN
            "Prepayment VAT Difference" := 0;
            IF NOT PrePaymentLineAmountEntered THEN
              IF NOT CalculateFullGST("Prepmt. Line Amount") THEN
                "Prepmt. Line Amount" := ROUND("Line Amount" * "Prepayment %" / 100,Currency."Amount Rounding Precision");
            IF "Prepmt. Line Amount" < "Prepmt. Amt. Inv." THEN
              FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text037,"Prepmt. Amt. Inv."));
            PrePaymentLineAmountEntered := FALSE;
            IF "Prepmt. Line Amount" <> 0 THEN BEGIN
              RemLineAmountToInvoice :=
                ROUND("Line Amount" * (Quantity - "Quantity Invoiced") / Quantity,Currency."Amount Rounding Precision");
              IF RemLineAmountToInvoice < ("Prepmt. Line Amount" - "Prepmt Amt Deducted") THEN
                FIELDERROR("Prepmt. Line Amount",STRSUBSTNO(Text039,RemLineAmountToInvoice + "Prepmt Amt Deducted"));
            END;
          END ELSE
            IF (CurrFieldNo <> 0) AND ("Line Amount" <> xRec."Line Amount") AND
               ("Prepmt. Amt. Inv." <> 0) AND ("Prepayment %" = 100)
            THEN BEGIN
              IF "Line Amount" < xRec."Line Amount" THEN
                FIELDERROR("Line Amount",STRSUBSTNO(Text038,xRec."Line Amount"));
              FIELDERROR("Line Amount",STRSUBSTNO(Text039,xRec."Line Amount"));
            END;
        END;
        UpdateVATAmounts;
        IF VATBaseAmount <> "VAT Base Amount" THEN
          LineAmountChanged := TRUE;

        IF LineAmountChanged THEN BEGIN
          UpdateDeferralAmounts;
          LineAmountChanged := FALSE;
        END;

        InitOutstandingAmount;

        IF Type = Type::"Charge (Item)" THEN
          UpdateItemChargeAssgnt;

        CalcPrepaymentToDeduct;
    end;

    local procedure UpdateVATAmounts();
    var
        PurchLine2 : Record "Purchase Line";
        TotalLineAmount : Decimal;
        TotalInvDiscAmount : Decimal;
        TotalAmount : Decimal;
        TotalAmountInclVAT : Decimal;
        TotalQuantityBase : Decimal;
        TotalLineAmountACY : Decimal;
        TotalAmountInclVATACY : Decimal;
    begin
        GetPurchHeader;
        PurchLine2.SETRANGE("Document Type","Document Type");
        PurchLine2.SETRANGE("Document No.","Document No.");
        PurchLine2.SETFILTER("Line No.",'<>%1',"Line No.");
        IF "Line Amount" = 0 THEN
          IF xRec."Line Amount" >= 0 THEN
            PurchLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            PurchLine2.SETFILTER(Amount,'<%1',0)
        ELSE
          IF "Line Amount" > 0 THEN
            PurchLine2.SETFILTER(Amount,'>%1',0)
          ELSE
            PurchLine2.SETFILTER(Amount,'<%1',0);
        PurchLine2.SETRANGE("VAT Identifier","VAT Identifier");
        PurchLine2.SETRANGE("Tax Group Code","Tax Group Code");

        IF "Line Amount" = "Inv. Discount Amount" THEN BEGIN
          Amount := 0;
          "VAT Base Amount" := 0;
          "Amount Including VAT" := 0;
          "VAT Base (ACY)" := 0;
          "Amount Including VAT (ACY)" := 0;
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
            IF NOT PurchLine2.ISEMPTY THEN BEGIN
              PurchLine2.CALCSUMS(
                "Line Amount","Inv. Discount Amount",Amount,"Amount Including VAT",
                "Quantity (Base)","Amount Including VAT (ACY)","Amount (ACY)");
              TotalLineAmount := PurchLine2."Line Amount";
              TotalInvDiscAmount := PurchLine2."Inv. Discount Amount";
              TotalAmount := PurchLine2.Amount;
              TotalAmountInclVAT := PurchLine2."Amount Including VAT";
              TotalQuantityBase := PurchLine2."Quantity (Base)";
              TotalLineAmountACY := PurchLine2."Amount (ACY)";
              TotalAmountInclVATACY := PurchLine2."Amount Including VAT (ACY)";
            END;

          IF PurchHeader."Prices Including VAT" THEN
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
                      Amount * (1 - PurchHeader."VAT Base Discount %" / 100),
                      Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalLineAmount + "Line Amount" -
                    ROUND(
                      (TotalAmount + Amount) * (PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
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
                  PurchHeader.TESTFIELD("VAT Base Discount %",0);
                  "Amount Including VAT" :=
                    ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  IF "Use Tax" THEN
                    Amount := "Amount Including VAT"
                  ELSE
                    Amount :=
                      ROUND(
                        SalesTaxCalculate.ReverseCalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                          TotalAmountInclVAT + "Amount Including VAT",TotalQuantityBase + "Quantity (Base)",
                          PurchHeader."Currency Factor"),
                        Currency."Amount Rounding Precision") -
                      TotalAmount;
                  "VAT Base Amount" := Amount;
                  IF "VAT Base Amount" <> 0 THEN
                    "VAT %" :=
                      ROUND(100 * ("Amount Including VAT" - "VAT Base Amount") / "VAT Base Amount",0.00001)
                  ELSE
                    "VAT %" := 0;
                END;
            END
          ELSE
            CASE "VAT Calculation Type" OF
              "VAT Calculation Type"::"Normal VAT",
              "VAT Calculation Type"::"Reverse Charge VAT":
                BEGIN
                  Amount := ROUND("Line Amount" - "Inv. Discount Amount",Currency."Amount Rounding Precision");
                  "VAT Base Amount" :=
                    ROUND(Amount * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT" :=
                    TotalAmount + Amount +
                    ROUND(
                      (TotalAmount + Amount) * (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVAT;
                  "Amount (ACY)" :=
                    ROUND(
                      CurrExchRate.ExchangeAmtLCYToFCY(
                        PurchHeader."Posting Date",GLSetup."Additional Reporting Currency",
                        ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            PurchHeader."Posting Date",PurchHeader."Currency Code",Amount,
                            PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                      AddCurrency."Amount Rounding Precision");
                  "VAT Base (ACY)" :=
                    ROUND("Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100),Currency."Amount Rounding Precision");
                  "Amount Including VAT (ACY)" :=
                    TotalLineAmountACY + "Amount (ACY)" +
                    ROUND(
                      (TotalLineAmountACY + "Amount (ACY)") * (1 - PurchHeader."VAT Base Discount %" / 100) * "VAT %" / 100,
                      Currency."Amount Rounding Precision",Currency.VATRoundingDirection) -
                    TotalAmountInclVATACY;
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
                  IF "Use Tax" THEN
                    "Amount Including VAT" := Amount
                  ELSE
                    "Amount Including VAT" :=
                      TotalAmount + Amount +
                      ROUND(
                        SalesTaxCalculate.CalculateTax(
                          "Tax Area Code","Tax Group Code","Tax Liable",PurchHeader."Posting Date",
                          TotalAmount + Amount,TotalQuantityBase + "Quantity (Base)",
                          PurchHeader."Currency Factor"),
                        Currency."Amount Rounding Precision") -
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

    procedure UpdatePrepmtSetupFields();
    var
        GenPostingSetup : Record "General Posting Setup";
        GLAcc : Record "G/L Account";
    begin
        IF ("Prepayment %" <> 0) AND (Type <> Type::" ") THEN BEGIN
          TESTFIELD("Document Type","Document Type"::Order);
          TESTFIELD("No.");
          GenPostingSetup.GET("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
          IF GenPostingSetup."Purch. Prepayments Account" <> '' THEN BEGIN
            GLAcc.GET(GenPostingSetup."Purch. Prepayments Account");
            IF NOT BASManagement.VendorRegistered("Buy-from Vendor No.") THEN
              VATPostingSetup.GET(
                "VAT Bus. Posting Group",
                BASManagement.GetUnregGSTProdPostGroup("VAT Bus. Posting Group","Buy-from Vendor No."))
            ELSE BEGIN
              GetGLSetup;
              IF GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
                GLAcc.TESTFIELD("VAT Prod. Posting Group","VAT Prod. Posting Group");
              VATPostingSetup.GET("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
            END;
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

    local procedure UpdateSalesCost();
    var
        SalesOrderLine : Record "Sales Line";
    begin
        CASE TRUE OF
          "Sales Order Line No." <> 0:
            // Drop Shipment
            SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Sales Order No.","Sales Order Line No.");
          "Special Order Sales Line No." <> 0:
            // Special Order
            BEGIN
              IF NOT
                 SalesOrderLine.GET(SalesOrderLine."Document Type"::Order,"Special Order Sales No.","Special Order Sales Line No.")
              THEN
                EXIT;
            END;
          ELSE
            EXIT;
        END;
        SalesOrderLine."Unit Cost (LCY)" := "Unit Cost (LCY)" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
        SalesOrderLine."Unit Cost" := "Unit Cost" * SalesOrderLine."Qty. per Unit of Measure" / "Qty. per Unit of Measure";
        SalesOrderLine.VALIDATE("Unit Cost (LCY)");
        SalesOrderLine.MODIFY;
    end;

    local procedure GetFAPostingGroup();
    var
        LocalGLAcc : Record "G/L Account";
        FAPostingGr : Record "FA Posting Group";
        FADeprBook : Record "FA Depreciation Book";
        FASetup : Record "FA Setup";
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
        IF "FA Posting Type" = "FA Posting Type"::" " THEN
          "FA Posting Type" := "FA Posting Type"::"Acquisition Cost";
        FADeprBook.GET("No.","Depreciation Book Code");
        FADeprBook.TESTFIELD("FA Posting Group");
        FAPostingGr.GET(FADeprBook."FA Posting Group");
        IF "FA Posting Type" = "FA Posting Type"::"Acquisition Cost" THEN BEGIN
          FAPostingGr.TESTFIELD("Acquisition Cost Account");
          LocalGLAcc.GET(FAPostingGr."Acquisition Cost Account");
        END ELSE BEGIN
          FAPostingGr.TESTFIELD("Maintenance Expense Account");
          LocalGLAcc.GET(FAPostingGr."Maintenance Expense Account");
        END;
        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TESTFIELD("Gen. Prod. Posting Group");
        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        "Tax Group Code" := LocalGLAcc."Tax Group Code";
        IF BASManagement.VendorRegistered("Buy-from Vendor No.") THEN
          "VAT Prod. Posting Group" := LocalGLAcc."VAT Prod. Posting Group"
        ELSE
          "VAT Prod. Posting Group" := BASManagement.GetUnregGSTProdPostGroup("VAT Bus. Posting Group","Buy-from Vendor No.");
        VALIDATE("VAT Prod. Posting Group")
    end;

    procedure UpdateUOMQtyPerStockQty();
    begin
        GetItem;
        "Unit Cost (LCY)" := Item."Unit Cost" * "Qty. per Unit of Measure";
        "Unit Price (LCY)" := Item."Unit Price" * "Qty. per Unit of Measure";
        GetPurchHeader;
        IF PurchHeader."Currency Code" <> '' THEN
          "Unit Cost" :=
            CurrExchRate.ExchangeAmtLCYToFCY(
              GetDate,PurchHeader."Currency Code",
              "Unit Cost (LCY)",PurchHeader."Currency Factor")
        ELSE
          "Unit Cost" := "Unit Cost (LCY)";
        UpdateDirectUnitCost(FIELDNO("Unit of Measure Code"));
    end;

    procedure ShowReservation();
    var
        Reservation : Page Reservation;
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("Prod. Order No.",'');
        TESTFIELD("No.");
        CLEAR(Reservation);
        Reservation.SetPurchLine(Rec);
        Reservation.RUNMODAL;
    end;

    procedure ShowReservationEntries(Modal : Boolean);
    var
        ReservEntry : Record "Reservation Entry";
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,TRUE);
        ReservePurchLine.FilterReservFor(ReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Reservation Entries",ReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Reservation Entries",ReservEntry);
    end;

    procedure GetDate() : Date;
    begin
        IF PurchHeader."Posting Date" <> 0D THEN
          EXIT(PurchHeader."Posting Date");
        EXIT(WORKDATE);
    end;

    procedure Signed(Value : Decimal) : Decimal;
    begin
        CASE "Document Type" OF
          "Document Type"::Quote,
          "Document Type"::Order,
          "Document Type"::Invoice,
          "Document Type"::"Blanket Order":
            EXIT(Value);
          "Document Type"::"Return Order",
          "Document Type"::"Credit Memo":
            EXIT(-Value);
        END;
    end;

    procedure BlanketOrderLookup();
    begin
        PurchLine2.RESET;
        PurchLine2.SETCURRENTKEY("Document Type",Type,"No.");
        PurchLine2.SETRANGE("Document Type","Document Type"::"Blanket Order");
        PurchLine2.SETRANGE(Type,Type);
        PurchLine2.SETRANGE("No.","No.");
        PurchLine2.SETRANGE("Pay-to Vendor No.","Pay-to Vendor No.");
        PurchLine2.SETRANGE("Buy-from Vendor No.","Buy-from Vendor No.");
        IF PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine2) = ACTION::LookupOK THEN BEGIN
          PurchLine2.TESTFIELD("Document Type","Document Type"::"Blanket Order");
          "Blanket Order No." := PurchLine2."Document No.";
          VALIDATE("Blanket Order Line No.",PurchLine2."Line No.");
        END;
    end;

    procedure BlockDynamicTracking(SetBlock : Boolean);
    begin
        TrackingBlocked := SetBlock;
        ReservePurchLine.Block(SetBlock);
    end;

    procedure ShowDimensions();
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document Type","Document No.","Line No."));
        VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure OpenItemTrackingLines();
    begin
        TESTFIELD(Type,Type::Item);
        TESTFIELD("No.");
        IF "Prod. Order No." <> '' THEN
          ERROR(Text031,"Prod. Order No.");

        TESTFIELD("Quantity (Base)");

        ReservePurchLine.CallItemTracking(Rec);
    end;

    procedure CreateDim(Type1 : Integer;No1 : Code[20];Type2 : Integer;No2 : Code[20];Type3 : Integer;No3 : Code[20];Type4 : Integer;No4 : Code[20]);
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
        TableID[4] := Type4;
        No[4] := No4;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetPurchHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
            PurchHeader."Dimension Set ID",DATABASE::Vendor);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
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

    local procedure GetSKU() : Boolean;
    begin
        TESTFIELD("No.");
        IF (SKU."Location Code" = "Location Code") AND
           (SKU."Item No." = "No.") AND
           (SKU."Variant Code" = "Variant Code")
        THEN
          EXIT(TRUE);
        IF SKU.GET("Location Code","No.","Variant Code") THEN
          EXIT(TRUE);

        EXIT(FALSE);
    end;

    procedure ShowItemChargeAssgnt();
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch : Codeunit "Item Charge Assgnt. (Purch.)";
        ItemChargeAssgnts : Page "Item Charge Assignment (Purch)";
        ItemChargeAssgntLineAmt : Decimal;
    begin
        GET("Document Type","Document No.","Line No.");
        TESTFIELD(Type,Type::"Charge (Item)");
        TESTFIELD("No.");
        TESTFIELD(Quantity);

        GetPurchHeader;
        IF PurchHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(PurchHeader."Currency Code");
        IF ("Inv. Discount Amount" = 0) AND
           ("Line Discount Amount" = 0) AND
           (NOT PurchHeader."Prices Including VAT")
        THEN
          ItemChargeAssgntLineAmt := "Line Amount"
        ELSE
          IF PurchHeader."Prices Including VAT" THEN
            ItemChargeAssgntLineAmt :=
              ROUND(("Line Amount" - "Inv. Discount Amount") / (1 + "VAT %" / 100),
                Currency."Amount Rounding Precision")
          ELSE
            ItemChargeAssgntLineAmt := "Line Amount" - "Inv. Discount Amount";

        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
        ItemChargeAssgntPurch.SETRANGE("Item Charge No.","No.");
        IF NOT ItemChargeAssgntPurch.FINDLAST THEN BEGIN
          ItemChargeAssgntPurch."Document Type" := "Document Type";
          ItemChargeAssgntPurch."Document No." := "Document No.";
          ItemChargeAssgntPurch."Document Line No." := "Line No.";
          ItemChargeAssgntPurch."Item Charge No." := "No.";
          ItemChargeAssgntPurch."Unit Cost" :=
            ROUND(ItemChargeAssgntLineAmt / Quantity,
              Currency."Unit-Amount Rounding Precision");
        END;

        ItemChargeAssgntLineAmt :=
          ROUND(
            ItemChargeAssgntLineAmt * ("Qty. to Invoice" / Quantity),
            Currency."Amount Rounding Precision");

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Return Shipment No.")
        ELSE
          AssignItemChargePurch.CreateDocChargeAssgnt(ItemChargeAssgntPurch,"Receipt No.");
        CLEAR(AssignItemChargePurch);
        COMMIT;

        ItemChargeAssgnts.Initialize(Rec,ItemChargeAssgntLineAmt);
        ItemChargeAssgnts.RUNMODAL;
        CALCFIELDS("Qty. to Assign");
    end;

    procedure UpdateItemChargeAssgnt();
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
        ShareOfVAT : Decimal;
        TotalQtyToAssign : Decimal;
        TotalAmtToAssign : Decimal;
    begin
        IF "Document Type" = "Document Type"::"Blanket Order" THEN
          EXIT;

        CALCFIELDS("Qty. Assigned","Qty. to Assign");
        IF ABS("Quantity Invoiced") > ABS(("Qty. Assigned" + "Qty. to Assign")) THEN
          ERROR(Text032,FIELDCAPTION("Quantity Invoiced"),FIELDCAPTION("Qty. Assigned"),FIELDCAPTION("Qty. to Assign"));

        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        ItemChargeAssgntPurch.SETRANGE("Document Line No.","Line No.");
        ItemChargeAssgntPurch.CALCSUMS("Qty. to Assign");
        TotalQtyToAssign := ItemChargeAssgntPurch."Qty. to Assign";
        IF (CurrFieldNo <> 0) AND ("Unit Cost" <> xRec."Unit Cost") THEN BEGIN
          ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
          IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
            ERROR(Text022,
              FIELDCAPTION("Unit Cost"));
          ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
        END;

        IF (CurrFieldNo <> 0) AND (Quantity <> xRec.Quantity) THEN BEGIN
          ItemChargeAssgntPurch.SETFILTER("Qty. Assigned",'<>0');
          IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
            ERROR(Text022,
              FIELDCAPTION(Quantity));
          ItemChargeAssgntPurch.SETRANGE("Qty. Assigned");
        END;

        IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
          GetPurchHeader;
          TotalAmtToAssign := CalcTotalAmtToAssign(TotalQtyToAssign);
          REPEAT
            ShareOfVAT := 1;
            IF PurchHeader."Prices Including VAT" THEN
              ShareOfVAT := 1 + "VAT %" / 100;
            IF Quantity <> 0 THEN
              IF ItemChargeAssgntPurch."Unit Cost" <> ROUND(
                   ("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                   Currency."Unit-Amount Rounding Precision")
              THEN
                ItemChargeAssgntPurch."Unit Cost" :=
                  ROUND(("Line Amount" - "Inv. Discount Amount") / Quantity / ShareOfVAT,
                    Currency."Unit-Amount Rounding Precision");
            IF TotalQtyToAssign <> 0 THEN BEGIN
              ItemChargeAssgntPurch."Amount to Assign" :=
                ROUND(ItemChargeAssgntPurch."Qty. to Assign" / TotalQtyToAssign * TotalAmtToAssign,
                  Currency."Amount Rounding Precision");
              TotalQtyToAssign -= ItemChargeAssgntPurch."Qty. to Assign";
              TotalAmtToAssign -= ItemChargeAssgntPurch."Amount to Assign";
            END;
            ItemChargeAssgntPurch.MODIFY;
          UNTIL ItemChargeAssgntPurch.NEXT = 0;
          CALCFIELDS("Qty. to Assign");
        END;
    end;

    local procedure DeleteItemChargeAssgnt(DocType : Option;DocNo : Code[20];DocLineNo : Integer);
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
    begin
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",DocType);
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",DocNo);
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.",DocLineNo);
        IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
          ItemChargeAssgntPurch.DELETEALL(TRUE);
    end;

    local procedure DeleteChargeChargeAssgnt(DocType : Option;DocNo : Code[20];DocLineNo : Integer);
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
    begin
        IF DocType <> "Document Type"::"Blanket Order" THEN
          IF "Quantity Invoiced" <> 0 THEN BEGIN
            CALCFIELDS("Qty. Assigned");
            TESTFIELD("Qty. Assigned","Quantity Invoiced");
          END;

        ItemChargeAssgntPurch.RESET;
        ItemChargeAssgntPurch.SETRANGE("Document Type",DocType);
        ItemChargeAssgntPurch.SETRANGE("Document No.",DocNo);
        ItemChargeAssgntPurch.SETRANGE("Document Line No.",DocLineNo);
        IF NOT ItemChargeAssgntPurch.ISEMPTY THEN
          ItemChargeAssgntPurch.DELETEALL;
    end;

    procedure CheckItemChargeAssgnt();
    var
        ItemChargeAssgntPurch : Record "Item Charge Assignment (Purch)";
    begin
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.","Document No.");
        ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Line No.","Line No.");
        ItemChargeAssgntPurch.SETRANGE("Document Type","Document Type");
        ItemChargeAssgntPurch.SETRANGE("Document No.","Document No.");
        IF ItemChargeAssgntPurch.FINDSET THEN BEGIN
          TESTFIELD("Allow Item Charge Assignment");
          REPEAT
            ItemChargeAssgntPurch.TESTFIELD("Qty. to Assign",0);
          UNTIL ItemChargeAssgntPurch.NEXT = 0;
        END;
    end;

    local procedure GetFieldCaption(FieldNumber : Integer) : Text[100];
    var
        "Field" : Record "Field";
    begin
        Field.GET(DATABASE::"Purchase Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber : Integer) : Text[80];
    begin
        IF NOT PurchHeader.GET("Document Type","Document No.") THEN BEGIN
          PurchHeader."No." := '';
          PurchHeader.INIT;
        END;
        CASE FieldNumber OF
          FIELDNO("No."):
            BEGIN
              IF ApplicationAreaSetup.IsFoundationEnabled THEN
                EXIT(STRSUBSTNO('3,%1',ItemNoFieldCaptionTxt));
              EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
            END;
          ELSE BEGIN
            IF PurchHeader."Prices Including VAT" THEN
              EXIT('2,1,' + GetFieldCaption(FieldNumber));
            EXIT('2,0,' + GetFieldCaption(FieldNumber));
          END
        END;
    end;

    local procedure TestStatusOpen();
    begin
        IF StatusCheckSuspended THEN
          EXIT;
        GetPurchHeader;
        IF NOT "System-Created Entry" THEN
          IF Type <> Type::" " THEN
            PurchHeader.TESTFIELD(Status,PurchHeader.Status::Open);
    end;

    procedure SuspendStatusCheck(Suspend : Boolean);
    begin
        StatusCheckSuspended := Suspend;
    end;

    procedure UpdateLeadTimeFields();
    begin
        IF Type = Type::Item THEN BEGIN
          GetPurchHeader;

          EVALUATE("Lead Time Calculation",
            LeadTimeMgt.PurchaseLeadTime(
              "No.","Location Code","Variant Code",
              "Buy-from Vendor No."));
          IF FORMAT("Lead Time Calculation") = '' THEN
            "Lead Time Calculation" := PurchHeader."Lead Time Calculation";
          EVALUATE("Safety Lead Time",LeadTimeMgt.SafetyLeadTime("No.","Location Code","Variant Code"));
        END;
    end;

    procedure GetUpdateBasicDates();
    begin
        GetPurchHeader;
        IF PurchHeader."Expected Receipt Date" <> 0D THEN
          VALIDATE("Expected Receipt Date",PurchHeader."Expected Receipt Date")
        ELSE
          VALIDATE("Order Date",PurchHeader."Order Date");
    end;

    procedure UpdateDates();
    begin
        IF "Promised Receipt Date" <> 0D THEN
          VALIDATE("Promised Receipt Date")
        ELSE
          IF "Requested Receipt Date" <> 0D THEN
            VALIDATE("Requested Receipt Date")
          ELSE
            GetUpdateBasicDates;
    end;

    procedure InternalLeadTimeDays(PurchDate : Date) : Text[30];
    var
        TotalDays : DateFormula;
    begin
        EVALUATE(
          TotalDays,'<' + FORMAT(CALCDATE("Safety Lead Time",CALCDATE("Inbound Whse. Handling Time",PurchDate)) - PurchDate) + 'D>');
        EXIT(FORMAT(TotalDays));
    end;

    procedure UpdateVATOnLines(QtyType : Option General,Invoicing,Shipping;var PurchHeader : Record "Purchase Header";var PurchLine : Record "Purchase Line";var VATAmountLine : Record "VAT Amount Line") LineWasModified : Boolean;
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
        NewAmountACY : Decimal;
        NewAmountIncludingVATACY : Decimal;
        NewVATBaseAmountACY : Decimal;
        VATAmountACY : Decimal;
        VATDifferenceACY : Decimal;
        LineAmountToInvoiceACY : Decimal;
        AddCurrency : Record Currency;
        CurrencyFactor : Decimal;
        UseDate : Date;
        FullGST : Boolean;
        LineAmountToInvoiceDiscounted : Decimal;
        DeferralAmount : Decimal;
    begin
        LineWasModified := FALSE;
        IF QtyType = QtyType::Shipping THEN
          EXIT;
        IF PurchHeader."Currency Code" = '' THEN
          Currency.InitRoundingPrecision
        ELSE
          Currency.GET(PurchHeader."Currency Code");
        GetGLSetup;
        UseDate := PurchHeader."Posting Date";
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
          AddCurrency.GET(GLSetup."Additional Reporting Currency");
          IF UseDate <> 0D THEN
            IF (PurchHeader."Vendor Exchange Rate (ACY)" <> 0) AND (PurchHeader."Currency Code" = '') THEN
              CurrencyFactor :=
                CurrExchRate.ExchangeRateFactorFRS21(
                  UseDate,GLSetup."Additional Reporting Currency",PurchHeader."Vendor Exchange Rate (ACY)")
            ELSE
              CurrencyFactor :=
                CurrExchRate.ExchangeRate(
                  UseDate,GLSetup."Additional Reporting Currency");
        END;

        TempVATAmountLineRemainder.DELETEALL;

        WITH PurchLine DO BEGIN
          SETRANGE("Document Type",PurchHeader."Document Type");
          SETRANGE("Document No.",PurchHeader."No.");
          LOCKTABLE;
          IF FINDSET THEN
            REPEAT
              IF NOT ZeroAmountLine(QtyType) THEN BEGIN
                FullGST :=
                  ("Prepayment Line" OR ("Prepmt. Line Amount" <> 0)) AND
                  GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
                DeferralAmount := GetDeferralAmount;
                VATAmountLine.GET("VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0,FullGST);
                IF VATAmountLine.Modified OR (PurchHeader."Vendor Exchange Rate (ACY)" <> 0) THEN BEGIN
                  IF NOT TempVATAmountLineRemainder.GET(
                       "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0,FullGST)
                  THEN BEGIN
                    TempVATAmountLineRemainder := VATAmountLine;
                    TempVATAmountLineRemainder.INIT;
                    TempVATAmountLineRemainder.INSERT;
                  END;

                  IF QtyType = QtyType::General THEN BEGIN
                    LineAmountToInvoice := "Line Amount";
                    LineAmountToInvoiceACY := "Amount (ACY)";
                  END ELSE BEGIN
                    LineAmountToInvoice :=
                      ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                    LineAmountToInvoiceACY :=
                      ROUND("Amount (ACY)" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                  END;

                  IF "Allow Invoice Disc." THEN BEGIN
                    IF (VATAmountLine."Inv. Disc. Base Amount" = 0) OR (LineAmountToInvoice = 0) THEN
                      InvDiscAmount := 0
                    ELSE BEGIN
                      IF QtyType = QtyType::General THEN BEGIN
                        LineAmountToInvoice := "Line Amount";
                        LineAmountToInvoiceACY := "Amount (ACY)";
                      END ELSE BEGIN
                        LineAmountToInvoice :=
                          ROUND("Line Amount" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                        LineAmountToInvoiceACY :=
                          ROUND("Amount (ACY)" * "Qty. to Invoice" / Quantity,Currency."Amount Rounding Precision");
                      END;
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
                    IF PurchHeader."Prices Including VAT" THEN BEGIN
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
                          NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                    END ELSE BEGIN
                      IF "VAT Calculation Type" = "VAT Calculation Type"::"Full VAT" THEN BEGIN
                        VATAmount := "Line Amount" - "Inv. Discount Amount";
                        IF ((GLSetup."Additional Reporting Currency" <> '') AND
                            (PurchHeader."Currency Code" = GLSetup."Additional Reporting Currency") AND
                            (PurchHeader."Vendor Exchange Rate (ACY)" = 0))
                        THEN
                          VATAmountACY := TempVATAmountLineRemainder."VAT Amount (ACY)" +
                            ROUND(VATAmount,Currency."Amount Rounding Precision")
                        ELSE
                          VATAmountACY :=
                            TempVATAmountLineRemainder."VAT Amount (ACY)" +
                            ROUND(
                              CurrExchRate.ExchangeAmtLCYToFCY(
                                UseDate,GLSetup."Additional Reporting Currency",
                                ROUND(
                                  CurrExchRate.ExchangeAmtFCYToLCY(
                                    UseDate,PurchHeader."Currency Code",VATAmount,
                                    PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                              AddCurrency."Amount Rounding Precision");
                        NewAmount := 0;
                        NewAmountACY := 0;
                        NewVATBaseAmount := 0;
                        NewVATBaseAmountACY := 0;
                      END ELSE BEGIN
                        NewAmount := "Line Amount" - "Inv. Discount Amount";
                        NewAmountACY :=
                          ROUND(VATAmountLine."Amount (ACY)",AddCurrency."Amount Rounding Precision");
                        NewVATBaseAmount :=
                          ROUND(
                            NewAmount * (1 - PurchHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision");
                        NewVATBaseAmountACY :=
                          ROUND(
                            NewAmountACY * (1 - PurchHeader."VAT Base Discount %" / 100),
                            AddCurrency."Amount Rounding Precision");

                        IF VATAmountLine."VAT Base" = 0 THEN
                          VATAmount := 0
                        ELSE
                          VATAmount :=
                            TempVATAmountLineRemainder."VAT Amount" +
                            VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";

                        IF VATAmountLine."VAT Base (ACY)" = 0 THEN
                          VATAmountACY := 0
                        ELSE
                          VATAmountACY :=
                            TempVATAmountLineRemainder."VAT Amount (ACY)" +
                            VATAmountLine."VAT Amount (ACY)" * NewAmountACY / VATAmountLine."VAT Base (ACY)";
                      END;
                      NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                      NewAmountIncludingVATACY := NewAmountACY + ROUND(VATAmountACY,AddCurrency."Amount Rounding Precision");
                    END
                  ELSE BEGIN
                    IF (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 THEN BEGIN
                      VATDifference := 0;
                      VATDifferenceACY := 0;
                    END ELSE BEGIN
                      VATDifference :=
                        TempVATAmountLineRemainder."VAT Difference" +
                        VATAmountLine."VAT Difference" * (LineAmountToInvoice - InvDiscAmount) /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                      VATDifferenceACY :=
                        TempVATAmountLineRemainder."VAT Difference (ACY)" +
                        VATAmountLine."VAT Difference (ACY)" * (LineAmountToInvoice - InvDiscAmount) /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount");
                    END;
                    IF LineAmountToInvoice = 0 THEN BEGIN
                      "VAT Difference" := 0;
                      "VAT Difference (ACY)" := 0;
                    END ELSE BEGIN
                      "VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");
                      "VAT Difference (ACY)" := ROUND(VATDifferenceACY,Currency."Amount Rounding Precision");
                    END;
                  END;

                  IF QtyType = QtyType::General THEN BEGIN
                    Amount := NewAmount;
                    "Amount Including VAT" := ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                    "VAT Base Amount" := NewVATBaseAmount;
                    "Amount Including VAT (ACY)" := ROUND(NewAmountIncludingVATACY,AddCurrency."Amount Rounding Precision");
                    "VAT Base (ACY)" := NewVATBaseAmountACY;
                    "Amount (ACY)" := NewAmountACY;
                  END;
                  InitOutstanding;
                  IF NOT ((Type = Type::"Charge (Item)") AND ("Quantity Invoiced" <> "Qty. Assigned")) THEN BEGIN
                    SetUpdateFromVAT(TRUE);
                    UpdateUnitCost;
                  END;
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
                  TempVATAmountLineRemainder."Amount Including VAT (ACY)" :=
                    NewAmountIncludingVATACY - ROUND(NewAmountIncludingVATACY,AddCurrency."Amount Rounding Precision");
                  TempVATAmountLineRemainder."VAT Amount (ACY)" := VATAmountACY - NewAmountIncludingVATACY + NewAmountACY;
                  TempVATAmountLineRemainder."VAT Difference (ACY)" := VATDifferenceACY - "VAT Difference (ACY)";
                  TempVATAmountLineRemainder.MODIFY;
                END;
              END;
            UNTIL NEXT = 0;
        END;
    end;

    procedure CalcVATAmountLines(QtyType : Option General,Invoicing,Shipping;var PurchHeader : Record "Purchase Header";var PurchLine : Record "Purchase Line";var VATAmountLine : Record "VAT Amount Line");
    var
        PrevVatAmountLine : Record "VAT Amount Line";
        Currency : Record Currency;
        SalesTaxCalculate : Codeunit "Sales Tax Calculate";
        TotalVATAmount : Decimal;
        QtyToHandle : Decimal;
        AmtToHandle : Decimal;
        RoundingLineInserted : Boolean;
        AddCurrency : Record Currency;
        CurrencyFactor : Decimal;
        UseDate : Date;
        TotalVATAmountACY : Decimal;
        FullGST : Boolean;
    begin
        Currency.Initialize(PurchHeader."Currency Code");

        GetGLSetup;
        UseDate := PurchHeader."Posting Date";
        IF ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           (PurchHeader."Posting Date" = 0D)
        THEN
          UseDate := WORKDATE;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
          AddCurrency.GET(GLSetup."Additional Reporting Currency");
          IF UseDate <> 0D THEN BEGIN
            IF (PurchHeader."Vendor Exchange Rate (ACY)" <> 0) AND (PurchHeader."Currency Code" = '') THEN
              CurrencyFactor :=
                CurrExchRate.ExchangeRateFactorFRS21(
                  UseDate,GLSetup."Additional Reporting Currency",PurchHeader."Vendor Exchange Rate (ACY)")
            ELSE
              CurrencyFactor :=
                CurrExchRate.ExchangeRate(
                  UseDate,GLSetup."Additional Reporting Currency");
          END;
        END;

        VATAmountLine.DELETEALL;

        WITH PurchLine DO BEGIN
          SETRANGE("Document Type",PurchHeader."Document Type");
          SETRANGE("Document No.",PurchHeader."No.");
          IF FINDSET THEN
            REPEAT
              IF NOT ZeroAmountLine(QtyType) THEN BEGIN
                IF (Type = Type::"G/L Account") AND NOT "Prepayment Line" THEN
                  RoundingLineInserted := ("No." = GetVPGInvRoundAcc(PurchHeader)) OR RoundingLineInserted;
                IF "VAT Calculation Type" IN
                   ["VAT Calculation Type"::"Reverse Charge VAT","VAT Calculation Type"::"Sales Tax"]
                THEN
                  "VAT %" := 0;
                FullGST :=
                  ("Prepayment Line" OR ("Prepmt. Line Amount" <> 0)) AND
                  GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
                IF NOT VATAmountLine.GET(
                     "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","Line Amount" >= 0,FullGST)
                THEN
                  VATAmountLine.InsertNewLine(
                    "VAT Identifier","VAT Calculation Type","Tax Group Code","Use Tax","VAT %","Line Amount" >= 0,FALSE,FullGST);

                CASE QtyType OF
                  QtyType::General:
                    BEGIN
                      VATAmountLine.Quantity += "Quantity (Base)";
                      VATAmountLine.SumLine(
                        "Line Amount","Inv. Discount Amount","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                      IF PurchHeader."Currency Code" = GLSetup."Additional Reporting Currency" THEN
                        VATAmountLine."Amount (ACY)" := Amount
                      ELSE
                        VATAmountLine."Amount (ACY)" := VATAmountLine."Amount (ACY)" +
                          ROUND(
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              UseDate,GLSetup."Additional Reporting Currency",
                              ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                UseDate,PurchHeader."Currency Code",Amount,
                                PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                            AddCurrency."Amount Rounding Precision");
                      VATAmountLine."VAT Base (ACY)" := VATAmountLine."Amount (ACY)";
                      VATAmountLine."VAT Difference (ACY)" += "VAT Difference (ACY)";
                      VATAmountLine.MODIFY;
                    END;
                  QtyType::Invoicing:
                    BEGIN
                      CASE TRUE OF
                        ("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]) AND
                        (NOT PurchHeader.Receive) AND PurchHeader.Invoice AND (NOT "Prepayment Line"):
                          IF "Receipt No." = '' THEN BEGIN
                            QtyToHandle := GetAbsMin("Qty. to Invoice","Qty. Rcd. Not Invoiced");
                            VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Qty. Rcd. Not Invoiced (Base)");
                          END ELSE BEGIN
                            QtyToHandle := "Qty. to Invoice";
                            VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                          END;
                        ("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]) AND
                        (NOT PurchHeader.Ship) AND PurchHeader.Invoice:
                          IF "Return Shipment No." = '' THEN BEGIN
                            QtyToHandle := GetAbsMin("Qty. to Invoice","Return Qty. Shipped Not Invd.");
                            VATAmountLine.Quantity += GetAbsMin("Qty. to Invoice (Base)","Ret. Qty. Shpd Not Invd.(Base)");
                          END ELSE BEGIN
                            QtyToHandle := "Qty. to Invoice";
                            VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                          END;
                        ELSE BEGIN
                          QtyToHandle := "Qty. to Invoice";
                          VATAmountLine.Quantity += "Qty. to Invoice (Base)";
                        END;
                      END;
                      AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                      IF PurchHeader."Invoice Discount Calculation" <> PurchHeader."Invoice Discount Calculation"::Amount THEN
                        VATAmountLine.SumLine(
                          AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                          "VAT Difference","Allow Invoice Disc.","Prepayment Line")
                      ELSE
                        VATAmountLine.SumLine(
                          AmtToHandle,"Inv. Disc. Amount to Invoice","VAT Difference","Allow Invoice Disc.","Prepayment Line");
                      IF PurchHeader."Currency Code" = GLSetup."Additional Reporting Currency" THEN
                        VATAmountLine."Amount (ACY)" := Amount
                      ELSE
                        VATAmountLine."Amount (ACY)" := VATAmountLine."Amount (ACY)" +
                          ROUND(
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              UseDate,GLSetup."Additional Reporting Currency",
                              ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  UseDate,PurchHeader."Currency Code",ROUND(Amount * QtyToHandle / Quantity,
                                    Currency."Amount Rounding Precision"),
                                  PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                            AddCurrency."Amount Rounding Precision");
                      VATAmountLine."VAT Base (ACY)" := VATAmountLine."Amount (ACY)";
                      VATAmountLine."VAT Difference (ACY)" += "VAT Difference (ACY)";
                      VATAmountLine.MODIFY;
                    END;
                  QtyType::Shipping:
                    BEGIN
                      IF "Document Type" IN
                         ["Document Type"::"Return Order","Document Type"::"Credit Memo"]
                      THEN BEGIN
                        QtyToHandle := "Return Qty. to Ship";
                        VATAmountLine.Quantity += "Return Qty. to Ship (Base)";
                      END ELSE BEGIN
                        QtyToHandle := "Qty. to Receive";
                        VATAmountLine.Quantity += "Qty. to Receive (Base)";
                      END;
                      AmtToHandle := GetLineAmountToHandle(QtyToHandle);
                      VATAmountLine.SumLine(
                        AmtToHandle,ROUND("Inv. Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                        "VAT Difference","Allow Invoice Disc.","Prepayment Line");
                      IF PurchHeader."Currency Code" = GLSetup."Additional Reporting Currency" THEN
                        VATAmountLine."Amount (ACY)" := Amount
                      ELSE
                        VATAmountLine."Amount (ACY)" := VATAmountLine."Amount (ACY)" +
                          ROUND(
                            CurrExchRate.ExchangeAmtLCYToFCY(
                              UseDate,GLSetup."Additional Reporting Currency",
                              ROUND(
                                CurrExchRate.ExchangeAmtFCYToLCY(
                                  UseDate,PurchHeader."Currency Code",
                                  ROUND(Amount * QtyToHandle / Quantity,Currency."Amount Rounding Precision"),
                                  PurchHeader."Currency Factor"),
                                Currency."Amount Rounding Precision"),
                              CurrencyFactor),
                            AddCurrency."Amount Rounding Precision");
                      VATAmountLine."VAT Base (ACY)" := VATAmountLine."Amount (ACY)";
                      VATAmountLine."VAT Difference (ACY)" += "VAT Difference (ACY)";
                      VATAmountLine.MODIFY;
                    END;
                END;
                TotalVATAmount += "Amount Including VAT" - Amount;
                TotalVATAmountACY += "Amount Including VAT (ACY)" - "Amount (ACY)";
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
              IF PurchHeader."Prices Including VAT" THEN BEGIN
                CASE "VAT Calculation Type" OF
                  "VAT Calculation Type"::"Normal VAT",
                  "VAT Calculation Type"::"Reverse Charge VAT":
                    BEGIN
                      IF "Full GST on Prepayment" AND "Includes Prepayment" THEN BEGIN
                        "VAT Amount" := "VAT Difference" +
                          ROUND(
                            PrevVatAmountLine."VAT Amount" +
                            "VAT Base" * "VAT %" / 100 * (1 - PurchHeader."VAT Base Discount %" / 100),
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
                            (1 - PurchHeader."VAT Base Discount %" / 100),
                            Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        "Amount Including VAT" := "VAT Base" + "VAT Amount";
                      END;
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        PrevVatAmountLine := VATAmountLine;
                        PrevVatAmountLine."VAT Amount" :=
                          ("Line Amount" - "Invoice Discount Amount" - "VAT Base" - "VAT Difference") *
                          (1 - PurchHeader."VAT Base Discount %" / 100);
                        PrevVatAmountLine."VAT Amount" :=
                          PrevVatAmountLine."VAT Amount" -
                          ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        PrevVatAmountLine."VAT Amount (ACY)" :=
                          PrevVatAmountLine."VAT Amount (ACY)" -
                          ROUND(PrevVatAmountLine."VAT Amount (ACY)",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                        IF "Full GST on Prepayment" THEN
                          CalcFullGSTValues(VATAmountLine,PurchLine,PurchHeader."Prices Including VAT");
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
                      IF "Use Tax" THEN
                        "VAT Base" := "Amount Including VAT"
                      ELSE
                        "VAT Base" :=
                          ROUND(
                            SalesTaxCalculate.ReverseCalculateTax(
                              PurchHeader."Tax Area Code","Tax Group Code",PurchHeader."Tax Liable",
                              PurchHeader."Posting Date","Amount Including VAT",Quantity,PurchHeader."Currency Factor"),
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
                          "VAT Base" * "VAT %" / 100 * (1 - PurchHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                      "VAT Base (ACY)" :=
                        ROUND(
                          "Amount (ACY)" * (1 - PurchHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "VAT Amount (ACY)" :=
                        "VAT Difference (ACY)" +
                        ROUND(
                          PrevVatAmountLine."VAT Amount (ACY)" +
                          "VAT Base (ACY)" * "VAT %" / 100 * (1 - PurchHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                      "Amount Including VAT" := "Line Amount" - "Invoice Discount Amount" + "VAT Amount";
                      "Amount Including VAT (ACY)" := "Amount (ACY)" + "VAT Amount (ACY)";
                      IF Positive THEN
                        PrevVatAmountLine.INIT
                      ELSE BEGIN
                        IF NOT "Includes Prepayment" THEN BEGIN
                          PrevVatAmountLine := VATAmountLine;
                          PrevVatAmountLine."VAT Amount" :=
                            "VAT Base" * "VAT %" / 100 * (1 - PurchHeader."VAT Base Discount %" / 100);
                          PrevVatAmountLine."VAT Amount" :=
                            PrevVatAmountLine."VAT Amount" -
                            ROUND(PrevVatAmountLine."VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
                          PrevVatAmountLine."VAT Amount (ACY)" :=
                            ROUND(
                              CurrExchRate.ExchangeAmtLCYToFCY(
                                UseDate,GLSetup."Additional Reporting Currency",
                                ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                    UseDate,PurchHeader."Currency Code",PrevVatAmountLine."VAT Amount",
                                    PurchHeader."Currency Factor"),Currency."Amount Rounding Precision"),CurrencyFactor),
                              AddCurrency."Amount Rounding Precision");
                        END;
                        IF "Full GST on Prepayment" THEN
                          CalcFullGSTValues(VATAmountLine,PurchLine,PurchHeader."Prices Including VAT");
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
                      IF "Use Tax" THEN
                        "VAT Amount" := 0
                      ELSE
                        "VAT Amount" :=
                          SalesTaxCalculate.CalculateTax(
                            PurchHeader."Tax Area Code","Tax Group Code",PurchHeader."Tax Liable",
                            PurchHeader."Posting Date","VAT Base",Quantity,PurchHeader."Currency Factor");
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

              IF RoundingLineInserted THEN
                TotalVATAmount := TotalVATAmount - "VAT Amount";
              "Calculated VAT Amount" := "VAT Amount" - "VAT Difference";
              "Calculated VAT Amount (ACY)" := "VAT Amount (ACY)" - "VAT Difference (ACY)";
              MODIFY;
            UNTIL NEXT = 0;

        IF RoundingLineInserted AND (TotalVATAmount <> 0) THEN
          IF VATAmountLine.GET(PurchLine."VAT Identifier",PurchLine."VAT Calculation Type",
               PurchLine."Tax Group Code",PurchLine."Use Tax",PurchLine."Line Amount" >= 0)
          THEN BEGIN
            VATAmountLine."VAT Amount" += TotalVATAmount;
            VATAmountLine."Amount Including VAT" += TotalVATAmount;
            VATAmountLine."Calculated VAT Amount" += TotalVATAmount;
            VATAmountLine.MODIFY;
          END;
    end;

    procedure UpdateWithWarehouseReceive();
    begin
        IF Type = Type::Item THEN
          CASE TRUE OF
            ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity >= 0):
              IF Location.RequireReceive("Location Code") THEN
                VALIDATE("Qty. to Receive",0)
              ELSE
                VALIDATE("Qty. to Receive","Outstanding Quantity");
            ("Document Type" IN ["Document Type"::Quote,"Document Type"::Order]) AND (Quantity < 0):
              IF Location.RequireShipment("Location Code") THEN
                VALIDATE("Qty. to Receive",0)
              ELSE
                VALIDATE("Qty. to Receive","Outstanding Quantity");
            ("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0):
              IF Location.RequireShipment("Location Code") THEN
                VALIDATE("Return Qty. to Ship",0)
              ELSE
                VALIDATE("Return Qty. to Ship","Outstanding Quantity");
            ("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0):
              IF Location.RequireReceive("Location Code") THEN
                VALIDATE("Return Qty. to Ship",0)
              ELSE
                VALIDATE("Return Qty. to Ship","Outstanding Quantity");
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
        IF "Prod. Order No." <> '' THEN
          EXIT;
        GetLocation("Location Code");
        IF "Location Code" = '' THEN BEGIN
          WhseSetup.GET;
          Location2."Require Shipment" := WhseSetup."Require Shipment";
          Location2."Require Pick" := WhseSetup."Require Pick";
          Location2."Require Receive" := WhseSetup."Require Receive";
          Location2."Require Put-away" := WhseSetup."Require Put-away";
        END ELSE
          Location2 := Location;

        DialogText := Text033;
        IF ("Document Type" IN ["Document Type"::Order,"Document Type"::"Return Order"]) AND
           Location2."Directed Put-away and Pick"
        THEN BEGIN
          ShowDialog := ShowDialog::Error;
          IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0)) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0))
          THEN
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Receive"))
          ELSE
            DialogText :=
              DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Shipment"));
        END ELSE BEGIN
          IF (("Document Type" = "Document Type"::Order) AND (Quantity >= 0) AND
              (Location2."Require Receive" OR Location2."Require Put-away")) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity < 0) AND
              (Location2."Require Receive" OR Location2."Require Put-away"))
          THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(
                 DATABASE::"Purchase Line",
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
              DialogText := Text034;
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Put-away"));
            END;
          END;

          IF (("Document Type" = "Document Type"::Order) AND (Quantity < 0) AND
              (Location2."Require Shipment" OR Location2."Require Pick")) OR
             (("Document Type" = "Document Type"::"Return Order") AND (Quantity >= 0) AND
              (Location2."Require Shipment" OR Location2."Require Pick"))
          THEN BEGIN
            IF WhseValidateSourceLine.WhseLinesExist(
                 DATABASE::"Purchase Line",
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
              DialogText := Text034;
              DialogText :=
                DialogText + Location2.GetRequirementText(Location2.FIELDNO("Require Pick"));
            END;
          END;
        END;

        CASE ShowDialog OF
          ShowDialog::Message:
            MESSAGE(Text016 + Text017,DialogText,FIELDCAPTION("Line No."),"Line No.");
          ShowDialog::Error:
            ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.")
        END;

        HandleDedicatedBin(TRUE);
    end;

    local procedure GetOverheadRateFCY() : Decimal;
    var
        QtyPerUOM : Decimal;
    begin
        IF "Prod. Order No." = '' THEN
          QtyPerUOM := "Qty. per Unit of Measure"
        ELSE BEGIN
          GetItem;
          QtyPerUOM := UOMMgt.GetQtyPerUnitOfMeasure(Item,"Unit of Measure Code");
        END;

        EXIT(
          CurrExchRate.ExchangeAmtLCYToFCY(
            GetDate,"Currency Code","Overhead Rate" * QtyPerUOM,PurchHeader."Currency Factor"));
    end;

    procedure GetItemTranslation();
    var
        ItemTranslation : Record "Item Translation";
    begin
        GetPurchHeader;
        IF ItemTranslation.GET("No.","Variant Code",PurchHeader."Language Code") THEN BEGIN
          Description := ItemTranslation.Description;
          "Description 2" := ItemTranslation."Description 2";
        END;
    end;

    local procedure GetGLSetup();
    begin
        IF NOT GLSetupRead THEN
          GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    local procedure GetPurchSetup();
    begin
        IF NOT PurchSetupRead THEN
          PurchSetup.GET;
        PurchSetupRead := TRUE;
    end;

    procedure AdjustDateFormula(DateFormulatoAdjust : DateFormula) : Text[30];
    begin
        IF FORMAT(DateFormulatoAdjust) <> '' THEN
          EXIT(FORMAT(DateFormulatoAdjust));
        EVALUATE(DateFormulatoAdjust,'<0D>');
        EXIT(FORMAT(DateFormulatoAdjust));
    end;

    local procedure GetLocation(LocationCode : Code[10]);
    begin
        IF LocationCode = '' THEN
          CLEAR(Location)
        ELSE
          IF Location.Code <> LocationCode THEN
            Location.GET(LocationCode);
    end;

    procedure RowID1() : Text[250];
    var
        ItemTrackingMgt : Codeunit "Item Tracking Management";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Purchase Line","Document Type",
            "Document No.",'',0,"Line No."));
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
            WMSManagement.GetDefaultBin("No.","Variant Code","Location Code","Bin Code");
            HandleDedicatedBin(FALSE);
          END;
        END;
    end;

    procedure IsInbound() : Boolean;
    begin
        CASE "Document Type" OF
          "Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote,"Document Type"::"Blanket Order":
            EXIT("Quantity (Base)" > 0);
          "Document Type"::"Return Order","Document Type"::"Credit Memo":
            EXIT("Quantity (Base)" < 0);
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

    procedure CrossReferenceNoLookUp();
    var
        ItemCrossReference : Record "Item Cross Reference";
    begin
        IF Type = Type::Item THEN BEGIN
          GetPurchHeader;
          ItemCrossReference.RESET;
          ItemCrossReference.SETCURRENTKEY("Cross-Reference Type","Cross-Reference Type No.");
          ItemCrossReference.SETFILTER(
            "Cross-Reference Type",'%1|%2',
            ItemCrossReference."Cross-Reference Type"::Vendor,
            ItemCrossReference."Cross-Reference Type"::" ");
          ItemCrossReference.SETFILTER("Cross-Reference Type No.",'%1|%2',PurchHeader."Buy-from Vendor No.",'');
          IF PAGE.RUNMODAL(PAGE::"Cross Reference List",ItemCrossReference) = ACTION::LookupOK THEN BEGIN
            VALIDATE("Cross-Reference No.",ItemCrossReference."Cross-Reference No.");
            PurchPriceCalcMgt.FindPurchLinePrice(PurchHeader,Rec,FIELDNO("Cross-Reference No."));
            PurchPriceCalcMgt.FindPurchLineLineDisc(PurchHeader,Rec);
            VALIDATE("Direct Unit Cost");
          END;
        END;
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

    local procedure GetAbsMin(QtyToHandle : Decimal;QtyHandled : Decimal) : Decimal;
    begin
        IF ABS(QtyHandled) < ABS(QtyToHandle) THEN
          EXIT(QtyHandled);

        EXIT(QtyToHandle);
    end;

    local procedure CheckApplToItemLedgEntry() : Code[10];
    var
        ItemLedgEntry : Record "Item Ledger Entry";
        ApplyRec : Record "Item Application Entry";
        ItemTrackingLines : Page "Item Tracking Lines";
        ReturnedQty : Decimal;
        RemainingtobeReturnedQty : Decimal;
    begin
        IF "Appl.-to Item Entry" = 0 THEN
          EXIT;

        IF "Receipt No." <> '' THEN
          EXIT;

        TESTFIELD(Type,Type::Item);
        TESTFIELD(Quantity);
        IF Signed(Quantity) > 0 THEN
          TESTFIELD("Prod. Order No.",'');
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          IF Quantity < 0 THEN
            FIELDERROR(Quantity,Text029);
        END ELSE BEGIN
          IF Quantity > 0 THEN
            FIELDERROR(Quantity,Text030);
        END;
        ItemLedgEntry.GET("Appl.-to Item Entry");
        ItemLedgEntry.TESTFIELD(Positive,TRUE);
        IF ItemLedgEntry.TrackingExists THEN
          ERROR(Text040,ItemTrackingLines.CAPTION,FIELDCAPTION("Appl.-to Item Entry"));

        ItemLedgEntry.TESTFIELD("Item No.","No.");
        ItemLedgEntry.TESTFIELD("Variant Code","Variant Code");

        // Track qty in both alternative and base UOM for better error checking and reporting
        IF ABS("Quantity (Base)") > ItemLedgEntry.Quantity THEN
          ERROR(
            Text042,
            ItemLedgEntry.Quantity,ItemLedgEntry.FIELDCAPTION("Document No."),
            ItemLedgEntry."Document No.");

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN
          IF ABS("Outstanding Qty. (Base)") > ItemLedgEntry."Remaining Quantity" THEN BEGIN
            ReturnedQty := ApplyRec.Returned(ItemLedgEntry."Entry No.");
            RemainingtobeReturnedQty := ItemLedgEntry.Quantity - ReturnedQty;
            IF NOT ("Qty. per Unit of Measure" = 0) THEN BEGIN
              ReturnedQty := ROUND(ReturnedQty / "Qty. per Unit of Measure",0.00001);
              RemainingtobeReturnedQty := ROUND(RemainingtobeReturnedQty / "Qty. per Unit of Measure",0.00001);
            END;

            IF ((("Qty. per Unit of Measure" = 0) AND (RemainingtobeReturnedQty < ABS("Outstanding Qty. (Base)"))) OR
                (("Qty. per Unit of Measure" <> 0) AND (RemainingtobeReturnedQty < ABS("Outstanding Quantity"))))
            THEN
              ERROR(
                Text035,
                ReturnedQty,ItemLedgEntry.FIELDCAPTION("Document No."),
                ItemLedgEntry."Document No.",RemainingtobeReturnedQty);
          END;

        EXIT(ItemLedgEntry."Location Code");
    end;

    procedure CalcPrepaymentToDeduct();
    begin
        IF ("Qty. to Invoice" <> 0) AND ("Prepmt. Amt. Inv." <> 0) THEN BEGIN
          GetPurchHeader;
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

        GetPurchHeader;
        LineAmount := ROUND(QtyToHandle * "Direct Unit Cost",Currency."Amount Rounding Precision");
        LineDiscAmount := ROUND("Line Discount Amount" * QtyToHandle / Quantity,Currency."Amount Rounding Precision");
        EXIT(LineAmount - LineDiscAmount);
    end;

    procedure JobTaskIsSet() : Boolean;
    begin
        EXIT(("Job No." <> '') AND ("Job Task No." <> '') AND (Type IN [Type::"G/L Account",Type::Item]));
    end;

    procedure CreateTempJobJnlLine(GetPrices : Boolean);
    begin
        GetPurchHeader;
        CLEAR(TempJobJnlLine);
        TempJobJnlLine.DontCheckStdCost;
        TempJobJnlLine.VALIDATE("Job No.","Job No.");
        TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
        TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
        TempJobJnlLine.SetCurrencyFactor("Job Currency Factor");
        IF Type = Type::"G/L Account" THEN
          TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::"G/L Account")
        ELSE
          TempJobJnlLine.VALIDATE(Type,TempJobJnlLine.Type::Item);
        TempJobJnlLine.VALIDATE("No.","No.");
        TempJobJnlLine.VALIDATE(Quantity,Quantity);
        TempJobJnlLine.VALIDATE("Variant Code","Variant Code");
        TempJobJnlLine.VALIDATE("Unit of Measure Code","Unit of Measure Code");

        IF NOT GetPrices THEN BEGIN
          IF xRec."Line No." <> 0 THEN BEGIN
            TempJobJnlLine."Unit Cost" := xRec."Unit Cost";
            TempJobJnlLine."Unit Cost (LCY)" := xRec."Unit Cost (LCY)";
            TempJobJnlLine."Unit Price" := xRec."Job Unit Price";
            TempJobJnlLine."Line Amount" := xRec."Job Line Amount";
            TempJobJnlLine."Line Discount %" := xRec."Job Line Discount %";
            TempJobJnlLine."Line Discount Amount" := xRec."Job Line Discount Amount";
          END ELSE BEGIN
            TempJobJnlLine."Unit Cost" := "Unit Cost";
            TempJobJnlLine."Unit Cost (LCY)" := "Unit Cost (LCY)";
            TempJobJnlLine."Unit Price" := "Job Unit Price";
            TempJobJnlLine."Line Amount" := "Job Line Amount";
            TempJobJnlLine."Line Discount %" := "Job Line Discount %";
            TempJobJnlLine."Line Discount Amount" := "Job Line Discount Amount";
          END;
          TempJobJnlLine.VALIDATE("Unit Price");
        END ELSE
          TempJobJnlLine.VALIDATE("Unit Cost (LCY)","Unit Cost (LCY)");
    end;

    procedure UpdateJobPrices();
    var
        PurchRcptLine : Record "Purch. Rcpt. Line";
    begin
        IF "Receipt No." = '' THEN BEGIN
          "Job Unit Price" := TempJobJnlLine."Unit Price";
          "Job Total Price" := TempJobJnlLine."Total Price";
          "Job Unit Price (LCY)" := TempJobJnlLine."Unit Price (LCY)";
          "Job Total Price (LCY)" := TempJobJnlLine."Total Price (LCY)";
          "Job Line Amount (LCY)" := TempJobJnlLine."Line Amount (LCY)";
          "Job Line Disc. Amount (LCY)" := TempJobJnlLine."Line Discount Amount (LCY)";
          "Job Line Amount" := TempJobJnlLine."Line Amount";
          "Job Line Discount %" := TempJobJnlLine."Line Discount %";
          "Job Line Discount Amount" := TempJobJnlLine."Line Discount Amount";
        END ELSE BEGIN
          PurchRcptLine.GET("Receipt No.","Receipt Line No.");
          "Job Unit Price" := PurchRcptLine."Job Unit Price";
          "Job Total Price" := PurchRcptLine."Job Total Price";
          "Job Unit Price (LCY)" := PurchRcptLine."Job Unit Price (LCY)";
          "Job Total Price (LCY)" := PurchRcptLine."Job Total Price (LCY)";
          "Job Line Amount (LCY)" := PurchRcptLine."Job Line Amount (LCY)";
          "Job Line Disc. Amount (LCY)" := PurchRcptLine."Job Line Disc. Amount (LCY)";
          "Job Line Amount" := PurchRcptLine."Job Line Amount";
          "Job Line Discount %" := PurchRcptLine."Job Line Discount %";
          "Job Line Discount Amount" := PurchRcptLine."Job Line Discount Amount";
        END;
    end;

    procedure JobSetCurrencyFactor();
    begin
        GetPurchHeader;
        CLEAR(TempJobJnlLine);
        TempJobJnlLine.VALIDATE("Job No.","Job No.");
        TempJobJnlLine.VALIDATE("Job Task No.","Job Task No.");
        TempJobJnlLine.VALIDATE("Posting Date",PurchHeader."Posting Date");
        "Job Currency Factor" := TempJobJnlLine."Currency Factor";
    end;

    procedure SetUpdateFromVAT(UpdateFromVAT2 : Boolean);
    begin
        UpdateFromVAT := UpdateFromVAT2;
    end;

    procedure InitQtyToReceive2();
    begin
        "Qty. to Receive" := "Outstanding Quantity";
        "Qty. to Receive (Base)" := "Outstanding Qty. (Base)";

        "Qty. to Invoice" := MaxQtyToInvoice;
        "Qty. to Invoice (Base)" := MaxQtyToInvoiceBase;
        "VAT Difference" := 0;

        CalcInvDiscToInvoice;

        CalcPrepaymentToDeduct;

        IF "Job Planning Line No." <> 0 THEN
          VALIDATE("Job Planning Line No.");
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

    procedure ClearQtyIfBlank();
    begin
        IF "Document Type" = "Document Type"::Order THEN BEGIN
          GetPurchSetup;
          IF PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank THEN BEGIN
            "Qty. to Receive" := 0;
            "Qty. to Receive (Base)" := 0;
          END;
        END;
    end;

    procedure ShowLineComments();
    var
        PurchCommentLine : Record "Purch. Comment Line";
        PurchCommentSheet : Page "Purch. Comment Sheet";
    begin
        TESTFIELD("Document No.");
        TESTFIELD("Line No.");
        PurchCommentLine.SETRANGE("Document Type","Document Type");
        PurchCommentLine.SETRANGE("No.","Document No.");
        PurchCommentLine.SETRANGE("Document Line No.","Line No.");
        PurchCommentSheet.SETTABLEVIEW(PurchCommentLine);
        PurchCommentSheet.RUNMODAL;
    end;

    procedure SetDefaultQuantity();
    begin
        GetPurchSetup;
        IF PurchSetup."Default Qty. to Receive" = PurchSetup."Default Qty. to Receive"::Blank THEN BEGIN
          IF ("Document Type" = "Document Type"::Order) OR ("Document Type" = "Document Type"::Quote) THEN BEGIN
            "Qty. to Receive" := 0;
            "Qty. to Receive (Base)" := 0;
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          END;
          IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
            "Return Qty. to Ship" := 0;
            "Return Qty. to Ship (Base)" := 0;
            "Qty. to Invoice" := 0;
            "Qty. to Invoice (Base)" := 0;
          END;
        END;
    end;

    procedure UpdatePrePaymentAmounts();
    var
        ReceiptLine : Record "Purch. Rcpt. Line";
        PurchOrderLine : Record "Purchase Line";
        PurchOrderHeader : Record "Purchase Header";
    begin
        IF ("Document Type" <> "Document Type"::Invoice) OR ("Prepayment %" = 0) THEN
          EXIT;

        IF NOT ReceiptLine.GET("Receipt No.","Receipt Line No.") THEN BEGIN
          "Prepmt Amt to Deduct" := 0;
          "Prepmt VAT Diff. to Deduct" := 0;
        END ELSE
          IF PurchOrderLine.GET(PurchOrderLine."Document Type"::Order,ReceiptLine."Order No.",ReceiptLine."Order Line No.") THEN BEGIN
            IF ("Prepayment %" = 100) AND (Quantity <> PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced") THEN
              "Prepmt Amt to Deduct" := "Line Amount"
            ELSE
              "Prepmt Amt to Deduct" :=
                ROUND((PurchOrderLine."Prepmt. Amt. Inv." - PurchOrderLine."Prepmt Amt Deducted") *
                  Quantity / (PurchOrderLine.Quantity - PurchOrderLine."Quantity Invoiced"),Currency."Amount Rounding Precision");
            "Prepmt VAT Diff. to Deduct" := "Prepayment VAT Difference" - "Prepmt VAT Diff. Deducted";
            PurchOrderHeader.GET(PurchOrderHeader."Document Type"::Order,PurchOrderLine."Document No.");
          END ELSE BEGIN
            "Prepmt Amt to Deduct" := 0;
            "Prepmt VAT Diff. to Deduct" := 0;
          END;

        GetPurchHeader;
        PurchHeader.TESTFIELD("Prices Including VAT",PurchOrderHeader."Prices Including VAT");
        IF PurchHeader."Prices Including VAT" THEN BEGIN
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

    procedure SetVendorItemNo();
    var
        ItemVend : Record "Item Vendor";
    begin
        GetItem;
        ItemVend.INIT;
        ItemVend."Vendor No." := "Buy-from Vendor No.";
        ItemVend."Variant Code" := "Variant Code";
        Item.FindItemVend(ItemVend,"Location Code");
        VALIDATE("Vendor Item No.",ItemVend."Vendor Item No.");
    end;

    procedure ZeroAmountLine(QtyType : Option General,Invoicing,Shipping) : Boolean;
    begin
        IF Type = Type::" " THEN
          EXIT(TRUE);
        IF Quantity = 0 THEN
          EXIT(TRUE);
        IF "Direct Unit Cost" = 0 THEN
          EXIT(TRUE);
        IF QtyType = QtyType::Invoicing THEN
          IF "Qty. to Invoice" = 0 THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure FilterLinesWithItemToPlan(var Item : Record Item;DocumentType : Option);
    begin
        RESET;
        SETCURRENTKEY("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date");
        SETRANGE("Document Type",DocumentType);
        SETRANGE(Type,Type::Item);
        SETRANGE("No.",Item."No.");
        SETFILTER("Variant Code",Item.GETFILTER("Variant Filter"));
        SETFILTER("Location Code",Item.GETFILTER("Location Filter"));
        SETFILTER("Drop Shipment",Item.GETFILTER("Drop Shipment Filter"));
        SETFILTER("Expected Receipt Date",Item.GETFILTER("Date Filter"));
        SETFILTER("Shortcut Dimension 1 Code",Item.GETFILTER("Global Dimension 1 Filter"));
        SETFILTER("Shortcut Dimension 2 Code",Item.GETFILTER("Global Dimension 2 Filter"));
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

    procedure GetVPGInvRoundAcc(var PurchHeader : Record "Purchase Header") : Code[20];
    var
        Vendor : Record Vendor;
        VendorPostingGroup : Record "Vendor Posting Group";
    begin
        GetPurchSetup;
        IF PurchSetup."Invoice Rounding" THEN
          IF Vendor.GET(PurchHeader."Pay-to Vendor No.") THEN
            VendorPostingGroup.GET(Vendor."Vendor Posting Group");

        EXIT(VendorPostingGroup."Invoice Rounding Account");
    end;

    local procedure CheckReceiptRelation();
    var
        PurchRcptLine : Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.GET("Receipt No.","Receipt Line No.");
        IF (Quantity * PurchRcptLine."Qty. Rcd. Not Invoiced") < 0 THEN
          FIELDERROR("Qty. to Invoice",Text051);
        IF ABS(Quantity) > ABS(PurchRcptLine."Qty. Rcd. Not Invoiced") THEN
          ERROR(Text052,PurchRcptLine."Document No.");
    end;

    local procedure CheckRetShptRelation();
    var
        ReturnShptLine : Record "Return Shipment Line";
    begin
        ReturnShptLine.GET("Return Shipment No.","Return Shipment Line No.");
        IF (Quantity * (ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced")) < 0 THEN
          FIELDERROR("Qty. to Invoice",Text053);
        IF ABS(Quantity) > ABS(ReturnShptLine.Quantity - ReturnShptLine."Quantity Invoiced") THEN
          ERROR(Text054,ReturnShptLine."Document No.");
    end;

    local procedure VerifyItemLineDim();
    begin
        IF IsReceivedShippedItemDimChanged THEN
          ConfirmReceivedShippedItemDimChange;
    end;

    procedure IsReceivedShippedItemDimChanged() : Boolean;
    begin
        EXIT(("Dimension Set ID" <> xRec."Dimension Set ID") AND (Type = Type::Item) AND
          (("Qty. Rcd. Not Invoiced" <> 0) OR ("Return Qty. Shipped Not Invd." <> 0)));
    end;

    procedure ConfirmReceivedShippedItemDimChange() : Boolean;
    begin
        IF NOT CONFIRM(Text049,TRUE,TABLECAPTION) THEN
          ERROR(Text050);

        EXIT(TRUE);
    end;

    procedure InitType();
    begin
        IF "Document No." <> '' THEN BEGIN
          PurchHeader.GET("Document Type","Document No.");
          IF (PurchHeader.Status = PurchHeader.Status::Released) AND
             (xRec.Type IN [xRec.Type::Item,xRec.Type::"Fixed Asset"])
          THEN
            Type := Type::" "
          ELSE
            Type := xRec.Type;
        END;
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
          IF PurchHeader."Prices Including VAT" THEN
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

    local procedure UpdateGSTAmounts() : Boolean;
    begin
        GetGLSetup;
        IF GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN BEGIN
          UpdateVATAmounts;
          EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    local procedure FullGSTAmount() : Decimal;
    begin
        IF PurchHeader."Prices Including VAT" THEN
          EXIT("Amount Including VAT" - Amount)
          ;
        EXIT(0);
    end;

    local procedure ExcludeVAT(AmountInclVAT : Decimal) : Decimal;
    begin
        EXIT(ROUND(AmountInclVAT / (1 + "VAT %" / 100),Currency."Amount Rounding Precision"));
    end;

    local procedure LineAmountExclFullGST() : Decimal;
    begin
        IF GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
          IF PurchHeader."Prices Including VAT" THEN
            EXIT(Amount + ExcludeVAT("Inv. Discount Amount"));
        EXIT("Line Amount");
    end;

    local procedure PrepmtLineAmtExclFullGST() : Decimal;
    var
        VATAmount : Decimal;
        PrepmtLineAmt : Decimal;
    begin
        IF NOT GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
          EXIT("Prepmt. Line Amount");

        PrepmtLineAmt := "Prepmt. Line Amount";
        IF PurchHeader."Prices Including VAT" THEN BEGIN
          VATAmount := FullGSTAmount;
          IF VATAmount > PrepmtLineAmt THEN
            EXIT(0);
          PrepmtLineAmt := ROUND(PrepmtLineAmt - VATAmount,Currency."Amount Rounding Precision");
        END;
        EXIT(AppendInvDiscount(PrepmtLineAmt));
    end;

    local procedure AppendInvDiscount(LineAmount : Decimal) : Decimal;
    begin
        IF "Inv. Discount Amount" = 0 THEN
          EXIT(LineAmount);
        EXIT(ROUND(LineAmount * "Line Amount" / ("Line Amount" - "Inv. Discount Amount"),Currency."Amount Rounding Precision"));
    end;

    procedure CalcFullGSTValues(var VATAmountLine : Record "VAT Amount Line";var PurchLine : Record "Purchase Line";PriceIncludingVAT : Boolean);
    var
        RecPurchLine : Record "Purchase Line";
    begin
        WITH VATAmountLine DO BEGIN
          "VAT Base" := 0;
          "VAT Amount" := 0;
          "Inv. Discount Amount" := 0;
          RecPurchLine.RESET;
          RecPurchLine.SETFILTER("Document No.",PurchLine."Document No.");
          RecPurchLine.SETFILTER(Type,'<>%1',PurchLine.Type::" ");
          RecPurchLine.SETFILTER("VAT Identifier",'%1',"VAT Identifier");
          IF RecPurchLine.FINDSET THEN BEGIN
            REPEAT
              IF PriceIncludingVAT THEN BEGIN
                VATBase :=
                  ROUND(
                    ((RecPurchLine."Line Amount" - RecPurchLine."Inv. Discount Amount") /
                     (1 + RecPurchLine."Prepayment VAT %" / 100) - RecPurchLine."VAT Difference"),Currency."Amount Rounding Precision");
                VATAmt :=
                  "VAT Difference" +
                  (RecPurchLine."Line Amount" - RecPurchLine."Inv. Discount Amount" - VATBase - "VAT Difference") *
                  (1 - PurchHeader."VAT Base Discount %" / 100);
                "VAT Base" := "VAT Base" + VATBase * (RecPurchLine."Qty. to Invoice" / RecPurchLine.Quantity);
                "VAT Amount" := "VAT Amount" + VATAmt * (RecPurchLine."Qty. to Invoice" / RecPurchLine.Quantity);
                "Invoice Discount Amount" := "Invoice Discount Amount" + ("Inv. Discount Amount" * RecPurchLine."Prepayment %" / 100);
              END ELSE BEGIN
                VATBase :=
                  ROUND(
                    (RecPurchLine."Line Amount" - RecPurchLine."Inv. Discount Amount") *
                    (RecPurchLine."Qty. to Invoice" / RecPurchLine.Quantity),
                    Currency."Amount Rounding Precision");
                "VAT Base" := "VAT Base" + VATBase;
                "VAT Amount" := "VAT Amount" + (VATBase * RecPurchLine."Prepayment VAT %" / 100);
                "Invoice Discount Amount" :=
                  "Invoice Discount Amount" + RecPurchLine."Inv. Discount Amount" * RecPurchLine."Prepayment %" / 100;
              END;
            UNTIL RecPurchLine.NEXT = 0;
            "VAT Base" := -1 * ROUND("VAT Base",Currency."Amount Rounding Precision");
            "VAT Amount" := -1 * ROUND("VAT Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
            "Invoice Discount Amount" := -1 * ROUND("Invoice Discount Amount",Currency."Amount Rounding Precision");
            IF PriceIncludingVAT THEN
              "Amount Including VAT" := ROUND("Line Amount",Currency."Amount Rounding Precision")
            ELSE BEGIN
              IF NOT Positive THEN
                "Amount Including VAT" := "Line Amount" - PurchLine."Inv. Discount Amount" + "VAT Amount"
              ELSE
                "Amount Including VAT" := "VAT Base" - PurchLine."Inv. Discount Amount" + "VAT Amount";
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
          DialogText := Text033;
          IF "Quantity (Base)" <> 0 THEN
            CASE "Document Type" OF
              "Document Type"::Invoice:
                IF "Receipt No." = '' THEN
                  IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                    DialogText += Location.GetRequirementText(Location.FIELDNO("Require Receive"));
                    ERROR(Text016,DialogText,FIELDCAPTION("Line No."),"Line No.");
                  END;
              "Document Type"::"Credit Memo":
                IF "Return Shipment No." = '' THEN
                  IF Location.GET("Location Code") AND Location."Directed Put-away and Pick" THEN BEGIN
                    DialogText += Location.GetRequirementText(Location.FIELDNO("Require Shipment"));
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

    local procedure CheckReservationDateConflict(DateFieldNo : Integer);
    var
        ReservEntry : Record "Reservation Entry";
        PurchLineReserve : Codeunit "Purch. Line-Reserve";
    begin
        IF CurrFieldNo = DateFieldNo THEN
          IF PurchLineReserve.FindReservEntry(Rec,ReservEntry) THEN BEGIN
            ReservEntry.SETFILTER("Shipment Date",'<%1',"Expected Receipt Date");
            IF NOT ReservEntry.ISEMPTY THEN
              IF NOT CONFIRM(DataConflictQst) THEN
                ERROR('');
          END;
    end;

    local procedure ReservEntryExist() : Boolean;
    var
        NewReservEntry : Record "Reservation Entry";
    begin
        ReservePurchLine.FilterReservFor(NewReservEntry,Rec);
        NewReservEntry.SETRANGE("Reservation Status",NewReservEntry."Reservation Status"::Reservation,
          NewReservEntry."Reservation Status"::Tracking);

        EXIT(NOT NewReservEntry.ISEMPTY);
    end;

    local procedure ValidateReturnReasonCode(CallingFieldNo : Integer);
    var
        ReturnReason : Record "Return Reason";
    begin
        IF CallingFieldNo = 0 THEN
          EXIT;
        IF "Return Reason Code" = '' THEN
          UpdateDirectUnitCost(CallingFieldNo);

        IF ReturnReason.GET("Return Reason Code") THEN BEGIN
          IF (CallingFieldNo <> FIELDNO("Location Code")) AND (ReturnReason."Default Location Code" <> '') THEN
            VALIDATE("Location Code",ReturnReason."Default Location Code");
          IF ReturnReason."Inventory Value Zero" THEN
            VALIDATE("Direct Unit Cost",0)
          ELSE
            UpdateDirectUnitCost(CallingFieldNo);
        END;
    end;

    local procedure UpdateDimensionsFromJobTask();
    var
        DimSetArrID : array [10] of Integer;
        DimValue1 : Code[20];
        DimValue2 : Code[20];
    begin
        DimSetArrID[1] := "Dimension Set ID";
        DimSetArrID[2] := DimMgt.CreateDimSetFromJobTaskDim("Job No.","Job Task No.",DimValue1,DimValue2);
        "Dimension Set ID" := DimMgt.GetCombinedDimensionSetID(DimSetArrID,DimValue1,DimValue2);
        "Shortcut Dimension 1 Code" := DimValue1;
        "Shortcut Dimension 2 Code" := DimValue2;
    end;

    local procedure UpdateItemCrossRef();
    begin
        DistIntegration.EnterPurchaseItemCrossRef(Rec);
        UpdateICPartner;
    end;

    local procedure UpdateItemReference();
    begin
        IF Type <> Type::Item THEN
          EXIT;

        UpdateItemCrossRef;
        IF "Cross-Reference No." = '' THEN
          SetVendorItemNo
        ELSE
          VALIDATE("Vendor Item No.","Cross-Reference No.");
    end;

    local procedure UpdateICPartner();
    var
        ICPartner : Record "IC Partner";
        ItemCrossReference : Record "Item Cross Reference";
    begin
        IF PurchHeader."Send IC Document" AND
           (PurchHeader."IC Direction" = PurchHeader."IC Direction"::Outgoing)
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
                ICPartner.GET(PurchHeader."Buy-from IC Partner Code");
                CASE ICPartner."Outbound Purch. Item No. Type" OF
                  ICPartner."Outbound Purch. Item No. Type"::"Common Item No.":
                    VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Common Item No.");
                  ICPartner."Outbound Purch. Item No. Type"::"Internal No.",
                  ICPartner."Outbound Purch. Item No. Type"::"Cross Reference":
                    BEGIN
                      IF ICPartner."Outbound Purch. Item No. Type" = ICPartner."Outbound Purch. Item No. Type"::"Internal No." THEN
                        VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::Item)
                      ELSE
                        VALIDATE("IC Partner Ref. Type","IC Partner Ref. Type"::"Cross Reference");
                      ItemCrossReference.SETRANGE("Cross-Reference Type",ItemCrossReference."Cross-Reference Type"::Vendor);
                      ItemCrossReference.SETRANGE("Cross-Reference Type No.","Buy-from Vendor No.");
                      ItemCrossReference.SETRANGE("Item No.","No.");
                      ItemCrossReference.SETRANGE("Variant Code","Variant Code");
                      ItemCrossReference.SETRANGE("Unit of Measure","Unit of Measure Code");
                      IF ItemCrossReference.FINDFIRST THEN
                        "IC Partner Reference" := ItemCrossReference."Cross-Reference No."
                      ELSE
                        "IC Partner Reference" := "No.";
                    END;
                  ICPartner."Outbound Purch. Item No. Type"::"Vendor Item No.":
                    BEGIN
                      "IC Partner Ref. Type" := "IC Partner Ref. Type"::"Vendor Item No.";
                      "IC Partner Reference" := "Vendor Item No.";
                    END;
                END;
              END;
            Type::"Fixed Asset":
              BEGIN
                "IC Partner Ref. Type" := "IC Partner Ref. Type"::" ";
                "IC Partner Reference" := '';
              END;
          END;
    end;

    local procedure CalcTotalAmtToAssign(TotalQtyToAssign : Decimal) TotalAmtToAssign : Decimal;
    begin
        TotalAmtToAssign := ("Line Amount" - "Inv. Discount Amount") * TotalQtyToAssign / Quantity;

        IF PurchHeader."Prices Including VAT" THEN
          TotalAmtToAssign := TotalAmtToAssign / (1 + "VAT %" / 100) - "VAT Difference";

        TotalAmtToAssign := ROUND(TotalAmtToAssign,Currency."Amount Rounding Precision");
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
        DeferralPostDate : Date;
        AdjustStartDate : Boolean;
    begin
        GetPurchHeader;
        DeferralPostDate := PurchHeader."Posting Date";
        AdjustStartDate := TRUE;
        IF "Document Type" = "Document Type"::"Return Order" THEN BEGIN
          IF "Returns Deferral Start Date" = 0D THEN
            "Returns Deferral Start Date" := PurchHeader."Posting Date";
          DeferralPostDate := "Returns Deferral Start Date";
          AdjustStartDate := FALSE;
        END;

        DeferralUtilities.RemoveOrSetDeferralSchedule(
          "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
          "Document Type","Document No.","Line No.",
          GetDeferralAmount,DeferralPostDate,Description,PurchHeader."Currency Code",AdjustStartDate);
    end;

    procedure ShowDeferrals(PostingDate : Date;CurrencyCode : Code[10]) : Boolean;
    begin
        EXIT(DeferralUtilities.OpenLineScheduleEdit(
            "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
            "Document Type","Document No.","Line No.",
            GetDeferralAmount,PostingDate,Description,CurrencyCode));
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
        END;
    end;

    procedure IsCreditDocType() : Boolean;
    begin
        EXIT("Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"]);
    end;

    procedure IsInvoiceDocType() : Boolean;
    begin
        EXIT("Document Type" IN ["Document Type"::Order,"Document Type"::Invoice]);
    end;

    local procedure IsReceivedFromOcr() : Boolean;
    var
        IncomingDocument : Record "Incoming Document";
    begin
        GetPurchHeader;
        IF NOT IncomingDocument.GET(PurchHeader."Incoming Document Entry No.") THEN
          EXIT(FALSE);
        EXIT(IncomingDocument."OCR Status" = IncomingDocument."OCR Status"::Success);
    end;

    local procedure TestReturnFieldsZero();
    begin
        TESTFIELD("Return Qty. Shipped Not Invd.",0);
        TESTFIELD("Return Qty. Shipped",0);
        TESTFIELD("Return Shipment No.",'');
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
        UnitOfMeasure : Record "Unit of Measure";
    begin
        IF NOT CanEditUnitOfMeasureCode THEN
          EXIT;

        IF (Type = Type::Item) AND ("No." <> '') THEN BEGIN
          ItemUnitOfMeasure.SETRANGE("Item No.","No.");
          IF PAGE.RUNMODAL(0,ItemUnitOfMeasure) = ACTION::LookupOK THEN
            VALIDATE("Unit of Measure Code",ItemUnitOfMeasure.Code);
        END ELSE
          IF PAGE.RUNMODAL(0,UnitOfMeasure) = ACTION::LookupOK THEN
            VALIDATE("Unit of Measure Code",UnitOfMeasure.Code);
    end;

    procedure ClearPurchaseHeader();
    begin
        CLEAR(PurchHeader);
    end;

    procedure RenameNo(LineType : Option;OriginalNo : Code[20];NewNo : Code[20]);
    begin
        RESET;
        SETRANGE(Type,LineType);
        SETRANGE("No.",OriginalNo);
        MODIFYALL("No.",NewNo);
    end;
}

