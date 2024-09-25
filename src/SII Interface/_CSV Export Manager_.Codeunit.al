codeunit 50201 "CSV Export Manager"
{
    // To be Exported: SE1.0050, VT1.0050, VT1.0040, AE1.0050, RC1.0100
    /// <summary>
    /// Exports the first file of the Switch In Process.
    /// </summary>
    /// <param name="Contract">Record Contract.</param>
    /// <returns>Return variable CSVText of type Text.</returns>
    procedure SwitchInSE10050(var Contract: Record Contract; Recreate: Boolean; var SIILogEntriesErrored: Record "SII Log Entries"; RevocaTimoe: Boolean; AcquistoCredito: Boolean)CSVText: Text var
        VATManagerSetup: Record "VAT Manager Setup";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        Customer: Record Customer;
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        UtilitySetup: Record "Utility Setup";
        SIILogEntries: Record "SII Log Entries";
        SIILogEntries2: Record "SII Log Entries";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CSVDataTempBlob: Codeunit "Temp Blob";
        VATManagerNo: Code[50];
        Recreate2: Boolean;
        FileInStream: InStream;
        LineNo: Integer;
        Filename: Text;
    begin
        SIILogEntries.Copy(SIILogEntriesErrored);
        CompanyInformation.Get();
        SIIInterfaceGeneralSetup.Get();
        LineNo:=1;
        TempCSVBuffer.InsertEntry(LineNo, 1, 'COD_SERVIZIO');
        TempCSVBuffer.InsertEntry(LineNo, 2, 'COD_FLUSSO');
        TempCSVBuffer.InsertEntry(LineNo, 3, 'PIVA_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 4, 'PIVA_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 5, 'CP_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 6, 'COD_POD');
        TempCSVBuffer.InsertEntry(LineNo, 7, 'CF');
        TempCSVBuffer.InsertEntry(LineNo, 8, 'PIVA');
        TempCSVBuffer.InsertEntry(LineNo, 9, 'CF_STRANIERO');
        TempCSVBuffer.InsertEntry(LineNo, 10, 'DATA_CONTRATTO');
        TempCSVBuffer.InsertEntry(LineNo, 11, 'DATA_DECORRENZA');
        TempCSVBuffer.InsertEntry(LineNo, 12, 'REVOCA_TIMOE');
        TempCSVBuffer.InsertEntry(LineNo, 13, 'ACQUISTO_CREDITO');
        TempCSVBuffer.InsertEntry(LineNo, 14, 'COD_CONTR_DISP');
        TempCSVBuffer.InsertEntry(LineNo, 15, 'PIVA_CONTROPARTE_COMMERCIALE');
        TempCSVBuffer.InsertEntry(LineNo, 16, 'CONTRATTO_CONNESSIONE');
        TempCSVBuffer.InsertEntry(LineNo, 17, 'COD_OFFERTA');
        if Contract.FindSet()then repeat //KB140224 - VAT Manager Setup added +++
                UtilitySetup.Get();
                Clear(VATManagerNo);
                if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
                else
                    VATManagerNo:=UtilitySetup."Default VAT Manager No.";
                //KB140224 - VAT Manager Setup added ---
                Recreate2:=Recreate;
                SIILogEntries2.SetRange(Type, "Process Type"::"Switch In");
                SIILogEntries2.SetRange("Contract No.", Contract."No.");
                if not SIILogEntries2.IsEmpty then Recreate2:=true;
                if Customer.Get(Contract."Customer No.")then;
                LineNo+=1;
                TempCSVBuffer.InsertEntry(LineNo, 1, 'SE1');
                TempCSVBuffer.InsertEntry(LineNo, 2, '0050');
                TempCSVBuffer.InsertEntry(LineNo, 3, Format(CompanyInformation."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 4, VATManagerNo); //VAT number of company managing the SII Portal
                if Recreate2 then begin
                    SIILogEntries.SetRange(Type, "Process Type"::"Switch In");
                    SIILogEntries.SetFilter("Contract No.", Contract."No.");
                    if SIILogEntries.FindFirst()then;
                    TempCSVBuffer.InsertEntry(LineNo, 5, SIILogEntries."CP User"); //Unique Record of Energy Selling Company
                end
                else
                    TempCSVBuffer.InsertEntry(LineNo, 5, NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Switch In CP User", Today, false)); //Unique Record of Energy Selling Company
                TempCSVBuffer.InsertEntry(LineNo, 6, Format(Contract."POD No."));
                TempCSVBuffer.InsertEntry(LineNo, 7, Customer."Fiscal Code");
                TempCSVBuffer.InsertEntry(LineNo, 8, Customer."VAT Registration No.");
                TempCSVBuffer.InsertEntry(LineNo, 9, '0'); //Foreign Fiscal Code Check Doc if full code or boolean
                TempCSVBuffer.InsertEntry(LineNo, 10, Format(Contract."Signature Date of Contract"));
                TempCSVBuffer.InsertEntry(LineNo, 11, Format(Contract."Contract Start Date"));
                TempCSVBuffer.InsertEntry(LineNo, 12, GetRevocaTimoe(RevocaTimoe)); //KB22112023 - TASK002154 Switch-In Process //indicates possibility to revoke the switching, Boolean
                TempCSVBuffer.InsertEntry(LineNo, 13, GetAcquistoCredito(AcquistoCredito)); //KB22112023 - TASK002154 Switch-In Process //indicates possibility to transfer the debts of the customer to the now energy selling company
                TempCSVBuffer.InsertEntry(LineNo, 14, SIIInterfaceGeneralSetup."Switch In Code of Dispatching"); //value that  shall be selected when doing a change of customer, shall be selectable with options. It regards a number assigned by pubblic authority
                TempCSVBuffer.InsertEntry(LineNo, 15, Format(CompanyInformation."VAT Registration No.")); //VAT number of energy selling company
                TempCSVBuffer.InsertEntry(LineNo, 16, '02'); //indicates why the energy seller signs the contract for connection with the final customer on behalf of the utility 
                TempCSVBuffer.InsertEntry(LineNo, 17, Format(SIIInterfaceGeneralSetup."Switch In Tariff Option")); //unique identifying number/alfanumeric of tarif other options:
            until Contract.Next() = 0;
        if LineNo > 1 then begin
            Filename:=StrSubstNo('SE1.0050_%1.csv', TempCSVBuffer.GetValue(LineNo, 5));
            TempCSVBuffer.SaveDataToBlob(CSVDataTempBlob, ';');
            //CSVDataTempBlob.Blob.CreateInStream(InStream);
            CSVDataTempBlob.CreateInStream(FileInStream);
            FileInStream.Read(CSVText);
            File.DownloadFromStream(FileInStream, '', '', '', Filename);
        end;
    end;
    /// <summary>
    ///Exports the first file of the Change of Customer process.
    /// </summary>
    /// <param name="Contract">Record Contract.</param>
    /// <returns>Return variable CSVText of type Text.</returns>
    procedure ChangeofCustomerVT10050(var Contract: Record Contract; Recreate: Boolean; var SIILogEntriesErrored: Record "SII Log Entries")CSVText: Text var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        TariffHeader_rec: Record "Tariff Header";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        Customer: Record "Customer";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        SIILogEntries: Record "SII Log Entries";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CSVDataTempBlob: Codeunit "Temp Blob";
        FileInStream: InStream;
        LineNo: Integer;
        Filename: Text;
        VATManagerNo: Code[50];
    begin
        SIILogEntries.Copy(SIILogEntriesErrored);
        CompanyInformation.Get();
        SIIInterfaceGeneralSetup.Get();
        LineNo:=1;
        //KB140224 - VAT Manager Setup added +++
        UtilitySetup.Get();
        Clear(VATManagerNo);
        if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNo:=UtilitySetup."Default VAT Manager No.";
        //KB140224 - VAT Manager Setup added ---
        TempCSVBuffer.InsertEntry(LineNo, 1, 'COD_SERVIZIO');
        TempCSVBuffer.InsertEntry(LineNo, 2, 'COD_FLUSSO');
        TempCSVBuffer.InsertEntry(LineNo, 3, 'PIVA_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 4, 'PIVA_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 5, 'CP_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 6, 'COD_POD');
        TempCSVBuffer.InsertEntry(LineNo, 7, 'CF');
        TempCSVBuffer.InsertEntry(LineNo, 8, 'PIVA');
        TempCSVBuffer.InsertEntry(LineNo, 9, 'CF_STRANIERO');
        TempCSVBuffer.InsertEntry(LineNo, 10, 'NOME');
        TempCSVBuffer.InsertEntry(LineNo, 11, 'COGNOME');
        TempCSVBuffer.InsertEntry(LineNo, 12, 'RAGIONE_SOCIALE_DENOMINAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 13, 'TELEFONO');
        TempCSVBuffer.InsertEntry(LineNo, 14, 'EMAIL');
        TempCSVBuffer.InsertEntry(LineNo, 15, 'TOPONIMO');
        TempCSVBuffer.InsertEntry(LineNo, 16, 'VIA');
        TempCSVBuffer.InsertEntry(LineNo, 17, 'CIV');
        TempCSVBuffer.InsertEntry(LineNo, 18, 'CAP');
        TempCSVBuffer.InsertEntry(LineNo, 19, 'ISTAT');
        TempCSVBuffer.InsertEntry(LineNo, 20, 'LOCALITA');
        TempCSVBuffer.InsertEntry(LineNo, 21, 'PROV');
        TempCSVBuffer.InsertEntry(LineNo, 22, 'NAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 23, 'ALTRO');
        TempCSVBuffer.InsertEntry(LineNo, 24, 'TOPONIMO');
        TempCSVBuffer.InsertEntry(LineNo, 25, 'VIA');
        TempCSVBuffer.InsertEntry(LineNo, 26, 'CIV');
        TempCSVBuffer.InsertEntry(LineNo, 27, 'CAP');
        TempCSVBuffer.InsertEntry(LineNo, 28, 'ISTAT');
        TempCSVBuffer.InsertEntry(LineNo, 29, 'LOCALITA');
        TempCSVBuffer.InsertEntry(LineNo, 30, 'PROV');
        TempCSVBuffer.InsertEntry(LineNo, 31, 'NAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 32, 'ALTRO');
        TempCSVBuffer.InsertEntry(LineNo, 33, 'TIPOLOGIA_VOLTURA');
        TempCSVBuffer.InsertEntry(LineNo, 34, 'TIPO_CONTRATTO');
        TempCSVBuffer.InsertEntry(LineNo, 35, 'CATEGORIA_CLIENTE');
        TempCSVBuffer.InsertEntry(LineNo, 36, 'DATA_RICHIESTA');
        TempCSVBuffer.InsertEntry(LineNo, 37, 'DATA_DECORRENZA');
        TempCSVBuffer.InsertEntry(LineNo, 38, 'DATA_DECORRENZA_RET');
        TempCSVBuffer.InsertEntry(LineNo, 39, 'COD_CONTR_DISP');
        TempCSVBuffer.InsertEntry(LineNo, 40, 'PIVA_CONTROPARTE_COMMERCIALE');
        TempCSVBuffer.InsertEntry(LineNo, 41, 'ALIQUOTA_IVA');
        TempCSVBuffer.InsertEntry(LineNo, 42, 'ALIQUOTA_ACCISE');
        TempCSVBuffer.InsertEntry(LineNo, 43, 'ADDIZ_PROVINCIALE');
        TempCSVBuffer.InsertEntry(LineNo, 44, 'ADDIZ_COMUNALE');
        TempCSVBuffer.InsertEntry(LineNo, 45, 'ALTRE_INFORMAZIONI');
        TempCSVBuffer.InsertEntry(LineNo, 46, 'NOME');
        TempCSVBuffer.InsertEntry(LineNo, 47, 'COGNOME');
        TempCSVBuffer.InsertEntry(LineNo, 48, 'EMAIL');
        TempCSVBuffer.InsertEntry(LineNo, 49, 'TELEFONO');
        TempCSVBuffer.InsertEntry(LineNo, 50, 'SERVIZIO_TUTELA');
        TempCSVBuffer.InsertEntry(LineNo, 51, 'CODICE_UFFICIO');
        TempCSVBuffer.InsertEntry(LineNo, 52, 'PAGAMENTO_IVA');
        TempCSVBuffer.InsertEntry(LineNo, 53, 'SETT_MERCEOLOGICO');
        TempCSVBuffer.InsertEntry(LineNo, 54, 'COD_OFFERTA');
        TempCSVBuffer.InsertEntry(LineNo, 55, 'AUTOCERTIFICAZIONE');
        if Contract.FindFirst()then repeat if Customer.Get(Contract."Customer No.")then;
                LineNo+=1;
                TempCSVBuffer.InsertEntry(LineNo, 1, 'VT1');
                TempCSVBuffer.InsertEntry(LineNo, 2, '0050');
                TempCSVBuffer.InsertEntry(LineNo, 3, Format(CompanyInformation."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 4, VATManagerNo);
                if Recreate then begin
                    SIILogEntries.SetRange(Type, "Process Type"::"Change of Customer");
                    SIILogEntries.SetFilter("Contract No.", Contract."No.");
                    if SIILogEntries.FindFirst()then;
                    TempCSVBuffer.InsertEntry(LineNo, 5, SIILogEntries."CP User"); //Unique Record of Energy Selling Company
                end
                else
                    TempCSVBuffer.InsertEntry(LineNo, 5, NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."CoC CP User", Today, false)); //Unique Record of Energy Selling Company
                TempCSVBuffer.InsertEntry(LineNo, 6, Format(Contract."POD No."));
                TempCSVBuffer.InsertEntry(LineNo, 7, Customer."Fiscal Code");
                TempCSVBuffer.InsertEntry(LineNo, 8, Customer."VAT Registration No.");
                TempCSVBuffer.InsertEntry(LineNo, 9, Customer."Fiscal Code"); //Foreign Fiscal Code
                TempCSVBuffer.InsertEntry(LineNo, 10, Customer."First Name");
                TempCSVBuffer.InsertEntry(LineNo, 11, Customer."Last Name");
                // AN 27112023 - TASK002168 will be fill in case of customer type Company only ++ 
                if(Customer."Customer Type" = Customer."Customer Type"::Company)then TempCSVBuffer.InsertEntry(LineNo, 12, Customer.Name)
                else
                    TempCSVBuffer.InsertEntry(LineNo, 12, '');
                // AN 27112023 - TASK002168 will be fill in case of customer type Company only --
                TempCSVBuffer.InsertEntry(LineNo, 13, Customer."Mobile Phone No.");
                TempCSVBuffer.InsertEntry(LineNo, 14, Customer."E-Mail");
                TempCSVBuffer.InsertEntry(LineNo, 15, Customer."Billing Toponym");
                // AN 27112023 - TASK002168 Filled only if Billng Address is different ++
                TempCSVBuffer.InsertEntry(LineNo, 16, Customer."Billing Address");
                // AN 27112023 - TASK002168 Filled only if Billng Address is different --
                TempCSVBuffer.InsertEntry(LineNo, 17, Customer."AAT Billing CIV PUB"); //Civic number. 
                TempCSVBuffer.InsertEntry(LineNo, 18, Customer."Billing Post Code");
                TempCSVBuffer.InsertEntry(LineNo, 19, Customer."Billing ISTAT Code");
                TempCSVBuffer.InsertEntry(LineNo, 20, Customer."Billing Country");
                TempCSVBuffer.InsertEntry(LineNo, 21, Customer."Billing County Code");
                // AN 27112023 - TASK002168 Filled only if Billng Country is different ++
                TempCSVBuffer.InsertEntry(LineNo, 22, Customer."Billing Country");
                // AN 27112023 - TASK002168 Filled only if Billng Country is different --
                TempCSVBuffer.InsertEntry(LineNo, 23, ''); // Other
                TempCSVBuffer.InsertEntry(LineNo, 24, Customer."Toponym");
                TempCSVBuffer.InsertEntry(LineNo, 25, Customer.Address);
                // AN 27112023  TASK002168 - Added address 2 ++
                TempCSVBuffer.InsertEntry(LineNo, 26, Contract."Bill-to Address 2");
                // AN 27112023  TASK002168 - Added address 2 --
                TempCSVBuffer.InsertEntry(LineNo, 27, Customer."Post Code");
                TempCSVBuffer.InsertEntry(LineNo, 28, Customer."ISTAT Code");
                // AN 27112023  TASK002168 - Added Name of City ++
                TempCSVBuffer.InsertEntry(LineNo, 29, Contract."Bill-to City");
                // AN 27112023  TASK002168 - Added Name of City --
                // AN 27112023 Task002168 - Added County and Country ++
                TempCSVBuffer.InsertEntry(LineNo, 30, Contract."Bill-to County Code");
                TempCSVBuffer.InsertEntry(LineNo, 31, Contract."Bill-to Country");
                // AN 27112023 Task002168 - Added County and Country --
                TempCSVBuffer.InsertEntry(LineNo, 32, ''); //Other
                // TempCSVBuffer.InsertEntry(LineNo, 33, CopyStr(Contract."AAT Type Of Volture SII".Names.Get(Contract."AAT Type Of Volture SII".AsInteger()), 1, 250));//'Type of Volture' Create enum and extra field on process page | 01  - if normal change of customer 02 - if change of customer due to death 03 - if due to incorporation of company 04 - if old customer and new customer are the same and there is no change in anagrafic data except the fiscal code
                // AN 27112023 TASK002168 - Type of customer from Change of Customer process ++
                // TempCSVBuffer.InsertEntry(LineNo, 33, CopyStr(Contract."AAT Type Of Volture SII".Names.Get(Contract."AAT Type Of Volture SII".AsInteger()), 1, 250));
                TempCSVBuffer.InsertEntry(LineNo, 33, Format(Contract."AAT Type Of Volture SII"));
                TempCSVBuffer.InsertEntry(LineNo, 34, Format(Contract."Contract Type"));
                // AN 27112023 TASK002168 - Type of customer from Change of Customer process --
                // TempCSVBuffer.InsertEntry(LineNo, 34, CopyStr(Contract."Contract Type".Names.Get(Contract."Contract Type".AsInteger()), 1, 250));
                TempCSVBuffer.InsertEntry(LineNo, 35, CopyStr(Contract."AAT Customer Category SII".Names.Get(Contract."AAT Customer Category SII".Ordinals.IndexOf(Contract."AAT Customer Category SII".AsInteger())), 1, 250)); //"Customer Category" Create enum and extra field on process page | 0E0: hit by natural disaster D00: employee in energy sector with discount DE0: employee in energy sector with discount "hit by natural desaster" PC0: heat pump
                TempCSVBuffer.InsertEntry(LineNo, 36, Format(Contract."Contract Start Date"));
                TempCSVBuffer.InsertEntry(LineNo, 37, Format(Contract."Economic Condition Start Date")); // Effective Date
                // AN 27112023  TASK002168 - Economic Condition Start date --
                TempCSVBuffer.InsertEntry(LineNo, 38, Format(CalcDate('<1M>', Today()))); //only if  "TIPOLOGIA_VOLTURA" = 05 //Effective Date for Return 
                TempCSVBuffer.InsertEntry(LineNo, 39, SIIInterfaceGeneralSetup."COC Code of Dispatching"); //Possible option field? value that  shall be selected when doing a change of customer, shall be selectable with options. It regards a number assigned by pubblic authority
                TempCSVBuffer.InsertEntry(LineNo, 40, Format(CompanyInformation."VAT Registration No.")); //VAT number of energy selling company
                // TempCSVBuffer.InsertEntry(LineNo, 41, Format(GetVATRateLastInvoice(Customer)));//VAT Rate of last Invoice
                // TempCSVBuffer.InsertEntry(LineNo, 42, '0');//Excise rate of last invoice
                // AN 27112023 - TASK002168 Added Value for contractual Power and Available Power from Economica Condition ++
                TempCSVBuffer.InsertEntry(LineNo, 41, format(Contract."Contractual Power"));
                TempCSVBuffer.InsertEntry(LineNo, 42, format(Contract."Available Power"));
                TempCSVBuffer.InsertEntry(LineNo, 43, '0.0'); //additional excise rate for the province always 0.0
                TempCSVBuffer.InsertEntry(LineNo, 44, '0.0'); //additional excise rate for the province always 0.0
                TempCSVBuffer.InsertEntry(LineNo, 45, ''); //Other Information
                if not(Customer."Customer Type" = Customer."Customer Type"::Company)then begin
                    TempCSVBuffer.InsertEntry(LineNo, 46, Customer."First Name");
                    TempCSVBuffer.InsertEntry(LineNo, 47, Customer."Last Name");
                end
                else
                begin
                    TempCSVBuffer.InsertEntry(LineNo, 46, '');
                    TempCSVBuffer.InsertEntry(LineNo, 47, '');
                end;
                TempCSVBuffer.InsertEntry(LineNo, 48, Customer."E-Mail");
                TempCSVBuffer.InsertEntry(LineNo, 49, Customer."Tel. Number");
                TempCSVBuffer.InsertEntry(LineNo, 50, Format(SIIInterfaceGeneralSetup."COC Tarrif Option")); //Otion field: "MT": maggior tutela, "S": Salvaguardia, "TG": tutela graduale
                TempCSVBuffer.InsertEntry(LineNo, 51, Contract."Office Code");
                TempCSVBuffer.InsertEntry(LineNo, 52, ConvertSplitPayment(Customer."Split Payment"));
                TempCSVBuffer.InsertEntry(LineNo, 53, Contract."Ateco Codex");
                TariffHeader_rec.Reset();
                TariffHeader_rec.SetRange("No.", Contract."Tariff Option No.");
                if TariffHeader_rec.FindFirst()then TempCSVBuffer.InsertEntry(LineNo, 54, TariffHeader_rec.COD_OFFERTA)
                else
                    TempCSVBuffer.InsertEntry(LineNo, 54, '');
                // AN 27112023 TASK002168- COD_OFFERTA value from Tariff Header New field COD_OFFERTA --
                TempCSVBuffer.InsertEntry(LineNo, 55, ''); //self-declaration available yes or no 
            until Contract.Next() = 0;
        // end;
        Filename:=StrSubstNo('VT1.0050_%1.csv', TempCSVBuffer.GetValue(LineNo, 5));
        TempCSVBuffer.SaveDataToBlob(CSVDataTempBlob, ';');
        CSVDataTempBlob.CreateInStream(FileInStream);
        FileInStream.Read(CSVText);
        File.DownloadFromStream(FileInStream, '', '', '', Filename);
    end;
    /// <summary>
    /// Exports the First file of the Change of Anagraphic Data.
    /// </summary>
    /// <param name="Contract">Record Contract.</param>
    /// <returns>Return variable CSVText of type Text.</returns>
    procedure ChangeofAnagraphicDataAE10050(var Contract: Record Contract; Recreate: Boolean; var SIILogEntriesErrored: Record "SII Log Entries")CSVText: Text var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        Customer: Record "Customer";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        SIILogEntries: Record "SII Log Entries";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CSVDataTempBlob: Codeunit "Temp Blob";
        VATManagerNo: Code[50];
        InStream: InStream;
        LineNo: Integer;
        Filename: Text;
    begin
        SIILogEntries.Copy(SIILogEntriesErrored);
        CompanyInformation.Get();
        SIIInterfaceGeneralSetup.Get();
        LineNo:=1;
        //KB140224 - VAT Manager Setup added +++
        UtilitySetup.Get();
        Clear(VATManagerNo);
        if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNo:=UtilitySetup."Default VAT Manager No.";
        //KB140224 - VAT Manager Setup added ---
        TempCSVBuffer.InsertEntry(LineNo, 1, 'COD_SERVIZIO');
        TempCSVBuffer.InsertEntry(LineNo, 2, 'COD_FLUSSO');
        TempCSVBuffer.InsertEntry(LineNo, 3, 'PIVA_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 4, 'PIVA_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 5, 'CP_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 6, 'COD_POD');
        TempCSVBuffer.InsertEntry(LineNo, 7, 'CF');
        TempCSVBuffer.InsertEntry(LineNo, 8, 'PIVA');
        TempCSVBuffer.InsertEntry(LineNo, 9, 'CF_STRANIERO');
        TempCSVBuffer.InsertEntry(LineNo, 10, 'NOME');
        TempCSVBuffer.InsertEntry(LineNo, 11, 'COGNOME');
        TempCSVBuffer.InsertEntry(LineNo, 12, 'RAGIONE_SOCIALE_DENOMINAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 13, 'TELEFONO');
        TempCSVBuffer.InsertEntry(LineNo, 14, 'TOPONIMO_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 15, 'VIA_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 16, 'CIV_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 17, 'CAP_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 18, 'ISTAT_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 19, 'LOCALITA_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 20, 'PROV_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 21, 'NAZIONE_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 22, 'ALTRO_FORN');
        TempCSVBuffer.InsertEntry(LineNo, 23, 'RESIDENZA');
        TempCSVBuffer.InsertEntry(LineNo, 24, 'DATA_VAL_RES');
        TempCSVBuffer.InsertEntry(LineNo, 25, 'TOPONIMO_ES');
        TempCSVBuffer.InsertEntry(LineNo, 26, 'VIA_ES');
        TempCSVBuffer.InsertEntry(LineNo, 27, 'CIV_ES');
        TempCSVBuffer.InsertEntry(LineNo, 28, 'CAP_ES');
        TempCSVBuffer.InsertEntry(LineNo, 29, 'ISTAT_ES');
        TempCSVBuffer.InsertEntry(LineNo, 30, 'LOCALITA_ES');
        TempCSVBuffer.InsertEntry(LineNo, 31, 'PROV');
        TempCSVBuffer.InsertEntry(LineNo, 32, 'NAZIONE_ES');
        TempCSVBuffer.InsertEntry(LineNo, 33, 'ALTRO');
        TempCSVBuffer.InsertEntry(LineNo, 34, 'ALIQUOTA_IVA');
        TempCSVBuffer.InsertEntry(LineNo, 35, 'ALIQUOTA_ACCISE');
        TempCSVBuffer.InsertEntry(LineNo, 36, 'ADDIZ_PROVINCIALE');
        TempCSVBuffer.InsertEntry(LineNo, 37, 'ADDIZ_COMUNALE');
        TempCSVBuffer.InsertEntry(LineNo, 38, 'ALTRE_INFORMAZIONI');
        TempCSVBuffer.InsertEntry(LineNo, 39, 'REF_NOME');
        TempCSVBuffer.InsertEntry(LineNo, 40, 'REF_COGNOME');
        TempCSVBuffer.InsertEntry(LineNo, 41, 'REF_EMAIL');
        TempCSVBuffer.InsertEntry(LineNo, 42, 'REF_TELEFONO');
        TempCSVBuffer.InsertEntry(LineNo, 43, 'SERVIZIO_TUTELA');
        TempCSVBuffer.InsertEntry(LineNo, 44, 'CODICE_UFFICIO');
        TempCSVBuffer.InsertEntry(LineNo, 45, 'PAGAMENTO_IVA');
        TempCSVBuffer.InsertEntry(LineNo, 46, 'SETT_MERCEOLOGICO');
        TempCSVBuffer.InsertEntry(LineNo, 47, 'COD_OFFERTA');
        TempCSVBuffer.InsertEntry(LineNo, 48, 'AUTOCERTIFICAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 49, 'TIPO_PRESTAZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 50, 'DATA_ESECUZIONE');
        if Contract.FindSet()then repeat if Customer.Get(Contract."Customer No.")then;
                LineNo+=1;
                TempCSVBuffer.InsertEntry(LineNo, 1, 'AE1');
                TempCSVBuffer.InsertEntry(LineNo, 2, '0050');
                TempCSVBuffer.InsertEntry(LineNo, 3, Format(CompanyInformation."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 4, VATManagerNo);
                if Recreate then begin
                    SIILogEntries.SetRange(Type, "Process Type"::"Change of Personal Data");
                    SIILogEntries.SetFilter("Contract No.", Contract."No.");
                    if SIILogEntries.FindFirst()then;
                    TempCSVBuffer.InsertEntry(LineNo, 5, SIILogEntries."CP User"); //Unique Record of Energy Selling Company
                end
                else
                    TempCSVBuffer.InsertEntry(LineNo, 5, NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."CoA CP User", Today, false)); //Unique Record of Energy Selling Company
                TempCSVBuffer.InsertEntry(LineNo, 6, Format(Contract."POD No."));
                TempCSVBuffer.InsertEntry(LineNo, 7, Customer."Fiscal Code");
                TempCSVBuffer.InsertEntry(LineNo, 8, Customer."VAT Registration No.");
                TempCSVBuffer.InsertEntry(LineNo, 9, Customer."Fiscal Code"); //Foreign Fiscal Code
                TempCSVBuffer.InsertEntry(LineNo, 10, Customer."First Name");
                TempCSVBuffer.InsertEntry(LineNo, 11, Customer."Last Name");
                TempCSVBuffer.InsertEntry(LineNo, 12, Customer.Name);
                TempCSVBuffer.InsertEntry(LineNo, 13, Customer."Mobile Phone No.");
                TempCSVBuffer.InsertEntry(LineNo, 14, Customer.Toponym);
                TempCSVBuffer.InsertEntry(LineNo, 15, Customer.Address);
                TempCSVBuffer.InsertEntry(LineNo, 16, Customer."AAT CIV PUB"); //Civic number.
                TempCSVBuffer.InsertEntry(LineNo, 17, Customer."Post Code");
                TempCSVBuffer.InsertEntry(LineNo, 18, Customer."ISTAT Code");
                TempCSVBuffer.InsertEntry(LineNo, 19, Customer."Location Code");
                TempCSVBuffer.InsertEntry(LineNo, 20, Customer.County);
                TempCSVBuffer.InsertEntry(LineNo, 21, Customer."Nation of Birth");
                TempCSVBuffer.InsertEntry(LineNo, 22, ''); //Other
                TempCSVBuffer.InsertEntry(LineNo, 23, ConvertResident(Format(Customer.Resident)));
                TempCSVBuffer.InsertEntry(LineNo, 24, ''); //Starting date of Residence
                TempCSVBuffer.InsertEntry(LineNo, 25, Contract."Physical Toponym");
                TempCSVBuffer.InsertEntry(LineNo, 26, Contract."Physical Address");
                TempCSVBuffer.InsertEntry(LineNo, 27, Contract."AAT Physical CIV PUB"); //Civic number.
                TempCSVBuffer.InsertEntry(LineNo, 28, Contract."Physical Post Code");
                TempCSVBuffer.InsertEntry(LineNo, 29, Contract."ISTAT Code");
                TempCSVBuffer.InsertEntry(LineNo, 30, ''); //Location code
                TempCSVBuffer.InsertEntry(LineNo, 31, Contract."Physical County Code");
                TempCSVBuffer.InsertEntry(LineNo, 32, Customer."Nation of Birth");
                TempCSVBuffer.InsertEntry(LineNo, 33, ''); //Other
                TempCSVBuffer.InsertEntry(LineNo, 34, Format(GetVATRateLastInvoice(Customer))); //Vat Rate of Last Invoice  <Posted or Existing?>
                TempCSVBuffer.InsertEntry(LineNo, 35, '0'); //Excise rate of last invoice  <Posted or Existing?>
                TempCSVBuffer.InsertEntry(LineNo, 36, '0.0');
                TempCSVBuffer.InsertEntry(LineNo, 37, '0.0');
                TempCSVBuffer.InsertEntry(LineNo, 38, ''); // Other info
                TempCSVBuffer.InsertEntry(LineNo, 39, Customer."First Name");
                TempCSVBuffer.InsertEntry(LineNo, 40, Customer."Last Name");
                TempCSVBuffer.InsertEntry(LineNo, 41, Customer."E-Mail");
                TempCSVBuffer.InsertEntry(LineNo, 42, Customer."Tel. Number");
                TempCSVBuffer.InsertEntry(LineNo, 43, Format(SIIInterfaceGeneralSetup."CoA Tariff Option")); //options:"MT": maggior tutela, "S": Salvaguardia, "TG": tutela graduale
                TempCSVBuffer.InsertEntry(LineNo, 44, Contract."Office Code");
                TempCSVBuffer.InsertEntry(LineNo, 45, ConvertSplitPayment(Customer."Split Payment"));
                TempCSVBuffer.InsertEntry(LineNo, 46, Contract."Ateco Codex");
                TempCSVBuffer.InsertEntry(LineNo, 47, Format(SIIInterfaceGeneralSetup."CoA Tariff Option")); //unique identifying number/alfanumeric of tarif other options: "MT" maggior tutela, "TG" tutela graduale, "S" salvaguardia
                TempCSVBuffer.InsertEntry(LineNo, 48, ''); // Self Certification
                TempCSVBuffer.InsertEntry(LineNo, 49, /*Format(Contract."Activation Cause")*/ ''); //TIPO_PRESTAZIONE activation: "ATT", changing market with same UDD/CC:"CTR"
                TempCSVBuffer.InsertEntry(LineNo, 50, Format(Today));
            until Contract.Next() = 0;
        Filename:=StrSubstNo('AE1.0050_%1.csv', TempCSVBuffer.GetValue(LineNo, 5));
        TempCSVBuffer.SaveDataToBlob(CSVDataTempBlob, ';');
        CSVDataTempBlob.CreateInStream(InStream);
        InStream.Read(CSVText);
        File.DownloadFromStream(InStream, '', '', '', Filename);
    end;
    /// <summary>6
    /// Exports the VT1.0040 File for the Change of Customer
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="Contract">Record Contract.</param>
    /// <returns>Return variable CSVText of type Text.</returns>
    procedure ChangeofCustomerVT10040(var SIILogEntry: Record "SII Log Entries"; Contract: Record Contract)CSVText: Text var
        VATManagerSetup: Record "VAT Manager Setup";
        TempCSVBuffer: Record "CSV Buffer" temporary;
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        UtilitySetup: Record "Utility Setup";
        CSVDataTempBlob: Codeunit "Temp Blob";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        InStream: InStream;
        LineNo: Integer;
        Filename: Text;
        VATManagerNo: Code[50];
    begin
        CompanyInformation.Get();
        SIIInterfaceGeneralSetup.Get();
        LineNo:=1;
        //KB140224 - VAT Manager Setup added +++
        UtilitySetup.Get();
        Clear(VATManagerNo);
        if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNo:=UtilitySetup."Default VAT Manager No.";
        //KB140224 - VAT Manager Setup added ---
        TempCSVBuffer.InsertEntry(LineNo, 1, 'COD_SERVIZIO');
        TempCSVBuffer.InsertEntry(LineNo, 2, 'COD_FLUSSO');
        TempCSVBuffer.InsertEntry(LineNo, 3, 'PIVA_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 4, 'PIVA_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 5, 'CP_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 6, 'CP_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 7, 'COD_POD');
        TempCSVBuffer.InsertEntry(LineNo, 8, 'MOTIVAZIONE');
        if SIILogEntry.FindSet()then repeat Contract.Get(SIILogEntry."Contract No.");
                LineNo+=1;
                TempCSVBuffer.InsertEntry(LineNo, 1, 'VT1');
                TempCSVBuffer.InsertEntry(LineNo, 2, '0040');
                TempCSVBuffer.InsertEntry(LineNo, 3, Format(CompanyInformation."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 4, VATManagerNo);
                TempCSVBuffer.InsertEntry(LineNo, 5, NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."CoC CP User", Today, false)); //Unique Record of Energy Selling Company
                TempCSVBuffer.InsertEntry(LineNo, 6, SIILogEntry."CP User"); //unique record number defined by SII
                TempCSVBuffer.InsertEntry(LineNo, 7, Format(Contract."POD No."));
                TempCSVBuffer.InsertEntry(LineNo, 8, Contract."Reason for Suspension");
            until SIILogEntry.Next() = 0;
        Filename:=StrSubstNo('VT1.0040_%1.csv', TempCSVBuffer.GetValue(LineNo, 5));
        TempCSVBuffer.SaveDataToBlob(CSVDataTempBlob, ';');
        CSVDataTempBlob.CreateInStream(InStream);
        InStream.Read(CSVText);
        File.DownloadFromStream(InStream, '', '', '', Filename);
    end;
    /// <summary>
    /// Exports the RC1.0050 File for the Contract Termination Request process.
    /// </summary>
    /// <param name="Contract">Record Contract.</param>
    /// <returns>Return variable CSVText of type Text.</returns>
    procedure ContractTerminationRC10050(var Contract: Record Contract; ReasonforTermination: Enum "Reason for Cont. Termination"; var SIILogEntriesErrored: Record "SII Log Entries"; Recreate: Boolean)CSVText: Text var
        TempCSVBuffer: Record "CSV Buffer" temporary;
        Customer: Record Customer;
        DetailedSIILogEntries: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        SIILogEntries: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CSVDataTempBlob: Codeunit "Temp Blob";
        VATManagerNo: Code[50];
        InStream: InStream;
        LineNo: Integer;
        Filename: Text;
    begin
        SIILogEntries.Copy(SIILogEntriesErrored);
        CompanyInformation.Get();
        SIIInterfaceGeneralSetup.Get();
        LineNo:=1;
        //KB140224 - VAT Manager Setup added +++
        Clear(VATManagerNo);
        UtilitySetup.Get();
        if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNo:=UtilitySetup."Default VAT Manager No.";
        //KB140224 - VAT Manager Setup added ---
        TempCSVBuffer.InsertEntry(LineNo, 1, 'COD_SERVIZIO');
        TempCSVBuffer.InsertEntry(LineNo, 2, 'COD_FLUSSO');
        TempCSVBuffer.InsertEntry(LineNo, 3, 'PIVA_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 4, 'PIVA_GESTORE');
        TempCSVBuffer.InsertEntry(LineNo, 5, 'CP_UTENTE');
        TempCSVBuffer.InsertEntry(LineNo, 6, 'COD_POD');
        TempCSVBuffer.InsertEntry(LineNo, 7, 'CF');
        TempCSVBuffer.InsertEntry(LineNo, 8, 'PIVA');
        TempCSVBuffer.InsertEntry(LineNo, 9, 'CF_STRANIERO');
        TempCSVBuffer.InsertEntry(LineNo, 10, 'ALIQUOTA_IVA');
        TempCSVBuffer.InsertEntry(LineNo, 11, 'ALIQUOTA_ACCISE');
        TempCSVBuffer.InsertEntry(LineNo, 12, 'ADDIZ_PROVINCIALE');
        TempCSVBuffer.InsertEntry(LineNo, 13, 'ADDIZ_COMUNALE');
        TempCSVBuffer.InsertEntry(LineNo, 14, 'ALTRE_INFORMAZIONI');
        TempCSVBuffer.InsertEntry(LineNo, 15, 'TIPOLOGIA_RISOLUZIONE');
        TempCSVBuffer.InsertEntry(LineNo, 16, 'DATA_DECORRENZA');
        if Contract.FindFirst()then repeat if Customer.Get(Contract."Customer No.")then;
                LineNo+=1;
                TempCSVBuffer.InsertEntry(LineNo, 1, 'RC1');
                TempCSVBuffer.InsertEntry(LineNo, 2, '0050');
                TempCSVBuffer.InsertEntry(LineNo, 3, Format(CompanyInformation."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 4, VATManagerNo);
                if Recreate then begin
                    SIILogEntries.SetRange(Type, "Process Type"::"Contract Termination");
                    SIILogEntries.SetFilter("Contract No.", Contract."No.");
                    if SIILogEntries.FindFirst()then TempCSVBuffer.InsertEntry(LineNo, 5, SIILogEntries."CP User"); //Unique Record of Energy Selling Company
                end
                else
                    TempCSVBuffer.InsertEntry(LineNo, 5, NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Contract Termination CP User", Today, false));
                TempCSVBuffer.InsertEntry(LineNo, 6, Format(Contract."POD No."));
                TempCSVBuffer.InsertEntry(LineNo, 7, Format(Customer."Fiscal Code"));
                TempCSVBuffer.InsertEntry(LineNo, 8, Format(Customer."VAT Registration No."));
                TempCSVBuffer.InsertEntry(LineNo, 9, '0'); // Foreign code
                TempCSVBuffer.InsertEntry(LineNo, 10, Format(GetVATRateLastInvoice(Customer))); //VAT Rate of last invoice?
                TempCSVBuffer.InsertEntry(LineNo, 11, '0'); //TODO Excise rate of last invoice?
                TempCSVBuffer.InsertEntry(LineNo, 12, '0.0'); //additional excise rate for the province, always 0.0
                TempCSVBuffer.InsertEntry(LineNo, 13, '0.0'); //additional excise rate for the municipality, always 0.0
                TempCSVBuffer.InsertEntry(LineNo, 14, ''); //ALTRE_INFORMAZIONI | other information
                if Recreate then begin
                    DetailedSIILogEntries.SetRange("CP User", SIILogEntries."CP User");
                    DetailedSIILogEntries.SetRange("Log Entry No.", SIILogEntries."Entry No.");
                    DetailedSIILogEntries.SetRange("Contract No.", Contract."No.");
                    DetailedSIILogEntries.SetRange("File Type", "AAT File Type SII"::"RC1.0050");
                    if DetailedSIILogEntries.FindFirst()then TempCSVBuffer.InsertEntry(LineNo, 15, CopyStr(DetailedSIILogEntries.Message, 1, 250)) // Resolution Type. Selected
                    else
                        TempCSVBuffer.InsertEntry(LineNo, 15, Format("Reason for Cont. Termination"::" ")) // Resolution Type. Selected
                end
                else
                    TempCSVBuffer.InsertEntry(LineNo, 15, Format(ReasonforTermination)); // Resolution Type. Selected 
                TempCSVBuffer.InsertEntry(LineNo, 16, Format(Contract."Contract End Date")); //Effective Date
            until Contract.Next() = 0;
        Filename:=StrSubstNo('RC1.0050_%1.csv', TempCSVBuffer.GetValue(LineNo, 5));
        TempCSVBuffer.SaveDataToBlob(CSVDataTempBlob, ';');
        CSVDataTempBlob.CreateInStream(InStream);
        InStream.Read(CSVText);
        File.DownloadFromStream(InStream, '', '', '', Filename);
    end;
    local procedure ConvertResident(Resident: Text)ConvertedString: Text[250]var
    begin
        if Resident = 'Resident' then ConvertedString:='SI'
        else
            ConvertedString:='NO';
    end;
    local procedure ConvertSplitPayment(SplitPaymentTest: Boolean)ConvertedBoolean: Text[250]var
    begin
        if SplitPaymentTest = true then ConvertedBoolean:='01'
        else
            ConvertedBoolean:='02';
    end;
    local procedure GetVATRateLastInvoice(Customer: Record Customer): Decimal var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.SetRange("Document Type", "Sales Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", Customer."No.");
        SalesHeader.SetCurrentKey("No.");
        SalesHeader.SetAscending("No.", false);
        if SalesHeader.FindFirst()then begin
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            SalesLine.SetRange("Document Type", "Sales Document Type"::Invoice);
            if SalesLine.FindFirst()then exit(SalesLine."VAT %")end;
    end;
    //KB22112023 - TASK002154 Switch-In Process +++
    local procedure GetRevocaTimoe(RevocaTimoe: Boolean): Text begin
        if RevocaTimoe then exit('1')
        else
            exit('0');
    end;
    local procedure GetAcquistoCredito(AcquistoCredito: Boolean): Text begin
        if AcquistoCredito then exit('1')
        else
            exit('0');
    end;
    //KB22112023 - TASK002154 Switch-In Process ---
    var CompanyInformation: Record "Company Information";
}
