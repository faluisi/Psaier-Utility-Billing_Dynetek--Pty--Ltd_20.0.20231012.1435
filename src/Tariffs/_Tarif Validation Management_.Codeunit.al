codeunit 50219 "Tarif Validation Management"
{
    procedure ValidateFormulaOperators(Formula: Text[500])
    var
        AllUnsupportedChars: Text;
        unsupportedItem: Text[5];
    begin
        AllUnsupportedChars:=FormulaUnsupportedOperatorsLbl;
        foreach unsupportedItem in AllUnsupportedChars.Split(',')do if(Formula.Contains(unsupportedItem))then Error(StrSubstNo(FormulaUnsupportedCharErrorLbl, unsupportedItem, FormulaSupportedOperatorsLbl));
    end;
    var FormulaUnsupportedOperatorsLbl: Label '+,-,/,*,\,>,<', Comment = '+,-,/,*,\,>,<';
    FormulaSupportedOperatorsLbl: Label 'SUM(), SUB(), MULT(), DIV(), MIN(), MAX()';
    FormulaUnsupportedCharErrorLbl: Label 'Operator "%1" not supported. \Supported Operators are: %2', Comment = 'Operator "%1" not supported. \Supported Operators are: %2';
}
