table 50233 "Price Value Line"
{
    Caption = 'Price Value Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Price Value No."; Code[20])
        {
            Caption = 'Tariff Price Value No.';
            TableRelation = "Price Value Header"."No.";
        }
        field(5; "Price Value Line No."; Integer)
        {
            Caption = 'Tariff Price Line No.';
        }
        field(10; Usage;Enum Usage)
        {
            Caption = 'Usage';

            //KB01022024 - Billing Process Accisso Price calculation +++
            trigger OnValidate()
            begin
                if Usage <> Usage::Domestic then begin
                    Rec."Contract Type":="Contract Type"::" ";
                    Rec."Monthly Consumption Range":="Monthly Consumption Range"::"0 KWH - 200.000 KWH";
                    Rec."Domestic Monthly Consum. Range":="Domestic Monthly Consum. Range"::" ";
                end;
            end;
        //KB01022024 - Billing Process Accisso Price calculation ---    
        }
        field(15; "Voltage Type";Enum "Voltage Type")
        {
            Caption = 'Voltage Type';
        }
        field(20; Resident; Boolean)
        {
            Caption = 'Resident';
        }
        field(30; "Contract Power";Enum "Tariff Price Value Contr Power")
        {
            Caption = 'Contract Power';
        }
        field(31; "Contract Power From"; Decimal)
        {
            Caption = 'Contract Power From';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Real Power From cannot be more than Real Power To';
            begin
                if("Contract Power From" > "Contract Power To") and ("Contract Power To" <> 0)then Error(ErrorMsg);
            end;
        }
        field(32; "Contract Power To"; Decimal)
        {
            Caption = 'Contract Power To';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Contract Power To cannot be less than Contract Power From';
            begin
                if("Contract Power To" < "Contract Power From") and ("Contract Power To" <> 0)then Error(ErrorMsg);
            end;
        }
        field(35; "Real Power";Enum "Tariff Price Real Power")
        {
            Caption = 'Real Power ';
        }
        field(36; "Real Power From"; Decimal)
        {
            Caption = 'Real Power From';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Real Power From cannot be more than Real Power To';
            begin
                if("Real Power From" > "Real Power To") and ("Real Power To" <> 0)then Error(ErrorMsg);
            end;
        }
        field(37; "Real Power To"; Decimal)
        {
            Caption = 'Real Power To';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Real Power To cannot be less than Real Power From';
            begin
                if("Real Power To" < "Real Power From") and ("Real Power To" <> 0)then Error(ErrorMsg);
            end;
        }
        field(40; "Single Step Type"; Code[20])
        {
            Caption = 'Single Step Type';
        }
        field(41; "Single Step From"; Decimal)
        {
            Caption = 'Single Step From';
        }
        field(42; "Single Step To"; Decimal)
        {
            Caption = 'Single Step To';
        }
        field(50; "Fixed Price Unit of Measure"; Code[10])
        {
            Caption = 'Fixed Price Unit of Measure';
            TableRelation = "Unit of Measure".Code;
        }
        field(51; "Fixed Price"; Decimal)
        {
            Caption = 'Fixed Price';
            DecimalPlaces = 0: 6;
        }
        field(55; "Power Price Unit of Measure"; Code[10])
        {
            Caption = 'Power Price Unit of Measure';
            TableRelation = "Unit of Measure".Code;
        }
        field(56; "Power Price"; Decimal)
        {
            Caption = 'Power Price';
            DecimalPlaces = 0: 6;
        }
        field(60; "Energy Price Unit of Measure"; Code[10])
        {
            Caption = 'Energy Price Unit of Measure';
            TableRelation = "Unit of Measure".Code;
        }
        field(61; "Energy Price"; Decimal)
        {
            Caption = 'Energy Price';
            DecimalPlaces = 0: 6;
        }
        field(71; "Month of the Price"; Integer)
        {
            Caption = 'Month of the Price';
        }
        field(75; "Effective Start Date"; Date)
        {
            Caption = 'Effective Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective Start date cannot be before Effective end date.';
                ErrorMsg2Lbl: Label 'Tariff Line is already define for Effective Start Date and Effective End Date Range.';
            begin
                if("Effective Start Date" > "Effective End Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
                if not VerifyDateNotRepeat(false)then Error(ErrorMsg2Lbl);
            end;
        }
        field(76; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective end date cannot be before Effective Start date.';
                ErrorMsg2Lbl: Label 'Tariff Line is already define for Effective Start Date and Effective End Date Range.';
            begin
                if("Effective End Date" < "Effective Start Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
                if not VerifyDateNotRepeat(true)then Error(ErrorMsg2Lbl);
            end;
        }
        //KB25012024 - Billing Process Energy Price Calculation Development +++
        field(77; "Active/Reactive Type";Enum "Active/Reactive Type")
        {
            Caption = 'Active/Reactive Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Active/Reactive Type" in["Active/Reactive Type"::" ", "Active/Reactive Type"::"Active F0", "Active/Reactive Type"::"Active F1", "Active/Reactive Type"::"Active F2", "Active/Reactive Type"::"Active F3", "Active/Reactive Type"::"Active F23"]then "Reactive Price Range Type":="Reactive Price Range Type"::" "
                else
                    "Reactive Price Range Type":="Reactive Price Range Type"::"> 33%";
                if "Active/Reactive Type" <> "Active/Reactive Type"::" " then begin
                    "Power Price":=0;
                    "Fixed Price":=0;
                    "Accisso Price":=0; //KB01022024 - Billing Process Accisso Price calculation
                end;
            end;
        }
        field(78; "Reactive Price Range Type";Enum "Reactive Price Range Type")
        {
            Caption = 'Reactive Price Range Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error1Lbl: Label 'You can not select Price Range for Active Type.';
                Error2Lbl: Label 'Price Range must not be Blank for Reactive Type.';
            begin
                if "Reactive Price Range Type" <> "Reactive Price Range Type"::" " then begin
                    if Rec."Active/Reactive Type" in["Active/Reactive Type"::"Active F0", "Active/Reactive Type"::"Active F1", "Active/Reactive Type"::"Active F2", "Active/Reactive Type"::"Active F3", "Active/Reactive Type"::"Active F23"]then Error(Error1Lbl);
                end
                else if Rec."Active/Reactive Type" in["Active/Reactive Type"::"Reactive F0", "Active/Reactive Type"::"Reactive F1", "Active/Reactive Type"::"Reactive F2", "Active/Reactive Type"::"Reactive F3", "Active/Reactive Type"::"Reactive F23"]then Error(Error2Lbl);
            end;
        }
        //KB25012024 - Billing Process Energy Price Calculation Development ---
        //KB01022024 - Billing Process Accisso Price calculation +++
        field(79; "Contract Type";Enum "Price Contract Type")
        {
            Caption = 'Contract Type';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Contract Type" <> "Contract Type"::" " then Rec.TestField(Usage, Usage::Domestic);
                case "Contract Type" of "Contract Type"::" ": begin
                    Rec."Monthly Consumption Range":=Rec."Monthly Consumption Range"::"0 KWH - 200.000 KWH";
                    Rec."Domestic Monthly Consum. Range":=Rec."Domestic Monthly Consum. Range"::" ";
                end;
                "Contract Type"::"Domestic with Main Residence": begin
                    Rec."Monthly Consumption Range":=Rec."Monthly Consumption Range"::" ";
                    Rec."Domestic Monthly Consum. Range":=Rec."Domestic Monthly Consum. Range"::"0 - 150 kWh";
                end;
                "Contract Type"::"Domestic without Main Residence": begin
                    Rec."Monthly Consumption Range":=Rec."Monthly Consumption Range"::" ";
                    Rec."Domestic Monthly Consum. Range":=Rec."Domestic Monthly Consum. Range"::" ";
                end;
                end;
            end;
        }
        field(80; "Accisso Price"; Decimal)
        {
            Caption = 'Accise Price';
            DecimalPlaces = 0: 6;
            DataClassification = ToBeClassified;
        }
        field(81; "Monthly Consumption Range";Enum "Monthly Consumption Range")
        {
            Caption = 'Monthly Consumption Range';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error1Lbl: Label 'You can not select Monthly Consumption Range when Contract Type is not blank and Usage is Domestic.';
            begin
                if Rec."Monthly Consumption Range" <> Rec."Monthly Consumption Range"::" " then if("Contract Type" <> "Contract Type"::" ") and (Usage = Usage::Domestic)then Error(Error1Lbl);
            end;
        }
        //KB01022024 - Billing Process Accisso Price calculation ---
        //KB03042024 - Net Loss Update in Billing +++
        field(82; "Net Loss %"; Decimal)
        {
            Caption = 'Net Loss %';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                PriceValueHeader: Record "Price Value Header";
            begin
                if PriceValueHeader.Get(Rec."Price Value No.")then PriceValueHeader.TestField("Net Loss Type", PriceValueHeader."Net Loss Type"::Excluding);
            end;
        }
        //KB03042024 - Net Loss Update in Billing ---
        //KB03062024 - Acciso Price calculation update +++
        field(83; "Domestic Monthly Consum. Range";Enum "Domestic Monthly Consum. Range")
        {
            Caption = 'Domestic Monthly Consumption Range';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Error1Lbl: Label 'You can not select Domestic Monthly Consumption Range when Usage is Domestic and Contract Type is not Domestic with main Residence.';
            begin
                if Rec."Monthly Consumption Range" <> Rec."Monthly Consumption Range"::" " then if("Contract Type" <> "Contract Type"::"Domestic with Main Residence") and (Usage <> Usage::Domestic)then Error(Error1Lbl);
            end;
        }
    }
    keys
    {
        //KB21022024 - Primary Key Remove Start Date End Date +++
        key(PK; "Price Value No.", "Price Value Line No.")
        {
            Clustered = true;
        }
    //KB21022024 - Primary Key Remove Start Date End Date ---
    }
    local procedure VerifyDateNotRepeat(IsEndDate: Boolean): Boolean var
        PriceValueLine: Record "Price Value Line";
    begin
        PriceValueLine.Reset();
        PriceValueLine.SetRange("Price Value No.", Rec."Price Value No.");
        PriceValueLine.SetFilter("Price Value Line No.", '<>%1', Rec."Price Value Line No.");
        PriceValueLine.SetRange(Usage, Rec.Usage);
        PriceValueLine.SetRange(Resident, Rec.Resident);
        PriceValueLine.SetRange("Voltage Type", Rec."Voltage Type");
        PriceValueLine.SetRange("Active/Reactive Type", Rec."Active/Reactive Type");
        PriceValueLine.SetRange("Reactive Price Range Type", Rec."Reactive Price Range Type");
        PriceValueLine.SetRange("Contract Type", Rec."Contract Type");
        PriceValueLine.SetRange("Monthly Consumption Range", Rec."Monthly Consumption Range");
        PriceValueLine.SetRange("Domestic Monthly Consum. Range", Rec."Domestic Monthly Consum. Range");
        PriceValueLine.SetRange("Contract Power", Rec."Contract Power");
        PriceValueLine.SetRange("Contract Power From", Rec."Contract Power From");
        PriceValueLine.SetRange("Contract Power To", Rec."Contract Power To");
        if IsEndDate then PriceValueLine.SetFilter("Effective Start Date", '<=%1', Rec."Effective End Date")
        else
            PriceValueLine.SetFilter("Effective Start Date", '<=%1', Rec."Effective Start Date");
        if IsEndDate then PriceValueLine.SetFilter("Effective End Date", '>=%1', Rec."Effective End Date")
        else
            PriceValueLine.SetFilter("Effective End Date", '>=%1', Rec."Effective Start Date");
        exit(PriceValueLine.IsEmpty());
    end;
}
