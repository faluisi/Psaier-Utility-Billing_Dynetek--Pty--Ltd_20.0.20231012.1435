codeunit 50226 "UTF File Export Mgmt"
{
    procedure ExportUTFMonthly(StartPeriod: Date; EndPeriod: Date)
    var
        Meter: Record Meter;
        LastMeasurement: Record Measurement;
        TarrifList: Record "Tariff Header";
        Measurement: Record Measurement;
        Contract: Record Contract;
        QuadroList: Record Quadro;
        CompanyInformation: Record "Company Information";
        TempBlob: Codeunit "Temp Blob";
        Declaration: XmlDeclaration;
        XmlDoc: XmlDocument;
        RootNode: XmlElement;
        ParentNode: XmlElement;
        ChildNode: XmlElement;
        SuperChileNode: XmlElement;
        XmlTxt: XmlText;
        IStream: InStream;
        OStream: OutStream;
        FileName: Text;
        StartOfMonthDate: Date;
        EndDate: Date;
        TotalPODCount: Decimal;
        TotalMeasurement: Decimal;
        PODNoFilter: Text[1000];
        PODNo: Code[20];
        PODNoList: List of[Code[20]];
    begin
        Clear(IStream);
        Clear(OStream);
        CompanyInformation.get();
        XmlDoc:=XmlDocument.Create();
        Declaration:=XmlDeclaration.Create('1.0', 'utf-8', 'no');
        XmlDoc.SetDeclaration(Declaration);
        RootNode:=XmlElement.Create('energia_elettrica_venditori');
        XmlDoc.Add(RootNode);
        ParentNode:=XmlElement.Create('codice_ditta');
        XmlTxt:=XmlText.Create(CompanyInformation."Company Code");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('partita_iva_venditore');
        XmlTxt:=XmlText.Create(CompanyInformation."VAT Registration No.");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('ragione_sociale_venditore');
        XmlTxt:=XmlText.Create(CompanyInformation.Name);
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('rappresentante_legale_venditore');
        ChildNode:=XmlElement.Create('codice_fiscale');
        XmlTxt:=XmlText.Create(CompanyInformation."Tax Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cognome');
        XmlTxt:=XmlText.Create(CompanyInformation."Name 2");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('nome');
        XmlTxt:=XmlText.Create(CompanyInformation."Name");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('presenza_delegato');
        XmlTxt:=XmlText.Create(Format(CompanyInformation."Presence of Delegate"));
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('delegato_rappresentante_legale_venditore');
        XmlTxt:=XmlText.Create(CompanyInformation."Delegate Legal Representative");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('codice_fiscale');
        XmlTxt:=XmlText.Create(CompanyInformation."Delegate Tax Code");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('cognome');
        XmlTxt:=XmlText.Create(CompanyInformation."Delegate Surname");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('nome');
        XmlTxt:=XmlText.Create(CompanyInformation."Delegate First Name");
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('data_procura');
        XmlTxt:=XmlText.Create(Format(CompanyInformation."Delegate Protocol Date"));
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        ParentNode:=XmlElement.Create('numero_procura');
        XmlTxt:=XmlText.Create(Format(CompanyInformation."Deledate attorney  number"));
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        StartOfMonthDate:=CalcDate('<-CM>', StartPeriod);
        EndDate:=CalcDate('<+CM>', EndPeriod);
        repeat ParentNode:=XmlElement.Create('anno');
            XmlTxt:=XmlText.Create(Format(Date2DMY(StartOfMonthDate, 3)));
            ParentNode.Add(XmlTxt);
            RootNode.Add(ParentNode);
            ParentNode:=XmlElement.Create('mese');
            XmlTxt:=XmlText.Create(Format(Date2DMY(StartOfMonthDate, 2)));
            ParentNode.Add(XmlTxt);
            RootNode.Add(ParentNode);
            Clear(PODNoList);
            TotalPODCount:=0;
            TotalMeasurement:=0;
            Contract.Reset();
            Contract.SetFilter("Quadro Code", '<>%1', '');
            Contract.SetFilter("Contract Start Date", '>=%1', StartPeriod);
            Contract.SetFilter("Contract Start Date", '<=%1', EndPeriod);
            Contract.SetRange(Status, Contract.Status::Open);
            if Contract.FindSet()then repeat if not PODNoList.Contains(Contract."POD No.")then begin
                        TotalPODCount+=1;
                        PODNoList.Add(Contract."POD No.");
                    end;
                until Contract.Next() = 0;
            ParentNode:=XmlElement.Create('n_pod_consumatori');
            XmlTxt:=XmlText.Create(Format(TotalPODCount));
            ParentNode.Add(XmlTxt);
            RootNode.Add(ParentNode);
            Clear(PODNoFilter);
            foreach PODNo in PODNoList do begin
                if PODNoFilter = '' then PODNoFilter:=PODNo
                else
                    PODNoFilter+='|' + PODNo;
            end;
            Clear(Measurement);
            Measurement.Reset();
            if PODNoFilter <> '' then begin
                Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                Measurement.SetFilter("POD No.", PODNoFilter);
                if Measurement.FindSet()then repeat if Meter.Get(Measurement."Meter Serial No.")then if Meter."Reading Type" = Meter."Reading Type"::Consumption then TotalMeasurement+=Measurement."Active Total"
                            else
                            begin
                                LastMeasurement.Reset();
                                Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                LastMeasurement.SetRange("POD No.", Measurement."POD No.");
                                LastMeasurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                                if LastMeasurement.FindLast()then TotalMeasurement+=(Measurement."Active Total" - LastMeasurement."Active Total")
                                else
                                    TotalMeasurement+=Measurement."Active Total";
                            end;
                    until Measurement.Next() = 0;
            end;
            ParentNode:=XmlElement.Create('qta_kWh_fornita');
            XmlTxt:=XmlText.Create(Format(TotalMeasurement));
            ParentNode.Add(XmlTxt);
            RootNode.Add(ParentNode);
            ParentNode:=XmlElement.Create('destinazioni');
            QuadroList.Reset();
            if QuadroList.FindSet()then repeat ChildNode:=XmlElement.Create('dest');
                    TotalPODCount:=0;
                    TotalMeasurement:=0;
                    Clear(PODNoList);
                    Contract.Reset();
                    Contract.SetRange("Quadro Code", QuadroList.Output);
                    Contract.SetFilter("Contract Start Date", '>=%1', StartPeriod);
                    Contract.SetFilter("Contract Start Date", '<=%1', EndPeriod);
                    Contract.SetRange(Status, Contract.Status::Open);
                    IF Contract.FindSet()then repeat if TarrifList.Get(Contract."Tariff Option No.")then if not TarrifList.BTVE then if not PODNoList.Contains(Contract."POD No.")then begin
                                        TotalPODCount+=1;
                                        PODNoList.Add(Contract."POD No.");
                                    end;
                        until Contract.Next() = 0;
                    SuperChileNode:=XmlElement.Create('n_pod');
                    XmlTxt:=XmlText.Create(Format(TotalPODCount));
                    SuperChileNode.Add(XmlTxt);
                    ChildNode.Add(SuperChileNode);
                    Clear(PODNoFilter);
                    Clear(PODNo);
                    foreach PODNo in PODNoList do begin
                        if PODNoFilter = '' then PODNoFilter:=PODNo
                        else
                            PODNoFilter+='|' + PODNo;
                    end;
                    Clear(Measurement);
                    Measurement.Reset();
                    if PODNoFilter <> '' then begin
                        Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                        Measurement.SetFilter("POD No.", PODNoFilter);
                        if Measurement.FindSet()then repeat if Meter.Get(Measurement."Meter Serial No.")then if Meter."Reading Type" = Meter."Reading Type"::Consumption then TotalMeasurement+=Measurement."Active Total"
                                    else
                                    begin
                                        LastMeasurement.Reset();
                                        Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                        LastMeasurement.SetRange("POD No.", Measurement."POD No.");
                                        LastMeasurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                                        if LastMeasurement.FindLast()then TotalMeasurement+=(Measurement."Active Total" - LastMeasurement."Active Total")
                                        else
                                            TotalMeasurement+=Measurement."Active Total";
                                    end;
                            until Measurement.Next() = 0;
                    end;
                    SuperChileNode:=XmlElement.Create('qta_kWh');
                    XmlTxt:=XmlText.Create(Format(TotalMeasurement));
                    SuperChileNode.Add(XmlTxt);
                    ChildNode.Add(SuperChileNode);
                    SuperChileNode:=XmlElement.Create('cod_rigo');
                    XmlTxt:=XmlText.Create(QuadroList.Output);
                    SuperChileNode.Add(XmlTxt);
                    ChildNode.Add(SuperChileNode);
                    TotalPODCount:=0;
                    TotalMeasurement:=0;
                    Clear(PODNoList);
                    Contract.Reset();
                    Contract.SetRange("Quadro Code", QuadroList.Output);
                    Contract.SetFilter("Contract Start Date", '>=%1', StartPeriod);
                    Contract.SetFilter("Contract Start Date", '<=%1', EndPeriod);
                    Contract.SetRange(Status, Contract.Status::Open);
                    IF Contract.FindSet()then repeat if TarrifList.Get(Contract."Tariff Option No.")then if TarrifList.BTVE then if not PODNoList.Contains(Contract."POD No.")then begin
                                        TotalPODCount+=1;
                                        PODNoList.Add(Contract."POD No.");
                                    end;
                        until Contract.Next() = 0;
                    SuperChileNode:=XmlElement.Create('n_pod_parte');
                    XmlTxt:=XmlText.Create(Format(TotalPODCount));
                    SuperChileNode.Add(XmlTxt);
                    ChildNode.Add(SuperChileNode);
                    Clear(PODNoFilter);
                    foreach PODNo in PODNoList do begin
                        if PODNoFilter = '' then PODNoFilter:=PODNo
                        else
                            PODNoFilter+='|' + PODNo;
                    end;
                    Clear(Measurement);
                    Measurement.Reset();
                    if PODNoFilter <> '' then begin
                        Measurement.SetRange(Date, StartOfMonthDate, CalcDate('<+CM>', StartOfMonthDate));
                        Measurement.SetFilter("POD No.", PODNoFilter);
                        if Measurement.FindSet()then repeat if Meter.Get(Measurement."Meter Serial No.")then if Meter."Reading Type" = Meter."Reading Type"::Consumption then TotalMeasurement+=Measurement."Active Total"
                                    else
                                    begin
                                        LastMeasurement.Reset();
                                        Measurement.SetCurrentKey("POD No.", "Meter Serial No.", Date);
                                        LastMeasurement.SetRange("POD No.", Measurement."POD No.");
                                        LastMeasurement.SetFilter(Date, '..%1', CalcDate('<-1D>', StartOfMonthDate));
                                        if LastMeasurement.FindLast()then TotalMeasurement+=(Measurement."Active Total" - LastMeasurement."Active Total")
                                        else
                                            TotalMeasurement+=Measurement."Active Total";
                                    end;
                            until Measurement.Next() = 0;
                    end;
                    SuperChileNode:=XmlElement.Create('qta_kWh_parte');
                    XmlTxt:=XmlText.Create(Format(TotalMeasurement));
                    SuperChileNode.Add(XmlTxt);
                    ChildNode.Add(SuperChileNode);
                    ParentNode.Add(ChildNode);
                until QuadroList.Next() = 0;
            RootNode.Add(ParentNode);
            StartOfMonthDate:=CalcDate('<+CM+1D>', StartOfMonthDate);
        until StartOfMonthDate >= EndDate;
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:='UTF_Monthly.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    procedure ExportUTFAnnual(StartPeriod: Date; EndPeriod: Date)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        SalesHeader: Record "Sales Header";
        UTFAnnualList: Record "UTF Annual List";
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrSymbol: Text[5];
    begin
        TempExcelBuffer.DeleteAll();
        GeneralLedgerSetup.Get();
        Clear(TempExcelBuffer);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Quadro', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nr. POD', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nr. Contratto', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nr. Bolletta', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Data fattura', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nome cliente', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Provincia', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nome commune', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Codice catastale', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Tipo utenza', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Residenza', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Essente Accise', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Recupero Accise', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Scaglione da', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Scaglione a', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('KWh mensile consumo', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Prezzo/KWh', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('imponibile', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        UTFAnnualList.Reset();
        UTFAnnualList.SetRange("Posting Date", StartPeriod, EndPeriod);
        if UTFAnnualList.FindSet()then repeat Clear(CurrSymbol);
                if SalesHeader.get(SalesHeader."Document Type"::Invoice, UTFAnnualList."Document No.")then;
                if SalesHeader."Currency Code" <> '' then begin
                    if Currency.get(SalesHeader."Currency Code")then CurrSymbol:=Currency.Symbol;
                end
                else
                    CurrSymbol:=GeneralLedgerSetup."Local Currency Symbol";
                TempExcelBuffer.NewRow();
                TempExcelBuffer.AddColumn(UTFAnnualList."Quadro No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."POD No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Contract No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
                TempExcelBuffer.AddColumn(UTFAnnualList."Customer Name", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Physical County Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Physical City", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Cadastral Municipality Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList.Usage, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList.Residenza, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Essente Accise", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Recupero Accise", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(UTFAnnualList."Acciso Starting Range", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(UTFAnnualList."Acciso Ending Range", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(UTFAnnualList."Acciso Consumption", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
                TempExcelBuffer.AddColumn(Format(UTFAnnualList."Unit Price") + ' ' + CurrSymbol, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
                TempExcelBuffer.AddColumn(Format(UTFAnnualList.Amount) + ' ' + CurrSymbol, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            until UTFAnnualList.Next() = 0;
        TempExcelBuffer.CreateNewBook('UTF Annual');
        TempExcelBuffer.WriteSheet('Sheet1', CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename('UTF Annual');
        TempExcelBuffer.OpenExcel();
    end;
}
