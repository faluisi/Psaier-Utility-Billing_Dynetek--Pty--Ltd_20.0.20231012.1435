table 50242 "Discount Selection"
{
    Caption = 'Discount Selection';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract;
        }
        field(2; "Discount ID"; Code[20])
        {
            Caption = 'Discount ID';
            TableRelation = "Discount Price Header";
        }
        field(3; "Annual Consumption From"; Decimal)
        {
            Caption = 'Annual Consumption From';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Discount Price Header"."Annual Consumption From" where(ID=field("Discount ID")));
        }
        field(4; "Annual Consumption To"; Decimal)
        {
            Caption = 'Annual Consumption To';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Discount Price Header"."Annual Consumption To" where(ID=field("Discount ID")));
        }
    }
    keys
    {
        key(PK; "Contract No.", "Discount ID")
        {
            Clustered = true;
        }
    }
}
