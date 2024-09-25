tableextension 50205 "Sales Invoice Header Ext" extends "Sales Invoice Header"
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
        }
        field(50202; "Tariff Name"; Text[100])
        {
            Caption = 'Tariff Name';
            DataClassification = CustomerContent;
        }
        field(50250; "AAT Invoice Contract Period"; Text[30])
        {
            Caption = 'Invoice Contract Period';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50203; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Invoice Line"."VAT Amount" where("Document No."=field("No.")));
            Editable = false;
        }
        field(50204; "Invoice Date Period"; Text[250])
        {
            Caption = 'Invoice Date Period';
            DataClassification = ToBeClassified;
        }
    }
}
