page 50256 "Price Value Lines"
{
    Caption = 'Value Lines';
    PageType = ListPart;
    SourceTable = "Price Value Line";
    AutoSplitKey = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field(Usage; Rec.Usage)
                {
                    Tooltip = 'Specifies the value of the Usage field.';
                    Caption = 'Usage';
                }
                field("Voltage Type"; Rec."Voltage Type")
                {
                    Tooltip = 'Specifies the value of the Voltage Type field.';
                    Caption = 'Voltage Type';
                }
                field(Resident; Rec.Resident)
                {
                    Tooltip = 'Specifies the value of the Resident field.';
                    Caption = 'Resident';
                }
                //KB25012024 - Billing Process Energy Price Calculation Development +++
                field("Active/Reactive Type"; Rec."Active/Reactive Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Active/Reactive Type field.';
                }
                field("Reactive Price Range Type"; Rec."Reactive Price Range Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reactive Price Range Type field.';
                }
                //KB25012024 - Billing Process Energy Price Calculation Development ---
                //KB01022024 - Billing Process Accisso Price calculation +++
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field("Monthly Consumption Range"; Rec."Monthly Consumption Range")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Monthly Consumption Range field.';
                }
                field("Domestic Monthly Consum. Range"; Rec."Domestic Monthly Consum. Range")
                {
                    ToolTip = 'Specifies the value of the Domestic Monthly Consumption Range field.', Comment = '%';
                }
                //KB01022024 - Billing Process Accisso Price calculation ---
                field("Contract Power"; Rec."Contract Power")
                {
                    ToolTip = 'Specifies the value of the Contract Power field.';
                    Caption = 'Contract Power';
                }
                field("Contract Power From"; Rec."Contract Power From")
                {
                    ToolTip = 'Specifies the value of the Contract Power From field.';
                    Caption = 'Contract Power From';
                }
                field("Contract Power To"; Rec."Contract Power To")
                {
                    ToolTip = 'Specifies the value of the Contract Power To field.';
                    Caption = 'Contract Power To';
                }
                field("Real Power "; Rec."Real Power")
                {
                    ToolTip = 'Specifies the value of the Real Power  field.';
                    Caption = 'Real Power ';
                }
                field("Real Power From"; Rec."Real Power From")
                {
                    ToolTip = 'Specifies the value of the Real Power From field.';
                    Caption = 'Real Power From';
                }
                field("Real Power To"; Rec."Real Power To")
                {
                    ToolTip = 'Specifies the value of the Real Power To field.';
                    Caption = 'Real Power To';
                }
                field("Single Step Type"; Rec."Single Step Type")
                {
                    ToolTip = 'Specifies the value of the Single Step Type field.';
                    Caption = 'Single Step Type';
                }
                field("Single Step From"; Rec."Single Step From")
                {
                    ToolTip = 'Specifies the value of the Single Step From field.';
                    Caption = 'Single Step From';
                }
                field("Single Step To"; Rec."Single Step To")
                {
                    ToolTip = 'Specifies the value of the Single Step To field.';
                    Caption = 'Single Step To';
                }
                //KB03042024 - Net Loss Update in Billing +++
                field("Net Loss %"; Rec."Net Loss %")
                {
                    ToolTip = 'Specifies the value of the Net Loss % field.';
                }
                //KB03042024 - Net Loss Update in Billing ---
                field("Fixed Price Unit of Measure"; Rec."Fixed Price Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Fixed Price Unit of Measure field.';
                    Caption = 'Fixed Price Unit of Measure';
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                    ToolTip = 'Specifies the value of the Fixed Price field.';
                    Caption = 'Fixed Price';
                }
                field("Power Price Unit of Measure"; Rec."Power Price Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Power Price Unit of Measure field.';
                    Caption = 'Power Price Unit of Measure';
                }
                field("Power Price"; Rec."Power Price")
                {
                    ToolTip = 'Specifies the value of the Power Price field.';
                    Caption = 'Power Price';
                }
                field("Energy Price Unit of Measure"; Rec."Energy Price Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Energy Price Unit of Measure field.';
                    Caption = 'Energy Price Unit of Measure';
                }
                field("Energy Price"; Rec."Energy Price")
                {
                    ToolTip = 'Specifies the value of the Energy Price field.';
                    Caption = 'Energy Price';
                }
                //KB01022024 - Billing Process Accisso Price calculation +++
                field("Accisso Price"; Rec."Accisso Price")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Accisso Price field.';
                }
                //KB01022024 - Billing Process Accisso Price calculation ---
                field("Month of the Price"; Rec."Month of the Price")
                {
                    ToolTip = 'Specifies the value of the Month of the Price field.';
                    Caption = 'Month of the Price';
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    Caption = 'Effective Date';
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                    Caption = 'Effective End Date';
                }
            }
        }
    }
}
