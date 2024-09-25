table 50240 "Discount Price Line"
{
    //KB03042024 - Discount Calculation +++
    Caption = 'Discount Price Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Code[20])
        {
            Caption = 'ID';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Price Value No."; Code[20])
        {
            Caption = 'Price Value No.';
            TableRelation = "Price Value Header"."No.";
        }
        field(4; "Line Cost Type";Enum "Discount Line Cost Type")
        {
            Caption = 'Line Cost Type';
        }
        field(5; "Discount %"; Decimal)
        {
            Caption = 'Discount';
        }
        field(6; "Start Date"; Date)
        {
            Caption = 'Start Date';
        }
        field(7; "End Date"; Date)
        {
            Caption = 'End Date';
        }
        field(8; "Discount Type";Enum "Discount Type")
        {
            Caption = 'Discount Type';
        }
    }
    keys
    {
        key(PK; ID, "Line No.")
        {
            Clustered = true;
        }
    }
//KB03042024 - Discount Calculation ---
}
