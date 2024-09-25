page 50221 "Measurement List Part"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = Measurement;
    // ApplicationArea = All;
    Caption = 'Measurement List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                /*field(Date; Rec.Date)
{
ToolTip = 'Specifies the value of the Date field.';
ApplicationArea = All;
}*/
                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    Caption = 'Month';
                    ApplicationArea = All;
                }
                field("Measure Date"; Rec."Measure Date")
                {
                    ToolTip = 'Specifies the value of the Measure Date field.';
                    Caption = 'Measure Date';
                    ApplicationArea = All;
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Caption = 'Meter Serial No.';
                    ApplicationArea = All;
                }
                field("Active Total"; Rec."Active Total")
                {
                    ToolTip = 'Specifies the value of the Active Total field.';
                    Caption = 'Active Total';
                    ApplicationArea = All;
                }
                field("Reactive Total"; Rec."Reactive Total")
                {
                    ToolTip = 'Specifies the value of the Reactive Total field.';
                    Caption = 'Reactive Total';
                    ApplicationArea = All;
                }
                field("Peak Total"; Rec."Peak Total")
                {
                    ToolTip = 'Specifies the value of the Peak Totalfield.';
                    Caption = 'Peak Total';
                    ApplicationArea = All;
                }
                field(LE; Rec.LE)
                {
                    ToolTip = 'Specifies the value of the LE field.';
                    Caption = 'LE';
                    ApplicationArea = All;
                }
                field(TL; Rec.TL)
                {
                    ToolTip = 'Specifies the value of the TL field.';
                    Caption = 'TL';
                    ApplicationArea = All;
                }
                field(CL; Rec.CL)
                {
                    ToolTip = 'Specifies the value of the CL field.';
                    Caption = 'CL';
                    ApplicationArea = All;
                }
                field(Note; Rec.Note)
                {
                    ToolTip = 'Specifies the value of the Note field.';
                    Caption = 'Note';
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                    Caption = 'Invoice No.';
                    ApplicationArea = All;
                }
                field("Import Date"; Rec."Import Date")
                {
                    ToolTip = 'Specifies the value of the Import Date field.';
                    Caption = 'Import Date';
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the value of the File Name field.';
                    Caption = 'File Name';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
