page 50239 "Measurement Hourly Detail"
{
    ApplicationArea = All;
    Caption = 'Measurement Hourly Detail';
    PageType = List;
    SourceTable = "Measurement Hourly Detail";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    visible = false;
                    Caption = 'Entry No.';
                }
                field("Measurement Entry No."; Rec."Measurement Entry No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Measurement Entry No. field.';
                    Caption = 'Measurement Entry No.';
                }
                field(Day; Rec.Day)
                {
                    ToolTip = 'Specifies the value of the Day field.';
                    Caption = 'Day';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Caption = 'Type';
                }
                field("Measurement Interval"; Rec."Measurement Interval")
                {
                    Tooltip = 'Specifies the value of the Measurement Interval';
                    Caption = 'Measurement Interval';
                }
                field(Measurement; Rec.Measurement)
                {
                    ToolTip = 'Specifies the value of the Measurement field.';
                    Caption = 'Measurement';
                }
            }
        }
    }
}
