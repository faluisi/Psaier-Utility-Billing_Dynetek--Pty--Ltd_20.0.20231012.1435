codeunit 50204 "Switch In Management"
{
    /// <summary>
    /// Intiates the start of the Switch In Process for the SII Interface.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    var Recreate: Boolean;
    procedure NewSwitchInProcess(var Contract: Record Contract; FileName: Text; RevocaTimoe: Boolean; AcquistoCredito: Boolean)
    var
        SIILogEntry: Record "SII Log Entries";
        SIILogEntry2: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Customer: Record Customer;
        CSVExportManager: Codeunit "CSV Export Manager";
        CSVOutstream: Outstream;
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
        ExistContractErr: Label 'Switch In SII log entry already exist for Contract/s:\\ %1', Comment = 'Switch In SII log entry already exist for Contract/s:\\ %1';
        ExistingContracts: Text;
    begin
        Recreate:=false;
        if Contract.FindSet()then CSVText:=CSVExportManager.SwitchInSE10050(Contract, Recreate, SIILogEntry, RevocaTimoe, AcquistoCredito);
        repeat SIILogEntry2.SetRange("Contract No.", Contract."No.");
            SIILogEntry2.SetRange(Type, "Process Type"::"Switch In");
            if not SIILogEntry2.IsEmpty then ExistingContracts+=Contract."No." + ', '
            else
            begin
                if Customer.Get(Contract."Customer No.")then;
                SIIInterfaceGeneralSetup.Get();
                SIILogEntry:=NewSIILogEntry(Customer, Contract);
                if FileName = '' then FileName:=Format("AAT File Type SII"::"SE1.0050") + '_' + SIILogEntry."CP User";
                SIILogEntry.Status:="AAT Log Status SII"::"Exported SE1.0050";
                SIILogEntry.Modify(true);
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                    CSVOutstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"SE1.0050"), SIILogEntry."CP User"));
                end;
            end;
        until Contract.Next() = 0;
        if StrLen(ExistingContracts) > 0 then Message(StrSubstNo(ExistContractErr, ExistingContracts));
    end;
    local procedure RecreateSwitchInProcess(var Contract: Record Contract; FileName: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Customer: Record Customer;
        CSVExportManager: Codeunit "CSV Export Manager";
        CSVOutstream: OutStream;
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        Recreate:=true;
        if Contract.FindSet()then CSVText:=CSVExportManager.SwitchInSE10050(Contract, Recreate, SIILogEntriesErrored, false, false);
        if SIILogEntriesErrored.FindSet()then repeat if Contract.Get(SIILogEntriesErrored."Contract No.")then if Customer.Get(Contract."Customer No.")then;
                SIIInterfaceGeneralSetup.Get();
                if FileName = '' then FileName:=Format("AAT File Type SII"::"SE1.0050") + '_' + SIILogEntriesErrored."CP User";
                SIILogEntriesErrored.Status:="AAT Log Status SII"::"Exported SE1.0050";
                SIILogEntriesErrored.Modify(true);
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntriesErrored, FileName);
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Recreated - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                    CSVOutstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"SE1.0050"), SIILogEntriesErrored."CP User"));
                end;
            until SIILogEntriesErrored.Next() = 0;
    end;
    /// <summary>
    /// On Import check file for errors before continuing.
    /// </summary>
    /// <param name="Var isError ">Boolean.</param>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ErrorCode">Code[20].</param>
    /// <param name="ErrorMessage">Text[150].</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure SwitchInErrorCheck(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text; TempCSVBuffer: Record "CSV Buffer"; FileName: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        Contract: Record Contract;
        CSVText: Text;
        DetailedEntryNo: Integer;
    begin
        SIIInterfaceGeneralSetup.Get();
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntryError(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry.Message:=CopyStr(ErrorMessage, 1, MaxStrLen(DetailedSIILogEntry.Message));
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
            end;
        end
        else
        begin
            SIILogEntry.Status:="AAT Log Status SII"::"Imported File SE1.0100";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate("Initial Upload Date", Today());
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry.Message:=CopyStr(ErrorMessage, 1, MaxStrLen(DetailedSIILogEntry.Message));
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
            end;
        end;
        //KB22112023 - TASK002154 Switch-In Process +++
        if Contract.Get(SIILogEntry."Contract No.")then begin
            Contract.Status:=Contract.Status::Open;
            Contract.Modify();
        end;
        //KB22112023 - TASK002154 Switch-In Process ---
        if TempCSVBuffer."Line No." = TempCSVBuffer.GetNumberOfLines()then if SIILogEntriesErrored.HasFilter then if SIILogEntriesErrored.Count > 0 then RecreateSwitchInDetailedLogEntry(TempCSVBuffer, FileName, SIILogEntriesErrored);
    end;
    /// <summary>
    /// Import Function for the Additional Files that could possibly be imported.
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure AdditionalFileImport(SIILogEntry: Record "SII Log Entries"; var TempCSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Contract: Record Contract;
        CSVText: Text;
        DetailedEntryNo: Integer;
    begin
        SIILogEntry.Status:="AAT Log Status SII"::"Imported Additional File SE1.0200";
        SIILogEntry.Modify(true);
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
            DetailedSIILogEntry."Detailed Entry No.":=SIILogEntry."Entry No.";
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE1.0200";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
            CSVText:=Format(TempCSVBuffer);
            DetailedSIILogEntry.Modify(true);
        end;
        //KB22112023 - TASK002154 Switch-In Process +++
        if Contract.Get(SIILogEntry."Contract No.")then if Contract.Status <> Contract.Status::Open then begin
                Contract.Status:=Contract.Status::Open;
                Contract.Modify();
            end;
    //KB22112023 - TASK002154 Switch-In Process ---
    end;
    local procedure RecreateSwitchInDetailedLogEntry(TempCSVBuffer: Record "CSV Buffer"; FileName: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Contract: Record Contract;
        ContractFilter: Text;
        Outstream: OutStream;
        CSVText: Text;
        MessageLbl: Label 'The following file has been rejected: SE1.0100 \\Switch In Process started again.', Locked = true;
    begin
        if SIILogEntriesErrored.FindSet()then repeat SIILogEntriesErrored.Status:="AAT Log Status SII"::Recreated;
                SIILogEntriesErrored.Modify(true);
                DetailedSIILogEntry."CVS Text".CreateOutStream(Outstream);
                CSVText:=Format(TempCSVBuffer);
                Outstream.Write(CSVText);
                if DetailedSIILogEntry.Modify(true)then Message(MessageLbl);
                if Contract.Get(SIILogEntriesErrored."Contract No.")then ContractFilter+=Contract."No." + '|';
            until SIILogEntriesErrored.Next() = 0;
        Contract.SetFilter("No.", CopyStr(ContractFilter, 1, StrLen(ContractFilter) - 1));
        if Contract.FindSet()then;
        RecreateSwitchInProcess(Contract, FileName, SIILogEntriesErrored);
    end;
    /// <summary>
    /// Completes the Switch In SII Interface Process.
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    procedure CompleteSwitchInProcess(SIILogEntry: Record "SII Log Entries"; FileName: Text)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        DetailedEntryNo: Integer;
    begin
        SIILogEntry.Status:="AAT Log Status SII"::Completed;
        SIILogEntry.Modify(true);
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE4.0200";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
            DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
            DetailedSIILogEntry.Modify(true);
        end;
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract)SIILogEntry: Record "SII Log Entries" var
    begin
        SIILogEntry.Init();
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Type:=SIILogEntry.Type::"Switch In";
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", Today());
        SIILogEntry.Validate("CP User");
        SIILogEntry.Validate(Status, "AAT Log Status SII"::" ");
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Insert(true);
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; FileName: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Validate(Filename, FileName);
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    local procedure NewDetailedSIILogEntryError(SIILogEntry: Record "SII Log Entries"; FileName: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Validate(Error, true);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Rejected);
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry.Validate(Filename, FileName);
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
}
