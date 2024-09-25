page 50223 "Measurement Reactive List Part"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = Measurement;
    // ApplicationArea = All;
    Caption = 'Measurement Reactive List Part';

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
                field("Reactive Total"; Rec."Reactive Total")
                {
                    ToolTip = 'Specifies the value of the Reactive Total field.';
                    Caption = 'Reactive Total';
                    ApplicationArea = All;
                }
                field("Reactive F1"; Rec."Reactive F1")
                {
                    ToolTip = 'Specifies the value of the Reactive F1 field.';
                    Caption = 'Reactive F1';
                    ApplicationArea = All;
                }
                field("Reactive F2"; Rec."Reactive F2")
                {
                    ToolTip = 'Specifies the value of the Reactive F2 field.';
                    Caption = 'Reactive F2';
                    ApplicationArea = All;
                }
                field("Reactive F3"; Rec."Reactive F3")
                {
                    ToolTip = 'Specifies the value of the Reactive F3 field.';
                    Caption = 'Reactive F3';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
