codeunit 70000 "ImportExportManagerDeactivate"
{
    //KB08112023 - TASK002126 Deactivation Process +++
    procedure ExportD010050File(Contract: Record Contract; CPUser: Code[20]; DisattFuoriOrario: Boolean; PresenzaClienteNoTelegestito: Boolean; RequestedDeactivationDate: Date)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        Customer: Record Customer;
        UtilitySetup: Record "Utility Setup";
        TempBlob: Codeunit "Temp Blob";
        Declaration: XmlDeclaration;
        XmlDoc: XmlDocument;
        RootNode: XmlElement;
        ParentNode: XmlElement;
        ChildNode: XmlElement;
        Attribute: XmlAttribute;
        SuperChileNode: XmlElement;
        XmlTxt: XmlText;
        IStream: InStream;
        OStream: OutStream;
        FileName: Text;
        VATManagerNo: Code[50];
    begin
        Clear(IStream);
        Clear(OStream);
        CompanyInformation.get();
        SIIInterfaceGeneralSetup.Get();
        if Customer.get(Contract."Customer No.")then;
        //KB140224 - VAT Manager Setup added +++
        Clear(VATManagerNo);
        UtilitySetup.Get();
        if VATManagerSetup.Get(CopyStr(Contract."POD No.", 3, 3))then VATManagerNo:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNo:=UtilitySetup."Default VAT Manager No.";
        //KB140224 - VAT Manager Setup added ---
        //Prestazione Rootnode
        XmlDoc:=XmlDocument.Create();
        Declaration:=XmlDeclaration.Create('1.0', 'utf-8', 'no');
        XmlDoc.SetDeclaration(Declaration);
        RootNode:=XmlElement.Create('Prestazione');
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_servizio', 'D01');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_flusso', 'E050');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('noNamespaceSchemaLocation', 'file:./xsd/D/D01_E050.xsd');
        RootNode.Add(Attribute);
        XmlDoc.Add(RootNode);
        //IdentificativiRichiesta
        ParentNode:=XmlElement.Create('IdentificativiRichiesta');
        ChildNode:=XmlElement.Create('piva_utente');
        XmlTxt:=XmlText.Create(CompanyInformation."VAT Registration No.");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('piva_distr');
        XmlTxt:=XmlText.Create(VATManagerNo); //KB140224 - VAT Manager Setup added
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cod_prat_utente');
        XmlTxt:=XmlText.Create(CPUser);
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cod_contr_disp');
        XmlTxt:=XmlText.Create(SIIInterfaceGeneralSetup."Contract Disp");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //ClienteFinale
        ParentNode:=XmlElement.Create('ClienteFinale');
        ChildNode:=XmlElement.Create('Anagrafica');
        SuperChileNode:=XmlElement.Create('cf');
        XmlTxt:=XmlText.Create(Customer."Fiscal Code");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('tel');
        XmlTxt:=XmlText.Create(Contract."Tel. No.");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //DatiTecnici
        ParentNode:=XmlElement.Create('DatiTecnici');
        ChildNode:=XmlElement.Create('cod_pod');
        XmlTxt:=XmlText.Create(Contract."POD No.");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //PresenzaCliente
        ParentNode:=XmlElement.Create('PresenzaCliente');
        ChildNode:=XmlElement.Create('Presenza_Cliente_No_Telegestito');
        XmlTxt:=XmlText.Create(Format(PresenzaClienteNoTelegestito));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //FuoriOrario
        ParentNode:=XmlElement.Create('FuoriOrario');
        ChildNode:=XmlElement.Create('Disatt_Fuori_Orario');
        XmlTxt:=XmlText.Create(Format(DisattFuoriOrario));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //Da_Eseguire_Non_Prima_Del
        ParentNode:=XmlElement.Create('Da_Eseguire_Non_Prima_Del');
        XmlTxt:=XmlText.Create(Format(RequestedDeactivationDate));
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:=Format("AAT File Type SII"::"D01.E050") + '_' + CPUser + '.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    //KB08112023 - TASK002126 Deactivation Process ---
    //KB09112023 - TASK002126 Deactivation Process +++
    procedure ImportD010100File(RootNode: XmlElement; FileName: text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        SIILogEntries: Record "SII Log Entries";
        DeactivationDataMgmt: Codeunit DeactivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CPUser: Code[20];
        DeactivationNo: Code[20];
        Status: Integer;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
    begin
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiRichiesta': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'piva_utente': begin
                        CompanyInformation.Get();
                        if CompanyInformation."VAT Registration No." <> ChildElement.InnerText then Error(CompanyVATNoLbl, ChildElement.InnerText);
                    end;
                    'piva_distr': VATManagerNo:=ChildElement.InnerText; //KB140224 - VAT Manager Setup added
                    'cod_prat_utente': CPUser:=ChildElement.InnerText;
                    'cod_prat_distr': DeactivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Ammissibilita': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'verifica_amm': Evaluate(Status, ChildElement.InnerText);
                    end;
                end;
            end;
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetRange(Type, SIILogEntries.Type::Deactivate);
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---   
            If Status = 1 then DeactivationDataMgmt.ModifyDeactivationDataVerification(false, SIILogEntries, FileName, DeactivationNo)
            else
                DeactivationDataMgmt.ModifyDeactivationDataVerification(true, SIILogEntries, FileName, DeactivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'D01_E0100'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ImportD010150File(RootNode: XmlElement; FileName: text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        Meter: Record Meter;
        Contract: Record Contract;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntries: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        DeactivationDataMgmt: Codeunit DeactivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        ChildNode3: XmlNode;
        ChildElement3: XmlElement;
        ChildNodeList3: XmlNodeList;
        Status: Integer;
        UnistallDate: Date;
        UnistallationActive: array[3]of Decimal;
        MeterNo: Code[20];
        PODNo: Code[20];
        CPUser: Code[20];
        DeactivationNo: Code[20];
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        PODNoErrorLbl: Label 'There is no POD No. that corresponds with: %1', Locked = true;
        MeterNoErrorLbl: Label 'There is no Meter No. that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        CompanyVATNoLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
    begin
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiRichiesta': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'piva_utente': begin
                        CompanyInformation.Get();
                        if CompanyInformation."VAT Registration No." <> ChildElement.InnerText then Error(CompanyVATNoLbl, ChildElement.InnerText);
                    end;
                    'piva_distr': VATManagerNo:=ChildElement.InnerText; //KB140224 - VAT Manager Setup added
                    'cod_prat_utente': CPUser:=ChildElement.InnerText;
                    'cod_prat_distr': DeactivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Esito': Evaluate(Status, ParentElement.InnerText);
            'DatiTecnici': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'cod_pod': PODNo:=ChildElement.InnerText;
                    'matr_mis': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'matr_mis_attiva': MeterNo:=SuperChildElement.InnerText;
                            end;
                        end;
                    end;
                    'data_disattivazione': Evaluate(UnistallDate, ChildElement.InnerText);
                    'lettura_disattivazione': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'lett_att': begin
                                ChildNodeList3:=SuperChildElement.GetChildElements();
                                foreach ChildNode3 in ChildNodeList3 do begin
                                    ChildElement3:=ChildNode3.AsXmlElement();
                                    case ChildElement3.Name of 'lett_att_1': Evaluate(UnistallationActive[1], ChildElement3.InnerText);
                                    'lett_att_2': Evaluate(UnistallationActive[2], ChildElement3.InnerText);
                                    'lett_att_3': Evaluate(UnistallationActive[3], ChildElement3.InnerText);
                                    end;
                                end;
                            end;
                            end;
                        end;
                    end;
                    end;
                end;
            end;
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetRange(Type, SIILogEntries.Type::Deactivate);
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---
            if Status = 1 then begin
                DeactivationDataMgmt.ModifyDeactivationDataFinalVerification(false, SIILogEntries, FileName, DeactivationNo);
                if PointOfDelivery.get(PODNo)then begin
                    PointOfDelivery.Validate("AAT POD Status", PointOfDelivery."AAT POD Status"::Deactivated);
                    PointOfDelivery.Modify();
                end
                else
                    Error(PODNoErrorLbl, PODNo);
                if Meter.Get(MeterNo)then begin
                    //KB07122023 - TASK002199 Deactivation Process Changes +++
                    Meter.Validate("Deactivation Date", UnistallDate);
                    Meter.Validate("Deactivation F1 Active", UnistallationActive[1]);
                    Meter.Validate("Deactivation F2 Active", UnistallationActive[2]);
                    Meter.Validate("Deactivation F3 Active", UnistallationActive[3]);
                    Meter.Modify();
                    //KB07122023 - TASK002199 Deactivation Process Changes ---
                    DeactivationDataMgmt.MeasurementDataUpdate(Meter); //KB07122023 - TASK002199 Meter Measurement List Update
                end
                else
                    Error(MeterNoErrorLbl, MeterNo);
                //KB07122023 - TASK002199 Deactivation Process Bug Solved - End Date update +++
                if Contract.Get(SIILogEntries."Contract No.")then begin
                    Contract.Validate("Contract End Date", UnistallDate);
                    Contract.Validate("Economic Condition End Date", UnistallDate);
                    Contract.Modify();
                end;
            //KB07122023 - TASK002199 Deactivation Process Bug Solved - End Date update ---
            end
            else
                DeactivationDataMgmt.ModifyDeactivationDataFinalVerification(true, SIILogEntries, FileName, DeactivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'D01_E0150'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    var CompanyInformation: Record "Company Information";
    SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
    ImportMessageLbl: Label 'Imported: %1', Comment = 'Imported: %1';
//KB09112023 - TASK002126 Deactivation Process ---
}
