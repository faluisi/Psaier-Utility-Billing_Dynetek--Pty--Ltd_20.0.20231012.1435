codeunit 50222 "AAT Additional Charge Imports"
{
    trigger OnRun()
    begin
    end;
    procedure TVFeeImport()
    var
        CSVBuffer: Record "CSV Buffer";
        AATAdditionalFeesSII: Record "AAT Additional Fees SII";
        FileName: Text;
        DateText: Text;
        DateVar: Date;
        CSVInStream: InStream;
        UploadStreamMsg: Label 'Choose a File to upload';
    begin
        CSVBuffer.DeleteAll();
        UploadIntoStream(UploadStreamMsg, '', '', FileName, CSVInStream);
        CSVBuffer.LoadDataFromStream(CSVInStream, ';');
        if CSVBuffer.FindSet()then // CSVBuffer.Next(10);
            CSVBuffer.Next(10);
        repeat if CSVBuffer."Field No." = 1 then Clear(AATAdditionalFeesSII);
            AATAdditionalFeesSII.Validate("AAT Fee Type SII", "AAT Additional Fee Type"::"TV Fee");
            case CSVBuffer."Field No." of 1: AATAdditionalFeesSII.Validate("AAT Fee Code SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT Fee Code SII")));
            2: AATAdditionalFeesSII.Validate("AAT POD No. SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT POD No. SII")));
            3: AATAdditionalFeesSII.Validate("AAT Fiscal Code SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT Fiscal Code SII")));
            4: begin
                CSVBuffer.Value:=ConvertStr(CSVBuffer.Value, '.', ',');
                Evaluate(AATAdditionalFeesSII."AAT Amount SII", CSVBuffer.Value);
                AATAdditionalFeesSII.Validate("AAT Amount SII");
            end;
            5: begin
                if StrLen(CSVBuffer.Value) = 6 then DateText:='01' + CSVBuffer.Value;
                if StrLen(CSVBuffer.Value) = 5 then DateText:='010' + CSVBuffer.Value;
                Evaluate(DateVar, DateText);
                AATAdditionalFeesSII.Validate("AAT Start Date SII", DateVar);
            end;
            6: begin
                if StrLen(CSVBuffer.Value) = 6 then DateText:='01' + CSVBuffer.Value;
                if StrLen(CSVBuffer.Value) = 5 then DateText:='010' + CSVBuffer.Value;
                Evaluate(DateVar, DateText);
                AATAdditionalFeesSII.Validate("AAT End Date SII", CalcDate('<CM>', DateVar));
            end;
            7: AATAdditionalFeesSII.Validate("AAT Amount Code SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT Amount Code SII")));
            8: AATAdditionalFeesSII.Validate("AAT ISTAT Code SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT ISTAT Code SII")));
            9: AATAdditionalFeesSII.Validate("AAT Rate SII", CopyStr(CSVBuffer.Value, 1, MaxStrLen(AATAdditionalFeesSII."AAT Rate SII")));
            10: begin
                Evaluate(AATAdditionalFeesSII."AAT Supply Start Date", CSVBuffer.Value);
                AATAdditionalFeesSII.Validate("AAT Supply Start Date");
            end;
            end;
            if CSVBuffer."Field No." = 10 then ModifyExistingFeeCheck(AATAdditionalFeesSII);
        until CSVBuffer.Next() = 0;
    end;
    procedure SocialBonusImport()
    var
        AATAdditionalFeesSII: Record "AAT Additional Fees SII";
        Filename: Text;
        SheetName: Text;
        InStream: InStream;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        RowNo: Integer;
        MaxRowNo: Integer;
    begin
        UploadIntoStream(UploadExcelMsg, '', '', Filename, InStream);
        if Filename <> '' then SheetName:=ExcelBuffer.SelectSheetsNameStream(InStream)
        else
            Error(NoFileFoundMsg);
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        ExcelBuffer.OpenBookStream(InStream, SheetName);
        ExcelBuffer.ReadSheet();
        RowNo:=0;
        MaxRowNo:=0;
        if ExcelBuffer.FindLast()then MaxRowNo:=ExcelBuffer."Row No.";
        for RowNo:=2 to MaxRowNo do begin
            Clear(AATAdditionalFeesSII);
            AATAdditionalFeesSII."AAT Fee Type SII":="AAT Additional Fee Type"::"Social Bonus";
            AATAdditionalFeesSII.Validate("AAT Fee Code SII", CopyStr(GetValueAtCell(RowNo, 1), 1, MaxStrLen(AATAdditionalFeesSII."AAT Fee Code SII")));
            AATAdditionalFeesSII.Validate("AAT Communication Type", CopyStr(GetValueAtCell(RowNo, 2), 1, MaxStrLen(AATAdditionalFeesSII."AAT Communication Type")));
            AATAdditionalFeesSII.Validate("AAT Reason Code SII", CopyStr(GetValueAtCell(RowNo, 3), 1, MaxStrLen(AATAdditionalFeesSII."AAT Reason Code SII")));
            AATAdditionalFeesSII.Validate("AAT POD No. SII", CopyStr(GetValueAtCell(RowNo, 4), 1, MaxStrLen(AATAdditionalFeesSII."AAT POD No. SII")));
            AATAdditionalFeesSII.Validate("AAT Fiscal Code SII", CopyStr(GetValueAtCell(RowNo, 5), 1, MaxStrLen(AATAdditionalFeesSII."AAT Fiscal Code SII")));
            AATAdditionalFeesSII.Validate("AAT Compensation Scheme", CopyStr(GetValueAtCell(RowNo, 6), 1, MaxStrLen(AATAdditionalFeesSII."AAT Compensation Scheme")));
            Evaluate(AATAdditionalFeesSII."AAT Valid Year SII", GetValueAtCell(RowNo, 7));
            AATAdditionalFeesSII.Validate("AAT Valid Year SII");
            Evaluate(AATAdditionalFeesSII."AAT Start Date SII", GetValueAtCell(RowNo, 8));
            AATAdditionalFeesSII.Validate("AAT Start Date SII");
            Evaluate(AATAdditionalFeesSII."AAT End Date SII", GetValueAtCell(RowNo, 9));
            AATAdditionalFeesSII.Validate("AAT End Date SII");
            Evaluate(AATAdditionalFeesSII."AAT Termination date", GetValueAtCell(RowNo, 10));
            AATAdditionalFeesSII.Validate("AAT Termination date");
            ModifyExistingFeeCheck(AATAdditionalFeesSII);
        end;
    end;
    procedure SocialBonusESITOImport()
    var
        AATAdditionalFeesSII: Record "AAT Additional Fees SII";
        Filename: Text;
        SheetName: Text;
        InStream: InStream;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        RowNo: Integer;
        MaxRowNo: Integer;
    begin
        UploadIntoStream(UploadExcelMsg, '', '', Filename, InStream);
        if Filename <> '' then SheetName:=ExcelBuffer.SelectSheetsNameStream(InStream)
        else
            Error(NoFileFoundMsg);
        ExcelBuffer.Reset();
        ExcelBuffer.DeleteAll();
        ExcelBuffer.OpenBookStream(InStream, SheetName);
        ExcelBuffer.ReadSheet();
        RowNo:=0;
        MaxRowNo:=0;
        if ExcelBuffer.FindLast()then MaxRowNo:=ExcelBuffer."Row No.";
        for RowNo:=2 to MaxRowNo do begin
            AATAdditionalFeesSII.SetRange("AAT Fee Code SII", GetValueAtCell(RowNo, 1));
            if AATAdditionalFeesSII.FindLast()then AATAdditionalFeesSII."AAT Outcome SII":=ConvertBoolean(GetValueAtCell(RowNo, 2));
            AATAdditionalFeesSII.Modify(true);
        end;
    end;
    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text begin
        ExcelBuffer.Reset();
        if ExcelBuffer.Get(RowNo, ColNo)then exit(ExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;
    local procedure ModifyExistingFeeCheck(AATAdditionalFeesSII: Record "AAT Additional Fees SII")
    var
        AATAdditionalFeesSII2: Record "AAT Additional Fees SII";
    begin
        AATAdditionalFeesSII2.SetRange("AAT Fee Code SII", AATAdditionalFeesSII."AAT Fee Code SII");
        AATAdditionalFeesSII2.SetRange("AAT Fee Type SII", AATAdditionalFeesSII."AAT Fee Type SII");
        if AATAdditionalFeesSII2.FindLast()then begin
            AATAdditionalFeesSII2.TransferFields(AATAdditionalFeesSII);
            AATAdditionalFeesSII2.Modify(true);
        end
        else
            AATAdditionalFeesSII.Insert(true);
    end;
    local procedure ConvertBoolean(Value: Text): Boolean;
    var
    begin
        exit(Value = 'SI');
    end;
    var ExcelBuffer: Record "Excel Buffer";
}
