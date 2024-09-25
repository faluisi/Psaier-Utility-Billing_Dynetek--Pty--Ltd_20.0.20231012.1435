table 70200 "Time Shift"
{
    //KB30112023 - TASK002171 Measurement Upload Process +++
    Caption = 'Time Shift';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Code";enum "Fascia Type")
        {
            Caption = 'Code';
        }
        field(3; "Type";Enum "Working/Non-Working Day Type")
        {
            Caption = 'Type';
        }
        field(4; "Start Time"; Time)
        {
            Caption = 'Start Time';

            trigger OnValidate()
            var
                TimeShift: Record "Time Shift";
                ErrorLbl: Label 'Start Time %1 is already defined for Code=%2 and Type=%3.', Comment = 'Start Time %1 is already defined for Code=%2 and Type=%3.';
            begin
                TimeShift.Reset();
                TimeShift.SetRange(Type, Rec.Type);
                if TimeShift.FindSet()then repeat if TimeShift."Start Time" = Rec."Start Time" then Error(StrSubstNo(ErrorLbl, Rec."Start Time", Rec.Code, Rec.Type));
                    until TimeShift.Next() = 0;
            end;
        }
        field(5; "End Time"; Time)
        {
            Caption = 'End Time';

            trigger OnValidate()
            var
                TimeShift: Record "Time Shift";
                ErrorLbl: Label 'End Time %1 is already defined for Code=%2 and Type=%3.', Comment = 'End Time %1 is already defined for Code=%2 and Type=%3.';
            begin
                TimeShift.Reset();
                TimeShift.SetRange(Type, Rec.Type);
                if TimeShift.FindSet()then repeat if TimeShift."End Time" = Rec."End Time" then Error(StrSubstNo(ErrorLbl, Rec."End Time", Rec.Code, Rec.Type));
                    until TimeShift.Next() = 0;
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
//KB30112023 - TASK002171 Measurement Upload Process ---
}
