codeunit 60103 "Change of Customer Method Mgmt"
{
    // AN 14122023 TASK002199 Change of Customer +++
    procedure ChangeOFCustomerVT30200(var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    Var
        CompanyInformation: Record "Company Information";
        Contract_LRec: Record Contract;
        Customer_Lrec: Record Customer;
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        TariffHeader_rec: Record "Tariff Header";
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        CSVImportManager: Codeunit "CSV Import Manager";
        Error: Boolean;
        CPUserErrorLbl: Label 'There is no CP User that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        SIIEntryFilterString: Text;
        ExplanatoryStatement: Text;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        SIILogEntries.Reset();
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 6, CSVBuffer));
        if SIILogEntries.Findlast()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 6, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> GetText(RowNo, 3, CSVBuffer)then begin
                            ExplanatoryStatement+=StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer));
                            Error:=true;
                            Error(StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer)));
                        end;
                4: VATManagerNo:=GetText(RowNo, 4, CSVBuffer); //KB140224 - VAT Manager Setup added
                5: if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(CPUserErrorLbl, GetText(RowNo, 5, CSVBuffer));
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                6: begin
                    if SIILogEntries."POD No." <> GetText(RowNo, 6, CSVBuffer)then begin
                        ExplanatoryStatement+=StrSubstNo(PODErrorLbl, GetText(RowNo, 6, CSVBuffer));
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(SIILogEntries."POD No.", 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ExplanatoryStatement+=StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer));
                        Error:=true;
                        Error(StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer)));
                    end;
                //KB140224 - VAT Manager Setup added ---   
                end;
                7: if Customer_Lrec.Get(Contract_LRec."Customer No.")then Customer_Lrec.TestField("Fiscal Code", GetText(RowNo, 7, CSVBuffer));
                8: if Customer_Lrec.Get(Contract_LRec."Customer No.")then Customer_Lrec.TestField("VAT Registration No.", GetText(RowNo, 8, CSVBuffer));
                10: if Customer_Lrec."Customer Type" = Customer_Lrec."Customer Type"::Person then Customer_Lrec.TestField("First Name", GetText(RowNo, 10, CSVBuffer));
                11: if Customer_Lrec."Customer Type" = Customer_Lrec."Customer Type"::Person then Customer_Lrec.TestField("Last Name", GetText(RowNo, 11, CSVBuffer));
                12: begin
                    if Customer_Lrec."Customer Type" = Customer_Lrec."Customer Type"::Person then Customer_Lrec.TestField(Name, GetText(RowNo, 12, CSVBuffer));
                    if Customer_Lrec."Customer Type" = Customer_Lrec."Customer Type"::Company then Customer_Lrec.TestField(Name, GetText(RowNo, 12, CSVBuffer));
                end;
                51: begin
                    TariffHeader_rec.Reset();
                    TariffHeader_rec.SetRange("No.", Contract_LRec."Tariff Option No.");
                    if TariffHeader_rec.FindFirst()then TariffHeader_rec.TestField(COD_OFFERTA, GetText(RowNo, 51, CSVBuffer));
                end;
                end;
                if CSVBuffer."Field No." = 51 then begin
                    if Error then SIIEntryFilterString+=SIILogEntries."CP User" + '|';
                    if StrLen(SIIEntryFilterString) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIIEntryFilterString, 1, StrLen(SIIEntryFilterString) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::"VT3.0200")then UpdateDetaildSiiLogVT30200(SIILogEntries, CSVBuffer, Filename);
                end;
                CSVBuffer."Field No."+=1 until CSVBuffer."Field No." = 52;
        end;
    end;
    // AN 14122023 TASK002199 Change of Customer ---
    // AN 13122023 TASK002199 Change of Customer +++
    procedure ChangeOfCustomerVT10100(Var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    var
        CompanyInformation: Record "Company Information";
        Contract_LRec: Record Contract;
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        ChangeofCustomerMgt: Codeunit "Change of Customer Management";
        CSVImportManager: Codeunit "CSV Import Manager";
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        Error: Boolean;
        CHECKAMM: Code[5];
        CUASALCode: Code[5];
        PODNo: Code[25];
        CPUserErrorLbl: Label 'There is no CP User that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        SIIEntryFilterString: Text;
        ExplanatoryStatement: Text[150];
        FieldCount: Integer;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        PODEmptyErrorLbl: Label 'POD No Empty';
        CheckAMMErrorLbl: Label 'Check AMM is blank';
    begin
        FieldCount:=11;
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 6, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
        if SIILogEntries.FindFirst()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
            Repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> GetText(RowNo, 3, CSVBuffer)then begin
                            ExplanatoryStatement+=StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer));
                            Error:=true;
                            Error(StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer)));
                        end;
                4: VATManagerNo:=GetText(RowNo, 4, CSVBuffer); //KB140224 - VAT Manager Setup added
                6: begin
                    SIILogEntries.SetRange("CP User", GetText(RowNo, 6, CSVBuffer));
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(CPUserErrorLbl, GetText(RowNo, 6, CSVBuffer));
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(GetText(RowNo, 7, CSVBuffer), 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(PODErrorLbl, GetText(RowNo, 7, CSVBuffer));
                        Error:=true;
                        Error(StrSubstNo(PODErrorLbl, GetText(RowNo, 7, CSVBuffer)));
                    end;
                    if PODNo = '' then begin
                        Error:=true;
                        ExplanatoryStatement:=PODEmptyErrorLbl;
                        Error(PODEmptyErrorLbl);
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ExplanatoryStatement+=StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer));
                        Error:=true;
                        Error(StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer)));
                    end;
                //KB140224 - VAT Manager Setup added ---   
                end;
                8: begin
                    CHECKAMM:=CopyStr(GetText(RowNo, 8, CSVBuffer), 1, MaxStrLen(CHECKAMM));
                    if GetText(RowNo, 8, CSVBuffer) = '0' then Error:=true
                    else
                        Error:=false;
                    if CHECKAMM = '' then begin
                        Error:=true;
                        ExplanatoryStatement:=CheckAMMErrorLbl;
                        Error(CheckAMMErrorLbl);
                    end end;
                9: CUASALCode:=CopyStr(GetText(RowNo, 9, CSVBuffer), 1, MaxStrLen(CUASALCode));
                10: ExplanatoryStatement+=CopyStr(GetText(RowNo, 10, CSVBuffer), 1, MaxStrLen(ExplanatoryStatement));
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIIEntryFilterString+=SIILogEntries."CP User" + '|';
                    if StrLen(SIIEntryFilterString) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIIEntryFilterString, 1, StrLen(SIIEntryFilterString) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::"VT1.0100")then ChangeofCustomerMgt.ChangeofCustomerErrorCheck(Error, SIILogEntries, CUASALCode, ExplanatoryStatement, CSVBuffer, SIILogEntriesErrored, Filename);
                end;
                CSVBuffer."Field No."+=1;
            Until CSVBuffer."Field No." = FieldCount;
        end;
    end;
    // AN 13122023 TASK002199 Change of Customer ---
    procedure ChangeOfCustomerVT10150(Var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    Var
        Customer: Record Customer;
        SIILogEntries: Record "SII Log Entries";
        Contract_LRec: Record Contract;
        CompanyInformation: Record "Company Information";
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        CSVImportManager: Codeunit "CSV Import Manager";
        ChangeofCustomerMgt: Codeunit "Change of Customer Management";
        Error: Boolean;
        ResultCode: Code[5];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no CP User that corresponds with: %1', Locked = true;
        CustomerFiscalLbl: Label 'The Fiscal Code: %1 \\Is not associated with Customer: %2', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        ErrorString: Text;
        ResultDetail: Text[200];
        FieldCount: Integer;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        FieldCount:=18;
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
        SIILogEntries.SetRange(Status, SIILogEntries.Status::"Imported File VT1.0100");
        if SIILogEntries.FindFirst()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> GetText(RowNo, 3, CSVBuffer)then begin
                            ResultDetail+=StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer));
                            Error:=true;
                            Error(ResultDetail); //User VAT No.
                        end;
                4: VATManagerNo:=GetText(RowNo, 4, CSVBuffer); //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer)); //CP User
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(CPUserErrorLbl, GetText(RowNo, 5, CSVBuffer));
                        Error:=true;
                        Error(ResultDetail);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(GetText(RowNo, 7, CSVBuffer), 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(PODErrorLbl, PODNo);
                        Error:=true;
                        Error(StrSubstNo(PODErrorLbl, PODNo));
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ResultDetail+=StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer));
                        Error:=true;
                        Error(StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer)));
                    end;
                //KB140224 - VAT Manager Setup added ---   
                end;
                8: if GetText(RowNo, 8, CSVBuffer) = '0' then Error:=true
                    else
                        Error:=false;
                9: ResultCode:=CopyStr(GetText(RowNo, 9, CSVBuffer), 1, MaxStrLen(ResultCode)); //Result Code
                10: ResultDetail:=CopyStr(GetText(RowNo, 10, CSVBuffer), 1, MaxStrLen(ResultDetail)); //Result Detail
                11: begin //CF
                    Contract_LRec.SetRange("POD No.", PODNo);
                    Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
                    if not Contract_LRec.IsEmpty() and Contract_LRec.FindFirst()then if Customer.Get(Contract_LRec."Customer No.")then if Customer."Fiscal Code" <> GetText(RowNo, 11, CSVBuffer)then begin
                                ResultDetail+=StrSubstNo(CustomerFiscalLbl, GetText(RowNo, 11, CSVBuffer), Customer.Name);
                                Error:=true;
                                ErrorString:=StrSubstNo(CustomerFiscalLbl, GetText(RowNo, 11, CSVBuffer), Customer.Name);
                                Error(ErrorString);
                            end;
                end;
                end;
                if CSVBuffer."Field No." = 17 then if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::"VT1.0150")then ChangeofCustomerMgt.CompleteChangeofCustomerProcess(SIILogEntries, ResultCode, ResultDetail, Filename, Error);
                CSVBuffer."Field No."+=1;
            until CSVBuffer."Field No." = FieldCount;
        end;
    end;
    local procedure GetText(LineNo: Integer; FieldNo: Integer; CSVBufferVar: Record "CSV Buffer"): Text Var
        Value: Text;
    begin
        CSVBufferVar.Reset();
        if CSVBufferVar.Get(LineNo, FieldNo)then if Evaluate(value, CSVBufferVar.Value)then exit(Value)end;
    local procedure GetDate(LineNo: Integer; FieldNo: Integer; CSVBufferVar: Record "CSV Buffer"): Date Var
        Value: Date;
    begin
        CSVBufferVar.Reset();
        if CSVBufferVar.Get(LineNo, FieldNo)then if Evaluate(value, CSVBufferVar.Value)then exit(Value)end;
    // AN 13122023 TASK002199 Change of Customer VNO file +++
    procedure ChangeOfCustomerVNO(StreamIn: InStream; FileName: text)
    Var
        XmlDoc: XmlDocument;
        RootNode: XmlElement;
        Attribute: XmlAttribute;
        AttributeList: XmlAttributeCollection;
        Element: XmlElement;
        FileType: Text[10];
        FlowCode: Text[10];
        ServiceCode: Text[10];
        Result: XmlAttribute;
    begin
        XmlDocument.ReadFrom(StreamIn, xmlDoc);
        if xmlDoc.GetRoot(RootNode)then begin
            AttributeList:=RootNode.Attributes();
            if AttributeList.Get('CodFlusso', Result)then FlowCode:=CopyStr(Result.Value, 1, MaxStrLen(FlowCode));
            FileType:=FlowCode;
            case FileType of Format("AAT File Type SII"::VNO): ImportVNOFile(RootNode, FileName);
            end;
        end;
    end;
    // AN 13122023 TASK002199 Change of Customer VNO file ---
    local procedure ImportVNOFile(RootNode: XmlElement; FileName: Text)
    Var
        Pod_LRec: Record "Point of Delivery";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        Contract_Lrec: Record Contract;
        Measurement: Record "Measurement";
        SIILogEntries: Record "SII Log Entries";
        CompanyInformation: Record "Company Information";
        CSVImportManager: Codeunit "CSV Import Manager";
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        COCCodeLbl: Label 'There is no Contract Dispatch Code that corresponds with: %1', Locked = true;
        PODNoErrorLbl: Label 'Point of Delivery: %1, does not exist in Business Central.', Locked = true;
        Datetext: Text;
        FieldTextBuilder: TextBuilder;
        isError: Boolean;
    // Measurement: Record Measurement;
    begin
        Clear(FieldTextBuilder);
        ValidateFileNameBeforeImport(FileName, FieldTextBuilder);
        Clear(Measurement);
        Measurement.Init();
        ParentNodeList:=RootNode.GetChildElements();
        foreach ParentNode in ParentNodeList do begin
            ParentElement:=ParentNode.AsXmlElement();
            case ParentElement.Name of 'IdentificativiFlusso': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'PIvaUtente': begin
                        CompanyInformation.Get();
                        if CompanyInformation."VAT Registration No." <> ChildElement.InnerText then Error(CompanyVATNoLbl, ChildElement.InnerText);
                    end;
                    'CodContrDisp': begin
                        SIIInterfaceGeneralSetup.get();
                        if SIIInterfaceGeneralSetup."COC Code of Dispatching" <> ChildElement.InnerText then Error(COCCodeLbl, ChildElement.InnerText);
                    end;
                    end;
                end;
            end;
            'DatiPod': begin
                ChildNodeList:=ParentElement.GetChildElements();
                foreach ChildNode in ChildNodeList do begin
                    ChildElement:=ChildNode.AsXmlElement();
                    case ChildElement.Name of 'Pod': if not Pod_LRec.Get(ChildElement.InnerText)then begin
                            FieldTextBuilder.AppendLine(StrSubstNo(PODNoErrorLbl, ChildElement.InnerText));
                            Measurement."POD No.":=Pod_LRec."No.";
                            Measurement."Meter Serial No.":=Pod_LRec."Meter Serial No.";
                            Measurement.Insert(true);
                        end
                        else
                        begin
                            Measurement."POD No.":=Pod_LRec."No.";
                            Measurement."Meter Serial No.":=Pod_LRec."Meter Serial No.";
                            Measurement.Insert(true);
                        end;
                    'DataMisura': begin
                        Datetext:=ChildElement.InnerText;
                        Evaluate(Measurement."Measure Date", Datetext);
                        Evaluate(Measurement.Date, Datetext);
                    end;
                    'DataPrest': Evaluate(Measurement."Activiation Date", ChildElement.InnerText);
                    'CodPrat_SII': Measurement."SII Code":=CopyStr(ChildElement.InnerText, 1, MaxStrLen(Measurement."SII Code"));
                    'DatiPdp': begin
                        ChildNodeList:=ChildElement.GetChildElements();
                        foreach ChildNode in ChildNodeList do begin
                            ChildElement:=ChildNode.AsXmlElement();
                            case ChildElement.Name of 'Trattamento': Measurement."Measurement Frequency":=CopyStr(ChildElement.InnerText, 1, MaxStrLen(Measurement."Measurement Frequency"));
                            'Tensione': Evaluate(Measurement.Voltage, ChildElement.InnerText);
                            'Forfait': Measurement."Flat Rate":=ReturnBoolean(ChildElement.InnerText);
                            'GruppoMis': Measurement."Measurement Group":=ReturnBoolean(ChildElement.InnerText);
                            'Ka': Evaluate(Measurement."Active Constant", ChildElement.InnerText);
                            end;
                        end;
                    end;
                    'Misura': begin
                        ChildNodeList:=ChildElement.GetChildElements();
                        foreach ChildNode in ChildNodeList do begin
                            ChildElement:=ChildNode.AsXmlElement();
                            case ChildElement.Name of 'Raccolta': Measurement.Collection:=CopyStr(ChildElement.InnerText, 1, MaxStrLen(Measurement.Collection));
                            'TipoDato': Measurement."Data Type":=CopyStr(ChildElement.InnerText, 1, MaxStrLen(Measurement."Data Type"));
                            'Validato': Measurement.Validated:=ReturnBoolean(ChildElement.InnerText);
                            'EaF1': Evaluate(Measurement."Active F1", ChildElement.InnerText);
                            'EaF2': Evaluate(Measurement."Active F2", ChildElement.InnerText);
                            'EaF3': Evaluate(Measurement."Active F3", ChildElement.InnerText);
                            'ErF1': Evaluate(Measurement."Reactive F1", ChildElement.InnerText);
                            'ErF2': Evaluate(Measurement."Reactive F2", ChildElement.InnerText);
                            'ErF3': Evaluate(Measurement."Reactive F3", ChildElement.InnerText);
                            'PotF1': begin
                                Evaluate(Measurement."Peak F1", ChildElement.InnerText);
                                PopulateTempTable(ChildElement.InnerText);
                            end;
                            'PotF2': begin
                                Evaluate(Measurement."Peak F2", ChildElement.InnerText);
                                PopulateTempTable(ChildElement.InnerText);
                            end;
                            'PotF3': begin
                                Evaluate(Measurement."Peak F3", ChildElement.InnerText);
                                PopulateTempTable(ChildElement.InnerText);
                            end;
                            end;
                        end;
                    end;
                    end;
                end end end end;
        Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3" + Measurement."Active F4" + Measurement."Active F5" + Measurement."Active F6";
        Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3" + Measurement."Reactive F4" + Measurement."Reactive F5" + Measurement."Reactive F6";
        Measurement."Peak Total":=ReturnPeakTotal();
        Measurement.Validate("Import Date", Today);
        Measurement.Validate(Date, Today);
        Measurement.Modify();
        Contract_Lrec.Reset();
        Contract_Lrec.SetRange("POD No.", Measurement."POD No.");
        Contract_Lrec.SetFilter(Status, '%1|%2', Contract_Lrec.Status::Open, Contract_Lrec.Status::"In Registration");
        if Contract_Lrec.FindLast()then begin
            SIILogEntries.Reset();
            SIILogEntries.SetRange("POD No.", Measurement."POD No.");
            SIILogEntries.SetRange(Type, SIILogEntries.type::"Change of Customer");
            SIILogEntries.SetRange("Contract No.", Contract_Lrec."No.");
            if SIILogEntries.FindLast()then if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::VNO)then UpdateDetaildSIILogVNO(SIILogEntries, Filename);
        end;
    end;
    // AN 13122023 TASK002199 Change of Customer VNO file ---
    local procedure ValidateFileNameBeforeImport(Filename: Text; var TextBuilder: TextBuilder): Boolean var
        Measurement: Record Measurement;
        DateLbl: Label 'File %1 already imported on %2', Locked = true;
    begin
        Measurement.SetRange("File Name", Filename);
        if not Measurement.IsEmpty()then begin
            TextBuilder.AppendLine:=StrSubstNo(DateLbl, Filename, Measurement."Import Date");
            exit(true);
        end;
    end;
    local procedure ReturnBoolean(TextToConvert: Text): Boolean var
    begin
        case TextToConvert of 'si': exit(true);
        's': exit(true);
        'y': exit(true);
        'yes': exit(true);
        else
            exit(false);
        end;
    end;
    local procedure PopulateTempTable(PeakValue: Text)
    var
    begin
        TempPeakTotalBuffer.Init();
        TempPeakTotalBuffer."Entry No":=PeakEntryNo + 1;
        Evaluate(TempPeakTotalBuffer.Value, PeakValue);
        TempPeakTotalBuffer.Insert(true);
        PeakEntryNo:=TempPeakTotalBuffer."Entry No";
    end;
    local procedure ReturnPeakTotal(): Decimal var
    begin
        TempPeakTotalBuffer.SetCurrentKey(Value);
        if TempPeakTotalBuffer.FindLast()then exit(TempPeakTotalBuffer.Value);
    end;
    local procedure UpdateDetaildSiiLogVT30200(SIILogEntries: Record "SII Log Entries"; CSVBuffer: Record "CSV Buffer"; Filename: Text)
    Var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        MessageLbl: Label 'The following file has been imported: %1 \\Detailed SII Log Entry %2 has been created.', Locked = true;
        DetailedEntryNo: Integer;
    begin
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntries, Filename);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT3.0200";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
            DetailedSIILogEntry."CP User":=SIILogEntries."CP User";
            DetailedSIILogEntry.Modify(true);
            Message(MessageLbl, Filename, DetailedEntryNo);
        end;
        SIILogEntries.Status:=SIILogEntries.Status::"Imported File VT3.0200";
        SIILogEntries.Modify();
    end;
    local procedure UpdateDetaildSIILogVNO(SIILogEntries: Record "SII Log Entries"; Filename: Text)
    Var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        MessageLbl: Label 'The following file has been imported: %1 \\Detailed SII Log Entry %2 has been created.', Locked = true;
        DetailedEntryNo: Integer;
    begin
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntries, Filename);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"VNO";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
            DetailedSIILogEntry."CP User":=SIILogEntries."CP User";
            DetailedSIILogEntry.Modify(true);
            Message(MessageLbl, Filename, DetailedEntryNo);
        end;
        SIILogEntries.Status:=SIILogEntries.Status::"Imported File VNO";
        SIILogEntries.Modify();
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; FileName: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", Today());
        DetailedSIILogEntry.Validate(User, UserId());
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    VAR TempPeakTotalBuffer: Record "Temp. Peak Total Buffer" temporary;
    PeakEntryNo: Integer;
}
