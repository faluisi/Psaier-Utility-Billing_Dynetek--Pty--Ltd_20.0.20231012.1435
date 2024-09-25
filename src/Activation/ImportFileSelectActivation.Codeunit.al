codeunit 70102 ImportFileSelectActivation
{
    procedure UploadFile()
    var
        IStream: InStream;
        FileName: text;
        Text001Lbl: Label 'Do you want to upload the xml file?', Comment = 'Do you want to upload the xml file?';
    begin
        if UploadIntoStream(Text001Lbl, '', '', FileName, IStream)then ChooseFileForImport(IStream, FileName)
        else
            exit;
    end;
    procedure ChooseFileForImport(IStream: InStream; FileName: text)
    var
        ImportExportManagerActivate: Codeunit ImportExportManagerActivate;
        XmlDoc: XmlDocument;
        RootNode: XmlElement;
        Attribute: XmlAttribute;
        AttributeList: XmlAttributeCollection;
        FileType: Text[10];
        FlowCode: Text[10];
        ServiceCode: Text[10];
    begin
        XmlDocument.ReadFrom(IStream, xmlDoc);
        if xmlDoc.GetRoot(RootNode)then begin
            AttributeList:=RootNode.Attributes();
            foreach Attribute in AttributeList do begin
                case Attribute.Name of 'cod_servizio': ServiceCode:=CopyStr(Attribute.Value, 1, MaxStrLen(ServiceCode));
                'cod_flusso': begin
                    FlowCode:=CopyStr(Attribute.Value, 1, MaxStrLen(FlowCode));
                    if StrLen(FlowCode) < 4 then repeat FlowCode:=CopyStr('0' + FlowCode, 1, MaxStrLen(FlowCode));
                        until StrLen(FlowCode) = 4;
                end;
                end;
            end;
            FileType:=CopyStr(ServiceCode + '.' + FlowCode, 1, MaxStrLen(FileType));
            case FileType of Format("AAT File Type SII"::"PN1.0100"): ImportExportManagerActivate.ImportPN10100File(RootNode, FileName);
            Format("AAT File Type SII"::"PN1.0150"): ImportExportManagerActivate.ImportPN10150File(RootNode, FileName);
            Format("AAT File Type SII"::"E01.0100"): ImportExportManagerActivate.ImportE010100File(RootNode, FileName);
            Format("AAT File Type SII"::"E01.0150"): ImportExportManagerActivate.ImportE010150File(RootNode, FileName);
            //KB24112023 - TASK002131 New Activation Process +++ //KB24112023 - TASK002167 Reactivation Process +++
            Format("AAT File Type SII"::"A01.0100"): ImportExportManagerActivate.ImportA010100File(RootNode, FileName);
            Format("AAT File Type SII"::"A01.0150"): ImportExportManagerActivate.ImportA010150File(RootNode, FileName);
            Format("AAT File Type SII"::"A01.0300"): ImportExportManagerActivate.ImportA010300File(RootNode, FileName);
            //KB24112023 - TASK002131 New Activation Process --- //KB24112023 - TASK002167 Reactivation Process ---
            end;
        end;
    end;
}
