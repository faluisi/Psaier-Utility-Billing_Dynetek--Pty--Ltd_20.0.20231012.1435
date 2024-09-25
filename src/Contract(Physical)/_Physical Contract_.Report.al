report 50200 "Physical Contract"
{
    Caption = 'Physical Contract';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");

            column(Name; Name)
            {
            }
            column(Company_Address; Address)
            {
            }
            column(Company_Address_2; "Address 2")
            {
            }
            column(Company_City; City)
            {
            }
            column(Company_Post_Code; "Post Code")
            {
            }
            column(Company_County; County)
            {
            }
            column(Company_Country_Region_Code; "Country/Region Code")
            {
            }
            column(Company_Picture; Picture)
            {
            }
            column(Company_E_Mail; "E-Mail")
            {
            }
            column(Company_Phone_No_; "Phone No.")
            {
            }
        }
        dataitem(Contract; Contract)
        {
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Contract Filter';

            column(AUCExempt; "AUC Exempt")
            {
            }
            column(AbsenseofCadastralData; "Absense of Cadastral Data")
            {
            }
            column(ActivationCause; "Activation Cause")
            {
            }
            column(ActiviationCode; "Activiation Code")
            {
            }
            column(AdminMunicipalityCode; "Admin. Municipality Code")
            {
            }
            column(AnnualConsumption; "Annual Consumption")
            {
            }
            column(AtecoCodex; "Ateco Codex")
            {
            }
            column(AvailablePower; "Available Power")
            {
            }
            column(BICSWIFT; "BIC")
            {
            }
            column(Bank; Bank)
            {
            }
            column(BilltoAddress; "Bill-to Address")
            {
            }
            column(BilltoAddress2; "Bill-to Address 2")
            {
            }
            column(BilltoCity; "Bill-to City")
            {
            }
            column(BilltoCountry; "Bill-to Country")
            {
            }
            column(BilltoCountyCode; "Bill-to County Code")
            {
            }
            column(BilltoISTATCode; "Bill-to ISTAT Code")
            {
            }
            column(BilltoPostCode; "Bill-to Post Code")
            {
            }
            column(BilltoToponym; "Bill-to Toponym")
            {
            }
            column(BillingInterval; "Billing Interval")
            {
            }
            column(BillingSuspension; "Billing Suspension")
            {
            }
            column(CIG; CIG)
            {
            }
            column(CUP; CUP)
            {
            }
            column(CadastralDataEndDate; "Cadastral Data End Date")
            {
            }
            column(CadastralDataNo; "Cadastral Data No.")
            {
            }
            column(CadastralDataStartDate; "Cadastral Data Start Date")
            {
            }
            column(CadastralMunicipalityCode; "Cadastral Municipality Code")
            {
            }
            column(CellNo; "Cell. No.")
            {
            }
            column(CertifiedEMail; "Certified E-Mail")
            {
            }
            column(ClassificationAccount; "Classification Account")
            {
            }
            column(CommunicationLangauge; "Communication Langauge")
            {
            }
            column(ConcessionBuilding; "Concession Building")
            {
            }
            column(ContractDescription; "Contract Description")
            {
            }
            column(ContractEndDate; "Contract End Date")
            {
            }
            column(ContractStartDate; "Contract Start Date")
            {
            }
            column(ContractType; "Contract Type")
            {
            }
            column(ContractualPower; "Contractual Power")
            {
            }
            column(CustomerName; "Customer Name")
            {
            }
            column(CustomerNo; "Customer No.")
            {
            }
            column(DeactivationCause; "Deactivation Cause")
            {
            }
            column(DirectDebtNo; "Direct Debt No.")
            {
            }
            column(DistributionofBill; "Distribution of Bill")
            {
            }
            column(EconomicConditionEndDate; "Economic Condition End Date")
            {
            }
            column(EconomicConditionNo; "Economic Condition No.")
            {
            }
            column(EconomicConditionStartDate; "Economic Condition Start Date")
            {
            }
            column(Email; Email)
            {
            }
            column(ExciseDutiesnotDue; "Excise Duties not Due")
            {
            }
            column(Holder; Holder)
            {
            }
            column(IBAN; IBAN)
            {
            }
            column(ISTATCode; "ISTAT Code")
            {
            }
            column(InvoiceLayout; "Invoice Layout")
            {
            }
            column(InvoicingGroup; "Invoicing Group")
            {
            }
            column(InvoicingPeriod; "Invoicing Period")
            {
            }
            column(LastBilledReading; "Last Billed Reading")
            {
            }
            column(LimiterPresent; "Limiter Present")
            {
            }
            column(Market; Market)
            {
            }
            column(MunicipalityCommDate; "Municipality Comm. Date")
            {
            }
            column(No; "No.")
            {
            }
            column(OfficeCode; "Office Code")
            {
            }
            column(PODNo; "POD No.")
            {
            }
            column(Particle; Particle)
            {
            }
            column(ParticleExtension; "Particle Extension")
            {
            }
            column(Payment; Payment)
            {
            }
            column(PaymentTerms; "Payment Terms")
            {
            }
            column(Period; Period)
            {
            }
            column(PhysicalAddress; "Physical Address")
            {
            }
            column(PhysicalAddress2; "Physical Address 2")
            {
            }
            column(PhysicalCity; "Physical City")
            {
            }
            column(PhysicalCountryCode; "Physical Country Code")
            {
            }
            column(PhysicalCountyCode; "Physical County Code")
            {
            }
            column(PhysicalPostCode; "Physical Post Code")
            {
            }
            column(PhysicalToponym; "Physical Toponym")
            {
            }
            column(PriceReduction; "Price Reduction")
            {
            }
            column(PriceReductionEndDate; "Price Reduction End Date")
            {
            }
            column(PriceReductionStartDate; "Price Reduction Start Date")
            {
            }
            column(PropertyType; "Property Type")
            {
            }
            column(ReasonforSuspension; "Reason for Suspension")
            {
            }
            column(ReducedVAT; "Reduced VAT")
            {
            }
            column(Resident; Resident)
            {
            }
            column(SchemeofSDD; "Scheme of SDD")
            {
            }
            column(Section; Section)
            {
            }
            column(SecurityDeposit; "Security Deposit")
            {
            }
            column(SecurityDepositAmount; "Security Deposit Amount")
            {
            }
            column(Sheet; Sheet)
            {
            }
            column(SignatureDateofContract; "Signature Date of Contract")
            {
            }
            column(Status; Status)
            {
            }
            column(Subordinate; Subordinate)
            {
            }
            column(SuspendedBy; "Suspended By")
            {
            }
            column(SystemType; "System Type")
            {
            }
            column(TariffOptionName; "Tariff Option Name")
            {
            }
            column(TariffOptionNo; "Tariff Option No.")
            {
            }
            column(TelNo; "Tel. No.")
            {
            }
            column(TypeofRenewal; "Type of Renewal")
            {
            }
            column(Usage; Usage)
            {
            }
            column(Voltage; Voltage)
            {
            }
            column(VoltageType; "Voltage Type")
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No."=field("Customer No.");
                DataItemTableView = sorting("No.");

                column(Customer_First_Name; "First Name")
                {
                }
                column(Customer_Last_Name; "Last Name")
                {
                }
                column(Customer_Fiscal_Code; "Fiscal Code")
                {
                }
                column(Customer_VAT_Registration_No_; "VAT Registration No.")
                {
                }
                column(Customer_Address; Address)
                {
                }
                column(Customer_Address_2; "Address 2")
                {
                }
                column(Customer_Post_Code; "Post Code")
                {
                }
                column(Customer_City; City)
                {
                }
                column(Customer_County; County)
                {
                }
                column(Customer_Country_Region_Code; "Country/Region Code")
                {
                }
                column(Customer_Phone_No_; "Phone No.")
                {
                }
                column(Customer_E_Mail; "E-Mail")
                {
                }
                column(Customer_Place_of_Birth; "Place of Birth")
                {
                }
                column(Customer_Date_of_Birth; "Date of Birth")
                {
                }
                column(Customer_Gender; Gender)
                {
                }
            }
            dataitem("Point of Delivery"; "Point of Delivery")
            {
                DataItemLink = "No."=field("Pod No.");
                DataItemTableView = sorting("No.");

                column(Meter_Serial_No_; "Meter Serial No.")
                {
                }
                column(Toponym; Toponym)
                {
                }
                column(Address; Address)
                {
                }
                column(Address_2; "Address 2")
                {
                }
                column(City; City)
                {
                }
                column(Post_Code; "Post Code")
                {
                }
                column(County_Code; "County Code")
                {
                }
                column(Country_Region_Code; "Country/Region Code")
                {
                }
                column(ISTAT_Code; "ISTAT Code")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                }
            }
        }
    }
    trigger OnPostReport()
    var
        Contract2: Record Contract;
        ConfirmLbl: Label 'Do you want to export the file?';
    begin
        Contract2.Get(Contract."No.");
        Contract2.Validate("Contract Printed", true);
        Contract2.Modify(true);
        //KB111223 - TASK002199 Physical Contract Report Update
        if IsProcess then If Dialog.Confirm(ConfirmLbl, true)then IsConfirm:=true
            else
                IsConfirm:=false;
    //KB111223 - TASK002199 Physical Contract Report Update ---
    end;
    //KB111223 - TASK002199 Physical Contract Report Update +++
    procedure SetProcess()
    begin
        IsProcess:=true;
    end;
    procedure GetConfirm(): Boolean begin
        exit(IsConfirm);
    end;
    //KB111223 - TASK002199 Physical Contract Report Update ---
    var IsProcess: Boolean;
    IsConfirm: Boolean;
}
