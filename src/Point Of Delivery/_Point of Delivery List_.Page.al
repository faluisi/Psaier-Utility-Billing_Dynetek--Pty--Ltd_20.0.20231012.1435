page 50211 "Point of Delivery List"
{
    CardPageID = "Point of Delivery Card";
    PageType = List;
    SourceTable = "Point of Delivery";
    UsageCategory = Lists;
    ApplicationArea = All;
    AdditionalSearchTerms = 'POD';
    Caption = 'Point of Delivery List';

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
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the meter Serial No. field.';
                    Caption = 'Meter Serial No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Customer No.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Caption = 'Customer Name';
                }
                field("AAT POD Status"; Rec."AAT POD Status")
                {
                    ToolTip = 'Specifies the value of the POD Status field.';
                    Caption = 'POD Status';
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action("Import Measurements")
            {
                Tooltip = 'Specifies the Action to Import Measurements';
                Caption = 'Import Measurements';
                Image = Import; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    XMLImportManager: Codeunit "XML Import Manager";
                begin
                    XMLImportManager.ImportMeasurementFileSelection(); //KB30112023 - TASK002171 Measurement Upload Process Procedure updated
                end;
            }
            action("Estimate Missing Measurements")
            {
                Caption = 'Estimate Missing Measurements';
                ToolTip = 'Executes the Estimate Missing Measurements action.';
                Image = CalculateLines; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    EstandPlausibilityMgt: Codeunit "Est. and Plausibility Mgt.";
                    SelectedPODs: Record "Point of Delivery";
                    Measurement: Record "Measurement";
                    NoMeasurementErr: Label 'There are no Measurements for POD: %1';
                begin
                    CurrPage.SetSelectionFilter(SelectedPODs);
                    if SelectedPODs.FindSet()then repeat Measurement.Reset();
                            Measurement.SetRange("POD No.", SelectedPODs."No.");
                            if not Measurement.FindFirst()then Error(NoMeasurementErr, SelectedPODs."No.");
                            EstandPlausibilityMgt.Estimate(Measurement);
                        until SelectedPODs.Next() = 0 // else // else
                //  Error('Select at least one POD to estimate Measurements.');
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Measurements', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Import Measurements_Promoted"; "Import Measurements")
                {
                }
                actionref("Estimate Missing Measurements_Promoted"; "Estimate Missing Measurements")
                {
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        UtilitySetup.GetRecordOnce();
        DevMode:=UtilitySetup."AAT Developer Mode PUB";
        CurrPage.Editable:=DevMode;
        CurrPage.Update();
    end;
    var UtilitySetup: Record "Utility Setup";
    DevMode: Boolean;
}
