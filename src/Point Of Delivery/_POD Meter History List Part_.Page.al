page 50228 "POD Meter History List Part"
{
    // AN 09112023 - TASK002140 ++ 
    Editable = false;
    // AN 09112023 - TASK002140 --
    PageType = ListPart;
    SourceTable = "Point of Delivery - Meter Hist";
    // ApplicationArea = All;
    Caption = 'POD Meter History List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Editable = false;
                    Caption = 'Meter Serial No.';
                    ApplicationArea = All;
                }
                field("Activation Date"; Rec."Activation Date")
                {
                    ToolTip = 'Specifies the value of the Activation Date field.';
                    Editable = false;
                    Caption = 'Activation Date';
                    ApplicationArea = All;
                }
                field("Deactivation Date"; Rec."Deactivation Date")
                {
                    ToolTip = 'Specifies the value of the Deactivation Date field.';
                    Caption = 'Deactivation Date';
                    ApplicationArea = All;
                    Editable = true;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    DrillDown = true;
                    Editable = false;
                    Caption = 'Period';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        Meter: Record Meter;
                    begin
                        Meter.Get(Rec."Meter Serial No.");
                        PAGE.RunModal(Page::"Meter Card", Meter);
                    end;
                }
            }
        }
    }
    actions
    {
    }
}
