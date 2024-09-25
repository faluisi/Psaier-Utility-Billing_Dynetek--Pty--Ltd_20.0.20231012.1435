page 50252 "Tariff Lines List Part"
{
    Caption = 'Lines';
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Tariff Line";
    CardPageId = "Tariff Line Header Card Page";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    Caption = 'Formula';
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.';
                    Caption = 'Resource No.';
                    ApplicationArea = All;
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    ToolTip = 'Specifies the value of the Resource Name field.';
                    Caption = 'Resource Name';
                    ApplicationArea = All;
                }
                //KB15022024 - TASK002433 New Billing Calculation +++
                field("Line Cost Type"; Rec."Line Cost Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Cost Type field.';
                }
                //KB15022024 - TASK002433 New Billing Calculation ---
                field("Meter Reading Detection"; Rec."Meter Reading Detection")
                {
                    ToolTip = 'Specifies the value of the Meter Reading Detection field.';
                    Caption = 'Meter Reading Detection';
                    ApplicationArea = All;
                }
                field("Dyn. Inv. Template No."; Rec."Dyn. Inv. Template No.")
                {
                    Caption = 'Dynamic Invoice Entry No.';
                    ToolTip = 'Specifies the value of the Dynamic Invoice Entry No. field.';
                    ApplicationArea = All;
                }
                field("Dyn. Inv. Eng Caption"; Rec."Dyn. Inv. Eng Caption")
                {
                    Caption = 'Dyn. Inv. Eng Caption';
                    ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
                    ApplicationArea = All;
                }
                field("Dyn. Inv. IT Caption"; Rec."Dyn. Inv. IT Caption")
                {
                    Visible = false;
                    Caption = 'Dyn. Inv. Eng Caption';
                    ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
                    ApplicationArea = All;
                }
                field("Dyn. Inv. DE Caption"; Rec."Dyn. Inv. DE Caption")
                {
                    Visible = false;
                    Caption = 'Dyn. Inv. Eng Caption';
                    ToolTip = 'Specifies the value of the Dyn. Inv. Eng Caption field.';
                    ApplicationArea = All;
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    NotBlank = true;
                    Caption = 'Effective Start Date';
                    ApplicationArea = All;
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                    NotBlank = true;
                    Caption = 'Effective End Date';
                    ApplicationArea = All;
                }
            }
        }
    }
}
