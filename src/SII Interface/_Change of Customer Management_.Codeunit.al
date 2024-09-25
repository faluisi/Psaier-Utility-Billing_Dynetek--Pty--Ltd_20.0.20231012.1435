codeunit 50206 "Change of Customer Management"
{
    /// <summary>
    /// Initiates the Change of Customer SII Interface Process.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    procedure NewChangeofCustomer(var Contract: Record Contract; Filename: Text)
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
        if Contract.FindSet()then CSVText:=CSVExportManager.ChangeofCustomerVT10050(Contract, Recreate, SIILogEntry);
        repeat if Customer.Get(Contract."Customer No.")then;
            SIIInterfaceGeneralSetup.Get();
            SIILogEntry:=NewSIILogEntry(Customer, Contract);
            if Filename = '' then Filename:=Format("AAT File Type SII"::"VT1.0050") + '_' + SIILogEntry."CP User";
            SIILogEntry.Status:="AAT Log Status SII"::"Exported VT1.0050";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0050";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                CSVOutstream.Write(CSVText);
                if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, 'VT1.0050', SIILogEntry."CP User"));
            end;
        until Contract.Next() = 0;
    end;
    procedure RecreateChangeofCustomer(var Contract: Record Contract; Filename: Text; var SIILogEntriesError: Record "SII Log Entries")
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
        Recreate:=true;
        if Contract.FindSet()then CSVText:=CSVExportManager.ChangeofCustomerVT10050(Contract, Recreate, SIILogEntriesError);
        if SIILogEntriesError.FindSet()then repeat if Contract.Get(SIILogEntriesError."Contract No.")then if Customer.Get(Contract."Customer No.")then;
                SIIInterfaceGeneralSetup.Get();
                SIILogEntriesError.Status:="AAT Log Status SII"::"Exported VT1.0050";
                SIILogEntriesError.Modify(true);
                if Filename = '' then Filename:=Format("AAT File Type SII"::"VT1.0050") + '_' + SIILogEntry."CP User";
                DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntriesError, Filename);
                if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                    DetailedSIILogEntry.Validate(Error, false);
                    DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Recreated - Awaiting File");
                    DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0050";
                    DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                    DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
                    CSVOutstream.Write(CSVText);
                    if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, 'VT1.0050', SIILogEntry."CP User"));
                end;
            until SIILogEntriesError.Next() = 0;
    end;
    /// <summary>
    /// Error checking while importing new file of the Change of Customer SII Process.
    /// </summary>
    /// <param name="Var isError ">Boolean.</param>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ErrorCode">Code[20].</param>
    /// <param name="ErrorMessage">Text[150].</param>
    /// <param name="Var TempCSVBuffer ">Record "CSV Buffer".</param>
    procedure ChangeofCustomerErrorCheck(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text[150]; TempCSVBuffer: Record "CSV Buffer"; var SIILogEntriesErrored: Record "SII Log Entries"; Filename: Text)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been imported: %1 \\Detailed SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntryError(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0100";
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
            SIILogEntry.Status:="AAT Log Status SII"::"Imported File VT1.0100";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate("Initial Upload Date", Today());
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0100";
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, Filename, DetailedEntryNo);
            end;
        end;
        if TempCSVBuffer."Line No." = TempCSVBuffer.GetNumberOfLines()then if SIILogEntriesErrored.HasFilter then if not SIILogEntriesErrored.IsEmpty then RecreateChangeofCustomerDetailedLogEntry(SIILogEntriesErrored, TempCSVBuffer, Filename);
    end;
    procedure CancelChangeofCustomerErrorCheck(isError: Boolean; SIILogEntry: Record "SII Log Entries"; ErrorCode: Code[20]; ErrorMessage: Text[150]; TempCSVBuffer: Record "CSV Buffer"; var SIILogEntriesErrored: Record "SII Log Entries"; Filename: Text)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been imported: %1 \\Detailed SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        if isError then begin
            SIILogEntry.Status:="AAT Log Status SII"::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntryError(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0101";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry."Error Code":=ErrorCode;
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry.Message:=ErrorMessage;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, Filename, DetailedEntryNo);
            end;
        end
        else
        begin
            SIILogEntry.Status:="AAT Log Status SII"::"Imported File VT1.0101";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0101";
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry.Message:=ErrorMessage;
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                CSVText:=Format(TempCSVBuffer);
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, Filename, DetailedEntryNo);
            end;
        end;
        if TempCSVBuffer."Line No." = TempCSVBuffer.GetNumberOfLines()then if SIILogEntriesErrored.HasFilter then if not SIILogEntriesErrored.IsEmpty then RecreateCancelChangeofCustomerDetailedLogEntry(SIILogEntriesErrored, TempCSVBuffer, Filename);
    end;
    local procedure RecreateChangeofCustomerDetailedLogEntry(var SIILogEntriesError: Record "SII Log Entries"; TempCSVBuffer: Record "CSV Buffer"; Filename: Text)
    var
        Contract: Record Contract;
        ContractFilter: Text;
    begin
        if SIILogEntriesError.FindSet()then repeat SIILogEntriesError.Status:="AAT Log Status SII"::Recreated;
                SIILogEntriesError.Modify(true);
                if Contract.Get(SIILogEntriesError."Contract No.")then ContractFilter+=Contract."No." + '|';
            until SIILogEntriesError.Next() = 0;
        Contract.SetFilter("No.", CopyStr(ContractFilter, 1, StrLen(ContractFilter) - 1));
        if Contract.FindSet()then;
        RecreateChangeofCustomer(Contract, Filename, SIILogEntriesError);
    end;
    local procedure RecreateCancelChangeofCustomerDetailedLogEntry(var SIILogEntriesError: Record "SII Log Entries"; TempCSVBuffer: Record "CSV Buffer"; Filename: Text)
    var
        Contract: Record Contract;
        ContractFilter: Text;
    begin
        if SIILogEntriesError.FindSet()then repeat SIILogEntriesError.Status:="AAT Log Status SII"::Recreated;
                SIILogEntriesError.Modify(true);
                if Contract.Get(SIILogEntriesError."Contract No.")then ContractFilter+=Contract."No." + '|';
            until SIILogEntriesError.Next() = 0;
        Contract.SetFilter("No.", CopyStr(ContractFilter, 1, StrLen(ContractFilter) - 1));
        if Contract.FindSet()then;
        RecreateCancelChangeofCustomerRequest(SIILogEntriesError, Contract, Filename);
    end;
    /// <summary>
    /// Exports a Change of Customer Cancellation request.
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    procedure CancelChangeofCustomerRequest(var SIILogEntry: Record "SII Log Entries"; var Contract: Record Contract; Filename: Text)
    var
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        CSVExportManager: Codeunit "CSV Export Manager";
        OutStream: OutStream;
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        CSVText:=CSVExportManager.ChangeofCustomerVT10040(SIILogEntry, Contract);
        SIIInterfaceGeneralSetup.Get();
        SIILogEntry.Status:="AAT Log Status SII"::"Exported VT1.0040";
        SIILogEntry.Modify(true);
        if Filename = '' then Filename:=Format("AAT File Type SII"::"VT1.0040") + '_' + SIILogEntry."CP User";
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry.Validate(Error, false);
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0040";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
            DetailedSIILogEntry."CVS Text".CreateOutStream(OutStream);
            OutStream.Write(CSVText);
            if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"VT1.0040"), SIILogEntry."CP User"));
        end;
    end;
    procedure RecreateCancelChangeofCustomerRequest(var SIILogEntriesError: Record "SII Log Entries"; var Contract: Record Contract; Filename: Text)
    var
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        CSVExportManager: Codeunit "CSV Export Manager";
        OutStream: OutStream;
        CSVText: Text;
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        if SIILogEntriesError.FindSet()then CSVText:=CSVExportManager.ChangeofCustomerVT10040(SIILogEntriesError, Contract);
        repeat SIIInterfaceGeneralSetup.Get();
            SIILogEntriesError.Status:="AAT Log Status SII"::"Exported VT1.0040";
            SIILogEntriesError.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntriesError, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry.Validate(Error, false);
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0040";
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
                DetailedSIILogEntry."CVS Text".CreateOutStream(OutStream);
                OutStream.Write(CSVText);
                if DetailedSIILogEntry.Modify(true)then Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"VT1.0040"), SIILogEntriesError."CP User"));
            end;
        until SIILogEntriesError.Next() = 0;
    end;
    /// <summary>
    /// Completes the Change of Customer SII Process by closing the Entry.
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    /// <param name="ResultCode">Code[5].</param>
    /// <param name="ResultDetail">Text[200].</param>
    procedure CompleteChangeofCustomerProcess(SIILogEntry: Record "SII Log Entries"; ResultCode: Code[5]; ResultDetail: Text[200]; Filename: Text; Error: Boolean)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        DetailedEntryNo: Integer;
        MessageLbl: Label 'The following file has been imported: %1 \\Detailed SII Log Entry %2 has been created.', Locked = true;
    begin
        // SIILogEntry.Status := 'Completed';
        if Error then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0150";
                DetailedSIILogEntry."Error Code":=ResultCode;
                DetailedSIILogEntry.Error:=true;
                DetailedSIILogEntry.Message:=ResultDetail;
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
                DetailedSIILogEntry.Modify(true);
            end;
        end
        else
        begin
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File VT1.0150";
            DetailedSIILogEntry.SetRange("CP User", SIILogEntry."CP User");
            if DetailedSIILogEntry.FindLast()then case DetailedSIILogEntry."File Type" of "AAT File Type SII"::"VT1.0100": SIILogEntry.Status:="AAT Log Status SII"::"Imported File VT1.0150";
                "AAT File Type SII"::"VT1.0101": SIILogEntry.Status:="AAT Log Status SII"::Completed;
                end;
            SIILogEntry.Modify(true);
            DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, Filename);
            if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
                DetailedSIILogEntry."File Type":="AAT File Type SII"::"VT1.0150";
                DetailedSIILogEntry."Error Code":=ResultCode;
                DetailedSIILogEntry.Message:=ResultDetail;
                DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
                DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
                DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
                DetailedSIILogEntry.Modify(true);
                Message(MessageLbl, Filename, DetailedEntryNo);
            end;
        end;
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract)SIILogEntry: Record "SII Log Entries" var
    begin
        SIILogEntry.Init();
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Type:=SIILogEntry.Type::"Change of Customer";
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
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
        DetailedSIILogEntry.Validate("Initial Upload Date", Today());
        DetailedSIILogEntry.Validate(User, UserId());
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    local procedure NewDetailedSIILogEntryError(SIILogEntry: Record "SII Log Entries"; Filename: Text)DetailedEntryNo: Integer var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Reset();
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", Today());
        DetailedSIILogEntry.Validate(Error, true);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Rejected);
        DetailedSIILogEntry.Validate(Filename, Filename);
        DetailedSIILogEntry.Validate(User, UserId());
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
    var Recreate: Boolean;
}
