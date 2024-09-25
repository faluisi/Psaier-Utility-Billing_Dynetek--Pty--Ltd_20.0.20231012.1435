enum 50201 "Process Type"
{
    Extensible = true;

    value(0; "Switch In")
    {
    Caption = 'Switch In';
    }
    value(5; "Change of Customer")
    {
    Caption = 'Change of Customer';
    }
    value(10; "Switch Out")
    {
    Caption = 'Switch Out';
    }
    value(15; "Contract Termination")
    {
    Caption = 'Contract Termination';
    }
    value(20; "Change of Personal Data")
    {
    Caption = 'Change of Personal Data';
    }
    //KB09112023 - TASK002126 Deactivation Process +++
    value(70000; "Deactivate")
    {
    Caption = 'Deactivate';
    }
    //KB09112023 - TASK002126 Deactivation Process ---
    //KB20112023 - TASK002131 New Activation Process +++
    value(70100; "New Activation")
    {
    Caption = 'New Activation';
    }
    //KB20112023 - TASK002131 New Activation Process --
    //KB24112023 - TASK002167 Reactivation Process +++
    value(70101; "Reactivation")
    {
    Caption = 'Reactivation';
    }
//KB24112023 - TASK002167 Reactivation Process ---
}
