codeunit 50205 "Switch Out Management"
{
    /// <summary>
    /// Initiates the Swith Out Process fot the SII Interface.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="Contract">Record Contract.</param>
    procedure NewSwitchOutProcess(Customer: Record Customer; Contract: Record Contract)
    var
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        DetailedEntryNo: Integer;
        FileName: Text;
        MessageLbl: Label 'SII log entry %1 has been created for the Switch Out. Import a SE3.0200 file to complete the Switch Out process.', Comment = 'SII log entry %1 has been created for the Switch Out. Import a SE3.0200 file to complete the Switch Out process.';
    begin
        SIIInterfaceGeneralSetup.Get();
        SIILogEntry:=NewSIILogEntry(Customer, Contract);
        FileName:='';
        SIILogEntry.Status:="AAT Log Status SII"::"Awaiting File";
        SIILogEntry.Modify(true);
        DetailedEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
        if DetailedSIILogEntry.Get(DetailedEntryNo)then begin
            DetailedSIILogEntry.Validate(Error, false);
            DetailedSIILogEntry.Validate(User, UserId);
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE3.0200";
            DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload;
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::"Created - Awaiting File");
            DetailedSIILogEntry.Modify(true);
            Message(MessageLbl, DetailedEntryNo);
        end;
    end;
    /// <summary>
    /// Completes the Switch Out Process by Completing the Status of the entry.
    /// </summary>
    /// <param name="SIILogEntry">Record "SII Log Entries".</param>
    procedure CompleteSwitchOut(SIILogEntry: Record "SII Log Entries"; FileName: Text)
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
        Contract: Record Contract;
        DetailedSEntryNo: Integer;
        CSVOutstream: OutStream;
        CSVText: Text;
        MessageLbl: Label 'The following file has been imported: %1 \\SII Log Entry %2 has been created. Contract %3 Status set to closed.', Locked = true;
    begin
        SIILogEntry.Status:="AAT Log Status SII"::Completed;
        SIILogEntry.Modify(true);
        DetailedSEntryNo:=NewDetailedSIILogEntry(SIILogEntry, FileName);
        if DetailedSIILogEntry.Get(DetailedSEntryNo)then begin
            DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
            DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE3.0200";
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
            DetailedSIILogEntry.Validate(Status, DetailedSIILogEntry.Status::Accepted);
            DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
            DetailedSIILogEntry."CVS Text".CreateOutStream(CSVOutstream);
            CSVOutstream.Write(CSVText);
            DetailedSIILogEntry.Modify(true);
            Contract.SetRange("No.", SIILogEntry."Contract No.");
            if Contract.FindFirst()then begin
                Contract."Deactivation Cause":=Contract."Deactivation Cause"::Switch;
                Contract.Validate(Status, Contract.Status::Closed);
                Contract.Modify(true);
                Message(MessageLbl, FileName, DetailedSEntryNo, DetailedSIILogEntry."Contract No.");
            end;
        end;
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract)SIILogEntry: Record "SII Log Entries" var
    begin
        SIILogEntry.Init();
        SIILogEntry.Type:=SIILogEntry.Type::"Switch Out";
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Type:=SIILogEntry.Type::"Switch Out";
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
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry."File Type":="AAT File Type SII"::"SE3.0200";
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Validate("Initial Upload Date", Today());
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry."CP User":=SIILogEntry."CP User";
        DetailedSIILogEntry.Insert(true);
        DetailedEntryNo:=DetailedSIILogEntry."Detailed Entry No.";
    end;
}
