table 50238 "AAT Compensation Scheme Lines"
{
    DataClassification = CustomerContent;
    Caption = 'Compensation Scheme Lines';

    fields
    {
        field(1; "AAT Scheme Code"; Code[20])
        {
            TableRelation = "AAT Compensation Scheme SII"."AAT Code SII";
            Caption = 'Scheme Code';
        }
        field(10; "AAT Start Date"; Date)
        {
            Caption = 'Start Date';

            trigger OnValidate();
            begin
                ValidateDateFields();
            end;
        }
        field(20; "AAT End Date"; Date)
        {
            Caption = 'End Date';

            trigger OnValidate();
            begin
                ValidateDateFields();
            end;
        }
        field(30; "AAT Additional Monthly Disc."; Decimal)
        {
            Caption = 'Additional Monthly Disc.';
        }
        field(40; "AAT Year"; Integer)
        {
            Caption = 'Year';
        }
    }
    keys
    {
        key(PK; "AAT Scheme Code", "AAT Start Date", "AAT End Date", "AAT Year")
        {
            Clustered = true;
        }
    }
    var OutsideYearErr: Label 'Period outside of year.';
    ErrorMsg: Label 'Effective End Date cannot be after Effective Start Date.';
    local procedure ValidateDateFields()
    var
        AATCompSchemeValidation: Codeunit "AAT Comp. Scheme Validation";
    begin
        DateInYearCheck();
        if((Rec."AAT Start Date" >= Rec."AAT End Date") and (Rec."AAT End Date" <> 0D))then Error(ErrorMsg);
        AATCompSchemeValidation.ValidateOverlappingDatesOnCompSchemes(Rec, xRec);
    end;
    local procedure DateInYearCheck()
    begin
        if Rec."AAT Year" = 0 then exit;
        if Rec."AAT Start Date" <> 0D then if(Rec."AAT Start Date" < DMY2Date(1, 1, Rec."AAT Year")) or (Rec."AAT Start Date" > DMY2Date(31, 12, Rec."AAT Year"))then Error(OutsideYearErr);
        if Rec."AAT End Date" <> 0D then if(Rec."AAT End Date" < DMY2Date(1, 1, Rec."AAT Year")) or (Rec."AAT End Date" > DMY2Date(31, 12, Rec."AAT Year"))then Error(OutsideYearErr);
    end;
    procedure isSchemeValid(): Boolean var
    begin
        exit((Rec."AAT Start Date" <> 0D) and (Rec."AAT End Date" <> 0D));
    end;
}
