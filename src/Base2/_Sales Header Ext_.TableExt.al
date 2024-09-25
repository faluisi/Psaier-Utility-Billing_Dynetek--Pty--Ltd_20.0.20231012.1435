tableextension 50204 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50200; "Contract No."; Code[25])
        {
            Caption = 'Contract No.';
            DataClassification = CustomerContent;
            TableRelation = Contract."No.";
        }
        field(50201; "Tariff No."; Code[20])
        {
            Caption = 'Tariff No.';
            DataClassification = CustomerContent;
            TableRelation = "Tariff Header"."No.";

            trigger OnValidate()
            var
                TariffHeader: Record "Tariff Header";
            begin
                TariffHeader.SetRange("No.", Rec."Tariff No.");
                if TariffHeader.FindFirst()then Rec.Validate("Tariff Name", TariffHeader.Description);
            end;
        }
        field(50202; "Tariff Name"; Text[100])
        {
            Caption = 'Tariff Name';
            DataClassification = CustomerContent;
        }
        field(50250; "AAT Invoice Contract Period"; Text[30])
        {
            Caption = 'Billing Period';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50203; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."VAT Amount" where("Document Type"=field("Document Type"), "Document No."=field("No.")));
            Editable = false;
        }
        field(50204; "Invoice Date Period"; Text[250])
        {
            Caption = 'Invoice Date Period';
            DataClassification = ToBeClassified;
        }
    }
}
