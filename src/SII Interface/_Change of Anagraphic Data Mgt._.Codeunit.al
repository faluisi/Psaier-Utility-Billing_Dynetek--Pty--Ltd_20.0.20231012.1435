codeunit 50207 "Change of Anagraphic Data Mgt."
{
    /// <summary>
    /// Initiates the Change of Anagraphic Data Process fot the SII Interface.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    procedure NewChangeOfAnagraphicData(var Contract: Record Contract; Filename: Text)
    var
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Customer: Record Customer;
        CSVExportManager: Codeunit "CSV Export Manager";
        CSVOutstream: OutStream;
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        Recreate:=false;
        if Contract.FindSet()then CSVText:=CSVExportManager.ChangeofAnagraphicDataAE10050(Contract, Recreate, SIILogEntry);
        repeat if Customer.Get(Contract."Customer No.")then;
            SIIInterfaceGeneralSetup.Get();
            SIILogEntry:=NewSIILogEntry(Customer, Contract);
            if Filename = '' then Filename:=Format("AAT File Type SII"::"AE1.0050") + '_' + SIILogEntry."CP User";
            SIILogEntry.Status:="AAT Log Status SII"::"Exported AE1.0050";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0050";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                CSVOutstream.Write(CSVText);
                if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"AE1.0050"), SIILogEntry."CP User"));
            end;
        until Contract.Next() = 0;
    end;
    procedure RecreateChangeOfAnagraphicData(var Contract: Record Contract; Filename: Text; var SIILogEntriesErrored: Record "SII Log Entries")
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
        if Contract.FindSet()then CSVText:=CSVExportManager.ChangeofAnagraphicDataAE10050(Contract, Recreate, SIILogEntriesErrored);
        if SIILogEntriesErrored.FindSet()then repeat SIIInterfaceGeneralSetup.Get();
                if Contract.Get(SIILogEntriesErrored."Contract No.")then if Customer.Get(Contract."Customer No.")then;
                Filename:=Format("AAT File Type SII"::"SE1.0050") + '_' + SIILogEntriesErrored."CP User";
                SIILogEntriesErrored.Status:="AAT Log Status SII"::"Exported AE1.0050";
                SIILogEntriesErrored.Modify(true);
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntriesErrored, Filename);
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                    CSVOutstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"AE1.0050"), SIILogEntriesErrored."CP User"));
                end;
            until SIILogEntriesErrored.Next() = 0;
    end;
    /// <summary>
    /// Change of Anagraphic Data error checking after import.
    /// </summary>
    /// <param name="Var isError ">Boolean.</param>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ErrorCode">Code[20].</param>
    /// <param name="ErrorMessage">Text[150].</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure ChangeOfAnagraphicDataErrorCheck(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text[150]; TempCSVBuffer: Record "CSV Buffer"; FileName: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been imported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntryError(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry.Message:=ErrorMessage;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
            end;
        end
        else
        begin
            SIILogEntry.Status:="AAT Log Status SII"::"Imported File AE1.0100";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate("Initial Upload Date", Today());
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, FileName, DetailedEntryNo);
            end;
        end;
        if TempCSVBuffer.GetNumberOfLines() = TempCSVBuffer."Line No." then if SIILogEntriesErrored.HasFilter then if not SIILogEntriesErrored.IsEmpty then RecreateChangeofAnagraphicDataDetailedLogEntry(SIILogEntriesErrored, TempCSVBuffer, FileName);
    end;
    local procedure RecreateChangeofAnagraphicDataDetailedLogEntry(var SIILogEntriesErrored: Record "SII Log Entries"; TempCSVBuffer: Record "CSV Buffer"; FileName: Text)
    var
        Contract: Record Contract;
        ContractFilter: Text;
    begin
        if SIILogEntriesErrored.FindSet()then repeat SIILogEntriesErrored.Status:="AAT Log Status SII"::Recreated;
                SIILogEntriesErrored.Modify(true);
                if Contract.Get(SIILogEntriesErrored."Contract No.")then ContractFilter+=Contract."No." + '|';
            until SIILogEntriesErrored.Next() = 0;
        Contract.SetFilter("No.", CopyStr(ContractFilter, 1, StrLen(ContractFilter) - 1));
        if Contract.FindSet()then;
        RecreateChangeOfAnagraphicData(Contract, FileName, SIILogEntriesErrored);
    end;
    /// <summary>
    /// Completes the Change of Anagraphic Data Process by Completing the Status of the entry.
    /// </summary>
    /// <param name="Var isError ">Boolean.</param>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ErrorCode">Code[20].</param>
    /// <param name="ErrorMessage">Text[150].</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure CompleteChangeOfAnagraphicData(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text[150]; TempCSVBuffer: Record "CSV Buffer"; FileName: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been imported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntryError(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0150";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry.Message:=ErrorMessage;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
            end;
        end
        else
        begin
            SIILogEntry.Status:="AAT Log Status SII"::Completed;
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate("Initial Upload Date", Today());
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"AE1.0150";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, FileName, DetailedEntryNo);
            end;
        end;
        if TempCSVBuffer.GetNumberOfLines() = TempCSVBuffer."Line No." then if SIILogEntriesErrored.HasFilter then if not SIILogEntriesErrored.IsEmpty then RecreateChangeofAnagraphicDataDetailedLogEntry(SIILogEntriesErrored, TempCSVBuffer, FileName);
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract)SIILogEntry: Record "SII Log Entries" var
    begin
        SIILogEntry.Init();
        SIILogEntry.Type:=SIILogEntry.Type::"Change of Personal Data";
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", Today());
        SIILogEntry.Validate("CP User");
        SIILogEntry.Validate(Status, "AAT Log Status SII"::" ");
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Insert(true);
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; FileName: Text)DetailedEntryNo: Integer;
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    local procedure NewDetailedSIILogEntryError(SIILogEntry: Record "SII Log Entries"; FileName: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry.Validate(Error, true);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Rejected);
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    var Recreate: Boolean;
}
