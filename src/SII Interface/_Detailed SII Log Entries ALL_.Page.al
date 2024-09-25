page 50234 "Detailed SII Log Entries ALL"
{
    ApplicationArea = All;
    Caption = 'Detailed SII Log Entries ALL';
    PageType = List;
    SourceTable = "Detailed SII Log Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Action"; Rec."Action")
                {
                    ToolTip = 'Specifies the value of the Action field.';
                    Caption = 'Action';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("Detailed Entry No."; Rec."Detailed Entry No.")
                {
                    ToolTip = 'Specifies the value of the Detailed Entry No. field.';
                    Caption = 'Detailed Entry No.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    Tooltip = 'Specifies the value of the Contract No. Field';
                    Caption = 'Contract No.';
                }
                field("CP User"; Rec."CP User")
                {
                    Tooltip = 'Specifies the value of the CP User Field';
                    Caption = 'CP User';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.';
                    Caption = 'Error';
                }
                field("Error Code"; Rec."Error Code")
                {
                    ToolTip = 'Specifies the value of the Error Code field.';
                    Caption = 'Error Code';
                }
                field("File Type"; Rec."File Type")
                {
                    ToolTip = 'Specifies the value of the File Type field';
                    Caption = 'File Type';
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
                    Caption = 'Filename';
                }
                field("Initial Upload Date"; Rec."Initial Upload Date")
                {
                    ToolTip = 'Specifies the value of the Initial Upload Date field.';
                    Caption = 'Initial Upload Date';
                }
                field("Log Entry No."; Rec."Log Entry No.")
                {
                    ToolTip = 'Specifies the value of the Log Entry No. field.';
                    Caption = 'Log Entry No.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Caption = 'Status';
                }
                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field.';
                    Caption = 'User';
                }
            }
        }
    }
}
