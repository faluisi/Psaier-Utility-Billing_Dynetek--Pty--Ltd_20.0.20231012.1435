page 50202 "Contract List"
{
    AdditionalSearchTerms = 'Contract,Con,Sevice Contract';
    ApplicationArea = All;
    CardPageID = "Contract Card";
    PageType = List;
    Editable = false;
    SourceTable = Contract;
    UsageCategory = Lists;
    RefreshOnActivate = true;
    Caption = 'Contracts';

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
                field("POD No."; Rec."POD No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the POD No. field.';
                }
                field(Period; Rec.Period)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Period field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Customer No.';
                }
                field("Contract Description"; Rec."Contract Description")
                {
                    ToolTip = 'Specifies the value of the Contract Description field.';
                    Caption = 'Contract Description';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ToolTip = 'Specifies the value of the Contract Start Date field.';
                    Caption = 'Contract Start Date';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ToolTip = 'Specifies the value of the Contract End Date field.';
                    Caption = 'Contract End Date';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status  field.';
                    Caption = 'Status';
                }
                field("Signature Date of Contract"; Rec."Signature Date of Contract")
                {
                    ToolTip = 'Specifies the value of the Signature Date of Contract field.';
                    Caption = 'Signature Date of Contract';
                }
                // AN 21112023 - TASK002127 field Added  ++
                field("Switch Out Date"; Rec."Switch Out Date")
                {
                    ToolTip = 'Specifies the value of the Switch Out Date field.';
                    Caption = 'Switch Out Date';
                }
            // AN 21112023 - TASK002127 field Added  --
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action("Generate New Contract")
            {
                ApplicationArea = All;
                Caption = 'Generate New Contract';
                ToolTip = 'Generate a new contract for activation';
                Image = New;

                trigger OnAction()
                var
                    Contract: Record Contract;
                    PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
                    UtilitySetup: Record "Utility Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                begin
                    UtilitySetup.Get();
                    Contract.Init();
                    Contract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, false);
                    Contract.Insert(true);
                    Contract.Validate("Activation Cause", Contract."Activation Cause"::Activation);
                    Contract.Validate(Status, Contract.Status::"In Registration");
                    Contract.Modify(true);
                    //Commit before run modal
                    Commit();
                    if Page.RunModal(Page::"Contract Card", Contract) = Action::LookupOK then begin
                        Contract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, true);
                        Contract.Modify();
                    end
                    else
                    begin
                        PointofDeliveryCustHist.SetRange("AAT Contract No", Contract."No.");
                        if PointofDeliveryCustHist.FindLast()then PointofDeliveryCustHist.Delete(true);
                        Contract.Delete();
                    end;
                end;
            }
        }
        area(Navigation)
        {
            action(DisplayCustomer)
            {
                ApplicationArea = All;
                Caption = 'Display Customer Details';
                ToolTip = 'Display the customer card of customer on contract';
                Image = Navigate;

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerErrorLbl: Label 'Customer not in system';
                begin
                    if not Customer.Get(Rec."Customer No.")then Error(CustomerErrorLbl);
                    Page.Run(Page::"Customer Card", Customer);
                end;
            }
        }
        area(processing)
        {
            action("Close Contract")
            {
                ApplicationArea = All;
                Caption = 'Close Contract';
                ToolTip = 'Closes the contract';
                Visible = DeveloperMode;
                Image = Close;

                trigger OnAction()
                begin
                    Rec.Validate(Status, "Contract Status"::Closed);
                    Rec.Modify();
                end;
            }
            action("Generate Invoice")
            {
                Image = Invoice;
                Caption = 'Generate Invoice';
                ToolTip = 'Executes the Generate Invoice action.';

                trigger OnAction()
                var
                    InvoiceGenerationManagement: Codeunit "Invoice Generation Management";
                begin
                    InvoiceGenerationManagement.SelectContractsForInvoicingNew('');
                end;
            }
            action("Switch In")
            {
                ApplicationArea = All;
                Caption = '&Generate Switch In Contract';
                Image = NewDocument;
                InFooterBar = true;
                ToolTip = 'Executes the &Generate Contract action.';

                trigger OnAction()
                var
                    Contract: Record Contract;
                    PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
                    UtilitySetup: Record "Utility Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                    SwitchInContractLbl: Label 'Please print and sign the physical contract %1.\\ Activate Contract contract and run switch in export action on contract card.', Comment = '%1 = Contract No';
                begin
                    UtilitySetup.Get();
                    Contract.Init();
                    Contract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, false);
                    Contract.Validate("No.");
                    Contract.Insert();
                    Contract.Validate("Activation Cause", Contract."Activation Cause"::Switch);
                    Contract.Validate(Status, Contract.Status::"In Registration");
                    Contract.Modify();
                    // Commit before run modal
                    Commit();
                    if Page.RunModal(Page::"Contract Card", Contract) = Action::LookupOK then begin
                        Contract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, true);
                        Contract.Modify();
                        Message(SwitchInContractLbl, Contract."No.");
                    end
                    else
                    begin
                        PointofDeliveryCustHist.SetRange("AAT Contract No", Contract."No.");
                        if PointofDeliveryCustHist.FindLast()then PointofDeliveryCustHist.Delete(true);
                        Contract.Delete();
                    end;
                end;
            }
        }
        area(Reporting)
        {
            action("Generate Physical Contract")
            {
                ToolTip = 'Specifies the value of the Generate Physical Contract Action';
                Caption = 'Generate Physical Contract';
                Image = FileContract;

                trigger OnAction()
                var
                    Contract: Record Contract;
                begin
                    CurrPage.SetSelectionFilter(Contract);
                    SelectContractLayout(Rec);
                    Report.RunModal(Report::"Physical Contract", true, false, Contract);
                end;
            }
            action("Change of Customer")
            {
                ToolTip = 'Specifies the value of the Change of the Customer Action';
                Caption = 'Generate New Contract for Change of Customer';
                ApplicationArea = All;
                Image = New;
                RunObject = page "Change of Customer Process";
            }
        }
        area(Promoted)
        {
            actionref("Generate New Contract_Promoted"; "Generate New Contract")
            {
            }
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref("Generate Invoice_Promoted"; "Generate Invoice")
                {
                }
            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';

                actionref("Generate Physical Contract_Promoted"; "Generate Physical Contract")
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'SII Interface', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref("Switch In_Promoted"; "Switch In")
                {
                }
                actionref("Change of Customer_Promoted"; "Change of Customer")
                {
                }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        UtilitySetup.GetRecordOnce();
        DeveloperMode:=UtilitySetup."AAT Developer Mode PUB";
    end;
    local procedure SelectContractLayout(var Contract: Record Contract)
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        ContractLayoutErrorLbl: Label 'No physical contract could be selected';
    begin
        UtilitySetup.GetRecordOnce();
        if(GetLanguageCode(Contract) = 'DE')then begin
            if(Contract.Resident)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Resident")
            else if(Contract.Farmer)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Farmer")
                else
                    ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Household");
        end
        else if(GetLanguageCode(Contract) = 'IT')then begin
                if(Contract.Resident)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Resident")
                else if(Contract.Farmer)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Farmer")
                    else
                        ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Household");
            end
            else
                Error(ContractLayoutErrorLbl);
    end;
    local procedure GetLanguageCode(var Contract: Record Contract): Text var
        Language: Record Language;
    begin
        Language.Get(Contract."Communication Langauge");
        case Language."Windows Language ID" of 1040, 2064: exit('IT');
        1031, 5127, 3079, 4103, 2055: exit('DE');
        end;
        exit('IT');
    end;
    var UtilitySetup: Record "Utility Setup";
    DeveloperMode: Boolean;
}
