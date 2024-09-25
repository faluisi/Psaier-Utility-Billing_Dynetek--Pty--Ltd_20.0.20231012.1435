table 50237 "AAT Compensation Scheme SII"
{
    DataClassification = CustomerContent;
    Caption = 'Compensation Scheme';

    fields
    {
        field(1; "AAT Code SII"; Code[50])
        {
            Caption = 'Code';
        }
        field(10; "AAT Year SII"; Integer)
        {
            Caption = 'Year';
        }
        field(20; "AAT Monthly Discount SII"; Decimal)
        {
            Caption = 'Monthly Discount';
        }
        field(30; "AAT Description SII"; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "AAT Code SII", "AAT Year SII")
        {
            Clustered = true;
        }
    }
    procedure ConfirmEmptyCompScheme(): Boolean var
        AATCompensationSchemeLines: Record "AAT Compensation Scheme Lines";
        ConfirmManagement: Codeunit "Confirm Management";
        Counter: Integer;
        IncompleteSchemeErr: Label '%1 Compensation Scheme Lines have empty start or end dates.', Comment = '%1=Counter';
    begin
        Counter:=0;
        AATCompensationSchemeLines.SetRange("AAT Scheme Code", Rec."AAT Code SII");
        AATCompensationSchemeLines.SetRange("AAT Year", Rec."AAT Year SII");
        if AATCompensationSchemeLines.FindSet()then repeat if not AATCompensationSchemeLines.isSchemeValid()then Counter+=1;
            until AATCompensationSchemeLines.Next() = 0;
        if Counter > 0 then if ConfirmManagement.GetResponse(StrSubstNo(IncompleteSchemeErr, Counter), false)then exit(true)
            else
                exit(false);
        exit(true);
    end;
}
