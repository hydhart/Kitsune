table 17 "G/L Entry"
{
    // version NAVW110.00,NAVAPAC10.00

    CaptionML = ENU='G/L Entry',
                ENA='G/L Entry';
    DrillDownPageID = 20;
    LookupPageID = 20;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            CaptionML = ENU='Entry No.',
                        ENA='Entry No.';
        }
        field(3;"G/L Account No.";Code[20])
        {
            CaptionML = ENU='G/L Account No.',
                        ENA='G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(4;"Posting Date";Date)
        {
            CaptionML = ENU='Posting Date',
                        ENA='Posting Date';
            ClosingDates = true;
        }
        field(5;"Document Type";Option)
        {
            CaptionML = ENU='Document Type',
                        ENA='Document Type';
            OptionCaptionML = ENU=' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund',
                              ENA=' ,Payment,Invoice,CR/Adj Note,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(6;"Document No.";Code[20])
        {
            CaptionML = ENU='Document No.',
                        ENA='Document No.';

            trigger OnLookup();
            var
                IncomingDocument : Record "Incoming Document";
            begin
                IncomingDocument.HyperlinkToDocument("Document No.","Posting Date");
            end;
        }
        field(7;Description;Text[50])
        {
            CaptionML = ENU='Description',
                        ENA='Description';
        }
        field(10;"Bal. Account No.";Code[20])
        {
            CaptionML = ENU='Bal. Account No.',
                        ENA='Bal. Account No.';
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account" ELSE IF (Bal. Account Type=CONST(Customer)) Customer ELSE IF (Bal. Account Type=CONST(Vendor)) Vendor ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account" ELSE IF (Bal. Account Type=CONST(Fixed Asset)) "Fixed Asset" ELSE IF (Bal. Account Type=CONST(IC Partner)) "IC Partner";
        }
        field(17;Amount;Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='Amount',
                        ENA='Amount';
        }
        field(23;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU='Global Dimension 1 Code',
                        ENA='Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(24;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU='Global Dimension 2 Code',
                        ENA='Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(27;"User ID";Code[50])
        {
            CaptionML = ENU='User ID',
                        ENA='User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            var
                UserMgt : Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(28;"Source Code";Code[10])
        {
            CaptionML = ENU='Source Code',
                        ENA='Source Code';
            TableRelation = "Source Code";
        }
        field(29;"System-Created Entry";Boolean)
        {
            CaptionML = ENU='System-Created Entry',
                        ENA='System-Created Entry';
        }
        field(30;"Prior-Year Entry";Boolean)
        {
            CaptionML = ENU='Prior-Year Entry',
                        ENA='Prior-Year Entry';
        }
        field(41;"Job No.";Code[20])
        {
            CaptionML = ENU='Job No.',
                        ENA='Job No.';
            TableRelation = Job;
        }
        field(42;Quantity;Decimal)
        {
            CaptionML = ENU='Quantity',
                        ENA='Quantity';
            DecimalPlaces = 0:5;
        }
        field(43;"VAT Amount";Decimal)
        {
            AutoFormatType = 1;
            CaptionML = ENU='VAT Amount',
                        ENA='GST Amount';
        }
        field(45;"Business Unit Code";Code[10])
        {
            CaptionML = ENU='Business Unit Code',
                        ENA='Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(46;"Journal Batch Name";Code[10])
        {
            CaptionML = ENU='Journal Batch Name',
                        ENA='Journal Batch Name';
        }
        field(47;"Reason Code";Code[10])
        {
            CaptionML = ENU='Reason Code',
                        ENA='Reason Code';
            TableRelation = "Reason Code";
        }
        field(48;"Gen. Posting Type";Option)
        {
            CaptionML = ENU='Gen. Posting Type',
                        ENA='Gen. Posting Type';
            OptionCaptionML = ENU=' ,Purchase,Sale,Settlement',
                              ENA=' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(49;"Gen. Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Bus. Posting Group',
                        ENA='Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(50;"Gen. Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='Gen. Prod. Posting Group',
                        ENA='Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(51;"Bal. Account Type";Option)
        {
            CaptionML = ENU='Bal. Account Type',
                        ENA='Bal. Account Type';
            OptionCaptionML = ENU='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner',
                              ENA='G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(52;"Transaction No.";Integer)
        {
            CaptionML = ENU='Transaction No.',
                        ENA='Transaction No.';
        }
        field(53;"Debit Amount";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Debit Amount',
                        ENA='Debit Amount';
        }
        field(54;"Credit Amount";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CaptionML = ENU='Credit Amount',
                        ENA='Credit Amount';
        }
        field(55;"Document Date";Date)
        {
            CaptionML = ENU='Document Date',
                        ENA='Document Date';
            ClosingDates = true;
        }
        field(56;"External Document No.";Code[35])
        {
            CaptionML = ENU='External Document No.',
                        ENA='External Document No.';
        }
        field(57;"Source Type";Option)
        {
            CaptionML = ENU='Source Type',
                        ENA='Source Type';
            OptionCaptionML = ENU=' ,Customer,Vendor,Bank Account,Fixed Asset',
                              ENA=' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(58;"Source No.";Code[20])
        {
            CaptionML = ENU='Source No.',
                        ENA='Source No.';
            TableRelation = IF (Source Type=CONST(Customer)) Customer ELSE IF (Source Type=CONST(Vendor)) Vendor ELSE IF (Source Type=CONST(Bank Account)) "Bank Account" ELSE IF (Source Type=CONST(Fixed Asset)) "Fixed Asset";
        }
        field(59;"No. Series";Code[10])
        {
            CaptionML = ENU='No. Series',
                        ENA='No. Series';
            TableRelation = "No. Series";
        }
        field(60;"Tax Area Code";Code[20])
        {
            CaptionML = ENU='Tax Area Code',
                        ENA='US Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(61;"Tax Liable";Boolean)
        {
            CaptionML = ENU='Tax Liable',
                        ENA='US Tax Liable';
        }
        field(62;"Tax Group Code";Code[10])
        {
            CaptionML = ENU='Tax Group Code',
                        ENA='US Tax Group Code';
            TableRelation = "Tax Group";
        }
        field(63;"Use Tax";Boolean)
        {
            CaptionML = ENU='Use Tax',
                        ENA='Use US Tax';
        }
        field(64;"VAT Bus. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Bus. Posting Group',
                        ENA='GST Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(65;"VAT Prod. Posting Group";Code[10])
        {
            CaptionML = ENU='VAT Prod. Posting Group',
                        ENA='GST Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(68;"Additional-Currency Amount";Decimal)
        {
            AccessByPermission = TableData Currency=R;
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Additional-Currency Amount',
                        ENA='Additional-Currency Amount';
        }
        field(69;"Add.-Currency Debit Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Add.-Currency Debit Amount',
                        ENA='Add.-Currency Debit Amount';
        }
        field(70;"Add.-Currency Credit Amount";Decimal)
        {
            AutoFormatExpression = GetCurrencyCode;
            AutoFormatType = 1;
            CaptionML = ENU='Add.-Currency Credit Amount',
                        ENA='Add.-Currency Credit Amount';
        }
        field(71;"Close Income Statement Dim. ID";Integer)
        {
            CaptionML = ENU='Close Income Statement Dim. ID',
                        ENA='Close Income Statement Dim. ID';
        }
        field(72;"IC Partner Code";Code[20])
        {
            CaptionML = ENU='IC Partner Code',
                        ENA='IC Partner Code';
            TableRelation = "IC Partner";
        }
        field(73;Reversed;Boolean)
        {
            CaptionML = ENU='Reversed',
                        ENA='Reversed';
        }
        field(74;"Reversed by Entry No.";Integer)
        {
            BlankZero = true;
            CaptionML = ENU='Reversed by Entry No.',
                        ENA='Reversed by Entry No.';
            TableRelation = "G/L Entry";
        }
        field(75;"Reversed Entry No.";Integer)
        {
            BlankZero = true;
            CaptionML = ENU='Reversed Entry No.',
                        ENA='Reversed Entry No.';
            TableRelation = "G/L Entry";
        }
        field(76;"G/L Account Name";Text[50])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE (No.=FIELD(G/L Account No.)));
            CaptionML = ENU='G/L Account Name',
                        ENA='G/L Account Name';
            Editable = false;
            FieldClass = FlowField;
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
        field(5400;"Prod. Order No.";Code[20])
        {
            CaptionML = ENU='Prod. Order No.',
                        ENA='Prod. Order No.';
        }
        field(5600;"FA Entry Type";Option)
        {
            AccessByPermission = TableData "Fixed Asset"=R;
            CaptionML = ENU='FA Entry Type',
                        ENA='FA Entry Type';
            OptionCaptionML = ENU=' ,Fixed Asset,Maintenance',
                              ENA=' ,Fixed Asset,Maintenance';
            OptionMembers = " ","Fixed Asset",Maintenance;
        }
        field(5601;"FA Entry No.";Integer)
        {
            BlankZero = true;
            CaptionML = ENU='FA Entry No.',
                        ENA='FA Entry No.';
            TableRelation = IF (FA Entry Type=CONST(Fixed Asset)) "FA Ledger Entry" ELSE IF (FA Entry Type=CONST(Maintenance)) "Maintenance Ledger Entry";
        }
        field(11600;"BAS Doc. No.";Code[11])
        {
            CaptionML = ENU='BAS Doc. No.',
                        ENA='BAS Doc. No.';
            TableRelation = "BAS Calculation Sheet".A1;
        }
        field(11601;"BAS Adjustment";Boolean)
        {
            CaptionML = ENU='BAS Adjustment',
                        ENA='BAS Adjustment';
        }
        field(11602;Adjustment;Boolean)
        {
            CaptionML = ENU='Adjustment',
                        ENA='Adjustment';
        }
        field(11624;"BAS Version";Integer)
        {
            CaptionML = ENU='BAS Version',
                        ENA='BAS Version';
            TableRelation = "BAS Calculation Sheet"."BAS Version" WHERE (A1=FIELD(BAS Doc. No.));
        }
        field(11625;"Consol. BAS Doc. No.";Code[11])
        {
            CaptionML = ENU='Consol. BAS Doc. No.',
                        ENA='Consol. BAS Doc. No.';
        }
        field(11626;"Consol. Version No.";Integer)
        {
            CaptionML = ENU='Consol. Version No.',
                        ENA='Consol. Version No.';
        }
        field(28160;"Entry Type";Option)
        {
            CaptionML = ENU='Entry Type',
                        ENA='Entry Type';
            OptionCaptionML = ENU='Definitive,Simulation',
                              ENA='Definitive,Simulation';
            OptionMembers = Definitive,Simulation;
        }
        field(50000;Narration;Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"G/L Account No.","Posting Date")
        {
            SumIndexFields = Amount,"Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
        }
        key(Key3;"G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date","Entry Type")
        {
            SumIndexFields = Amount,"Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
        }
        key(Key4;"G/L Account No.","Business Unit Code","Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount,"Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
        }
        key(Key5;"G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code","Posting Date")
        {
            Enabled = false;
            SumIndexFields = Amount,"Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
        }
        key(Key6;"Document No.","Posting Date")
        {
        }
        key(Key7;"Transaction No.")
        {
        }
        key(Key8;"IC Partner Code")
        {
        }
        key(Key9;"G/L Account No.","Job No.","Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key10;"Posting Date","G/L Account No.","Dimension Set ID")
        {
            SumIndexFields = Amount;
        }
        key(Key11;"G/L Account No.","Posting Date","VAT Bus. Posting Group","VAT Prod. Posting Group")
        {
            SumIndexFields = "VAT Amount",Amount;
        }
        key(Key12;"BAS Doc. No.","BAS Version")
        {
        }
        key(Key13;"G/L Account No.","BAS Adjustment","VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date","BAS Doc. No.")
        {
            SumIndexFields = "VAT Amount",Amount;
        }
        key(Key14;"G/L Account No.","Posting Date","Entry Type")
        {
            SumIndexFields = Amount,"Debit Amount","Credit Amount","Additional-Currency Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount";
        }
        key(Key15;"Source Code","Posting Date","Document No.")
        {
        }
        key(Key16;"G/L Account No.","Posting Date","Source Code")
        {
        }
        key(Key17;"Entry Type","G/L Account No.")
        {
            SumIndexFields = Amount;
        }
        key(Key18;"Entry Type","G/L Account No.","Global Dimension 1 Code","Posting Date")
        {
            SumIndexFields = "Debit Amount","Credit Amount",Amount;
        }
        key(Key19;"G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code","Entry Type")
        {
        }
        key(Key20;"Entry Type","Business Unit Code","G/L Account No.","Posting Date")
        {
            SumIndexFields = Amount;
        }
        key(Key21;"Source Code","Document No.","Posting Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Entry No.",Description,"G/L Account No.","Posting Date","Document Type","Document No.")
        {
        }
    }

    var
        GLSetup : Record "General Ledger Setup";
        GLSetupRead : Boolean;

    procedure GetCurrencyCode() : Code[10];
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;

    procedure ShowValueEntries();
    var
        GLItemLedgRelation : Record "G/L - Item Ledger Relation";
        ValueEntry : Record "Value Entry";
        TempValueEntry : Record "Value Entry" temporary;
    begin
        GLItemLedgRelation.SETRANGE("G/L Entry No.","Entry No.");
        IF GLItemLedgRelation.FINDSET THEN
          REPEAT
            ValueEntry.GET(GLItemLedgRelation."Value Entry No.");
            TempValueEntry.INIT;
            TempValueEntry := ValueEntry;
            TempValueEntry.INSERT;
          UNTIL GLItemLedgRelation.NEXT = 0;

        PAGE.RUNMODAL(0,TempValueEntry);
    end;

    procedure ShowDimensions();
    var
        DimMgt : Codeunit DimensionManagement;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2',TABLECAPTION,"Entry No."));
    end;

    procedure UpdateDebitCredit(Correction : Boolean);
    begin
        IF ((Amount > 0) AND (NOT Correction)) OR
           ((Amount < 0) AND Correction)
        THEN BEGIN
          "Debit Amount" := Amount;
          "Credit Amount" := 0
        END ELSE BEGIN
          "Debit Amount" := 0;
          "Credit Amount" := -Amount;
        END;

        IF (("Additional-Currency Amount" > 0) AND (NOT Correction)) OR
           (("Additional-Currency Amount" < 0) AND Correction)
        THEN BEGIN
          "Add.-Currency Debit Amount" := "Additional-Currency Amount";
          "Add.-Currency Credit Amount" := 0
        END ELSE BEGIN
          "Add.-Currency Debit Amount" := 0;
          "Add.-Currency Credit Amount" := -"Additional-Currency Amount";
        END;
    end;

    procedure CopyFromGenJnlLine(GenJnlLine : Record "Gen. Journal Line");
    begin
        "Posting Date" := GenJnlLine."Posting Date";
        "Document Date" := GenJnlLine."Document Date";
        "Document Type" := GenJnlLine."Document Type";
        "Document No." := GenJnlLine."Document No.";
        "External Document No." := GenJnlLine."External Document No.";
        Description := GenJnlLine.Description;
        //ASHNEIL CHANDRA  21072017
        Narration := GenJnlLine.Narration;
        //ASHNEIL CHANDRA  21072017
        "Business Unit Code" := GenJnlLine."Business Unit Code";
        "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
        "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
        "Dimension Set ID" := GenJnlLine."Dimension Set ID";
        "Source Code" := GenJnlLine."Source Code";
        IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
          "Source Type" := GenJnlLine."Source Type";
          "Source No." := GenJnlLine."Source No.";
        END ELSE BEGIN
          "Source Type" := GenJnlLine."Account Type";
          "Source No." := GenJnlLine."Account No.";
        END;
        IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") OR
           (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
        THEN
          "Source Type" := "Source Type"::" ";
        "Job No." := GenJnlLine."Job No.";
        Quantity := GenJnlLine.Quantity;
        "Journal Batch Name" := GenJnlLine."Journal Batch Name";
        "Reason Code" := GenJnlLine."Reason Code";
        "User ID" := USERID;
        "No. Series" := GenJnlLine."Posting No. Series";
        "IC Partner Code" := GenJnlLine."IC Partner Code";
        "BAS Adjustment" := GenJnlLine."BAS Adjustment";
        "BAS Doc. No." := GenJnlLine."BAS Doc. No.";
        "BAS Version" := GenJnlLine."BAS Version";

        OnAfterCopyGLEntryFromGenJnlLine(Rec,GenJnlLine);
    end;

    procedure CopyPostingGroupsFromGLEntry(GLEntry : Record "G/L Entry");
    begin
        "Gen. Posting Type" := GLEntry."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
        "Tax Area Code" := GLEntry."Tax Area Code";
        "Tax Liable" := GLEntry."Tax Liable";
        "Tax Group Code" := GLEntry."Tax Group Code";
        "Use Tax" := GLEntry."Use Tax";
    end;

    procedure CopyPostingGroupsFromVATEntry(VATEntry : Record "VAT Entry");
    begin
        "Gen. Posting Type" := VATEntry.Type;
        "Gen. Bus. Posting Group" := VATEntry."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := VATEntry."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := VATEntry."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := VATEntry."VAT Prod. Posting Group";
        "Tax Area Code" := VATEntry."Tax Area Code";
        "Tax Liable" := VATEntry."Tax Liable";
        "Tax Group Code" := VATEntry."Tax Group Code";
        "Use Tax" := VATEntry."Use Tax";
    end;

    procedure CopyPostingGroupsFromGenJnlLine(GenJnlLine : Record "Gen. Journal Line");
    begin
        "Gen. Posting Type" := GenJnlLine."Gen. Posting Type";
        "Gen. Bus. Posting Group" := GenJnlLine."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := GenJnlLine."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := GenJnlLine."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := GenJnlLine."VAT Prod. Posting Group";
        "Tax Area Code" := GenJnlLine."Tax Area Code";
        "Tax Liable" := GenJnlLine."Tax Liable";
        "Tax Group Code" := GenJnlLine."Tax Group Code";
        "Use Tax" := GenJnlLine."Use Tax";
    end;

    procedure CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf : Record "Detailed CV Ledg. Entry Buffer";GenPostingType : Option " ",Purchase,Sale,Settlement);
    begin
        "Gen. Posting Type" := GenPostingType;
        "Gen. Bus. Posting Group" := DtldCVLedgEntryBuf."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := DtldCVLedgEntryBuf."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := DtldCVLedgEntryBuf."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := DtldCVLedgEntryBuf."VAT Prod. Posting Group";
        "Tax Area Code" := DtldCVLedgEntryBuf."Tax Area Code";
        "Tax Liable" := DtldCVLedgEntryBuf."Tax Liable";
        "Tax Group Code" := DtldCVLedgEntryBuf."Tax Group Code";
        "Use Tax" := DtldCVLedgEntryBuf."Use Tax";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry : Record "G/L Entry";var GenJournalLine : Record "Gen. Journal Line");
    begin
    end;

    procedure CopyFromDeferralPostBuffer(DeferralPostBuffer : Record "Deferral Post. Buffer");
    begin
        "System-Created Entry" := DeferralPostBuffer."System-Created Entry";
        "Gen. Posting Type" := DeferralPostBuffer."Gen. Posting Type";
        "Gen. Bus. Posting Group" := DeferralPostBuffer."Gen. Bus. Posting Group";
        "Gen. Prod. Posting Group" := DeferralPostBuffer."Gen. Prod. Posting Group";
        "VAT Bus. Posting Group" := DeferralPostBuffer."VAT Bus. Posting Group";
        "VAT Prod. Posting Group" := DeferralPostBuffer."VAT Prod. Posting Group";
        "Tax Area Code" := DeferralPostBuffer."Tax Area Code";
        "Tax Liable" := DeferralPostBuffer."Tax Liable";
        "Tax Group Code" := DeferralPostBuffer."Tax Group Code";
        "Use Tax" := DeferralPostBuffer."Use Tax";
    end;
}

