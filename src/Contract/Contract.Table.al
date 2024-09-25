table 50203 Contract
{
    Caption = 'Contract';
    DataCaptionFields = "No.", "Customer Name";
    LookupPageID = "Contract Lookup";

    fields
    {
        field(1; "No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    UtilitySetup.Get();
                    NoSeriesMgt.TestManual(UtilitySetup."Contract No. Series");
                    "No. Series":='';
                end;
            end;
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get("Customer No.")then begin
                    "Customer Name":=Customer.Name;
                    Rec.GetBillingInformation(Customer);
                end;
                UpdateInvoiceMarket();
                UpdateInvoiceContractType();
                UpdateInvoicePaymentType();
            end;
        }
        field(10; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(15; "Contract Description"; Text[50])
        {
            Caption = 'Contract Description';
            DataClassification = CustomerContent;
        }
        field(20; "Contract Start Date"; Date)
        {
            Caption = 'Contract Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Contract start date cannot be after contract end date.';
                ErrorLbl: Label '%1 cannot be later than %2';
                NextBillingDate: Date;
            begin
                if("Contract Start Date" > "Contract End Date") and ("Contract End Date" <> 0D)then Error(ErrorMsg);
                // AN 09112023 - TASK002140 -  Added validation for signature date to be fill before starting date ++                                      
                if("Contract Start Date" > "Signature Date of Contract") and ("Signature Date of Contract" <> 0D)then //KB07122023 - TASK002199 Bug - Do not check condition for when Signature Date of Contract is blank 
 Error(ErrorLbl, FieldCaption("Contract Start Date"), FieldCaption("Signature Date of Contract"));
                // AN 09112023 - TASK002140 -  Added validation for signature date to be fill before starting date --                                 
                Rec."Next Billing Date":=CalcDate('<-CM>', CalcDate(GetCalcFormulaBasedOnContractBillingInterval(), Rec."Contract Start Date")); //KB15022024 - TASK002433 New Billing Calculation
                Rec.Period:=Format(Rec."Contract Start Date");
            end;
        }
        field(25; "Contract End Date"; Date)
        {
            Caption = 'Contract End Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Contract end date cannot be before contract start date.';
                ErrorLbl: Label '%1 cannot before %2', Comment = '%1 cannot before %2';
            begin
                if("Contract End Date" < "Contract Start Date") and ("Contract End Date" <> 0D)then Error(ErrorMsg);
                // AN 09112023 - TASK002140 -  Added validation for End Date to be bigger starting date ++                                      
                if("Contract End Date" < "Signature Date of Contract")then Error(ErrorLbl, FieldCaption("Contract End Date"), FieldCaption("Signature Date of Contract"));
                // AN 09112023 - TASK002140 -  Added validation for End Date to be bigger starting date --                                      
                Rec.Period:=Format(Rec."Contract Start Date");
            end;
        }
        field(30; "Activation Cause";Enum "Activation Cause")
        {
            Caption = 'Activiation Cause';
            DataClassification = CustomerContent;
        }
        field(35; "Deactivation Cause";Enum "Deactivation Cause")
        {
            Caption = 'Deactivation Cause';
            DataClassification = CustomerContent;
        }
        field(40; Status;Enum "Contract Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
            begin
                if Rec.Status = "Contract Status"::Closed then begin
                    if Rec."Contract End Date" = 0D then Rec."Contract End Date":=Today();
                    PointofDeliveryCustHist.SetRange("AAT Contract No", Rec."No.");
                    PointofDeliveryCustHist.SetFilter("To Date", '%1', 0D);
                    if "POD No." <> '' then PointofDeliveryCustHist.SetRange("POD No.", Rec."POD No.");
                    if PointofDeliveryCustHist.FindLast()then begin
                        PointofDeliveryCustHist.Validate("To Date", Today);
                        PointofDeliveryCustHist.Modify();
                    end;
                end;
            end;
        }
        field(45; "Type of Renewal";Enum "Type of Renewal")
        {
            Caption = 'Type of Renewal';
            DataClassification = CustomerContent;
        }
        field(50; "Signature Date of Contract"; Date)
        {
            Caption = 'Signature Date of Contract';
            DataClassification = CustomerContent;

            // AN 13122023 
            Trigger OnValidate()
            Var
                ErrorLbl: Label 'Signature Date of Contract Cannot before Contract Start date.';
            begin
                if(Rec."Contract Start Date" <> 0D) and (Rec."Contract Start Date" > Rec."Signature Date of Contract")then Error(ErrorLbl)end;
        }
        field(55; "Tel. No."; Text[30])
        {
            Caption = 'Tel. No';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Numeric = true;
        }
        field(60; "Cell. No."; Text[30])
        {
            Caption = 'Cell. No.';
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Numeric = true;
        }
        field(65; "Certified E-Mail"; Text[80])
        {
            Caption = 'Certified E-Mail';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                Email: Text;
                ErrorMsg: Label 'Invalid email entered. Please enter a valid email address.';
            begin
                Email:="Certified E-Mail";
                if(StrPos(Email, '@') = 0) or (StrPos(Email, '.') = 0) and not(Email = '')then Error(ErrorMsg);
            end;
        }
        field(70; Email; Text[80])
        {
            Caption = 'Email';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                Email2: Text;
                ErrorMsg: Label 'Invalid email entered. Please enter a valid email address.';
            begin
                Email2:=Rec.Email;
                if(StrPos(Email2, '@') = 0) or (StrPos(Email2, '.') = 0) and not(Email2 = '')then Error(ErrorMsg);
            end;
        }
        field(75; "Payment Terms"; Code[10])
        {
            Caption = 'Payment Terms';
            DataClassification = CustomerContent;
            TableRelation = "Payment Terms".Code;
        }
        field(80; "Invoicing Group"; Text[50])
        {
            Caption = 'Invoicing Group';
            DataClassification = CustomerContent;
        }
        field(85; "Invoicing Period"; Text[50])
        {
            Caption = 'Invoicing Period';
            DataClassification = CustomerContent;
        }
        field(90; "Last Billed Reading"; Decimal)
        {
            Caption = 'Last Billed Reading';
            DataClassification = CustomerContent;
        }
        field(95; "Billing Suspension"; Boolean)
        {
            Caption = 'Billing Supension';
            DataClassification = CustomerContent;
        }
        field(100; "Reason for Suspension"; Text[50])
        {
            Caption = 'Reason for Suspension';
            DataClassification = CustomerContent;
        }
        field(105; "Suspended By"; Text[30])
        {
            Caption = 'Suspended By';
            DataClassification = CustomerContent;
        }
        field(110; "Price Reduction Start Date"; Date)
        {
            Caption = 'Price Reduction Start Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Price Reduction start date cannot be after Price Reduction end date.';
            begin
                if("Price Reduction Start Date" > "Price Reduction End Date") and ("Price Reduction End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(115; "Price Reduction End Date"; Date)
        {
            Caption = 'Price Reduction End Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Price Reduction End date cannot be before Price Reduction Start date.';
            begin
                if("Price Reduction End Date" < "Price Reduction Start Date") and ("Price Reduction End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(120; "Price Reduction";Enum "Price Reduction")
        {
            Caption = 'Price Reduction';
            DataClassification = CustomerContent;
        }
        field(125; "Bill-to Toponym"; Code[50])
        {
            Caption = 'Bill-to Toponym';
            DataClassification = CustomerContent;
            TableRelation = Toponym.Toponym;
        }
        field(129; "AAT Bill-to CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Bill-to CIV';
        }
        field(130; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';
            DataClassification = CustomerContent;
        }
        field(135; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
            DataClassification = CustomerContent;
        }
        field(140; "Bill-to City"; Text[30])
        {
            TableRelation = if("Bill-to Country"=const(''))"Post Code".City
            else if("Bill-to Country"=filter(<>''))"Post Code".City where("Country/Region Code"=field("Bill-to Country"));
            ValidateTableRelation = true;
            Caption = 'Bill-to City';

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
                BillToCounty: Text;
                CountryCode: Code[10];
            begin
                PostCode.LookupPostCode("Bill-to City", "Bill-to Post Code", BillToCounty, CountryCode);
                Rec.Validate("Bill-to City", Rec."Bill-to City");
            end;
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(City, Rec."Bill-to City");
                PostCode.SetRange(Code, Rec."Bill-to Post Code");
                if PostCode.FindFirst()then begin
                    Rec.Validate("Bill-to County Code", PostCode."County Code");
                    Rec."Bill-to Country":=PostCode."Country/Region Code";
                    Rec."Bill-to ISTAT Code":=PostCode."ISTAT Code";
                end;
            end;
        }
        field(145; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            DataClassification = CustomerContent;
            TableRelation = if("Bill-to Country"=const(''))"Post Code".Code
            else if("Bill-to Country"=filter(<>''))"Post Code".Code where("Country/Region Code"=field("Bill-to Country"));
            ValidateTableRelation = true;

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
                BillToCounty: Text;
                CountryCode: Code[10];
            begin
                PostCode.LookupPostCode("Bill-to City", "Bill-to Post Code", BillToCounty, CountryCode);
                Rec.Validate("Bill-to Post Code", Rec."Bill-to Post Code");
            end;
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(City, Rec."Bill-to City");
                PostCode.SetRange(Code, Rec."Bill-to Post Code");
                if PostCode.FindFirst()then begin
                    Rec.Validate("Bill-to County Code", PostCode."County Code");
                    Rec."Bill-to Country":=PostCode."Country/Region Code";
                    Rec."Bill-to ISTAT Code":=PostCode."ISTAT Code";
                end;
            end;
        }
        field(150; "Bill-to County Code"; Code[20])
        {
            Caption = 'Bill-to County';
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;
        }
        field(155; "Bill-to Country"; Text[30])
        {
            Caption = 'Bill-to Country';
            DataClassification = CustomerContent;
        }
        field(160; "Bill-to ISTAT Code"; Code[6])
        {
            Caption = 'Bill-to ISTAT Code';
            DataClassification = CustomerContent;
        }
        field(165; "Office Code"; Code[30])
        {
            Caption = 'Office Code';
            DataClassification = CustomerContent;
        }
        field(170; Holder;Enum "Holder Type")
        {
            Caption = 'Holder';
            DataClassification = CustomerContent;
        }
        field(175; "Distribution of Bill";Enum "Distribution of Bill")
        {
            Caption = 'Distribution of Bill';
            DataClassification = CustomerContent;

            trigger OnValidate()
            Var
                Customer_Lrec: Record Customer;
                ErrorLbl: Label 'Option PEC Can only be selected in case of Customer type Company.';
            begin
                // AN 09112023 - TASK002140  PEC option in Distribution of Bill can be selected only in case of Company ++ 
                IF "Distribution of Bill" = "Distribution of Bill"::PEC THEN if Customer_Lrec.get(Rec."Customer No.")then if NOT(Customer_Lrec."Contact Type" = Customer_Lrec."Contact Type"::Company)then Error(ErrorLbl);
            // AN 09112023 - TASK002140  PEC option in Distribution of Bill can be selected only in case of Company --  
            end;
        }
        field(180; CIG; Code[20])
        {
            Caption = 'CIG';
            DataClassification = CustomerContent;
        }
        field(185; CUP; Code[20])
        {
            Caption = 'CUP';
            DataClassification = CustomerContent;
        }
        field(190; Payment;Enum "Payment")
        {
            Caption = 'Payment';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoicePaymentType();
            end;
        }
        field(195; IBAN; Text[100])
        {
            Caption = 'IBAN';
            DataClassification = CustomerContent;

            trigger OnValidate();
            var
                CompanyInformation: Record "Company Information";
            begin
                CompanyInformation.CheckIBAN(Rec.IBAN);
            end;
        }
        field(200; Bank; Text[50])
        {
            Caption = 'Bank';
            DataClassification = CustomerContent;
        }
        field(205; "BIC"; Text[20])
        {
            Caption = 'BIC';
            DataClassification = CustomerContent;
            TableRelation = "SWIFT Code".Code;
        }
        field(210; "Activiation Code"; Code[20])
        {
            Caption = 'Activation Code';
            DataClassification = CustomerContent;
        }
        field(215; "Direct Debt No."; Code[20])
        {
            Caption = 'Direct Debt No.';
            DataClassification = CustomerContent;
        }
        field(220; "Scheme of SDD";Enum "Scheme of SDD")
        {
            Caption = 'Direct Debt No.';
            DataClassification = CustomerContent;
        }
        field(225; "Classification Account";Enum "Classification Account")
        {
            Caption = 'Classification Account';
            DataClassification = CustomerContent;
        }
        field(230; Usage;Enum Usage)
        {
            Caption = 'Usage';
            DataClassification = CustomerContent;
        }
        field(235; "Contract Type";Enum "AAT Contract Type SII")
        {
            Caption = 'Contract Type';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceContractType();
                if "Contract Type" = "Contract Type"::"01" then Resident:=true
                else
                    Resident:=false;
            end;
        }
        field(240; Market;ENUM Market)
        {
            Caption = 'Market';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceMarket();
            end;
        }
        field(245; "Ateco Codex"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Ateco Codex';
            // AN 23112023 - TASK002140  Linked this field with Ateco Codex table ++ 
            TableRelation = "Ateco Codex"."Ateco Codex No.";
        // AN 23112023 - TASK002140  Linked this field with Ateco Codex table ++ 
        }
        field(250; "Communication Langauge"; Code[15])
        {
            Caption = 'Communication Langauge';
            DataClassification = CustomerContent;
            TableRelation = Language;
        }
        field(251; "Economic Condition No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Economic Condition No.';
        }
        field(252; "Economic Condition Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Economic Condition Start Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Start date cannot be after end date.';
            begin
                if(Rec."Economic Condition Start Date" > Rec."Economic Condition End Date") and ("Economic Condition End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(253; "Economic Condition End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Economic Condition End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'End date cannot be before start date.';
            begin
                if(Rec."Economic Condition End Date" < Rec."Economic Condition Start Date") and (Rec."Economic Condition End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(255; "Invoice Layout";ENUM "Invoice Layout")
        {
            Caption = 'Invoice Layout';
        }
        field(260; "Contractual Power"; Decimal)
        {
            Caption = 'Contractual Power';
            DataClassification = CustomerContent;
        }
        field(275; "Available Power"; Decimal)
        {
            Caption = 'Available Power';
            DataClassification = CustomerContent;
        }
        field(280; "Billing Interval";Enum "Billing Interval")
        {
            Caption = 'Billing Interval';
            DataClassification = ToBeClassified;
        }
        field(285; "Voltage Type";Enum "Voltage Type")
        {
            Caption = 'Voltage Type';
            DataClassification = CustomerContent;
        }
        field(290; Voltage; Decimal)
        {
            Caption = 'Voltage';
            DataClassification = CustomerContent;
        }
        field(295; "System Type";Enum "System Type")
        {
            Caption = 'System Type';
            DataClassification = CustomerContent;
        }
        field(300; "Reduced VAT";Enum "Reduced VAT")
        {
            Caption = 'Reduced VAT';
            DataClassification = CustomerContent;
        }
        field(305; "Tariff Option No."; Code[20])
        {
            Caption = 'Tariff Option No.';
            DataClassification = CustomerContent;
            TableRelation = "Tariff Header"."No.";
        }
        field(310; "Tariff Option Name"; Text[50])
        {
            Caption = 'Tariff Option Name';
            DataClassification = CustomerContent;
        }
        field(315; "Annual Consumption"; Decimal)
        {
            Caption = 'Annual Consumption';
            DataClassification = CustomerContent;
        }
        field(320; "AUC Exempt"; Boolean)
        {
            Caption = 'AUC Exempt';
            DataClassification = CustomerContent;
        }
        field(325; "Excise Duties not Due"; Boolean)
        {
            Caption = 'Excise Duties not Due';
            DataClassification = CustomerContent;
        }
        field(330; "Limiter Present"; Boolean)
        {
            Caption = 'Limiter Present';
            DataClassification = CustomerContent;
        }
        field(335; Resident; Boolean)
        {
            Caption = 'Resident';
            DataClassification = CustomerContent;
        }
        field(337; "Farmer"; Boolean)
        {
            Caption = 'Farmer';
            DataClassification = CustomerContent;
        }
        field(340; "Security Deposit"; Boolean)
        {
            Caption = 'Security Deposit';
            DataClassification = CustomerContent;
        }
        field(345; "Security Deposit Amount"; Decimal)
        {
            Caption = 'Security Deposit Amount';
            DataClassification = CustomerContent;
        }
        field(346; "Cadastral Data No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Cadastral Data No.';
        }
        field(350; "Municipality Comm. Date"; Date)
        {
            Caption = 'Municipality Comm. Date';
            DataClassification = CustomerContent;
        }
        field(355; "Property Type";Enum "Property Type")
        {
            Caption = 'Property Type';
            DataClassification = CustomerContent;
        }
        field(360; "Concession Building"; Text[50])
        {
            Caption = 'Concession Building';
            DataClassification = CustomerContent;
        }
        field(365; "Cadastral Municipality Code"; Code[20])
        {
            Caption = 'Cadastral Municpality Code';
            DataClassification = CustomerContent;
        }
        field(370; "Admin. Municipality Code"; Code[20])
        {
            Caption = 'Admin. Municipality Code';
            DataClassification = CustomerContent;
        }
        field(375; Section; Text[50])
        {
            Caption = 'Section';
            DataClassification = CustomerContent;
        }
        field(380; Sheet; Text[50])
        {
            Caption = 'Sheet';
            DataClassification = CustomerContent;
        }
        field(385; Particle; Text[50])
        {
            Caption = 'Particle';
            DataClassification = CustomerContent;
        }
        field(386; "Particle Type";Enum "Particle Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Particle Type';
        }
        field(390; "Particle Extension"; Text[50])
        {
            Caption = 'Particle Extension';
            DataClassification = CustomerContent;
        }
        field(395; Subordinate; Text[50])
        {
            Caption = 'Subordinate';
            DataClassification = CustomerContent;
        }
        field(399; "Reason for Absence";Enum "Reason For Absence")
        {
            Caption = 'Reason for Absence';
            DataClassification = CustomerContent;
        }
        field(400; "Absense of Cadastral Data"; Boolean)
        {
            Caption = 'Absense of Cadastral Data';
            DataClassification = CustomerContent;
        }
        field(401; "Cadastral Data Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Cadastral Data Start Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Cadastral Data Start Date cannot be after Cadastral Data End Date.';
            begin
                if("Cadastral Data End Date" < "Cadastral Data Start Date") and (Rec."Cadastral Data End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(402; "Cadastral Data End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Cadastral Data End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Cadastral Data End Date cannot be before Cadastral Data Start Date.';
            begin
                if("Cadastral Data End Date" < "Cadastral Data Start Date") and (Rec."Cadastral Data End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(405; "POD No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';

            trigger OnValidate()
            var
                Contract: Record Contract;
                Contract2: Record Contract;
                PointofDelivery: Record "Point of Delivery";
                ConfirmManagement: Codeunit "Confirm Management";
                ErrorMsg: Label 'The selected POD is already in use for Contract No. : %1', Comment = '%1 = Contract No.';
                ConfirmationLbl: Label 'This action will close contract %1.\\Do you wish to continue?', Comment = '%1 = Contract No.';
            begin
                Contract.SetRange("POD No.", Rec."POD No.");
                Contract.SetFilter(Status, '%1|%2', "Contract Status"::"In Registration", "Contract Status"::Open);
                if not(Contract.IsEmpty()) and (Contract.FindFirst())then begin
                    Contract2.SetRange("POD No.", Rec."POD No.");
                    Contract2.SetFilter(Status, '%1', "Contract Status"::"Closed - Awaiting Approval");
                    if not Contract2.IsEmpty()then Error(ErrorMsg, Contract."No.")
                    else if Rec."Activation Cause" = "Activation Cause"::"Take Over" then if ConfirmManagement.GetResponseOrDefault(StrSubstNo(ConfirmationLbl, Contract."No."), false)then begin
                                Contract."POD No.":='';
                                Contract.Validate(Status, "Contract Status"::"Closed - Awaiting Approval");
                                Contract.Validate("Deactivation Cause", "Deactivation Cause"::"Take Over");
                                Contract.Modify(true);
                                UpdatePODECAndHist();
                            end
                            else
                                Error(ErrorMsg, Contract."No.");
                end
                else
                    UpdatePODECAndHist();
                PointofDelivery.Get(Rec."POD No.");
                PointofDelivery.PopulatePhysicalAddress(Rec);
            end;
        }
        field(408; "POD Cost"; Decimal)
        {
            Caption = 'POD Cost';
        }
        field(410; "Physical Toponym"; Code[50])
        {
            Caption = 'Physical Toponym';
            FieldClass = Normal;
        }
        field(414; "AAT Physical CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Physical CIV';
        }
        field(415; "Physical Address"; Text[100])
        {
            Caption = 'Physical Address';
            FieldClass = Normal;
        }
        field(420; "Physical Address 2"; Text[50])
        {
            Caption = 'Physical Address 2';
            FieldClass = Normal;
        }
        field(425; "Physical City"; Text[30])
        {
            Caption = 'Physical City';
            TableRelation = "Post Code".City;
            ValidateTableRelation = true;
        }
        field(430; "Physical Post Code"; Code[20])
        {
            Caption = 'Physical Post Code';
            FieldClass = Normal;
        }
        field(435; "Physical County Code"; Text[20])
        {
            Caption = 'Physical Province';
            FieldClass = Normal;
        }
        field(440; "Physical Country Code"; Code[10])
        {
            Caption = 'Physical Country Code';
            FieldClass = Normal;
        }
        field(445; "ISTAT Code"; Code[6])
        {
            Caption = 'ISTAT Code';
            DataClassification = CustomerContent;
        }
        field(450; Period; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(500; "Process Status";Enum "Contract Proccess Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Process Status';
        }
        field(505; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(550; "Contract Printed"; Boolean)
        {
            Caption = 'Contract Printed';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(570; "AAT Type Of Volture SII";Enum "AAT Type Of Volture SII")
        {
            DataClassification = CustomerContent;
            Caption = 'Reason for Change';
        }
        field(575; "AAT Customer Category SII";Enum "AAT COC Category SII")
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Category';
        }
        // AN 08112023 - TASK002127 field Added  ++ 
        field(576; "Switch Out Date"; Date)
        {
            Caption = 'Switch Out Date';
            DataClassification = ToBeClassified;
        }
        // AN 08112023 - TASK002127 field Added  ++ 
        //KB12122023 - TASK002199 Switch In Field +++
        field(577; "Switch In Date"; Date)
        {
            Caption = 'Switch In Date';
            DataClassification = ToBeClassified;
        }
        //KB12122023 - TASK002199 Switch In Field ---
        //KB08022024 New field added +++
        field(578; DATI_FATTI; Boolean)
        {
            Caption = 'DATI FATTI';
            DataClassification = ToBeClassified;
        }
        field(579; INTERROMPABILITà; Boolean)
        {
            Caption = 'INTERROMPABILITà';
            DataClassification = ToBeClassified;
        }
        field(580; APPARATO_MEDICALE; Boolean)
        {
            Caption = 'APPARATO MEDICALE';
            DataClassification = ToBeClassified;
        }
        field(581; "CATEGORIA MERCEOLOGICA"; Boolean)
        {
            Caption = 'CATEGORIA MERCEOLOGICA';
            DataClassification = ToBeClassified;
        }
        //KB08022024 New field added ---
        //KB15022024 - TASK002433 New Billing Calculation +++
        field(582; "Next Billing Date"; Date)
        {
            Caption = 'Next Billing Date';
            DataClassification = ToBeClassified;
        }
        //KB15022024 - TASK002433 New Billing Calculation ---
        //KB03042024 - Discount Calculation +++
        field(583; "Discount ID"; Code[20])
        {
            Caption = 'Discount ID';
            TableRelation = "Discount Price Header";
            DataClassification = ToBeClassified;
        }
        //KB03042024 - Discount Calculation ---
        field(588; "Quadro Code"; Code[20])
        {
            Caption = 'Monthly Quadro Code';
            TableRelation = Quadro;
            DataClassification = ToBeClassified;
        }
        field(589; "Quadro LB5"; Boolean)
        {
            Caption = 'Annual Quadro LB5';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec."Quadro LB5" then Rec.TestField("Quadro LB6", false);
            end;
        }
        field(590; "Quadro LB6"; Boolean)
        {
            Caption = 'Annual Quadro LB6';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if Rec."Quadro LB6" then Rec.TestField("Quadro LB5", false);
            end;
        }
        field(591; "Quadro M3"; Boolean)
        {
            Caption = 'Annual Quadro M3';
            DataClassification = ToBeClassified;
        }
        field(585; "Invoice Market"; Text[100])
        {
            Caption = 'Invoice Market';
            DataClassification = ToBeClassified;
        }
        field(586; "Invoice Contract Type"; Text[100])
        {
            Caption = 'Invoice Contract Type';
            DataClassification = ToBeClassified;
        }
        field(587; "Invoice Payment"; Text[100])
        {
            Caption = 'Invoice Payment';
            DataClassification = ToBeClassified;
        }
        field(592; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key3; "Customer No.")
        {
        }
        key(key2; "POD No.")
        {
        }
    }
    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeInsert(Rec, IsHandled);
        if IsHandled then exit;
        if "No." = '' then begin
            UtilitySetup.Get();
            UtilitySetup.TestField("Contract No. Series");
            NoSeriesMgt.InitSeries(UtilitySetup."Contract No. Series", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        OnAfterOnInsert(Rec, xRec);
    end;
    trigger OnModify()
    var
        POD: Record "Point of Delivery";
    begin
        if Rec."POD No." <> '' then if(Rec."POD No." <> xRec."POD No.") or ((Rec."Activation Cause" = "Activation Cause"::Transfer) and (Rec."Customer No." <> ''))then begin
                POD.Get(Rec."POD No.");
                POD.Validate("Customer No.", Rec."Customer No.");
                POD.Modify();
            end;
    end;
    local procedure GeneralTabValidation()
    var
        Customer: Record Customer;
        NoCustomerErr: Label 'Customer not in system.';
        EmptyStartDateErr: Label 'Contract Start Date cannot be empty.';
        EmptySignatureDateErr: Label 'Signature Date of Contract Cannot be empty.';
    begin
        if not Customer.Get(Rec."Customer No.")then Error(NoCustomerErr);
        if Rec."Contract Start Date" = 0D then Error(EmptyStartDateErr);
        if "Signature Date of Contract" = 0D then Error(EmptySignatureDateErr);
    end;
    local procedure ContractDetailsValidation()
    var
        Customer: Record Customer;
        ContractUsageErr: Label 'Contract:\Contract Details:\\Contract Usage not set.';
        MarketErr: Label 'Contract:\Contract Details:\\Market not set.';
        AtecoCodexErr: Label 'Contract:\Contract Details:\\Ateco Codex not specified.';
        CommLanguageErr: Label 'Contract:\Contract Details:\\Communication Language not set.';
    begin
        if Rec.Usage = Usage::" " then Error(ContractUsageErr);
        if Rec.Market = Market::" " then Error(MarketErr);
        if Customer.get(Rec."Customer No.")then if Customer."Customer Type" = Customer."Customer Type"::Company then if Rec."Ateco Codex" = '' then Error(AtecoCodexErr);
        if Rec."Communication Langauge" = '' then Error(CommLanguageErr);
    end;
    local procedure UpdateInvoiceMarket()
    var
        Customer: Record Customer;
        Language: Record Language;
    begin
        if Customer.Get("Customer No.")then begin
            case Rec.Market of Rec.Market::" ": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Market":=Format("Market Italian"::" ");
                    2064: Rec."Invoice Market":=Format("Market Italian"::" ");
                    5127: Rec."Invoice Market":=Format("Market Germen"::" ");
                    3079: Rec."Invoice Market":=Format("Market Germen"::" ");
                    4103: Rec."Invoice Market":=Format("Market Germen"::" ");
                    1031: Rec."Invoice Market":=Format("Market Germen"::" ");
                    else
                        Rec."Invoice Market":=Format(Rec.Market);
                    end;
                end;
            end;
            Rec.Market::Free: begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Market":=Format("Market Italian"::"mercato libero");
                    2064: Rec."Invoice Market":=Format("Market Italian"::"mercato libero");
                    5127: Rec."Invoice Market":=Format("Market Germen"::"Freier Markt");
                    3079: Rec."Invoice Market":=Format("Market Germen"::"Freier Markt");
                    4103: Rec."Invoice Market":=Format("Market Germen"::"Freier Markt");
                    1031: Rec."Invoice Market":=Format("Market Germen"::"Freier Markt");
                    else
                        Rec."Invoice Market":=Format(Rec.Market);
                    end;
                end;
            end;
            Rec.Market::Protected: begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Market":=Format("Market Italian"::Protetto);
                    2064: Rec."Invoice Market":=Format("Market Italian"::Protetto);
                    5127: Rec."Invoice Market":=Format("Market Germen"::"Geschützt");
                    3079: Rec."Invoice Market":=Format("Market Germen"::"Geschützt");
                    4103: Rec."Invoice Market":=Format("Market Germen"::"Geschützt");
                    1031: Rec."Invoice Market":=Format("Market Germen"::"Geschützt");
                    else
                        Rec."Invoice Market":=Format(Rec.Market);
                    end;
                end;
            end;
            end;
        end
        else
            Rec."Invoice Market":='';
    end;
    local procedure UpdateInvoiceContractType()
    var
        Customer: Record Customer;
        Language: Record Language;
    begin
        if Customer.Get("Customer No.")then begin
            case Rec."Contract Type" of Rec."Contract Type"::" ": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::" ");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::" ");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::" ");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::" ");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::" ");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::" ");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            Rec."Contract Type"::"01": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"01");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"01");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"01");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"01");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"01");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"01");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            Rec."Contract Type"::"02": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"02");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"02");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"02");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"02");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"02");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"02");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            Rec."Contract Type"::"03": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"03");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"03");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"03");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"03");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"03");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"03");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            Rec."Contract Type"::"04": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"04");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"04");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"04");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"04");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"04");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"04");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            Rec."Contract Type"::"05": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"05");
                    2064: Rec."Invoice Contract Type":=Format("Contract Type Italian"::"05");
                    5127: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"05");
                    3079: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"05");
                    4103: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"05");
                    1031: Rec."Invoice Contract Type":=Format("Contract Type Germen"::"05");
                    else
                        Rec."Invoice Contract Type":=Format(Rec."Contract Type");
                    end;
                end;
            end;
            end;
        end
        else
            Rec."Invoice Contract Type":='';
    end;
    local procedure UpdateInvoicePaymentType()
    var
        Customer: Record Customer;
        Language: Record Language;
    begin
        if Customer.Get("Customer No.")then begin
            case Rec.Payment of Rec.Payment::" ": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Payment":=Format("Payment Italian"::" ");
                    2064: Rec."Invoice Payment":=Format("Payment Italian"::" ");
                    5127: Rec."Invoice Payment":=Format("Payment Germen"::" ");
                    3079: Rec."Invoice Payment":=Format("Payment Germen"::" ");
                    4103: Rec."Invoice Payment":=Format("Payment Germen"::" ");
                    1031: Rec."Invoice Payment":=Format("Payment Germen"::" ");
                    else
                        Rec."Invoice Payment":=Format(Rec.Payment);
                    end;
                end;
            end;
            Rec.Payment::"Bank Transfer": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Payment":=Format("Payment Italian"::"Bonifico bancario");
                    2064: Rec."Invoice Payment":=Format("Payment Italian"::"Bonifico bancario");
                    5127: Rec."Invoice Payment":=Format("Payment Germen"::"Banküberweisung");
                    3079: Rec."Invoice Payment":=Format("Payment Germen"::"Banküberweisung");
                    4103: Rec."Invoice Payment":=Format("Payment Germen"::"Banküberweisung");
                    1031: Rec."Invoice Payment":=Format("Payment Germen"::"Banküberweisung");
                    else
                        Rec."Invoice Payment":=Format(Rec.Payment);
                    end;
                end;
            end;
            Rec.Payment::"Direct Debt": begin
                if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: Rec."Invoice Payment":=Format("Payment Italian"::"Addebito diretto");
                    2064: Rec."Invoice Payment":=Format("Payment Italian"::"Addebito diretto");
                    5127: Rec."Invoice Payment":=Format("Payment Germen"::Lastschrift);
                    3079: Rec."Invoice Payment":=Format("Payment Germen"::Lastschrift);
                    4103: Rec."Invoice Payment":=Format("Payment Germen"::Lastschrift);
                    1031: Rec."Invoice Payment":=Format("Payment Germen"::Lastschrift);
                    else
                        Rec."Invoice Payment":=Format(Rec.Payment);
                    end;
                end;
            end;
            end;
        end;
    end;
    local procedure CommunicationValidation()
    var
        TelNoErr: Label 'Contract:\Communication:\\Tel No. is not populated';
        PaymentTermErr: Label 'Contract:\Communication:\\Payment Terms not set';
        PaymentErr: Label 'Contract:\Communication:\\Payment method not selected';
    begin
        if Rec."Tel. No." = '' then Error(TelNoErr);
        if Rec."Payment Terms" = '' then Error(PaymentTermErr);
        if Rec.Payment = Payment::" " then Error(PaymentErr);
    end;
    local procedure EconomicConditionValidation()
    var
        EconomicCondition: Record "Economic Condition";
        EconomicConditionErr: Label 'Economic Condition not found in system';
    begin
        if not EconomicCondition.Get(Rec."Economic Condition No.")then Error(EconomicConditionErr);
        EconomicCondition.ValidateEconomicCondition();
    end;
    local procedure PODValidation()
    var
        PointofDelivery: Record "Point of Delivery";
        NoPODErr: Label 'POD not in system';
    begin
        if not PointofDelivery.Get(Rec."POD No.")then Error(NoPODErr);
        PointofDelivery.ValidatePOD();
    end;
    local procedure CadastralDataValidation()
    var
        CadastralData: Record "Cadastral Data";
        NoCadastralDataErr: Label 'Cadastral Data not found';
    begin
        if not CadastralData.Get("Cadastral Data No.")then Error(NoCadastralDataErr);
        CadastralData.ValidateCadastralData();
    end;
    local procedure InitialPodCustHistEntry()
    var
        PointOfDeliveryCustHist: Record "Point of Delivery - Cust Hist";
        PointofDeliveryCustHist2: Record "Point of Delivery - Cust Hist";
    begin
        PointofDeliveryCustHist2.SetRange("POD No.", Rec."POD No.");
        if PointofDeliveryCustHist2.FindLast()then begin
            PointofDeliveryCustHist2.Validate("To Date", Today);
            PointofDeliveryCustHist2.PopulateCustHistPeriod();
            PointofDeliveryCustHist2.Modify(true);
        end;
        PointOfDeliveryCustHist.Init();
        PointOfDeliveryCustHist."POD No.":=CopyStr(Rec."POD No.", 1, MaxStrLen(PointOfDeliveryCustHist."POD No."));
        PointOfDeliveryCustHist.Validate("Customer No.", Rec."Customer No.");
        PointOfDeliveryCustHist.Insert(true);
        PointOfDeliveryCustHist."Customer Name":=Rec."Customer Name";
        PointOfDeliveryCustHist.Validate("From Date", Today());
        PointOfDeliveryCustHist.PopulateCustHistPeriod();
        PointOfDeliveryCustHist."AAT Contract No":=Rec."No.";
        PointOfDeliveryCustHist.Modify(true);
    end;
    local procedure UpdatePODECAndHist()
    var
        POD: Record "Point of Delivery";
        EconomicConditions: Record "Economic Condition";
    begin
        if POD.Get(Rec."POD No.")then begin
            Rec."Physical Toponym":=POD.Toponym;
            Rec."AAT Physical CIV PUB":=POD."AAT CIV PUB";
            Rec."Physical Address":=POD.Address;
            Rec."Physical Address 2":=POD."Address 2";
            Rec."Physical City":=POD.City;
            Rec."Physical Post Code":=POD."Post Code";
            Rec."Physical County Code":=POD."County Code";
            Rec."Physical Country Code":=POD."Country/Region Code";
            Rec."ISTAT Code":=POD."ISTAT Code";
            Rec."POD Cost":=POD."POD Cost";
            POD.Validate("Customer No.", Rec."Customer No.");
            POD.Modify();
            if not Rec.Modify()then;
            EconomicConditions.SetRange("Contract No.", Rec."No.");
            if not EconomicConditions.IsEmpty() and EconomicConditions.FindLast()then begin
                EconomicConditions."POD No.":=Rec."POD No.";
                EconomicConditions.Modify();
            end;
            InitialPodCustHistEntry();
        end;
    end;
    procedure DeactivationValidation(): Boolean var
        ConfirmManagement: Codeunit "Confirm Management";
        DeactiveConfirmErr: Label 'By selecting OK you confirm that:\\1: You have inserted the necessary feedback received from the Utility Provider into the meter correctly.';
    begin
        if ConfirmManagement.GetResponseOrDefault(DeactiveConfirmErr, false)then exit(true);
    end;
    /// <summary>
    /// GetBillingInformation.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    procedure GetBillingInformation(Customer: Record Customer)
    var
    begin
        Rec."Bill-to Toponym":=Customer."Billing Toponym";
        Rec."AAT Bill-to CIV PUB":=Customer."AAT Billing CIV PUB";
        Rec."Bill-to Address":=Customer."Billing Address";
        Rec."Bill-to Address 2":=Customer."Billing Address 2";
        Rec."Bill-to City":=Customer."Billing City";
        Rec."Bill-to County Code":=Customer."Billing County Code";
        Rec."Bill-to Country":=Customer."Billing Country";
        Rec."Bill-to Post Code":=Customer."Billing Post Code";
        Rec."Bill-to ISTAT Code":=Customer."Billing ISTAT Code";
        Rec."Tel. No.":=Customer."Phone No.";
        Rec."Cell. No.":=Customer."Mobile Phone No.";
        Rec.Email:=Customer."E-Mail";
        Rec."Certified E-Mail":=Customer."Certified E-Mail Address";
        Rec."Communication Langauge":=Customer."Customer Language Code";
    end;
    procedure ValidateContractInformation(): Boolean begin
        // General Group validation
        GeneralTabValidation();
        //Contract Details Group Validation
        ContractDetailsValidation();
        //Communication group Validation
        CommunicationValidation();
        //Point of Delivery
        PODValidation();
        //Economic Condition
        EconomicConditionValidation();
        //Cadastral Data
        CadastralDataValidation();
        exit(true);
    end;
    //KB15022024 - TASK002433 New Billing Calculation +++
    procedure GetCalcFormulaBasedOnContractBillingInterval(): Text begin
        case Rec."Billing Interval" of "Billing Interval"::Monthly: exit('<+CM>');
        "Billing Interval"::"2 Months": exit('<+1M+CM>');
        "Billing Interval"::"3 Months": exit('<+2M+CM>');
        "Billing Interval"::"4 Months": exit('<+3M+CM>');
        "Billing Interval"::"6 Months": exit('<+5M+CM>');
        "Billing Interval"::" Once a Year": exit('<+1Y>');
        end;
    end;
    //KB15022024 - TASK002433 New Billing Calculation ---
    procedure GetCalcFormulaBasedOnContractBillingIntervalWithStartDate(StartMonthDate: Date): Text var
        YearStartDate: Date;
        NoOfMonths: Integer;
    begin
        YearStartDate:=CalcDate('<-CY>', StartMonthDate);
        case Rec."Billing Interval" of "Billing Interval"::Monthly: exit('<+CM>');
        "Billing Interval"::"2 Months": begin
            NoOfMonths:=CalculateMonths(YearStartDate, StartMonthDate);
            if NoOfMonths mod 2 >= 1 then exit('<+CM>')
            else
                exit('<+1M+CM>');
        end;
        "Billing Interval"::"3 Months": begin
            NoOfMonths:=CalculateMonths(YearStartDate, StartMonthDate);
            if NoOfMonths mod 3 >= 2 then exit('<+CM>')
            else
                exit('<+' + Format(2 - (NoOfMonths mod 3)) + 'M+CM');
        end;
        "Billing Interval"::"4 Months": begin
            NoOfMonths:=CalculateMonths(YearStartDate, StartMonthDate);
            if NoOfMonths mod 4 >= 3 then exit('<+CM>')
            else
                exit('<+' + Format(3 - (NoOfMonths mod 4)) + 'M+CM');
        end;
        "Billing Interval"::"6 Months": begin
            NoOfMonths:=CalculateMonths(YearStartDate, StartMonthDate);
            if NoOfMonths mod 6 >= 5 then exit('<+CM>')
            else
                exit('<+' + Format(5 - (NoOfMonths mod 6)) + 'M+CM');
        end;
        "Billing Interval"::" Once a Year": begin
            NoOfMonths:=CalculateMonths(YearStartDate, StartMonthDate);
            if NoOfMonths mod 12 >= 11 then exit('<+CM>')
            else
                exit('<+' + Format(11 - (NoOfMonths mod 12)) + 'M+CM');
        end;
        end;
    end;
    var UtilitySetup: Record "Utility Setup";
    NoSeriesMgt: Codeunit NoSeriesManagement;
    local procedure CalculateMonths(StartDate: Date; EndDate: Date): Integer var
        NoOfYears: Integer;
        NoOfMonths: Integer;
    begin
        NoOfYears:=DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
        NoOfMonths:=DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
        exit((12 * NoOfYears) + NoOfMonths);
    end;
    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var Contract: Record Contract; xContract: Record Contract)
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var Contract: Record Contract; var IsHandled: Boolean)
    begin
    end;
}
