table 50218 "Dynamic Invoice DataItem"
{
    Caption = 'DynamicInvDataItem.Table';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'Invoice No.';
            NotBlank = true;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Pre - Assigned No.';
        }
        field(30; "Due Date"; Date)
        {
            Caption = 'Pre - Assigned No.';
        }
        field(40; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
        field(50; "Document Type";Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
