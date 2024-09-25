table 50214 "Point of Delivery - Yearly Con"
{
    Caption = 'Point of Delivery - Yearly Con';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(5; "POD No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(10; Period; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(15; Consumption; Decimal)
        {
            Caption = 'Consumption';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
}
