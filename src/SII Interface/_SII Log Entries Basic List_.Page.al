page 50232 "SII Log Entries Basic List"
{
    PageType = ListPart;
    SourceTable = "SII Log Entries";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'SII Log Entries Basic List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Visible = false;
                    Caption = 'Entry No.';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                }
                field("CP User"; Rec."CP User")
                {
                    Tooltip = 'Specifies the value of the CP User Field';
                    Caption = 'CP User';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    DrillDown = true;
                    Visible = false;
                    Caption = 'Type';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Caption = 'Customer Name';
                }
                field("Fiscal Code"; Rec."Fiscal Code")
                {
                    ToolTip = 'Specifies the value of the Fiscal Code field.';
                    Caption = 'Fiscal Code';
                }
                field("VAT Number"; Rec."VAT Number")
                {
                    ToolTip = 'Specifies the value of the VAT Number field.';
                    Caption = 'VAT Number';
                }
                field("Initial Upload"; Rec."Initial Upload")
                {
                    ToolTip = 'Specifies the value of the Initial Upload field.';
                    Caption = 'Initial Upload';
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    Caption = 'Effective Date';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field';
                    AssistEdit = false;
                    DrillDown = true;
                    Caption = 'Status';

                    trigger OnDrillDown()
                    begin
                        Clear(DetailedSIILogEntriesPage);
                        DetailedSIILogEntries.SetRange("Log Entry No.", Rec."Entry No.");
                        DetailedSIILogEntries.SetRange("CP User", Rec."CP User");
                        if DetailedSIILogEntries.FindSet()then Page.RunModal(Page::"Detailed SII Log Entries", DetailedSIILogEntries);
                    end;
                }
            }
        }
    }
    var DetailedSIILogEntries: Record "Detailed SII Log Entries";
    DetailedSIILogEntriesPage: Page "Detailed SII Log Entries";
}
