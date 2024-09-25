codeunit 70100 ImportExportManagerActivate
{
    //KB20112023 - TASK002131 New Activation Process +++
    procedure ExportPN10050File(Contract: Record Contract; CPUser: Code[20]; Notes: Text[50])
    var
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        Customer: Record Customer;
        SIIInterfaceSetup: Record "SII Interface General Setup";
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
        SIIInterfaceSetup.Get();
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
        Attribute:=XmlAttribute.Create('cod_servizio', 'PN1');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_flusso', '0050');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('noNamespaceSchemaLocation', 'file:./xsd/P/PN1_0050.xsd');
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
        XmlTxt:=XmlText.Create(SIIInterfaceSetup."Activation Contract Disp");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //ClienteFinale
        ParentNode:=XmlElement.Create('ClienteFinale');
        ChildNode:=XmlElement.Create('Anagrafica');
        SuperChileNode:=XmlElement.Create('rag_soc');
        XmlTxt:=XmlText.Create(Customer.Name);
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('tel');
        XmlTxt:=XmlText.Create(Contract."Tel. No.");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('piva');
        // AN 03012024 TASK002297  added Piva Value according to Customer type +++
        case Customer."Customer Type" of "Customer Type"::Company: begin
            XmlTxt:=XmlText.Create(Customer."VAT Registration No.");
            SuperChileNode.Add(XmlTxt);
            ChildNode.Add(SuperChileNode);
        end;
        "Customer Type"::Person: begin
            XmlTxt:=XmlText.Create(Customer."Fiscal Code");
            SuperChileNode.Add(XmlTxt);
            ChildNode.Add(SuperChileNode);
        end;
        End;
        // AN 03012024 TASK002297 added Piva Value according to Customer type ---
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //Fornitura
        ParentNode:=XmlElement.Create('Fornitura');
        ChildNode:=XmlElement.Create('UbicazionePod');
        SuperChileNode:=XmlElement.Create('toponimo');
        XmlTxt:=XmlText.Create(Contract."Bill-to Address"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('via');
        XmlTxt:=XmlText.Create(Contract."Bill-to Address 2"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('civ');
        XmlTxt:=XmlText.Create(Contract."AAT Bill-to CIV PUB"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('cap');
        XmlTxt:=XmlText.Create(Contract."Bill-to Post Code"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('istat');
        XmlTxt:=XmlText.Create(Contract."Bill-to ISTAT Code"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('comune');
        XmlTxt:=XmlText.Create(Contract."Bill-to City"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('prov');
        XmlTxt:=XmlText.Create(Contract."Bill-to Country"); //KB13122023 - TASK002199 Field mapping update
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //DatiTecnici
        ParentNode:=XmlElement.Create('DatiTecnici');
        ChildNode:=XmlElement.Create('n_pod');
        XmlTxt:=XmlText.Create('001');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('pot_tot_util');
        XmlTxt:=XmlText.Create(Format(Contract."Contractual Power"));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('fase');
        if Contract."System Type" = Contract."System Type"::"Phase One" then XmlTxt:=XmlText.Create(Format('M'))
        else
            XmlTxt:=XmlText.Create(Format('T'));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tp_uso');
        case Contract.Usage of Contract.Usage::Domestic: XmlTxt:=XmlText.Create('D');
        Contract.Usage::Vehicles: XmlTxt:=XmlText.Create('V');
        else
            XmlTxt:=XmlText.Create('A');
        end;
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tp_tensione');
        case Contract."Voltage Type" of Contract."Voltage Type"::BT: XmlTxt:=XmlText.Create('B');
        else
            XmlTxt:=XmlText.Create(Format(Contract."Voltage Type"));
        end;
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //note
        ParentNode:=XmlElement.Create('note');
        XmlTxt:=XmlText.Create(Notes);
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:=Format("AAT File Type SII"::"PN1.0050") + '_' + CPUser + '.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    procedure ExportPM10050File(Contract: Record Contract; CPUser: Code[20])
    var
        UtilitySetup: Record "Utility Setup";
        Customer: Record Customer;
        SIIInterfaceSetup: Record "SII Interface General Setup";
        VATManagerSetup: Record "VAT Manager Setup";
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
        Clear(VATManagerNo);
        CompanyInformation.get();
        SIIInterfaceSetup.Get();
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
        Attribute:=XmlAttribute.Create('cod_servizio', 'PM1');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_flusso', '0050');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('noNamespaceSchemaLocation', 'file:./xsd/P/PM1_0050.xsd');
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
        XmlTxt:=XmlText.Create(SIIInterfaceSetup."Activation Contract Disp");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //ClienteFinale
        ParentNode:=XmlElement.Create('ClienteFinale');
        ChildNode:=XmlElement.Create('Anagrafica');
        SuperChileNode:=XmlElement.Create('rag_soc');
        XmlTxt:=XmlText.Create(Customer.Name);
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('tel');
        XmlTxt:=XmlText.Create(Contract."Tel. No.");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('piva');
        XmlTxt:=XmlText.Create(Customer."VAT Registration No.");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //DatiTecnici
        ParentNode:=XmlElement.Create('DatiTecnici');
        ChildNode:=XmlElement.Create('n_pod');
        XmlTxt:=XmlText.Create('001');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('pot_tot_util');
        XmlTxt:=XmlText.Create(Format(Contract."Contractual Power"));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:='PM1.0050' + '_' + CPUser + '.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    //KB20112023 - TASK002131 New Activation Process ---
    //KB21112023 - TASK002131 New Activation Process +++
    procedure ImportPN10100File(RootNode: XmlElement; FileName: text)
    var
        SIILogEntries: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        Status: Integer;
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
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
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
        SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---   
            if Status = 1 then ActivationDataMgmt.ModifyNewActivationDataVerification(false, SIILogEntries, FileName, NewActivationNo)
            else
                ActivationDataMgmt.ModifyNewActivationDataVerification(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'PN1_0100'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ImportPN10150File(RootNode: XmlElement; FileName: text)
    var
        SIILogEntries: Record "SII Log Entries";
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        Notes: Text[100];
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
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Esito': Evaluate(Status, ParentElement.InnerText);
            'note': Notes:=CopyStr(ParentElement.InnerText, 1, 100);
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(copystr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---   
            if Status = 1 then ActivationDataMgmt.ModifyNewActivationDataFinalVerification(false, SIILogEntries, FileName, NewActivationNo)
            else
                ActivationDataMgmt.ModifyNewActivationDataFinalVerification(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'PN1_0150'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ExportE010050File(Contract: Record Contract; CPUser: Code[20])
    var
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        Customer: Record Customer;
        SIIInterfaceSetup: Record "SII Interface General Setup";
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
        SIIInterfaceSetup.Get();
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
        Attribute:=XmlAttribute.Create('cod_servizio', 'E01');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_flusso', '0050');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('noNamespaceSchemaLocation', 'file:./xsd/E/E01_0050.xsd');
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
        XmlTxt:=XmlText.Create(SIIInterfaceSetup."Activation Contract Disp");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //ClienteFinale
        ParentNode:=XmlElement.Create('ClienteFinale');
        ChildNode:=XmlElement.Create('Anagrafica');
        SuperChileNode:=XmlElement.Create('rag_soc');
        XmlTxt:=XmlText.Create(Customer.Name);
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        SuperChileNode:=XmlElement.Create('tel');
        XmlTxt:=XmlText.Create(Contract."Tel. No.");
        SuperChileNode.Add(XmlTxt);
        ChildNode.Add(SuperChileNode);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:=Format("AAT File Type SII"::"E01.0050") + '_' + CPUser + '.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    procedure ImportE010100File(RootNode: XmlElement; FileName: text)
    var
        SIILogEntries: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        Status: Integer;
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
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
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
        SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---   
            If Status = 1 then ActivationDataMgmt.ModifyNewActivationDataAfterPODInstallationVerification(false, SIILogEntries, FileName, NewActivationNo)
            else
                ActivationDataMgmt.ModifyNewActivationDataAfterPODInstallationVerification(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'E01_0100'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ImportE010150File(RootNode: XmlElement; FileName: text)
    var
        Contract: Record Contract;
        Meter: Record Meter;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntries: Record "SII Log Entries";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        ActivationDate: Date;
        MeterNo: Code[20];
        PODNo: Code[20];
        InstallationActive: array[3]of Decimal;
        InstallationReActive: array[3]of Decimal;
        InstallationPeak: array[3]of Decimal;
        Status: Integer;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
        MeterNoErrorLbl: Label 'There is no Meter No. that corresponds with: %1', Locked = true;
    begin
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiRichiesta': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'cod_prat_utente': CPUser:=ChildElement.InnerText;
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Esito': Evaluate(Status, ParentElement.InnerText);
            'DatiTecnici': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'data_esecuzione': Evaluate(ActivationDate, ChildElement.InnerText);
                    'Misuratore': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'matr_mis1': MeterNo:=SuperChildElement.InnerText;
                            end;
                        end;
                    end;
                    'LetturaAttiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Attiva1': Evaluate(InstallationActive[1], SuperChildElement.InnerText);
                            'segn_Attiva2': Evaluate(InstallationActive[2], SuperChildElement.InnerText);
                            'segn_Attiva3': Evaluate(InstallationActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaReattiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Reattiva1': Evaluate(InstallationReActive[1], SuperChildElement.InnerText);
                            'segn_Reattiva2': Evaluate(InstallationReActive[2], SuperChildElement.InnerText);
                            'segn_Reattiva3': Evaluate(InstallationReActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaPotenza': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Potenza1': Evaluate(InstallationPeak[1], SuperChildElement.InnerText);
                            'segn_Potenza2': Evaluate(InstallationPeak[2], SuperChildElement.InnerText);
                            'segn_Potenza3': Evaluate(InstallationPeak[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    //KB13122023 - TASK002199 Insert POD +++    
                    'PoD': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'cod_pod': PODNo:=SuperChildElement.InnerText;
                            end;
                        end;
                    end;
                    //KB13122023 - TASK002199 Insert POD ---
                    end;
                end;
            end;
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetRange(Type, SIILogEntries.Type::"New Activation");
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            if Status = 1 then begin
                if not PointOfDelivery.Get(PODNo)then begin
                    PointOfDelivery.Init();
                    PointOfDelivery.Validate("No.", PODNo);
                    PointOfDelivery.Insert(true);
                end;
                ActivationDataMgmt.ModifyNewActivationDataAfterPODInstallationFinalVerification(false, SIILogEntries, FileName, NewActivationNo, PODNo);
                if Meter.Get(MeterNo)then begin
                    Meter.Validate("POD No.", PODNo);
                    Meter.Validate("Installation Date", ActivationDate);
                    Meter.Validate("Installation F1 Active", InstallationActive[1]);
                    Meter.Validate("Installation F2 Active", InstallationActive[2]);
                    Meter.Validate("Installation F3 Active", InstallationActive[3]);
                    Meter.Validate("Installation F1 Reactive", InstallationReActive[1]);
                    Meter.Validate("Installation F2 Reactive", InstallationReActive[2]);
                    Meter.Validate("Installation F3 Reactive", InstallationReActive[3]);
                    Meter.Validate("Installation F1 Peak", InstallationPeak[1]);
                    Meter.Validate("Installation F2 Peak", InstallationPeak[2]);
                    Meter.Validate("Installation F3 Peak", InstallationPeak[3]);
                    Meter.Modify();
                    // AN 03012024 TASK002297  Insert Measurement +++ 
                    ActivationDataMgmt.MeasurementDataUpdate(Meter, true)// AN 03012024 TASK002297  Insert Measurement --- 
                end
                else
                    Error(MeterNoErrorLbl, MeterNo);
                if Contract.Get(SIILogEntries."Contract No.")then;
                PointOfDelivery.Validate("Customer No.", Contract."Customer No.");
                PointOfDelivery."Meter Serial No.":=MeterNo;
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Installation Completed";
                PointOfDelivery.Modify();
                Contract.Validate("POD No.", PointOfDelivery."No.");
                Contract.Validate(Status, Contract.Status::Open); //KB201223 - TASK002199 POD Validation
                Contract.Modify();
            end
            else
                ActivationDataMgmt.ModifyNewActivationDataAfterPODInstallationFinalVerification(true, SIILogEntries, FileName, NewActivationNo, PODNo);
            Message(StrSubstNo(ImportMessageLbl, 'E01_0150'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    //KB21112023 - TASK002131 New Activation Process ---
    //KB24112023 - TASK002131 New Activation Process +++ //KB24112023 - TASK002167 Reactivation Process +++
    procedure ExportA010050File(Contract: Record Contract; CPUser: Code[20]; Notes: Text[50]; data_ricenzione: Date)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        Customer: Record Customer;
        CountryRegion: Record "Country/Region";
        SIIInterfaceSetup: Record "SII Interface General Setup";
        UtilitySetup: Record "Utility Setup";
        TempBlob: Codeunit "Temp Blob";
        Declaration: XmlDeclaration;
        XmlDoc: XmlDocument;
        RootNode: XmlElement;
        ParentNode: XmlElement;
        ChildNode: XmlElement;
        Attribute: XmlAttribute;
        XmlTxt: XmlText;
        IStream: InStream;
        OStream: OutStream;
        FileName: Text;
        VATManagerNo: Code[50];
    begin
        Clear(IStream);
        Clear(OStream);
        CompanyInformation.get();
        SIIInterfaceSetup.Get();
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
        Attribute:=XmlAttribute.Create('cod_servizio', 'A01');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.Create('cod_flusso', '0050');
        RootNode.Add(Attribute);
        Attribute:=XmlAttribute.CreateNamespaceDeclaration('noNamespaceSchemaLocation', 'file:./xsd/P/PN1_0050.xsd');
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
        ChildNode:=XmlElement.Create('data_ricenzione');
        XmlTxt:=XmlText.Create(Format(data_ricenzione));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cod_contr_disp');
        XmlTxt:=XmlText.Create(SIIInterfaceSetup."Activation Contract Disp");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //residente
        ParentNode:=XmlElement.Create('residente');
        if Contract.Resident then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        //Anagrafica
        ParentNode:=XmlElement.Create('Anagrafica');
        ChildNode:=XmlElement.Create('cognome');
        XmlTxt:=XmlText.Create(Customer."Last Name");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('nome');
        XmlTxt:=XmlText.Create(Customer."First Name");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tel');
        XmlTxt:=XmlText.Create(Contract."Tel. No.");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('diritto_salvaguardia');
        if Customer."Salvaguardia Market" then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cf');
        XmlTxt:=XmlText.Create(Customer."Fiscal Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //Recapito
        ParentNode:=XmlElement.Create('Recapito');
        ChildNode:=XmlElement.Create('toponimo');
        XmlTxt:=XmlText.Create(Contract."Physical Address");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('via');
        XmlTxt:=XmlText.Create(Contract."Physical Address 2");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('civ');
        XmlTxt:=XmlText.Create(Contract."AAT Physical CIV PUB");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cap');
        XmlTxt:=XmlText.Create(Contract."Physical Post Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('istat');
        XmlTxt:=XmlText.Create(Contract."ISTAT Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('comune');
        XmlTxt:=XmlText.Create(Contract."Physical City");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('prov');
        XmlTxt:=XmlText.Create(Contract."Physical Country Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('nazione');
        if CountryRegion.Get(Contract."Physical Country Code")then XmlTxt:=XmlText.Create(CountryRegion.Name)
        else
            XmlTxt:=XmlText.Create('');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //dati_fatt
        ParentNode:=XmlElement.Create('dati_fatt');
        if Contract.DATI_FATTI then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        //AnagraficaFatt
        ParentNode:=XmlElement.Create('AnagraficaFatt');
        ChildNode:=XmlElement.Create('cognome');
        XmlTxt:=XmlText.Create(Customer."Last Name");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('nome');
        XmlTxt:=XmlText.Create(Customer."First Name");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //RecapitoFatt
        ParentNode:=XmlElement.Create('RecapitoFatt');
        ChildNode:=XmlElement.Create('toponimo');
        XmlTxt:=XmlText.Create(Contract."Physical Address");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('via');
        XmlTxt:=XmlText.Create(Contract."Physical Address 2");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('civ');
        XmlTxt:=XmlText.Create(Contract."AAT Physical CIV PUB");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cap');
        XmlTxt:=XmlText.Create(Contract."Physical Post Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('istat');
        XmlTxt:=XmlText.Create(Contract."ISTAT Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('comune');
        XmlTxt:=XmlText.Create(Contract."Physical City");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('prov');
        XmlTxt:=XmlText.Create(Contract."Physical Country Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('nazione');
        if CountryRegion.Get(Contract."Physical Country Code")then XmlTxt:=XmlText.Create(CountryRegion.Name)
        else
            XmlTxt:=XmlText.Create('');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //UbicazionePod
        ParentNode:=XmlElement.Create('UbicazionePod');
        ChildNode:=XmlElement.Create('toponimo');
        XmlTxt:=XmlText.Create(Contract."Physical Address");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('via');
        XmlTxt:=XmlText.Create(Contract."Physical Address 2");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('civ');
        XmlTxt:=XmlText.Create(Contract."AAT Physical CIV PUB");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('cap');
        XmlTxt:=XmlText.Create(Contract."Physical Post Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('istat');
        XmlTxt:=XmlText.Create(Contract."ISTAT Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('comune');
        XmlTxt:=XmlText.Create(Contract."Physical City");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('prov');
        XmlTxt:=XmlText.Create(Contract."Physical Country Code");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //DatiTecnici
        ParentNode:=XmlElement.Create('DatiTecnici');
        ChildNode:=XmlElement.Create('cod_pod');
        XmlTxt:=XmlText.Create(Contract."POD No.");
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('pot_ric_contratto');
        XmlTxt:=XmlText.Create(Format(Contract."Contractual Power"));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tensione');
        case Contract."Voltage Type" of Contract."Voltage Type"::BT: XmlTxt:=XmlText.Create('B')
        else
            XmlTxt:=XmlText.Create(Format(Contract."Voltage Type"));
        end;
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tp_mercato');
        XmlTxt:=XmlText.Create(Format(Contract.Market));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('tp_uso');
        case Contract.Usage of Contract.Usage::Domestic: XmlTxt:=XmlText.Create('D');
        Contract.Usage::Vehicles: XmlTxt:=XmlText.Create('V');
        else
            XmlTxt:=XmlText.Create('A');
        end;
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('interrompibilita');
        if Contract."INTERROMPABILITà" then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('apparato_medicale');
        if Contract.APPARATO_MEDICALE then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('fase');
        if Contract."System Type" = Contract."System Type"::"Phase One" then XmlTxt:=XmlText.Create(Format('M'))
        else
            XmlTxt:=XmlText.Create(Format('T'));
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        ChildNode:=XmlElement.Create('categoria_merceologica');
        if Contract."CATEGORIA MERCEOLOGICA" then XmlTxt:=XmlText.Create('SI')
        else
            XmlTxt:=XmlText.Create('NO');
        ChildNode.Add(XmlTxt);
        ParentNode.Add(ChildNode);
        RootNode.Add(ParentNode);
        //note
        ParentNode:=XmlElement.Create('note');
        XmlTxt:=XmlText.Create(Notes);
        ParentNode.Add(XmlTxt);
        RootNode.Add(ParentNode);
        TempBlob.CreateInStream(IStream);
        TempBlob.CreateOutStream(OStream);
        XmlDoc.WriteTo(OStream);
        //Download File
        FileName:=Format("AAT File Type SII"::"A01.0050") + '_' + CPUser + '.xml';
        File.DownloadFromStream(IStream, '', '', '', Filename);
    end;
    procedure ImportA010100File(RootNode: XmlElement; FileName: text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        SIILogEntries: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
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
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
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
        SIILogEntries.SetFilter(Type, '%1|%2', SIILogEntries.Type::"New Activation", SIILogEntries.Type::Reactivation);
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            //KB140224 - VAT Manager Setup added +++
            UtilitySetup.Get();
            if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
            else
                VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
            if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
            //KB140224 - VAT Manager Setup added ---   
            If Status = 1 then ActivationDataMgmt.ModifyActivationDataAfterVerification(false, SIILogEntries, FileName, NewActivationNo)
            else
                ActivationDataMgmt.ModifyActivationDataAfterVerification(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'A01_0100'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ImportA010150File(RootNode: XmlElement; FileName: text)
    var
        SIILogEntries1: Record "SII Log Entries";
        Meter: Record Meter;
        SIILogEntries: Record "SII Log Entries";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        ActivationDate: Date;
        MeterNo: Code[20];
        InstallationActive: array[3]of Decimal;
        InstallationReActive: array[3]of Decimal;
        InstallationPeak: array[3]of Decimal;
        Status: Integer;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
        MeterNoErrorLbl: Label 'There is no Meter No. that corresponds with: %1', Locked = true;
        PodNoErrorLbl: Label 'POD No. must be equal to %1 in SII Log Entries: Entry No.=%2. Current value is %3.', Comment = 'POD No. must be equal to %1 in SII Log Entries: Entry No.=%2. Current value is %3.';
    begin
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiRichiesta': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'cod_prat_utente': CPUser:=ChildElement.InnerText;
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Esito': Evaluate(Status, ParentElement.InnerText);
            'DatiTecnici': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of // AN 03012024 TASK002297  Added Error if Pod No. is Different in file +++
                    'cod_pod': begin
                        SIILogEntries1.Reset();
                        SIILogEntries1.SetFilter(Type, '%1|%2', SIILogEntries1.Type::"New Activation", SIILogEntries1.Type::Reactivation);
                        SIILogEntries1.SetRange("CP User", CPUser);
                        if SIILogEntries1.FindFirst()then if ChildElement.InnerText <> SIILogEntries1."POD No." then Error(PodNoErrorLbl, SIILogEntries1."POD No.", SIILogEntries1."Entry No.", ChildElement.InnerText)end;
                    // AN 03012024 TASK002297  Added Error if Pod No. is Different in file ---
                    'data_attivazione': Evaluate(ActivationDate, ChildElement.InnerText);
                    'Misuratore': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'matr_mis1': MeterNo:=SuperChildElement.InnerText;
                            end;
                        end;
                    end;
                    'LetturaAttiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Attiva1': Evaluate(InstallationActive[1], SuperChildElement.InnerText);
                            'segn_Attiva2': Evaluate(InstallationActive[2], SuperChildElement.InnerText);
                            'segn_Attiva3': Evaluate(InstallationActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaReattiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Reattiva1': Evaluate(InstallationReActive[1], SuperChildElement.InnerText);
                            'segn_Reattiva2': Evaluate(InstallationReActive[2], SuperChildElement.InnerText);
                            'segn_Reattiva3': Evaluate(InstallationReActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaPotenza': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Potenza1': Evaluate(InstallationPeak[1], SuperChildElement.InnerText);
                            'segn_Potenza2': Evaluate(InstallationPeak[2], SuperChildElement.InnerText);
                            'segn_Potenza3': Evaluate(InstallationPeak[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    end;
                end;
            end;
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetFilter(Type, '%1|%2', SIILogEntries.Type::"New Activation", SIILogEntries.Type::Reactivation);
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            if Status = 1 then begin
                ActivationDataMgmt.ModifyActivationAfterFinalVerification(false, SIILogEntries, FileName, NewActivationNo);
                if Meter.Get(MeterNo)then begin
                    if SIILogEntries.Type = SIILogEntries.Type::"New Activation" then begin
                        Meter.Validate("Installation Date", ActivationDate);
                        Meter.Validate("Installation F1 Active", InstallationActive[1]);
                        Meter.Validate("Installation F2 Active", InstallationActive[2]);
                        Meter.Validate("Installation F3 Active", InstallationActive[3]);
                        Meter.Validate("Installation F1 Reactive", InstallationReActive[1]);
                        Meter.Validate("Installation F2 Reactive", InstallationReActive[2]);
                        Meter.Validate("Installation F3 Reactive", InstallationReActive[3]);
                        Meter.Validate("Installation F1 Peak", InstallationPeak[1]);
                        Meter.Validate("Installation F2 Peak", InstallationPeak[2]);
                        Meter.Validate("Installation F3 Peak", InstallationPeak[3]);
                        Meter.Modify();
                        //KB07122023 - TASK002199 Reactivation Process Changes +++ 
                        ActivationDataMgmt.MeasurementDataUpdate(Meter, true); //KB07122023 - TASK002199 Meter Measurement List Update
                    end
                    else
                    begin
                        Meter.Validate("Reactivation Date", ActivationDate);
                        Meter.Validate("Reactivation F1 Active", InstallationActive[1]);
                        Meter.Validate("Reactivation F2 Active", InstallationActive[2]);
                        Meter.Validate("Reactivation F3 Active", InstallationActive[3]);
                        Meter.Validate("Reactivation F1 Reactive", InstallationReActive[1]);
                        Meter.Validate("Reactivation F2 Reactive", InstallationReActive[2]);
                        Meter.Validate("Reactivation F3 Reactive", InstallationReActive[3]);
                        Meter.Validate("Reactivation F1 Peak", InstallationPeak[1]);
                        Meter.Validate("Reactivation F2 Peak", InstallationPeak[2]);
                        Meter.Validate("Reactivation F3 Peak", InstallationPeak[3]);
                        Meter.Modify();
                        ActivationDataMgmt.MeasurementDataUpdate(Meter, false); //KB07122023 - TASK002199 Meter Measurement List Update
                    end;
                //KB07122023 - TASK002199 Reactivation Process Changes ---
                end
                else
                    Error(MeterNoErrorLbl, MeterNo);
            end
            else
                ActivationDataMgmt.ModifyActivationAfterFinalVerification(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'A01_0150'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    procedure ImportA010300File(RootNode: XmlElement; FileName: text)
    var
        Meter: Record Meter;
        SIILogEntries: Record "SII Log Entries";
        ActivationDataMgmt: Codeunit ActivationDataMgmt;
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        CPUser: Code[20];
        NewActivationNo: Code[20];
        ActivationDate: Date;
        MeterNo: Code[20];
        InstallationActive: array[3]of Decimal;
        InstallationReActive: array[3]of Decimal;
        InstallationPeak: array[3]of Decimal;
        Status: Integer;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
        MeterNoErrorLbl: Label 'There is no Meter No. that corresponds with: %1', Locked = true;
    begin
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiRichiesta': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'cod_prat_utente': CPUser:=ChildElement.InnerText;
                    'cod_prat_distr': NewActivationNo:=ChildElement.InnerText;
                    end;
                end;
            end;
            'Esito': Evaluate(Status, ParentElement.InnerText);
            'DatiTecnici': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'misuratore': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'matr_mis1': MeterNo:=SuperChildElement.InnerText;
                            end;
                        end;
                    end;
                    'LetturaAttiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Attiva1': Evaluate(InstallationActive[1], SuperChildElement.InnerText);
                            'segn_Attiva2': Evaluate(InstallationActive[2], SuperChildElement.InnerText);
                            'segn_Attiva3': Evaluate(InstallationActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaReattiva': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Reattiva1': Evaluate(InstallationReActive[1], SuperChildElement.InnerText);
                            'segn_Reattiva2': Evaluate(InstallationReActive[2], SuperChildElement.InnerText);
                            'segn_Reattiva3': Evaluate(InstallationReActive[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    'LetturaPotenza': begin
                        SuperChildNodeList:=ChildElement.GetChildElements();
                        foreach SuperChildNode in SuperChildNodeList do begin
                            SuperChildElement:=SuperChildNode.AsXmlElement();
                            case SuperChildElement.Name of 'segn_Potenza1': Evaluate(InstallationPeak[1], SuperChildElement.InnerText);
                            'segn_Potenza2': Evaluate(InstallationPeak[2], SuperChildElement.InnerText);
                            'segn_Potenza3': Evaluate(InstallationPeak[3], SuperChildElement.InnerText);
                            end;
                        end;
                    end;
                    end;
                end;
            end;
            end;
        end;
        SIILogEntries.Reset();
        SIILogEntries.SetFilter(Type, '%1|%2', SIILogEntries.Type::"New Activation", SIILogEntries.Type::Reactivation);
        SIILogEntries.SetRange("CP User", CPUser);
        if SIILogEntries.FindFirst()then begin
            if Status = 1 then begin
                ActivationDataMgmt.ModifyActivationAfterFinalVerificationOther(false, SIILogEntries, FileName, NewActivationNo);
                if Meter.Get(MeterNo)then begin
                    if SIILogEntries.Type = SIILogEntries.Type::"New Activation" then begin
                        Meter.Validate("Installation Date", ActivationDate);
                        Meter.Validate("Installation F1 Active", InstallationActive[1]);
                        Meter.Validate("Installation F2 Active", InstallationActive[2]);
                        Meter.Validate("Installation F3 Active", InstallationActive[3]);
                        Meter.Validate("Installation F1 Reactive", InstallationReActive[1]);
                        Meter.Validate("Installation F2 Reactive", InstallationReActive[2]);
                        Meter.Validate("Installation F3 Reactive", InstallationReActive[3]);
                        Meter.Validate("Installation F1 Peak", InstallationPeak[1]);
                        Meter.Validate("Installation F2 Peak", InstallationPeak[2]);
                        Meter.Validate("Installation F3 Peak", InstallationPeak[3]);
                        Meter.Modify();
                        //KB07122023 - TASK002199 Reactivation Process Changes +++ 
                        ActivationDataMgmt.MeasurementDataUpdate(Meter, true); //KB07122023 - TASK002199 Meter Measurement List Update
                    end
                    else
                    begin
                        Meter.Validate("Reactivation Date", ActivationDate);
                        Meter.Validate("Reactivation F1 Active", InstallationActive[1]);
                        Meter.Validate("Reactivation F2 Active", InstallationActive[2]);
                        Meter.Validate("Reactivation F3 Active", InstallationActive[3]);
                        Meter.Validate("Reactivation F1 Reactive", InstallationReActive[1]);
                        Meter.Validate("Reactivation F2 Reactive", InstallationReActive[2]);
                        Meter.Validate("Reactivation F3 Reactive", InstallationReActive[3]);
                        Meter.Validate("Reactivation F1 Peak", InstallationPeak[1]);
                        Meter.Validate("Reactivation F2 Peak", InstallationPeak[2]);
                        Meter.Validate("Reactivation F3 Peak", InstallationPeak[3]);
                        Meter.Modify();
                        ActivationDataMgmt.MeasurementDataUpdate(Meter, false); //KB07122023 - TASK002199 Meter Measurement List Update
                    end;
                //KB07122023 - TASK002199 Reactivation Process Changes ---
                end
                else
                    Error(MeterNoErrorLbl, MeterNo);
            end
            else
                ActivationDataMgmt.ModifyActivationAfterFinalVerificationOther(true, SIILogEntries, FileName, NewActivationNo);
            Message(StrSubstNo(ImportMessageLbl, 'A01_0300'));
        end
        else
            Error(CPUserErrorLbl, CPUser);
    end;
    //KB24112023 - TASK002131 New Activation Process --- //KB24112023 - TASK002167 Reactivation Process ---
    var CompanyInformation: Record "Company Information";
    ImportMessageLbl: Label 'Imported: %1', Comment = 'Import: %1';
}
