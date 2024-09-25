page 50220 "Measurement List Page"
{
    PageType = List;
    SourceTable = Measurement;
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Measurement List Page';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry no. field.';
                    Caption = 'Entry No.';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Caption = 'Meter Serial No.';
                }
                field("Active Total"; Rec."Active Total")
                {
                    ToolTip = 'Specifies the value of the Active Total field.';
                    Caption = 'Active Total';
                }
                field("Active F1"; Rec."Active F1")
                {
                    ToolTip = 'Specifies the value of the Active F1 field.';
                    Caption = 'Active F1';
                }
                field("Active F2"; Rec."Active F2")
                {
                    ToolTip = 'Specifies the value of the Active F2 field.';
                    Caption = 'Active F2';
                }
                field("Active F3"; Rec."Active F3")
                {
                    ToolTip = 'Specifies the value of the Active F3 field.';
                    Caption = 'Active F3';
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
                field("Reactive Total"; Rec."Reactive Total")
                {
                    ToolTip = 'Specifies the value of the Reactive Total field.';
                    Caption = 'Reactive Total';
                }
                field("Reactive F1"; Rec."Reactive F1")
                {
                    ToolTip = 'Specifies the value of the Reactive F1 field.';
                    Caption = 'Reactive F1';
                }
                field("Reactive F2"; Rec."Reactive F2")
                {
                    ToolTip = 'Specifies the value of the Reactive F2 field.';
                    Caption = 'Reactive F2';
                }
                field("Reactive F3"; Rec."Reactive F3")
                {
                    ToolTip = 'Specifies the value of the Reactive F3 field.';
                    Caption = 'Reactive F3';
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
                field("Peak Total"; Rec."Peak Total")
                {
                    ToolTip = 'Specifies the value of the Peak Total field.';
                    Caption = 'Peak Total';
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
                field(SM; Rec.SM)
                {
                    ToolTip = 'Specifies the value of the SM field.';
                    Caption = 'SM';
                }
                field(LE; Rec.LE)
                {
                    ToolTip = 'Specifies the value of the LE field.';
                    Caption = 'LE';
                }
                field(TL; Rec.TL)
                {
                    ToolTip = 'Specifies the value of the TL field.';
                    Caption = 'TL';
                }
                field(CL; Rec.CL)
                {
                    ToolTip = 'Specifies the value of the CL field.';
                    Caption = 'CL';
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    Caption = 'Note';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    Caption = 'Invoice No.';
                }
                field("Import Date"; Rec."Import Date")
                {
                    ToolTip = 'Specifies the value of the Import Date field.';
                    Caption = 'Import Date';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                    Caption = 'File Name';
                }
                field("SII Code"; Rec."SII Code")
                {
                    ToolTip = 'Specifies the value of the SII Code field.';
                    Caption = 'SII Code';
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
                field("Latest Measurement"; Rec."Latest Measurement")
                {
                    ToolTip = 'Specifies the value of the Latest Measurement field.';
                    Caption = 'Latest Measurement';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("View Card")
            {
                Tooltip = 'Action for Importing Measurments';
                Caption = 'View Card';
                Visible = false; //KB30112023 - TASK002171 Measurement Upload Process

                trigger OnAction()
                begin
                    Page.RunModal(Page::"Measurement Card", Rec);
                end;
            }
            //KB30112023 - TASK002171 Measurement Upload Process +++
            action("View Details")
            {
                ToolTip = 'Action for view Measurement Details';
                Caption = 'View Details';
                Image = View; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    Measurement: Record Measurement;
                begin
                    Measurement.Reset();
                    Measurement.FilterGroup(2);
                    Measurement.SetRange("POD No.", Rec."POD No.");
                    Measurement.FilterGroup(0);
                    if Measurement.FindSet()then begin
                        Page.Run(Page::"ALL Measurement List for POD", Measurement);
                    end;
                end;
            }
            //KB30112023 - TASK002171 Measurement Upload Process ---
            action("Import Measurements")
            {
                Tooltip = 'Action for Importing Measurments';
                Caption = 'Import Measurements';
                Image = Import; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                    XMLImportManager: Codeunit "XML Import Manager";
                begin
                    XMLImportManager.ImportMeasurementFileSelection(); //KB30112023 - TASK002171 Measurement Upload Process Procedure updated
                end;
            }
            action("View Failed Imports")
            {
                Tooltip = 'View Imports With Issues';
                Caption = 'View Failed Imports';
                Image = ErrorLog; //KB14122023 - TASK002199 Image Icon

                trigger OnAction()
                var
                begin
                    Page.Run(Page::"Failed Measurement Imports");
                end;
            }
        }
        area(Promoted)
        {
            actionref(View_Details_Promoted; "View Details")
            {
            }
        }
    }
}
