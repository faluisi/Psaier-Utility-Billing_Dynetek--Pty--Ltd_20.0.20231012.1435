table 50244 "UTF Annual List"
{
    Caption = 'UTF Annual List';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Quadro No."; Code[20])
        {
            Caption = 'Quadro No.';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "POD No."; Code[25])
        {
            Caption = 'POD No.';
        }
        field(5; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(8; "Physical County Code"; Text[20])
        {
            Caption = 'Physical County Code';
        }
        field(9; "Physical City"; Text[30])
        {
            Caption = 'Physical City';
        }
        field(10; "Cadastral Municipality Code"; Code[20])
        {
            Caption = 'Cadastral Municipality Code';
        }
        field(11; Usage;enum Usage)
        {
            Caption = 'Usage';
        }
        field(12; "Contract Type";Enum "AAT Contract Type SII")
        {
            Caption = 'Contract Type';
        }
        field(13; Residenza; Boolean)
        {
            Caption = 'Residenza';
        }
        field(14; "Essente Accise"; Boolean)
        {
            Caption = 'Essente Accise';
        }
        field(15; "Recupero Accise"; Boolean)
        {
            Caption = 'Recupero Accise';
        }
        field(16; "Acciso Starting Range"; Decimal)
        {
            Caption = 'Acciso Starting Range';
        }
        field(17; "Acciso Ending Range"; Decimal)
        {
            Caption = 'Acciso Ending Range';
        }
        field(18; "Acciso Consumption"; Decimal)
        {
            Caption = 'Acciso Consumption';
        }
        field(19; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(20; Amount; Decimal)
        {
            Caption = 'Amount';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
