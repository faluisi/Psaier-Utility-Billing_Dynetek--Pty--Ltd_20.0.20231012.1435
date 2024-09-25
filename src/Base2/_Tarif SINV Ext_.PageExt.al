pageextension 50205 "Tarif SINV Ext" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Location Code")
        {
            //KB01022024 - Billing Process Accisso Price calculation +++
            field("Effective Start Date"; Rec."Effective Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Effective Start Date field.';
            }
            field("Effective End Date"; Rec."Effective End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Effective End Date field.';
            }
            field("Active Type"; Rec."Active Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Active Type field.';
            }
            field("Reactive Type"; Rec."Reactive Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reactive Type field.';
            }
        //KB01022024 - Billing Process Accisso Price calculation ---
        }
        modify(Quantity)
        {
            BlankZero = false;
        }
        modify("Unit Price")
        {
            BlankZero = false;
        }
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
                ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
            }
            field("Dyn. Inv. DE Caption"; Rec."Dyn. Inv. DE Caption")
            {
                ApplicationArea = All;
                Visible = false;
                Caption = 'Dyn. Inv. DE Caption';
                ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
            }
        }
    }
}
