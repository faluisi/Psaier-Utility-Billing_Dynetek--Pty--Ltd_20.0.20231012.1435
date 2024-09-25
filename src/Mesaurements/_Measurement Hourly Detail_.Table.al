table 50222 "Measurement Hourly Detail"
{
    Caption = 'Measurement Hourly Detail';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Measurement Entry No."; Integer)
        {
            Caption = 'Measurement Entry No.';
            TableRelation = Measurement."Entry No.";
        }
        field(3; Day; Integer)
        {
            Caption = 'Day';
        }
        field(4; Measurement; Decimal)
        {
            Caption = 'Measurement';
        }
        field(5; Type; Text[25])
        {
            Caption = 'Type';
        }
        field(6; "Measurement Interval"; Code[10])
        {
            Caption = 'Measurement Interval';
        }
        //KB30112023 - TASK002171 Measurement Upload Process +++
        field(7; "Fascia Type";Enum "Fascia Type")
        {
            Caption = 'Fascia Type';
        }
        field(8; "Measurement Date"; Date)
        {
            Caption = 'Measurement Date';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(SK; "Measurement Entry No.")
        {
        }
    }
}
