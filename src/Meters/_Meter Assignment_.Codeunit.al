codeunit 50216 "Meter Assignment"
{
    TableNo = Meter;

    local procedure SetAssignedMeter()
    var
        AssignedMeter: Record "Point of Delivery - Meter Hist";
        AssignedMeter2: Record "Point of Delivery - Meter Hist";
        Meter2: Record Meter;
        POD2: Record "Point of Delivery";
    begin
        AssignedMeter2.SetRange("POD No.", Meter."POD No.");
        AssignedMeter2.SetFilter("Deactivation Date", '=%1', 0D);
        AssignedMeter2.SetCurrentKey("Activation Date");
        if AssignedMeter2.FindLast()then begin
            AssignedMeter2.Validate("Deactivation Date", PODMeterHist."Activation Date" - 1);
            AssignedMeter2.Validate(Active, false);
            AssignedMeter2.Modify(true);
            if Meter2.Get(AssignedMeter2."Meter Serial No.")then begin
                Clear(Meter2."POD No.");
                Meter2.Modify(true);
            end;
        end;
        AssignedMeter.Init();
        AssignedMeter.Validate("Meter Serial No.", PODMeterHist."Meter Serial No.");
        AssignedMeter.Validate("POD No.", Meter."POD No.");
        AssignedMeter.Validate("Activation Date", PODMeterHist."Activation Date");
        AssignedMeter.Validate(Active, true);
        if AssignedMeter.Insert(true) or AssignedMeter.Modify(true)then begin
            POD2.Get(Meter."POD No.");
            POD2."Meter Serial No.":=PODMeterHist."Meter Serial No.";
            if POD2.Modify(true)then;
        end;
    end;
    /// <summary>
    /// GetAssignedMeter.
    /// </summary>
    /// <param name="POD">Record "Point of Delivery".</param>
    local procedure GetAssignedMeter(var POD: Record "Point of Delivery")
    begin
        Meter.Validate("POD No.", POD."No.");
    end;
    /// <summary>
    /// OpenPage.
    /// </summary>
    /// <param name="POD">Record "Point of Delivery".</param>
    procedure OpenPage(var POD: Record "Point of Delivery")
    var
        MeterAssigmentCardPage: Page "Meter Assigment Card Page";
    begin
        MeterAssigmentCardPage.LookupMode(true);
        if MeterAssigmentCardPage.RunModal() = Action::LookupOK then begin
            PODMeterHist:=MeterAssigmentCardPage.GetPODMeterHistRecord();
            if PODMeterHist."Activation Date" = 0D then PODMeterHist."Activation Date":=Today();
            PODMeterHist.TestField("Activation Date");
            Meter.Get(PODMeterHist."Meter Serial No.");
            GetAssignedMeter(POD);
            Meter.Modify(true);
            SetAssignedMeter();
        end;
    end;
    var Meter: Record Meter;
    PODMeterHist: Record "Point of Delivery - Meter Hist";
}
