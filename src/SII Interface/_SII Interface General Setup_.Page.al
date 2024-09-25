page 50248 "SII Interface General Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "SII Interface General Setup";
    Caption = 'SII Interface General Setup';
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group("Switch In")
            {
                Caption = 'Switch In';

                field("Switch In Manager VAT No."; Rec."Switch In Manager VAT No.")
                {
                    caption = 'VAT Manager No.';
                    Visible = false;
                    Tooltip = 'Specifies the value of the Switch In Manager VAT No. Code';
                }
                field("Switch In CP User"; Rec."Switch In CP User")
                {
                    Caption = 'CP User';
                    Tooltip = 'Specifies the value of the Switch In CP User Code';
                }
                field("Switch In Tariff Option"; Rec."Switch In Tariff Option")
                {
                    Caption = 'Tariff Option';
                    Tooltip = 'Specifies the value of the Switch In Tariff Option Field';
                }
                field("Switch In Code of Dispatching"; Rec."Switch In Code of Dispatching")
                {
                    Caption = 'Code of Dispatching';
                    Tooltip = 'Specifies the value of the Switch In Code of Dispatching';
                }
            }
            group("Change of Customer")
            {
                Caption = 'Change of Customer';

                field("CoC CP User"; Rec."CoC CP User")
                {
                    Tooltip = 'Specifies the value of the Change of Customer CP User field';
                    Caption = 'CP User';
                }
                field("COC Tarrif Option"; Rec."COC Tarrif Option")
                {
                    Tooltip = 'Specifies the value of the Change of Customer Tariff Option field';
                    Caption = 'Tariff Option';
                }
                field("COC VAT Manager"; Rec."COC VAT Manager")
                {
                    Tooltip = 'Specifies the value of the Change of Customer VAT Manager field';
                    Caption = 'VAT Manager';
                    Visible = false;
                }
                field("COC Code of Dispatching"; Rec."COC Code of Dispatching")
                {
                    Tooltip = 'Specifies the value of the Change of Customer Code Dispatching field';
                    Caption = 'Code of Dispatching';
                }
            }
            group("Switch Out")
            {
                Caption = 'Switch Out';

                field("Switch Out VAT Manager"; Rec."Switch Out VAT Manager")
                {
                    Tooltip = 'Specifies the value of the Switch Out VAT Manager';
                    Caption = 'VAT Manager';
                    Visible = false;
                }
                field("Switch Out CP User"; Rec."Switch Out CP User")
                {
                    Tooltip = 'Specifies the value of the Switch Out CP User';
                    Caption = 'CP User';
                }
            }
            group("Change of Anagraphic Data")
            {
                Caption = 'Change of Anagraphic Data';

                field("CoA CP User"; Rec."CoA CP User")
                {
                    Tooltip = 'Specifies the value of the Change of Anagraphic CP User field';
                    Caption = 'CP User';
                }
                field("CoA Tariff Option"; Rec."CoA Tariff Option")
                {
                    Tooltip = 'Specifies the value of the Change of Anagraphic Tariff Option field';
                    Caption = 'Tariff Option';
                }
                field("CoA VAT Manager"; Rec."CoA VAT Manager")
                {
                    Tooltip = 'Specifies the value of the Change of Anagraphic Data VAT Manager field';
                    Caption = 'VAT Manager';
                    Visible = false;
                }
            }
            group("Contract Termination")
            {
                Caption = 'Contract Termination';

                field("Contract Termination CP User"; Rec."Contract Termination CP User")
                {
                    Tooltip = 'Specifies the value of the Contract Termination CP User field';
                    Caption = 'CP User';
                }
                field("AAT CT VAT Manager SII"; Rec."AAT CT VAT Manager SII")
                {
                    ToolTip = 'Specifies the value of the CT VAT Manager field.';
                    Visible = false;
                }
            }
            //KB09112023 - TASK002126 Deactivation Process +++
            group("Deactivate")
            {
                Caption = 'Deactivate';

                field("Deactivation Manager VAT No."; Rec."Deactivation Manager VAT No.")
                {
                    Caption = 'Deactivation Manager VAT No.';
                    Visible = false;
                    ToolTip = 'Specifies the value of the Deactivation Manager VAT No. field.';
                }
                field("Deactivation CP User"; Rec."Deactivation CP User")
                {
                    Caption = 'Deactivation CP User';
                    ToolTip = 'Specifies the value of the Deactivation CP User field.';
                }
                field("Contract Disp"; Rec."Contract Disp")
                {
                    Caption = 'Contract Disp';
                    ToolTip = 'Specifies the value of the Contract Disp field.';
                }
            }
            //KB09112023 - TASK002126 Deactivation Process ---
            //KB20112023 - TASK002131 New Activation Process +++
            group("New Activation")
            {
                Caption = 'New Activation';

                field("Activation Manager VAT No."; Rec."Activation Manager VAT No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the New Activation Manager VAT No. field.';
                }
                field("Activation CP User"; Rec."Activation CP User")
                {
                    ToolTip = 'Specifies the value of the New Activation CP User field.';
                }
                field("Activation Contract Disp"; Rec."Activation Contract Disp")
                {
                    ToolTip = 'Specifies the value of the New Activation Contract Disp field.';
                }
            }
            //KB20112023 - TASK002131 New Activation Process ---
            //KB24112023 - TASK002167 Reactivation Process +++
            group("Reactivation")
            {
                Caption = 'Reactivation';

                field("Reactivation Manager VAT No."; Rec."Reactivation Manager VAT No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Reactivation Manager VAT No. field.';
                }
                field("Reactivation CP User"; Rec."Reactivation CP User")
                {
                    ToolTip = 'Specifies the value of the Reactivation CP User field.';
                }
                field("Reactivation Contract Disp"; Rec."Reactivation Contract Disp")
                {
                    ToolTip = 'Specifies the value of the Reactivation Contract Disp field.';
                }
            }
        //KB24112023 - TASK002167 Reactivation Process ---
        }
    }
    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
