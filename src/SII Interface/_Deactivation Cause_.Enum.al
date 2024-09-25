enum 50227 "Deactivation Cause"
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
    Caption = 'Transfer'; //change of customer
    }
    value(3; Deactivation)
    {
    Caption = 'Deactivation';
    }
    value(4; "Take Over")
    {
    Caption = 'Take Over';
    }
    value(5; "Termination")
    {
    Caption = 'Termination';
    }
}
