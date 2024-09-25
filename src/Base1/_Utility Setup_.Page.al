page 50249 "Utility Setup"
{
    Caption = 'Utility Setup';
    PageType = Card;
    SourceTable = "Utility Setup";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Contract No. Series"; Rec."Contract No. Series")
                {
                    ToolTip = 'Specifies the value of the Contract No. Series field.';
                    Caption = 'Contract No. Series';
                }
                field("Plausibility Percentage"; Rec."Plausibility Percentage")
                {
                    ToolTip = 'Specifies the value of the Plausibility Percentage field.';
                    Caption = 'Plausibility Percentage';
                }
                field("Power Limit"; Rec."Power Limit")
                {
                    Tooltip = 'If Measuremessnt below this amount, Contractual Power will be used for Invoice Calculations.';
                    Caption = 'Power Limit';
                }
                field("AAT Developer Mode PUB"; Rec."AAT Developer Mode PUB")
                {
                    ToolTip = 'Specifies the value of the Developer Mode field.';
                }
                // AN 01122023 TASK002178  Added field for Mapping Resocure for television fees ++
                field("Television Fees Code"; Rec."Television Fees Code")
                {
                    ToolTip = 'Specifies the value of the Television Fees field.';
                }
                field("TV Dyn. Inv. Template No."; Rec."TV Dyn. Inv. Template No.")
                {
                    ToolTip = 'Specifies the value of the Television Fees Dyn. Inv. Template No. field.', Comment = '%';
                }
                field("Social Bonus Code"; Rec."Social Bonus Code")
                {
                    ToolTip = 'Specifies the value of the Social Bonus field.';
                }
                field("SB Dyn. Inv. Template No."; Rec."SB Dyn. Inv. Template No.")
                {
                    ToolTip = 'Specifies the value of the Social Bonus Dyn. Inv. Template No. field.', Comment = '%';
                }
                field("Peak Calc Threshold"; Rec."Peak Calc Threshold")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Peak Calculation Threshold field.';
                }
                field("Reactive Calc Threshold"; Rec."Reactive Calc Threshold")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reactive Calculation Threshold field.';
                }
                field("Default VAT Manager No."; Rec."Default VAT Manager No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Default VAT Manager No. field.';
                }
            // AN 01122023 TASK002178  Added field for Mapping Resocure for television fees ++
            }
            group("Report Selection")
            {
                Caption = 'Report Selection';

                group("Physical Contract Layouts")
                {
                    Caption = 'Physical Contract Layouts';

                    group("German Layouts")
                    {
                        Caption = 'German Layouts';

                        field("Report Code - G Household"; Rec."Report Code - G Household")
                        {
                            ToolTip = 'Specifies the value of the Report Code for Deutsch';
                            Caption = 'Household Report Code';
                        }
                        field("Report Name - G Household"; Rec."Report Name - G Household")
                        {
                            ToolTip = 'Specifies the value of the Household Report Name for Deutsch';
                            Caption = 'Household Report Name';
                        }
                        field("Report Code - G Farmer"; Rec."Report Code - G Farmer")
                        {
                            ToolTip = 'Specifies the value of the Farmer Report Code for Deutsch';
                            Caption = 'Farmer Report Code';
                        }
                        field("Report Name - G Farmer"; Rec."Report Name - G Farmer")
                        {
                            ToolTip = 'Specifies the value of the Farmer Report Name for Deutsch';
                            Caption = 'Farmer Report Name';
                        }
                        field("Report Code - G Resident"; Rec."Report Code - G Resident")
                        {
                            ToolTip = 'Specifies the value of the Resident Report Code for Deutsch';
                            Caption = 'Resident Report Code';
                        }
                        field("Report Name - G Resident"; Rec."Report Name - G Resident")
                        {
                            ToolTip = 'Specifies the value of the Resident Report Name for Deutsch';
                            Caption = 'Resident Report Name';
                        }
                    }
                    group("Italian Layouts")
                    {
                        Caption = 'Italian Layouts';

                        field("Report Code - I Household"; Rec."Report Code - I Household")
                        {
                            ToolTip = 'Specifies the value of the Household Report Code for Italian';
                            Caption = 'Household Report Code';
                        }
                        field("Report Name - I Household"; Rec."Report Name - I Household")
                        {
                            ToolTip = 'Specifies the value of the Household Report name for Italian';
                            Caption = 'Household Report Name';
                        }
                        field("Report Code - I Farmer"; Rec."Report Code - I Farmer")
                        {
                            ToolTip = 'Specifies the value of the Farmer Report Code for Italian';
                            Caption = 'Farmer Report Code';
                        }
                        field("Report Name - I Farmer"; Rec."Report Name - I Farmer")
                        {
                            ToolTip = 'Specifies the value of the Farmer Report name for Italian';
                            Caption = 'Farmer Report Name';
                        }
                        field("Report Code - I Resident"; Rec."Report Code - I Resident")
                        {
                            ToolTip = 'Specifies the value of the Resident Report Code for Italian';
                            Caption = 'Resident Report Code';
                        }
                        field("Report Name - I Resident"; Rec."Report Name - I Resident")
                        {
                            ToolTip = 'Specifies the value of the Resident Report name for Italian';
                            Caption = 'Resident Report Name';
                        }
                    }
                }
            }
            group("Dynamic Invoice Generation")
            {
                Caption = 'Dynamic Invoice Generation';

                field("Allow Direct Template Caption Creation"; Rec."Allow Templ. Caption Creation")
                {
                    Caption = 'Dynamic Invoice, Allow Direct Template Caption Creation';
                    ToolTip = 'Specifies the value of the Dynamic Invoice, Allow Direct Template Caption Creation field.';
                }
                field("All Invoices Paid Caption"; Rec."All Invoices Paid Caption")
                {
                    Caption = 'All Invoices Paid Caption';
                    ToolTip = 'Specifies the Caption that will be displayed on the Invoice if there are no unpaid invoices for the customer.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}
