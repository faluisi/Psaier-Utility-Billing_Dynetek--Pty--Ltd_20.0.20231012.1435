page 50241 "Switch In Process"
{
    Caption = 'Switch In';
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
                            ApplicationArea = All;
                            TableRelation = Customer."No.";
                            Caption = 'No.';
                            ToolTip = 'Specifies the value of the Customer No. field.';
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
                            ToolTip = 'Specifies the value of the Customer Name field.';
                            Caption = 'Customer Name';
                            ApplicationArea = All;
                            Editable = false;
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
                            ToolTip = 'Specifies the value of the Customer No. field.';
                            Caption = 'Customer No.';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Customer Name2"; CustomerName)
                        {
                            ToolTip = 'Specifies the value of the Customer Name field.';
                            Caption = 'Customer Name';
                            Editable = false;
                            ApplicationArea = All;
                        }
                        field("Contract No."; ContractNo)
                        {
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            Caption = 'Contract No.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field.';
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

                group("Para2.1.2")
                {
                    ShowCaption = false;

                    field("Customer No.3"; CustomerNo)
                    {
                        ToolTip = 'Specifies the value of the Customer No. field.';
                        Caption = 'Customer No.';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Customer Name3"; CustomerName)
                    {
                        ToolTip = 'Specifies the value of the Customer Name field.';
                        Caption = 'Customer Name';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Contract No.2"; ContractNo)
                    {
                        ToolTip = 'Specifies the value of the Contract No. field.';
                        Caption = 'Contract No.';
                        ApplicationArea = All;
                        TableRelation = Contract."No.";
                        Editable = false;
                    }
                    field("Contract Description2"; ContractDescription)
                    {
                        ToolTip = 'Specifies the value of the Contract Description field.';
                        Caption = 'Contract Description';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    //KB22112023 - TASK002154 Switch-In Process +++
                    field("Acquisto_Credito"; Acquisto_Credito)
                    {
                        ToolTip = 'Specifies the value of the Acquisto_Credito field.';
                        Caption = 'Acquisto_Credito';
                        ApplicationArea = All;
                    }
                    field("Revoca_Timoe"; Revoca_Timoe)
                    {
                        ToolTip = 'Specifies the value of the Revoca_Timoe field.';
                        Caption = 'Revoca_Timoe';
                        ApplicationArea = All;
                    }
                //KB22112023 - TASK002154 Switch-In Process ---
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
                    PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
                    UtilitySetup: Record "Utility Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                    ErrorTxt: Text;
                begin
                    UtilitySetup.Get();
                    TempContract.Init();
                    TempContract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, false);
                    TempContract.Insert();
                    TempContract.Validate("Customer No.", CustomerNo);
                    TempContract.Validate("Activation Cause", TempContract."Activation Cause"::Switch);
                    TempContract.Validate(Status, TempContract.Status::"In Registration");
                    TempContract.Modify();
                    if Page.RunModal(Page::"Contract Card", TempContract) = Action::LookupOK then begin
                        TempContract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, true);
                        TempContract.Modify();
                        //KB14122023 - TASK002199 Contract Insert issue +++
                        ContractNew:=TempContract;
                        ContractNew.Insert();
                        //KB14122023 - TASK002199 Contract Insert issue ---
                        ContractNo:=ContractNew."No.";
                        ContractDescription:=ContractNew."Contract Description";
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
                    Contract: Record Contract;
                    Error1Lbl: Label 'Customer No must not be Blank.';
                    Error2Lbl: Label 'Contract No must not be Blank.';
                    ErrorTxt: Text;
                begin
                    if CurrentPage = 1 then if CustomerNo = '' then Error(Error1Lbl);
                    if CurrentPage = 2 then begin
                        if ContractNo = '' then Error(Error2Lbl);
                        //KB22112023 - TASK002154 Switch-In Process +++
                        if Contract.Get(ContractNo)then ErrorTxt:=ValidateFields(Contract);
                        if ErrorTxt <> '' then Error(ErrorTxt);
                    //KB22112023 - TASK002154 Switch-In Process ---
                    end;
                    CurrentPage:=CurrentPage + 1;
                    CurrPage.Update();
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = '&Finish';
                Enabled = (CurrentPage = 3);
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Finish action.';

                trigger OnAction()
                var
                    Contract: Record Contract;
                    PhysicalContrct: Report "Physical Contract";
                    SIIInterfaceManagement: Codeunit "Switch In Management";
                    Filename: Text;
                begin
                    if CurrentPage = 3 then begin
                        Contract.SetFilter("No.", ContractNo);
                        if Contract.FindFirst()then begin
                            Filename:='';
                            //KB22112023 - TASK002154 Switch-In Process +++
                            SelectContractLayout(Contract);
                            //KB111223 - TASK002199 Physical Contract Report Update +++
                            PhysicalContrct.SetProcess();
                            PhysicalContrct.SetTableView(Contract);
                            PhysicalContrct.RunModal();
                            if PhysicalContrct.GetConfirm()then begin
                                SIIInterfaceManagement.NewSwitchInProcess(Contract, Filename, Revoca_Timoe, Acquisto_Credito);
                                CurrPage.Close();
                            end;
                        end
                        else
                            CurrPage.Close();
                    end;
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
    //KB22112023 - TASK002154 Switch-In Process +++
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
    local procedure ValidateFields(Contract: Record Contract)ErrorTxt: Text var
        PODNoErrorLbl: Label 'POD No must not be Blank for %1.', Comment = 'POD No must not be Blank for %1.';
        StartDateLbl: Label 'Contract Start Date must not be Blank for %1.', Comment = 'Contract Start Date must not be Blank for %1.';
        EconomicalDataErrorLbl: Label 'Economical Start Date must not be Blank for %1.', Comment = 'Economical Start Date must not be Blank for %1.';
        CadastralDataErrorLbl: Label 'Cadastral Start Date must not be Blank for %1.', Comment = 'Cadastral Start Date must not be Blank for %1.';
    begin
        Clear(ErrorTxt);
        if Contract."POD No." = '' then if ErrorTxt = '' then ErrorTxt+=StrSubstNo(PODNoErrorLbl, Contract."No.")
            else
                ErrorTxt+='\' + StrSubstNo(PODNoErrorLbl, Contract."No.");
        if Contract."Contract Start Date" = 0D then if ErrorTxt = '' then ErrorTxt+=StrSubstNo(StartDateLbl, Contract."No.")
            else
                ErrorTxt+='\' + StrSubstNo(StartDateLbl, Contract."No.");
        if Contract."Economic Condition Start Date" = 0D then if ErrorTxt = '' then ErrorTxt+=StrSubstNo(EconomicalDataErrorLbl, Contract."No.")
            else
                ErrorTxt+='\' + StrSubstNo(EconomicalDataErrorLbl, Contract."No.");
        if Contract."Cadastral Data Start Date" = 0D then if ErrorTxt = '' then ErrorTxt+=StrSubstNo(CadastralDataErrorLbl, Contract."No.")
            else
                ErrorTxt+='\' + StrSubstNo(CadastralDataErrorLbl, Contract."No.");
    end;
    //KB22112023 - TASK002154 Switch-In Process ---
    var MediaRepositoryDone: Record "Media Repository";
    MediaRepositoryStandard: Record "Media Repository";
    MediaResourcesDone: Record "Media Resources";
    MediaResourcesStandard: Record "Media Resources";
    ClientTypeManagement: Codeunit "Client Type Management";
    TopBannerVisible: Boolean;
    CustomerNo: Code[20];
    ContractNo: Code[25];
    CurrentPage: Integer;
    ContractDescription: Text;
    CustomerName: Text;
    Revoca_Timoe: Boolean;
    Acquisto_Credito: Boolean;
}
