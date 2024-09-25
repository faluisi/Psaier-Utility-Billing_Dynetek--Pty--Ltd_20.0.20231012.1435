table 50231 "Tariff Line"
{
    Caption = 'Tariff Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Header"."No.";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(15; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource."No.";

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                if Resource.Get(Rec."Resource No.")then Rec."Resource Name":=Resource.Name;
            end;
        }
        field(16; "Resource Name"; Text[100])
        {
            Caption = 'Resource Name';
        }
        field(20; Formula; Text[500])
        {
            Caption = 'Formula';

            trigger OnValidate();
            begin
                TarifValidationMgt.ValidateFormulaOperators(Rec.Formula);
            end;
        }
        field(21; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective Start date cannot be before Effective end date.';
                ErrorMsg2Lbl: Label 'Tariff Line is already define for Effective Start Date and Effective End Date Range.';
            begin
                if("Effective Start Date" > "Effective End Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
                if not VerifyDateNotRepeat(false)then Error(ErrorMsg2Lbl);
                if Rec."Effective Start Date" <> xRec."Effective Start Date" then UpdtaeFormulaLineDate();
            end;
        }
        field(22; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective end date cannot be before Effective Start date.';
                ErrorMsg2Lbl: Label 'Tariff Line is already define for Effective Start Date and Effective End Date Range.';
            begin
                if("Effective End Date" < "Effective Start Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
                if not VerifyDateNotRepeat(true)then Error(ErrorMsg2Lbl);
                if Rec."Effective End Date" <> xRec."Effective End Date" then UpdtaeFormulaLineDate();
            end;
        }
        field(30; "Meter Reading Detection";Enum "Meter Reading Detection")
        {
            Caption = 'Meter Reading Detection';
        }
        field(50200; "Dyn. Inv. Template No."; Integer)
        {
            Caption = 'Dynamic Invoice Entry No.';
            TableRelation = "Dynamic Inv. Content Template"."Entry No.";
        }
        field(50201; "Dyn. Inv. Eng Caption"; Text[500])
        {
            Caption = 'Dyn. Inv. Eng Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Content Template"."English Caption" where("Entry No."=field("Dyn. Inv. Template No.")));
            Editable = false;
        }
        field(50202; "Dyn. Inv. IT Caption"; Text[500])
        {
            Caption = 'Dyn. Inv. Eng Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Content Template"."Italian Caption" where("Entry No."=field("Dyn. Inv. Template No.")));
            Editable = false;
        }
        field(50203; "Dyn. Inv. DE Caption"; Text[500])
        {
            Caption = 'Dyn. Inv. Eng Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Content Template"."German Caption" where("Entry No."=field("Dyn. Inv. Template No.")));
            Editable = false;
        }
        field(50204; "Line Cost Type";enum "Tariff Line Cost Type")
        {
            Caption = 'Line Cost Type';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        //KB21022024 - Primary Key Remove Start Date End Date +++
        key(PK; "Tariff No.", "Line No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        rec.TestField(Formula);
    end;
    trigger OnDelete()
    var
        FormulaLine: Record "Formula Line";
    begin
        FormulaLine.SetRange("Tariff No.", Rec."Tariff No.");
        FormulaLine.SetRange("Tariff Line No.", Rec."Line No.");
        if not FormulaLine.IsEmpty()then FormulaLine.DeleteAll()end;
    local procedure UpdtaeFormulaLineDate()
    var
        FormulaLine: Record "Formula Line";
    begin
        FormulaLine.Reset();
        FormulaLine.SetRange("Tariff No.", Rec."Tariff No.");
        FormulaLine.SetRange("Tariff Line No.", Rec."Line No.");
        if FormulaLine.FindSet()then begin
            FormulaLine."Effective Start Date":=Rec."Effective Start Date";
            FormulaLine."Effective End Date":=Rec."Effective End Date";
            FormulaLine.Modify();
        end;
    end;
    local procedure VerifyDateNotRepeat(IsEndDate: Boolean): Boolean var
        TariffLine: Record "Tariff Line";
    begin
        TariffLine.Reset();
        TariffLine.SetRange("Tariff No.", Rec."Tariff No.");
        TariffLine.SetFilter("Line No.", '<>%1', Rec."Line No.");
        TariffLine.SetRange(Formula, Rec.Formula);
        TariffLine.SetRange("Resource No.", Rec."Resource No.");
        TariffLine.SetRange("Line Cost Type", Rec."Line Cost Type");
        TariffLine.SetRange("Meter Reading Detection", Rec."Meter Reading Detection");
        if IsEndDate then TariffLine.SetFilter("Effective Start Date", '<=%1', Rec."Effective End Date")
        else
            TariffLine.SetFilter("Effective Start Date", '<=%1', Rec."Effective Start Date");
        if IsEndDate then TariffLine.SetFilter("Effective End Date", '>=%1', Rec."Effective End Date")
        else
            TariffLine.SetFilter("Effective End Date", '>=%1', Rec."Effective Start Date");
        exit(TariffLine.IsEmpty());
    end;
    var TarifValidationMgt: Codeunit "Tarif Validation Management";
}
