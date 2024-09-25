table 50204 "Economic Condition"
{
    Caption = 'Economic Condition';

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'No.';
        }
        field(2; "Contract No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Contract."No.";
            Caption = 'Contract No.';
        }
        field(3; "POD No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(5; "Invoice Layout";ENUM "Invoice Layout")
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Layout';
        }
        field(8; "Seller Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Seller Name';
        }
        field(10; "Contractual Power"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Contractual Power';
        }
        field(13; Typology;ENUM "Typology Option")
        {
            DataClassification = CustomerContent;
            Caption = 'Typology';
        }
        field(15; "Available Power"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Available Power';
        }
        field(20; "Billing Interval";ENUM "Billing Interval")
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Interval';
        }
        field(25; "Voltage Type";Enum "Voltage Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Voltage Type';
        }
        field(30; Voltage; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Voltage';
        }
        field(35; "System Type";Enum "System Type")
        {
            DataClassification = CustomerContent;
            Caption = 'System Type';
        }
        field(40; "Reduced VAT";Enum "Reduced VAT")
        {
            DataClassification = CustomerContent;
            Caption = 'Reduced VAT';
        }
        field(45; "Tariff Option No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Tariff Header"."No.";
            Caption = 'Tariff Option No.';
        }
        field(50; "Tariff Option Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Tariff Option Name';
        }
        field(55; "Annual Consumption"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Annual Consumption';
        }
        field(60; "AUC Exempt"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'AUC Exempt';
        }
        field(65; "Excise Duties not Due"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Excise Duties not Due';
        }
        field(70; "Limiter Present"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Limiter Present';
        }
        field(75; Resident; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Resident';

            trigger OnValidate()
            begin
                if Rec.Resident then Rec.Farmer:=false;
            end;
        }
        field(77; "Farmer"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Farmer';

            trigger OnValidate()
            begin
                if Rec.Farmer then Rec.Resident:=false;
            end;
        }
        field(80; "Security Deposit"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Security Deposit';
        }
        field(85; "Security Deposit Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Security Deposit Amount';
        }
        field(90; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';

            trigger OnValidate()
            var
                Contract_LRec: Record Contract;
                ErrorMsg: Label 'Start date cannot be after end date.';
                ErrorLbl: Label 'Start Date should be after 2 day''s of Contract Start Date.';
            begin
                if(Rec."Start Date" > Rec."End Date") and (Rec."End Date" <> 0D)then Error(ErrorMsg);
                // AN 27112023 TASK002168 Economic Start date should be after 2 days of Contract Start Date. ++
                if Contract_LRec.get(rec."Contract No.")then if rec."Start Date" < CalcDate('<2D>', Contract_LRec."Contract Start Date")then Error(ErrorLbl);
                // AN 27112023 TASK002168 Economic Start date should be after 2 days of Contract Start Date. --
                PopulateEcoConPeriod();
            end;
        }
        field(95; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'End date cannot be before start date.';
            begin
                if(Rec."End Date" < Rec."Start Date") and (Rec."End Date" <> 0D)then Error(ErrorMsg);
                PopulateEcoConPeriod();
            end;
        }
        field(100; Period; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(120; "Con. kW"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Con. kW';
        }
        field(121; "Dis. kW"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Dis. kW';
        }
        field(122; "Ten. V"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Ten. V';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    procedure PopulateEcoConPeriod()
    var
        PeriodLbl: Label '%1..%2', Comment = '%1 = start date, %2 = End date';
    begin
        Rec.Period:=StrSubstNo(PeriodLbl, Format(Rec."Start Date"), Format(Rec."End Date"));
        if not Rec.Modify(true)then Rec.Insert(true);
    end;
    procedure ValidateEconomicCondition()
    var
        StartDateErr: Label 'Economic Conditions:\\Economic start date cannot be empty';
        ContrPowerErr: Label 'Economic Conditions:\\Contractual power cannot be 0';
        AvailPowerErr: Label 'Economic Conditions:\\Available power cannot be 0';
        VoltageTypeErr: Label 'Economic Conditions:\\Voltage Type not set';
        TariffOptionErr: Label 'Economic Conditions:\\Tariff Option not selected';
        ResFarmConditionErr: Label 'Economic Conditions:\\Select either Resident or Farmer.';
    begin
        if Rec."Start Date" = 0D then Error(StartDateErr);
        if Rec."Contractual Power" = 0 then Error(ContrPowerErr);
        if Rec."Available Power" = 0 then Error(AvailPowerErr);
        if "Voltage Type" = "Voltage Type"::" " then Error(VoltageTypeErr);
        if Rec."Tariff Option No." = '' then Error(TariffOptionErr);
        if Rec.Resident and Rec.Farmer then Error(ResFarmConditionErr);
    end;
}
