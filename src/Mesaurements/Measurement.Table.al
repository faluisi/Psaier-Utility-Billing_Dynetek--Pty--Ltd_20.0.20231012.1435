table 50212 Measurement
{
    DrillDownPageID = "Measurement List Page";
    LookupPageID = "Measurement List Page";
    Caption = 'Measurement';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(5; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(10; "POD No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(15; "Meter Serial No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Meter."Serial No.";
            Caption = 'Meter Serial No.';
        }
        field(20; "Flow Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Flow Code';
        }
        field(30; "Active Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active Total';
        }
        field(31; "Active F1"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F1';
        }
        field(32; "Active F2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F2';
        }
        field(33; "Active F3"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F3';
        }
        field(34; "Active F4"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F4';
        }
        field(35; "Active F5"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F5';
        }
        field(36; "Active F6"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active F6';
        }
        field(40; "Reactive Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive Total';
        }
        field(41; "Reactive F1"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F1';
        }
        field(42; "Reactive F2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F2';
        }
        field(43; "Reactive F3"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F3';
        }
        field(44; "Reactive F4"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F4';
        }
        field(45; "Reactive F5"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F5';
        }
        field(46; "Reactive F6"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive F6';
        }
        field(50; "Peak Total"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak Total';
        }
        field(51; "Peak F1"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F1';
        }
        field(52; "Peak F2"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F2';
        }
        field(53; "Peak F3"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F3';
        }
        field(54; "Peak F4"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F4';
        }
        field(55; "Peak F5"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F5';
        }
        field(56; "Peak F6"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Peak F6';
        }
        field(70; SM; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'SM';
        }
        field(71; LE; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'LE';
        }
        field(72; TL; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'TL';
        }
        field(73; CL; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CL';
        }
        field(80; Note; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Note';
        }
        field(85; "Invoice No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice No.';
        }
        field(100; "Import Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Import Date';
        }
        field(101; "File Name"; Text[150])
        {
            DataClassification = CustomerContent;
            Caption = 'File Name';
        }
        field(102; Year; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Year';
        }
        field(105; "SII Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'SII Code';
        }
        field(107; "Corrected By Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Corrected By Entry';
        }
        field(109; "Corrected Entry"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Corrected Entry';
        }
        field(112; "Latest Measurement"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Latest Measurement';
        }
        field(113; "Month"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Month';
        }
        field(115; "Type of Measure"; Code[2])
        {
            DataClassification = CustomerContent;
            Caption = 'Type of Measure';
        }
        field(117; "Active Constant"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Active Constant';
        }
        field(119; "Reactive Constant"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Reactive Constant';
        }
        field(121; "Power Constant"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Power Constant';
        }
        field(123; "Voltage"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Voltage';
        }
        field(125; "Flat Rate"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Flat Rate';
        }
        field(127; "Date Detection"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Detection';
        }
        field(130; "Motiviation"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Motiviation';
        }
        field(132; "Measure Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Measure Date';
        }
        field(134; "Activiation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Activiation Date';
        }
        field(136; "Measurement Frequency"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Measurement Frequency';
        }
        field(138; "Measurement Group"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Measurement Group';
        }
        field(140; "Collection"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Collection';
        }
        field(142; "Data Type"; Code[5])
        {
            DataClassification = CustomerContent;
            Caption = 'Data Type';
        }
        field(144; "Motivation Estimate"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Motivation Estimate';
        }
        field(146; "Validated"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Validated';
        }
        field(148; "Import Status";Enum "Measurement Import Status")
        {
            DataClassification = CustomerContent;
            Caption = 'Import Status';
        }
        field(150; "Import Error"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Import Error';
        }
        field(155; "Import Notes"; Text[1000])
        {
            DataClassification = CustomerContent;
            Caption = 'Import Notes';
        }
        field(160; "XML File"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'XML File';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(SK; "File Name", Month)
        {
        }
        key(SK2; "POD No.", "Meter Serial No.", Date)
        {
            SumIndexFields = "Active F1", "Active F2", "Active F3", "Reactive F1", "Reactive F2", "Reactive F3";
        }
    }
    fieldgroups
    {
    }
    trigger OnDelete()
    var
        MeasurementHourlyDetail: Record "Measurement Hourly Detail";
    begin
        MeasurementHourlyDetail.Reset();
        MeasurementHourlyDetail.SetRange("Measurement Entry No.", Rec."Entry No.");
        if MeasurementHourlyDetail.FindSet()then MeasurementHourlyDetail.DeleteAll();
    end;
    /// <summary>
    /// ApproveMeaurementEntry.
    /// </summary>
    procedure ApproveMeasurementEntry()
    var
        Measurement2: Record Measurement;
    begin
        Rec."Import Error":=false;
        Rec."Import Notes":='Measurement Import Approved';
        Measurement2.SetRange("POD No.", Rec."POD No.");
        Measurement2.SetRange("Latest Measurement", true);
        if Measurement2.FindFirst()then begin
            Measurement2."Latest Measurement":=false;
            Rec."Latest Measurement":=true;
            Measurement2.Modify(true);
        end
        else
            Rec."Latest Measurement":=true;
        if not Rec.Modify(true)then Rec.Insert(true);
    end;
}
