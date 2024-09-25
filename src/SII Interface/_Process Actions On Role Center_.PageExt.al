pageextension 50240 "Process Actions On Role Center" extends "Business Manager Role Center"
{
    actions
    {
        addafter("Purchase Invoice")
        {
            action("Activation")
            {
                ToolTip = 'Specifies the value of the Activiation Action';
                Caption = 'New Activation';
                ApplicationArea = All;
                RunObject = page "Activation Process";
                Image = New;
            }
            action("Switch In")
            {
                ToolTip = 'Specifies the value of the Switch Action';
                Caption = 'New Switch In';
                ApplicationArea = All;
                RunObject = page "Switch In Process";
                Image = New;
            }
            action("Switch Out")
            {
                ToolTip = 'Specifies the value of the Switch Out Action';
                Caption = 'New Switch Out';
                ApplicationArea = All;
                RunObject = page "Switch Out Process";
                Image = New;
            }
            action("Change of Customer")
            {
                ToolTip = 'Specifies the value of the Change of the Customer Action';
                Caption = 'New Change of Customer Request';
                ApplicationArea = All;
                RunObject = page "Change of Customer Process";
                Image = New;
            }
            action("Contract Termination")
            {
                ToolTip = 'Specifies the value of the Contract Termination Action';
                Caption = 'New Contract Termination';
                ApplicationArea = All;
                RunObject = page "Contract Termination";
                Image = Cancel;
            }
            //KB08112023 - TASK002126 Deactivation Process +++
            action("Deactivation")
            {
                ToolTip = 'Specifies the value of the Deactivation Action';
                Caption = 'New Deactivation';
                ApplicationArea = All;
                RunObject = page "Deactivation Process";
                Image = Close;
            }
            //KB08112023 - TASK002126 Deactivation Process ---
            //KB24112023 - TASK002167 Reactivation Process +++
            action("Reactivation")
            {
                ToolTip = 'Specifies the value of the Reactiviation Action';
                Caption = 'Reactivation';
                ApplicationArea = All;
                RunObject = page "Reactivation Process";
                Image = New;
            }
        //KB24112023 - TASK002167 Reactivation Process ---
        }
    }
}
