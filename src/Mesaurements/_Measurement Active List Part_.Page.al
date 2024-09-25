page 50222 "Measurement Active List Part"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = Measurement;
    Caption = 'Measurement Active List Part';

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
                field("Active F1"; Rec."Active F1")
                {
                    ToolTip = 'Specifies the value of the Active F1 field.';
                    Caption = 'Active F1';
                    ApplicationArea = All;
                }
                field("Active F2"; Rec."Active F2")
                {
                    ToolTip = 'Specifies the value of the Active F2 field.';
                    Caption = 'Active F2';
                    ApplicationArea = All;
                }
                field("Active F3"; Rec."Active F3")
                {
                    ToolTip = 'Specifies the value of the Active F3 field.';
                    Caption = 'Active F3';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
