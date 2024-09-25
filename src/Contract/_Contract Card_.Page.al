page 50201 "Contract Card"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = Contract;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Contract Card';

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
                    Caption = 'No.';
                    ApplicationArea = All;
                    Editable = false; //KB14122023 - TASK002199 Editable false 
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Customer No.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                        if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then begin
                            Customer.Get(Customer."No.");
                            Rec."Customer No.":=Customer."No.";
                            Rec."Customer Name":=Customer.Name;
                            Rec.GetBillingInformation(Customer);
                        end;
                        CurrPage.Update();
                    end;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Caption = 'Customer Name';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract Description"; Rec."Contract Description")
                {
                    ToolTip = 'Specifies the value of the Contract Description field.';
                    Caption = 'Contract Description';
                    ApplicationArea = All;
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ToolTip = 'Specifies the value of the Contract Start Date field.';
                    Caption = 'Contract Start Date';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ToolTip = 'Specifies the value of the Contract End Date field.';
                    Caption = 'Contract End Date';
                    ApplicationArea = All;
                }
                field("Activation Cause"; Rec."Activation Cause")
                {
                    ToolTip = 'Specifies the value of the Activation Cause field.';
                    Caption = 'Activiation Cause';
                    ApplicationArea = All;
                    Editable = DeveloperMode;
                }
                field("Deactivation Cause"; Rec."Deactivation Cause")
                {
                    ToolTip = 'Specifies the value of the Deactivation Cause field.';
                    Caption = 'Deactivation Cause';
                    ApplicationArea = All;
                    Editable = DeveloperMode;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Caption = 'Status';
                    ApplicationArea = All;
                    Editable = DeveloperMode;
                }
                field("Type of Renewal"; Rec."Type of Renewal")
                {
                    ToolTip = 'Specifies the value of the Type of Renewal field.';
                    Caption = 'Type of Renewal';
                    ApplicationArea = All;
                }
                field("Signature Date of Contract"; Rec."Signature Date of Contract")
                {
                    ToolTip = 'Specifies the value of the Signature Date of Contract field.';
                    Caption = 'Signature Date of Contract';
                    ApplicationArea = All;
                }
                field("Contract Printed"; Rec."Contract Printed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Printed field.';
                    Editable = DeveloperMode;
                }
                //KB12122023 - TASK002199 Switch In Field +++
                field("Switch In Date"; Rec."Switch In Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Switch In Date field.';
                }
                //KB12122023 - TASK002199 Switch In Field ---
                // AN 21112023 - TASK002127 field Added  ++
                field("Switch Out Date"; Rec."Switch Out Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Switch Out Date field.';
                    Caption = 'Switch Out Date';
                    Editable = false; //KB14122023 - TASK002199 Editable false  
                }
                // AN 21112023 - TASK002127 field Added  --
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the VAT Bus. Posting Groups field.';
                }
            }
            group("Contract Details")
            {
                Caption = 'Contract Details';

                field(Usage; Rec.Usage)
                {
                    ToolTip = 'Specifies the value of the Usage field.';
                    Caption = 'Usage';
                    ApplicationArea = All;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                    Caption = 'Contract Type';
                    ApplicationArea = All;
                }
                field(Market; Rec.Market)
                {
                    ToolTip = 'Specifies the value of the Market field.';
                    Caption = 'Market';
                    ApplicationArea = All;
                }
                field("Ateco Codex"; Rec."Ateco Codex")
                {
                    ToolTip = 'Specifies the value of the Ateco Codex field.';
                    Caption = 'Ateco Codex';
                    ApplicationArea = All;
                }
                field("Communication Langauge"; Rec."Communication Langauge")
                {
                    ToolTip = 'Specifies the value of the Communication Language field.';
                    Caption = 'Communication Langauge';
                    ApplicationArea = All;
                }
                field(DATI_FATTI; Rec.DATI_FATTI)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DATI_FATTI field.';
                }
                field("INTERROMPABILITà"; Rec."INTERROMPABILITà")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the INTERROMPABILITà field.';
                }
                field(APPARATO_MEDICALE; Rec.APPARATO_MEDICALE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the APPARATO_MEDICALE field.';
                }
                field("CATEGORIA MERCEOLOGICA"; Rec."CATEGORIA MERCEOLOGICA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CATEGORIA MERCEOLOGICA field.';
                }
                field("Quadro Code"; Rec."Quadro Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quadro Code field.';
                }
                field("Quadro LB5"; Rec."Quadro LB5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quadro LB5 field.', Comment = '%';
                }
                field("Quadro LB6"; Rec."Quadro LB6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quadro LB6 field.', Comment = '%';
                }
                field("Quadro M3"; Rec."Quadro M3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Annual Quadro M3 field.', Comment = '%';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';

                field("Tel. No."; Rec."Tel. No.")
                {
                    ToolTip = 'Specifies the value of the Tel. No. field.';
                    Caption = 'Tel. No';
                    ApplicationArea = All;
                }
                field("Cell. No."; Rec."Cell. No.")
                {
                    ToolTip = 'Specifies the value of the Cell. No. field.';
                    Caption = 'Cell. No.';
                    ApplicationArea = All;
                }
                field("Certified E-Mail"; Rec."Certified E-Mail")
                {
                    ToolTip = 'Specifies the value of the Certified E-Mail field.';
                    Caption = 'Certified E-Mail';
                    ApplicationArea = All;
                }
                field(Email; Rec.Email)
                {
                    ToolTip = 'Specifies the value of the Email field.';
                    Caption = 'Email';
                    ApplicationArea = All;
                }
                group(Invoicing)
                {
                    Caption = 'Invoicing';

                    field("Payment Terms"; Rec."Payment Terms")
                    {
                        ToolTip = 'Specifies the value of the Payment Terms field.';
                        Caption = 'Payment Terms';
                        ApplicationArea = All;
                    }
                    // AN 06122023 - TASK002140- Removed this field as it is not necessary ++
                    field("Invoicing Group"; Rec."Invoicing Group")
                    {
                        ToolTip = 'Specifies the value of the Invoicing Group field.';
                        Caption = 'Invoicing Group';
                        ApplicationArea = All;
                        Visible = false;
                    }
                    // AN 06122023 - TASK002140- Removed this field as it is not necessary --
                    field("Last Billed Reading"; Rec."Last Billed Reading")
                    {
                        ToolTip = 'Specifies the value of the Last Billed Reading field.';
                        Caption = 'Last Billed Reading';
                        ApplicationArea = All;
                    }
                    field("Billing Suspension"; Rec."Billing Suspension")
                    {
                        ToolTip = 'Specifies the value of the Billing Suspension field.';
                        Caption = 'Billing Supension';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Rec."Billing Suspension" = true then begin
                                ShowBillingSuspension:=true;
                                CurrPage.Update(true);
                            end
                            else if Rec."Billing Suspension" = false then begin
                                    ShowBillingSuspension:=false;
                                    CurrPage.Update(true);
                                end;
                        end;
                    }
                    group("Billing Suspension Grp")
                    {
                        ShowCaption = false;
                        Visible = ShowBillingSuspension;

                        field("Reason for Suspension"; Rec."Reason for Suspension")
                        {
                            ToolTip = 'Specifies the value of the Reason for Suspension field.';
                            Caption = 'Reason for Suspension';
                            ApplicationArea = All;
                        }
                        field("Suspended By"; Rec."Suspended By")
                        {
                            ToolTip = 'Specifies the value of the Suspended By field.';
                            Caption = 'Suspended By';
                            ApplicationArea = All;
                        }
                    }
                    group(Control67)
                    {
                        ShowCaption = false;

                        field("Bill-to Toponym"; Rec."Bill-to Toponym")
                        {
                            ToolTip = 'Specifies the value of the Bill-to Toponym field.';
                            // AssistEdit = true;
                            Caption = 'Bill-to Toponym';
                            ApplicationArea = All;
                        }
                        field("AAT Bill-to CIV PUB"; Rec."AAT Bill-to CIV PUB")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Bill-to CIV field.';
                        }
                        field("Bill-to Address"; Rec."Bill-to Address")
                        {
                            ToolTip = 'Specifies the value of the Bill-to Address field.';
                            Caption = 'Bill-to Address';
                            ApplicationArea = All;
                        }
                        field("Bill-to Address 2"; Rec."Bill-to Address 2")
                        {
                            ToolTip = 'Specifies the value of the Bill-to Address 2 field.';
                            Caption = 'Bill-to Address 2';
                            ApplicationArea = All;
                        }
                        field("Bill-to City"; Rec."Bill-to City")
                        {
                            ToolTip = 'Specifies the value of the Bill-to City field.';
                            Caption = 'Bill-to City';
                            ApplicationArea = All;
                        }
                        field("Bill-to Post Code"; Rec."Bill-to Post Code")
                        {
                            ToolTip = 'Specifies the value of the Bill-to Post Code field.';
                            Caption = 'Bill-to Post Code';
                            ApplicationArea = All;
                        }
                        field("Bill-to County Code"; Rec."Bill-to County Code")
                        {
                            ToolTip = 'Specifies the value of the Bill-to County Code field.';
                            Caption = 'Bill-to County';
                            ApplicationArea = All;
                        }
                        field("Bill-to Country"; Rec."Bill-to Country")
                        {
                            ToolTip = 'Specifies the value of the Bill-to Country field.';
                            Caption = 'Bill-to Country';
                            ApplicationArea = All;
                        }
                        field("Bill-to ISTAT Code"; Rec."Bill-to ISTAT Code")
                        {
                            ToolTip = 'Specifies the value of the Bill-to ISTAT Code field.';
                            Caption = 'Bill-to ISTAT Code';
                            ApplicationArea = All;
                        }
                    }
                }
                group(Administration)
                {
                    Caption = 'Administration';

                    field("Office Code"; Rec."Office Code")
                    {
                        ToolTip = 'Specifies the value of the Office Code field.';
                        Caption = 'Office Code';
                        ApplicationArea = All;
                    }
                    field(Holder; Rec.Holder)
                    {
                        ToolTip = 'Specifies the value of the Holder field.';
                        Caption = 'Holder';
                        ApplicationArea = All;
                    }
                    field("Distribution of Bill"; Rec."Distribution of Bill")
                    {
                        ToolTip = 'Specifies the value of the Distribution of Bill field.';
                        Caption = 'Distribution of Bill';
                        ApplicationArea = All;
                    }
                    field(CIG; Rec.CIG)
                    {
                        ToolTip = 'Specifies the value of the CIG field.';
                        Caption = 'CIG';
                        ApplicationArea = All;
                    }
                    field(CUP; Rec.CUP)
                    {
                        ToolTip = 'Specifies the value of the CUP field.';
                        Caption = 'CUP';
                        ApplicationArea = All;
                    }
                    field(Payment; Rec.Payment)
                    {
                        ToolTip = 'Specifies the value of the Payment field.';
                        Caption = 'Payment';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            if Rec.Payment = Rec.Payment::"Bank Transfer" then ShowDirectDebit:=false;
                            if Rec.Payment = Rec.Payment::"Direct Debt" then ShowDirectDebit:=true;
                            if Rec.Payment = Rec.Payment::" " then ShowDirectDebit:=false;
                        end;
                    }
                    group("Direct Debit")
                    {
                        Visible = ShowDirectDebit;
                        Caption = 'Direct Debit';

                        field(IBAN; Rec.IBAN)
                        {
                            ToolTip = 'Specifies the value of the IBAN field.';
                            Caption = 'IBAN';
                            ApplicationArea = All;
                        }
                        field(Bank; Rec.Bank)
                        {
                            ToolTip = 'Specifies the value of the Bank field.';
                            Caption = 'Bank';
                            ApplicationArea = All;
                        }
                        field("BIC"; Rec."BIC")
                        {
                            ToolTip = 'Specifies the value of the BIC field.';
                            Caption = 'BIC';
                            ApplicationArea = All;
                        }
                        field("Activiation Code"; Rec."Activiation Code")
                        {
                            ToolTip = 'Specifies the value of the Activiation Code field.';
                            Caption = 'Activation Code';
                            ApplicationArea = All;
                        }
                        field("Direct Debt No."; Rec."Direct Debt No.")
                        {
                            ToolTip = 'Specifies the value of the Direct Debt No. field.';
                            Caption = 'Direct Debt No.';
                            ApplicationArea = All;
                        }
                        field("Scheme of SDD"; Rec."Scheme of SDD")
                        {
                            ToolTip = 'Specifies the value of the Scheme of SDD field.';
                            Caption = 'Scheme of SDD';
                            ApplicationArea = All;
                        }
                        field("Classification Account"; Rec."Classification Account")
                        {
                            ToolTip = 'Specifies the value of the Classification Account field.';
                            Caption = 'Classification Account';
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(POD)
            {
                Caption = 'POD';

                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Editable = true;
                    ShowMandatory = true;
                    Caption = 'POD No.';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        CurrPage.Update();
                    end;
                }
                field("POD Cost"; Rec."POD Cost")
                {
                    Editable = false;
                    Caption = 'POD Cost';
                    ToolTip = 'Specifies the value of the POD Cost field.';
                    ApplicationArea = All;
                }
                group(Control11)
                {
                    ShowCaption = false;

                    field("Physical Toponym"; Rec."Physical Toponym")
                    {
                        ToolTip = 'Specifies the value of the Physical Toponym field.';
                        Editable = false;
                        Caption = 'Physical Toponym';
                        ApplicationArea = All;
                    }
                    field("AAT Physical CIV PUB"; Rec."AAT Physical CIV PUB")
                    {
                        ApplicationArea = All;
                        Editable = false; //KB14122023 - TASK002199 Editable false 
                        ToolTip = 'Specifies the value of the Physical CIV field.';
                    }
                    field("Physical Address"; Rec."Physical Address")
                    {
                        ToolTip = 'Specifies the value of the Physical Address field.';
                        Editable = false;
                        Caption = 'Physical Address';
                        ApplicationArea = All;
                    }
                    field("Physical Address 2"; Rec."Physical Address 2")
                    {
                        ToolTip = 'Specifies the value of the Physical Address 2 field.';
                        Editable = false;
                        Caption = 'Physical Address 2';
                        ApplicationArea = All;
                    }
                    field("Physical City"; Rec."Physical City")
                    {
                        ToolTip = 'Specifies the value of the Physical City field.';
                        Editable = false;
                        Caption = 'Physical City';
                        ApplicationArea = All;
                    }
                    field("Physical Post Code"; Rec."Physical Post Code")
                    {
                        ToolTip = 'Specifies the value of the Physical Post Code field.';
                        Editable = false;
                        Caption = 'Physical Post Code';
                        ApplicationArea = All;
                    }
                    field("Physical County Code"; Rec."Physical County Code")
                    {
                        ToolTip = 'Specifies the value of the Physical County Code field.';
                        Editable = false;
                        Caption = 'Physical Province';
                        ApplicationArea = All;
                    }
                    field("Physical Country Code"; Rec."Physical Country Code")
                    {
                        ToolTip = 'Sfpecifies the value of the Physical Country Code field.';
                        Editable = false;
                        Caption = 'Physical Country Code';
                        ApplicationArea = All;
                    }
                    field("ISTAT Code"; Rec."ISTAT Code")
                    {
                        ToolTip = 'Specifies the value of the ISTAT Code field.';
                        Editable = false;
                        Caption = 'ISTAT Code';
                        ApplicationArea = All;
                    }
                }
            }
            group("Economic Condition")
            {
                Caption = 'Economic Condition';

                field("Economic Condition Start Date"; Rec."Economic Condition Start Date")
                {
                    ToolTip = 'Specifies the value of the Economic Condition Start Date field.';
                    AssistEdit = true;
                    Caption = 'Start Date';
                    Editable = false;
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if Rec.Modify(true)then;
                        CurrPage.SaveRecord();
                        Clear(EconomicConditionCard);
                        EconomicConditions.SetRange("Contract No.", Rec."No.");
                        if EconomicConditions.IsEmpty()then begin
                            EconomicConditions.Init();
                            EconomicConditions."No.":=0;
                            EconomicConditions."Contract No.":=Rec."No.";
                            EconomicConditions."POD No.":=Rec."POD No.";
                            if Rec."Contract Type" = Rec."Contract Type"::"01" then EconomicConditions.Resident:=true
                            else
                                EconomicConditions.Resident:=false;
                            EconomicConditions.Validate("Seller Name", Rec."Customer Name");
                            EconomicConditions.Validate(Typology, "Typology Option"::Domestic);
                            EconomicConditions.Insert(true);
                        end
                        else
                        begin
                            if EconomicConditions.FindSet()then repeat if Rec."Contract Type" = Rec."Contract Type"::"01" then EconomicConditions.Resident:=true
                                    else
                                        EconomicConditions.Resident:=false;
                                    EconomicConditions.Validate("Seller Name", Rec."Customer Name");
                                    EconomicConditions.Validate(Typology, "Typology Option"::Domestic);
                                    EconomicConditions.Modify(true);
                                until EconomicConditions.Next() = 0;
                        end;
                        EconomicConditionCard.SetRecord(EconomicConditions);
                        EconomicConditionCard.LookupMode(true);
                        //Commit before RunModal
                        Commit();
                        //KB08012024 - Temporary data issue +++
                        if EconomicConditionCard.RunModal() = Action::LookupOK then begin
                            EconomicConditions:=EconomicConditionCard.GetEconomicRecord();
                            if Rec."Contract Type" = Rec."Contract Type"::"01" then EconomicConditions.TestField(Resident, true)
                            else
                                EconomicConditions.TestField(Resident, false);
                            Rec."Economic Condition No.":=EconomicConditions."No.";
                            Rec."Invoice Layout":=EconomicConditions."Invoice Layout";
                            Rec.Validate("Contractual Power", EconomicConditions."Contractual Power");
                            Rec.Validate("Available Power", EconomicConditions."Available Power");
                            Rec.Validate("Voltage Type", EconomicConditions."Voltage Type");
                            Rec.Validate(Voltage, EconomicConditions.Voltage);
                            Rec.Validate("System Type", EconomicConditions."System Type");
                            Rec.Validate("Tariff Option No.", EconomicConditions."Tariff Option No.");
                            Rec.Validate("Tariff Option Name", EconomicConditions."Tariff Option Name");
                            Rec.Validate("Annual Consumption", EconomicConditions."Annual Consumption");
                            Rec.Validate("AUC Exempt", EconomicConditions."AUC Exempt");
                            Rec.Validate("Excise Duties not Due", EconomicConditions."Excise Duties not Due");
                            Rec.Validate("Limiter Present", EconomicConditions."Limiter Present");
                            Rec.Validate(Resident, EconomicConditions.Resident);
                            Rec.Validate(Farmer, EconomicConditions.Farmer);
                            Rec.Validate("Security Deposit", EconomicConditions."Security Deposit");
                            Rec.Validate("Security Deposit Amount", EconomicConditions."Security Deposit Amount");
                            Rec.Validate("Economic Condition Start Date", EconomicConditions."Start Date");
                            Rec.Validate("Economic Condition End Date", EconomicConditions."End Date");
                            Rec.Validate("Billing Interval", EconomicConditions."Billing Interval");
                            if Rec.IsTemporary then Rec.Modify();
                        end;
                    //KB08012024 - Temporary data issue ---
                    end;
                }
                field("Economic Condition End Date"; Rec."Economic Condition End Date")
                {
                    ToolTip = 'Specifies the value of the Economic Condition End Date field.';
                    Caption = 'End Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Invoice Layout"; Rec."Invoice Layout")
                {
                    ToolTip = 'Specifies the value of the Invoice Layout field.';
                    Editable = false;
                    Caption = 'Invoice Layout';
                    ApplicationArea = All;
                }
                field("Contractual Power"; Rec."Contractual Power")
                {
                    ToolTip = 'Specifies the value of the Contractual Power field.';
                    Editable = false;
                    Caption = 'Contractual Power';
                    ApplicationArea = All;
                }
                field("Available Power"; Rec."Available Power")
                {
                    ToolTip = 'Specifies the value of the Available Power field.';
                    Editable = false;
                    Caption = 'Available Power';
                    ApplicationArea = All;
                }
                field("Billing Interval"; Rec."Billing Interval")
                {
                    ToolTip = 'Specifies the value of the Billing Interval field.';
                    Caption = 'Billing Interval';
                    ApplicationArea = All;
                }
                field("Voltage Tpye"; Rec."Voltage Type")
                {
                    ToolTip = 'Specifies the value of the Voltage Tpye field.';
                    Editable = false;
                    Caption = 'Voltage Type';
                    ApplicationArea = All;
                }
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                    Editable = false;
                    Caption = 'Voltage';
                    ApplicationArea = All;
                }
                field("System Type"; Rec."System Type")
                {
                    ToolTip = 'Specifies the value of the System Type field.';
                    Editable = false;
                    Caption = 'System Type';
                    ApplicationArea = All;
                }
                field("Reduced VAT"; Rec."Reduced VAT")
                {
                    ToolTip = 'Specifies the value of the Reduced VAT field.';
                    Editable = false;
                    Caption = 'Reduced VAT';
                    ApplicationArea = All;
                }
                field("Tariff Option No."; Rec."Tariff Option No.")
                {
                    ToolTip = 'Specifies the value of the Tariff Option No. field.';
                    Editable = false;
                    Caption = 'Tariff Option No.';
                    ApplicationArea = All;
                }
                field("Tariff Option Name"; Rec."Tariff Option Name")
                {
                    ToolTip = 'Specifies the value of the Tariff Option Name field.';
                    Editable = false;
                    Caption = 'Tariff Option Name';
                    ApplicationArea = All;
                }
                field("Anual Consumption"; Rec."Annual Consumption")
                {
                    ToolTip = 'Specifies the value of the Anual Consumption field.';
                    Editable = false;
                    Caption = 'Annual Consumption';
                    ApplicationArea = All;
                }
                field("AUC Exempt"; Rec."AUC Exempt")
                {
                    ToolTip = 'Specifies the value of the AUC Exempt field.';
                    Editable = false;
                    Caption = 'AUC Exempt';
                    ApplicationArea = All;
                }
                field("Excise Duties not Due"; Rec."Excise Duties not Due")
                {
                    ToolTip = 'Specifies the value of the Excise Duties not Due field.';
                    Editable = false;
                    Caption = 'Excise Duties not Due';
                    ApplicationArea = All;
                }
                field("Limiter Present"; Rec."Limiter Present")
                {
                    ToolTip = 'Specifies the value of the Limiter Present field.';
                    Editable = false;
                    Caption = 'Limiter Present';
                    ApplicationArea = All;
                }
                field(Resident; Rec.Resident)
                {
                    ToolTip = 'Specifies the value of the Resident field.';
                    Editable = false;
                    Caption = 'Resident';
                    ApplicationArea = All;
                }
                field(Farmer; Rec.Farmer)
                {
                    ToolTip = 'Specifies the value of the Farmer field.';
                    Editable = false;
                    Caption = 'Farmer';
                    ApplicationArea = All;
                }
                field("Security Deposit"; Rec."Security Deposit")
                {
                    ToolTip = 'Specifies the value of the Security Deposit field.';
                    Editable = false;
                    Caption = 'Security Deposit';
                    ApplicationArea = All;
                }
                group("Security Deposit Grp")
                {
                    Visible = ShowSecurityAmount;
                    Caption = 'Security Deposit Grp';

                    field("Security Deposit Amount"; Rec."Security Deposit Amount")
                    {
                        ToolTip = 'Specifies the value of the Security Deposit Amount field.';
                        Editable = false;
                        Visible = true;
                        Caption = 'Security Deposit Amount';
                        ApplicationArea = All;
                    }
                }
            }
            group("Cadastral Data")
            {
                Caption = 'Cadastral Data';

                field("Cadastral Data Start Date"; Rec."Cadastral Data Start Date")
                {
                    ToolTip = 'Specifies the value of the Cadastral Data Start Date field.';
                    AssistEdit = true;
                    Caption = 'Start Date';
                    Editable = false;
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        CurrPage.SaveRecord();
                        Clear(CadastralDataCard);
                        CadastralData.SetRange("Contract No.", Rec."No.");
                        if CadastralData.IsEmpty()then begin
                            CadastralData."No.":=0;
                            CadastralData."Contract No.":=Rec."No.";
                            CadastralData."POD No.":=Rec."POD No.";
                            CadastralData.Insert(true);
                        end;
                        CadastralData.SetRange("Contract No.", Rec."No.");
                        if CadastralData.FindFirst()then CadastralDataCard.SetRecord(CadastralData);
                        //Commit before RunModal
                        Commit();
                        //KB08012024 - Temporary data issue +++
                        CadastralDataCard.LookupMode(true);
                        if CadastralDataCard.RunModal() = Action::LookupOK then begin
                            CadastralData:=CadastralDataCard.GetCadestralData();
                            Rec."Municipality Comm. Date":=CadastralData."Municipality Comm. Date";
                            Rec."Property Type":=CadastralData."Property Type";
                            Rec.Validate("Concession Building", CadastralData."Concession Building");
                            Rec.Validate("Cadastral Municipality Code", CadastralData."Cadastral Municipality Code");
                            Rec.Validate("Admin. Municipality Code", CadastralData."Admin. Municipality Code");
                            Rec.Validate("Cadastral Data No.", CadastralData."No.");
                            Rec.Validate(Section, CadastralData.Section);
                            Rec.Validate(Sheet, CadastralData.Sheet);
                            Rec.Validate(Particle, CadastralData.Particle);
                            Rec.Validate("Particle Extension", CadastralData."Partice Extension");
                            Rec.Validate(Subordinate, CadastralData.Subordinate);
                            Rec.Validate("Absense of Cadastral Data", CadastralData."Absense of Cadastral Data");
                            Rec.Validate("Cadastral Data Start Date", CadastralData."Start Date");
                            Rec.Validate("Cadastral Data End Date", CadastralData."End Date");
                            Rec.Validate("Reason for Absence", CadastralData."Reason for Absence");
                            Rec.Validate("Particle Type", CadastralData."Particle Type");
                            if Rec.IsTemporary then Rec.Modify();
                        end;
                    //KB08012024 - Temporary data issue ---
                    end;
                }
                field("Cadastral Data End Date"; Rec."Cadastral Data End Date")
                {
                    ToolTip = 'Specifies the value of the Cadastral Data End Date field.';
                    Caption = 'End Date';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Municipality Comm. Date"; Rec."Municipality Comm. Date")
                {
                    ToolTip = 'Specifies the value of the Municipality Comm. Date field.';
                    Editable = false;
                    Caption = 'Municipality Comm. Date';
                    ApplicationArea = All;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ToolTip = 'Specifies the value of the Property Type field.';
                    Editable = false;
                    Caption = 'Property Type';
                    ApplicationArea = All;
                }
                field("Concession Building"; Rec."Concession Building")
                {
                    ToolTip = 'Specifies the value of the Concession Building field.';
                    Editable = false;
                    Caption = 'Concession Building';
                    ApplicationArea = All;
                }
                field("Cadastral Municipality Code"; Rec."Cadastral Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Cadastral Municipality Code field.';
                    Editable = false;
                    Caption = 'Cadastral Municpality Code';
                    ApplicationArea = All;
                }
                field("Admin. Municipality Code"; Rec."Admin. Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Admin. Municipality Code field.';
                    Editable = false;
                    Caption = 'Admin. Municipality Code';
                    ApplicationArea = All;
                }
                field(Section; Rec.Section)
                {
                    ToolTip = 'Specifies the value of the Section field.';
                    Editable = false;
                    Caption = 'Section';
                    ApplicationArea = All;
                }
                field(Sheet; Rec.Sheet)
                {
                    ToolTip = 'Specifies the value of the Sheet field.';
                    Editable = false;
                    Caption = 'Sheet';
                    ApplicationArea = All;
                }
                field(Particle; Rec.Particle)
                {
                    ToolTip = 'Specifies the value of the Particle field.';
                    Editable = false;
                    Caption = 'Particle';
                    ApplicationArea = All;
                }
                field("Particle Type"; Rec."Particle Type")
                {
                    ToolTip = 'Specifies the value of the Particle Type field.';
                    Editable = false;
                    Caption = 'Particle Type';
                    ApplicationArea = All;
                }
                field("Particle Extension"; Rec."Particle Extension")
                {
                    ToolTip = 'Specifies the value of the Particle Extension field.';
                    Editable = false;
                    Caption = 'Particle Extension';
                    ApplicationArea = All;
                }
                field(Subordinate; Rec.Subordinate)
                {
                    ToolTip = 'Specifies the value of the Subordinate field.';
                    Editable = false;
                    Caption = 'Subordinate';
                    ApplicationArea = All;
                }
                field("Absense of Cadastral Data"; Rec."Absense of Cadastral Data")
                {
                    ToolTip = 'Specifies the value of the Absense of Cadastral Data field.';
                    Editable = false;
                    Caption = 'Absense of Cadastral Data';
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        ShowReasonofAbsence:=Rec."Absense of Cadastral Data";
                        if not ShowReasonofAbsence then Clear(Rec."Reason for Absence");
                    end;
                }
                field("Reason for Absence"; Rec."Reason for Absence")
                {
                    ToolTip = 'Specifies the value of the Reason for Absence field.';
                    Editable = false;
                    Caption = 'Reason for Absence';
                    Visible = ShowReasonofAbsence;
                    ApplicationArea = All;
                }
            }
            group("Discount Selection")
            {
                Caption = 'Discount Selection Lines';

                part(Control1; "Discount Selection List")
                {
                    SubPageLink = "Contract No."=field("No.");
                    Caption = 'Discount Selection Line Subform';
                    ApplicationArea = all;
                }
            }
            group("Disc. Reduction Lines")
            {
                Caption = 'Disc. Reduction Lines';

                part(Control2; "Disc. Reduction Line Subform")
                {
                    SubPageLink = "Contract No."=field("No.");
                    Caption = 'Disc. Reduction Line Subform';
                    ApplicationArea = All;
                }
            }
            group("Additional Charges")
            {
                Caption = 'Additional Charges';

                part(Control99; "Additional Charges Subform")
                {
                    SubPageLink = "Contract No."=field("No.");
                    Caption = 'Additional Charges Subform';
                    ApplicationArea = All;
                }
            }
            group("Sales Invoices")
            {
                Caption = 'Sales Invoices';

                part(SalesInvoices; "Contract Sales Invoices")
                {
                    Editable = false;
                    SubPageLink = "Document Type"=const(Invoice), "Contract No."=field("No."); //KB15122023 - TASK002199 Subpage Link Property change
                    Caption = 'Contract Sales Invoices';
                    ApplicationArea = All;
                }
            }
            group("Posted Sales Invoices")
            {
                Caption = 'Posted Sales Invoices';

                part(PostedSalesInvoices; "Contract Posted Sales Invoices")
                {
                    Editable = false;
                    SubPageLink = "Contract No."=field("No."); //KB15122023 - TASK002199 Subpage Link Property change
                    Caption = 'Contract Posted Sales Invoices';
                    ApplicationArea = All;
                }
            }
            group("Tariff Price Groups")
            {
                Caption = 'Tariff Price Groups';

                part(Control105; "Customer Tariff Price Groups")
                {
                    Editable = false;
                    Caption = 'Customer Tariff Price Groups';
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Physical Contract';
                SubPageLink = "Table ID"=const(Database::Contract), "No."=field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(DeleteContract) // For testing purposes
            {
                ApplicationArea = All;
                Caption = 'Delete Contract';
                ToolTip = 'Only for testing Purposes';
                Enabled = DeveloperMode;
                Image = Delete;

                trigger OnAction()
                begin
                    Rec.Delete()end;
            }
            action("Activate Contract")
            {
                ToolTip = 'Specifies the value of the Activate Contract Action';
                Caption = 'Activate Contract';
                Image = Administration;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ConfirmManagement: Codeunit "Confirm Management";
                    CanceledMsg: Label 'Activation Canceled';
                    ConfirmMsg: Label 'By activating the contract you acknowledge the following:\\1. The physical contract was signed by the customer and attatched to the contract in Business Central.\\2. The inserted POD, Meter and tarif information is correct.\\\Would you like to activate this contract?';
                    NotPrintedErr: Label 'Physical Contract has not been Printed';
                    SuccessMsg: Label 'Contract has been successfully activated';
                    WrongStatusErr: Label 'Contract not in registration';
                    ActivationCauseErr: Label 'Contract not in Activation process';
                begin
                    if Rec."Activation Cause" <> Rec."Activation Cause"::Activation then Error(ActivationCauseErr);
                    if not Rec."Contract Printed" then Error(NotPrintedErr);
                    if Rec.Status.AsInteger() <> "Contract Status"::"In Registration".AsInteger()then Error(WrongStatusErr);
                    if Rec.ValidateContractInformation()then begin
                        if not ConfirmManagement.GetResponse(ConfirmMsg, false)then Error(CanceledMsg);
                        Rec.Validate(Status, "Contract Status"::Open);
                        if Rec.Modify(true)then Message(SuccessMsg);
                    end;
                end;
            }
            action("Deactivate Contract")
            {
                ApplicationArea = All;
                Caption = 'Deactivate Contract';
                ToolTip = 'Deactivates current contract';
                Image = Close;

                trigger OnAction()
                begin
                    if(Rec.Status.AsInteger() <> "Contract Status"::Open.AsInteger())then Error(ValidStatusErr);
                    if Rec.DeactivationValidation()then Rec.Validate(Status, "Contract Status"::Closed);
                    CurrPage.Update();
                end;
            }
            action("Generate Invoice")
            {
                Image = Invoice;
                Caption = 'Generate Invoice';
                ToolTip = 'Executes the Generate Invoice action.';
                ApplicationArea = all;

                trigger OnAction()
                var
                    InvoiceGenerationManagement: Codeunit "Invoice Generation Management";
                begin
                    InvoiceGenerationManagement.SelectContractsForInvoicingNew(Rec."No.");
                end;
            }
            // AN 24112023 
            group("SII Interface")
            {
                Caption = 'SII Interface';

                action("Terminate Contract")
                {
                    ApplicationArea = All;
                    Caption = 'Terminate Contract';
                    ToolTip = 'Start Contract termination process';
                    Image = TerminationDescription;

                    trigger OnAction()
                    var
                        ContractTermination: Page "Contract Termination";
                    begin
                        ContractTermination.SetRecord(Rec);
                        ContractTermination.RunModal();
                    end;
                }
                action("Export Anagraphic Data")
                {
                    ToolTip = 'Export AE1.0050';
                    Caption = '';
                    ApplicationArea = All;
                    Image = Export;

                    trigger OnAction()
                    var
                        Contract: Record Contract;
                        ChangeOfAnagraphicDataMgt: Codeunit "Change of Anagraphic Data Mgt.";
                        FileName: Text;
                    begin
                        FileName:='';
                        Contract.SetRange("No.", Rec."No.");
                        if Contract.FindFirst()then ChangeOfAnagraphicDataMgt.NewChangeOfAnagraphicData(Contract, FileName);
                    end;
                }
                action("Switch Out")
                {
                    ToolTip = 'Start Switch Out process';
                    Caption = '';
                    ApplicationArea = All;
                    Image = FileContract;

                    trigger OnAction()
                    var
                        Customer: Record Customer;
                        ConfirmManagement: Codeunit "Confirm Management";
                        SwitchOutManagement: Codeunit "Switch Out Management";
                        CancelationLbl: Label 'Switch Out Canceled';
                        ConfirmMessageLbl: Label 'By Switching out the customer you acknowledge the following: \\ 1. The latest measurements for the contract have been imported to Business Central \\ 2. The latest Invoice for this contract has been generated and sent to the client. \\ Would you like to Switch out this Client?';
                    begin
                        if(Rec.Status.AsInteger() <> "Contract Status"::Open.AsInteger())then Error(ValidStatusErr);
                        if not ConfirmManagement.GetResponse(ConfirmMessageLbl, false)then Error(CancelationLbl);
                        if Customer.Get(Rec."Customer No.")then SwitchOutManagement.NewSwitchOutProcess(Customer, Rec);
                    end;
                }
                action("Change of Customer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Export VT1.0050 for Change of Customer process';
                    Caption = 'Change of Customer';
                    Image = Export;

                    trigger OnAction()
                    var
                        Contract: Record Contract;
                        ChangeofCustomerMgt: Codeunit "Change of Customer Management";
                    begin
                        if(Rec.Status.AsInteger() >= "Contract Status"::Open.AsInteger())then Error(ValidStatusErr);
                        Contract.SetRange("No.", Rec."No.");
                        if Contract.FindSet()then ChangeofCustomerMgt.NewChangeofCustomer(Contract, '');
                    end;
                }
                action("Switch In")
                {
                    ApplicationArea = All;
                    ToolTip = 'Export SE1.0050 for switch in process';
                    Caption = 'Switch In';
                    Image = Export;

                    trigger OnAction()
                    var
                        Contract: Record Contract;
                        SwitchInManagement: Codeunit "Switch In Management";
                        Filename: Text;
                        ContractNotPrintErrorLbl: Label 'Contract not printed.';
                    begin
                        if not(Rec.Status.AsInteger() = "Contract Status"::"In Registration".AsInteger())then Error(ValidStatusErr);
                        if not Rec."Contract Printed" then Error(ContractNotPrintErrorLbl);
                        Contract.SetRange("No.", Rec."No.");
                        if Contract.FindFirst()then begin
                            Filename:='';
                            if Contract.ValidateContractInformation()then SwitchInManagement.NewSwitchInProcess(Contract, Filename, false, false);
                        end;
                    end;
                }
            }
            Action("Import File")
            {
                ToolTip = 'Import VT10100 File for Activation';
                Caption = '';
                ApplicationArea = All;
                Image = FileContract;

                trigger OnAction()
                var
                    CSVImportManager: Codeunit "CSV Import Manager";
                begin
                    CSVImportManager.CSVFileManager();
                end;
            }
            //KB20112023 - TASK002131 New Activation Process +++
            action("Export New Activation")
            {
                ApplicationArea = All;
                ToolTip = 'Export PN1.0050 for New Activation process';
                Caption = 'Export New Activation';
                Image = Export;

                trigger OnAction()
                var
                    SIILogEntries: Record "SII Log Entries";
                    NewActivationExportMgmt: Codeunit ImportExportManagerActivate;
                    ErrorLbl: Label 'SII Log Entries not Inserted for New Activation';
                begin
                    SIILogEntries.Reset();
                    SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
                    SIILogEntries.SetRange("Contract No.", Rec."No.");
                    SIILogEntries.SetRange(Status, "AAT Log Status SII"::"Exported PN1.0050");
                    if SIILogEntries.FindFirst()then NewActivationExportMgmt.ExportPN10050File(Rec, SIILogEntries."CP User", SIILogEntries."New Activation Notes")
                    else
                        Error(ErrorLbl);
                end;
            }
            action("Export Activation for POD Installation")
            {
                ApplicationArea = All;
                ToolTip = 'Export E01.0050 for New Activation process';
                Caption = 'Export Activation for POD Installation';
                Image = Export;

                trigger OnAction()
                var
                    SIILogEntries: Record "SII Log Entries";
                    ActivationDataMgmt: Codeunit ActivationDataMgmt;
                    ErrorLbl: Label 'SII Log Entries is not verified for New Activation';
                begin
                    SIILogEntries.Reset();
                    SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
                    SIILogEntries.SetRange("Contract No.", Rec."No.");
                    SIILogEntries.SetRange(Status, "AAT Log Status SII"::"Imported File PN1.0150");
                    if SIILogEntries.FindFirst()then ActivationDataMgmt.ChangeOfNewActivationDataAfterPODInstallation(Rec)
                    else
                        Error(ErrorLbl);
                end;
            }
            action("Export For POD Activation")
            {
                ApplicationArea = All;
                ToolTip = 'Export A01.0050 for New Activation process';
                Caption = 'Export for POD Activation';
                Image = Export;

                trigger OnAction()
                var
                    SIILogEntries: Record "SII Log Entries";
                    ActivationDataMgmt: Codeunit ActivationDataMgmt;
                    ErrorLbl: Label 'SII Log Entries is not verified for POD Installation';
                begin
                    SIILogEntries.Reset();
                    SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
                    SIILogEntries.SetRange("Contract No.", Rec."No.");
                    SIILogEntries.SetRange(Status, "AAT Log Status SII"::"Imported File E01.0150");
                    if SIILogEntries.FindFirst()then ActivationDataMgmt.ChangeOfPODActivationData(Rec)
                    else
                        Error(ErrorLbl);
                end;
            }
            action("Export Activation File for Rejection")
            {
                ApplicationArea = All;
                ToolTip = 'Export PM1.0050 for New Activation process';
                Caption = 'Export Activation File for Rejectionn';
                Image = Export;

                trigger OnAction()
                var
                    SIILogEntries: Record "SII Log Entries";
                    ImportExportManagerActivate: Codeunit ImportExportManagerActivate;
                    MessageLbl: Label 'The following file has been exported: %1 for CP User %2', Locked = true;
                begin
                    ImportExportManagerActivate.ExportPM10050File(Rec, SIILogEntries."CP User");
                    Message(StrSubstNo(MessageLbl, 'PM1.0050', SIILogEntries."CP User"));
                end;
            }
            //KB20112023 - TASK002131 New Activation Process ---
            Action("Show Detailed SII Entries")
            {
                ToolTip = 'Import VT10100 File for Activation';
                Caption = '';
                ApplicationArea = All;
                Image = FileContract;

                trigger OnAction()
                var
                    DetailedSIILogEntries: Record "Detailed SII Log Entries";
                    DetailedSIILogEntriesPage: Page "Detailed SII Log Entries";
                begin
                    DetailedSIILogEntries.SetRange("Contract No.", Rec."No.");
                    if DetailedSIILogEntries.FindSet()then begin
                        DetailedSIILogEntriesPage.SetTableView(DetailedSIILogEntries);
                        DetailedSIILogEntriesPage.RunModal();
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
                ApplicationArea = All;

                trigger OnAction()
                var
                    Contract: Record Contract;
                begin
                    if Rec.Status.AsInteger() < "Contract Status"::"In Registration".AsInteger()then Rec.Validate(Status, "Contract Status"::"In Registration");
                    CurrPage.SetSelectionFilter(Contract);
                    SelectContractLayout(Rec);
                    Report.RunModal(Report::"Physical Contract", true, false, Contract);
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
        area(Promoted)
        {
            actionref(DeleteRec_Promoted; DeleteContract)
            {
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
                Caption = 'Main Process', Comment = 'Generated from the PromotedActionCategories property index 3.';

                group("SII Interface 2")
                {
                    Caption = 'SII Interface 2';

                    actionref("Export Anagraphic Data_Promoted"; "Export Anagraphic Data")
                    {
                    }
                    actionref("Switch Out_Promoted"; "Switch Out")
                    {
                    }
                    actionref("Change of Customer_Promoted"; "Change of Customer")
                    {
                    }
                    actionref("Switch In_Promoted"; "Switch In")
                    {
                    }
                    actionref("Import File_Promoted"; "Import File")
                    {
                    }
                    //KB20112023 - TASK002131 New Activation Process +++
                    actionref("Export New Activation_Promoted"; "Export New Activation")
                    {
                    }
                    actionref("Export Activation for POD Installation_Promoted"; "Export Activation for POD Installation")
                    {
                    }
                    actionref("Export For POD Activation_Promoted"; "Export For POD Activation")
                    {
                    }
                    actionref("Export Activation after Rejection_Promoted"; "Export Activation File for Rejection")
                    {
                    }
                    //KB20112023 - TASK002131 New Activation Process ---
                    actionref("Show Detailed SII Entries_Promoted"; "Show Detailed SII Entries")
                    {
                    }
                    actionref("Terminate Contract_Promoted"; "Terminate Contract")
                    {
                    }
                }
                actionref("Activate Contract_Promoted"; "Activate Contract")
                {
                }
                actionref("Deactivate Contract_Promoted"; "Deactivate Contract")
                {
                }
                actionref("Generate Invoice_Promoted"; "Generate Invoice")
                {
                }
            }
        }
    }
    trigger OnQueryClosePage(Close: Action): Boolean Var
        Customer_Rec: Record Customer;
    begin
        // AN 09112023 - TASK002140 If Mail option is selected in Distribution of Field, value in email field is Mandatory ++
        if Rec."Distribution of Bill" = Rec."Distribution of Bill"::Mail then Rec.testfield(Email);
        // AN 09112023 - TASK002140 If Mail option is selected in Distribution of Field, value in email field is Mandatory --
        // AN 09112023 - TASK002140 If the customer type is company Ateco Codex will be a mandatory field.  ++
        if Customer_Rec.get(Rec."Customer No.")then if not(Customer_Rec."Customer Type" in[Customer_Rec."Customer Type"::" ", Customer_Rec."Customer Type"::Person])then rec.TestField("Ateco Codex");
    // AN 09112023 - TASK002140 If the customer type is company Ateco Codex will be a mandatory field.  --
    end;
    trigger OnOpenPage()
    var
        Customer: Record Customer;
        UtilitySetup: Record "Utility Setup";
    begin
        UtilitySetup.GetRecordOnce();
        DeveloperMode:=UtilitySetup."AAT Developer Mode PUB";
        if not DeveloperMode then if Rec.Status.AsInteger() > "Contract Status"::Open.AsInteger()then CurrPage.Editable:=false;
        case Rec.Payment of Rec.Payment::"Direct Debt": ShowDirectDebit:=true;
        Rec.Payment::"Bank Transfer": ShowDirectDebit:=false;
        end;
        ShowReasonofAbsence:=Rec."Absense of Cadastral Data";
        if Rec."Customer No." <> '' then if Customer.Get(Rec."Customer No.")then Rec.GetBillingInformation(Customer);
    end;
    /// <summary>
    /// SetTempRecord.
    /// </summary>
    /// <param name="Contract">Temporary Record Contract.</param>
    procedure SetTempRecord(Contract: Record Contract temporary)
    begin
        Rec:=Contract;
    end;
    trigger OnInit()
    begin
        if Rec.Payment = Rec.Payment::"Direct Debt" then ShowDirectDebit:=true;
        if Rec."Security Deposit" = true then ShowSecurityAmount:=true;
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
        else if(GetLanguageCode(Contract) = 'IT')then begin
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
        case Language."Windows Language ID" of 1040, 2064: exit('IT');
        1031, 5127, 3079, 4103, 2055: exit('DE');
        end;
        exit('IT');
    end;
    var CadastralData: Record "Cadastral Data";
    EconomicConditions: Record "Economic Condition";
    CadastralDataCard: Page "Cadastral Data Card";
    EconomicConditionCard: Page "Economic Condition Card";
    DeveloperMode: Boolean;
    ShowBillingSuspension: Boolean;
    ShowDirectDebit: Boolean;
    ShowReasonofAbsence: Boolean;
    ShowSecurityAmount: Boolean;
    ValidStatusErr: Label 'Contract not in Valid status for Switch Out';
}
