page 50261 "Economic Conditions List"
{
    PageType = List;
    SourceTable = "Economic Condition";
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'Economic Conditions List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Invoice Layout"; Rec."Invoice Layout")
                {
                    ToolTip = 'Specifies the value of the Invoice Layout field.';
                    Caption = 'Invoice Layout';
                }
                field("Contractual Power"; Rec."Contractual Power")
                {
                    ToolTip = 'Specifies the value of the Contractual Power field.';
                    Caption = 'Contractual Power';
                }
                field("Available Power"; Rec."Available Power")
                {
                    ToolTip = 'Specifies the value of the Available Power field.';
                    Caption = 'Available Power';
                }
                field("Billing Interval"; Rec."Billing Interval")
                {
                    ToolTip = 'Specifies the value of the Billing Power field.';
                    Caption = 'Billing Interval';
                }
                field("Voltage Type"; Rec."Voltage Type")
                {
                    ToolTip = 'Specifies the value of the Voltage Type field.';
                    Caption = 'Voltage Type';
                }
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                    Caption = 'Voltage';
                }
                field("System Type"; Rec."System Type")
                {
                    ToolTip = 'Specifies the value of the System Type field.';
                    Caption = 'System Type';
                }
                field("Reduced VAT"; Rec."Reduced VAT")
                {
                    ToolTip = 'Specifies the value of the Reduced VAT field.';
                    Caption = 'Reduced VAT';
                }
                field("Tariff Option No."; Rec."Tariff Option No.")
                {
                    ToolTip = 'Specifies the value of the Tariff Option No. field.';
                    Caption = 'Tariff Option No.';
                }
                field("Tariff Option Name"; Rec."Tariff Option Name")
                {
                    ToolTip = 'Specifies the value of the tariff Option Name field.';
                    Caption = 'Tariff Option Name';
                }
                field("Annual Consumption"; Rec."Annual Consumption")
                {
                    ToolTip = 'Specifies the value of the Annual Consumption field.';
                    Caption = 'Annual Consumption';
                }
                field("AUC Exempt"; Rec."AUC Exempt")
                {
                    ToolTip = 'Specifies the value of the AUC Exempt field.';
                    Caption = 'AUC Exempt';
                }
                field("Excise Duties not Due"; Rec."Excise Duties not Due")
                {
                    ToolTip = 'Specifies the value of the Excise Duties Not Due field.';
                    Caption = 'Excise Duties not Due';
                }
                field("Limiter Present"; Rec."Limiter Present")
                {
                    ToolTip = 'Specifies the value of the Limiter Present field.';
                    Caption = 'Limiter Present';
                }
                field(Resident; Rec.Resident)
                {
                    ToolTip = 'Specifies the value of the Resident field.';
                    Caption = 'Resident';
                }
                field(Farmer; Rec.Farmer)
                {
                    Caption = 'Farmer';
                    ToolTip = 'Specifies the value of the Farmer field.';
                }
                field("Seller Name"; Rec."Seller Name")
                {
                    Caption = 'Seller Name';
                    ToolTip = 'Specifies the value of the Seller Name field.';
                }
                field(Typology; Rec.Typology)
                {
                    Caption = 'Typology';
                    ToolTip = 'Specifies the value of the Typology field.';
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ToolTip = 'Specifies the value of the Security Deposit field.';
                    Caption = 'Security Deposit';
                }
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ToolTip = 'Specifies the value of the Security Deposit Amount field.';
                    Caption = 'Security Deposit Amount';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Economic Conditions Details")
            {
                ToolTip = 'Specifies the value of the Economic Conditions Details Action.';
                Image = ViewDetails;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Economic Conditions Details';

                trigger OnAction()
                begin
                    EconomicConditionCard.SetRecord(Rec);
                    EconomicConditionCard.RunModal();
                end;
            }
        }
    }
    var EconomicConditionCard: Page "Economic Condition Card";
}
