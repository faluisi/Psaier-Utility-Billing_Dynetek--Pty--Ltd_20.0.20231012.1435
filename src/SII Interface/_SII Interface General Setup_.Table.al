table 50220 "SII Interface General Setup"
{
    DataClassification = CustomerContent;
    Caption = 'SII Interface General Setup';

    fields
    {
        field(1; PK; Code[10])
        {
            Caption = 'PK';
        }
        field(10; "Switch In Manager VAT No."; Code[15])
        {
            Caption = 'Switch In Manager VAT No.';
        }
        field(15; "Switch In CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Switch In CP User';
        }
        field(18; "Switch In Code of Dispatching"; Code[10])
        {
            Caption = 'Code of Dispatching';
        }
        field(20; "Switch In Tariff Option";Enum "Tariff Options")
        {
            Caption = 'Switch In Tariff Option';
        }
        field(25; "CoA Tariff Option";Enum "Tariff Options")
        {
            Caption = 'CoA Tariff Option';
        }
        field(30; "CoA VAT Manager"; Code[25])
        {
            Caption = 'CoA VAT Manager';
        }
        field(35; "CoA CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'CoA CP User';
        }
        field(40; "CoC CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'CoC CP User';
        }
        field(45; "COC Tarrif Option";Enum "Tariff Options")
        {
            Caption = 'COC Tarrif Option';
        }
        field(50; "COC VAT Manager"; Code[25])
        {
            Caption = 'COC VAT Manager';
        }
        field(52; "COC Code of Dispatching"; Code[10])
        {
            Caption = 'Code of Dispatching';
        }
        field(55; "Switch Out VAT Manager"; Code[25])
        {
            Caption = 'Switch Out VAT Manager';
        }
        field(60; "Switch Out CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Switch Out CP User';
        }
        field(65; "Contract Termination CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Contract Termination CP User';
        }
        field(70; "AAT CT VAT Manager SII"; Code[25])
        {
            Caption = 'CT VAT Manager';
        }
        //KB08112023 - TASK002126 Deactivation Process +++
        field(70001; "Deactivation Manager VAT No."; Code[50])
        {
            Caption = 'Deactivation Manager VAT No.';
            DataClassification = ToBeClassified;
        }
        field(70002; "Deactivation CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Deactivation CP User';
            DataClassification = ToBeClassified;
        }
        field(70003; "Contract Disp"; Code[20])
        {
            Caption = 'Contract Disp';
            DataClassification = ToBeClassified;
        }
        //KB08112023 - TASK002126 Deactivation Process ---
        //KB20112023 - TASK002131 New Activation Process +++
        field(70100; "Activation Manager VAT No."; Code[50])
        {
            Caption = 'New Activation Manager VAT No.';
            DataClassification = ToBeClassified;
        }
        field(70101; "Activation CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'New Activation CP User';
            DataClassification = ToBeClassified;
        }
        field(70102; "Activation Contract Disp"; Code[20])
        {
            Caption = 'New Activation Contract Disp';
            DataClassification = ToBeClassified;
        }
        //KB20112023 - TASK002131 New Activation Process ---
        //KB24112023 - TASK002167 Reactivation Process +++
        field(70103; "Reactivation Manager VAT No."; Code[50])
        {
            Caption = 'Reactivation Manager VAT No.';
            DataClassification = ToBeClassified;
        }
        field(70104; "Reactivation CP User"; Code[20])
        {
            TableRelation = "No. Series";
            Caption = 'Reactivation CP User';
            DataClassification = ToBeClassified;
        }
        field(70105; "Reactivation Contract Disp"; Code[20])
        {
            Caption = 'Reactivation Contract Disp';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; PK)
        {
            Clustered = true;
        }
    }
    var RecordHasBeenRead: Boolean;
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then exit;
        Get();
        RecordHasBeenRead:=true;
    end;
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get()then begin
            Init();
            Insert(true);
        end;
    end;
}
