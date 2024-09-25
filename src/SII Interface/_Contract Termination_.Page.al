page 50244 "Contract Termination"
{
    Caption = 'Contract Termination';
    PageType = NavigatePage;
    SourceTable = Contract;

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
                    Caption = 'Contract Selection';
                    InstructionalText = '';

                    group("Para1.1.1")
                    {
                        ShowCaption = false;

                        field("Contract No."; ContractNo)
                        {
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Caption = 'No.';
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            NotBlank = true;
                            Lookup = true;

                            // AN 23112023 - Terminate the contract from New Termination contract ++
                            trigger OnValidate()
                            var
                                Contract: Record Contract;
                            begin
                                if Contract.Get(ContractNo)then ContractDescription:=Contract."Contract Description";
                            end;
                        // AN 23112023 - Terminate the contract from New Termination contract ++
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
            group(Step2)
            {
                Caption = '';
                Visible = CurrentPage = 2;

                group("Para2.1")
                {
                    Caption = 'Contract Termination';
                    InstructionalText = '';

                    group("Para2.1.1")
                    {
                        ShowCaption = false;

                        field("Contract No.2"; ContractNo)
                        {
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Caption = 'No.';
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            NotBlank = true;
                            Editable = false;
                        }
                        field("Contract Description2"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field.';
                            Caption = 'Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Reason for Termination"; ReasonForTermination)
                        {
                            ToolTip = 'Specifies the value of the Reason for Termination field.';
                            Caption = 'Reason for Termination';
                            Editable = true;
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(Step3)
            {
                Caption = 'Contract Termination Confirmation';
                Visible = CurrentPage = 3;

                group("Para2.1.2")
                {
                    ShowCaption = false;

                    field("Contract No.3"; ContractNo)
                    {
                        ApplicationArea = All;
                        TableRelation = Contact."No.";
                        Caption = 'No.';
                        ToolTip = 'Specifies the value of the Contract No. field.';
                        NotBlank = true;
                        Editable = false;
                    }
                    field("Contract Description3"; ContractDescription)
                    {
                        ToolTip = 'Specifies the value of the Contract Description field.';
                        Caption = 'Contract Description';
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Reason for Termination3"; ReasonForTermination)
                    {
                        ToolTip = 'Specifies the value of the Reason for Termination field.';
                        Caption = 'Reason for Termination';
                        Editable = false;
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
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
                    Error1Lbl: Label 'Contract No must not be Blank.';
                    Error2Lbl: Label 'Please select Reason for Termination.';
                begin
                    if CurrentPage = 1 then begin
                        ContractNo:=ContractNo;
                        ContractDescription:=ContractDescription;
                    end;
                    //KB14122023 - TASK002199 Next Button validation +++
                    if CurrentPage = 1 then if ContractNo = '' then Error(Error1Lbl);
                    if CurrentPage = 2 then if ReasonForTermination = ReasonForTermination::" " then Error(Error2Lbl);
                    //KB14122023 - TASK002199 Next Button validation ---
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
                    Customer: Record Customer;
                    Contract: Record Contract;
                    ContractTerminationMgt: Codeunit "Contract Termination Mgt.";
                    ConfirmLbl: Label 'Are you sure you want to Terminate Contract %1?', Locked = true;
                begin
                    if CurrentPage = 3 then begin
                        Contract.SetRange("No.", ContractNo);
                        if Contract.FindFirst()then if Customer.Get(Contract."Customer No.")then if Confirm(StrSubstNo(ConfirmLbl, ContractNo))then begin
                                    ContractTerminationMgt.NewContractTerminationProcess(Contract, ReasonForTermination, '');
                                    CurrPage.Close();
                                end;
                    end;
                    CurrPage.Update();
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
    var MediaRepositoryStandard: Record "Media Repository";
    MediaRepositoryDone: Record "Media Repository";
    MediaResourcesStandard: Record "Media Resources";
    MediaResourcesDone: Record "Media Resources";
    ClientTypeManagement: Codeunit "Client Type Management";
    ContractDescription: Text;
    ContractNo: Code[25];
    TopBannerVisible: Boolean;
    CurrentPage: Integer;
    ReasonForTermination: Enum "Reason for Cont. Termination";
}
