table 50219 "Currency Exchange Rate Payroll"
{
    // version ASHNEILCHANDRA_PAYROLL2017

    CaptionML = ENU='Currency Exchange Rate',
                ENA='Currency Exchange Rate Payroll';
    DataCaptionFields = "Currency Code";
    DrillDownPageID = 50219;
    LookupPageID = 50219;

    fields
    {
        field(1;"Currency Code";Code[10])
        {
            CaptionML = ENU='Currency Code',
                        ENA='Currency Code';
            Editable = false;
            NotBlank = true;
            TableRelation = Currency;
        }
        field(2;"Starting Date";Date)
        {
            CaptionML = ENU='Starting Date',
                        ENA='Starting Date';
            NotBlank = true;
        }
        field(3;"Exchange Rate Amount";Decimal)
        {
            CaptionML = ENU='Exchange Rate Amount',
                        ENA='Exchange Rate Amount';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
        field(4;"Adjustment Exch. Rate Amount";Decimal)
        {
            CaptionML = ENU='Adjustment Exch. Rate Amount',
                        ENA='Adjustment Exch. Rate Amount';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
        field(5;"Relational Currency Code";Code[10])
        {
            CaptionML = ENU='Relational Currency Code',
                        ENA='Relational Currency Code';
            TableRelation = Currency;
        }
        field(6;"Relational Exch. Rate Amount";Decimal)
        {
            CaptionML = ENU='Relational Exch. Rate Amount',
                        ENA='Relational Exch. Rate Amount';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
        field(7;"Fix Exchange Rate Amount";Option)
        {
            CaptionML = ENU='Fix Exchange Rate Amount',
                        ENA='Fix Exchange Rate Amount';
            OptionCaptionML = ENU='Currency,Relational Currency,Both',
                              ENA='Currency,Relational Currency,Both';
            OptionMembers = Currency,"Relational Currency",Both;
        }
        field(8;"Relational Adjmt Exch Rate Amt";Decimal)
        {
            CaptionML = ENU='Relational Adjmt Exch Rate Amt',
                        ENA='Relational Adjmt Exch Rate Amt';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
        field(28041;"Relational Sett. Rate Amount";Decimal)
        {
            CaptionML = ENU='Relational Sett. Rate Amount',
                        ENA='Relational Sett. Rate Amount';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
        field(28140;"Settlement Rate Amount";Decimal)
        {
            CaptionML = ENU='Settlement Rate Amount',
                        ENA='Settlement Rate Amount';
            DecimalPlaces = 1:6;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1;"Currency Code","Starting Date","Exchange Rate Amount")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000 : TextConst ENU='The currency code in the %1 field and the %2 field cannot be the same.',ENA='The currency code in the %1 field and the %2 field cannot be the same.';
        CurrencyExchRate2 : array [2] of Record "Currency Exchange Rate";
        CurrencyExchRate3 : array [3] of Record "Currency Exchange Rate";
        ExchangeRateAmtFCY : Decimal;
        RelExchangeRateAmtFCY : Decimal;
        RelExchangeRateAmt : Decimal;
        ExchangeRateAmt : Decimal;
        RelCurrencyCode : Code[10];
        FixExchangeRateAmt : Option;
        CurrencyFactor : Decimal;
        UseAdjmtAmounts : Boolean;
        CurrencyCode2 : array [2] of Code[10];
        Date2 : array [2] of Date;

    procedure ExchangeAmtLCYToFCY(Date : Date;CurrencyCode : Code[10];Amount : Decimal;Factor : Decimal) : Decimal;
    begin
    end;

    procedure ExchangeAmtFCYToLCY(Date : Date;CurrencyCode : Code[10];Amount : Decimal;Factor : Decimal) : Decimal;
    begin
    end;

    procedure ExchangeRate(Date : Date;CurrencyCode : Code[10]) : Decimal;
    begin
    end;

    procedure ExchangeAmtLCYToFCYOnlyFactor(Amount : Decimal;Factor : Decimal) : Decimal;
    begin
    end;

    procedure ExchangeAmtFCYToLCYAdjmt(Date : Date;CurrencyCode : Code[10];Amount : Decimal;Factor : Decimal) : Decimal;
    begin
    end;

    procedure ExchangeRateAdjmt(Date : Date;CurrencyCode : Code[10]) : Decimal;
    begin
    end;

    procedure FindCurrency(Date : Date;CurrencyCode : Code[10];CacheNo : Integer);
    begin
    end;

    procedure ExchangeAmtFCYToFCY(Date : Date;FromCurrencyCode : Code[10];ToCurrencyCode : Code[10];Amount : Decimal) : Decimal;
    begin
    end;

    procedure FindCurrency2(Date : Date;CurrencyCode : Code[10];Number : Integer);
    begin
    end;

    procedure ApplnExchangeAmtFCYToFCY(Date : Date;FromCurrencyCode : Code[10];ToCurrencyCode : Code[10];Amount : Decimal;var ExchRateFound : Boolean) : Decimal;
    begin
    end;

    local procedure FindApplnCurrency(Date : Date;CurrencyCode : Code[10];Number : Integer) : Boolean;
    begin
    end;

    procedure GetCurrentCurrencyFactor(CurrencyCode : Code[10]) : Decimal;
    begin
    end;

    procedure SetCurrentCurrencyFactor(CurrencyCode : Code[10];CurrencyFactor : Decimal);
    var
        RateForTodayExists : Boolean;
    begin
    end;

    procedure ExchangeRateFactorFRS21(Date : Date;CurrencyCode : Code[10];VendorExchRate : Decimal) : Decimal;
    begin
    end;

    procedure ExchangeRateFRS21(Date : Date;CurrencyCodeFCY : Code[10];CurrencyCode : Code[10];VendorExchRate : Decimal) : Decimal;
    begin
    end;
}

