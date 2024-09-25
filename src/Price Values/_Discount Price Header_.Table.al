table 50239 "Discount Price Header"
{
    //KB03042024 - Discount Calculation +++
    Caption = 'Discount Price Header';
    DataClassification = ToBeClassified;
    LookupPageId = "Discount List";

    fields
    {
        field(1; ID; Code[20])
        {
            Caption = 'ID';
        }
        field(2; "Annual Consumption From"; Decimal)
        {
            Caption = 'Annual Consumption From';
        }
        field(3; "Annual Consumption To"; Decimal)
        {
            Caption = 'Annual Consumption To';
        }
        field(4; "Desciprtion"; Text[100])
        {
            Caption = 'Desciprtion';
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
//KB03042024 - Discount Calculation ---
}
