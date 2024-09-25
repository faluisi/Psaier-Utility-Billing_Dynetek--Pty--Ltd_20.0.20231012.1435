codeunit 50208 "Contract Termination Mgt."
{
    /// <summary>
    /// Initiates the Contract termination SII Interface Process
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    /// <param name="ReasonforTermination">Enum "Reason for Cont. Termination".</param>
    procedure NewContractTerminationProcess(var Contract: Record Contract; ReasonforTermination: Enum "Reason for Cont. Termination"; Filename: Text)
    var
        Customer: Record Customer;
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        SIILogEntry: Record "SII Log Entries";
        CSVExportManager: Codeunit "CSV Export Manager";
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
        Outstream: OutStream;
        CSVText: Text;
    begin
        Recreate:=false;
        if Contract.FindSet()then repeat CSVText:=CSVExportManager.ContractTerminationRC10050(Contract, ReasonforTermination, SIILogEntry, Recreate);
                SIIInterfaceGeneralSetup.Get();
                if Customer.Get(Contract."Customer No.")then;
                SIILogEntry:=NewSIILogEntry(Customer, Contract);
                if Filename = '' then Filename:=Format("AAT File Type SII"::"RC1.0050") + '_' + SIILogEntry."CP User";
                SIILogEntry.Status:="AAT Log Status SII"::"Exported RC1.0050";
                SIILogEntry.Modify(true);
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, '');
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"RC1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    DetailedSIILogEntry.Message:=Format(ReasonforTermination);
                    DetailedSIILogEntry."CVS Text".CreateOutStream(Outstream);
                    Outstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then begin
                        Contract."Deactivation Cause":="Deactivation Cause"::Termination;
                        Contract.Status:=Contract.Status::"Closed - Awaiting Approval";
                        Contract.Modify(true);
                        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"RC1.0050"), SIILogEntry."CP User"));
                    end;
                end;
            until Contract.Next() = 0;
    end;
    procedure RecreateContractTerminationProcess(var Contract: Record Contract; ReasonforTermination: Enum "Reason for Cont. Termination"; Filename: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        Customer: Record Customer;
        DetailedSIILogEntries2: Record "Detailed SII Log Entries";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        CSVExportManager: Codeunit "CSV Export Manager";
        DetailedEntryNo: Integer;
        Outstream: OutStream;
        CSVText: Text;
    begin
        Recreate:=true;
        if Contract.FindSet()then CSVText:=CSVExportManager.ContractTerminationRC10050(Contract, ReasonforTermination, SIILogEntriesErrored, Recreate);
        if SIILogEntriesErrored.FindSet()then repeat if Contract.Get(SIILogEntriesErrored."Contract No.")then if Customer.Get(Contract."Customer No.")then;
                SIIInterfaceGeneralSetup.Get();
                if Filename = '' then Filename:=Format("AAT File Type SII"::"RC1.0050") + '_' + SIILogEntriesErrored."CP User";
                SIILogEntriesErrored.Status:="AAT Log Status SII"::"Exported RC1.0050";
                SIILogEntriesErrored.Modify(true);
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntriesErrored, Filename);
                DetailedSIILogEntries2.SetRange("CP User", SIILogEntriesErrored."CP User");
                DetailedSIILogEntries2.SetRange("Log Entry No.", SIILogEntriesErrored."Entry No.");
                DetailedSIILogEntries2.SetRange("Contract No.", Contract."No.");
                DetailedSIILogEntries2.SetRange("File Type", "AAT File Type SII"::"RC1.0050");
                if DetailedSIILogEntries2.FindFirst()then;
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Recreated - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"RC1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    if SIILogEntriesErrored.Status = "AAT Log Status SII"::"Exported RC1.0050" then DetailedSIILogEntry.Message:=DetailedSIILogEntries2.Message;
                    DetailedSIILogEntry."CVS Text".CreateOutStream(Outstream);
                    Outstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then begin
                        Contract."Deactivation Cause":="Deactivation Cause"::Termination;
                        Contract.Status:=Contract.Status::"Closed - Awaiting Approval";
                        Contract.Modify(true);
                    end;
                end;
            until SIILogEntriesErrored.Next() = 0;
    end;
    /// <summary>
    /// Completes the Contract Termination SII Interface Process.
    /// </summary>
    /// <param name="Var isError ">Boolean.</param>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ErrorCode">Code[20].</param>
    /// <param name="ErrorMessage">Text[150].</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure CompleteContractTermination(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text[150]; TempCSVBuffer: Record "CSV Buffer"; Filename: Text; var SIILogEntriesErrored: Record "SII Log Entries")
    var
        Contract: Record Contract;
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        DetailedEntryNo: Integer;
    begin
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"RC1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Rejected);
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
                DetailedSIILogEntry.Modify(true);
            end;
        end
        else
        begin
            SIILogEntry.Status:="AAT Log Status SII"::"Termination Completed";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"RC1.0100";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
                DetailedSIILogEntry.Modify(true);
            end;
            if Contract.Get(DetailedSIILogEntry."Contract No.")then begin
                Contract.Validate("Deactivation Cause");
                Contract.Validate(Status, "Contract Status"::Closed);
                Contract.Modify(true);
            end;
        end;
        if TempCSVBuffer."Line No." = TempCSVBuffer.GetNumberOfLines()then if SIILogEntriesErrored.HasFilter then if SIILogEntriesErrored.Count > 0 then RecreateTerminationProcess(SIILogEntriesErrored, TempCSVBuffer, Filename);
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract)SIILogEntry: Record "SII Log Entries" var
    begin
        SIILogEntry.Init();
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Type:=SIILogEntry.Type::"Contract Termination";
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", CalcDate('<1W>', SIILogEntry."Initial Upload"));
        SIILogEntry.Validate("CP User");
        SIILogEntry.Validate(Status, "AAT Log Status SII"::" ");
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Insert(true);
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; Filename: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry.Validate(Filename, Filename);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    local procedure RecreateTerminationProcess(var SIILogEntriesErrored: Record "SII Log Entries"; TempCSVBuffer: Record "CSV Buffer"; FileName: Text)
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
        RecreateContractTerminationProcess(Contract, "Reason for Cont. Termination"::" ", FileName, SIILogEntriesErrored);
    end;
    var Recreate: Boolean;
}
