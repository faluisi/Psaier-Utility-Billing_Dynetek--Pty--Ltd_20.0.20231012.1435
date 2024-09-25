page 50238 "Measurement Detail List Part"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Measurement;
    Caption = 'Measurement Detail List Part';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    Caption = 'Month';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Editable = EditDetails;
                    Caption = 'POD No.';
                }
                field("Active Constant"; Rec."Active Constant")
                {
                    ToolTip = 'Specifies the value of the Active Constant field.';
                    Editable = EditDetails;
                    Caption = 'Active Constant';
                }
                field("Active F1"; Rec."Active F1")
                {
                    ToolTip = 'Specifies the value of the Active F1 field.';
                    Editable = EditDetails;
                    Caption = 'Active F1';
                }
                field("Active F2"; Rec."Active F2")
                {
                    ToolTip = 'Specifies the value of the Active F2 field.';
                    Editable = EditDetails;
                    Caption = 'Active F2';
                }
                field("Active F3"; Rec."Active F3")
                {
                    ToolTip = 'Specifies the value of the Active F3 field.';
                    Editable = EditDetails;
                    Caption = 'Active F3';
                }
                field("Active F4"; Rec."Active F4")
                {
                    ToolTip = 'Specifies the value of the Active F4 field.';
                    Editable = EditDetails;
                    Caption = 'Active F4';
                }
                field("Active F5"; Rec."Active F5")
                {
                    ToolTip = 'Specifies the value of the Active F5 field.';
                    Editable = EditDetails;
                    Caption = 'Active F5';
                }
                field("Active F6"; Rec."Active F6")
                {
                    ToolTip = 'Specifies the value of the Active F6 field.';
                    Editable = EditDetails;
                    Caption = 'Active F6';
                }
                field("Active Total"; Rec."Active Total")
                {
                    ToolTip = 'Specifies the value of the Active Total field.';
                    Editable = EditDetails;
                    Caption = 'Active Total';
                }
                field("Activiation Date"; Rec."Activiation Date")
                {
                    ToolTip = 'Specifies the value of the Activiation Date field.';
                    Caption = 'Activiation Date';
                }
                field(CL; Rec.CL)
                {
                    ToolTip = 'Specifies the value of the CL field.';
                    Editable = EditDetails;
                    Caption = 'CL';
                }
                field(Collection; Rec.Collection)
                {
                    ToolTip = 'Specifies the value of the Collection field.';
                    Editable = EditDetails;
                    Caption = 'Collection';
                }
                field("Corrected By Entry"; Rec."Corrected By Entry")
                {
                    ToolTip = 'Specifies the value of the Corrected By Entry field.';
                    Editable = EditDetails;
                    Caption = 'Corrected By Entry';
                }
                field("Corrected Entry"; Rec."Corrected Entry")
                {
                    ToolTip = 'Specifies the value of the Corrected Entry field.';
                    Editable = EditDetails;
                    Caption = 'Corrected Entry';
                }
                field("Data Type"; Rec."Data Type")
                {
                    ToolTip = 'Specifies the value of the Data Type field.';
                    Editable = EditDetails;
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
                    Editable = EditDetails;
                    Caption = 'Date Detection';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry no. field.';
                    Editable = EditDetails;
                    Caption = 'Entry No.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                    Editable = EditDetails;
                    Caption = 'File Name';
                }
                field("Flat Rate"; Rec."Flat Rate")
                {
                    ToolTip = 'Specifies the value of the Flat Rate field.';
                    Editable = EditDetails;
                    Caption = 'Flat Rate';
                }
                field("Flow Code"; Rec."Flow Code")
                {
                    ToolTip = 'Specifies the value of the Flow Code field.';
                    Editable = EditDetails;
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
                    Editable = EditDetails;
                    Caption = 'Import Error';
                }
                field("Import Notes"; Rec."Import Notes")
                {
                    ToolTip = 'Specifies the value of the Errors while Importing field.';
                    Editable = EditDetails;
                    Caption = 'Import Notes';
                }
                field("Import Status"; Rec."Import Status")
                {
                    ToolTip = 'Specifies the value of the Import Status field.';
                    Editable = EditDetails;
                    Caption = 'Import Status';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    Editable = EditDetails;
                    Caption = 'Invoice No.';
                }
                field("Latest Measurement"; Rec."Latest Measurement")
                {
                    ToolTip = 'Specifies the value of the Latest Measurement field.';
                    Editable = EditDetails;
                    Caption = 'Latest Measurement';
                }
                field(LE; Rec.LE)
                {
                    ToolTip = 'Specifies the value of the LE field.';
                    Editable = EditDetails;
                    Caption = 'LE';
                }
                field("Measure Date"; Rec."Measure Date")
                {
                    ToolTip = 'Specifies the value of the Measure Date field.';
                    Editable = EditDetails;
                    Caption = 'Measure Date';
                }
                field("Measurement Frequency"; Rec."Measurement Frequency")
                {
                    ToolTip = 'Specifies the value of the Measurement Frequency field.';
                    Editable = EditDetails;
                    Caption = 'Measurement Frequency';
                }
                field("Measurement Group"; Rec."Measurement Group")
                {
                    ToolTip = 'Specifies the value of the Measurement Group field.';
                    Editable = EditDetails;
                    Caption = 'Measurement Group';
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Editable = EditDetails;
                    Caption = 'Meter Serial No.';
                }
                field("Motivation Estimate"; Rec."Motivation Estimate")
                {
                    ToolTip = 'Specifies the value of the Motivation Estimate field.';
                    Editable = EditDetails;
                    Caption = 'Motivation Estimate';
                }
                field(Motiviation; Rec.Motiviation)
                {
                    ToolTip = 'Specifies the value of the Motiviation field.';
                    Editable = EditDetails;
                    Caption = 'Motiviation';
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    Editable = EditDetails;
                    Caption = 'Note';
                }
                field("Peak F1"; Rec."Peak F1")
                {
                    ToolTip = 'Specifies the value of the Peak F1 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F1';
                }
                field("Peak F2"; Rec."Peak F2")
                {
                    ToolTip = 'Specifies the value of the Peak F2 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F2';
                }
                field("Peak F3"; Rec."Peak F3")
                {
                    ToolTip = 'Specifies the value of the Peak F3 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F3';
                }
                field("Peak F4"; Rec."Peak F4")
                {
                    ToolTip = 'Specifies the value of the Peak F4 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F4';
                }
                field("Peak F5"; Rec."Peak F5")
                {
                    ToolTip = 'Specifies the value of the Peak F5 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F5';
                }
                field("Peak F6"; Rec."Peak F6")
                {
                    ToolTip = 'Specifies the value of the Peak F6 field.';
                    Editable = EditDetails;
                    Caption = 'Peak F6';
                }
                field("Peak Total"; Rec."Peak Total")
                {
                    ToolTip = 'Specifies the value of the Peak Total field.';
                    Editable = EditDetails;
                    Caption = 'Peak Total';
                }
                field("Power Constant"; Rec."Power Constant")
                {
                    ToolTip = 'Specifies the value of the Power Constant field.';
                    Editable = EditDetails;
                    Caption = 'Power Constant';
                }
                field("Reactive Constant"; Rec."Reactive Constant")
                {
                    ToolTip = 'Specifies the value of the Reactive Constant field.';
                    Editable = EditDetails;
                    Caption = 'Reactive Constant';
                }
                field("Reactive F1"; Rec."Reactive F1")
                {
                    ToolTip = 'Specifies the value of the Reactive F1 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F1';
                }
                field("Reactive F2"; Rec."Reactive F2")
                {
                    ToolTip = 'Specifies the value of the Reactive F2 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F2';
                }
                field("Reactive F3"; Rec."Reactive F3")
                {
                    ToolTip = 'Specifies the value of the Reactive F3 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F3';
                }
                field("Reactive F4"; Rec."Reactive F4")
                {
                    ToolTip = 'Specifies the value of the Reactive F4 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F4';
                }
                field("Reactive F5"; Rec."Reactive F5")
                {
                    ToolTip = 'Specifies the value of the Reactive F5 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F5';
                }
                field("Reactive F6"; Rec."Reactive F6")
                {
                    ToolTip = 'Specifies the value of the Reactive F6 field.';
                    Editable = EditDetails;
                    Caption = 'Reactive F6';
                }
                field("Reactive Total"; Rec."Reactive Total")
                {
                    ToolTip = 'Specifies the value of the Reactive Total field.';
                    Editable = EditDetails;
                    Caption = 'Reactive Total';
                }
                field("SII Code"; Rec."SII Code")
                {
                    ToolTip = 'Specifies the value of the SII Code field.';
                    Editable = EditDetails;
                    Caption = 'SII Code';
                }
                field(SM; Rec.SM)
                {
                    ToolTip = 'Specifies the value of the SM field.';
                    Editable = EditDetails;
                    Caption = 'SM';
                }
                field(TL; Rec.TL)
                {
                    ToolTip = 'Specifies the value of the TL field.';
                    Editable = EditDetails;
                    Caption = 'TL';
                }
                field("Type of Measure"; Rec."Type of Measure")
                {
                    ToolTip = 'Specifies the value of the Type of Measure field.';
                    Editable = EditDetails;
                    Caption = 'Type of Measure';
                }
                field(Validated; Rec.Validated)
                {
                    ToolTip = 'Specifies the value of the Validated field.';
                    Editable = EditDetails;
                    Caption = 'Validated';
                }
                field(Voltage; Rec.Voltage)
                {
                    ToolTip = 'Specifies the value of the Voltage field.';
                    Editable = EditDetails;
                    Caption = 'Voltage';
                }
                field("XML File"; Rec."XML File")
                {
                    ToolTip = 'Specifies the value of the XML File field.';
                    Editable = EditDetails;
                    Caption = 'XML File';
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    Editable = EditDetails;
                    Caption = 'Year';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Retrieve Measurement File")
            {
                ToolTip = 'Downloads the Measurement XML file';
                Caption = 'Retrieve Measurement File';

                trigger OnAction()
                var
                    FileInStream: InStream;
                begin
                    Rec.CalcFields("XML File");
                    Rec."XML File".CreateInStream(FileInStream);
                    File.DownloadFromStream(FileInStream, '', '', '.xml', Rec."File Name");
                end;
            }
            action("Edit Record")
            {
                Caption = 'Edit Record';
                ToolTip = 'Executes the Edit Record action.';

                trigger OnAction()
                var
                // Measurement: Record Measurement;
                // MeasurementDetailListPart: Page "Measurement Detail List Part";
                begin
                    EditDetails:=false;
                    Page.RunModal(Page::"Measurement Detail List Part", Rec);
                end;
            }
        }
    }
    var EditDetails: Boolean;
}
