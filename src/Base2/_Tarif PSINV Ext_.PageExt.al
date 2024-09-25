pageextension 50206 "Tarif PSINV Ext" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Dyn. Inv. Template No."; Rec."Dyn. Inv. Template No.")
            {
                ApplicationArea = All;
                Caption = 'Dynamic Invoice Entry No.';
                ToolTip = 'Specifies the value of the Dynamic Invoice Entry No. field.';
            }
            field("Dyn. Inv. Eng Caption"; Rec."Dyn. Inv. Eng Caption")
            {
                ApplicationArea = All;
                Caption = 'Dyn. Inv. Eng Caption';
                ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
            }
            field("Dyn. Inv. IT Caption"; Rec."Dyn. Inv. IT Caption")
            {
                ApplicationArea = All;
                Visible = false;
                Caption = 'Dyn. Inv. IT Caption';
                ToolTip = 'Specifies the value of the Dyn. Inv. IT Caption field.';
            }
            field("Dyn. Inv. DE Caption"; Rec."Dyn. Inv. DE Caption")
            {
                ApplicationArea = All;
                Visible = false;
                Caption = 'Dyn. Inv. DE Caption';
                ToolTip = 'Specifies the value of the Dyn. Inv. DE Caption field.';
            }
        }
    }
}
