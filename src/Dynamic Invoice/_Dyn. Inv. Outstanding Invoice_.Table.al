table 50221 "Dyn. Inv. Outstanding Invoice"
{
    DataClassification = CustomerContent;
    Caption = 'Status Of Open Invoices';

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Entry No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Target Document No."; Code[20])
        {
            Caption = 'Target Document No.';
        }
        field(10; "Status Description"; Text[500])
        {
            Caption = 'Description';
        }
        field(20; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
    }
    keys
    {
        key(PK; "Invoice No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
