codeunit 50212 "Tariff Calculation Management"
{
    trigger OnRun()
    var
    begin
    end;
    procedure TextFx()
    var
        contract: Record Contract;
        tariffLine: Record "Tariff Line";
        results: Decimal;
        Qunatity: Decimal;
        UnitPriceLbl: Label 'Unit Price = %1';
    begin
        // results := CalculateFormulaDec('FIN', 'root', 'SUM(SUM(1,2),5)'); //==6
        // results := CalculateFormulaDec('FIN', 'root', 'SUM(SUM(1,2),SUM(5,4))'); //== 12
        // results := CalculateFormulaDec('FIN', 'root', 'SUB(5,1)');
        // results := CalculateFormulaDec('FIN', 'root', 'SUM(SUM(SUM(1,2),3),SUM(4,5))'); //==15
        // results := CalculateFormulaDec('FIN', '?', 'SUM(2,5)');
        // results := CalculateFormulaDec('FIN', '?', 'SUM(5,10,20,5)');
        // results := CalculateFormulaDec('FIN', 'SUB(SUM(10,MAX(3,10,20)),MULT(MIN(5,10,20),2))', 0);
        // results := CalculateResultsForFormula('SUM(SUM(SUM(1,2),3),SUM(4,5))';
        contract.SetRange("No.", 'CON-000004');
        contract.FindFirst();
        tariffLine.SetRange("Tariff No.", contract."Tariff Option No.");
        tariffLine.FindFirst();
        results:=CalculateUnitPrice(tariffLine, contract, CalcDate('<-1M>', WorkDate()), WorkDate(), "Active Type"::" ", "Reactive Type"::" ", false, Qunatity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, '', 0);
        Message(UnitPriceLbl, results);
    end;
    /// <summary>
    /// Provided a String Formula, Perform calculations and return Decimal
    /// (Will be used recursively, To Start FX cant be blank!)
    /// </summary>
    /// <param name="function">Text.</param>
    /// <param name="remainingSide">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    local procedure CalculateFormulaDec(function: Text; remainingSide: Text; level: Integer; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer)returnVal: Decimal var
        formulaLine: Record "Formula Line";
        calcStepResult: Decimal;
        tempDecimal: Decimal;
        formulaPartIndex: Integer;
        tempIngeger: Integer;
        //tokenList: List of [Text];
        fxParmList: List of[Decimal];
        fxParmListCurrLvl: List of[Decimal];
        //tempResult: Decimal;
        // calcFunction: Text;
        //calcRemainingSide: Text;
        functionList: List of[Text];
        remainingSideList: List of[Text];
        tempParmsAsText: List of[Text];
        currParamterAsText: Text;
        currRemainingSide: Text;
    //index: Integer;
    begin
        BreakdownFormula(remainingSide, functionList, remainingSideList);
        Clear(fxParmList);
        for formulaPartIndex:=1 to functionList.Count()do begin
            currRemainingSide:=remainingSideList.Get(formulaPartIndex);
            if StrContainsFormula(currRemainingSide)then begin
                // This part stil contains a formula. Get the result and add the result to the decimal parameter list.
                calcStepResult:=CalculateFormulaDec(functionList.Get(formulaPartIndex), currRemainingSide, level + 1, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo);
                fxParmList.Add(calcStepResult);
            end
            else
            begin
                // Constant values, Split (if needed) and add to decimal parameter list.
                Clear(tempParmsAsText);
                if(currRemainingSide.Contains(','))then tempParmsAsText.AddRange(currRemainingSide.Split(','))
                else
                    tempParmsAsText.Add(currRemainingSide);
                Clear(fxParmListCurrLvl);
                foreach currParamterAsText in tempParmsAsText do begin
                    // if (DelChr(currParamterAsText, '-,.1234567890') = '') then begin
                    //     Evaluate(tempDecimal, currParamterAsText);
                    //     fxParmListCurrLvl.Add(tempDecimal);
                    // end else begin
                    // if Confirm('ID to calc Price Val = >%1<', false, currParamterAsText) then;
                    formulaLine.SetRange("No.", currParamterAsText.Trim());
                    if(not formulaLine.IsEmpty())then begin
                        tempDecimal:=GetFormulaPriceValue(currParamterAsText, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo);
                        fxParmListCurrLvl.Add(tempDecimal);
                    end
                    else
                    begin
                        if Evaluate(tempIngeger, currParamterAsText.Trim())then fxParmListCurrLvl.Add(tempIngeger);
                    end;
                end;
                fxParmList.Add(RunSingleFX(functionList.Get(formulaPartIndex), fxParmListCurrLvl));
            end;
        end;
        // Final Calc for this level
        returnVal:=RunSingleFX(function, fxParmList);
    end;
    /// <summary>
    /// Check if a given Formula string contains a Function
    /// </summary>
    /// <param name="textToCheck">Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    local procedure StrContainsFormula(textToCheck: Text): Boolean begin
        exit(textToCheck.Contains('('));
    end;
    /// <summary>
    /// Break Formula string down into next formula / plain paramters
    /// </summary>
    /// <param name="formulaString">Current Step Fx String</param>
    /// <param name="functionList">VAR, Broken down function list</param>
    /// <param name="remainingSideList">VAR, Broken down parameter list</param>
    local procedure BreakdownFormula(formulaString: Text; var functionList: List of[Text]; var remainingSideList: List of[Text])
    var
        endOfFxString: Boolean;
        findingFX: Boolean;
        findingRemainPart: Boolean;
        currCharValue: Char;
        bracketCounter: Integer;
        currCharPos: Integer;
        fxStringLength: Integer;
        tempFxString: Text;
        tempRemainPartString: Text;
    begin
        findingFX:=true;
        findingRemainPart:=false;
        fxStringLength:=StrLen(formulaString);
        for currCharPos:=1 to fxStringLength do begin
            currCharValue:=formulaString[currCharPos];
            endOfFxString:=fxStringLength = currCharPos;
            if(currCharValue = '(')then bracketCounter+=1;
            if(currCharValue = ')')then bracketCounter-=1;
            findingRemainPart:=bracketCounter > 0;
            findingFX:=not findingRemainPart;
            if(((currCharValue = ',') and (bracketCounter = 0)) or endOfFxString)then begin
                // We now have the FX and Remaining > Add to List\
                if endOfFxString then begin
                    if(findingFX and (bracketCounter = 0))then tempFxString+=currCharValue;
                    if(findingRemainPart and (bracketCounter <> 0))then tempRemainPartString+=currCharValue;
                end;
                tempFxString:=tempFxString.Replace(')', '');
                if(tempRemainPartString[1] = '(')then tempRemainPartString:=tempRemainPartString.Substring(2);
                // Catch Constant values
                if((tempRemainPartString = '') and (tempFxString <> ''))then begin
                    tempRemainPartString:=tempFxString;
                    tempFxString:='CONST';
                end;
                functionList.Add(tempFxString);
                remainingSideList.Add(tempRemainPartString);
                tempFxString:='';
                tempRemainPartString:='';
            end
            else
            begin
                if(findingFX and (bracketCounter = 0))then tempFxString+=currCharValue;
                if(findingRemainPart and (bracketCounter <> 0))then tempRemainPartString+=currCharValue;
            end;
        end;
    end;
    /// <summary>
    /// Take a single Function with its parms and call correct subset of calculations.
    /// </summary>
    /// <param name="functionAsText">Function to Run</param>
    /// <param name="fxParmList">List of function paramters</param>
    /// <returns>Return value of type Decimal.</returns>
    local procedure RunSingleFX(functionAsText: Text; fxParmList: List of[Decimal]): Decimal var
        tempDecimal: Decimal;
        enumValueIndex: Integer;
        UnsupportedFunctionErr: Label 'Function "%1" not supported, Please review formula.';
        boolParameters: List of[Boolean];
    begin
        // Final Results, dont waste time, return value.
        if(functionAsText = 'FIN')then exit(fxParmList.Get(1));
        if(functionAsText = 'CONST')then // if Confirm('LS Count = %1', false, fxParmList.Count) then;
            exit(fxParmList.Get(1));
        // --- Actual Operational Functions ---
        enumValueIndex:=Enum::"Tarif Calc Decimal Operations".Names().IndexOf(functionAsText);
        if(enumValueIndex > 0)then exit(RunSingleDecimalFunction(Enum::"Tarif Calc Decimal Operations".FromInteger(enumValueIndex), fxParmList));
        enumValueIndex:=Enum::"Tarif Calc Logic Operations".Names().IndexOf(functionAsText);
        if(enumValueIndex > 0)then begin
            foreach tempDecimal in fxParmList do boolParameters.Add(tempDecimal = 1);
            if(RunSingleLogicalFunction(Enum::"Tarif Calc Logic Operations".FromInteger(enumValueIndex), boolParameters))then exit(1)
            else
                exit(0);
        end;
        enumValueIndex:=Enum::"Tarif Dec Logic Operations".Names().IndexOf(functionAsText);
        if(enumValueIndex > 0)then if(RunSingleDecimalLogicFunction(Enum::"Tarif Dec Logic Operations".FromInteger(enumValueIndex), fxParmList))then exit(1)
            else
                exit(0);
        Error(UnsupportedFunctionErr, functionAsText);
    end;
    /// <summary>
    /// Perform Operations for functions such as SUM, MIN, MAX
    /// </summary>
    /// <param name="operation">Operation to perform</param>
    /// <param name="parameters">List of Decimals</param>
    /// <returns>Returns Decimal</returns>
    local procedure RunSingleDecimalFunction(operation: Enum "Tarif Calc Decimal Operations"; parameters: List of[Decimal]): Decimal var
        firstNumberSet: Boolean;
        finalResultDecimal: Decimal;
        tempDecimal: Decimal;
        DIVParamErr: Label 'Function "DIV" only supports 2 parameters at this time.';
        EQUALParamErr: Label 'Function "EQUAL" only supports 2 parameters at this time.';
        MULTParamErr: Label 'Function "MULT" only supports 2 parameters at this time.';
    begin
        case operation of "Tarif Calc Decimal Operations"::"SUM": begin
            foreach tempDecimal in parameters do finalResultDecimal+=tempDecimal;
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"SUB": begin
            firstNumberSet:=false;
            foreach tempDecimal in parameters do if not firstNumberSet then begin
                    finalResultDecimal:=tempDecimal;
                    firstNumberSet:=true;
                end
                else
                    finalResultDecimal-=tempDecimal;
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"MULT": begin
            if parameters.Count > 2 then Error(MULTParamErr);
            finalResultDecimal:=parameters.Get(1) * parameters.Get(2);
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"DIV": begin
            if parameters.Count > 2 then Error(DIVParamErr);
            finalResultDecimal:=parameters.Get(1) / parameters.Get(2);
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"MAX": begin
            finalResultDecimal:=parameters.Get(1);
            foreach tempDecimal in parameters do if(tempDecimal > finalResultDecimal)then finalResultDecimal:=tempDecimal;
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"MIN": begin
            finalResultDecimal:=parameters.Get(1);
            foreach tempDecimal in parameters do if(tempDecimal < finalResultDecimal)then finalResultDecimal:=tempDecimal;
            exit(finalResultDecimal);
        end;
        "Tarif Calc Decimal Operations"::"EQUAL": begin
            if parameters.Count > 2 then Error(EQUALParamErr);
            // Acts like Comparer
            if(parameters.Get(1) > parameters.Get(2))then exit(1);
            if(parameters.Get(1) < parameters.Get(2))then exit(-1);
            exit(0);
        end;
        end;
    end;
    /// <summary>
    /// Perform Operations for functions such as IF, AND, NOT
    /// </summary>
    /// <param name="operation">Operation to perform</param>
    /// <param name="parameters">List of Booleans</param>
    /// <returns>Returns Boolean</returns>
    local procedure RunSingleLogicalFunction(operation: Enum "Tarif Calc Logic Operations"; parameters: List of[Boolean]): Boolean var
        UnsupportedFunctionErr: Label ' Funtion "%1" not supported yet.';
    begin
        case operation of "Tarif Calc Logic Operations"::"IF": Error(UnsupportedFunctionErr, "Tarif Calc Logic Operations"::"IF");
        "Tarif Calc Logic Operations"::"THEN": Error(UnsupportedFunctionErr, "Tarif Calc Logic Operations"::"THEN");
        "Tarif Calc Logic Operations"::"ELSE": Error(UnsupportedFunctionErr, "Tarif Calc Logic Operations"::"ELSE");
        "Tarif Calc Logic Operations"::"OR": exit(parameters.Get(1) or parameters.Get(2));
        "Tarif Calc Logic Operations"::"AND": exit(parameters.Get(1) and parameters.Get(2));
        "Tarif Calc Logic Operations"::"NOT": exit(not parameters.Get(1));
        "Tarif Calc Logic Operations"::"EQUAL": // Acts like == for bools only
            exit(parameters.Get(1) = parameters.Get(2));
        end;
    end;
    /// <summary>
    /// Perform Operations for functions such as Greater, Smaller
    /// </summary>
    /// <param name="operation">Operation to perform</param>
    /// <param name="parameters">List of Decimals</param>
    /// <returns>Returns Boolean</returns>
    local procedure RunSingleDecimalLogicFunction(operation: Enum "Tarif Dec Logic Operations"; parameters: List of[Decimal]): Boolean begin
        case operation of "Tarif Dec Logic Operations"::"EQUAL": exit(parameters.Get(1) = parameters.Get(2));
        "Tarif Dec Logic Operations"::GREATER: exit(parameters.Get(1) > parameters.Get(2));
        "Tarif Dec Logic Operations"::SMALLER: exit(parameters.Get(1) < parameters.Get(2));
        end;
    end;
    // -----------------------------------
    /// <summary>
    /// Main Entry point for "Invoice Generation Mgt" Codeunit
    /// </summary>
    /// <param name="tariffLine">Record "Tariff Line".</param>
    /// <param name="contract">Record Contract.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalculateUnitPrice(tariffLine: Record "Tariff Line"; contract: Record Contract; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer): Decimal var
        ErrorInfo: ErrorInfo;
    begin
        ErrorInfo.Collectible:=true;
        CurrentTariffLine.Get(tariffLine.RecordId);
        CurrentContract.Get(contract.RecordId);
        if CurrentTariffLine.Formula = '' then begin
            ErrorInfo.Message:=StrSubstNo(MissingFormulaInTariffLineErr, CurrentTariffLine."Line No.", CurrentTariffLine."Tariff No.");
            Error(ErrorInfo);
        end;
        exit(CalculateResultsForFormula(CurrentTariffLine.Formula, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo))end;
    /// <summary>
    /// Wrapper function for Recursive function to calculate Results from single Formula String
    /// </summary>
    /// <param name="formulaText">The Formula Text to Calculate</param>
    /// <returns>Returns Results as Decimal</returns>
    procedure CalculateResultsForFormula(formulaText: Text; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer): Decimal;
    begin
        exit(CalculateFormulaDec('FIN', formulaText, 0, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo));
    end;
    local procedure GetFormulaPriceValue(tempText: Text; StartOfMonthDate: Date; EndDate: Date; ActiveType: Enum "Active Type"; ReactiveType: Enum "Reactive Type"; IsQuantity: Boolean; var Quantity: Decimal; IsSystemTransport: Boolean; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range"; NetLoss: Boolean; IsDiscount: Boolean; DocumentNo: Code[20]; LineNo: Integer): Decimal var
        FormulaLine: Record "Formula Line";
        TariffHeader: Record "Tariff Header";
        tariffPriceValueMngt: Codeunit "Tariff Price Value Management";
        ErrorInfo: ErrorInfo;
    begin
        ErrorInfo.Collectible:=true;
        FormulaLine.SetRange("No.", tempText);
        FormulaLine.SetRange("Tariff No.", CurrentTariffLine."Tariff No.");
        FormulaLine.SetRange("Tariff Line No.", CurrentTariffLine."Line No.");
        FormulaLine.SetFilter("Effective Start Date", '<=%1', StartOfMonthDate);
        FormulaLine.SetFilter("Effective End Date", '>=%1&>=%2', StartOfMonthDate, EndDate);
        if not FormulaLine.FindFirst()then begin
            ErrorInfo.Message:=StrSubstNo(NoTarifLineLbl, FormulaLine.GetFilters());
            Error(ErrorInfo);
        end;
        exit(tariffPriceValueMngt.GetPriceValue(CurrentContract, FormulaLine, StartOfMonthDate, EndDate, ActiveType, ReactiveType, IsQuantity, Quantity, IsSystemTransport, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, NetLoss, IsDiscount, DocumentNo, LineNo));
    end;
    /// <summary>
    /// For Debugging only
    /// Convert List to text to readable CSV
    /// </summary>
    /// <param name="listParm">List of [Decimal].</param>
    /// <returns>Return value of type Text.</returns>
     // local procedure DecListToString(listParm: List of [Decimal]): Text
    // var
    //     tempText: Text;
    //     index: Integer;
    // begin
    //     for index := 1 to listParm.Count() do
    //         tempText += Format(listParm.Get(index)) + ';';
    //     exit(tempText);
    // end;
    var CurrentContract: Record Contract;
    CurrentTariffLine: Record "Tariff Line";
    MissingFormulaInTariffLineErr: Label 'Tariff line %1 of Tariff %2 has no Formula assigned.', Comment = '%1 = Tariff Line No, %2 = Tariff No';
    NoTarifLineLbl: Label 'No related Formula lines could be located.\Filters: {%1}', Comment = '%1 = set Filter';
}
