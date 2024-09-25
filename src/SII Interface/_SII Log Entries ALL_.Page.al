page 50235 "SII Log Entries ALL"
{
    ApplicationArea = All;
    Caption = 'SII Log Entries ALL';
    PageType = List;
    SourceTable = "SII Log Entries";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Caption = 'Customer Name';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    Caption = 'Effective Date';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Caption = 'Entry No.';
                }
                field("Fiscal Code"; Rec."Fiscal Code")
                {
                    ToolTip = 'Specifies the value of the Fiscal Code field.';
                    Caption = 'Fiscal Code';
                }
                field("Initial Upload"; Rec."Initial Upload")
                {
                    ToolTip = 'Specifies the value of the Initial Upload field.';
                    Caption = 'Initial Upload';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Caption = 'Status';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Caption = 'Type';
                }
                field("VAT Number"; Rec."VAT Number")
                {
                    ToolTip = 'Specifies the value of the VAT Number field.';
                    Caption = 'VAT Number';
                }
            }
        }
    }
}
