codeunit 60104 "Anagraphic Data Management"
{
    procedure ChangeofAnagraphicDataAE10100(var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    var
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        CompanyInformation: Record "Company Information";
        Contract_LRec: Record Contract;
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        CSVImportManager: Codeunit "CSV Import Manager";
        ChangeofAnagraphicDataMgt: Codeunit "Change of Anagraphic Data Mgt.";
        Error: Boolean;
        CUASALCode: Code[5];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUsersLbl: Label 'There is no CP User that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        LogEntryNotExistErrorLbl: Label 'There is no Sii Log Entry corresponds with Pod No. %1 and CP User %2.', Locked = true;
        SIILogErrors: Text;
        ExplanatoryStatement: Text;
        FieldCount: Integer;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        FieldCount:=11;
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
        if SIILogEntries.FindFirst()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> GetText(RowNo, 3, CSVBuffer)then begin
                            ExplanatoryStatement+=StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer));
                            Error:=true;
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
                    if SIILogEntries.IsEmpty and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(CPUsersLbl, GetText(RowNo, 5, CSVBuffer));
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                end;
                7: begin
                    SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        Error:=true;
                        ExplanatoryStatement+=StrSubstNo(PODErrorLbl, GetText(RowNo, 7, CSVBuffer));
                    end
                    else
                        PODNo:=CopyStr(GetText(RowNo, 3, CSVBuffer), 1, MaxStrLen(PODNo));
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ExplanatoryStatement+=StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer));
                        Error:=true;
                    end;
                //KB140224 - VAT Manager Setup added ---    
                end;
                8: if GetText(RowNo, 8, CSVBuffer) = '0' then Error:=true
                    else
                        Error:=false;
                9: CUASALCode:=CopyStr(GetText(RowNo, 9, CSVBuffer), 1, MaxStrLen(CUASALCode));
                10: ExplanatoryStatement+=GetText(RowNo, 10, CSVBuffer);
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIILogErrors:=SIILogEntries."CP User" + '|';
                    if StrLen(SIILogErrors) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIILogErrors, 1, StrLen(SIILogErrors) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::"AE1.0100")then ChangeofAnagraphicDataMgt.ChangeOfAnagraphicDataErrorCheck(Error, SIILogEntries, CUASALCode, CopyStr(ExplanatoryStatement, 1, 150), CSVBuffer, FileName, SIILogEntriesErrored);
                end;
                CSVBuffer."Field No."+=1;
            until CSVBuffer."Field No." = FieldCount;
        end
        else
            Error(LogEntryNotExistErrorLbl, GetText(RowNo, 7, CSVBuffer), GetText(RowNo, 6, CSVBuffer))end;
    procedure ChangeofAnagraphicDataAE10150(var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    var
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        VATManagerSetup: Record "VAT Manager Setup";
        Contract_LRec: Record Contract;
        CompanyInformation: Record "Company Information";
        UtilitySetup: Record "Utility Setup";
        CSVImportManager: Codeunit "CSV Import Manager";
        ChangeofAnagraphicDataMgt: Codeunit "Change of Anagraphic Data Mgt.";
        Error: Boolean;
        ResultCode: Code[10];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no CP User No that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        SIILogErrors: Text;
        ResultDetail: Text;
        FieldCount: Integer;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        FieldCount:=11;
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
        if SIILogEntries.FindFirst()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> GetText(RowNo, 3, CSVBuffer)then begin
                            ResultDetail+=StrSubstNo(CompanyVATNoLbl, GetText(RowNo, 3, CSVBuffer));
                            Error:=true;
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
                    if SIILogEntries.IsEmpty and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(CPUserErrorLbl, GetText(RowNo, 5, CSVBuffer));
                        Error:=true;
                        Error(ResultDetail);
                    end;
                end;
                7: begin
                    SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(PODErrorLbl, GetText(RowNo, 7, CSVBuffer));
                        Error:=true;
                    end
                    else
                        PODNo:=CopyStr(GetText(RowNo, 7, CSVBuffer), 1, MaxStrLen(PODNo));
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ResultDetail+=StrSubstNo(ManagerVATNoErrorLbl, GetText(RowNo, 4, CSVBuffer));
                        Error:=true;
                    end;
                //KB140224 - VAT Manager Setup added --- 
                end;
                8: if GetText(RowNo, 8, CSVBuffer) = '0' then Error:=true
                    else
                        Error:=false;
                9: ResultCode:=CopyStr(GetText(RowNo, 9, CSVBuffer), 1, MaxStrLen(ResultCode));
                10: ResultDetail+=GetText(RowNo, 10, CSVBuffer);
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIILogErrors:=SIILogEntries."CP User" + '|';
                    if StrLen(SIILogErrors) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIILogErrors, 1, StrLen(SIILogErrors) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not CSVImportManager.HasExistingFile(SIILogEntries, "AAT File Type SII"::"AE1.0150")then ChangeofAnagraphicDataMgt.CompleteChangeOfAnagraphicData(Error, SIILogEntries, ResultCode, CopyStr(ResultDetail, 1, 150), CSVBuffer, Filename, SIILogEntriesErrored);
                end;
                CSVBuffer."Field No."+=1;
            until CSVBuffer."Field No." = FieldCount;
        end end;
    procedure ChangeofAnagraphicDataAE20200(var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    Var
        SIILogEntries: Record "SII Log Entries";
        Contract_LRec: Record Contract;
        FieldCount: Integer;
    begin
        FieldCount:=47;
        SIILogEntries.Reset();
        SIILogEntries.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntries.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
        if SIILogEntries.FindFirst()then begin
            Contract_LRec.Reset();
            Contract_LRec.SetRange("No.", SIILogEntries."Contract No.");
            Contract_LRec.SetRange("POD No.", GetText(RowNo, 7, CSVBuffer));
            Contract_LRec.SetRange(Status, Contract_LRec.Status::"In Registration");
            if Contract_LRec.FindFirst()then;
        end end;
    local procedure GetText(LineNo: Integer; FieldNo: Integer; CSVBufferVar: Record "CSV Buffer"): Text Var
        Value: Text;
    begin
        CSVBufferVar.Reset();
        if CSVBufferVar.Get(LineNo, FieldNo)then if Evaluate(value, CSVBufferVar.Value)then exit(Value)end;
}
