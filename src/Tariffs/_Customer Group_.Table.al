table 50225 "Customer Group"
{
    DataClassification = CustomerContent;
    Caption = 'Customer Group';

    fields
    {
        field(1; "Tariff No."; code[20])
        {
            TableRelation = "Tariff Header"."No.";
            Caption = 'Tariff No.';

            // AN 23112023 - TASK002140 -Tariff Price Group details are not visible on the Contract, even though it is attached in the Economic Data ++
            trigger OnValidate()
            var
                Contract_LRec: Record Contract;
                CustomerTariffPriceGrp: Record "Customer Tariff Price Group";
            begin
                Contract_LRec.Reset();
                Contract_LRec.SetRange("Customer No.", "Customer No.");
                Contract_LRec.SetRange(Status, Contract_LRec.Status::Open);
                if Contract_LRec.FindSet()then repeat CustomerTariffPriceGrp.Init();
                        CustomerTariffPriceGrp.Validate("No.", "Tariff No.");
                        CustomerTariffPriceGrp.Validate("Contract No.", Contract_LRec."No.");
                        CustomerTariffPriceGrp.Insert();
                    until Contract_LRec.next() = 0 end;
        // AN 23112023 - TASK002140 -Tariff Price Group details are not visible on the Contract, even though it is attached in the Economic Data --
        }
        field(2; "Customer No."; Code[20])
        {
            TableRelation = Customer."No.";
            Caption = 'Customer No.';
        }
    }
    keys
    {
        key(PK; "Tariff No.", "Customer No.")
        {
            Clustered = true;
        }
    }
}
