codeunit 50223 "AAT Paid TV Export SII"
{
    procedure ExportIEAFile()
    var
        Contract: Record Contract;
        Customer: Record Customer;
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        AATAdditionalFeesSII: Record "AAT Additional Fees SII";
        UtilitySetup: Record "Utility Setup";
        TempBlob: Codeunit "Temp Blob";
        FileNameLbl: Label 'Test IEA Text Export.txt';
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        HeaderLine: Text;
        FooterLine: Text;
        DataLine: Text;
        StartDate: Date;
        EndDate: Date;
        Counter: Integer;
        DebitID: Text[14];
        POD: Text[20];
        InVoiceNo: Text[12];
        MonthDateText: Text[6];
        CompanyVatNo: Text[11];
        LineNo: Text[8];
        LineNoCounter: Integer;
        TVFeeAmountText: Text[8];
    begin
        CompanyInformation.GetRecordOnce();
        UtilitySetup.Get();
        FileName:=FileNameLbl;
        TempBlob.CreateOutStream(OutStream);
        MonthDateText:=Format(Today, 0, '<Month,2><Year4>');
        CompanyVatNo:=CopyStr(PadText(CompanyInformation."VAT Registration No.", 11, DataType::Num), 1, MaxStrLen(CompanyVatNo));
        HeaderLine:='A              ' + UtilitySetup."No. Series for Television Fees" + '        ' + '00000000' + '                 ' + CompanyVatNo + '     ' + MonthDateText + ' 1' + '                              A';
        OutStream.WriteText(HeaderLine);
        OutStream.WriteText();
        Counter:=0;
        SalesInvLine.Reset();
        SalesInvLine.SetRange("No.", UtilitySetup."Television Fees Code");
        if SalesInvLine.FindSet()then repeat SalesInvHeader.get(SalesInvLine."Document No.");
                if Contract.Get(SalesInvHeader."Contract No.")then begin
                    Customer.SetLoadFields("Fiscal Code");
                    Customer.Get(Contract."Customer No.");
                    POD:=CopyStr(Contract."POD No.", 1, MaxStrLen(POD));
                    if FindTVFee(AATAdditionalFeesSII, SalesInvLine, Customer, POD, StartDate, EndDate)then begin
                        Counter+=1;
                        DebitID:=CopyStr(PadText(CopyStr(AATAdditionalFeesSII."AAT Fee Code SII", 1, MaxStrLen(DebitID)), 14, DataType::Text), 1, MaxStrLen(DebitID));
                        LineNoCounter+=1;
                        LineNo:=CopyStr(PadText(Format(LineNoCounter), 8, DataType::Num), 1, MaxStrLen(LineNo));
                        POD:=CopyStr(PadText(POD, 19, DataType::Text), 1, MaxStrLen(POD));
                        InVoiceNo:=CopyStr(PadText(CopyStr(SalesInvLine."Document No.", 1, MaxStrLen(InVoiceNo)), 12, DataType::Text), 1, MaxStrLen(InVoiceNo));
                        TVFeeAmountText:=CopyStr(DelChr((Format(SalesInvLine."Line Amount", 0, '<Integer><Decimals>')), '=', ','), 1, MaxStrLen(TVFeeAmountText));
                        TVFeeAmountText:=CopyStr(PadText(TVFeeAmountText, 8, DataType::Text), 1, MaxStrLen(TVFeeAmountText));
                        DataLine:='1' + LineNo + DebitID + CompanyVatNo + POD + ' ' + InVoiceNo + '        ' + Format(StartDate, 0, '<Closing><Day, 2 ><Month, 2 ><Year4>') + Format(EndDate, 0, '<Closing><Day, 2 ><Month, 2 ><Year4>') + TVFeeAmountText + '                   A';
                        OutStream.WriteText(DataLine);
                        OutStream.WriteText();
                    end;
                end;
            until SalesInvLine.Next() = 0;
        FooterLine:='Z              ' + UtilitySetup."No. Series for Television Fees" + '        ' + '99999990' + '                 ' + CompanyVatNo + '     ' + MonthDateText + ' 1' + '       ' + Format(Counter) + '                    A';
        OutStream.WriteText(FooterLine);
        OutStream.WriteText();
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, '', '', '', FileName);
    end;
    procedure ExportIEBFile()
    var
        Contract: Record Contract;
        Customer: Record Customer;
        UtilitySetup: Record "Utility Setup";
        SalesInvLine: Record "Sales Invoice Line";
        SalesInvHeader: Record "Sales Invoice Header";
        AATAdditionalFeesSII: Record "AAT Additional Fees SII";
        TempBlob: Codeunit "Temp Blob";
        FileNameLbl: Label 'Test IEB Text Export.txt';
        InStream: InStream;
        OutStream: OutStream;
        FileName: Text;
        HeaderLine: Text;
        FooterLine: Text;
        DataLine: Text;
        StartDate: Date;
        EndDate: Date;
        POD: Text[19];
        InVoiceNo: Text[12];
        MonthDateText: Text[6];
        LineNoCounter: Integer;
        LineNo: Text[8];
        CompanyVatNo: Text[11];
        Counter: Integer;
        TVFeeAmountText: Text[8];
    begin
        CompanyInformation.GetRecordOnce();
        FileName:=FileNameLbl;
        TempBlob.CreateOutStream(OutStream);
        UtilitySetup.Get();
        Counter:=0;
        CompanyVatNo:=CopyStr(PadText(CompanyInformation."VAT Registration No.", 11, DataType::Num), 1, MaxStrLen(CompanyVatNo));
        MonthDateText:=Format(Today, 0, '<Month,2><Year4>');
        HeaderLine:='This will be the header:';
        OutStream.WriteText(HeaderLine);
        OutStream.WriteText();
        HeaderLine:='A              ' + UtilitySetup."No. Series for Television Fees" + '        ' + '00000000' + '                 ' + CompanyVatNo + '     ' + MonthDateText + ' 1' + '                              A';
        OutStream.WriteText(HeaderLine);
        OutStream.WriteText();
        SalesInvLine.Reset();
        SalesInvLine.SetRange("No.", UtilitySetup."Television Fees Code");
        if SalesInvLine.FindSet()then repeat SalesInvHeader.get(SalesInvLine."Document No.");
                if Contract.Get(SalesInvHeader."Contract No.")then begin
                    Customer.SetLoadFields("Fiscal Code");
                    Customer.Get(Contract."Customer No.");
                    POD:=CopyStr(Contract."POD No.", 1, MaxStrLen(POD));
                    if FindTVFee(AATAdditionalFeesSII, SalesInvLine, Customer, POD, StartDate, EndDate)then begin
                        Counter+=1;
                        LineNoCounter+=1;
                        LineNo:=CopyStr(PadText(Format(LineNoCounter), 8, DataType::Num), 1, MaxStrLen(LineNo));
                        POD:=CopyStr(PadText(POD, 19, DataType::Text), 1, MaxStrLen(POD));
                        InVoiceNo:=CopyStr(PadText(SalesInvLine."Document No.", 12, DataType::Text), 1, MaxStrLen(InVoiceNo));
                        TVFeeAmountText:=CopyStr(DelChr((Format(SalesInvLine."Line Amount", 0, '<Integer><Decimals>')), '=', ','), 1, MaxStrLen(TVFeeAmountText));
                        TVFeeAmountText:=CopyStr(PadText(TVFeeAmountText, 8, DataType::Text), 1, MaxStrLen(TVFeeAmountText));
                        DataLine:='2' + LineNo + CompanyVatNo + POD + ' ' + InVoiceNo + '        ' + Format(StartDate, 0, '<Closing><Day, 2 ><Month, 2 ><Year4>') + Format(EndDate, 0, '<Closing><Day, 2 ><Month, 2 ><Year4>') + TVFeeAmountText + Format(EndDate, 0, '<Closing><Day, 2 ><Month, 2 ><Year4>') + ' ' + MonthDateText + '                  A';
                        OutStream.WriteText(DataLine);
                        OutStream.WriteText();
                    end;
                end;
            until SalesInvLine.Next() = 0;
        FooterLine:='Z              ' + UtilitySetup."No. Series for Television Fees" + '        ' + '99999990' + '                 ' + CompanyVatNo + '     ' + MonthDateText + ' 1' + '       ' + Format(Counter) + '                    A';
        OutStream.WriteText(FooterLine);
        OutStream.WriteText();
        TempBlob.CreateInStream(InStream);
        DownloadFromStream(InStream, '', '', '', FileName);
    end;
    local procedure FindTVFee(var AATAdditionalFeesSII: Record "AAT Additional Fees SII"; SalesInvLine: Record "Sales Invoice Line"; Customer: Record Customer; POD: Text[20]; var StartDate: Date; var EndDate: Date): Boolean begin
        AATAdditionalFeesSII.SetRange("AAT POD No. SII", POD);
        AATAdditionalFeesSII.SetRange("AAT Fee Type SII", AATAdditionalFeesSII."AAT Fee Type SII"::"TV Fee");
        AATAdditionalFeesSII.SetRange("AAT Fiscal Code SII", Customer."Fiscal Code");
        StartDate:=SalesInvLine."Effective Start Date";
        EndDate:=SalesInvLine."Effective End Date";
        AATAdditionalFeesSII.SetFilter("AAT Start Date SII", '>=%1', StartDate);
        AATAdditionalFeesSII.SetFilter("AAT End Date SII", '<=%1', EndDate);
        if AATAdditionalFeesSII.FindFirst()then exit(true)
        else
            exit(false);
    end;
    local procedure PadText(TextValue: Text; Length: Integer; DataType2: Option): Text begin
        if DataType2 = DataType::Text then if StrLen(TextValue) < Length then repeat TextValue:=CopyStr(' ' + TextValue, 1, Length);
                until StrLen(TextValue) = Length;
        if DataType2 = DataType::Num then if StrLen(TextValue) < Length then repeat TextValue:=CopyStr('0' + TextValue, 1, Length);
                until StrLen(TextValue) = Length;
        exit(TextValue);
    end;
    var CompanyInformation: Record "Company Information";
    DataType: Option Text, Num;
}
