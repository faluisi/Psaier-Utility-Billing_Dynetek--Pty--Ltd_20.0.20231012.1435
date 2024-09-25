page 70200 "Time Shift List"
{
    //KB30112023 - TASK002171 Measurement Upload Process +++
    ApplicationArea = All;
    Caption = 'Time Shift List';
    PageType = List;
    SourceTable = "Time Shift";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.';
                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.';
                }
            }
        }
    }
//KB30112023 - TASK002171 Measurement Upload Process ---
}
