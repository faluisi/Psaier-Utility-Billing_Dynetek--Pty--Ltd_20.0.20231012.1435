codeunit 70001 DeactivationDataMgmt
{
    //KB08112023 - TASK002126 Deactivation Process +++
    procedure NewChangeofDeactivationData(Contract: Record Contract; DisattFuoriOrario: Boolean; PresenzaClienteNoTelegestito: Boolean; RequestedDeactivationDate: Date)
    var
        Customer: Record Customer;
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        SIILogEntry: Record "SII Log Entries";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DeactivationExportMgmt: Codeunit ImportExportManagerDeactivate;
        FileName: Text;
        CPUser: Code[20];
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        CPUser:=NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Deactivation CP User", Today, true);
        FileName:=Format("AAT File Type SII"::"D01.E050") + '_' + CPUser;
        DeactivationExportMgmt.ExportD010050File(Contract, CPUser, DisattFuoriOrario, PresenzaClienteNoTelegestito, RequestedDeactivationDate);
        if Customer.get(Contract."Customer No.")then;
        SIILogEntry:=NewSIILogEntry(Customer, Contract, CPUser, "AAT Log Status SII"::"Exported D01.E050");
        NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"D01.E050", true, "SII Detailed Status"::"Created - Awaiting File");
        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"D01.E050"), SIILogEntry."CP User"));
    end;
    procedure ModifyDeactivationDataVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; DeactivationNo: Code[20])
    var
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"D01.E100", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."Deactivation No.":=DeactivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported D01.E100";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"D01.E100", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ModifyDeactivationDataFinalVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; DeactivationNo: Code[20])
    var
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"D01.E150", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."Deactivation No.":=DeactivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported D01.E150";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"D01.E150", false, "SII Detailed Status"::Accepted);
        end;
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract; CPUser: Code[20]; Status: Enum "AAT Log Status SII")SIILogEntry: Record "SII Log Entries" begin
        SIILogEntry.Init();
        SIILogEntry.Type:=SIILogEntry.Type::Deactivate;
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Validate("CP User", CPUser);
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", Today());
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Validate(Status, Status);
        SIILogEntry.Insert(true);
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; FileName: Text; FileType: Enum "AAT File Type SII"; IsExport: Boolean; Status: Enum "SII Detailed Status")
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
        DetailedSIILogEntry.Validate("CP User", SIILogEntry."CP User");
        DetailedSIILogEntry.Validate(Error, false);
        DetailedSIILogEntry."File Type":=FileType;
        DetailedSIILogEntry.Status:=Status;
        if IsExport then DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload
        else
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
        DetailedSIILogEntry.Insert(true);
    end;
    //KB08112023 - TASK002126 Deactivation Process ---   
    //KB07122023 - TASK002199 Meter Measurement List Update +++
    procedure MeasurementDataUpdate(Meter: Record Meter)
    var
        Measurement: Record Measurement;
    begin
        Measurement.Init();
        Measurement.Validate("POD No.", Meter."POD No.");
        Measurement.Validate("Meter Serial No.", Meter."Serial No.");
        Measurement.Date:=Meter."Deactivation Date";
        Measurement."Measure Date":=Meter."Deactivation Date";
        Evaluate(Measurement.Month, Format(Measurement."Measure Date", 0, '<Month,2>/<Year4>'));
        Measurement."Active F1":=Meter."Deactivation F1 Active";
        Measurement."Active F2":=Meter."Deactivation F2 Active";
        Measurement."Active F3":=Meter."Deactivation F3 Active";
        Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3";
        Measurement."Reactive F1":=Meter."Deactivation F1 Reactive";
        Measurement."Reactive F2":=Meter."Deactivation F2 Reactive";
        Measurement."Reactive F3":=Meter."Deactivation F3 Reactive";
        Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3";
        Measurement."Peak F1":=Meter."Deactivation F1 Peak";
        Measurement."Peak F2":=Meter."Deactivation F2 Peak";
        Measurement."Peak F3":=Meter."Deactivation F3 Peak";
        Measurement.Insert();
    end;
//KB07122023 - TASK002199 Meter Measurement List Update ---     
}
