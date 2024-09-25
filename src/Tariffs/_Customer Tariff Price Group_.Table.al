table 50208 "Customer Tariff Price Group"
{
    Caption = 'Customer Tariff Price Group';

    fields
    {
        field(1; "No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(5; "Contract No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Contract."No.";
            Caption = 'Contract No.';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
