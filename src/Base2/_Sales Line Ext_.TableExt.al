tableextension 50202 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
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
            Caption = 'Dyn. Inv. IT Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Content Template"."Italian Caption" where("Entry No."=field("Dyn. Inv. Template No.")));
            Editable = false;
        }
        field(50203; "Dyn. Inv. DE Caption"; Text[500])
        {
            Caption = 'Dyn. Inv. DE Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Content Template"."German Caption" where("Entry No."=field("Dyn. Inv. Template No.")));
            Editable = false;
        }
        //KB01022024 - Billing Process Accisso Price calculation +++
        field(50204; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec."Invoice Date Period":=Format("Effective Start Date", 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>') + ' - ' + Format("Effective End Date", 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>');
            end;
        }
        field(50205; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Rec."Invoice Date Period":=Format("Effective Start Date", 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>') + ' - ' + Format("Effective End Date", 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>');
            end;
        }
        field(50206; "Active Type";enum "Active Type")
        {
            Caption = 'Active Type';
            DataClassification = ToBeClassified;
        }
        field(50207; "Reactive Type";enum "Reactive Type")
        {
            Caption = 'Reactive Type';
            DataClassification = ToBeClassified;
        }
        field(50208; "Invoice Date Period"; Text[100])
        {
            Caption = 'Invoice Date Period';
            DataClassification = ToBeClassified;
        }
        //KB01022024 - Billing Process Accisso Price calculation ---
        field(50210; "VAT Amount"; Decimal)
        {
            Caption = 'VAT Amount';
            DataClassification = ToBeClassified;
        }
        field(50211; "Invoice Active Type"; Text[200])
        {
            Caption = 'Invoice Active Type';
            DataClassification = ToBeClassified;
        }
        field(50212; "Invoice Reactive Type"; Text[200])
        {
            Caption = 'Invoice Reactive Type';
            DataClassification = ToBeClassified;
        }
        field(50213; "Invoice Unit Of Measure"; Code[10])
        {
            Caption = 'Invoice Unit Of Measure';
            DataClassification = ToBeClassified;
        }
        field(50214; "Acciso Starting Range"; Decimal)
        {
            Caption = 'Acciso Starting Range';
            DataClassification = ToBeClassified;
        }
        field(50215; "Acciso Ending Range"; Decimal)
        {
            Caption = 'Acciso Ending Range';
            DataClassification = ToBeClassified;
        }
    }
}
