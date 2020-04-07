table 123 "Purch. Inv. Line"
{
    // version NAVW110.00.00.16585,NAVAPAC10.00.00.16585

    CaptionML = ENU='Purch. Inv. Line',
                ENA='Purch. Inv. Line';
    DrillDownPageID = 529;
    LookupPageID = 529;
    Permissions = TableData "Item Ledger Entry"=r,
                  TableData "Value Entry"=r;

    fields
    {
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
            TableRelation = "Purch. Inv. Header";
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
        }
        field(6;"No.";Code[20])
        {
            CaptionML = ENU='No.',
                        ENA='No.';
            TableRelation = IF (Type=CONST(G/L Account)) "G/L Account" ELSE IF (Type=CONST(Item)) Item ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Type=CONST("Charge (Item)")) "Item Charge";
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
        field(10;"Expected Receipt Date";Date)
        {
            CaptionML = ENU='Expected Receipt Date',
                        ENA='Expected Receipt Date';
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
        field(22;"Direct Unit Cost";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 2;
            CaptionClass = GetCaptionClass(FIELDNO("Direct Unit Cost"));
            CaptionML = ENU='Direct Unit Cost',
                        ENA='Direct Unit Cost';
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
        field(45;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            TableRelation = Job;
        }
        field(54;"Indirect Cost %";Decimal)
        {
            CaptionML = ENU='Indirect Cost %',
                        ENA='Indirect Cost %';
            DecimalPlaces = 0:5;
            MinValue = 0;
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
        field(68;"Pay-to Vendor No.";Code[20])
        {
            CaptionML = ENU='Pay-to Vendor No.',
                        ENA='Pay-to Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(69;"Inv. Discount Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Inv. Discount Amount',
                        ENA='Inv. Discount Amount';
        }
        field(70;"Vendor Item No.";Text[20])
        {
            CaptionML = ENU='Vendor Item No.',
                        ENA='Vendor Item No.';
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
            TableRelation = "Purch. Inv. Line"."Line No." WHERE (Document No.=FIELD(Document No.));
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
        field(88;"Use Tax";Boolean)
        {
            CaptionML = ENU='Use Tax',
                        ENA='Use US Tax';
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
            TableRelation = "Purchase Header".No. WHERE (Document Type=CONST(Blanket Order));
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(98;"Blanket Order Line No.";Integer)
        {
            CaptionML = ENU='Blanket Order Line No.',
                        ENA='Blanket Order Line No.';
            TableRelation = "Purchase Line"."Line No." WHERE (Document Type=CONST(Blanket Order), Document No.=FIELD(Blanket Order No.));
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
            TableRelation = "Job Task"."Job Task No." WHERE (Job No.=FIELD(Job No.));
        }
        field(1002;"Job Line Type";Option)
        {
            CaptionML = ENU='Job Line Type',
                        ENA='Job Line Type';
            OptionCaptionML = ENU=' ,Budget,Billable,Both Budget and Billable',
                              ENA=' ,Budget,Billable,Both Budget and Billable';
            OptionMembers = " ",Budget,Billable,"Both Budget and Billable";
        }
        field(1003;"Job Unit Price";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Unit Price',
                        ENA='Job Unit Price';
        }
        field(1004;"Job Total Price";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Total Price',
                        ENA='Job Total Price';
        }
        field(1005;"Job Line Amount";Decimal)
        {
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Amount',
                        ENA='Job Line Amount';
        }
        field(1006;"Job Line Discount Amount";Decimal)
        {
            AutoFormatExpression = "Job Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Discount Amount',
                        ENA='Job Line Discount Amount';
        }
        field(1007;"Job Line Discount %";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Line Discount %',
                        ENA='Job Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(1008;"Job Unit Price (LCY)";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Unit Price (LCY)',
                        ENA='Job Unit Price (LCY)';
        }
        field(1009;"Job Total Price (LCY)";Decimal)
        {
            BlankZero = true;
            CaptionML = ENU='Job Total Price (LCY)',
                        ENA='Job Total Price (LCY)';
        }
        field(1010;"Job Line Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Amount (LCY)',
                        ENA='Job Line Amount (LCY)';
        }
        field(1011;"Job Line Disc. Amount (LCY)";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Job Line Disc. Amount (LCY)',
                        ENA='Job Line Disc. Amount (LCY)';
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
        field(1700;"Deferral Code";Code[10])
        {
            CaptionML = ENU='Deferral Code',
                        ENA='Deferral Code';
            TableRelation = "Deferral Template"."Deferral Code";
        }
        field(5401;"Prod. Order No.";Code[20])
        {
            CaptionML = ENU='Prod. Order No.',
                        ENA='Prod. Order No.';
            TableRelation = "Production Order".No. WHERE (Status=FILTER(Released|Finished));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        field(5601;"FA Posting Type";Option)
        {
            CaptionML = ENU='FA Posting Type',
                        ENA='FA Posting Type';
            OptionCaptionML = ENU=' ,Acquisition Cost,Maintenance',
                              ENA=' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(5602;"Depreciation Book Code";Code[10])
        {
            CaptionML = ENU='Depreciation Book Code',
                        ENA='Depreciation Book Code';
            TableRelation = "Depreciation Book";
        }
        field(5603;"Salvage Value";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Salvage Value',
                        ENA='Salvage Value';
        }
        field(5605;"Depr. until FA Posting Date";Boolean)
        {
            CaptionML = ENU='Depr. until FA Posting Date',
                        ENA='Depr. until FA Posting Date';
        }
        field(5606;"Depr. Acquisition Cost";Boolean)
        {
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
        field(6608;"Return Reason Code";Code[10])
        {
            CaptionML = ENU='Return Reason Code',
                        ENA='Return Reason Code';
            TableRelation = "Return Reason";
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
        field(28091;"Prepayment %";Decimal)
        {
            CaptionML = ENU='Prepayment %',
                        ENA='Prepayment %';
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
            TableRelation = "Prod. Order Routing Line"."Operation No." WHERE (Status=FILTER(Released..), Prod. Order No.=FIELD(Prod. Order No.), Routing No.=FIELD(Routing No.));
        }
        field(99000752;"Work Center No.";Code[20])
        {
            CaptionML = ENU='Work Center No.',
                        ENA='Work Centre No.';
            TableRelation = "Work Center";
        }
        field(99000754;"Prod. Order Line No.";Integer)
        {
            CaptionML = ENU='Prod. Order Line No.',
                        ENA='Prod. Order Line No.';
            TableRelation = "Prod. Order Line"."Line No." WHERE (Status=FILTER(Released..), Prod. Order No.=FIELD(Prod. Order No.));
        }
        field(99000755;"Overhead Rate";Decimal)
        {
            CaptionML = ENU='Overhead Rate',
                        ENA='Overhead Rate';
            DecimalPlaces = 0:5;
        }
        field(99000759;"Routing Reference No.";Integer)
        {
            CaptionML = ENU='Routing Reference No.',
                        ENA='Routing Reference No.';
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
        key(Key3;Type,"No.","Variant Code")
        {
        }
        key(Key4;"Buy-from Vendor No.")
        {
        }
        key(Key5;"Document No.","WHT Business Posting Group","WHT Product Posting Group")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        PurchDocLineComments : Record "Purch. Comment Line";
        PostedDeferralHeader : Record "Posted Deferral Header";
    begin
        PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::"Posted Invoice");
        PurchDocLineComments.SETRANGE("No.","Document No.");
        PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
        IF NOT PurchDocLineComments.ISEMPTY THEN
          PurchDocLineComments.DELETEALL;

        PostedDeferralHeader.DeleteHeader(DeferralUtilities.GetPurchDeferralDocType,'','',
          PurchDocLineComments."Document Type"::"Posted Invoice","Document No.","Line No.");
    end;

    var
        DimMgt : Codeunit DimensionManagement;
        DeferralUtilities : Codeunit "Deferral Utilities";

    procedure GetCurrencyCode() : Code[10];
    var
        PurchInvHeader : Record "Purch. Inv. Header";
    begin
        IF "Document No." = PurchInvHeader."No." THEN
          EXIT(PurchInvHeader."Currency Code");
        IF PurchInvHeader.GET("Document No.") THEN
          EXIT(PurchInvHeader."Currency Code");
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

    procedure CalcVATAmountLines(PurchInvHeader : Record "Purch. Inv. Header";var TempVATAmountLine : Record "VAT Amount Line" temporary);
    var
        GLSetup : Record "General Ledger Setup";
        PurchInvLine : Record "Purch. Inv. Line";
        IsFullGST : Boolean;
    begin
        GLSetup.GET;
        TempVATAmountLine.DELETEALL;
        SETRANGE("Document No.",PurchInvHeader."No.");
        SETFILTER(Type,'<>%1',Type::" ");
        IF FIND('-') THEN
          REPEAT
            TempVATAmountLine.INIT;
            TempVATAmountLine."VAT Identifier" := "VAT Identifier";
            TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
            TempVATAmountLine."Tax Group Code" := "Tax Group Code";
            TempVATAmountLine."Use Tax" := "Use Tax";
            TempVATAmountLine."VAT %" := "VAT %";
            TempVATAmountLine."Line Amount" := "Line Amount";
            TempVATAmountLine."Amount Including VAT" := "Amount Including VAT";
            TempVATAmountLine."VAT Amount" := "Amount Including VAT" - Amount;
            IsFullGST := GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group");
            IF NOT IsFullGST THEN BEGIN
              IF GLSetup."Pmt. Disc. Excl. VAT" THEN
                TempVATAmountLine."VAT Base" := Amount * (1 - PurchInvHeader."VAT Base Discount %" / 100)
              ELSE
                TempVATAmountLine."VAT Base" := Amount;
            END ELSE
              IF GLSetup."Pmt. Disc. Excl. VAT" THEN BEGIN
                TempVATAmountLine."VAT Base" := Amount * (1 - PurchInvHeader."VAT Base Discount %" / 100);
                IF "Prepayment Line" THEN BEGIN
                  TempVATAmountLine."VAT Base" := "VAT Base Amount";
                  PurchInvLine.RESET;
                  PurchInvLine.SETRANGE("Document No.",PurchInvHeader."No.");
                  PurchInvLine.SETRANGE("Prepayment Line",FALSE);
                  IF PurchInvLine.FIND('-') THEN BEGIN
                    TempVATAmountLine."VAT Base" := 0;
                    REPEAT
                      TempVATAmountLine."VAT Base" -= PurchInvLine.Amount * (1 - PurchInvHeader."VAT Base Discount %" / 100);
                    UNTIL PurchInvLine.NEXT = 0;
                  END;
                END;
              END ELSE BEGIN
                TempVATAmountLine."VAT Base" := Amount;
                IF "Prepayment Line" = TRUE THEN BEGIN
                  TempVATAmountLine."VAT Base" := "VAT Base Amount";
                  PurchInvLine.RESET;
                  PurchInvLine.SETRANGE("Document No.",PurchInvHeader."No.");
                  PurchInvLine.SETRANGE("Prepayment Line",FALSE);
                  IF PurchInvLine.FIND('-') THEN BEGIN
                    TempVATAmountLine."VAT Base" := 0;
                    REPEAT
                      TempVATAmountLine."VAT Base" -= PurchInvLine.Amount;
                    UNTIL PurchInvLine.NEXT = 0;
                  END;
                END;
              END;
            IF "Prepayment Line" THEN
              IF GLSetup.CheckFullGSTonPrepayment("VAT Bus. Posting Group","VAT Prod. Posting Group") THEN
                IF PurchInvHeader."Prices Including VAT" THEN BEGIN
                  TempVATAmountLine."VAT Amount" := TempVATAmountLine."VAT Base" * TempVATAmountLine."VAT %" / 100;
                  IF TempVATAmountLine."VAT Amount" > 0 THEN
                    TempVATAmountLine."Amount Including VAT" := "Line Amount";
                  IF TempVATAmountLine."VAT Amount" < 0 THEN
                    TempVATAmountLine."Amount Including VAT" := "Line Amount" + TempVATAmountLine."VAT Amount";
                END ELSE BEGIN
                  TempVATAmountLine."VAT Amount" := TempVATAmountLine."VAT Base" * TempVATAmountLine."VAT %" / 100;
                  TempVATAmountLine."Amount Including VAT" := "Line Amount" + TempVATAmountLine."VAT Amount";
                END;
            TempVATAmountLine."Amount Including VAT" := "Amount Including VAT";
            IF "Allow Invoice Disc." THEN
              TempVATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
            TempVATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
            TempVATAmountLine.Quantity := "Quantity (Base)";
            TempVATAmountLine."Calculated VAT Amount" := "Amount Including VAT" - Amount - "VAT Difference";
            TempVATAmountLine."VAT Difference" := "VAT Difference";
            TempVATAmountLine."VAT Base (ACY)" := "VAT Base (ACY)";
            TempVATAmountLine."VAT Amount (ACY)" := "Amount Including VAT (ACY)" - "Amount (ACY)";
            TempVATAmountLine."Amount Including VAT (ACY)" := "Amount Including VAT (ACY)";
            TempVATAmountLine."Amount (ACY)" := "Amount (ACY)";
            TempVATAmountLine."VAT Difference (ACY)" := "VAT Difference (ACY)";
            TempVATAmountLine."Calculated VAT Amount (ACY)" :=
              "Amount Including VAT (ACY)" - "Amount (ACY)" - "VAT Difference (ACY)";
            TempVATAmountLine."Includes Prepayment" := "Prepayment Line";
            TempVATAmountLine.InsertLine;
          UNTIL NEXT = 0;
    end;

    local procedure GetFieldCaption(FieldNumber : Integer) : Text[100];
    var
        "Field" : Record "Field";
    begin
        Field.GET(DATABASE::"Purch. Inv. Line",FieldNumber);
        EXIT(Field."Field Caption");
    end;

    local procedure GetCaptionClass(FieldNumber : Integer) : Text[80];
    var
        PurchInvHeader : Record "Purch. Inv. Header";
    begin
        IF NOT PurchInvHeader.GET("Document No.") THEN
          PurchInvHeader.INIT;
        IF PurchInvHeader."Prices Including VAT" THEN
          EXIT('2,1,' + GetFieldCaption(FieldNumber));

        EXIT('2,0,' + GetFieldCaption(FieldNumber));
    end;

    procedure RowID1() : Text[250];
    var
        ItemTrackingMgt : Codeunit "Item Tracking Management";
    begin
        EXIT(ItemTrackingMgt.ComposeRowID(DATABASE::"Purch. Inv. Line",
            0,"Document No.",'',0,"Line No."));
    end;

    local procedure GetPurchRcptLines(var TempPurchRcptLine : Record "Purch. Rcpt. Line" temporary);
    var
        PurchRcptLine : Record "Purch. Rcpt. Line";
        ItemLedgEntry : Record "Item Ledger Entry";
        ValueEntry : Record "Value Entry";
    begin
        TempPurchRcptLine.RESET;
        TempPurchRcptLine.DELETEALL;

        IF Type <> Type::Item THEN
          EXIT;

        FilterPstdDocLineValueEntries(ValueEntry);
        ValueEntry.SETFILTER("Invoiced Quantity",'<>0');
        IF ValueEntry.FINDSET THEN
          REPEAT
            ItemLedgEntry.GET(ValueEntry."Item Ledger Entry No.");
            IF ItemLedgEntry."Document Type" = ItemLedgEntry."Document Type"::"Purchase Receipt" THEN
              IF PurchRcptLine.GET(ItemLedgEntry."Document No.",ItemLedgEntry."Document Line No.") THEN BEGIN
                TempPurchRcptLine.INIT;
                TempPurchRcptLine := PurchRcptLine;
                IF TempPurchRcptLine.INSERT THEN;
              END;
          UNTIL ValueEntry.NEXT = 0;
    end;

    procedure CalcReceivedPurchNotReturned(var RemainingQty : Decimal;var RevUnitCostLCY : Decimal;ExactCostReverse : Boolean);
    var
        TempItemLedgEntry : Record "Item Ledger Entry" temporary;
        TotalCostLCY : Decimal;
        TotalQtyBase : Decimal;
    begin
        RemainingQty := 0;
        IF (Type <> Type::Item) OR (Quantity <= 0) THEN BEGIN
          RevUnitCostLCY := "Unit Cost (LCY)";
          EXIT;
        END;

        RevUnitCostLCY := 0;
        GetItemLedgEntries(TempItemLedgEntry,FALSE);

        IF TempItemLedgEntry.FINDSET THEN
          REPEAT
            RemainingQty := RemainingQty + TempItemLedgEntry."Remaining Quantity";
            IF ExactCostReverse THEN BEGIN
              TempItemLedgEntry.CALCFIELDS("Cost Amount (Expected)","Cost Amount (Actual)");
              TotalCostLCY :=
                TotalCostLCY + TempItemLedgEntry."Cost Amount (Expected)" + TempItemLedgEntry."Cost Amount (Actual)";
              TotalQtyBase := TotalQtyBase + TempItemLedgEntry.Quantity;
            END;
          UNTIL TempItemLedgEntry.NEXT = 0;

        IF ExactCostReverse AND (RemainingQty <> 0) AND (TotalQtyBase <> 0) THEN
          RevUnitCostLCY :=
            ABS(TotalCostLCY / TotalQtyBase) * "Qty. per Unit of Measure"
        ELSE
          RevUnitCostLCY := "Unit Cost (LCY)";
        RemainingQty := CalcQty(RemainingQty);

        IF RemainingQty > Quantity THEN
          RemainingQty := Quantity;
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
          IF "Work Center No." <> '' THEN
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
              IF ABS(TempItemLedgEntry."Remaining Quantity") > ABS(TempItemLedgEntry.Quantity) THEN
                TempItemLedgEntry."Remaining Quantity" := ABS(TempItemLedgEntry.Quantity);
            END;
            IF TempItemLedgEntry.INSERT THEN;
          UNTIL ValueEntry.NEXT = 0;
    end;

    local procedure FilterPstdDocLineValueEntries(var ValueEntry : Record "Value Entry");
    begin
        ValueEntry.RESET;
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.","Document No.");
        ValueEntry.SETRANGE("Document Type",ValueEntry."Document Type"::"Purchase Invoice");
        ValueEntry.SETRANGE("Document Line No.","Line No.");
    end;

    procedure ShowItemReceiptLines();
    var
        TempPurchRcptLine : Record "Purch. Rcpt. Line" temporary;
    begin
        IF Type = Type::Item THEN BEGIN
          GetPurchRcptLines(TempPurchRcptLine);
          PAGE.RUNMODAL(0,TempPurchRcptLine);
        END;
    end;

    procedure ShowLineComments();
    var
        PurchDocLineComments : Record "Purch. Comment Line";
        PurchDocCommentSheet : Page "Purch. Comment Sheet";
    begin
        PurchDocLineComments.SETRANGE("Document Type",PurchDocLineComments."Document Type"::"Posted Invoice");
        PurchDocLineComments.SETRANGE("No.","Document No.");
        PurchDocLineComments.SETRANGE("Document Line No.","Line No.");
        PurchDocCommentSheet.SETTABLEVIEW(PurchDocLineComments);
        PurchDocCommentSheet.RUNMODAL;
    end;

    procedure InitFromPurchLine(PurchInvHeader : Record "Purch. Inv. Header";PurchLine : Record "Purchase Line");
    begin
        INIT;
        TRANSFERFIELDS(PurchLine);
        IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
          Type := Type::" ";
        "Posting Date" := PurchInvHeader."Posting Date";
        "Document No." := PurchInvHeader."No.";
        //ASHNEIL CHANDRA  05/08/2016
        Narration := PurchLine.Narration;
        //ASHNEIL CHANDRA  05/08/2016
        Quantity := PurchLine."Qty. to Invoice";
        "Quantity (Base)" := PurchLine."Qty. to Invoice (Base)";
    end;

    procedure ShowDeferrals();
    begin
        DeferralUtilities.OpenLineScheduleView(
          "Deferral Code",DeferralUtilities.GetPurchDeferralDocType,'','',
          GetDocumentType,"Document No.","Line No.");
    end;

    procedure GetDocumentType() : Integer;
    var
        PurchCommentLine : Record "Purch. Comment Line";
    begin
        EXIT(PurchCommentLine."Document Type"::"Posted Invoice")
    end;
}

