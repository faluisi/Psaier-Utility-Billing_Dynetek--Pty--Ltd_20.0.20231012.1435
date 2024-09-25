codeunit 50211 "Tariff Price Value Management"
{
    /// <summary>
    /// PriceValue.
    /// </summary>
    /// <param name="PriceValueLine">VAR Record "Tariff Price Value Line".</param>
    /// <param name="Contract">Record Contract.</param>
    /// <param name="PriceValueNo">Code[20].</param>
    procedure GetPriceValue(Contract: Record Contract; FormulaLine: Record "Formula Line"; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer): Decimal begin
        exit(GetPrice(Contract, FormulaLine, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo));
    end;
    local procedure GetPrice(Contract: Record Contract; FormulaLine: Record "Formula Line"; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer): Decimal var
        PriceValueHeader: Record "Price Value Header";
        ErrorInfo: ErrorInfo;
    begin
        ErrorInfo.Collectible:=true;
        PriceValueHeader.Reset();
        PriceValueHeader.SetRange("No.", FormulaLine."Price Value No.");
        if not PriceValueHeader.FindSet()then begin
            ErrorInfo.Message:=StrSubstNo(MissingPriceValueHeaderErr, PriceValueHeader.GetFilters());
            Error(ErrorInfo);
        end;
        exit(GetPriceValueLineForContractualPower(Contract, FormulaLine."Price Type", PriceValueHeader, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo)); //KB30012024 - Billing Process Energy Price Calculation Development StartOfMonthDate Parameter added
    end;
    local procedure GetPriceValueLineForContractualPower(Contract: Record Contract; PriceType: Enum "Price Value Price Type"; PriceValueHeader: Record "Price Value Header"; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; DocumetLineNo: Integer): Decimal //KB30012024 - Billing Process Energy Price Calculation Development StartOfMonthDate Parameter added 
 var
        PriceValueLine: Record "Price Value Line";
        PriceValueLines: Record "Price Value Line";
        DiscountPriceHeader: Record "Discount Price Header";
        DiscountPriceLine: Record "Discount Price Line";
        DetailePriceCalcEntry: Record "Detailed Price Calc. Entry";
        DiscountSelection: Record "Discount Selection";
        LastEntryNo: Integer;
        MissingPriceValueLinesErr: Label 'No price value lines were found with the following filters:\{%1}', Comment = '%1 = Price Value Lines filters.';
        ListOfLineNo: List of[Integer];
        ListOfLineNo2: List of[Integer];
        LineNo: Integer;
        LineNo2: Integer;
        PriceAmount: Decimal;
        ErrorInformation: ErrorInfo;
    begin
        PriceAmount:=0;
        if not NetLoss or (NetLoss and (PriceValueHeader."Net Loss Type" = PriceValueHeader."Net Loss Type"::Excluding))then begin
            ErrorInformation.Collectible:=true;
            PriceValueLines.SetRange("Price Value No.", PriceValueHeader."No.");
            PriceValueLines.SetRange(Usage, Contract.Usage);
            PriceValueLine.SetRange(Resident, Contract.Resident);
            PriceValueLines.SetRange("Voltage Type", Contract."Voltage Type");
            PriceValueLines.SetFilter("Effective Start Date", '<=%1', StartOfMonthDate);
            PriceValueLines.SetFilter("Effective End Date", '>=%1&>=%2', StartOfMonthDate, EndDate);
            SetFilterForPriceValueLineActive(PriceValueLines, ActiveType);
            SetFilterForPriceValueLineReactive(PriceValueLines, ReactiveType);
            if(PriceType = PriceType::"Energy Price") and (ActiveType = ActiveType::" ") and (ReactiveType = ReactiveType::" ")then PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::" ");
            if PriceType = PriceType::"Accisso Price" then begin
                SetFilterAcciso(Contract, PriceValueLines);
                if Contract.Usage <> Contract.Usage::Domestic then begin
                    case MonthlyConsumptionRange of MonthlyConsumptionRange::" ": PriceValueLine.SetRange("Monthly Consumption Range", PriceValueLine."Monthly Consumption Range"::" ");
                    MonthlyConsumptionRange::"0 KWH - 200.000 KWH": PriceValueLine.SetRange("Monthly Consumption Range", PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH");
                    MonthlyConsumptionRange::"200.001 - 1.200.000 kWh": PriceValueLine.SetRange("Monthly Consumption Range", PriceValueLine."Monthly Consumption Range"::"200.001 - 1.200.000 kWh");
                    MonthlyConsumptionRange::"> 1.200.001 KWH": PriceValueLine.SetRange("Monthly Consumption Range", PriceValueLine."Monthly Consumption Range"::"> 1.200.001 KWH");
                    end;
                end
                else
                begin
                    case DomesticMonthlyConsumptionRange of DomesticMonthlyConsumptionRange::" ": PriceValueLine.SetRange("Domestic Monthly Consum. Range", PriceValueLine."Domestic Monthly Consum. Range"::" ");
                    DomesticMonthlyConsumptionRange::"0 - 150 kWh": PriceValueLine.SetRange("Domestic Monthly Consum. Range", PriceValueLine."Domestic Monthly Consum. Range"::"0 - 150 kWh");
                    DomesticMonthlyConsumptionRange::"151 - 220 kWh": PriceValueLine.SetRange("Domestic Monthly Consum. Range", PriceValueLine."Domestic Monthly Consum. Range"::"151 - 220 kWh");
                    DomesticMonthlyConsumptionRange::"221 - 370 kWh": PriceValueLine.SetRange("Domestic Monthly Consum. Range", PriceValueLine."Domestic Monthly Consum. Range"::"221 - 370 kWh");
                    DomesticMonthlyConsumptionRange::"371 - Unlimited kWh": PriceValueLine.SetRange("Domestic Monthly Consum. Range", PriceValueLine."Domestic Monthly Consum. Range"::"371 - Unlimited kWh");
                    end;
                end;
            end;
            if PriceValueLines.FindSet()then repeat ListOfLineNo.Add(PriceValueLines."Price Value Line No.");
                until PriceValueLines.Next() = 0
            else
            begin
                ErrorInformation.Message:=StrSubstNo(MissingPriceValueLinesErr, PriceValueLines.GetFilters());
                Error(ErrorInformation);
            end;
            foreach LineNo in ListOfLineNo do begin
                PriceValueLine.SetRange("Price Value No.", PriceValueHeader."No.");
                PriceValueLine.SetRange("Price Value Line No.", LineNo);
                if PriceValueLine.FindFirst()then if PriceValueLine."Contract Power" = Enum::"Tariff Price Value Contr Power"::Available then begin
                        if PriceValueLine."Contract Power To" = 0 then begin
                            if(Contract."Contractual Power" >= PriceValueLine."Contract Power From")then ListOfLineNo2.Add(LineNo);
                        end
                        else if(Contract."Contractual Power" >= PriceValueLine."Contract Power From") and (Contract."Contractual Power" < PriceValueLine."Contract Power To")then ListOfLineNo2.Add(LineNo);
                    end
                    else
                        ListOfLineNo2.Add(LineNo);
            end;
            ListOfLineNo:=ListOfLineNo2;
            Clear(ListOfLineNo2);
            foreach LineNo in ListOfLineNo do begin
                PriceValueLine.SetRange("Price Value No.", PriceValueHeader."No.");
                PriceValueLine.SetRange("Price Value Line No.", LineNo);
                if PriceValueLine.FindFirst()then if PriceValueLine."Real Power" = Enum::"Tariff Price Real Power"::"Contractual Power" then begin
                        if PriceValueLine."Real Power To" = 0 then begin
                            if(Contract."Contractual Power" >= PriceValueLine."Real Power From")then ListOfLineNo2.Add(LineNo);
                        end
                        else if(Contract."Contractual Power" >= PriceValueLine."Real Power From") and (Contract."Contractual Power" < PriceValueLine."Real Power To")then ListOfLineNo2.Add(LineNo);
                    end
                    else
                        ListOfLineNo2.Add(LineNo);
            end;
            //KB25012024 - Billing Process Energy Price Calculation Development Code Commented ---
            //KB25012024 - Billing Process Energy Price Calculation Development +++
            foreach LineNo2 in ListOfLineNo2 do begin
                PriceValueLine.SetRange("Price Value No.", PriceValueHeader."No.");
                PriceValueLine.SetRange("Price Value Line No.", LineNo2);
                if PriceValueLine.FindFirst()then if IsDiscount then begin
                        DiscountSelection.Reset();
                        DiscountSelection.SetRange("Contract No.", Contract."No.");
                        DiscountSelection.SetFilter("Annual Consumption From", '<=%1', Contract."Annual Consumption");
                        DiscountSelection.SetFilter("Annual Consumption To", '>=%1', Contract."Annual Consumption");
                        if DiscountSelection.FindFirst()then if DiscountPriceHeader.Get(DiscountSelection."Discount ID")then if(DiscountPriceHeader."Annual Consumption From" <= Contract."Annual Consumption") and (DiscountPriceHeader."Annual Consumption To" >= Contract."Annual Consumption")then begin
                                    DiscountPriceLine.Reset();
                                    DiscountPriceLine.SetRange(ID, DiscountPriceHeader.ID);
                                    DiscountPriceLine.SetRange("Price Value No.", PriceValueHeader."No.");
                                    DiscountPriceLine.SetFilter("Start Date", '<=%1', StartOfMonthDate);
                                    DiscountPriceLine.SetFilter("End Date", '>=%1&>=%2', StartOfMonthDate, EndDate);
                                    case PriceType of Enum::"Price Value Price Type"::"Energy Price": DiscountPriceLine.SetRange("Line Cost Type", DiscountPriceLine."Line Cost Type"::Energy);
                                    Enum::"Price Value Price Type"::"Fix Price": DiscountPriceLine.SetRange("Line Cost Type", DiscountPriceLine."Line Cost Type"::Transport);
                                    Enum::"Price Value Price Type"::"Power Price": DiscountPriceLine.SetRange("Line Cost Type", DiscountPriceLine."Line Cost Type"::Peak);
                                    end;
                                    if DiscountPriceLine.FindFirst()then begin
                                        case PriceType of Enum::"Price Value Price Type"::"Energy Price": if IsQuantity then begin
                                                PriceAmount+=GetEnergyPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate, IsSystemTransport) * PriceValueLine."Energy Price";
                                            end
                                            else
                                            begin
                                                if DiscountPriceLine."Discount Type" = DiscountPriceLine."Discount Type"::"Percentage(%)" then PriceAmount+=DiscountPriceLine."Discount %" * PriceValueLine."Energy Price" / 100
                                                else
                                                    PriceAmount+=DiscountPriceLine."Discount %";
                                                Quantity:=GetEnergyPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate, IsSystemTransport);
                                            end;
                                        Enum::"Price Value Price Type"::"Fix Price": if IsQuantity then begin
                                                PriceAmount+=1 * PriceValueLine."Fixed Price"; //KB25012024 - Billing Process Fixed Price Calculation Development
                                            end
                                            else
                                            begin
                                                if DiscountPriceLine."Discount Type" = DiscountPriceLine."Discount Type"::"Percentage(%)" then PriceAmount+=DiscountPriceLine."Discount %" * PriceValueLine."Fixed Price" / 100
                                                else
                                                    PriceAmount+=DiscountPriceLine."Discount %";
                                                Quantity:=1;
                                            end;
                                        Enum::"Price Value Price Type"::"Power Price": if IsQuantity then begin
                                                PriceAmount+=GetPowerPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate) * PriceValueLine."Power Price"; //KB31012024 - Billing Process Power Price Calculation Development
                                            end
                                            else
                                            begin
                                                if DiscountPriceLine."Discount Type" = DiscountPriceLine."Discount Type"::"Percentage(%)" then PriceAmount+=DiscountPriceLine."Discount %" * PriceValueLine."Power Price" / 100
                                                else
                                                    PriceAmount+=PriceValueLine."Power Price";
                                                Quantity:=GetPowerPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate);
                                            end;
                                        end;
                                    end;
                                end end
                    else
                    begin
                        case PriceType of Enum::"Price Value Price Type"::"Energy Price": if IsQuantity then PriceAmount+=GetEnergyPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate, IsSystemTransport) * PriceValueLine."Energy Price"
                            else
                            begin
                                if NetLoss then PriceAmount+=PriceValueLine."Net Loss %" * PriceValueLine."Energy Price" / 100
                                else
                                    PriceAmount+=PriceValueLine."Energy Price";
                                Quantity:=GetEnergyPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate, IsSystemTransport);
                            end;
                        Enum::"Price Value Price Type"::"Fix Price": if IsQuantity then PriceAmount+=1 * PriceValueLine."Fixed Price" //KB25012024 - Billing Process Fixed Price Calculation Development
                            else
                            begin
                                if NetLoss then PriceAmount+=PriceValueLine."Net Loss %" * PriceValueLine."Fixed Price" / 100
                                else
                                    PriceAmount+=PriceValueLine."Fixed Price";
                                Quantity:=1;
                            end;
                        Enum::"Price Value Price Type"::"Power Price": if IsQuantity then PriceAmount+=GetPowerPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate) * PriceValueLine."Power Price" //KB31012024 - Billing Process Power Price Calculation Development
                            else
                            begin
                                if NetLoss then PriceAmount+=PriceValueLine."Net Loss %" * PriceValueLine."Power Price" / 100
                                else
                                    PriceAmount+=PriceValueLine."Power Price";
                                Quantity:=GetPowerPriceAmount(Contract, PriceValueLine, StartOfMonthDate, EndDate);
                            end;
                        //KB01022024 - Billing Process Accisso Price calculation +++
                        Enum::"Price Value Price Type"::"Accisso Price": if IsQuantity then PriceAmount:=GetAccisoPriceNew(Contract, PriceValueLine, StartOfMonthDate, EndDate)
                            else
                            begin
                                PriceAmount:=PriceValueLine."Accisso Price";
                                Quantity:=GetAccisoPriceNew(Contract, PriceValueLine, StartOfMonthDate, EndDate);
                            end;
                        //KB01022024 - Billing Process Accisso Price calculation ---
                        end;
                    end;
            end;
        end;
        if(PriceAmount <> 0) and (DocumentNo <> '')then begin
            DetailePriceCalcEntry.Reset();
            DetailePriceCalcEntry.SetCurrentKey("Entry No.");
            if DetailePriceCalcEntry.FindLast()then LastEntryNo:=DetailePriceCalcEntry."Entry No.";
            DetailePriceCalcEntry.Reset();
            DetailePriceCalcEntry.Init();
            DetailePriceCalcEntry."Entry No.":=LastEntryNo + 1;
            DetailePriceCalcEntry."Document Type":=DetailePriceCalcEntry."Document Type"::Invoice;
            DetailePriceCalcEntry."Invoice No.":=DocumentNo;
            DetailePriceCalcEntry."Line No.":=DocumetLineNo;
            DetailePriceCalcEntry."Price Value No.":=PriceValueHeader."No.";
            DetailePriceCalcEntry."Price Type":=PriceType;
            if IsDiscount then DetailePriceCalcEntry.Price:=-PriceAmount
            else
                DetailePriceCalcEntry.Price:=PriceAmount;
            DetailePriceCalcEntry.Insert();
        end;
        exit(PriceAmount);
    //KB25012024 - Billing Process Energy Price Calculation Development ---
    end;
    //KB15022024 - TASK002433 New Billing Calculation +++
    local procedure SetFilterForPriceValueLineActive(var PriceValueLine: Record "Price Value Line"; ActiveType: Enum "Active Type")
    begin
        case ActiveType of ActiveType::"Active F0": PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Active F0");
        ActiveType::"Active F1": PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Active F1");
        ActiveType::"Active F2": PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Active F2");
        ActiveType::"Active F3": PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Active F3");
        ActiveType::"Active F23": PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Active F23");
        end;
    end;
    local procedure SetFilterForPriceValueLineReactive(var PriceValueLine: Record "Price Value Line"; ReactiveType: Enum "Reactive Type")
    begin
        case ReactiveType of ReactiveType::"Reactive F0 0.33-Other": begin
            PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Reactive F0");
            PriceValueLine.SetRange("Reactive Price Range Type", PriceValueLine."Reactive Price Range Type"::"> 33%");
        end;
        ReactiveType::"Reactive F1 0.33-Other": begin
            PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Reactive F1");
            PriceValueLine.SetRange("Reactive Price Range Type", PriceValueLine."Reactive Price Range Type"::"> 33%");
        end;
        ReactiveType::"Reactive F2 0.33-Other": begin
            PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Reactive F2");
            PriceValueLine.SetRange("Reactive Price Range Type", PriceValueLine."Reactive Price Range Type"::"> 33%");
        end;
        ReactiveType::"Reactive F3 0.33-Other": begin
            PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Reactive F3");
            PriceValueLine.SetRange("Reactive Price Range Type", PriceValueLine."Reactive Price Range Type"::"> 33%");
        end;
        ReactiveType::"Reactive F23 0.33-Other": begin
            PriceValueLine.SetRange("Active/Reactive Type", PriceValueLine."Active/Reactive Type"::"Reactive F23");
            PriceValueLine.SetRange("Reactive Price Range Type", PriceValueLine."Reactive Price Range Type"::"> 33%");
        end;
        end;
    end;
    local procedure SetFilterAcciso(Contract: Record Contract; var PriceValueLine: Record "Price Value Line")
    begin
        if Contract.Usage = Contract.Usage::Domestic then case Contract."Contract Type" of Contract."Contract Type"::"01": PriceValueLine.SetRange("Contract Type", PriceValueLine."Contract Type"::"Domestic with Main Residence");
            Contract."Contract Type"::"02": PriceValueLine.SetRange("Contract Type", PriceValueLine."Contract Type"::"Domestic without Main Residence");
            else
                PriceValueLine.SetRange("Contract Type", PriceValueLine."Contract Type"::" ");
            end;
    end;
    //KB15022024 - TASK002433 New Billing Calculation ---
    //KB25012024 - Billing Process Fixed Price Calculation Development +++
    procedure GetFixedPriceAmount(Contract: Record Contract; PriceValueLine: Record "Price Value Line"; StartOfMonthDate: Date; EndDate: Date): Decimal begin
        case Contract."Billing Interval" of "Billing Interval"::Monthly: exit(1);
        "Billing Interval"::"2 Months": exit(2);
        "Billing Interval"::"3 Months": exit(3);
        "Billing Interval"::"4 Months": exit(4);
        "Billing Interval"::"6 Months": exit(6);
        "Billing Interval"::" Once a Year": exit(12);
        end;
    end;
    //KB25012024 - Billing Process Fixed Price Calculation Development ---
    //KB25012024 - Billing Process Energy Price Calculation Development +++
    procedure GetEnergyPriceAmount(Contract: Record Contract; PriceValueLine: Record "Price Value Line"; StartOfMonthDate: Date; EndDate: Date; IsSystemTransport: Boolean): Decimal var
        Meter: Record Meter;
        ActiveConsumption: Decimal;
        ReactiveConsumption: Decimal;
    begin
        ActiveConsumption:=0;
        ReactiveConsumption:=0;
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then begin
            case Meter."Reading Type" of Meter."Reading Type"::Active, Meter."Reading Type"::"Active - Peak": begin
                GetActiveEnergyConsumption(Contract, Meter, PriceValueLine."Active/Reactive Type", StartOfMonthDate, EndDate, false, ActiveConsumption);
                exit(GetPriceBasedOnConsumption(ActiveConsumption, ReactiveConsumption, PriceValueLine));
            end;
            Meter."Reading Type"::"Active - Reactive", Meter."Reading Type"::"Active - Reactive - Peak": begin
                GetActiveEnergyConsumption(Contract, Meter, PriceValueLine."Active/Reactive Type", StartOfMonthDate, EndDate, false, ActiveConsumption);
                if not IsSystemTransport then GetReactiveEnergyConsumption(Contract, Meter, PriceValueLine."Active/Reactive Type", StartOfMonthDate, EndDate, false, ActiveConsumption, ReactiveConsumption);
                exit(GetPriceBasedOnConsumption(ActiveConsumption, ReactiveConsumption, PriceValueLine));
            end;
            Meter."Reading Type"::Consumption: begin
                GetActiveEnergyConsumption(Contract, Meter, PriceValueLine."Active/Reactive Type", StartOfMonthDate, EndDate, true, ActiveConsumption);
                if not IsSystemTransport then GetReactiveEnergyConsumption(Contract, Meter, PriceValueLine."Active/Reactive Type", StartOfMonthDate, EndDate, true, ActiveConsumption, ReactiveConsumption);
                exit(GetPriceBasedOnConsumption(ActiveConsumption, ReactiveConsumption, PriceValueLine));
            end;
            end;
        end;
    end;
    procedure GetActiveEnergyConsumption(Contract: Record Contract; Meter: Record Meter; ActiveReactiveType: Enum "Active/Reactive Type"; StartOfMonthDate: Date; EndDate: Date; IsConsumption: Boolean; var ActiveConsumption: Decimal)
    var
        Measurement: Record Measurement;
        TotalValueActive: Decimal;
        LastTotalValueActive: Decimal;
    begin
        TotalValueActive:=0;
        LastTotalValueActive:=0;
        case ActiveReactiveType of ActiveReactiveType::"Active F0", ActiveReactiveType::" ": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active Total");
                    TotalValueActive+=Measurement."Active Total";
                end;
            end
            else if Measurement.FindLast()then TotalValueActive+=Measurement."Active Total";
        end;
        ActiveReactiveType::"Active F1": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F1");
                    TotalValueActive+=Measurement."Active F1";
                end;
            end
            else if Measurement.FindLast()then TotalValueActive+=Measurement."Active F1";
        end;
        ActiveReactiveType::"Active F2": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F2");
                    TotalValueActive+=Measurement."Active F2";
                end;
            end
            else if Measurement.FindLast()then TotalValueActive+=Measurement."Active F2";
        end;
        ActiveReactiveType::"Active F3": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F3");
                    TotalValueActive+=Measurement."Active F3";
                end;
            end
            else if Measurement.FindLast()then TotalValueActive+=Measurement."Active F3";
        end;
        ActiveReactiveType::"Active F23": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F2", "Active F3");
                    TotalValueActive+=(Measurement."Active F2" + Measurement."Active F3");
                end;
            end
            else if Measurement.FindLast()then TotalValueActive+=(Measurement."Active F2" + Measurement."Active F3");
        end;
        end;
        if not IsConsumption then begin
            case ActiveReactiveType of ActiveReactiveType::"Active F0", ActiveReactiveType::" ": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
            end;
            ActiveReactiveType::"Active F1": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active F1";
            end;
            ActiveReactiveType::"Active F2": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active F2";
            end;
            ActiveReactiveType::"Active F3": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active F3";
            end;
            ActiveReactiveType::"Active F23": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=(Measurement."Active F2" + Measurement."Active F3");
            end;
            end;
        end;
        if TotalValueActive <> 0 then ActiveConsumption:=TotalValueActive - LastTotalValueActive;
    end;
    procedure GetReactiveEnergyConsumption(Contract: Record Contract; Meter: Record Meter; ActiveReactiveType: Enum "Active/Reactive Type"; StartOfMonthDate: Date; EndDate: Date; IsConsumption: Boolean; var ActiveConsumption: Decimal; var ReactiveConsumption: Decimal): Decimal var
        Measurement: Record Measurement;
        TotalValueActive: Decimal;
        TotalValueReactive: Decimal;
        LastTotalValueActive: Decimal;
        LastTotalValueReactive: Decimal;
        IsUpdate: Boolean;
    begin
        TotalValueActive:=0;
        LastTotalValueActive:=0;
        TotalValueReactive:=0;
        LastTotalValueReactive:=0;
        IsUpdate:=false;
        case ActiveReactiveType of ActiveReactiveType::"Reactive F0", ActiveReactiveType::" ": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active Total", "Reactive Total");
                    TotalValueActive+=Measurement."Active Total";
                    TotalValueReactive+=Measurement."Reactive Total";
                end;
            end
            else if Measurement.FindLast()then begin
                    TotalValueActive+=Measurement."Active Total";
                    TotalValueReactive+=Measurement."Reactive Total";
                end;
            IsUpdate:=true;
        end;
        ActiveReactiveType::"Reactive F1": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F1", "Reactive F1");
                    TotalValueActive+=Measurement."Active F1";
                    TotalValueReactive+=Measurement."Reactive F1";
                end;
            end
            else if Measurement.FindLast()then begin
                    TotalValueActive+=Measurement."Active F1";
                    TotalValueReactive+=Measurement."Reactive F1";
                end;
            IsUpdate:=true;
        end;
        ActiveReactiveType::"Reactive F2": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F2", "Reactive F2");
                    TotalValueActive+=Measurement."Active F2";
                    TotalValueReactive+=Measurement."Reactive F2";
                end;
            end
            else if Measurement.FindLast()then begin
                    TotalValueActive+=Measurement."Active F2";
                    TotalValueReactive+=Measurement."Reactive F2";
                end;
            IsUpdate:=true;
        end;
        ActiveReactiveType::"Reactive F3": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F3", "Reactive F3");
                    TotalValueActive+=Measurement."Active F3";
                    TotalValueReactive+=Measurement."Reactive F3";
                end;
            end
            else if Measurement.FindLast()then begin
                    TotalValueActive+=Measurement."Active F3";
                    TotalValueReactive+=Measurement."Reactive F3";
                end;
            IsUpdate:=true;
        end;
        ActiveReactiveType::"Reactive F23": begin
            Measurement.Reset();
            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
            Measurement.SetRange("POD No.", Meter."POD No.");
            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
            if IsConsumption then begin
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active F2", "Active F3", "Reactive F2", "Reactive F3");
                    TotalValueActive+=(Measurement."Active F2" + Measurement."Active F3");
                    TotalValueReactive+=(Measurement."Reactive F2" + Measurement."Reactive F3");
                end;
            end
            else if Measurement.FindLast()then begin
                    TotalValueActive+=(Measurement."Active F2" + Measurement."Active F3");
                    TotalValueReactive+=(Measurement."Reactive F2" + Measurement."Reactive F3");
                end;
            IsUpdate:=true;
        end;
        end;
        if not IsConsumption then case ActiveReactiveType of ActiveReactiveType::"Reactive F0", ActiveReactiveType::" ": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then begin
                    LastTotalValueActive:=Measurement."Active Total";
                    LastTotalValueReactive:=Measurement."Reactive Total";
                end;
            end;
            ActiveReactiveType::"Reactive F1": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then begin
                    LastTotalValueActive:=Measurement."Active F1";
                    LastTotalValueReactive:=Measurement."Reactive F1";
                end;
            end;
            ActiveReactiveType::"Reactive F2": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then begin
                    LastTotalValueActive:=Measurement."Active F2";
                    LastTotalValueReactive:=Measurement."Reactive F2";
                end;
            end;
            ActiveReactiveType::"Reactive F3": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then begin
                    LastTotalValueActive:=Measurement."Active F3";
                    LastTotalValueReactive:=Measurement."Reactive F3";
                end;
            end;
            ActiveReactiveType::"Reactive F23": begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then begin
                    LastTotalValueActive:=(Measurement."Active F2" + Measurement."Active F3");
                    LastTotalValueReactive:=(Measurement."Reactive F2" + Measurement."Reactive F3");
                end;
            end;
            end;
        if IsUpdate then begin
            if TotalValueActive <> 0 then ActiveConsumption:=TotalValueActive - LastTotalValueActive;
            if TotalValueReactive <> 0 then ReactiveConsumption:=TotalValueReactive - LastTotalValueReactive;
        end;
    end;
    procedure GetPriceBasedOnConsumption(ActiveConsumption: Decimal; ReactiveConsumption: Decimal; PriceValueLine: Record "Price Value Line"): Decimal var
        ReactiveActiveRatio: Decimal;
        FinalValue: Decimal;
    begin
        ReactiveActiveRatio:=0;
        if ReactiveConsumption <> 0 then begin
            FinalValue:=0;
            if ActiveConsumption <> 0 then ReactiveActiveRatio:=ReactiveConsumption / ActiveConsumption
            else
                ReactiveActiveRatio:=ReactiveConsumption;
            if(ReactiveActiveRatio > 0.33) and (PriceValueLine."Reactive Price Range Type" = PriceValueLine."Reactive Price Range Type"::"> 33%")then if ActiveConsumption <> 0 then FinalValue:=(ReactiveActiveRatio - 0.33) * ActiveConsumption
                else
                    FinalValue:=(ReactiveActiveRatio - 0.33);
            exit(FinalValue);
        end
        else
            exit(ActiveConsumption);
    end;
    //KB25012024 - Billing Process Energy Price Calculation Development ---
    //KB31012024 - Billing Process Power Price Calculation Development +++
    procedure GetPowerPriceAmount(Contract: Record Contract; PriceValueLine: Record "Price Value Line"; StartOfMonthDate: Date; EndDate: Date): Decimal var
        Meter: Record Meter;
        Measurement: Record Measurement;
        UtilitySetup: Record "Utility Setup";
        PeakMaxValue: Decimal;
    begin
        UtilitySetup.Get();
        if(Contract."Contractual Power" <= UtilitySetup."Peak Calc Threshold") and (not(Contract."Voltage Type" in[Contract."Voltage Type"::MT, Contract."Voltage Type"::AT]))then exit(Contract."Contractual Power")
        else
        begin
            Meter.Reset();
            Meter.SetRange("POD No.", Contract."POD No.");
            Meter.SetFilter("Reading Type", '%1|%2|%3', Meter."Reading Type"::"Active - Peak", Meter."Reading Type"::"Active - Reactive - Peak", Meter."Reading Type"::Consumption);
            if Meter.FindFirst()then begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                if Measurement.FindSet()then repeat if Measurement."Peak Total" > PeakMaxValue then PeakMaxValue:=Measurement."Peak Total";
                    until Measurement.Next() = 0;
                exit(PeakMaxValue);
            end;
        end;
    end;
    //KB31012024 - Billing Process Power Price Calculation Development ---
    //KB04062024 - Acciso Price calculation update +++
    procedure GetAccisoPriceNew(Contract: Record Contract; PriceValueLine: Record "Price Value Line"; StartOfMonthDate: Date; EndDate: Date): Decimal var
        Measurement: Record Measurement;
        Meter: Record Meter;
        TotalValueActive: Decimal;
        LastTotalValueActive: Decimal;
        MonthlyConsumption: Decimal;
    begin
        TotalValueActive:=0;
        MonthlyConsumption:=0;
        LastTotalValueActive:=0;
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then begin
            if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active Total");
                    MonthlyConsumption:=Measurement."Active Total";
                end;
            end
            else
            begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
            end;
        end;
        if Contract.Usage = Contract.Usage::Domestic then begin
            if(Contract."Contract Type" = Contract."Contract Type"::"01") and (PriceValueLine."Contract Type" = PriceValueLine."Contract Type"::"Domestic with Main Residence")then begin
                if Contract."Contractual Power" <= 3 then begin
                    case MonthlyConsumption of 0 .. 150: exit(MonthlyConsumption);
                    151 .. 220: begin
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"0 - 150 kWh" then exit(150);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"151 - 220 kWh" then exit(MonthlyConsumption - 150);
                    end;
                    221 .. 370: begin
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"0 - 150 kWh" then exit(150);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"151 - 220 kWh" then exit(70);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"221 - 370 kWh" then exit((MonthlyConsumption - 220) * 2);
                    end
                    else
                    begin
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"0 - 150 kWh" then exit(150);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"151 - 220 kWh" then exit(70);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"221 - 370 kWh" then exit(150 * 2);
                        if PriceValueLine."Domestic Monthly Consum. Range" = PriceValueLine."Domestic Monthly Consum. Range"::"371 - Unlimited kWh" then exit(MonthlyConsumption - 370);
                    end;
                    end;
                end
                else
                    exit(MonthlyConsumption);
            end
            else if(Contract."Contract Type" = Contract."Contract Type"::"02") and (PriceValueLine."Contract Type" = PriceValueLine."Contract Type"::"Domestic without Main Residence")then exit(MonthlyConsumption)
                else if(Contract."Contract Type" = Contract."Contract Type"::" ")then case MonthlyConsumption of 0 .. 200000: if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(MonthlyConsumption);
                        200001 .. 1200000: begin
                            if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(200000);
                            if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"200.001 - 1.200.000 kWh" then exit(MonthlyConsumption - 200000);
                        end;
                        else
                        begin
                            if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(200000);
                            if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"> 1.200.001 KWH" then exit(MonthlyConsumption - 200000);
                        end;
                        end;
        end
        else
            case MonthlyConsumption of 0 .. 200000: if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(MonthlyConsumption);
            200001 .. 1200000: begin
                if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(200000);
                if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"200.001 - 1.200.000 kWh" then exit(MonthlyConsumption - 200000);
            end;
            else
            begin
                if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH" then exit(200000);
                if PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"> 1.200.001 KWH" then exit(MonthlyConsumption - 200000);
            end;
            end;
    end;
    //KB04062024 - Acciso Price calculation update --- 
    //KB01022024 - Billing Process Accisso Price calculation +++
    procedure GetAccissoPrice(Contract: Record Contract; PriceValueLine: Record "Price Value Line"; StartOfMonthDate: Date; EndDate: Date): Decimal var
        Measurement: Record Measurement;
        Meter: Record Meter;
        TotalValueActive: Decimal;
        LastTotalValueActive: Decimal;
        MonthlyConsumption: Decimal;
    begin
        TotalValueActive:=0;
        MonthlyConsumption:=0;
        LastTotalValueActive:=0;
        if Contract.Usage = Contract.Usage::Domestic then begin
            if(Contract."Contract Type" = Contract."Contract Type"::"01") and (PriceValueLine."Contract Type" = PriceValueLine."Contract Type"::"Domestic with Main Residence")then begin
                if Contract."Contractual Power" <= 3 then begin
                    Meter.Reset();
                    Meter.SetRange("POD No.", Contract."POD No.");
                    if Meter.FindFirst()then begin
                        if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindSet()then begin
                                Measurement.CalcSums("Active Total");
                                MonthlyConsumption:=Measurement."Active Total";
                            end;
                        end
                        else
                        begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                            if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                            MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
                        end;
                        if Contract."Annual Consumption" > 1800 then if Contract."Annual Consumption" < 2640 then exit((MonthlyConsumption - 150))
                            else
                                exit((MonthlyConsumption - (150 - ((Contract."Annual Consumption" - 2640) / 12))));
                    end;
                end
                else
                begin
                    Meter.Reset();
                    Meter.SetRange("POD No.", Contract."POD No.");
                    if Meter.FindFirst()then begin
                        if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindSet()then begin
                                Measurement.CalcSums("Active Total");
                                MonthlyConsumption:=Measurement."Active Total";
                            end;
                        end
                        else
                        begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                            if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                            MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
                        end;
                        exit(MonthlyConsumption);
                    end;
                end end
            else if(Contract."Contract Type" = Contract."Contract Type"::"02") and (PriceValueLine."Contract Type" = PriceValueLine."Contract Type"::"Domestic without Main Residence")then begin
                    Meter.Reset();
                    Meter.SetRange("POD No.", Contract."POD No.");
                    if Meter.FindFirst()then begin
                        if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindSet()then begin
                                Measurement.CalcSums("Active Total");
                                MonthlyConsumption:=Measurement."Active Total";
                            end;
                        end
                        else
                        begin
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                            if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                            Measurement.Reset();
                            Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                            Measurement.SetRange("POD No.", Meter."POD No.");
                            Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                            Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                            if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                            MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
                        end;
                        exit(MonthlyConsumption);
                    end;
                end
                else if(PriceValueLine."Contract Type" = PriceValueLine."Contract Type"::" ")then begin
                        Meter.Reset();
                        Meter.SetRange("POD No.", Contract."POD No.");
                        if Meter.FindFirst()then begin
                            if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                                Measurement.Reset();
                                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                Measurement.SetRange("POD No.", Meter."POD No.");
                                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                                if Measurement.FindSet()then begin
                                    Measurement.CalcSums("Active Total");
                                    MonthlyConsumption:=Measurement."Active Total";
                                end;
                            end
                            else
                            begin
                                Measurement.Reset();
                                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                Measurement.SetRange("POD No.", Meter."POD No.");
                                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                                if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                                Measurement.Reset();
                                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                Measurement.SetRange("POD No.", Meter."POD No.");
                                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                                MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
                            end;
                            if(MonthlyConsumption < 20000)then begin
                                if(PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH")then exit(MonthlyConsumption)end
                            else if(PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH")then exit(20000)
                                else
                                    exit((MonthlyConsumption - 20000));
                        end;
                    end;
        end
        else
        begin
            Meter.Reset();
            Meter.SetRange("POD No.", Contract."POD No.");
            if Meter.FindFirst()then begin
                if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                    if Measurement.FindSet()then begin
                        Measurement.CalcSums("Active Total");
                        MonthlyConsumption:=Measurement."Active Total";
                    end;
                end
                else
                begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                    if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                    if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                    MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
                end;
                if(MonthlyConsumption < 200000)then begin
                    if(PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH")then exit(MonthlyConsumption)end
                else if(PriceValueLine."Monthly Consumption Range" = PriceValueLine."Monthly Consumption Range"::"0 KWH - 200.000 KWH")then exit(200000)
                    else
                        exit((MonthlyConsumption - 200000));
            end;
        end;
    end;
    //KB01022024 - Billing Process Accisso Price calculation ---
    /// <summary>
    /// Main Function to return kW/H for sales line creation.
    /// </summary>
    /// <param name="Contract">Record Contract.</param>
    /// <param name="StartOfMonthDate">Date.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetQuantity(Contract: Record Contract; StartOfMonthDate: Date): Decimal var
        UtilitySetup: Record "Utility Setup";
        finalKWHAmount: Decimal;
    begin
        finalKWHAmount:=GetMeasurement(Contract, StartOfMonthDate); //KB04122023 - TASK002210 Invoice Billing Process
        if finalKWHAmount = 0 then exit(Contract."Contractual Power");
        UtilitySetup.Get();
        if finalKWHAmount < UtilitySetup."Power Limit" then finalKWHAmount:=Contract."Contractual Power";
        exit(finalKWHAmount)end;
    //KB04122023 - TASK002210 Invoice Billing Process +++
    local procedure GetMeasurement(Contract: Record Contract; StartOfMonthDate: Date): Decimal var
        Measurement: Record Measurement;
        Meter: Record Meter;
        TotalValue: Decimal;
        MeasurementValue: Decimal;
        LastTotalValue: Decimal;
        PeakMaxValue: Decimal;
    begin
        MeasurementValue:=0;
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then begin
            case Meter."Reading Type" of Meter."Reading Type"::Active: begin
                TotalValue:=0;
                LastTotalValue:=0;
                Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                if Measurement.FindSet()then repeat TotalValue+=Measurement."Active Total";
                    until Measurement.Next() = 0;
                Measurement.Reset();
                Measurement.SetCurrentKey(Date);
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total";
                MeasurementValue:=TotalValue - LastTotalValue;
            end;
            Meter."Reading Type"::"Active - Peak": begin
                PeakMaxValue:=0;
                TotalValue:=0;
                LastTotalValue:=0;
                Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                if Measurement.FindSet()then repeat TotalValue+=Measurement."Active Total";
                        if Measurement."Peak Total" > PeakMaxValue then PeakMaxValue:=Measurement."Peak Total";
                    until Measurement.Next() = 0;
                Measurement.Reset();
                Measurement.SetCurrentKey(Date);
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total";
                MeasurementValue:=TotalValue + PeakMaxValue - LastTotalValue;
            end;
            Meter."Reading Type"::"Active - Reactive": begin
                TotalValue:=0;
                LastTotalValue:=0;
                Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                if Measurement.FindSet()then repeat TotalValue+=Measurement."Active Total" + Measurement."Reactive Total";
                    until Measurement.Next() = 0;
                Measurement.Reset();
                Measurement.SetCurrentKey(Date);
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total" + Measurement."Reactive Total";
                MeasurementValue:=TotalValue - LastTotalValue;
            end;
            Meter."Reading Type"::"Active - Reactive - Peak": begin
                PeakMaxValue:=0;
                TotalValue:=0;
                LastTotalValue:=0;
                Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                if Measurement.FindSet()then repeat TotalValue+=Measurement."Active Total" + Measurement."Reactive Total";
                        if Measurement."Peak Total" > PeakMaxValue then PeakMaxValue:=Measurement."Peak Total";
                    until Measurement.Next() = 0;
                if TotalValue <> 0 then begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey(Date);
                    Measurement.SetRange("POD No.", Contract."POD No.");
                    Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                    if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total" + Measurement."Reactive Total";
                end;
                MeasurementValue:=TotalValue + PeakMaxValue - LastTotalValue;
            end;
            Meter."Reading Type"::Consumption: begin
                PeakMaxValue:=0;
                TotalValue:=0;
                Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                if Measurement.FindSet()then repeat TotalValue+=Measurement."Active Total" + Measurement."Reactive Total";
                        if Measurement."Peak Total" > PeakMaxValue then PeakMaxValue:=Measurement."Peak Total";
                    until Measurement.Next() = 0;
                MeasurementValue:=TotalValue + PeakMaxValue;
            end;
            end;
            exit(MeasurementValue * Meter."Energy Coeff");
        end;
    end;
    //KB04122023 - TASK002210 Invoice Billing Process ---
    var MissingPriceValueHeaderErr: Label 'Price value with the following details, does not exist: \\{%1}.', Comment = '%1 Filters on Price Value Header';
}
