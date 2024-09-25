page 50203 "Economic Condition Card"
{
    PageType = Card;
    SourceTable = "Economic Condition";
    Caption = 'Economic Condition Card';
    InsertAllowed = false; //KB14122023 - TASK002199 Disable Insert
    DeleteAllowed = false; //KB14122023 - TASK002199 Disable Delete

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Start Date"; EconomicConditions."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field("End Date"; EconomicConditions."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
                field("Invoice Layout"; EconomicConditions."Invoice Layout")
                {
                    ToolTip = 'Specifies the value of the Invoice Layout field.';
                    Caption = 'Invoice Layout';
                    ApplicationArea = All;
                }
                field("Contractual Power"; EconomicConditions."Contractual Power")
                {
                    ToolTip = 'Specifies the value of the Contractual Power field.';
                    Caption = 'Contractual Power';
                    ApplicationArea = All;
                }
                field("Available Power"; EconomicConditions."Available Power")
                {
                    ToolTip = 'Specifies the value of the Available Power field.';
                    Caption = 'Available Power';
                    ApplicationArea = All;
                }
                field("Billing Interval"; EconomicConditions."Billing Interval")
                {
                    ToolTip = 'Specifies the value of the Billing Interval field.';
                    Caption = 'Billing Interval';
                    ApplicationArea = All;
                }
                field("Voltage Type"; EconomicConditions."Voltage Type")
                {
                    ToolTip = 'Specifies the value of the Voltage Type field.';
                    Caption = 'Voltage Type';
                    ApplicationArea = All;
                }
                field(Voltage; EconomicConditions.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                    Caption = 'Voltage';
                    ApplicationArea = All;
                }
                field("System Type"; EconomicConditions."System Type")
                {
                    ToolTip = 'Specifies the value of the System Type field.';
                    Caption = 'System Type';
                    ApplicationArea = All;
                }
                field("Reduced VAT"; EconomicConditions."Reduced VAT")
                {
                    ToolTip = 'Specifies the value of the Reduced VAT field.';
                    Caption = 'Reduced VAT';
                    ApplicationArea = All;
                }
                field("Tariff Option No."; EconomicConditions."Tariff Option No.")
                {
                    ToolTip = 'Specifies the value of the Tariff Option No. field.';
                    Caption = 'Tariff Option No.';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean var
                        TariffHeader: Record "Tariff Header";
                    begin
                        TariffHeader.Reset();
                        if Page.RunModal(Page::"Tariff List", TariffHeader) = Action::LookupOK then begin
                            EconomicConditions."Tariff Option No.":=TariffHeader."No.";
                            EconomicConditions."Tariff Option Name":=TariffHeader.Description;
                        end;
                    end;
                }
                field("Tariff Option Name"; EconomicConditions."Tariff Option Name")
                {
                    ToolTip = 'Specifies the value of the Tariff Option Name field.';
                    Editable = false;
                    Caption = 'Tariff Option Name';
                    ApplicationArea = All;
                }
                field("Anual Consumption"; EconomicConditions."Annual Consumption")
                {
                    ToolTip = 'Specifies the value of the Annual Consumption field.';
                    Caption = 'Annual Consumption';
                    ApplicationArea = All;
                }
                field("AUC Exempt"; EconomicConditions."AUC Exempt")
                {
                    ToolTip = 'Specifies the value of the AUC Exempt field.';
                    Caption = 'AUC Exempt';
                    ApplicationArea = All;
                }
                field("Excise Duties not Due"; EconomicConditions."Excise Duties not Due")
                {
                    ToolTip = 'Specifies the value of the Excise Duties not Due field.';
                    Caption = 'Excise Duties not Due';
                    ApplicationArea = All;
                }
                field("Limiter Present"; EconomicConditions."Limiter Present")
                {
                    ToolTip = 'Specifies the value of the Limiter Present field.';
                    Caption = 'Limiter Present';
                    ApplicationArea = All;
                }
                field(Resident; EconomicConditions.Resident)
                {
                    ToolTip = 'Specifies the value of the Resident field.';
                    Caption = 'Resident';
                    ApplicationArea = All;

                    trigger OnValidate();
                    var
                        Contract: Record Contract;
                    begin
                        if Rec.Resident then Rec.Validate(Farmer, false);
                        if Contract.Get(EconomicConditions."Contract No.")then if Contract."Contract Type" = Contract."Contract Type"::"01" then EconomicConditions.TestField(Resident, true)
                            else
                                EconomicConditions.TestField(Resident, false);
                    end;
                }
                field(Farmer; EconomicConditions.Farmer)
                {
                    ToolTip = 'Specifies the value of the Farmer field.';
                    Caption = 'Farmer';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        if Rec.Farmer then Rec.Validate(Resident, false);
                    end;
                }
                field("Security Deposit"; EconomicConditions."Security Deposit")
                {
                    ToolTip = 'Specifies the value of the Security Deposit field.';
                    Visible = true;
                    Caption = 'Security Deposit';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        case EconomicConditions."Security Deposit" of true: ShowSecurityAmount:=true;
                        false: ShowSecurityAmount:=false;
                        end;
                        CurrPage.Update(true);
                    end;
                }
                group("Security Deposit Grp")
                {
                    Visible = ShowSecurityAmount;
                    Caption = 'Security Deposit Grp';

                    field("Security Deposit Amount"; EconomicConditions."Security Deposit Amount")
                    {
                        ToolTip = 'Specifies the value of the Security Deposit Amount field.';
                        Visible = true;
                        Caption = 'Security Deposit Amount';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        EconomicConditions.SetRange("Contract No.", Rec."Contract No.");
        EconomicConditions.SetRange("POD No.", Rec."POD No.");
        if EconomicConditions.FindLast()then;
        //KB14122023 - TASK002199 Disable Next and Previous Button +++
        Rec.FilterGroup(100);
        Rec.SetRange("No.", EconomicConditions."No.");
        Rec.FilterGroup(0);
    //KB14122023 - TASK002199 Disable Next and Previous Button ---
    end;
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
        ConfirmManagement: Codeunit "Confirm Management";
        ConfirmMsg: Label 'Changes have been made to the record.\ \Do you want to save the changes?';
    begin
        if EconomicConditions."Start Date" = 0D then EconomicConditions."Start Date":=Today;
        EconomicConditions.ValidateEconomicCondition();
        EconomicConditions2.SetRange("Contract No.", Rec."Contract No.");
        // AN 15122023 TASK002168  change of Customer +++
        if EconomicConditions2.FindLast()then if EconomicConditions2."Start Date" = 0D then EconomicConditions2.Delete();
        // AN 15122023 TASK002168 change of Customer ---
        if EconomicConditions2.FindLast()then begin
            if Format(EconomicConditions) <> Format(EconomicConditions2)then begin
                if ConfirmManagement.GetResponse(ConfirmMsg, false)then begin
                    InsertNewEconomicCondition();
                    EconomicConditions.PopulateEcoConPeriod();
                    EconomicConditions2.Validate("End Date", Today());
                    EconomicConditions2.Modify(true);
                //Commit();
                end;
            end
            else
                exit;
        end
        else
        begin
            InsertNewEconomicCondition();
            EconomicConditions.PopulateEcoConPeriod();
        end;
    end;
    var EconomicConditions: Record "Economic Condition";
    EconomicConditions2: Record "Economic Condition";
    Contract: Record Contract;
    ShowSecurityAmount: Boolean;
    //KB08012024 - Temporary data issue +++
    procedure GetEconomicRecord(): Record "Economic Condition" begin
        exit(EconomicConditions);
    end;
    //KB08012024 - Temporary data issue ---
    local procedure InsertNewEconomicCondition()
    var
        EconomicCondition: Record "Economic Condition";
    begin
        EconomicCondition.Copy(EconomicConditions);
        EconomicCondition."No.":=0;
        EconomicCondition.Insert(true);
        Contract.SetRange("No.", EconomicCondition."Contract No.");
        if Contract.FindFirst()then begin
            Contract."Economic Condition No.":=EconomicCondition."No.";
            Contract."Invoice Layout":=EconomicCondition."Invoice Layout";
            Contract.Validate("Contractual Power", EconomicCondition."Contractual Power");
            Contract.Validate("Available Power", EconomicCondition."Available Power");
            Contract.Validate("Voltage Type", EconomicCondition."Voltage Type");
            Contract.Validate(Voltage, EconomicCondition.Voltage);
            Contract.Validate("System Type", EconomicCondition."System Type");
            Contract.Validate("Tariff Option No.", EconomicCondition."Tariff Option No.");
            Contract.Validate("Tariff Option Name", EconomicCondition."Tariff Option Name");
            Contract.Validate("Annual Consumption", EconomicCondition."Annual Consumption");
            Contract.Validate("AUC Exempt", EconomicCondition."AUC Exempt");
            Contract.Validate("Excise Duties not Due", EconomicCondition."Excise Duties not Due");
            Contract.Validate("Limiter Present", EconomicCondition."Limiter Present");
            Contract.Validate(Resident, EconomicCondition.Resident);
            Contract.Validate(Farmer, EconomicCondition.Farmer);
            Contract.Validate("Security Deposit", EconomicCondition."Security Deposit");
            Contract.Validate("Security Deposit Amount", EconomicCondition."Security Deposit Amount");
            Contract.Validate("Economic Condition Start Date", EconomicCondition."Start Date");
            Contract.Validate("Economic Condition End Date", EconomicCondition."End Date");
            Contract.Modify();
            Commit();
        end;
        EconomicConditions.Copy(EconomicCondition);
        EconomicConditions.Modify(true)end;
    /// <summary>
    /// Sets the Contract No  for the Economic Conditions.
    /// </summary>
    /// <param name="ContractNo">Code[20].</param>
    /// <param name="PODNo">Code[20].</param>
    procedure SetContractNo(ContractNo: Code[25]; PODNo: Code[25])
    begin
        Rec."Contract No.":=ContractNo;
        Rec."POD No.":=PODNo;
        EconomicConditions."POD No.":=PODNo;
    end;
}
