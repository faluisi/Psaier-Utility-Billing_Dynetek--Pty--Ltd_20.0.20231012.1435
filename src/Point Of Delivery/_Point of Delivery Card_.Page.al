page 50210 "Point of Delivery Card"
{
    Caption = 'Point of Delivery';
    PageType = Card;
    InsertAllowed = true;
    SourceTable = "Point of Delivery";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Editable = false;
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field("POD Cost"; Rec."POD Cost")
                {
                    ToolTip = 'Specifies the value of the POD Cost field.';
                    ApplicationArea = All;
                    Caption = 'POD Cost';
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the meter Serial No. field. Assign through "Assign Meter to POD" action';
                    Caption = 'Meter Serial No.';
                    Editable = false;
                    ShowMandatory = true;
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        MeterAssignment: Codeunit "Meter Assignment";
                    begin
                        MeterAssignment.OpenPage(Rec);
                    end;
                }
                field("AAT POD Status"; Rec."AAT POD Status")
                {
                    ApplicationArea = All;
                    Caption = 'POD Status';
                    ToolTip = 'Specifies the value of the POD Status field.';
                    Editable = DevMode;
                }
                group("Consumption")
                {
                    Caption = 'Consumption';

                    field("Consumption Constant"; Rec."Consumption Constant")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Consumption Constant field.';
                        ShowMandatory = true;
                        Caption = 'Consumption Constant';
                    }
                }
                group("Physical Address")
                {
                    Caption = 'Physical Address';

                    field("Address Langauge Code"; Rec."Address Langauge Code")
                    {
                        ToolTip = 'Specifies the value of the Address Language Code field.';
                        AssistEdit = true;
                        ApplicationArea = All;
                        Caption = 'Address Language Code';

                        trigger OnAssistEdit()
                        var
                            SecondaryAddressPage: Page "Address Secondary Language";
                        //ModifySecondaryLanguage: Codeunit "Modify Secondary Language";
                        begin
                            //ModifySecondaryLanguage.OpenPageFromPODPage(Rec);
                            SecondaryAddressPage.OpenPageFromPODPage(Rec);
                            Rec.UpdateInvoiceAddress();
                        end;
                    }
                    field("AAT CIV PUB"; Rec."AAT CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIV field.';
                    }
                    field(Toponym; Rec.Toponym)
                    {
                        ToolTip = 'Specifies the value of the Toponym field.';
                        ApplicationArea = All;
                        Caption = 'Toponym';
                    }
                    field(Address; Rec.Address)
                    {
                        ToolTip = 'Specifies the value of the Address field.';
                        ApplicationArea = All;
                        Caption = 'Address';
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ToolTip = 'Specifies the value of the Address 2 field.';
                        ApplicationArea = All;
                        Caption = 'Address 2';
                    }
                    field(City; Rec.City)
                    {
                        ToolTip = 'Specifies the value of the City field.';
                        ApplicationArea = All;
                        Caption = 'City';
                    }
                    field("Post Code"; Rec."Post Code")
                    {
                        ToolTip = 'Specifies the value of the Post Code field.';
                        ApplicationArea = All;
                        Caption = 'Post Code';
                    }
                    field("County Code"; Rec."County Code")
                    {
                        ToolTip = 'Specifies the value of the County Code field.';
                        ApplicationArea = All;
                        Caption = 'County Code';
                    }
                    field(County; Rec.County)
                    {
                        ToolTip = 'Specifies the value of the County field.';
                        ApplicationArea = All;
                        visible = false;
                        Caption = 'County';
                    }
                    field("Country/Region Code"; Rec."Country/Region Code")
                    {
                        Caption = 'Country';
                        ToolTip = 'Specifies the value of the Country/Region Code field.';
                        ApplicationArea = All;
                    }
                    //KB20112023 - TASK002131 New Activation Process +++
                    field("ISTAT Code"; Rec."ISTAT Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the ISTAT Code field.';
                    }
                //KB20112023 - TASK002131 New Activation Process ---
                }
            }
            group("POD Meter History")
            {
                Caption = 'POD Meter History';

                part(Meter; "POD Meter History List Part")
                {
                    Editable = true;
                    Caption = 'Meter';
                    SubPageLink = "POD No."=field("No.");
                    ApplicationArea = Basic, Suite;
                }
            }
            group("POD Economic Conditions")
            {
                Caption = 'POD Economic Conditions';

                part("Economic Conditions"; "POD Eco Condition List Part")
                {
                    Editable = DevMode;
                    Caption = 'Economic Conditions';
                    SubPageLink = "POD No."=field("No.");
                    SubPageView = sorting("No.")order(descending);
                    ApplicationArea = All;
                }
            }
            group("Measurement List")
            {
                Caption = 'Measurement List';

                part(Measurements; "Measurement List Part")
                {
                    Editable = DevMode;
                    Caption = 'Measurements';
                    SubPageLink = "POD No."=field("No."), "Import Error"=const(false);
                    SubPageView = sorting(Month)order(descending);
                    ApplicationArea = All;
                }
            }
            group("Measurement Active List")
            {
                Caption = 'Measurement Active List';

                part(Active; "Measurement Active List Part")
                {
                    Editable = DevMode;
                    Caption = 'Active';
                    SubPageLink = "POD No."=field("No.");
                    ApplicationArea = All;
                }
            }
            group("Measurement Reactive List")
            {
                Caption = 'Measurement Reactive List';

                part(Reactive; "Measurement Reactive List Part")
                {
                    Editable = DevMode;
                    Caption = 'Reactive';
                    SubPageLink = "POD No."=field("No.");
                    ApplicationArea = All;
                }
            }
            group("Measurement Peak List")
            {
                Caption = 'Measurement Peak List';

                part(Peak; "Measurement Peak List Part")
                {
                    Editable = DevMode;
                    Caption = 'Peak';
                    SubPageLink = "POD No."=field("No.");
                    ApplicationArea = All;
                }
            }
            group("Contract History")
            {
                Caption = 'Contract History';

                part(Contract; "POD Contract Hist List Part")
                {
                    Editable = DevMode;
                    Caption = 'Contract';
                    SubPageLink = "POD No."=field("No.") /*, "No." = filter(TempContract)*/;
                    ApplicationArea = All;
                }
            }
            group("Customer History")
            {
                Caption = 'Customer History';

                part(Customer; "POD Customer History List Part")
                {
                    Editable = DevMode;
                    Caption = 'Customer';
                    ApplicationArea = All;
                    SubPageLink = "POD No."=field("No.");
                }
            }
            // AN 30112023 TASK002178 Added group for Television fees History ++ 
            group("Television Fees List")
            {
                Caption = 'Television Fees List';

                part("AAT TV Fee SII List Part"; "AAT TV Fee SII List Part")
                {
                    Editable = false;
                    Caption = 'Television Fees';
                    SubPageLink = "AAT POD No. SII"=field("No."), "AAT Fee Type SII"=filter("TV Fee");
                    ApplicationArea = all;
                }
            }
        // AN 30112023 TASK002178 Added group for Television fees History  -- 
        }
    }
    actions
    {
        area(creation)
        {
            // action("Generate Invoice")
            // {
            //     ToolTip = 'Create a Invoice for the current month.';
            //     ApplicationArea = All;
            //     PromotedCategory = Category4;
            //     Promoted = true;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     trigger OnAction()
            //     var
            //         InvoiceMgt: Codeunit "Invoice Generation Management";
            //     begin
            //         // InvoiceMgt.GenerateInvoice(Rec);
            //     end;
            // }
            action("Assign Meter to POD")
            {
                ToolTip = 'Specifies the Assign Meter to POD Action.';
                ApplicationArea = All;
                Caption = 'Assign Meter to POD';
                Image = Allocate; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    //AssignMeterPage: Page "Meter Assigment Card Page";
                    MeterAssignment: Codeunit "Meter Assignment";
                begin
                    MeterAssignment.OpenPage(Rec);
                end;
            }
            // action("Deactivate Active Meter")
            // {
            //     ToolTip = 'Specifies the value of the Deactivate Active Meter Action.';
            //     ApplicationArea = All;
            //     Caption = 'Deactivate Active Meter';
            //     trigger OnAction()
            //     var
            //         "AssignedMeter": Record "Point of Delivery - Meter Hist";
            //     begin
            //         if Confirm(StrSubstNo(DeactivationConfirmationLbl, Rec."Meter Serial No.")) then begin
            //             "AssignedMeter".SetRange("POD No.", Rec."No.");
            //             "AssignedMeter".SetRange("Meter Serial No.", Rec."Meter Serial No.");
            //             "AssignedMeter".SetFilter("Deactivation Date", '');
            //             if not ("AssignedMeter".IsEmpty) and AssignedMeter.FindFirst() then
            //                 AssignedMeter."Deactivation Date" := System.Today;
            //         end;
            //     end;
            // }
            action("Open Measurements")
            {
                Tooltip = 'Opens the Measurements Page.';
                ApplicationArea = All;
                Caption = 'Open Measurements';
                Image = View; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    Measurement: Record "Measurement";
                    MeasurementPage: Page "Measurement Card";
                    MesearementNotFoundLbl: Label 'Measurements not found for %1', Locked = true;
                begin
                    Measurement.SetRange("POD No.", Rec."No.");
                    //Measurement.SetRange("Latest Measurement", True);
                    if Measurement.FindFirst()then begin
                        MeasurementPage.SetRecord(Measurement);
                        MeasurementPage.Run();
                    end
                    else
                        Message(StrSubstNo(MesearementNotFoundLbl, Rec."No."));
                end;
            }
            action("Import Measurements")
            {
                Tooltip = 'Action for Importing Measurments';
                Caption = 'Import Measurements';
                ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Estimate Missing Measurements';
                ToolTip = 'Executes the Estimate Missing Measurements action.';
                Image = CalculateLines; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    Measurement: Record "Measurement";
                    EstandPlausibilityMgt: Codeunit "Est. and Plausibility Mgt.";
                    NoMeasurementErr: Label 'No Measurements found for current POD.';
                begin
                    Measurement.SetFilter("POD No.", Rec."No.");
                    if Measurement.FindFirst()then EstandPlausibilityMgt.Estimate(Measurement)
                    else
                        Error(NoMeasurementErr);
                end;
            }
            // AN 09110223 - TASK002127 Remove Export Anagraphic Data from Meter Management Actions ++ 
            action("Export Anagraphic Data")
            {
                ToolTip = 'Export AE1.0050';
                Caption = '';
                ApplicationArea = All;
                Image = Export;
                Visible = false;

                // ObsoleteState =Pending;
                // ObsoleteReason ='Remove Export Anagraphic Data from Meter Management Actions.';
                trigger OnAction()
                var
                    // Customer: Record Customer;
                    Contract: Record Contract;
                    ChangeOfAnagraphicDataMgt: Codeunit "Change of Anagraphic Data Mgt.";
                    FileName: Text;
                begin
                    FileName:='';
                    Contract.SetRange("POD No.", Rec."No.");
                    if Contract.FindFirst()then ChangeOfAnagraphicDataMgt.NewChangeOfAnagraphicData(Contract, FileName);
                end;
            }
            // AN 09110223 - TASK002127 Remove Export Anagraphic Data from Meter Management Actions -- 
            //KB09112023 - TASK002126 Deactivation Process +++
            action("Import Deactivation")
            {
                Caption = 'Import Deactivation';
                ApplicationArea = All;
                Image = Import;
                ToolTip = 'Import D01.E0150';

                trigger OnAction()
                var
                    ImportFileSelectDeactivation: Codeunit ImportFileSelectDeactivation;
                begin
                    ImportFileSelectDeactivation.UploadFile();
                end;
            }
        //KB09112023 - TASK002126 Deactivation Process ---
        }
        area(Promoted)
        {
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
            group(Category_Category4)
            {
                Caption = 'Meter Management', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Assign Meter to POD_Promoted"; "Assign Meter to POD")
                {
                }
                actionref("Estimate Missing Measurements_Promoted"; "Estimate Missing Measurements")
                {
                }
                actionref("Export Anagraphic Data_Promoted"; "Export Anagraphic Data")
                {
                }
                //KB09112023 - TASK002126 Deactivation Process +++
                actionref("ImportMeterUnistallation"; "Import Deactivation")
                {
                }
            //KB09112023 - TASK002126 Deactivation Process ---
            }
            group(Category_Category5)
            {
                Caption = ' Measurements', Comment = 'Generated from the PromotedActionCategories property index 4.';

                actionref("Open Measurements_Promoted"; "Open Measurements")
                {
                }
                actionref("Import Measurements_Promoted"; "Import Measurements")
                {
                }
            }
        }
    /*area(Creation)
        {

            action("Open Measurements")
            {
                ApplicationArea = All;
                PromotedCategory = Category12;
                Promoted = True;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    Measurement: Record "Measurement";
                    MeasurementPage: Page Measurement;
                begin
                    Measurement.SetRange("POD No.", Rec."No.");
                    Measurement.SetRange("Latest Measurement", True);

                    If Not Measurement.ISEmpty() and Measurement.FindFirst() then begin
                        MeasurementPage.SetRecord(Measurement);
                        MeasurementPage.Run();
                    end;
                end;
            }
            action("Import Measurements")
            {

                ApplicationArea = All;
                PromotedCategory = Category12;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    XMLImportManager: Codeunit "XML Import Manager";
                begin
                    XMLImportManager.ImportXML();
                end;
            }
        }*/
    }
    /*
    // Return to later
    // trigger OnAfterGetCurrRecord()
    // var
    //     PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
    //     Contract2: Record Contract;
    //     TempContract2: Record Contract temporary;
    // begin
    //     ContractViewFilter := '';
    //     PointofDeliveryCustHist.SetRange("POD No.", Rec."No.");
    //     if PointofDeliveryCustHist.FindSet() then
    //         repeat
    //             ContractViewFilter += PointofDeliveryCustHist."AAT Contract No" + '|';
    //         until PointofDeliveryCustHist.Next() = 0;

    //     ContractViewFilter := CopyStr(ContractViewFilter, 1, StrLen(ContractViewFilter) - 1);

    //     Contract2.SetFilter("No.", '%1', ContractViewFilter);
    //     Contract2.SetCurrentKey("No.");
    //     if Contract2.FindSet() then
    //         TempContract2.Copy(TempContract);
    //     repeat
    //         TempContract := Contract2;
    //         // TempContract.TransferFields(Contract3);
    //         TempContract2.SetFilter("No.", Contract2."No.");
    //         if not TempContract.FindFirst() then
    //             TempContract.Insert();
    //     until Contract2.Next() = 0;
    // end;
    

    var
        TempContract: Record Contract temporary;
        DeactivationConfirmationLbl: Label 'Are you sure you want to Deactivate the Meter with Serial No. = %1 for this POD ? ', Locked = true;
        ContractViewFilter: Text;
        */
    trigger OnOpenPage();
    begin
        UtilitySetup.GetRecordOnce();
        DevMode:=UtilitySetup."AAT Developer Mode PUB";
        CurrPage.Update();
    end;
    var UtilitySetup: Record "Utility Setup";
    DevMode: Boolean;
}
