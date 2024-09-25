page 50243 "Change of Customer Process"
{
    Caption = 'Change of Customer';
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
                            ToolTip = 'Specifies the value of the Customer No. field';
                            ApplicationArea = All;
                            TableRelation = Customer."No.";
                            Caption = 'No.';
                            NotBlank = true;
                            Lookup = true;

                            trigger OnValidate()
                            var
                                Customer: Record Customer;
                            begin
                                if Customer.Get(CustomerNo)then CustomerName:=Customer.Name;
                            end;
                        }
                        field("Customer Name"; CustomerName)
                        {
                            ToolTip = 'Specifies the value of the Customer Name field';
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
                    Caption = 'Choose Point of Delivery';
                    InstructionalText = '';

                    group("Para2.1.1")
                    {
                        ShowCaption = false;

                        field("POD No."; PODNo)
                        {
                            ToolTip = 'Specifies the value of the POD No. field';
                            ApplicationArea = All;
                            TableRelation = "Point of Delivery"."No.";
                            Caption = 'POD No.';
                            NotBlank = true;
                            Lookup = true;

                            trigger OnValidate()
                            var
                                Contract: Record Contract;
                            begin
                                Contract.SetRange("POD No.", PODNo);
                                // AN 12122023 TASK002199 Select POD with Open Status only. +++
                                Contract.SetFilter(Status, '%1|%2', Contract.Status::Open, Contract.Status::"In Registration");
                                if not Contract.IsEmpty() and Contract.FindLast()then begin
                                    CurrentContractNo:=Contract."No.";
                                    CurrentContractDescription:=Contract."Contract Description";
                                end;
                            // AN 12122023 TASK002199 Select POD with Open Status only. ---
                            end;
                        }
                        field("Current Contract"; CurrentContractNo)
                        {
                            ToolTip = 'Specifies the value of the Customer No. field';
                            ApplicationArea = All;
                            TableRelation = "Point of Delivery"."No.";
                            Caption = 'Current Contract No.';
                            NotBlank = true;
                            Editable = false;
                        }
                        field("Current Contract Description"; CurrentContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field';
                            Caption = 'Current Contract Description';
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
                    Caption = 'Generate Contract';
                    InstructionalText = '';

                    group("Para3.1.1")
                    {
                        ShowCaption = false;

                        field("POD No.2"; PODNo)
                        {
                            ToolTip = 'Specifies the value of the POD No. field';
                            ApplicationArea = All;
                            TableRelation = "Point of Delivery"."No.";
                            Caption = 'POD No.';
                            NotBlank = true;
                            Lookup = true;

                            trigger OnValidate()
                            var
                                Contract: Record Contract;
                            begin
                                Contract.SetRange("POD No.", PODNo);
                                if not Contract.IsEmpty() and Contract.FindFirst()then begin
                                    CurrentContractNo:=Contract."No.";
                                    ContractDescription:=Contract."Contract Description";
                                end;
                            end;
                        }
                        field("Contract No."; ContractNo)
                        {
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            Caption = 'New Contract No.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field.';
                            Caption = 'New Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
            group(Step4)
            {
                Caption = '';
                Visible = CurrentPage = 4;

                group("Para4.1")
                {
                    Caption = 'Confirm Change of Customer';
                    InstructionalText = '';

                    group("Para4.1.1")
                    {
                        ShowCaption = false;

                        field("POD No.3"; PODNo)
                        {
                            ToolTip = 'Specifies the value of the POD No. field';
                            ApplicationArea = All;
                            TableRelation = "Point of Delivery"."No.";
                            Caption = 'POD No.';
                            NotBlank = true;
                            Lookup = true;
                            Editable = false;

                            trigger OnValidate()
                            var
                                Contract: Record Contract;
                            begin
                                Contract.SetRange("POD No.", PODNo);
                                if not Contract.IsEmpty() and Contract.FindFirst()then begin
                                    CurrentContractNo:=Contract."No.";
                                    ContractDescription:=Contract."Contract Description";
                                end;
                            end;
                        }
                        field("Current Contract3"; CurrentContractNo)
                        {
                            ToolTip = 'Specifies the value of the Customer No. field';
                            ApplicationArea = All;
                            TableRelation = "Point of Delivery"."No.";
                            Caption = 'Current Contract No.';
                            NotBlank = true;
                            Editable = false;
                        }
                        field("Current Contract Description3"; CurrentContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field';
                            Caption = 'Current Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Contract No.2"; ContractNo)
                        {
                            ToolTip = 'Specifies the value of the Contract No. field.';
                            Caption = 'New Contract No.';
                            ApplicationArea = All;
                            TableRelation = Contract."No.";
                            Editable = false;
                        }
                        field("Contract Description2"; ContractDescription)
                        {
                            ToolTip = 'Specifies the value of the Contract Description field.';
                            Caption = 'New Contract Description';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Reason for Change"; AATTypeOfVoltureSII)
                        {
                            ApplicationArea = All;
                            Caption = 'Type Of Volture';
                            ToolTip = 'Specifies the value of the Type Of Volture field.';
                        }
                        field("Customer Category"; AATCOCCategorySII)
                        {
                            ApplicationArea = All;
                            Caption = 'Customer Category';
                            ToolTip = 'Specifies the value of the Customer Category field.';
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
            action(GenerateContract)
            {
                ApplicationArea = All;
                Caption = '&Generate Contract';
                Enabled = CurrentPage = 3;
                Image = NewDocument;
                InFooterBar = true;
                ToolTip = 'Executes the &Generate Contract action.';

                trigger OnAction()
                var
                    TempContract: Record Contract temporary;
                    Contract2: Record Contract;
                    ContractNew: Record Contract;
                    Customer: Record Customer;
                    PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
                    UtilitySetup: Record "Utility Setup";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                begin
                    UtilitySetup.Get();
                    Contract2.Reset();
                    Contract2.SetRange("POD No.", PODNo);
                    Contract2.SetFilter(Status, '%1|%2', Contract2.status::OPen, Contract2.status::"In Registration");
                    if not Contract2.IsEmpty() and Contract2.FindFirst()then begin
                        Contract2.Status:=Contract2.Status::"Closed - Awaiting Approval";
                        Contract2.Validate("Deactivation Cause", "Deactivation Cause"::Transfer);
                        Contract2.Validate("Contract End Date", Today);
                        Contract2.Modify(true);
                    end;
                    TempContract.Init();
                    TempContract."No.":=NoSeriesManagement.GetNextNo(UtilitySetup."Contract No. Series", Today, false);
                    TempContract.Insert();
                    TempContract.Validate("Customer No.", CustomerNo);
                    // AN 27112023 - TASK002168 - Removed Validation for POD No. ++  
                    TempContract.Validate("POD No.", PODNo);
                    // AN 27112023 - TASK002168 - Removed Validation for POD No. --
                    TempContract.Validate("Activation Cause", TempContract."Activation Cause"::Transfer);
                    TempContract.Validate(Status, TempContract.Status::"In Registration");
                    Customer.Get(CustomerNo);
                    TempContract.Validate("Communication Langauge", Customer."Customer Language Code");
                    TempContract.Modify();
                    Commit(); //KB14122023 - TASK002199 Contract Insert issue Code commented
                    if Page.RunModal(Page::"Contract Card", TempContract) = Action::LookupOK then begin
                        Clear(Contract2."POD No.");
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
                        if Contract2.FindFirst()then begin
                            Contract2.Validate(Status, "Contract Status"::Open);
                            Clear(Contract2."Contract End Date");
                            Clear(Contract2."Deactivation Cause");
                            Contract2.Modify(true);
                        end;
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
                Enabled = (CurrentPage < 4);
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Next action.';

                trigger OnAction()
                var
                    Error1Lbl: Label 'Customer No must not be Blank.';
                    Error2Lbl: Label 'POD No must not be Blank.';
                    Error3Lbl: Label 'Contract No must not be Blank.';
                begin
                    //KB14122023 - TASK002199 Next Button validation +++
                    if CurrentPage = 1 then if CustomerNo = '' then Error(Error1Lbl);
                    if CurrentPage = 2 then if PODNo = '' then Error(Error2Lbl);
                    if CurrentPage = 3 then if ContractNo = '' then Error(Error3Lbl);
                    //KB14122023 - TASK002199 Next Button validation ---
                    CurrentPage:=CurrentPage + 1;
                    CurrPage.Update();
                end;
            }
            action(FinishAction)
            {
                ApplicationArea = All;
                Caption = '&Finish';
                Enabled = (CurrentPage = 4);
                Image = NextRecord;
                InFooterBar = true;
                ToolTip = 'Executes the &Finish action.';

                trigger OnAction()
                var
                    Contract: Record Contract;
                    Contract_Rec: Record Contract;
                    ChangeofCustomerMgt: Codeunit "Change of Customer Management";
                    COCStartLbl: Label 'Please run Print Contract action on Contract Card.\\ When Contract is signed and all necessary values have been inserted into the system, Run Change of Customer Export action on Contract card.';
                begin
                    if CurrentPage = 4 then //begin
 if Contract.Get(ContractNo)then begin
                            Contract.Validate("AAT Type Of Volture SII", AATTypeOfVoltureSII);
                            Contract.Validate("AAT Customer Category SII", AATCOCCategorySII);
                            Contract.Modify(true);
                        end;
                    Message(COCStartLbl);
                    // AN 27112023 TASK002168  - Downoload VT01.0050 file. ++ 
                    Contract_Rec.reset();
                    Contract_Rec.SetRange("No.", ContractNo);
                    if Contract_Rec.FindSet()then ChangeofCustomerMgt.NewChangeofCustomer(Contract_Rec, '');
                    // AN 27112023 TASK002168  - Downoload VT01.0050 file. ++ 
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
    var MediaRepositoryDone: Record "Media Repository";
    MediaRepositoryStandard: Record "Media Repository";
    MediaResourcesDone: Record "Media Resources";
    MediaResourcesStandard: Record "Media Resources";
    ClientTypeManagement: Codeunit "Client Type Management";
    TopBannerVisible: Boolean;
    ContractNo: Code[25];
    CustomerNo: Code[20];
    CurrentContractNo: Code[25];
    PODNo: Code[25];
    AATCOCCategorySII: Enum "AAT COC Category SII";
    AATTypeOfVoltureSII: Enum "AAT Type Of Volture SII";
    CurrentPage: Integer;
    ContractDescription: Text;
    CurrentContractDescription: Text;
    CustomerName: Text;
}
