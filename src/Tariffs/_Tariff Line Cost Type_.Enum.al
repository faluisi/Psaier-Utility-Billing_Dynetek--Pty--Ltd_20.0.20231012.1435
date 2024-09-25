enum 50258 "Tariff Line Cost Type"
{
    //KB15022024 - TASK002433 New Billing Calculation +++
    Extensible = true;

    value(0; "Energy Sale Cost")
    {
    Caption = 'Energy Sale Cost';
    }
    value(1; "Transport Cost")
    {
    Caption = 'Transport Cost';
    }
    value(2; "System Cost")
    {
    Caption = 'System Cost';
    }
    value(3; "Energy Reactive Cost")
    {
    Caption = 'Energy Reactive Cost';
    }
    value(4; "Acciso Cost")
    {
    Caption = 'Acciso Cost';
    }
    value(5; Discount)
    {
    Caption = 'Discount';
    }
//KB15022024 - TASK002433 New Billing Calculation ---
}
