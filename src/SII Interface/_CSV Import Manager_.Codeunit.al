codeunit 50203 "CSV Import Manager"
{
    //To import: SE1.0100, SE1.0200, SE3.0200, VT1.0100, VT1.0150, VT1.0101, RC1.0100, AE1.0100, AE1.0150
    /// <summary>
    /// Main CSV File Import manager.
    /// </summary>
    procedure CSVFileManager()
    var
        CSVBuffer: Record "CSV Buffer";
        SwitchOutFile: Codeunit "Switch Out File Import";
        ImportFileSelectDeactivation: Codeunit ImportFileSelectDeactivation;
        FileMgmt: Codeunit "File Management";
        ImportFileSelectActivation: Codeunit ImportFileSelectActivation;
        ChangeOfCustomer: Codeunit "Change of Customer Method Mgmt";
        AnagraphicDataManagement: Codeunit "Anagraphic Data Management";
        CSVInstream: InStream;
        UploadStreamMsg: Label 'Choose a File to upload';
        FileName: Text;
        FileExtension: Text;
        FileType: Text[10];
        FlowCode: Text[15];
        ServiceCode: Text[15];
        RowNo: Integer;
    begin
        CSVBuffer.DeleteAll();
        UploadIntoStream(UploadStreamMsg, '', '', FileName, CSVInstream);
        //KB09112023 - TASK002126 Deactivation Process +++
        FileExtension:=FileMgmt.GetExtension(FileName);
        if FileExtension = 'xml' then begin
            //KB20112023 - TASK002131 New Activation Process +++
            ImportFileSelectActivation.ChooseFileForImport(CSVInstream, FileName);
            //KB20112023 - TASK002131 New Activation Process ---
            ImportFileSelectDeactivation.ChooseFileForImport(CSVInstream, FileName);
        //KB09112023 - TASK002126 Deactivation Process ---
        end
        else
        begin
            CSVBuffer.LoadDataFromStream(CSVInstream, ';');
            // AN - TASK002127  Added action for import multiple data in Switch Out ++ 
            RowNo:=0;
            for RowNo:=2 to CSVBuffer.GetNumberOfLines()do begin
                CSVBuffer.Reset();
                if CSVBuffer.Get(RowNo, 1)then ServiceCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ServiceCode));
                CSVBuffer.Reset();
                if CSVBuffer.Get(RowNo, 2)then begin
                    FlowCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(FlowCode));
                    if StrLen(FlowCode) < 4 then repeat FlowCode:=CopyStr('0' + FlowCode, 1, MaxStrLen(FlowCode));
                        until StrLen(FlowCode) = 4;
                    FileType:=CopyStr(ServiceCode + '.' + FlowCode, 1, MaxStrLen(FileType));
                    case FileType of Format("AAT File Type SII"::"SE3.0200"): SwitchOutFile.ImportSwitchOutSE03200(CSVBuffer, FileName, RowNo);
                    // AN 12122023 TASK002199  Import File for Change of Customer +++ 
                    Format("AAT File Type SII"::"VT1.0100"): ChangeOfCustomer.ChangeOFCustomerVT10100(CSVBuffer, FileName, RowNo);
                    Format("AAT File Type SII"::"VT1.0150"): ChangeOfCustomer.ChangeofCustomerVT10150(CSVBuffer, FileName, RowNo);
                    format("AAT File Type SII"::"VT3.0200"): ChangeOfCustomer.ChangeOFCustomerVT30200(CSVBuffer, FileName, RowNo);
                    // AN 12122023 TASK002199  Import File for Change of Customer ---
                    //AN 14122023 TASK002230  Import Anagraphic Data +++
                    Format("AAT File Type SII"::"AE1.0100"): AnagraphicDataManagement.ChangeofAnagraphicDataAE10100(CSVBuffer, FileName, RowNo);
                    Format("AAT File Type SII"::"AE1.0150"): AnagraphicDataManagement.ChangeofAnagraphicDataAE10150(CSVBuffer, FileName, RowNo);
                    //AN 14122023 TASK002230  Import Anagraphic Data ---
                    end end;
            end;
            // AN - TASK002127  Added action for import multiple data in Switch Out --
            if CSVBuffer.FindSet()then repeat case CSVBuffer."Line No." of 2: case CSVBuffer."Field No." of 1: ServiceCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ServiceCode));
                        2: begin
                            FlowCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(FlowCode));
                            if StrLen(FlowCode) < 4 then repeat FlowCode:=CopyStr('0' + FlowCode, 1, MaxStrLen(FlowCode));
                                until StrLen(FlowCode) = 4;
                            FileType:=CopyStr(ServiceCode + '.' + FlowCode, 1, MaxStrLen(FileType));
                            case FileType of /*'SE1.0100'*/
                            Format("AAT File Type SII"::"SE1.0100"): SwitchInSE10100(CSVBuffer, FileName);
                            /*'SE1.0200'*/
                            Format("AAT File Type SII"::"SE1.0200"): SwitchInSE10200(CSVBuffer, FileName);
                            /*'SE4.0200'*/
                            Format("AAT File Type SII"::"SE4.0200"): SwitchInSE40200(CSVBuffer, FileName);
                            Format("AAT File Type SII"::"VT1.0101"): ChangeofCustomerVT10101(CSVBuffer, FileName);
                            /*'RC1.0100'*/
                            Format("AAT File Type SII"::"RC1.0100"): ContractTerminationRC10100(CSVBuffer, FileName);
                            end;
                        end;
                        end;
                    end;
                until CSVBuffer.Next() = 0;
        end;
    end;
    local procedure ChangeofCustomerVT10101(var CSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        ChangeofCustomerMgt: Codeunit "Change of Customer Management";
        Error: Boolean;
        CHECKAMM: Code[5];
        CUASALCode: Code[5];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no CP User that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        SIIEntryFilterString: Text;
        ExplanatoryStatement: Text[150];
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ExplanatoryStatement+=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error:=true;
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", CSVBuffer.Value);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(CPUserErrorLbl, CSVBuffer.Value);
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(PODErrorLbl, CSVBuffer.Value);
                        Error:=true;
                    end;
                    if PODNo = '' then begin
                        Error:=true;
                        ExplanatoryStatement:='POD No Empty';
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ExplanatoryStatement+=StrSubstNo(ManagerVATNoErrorLbl, CSVBuffer.Value);
                        Error:=true;
                    end;
                //KB140224 - VAT Manager Setup added --- 
                end;
                8: begin
                    CHECKAMM:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CHECKAMM));
                    if CSVBuffer.Value = '0' then Error:=true
                    else
                        Error:=false;
                    if CHECKAMM = '' then begin
                        Error:=true;
                        ExplanatoryStatement:='Check AMM is blank';
                    end end;
                9: CUASALCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CUASALCode));
                10: ExplanatoryStatement+=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ExplanatoryStatement));
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIIEntryFilterString+=SIILogEntries."CP User" + '|';
                    if StrLen(SIIEntryFilterString) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIIEntryFilterString, 1, StrLen(SIIEntryFilterString) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"VT1.0101")then ChangeofCustomerMgt.CancelChangeofCustomerErrorCheck(Error, SIILogEntries, CUASALCode, ExplanatoryStatement, CSVBuffer, SIILogEntriesErrored, FileName);
                end;
            until CSVBuffer.Next() = 0;
        end;
    end;
    local procedure ChangeofCustomerVT10150(var CSVBuffer: Record "CSV Buffer"; Filename: Text)
    var
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        Contract: Record Contract;
        Customer: Record Customer;
        SIILogEntries: Record "SII Log Entries";
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
        ResultDetail: Text[150];
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ResultDetail+=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error:=true;
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", CSVBuffer.Value); //CP User
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(CPUserErrorLbl, CSVBuffer.Value);
                        Error:=true;
                        Error(ResultDetail);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ResultDetail+=StrSubstNo(PODErrorLbl, PODNo);
                        Error:=true;
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ResultDetail+=StrSubstNo(ManagerVATNoErrorLbl, CSVBuffer.Value);
                        Error:=true;
                    end;
                //KB140224 - VAT Manager Setup added --- 
                end;
                8: if CSVBuffer.Value = '0' then Error:=true
                    else
                        Error:=false;
                9: ResultCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ResultCode)); //Result Code
                10: ResultDetail:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ResultDetail)); //Result Detail
                11: begin //CF
                    Contract.SetRange("POD No.", PODNo);
                    Contract.SetRange("No.", SIILogEntries."Contract No.");
                    if not Contract.IsEmpty() and Contract.FindFirst()then if Customer.Get(Contract."Customer No.")then if Customer."Fiscal Code" <> CSVBuffer.Value then begin
                                ResultDetail+=StrSubstNo(CustomerFiscalLbl, CSVBuffer.Value, Customer.Name);
                                Error:=true;
                                ErrorString:=StrSubstNo(CustomerFiscalLbl, CSVBuffer.Value, Customer.Name);
                                Error(ErrorString);
                            end;
                end;
                end;
                if CSVBuffer."Field No." = 17 then if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"VT1.0150")then ChangeofCustomerMgt.CompleteChangeofCustomerProcess(SIILogEntries, ResultCode, ResultDetail, Filename, Error);
            until CSVBuffer.Next() = 0;
        end;
    end;
    local procedure ContractTerminationRC10100(var CSVBuffer: Record "CSV Buffer"; Filename: Text)
    var
        UtilitySetup: Record "Utility Setup";
        VATManagerSetup: Record "VAT Manager Setup";
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        ContractTerminationMgt: Codeunit "Contract Termination Mgt.";
        Error: Boolean;
        CHECKAMM: Code[5];
        CUASALCode: Code[5];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        SIIEntryFilterString: Text;
        ExplanatoryStatement: Text[150];
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ExplanatoryStatement+=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error:=true;
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", CSVBuffer.Value);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(CPUserErrorLbl, CSVBuffer.Value);
                        Error:=true;
                        Error(ExplanatoryStatement);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ExplanatoryStatement+=StrSubstNo(PODErrorLbl, CSVBuffer.Value);
                        Error:=true;
                    end;
                    if PODNo = '' then begin
                        Error:=true;
                        ExplanatoryStatement:='POD No Empty';
                    end;
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ExplanatoryStatement+=StrSubstNo(ManagerVATNoErrorLbl, CSVBuffer.Value);
                        Error:=true;
                    end;
                //KB140224 - VAT Manager Setup added ---   
                end;
                8: begin
                    CHECKAMM:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CHECKAMM));
                    if CSVBuffer.Value = '0' then Error:=true
                    else
                        Error:=false;
                    if CHECKAMM = '' then begin
                        Error:=true;
                        ExplanatoryStatement:='Check AMM is blank';
                    end end;
                9: CUASALCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CUASALCode));
                10: ExplanatoryStatement:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(ExplanatoryStatement));
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIIEntryFilterString+=SIILogEntries."CP User" + '|';
                    if StrLen(SIIEntryFilterString) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIIEntryFilterString, 1, StrLen(SIIEntryFilterString) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"RC1.0100")then ContractTerminationMgt.CompleteContractTermination(Error, SIILogEntries, CUASALCode, ExplanatoryStatement, CSVBuffer, Filename, SIILogEntriesErrored);
                end;
            until CSVBuffer.Next() = 0 end;
    end;
    local procedure SwitchInSE10100(var CSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        SIILogEntries: Record "SII Log Entries";
        SIILogEntriesErrored: Record "SII Log Entries";
        SwitchInManagement: Codeunit "Switch In Management";
        Error: Boolean;
        CHECKAMM: Code[5];
        CUASALCode: Code[5];
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no SII Log Entry with CP User number: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        PODEmptyErrorLbl: Label 'POD No is empty';
        CheckAMMErrorLbl: Label 'CHECKADM field was empty';
        ErrorString: Text;
        ExplanatoryStatement: Text;
        SIIEntryFilterString: Text;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        SIILogEntries.SetRange(Type, "Process Type"::"Switch In");
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat ExplanatoryStatement:='';
                case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ErrorString+=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error(ErrorString);
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", CSVBuffer.Value);
                    if not SIILogEntries.FindFirst()then begin
                        ErrorString:=StrSubstNo(CPUserErrorLbl, CSVBuffer.Value);
                        Error(ErrorString);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ErrorString:=StrSubstNo(PODErrorLbl, PODNo);
                        Error(ErrorString);
                    end;
                    if PODNo = '' then Error(PODEmptyErrorLbl);
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ErrorString+=StrSubstNo(ManagerVATNoErrorLbl, VATManagerNoCheck);
                        Error(ErrorString);
                    end;
                //KB140224 - VAT Manager Setup added ---
                end;
                8: begin
                    CHECKAMM:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CHECKAMM));
                    if not Error then if CSVBuffer.Value = '0' then Error:=true
                        else
                            Error:=false;
                    if CHECKAMM = '' then Error(CheckAMMErrorLbl);
                end;
                9: CUASALCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CUASALCode));
                10: ExplanatoryStatement+=CSVBuffer.Value;
                end;
                if CSVBuffer."Field No." = 10 then begin
                    if Error then SIIEntryFilterString+=SIILogEntries."CP User" + '|';
                    if StrLen(SIIEntryFilterString) > 0 then begin
                        SIILogEntriesErrored.SetFilter("CP User", CopyStr(SIIEntryFilterString, 1, StrLen(SIIEntryFilterString) - 1));
                        if SIILogEntriesErrored.FindSet()then;
                    end;
                    if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"SE1.0100")then SwitchInManagement.SwitchInErrorCheck(Error, SIILogEntries, CUASALCode, ExplanatoryStatement, CSVBuffer, FileName, SIILogEntriesErrored);
                end;
            until CSVBuffer.Next() = 0;
        end;
    end;
    local procedure SwitchInSE10200(var CSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        Contract: Record Contract;
        PointofDelivery: Record "Point of Delivery";
        SIILogEntries: Record "SII Log Entries";
        SwitchInManagement: Codeunit "Switch In Management";
        PODNo: Code[25];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CPUserErrorLbl: Label 'There is no valid SII Log Entry with CP User number: %1 with a "%2" status', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1 |', Locked = true;
        PODNoEmptyErrorLbl: Label 'POD No is empty';
        ErrorString: Text;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ErrorString:=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error(ErrorString);
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                5: begin
                    SIILogEntries.SetRange("CP User", CSVBuffer.Value);
                    SIILogEntries.SetRange(Status, "AAT Log Status SII"::"Imported File SE1.0100");
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ErrorString:=StrSubstNo(CPUserErrorLbl, CSVBuffer.Value, Format("AAT Log Status SII"::"Imported File SE1.0100"));
                        Error(ErrorString);
                    end;
                end;
                7: begin
                    PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    if not PointofDelivery.Get(PODNo)then begin
                        ErrorString:=StrSubstNo(PODErrorLbl, PODNo);
                        Error(ErrorString);
                    end;
                    SIILogEntries.SetRange("POD No.", PODNo);
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindFirst()then begin
                        ErrorString+=StrSubstNo(PODErrorLbl, CSVBuffer.Value);
                        Error(ErrorString);
                    end;
                    if PODNo = '' then Error(PODNoEmptyErrorLbl);
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ErrorString+=StrSubstNo(ManagerVATNoErrorLbl, VATManagerNoCheck);
                        Error(ErrorString);
                    end;
                //KB140224 - VAT Manager Setup added ---
                end;
                12: //KB12122023 - TASK002199 Switch In Field +++
                    if Contract.Get(SIILogEntries."Contract No.")then begin
                        Evaluate(Contract."Switch In Date", CSVBuffer.Value);
                        Contract.Modify();
                    end;
                //KB12122023 - TASK002199 Switch In Field ---
                end;
                if CSVBuffer."Field No." = 15 then if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"SE1.0200")then SwitchInManagement.AdditionalFileImport(SIILogEntries, CSVBuffer, FileName);
            until CSVBuffer.Next() = 0;
        end;
    end;
    local procedure SwitchInSE40200(var CSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        VATManagerSetup: Record "VAT Manager Setup";
        UtilitySetup: Record "Utility Setup";
        Contract: Record Contract;
        Customer: Record Customer;
        SIILogEntries: Record "SII Log Entries";
        SwitchInManagement: Codeunit "Switch In Management";
        PODNo: Code[25];
        CustomerFiscalCode: Code[30];
        CompanyVATNoLbl: Label 'There is no VAT No that corresponds with: %1', Locked = true;
        CustomerFiscalLbl: Label 'The Fiscal Code: %1 \\Is not associated with Customer: %2', Locked = true;
        CustomerVATLbl: Label 'The VAT No.: %1 Is not associated with Customer: %2', Locked = true;
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        PODErrorLbl: Label 'There is no POD No that corresponds with: %1', Locked = true;
        ErrorString: Text;
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
    begin
        if CSVBuffer.FindSet()then begin
            CSVBuffer."Line No.":=2;
            repeat case CSVBuffer."Field No." of 3: if CompanyInformation.Get()then if CompanyInformation."VAT Registration No." <> CSVBuffer.Value then begin
                            ErrorString:=StrSubstNo(CompanyVATNoLbl, CSVBuffer.Value);
                            Error(ErrorString);
                        end;
                4: VATManagerNo:=CSVBuffer.Value; //KB140224 - VAT Manager Setup added
                6: begin
                    SIILogEntries.SetRange("POD No.", CSVBuffer.Value);
                    SIILogEntries.SetRange(Type, "Process Type"::"Switch In");
                    SIILogEntries.SetFilter(Status, '%1|%2', "AAT Log Status SII"::"Imported File SE1.0100", "AAT Log Status SII"::"Imported Additional File SE1.0200");
                    if SIILogEntries.IsEmpty() and not SIILogEntries.FindLast()then begin
                        ErrorString:=StrSubstNo(PODErrorLbl, CSVBuffer.Value);
                        Error(ErrorString);
                    end
                    else
                        PODNo:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(PODNo));
                    //KB140224 - VAT Manager Setup added +++
                    UtilitySetup.Get();
                    if VATManagerSetup.Get(CopyStr(PODNo, 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
                    else
                        VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
                    if VATManagerNoCheck <> VATManagerNo then begin
                        ErrorString:=StrSubstNo(ManagerVATNoErrorLbl, VATManagerNoCheck);
                        Error(ErrorString);
                    end;
                //KB140224 - VAT Manager Setup added ---
                end;
                7: begin
                    CustomerFiscalCode:=CopyStr(CSVBuffer.Value, 1, MaxStrLen(CustomerFiscalCode));
                    Contract.SetRange("POD No.", PODNo);
                    if not Contract.IsEmpty() and Contract.FindFirst()then if Customer.Get(Contract."Customer No.")then if CustomerFiscalCode <> '' then if Customer."Fiscal Code" <> CustomerFiscalCode then begin
                                    ErrorString:=StrSubstNo(CustomerFiscalLbl, CSVBuffer.Value, Customer.Name);
                                    Error(ErrorString);
                                end;
                end;
                8: if SIILogEntries."VAT Number" <> CSVBuffer.Value then begin
                        ErrorString:=StrSubstNo(CustomerVATLbl, CSVBuffer.Value, Customer.Name);
                        Error(ErrorString);
                    end;
                end;
                if CSVBuffer."Field No." = 10 then if not HasExistingFile(SIILogEntries, "AAT File Type SII"::"SE4.0200")then SwitchInManagement.CompleteSwitchInProcess(SIILogEntries, FileName);
            until CSVBuffer.Next() = 0;
        end;
    end;
    procedure HasExistingFile(var SIILogEntry: Record "SII Log Entries"; AATFileTypeSII: Enum "AAT File Type SII"): Boolean var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        ExistingFileErr: Label 'File type %1 has already been imported and accepted for %2.', Comment = 'File type %1 has already been imported and accepted for %2.';
    begin
        DetailedSIILogEntry.SetRange("CP User", SIILogEntry."CP User");
        DetailedSIILogEntry.SetRange("File Type", AATFileTypeSII);
        DetailedSIILogEntry.SetRange(Status, "SII Detailed Status"::Accepted);
        if not DetailedSIILogEntry.FindLast()then exit(false)
        else
            Error(ExistingFileErr, DetailedSIILogEntry."File Type", DetailedSIILogEntry."CP User");
    end;
    var CompanyInformation: Record "Company Information";
}
