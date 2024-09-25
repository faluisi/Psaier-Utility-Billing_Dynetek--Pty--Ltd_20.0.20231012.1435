page 50224 "Measurement Peak List Part"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = Measurement;
    // ApplicationArea = All;
    Caption = 'Measurement Peak List Part';

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
                field("Peak Total"; Rec."Peak Total")
                {
                    ToolTip = 'Specifies the value of the Peak Total field.';
                    Caption = 'Peak Total';
                    ApplicationArea = All;
                }
                field("Peak F1"; Rec."Peak F1")
                {
                    ToolTip = 'Specifies the value of the Peak F1 field.';
                    Caption = 'Peak F1';
                    ApplicationArea = All;
                }
                field("Peak F2"; Rec."Peak F2")
                {
                    ToolTip = 'Specifies the value of the Peak F2 field.';
                    Caption = 'Peak F2';
                    ApplicationArea = All;
                }
                field("Peak F3"; Rec."Peak F3")
                {
                    ToolTip = 'Specifies the value of the Peak F3 field.';
                    Caption = 'Peak F3';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
