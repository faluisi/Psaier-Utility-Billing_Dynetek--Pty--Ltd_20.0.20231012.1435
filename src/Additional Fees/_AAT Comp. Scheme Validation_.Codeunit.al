codeunit 50224 "AAT Comp. Scheme Validation"
{
    trigger OnRun()
    begin
    end;
    procedure ValidateOverlappingDatesOnCompSchemes(var AATCompensationSchemeLines: Record "AAT Compensation Scheme Lines"; xAATCompensationSchemeLines: Record "AAT Compensation Scheme Lines"): Boolean var
        AATCompensationSchemeLines2: Record "AAT Compensation Scheme Lines";
        ExistingStartDateExistErr: Label 'Compensation Scheme with the same code has a starting date of %1 before the new end date of %2', Comment = '%1 = Existing start date, %2 = new end date';
        ExistingEndDateExistErr: Label 'Compensation Scheme with the same code has an end date of %1 before the new start date of %2', Comment = '%1 = Existing end date, %2 = new start date';
    begin
        // if not xRec.IsEmpty then
        //     exit(true);
        AATCompensationSchemeLines2.SetRange("AAT Scheme Code", AATCompensationSchemeLines."AAT Scheme Code");
        AATCompensationSchemeLines2.SetRange("AAT Year", AATCompensationSchemeLines."AAT Year");
        // if AATCompensationSchemeLines2.IsEmpty() then
        //     exit;
        AATCompensationSchemeLines2.SetRange("AAT Start Date", AATCompensationSchemeLines."AAT Start Date", AATCompensationSchemeLines."AAT End Date");
        if AATCompensationSchemeLines2.FindFirst()then if Format(AATCompensationSchemeLines) <> Format(AATCompensationSchemeLines2)then if Format(xAATCompensationSchemeLines) <> Format(AATCompensationSchemeLines2)then Error(ExistingStartDateExistErr, AATCompensationSchemeLines2."AAT Start Date", AATCompensationSchemeLines."AAT End Date");
        AATCompensationSchemeLines2.SetRange("AAT Start Date");
        AATCompensationSchemeLines2.SetRange("AAT End Date", AATCompensationSchemeLines."AAT Start Date", AATCompensationSchemeLines."AAT End Date");
        if AATCompensationSchemeLines2.FindFirst()then if Format(AATCompensationSchemeLines) <> Format(AATCompensationSchemeLines2)then if Format(xAATCompensationSchemeLines) <> Format(AATCompensationSchemeLines2)then Error(ExistingEndDateExistErr, AATCompensationSchemeLines2."AAT End Date", AATCompensationSchemeLines."AAT Start Date");
        exit(true)end;
}
