codeunit 50213 "Invoice Generation Management"
{
    trigger OnRun()
    begin
    // SelectContractsForInvoicing();
    end;
    /// <summary>
    /// GenerateInvoice.
    /// </summary>
    /// <param name="Contracts">Record Contract.</param>
     // [ErrorBehavior(ErrorBehavior::Collect)]
    procedure GenerateInvoice(Contracts: Record Contract; StartOfMonthDate: Date)
    var
        UtilitySetup_LRec: Record "Utility Setup";
        TVResource_Lrec: Record Resource;
        SBResource_Rec: Record Resource;
        TelevisionFees_Rec: Record "AAT Additional Fees SII";
        TVFee_LRec: Record "AAT Additional Fees SII";
        SocialBonus_Rec: Record "AAT Additional Fees SII";
        TariffLines: Record "Tariff Line";
        SalesHeader: Record "Sales Header";
        MissingResourceNoErr: Label 'Tariff Line: %1 does not have a %2 assigned.', Comment = 'Tariff Line: %1 does not have a %2 assigned.';
        ErrorInfo: ErrorInfo;
    begin
        ErrorInfo.Collectible:=true;
        if CreateSalesHeader(SalesHeader, Contracts, StartOfMonthDate)then begin
            if GetTariffLines(TariffLines, Contracts, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate))then repeat if not(TariffLines."Resource No." = '')then // AN 0122023 TASK002178  Added Resource Record Parameter in CreateSalesLine function 
                        CreateSalesLine(SalesHeader, Contracts, TariffLines, StartOfMonthDate, TVResource_Lrec, TVFee_LRec)
                    else
                    begin
                        ErrorInfo.Message:=StrSubstNo(MissingResourceNoErr, TariffLines."Line No.", TariffLines.FieldCaption("Resource No."));
                        Error(ErrorInfo);
                    end;
                until TariffLines.Next() < 1;
            // AN 01122023 TASK002178  added Television Fees and Social Discount in invoice ++ 
            UtilitySetup_LRec.Get();
            if TVResource_Lrec.Get(UtilitySetup_LRec."Television Fees Code")then;
            if SBResource_Rec.get(UtilitySetup_LRec."Social Bonus Code")then;
            TelevisionFees_Rec.Reset();
            TelevisionFees_Rec.SetRange("AAT Fee Type SII", TelevisionFees_Rec."AAT Fee Type SII"::"TV Fee");
            TelevisionFees_Rec.SetRange("AAT POD No. SII", Contracts."POD No.");
            if TelevisionFees_Rec.FindFirst()then CreateSalesLine(SalesHeader, Contracts, TariffLines, StartOfMonthDate, TVResource_Lrec, TelevisionFees_Rec);
            SocialBonus_Rec.Reset();
            SocialBonus_Rec.SetRange("AAT Fee Type SII", TelevisionFees_Rec."AAT Fee Type SII"::"Social Bonus");
            SocialBonus_Rec.SetRange("AAT POD No. SII", Contracts."POD No.");
            if SocialBonus_Rec.FindFirst()then CreateSalesLine(SalesHeader, Contracts, TariffLines, StartOfMonthDate, SBResource_Rec, SocialBonus_Rec);
        // AN 01122023 TASK002178  added Television Fees and Social Discount in invoice ++ 
        end;
    end;
    local procedure GetTariffLines(var TariffLines: Record "Tariff Line"; Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date): Boolean var
        TariffHeader: Record "Tariff Header";
        TariffLine2: Record "Tariff Line";
        Meter: Record Meter;
    begin
        TariffHeader.SetFilter("No.", Contract."Tariff Option No.");
        if TariffHeader.FindFirst()then begin
            TariffLine2.SetRange("Tariff No.", TariffHeader."No.");
            //KB21022024 - Primary Key Remove Start Date End Date +++
            TariffLine2.SetFilter("Effective Start Date", '>=%1', StartOfMonthDate);
            TariffLine2.SetFilter("Effective End Date", '<=%1', EndDate);
            Meter.Reset();
            Meter.SetRange("POD No.", Contract."POD No.");
            if Meter.FindFirst()then TariffLine2.SetRange("Meter Reading Detection", Meter."Reading Detection");
            // TariffLine2.SetRange("Meter Reading Detection", "Meter Reading Detection"::" ");
            if TariffLine2.FindSet()then begin
                TariffLines.Copy(TariffLine2);
                exit(true);
            end;
        end;
    end;
    local procedure CreateSalesHeader(var SalesHeader: Record "Sales Header"; Contract: Record Contract; StartOfMonthDate: Date): Boolean var
    begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", Enum::"Sales Document Type"::Invoice);
        SalesHeader.Validate("Sell-to Customer No.", Contract."Customer No.");
        SalesHeader.Validate("Posting Date", Today());
        SalesHeader.Validate("AAT Invoice Contract Period", Format(Format(StartOfMonthDate) + '..' + Format(CalcDate('<+CM>', StartOfMonthDate))));
        SalesHeader.Validate("Contract No.", Contract."No.");
        SalesHeader."Tariff No.":=Contract."Tariff Option No.";
        SalesHeader.Validate("Document Date", StartOfMonthDate);
        if SalesHeader.Insert(true)then exit(true)
        else
            exit(false);
    end;
    local procedure CreateSalesLine(SalesHeader: Record "Sales Header"; Contract: Record Contract; TariffLine: Record "Tariff Line"; StartOfMonthDate: Date; Resource: Record Resource; AATAdditionalFeesSII: Record "AAT Additional Fees SII")
    var
        UtilitySetup: Record "Utility Setup";
        SalesLine: Record "Sales Line";
        AATCompensationSchemeSII: Record "AAT Compensation Scheme SII";
        AATCompensationSchemeLines: Record "AAT Compensation Scheme Lines";
        TariffCalcManagement: Codeunit "Tariff Calculation Management";
        RemainingMonth: Integer;
        StartDate: Date;
        EndDate: Date;
        StringPos: Integer;
        AdditionalMonthlyDisc: Decimal;
        Quantity: Decimal;
    begin
        UtilitySetup.Get();
        Clear(AdditionalMonthlyDisc);
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
        // AN 01122023 TASK002178 Add Television fees & Social Discount in Sales Line --
        IF not(Resource."No." = '')THEN begin
            if AATAdditionalFeesSII."AAT Fee Type SII" = AATAdditionalFeesSII."AAT Fee Type SII"::"TV Fee" then begin
                UtilitySetup.TestField("Television Fees Code");
                SalesLine.Validate("No.", Resource."No.");
                SalesLine.Validate(Quantity, 1);
                SalesLine.Validate("Unit Price", AATAdditionalFeesSII."AAT Amount SII")end;
            if AATAdditionalFeesSII."AAT Fee Type SII" = AATAdditionalFeesSII."AAT Fee Type SII"::"Social Bonus" then begin
                UtilitySetup.TestField("Social Bonus Code");
                if AATAdditionalFeesSII."AAT Outcome SII" = true then begin
                    // if (SalesHeader."AAT Invoice Contract Period" <= AATAdditionalFeesSII."AAT End Date SII")
                    Evaluate(StartDate, CopyStr(SalesHeader."AAT Invoice Contract Period", 1, 8));
                    Evaluate(EndDate, CopyStr(SalesHeader."AAT Invoice Contract Period", 11, StrLen(SalesHeader."AAT Invoice Contract Period")));
                    if(StartDate >= AATAdditionalFeesSII."AAT Start Date SII") and (EndDate <= AATAdditionalFeesSII."AAT End Date SII")then // AN 06122023 TASK002178 Additional Discount  --- 
                        if AATCompensationSchemeSII.get(AATAdditionalFeesSII."AAT Compensation Scheme", AATAdditionalFeesSII."AAT Valid Year SII")then begin
                            AATCompensationSchemeLines.Reset();
                            AATCompensationSchemeLines.SetRange("AAT Scheme Code", AATCompensationSchemeSII."AAT Code SII");
                            AATCompensationSchemeLines.SetRange("AAT Year", AATCompensationSchemeSII."AAT Year SII");
                            if AATCompensationSchemeLines.findset()then repeat if(StartDate >= AATCompensationSchemeLines."AAT Start Date") and (StartDate < AATCompensationSchemeLines."AAT End Date") and (EndDate <= AATCompensationSchemeLines."AAT End Date")then AdditionalMonthlyDisc:=AATCompensationSchemeLines."AAT Additional Monthly Disc.";
                                until AATCompensationSchemeLines.next() = 0;
                        end;
                    // AN 06122023 TASK002178 Additional Discount --- 
                    if Contract."Contract End Date" <> 0D then //KB01022024 Invoice Calculation Bug solution
 if(Contract."Deactivation Cause" = Contract."Deactivation Cause"::Switch) and (Calcdate('<+1D>', Contract."Contract End Date") < AATAdditionalFeesSII."AAT End Date SII")then begin
                            SalesLine.Validate("No.", Resource."No.");
                            RemainingMonth:=CalculateMonths(Calcdate('<+1D>', Contract."Contract End Date"), AATAdditionalFeesSII."AAT End Date SII");
                            SalesLine.Validate(Quantity, RemainingMonth + 1);
                            SalesLine.Validate("Unit Price", -((AATCompensationSchemeSII."AAT Monthly Discount SII" * RemainingMonth) + AdditionalMonthlyDisc));
                        end
                        else
                        begin
                            SalesLine.Validate("No.", Resource."No.");
                            SalesLine.Validate(Quantity, 1);
                            SalesLine.Validate("Unit Price", -(AATCompensationSchemeSII."AAT Monthly Discount SII" + AdditionalMonthlyDisc))end;
                end;
            end end
        // AN 01122023 TASK002178  Add Television fees & Social Discount in Sales Line --
        else
        begin
            SalesLine.Validate("No.", TariffLine."Resource No.");
            SalesLine.Validate(Quantity, 1); //KB290124 - Billing Price Quantity calculation code update
            Clear(TariffCalcManagement);
            SalesLine.Validate("Unit Price", TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, StartOfMonthDate, EndDate, "Active Type"::" ", "Reactive Type"::" ", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."));
            SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
        end;
        SalesLine.Insert();
    end;
    local procedure GetNextLineNo(SalesLine: Record "Sales Line"): Integer var
        SalesLines: Record "Sales Line";
    begin
        SalesLines.SetRange("Document Type", SalesLine."Document Type");
        SalesLines.SetRange("Document No.", SalesLine."Document No.");
        if SalesLines.FindLast()then exit(SalesLines."Line No." + 10000)
        else
            exit(10000);
    end;
    // AN 05122023 TASK002178 Month calculation ++
    local procedure CalculateMonths(StartDate: Date; EndDate: Date): Integer var
        NoOfYears: Integer;
        NoOfMonths: Integer;
    begin
        NoOfYears:=DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3);
        NoOfMonths:=DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2);
        exit((12 * NoOfYears) + NoOfMonths);
    end;
    // AN 05122023 TASK002178 Month calculation --
    local procedure InvoiceGenerationProcedure(var Contract: Record Contract; StartOfMonthDate: Date; var InvoiceCount: Integer)
    var
        SalesHeader: Record "Sales Header";
        InvoiceGenerationMgt: Codeunit "Invoice Generation Management";
    begin
        SalesHeader.SetRange("Contract No.", Contract."No.");
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Tariff No.", Contract."Tariff Option No.");
        SalesHeader.SetRange("AAT Invoice Contract Period", Format(Format(StartOfMonthDate) + '..' + Format(CalcDate('<+CM>', StartOfMonthDate))));
        if SalesHeader.IsEmpty()then begin
            InvoiceGenerationMgt.GenerateInvoice(Contract, StartOfMonthDate);
            InvoiceCount:=InvoiceCount + 1;
        end;
    end;
    local procedure ProcessContractsBeforeInvoicing(StartOfMonthDate: Date; var InvoiceCount: Integer; var TotalContracts: Integer)
    var
        Tariff_LRec: Record "Tariff Header";
        Contract: Record Contract;
        ProgressWindowMsg: Label 'Creating Invoices\\Open Contracts: #2###\Contract No: #1#######\Invoices Created #3###', Comment = '#1 = Contract No., #2 = InvoiceCount, #3 = ContractCount';
        ProgressWindow: Dialog;
    begin
        Contract.Reset();
        Contract.SetRange(Status, Enum::"Contract Status"::Open);
        Contract.SetFilter("Contract Start Date", '<=%1', CalcDate('<+CM>', StartOfMonthDate));
        if Contract."Contract End Date" <> 0D then Contract.SetFilter("Contract End Date", '>=%1', StartOfMonthDate);
        ProgressWindow.Open(ProgressWindowMsg);
        TotalContracts:=Contract.Count;
        ProgressWindow.Update(2, TotalContracts);
        if Contract.FindSet()then repeat ProgressWindow.Update(1, Contract."No.");
                Tariff_LRec.Reset();
                Tariff_LRec.SetRange("No.", Contract."Tariff Option No.");
                if(Tariff_LRec.findfirst())then if not(Tariff_LRec.Status in[Tariff_LRec.Status::Closed, Tariff_LRec.Status::New])then InvoiceGenerationProcedure(Contract, StartOfMonthDate, InvoiceCount);
                ProgressWindow.Update(3, InvoiceCount);
            until Contract.Next() < 1;
        ProgressWindow.Close();
    end;
    //KB12022024 Annual Consumption calculation +++
    procedure CalcAnnualConsumption(Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date): Decimal var
        Meter: Record Meter;
        Measurement: Record Measurement;
        FirstTotalValue: Decimal;
        LastTotalValue: Decimal;
        AnnualConsumption: Decimal;
    begin
        FirstTotalValue:=0;
        LastTotalValue:=0;
        AnnualConsumption:=0;
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then if CalcDate('<-1Y>', StartOfMonthDate) > Contract."Contract Start Date" then begin
                if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, CalcDate('<-1Y>', StartOfMonthDate), EndDate);
                    if Measurement.FindSet()then begin
                        Measurement.CalcSums("Active Total");
                        AnnualConsumption:=Measurement."Active Total";
                    end;
                end
                else
                begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, CalcDate('<-1Y>', StartOfMonthDate), EndDate);
                    if Measurement.FindFirst()then FirstTotalValue:=Measurement."Active Total";
                    if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total";
                    AnnualConsumption:=LastTotalValue - FirstTotalValue;
                end;
            end
            else if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, Contract."Contract Start Date", EndDate);
                    if Measurement.FindSet()then begin
                        Measurement.CalcSums("Active Total");
                        AnnualConsumption:=Measurement."Active Total";
                    end;
                end
                else
                begin
                    Measurement.Reset();
                    Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                    Measurement.SetRange("POD No.", Meter."POD No.");
                    Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                    Measurement.SetRange(Date, Contract."Contract Start Date", EndDate);
                    if Measurement.FindFirst()then FirstTotalValue:=Measurement."Active Total";
                    if Measurement.FindLast()then LastTotalValue:=Measurement."Active Total";
                    AnnualConsumption:=LastTotalValue - FirstTotalValue;
                end;
        exit(AnnualConsumption);
    end;
    //KB12022024 Annual Consumption calculation ---
    procedure GetSecondaryLanguage(var SalesHeader: Record "Sales Header")
    var
        SecondaryAddress: Record "Secondary Language Address";
        Customer: Record Customer;
    begin
        SecondaryAddress.SetRange("Source No.", SalesHeader."Sell-to Customer No.");
        if not SecondaryAddress.FindSet()then exit;
        GetLegalAddressFromSecondaryLanguage(SalesHeader, SecondaryAddress);
        Customer.Get(SalesHeader."Sell-to Customer No.");
        if(Customer."Address Preferences" = Customer."Address Preferences"::"Different Billing Address")then GetBillingAddressFromSecondaryLanguage(SalesHeader, SecondaryAddress);
    end;
    local procedure GetLegalAddressFromSecondaryLanguage(var SalesHeader: Record "Sales Header"; var SecondaryAddress: Record "Secondary Language Address")
    var
        Customer: Record Customer;
    begin
        SecondaryAddress.SetRange(Type, SecondaryAddress.Type::Legal);
        if SecondaryAddress.FindFirst()then begin
            SalesHeader."Sell-to Address":=SecondaryAddress.Address;
            SalesHeader."Sell-to Address 2":=SecondaryAddress."Address 2";
            SalesHeader."Sell-to City":=SecondaryAddress.City;
            SalesHeader."Sell-to Post Code":=SecondaryAddress."Post Code";
            SalesHeader."Sell-to County":=SecondaryAddress."County Code";
            SalesHeader."Sell-to Country/Region Code":=SecondaryAddress."Country No";
            if not SalesHeader.Insert(true)then SalesHeader.Modify(true);
        end;
        Customer.Get(SalesHeader."Sell-to Customer No.");
        case Customer."Address Preferences" of "Adress Preferences"::"Different Communication Address": GetBillingAddressFromLegal(SalesHeader, SecondaryAddress);
        end;
    end;
    local procedure GetBillingAddressFromSecondaryLanguage(var SalesHeader: Record "Sales Header"; var SecondaryAddress: Record "Secondary Language Address")
    begin
        SecondaryAddress.SetRange(Type, SecondaryAddress.Type::Billing);
        if SecondaryAddress.FindFirst()then begin
            SalesHeader."Bill-to Address":=SecondaryAddress.Address;
            SalesHeader."Bill-to Address 2":=SecondaryAddress."Address 2";
            SalesHeader."Bill-to City":=SecondaryAddress.City;
            SalesHeader."Bill-to Post Code":=SecondaryAddress."Post Code";
            SalesHeader."Bill-to County":=SecondaryAddress."County Code";
            SalesHeader."Bill-to Country/Region Code":=SecondaryAddress."Country No";
            if not SalesHeader.Insert(true)then SalesHeader.Modify(true);
        end;
    end;
    local procedure GetBillingAddressFromLegal(var SalesHeader: Record "Sales Header"; var SecondaryAddress: Record "Secondary Language Address")
    begin
        if SecondaryAddress.FindFirst()then begin
            SalesHeader."Bill-to Address":=SalesHeader."Sell-to Address";
            SalesHeader."Bill-to Address 2":=SalesHeader."Sell-to Address 2";
            SalesHeader."Bill-to City":=SalesHeader."Sell-to City";
            SalesHeader."Bill-to Post Code":=SalesHeader."Sell-to Post Code";
            SalesHeader."Bill-to County":=SalesHeader."Sell-to County";
            SalesHeader."Bill-to Country/Region Code":=SalesHeader."Sell-to Country/Region Code";
            if not SalesHeader.Insert(true)then SalesHeader.Modify(true);
        end;
    end;
    [ErrorBehavior(ErrorBehavior::Collect)]
    procedure SelectContractsForInvoicing()
    var
        ConfirmMsg: Label 'Invoices will be created for Open contracts, Continue?';
        SalesInvoiceLinkLbl: Label 'Successfully created %1 invoices for %2 Contracts.\\Would you like to open the Sales Invoice List?', Comment = '%1 = ContractCount, %2 = InvoiceCount';
        StartOfMonthDate: Date;
        InvoiceCount: Integer;
        TotalContracts: Integer;
    begin
        InvoiceCount:=0;
        StartOfMonthDate:=CalcDate('<-2M>', Today());
        StartOfMonthDate:=CalcDate('<-CM>', StartOfMonthDate);
        if Dialog.Confirm(ConfirmMsg, true)then repeat ProcessContractsBeforeInvoicing(StartOfMonthDate, InvoiceCount, TotalContracts);
                StartOfMonthDate:=CalcDate('<+1M>', StartOfMonthDate);
            until StartOfMonthDate >= Today(); //TODO make logic to determine what end date to use {Next Phase}
        if Dialog.Confirm(SalesInvoiceLinkLbl, true, InvoiceCount, TotalContracts)then Page.Run(Page::"Sales Invoice List");
    end;
    //KB15022024 - TASK002433 New Billing Calculation +++
    [ErrorBehavior(ErrorBehavior::Collect)]
    procedure SelectContractsForInvoicingNew(ContractNo: Code[25])
    var
        ConfirmMsg: Label 'Invoices will be created for Open contracts, Continue?';
        SalesInvoiceLinkLbl: Label 'Successfully created %1 invoices for %2 Contracts.\\Would you like to open the Sales Invoice List?', Comment = '%1 = ContractCount, %2 = InvoiceCount';
        InvoiceCount: Integer;
        TotalContracts: Integer;
    begin
        InvoiceCount:=0;
        if Dialog.Confirm(ConfirmMsg, true)then ProcessContractsBeforeInvoicingNew(InvoiceCount, TotalContracts, ContractNo);
        if Dialog.Confirm(SalesInvoiceLinkLbl, true, InvoiceCount, TotalContracts)then Page.Run(Page::"Sales Invoice List");
    end;
    local procedure ProcessContractsBeforeInvoicingNew(var InvoiceCount: Integer; var TotalContracts: Integer; ContractNo: Code[25])
    var
        Tariff_LRec: Record "Tariff Header";
        Contract: Record Contract;
        ProgressWindowMsg: Label 'Creating Invoices\\Open Contracts: #2###\Contract No: #1#######\Invoices Created #3###', Comment = '#1 = Contract No., #2 = InvoiceCount, #3 = ContractCount';
        ProgressWindow: Dialog;
        StartOfMonthDate: Date;
        EndDate: Date;
    begin
        Contract.Reset();
        if ContractNo <> '' then begin
            Contract.SetRange("No.", ContractNo);
            Contract.SetRange(Status, Enum::"Contract Status"::Open);
            Contract.SetFilter("Contract Start Date", '<=%1', Today);
        end
        else
        begin
            Contract.SetCurrentKey(Status, "Next Billing Date");
            Contract.SetRange(Status, Enum::"Contract Status"::Open);
            Contract.SetFilter("Contract Start Date", '<=%1', Today);
        end;
        ProgressWindow.Open(ProgressWindowMsg);
        TotalContracts:=Contract.Count;
        ProgressWindow.Update(2, TotalContracts);
        if Contract.FindSet()then repeat ProgressWindow.Update(1, Contract."No.");
                Tariff_LRec.Reset();
                Tariff_LRec.SetRange("No.", Contract."Tariff Option No.");
                Tariff_LRec.SetRange(Status, Tariff_LRec.Status::Approved);
                if Tariff_LRec.FindFirst()then begin
                    StartOfMonthDate:=CalcDate('<-CM>', Contract."Contract Start Date");
                    EndDate:=CalcDate(Contract.GetCalcFormulaBasedOnContractBillingIntervalWithStartDate(StartOfMonthDate), StartOfMonthDate);
                    repeat Contract."Annual Consumption":=CalcAnnualConsumption(Contract, StartOfMonthDate, EndDate);
                        Contract.Modify();
                        InvoiceGenerationProcedureNew(Contract, StartOfMonthDate, EndDate, InvoiceCount);
                        ProgressWindow.Update(3, InvoiceCount);
                        StartOfMonthDate:=CalcDate('<+1D>', EndDate);
                        EndDate:=CalcDate(Contract.GetCalcFormulaBasedOnContractBillingInterval(), StartOfMonthDate);
                    until EndDate >= Today;
                end;
            until Contract.Next() = 0;
        ProgressWindow.Close();
    end;
    local procedure InvoiceGenerationProcedureNew(var Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date; var InvoiceCount: Integer)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        Measurement: Record Measurement;
        IsInsert: Boolean;
    begin
        IsInsert:=true;
        Measurement.Reset();
        Measurement.SetRange("POD No.", Contract."POD No.");
        Measurement.SetRange(Date, StartOfMonthDate, EndDate);
        if Measurement.IsEmpty()then IsInsert:=false;
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Invoice);
        SalesHeader.SetRange("Contract No.", Contract."No.");
        SalesHeader.SetRange("Tariff No.", Contract."Tariff Option No.");
        SalesHeader.SetRange("AAT Invoice Contract Period", Format(Format(StartOfMonthDate) + '..' + Format(EndDate)));
        if not SalesHeader.IsEmpty()then IsInsert:=false;
        SalesInvoiceHeader.Reset();
        SalesInvoiceHeader.SetRange("Contract No.", Contract."No.");
        SalesInvoiceHeader.SetRange("Tariff No.", Contract."Tariff Option No.");
        SalesInvoiceHeader.SetRange("AAT Invoice Contract Period", Format(Format(StartOfMonthDate) + '..' + Format(EndDate)));
        if not SalesInvoiceHeader.IsEmpty()then IsInsert:=false;
        if IsInsert then begin
            GenerateInvoiceNew(Contract, StartOfMonthDate, EndDate);
            InvoiceCount:=InvoiceCount + 1;
        end;
    end;
    local procedure GenerateInvoiceNew(Contracts: Record Contract; StartOfMonthDate: Date; EndDate: Date)
    var
        TariffLines: Record "Tariff Line";
        SalesHeader: Record "Sales Header";
        TelevisionFees_Rec: Record "AAT Additional Fees SII";
        SocialBonus_Rec: Record "AAT Additional Fees SII";
        MissingResourceNoErr: Label 'Tariff Line: %1 does not have a %2 assigned.', Comment = 'Tariff Line: %1 does not have a %2 assigned.';
        ErrorInfo: ErrorInfo;
        ActiveStartDate: Date;
        ActiveEndDate: Date;
    begin
        ErrorInfo.Collectible:=true;
        if CreateSalesHeaderNew(SalesHeader, Contracts, StartOfMonthDate, EndDate)then if GetTariffLinesNew(TariffLines, Contracts, StartOfMonthDate, EndDate)then repeat if not(TariffLines."Resource No." = '')then CreateSalesLineNew(SalesHeader, Contracts, TariffLines, StartOfMonthDate, EndDate)
                    else
                    begin
                        ErrorInfo.Message:=StrSubstNo(MissingResourceNoErr, TariffLines."Line No.", TariffLines.FieldCaption("Resource No."));
                        Error(ErrorInfo);
                    end;
                until TariffLines.Next() = 0;
        ActiveStartDate:=StartOfMonthDate;
        ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
        repeat TelevisionFees_Rec.Reset();
            TelevisionFees_Rec.SetRange("AAT Fee Type SII", TelevisionFees_Rec."AAT Fee Type SII"::"TV Fee");
            TelevisionFees_Rec.SetRange("AAT POD No. SII", Contracts."POD No.");
            TelevisionFees_Rec.SetFilter("AAT Start Date SII", '<=%1', ActiveStartDate);
            TelevisionFees_Rec.SetFilter("AAT End Date SII", '>=%1&>=%2', ActiveStartDate, ActiveEndDate);
            if TelevisionFees_Rec.FindFirst()then CreateSalesLineTelevisionFees(SalesHeader, Contracts, ActiveStartDate, ActiveEndDate, TelevisionFees_Rec);
            ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
            ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
        until ActiveEndDate > EndDate;
        SocialBonus_Rec.Reset();
        SocialBonus_Rec.SetRange("AAT Fee Type SII", TelevisionFees_Rec."AAT Fee Type SII"::"Social Bonus");
        SocialBonus_Rec.SetRange("AAT POD No. SII", Contracts."POD No.");
        if SocialBonus_Rec.FindFirst()then CreateSalesLineSocialBonus(SalesHeader, Contracts, StartOfMonthDate, EndDate, SocialBonus_Rec);
    end;
    local procedure CreateSalesHeaderNew(var SalesHeader: Record "Sales Header"; Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date): Boolean begin
        SalesHeader.Init();
        SalesHeader.Validate("Document Type", Enum::"Sales Document Type"::Invoice);
        SalesHeader.Validate("Sell-to Customer No.", Contract."Customer No.");
        SalesHeader.Validate("Posting Date", Today());
        SalesHeader.Validate("AAT Invoice Contract Period", Format(Format(StartOfMonthDate) + '..' + Format(EndDate)));
        SalesHeader.Validate("Invoice Date Period", Format(StartOfMonthDate, 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>') + ' - ' + Format(EndDate, 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>'));
        SalesHeader.Validate("Contract No.", Contract."No.");
        SalesHeader."Tariff No.":=Contract."Tariff Option No.";
        if SalesHeader.Insert(true)then begin
            SalesHeader.Validate("Document Date", StartOfMonthDate);
            SalesHeader.Validate("Payment Terms Code", Contract."Payment Terms");
            //UK12082024 - Contract wise vat posting group++
            If Contract."VAT Bus. Posting Group" <> '' then SalesHeader.Validate("VAT Bus. Posting Group", Contract."VAT Bus. Posting Group");
            //UK12082024 - Contract wise vat posting group--
            SalesHeader.Modify();
            exit(true);
        end
        else
            exit(false);
    end;
    local procedure GetTariffLinesNew(var TariffLines: Record "Tariff Line"; Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date): Boolean var
        TariffHeader: Record "Tariff Header";
        TariffLine2: Record "Tariff Line";
        Meter: Record Meter;
    begin
        TariffHeader.Reset();
        TariffHeader.SetFilter("No.", Contract."Tariff Option No.");
        if TariffHeader.FindFirst()then begin
            TariffLine2.SetRange("Tariff No.", TariffHeader."No.");
            TariffLine2.SetFilter("Effective Start Date", '<=%1', StartOfMonthDate);
            TariffLine2.SetFilter("Effective End Date", '>=%1&>=%2', StartOfMonthDate, EndDate);
            Meter.Reset();
            Meter.SetRange("POD No.", Contract."POD No.");
            if Meter.FindFirst()then TariffLine2.SetRange("Meter Reading Detection", Meter."Reading Detection");
            if TariffLine2.FindSet()then begin
                TariffLines.Copy(TariffLine2);
                exit(true);
            end;
        end;
    end;
    local procedure InsertAccisoLines(SalesHeader: Record "Sales Header"; Contract: Record Contract; TariffLine: Record "Tariff Line"; ActiveStartDate: Date; ActiveEndDate: Date; MonthlyConsumptionRange: Enum "Monthly Consumption Range"; DomesticMonthlyConsumptionRange: Enum "Domestic Monthly Consum. Range")
    var
        SalesLine: Record "Sales Line";
        UTFAnnual: Record "UTF Annual List";
        DetailedPriceCalcEntries: Record "Detailed Price Calc. Entry";
        TariffCalcManagement: Codeunit "Tariff Calculation Management";
        Quantity: Decimal;
        LastEntryNo: Integer;
    begin
        Clear(TariffCalcManagement);
        Clear(SalesLine);
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
        SalesLine.Validate("No.", TariffLine."Resource No.");
        SalesLine.Validate("Effective Start Date", ActiveStartDate);
        SalesLine.Validate("Effective End Date", ActiveEndDate);
        SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
        SalesLine.Validate(Quantity, TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", true, Quantity, false, MonthlyConsumptionRange, DomesticMonthlyConsumptionRange, false, false, '', 0));
        if MonthlyConsumptionRange = MonthlyConsumptionRange::"> 1.200.001 KWH" then if Quantity <> 0 then SalesLine.Validate("Unit Price", Round(4820 / Quantity, 0.0000001));
        if(MonthlyConsumptionRange = MonthlyConsumptionRange::" ") and (DomesticMonthlyConsumptionRange = DomesticMonthlyConsumptionRange::" ")then begin
            SalesLine.Validate("Acciso Starting Range", 0);
            SalesLine.Validate("Acciso Ending Range", 999999999);
        end
        else if MonthlyConsumptionRange = MonthlyConsumptionRange::" " then case DomesticMonthlyConsumptionRange of DomesticMonthlyConsumptionRange::"0 - 150 kWh": begin
                    SalesLine.Validate("Acciso Starting Range", 0);
                    SalesLine.Validate("Acciso Ending Range", 150);
                end;
                DomesticMonthlyConsumptionRange::"151 - 220 kWh": begin
                    SalesLine.Validate("Acciso Starting Range", 151);
                    SalesLine.Validate("Acciso Ending Range", 220);
                end;
                DomesticMonthlyConsumptionRange::"221 - 370 kWh": begin
                    SalesLine.Validate("Acciso Starting Range", 221);
                    SalesLine.Validate("Acciso Ending Range", 370);
                end;
                DomesticMonthlyConsumptionRange::"371 - Unlimited kWh": begin
                    SalesLine.Validate("Acciso Starting Range", 371);
                    SalesLine.Validate("Acciso Ending Range", 999999999);
                end;
                end
            else
                case MonthlyConsumptionRange of MonthlyConsumptionRange::"0 KWH - 200.000 KWH": begin
                    SalesLine.Validate("Acciso Starting Range", 0);
                    SalesLine.Validate("Acciso Ending Range", 200000);
                end;
                MonthlyConsumptionRange::"200.001 - 1.200.000 kWh": begin
                    SalesLine.Validate("Acciso Starting Range", 200001);
                    SalesLine.Validate("Acciso Ending Range", 1200000);
                end;
                MonthlyConsumptionRange::"> 1.200.001 KWH": begin
                    SalesLine.Validate("Acciso Starting Range", 1200001);
                    SalesLine.Validate("Acciso Ending Range", 999999999);
                end;
                end;
        SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
        SalesLine.Insert();
        DetailedPriceCalcEntries.Reset();
        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
        DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
        DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
        if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                DetailedPriceCalcEntries.Modify();
            until DetailedPriceCalcEntries.Next() = 0;
        UTFAnnual.Reset();
        UTFAnnual.SetCurrentKey("Entry No.");
        if UTFAnnual.FindLast()then LastEntryNo:=UTFAnnual."Entry No.";
        Clear(UTFAnnual);
        UTFAnnual.Init();
        UTFAnnual."Entry No.":=LastEntryNo + 1;
        if SalesLine."Unit Price" <> 0 then begin
            if(Contract."Contract Type" = Contract."Contract Type"::"01") and (Contract.Resident)then UTFAnnual."Quadro No.":='M1'
            else if(Contract."Contract Type" = Contract."Contract Type"::"02") and (not Contract.Resident)then UTFAnnual."Quadro No.":='M2'
                else
                    UTFAnnual."Quadro No.":='M';
        end
        else if Contract."Quadro LB5" then UTFAnnual."Quadro No.":='LB5'
            else if Contract."Quadro LB6" then UTFAnnual."Quadro No.":='LB6'
                else if(SalesLine."Unit Price" = 0) and (Contract."Annual Consumption" < 1800)then UTFAnnual."Quadro No.":='LB9'
                    else if(SalesLine."Unit Price" = 0) and (Contract."Quadro M3")then UTFAnnual."Quadro No.":='M3'
                        else if(SalesLine."Unit Price" = 0) and (Contract.Usage <> Contract.Usage::Domestic)then UTFAnnual."Quadro No.":='M9';
        UTFAnnual."Contract No.":=Contract."No.";
        UTFAnnual."POD No.":=Contract."POD No.";
        UTFAnnual."Document No.":=SalesHeader."No.";
        UTFAnnual."Customer Name":=Contract."Customer Name";
        UTFAnnual."Cadastral Municipality Code":=Contract."Cadastral Municipality Code";
        UTFAnnual."Contract Type":=Contract."Contract Type";
        UTFAnnual.Usage:=Contract.Usage;
        UTFAnnual."Physical County Code":=Contract."Physical County Code";
        UTFAnnual."Physical City":=Contract."Physical City";
        UTFAnnual."Posting Date":=SalesHeader."Posting Date";
        UTFAnnual."Acciso Starting Range":=SalesLine."Acciso Starting Range";
        UTFAnnual."Acciso Ending Range":=SalesLine."Acciso Ending Range";
        UTFAnnual."Acciso Consumption":=SalesLine.Quantity;
        UTFAnnual."Unit Price":=SalesLine."Unit Price";
        UTFAnnual.Amount:=SalesLine."Line Amount";
        if Contract."Contract Type" = Contract."Contract Type"::"01" then UTFAnnual.Residenza:=true;
        if DomesticMonthlyConsumptionRange = DomesticMonthlyConsumptionRange::"0 - 150 kWh" then UTFAnnual."Essente Accise":=true;
        UTFAnnual.Insert();
    end;
    local procedure CreateSalesLineNew(SalesHeader: Record "Sales Header"; Contract: Record Contract; TariffLine: Record "Tariff Line"; StartOfMonthDate: Date; EndDate: Date)
    var
        Customer: Record Customer;
        Measurement: Record Measurement;
        Resource: Record Resource;
        DetailedPriceCalcEntries: Record "Detailed Price Calc. Entry";
        DiscountPriceHeader: Record "Discount Price Header";
        DiscountSelection: Record "Discount Selection";
        Language: Record Language;
        UTFAnnual: Record "UTF Annual List";
        UnitOfMeasure: Record "Unit of Measure";
        SalesLine: Record "Sales Line";
        UtilitySetup: Record "Utility Setup";
        TariffCalcManagement: Codeunit "Tariff Calculation Management";
        Quantity: Decimal;
        ActiveTypeList: List of[Integer];
        ReactiveTypeList: List of[Integer];
        Consumption: Decimal;
        ActiveStartDate: Date;
        ActiveEndDate: Date;
        I: Integer;
        LastEntryNo: Integer;
        ActiveTypeGermen: Enum "Active Type Germen";
        ActiveTypeItalian: Enum "Active Type Italian";
        ReactiveGermen: Enum "Reactive Type Germen";
        ReactiveItalian: Enum "Reactive Type Italian";
        NetLossVar: Text[20];
        DiscountVar: Text[20];
        LanguageCode: Code[5];
        ReactiveSkip: Boolean;
        ErrorLbl: Label 'Measurement does not exist for POD No: %1 and Date Range: %2 to %3', Comment = 'Measurement does not exist for POD No: %1 and Date Range: %2 to %3';
        NetLossLbl: Label 'Net Loss', Comment = 'Net Loss';
        NetLossGermenLbl: Label 'Netzverlust', Comment = 'Netzverlust';
        NetLossItalianLbl: Label 'Perdita rete', Comment = 'Perdita rete';
        DiscountLbl: Label 'Discount', Comment = 'Discount';
        DiscountGermenLbl: Label 'Skonto', Comment = 'Skonto';
        DiscountItalianLbl: Label 'Sconto', Comment = 'Sconto';
    begin
        LanguageCode:='';
        if Customer.get(SalesHeader."Sell-to Customer No.")then if Language.Get(Customer."Language Code")then case Language."Windows Language ID" of 1040: begin
                    NetLossVar:=NetLossItalianLbl;
                    DiscountVar:=DiscountItalianLbl;
                    LanguageCode:='IT';
                end;
                2064: begin
                    NetLossVar:=NetLossItalianLbl;
                    DiscountVar:=DiscountItalianLbl;
                    LanguageCode:='IT';
                end;
                5127: begin
                    NetLossVar:=NetLossGermenLbl;
                    DiscountVar:=DiscountGermenLbl;
                    LanguageCode:='DE';
                end;
                3079: begin
                    NetLossVar:=NetLossGermenLbl;
                    DiscountVar:=DiscountGermenLbl;
                    LanguageCode:='DE';
                end;
                4103: begin
                    NetLossVar:=NetLossGermenLbl;
                    DiscountVar:=DiscountGermenLbl;
                    LanguageCode:='DE';
                end;
                1031: begin
                    NetLossVar:=NetLossGermenLbl;
                    DiscountVar:=DiscountGermenLbl;
                    LanguageCode:='DE';
                end;
                else
                begin
                    NetLossVar:=NetLossLbl;
                    DiscountVar:=DiscountLbl;
                    LanguageCode:='ENG';
                end;
                end
            else
            begin
                NetLossVar:=NetLossLbl;
                DiscountVar:=DiscountLbl;
                LanguageCode:='ENG';
            end;
        UtilitySetup.Get();
        case TariffLine."Line Cost Type" of TariffLine."Line Cost Type"::"Acciso Cost": begin
            ActiveStartDate:=StartOfMonthDate;
            ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
            repeat Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                if(Contract.Usage = Contract.Usage::Domestic) and (Contract."Contract Type" = Contract."Contract Type"::"01")then begin
                    if Contract."Contractual Power" <= 3 then begin
                        CalculateConsumption(Contract, ActiveStartDate, ActiveEndDate, Consumption);
                        case Consumption of 0 .. 150: InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"0 - 150 kWh");
                        151 .. 220: begin
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"0 - 150 kWh");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"151 - 220 kWh");
                        end;
                        221 .. 370: begin
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"0 - 150 kWh");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"151 - 220 kWh");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"221 - 370 kWh");
                            Clear(TariffCalcManagement);
                            Clear(SalesLine);
                            SalesLine.Init();
                            SalesLine.Validate("Document Type", SalesHeader."Document Type");
                            SalesLine.Validate("Document No.", SalesHeader."No.");
                            SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                            SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                            SalesLine.Validate("No.", TariffLine."Resource No.");
                            SalesLine.Validate("Effective Start Date", ActiveStartDate);
                            SalesLine.Validate("Effective End Date", ActiveEndDate);
                            SalesLine.Validate("Unit Price", 0);
                            SalesLine.Validate(Quantity, -(Consumption - 220));
                            SalesLine.Validate("Acciso Starting Range", 0);
                            SalesLine.Validate("Acciso Ending Range", 150);
                            SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                            SalesLine.Insert();
                            LastEntryNo:=0;
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetCurrentKey("Entry No.");
                            if DetailedPriceCalcEntries.FindLast()then LastEntryNo:=DetailedPriceCalcEntries."Entry No.";
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.Init();
                            DetailedPriceCalcEntries."Entry No.":=LastEntryNo + 1;
                            DetailedPriceCalcEntries."Document Type":=DetailedPriceCalcEntries."Document Type"::Invoice;
                            DetailedPriceCalcEntries."Invoice No.":=SalesLine."Document No.";
                            DetailedPriceCalcEntries."Line No.":=SalesLine."Line No.";
                            DetailedPriceCalcEntries.Price:=SalesLine."Unit Price";
                            DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                            DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                            DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                            DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                            DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                            DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                            DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                            DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                            DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                            DetailedPriceCalcEntries.Insert();
                            UTFAnnual.Reset();
                            UTFAnnual.SetCurrentKey("Entry No.");
                            if UTFAnnual.FindLast()then LastEntryNo:=UTFAnnual."Entry No.";
                            Clear(UTFAnnual);
                            UTFAnnual.Init();
                            UTFAnnual."Entry No.":=LastEntryNo + 1;
                            if SalesLine."Unit Price" <> 0 then begin
                                if(Contract."Contract Type" = Contract."Contract Type"::"01") and (Contract.Resident)then UTFAnnual."Quadro No.":='M1'
                                else if(Contract."Contract Type" = Contract."Contract Type"::"02") and (not Contract.Resident)then UTFAnnual."Quadro No.":='M2'
                                    else
                                        UTFAnnual."Quadro No.":='M';
                            end
                            else if Contract."Quadro LB5" then UTFAnnual."Quadro No.":='LB5'
                                else if Contract."Quadro LB6" then UTFAnnual."Quadro No.":='LB6'
                                    else if(SalesLine."Unit Price" = 0) and (Contract."Annual Consumption" < 1800)then UTFAnnual."Quadro No.":='LB9'
                                        else if(SalesLine."Unit Price" = 0) and (Contract."Quadro M3")then UTFAnnual."Quadro No.":='M3'
                                            else if(SalesLine."Unit Price" = 0) and (Contract.Usage <> Contract.Usage::Domestic)then UTFAnnual."Quadro No.":='M9';
                            UTFAnnual."Contract No.":=Contract."No.";
                            UTFAnnual."POD No.":=Contract."POD No.";
                            UTFAnnual."Document No.":=SalesHeader."No.";
                            UTFAnnual."Customer Name":=Contract."Customer Name";
                            UTFAnnual."Cadastral Municipality Code":=Contract."Cadastral Municipality Code";
                            UTFAnnual."Contract Type":=Contract."Contract Type";
                            UTFAnnual.Usage:=Contract.Usage;
                            UTFAnnual."Physical County Code":=Contract."Physical County Code";
                            UTFAnnual."Physical City":=Contract."Physical City";
                            UTFAnnual."Posting Date":=SalesHeader."Posting Date";
                            UTFAnnual."Acciso Starting Range":=SalesLine."Acciso Starting Range";
                            UTFAnnual."Acciso Ending Range":=SalesLine."Acciso Ending Range";
                            UTFAnnual."Acciso Consumption":=SalesLine.Quantity;
                            UTFAnnual."Unit Price":=SalesLine."Unit Price";
                            UTFAnnual.Amount:=SalesLine."Line Amount";
                            if Contract."Contract Type" = Contract."Contract Type"::"01" then UTFAnnual.Residenza:=true;
                            UTFAnnual."Recupero Accise":=true;
                            UTFAnnual.Insert();
                        end;
                        else
                        begin
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"0 - 150 kWh");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"151 - 220 kWh");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"221 - 370 kWh");
                            Clear(TariffCalcManagement);
                            Clear(SalesLine);
                            SalesLine.Init();
                            SalesLine.Validate("Document Type", SalesHeader."Document Type");
                            SalesLine.Validate("Document No.", SalesHeader."No.");
                            SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                            SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                            SalesLine.Validate("No.", TariffLine."Resource No.");
                            SalesLine.Validate("Effective Start Date", ActiveStartDate);
                            SalesLine.Validate("Effective End Date", ActiveEndDate);
                            SalesLine.Validate("Unit Price", 0);
                            SalesLine.Validate(Quantity, -150);
                            SalesLine.Validate("Acciso Starting Range", 0);
                            SalesLine.Validate("Acciso Ending Range", 150);
                            SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                            SalesLine.Insert();
                            LastEntryNo:=0;
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetCurrentKey("Entry No.");
                            if DetailedPriceCalcEntries.FindLast()then LastEntryNo:=DetailedPriceCalcEntries."Entry No.";
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.Init();
                            DetailedPriceCalcEntries."Entry No.":=LastEntryNo + 1;
                            DetailedPriceCalcEntries."Document Type":=DetailedPriceCalcEntries."Document Type"::Invoice;
                            DetailedPriceCalcEntries."Invoice No.":=SalesLine."Document No.";
                            DetailedPriceCalcEntries."Line No.":=SalesLine."Line No.";
                            DetailedPriceCalcEntries.Price:=SalesLine."Unit Price";
                            DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                            DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                            DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                            DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                            DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                            DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                            DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                            DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                            DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                            DetailedPriceCalcEntries.Insert();
                            UTFAnnual.Reset();
                            UTFAnnual.SetCurrentKey("Entry No.");
                            if UTFAnnual.FindLast()then LastEntryNo:=UTFAnnual."Entry No.";
                            Clear(UTFAnnual);
                            UTFAnnual.Init();
                            UTFAnnual."Entry No.":=LastEntryNo + 1;
                            if SalesLine."Unit Price" <> 0 then begin
                                if(Contract."Contract Type" = Contract."Contract Type"::"01") and (Contract.Resident)then UTFAnnual."Quadro No.":='M1'
                                else if(Contract."Contract Type" = Contract."Contract Type"::"02") and (not Contract.Resident)then UTFAnnual."Quadro No.":='M2'
                                    else
                                        UTFAnnual."Quadro No.":='M';
                            end
                            else if Contract."Quadro LB5" then UTFAnnual."Quadro No.":='LB5'
                                else if Contract."Quadro LB6" then UTFAnnual."Quadro No.":='LB6'
                                    else if(SalesLine."Unit Price" = 0) and (Contract."Annual Consumption" < 1800)then UTFAnnual."Quadro No.":='LB9'
                                        else if(SalesLine."Unit Price" = 0) and (Contract."Quadro M3")then UTFAnnual."Quadro No.":='M3'
                                            else if(SalesLine."Unit Price" = 0) and (Contract.Usage <> Contract.Usage::Domestic)then UTFAnnual."Quadro No.":='M9';
                            UTFAnnual."Contract No.":=Contract."No.";
                            UTFAnnual."POD No.":=Contract."POD No.";
                            UTFAnnual."Document No.":=SalesHeader."No.";
                            UTFAnnual."Customer Name":=Contract."Customer Name";
                            UTFAnnual."Cadastral Municipality Code":=Contract."Cadastral Municipality Code";
                            UTFAnnual."Contract Type":=Contract."Contract Type";
                            UTFAnnual.Usage:=Contract.Usage;
                            UTFAnnual."Physical County Code":=Contract."Physical County Code";
                            UTFAnnual."Physical City":=Contract."Physical City";
                            UTFAnnual."Posting Date":=SalesHeader."Posting Date";
                            UTFAnnual."Acciso Starting Range":=SalesLine."Acciso Starting Range";
                            UTFAnnual."Acciso Ending Range":=SalesLine."Acciso Ending Range";
                            UTFAnnual."Acciso Consumption":=SalesLine.Quantity;
                            UTFAnnual."Unit Price":=SalesLine."Unit Price";
                            UTFAnnual.Amount:=SalesLine."Line Amount";
                            if Contract."Contract Type" = Contract."Contract Type"::"01" then UTFAnnual.Residenza:=true;
                            UTFAnnual."Recupero Accise":=true;
                            UTFAnnual.Insert();
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::"371 - Unlimited kWh");
                        end;
                        end;
                    end
                    else
                        InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ");
                end
                else if(Contract.Usage = Contract.Usage::Domestic) and (Contract."Contract Type" = Contract."Contract Type"::"02")then InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ")
                    else
                    begin
                        CalculateConsumption(Contract, ActiveStartDate, ActiveEndDate, Consumption);
                        case Consumption of 0 .. 200000: InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::"0 KWH - 200.000 KWH", "Domestic Monthly Consum. Range"::" ");
                        200001 .. 1200000: begin
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::"0 KWH - 200.000 KWH", "Domestic Monthly Consum. Range"::" ");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::"200.001 - 1.200.000 kWh", "Domestic Monthly Consum. Range"::" ");
                        end;
                        else
                        begin
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::"0 KWH - 200.000 KWH", "Domestic Monthly Consum. Range"::" ");
                            InsertAccisoLines(SalesHeader, Contract, TariffLine, ActiveStartDate, ActiveEndDate, "Monthly Consumption Range"::"> 1.200.001 KWH", "Domestic Monthly Consum. Range"::" ");
                        end;
                        end;
                    end;
                ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
            until ActiveEndDate > EndDate;
        end;
        TariffLine."Line Cost Type"::"Energy Sale Cost": begin
            ActiveTypeList:=SelectBasedOnMeterReadingDetectionActive(Contract);
            ActiveStartDate:=StartOfMonthDate;
            ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
            repeat Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                foreach I in ActiveTypeList do begin
                    Clear(SalesLine);
                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                    SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                    SalesLine.Validate("No.", TariffLine."Resource No.");
                    SalesLine.Validate("Active Type", I);
                    ActiveTypeGermen:=I;
                    ActiveTypeItalian:=I;
                    if LanguageCode = 'DE' then SalesLine.Validate("Invoice Active Type", Format(ActiveTypeGermen))
                    else if LanguageCode = 'IT' then Salesline.Validate("Invoice ACtive Type", Format(ActiveTypeItalian))
                        else
                            SalesLine.Validate("Invoice Active Type", Format(SalesLine."Active Type"));
                    SalesLine.Validate("Effective Start Date", ActiveStartDate);
                    SalesLine.Validate("Effective End Date", ActiveEndDate);
                    SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                    SalesLine.Validate(Quantity, Quantity);
                    SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                    SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                    if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                        else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                    if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE")
                        else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT");
                    if(SalesLine."Unit Price" <> 0)then begin
                        SalesLine.Insert();
                        DetailedPriceCalcEntries.Reset();
                        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                        DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                        DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                        if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                DetailedPriceCalcEntries.Modify();
                            until DetailedPriceCalcEntries.Next() = 0;
                    end
                    else
                    begin
                        DetailedPriceCalcEntries.Reset();
                        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                        DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                        DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                        if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                    end;
                end;
                foreach I in ActiveTypeList do begin
                    Clear(SalesLine);
                    SalesLine.Init();
                    SalesLine.Validate("Document Type", SalesHeader."Document Type");
                    SalesLine.Validate("Document No.", SalesHeader."No.");
                    SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                    SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                    SalesLine.Validate("No.", TariffLine."Resource No.");
                    SalesLine.Description+=' ' + NetLossVar;
                    SalesLine.Validate("Active Type", I);
                    ActiveTypeGermen:=I;
                    ActiveTypeItalian:=I;
                    if LanguageCode = 'DE' then SalesLine.Validate("Invoice Active Type", Format(ActiveTypeGermen))
                    else if LanguageCode = 'IT' then Salesline.Validate("Invoice ACtive Type", Format(ActiveTypeItalian))
                        else
                            SalesLine.Validate("Invoice Active Type", Format(SalesLine."Active Type"));
                    SalesLine.Validate("Effective Start Date", ActiveStartDate);
                    SalesLine.Validate("Effective End Date", ActiveEndDate);
                    SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", true, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                    SalesLine.Validate(Quantity, Quantity);
                    SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                    SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                    if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                        else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                    if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE" + ' ' + NetLossVar)
                        else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT" + ' ' + NetLossVar);
                    if(SalesLine."Unit Price" <> 0)then begin
                        SalesLine.Insert();
                        DetailedPriceCalcEntries.Reset();
                        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                        DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                        DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                        if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                DetailedPriceCalcEntries.Modify();
                            until DetailedPriceCalcEntries.Next() = 0;
                    end
                    else
                    begin
                        DetailedPriceCalcEntries.Reset();
                        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                        DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                        DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                        if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                    end;
                end;
                DiscountSelection.Reset();
                DiscountSelection.SetRange("Contract No.", Contract."No.");
                DiscountSelection.SetFilter("Annual Consumption From", '<=%1', Contract."Annual Consumption");
                DiscountSelection.SetFilter("Annual Consumption To", '>=%1', Contract."Annual Consumption");
                if DiscountSelection.FindFirst()then if DiscountPriceHeader.Get(DiscountSelection."Discount ID")then foreach I in ActiveTypeList do begin
                            Clear(SalesLine);
                            SalesLine.Init();
                            SalesLine.Validate("Document Type", SalesHeader."Document Type");
                            SalesLine.Validate("Document No.", SalesHeader."No.");
                            SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                            SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                            SalesLine.Validate("No.", TariffLine."Resource No.");
                            SalesLine.Description:=DiscountVar + ' ' + SalesLine.Description;
                            SalesLine.Validate("Active Type", I);
                            ActiveTypeGermen:=I;
                            ActiveTypeItalian:=I;
                            if LanguageCode = 'DE' then SalesLine.Validate("Invoice Active Type", Format(ActiveTypeGermen))
                            else if LanguageCode = 'IT' then Salesline.Validate("Invoice ACtive Type", Format(ActiveTypeItalian))
                                else
                                    SalesLine.Validate("Invoice Active Type", Format(SalesLine."Active Type"));
                            SalesLine.Validate("Effective Start Date", ActiveStartDate);
                            SalesLine.Validate("Effective End Date", ActiveEndDate);
                            SalesLine.Validate("Unit Price", -Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, true, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                            SalesLine.Validate(Quantity, Quantity);
                            SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                            SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                            if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                                else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                            if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name DE")
                                else if LanguageCode = 'IT' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name IT");
                            if(SalesLine."Unit Price" <> 0)then begin
                                SalesLine.Insert();
                                DetailedPriceCalcEntries.Reset();
                                DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                                DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                                DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                                if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                        DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                        DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                        DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                        DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                        DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                        DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                        DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                        DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                        DetailedPriceCalcEntries.Modify();
                                    until DetailedPriceCalcEntries.Next() = 0;
                            end
                            else
                            begin
                                DetailedPriceCalcEntries.Reset();
                                DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                                DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                                DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                                if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                            end;
                        end;
                ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
            until ActiveEndDate > EndDate;
        end;
        TariffLine."Line Cost Type"::"Energy Reactive Cost": begin
            ReactiveSkip:=false;
            if not(Contract."Voltage Type" in[Contract."Voltage Type"::MT, Contract."Voltage Type"::AT])then if(Contract."Contractual Power" <= UtilitySetup."Reactive Calc Threshold")then ReactiveSkip:=true;
            if not ReactiveSkip then begin
                ReactiveTypeList:=SelectBasedOnMeterReadingDetectionReactive(Contract);
                ActiveStartDate:=StartOfMonthDate;
                ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
                repeat Measurement.Reset();
                    Measurement.SetRange("POD No.", Contract."POD No.");
                    Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                    if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                    foreach I in ReactiveTypeList do begin
                        Clear(SalesLine);
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                        SalesLine.Validate("No.", TariffLine."Resource No.");
                        SalesLine.Validate("Reactive Type", I);
                        ReactiveGermen:=I;
                        ReactiveItalian:=I;
                        if LanguageCode = 'DE' then SalesLine.Validate("Invoice Reactive Type", Format(ReactiveGermen))
                        else if LanguageCode = 'IT' then Salesline.Validate("Invoice Reactive Type", Format(ReactiveItalian))
                            else
                                SalesLine.Validate("Invoice Reactive Type", Format(SalesLine."Reactive Type"));
                        SalesLine.Validate("Effective Start Date", ActiveStartDate);
                        SalesLine.Validate("Effective End Date", ActiveEndDate);
                        SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                        SalesLine.Validate(Quantity, Quantity);
                        SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                        SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                        if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                        if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT");
                        if(SalesLine.Quantity <> 0)then begin
                            SalesLine.Insert();
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                    DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                    DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                    DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                    DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                    DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                    DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                    DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                    DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                    DetailedPriceCalcEntries.Modify();
                                until DetailedPriceCalcEntries.Next() = 0;
                        end
                        else
                        begin
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                        end;
                    end;
                    DiscountSelection.Reset();
                    DiscountSelection.SetRange("Contract No.", Contract."No.");
                    DiscountSelection.SetFilter("Annual Consumption From", '<=%1', Contract."Annual Consumption");
                    DiscountSelection.SetFilter("Annual Consumption To", '>=%1', Contract."Annual Consumption");
                    if DiscountSelection.FindFirst()then if DiscountPriceHeader.Get(DiscountSelection."Discount ID")then foreach I in ReactiveTypeList do begin
                                Clear(SalesLine);
                                SalesLine.Init();
                                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                                SalesLine.Validate("Document No.", SalesHeader."No.");
                                SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                                SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                                SalesLine.Validate("No.", TariffLine."Resource No.");
                                SalesLine.Description:=DiscountVar + ' ' + SalesLine.Description;
                                SalesLine.Validate("Reactive Type", I);
                                ReactiveGermen:=I;
                                ReactiveItalian:=I;
                                if LanguageCode = 'DE' then SalesLine.Validate("Invoice Reactive Type", Format(ReactiveGermen))
                                else if LanguageCode = 'IT' then Salesline.Validate("Invoice Reactive Type", Format(ReactiveItalian))
                                    else
                                        SalesLine.Validate("Invoice Reactive Type", Format(SalesLine."Reactive Type"));
                                SalesLine.Validate("Effective Start Date", ActiveStartDate);
                                SalesLine.Validate("Effective End Date", ActiveEndDate);
                                SalesLine.Validate("Unit Price", -Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, true, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                                SalesLine.Validate(Quantity, Quantity);
                                SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                                SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                                if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                                    else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                                if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name DE")
                                    else if LanguageCode = 'IT' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name IT");
                                if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then begin
                                    SalesLine.Insert();
                                    DetailedPriceCalcEntries.Reset();
                                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                                    if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                            DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                            DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                            DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                            DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                            DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                            DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                            DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                            DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                            DetailedPriceCalcEntries.Modify();
                                        until DetailedPriceCalcEntries.Next() = 0;
                                end
                                else
                                begin
                                    DetailedPriceCalcEntries.Reset();
                                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                                    if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                                end;
                            end;
                    ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                    ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
                until ActiveEndDate > EndDate;
            end;
        end;
        TariffLine."Line Cost Type"::"System Cost": begin
            ActiveStartDate:=StartOfMonthDate;
            ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
            repeat Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                Clear(TariffCalcManagement);
                Clear(SalesLine);
                Quantity:=0;
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                SalesLine.Validate("No.", TariffLine."Resource No.");
                SalesLine.Validate("Effective Start Date", ActiveStartDate);
                SalesLine.Validate("Effective End Date", ActiveEndDate);
                SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, true, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                SalesLine.Validate(Quantity, Quantity);
                SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT");
                if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then begin
                    SalesLine.Insert();
                    DetailedPriceCalcEntries.Reset();
                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                    if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                            DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                            DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                            DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                            DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                            DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                            DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                            DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                            DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                            DetailedPriceCalcEntries.Modify();
                        until DetailedPriceCalcEntries.Next() = 0;
                end
                else
                begin
                    DetailedPriceCalcEntries.Reset();
                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                    if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                end;
                DiscountSelection.Reset();
                DiscountSelection.SetRange("Contract No.", Contract."No.");
                DiscountSelection.SetFilter("Annual Consumption From", '<=%1', Contract."Annual Consumption");
                DiscountSelection.SetFilter("Annual Consumption To", '>=%1', Contract."Annual Consumption");
                if DiscountSelection.FindFirst()then if DiscountPriceHeader.Get(DiscountSelection."Discount ID")then begin
                        Clear(TariffCalcManagement);
                        Clear(SalesLine);
                        Quantity:=0;
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                        SalesLine.Validate("No.", TariffLine."Resource No.");
                        SalesLine.Description:=DiscountVar + ' ' + SalesLine.Description;
                        SalesLine.Validate("Effective Start Date", ActiveStartDate);
                        SalesLine.Validate("Effective End Date", ActiveEndDate);
                        SalesLine.Validate("Unit Price", -Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, true, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, true, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                        SalesLine.Validate(Quantity, Quantity);
                        SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                        SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                        if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                        if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name IT");
                        if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then begin
                            SalesLine.Insert();
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                    DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                    DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                    DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                    DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                    DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                    DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                    DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                    DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                    DetailedPriceCalcEntries.Modify();
                                until DetailedPriceCalcEntries.Next() = 0;
                        end
                        else
                        begin
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                        end;
                    end;
                ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
            until ActiveEndDate > EndDate;
        end;
        TariffLine."Line Cost Type"::"Transport Cost": begin
            ActiveStartDate:=StartOfMonthDate;
            ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
            repeat Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                Clear(SalesLine);
                Clear(TariffCalcManagement);
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                SalesLine.Validate("No.", TariffLine."Resource No.");
                SalesLine.Validate("Effective Start Date", ActiveStartDate);
                SalesLine.Validate("Effective End Date", ActiveEndDate);
                SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, true, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                SalesLine.Validate(Quantity, Quantity);
                SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT");
                if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then begin
                    SalesLine.Insert();
                    DetailedPriceCalcEntries.Reset();
                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                    if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                            DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                            DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                            DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                            DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                            DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                            DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                            DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                            DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                            DetailedPriceCalcEntries.Modify();
                        until DetailedPriceCalcEntries.Next() = 0;
                end
                else
                begin
                    DetailedPriceCalcEntries.Reset();
                    DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                    DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                    DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                    if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                end;
                DiscountSelection.Reset();
                DiscountSelection.SetRange("Contract No.", Contract."No.");
                DiscountSelection.SetFilter("Annual Consumption From", '<=%1', Contract."Annual Consumption");
                DiscountSelection.SetFilter("Annual Consumption To", '>=%1', Contract."Annual Consumption");
                if DiscountSelection.FindFirst()then if DiscountPriceHeader.Get(DiscountSelection."Discount ID")then begin
                        Clear(SalesLine);
                        Clear(TariffCalcManagement);
                        SalesLine.Init();
                        SalesLine.Validate("Document Type", SalesHeader."Document Type");
                        SalesLine.Validate("Document No.", SalesHeader."No.");
                        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                        SalesLine.Validate("No.", TariffLine."Resource No.");
                        SalesLine.Description:=DiscountVar + ' ' + SalesLine.Description;
                        SalesLine.Validate("Effective Start Date", ActiveStartDate);
                        SalesLine.Validate("Effective End Date", ActiveEndDate);
                        SalesLine.Validate("Unit Price", -Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, true, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, true, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                        SalesLine.Validate(Quantity, Quantity);
                        SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                        SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                        if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                        if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name DE")
                            else if LanguageCode = 'IT' then SalesLine.Validate(Description, DiscountVar + ' ' + Resource."Name IT");
                        if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then begin
                            SalesLine.Insert();
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then repeat DetailedPriceCalcEntries.Validate("Resource No.", SalesLine."No.");
                                    DetailedPriceCalcEntries.Validate(Description, SalesLine.Description);
                                    DetailedPriceCalcEntries.Validate(Quantity, SalesLine.Quantity);
                                    DetailedPriceCalcEntries.Validate("Dyn. Inv. Template No.", SalesLine."Dyn. Inv. Template No.");
                                    DetailedPriceCalcEntries.Validate("Active Type", SalesLine."Active Type");
                                    DetailedPriceCalcEntries.Validate("Reactive Type", SalesLine."Reactive Type");
                                    DetailedPriceCalcEntries.Validate("Line Amount", SalesLine.Quantity * DetailedPriceCalcEntries.Price);
                                    DetailedPriceCalcEntries.Validate("Effective Start Date", SalesLine."Effective Start Date");
                                    DetailedPriceCalcEntries.Validate("Effective End Date", SalesLine."Effective End Date");
                                    DetailedPriceCalcEntries.Modify();
                                until DetailedPriceCalcEntries.Next() = 0;
                        end
                        else
                        begin
                            DetailedPriceCalcEntries.Reset();
                            DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
                            DetailedPriceCalcEntries.SetRange("Invoice No.", SalesLine."Document No.");
                            DetailedPriceCalcEntries.SetRange("Line No.", SalesLine."Line No.");
                            if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
                        end;
                    end;
                ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
            until ActiveEndDate > EndDate;
        end;
        TariffLine."Line Cost Type"::Discount: begin
            ActiveStartDate:=StartOfMonthDate;
            ActiveEndDate:=CalcDate('<+CM>', StartOfMonthDate);
            repeat Measurement.Reset();
                Measurement.SetRange("POD No.", Contract."POD No.");
                Measurement.SetRange(Date, ActiveStartDate, ActiveEndDate);
                if Measurement.IsEmpty()then Error(ErrorLbl, Contract."POD No.", ActiveStartDate, ActiveEndDate);
                Clear(TariffCalcManagement);
                Clear(SalesLine);
                SalesLine.Init();
                SalesLine.Validate("Document Type", SalesHeader."Document Type");
                SalesLine.Validate("Document No.", SalesHeader."No.");
                SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
                SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
                SalesLine.Validate("No.", TariffLine."Resource No.");
                SalesLine.Validate("Effective Start Date", ActiveStartDate);
                SalesLine.Validate("Effective End Date", ActiveEndDate);
                SalesLine.Validate("Unit Price", Round(TariffCalcManagement.CalculateUnitPrice(TariffLine, Contract, ActiveStartDate, ActiveEndDate, SalesLine."Active Type", SalesLine."Reactive Type", false, Quantity, false, "Monthly Consumption Range"::" ", "Domestic Monthly Consum. Range"::" ", false, false, SalesLine."Document No.", SalesLine."Line No."), 0.0000001));
                SalesLine.Validate(Quantity, Quantity);
                SalesLine.Validate("Dyn. Inv. Template No.", TariffLine."Dyn. Inv. Template No.");
                SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
                if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
                if Resource.Get(SalesLine."No.")then if LanguageCode = 'DE' then SalesLine.Validate(Description, Resource."Name DE")
                    else if LanguageCode = 'IT' then SalesLine.Validate(Description, Resource."Name IT");
                if(SalesLine.Quantity <> 0) and (SalesLine."Unit Price" <> 0)then SalesLine.Insert();
                ActiveStartDate:=CalcDate('<+1D>', ActiveEndDate);
                ActiveEndDate:=CalcDate('<+CM>', ActiveStartDate);
            until ActiveEndDate > EndDate;
        end;
        end;
    end;
    local procedure CalculateConsumption(Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date; var MonthlyConsumption: Decimal)
    var
        Meter: Record Meter;
        Measurement: Record Measurement;
        TotalValueActive: Decimal;
        LastTotalValueActive: Decimal;
    begin
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then if Meter."Reading Type" = Meter."Reading Type"::Consumption then begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                if Measurement.FindSet()then begin
                    Measurement.CalcSums("Active Total");
                    MonthlyConsumption:=Measurement."Active Total";
                end;
            end
            else
            begin
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetRange(Date, StartOfMonthDate, EndDate);
                if Measurement.FindLast()then TotalValueActive:=Measurement."Active Total";
                Measurement.Reset();
                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                Measurement.SetRange("POD No.", Meter."POD No.");
                Measurement.SetRange("Meter Serial No.", Meter."Serial No.");
                Measurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                if Measurement.FindLast()then LastTotalValueActive:=Measurement."Active Total";
                MonthlyConsumption:=TotalValueActive - LastTotalValueActive;
            end;
    end;
    local procedure SelectBasedOnMeterReadingDetectionActive(Contract: Record Contract): List of[Integer]var
        Meter: Record Meter;
        ActiveType: Enum "Active Type";
        ActiveTypeList: List of[Integer];
    begin
        Clear(ActiveTypeList);
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then case Meter."Reading Detection" of Meter."Reading Detection"::Monorary: begin
                ActiveTypeList.AddRange(ActiveType.Ordinals);
                ActiveTypeList.RemoveRange(3, 4);
                ActiveTypeList.RemoveAt(1);
            end;
            Meter."Reading Detection"::Bioraria: begin
                ActiveTypeList.AddRange(ActiveType.Ordinals);
                ActiveTypeList.RemoveRange(4, 2);
                ActiveTypeList.RemoveRange(1, 2);
            end;
            Meter."Reading Detection"::Phase: begin
                ActiveTypeList.AddRange(ActiveType.Ordinals);
                ActiveTypeList.RemoveAt(6);
                if ActiveTypeList.RemoveRange(1, 2)then;
            end;
            Meter."Reading Detection"::" ": begin
                ActiveTypeList.AddRange(ActiveType.Ordinals);
                ActiveTypeList.RemoveAt(1);
            end;
            end;
        exit(ActiveTypeList);
    end;
    local procedure SelectBasedOnMeterReadingDetectionReactive(Contract: Record Contract): List of[Integer]var
        Meter: Record Meter;
        ReactiveType: Enum "Reactive Type";
        ReactiveTypeList: List of[Integer];
    begin
        Clear(ReactiveTypeList);
        Meter.Reset();
        Meter.SetRange("POD No.", Contract."POD No.");
        if Meter.FindFirst()then case Meter."Reading Detection" of Meter."Reading Detection"::Monorary: begin
                ReactiveTypeList.AddRange(ReactiveType.Ordinals);
                // ReactiveTypeList.RemoveRange(8, 4);
                ReactiveTypeList.RemoveRange(3, 4);
                ReactiveTypeList.RemoveAt(1);
            end;
            Meter."Reading Detection"::Bioraria: begin
                ReactiveTypeList.AddRange(ReactiveType.Ordinals);
                // ReactiveTypeList.RemoveRange(9, 2);
                // ReactiveTypeList.RemoveAt(7);
                ReactiveTypeList.RemoveRange(4, 2);
                ReactiveTypeList.RemoveRange(1, 2);
            end;
            Meter."Reading Detection"::Phase: begin
                ReactiveTypeList.AddRange(ReactiveType.Ordinals);
                // ReactiveTypeList.RemoveAt(11);
                // ReactiveTypeList.RemoveAt(7);
                ReactiveTypeList.RemoveAt(6);
                ReactiveTypeList.RemoveRange(1, 2);
            end;
            Meter."Reading Detection"::" ": begin
                ReactiveTypeList.AddRange(ReactiveType.Ordinals);
                ReactiveTypeList.RemoveAt(1);
            end;
            end;
        exit(ReactiveTypeList);
    end;
    local procedure CreateSalesLineTelevisionFees(SalesHeader: Record "Sales Header"; Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date; AATAdditionalFeesSII: Record "AAT Additional Fees SII")
    var
        UnitOfMeasure: Record "Unit of Measure";
        UtilitySetup_LRec: Record "Utility Setup";
        TVResource_Lrec: Record Resource;
        SalesLine: Record "Sales Line";
        Customer: Record Customer;
        Language: Record Language;
        LanguageCode: Code[5];
    begin
        LanguageCode:='';
        if Customer.get(SalesHeader."Sell-to Customer No.")then if Language.Get(Customer."Language Code")then case Language."Windows Language ID" of 1040: LanguageCode:='IT';
                2064: LanguageCode:='IT';
                5127: LanguageCode:='DE';
                3079: LanguageCode:='DE';
                4103: LanguageCode:='DE';
                1031: LanguageCode:='DE';
                else
                    LanguageCode:='ENG';
                end
            else
                LanguageCode:='ENG';
        UtilitySetup_LRec.Get();
        UtilitySetup_LRec.TestField("Television Fees Code");
        if TVResource_Lrec.Get(UtilitySetup_LRec."Television Fees Code")then;
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
        SalesLine.Validate("No.", TVResource_Lrec."No.");
        SalesLine.Validate(Quantity, 1);
        SalesLine.Validate("Unit Price", AATAdditionalFeesSII."AAT Amount SII");
        SalesLine.Validate("Dyn. Inv. Template No.", UtilitySetup_LRec."TV Dyn. Inv. Template No.");
        SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
        SalesLine.Validate("Effective Start Date", StartOfMonthDate);
        SalesLine.Validate("Effective End Date", EndDate);
        if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
            else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
        if LanguageCode = 'DE' then SalesLine.Validate(Description, TVResource_Lrec."Name DE")
        else if LanguageCode = 'IT' then SalesLine.Validate(Description, TVResource_Lrec."Name IT");
        SalesLine.Insert();
    end;
    local procedure CreateSalesLineSocialBonus(SalesHeader: Record "Sales Header"; Contract: Record Contract; StartOfMonthDate: Date; EndDate: Date; AATAdditionalFeesSII: Record "AAT Additional Fees SII")
    var
        UnitOfMeasure: Record "Unit of Measure";
        UtilitySetup_LRec: Record "Utility Setup";
        SBResource_Rec: Record Resource;
        SalesLine: Record "Sales Line";
        AATCompensationSchemeSII: Record "AAT Compensation Scheme SII";
        AATCompensationSchemeLines: Record "AAT Compensation Scheme Lines";
        Customer: Record Customer;
        Language: Record Language;
        RemainingMonth: Integer;
        LanguageCode: Code[5];
        StartDate: Date;
        StringPos: Integer;
        AdditionalMonthlyDisc: Decimal;
    begin
        LanguageCode:='';
        if Customer.get(SalesHeader."Sell-to Customer No.")then if Language.Get(Customer."Language Code")then case Language."Windows Language ID" of 1040: LanguageCode:='IT';
                2064: LanguageCode:='IT';
                5127: LanguageCode:='DE';
                3079: LanguageCode:='DE';
                4103: LanguageCode:='DE';
                1031: LanguageCode:='DE';
                else
                    LanguageCode:='ENG';
                end
            else
                LanguageCode:='ENG';
        UtilitySetup_LRec.Get();
        UtilitySetup_LRec.TestField("Social Bonus Code");
        if SBResource_Rec.get(UtilitySetup_LRec."Social Bonus Code")then;
        SalesLine.Init();
        SalesLine.Validate("Document Type", SalesHeader."Document Type");
        SalesLine.Validate("Document No.", SalesHeader."No.");
        SalesLine.Validate("Line No.", GetNextLineNo(SalesLine));
        SalesLine.Validate(Type, Enum::"Sales Line Type"::Resource);
        if AATAdditionalFeesSII."AAT Outcome SII" = true then begin
            Evaluate(StartDate, CopyStr(SalesHeader."AAT Invoice Contract Period", 1, 8));
            Evaluate(EndDate, CopyStr(SalesHeader."AAT Invoice Contract Period", 11, StrLen(SalesHeader."AAT Invoice Contract Period")));
            if(StartDate >= AATAdditionalFeesSII."AAT Start Date SII") and (EndDate <= AATAdditionalFeesSII."AAT End Date SII")then if AATCompensationSchemeSII.get(AATAdditionalFeesSII."AAT Compensation Scheme", AATAdditionalFeesSII."AAT Valid Year SII")then begin
                    AATCompensationSchemeLines.Reset();
                    AATCompensationSchemeLines.SetRange("AAT Scheme Code", AATCompensationSchemeSII."AAT Code SII");
                    AATCompensationSchemeLines.SetRange("AAT Year", AATCompensationSchemeSII."AAT Year SII");
                    if AATCompensationSchemeLines.findset()then repeat if(StartDate >= AATCompensationSchemeLines."AAT Start Date") and (StartDate < AATCompensationSchemeLines."AAT End Date") and (EndDate <= AATCompensationSchemeLines."AAT End Date")then AdditionalMonthlyDisc:=AATCompensationSchemeLines."AAT Additional Monthly Disc.";
                        until AATCompensationSchemeLines.next() = 0;
                end;
            if Contract."Contract End Date" <> 0D then if(Contract."Deactivation Cause" = Contract."Deactivation Cause"::Switch) and (Calcdate('<+1D>', Contract."Contract End Date") < AATAdditionalFeesSII."AAT End Date SII")then begin
                    SalesLine.Validate("No.", SBResource_Rec."No.");
                    RemainingMonth:=CalculateMonths(Calcdate('<+1D>', Contract."Contract End Date"), AATAdditionalFeesSII."AAT End Date SII");
                    SalesLine.Validate(Quantity, RemainingMonth + 1);
                    SalesLine.Validate("Unit Price", -((AATCompensationSchemeSII."AAT Monthly Discount SII" * RemainingMonth) + AdditionalMonthlyDisc));
                end
                else
                begin
                    SalesLine.Validate("No.", SBResource_Rec."No.");
                    SalesLine.Validate(Quantity, 1);
                    SalesLine.Validate("Unit Price", -(AATCompensationSchemeSII."AAT Monthly Discount SII" + AdditionalMonthlyDisc))end;
        end;
        SalesLine.Validate("Dyn. Inv. Template No.", UtilitySetup_LRec."SB Dyn. Inv. Template No.");
        SalesLine.Validate("Effective Start Date", StartOfMonthDate);
        SalesLine.Validate("Effective End Date", EndDate);
        SalesLine.Validate("Invoice Unit Of Measure", SalesLine."Unit of Measure");
        if UnitOfMeasure.Get(SalesLine."Unit of Measure")then if LanguageCode = 'DE' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM DE")
            else if LanguageCode = 'IT' then SalesLine.Validate("Invoice Unit Of Measure", UnitOfMeasure."UOM IT");
        if LanguageCode = 'DE' then SalesLine.Validate(Description, SBResource_Rec."Name DE")
        else if LanguageCode = 'IT' then SalesLine.Validate(Description, SBResource_Rec."Name IT");
        SalesLine.Insert();
    end;
//KB15022024 - TASK002433 New Billing Calculation ---
}
