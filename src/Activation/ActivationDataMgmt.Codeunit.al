codeunit 70101 ActivationDataMgmt
{
    //KB20112023 - TASK002131 New Activation Process +++
    procedure ChangeOfNewActivationData(Contract: Record Contract; Notes: Text[50])
    var
        Customer: Record Customer;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        NewActivationExportMgmt: Codeunit ImportExportManagerActivate;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CPUser: Code[20];
        FileName: Text;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        CPUser:=NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Activation CP User", Today, true);
        FileName:=Format("AAT File Type SII"::"PN1.0050") + '_' + CPUser;
        NewActivationExportMgmt.ExportPN10050File(Contract, CPUser, Notes);
        if Customer.get(Contract."Customer No.")then;
        SIILogEntry:=NewSIILogEntry(Customer, Contract, CPUser, Notes, "AAT Log Status SII"::"Exported PN1.0050");
        NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"PN1.0050", true, "SII Detailed Status"::"Created - Awaiting File");
        if PointOfDelivery.Get(Contract."POD No.")then begin
            PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Offer Requested";
            PointOfDelivery.Modify();
        end;
        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"PN1.0050"), SIILogEntry."CP User"));
    end;
    procedure ModifyNewActivationDataVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"PN1.0100", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File PN1.0100";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Offer Accepted";
                PointOfDelivery.Modify();
            end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"PN1.0100", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ModifyNewActivationDataFinalVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"PN1.0150", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File PN1.0150";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Offer Accepted";
                PointOfDelivery.Modify();
            end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"PN1.0150", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ChangeOfNewActivationDataAfterPODInstallation(Contract: Record Contract)
    var
        Customer: Record Customer;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        NewActivationExportMgmt: Codeunit ImportExportManagerActivate;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CPUser: Code[20];
        FileName: Text;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        CPUser:=NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Activation CP User", Today, true);
        FileName:=Format("AAT File Type SII"::"E01.0050") + '_' + CPUser;
        NewActivationExportMgmt.ExportE010050File(Contract, CPUser);
        if Customer.get(Contract."Customer No.")then;
        SIILogEntry:=NewSIILogEntry(Customer, Contract, CPUser, '', "AAT Log Status SII"::"Exported E01.0050");
        NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"E01.0050", true, "SII Detailed Status"::"Created - Awaiting File");
        if PointOfDelivery.Get(Contract."POD No.")then begin
            PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Installation Requested";
            PointOfDelivery.Modify();
        end;
        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"E01.0050"), SIILogEntry."CP User"));
    end;
    procedure ModifyNewActivationDataAfterPODInstallationVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"E01.0100", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File E01.0100";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Installation Accepted";
                PointOfDelivery.Modify();
            end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"E01.0100", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ModifyNewActivationDataAfterPODInstallationFinalVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20]; PODNo: Code[20])
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"E01.0150", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry."POD No.":=PODNo; //KB13122023 - TASK002199 Insert POD
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File E01.0150";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"E01.0150", false, "SII Detailed Status"::Accepted);
        end;
    end;
    //KB20112023 - TASK002131 New Activation Process --- //KB24112023 - TASK002167 Reactivation Process +++
    procedure ChangeOfPODActivationData(Contract: Record Contract)
    var
        Customer: Record Customer;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        NewActivationExportMgmt: Codeunit ImportExportManagerActivate;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CPUser: Code[20];
        FileName: Text;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        CPUser:=NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Activation CP User", Today, true);
        FileName:=Format("AAT File Type SII"::"A01.0050") + '_' + CPUser;
        NewActivationExportMgmt.ExportA010050File(Contract, CPUser, '', Contract."Contract Start Date");
        if Customer.get(Contract."Customer No.")then;
        SIILogEntry:=NewSIILogEntry(Customer, Contract, CPUser, '', "AAT Log Status SII"::"Exported A01.0050");
        NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0050", true, "SII Detailed Status"::"Created - Awaiting File");
        if PointOfDelivery.Get(Contract."POD No.")then begin
            PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Activation Requested";
            PointOfDelivery.Modify();
        end;
        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"A01.0050"), SIILogEntry."CP User"));
    end;
    procedure ModifyActivationDataAfterVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0100", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File A01.0100";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Activation Accepted";
                PointOfDelivery.Modify();
            end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0100", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ModifyActivationAfterFinalVerification(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
        Contract: Record Contract;
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0150", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File A01.0150";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Activation Completed";
                PointOfDelivery.Modify();
            end;
            if Contract.Get(SIILogEntry."Contract No.")then if Contract.Status <> Contract.Status::Open then begin
                    Contract.Validate(Status, Contract.Status::Open);
                    Contract.Modify();
                end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0150", false, "SII Detailed Status"::Accepted);
        end;
    end;
    procedure ModifyActivationAfterFinalVerificationOther(isError: Boolean; SIILogEntry: Record "SII Log Entries"; FileName: Text; ActivationNo: Code[20])
    var
        PointOfDelivery: Record "Point of Delivery";
        Contract: Record Contract;
    begin
        if isError then begin
            SIILogEntry.Status:=SIILogEntry.Status::"Rejected - Created File";
            SIILogEntry.Modify(true);
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0300", false, "SII Detailed Status"::Rejected);
        end
        else
        begin
            SIILogEntry."New Activation No.":=ActivationNo;
            SIILogEntry.Status:=SIILogEntry.Status::"Imported File A01.0300";
            SIILogEntry.Modify(true);
            if PointOfDelivery.Get(SIILogEntry."POD No.")then begin
                PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Activation Completed";
                PointOfDelivery.Modify();
            end;
            if Contract.Get(SIILogEntry."Contract No.")then if Contract.Status <> Contract.Status::Open then begin
                    Contract.Validate(Status, Contract.Status::Open);
                    Contract.Modify();
                end;
            NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0300", false, "SII Detailed Status"::Accepted);
        end;
    end;
    local procedure NewSIILogEntry(Customer: Record Customer; Contract: Record Contract; CPUser: Code[20]; Notes: Text[50]; AATLogStatusSII: Enum "AAT Log Status SII")SIILogEntry: Record "SII Log Entries" begin
        SIILogEntry.Init();
        SIILogEntry.Type:=SIILogEntry.Type::"New Activation";
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Validate("CP User", CPUser);
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", Today());
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Validate(Status, AATLogStatusSII);
        SIILogEntry."New Activation Notes":=Notes;
        SIILogEntry.Insert(true);
    end;
    local procedure NewDetailedSIILogEntry(SIILogEntry: Record "SII Log Entries"; FileName: Text; AATFileTypeSII: Enum "AAT File Type SII"; IsExport: Boolean; Status: Enum "SII Detailed Status")
    var
        DetailedSIILogEntry: Record "Detailed SII Log Entries";
    begin
        DetailedSIILogEntry.Init();
        DetailedSIILogEntry."Log Entry No.":=SIILogEntry."Entry No.";
        DetailedSIILogEntry."Contract No.":=SIILogEntry."Contract No.";
        DetailedSIILogEntry.Filename:=CopyStr(FileName, 1, MaxStrLen(DetailedSIILogEntry.Filename));
        DetailedSIILogEntry.Validate(Date, Today());
        DetailedSIILogEntry.Validate("Initial Upload Date", SIILogEntry."Initial Upload");
        DetailedSIILogEntry.Validate(User, UserId);
        DetailedSIILogEntry.Validate("CP User", SIILogEntry."CP User");
        DetailedSIILogEntry.Validate(Error, false);
        DetailedSIILogEntry."File Type":=AATFileTypeSII;
        DetailedSIILogEntry.Status:=Status;
        if IsExport then DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Upload
        else
            DetailedSIILogEntry.Action:=DetailedSIILogEntry.Action::Download;
        DetailedSIILogEntry.Insert(true);
    end;
    //KB20112023 - TASK002131 New Activation Process --- //KB24112023 - TASK002167 Reactivation Process --- 
    //KB24112023 - TASK002167 Reactivation Process +++
    procedure ChangeOfReActivationData(Contract: Record Contract; Notes: Text[50]; data_ricenzione: Date)
    var
        Customer: Record Customer;
        PointOfDelivery: Record "Point of Delivery";
        SIILogEntry: Record "SII Log Entries";
        SIIInterfaceGeneralSetup: Record "SII Interface General Setup";
        NewActivationExportMgmt: Codeunit ImportExportManagerActivate;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CPUser: Code[20];
        FileName: Text;
        MessageLbl: Label 'The following file has been exported: %1 \\SII Log Entry %2 has been created.', Locked = true;
    begin
        SIIInterfaceGeneralSetup.Get();
        CPUser:=NoSeriesManagement.GetNextNo(SIIInterfaceGeneralSetup."Reactivation CP User", Today, true);
        FileName:=Format("AAT File Type SII"::"A01.0050") + '_' + CPUser;
        NewActivationExportMgmt.ExportA010050File(Contract, CPUser, Notes, data_ricenzione);
        if Customer.get(Contract."Customer No.")then;
        SIILogEntry:=NewSIILogEntryReactivation(Customer, Contract, CPUser, '', "AAT Log Status SII"::"Exported A01.0050");
        NewDetailedSIILogEntry(SIILogEntry, FileName, "AAT File Type SII"::"A01.0050", true, "SII Detailed Status"::"Created - Awaiting File");
        if PointOfDelivery.Get(Contract."POD No.")then begin
            PointOfDelivery."AAT POD Status":=PointOfDelivery."AAT POD Status"::"Activation Requested";
            PointOfDelivery.Modify();
        end;
        Message(StrSubstNo(MessageLbl, Format("AAT File Type SII"::"A01.0050"), SIILogEntry."CP User"));
    end;
    local procedure NewSIILogEntryReactivation(Customer: Record Customer; Contract: Record Contract; CPUser: Code[20]; Notes: Text[50]; AATLogStatusSII: Enum "AAT Log Status SII")SIILogEntry: Record "SII Log Entries" begin
        SIILogEntry.Init();
        SIILogEntry.Type:=SIILogEntry.Type::Reactivation;
        SIILogEntry.Validate("POD No.", Contract."POD No.");
        SIILogEntry.Validate("Contract No.", Contract."No.");
        SIILogEntry.Validate("Customer Name", Customer.Name);
        SIILogEntry.Validate("Fiscal Code", Customer."Fiscal Code");
        SIILogEntry.Validate("VAT Number", Customer."VAT Registration No.");
        SIILogEntry.Validate("CP User", CPUser);
        SIILogEntry.Validate("Initial Upload", Today());
        SIILogEntry.Validate("Effective Date", Today());
        SIILogEntry.Validate(Date, Today());
        SIILogEntry.Validate(Status, AATLogStatusSII);
        SIILogEntry."New Activation Notes":=Notes;
        SIILogEntry.Insert(true);
    end;
    //KB24112023 - TASK002167 Reactivation Process ---
    //KB07122023 - TASK002199 Meter Measurement List Update +++
    procedure MeasurementDataUpdate(Meter: Record Meter; IsInstall: Boolean)
    var
        Measurement: Record Measurement;
    begin
        Measurement.Init();
        Measurement.Validate("POD No.", Meter."POD No.");
        Measurement.Validate("Meter Serial No.", Meter."Serial No.");
        if IsInstall then begin
            Measurement.Date:=Meter."Installation Date";
            Measurement."Measure Date":=Meter."Installation Date";
            Evaluate(Measurement.Month, Format(Measurement."Measure Date", 0, '<Month,2>/<Year4>'));
            Measurement."Active F1":=Meter."Installation F1 Active";
            Measurement."Active F2":=Meter."Installation F2 Active";
            Measurement."Active F3":=Meter."Installation F3 Active";
            Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3";
            Measurement."Reactive F1":=Meter."Installation F1 Reactive";
            Measurement."Reactive F2":=Meter."Installation F2 Reactive";
            Measurement."Reactive F3":=Meter."Installation F3 Reactive";
            Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3";
            Measurement."Peak F1":=Meter."Installation F1 Peak";
            Measurement."Peak F2":=Meter."Installation F2 Peak";
            Measurement."Peak F3":=Meter."Installation F3 Peak";
            // AN 03012024 TASK002297  Added Peak Total to Meansurement +++
            Measurement."Peak Total":=Measurement."Peak F1" + Measurement."Peak F2" + Measurement."Peak F3";
            // AN 03012024 TASK002297  Added Peak Total to Meansurement +++
            Measurement.Insert();
        end
        else
        begin
            Measurement.Date:=Meter."Reactivation Date";
            Measurement."Measure Date":=Meter."Reactivation Date";
            Evaluate(Measurement.Month, Format(Measurement."Measure Date", 0, '<Month,2>/<Year4>'));
            Measurement."Active F1":=Meter."Reactivation F1 Active";
            Measurement."Active F2":=Meter."Reactivation F2 Active";
            Measurement."Active F3":=Meter."Reactivation F3 Active";
            Measurement."Active Total":=Measurement."Active F1" + Measurement."Active F2" + Measurement."Active F3";
            Measurement."Reactive F1":=Meter."Reactivation F1 Reactive";
            Measurement."Reactive F2":=Meter."Reactivation F2 Reactive";
            Measurement."Reactive F3":=Meter."Reactivation F3 Reactive";
            Measurement."Reactive Total":=Measurement."Reactive F1" + Measurement."Reactive F2" + Measurement."Reactive F3";
            Measurement."Peak F1":=Meter."Reactivation F1 Peak";
            Measurement."Peak F2":=Meter."Reactivation F2 Peak";
            Measurement."Peak F3":=Meter."Reactivation F3 Peak";
            Measurement.Insert();
        end;
    end;
//KB07122023 - TASK002199 Meter Measurement List Update ---
}
