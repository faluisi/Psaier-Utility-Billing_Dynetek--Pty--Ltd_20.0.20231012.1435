codeunit 50210 "Est. and Plausibility Mgt."
{
    trigger OnRun()
    begin
    end;
    /// <summary>
    /// Estimate.
    /// </summary>
    /// <param name="Measurement">Record "Measurement".</param>
    procedure Estimate(Measurement: Record "Measurement")
    var
        Measurement2: Record Measurement;
        EarliestStartDate: Date;
        ListofMonths: Dictionary of[Integer, Integer];
        DictionaryKey: Integer;
        ShowMessage: Boolean;
        Counter: Integer;
        SuccessLabelMsg: Label 'Estimation Success.\\POD: %1\Records Added: %2', Locked = true;
    begin
        EstimateDialog.Open('Estimating...\' + 'POD No.   #1##########\' /* +
                    'Counter  #2##########\'*/);
        Measurement2.SetRange("POD No.", Measurement."POD No.");
        EarliestStartDate:=CalcDate('<-10M>', Measurement."Month");
        Measurement2.SetRange("Month", EarliestStartDate, Today);
        if Measurement2.FindSet()then begin
            PopulateListOfMonths(ListofMonths);
            repeat ListofMonths.Set((Date2DMY(Measurement2.Month, 2)), (Date2DMY(Measurement2.Month, 3)));
                if not ListofMonths.Remove((Date2DMY(Measurement2.Month, 2)))then;
            until Measurement2.Next() = 0;
            foreach DictionaryKey in ListofMonths.Keys do begin
                EstimateforMonth(Measurement, DictionaryKey, ListofMonths.Get(DictionaryKey));
                EstimateDialog.Update(1, Measurement."POD No.");
                Counter+=1;
                ShowMessage:=true;
            end;
            if ShowMessage then Message(StrSubstNo(SuccessLabelMsg, Measurement."POD No.", Counter));
        end;
        EstimateDialog.Close(); // close estimate dialog
    end;
    local procedure EstimateforMonth(Measurement: Record Measurement; IntegerMonth: Integer; IntegerYear: Integer)
    var
        PointOfDelivery: Record "Point of Delivery";
        Measurement2: Record Measurement;
        Measurement3: Record Measurement;
        TempMeasurementEstimation: Record "Measurement Estimation" temporary;
        EstimateMonth: Date;
        EstimationMonthFilters: Date;
        Counter: Integer;
        MonthDifference: Decimal;
        Estimation: Decimal;
    begin
        IntegerYear:=CheckYear(IntegerMonth, IntegerYear);
        Evaluate(EstimateMonth, Format(DMY2Date(1, IntegerMonth, IntegerYear)));
        EstimationMonthFilters:=EstimateMonth;
        Measurement2.SetRange("POD No.", Measurement."POD No.");
        Measurement2.SetRange("Latest Measurement", false);
        Clear(Measurement2);
        Measurement2.SetRange("POD No.", Measurement."POD No.");
        Measurement2.SetRange(Month, EstimateMonth);
        if Measurement2.FindSet()then begin
            repeat if(Date2DMY(Measurement2.Month, 2) = IntegerMonth) or (Date2DMY(Measurement2.Month, 2) = IntegerMonth - 1)then begin
                    Clear(TempMeasurementEstimation);
                    TempMeasurementEstimation.Init();
                    TempMeasurementEstimation.Month:=Date2DMY(Measurement2."Import Date", 2);
                    TempMeasurementEstimation.Year:=Date2DMY(Measurement2."Import Date", 3);
                    TempMeasurementEstimation.Consumptions:=Measurement2."Peak Total";
                    Counter+=1;
                    if Counter mod 2 = 0 then MonthDifference:=MonthDifference - TempMeasurementEstimation.Consumptions
                    else
                        MonthDifference:=MonthDifference + TempMeasurementEstimation.Consumptions;
                    TempMeasurementEstimation.Insert(true);
                    Commit();
                end;
            until Measurement2.Next() = 0;
            if MonthDifference <> 0 then begin
                Estimation:=(MonthDifference / Counter);
                Measurement3.SetRange("POD No.", Measurement."POD No.");
                if IntegerMonth <> 1 then Measurement3.SetFilter(Month, Format(CalcDate('<-1M>', EstimationMonthFilters)))
                else
                    Measurement3.SetFilter(Month, Format(DMY2Date(1, 12, IntegerYear)));
                if Measurement3.FindFirst()then Estimation:=Estimation + Measurement3."Peak Total";
                InsertNewMeasurementEntry(Measurement2, Estimation, EstimateMonth);
            end end
        else
        begin
            PointOfDelivery.SetRange("No.", Measurement."POD No.");
            if PointOfDelivery.FindFirst()then begin
                PointOfDelivery.TestField("Consumption Constant");
                Estimation:=PointOfDelivery."Consumption Constant" / 12;
                Measurement3.SetRange("POD No.", Measurement."POD No.");
                if IntegerMonth <> 1 then Measurement3.SetFilter(Month, Format(CalcDate('<-1M>', EstimationMonthFilters)))
                else
                    Measurement3.SetFilter(Month, Format(DMY2Date(1, 12, IntegerYear)));
                if Measurement3.FindFirst()then begin
                    Clear(Estimation);
                    Estimation:=Estimation + Measurement3."Peak Total";
                end;
                InsertNewMeasurementEntry(Measurement, Estimation, EstimateMonth);
            end;
        end;
    end;
    local procedure PopulateListOfMonths(var Months: Dictionary of[Integer, Integer])
    var
    begin
        Months.Add(1, Date2DMY(Today, 3));
        Months.Add(2, Date2DMY(Today, 3));
        Months.Add(3, Date2DMY(Today, 3));
        Months.Add(4, Date2DMY(Today, 3));
        Months.Add(5, Date2DMY(Today, 3));
        Months.Add(6, Date2DMY(Today, 3));
        Months.Add(7, Date2DMY(Today, 3));
        Months.Add(8, Date2DMY(Today, 3));
        Months.Add(9, Date2DMY(Today, 3));
        Months.Add(10, Date2DMY(Today, 3));
        Months.Add(12, Date2DMY(Today, 3));
    end;
    local procedure InsertNewMeasurementEntry(Measurement: Record Measurement; Estimation: Decimal; EstimateMonth: Date)
    var
        Measurement2: Record Measurement;
        Measurement3: Record Measurement;
    begin
        Measurement2.Init();
        Measurement2."Peak Total":=Estimation;
        Measurement2.Month:=EstimateMonth;
        Measurement2."Import Notes":='Estimation';
        Measurement2."File Name":='Estimation';
        Measurement2."POD No.":=Measurement."POD No.";
        Measurement2."Meter Serial No.":=Measurement."Meter Serial No.";
        Measurement2."Flow Code":=Measurement."Flow Code";
        Measurement2."Measure Date":=Today();
        Measurement3.SetRange("POD No.", Measurement."POD No.");
        Measurement3.SetRange("Latest Measurement", true);
        if Measurement3.FindFirst()then if Measurement3.Month < Measurement2.Month then begin
                Measurement2."Latest Measurement":=true;
                Measurement3."Latest Measurement":=false;
                Measurement3.Modify(true);
            end;
        Measurement2.Insert(true);
    end;
    local procedure CheckYear(Month: Integer; Year: Integer): Integer var
        DatetoCheck: Date;
    begin
        Evaluate(DatetoCheck, Format(DMY2Date(1, Month, Year)));
        if DatetoCheck > Today()then Year:=Year - 1;
        exit(Year);
    end;
    var EstimateDialog: Dialog;
}
