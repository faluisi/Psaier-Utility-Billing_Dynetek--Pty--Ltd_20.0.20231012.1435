codeunit 50209 "XML Import Manager"
{
    trigger OnRun()
    begin
    end;
    //KB30112023 - TASK002171 Measurement Upload Process +++
    procedure ImportMeasurementFileSelection()
    var
        ChangeOfCustomer: Codeunit "Change of Customer Method Mgmt";
        UploadStreamMsg: Label 'Do you want to upload the xml file?';
        IStream: InStream;
        RootNode: XmlElement;
        XmlDoc: XmlDocument;
        Attribute: XmlAttribute;
        AttributeList: XmlAttributeCollection;
        FileName: Text;
        FlowCode: Text[10];
    begin
        if UploadIntoStream(UploadStreamMsg, '', '', FileName, IStream)then if XmlDocument.ReadFrom(IStream, XmlDoc)then begin
                XmlDoc.GetRoot(RootNode);
                AttributeList:=RootNode.Attributes();
                foreach Attribute in AttributeList do case Attribute.Name of 'CodFlusso': FlowCode:=CopyStr(Attribute.Value, 1, MaxStrLen(FlowCode));
                    end;
                case FlowCode of 'PNO': ImportXML(RootNode, FileName, IStream);
                'PDO': ImportXMLCosumption(RootNode, FileName, IStream);
                'VNO': ChangeOfCustomer.ChangeOfCustomerVNO(IStream, FileName);
                'SNM': ImportSiwtchInMeasurement(RootNode, FileName, IStream);
                end;
            end;
    end;
    //KB30112023 - TASK002171 Measurement Upload Process ---
    /// <summary>
    /// ImportXML.
    /// </summary>
    procedure ImportXML(Root: XmlElement; FileName: Text; CSVInStream: InStream) //KB30112023 - - TASK002171 Measurement Upload Process Parameters add
    var
        Measurement: Record "Measurement";
        PointofDelivery: Record "Point of Delivery";
        CSVOutStream: OutStream;
        Records: XmlNodeList;
        Node: XmlNode;
        e: XmlElement;
        fieldnode: XmlNode;
        Xmlfield: XmlElement;
        isError: Boolean;
        FieldTextBuilder: TextBuilder;
        Datetext: Text;
        FieldTextBuilder1Msg: Label 'Point of Delivery:';
        FieldTextBuilder2Msg: Label ', does not exist in Business Central';
    begin
        Clear(TempPeakTotalBuffer);
        isError:=ValidateFileNameBeforeImport(FileName, FieldTextBuilder);
        Records:=Root.GetChildElements('DatiPod');
        foreach Node in Records do begin
            e:=Node.AsXmlElement();
            Clear(Measurement);
            TempPeakTotalBuffer.DeleteAll();
            Measurement.Init();
            WindowDialog.Open(ImportMessageLbl, MeasurementCounter, Errors);
            foreach fieldnode in e.GetChildElements()do begin
                Xmlfield:=fieldnode.AsXmlElement();
                case Xmlfield.Name of 'Pod': begin
                    Clear(PointofDelivery);
                    if not PointofDelivery.Get(Xmlfield.InnerText)then begin
                        isError:=true;
                        Clear(FieldTextBuilder);
                        FieldTextBuilder.AppendLine(FieldTextBuilder1Msg + Xmlfield.InnerText + FieldTextBuilder2Msg);
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
                        Measurement.Insert(true);
                    end
                    else
                    begin
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
                        Measurement.Insert(true);
                    end;
                end;
                'MeseAnno': Evaluate(Measurement.Month, Xmlfield.InnerText);
                'TipoRettifica': Measurement."Type of Measure":=CopyStr(Xmlfield.InnerText, 1, MaxStrLen(Measurement."Type of Measure"));
                'DataRilevazione': Evaluate(Measurement."Date Detection", Xmlfield.InnerText);
                'Motivazione': Measurement.Motiviation:=CopyStr(Xmlfield.InnerText, 1, MaxStrLen(Measurement.Motiviation));
                'DataMisura': begin
                    Datetext:=Xmlfield.InnerText;
                    Evaluate(Measurement."Measure Date", Datetext);
                    Evaluate(Measurement.Date, Datetext);
                end;
                'DataPrest': Evaluate(Measurement."Activiation Date", Xmlfield.InnerText);
                'CodPrat_SII': Measurement."SII Code":=CopyStr(Xmlfield.InnerText, 1, MaxStrLen(Measurement."SII Code"));
                'DatiPdp': begin
                    Records:=Xmlfield.GetChildElements();
                    foreach Node in Records do begin
                        e:=Node.AsXmlElement();
                        case e.Name of 'Trattamento': Measurement."Measurement Frequency":=CopyStr(e.InnerText, 1, MaxStrLen(Measurement."Measurement Frequency"));
                        'Tensione': Evaluate(Measurement.Voltage, e.InnerText);
                        'Forfait': Measurement."Flat Rate":=ReturnBoolean(e.InnerText);
                        'GruppoMis': Measurement."Measurement Group":=ReturnBoolean(e.InnerText);
                        'Ka': Evaluate(Measurement."Active Constant", e.InnerText);
                        'Kr': Evaluate(Measurement."Reactive Constant", e.InnerText);
                        'Kp': Evaluate(Measurement."Power Constant", e.InnerText);
                        end;
                    end;
                end;
                'Misura': begin
                    Records:=Xmlfield.GetChildElements();
                    foreach Node in Records do begin
                        e:=Node.AsXmlElement();
                        case e.Name of 'Raccolta': Measurement.Collection:=CopyStr(e.InnerText, 1, MaxStrLen(Measurement.Collection));
                        'TipoDato': Measurement."Data Type":=CopyStr(e.InnerText, 1, MaxStrLen(Measurement."Data Type"));
                        'MotivazioneStima': Measurement."Motivation Estimate":=ReturnBoolean(e.InnerText);
                        'Validato': Measurement.Validated:=ReturnBoolean(e.InnerText);
                        'PotMax': Evaluate(Measurement."Peak Total", e.InnerText);
                        'EaF1': Evaluate(Measurement."Active F1", e.InnerText);
                        'EaF2': Evaluate(Measurement."Active F2", e.InnerText);
                        'EaF3': Evaluate(Measurement."Active F3", e.InnerText);
                        'EaF4': Evaluate(Measurement."Active F4", e.InnerText);
                        'EaF5': Evaluate(Measurement."Active F5", e.InnerText);
                        'EaF6': Evaluate(Measurement."Active F6", e.InnerText);
                        'ErF1': Evaluate(Measurement."Reactive F1", e.InnerText);
                        'ErF2': Evaluate(Measurement."Reactive F2", e.InnerText);
                        'ErF3': Evaluate(Measurement."Reactive F3", e.InnerText);
                        'ErF4': Evaluate(Measurement."Reactive F4", e.InnerText);
                        'ErF5': Evaluate(Measurement."Reactive F5", e.InnerText);
                        'ErF6': Evaluate(Measurement."Reactive F6", e.InnerText);
                        'PotF1': begin
                            Evaluate(Measurement."Peak F1", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        'PotF2': begin
                            Evaluate(Measurement."Peak F2", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        'PotF3': begin
                            Evaluate(Measurement."Peak F3", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        'PotF4': begin
                            Evaluate(Measurement."Peak F4", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        'PotF5': begin
                            Evaluate(Measurement."Peak F5", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        'PotF6': begin
                            Evaluate(Measurement."Peak F6", e.InnerText);
                            PopulateTempTable(e.InnerText);
                        end;
                        end;
                    end;
                end;
                end;
            end;
            Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3" + Measurement."Active F4" + Measurement."Active F5" + Measurement."Active F6";
            Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3" + Measurement."Reactive F4" + Measurement."Reactive F5" + Measurement."Reactive F6";
            Measurement."Import Date":=Today();
            Measurement."File Name":=CopyStr(FileName, 1, MaxStrLen(Measurement."File Name"));
            Measurement."Peak Total":=ReturnPeakTotal(); //TODO Calculate based on reading type and reading detection of meter{Next Phase}
            Measurement."Flow Code":='PNO'; //KB30112023 - TASK002171 Measurement Upload Process
            Measurement."XML File".CreateOutStream(CSVOutStream);
            CopyStream(CSVOutStream, CSVInStream);
            if Format(Measurement.Month) = '' then Evaluate(Measurement.Month, Format(Measurement."Measure Date", 0, '<Month,2>/<Year4>'));
            if Format(Measurement."Measure Date") = '' then Measurement."Measure Date":=CalcDate('<-CM>', Measurement.Month);
            CompareMeasurement(Measurement, PointofDelivery);
            if isError then CreateImportErrorEntry(Measurement, FieldTextBuilder);
            if PlausibilityCheck(Measurement)then begin
                FieldTextBuilder.Append('Above Plausibility Range');
                CreateImportErrorEntry(Measurement, FieldTextBuilder);
            end;
            if Format(Measurement.Month) = '' then Measurement.Month:=Measurement."Measure Date";
            if Format(Measurement."Measure Date") = '' then Measurement."Measure Date":=Measurement.Month;
            Measurement.Modify(true);
            MeasurementCounter+=1;
            WindowDialog.Update(1, MeasurementCounter);
            WindowDialog.Update(2, Errors);
        end;
        WindowDialog.Close();
        Message(StrSubstNo(ImportedMessageLbl, MeasurementCounter, Errors));
    end;
    //KB30112023 - TASK002171 Measurement Upload Process +++
    procedure ImportXMLCosumption(RootNode: XmlElement; FileName: Text; IStream: InStream)
    var
        Measurement: Record "Measurement";
        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
        PointofDelivery: Record "Point of Delivery";
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        Attribute: XmlAttribute;
        isError: Boolean;
        FieldTextBuilder: TextBuilder;
        EndLoop: Integer;
        StartLoop: Integer;
        dd: Integer;
        OStream: OutStream;
        PODNoErrorLbl: Label 'Point of Delivery: %1, does not exist in Business Central.', Comment = 'Point of Delivery: %1, does not exist in Business Central.';
    begin
        Clear(FieldTextBuilder);
        isError:=ValidateFileNameBeforeImport(FileName, FieldTextBuilder);
        ParentNodeList:=RootNode.GetChildElements('DatiPod');
        foreach ParentNode in ParentNodeList do begin
            Clear(Measurement);
            Measurement.Init();
            WindowDialog.Open(ImportMessageLbl, MeasurementCounter, Errors);
            ParentElement:=ParentNode.AsXmlElement();
            ChildNodeList:=ParentElement.GetChildElements();
            foreach ChildNode in ChildNodeList do begin
                ChildElement:=ChildNode.AsXmlElement();
                case ChildElement.Name of 'Pod': if not PointofDelivery.Get(ChildElement.InnerText)then begin
                        isError:=true;
                        FieldTextBuilder.AppendLine(StrSubstNo(PODNoErrorLbl, ChildElement.InnerText));
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
                        Measurement.Insert(true);
                    end
                    else
                    begin
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
                        Measurement.Insert(true);
                    end;
                'MeseAnno': Evaluate(Measurement.Month, ChildElement.InnerText);
                'DatiPdp': begin
                    SuperChildNodeList:=ChildElement.GetChildElements();
                    foreach SuperChildNode in SuperChildNodeList do begin
                        SuperChildElement:=SuperChildNode.AsXmlElement();
                        case SuperChildElement.Name of 'Trattamento': Measurement."Measurement Frequency":=SuperChildElement.InnerText;
                        'Tensione': Evaluate(Measurement.Voltage, SuperChildElement.InnerText);
                        'Forfait': Measurement."Flat Rate":=ReturnBoolean(SuperChildElement.InnerText);
                        'GruppoMis': Measurement."Measurement Group":=ReturnBoolean(SuperChildElement.InnerText);
                        'Ka': Evaluate(Measurement."Active Constant", SuperChildElement.InnerText);
                        'Kr': Evaluate(Measurement."Reactive Constant", SuperChildElement.InnerText);
                        'Kp': Evaluate(Measurement."Power Constant", SuperChildElement.InnerText);
                        end;
                    end;
                end;
                'Misura': begin
                    SuperChildNodeList:=ChildElement.GetChildElements();
                    foreach SuperChildNode in SuperChildNodeList do begin
                        SuperChildElement:=SuperChildNode.AsXmlElement();
                        case SuperChildElement.Name of 'Raccolta': Measurement.Collection:=SuperChildElement.InnerText;
                        'TipoDato': Measurement."Data Type":=SuperChildElement.InnerText;
                        'Validato': Measurement.Validated:=ReturnBoolean(SuperChildElement.InnerText);
                        'PotMax': Evaluate(Measurement."Peak Total", SuperChildElement.InnerText);
                        'Ea': begin
                            Evaluate(dd, SuperChildElement.InnerText);
                            EndLoop:=SuperChildElement.Attributes().Count;
                            for StartLoop:=1 to EndLoop do begin
                                SuperChildElement.Attributes().Get(StartLoop, Attribute);
                                Clear(MeasurementHourlyDetail);
                                MeasurementHourlyDetail.Init();
                                MeasurementHourlyDetail."Measurement Entry No.":=Measurement."Entry No.";
                                Evaluate(MeasurementHourlyDetail.Day, SuperChildElement.InnerText);
                                MeasurementHourlyDetail.Type:=ActiveLbl;
                                if dd = 1 then MeasurementHourlyDetail."Measurement Date":=Measurement.Month
                                else
                                    MeasurementHourlyDetail."Measurement Date":=CalcDate('<' + Format(dd - 1) + 'D>', Measurement.Month);
                                MeasurementHourlyDetail."Fascia Type":=GetFasciaType(StartLoop, MeasurementHourlyDetail."Measurement Date");
                                MeasurementHourlyDetail."Measurement Interval":=CopyStr(Attribute.Name, 1, MaxStrLen(MeasurementHourlyDetail."Measurement Interval"));
                                Evaluate(MeasurementHourlyDetail.Measurement, Attribute.Value);
                                if UpperCase(MeasurementHourlyDetail."Measurement Interval") <> 'DST' then MeasurementHourlyDetail.Insert(true);
                            end;
                        end;
                        'Er': begin
                            Evaluate(dd, SuperChildElement.InnerText);
                            EndLoop:=SuperChildElement.Attributes().Count;
                            for StartLoop:=1 to EndLoop do begin
                                SuperChildElement.Attributes().Get(StartLoop, Attribute);
                                Clear(MeasurementHourlyDetail);
                                MeasurementHourlyDetail.Init();
                                MeasurementHourlyDetail."Measurement Entry No.":=Measurement."Entry No.";
                                Evaluate(MeasurementHourlyDetail.Day, SuperChildElement.InnerText);
                                MeasurementHourlyDetail.Type:=ReactiveLbl;
                                if dd = 1 then MeasurementHourlyDetail."Measurement Date":=Measurement.Month
                                else
                                    MeasurementHourlyDetail."Measurement Date":=CalcDate('<' + Format(dd - 1) + 'D>', Measurement.Month);
                                MeasurementHourlyDetail."Fascia Type":=GetFasciaType(StartLoop, MeasurementHourlyDetail."Measurement Date");
                                MeasurementHourlyDetail."Measurement Interval":=CopyStr(Attribute.Name, 1, MaxStrLen(MeasurementHourlyDetail."Measurement Interval"));
                                Evaluate(MeasurementHourlyDetail.Measurement, Attribute.Value);
                                if UpperCase(MeasurementHourlyDetail."Measurement Interval") <> 'DST' then MeasurementHourlyDetail.Insert(true);
                            end;
                        end;
                        end;
                    end;
                end;
                end;
            end;
            Measurement."Active F1":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F1, ActiveLbl);
            Measurement."Active F2":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F2, ActiveLbl);
            Measurement."Active F3":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F3, ActiveLbl);
            Measurement."Reactive F1":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F1, ReactiveLbl);
            Measurement."Reactive F2":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F2, ReactiveLbl);
            Measurement."Reactive F3":=GetFasciaTotalValue(Measurement."Entry No.", "Fascia Type"::F3, ReactiveLbl);
            Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3" + Measurement."Active F4" + Measurement."Active F5" + Measurement."Active F6";
            Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3" + Measurement."Reactive F4" + Measurement."Reactive F5" + Measurement."Reactive F6";
            Measurement."Import Date":=Today();
            Measurement."File Name":=CopyStr(FileName, 1, MaxStrLen(Measurement."File Name"));
            Measurement."Flow Code":='PDO';
            Measurement."XML File".CreateOutStream(OStream);
            CopyStream(OStream, IStream);
            if Measurement."Measure Date" = 0D then Measurement."Measure Date":=Measurement.Month;
            if Measurement.Date = 0D then Measurement.Date:=Measurement."Measure Date";
            CompareMeasurement(Measurement, PointofDelivery);
            if isError then CreateImportErrorEntry(Measurement, FieldTextBuilder);
            if PlausibilityCheck(Measurement)then begin
                FieldTextBuilder.Append('Above Plausibility Range');
                CreateImportErrorEntry(Measurement, FieldTextBuilder);
            end;
            Measurement.Modify(true);
            MeasurementCounter+=1;
            WindowDialog.Update(1, MeasurementCounter);
            WindowDialog.Update(2, Errors);
        end;
        WindowDialog.Close();
        Message(StrSubstNo(ImportedMessageLbl, MeasurementCounter, Errors));
    end;
    //KB12122023 - TASK002199 Switch In Measurement Import +++
    procedure ImportSiwtchInMeasurement(RootNode: XmlElement; FileName: Text; IStream: InStream)
    var
        Measurement: Record "Measurement";
        PointofDelivery: Record "Point of Delivery";
        ParentNode: XmlNode;
        ParentElement: XmlElement;
        ParentNodeList: XmlNodeList;
        ChildNode: XmlNode;
        ChildElement: XmlElement;
        ChildNodeList: XmlNodeList;
        SuperChildNode: XmlNode;
        SuperChildElement: XmlElement;
        SuperChildNodeList: XmlNodeList;
        isError: Boolean;
        FieldTextBuilder: TextBuilder;
        OStream: OutStream;
        Datetext: Text;
        PODNoErrorLbl: Label 'Point of Delivery: %1, does not exist in Business Central.', Comment = 'Point of Delivery: %1, does not exist in Business Central.';
    begin
        Clear(FieldTextBuilder);
        isError:=ValidateFileNameBeforeImport(FileName, FieldTextBuilder);
        ParentNodeList:=RootNode.GetChildElements('DatiPod');
        foreach ParentNode in ParentNodeList do begin
            Measurement.Init();
            WindowDialog.Open(ImportMessageLbl, MeasurementCounter, Errors);
            ParentElement:=ParentNode.AsXmlElement();
            ChildNodeList:=ParentElement.GetChildElements();
            foreach ChildNode in ChildNodeList do begin
                ChildElement:=ChildNode.AsXmlElement();
                case ChildElement.Name of 'Pod': if not PointofDelivery.Get(ChildElement.InnerText)then begin
                        isError:=true;
                        FieldTextBuilder.AppendLine(StrSubstNo(PODNoErrorLbl, ChildElement.InnerText));
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
                        Measurement.Insert(true);
                    end
                    else
                    begin
                        Measurement."POD No.":=PointofDelivery."No.";
                        Measurement."Meter Serial No.":=PointofDelivery."Meter Serial No.";
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
                    SuperChildNodeList:=ChildElement.GetChildElements();
                    foreach SuperChildNode in SuperChildNodeList do begin
                        SuperChildElement:=SuperChildNode.AsXmlElement();
                        case SuperChildElement.Name of 'Trattamento': Measurement."Measurement Frequency":=SuperChildElement.InnerText;
                        'Tensione': Evaluate(Measurement.Voltage, SuperChildElement.InnerText);
                        'Forfait': Measurement."Flat Rate":=ReturnBoolean(SuperChildElement.InnerText);
                        'GruppoMis': Measurement."Measurement Group":=ReturnBoolean(SuperChildElement.InnerText);
                        'Ka': Evaluate(Measurement."Active Constant", SuperChildElement.InnerText);
                        'Kr': Evaluate(Measurement."Reactive Constant", SuperChildElement.InnerText);
                        'Kp': Evaluate(Measurement."Power Constant", SuperChildElement.InnerText);
                        end;
                    end;
                end;
                'Misura': begin
                    SuperChildNodeList:=ChildElement.GetChildElements();
                    foreach SuperChildNode in SuperChildNodeList do begin
                        SuperChildElement:=SuperChildNode.AsXmlElement();
                        case SuperChildElement.Name of 'Raccolta': Measurement.Collection:=SuperChildElement.InnerText;
                        'TipoDato': Measurement."Data Type":=SuperChildElement.InnerText;
                        'Validato': Measurement.Validated:=ReturnBoolean(SuperChildElement.InnerText);
                        'PotMax': Evaluate(Measurement."Peak Total", SuperChildElement.InnerText);
                        'EaF1': Evaluate(Measurement."Active F1", SuperChildElement.InnerText);
                        'EaF2': Evaluate(Measurement."Active F2", SuperChildElement.InnerText);
                        'EaF3': Evaluate(Measurement."Active F3", SuperChildElement.InnerText);
                        'EaF4': Evaluate(Measurement."Active F4", SuperChildElement.InnerText);
                        'EaF5': Evaluate(Measurement."Active F5", SuperChildElement.InnerText);
                        'EaF6': Evaluate(Measurement."Active F6", SuperChildElement.InnerText);
                        'ErF1': Evaluate(Measurement."Reactive F1", SuperChildElement.InnerText);
                        'ErF2': Evaluate(Measurement."Reactive F2", SuperChildElement.InnerText);
                        'ErF3': Evaluate(Measurement."Reactive F3", SuperChildElement.InnerText);
                        'ErF4': Evaluate(Measurement."Reactive F4", SuperChildElement.InnerText);
                        'ErF5': Evaluate(Measurement."Reactive F5", SuperChildElement.InnerText);
                        'ErF6': Evaluate(Measurement."Reactive F6", SuperChildElement.InnerText);
                        'PotF1': begin
                            Evaluate(Measurement."Peak F1", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        'PotF2': begin
                            Evaluate(Measurement."Peak F2", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        'PotF3': begin
                            Evaluate(Measurement."Peak F3", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        'PotF4': begin
                            Evaluate(Measurement."Peak F4", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        'PotF5': begin
                            Evaluate(Measurement."Peak F5", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        'PotF6': begin
                            Evaluate(Measurement."Peak F6", SuperChildElement.InnerText);
                            PopulateTempTable(SuperChildElement.InnerText);
                        end;
                        end;
                    end;
                end;
                end;
            end;
            Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3" + Measurement."Active F4" + Measurement."Active F5" + Measurement."Active F6";
            Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3" + Measurement."Reactive F4" + Measurement."Reactive F5" + Measurement."Reactive F6";
            Measurement."Peak Total":=ReturnPeakTotal();
            Measurement."Import Date":=Today();
            Measurement."File Name":=CopyStr(FileName, 1, MaxStrLen(Measurement."File Name"));
            Measurement."Flow Code":='SNM';
            Measurement."XML File".CreateOutStream(OStream);
            CopyStream(OStream, IStream);
            if Measurement.Month = 0D then Evaluate(Measurement.Month, Format(Measurement."Measure Date", 0, '<Month,2>/<Year4>'));
            CompareMeasurement(Measurement, PointofDelivery);
            if isError then CreateImportErrorEntry(Measurement, FieldTextBuilder);
            if PlausibilityCheck(Measurement)then begin
                FieldTextBuilder.Append('Above Plausibility Range');
                CreateImportErrorEntry(Measurement, FieldTextBuilder);
            end;
            Measurement.Modify(true);
            MeasurementCounter+=1;
            WindowDialog.Update(1, MeasurementCounter);
            WindowDialog.Update(2, Errors);
        end;
        WindowDialog.Close();
        Message(StrSubstNo(ImportedMessageLbl, MeasurementCounter, Errors));
    end;
    //KB12122023 - TASK002199 Switch In Measurement Import ---
    local procedure GetFasciaType(Interval: Integer; CheckDate: Date): Enum "Fascia Type" var
        TimeShift: Record "Time Shift";
        CompanyInformation: Record "Company Information";
        CustomCalenderChange: Record "Customized Calendar Change";
        CalenderMgmt: Codeunit "Calendar Management";
        StartInterval: Integer;
        EndInterval: Integer;
        FasciaType: Enum "Fascia Type";
        Type: Enum "Working/Non-Working Day Type";
    begin
        CompanyInformation.get();
        CalenderMgmt.SetSource(CompanyInformation, CustomCalenderChange);
        if CalenderMgmt.IsNonworkingDay(CheckDate, CustomCalenderChange)then Type:=Type::"Sunday/Holiday"
        else if Date2DWY(CheckDate, 1) = 6 then Type:=Type::Saturday
            else
                Type:=Type::"Week Day";
        TimeShift.Reset();
        TimeShift.SetRange(Type, Type);
        if TimeShift.FindSet()then repeat if TimeShift."Start Time" = 000000T then StartInterval:=0
                else
                    StartInterval:=(TimeShift."Start Time" - 000000T) / 3600000 * 4;
                if TimeShift."End Time" = 000000T then EndInterval:=96
                else
                    EndInterval:=(TimeShift."End Time" - 000000T) / 3600000 * 4;
                if(Interval > StartInterval) and (Interval <= EndInterval)then FasciaType:=TimeShift.Code;
            until TimeShift.Next() = 0;
        exit(FasciaType);
    end;
    local procedure GetFasciaTotalValue(MeasurementEntryNo: Integer; FasciaType: Enum "Fascia Type"; Type: Text[25]): Decimal var
        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
    begin
        MeasurementHourlyDetail.Reset();
        MeasurementHourlyDetail.SetRange("Measurement Entry No.", MeasurementEntryNo);
        MeasurementHourlyDetail.SetRange(Type, Type);
        MeasurementHourlyDetail.SetRange("Fascia Type", FasciaType);
        if MeasurementHourlyDetail.FindSet()then begin
            MeasurementHourlyDetail.CalcSums(Measurement);
            exit(MeasurementHourlyDetail.Measurement);
        end
        else
            exit(0);
    end;
    //KB30112023 - TASK002171 Measurement Upload Process ---
    local procedure PlausibilityCheck(var Measurement: Record Measurement): Boolean var
        Measurement2: Record Measurement;
        UtilitySetup: Record "Utility Setup";
        Month: Date;
        Difference: Decimal;
        PercentageDiff: Decimal;
    begin
        UtilitySetup.Get();
        Month:=CalcDate('<-1M>', Measurement.Month);
        Measurement2.SetRange("POD No.", Measurement."POD No.");
        Measurement2.SetRange(Month, Month);
        if Measurement."Peak Total" <> 0 then if Measurement2.FindFirst()then begin
                Difference:=(Measurement."Peak Total" - Measurement2."Peak Total");
                PercentageDiff:=(Difference / Measurement."Peak Total") * 100;
            end;
        if Abs(PercentageDiff) >= UtilitySetup."Plausibility Percentage" then exit(true);
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
    local procedure CompareMeasurement(var Measurement: Record Measurement; POD: Record "Point of Delivery")
    var
        Measurement2: Record Measurement;
    begin
        Measurement2.SetRange("POD No.", POD."No.");
        Measurement2.SetRange("Latest Measurement", true);
        if Measurement2.FindFirst()then begin
            Measurement2."Latest Measurement":=false;
            Measurement."Latest Measurement":=true;
            Measurement2.Modify(true);
        end
        else
            Measurement."Latest Measurement":=true;
    end;
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
    local procedure CreateImportErrorEntry(var Measurement: Record Measurement; var TextBuilder: TextBuilder)
    var
    begin
        Measurement."Import Error":=true;
        Measurement."Import Status":="Measurement Import Status"::"Imported with Errors";
        Measurement."Import Notes":=CopyStr(TextBuilder.ToText(), 1, MaxStrLen(Measurement."Import Notes"));
        Errors+=1;
    end;
    var TempPeakTotalBuffer: Record "Temp. Peak Total Buffer" temporary;
    ReactiveLbl: Label 'Reactive', Locked = true;
    ActiveLbl: Label 'Active', Locked = true;
    PeakEntryNo: Integer;
    ImportMessageLbl: Label 'Importing: #1###### \Errors: #2######', Locked = true;
    WindowDialog: Dialog;
    MeasurementCounter: Integer;
    Errors: Integer;
    ImportedMessageLbl: Label 'Imported: %1 \Errors:%2', Locked = true;
}
