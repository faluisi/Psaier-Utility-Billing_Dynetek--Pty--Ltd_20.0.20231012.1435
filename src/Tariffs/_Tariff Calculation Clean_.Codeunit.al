codeunit 50214 "Tariff Calculation Clean"
{
    procedure BreakdownFormula(formulaString: Text; var functionList: List of[Text]; var remainingSideList: List of[Text])
    var
        currCharPos: Integer;
        bracketCounter: Integer;
        currCharValue: Char;
        fxStringLength: Integer;
        endOfFxString: Boolean;
        findingFX: Boolean;
        tempFxString: Text;
        findingRemainPart: Boolean;
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
    /// Provided a String Formula, Perform calculations and return Decimal
    /// (Will be used recursively, To Start FX cant be blank!)
    /// </summary>
    /// <param name="function">Text.</param>
    /// <param name="returnType">Text.</param>
    /// <param name="remainingSide">Text.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure CalculateFormulaDec(function: Text; returnType: Text; remainingSide: Text)returnVal: Decimal var
        fxParmList: List of[Decimal];
        tempParmsAsText: List of[Text];
        tempText: Text;
        tempText2: Text;
        tempDecimal: Decimal;
        functionList: List of[Text];
        remainingSideList: List of[Text];
        formulaPartIndex: Integer;
        index: Integer;
    begin
        BreakdownFormula(remainingSide, functionList, remainingSideList);
        for index:=1 to functionList.Count()do;
        Clear(fxParmList);
        for formulaPartIndex:=1 to functionList.Count()do begin
            tempText:=remainingSideList.Get(formulaPartIndex);
            if StrContainsFormula(tempText)then // This part still contains a formula. Get the result and add the result to the decimal parameter list.
                fxParmList.Add(CalculateFormulaDec(functionList.Get(formulaPartIndex), returnType + ' > ' + tempText, tempText))
            else
            begin
                // Constant values, Split (if needed) and add to decimal parameter list.
                Clear(tempParmsAsText);
                if(tempText.Contains(','))then tempParmsAsText.AddRange(tempText.Split(','))
                else
                    tempParmsAsText.Add(tempText);
                foreach tempText2 in tempParmsAsText do begin
                    Evaluate(tempDecimal, tempText2);
                    fxParmList.Add(tempDecimal);
                end;
            end;
        end;
        tempText2:='';
        for index:=1 to fxParmList.Count()do tempText2+=Format(fxParmList.Get(index)) + ';';
        // Final Results, dont waste time, return value.
        if(function = 'FIN')then returnVal:=fxParmList.Get(1);
        // Actual Operational Functions
        if(function = 'SUM')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::"SUM", fxParmList);
        if(function = 'SUB')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::SUB, fxParmList);
        if(function = 'MULT')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::MULT, fxParmList);
        if(function = 'DIV')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::"DIV", fxParmList);
        if(function = 'MAX')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::"MAX", fxParmList);
        if(function = 'MIN')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::"MIN", fxParmList);
        if(function = 'EQUAL')then returnVal:=RunSingleDecimalFunction("Tarif Calc Decimal Operations"::EQUAL, fxParmList);
        // Return value set > Clear the paramters
        Clear(fxParmList);
    end;
    local procedure StrContainsFormula(textToCheck: Text): Boolean begin
        exit(textToCheck.Contains('('));
    end;
    /// <summary>
    /// Perform Operations for functions such as SUM, MIN, MAX
    /// </summary>
    /// <param name="operation">Operation to perform</param>
    /// <param name="parameters">List of Decimals</param>
    /// <returns>Returns Decimal</returns>
    procedure RunSingleDecimalFunction(operation: Enum "Tarif Calc Decimal Operations"; parameters: List of[Decimal]): Decimal var
        MULTParamErr: Label 'Function "MULT" only supports 2 parameters at this time.';
        DIVParamErr: Label 'Function "DIV" only supports 2 parameters at this time.';
        EQUALParamErr: Label 'Function "EQUAL" only supports 2 parameters at this time.';
        DecCalcFuncErr: Label 'Decimal Calculation Error:\Function "%1" not supported.', Comment = 'Decimal Calculation Error:\Function "%1" not supported.';
        finalResultDecimal: Decimal;
        tempDecimal: Decimal;
        firstNumberSet: Boolean;
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
        Error(DecCalcFuncErr, operation);
    end;
}
