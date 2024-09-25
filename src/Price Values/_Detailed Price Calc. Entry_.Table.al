table 50241 "Detailed Price Calc. Entry"
{
    Caption = 'Detailed Price Calculation Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(5; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
        }
        field(6; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
        }
        field(7; "Active Type";Enum "Active Type")
        {
            Caption = 'Active Type';
        }
        field(8; "Reactive Type";Enum "Reactive Type")
        {
            Caption = 'Reactive Type';
        }
        field(9; "Price Value No."; Code[20])
        {
            Caption = 'Price Value No.';
        }
        field(10; Price; Decimal)
        {
            Caption = 'Price';
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(12; "Document Type";Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(14; "Dyn. Inv. Template No."; Integer)
        {
            Caption = 'Dyn. Inv. Template No.';
        }
        field(15; "Price Type";Enum "Price Value Price Type")
        {
            Caption = 'Price Type';
        }
        field(16; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
        }
        field(17; "Line Amount"; Decimal)
        {
            Caption = 'Line Amount';
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
