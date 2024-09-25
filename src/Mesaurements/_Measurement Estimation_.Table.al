table 50224 "Measurement Estimation"
{
    Caption = 'Measurement Estimation';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; Entry; Integer)
        {
            Caption = 'Entry';
        }
        field(2; Month; Integer)
        {
            Caption = 'Month';
        }
        field(3; Year; Integer)
        {
            Caption = 'Year';
        }
        field(4; Consumptions; Decimal)
        {
            Caption = 'Consumptions';
        }
    }
    keys
    {
        key(PK; Entry)
        {
            Clustered = true;
        }
    }
}
