page 70201 "ALL Measurement List for POD"
{
    //KB30112023 - TASK002171 Measurement Upload Process +++
    Caption = 'ALL Measurement Details';
    PageType = List;
    SourceTable = Measurement;
    Editable = false;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    Caption = 'Month';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Active F1"; Rec."Active F1")
                {
                    ToolTip = 'Specifies the value of the Active F1 field.';
                    Caption = 'Active F1';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ActiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F1);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Active F2"; Rec."Active F2")
                {
                    ToolTip = 'Specifies the value of the Active F2 field.';
                    Caption = 'Active F2';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ActiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F2);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Active F3"; Rec."Active F3")
                {
                    ToolTip = 'Specifies the value of the Active F3 field.';
                    Caption = 'Active F3';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ActiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F3);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Active F4"; Rec."Active F4")
                {
                    ToolTip = 'Specifies the value of the Active F4 field.';
                    Caption = 'Active F4';
                }
                field("Active F5"; Rec."Active F5")
                {
                    ToolTip = 'Specifies the value of the Active F5 field.';
                    Caption = 'Active F5';
                }
                field("Active F6"; Rec."Active F6")
                {
                    ToolTip = 'Specifies the value of the Active F6 field.';
                    Caption = 'Active F6';
                }
                field("Active Total"; Rec."Active Total")
                {
                    ToolTip = 'Specifies the value of the Active Total field.';
                    Caption = 'Active Total';
                }
                field("Reactive F1"; Rec."Reactive F1")
                {
                    ToolTip = 'Specifies the value of the Reactive F1 field.';
                    Caption = 'Reactive F1';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ReactiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F1);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Reactive F2"; Rec."Reactive F2")
                {
                    ToolTip = 'Specifies the value of the Reactive F2 field.';
                    Caption = 'Reactive F2';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ReactiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F2);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Reactive F3"; Rec."Reactive F3")
                {
                    ToolTip = 'Specifies the value of the Reactive F3 field.';
                    Caption = 'Reactive F3';

                    trigger OnDrillDown()
                    var
                        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                    begin
                        MeasurementHourlyDetail.Reset();
                        MeasurementHourlyDetail.FilterGroup(2);
                        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
                        MeasurementHourlyDetail.SetRange(Type, ReactiveLbl);
                        MeasurementHourlyDetail.SetRange("Fascia Type", MeasurementHourlyDetail."Fascia Type"::F3);
                        MeasurementHourlyDetail.FilterGroup(0);
                        if MeasurementHourlyDetail.FindSet()then Page.Run(page::"Measurement Hourly Detail", MeasurementHourlyDetail)
                        else
                            Error(HourlyDetailError);
                    end;
                }
                field("Reactive F4"; Rec."Reactive F4")
                {
                    ToolTip = 'Specifies the value of the Reactive F4 field.';
                    Caption = 'Reactive F4';
                }
                field("Reactive F5"; Rec."Reactive F5")
                {
                    ToolTip = 'Specifies the value of the Reactive F5 field.';
                    Caption = 'Reactive F5';
                }
                field("Reactive F6"; Rec."Reactive F6")
                {
                    ToolTip = 'Specifies the value of the Reactive F6 field.';
                    Caption = 'Reactive F6';
                }
                field("Reactive Total"; Rec."Reactive Total")
                {
                    ToolTip = 'Specifies the value of the Reactive Total field.';
                    Caption = 'Reactive Total';
                }
                field("Peak F1"; Rec."Peak F1")
                {
                    ToolTip = 'Specifies the value of the Peak F1 field.';
                    Caption = 'Peak F1';
                }
                field("Peak F2"; Rec."Peak F2")
                {
                    ToolTip = 'Specifies the value of the Peak F2 field.';
                    Caption = 'Peak F2';
                }
                field("Peak F3"; Rec."Peak F3")
                {
                    ToolTip = 'Specifies the value of the Peak F3 field.';
                    Caption = 'Peak F3';
                }
                field("Peak F4"; Rec."Peak F4")
                {
                    ToolTip = 'Specifies the value of the Peak F4 field.';
                    Caption = 'Peak F4';
                }
                field("Peak F5"; Rec."Peak F5")
                {
                    ToolTip = 'Specifies the value of the Peak F5 field.';
                    Caption = 'Peak F5';
                }
                field("Peak F6"; Rec."Peak F6")
                {
                    ToolTip = 'Specifies the value of the Peak F6 field.';
                    Caption = 'Peak F6';
                }
                field("Peak Total"; Rec."Peak Total")
                {
                    ToolTip = 'Specifies the value of the Peak Total field.';
                    Caption = 'Peak Total';
                }
                field("Activiation Date"; Rec."Activiation Date")
                {
                    ToolTip = 'Specifies the value of the Activiation Date field.';
                    Caption = 'Activiation Date';
                }
                field(CL; Rec.CL)
                {
                    ToolTip = 'Specifies the value of the CL field.';
                    Caption = 'CL';
                }
                field(Collection; Rec.Collection)
                {
                    ToolTip = 'Specifies the value of the Collection field.';
                    Caption = 'Collection';
                }
                field("Corrected By Entry"; Rec."Corrected By Entry")
                {
                    ToolTip = 'Specifies the value of the Corrected By Entry field.';
                    Caption = 'Corrected By Entry';
                }
                field("Corrected Entry"; Rec."Corrected Entry")
                {
                    ToolTip = 'Specifies the value of the Corrected Entry field.';
                    Caption = 'Corrected Entry';
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.';
                    Caption = 'Data Type';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("Date Detection"; Rec."Date Detection")
                {
                    ToolTip = 'Specifies the value of the Date Detection field.';
                    Caption = 'Date Detection';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry no. field.';
                    Caption = 'Entry No.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                    Caption = 'File Name';
                }
                field("Flat Rate"; Rec."Flat Rate")
                {
                    ToolTip = 'Specifies the value of the Flat Rate field.';
                    Caption = 'Flat Rate';
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ToolTip = 'Specifies the value of the Flow Code field.';
                    Caption = 'Flow Code';
                }
                field("Import Date"; Rec."Import Date")
                {
                    ToolTip = 'Specifies the value of the Import Date field.';
                    Caption = 'Import Date';
                }
                field("Import Error"; Rec."Import Error")
                {
                    ToolTip = 'Specifies the value of the Import Error field.';
                    Caption = 'Import Error';
                }
                field("Import Notes"; Rec."Import Notes")
                {
                    ToolTip = 'Specifies the value of the Errors while Importing field.';
                    Caption = 'Import Notes';
                }
                field("Import Status"; Rec."Import Status")
                {
                    ToolTip = 'Specifies the value of the Import Status field.';
                    Caption = 'Import Status';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    Caption = 'Invoice No.';
                }
                field("Latest Measurement"; Rec."Latest Measurement")
                {
                    ToolTip = 'Specifies the value of the Latest Measurement field.';
                    Caption = 'Latest Measurement';
                }
                field(LE; Rec.LE)
                {
                    ToolTip = 'Specifies the value of the LE field.';
                    Caption = 'LE';
                }
                field("Measure Date"; Rec."Measure Date")
                {
                    ToolTip = 'Specifies the value of the Measure Date field.';
                    Caption = 'Measure Date';
                }
                field("Measurement Frequency"; Rec."Measurement Frequency")
                {
                    ToolTip = 'Specifies the value of the Measurement Frequency field.';
                    Caption = 'Measurement Frequency';
                }
                field("Measurement Group"; Rec."Measurement Group")
                {
                    ToolTip = 'Specifies the value of the Measurement Group field.';
                    Caption = 'Measurement Group';
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Caption = 'Meter Serial No.';
                }
                field("Motivation Estimate"; Rec."Motivation Estimate")
                {
                    ToolTip = 'Specifies the value of the Motivation Estimate field.';
                    Caption = 'Motivation Estimate';
                }
                field(Motiviation; Rec.Motiviation)
                {
                    ToolTip = 'Specifies the value of the Motiviation field.';
                    Caption = 'Motiviation';
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    Caption = 'Note';
                }
                field("Active Constant"; Rec."Active Constant")
                {
                    ToolTip = 'Specifies the value of the Active Constant field.';
                    Caption = 'Active Constant';
                }
                field("Power Constant"; Rec."Power Constant")
                {
                    ToolTip = 'Specifies the value of the Power Constant field.';
                    Caption = 'Power Constant';
                }
                field("Reactive Constant"; Rec."Reactive Constant")
                {
                    ToolTip = 'Specifies the value of the Reactive Constant field.';
                    Caption = 'Reactive Constant';
                }
                field("SII Code"; Rec."SII Code")
                {
                    ToolTip = 'Specifies the value of the SII Code field.';
                    Caption = 'SII Code';
                }
                field(SM; Rec.SM)
                {
                    ToolTip = 'Specifies the value of the SM field.';
                    Caption = 'SM';
                }
                field(TL; Rec.TL)
                {
                    ToolTip = 'Specifies the value of the TL field.';
                    Caption = 'TL';
                }
                field("Type of Measure"; Rec."Type of Measure")
                {
                    ToolTip = 'Specifies the value of the Type of Measure field.';
                    Caption = 'Type of Measure';
                }
                field(Validated; Rec.Validated)
                {
                    ToolTip = 'Specifies the value of the Validated field.';
                    Caption = 'Validated';
                }
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                    Caption = 'Voltage';
                }
                field("XML File"; Rec."XML File")
                {
                    ToolTip = 'Specifies the value of the XML File field.';
                    Caption = 'XML File';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    Caption = 'Year';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export Measurement File")
            {
                ToolTip = 'Exports the selected Measurment File';
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Export;
                Caption = 'Export Measurement File';

                trigger OnAction()
                var
                    Instream: InStream;
                begin
                    if Rec."Import Notes" = 'Estimation' then begin
                        Rec."XML File".CreateInStream(Instream);
                        File.DownloadFromStream(InStream, 'Measurement File', '', '.xml', Rec."File Name");
                    end;
                end;
            }
            action("Estimate for Missing Month")
            {
                ToolTip = 'Finds the missing month in the Measurements to estimate for that month';
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCalendar;
                Caption = 'Estimate for Missing Month';

                trigger OnAction()
                var
                    EstimationsMgt: Codeunit "Est. and Plausibility Mgt.";
                begin
                    EstimationsMgt.Estimate(Rec);
                end;
            }
        }
    }
    var ReactiveLbl: Label 'Reactive';
    ActiveLbl: Label 'Active';
    HourlyDetailError: Label 'There is no Hourly details to show.';
//KB30112023 - TASK002171 Measurement Upload Process ---
}
