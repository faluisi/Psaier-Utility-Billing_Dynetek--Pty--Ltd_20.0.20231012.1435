page 50242 "Switch Out Process"
{
    Caption = 'Switch Out';
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
                                Contract: Record Contract;
                                ErrorText: Text;
                                ContractErrorLbl: Label 'No Contract is associated with Customer: %1', Locked = true;
                            begin
                                Contract.SetRange("Customer No.", CustomerNo);
                                if not Contract.IsEmpty()then begin
                                    if Customer.Get(CustomerNo)then CustomerName:=Customer.Name;
                                end
                                else
                                begin
                                    ErrorText:=StrSubstNo(ContractErrorLbl, CustomerNo);
                                    Error(ErrorText);
                                end;
                            end;
                        }
                        field("Customer Name"; CustomerName)
                        {
                            Caption = 'Customer Name';
                            ToolTip = 'Specifies the value of the Customer Name field.';
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
                    Caption = 'Contract Selection';
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
                            Caption = 'Contract No.';
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = true;
                            Lookup = true;

                            trigger OnLookup(var Text: Text): Boolean var
                                Contract: Record Contract;
                            begin
                                Contract.Reset();
                                Contract.SetRange("Customer No.", CustomerNo);
                                if Page.RunModal(Page::"Contract List", Contract) = Action::LookupOK then begin
                                    Text:=Contract."No.";
                                    exit(true);
                                end;
                            end;
                            trigger OnValidate()
                            var
                                Contract: Record Contract;
                            begin
                                if Contract.Get(ContractNo)then ContractDescription:=Contract."Contract Description";
                            end;
                        }
                        field("Contract Description"; ContractDescription)
                        {
                            Caption = 'Contract Description';
                            ToolTip = 'Specifies the value of the Contract Description field.';
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

                group("Para3.1.")
                {
                    Caption = 'Confirmation';
                    InstructionalText = '';

                    group("Para3.1.1")
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
                            Caption = 'Contract No.';
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description2"; ContractDescription)
                        {
                            Caption = 'Contract Description';
                            ToolTip = 'Specifies the value of the Contract Description field.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            Action(BackAction)
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
            Action(NextAction)
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
                    //KB14122023 - TASK002199 Next Button validation +++
                    if CurrentPage = 1 then if CustomerNo = '' then Error(Error1Lbl);
                    if CurrentPage = 2 then if ContractNo = '' then Error(Error2Lbl);
                    //KB14122023 - TASK002199 Next Button validation ---
                    CurrentPage:=CurrentPage + 1;
                    CurrPage.Update();
                end;
            }
            Action(FinishAction)
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
                    SwitchOutManagement: Codeunit "Switch Out Management";
                    ConfirmManagement: Codeunit "Confirm Management";
                    CancelationLbl: Label 'Switch Out Canceled';
                    ConfirmMessageLbl: Label 'By Switching out the customer you acknowledge the following: \\ 1. The latest measurements for the contract have been imported to Business Central \\ 2. The latest Invoice for this contract has been generated and sent to the client. \\ Would you like to Switch out this Client?';
                begin
                    if not ConfirmManagement.GetResponse(ConfirmMessageLbl, false)then Error(CancelationLbl);
                    if CurrentPage = 3 then if Customer.Get(CustomerNo)then if Contract.Get(ContractNo)then begin
                                SwitchOutManagement.NewSwitchOutProcess(Customer, Contract);
                                CurrPage.Close();
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
        if MediaRepositoryStandard.Get('AssistedSetup-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType())) and MediaRepositoryDone.Get('AssistedSetupDone-NoText-400px.png', Format(ClientTypeManagement.GetCurrentClientType()))then if MediaResourcesStandard.Get(MediaRepositoryStandard."Media Resources Ref") and MediaResourcesDone.Get(MediaRepositoryDone."Media Resources Ref")then TopBannerVisible:=MediaResourcesDone."Media Reference".HasValue();
    end;
    var MediaRepositoryStandard: Record "Media Repository";
    MediaRepositoryDone: Record "Media Repository";
    MediaResourcesStandard: Record "Media Resources";
    MediaResourcesDone: Record "Media Resources";
    ClientTypeManagement: Codeunit "Client Type Management";
    CustomerNo: Code[20];
    CustomerName: Text;
    ContractDescription: Text;
    ContractNo: Code[20];
    TopBannerVisible: Boolean;
    CurrentPage: Integer;
}
