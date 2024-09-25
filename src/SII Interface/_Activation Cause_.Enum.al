enum 50229 "Activation Cause"
{
    Extensible = true;

    value(0; " ")
    {
    Caption = ' ';
    }
    value(1; Switch)
    {
    Caption = 'Switch'; // Switch in and out
    }
    value(2; Transfer)
    {
    Caption = 'Transfer'; // Change of customer
    }
    value(3; Activation)
    {
    Caption = 'Activation';
    }
    value(4; "Take Over")
    {
    Caption = 'Take Over';
    }
}
