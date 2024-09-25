codeunit 70002 ImportFileSelectDeactivation
{
    //KB09112023 - TASK002126 Deactivation Process +++
    procedure UploadFile()
    var
        IStream: InStream;
        FileName: text;
        Text001Lbl: Label 'Do you want to upload the xml file?';
    begin
        if UploadIntoStream(Text001Lbl, '', '', FileName, IStream)then ChooseFileForImport(IStream, FileName)
        else
            exit;
    end;
    procedure ChooseFileForImport(IStream: InStream; FileName: text)
    var
        ImportExportManagerDeactivate: Codeunit ImportExportManagerDeactivate;
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
            case FileType of Format("AAT File Type SII"::"D01.E100"): ImportExportManagerDeactivate.ImportD010100File(RootNode, FileName);
            Format("AAT File Type SII"::"D01.E150"): ImportExportManagerDeactivate.ImportD010150File(RootNode, FileName);
            end;
        end;
    end;
//KB09112023 - TASK002126 Deactivation Process ---
}
