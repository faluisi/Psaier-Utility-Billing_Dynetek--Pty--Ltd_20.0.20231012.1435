page 50240 "Activation Process"
{
    Caption = 'Activation';
    PageType = NavigatePage;

    layout
    {
        area(content)
        {
            group(Banner)
            {
                Editable = false;
                ShowCaption = false;
                Visible = TopBannerVisible;

                field("MediaResourcesStandard.""Media Reference"""; MediaResourcesStandard."Media Reference")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Banner2)
            {
                Editable = false;
                ShowCaption = false;
                Visible = TopBannerVisible and (CurrentPage = 5);

                field("MediaResourcesDone.""Media Reference"""; MediaResourcesDone."Media Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(Step1)
            {
                Caption = '';
                Visible = CurrentPage = 1;

                group("Para1.1")
                {
                    Caption = 'Customer Selection';
                    InstructionalText = '';

                    group("Para1.1.1")
                    {
                        ShowCaption = false;

                        field("Customer No."; CustomerNo)
                        {
                            ToolTip = 'Specifies the value of the Customer No.';
                            ApplicationArea = All;
                            TableRelation = Customer."No.";
                            Caption = 'No.';
                            NotBlank = true;
                            Lookup = true;

                            trigger OnValidate()
                            var
                                Customer: Record "Customer";
                            begin
                                if Customer.Get(CustomerNo)then CustomerName:=Customer.Name;
                            end;
                        }
                        field("Customer Name"; CustomerName)
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Customer Name'; //KB13122023 - TASK002199 Caption Update
                            ToolTip = 'Specifies the value of the CustomerName field.';
                        }
                    }
                }
            }
            group(Step2)
            {
                Caption = '';
                Visible = CurrentPage = 2;

                group("Para2.1")
                {
                    Caption = 'Contract Creation';
                    InstructionalText = '';

                    group("Para2.1.1")
                    {
                        ShowCaption = false;

                        field("Customer No.2"; CustomerNo)
                        {
                            Caption = 'Customer No.';
                            ToolTip = 'Specifies the value of the Customer No. field';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Customer Name2"; CustomerName)
                        {
                            ToolTip = 'Specifies the value of the Customer Name field';
                            Caption = 'Customer Name';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Contract No."; ContractNo)
                        {
                            ToolTip = 'Specifies the value of the Contract No. field';
                            Caption = 'Contract No.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field';
                            Caption = 'Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
            group(Step3)
            {
                Caption = '';
                Visible = CurrentPage = 3;

                group("Para3.1")
                {
                    Caption = 'Contract Creation';
                    InstructionalText = '';

                    group("Para3.1.1")
                    {
                        ShowCaption = false;

                        field("Customer No.3"; CustomerNo)
                        {
                            Caption = 'Customer No.';
                            ToolTip = 'Specifies the value of the Customer No. field';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Customer Name3"; CustomerName)
                        {
                            ToolTip = 'Specifies the value of the Customer Name field';
                            Caption = 'Customer Name';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Contract No.3"; ContractNo)
                        {
                            ToolTip = 'Specifies the value of the Contract No. field';
                            Caption = 'Contract No.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description3"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field';
                            Caption = 'Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        //KB20112023 - TASK002131 New Activation Process +++
                        field("Notes"; Notes)
                        {
                            ToolTip = 'Specifies the value of the Notes field';
                            Caption = 'Notes';
                            ApplicationArea = All;
                        }
                    //KB20112023 - TASK002131 New Activation Process ---
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateContract)
            {
                ApplicationArea = All;
                Caption = '&Generate Contract';
                Enabled = CurrentPage = 2;
                Image = NewDocument;
                InFooterBar = true;
                ToolTip = 'Executes the &Generate Contract action.';

                trigger OnAction()
                var
                    TempContract: Record Contract temporary;
                    ContractNew: Record Contract;
                    Customer: Record Customer;
                    PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
                    UtilitySetup: Record "Utility Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                begin
                    UtilitySetup.Get();
                    TempContract.Init();
                    TempContract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, false);
                    TempContract.Insert();
                    TempContract.Validate("Customer No.", CustomerNo);
                    TempContract.Validate("Activation Cause", TempContract."Activation Cause"::Activation);
                    TempContract.Validate(Status, TempContract.Status::"In Registration");
                    Customer.Get(CustomerNo);
                    TempContract.Validate("Communication Langauge", Customer."Customer Language Code");
                    TempContract.Modify();
                    // Commit(); //KB14122023 - TASK002199 Contract Insert issue Code commented  // AN 03012024 - TASK002297 - 1 Uncommented
                    if Page.RunModal(Page::"Contract Card", TempContract) = Action::LookupOK then begin
                        TempContract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, true);
                        TempContract.Modify();
                        // AN 03012024 TASK002297 Insert Issue Commented ++ 
                        //KB14122023 - TASK002199 Contract Insert issue +++
                        ContractNew:=TempContract;
                        ContractNew.Insert();
                        //KB14122023 - TASK002199 Contract Insert issue ---
                        ContractNo:=CopyStr(TempContract."No.", 1, MaxStrLen(ContractNo));
                        // AN 03012024 TASK002297 Insert Issue Commented ----
                        ContractDescription:=TempContract."Contract Description";
                        CurrPage.Update();
                    end
                    else
                    begin
                        PointofDeliveryCustHist.SetRange("AAT Contract No", TempContract."No.");
                        if PointofDeliveryCustHist.FindLast()then PointofDeliveryCustHist.Delete(true);
                        TempContract.Delete();
                    end;
                end;
            }
            action(BackAction)
            {
                ApplicationArea = All;
                Caption = '&Back';
                Enabled = (CurrentPage <> 1);
                Image = PreviousRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Back action.';

                trigger OnAction()
                begin
                    CurrentPage:=CurrentPage - 1;
                    CurrPage.Update();
                end;
            }
            action(NextAction)
            {
                ApplicationArea = All;
                Caption = '&Next';
                Enabled = (CurrentPage < 3);
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Next action.';

                trigger OnAction()
                var
                    Error1Lbl: Label 'Customer No must not be Blank.';
                    Error2Lbl: Label 'Contract No must not be Blank.';
                begin
                    if CurrentPage = 1 then if CustomerNo = '' then Error(Error1Lbl);
                    if CurrentPage = 2 then if ContractNo = '' then Error(Error2Lbl);
                    CurrentPage:=CurrentPage + 1;
                    CurrPage.Update();
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = '&Finish';
                Enabled = CurrentPage = 3;
                Visible = CurrentPage = 3;
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Finish action.';

                trigger OnAction()
                var
                    Contract: Record Contract;
                    PhysicalContrct: Report "Physical Contract";
                    ActivationDataMgmt: Codeunit ActivationDataMgmt;
                begin
                    Contract.SetFilter("No.", ContractNo);
                    if Contract.FindFirst()then begin
                        SelectContractLayout(Contract);
                        //KB111223 - TASK002199 Physical Contract Report Update +++
                        PhysicalContrct.SetProcess();
                        PhysicalContrct.SetTableView(Contract);
                        PhysicalContrct.RunModal();
                        if PhysicalContrct.GetConfirm()then begin
                            ActivationDataMgmt.ChangeOfNewActivationData(Contract, Notes); //KB20112023 - TASK002131 New Activation Process 
                            CurrPage.Close();
                        end;
                    end
                    else
                        CurrPage.Close();
                end;
            }
        }
    }
    trigger OnInit()
    begin
        CurrentPage:=1;
        LoadTopBanners();
    end;
    local procedure LoadTopBanners()
    begin
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType())) and MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType()))then if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")then TopBannerVisible:=MediaResourcesDone."Media Reference".HasValue;
    end;
    local procedure SelectContractLayout(var Contract: Record Contract)
    var
        ReportLayoutSelection: Record "Report Layout Selection";
        UtilitySetup: Record "Utility Setup";
        ContractLayoutErr: Label 'No physical contract layout could be selected';
    begin
        UtilitySetup.Get();
        if(GetLanguageCode(Contract) = 'DE')then begin
            if(Contract.Resident)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Resident")
            else if(Contract.Farmer)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Farmer")
                else
                    ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - G Household");
        end
        else if(GetLanguageCode(Contract) = 'ITA')then begin
                if(Contract.Resident)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Resident")
                else if(Contract.Farmer)then ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Farmer")
                    else
                        ReportLayoutSelection.SetTempLayoutSelected(UtilitySetup."Report Code - I Household");
            end
            else
                Error(ContractLayoutErr);
    end;
    local procedure GetLanguageCode(var Contract: Record Contract): Text var
        Language: Record Language;
    begin
        Language.Get(Contract."Communication Langauge");
        case Language."Windows Language ID" of 1040: exit('ITA');
        2064: exit('ITA');
        1031: exit('DE');
        5127: exit('DE');
        3079: exit('DE');
        4103: exit('DE');
        2055: exit('DE');
        end;
        exit('ENG');
    end;
    var MediaRepositoryDone: Record "Media Repository";
    MediaRepositoryStandard: Record "Media Repository";
    MediaResourcesDone: Record "Media Resources";
    MediaResourcesStandard: Record "Media Resources";
    ClientTypeManagement: Codeunit "Client Type Management";
    TopBannerVisible: Boolean;
    ContractNo: Code[20];
    CustomerNo: Code[20];
    CurrentPage: Integer;
    ContractDescription: Text;
    CustomerName: Text;
    Notes: Text[50];
}
