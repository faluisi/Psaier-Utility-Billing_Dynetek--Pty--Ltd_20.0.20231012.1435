table 50234 "Formula Line"
{
    Caption = 'Formula Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            TableRelation = "Tariff Line"."Tariff No.";
        }
        field(2; "Tariff Line No."; Integer)
        {
            Caption = 'Tariff Line No.';
            TableRelation = "Tariff Line"."Line No.";
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(10; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
            Editable = false;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective Start date cannot be before Effective end date.';
            begin
                if("Effective Start Date" > "Effective End Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(11; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
            Editable = false;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Effective end date cannot be before Effective Start date.';
            begin
                if("Effective End Date" < "Effective Start Date") and ("Effective End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(15; "Entry Type";Enum "Tariff Entry Type")
        {
            Caption = 'Entry Type';
        }
        field(20; "Parent No."; Code[20])
        {
            Caption = 'Parent Entry No.';
            TableRelation = "Formula Line"."No.";
        }
        field(21; "Parent Title"; Text[50])
        {
            Caption = 'Parent Title';
        }
        field(22; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(23; Title; Text[50])
        {
            Caption = 'Title';
        }
        field(24; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(31; "Global Vaiable"; Boolean)
        {
            Caption = 'Global Vaiable';
        }
        field(32; "Expose for Ext. Documents"; Boolean)
        {
            Caption = 'Expose for Ext. Documents';
        }
        field(40; Formula; Text[500])
        {
            Caption = 'Formula';

            trigger OnValidate();
            begin
                TarifValidationMgt.ValidateFormulaOperators(Rec.Formula);
            end;
        }
        field(41; "Decimal Places"; Integer)
        {
            Caption = 'Decimal Places';
        }
        field(50; "Lookup Table No."; Integer)
        {
            Caption = 'Lookup Table No.';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type"=const(Table));
        }
        field(51; "Lookup Table Name"; Text[249])
        {
            Caption = 'Lookup Table Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=field("Lookup Table No.")));
        }
        field(52; "Lookup Field No."; Integer)
        {
            Caption = 'Lookup Field No.';
            TableRelation = Field."No." where(TableNo=field("Lookup Table No."));

            trigger OnLookup()
            var
                Field: Record Field;
            begin
                Field.SetRange(TableNo, "Lookup Table No.");
                if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then Validate("Lookup Field No.", Field."No.");
            end;
        }
        field(53; "Lookup Field Name"; Text[80])
        {
            Caption = 'Lookup Field Name';
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo=field("Lookup Table No."), "No."=field("Lookup Field No.")));
            Editable = false;
        }
        field(54; "Lookup Filter"; Text[200])
        {
            Caption = 'Lookup Filter';
        }
        field(60; "Price Value No."; Code[20])
        {
            Caption = 'Price Value No.';
            TableRelation = "Price Value Header";

            trigger OnLookup()
            var
                PriceValueHeader: Record "Price Value Header";
            begin
                if Page.RunModal(Page::"Price Value Header List", PriceValueHeader) = Action::LookupOK then "Price Value No.":=PriceValueHeader."No.";
            end;
        }
        field(65; "Price Type";Enum "Price Value Price Type")
        {
            Caption = 'Price Type';
        }
    }
    keys
    {
        //KB21022024 - Primary Key Remove Start Date End Date +++
        key(PK; "Tariff No.", "Tariff Line No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var TarifValidationMgt: Codeunit "Tarif Validation Management";
}
