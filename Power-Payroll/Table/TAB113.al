table 113 "Sales Invoice Line"
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585

    CaptionML = ENU='Sales Invoice Line',
                ENA='Sales Invoice Line';
    DrillDownPageID = 526;
    LookupPageID = 526;
    Permissions = TableData "Item Ledger Entry"=r,
                  TableData "Value Entry"=r;

    fields
    {
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
            TableRelation = "Sales Invoice Header";
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
        }
        field(6;"No.";Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("No."));
            CaptionML = ENU='No.',
                        ENA='No.';
            TableRelation = IF (Type=CONST(G/L Account)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Resource)) Resource ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
        }
        field(7;"Location Code";Code[10])
        {
            CaptionML = ENU='Location Code',
                        ENA='Location Code';
            TableRelation = Location WHERE (Use As In-Transit=CONST(No));
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
            CaptionML = ENU='Shipment Date',
                        ENA='Shipment Date';
        }
        field(11;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
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
        }
        field(22;"Unit Price";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Unit Price"));
            CaptionML = ENU='Unit Price',
                        ENA='Unit Price';
        }
        field(23;"Unit Cost (LCY)";Decimal)
        {
            AutoFormatType = 2;
            CaptionML = ENU='Unit Cost (LCY)',
                        ENA='Unit Cost (LCY)';
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
        }
        field(28;"Line Discount Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Line Discount Amount',
                        ENA='Line Discount Amount';
        }
        field(29;Amount;Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Amount',
                        ENA='Amount';
        }
        field(30;"Amount Including VAT";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Amount Including VAT',
                        ENA='Amount Including GST';
        }
        field(32;"Allow Invoice Disc.";Boolean)
        {
            CaptionML = ENU='Allow Invoice Disc.',
                        ENA='Allow Invoice Disc.';
            InitValue = true;
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
        }
        field(40;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            CaptionML = ENU='Shortcut Dimension 1 Code',
                        ENA='Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(41;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            CaptionML = ENU='Shortcut Dimension 2 Code',
                        ENA='Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(42;"Customer Price Group";Code[10])
        {
            CaptionML = ENU='Customer Price Group',
                        ENA='Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(45;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            TableRelation = Job;
        }
        field(52;"Work Type Code";Code[10])
        {
            CaptionML = ENU='Work Type Code',
                        ENA='Work Type Code';
            TableRelation = "Work Type";
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
        field(68;"Bill-to Customer No.";Code[20])
        {
            CaptionML = ENU='Bill-to Customer No.',
                        ENA='Bill-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Discount Amount',
                        ENA='Inv. Discount Amount';
        }
        field(73;"Drop Shipment";Boolean)
        {
            AccessByPermission = TableData "Drop Shpt. Post. Buffer"=R;
            CaptionML = ENU='Drop Shipment',
                        ENA='Drop Shipment';
        }
        field(74;"Gen. Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Bus. Posting Group',
                        ENA='Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75;"Gen. Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Prod. Posting Group',
                        ENA='Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(77;"VAT Calculation Type";Option)
        {
            CaptionML = ENU='VAT Calculation Type',
                        ENA='GST Calculation Type';
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
            TableRelation = "Sales Invoice Line"."Line No." WHERE (Document No.=FIELD(Document No.));
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
        }
        field(86;"Tax Liable";Boolean)
        {
            CaptionML = ENU='Tax Liable',
                        ENA='US Tax Liable';
        }
        field(87;"Tax Group Code";Code[10])
        {
            CaptionML = ENU='Tax Group Code',
                        ENA='US Tax Group Code';
            TableRelation = "Tax Group";
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
        }
        field(90;"VAT Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Prod. Posting Group',
                        ENA='GST Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(97;"Blanket Order No.";Code[20])
        {
            CaptionML = ENU='Blanket Order No.',
                        ENA='Blanket Order No.';
            TableRelation = "Sales Header".No. WHERE (Document Type=CONST(Blanket Order));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            CaptionML = ENU='Blanket Order Line No.',
                        ENA='Blanket Order Line No.';
            TableRelation = "Sales Line"."Line No." WHERE (Document Type=CONST(Blanket Order), Document No.=FIELD(Blanket Order No.));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(99;"VAT Base Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='VAT Base Amount',
                        ENA='GST Base Amount';
            Editable = false;
        }
        field(100;"Unit Cost";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
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
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionClass = GetCaptionClass(FIELDNO("Line Amount"));
            CaptionML = ENU='Line Amount',
                        ENA='Line Amount';
        }
        field(104;"VAT Difference";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='VAT Difference',
                        ENA='GST Difference';
        }
        field(106;"VAT Identifier";Code[10])
        {
            CaptionML = ENU='VAT Identifier',
                        ENA='GST Identifier';
            Editable = false;
        }
        field(107;"IC Partner Ref. Type";Option)
        {
            CaptionML = ENU='IC Partner Ref. Type',
                        ENA='IC Partner Ref. Type';
            OptionCaptionML = ENU=' ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.',
                              ENA=' ,G/L Account,Item,,,Charge (Item),Cross reference,Common Item No.';
            OptionMembers = " ","G/L Account",Item,,,"Charge (Item)","Cross reference","Common Item No.";
        }
        field(108;"IC Partner Reference";Code[20])
        {
            CaptionML = ENU='IC Partner Reference',
                        ENA='IC Partner Reference';
        }
        field(123;"Prepayment Line";Boolean)
        {
            CaptionML = ENU='Prepayment Line',
                        ENA='Prepayment Line';
            Editable = false;
        }
        field(130;"IC Partner Code";Code[20])
        {
            CaptionML = ENU='IC Partner Code',
                        ENA='IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(131;"Posting Date";Date)
        {
            CaptionML = ENU='Posting Date',
                        ENA='Posting Date';
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
            Editable = false;
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
        }
        field(1002;"Job Contract Entry No.";Integer)
        {
            CaptionML = ENU='Job Contract Entry No.',
                        ENA='Job Contract Entry No.';
            Editable = false;
        }
        field(1700;"Deferral Code";Code[10])
        {
            CaptionML = ENU='Deferral Code',
                        ENA='Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(5402;"Variant Code";Code[10])
        {
            CaptionML = ENU='Variant Code',
                        ENA='Variant Code';
            TableRelation = IF (Type=CONST(Item)) "Item Variant".Code WHERE (Item No.=FIELD(No.));
        }
        field(5403;"Bin Code";Code[20])
        {
            CaptionML = ENU='Bin Code',
                        ENA='Bin Code';
            TableRelation = Bin.Code WHERE (Location Code=FIELD(Location Code), Item Filter=FIELD(No.), Variant Filter=FIELD(Variant Code));
        }
        field(5404;"Qty. per Unit of Measure";Decimal)
        {
            CaptionML = ENU='Qty. per Unit of Measure',
                        ENA='Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(5407;"Unit of Measure Code";Code[10])
        {
            CaptionML = ENU='Unit of Measure Code',
                        ENA='Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(No.)) ELSE "Unit of Measure";
        }
        field(5415;"Quantity (Base)";Decimal)
        {
            CaptionML = ENU='Quantity (Base)',
                        ENA='Quantity (Base)';
            DecimalPlaces = 0:5;
        }
        field(5600;"FA Posting Date";Date)
        {
            CaptionML = ENU='FA Posting Date',
                        ENA='FA Posting Date';
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            CaptionML = ENU='Depreciation Book Code',
                        ENA='Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            CaptionML = ENU='Depr. until FA Posting Date',
                        ENA='Depr. until FA Posting Date';
        }
        field(5612;"Duplicate in Depreciation Book";Code[10])
        {
            CaptionML = ENU='Duplicate in Depreciation Book',
                        ENA='Duplicate in Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(5613;"Use Duplication List";Boolean)
        {
            CaptionML = ENU='Use Duplication List',
                        ENA='Use Duplication List';
        }
        field(5700;"Responsibility Center";Code[10])
        {
            CaptionML = ENU='Responsibility Center',
                        ENA='Responsibility Centre';
            TableRelation = "Responsibility Center";
        }
        field(5705;"Cross-Reference No.";Code[20])
        {
            AccessByPermission = TableData "Item Cross Reference"=R;
            CaptionML = ENU='Cross-Reference No.',
                        ENA='Cross-Reference No.';
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
            TableRelation = IF (Type=CONST(Item)) "Item Category";
        }
        field(5710;Nonstock;Boolean)
        {
            CaptionML = ENU='Nonstock',
                        ENA='Nonstock';
        }
        field(5711;"Purchasing Code";Code[10])
        {
            CaptionML = ENU='Purchasing Code',
                        ENA='Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5712;"Product Group Code";Code[10])
        {
            CaptionML = ENU='Product Group Code',
                        ENA='Product Group Code';
            TableRelation = "Product Group".Code WHERE (Item Category Code=FIELD(Item Category Code));
            ValidateTableRelation = false;
        }
        field(5811;"Appl.-from Item Entry";Integer)
        {
            AccessByPermission = TableData Item=R;
            CaptionML = ENU='Appl.-from Item Entry',
                        ENA='Appl.-from Item Entry';
            MinValue = 0;
        }
        field(6608;"Return Reason Code";Code[10])
        {
            CaptionML = ENU='Return Reason Code',
                        ENA='Return Reason Code';
            TableRelation = "Return Reason";
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
        }
        field(17110;"S/T Exempt";Boolean)
        {
            CaptionML = ENU='S/T Exempt',
                        ENA='S/T Exempt';
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
        field(28090;"Prepayment %";Decimal)
        {
            CaptionML = ENU='Prepayment %',
                        ENA='Prepayment %';
        }
        field(50000;Narration;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = Amount,"Amount Including VAT";
        }
        key(Key2;"Blanket Order No.","Blanket Order Line No.")
        {
        }
        key(Key3;"Sell-to Customer No.")
        {
        }
        key(Key4;"Sell-to Customer No.",Type,"Document No.")
        {
            Enabled = false;
            MaintainSQLIndex = false;
        }
        key(Key5;"Shipment No.","Shipment Line No.")
        {
        }
        key(Key6;"Job Contract Entry No.")
        {
        }
        key(Key7;"Bill-to Customer No.")
        {
        }
        key(Key8;"Document No.","WHT Business Posting Group","WHT Product Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        SalesDocLineComments : Record "Sales Comment Line";
        PostedDeferralHeader : Record "Posted Deferral Header";
    begin
        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesDocLineComments.ISEMPTY THEN
          SalesDocLineComments.DELETEALL;

        PostedDeferralHeader.DeleteHeader(DeferralUtilities.GetSalesDeferralDocType,'','',
          SalesDocLineComments."Document Type"::"Posted Invoice","Document No.","Line No.");
    end;

    var
        ApplicationAreaSetup : Record "Application Area Setup";
        DimMgt : Codeunit DimensionManagement;
        SalesInvLine : Record "Sales Invoice Line";
        DeferralUtilities : Codeunit "Deferral Utilities";
        ItemNoFieldCaptionTxt : TextConst ENU='Item No.',ENA='Item No.';

    procedure GetCurrencyCode() : Code[10];
    var
        SalesInvHeader : Record "Sales Invoice Header";
    begin
        IF "Document No." = SalesInvHeader."No." THEN
          EXIT(SalesInvHeader."Currency Code");
        IF SalesInvHeader.GET("Document No.") THEN
          EXIT(SalesInvHeader."Currency Code");
        EXIT('');
    end;

    procedure ShowDimensions();
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',TABLECAPTION,"Document No.","Line No."));
    end;

    procedure ShowItemTrackingLines();
    var
        ItemTrackingDocMgt : Codeunit "Item Tracking Doc. Management";
    begin
        ItemTrackingDocMgt.ShowItemTrackingForInvoiceLine(RowID1);
    end;

    procedure CalcVATAmountLines(SalesInvHeader : Record "Sales Invoice Header";var TempVATAmountLine : Record "VAT Amount Line" temporary);
    var
        GLSetup : Record "General Ledger Setup";
        IsFullGST : Boolean;
    begin
        TempVATAmountLine.DELETEALL;
        GLSetup.GET;
        SETRANGE("Document No.",SalesInvHeader."No.");
        SETFILTER(Type,'<>%1',Type::" ");
        IF FIND('-') THEN
          REPEAT
            TempVATAmountLine.INIT;
            TempVATAmountLine."VAT Identifier" := "VAT Identifier";
            TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
            TempVATAmountLine."Tax Group Code" := "Tax Group Code";
            TempVATAmountLine."VAT %" := "VAT %";
            IsFullGST := GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
            IF NOT IsFullGST THEN BEGIN
              IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                TempVATAmountLine."VAT Base" := Amount * (1 - SalesInvHeader."VAT Base Discount %" / 100)
              ELSE
                TempVATAmountLine."VAT Base" := Amount;
            END ELSE
              IF GLSetup."Pmt. Disc. Excl. VAT" THEN BEGIN
                TempVATAmountLine."VAT Base" := Amount * (1 - SalesInvHeader."VAT Base Discount %" / 100);
                IF "Prepayment Line" = TRUE THEN BEGIN
                  TempVATAmountLine."VAT Base" := "VAT Base Amount";
                  SalesInvLine.RESET;
                  SalesInvLine.SETRANGE("Document No.",SalesInvHeader."No.");
                  SalesInvLine.SETRANGE("Prepayment Line",FALSE);
                  IF SalesInvLine.FIND('-') THEN BEGIN
                    TempVATAmountLine."VAT Base" := 0;
                    REPEAT
                      TempVATAmountLine."VAT Base" -= SalesInvLine.Amount * (1 - SalesInvHeader."VAT Base Discount %" / 100);
                    UNTIL SalesInvLine.NEXT = 0;
                  END;
                END;
              END ELSE BEGIN
                TempVATAmountLine."VAT Base" := Amount;
                IF "Prepayment Line" = TRUE THEN BEGIN
                  TempVATAmountLine."VAT Base" := "VAT Base Amount";
                  SalesInvLine.RESET;
                  SalesInvLine.SETRANGE("Document No.",SalesInvHeader."No.");
                  SalesInvLine.SETRANGE("Prepayment Line",FALSE);
                  IF SalesInvLine.FIND('-') THEN BEGIN
                    TempVATAmountLine."VAT Base" := 0;
                    REPEAT
                      TempVATAmountLine."VAT Base" -= SalesInvLine.Amount;
                    UNTIL SalesInvLine.NEXT = 0;
                  END;
                END;
              END;
            TempVATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
            TempVATAmountLine."Amount Including VAT" := "Amount Including VAT";
            TempVATAmountLine."Line Amount" := "Line Amount";
            IF "Allow Invoice Disc." THEN
              TempVATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
            TempVATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
            TempVATAmountLine.Quantity := "Quantity (Base)";
            TempVATAmountLine."Calculated VAT Amount" := "Amount Including VAT" - Amount - "VAT Difference";
            TempVATAmountLine."VAT Difference" := "VAT Difference";
            TempVATAmountLine."Includes Prepayment" := "Prepayment Line";
            TempVATAmountLine.InsertLine;
          UNTIL NEXT = 0;
    end;

    local procedure GetFieldCaption(FieldNumber : Integer) : Text[100];
    var
        "Field" : Record "Field";
    begin
        Field.GET(DATABASE::"Sales Invoice Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber : Integer) : Text[80];
    var
        SalesInvHeader : Record "Sales Invoice Header";
    begin
        IF NOT SalesInvHeader.GET("Document No.") THEN
          SalesInvHeader.INIT;
        CASE FieldNumber OF
          FIELDNO("No."):
            BEGIN
              IF ApplicationAreaSetup.IsFoundationEnabled THEN
                EXIT(STRSUBSTNO('3,%1',ItemNoFieldCaptionTxt));
              EXIT(STRSUBSTNO('3,%1',GetFieldCaption(FieldNumber)));
            END;
          ELSE BEGIN
            IF SalesInvHeader."Prices Including VAT" THEN
              EXIT('2,1,' + GetFieldCaption(FieldNumber));
            EXIT('2,0,' + GetFieldCaption(FieldNumber));
          END
        END;
    end;

    procedure RowID1() : Text[250];
    var
        ItemTrackingMgt : Codeunit "Item Tracking Management";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Sales Invoice Line",
            0,"Document No.",'',0,"Line No."));
    end;

    local procedure GetSalesShptLines(var TempSalesShptLine : Record "Sales Shipment Line" temporary);
    var
        SalesShptLine : Record "Sales Shipment Line";
        ItemLedgEntry : Record "Item Ledger Entry";
        ValueEntry : Record "Value Entry";
    begin
        TempSalesShptLine.RESET;
        TempSalesShptLine.DELETEALL;

        IF Type <> Type::Item THEN
          EXIT;

        FilterPstdDocLineValueEntries(ValueEntry);
        IF ValueEntry.FINDSET THEN
          REPEAT
            ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
            IF ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Sales Shipment" THEN
              IF SalesShptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") THEN BEGIN
                TempSalesShptLine.INIT;
                TempSalesShptLine := SalesShptLine;
                IF TempSalesShptLine.INSERT THEN;
              END;
          UNTIL ValueEntry.NEXT = 0;
    end;

    procedure CalcShippedSaleNotReturned(var ShippedQtyNotReturned : Decimal;var RevUnitCostLCY : Decimal;ExactCostReverse : Boolean);
    var
        TempItemLedgEntry : Record "Item Ledger Entry" temporary;
        TotalCostLCY : Decimal;
        TotalQtyBase : Decimal;
    begin
        ShippedQtyNotReturned := 0;
        IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
          RevUnitCostLCY := "Unit Cost (LCY)";
          EXIT;
        END;

        RevUnitCostLCY := 0;
        GetItemLedgEntries(TempItemLedgEntry,FALSE);
        IF TempItemLedgEntry.FINDSET THEN
          REPEAT
            ShippedQtyNotReturned := ShippedQtyNotReturned - TempItemLedgEntry."Shipped Qty. Not Returned";
            IF ExactCostReverse THEN BEGIN
              TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
              TotalCostLCY :=
                TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
              TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
            END;
          UNTIL TempItemLedgEntry.NEXT = 0;

        IF ExactCostReverse AND (ShippedQtyNotReturned <> 0) AND (TotalQtyBase <> 0) THEN
          RevUnitCostLCY := ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
        ELSE
          RevUnitCostLCY := "Unit Cost (LCY)";
        ShippedQtyNotReturned := CalcQty(ShippedQtyNotReturned);

        IF ShippedQtyNotReturned > Quantity THEN
          ShippedQtyNotReturned := Quantity;
    end;

    local procedure CalcQty(QtyBase : Decimal) : Decimal;
    begin
        IF "Qty. per Unit of Measure" = 0 THEN
          EXIT(QtyBase);
        EXIT(ROUND(QtyBase / "Qty. per Unit of Measure",0.00001));
    end;

    procedure GetItemLedgEntries(var TempItemLedgEntry : Record "Item Ledger Entry" temporary;SetQuantity : Boolean);
    var
        ItemLedgEntry : Record "Item Ledger Entry";
        ValueEntry : Record "Value Entry";
    begin
        IF SetQuantity THEN BEGIN
          TempItemLedgEntry.RESET;
          TempItemLedgEntry.DELETEALL;

          IF Type <> Type::Item THEN
            EXIT;
        END;

        FilterPstdDocLineValueEntries(ValueEntry);
        ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
        IF ValueEntry.FINDSET THEN
          REPEAT
            ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
            TempItemLedgEntry := ItemLedgEntry;
            IF SetQuantity THEN BEGIN
              TempItemLedgEntry.Quantity := ValueEntry."Invoiced Quantity";
              IF ABS(TempItemLedgEntry."Shipped Qty. Not Returned") > ABS(TempItemLedgEntry.Quantity) THEN
                TempItemLedgEntry."Shipped Qty. Not Returned" := TempItemLedgEntry.Quantity;
            END;
            IF TempItemLedgEntry.INSERT THEN;
          UNTIL ValueEntry.NEXT = 0;
    end;

    procedure FilterPstdDocLineValueEntries(var ValueEntry : Record "Value Entry");
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.","Document No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Sales Invoice");
        ValueEntry.SETRANGE("Document Line No.","Line No.");
    end;

    procedure ShowItemShipmentLines();
    var
        TempSalesShptLine : Record "Sales Shipment Line" temporary;
    begin
        IF Type = Type::Item THEN BEGIN
          GetSalesShptLines(TempSalesShptLine);
          PAGE.RUNMODAL(0,TempSalesShptLine);
        END;
    end;

    procedure ShowLineComments();
    var
        SalesDocLineComments : Record "Sales Comment Line";
        SalesDocCommentSheet : Page "Sales Comment Sheet";
    begin
        SalesDocLineComments.SETRANGE("Document Type",SalesDocLineComments."Document Type"::"Posted Invoice");
        SalesDocLineComments.SETRANGE("No.","Document No.");
        SalesDocLineComments.SETRANGE("Document Line No.","Line No.");
        SalesDocCommentSheet.SETTABLEVIEW(SalesDocLineComments);
        SalesDocCommentSheet.RUNMODAL;
    end;

    procedure InitFromSalesLine(SalesInvHeader : Record "Sales Invoice Header";SalesLine : Record "Sales Line");
    begin
        INIT;
        TRANSFERFIELDS(SalesLine);
        IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
          Type := Type::" ";
        "Posting Date" := SalesInvHeader."Posting Date";
        //ASHNEIL CHANDRA  05/08/2016
        Narration := SalesLine.Narration;
        //ASHNEIL CHANDRA  05/08/2016
        "Document No." := SalesInvHeader."No.";
        Quantity := SalesLine."Qty. to Invoice";
        "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";
    end;

    procedure ShowDeferrals();
    begin
        DeferralUtilities.OpenLineScheduleView(
          "Deferral Code",DeferralUtilities.GetSalesDeferralDocType,'','',
          GetDocumentType,"Document No.","Line No.");
    end;

    procedure GetDocumentType() : Integer;
    var
        SalesCommentLine : Record "Sales Comment Line";
    begin
        EXIT(SalesCommentLine."Document Type"::"Posted Invoice")
    end;
}

