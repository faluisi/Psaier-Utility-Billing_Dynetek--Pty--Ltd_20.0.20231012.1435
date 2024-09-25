page 60102 "AAT TV Fee SII List Part"
{
    Caption = 'AAT TV Fee SII List Part';
    PageType = ListPart;
    SourceTable = "AAT Additional Fees SII";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("AAT POD No. SII"; Rec."AAT POD No. SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the POD No. field.';
                }
                field("AAT Fee Code SII"; Rec."AAT Fee Code SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Fee Code field.';
                }
                field("AAT Start Date SII"; Rec."AAT Start Date SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("AAT End Date SII"; Rec."AAT End Date SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
                field("AAT Fiscal Code SII"; Rec."AAT Fiscal Code SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Fiscal Code field.';
                }
                field("AAT ISTAT Code SII"; Rec."AAT ISTAT Code SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the ISTAT Code field.';
                }
                field("AAT Amount SII"; Rec."AAT Amount SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("AAT Amount Code SII"; Rec."AAT Amount Code SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount Code field.';
                }
                field("AAT Supply Start Date"; Rec."AAT Supply Start Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Supply Start Date field.';
                }
                field("AAT Termination date"; Rec."AAT Termination date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Termination date field.';
                }
                field("AAT Valid Year SII"; Rec."AAT Valid Year SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Valid Year field.';
                }
                field("AAT Communication Type"; Rec."AAT Communication Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Communication Type field.';
                }
                field("AAT Reason Code SII"; Rec."AAT Reason Code SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Reason Code field.';
                }
                field("AAT Compensation Scheme"; Rec."AAT Compensation Scheme")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Compensation Scheme field.';
                }
                field("AAT Rate SII"; Rec."AAT Rate SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Rate field.';
                }
                field("AAT Outcome SII"; Rec."AAT Outcome SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Outcome field.';
                }
                field("AAT Fee Type SII"; Rec."AAT Fee Type SII")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Fee Type field.';
                }
            }
        }
    }
}
