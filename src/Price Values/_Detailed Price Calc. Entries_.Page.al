page 50270 "Detailed Price Calc. Entries"
{
    ApplicationArea = All;
    Caption = 'Detailed Price Calc. Entries';
    PageType = List;
    SourceTable = "Detailed Price Calc. Entry";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Active Type"; Rec."Active Type")
                {
                    ToolTip = 'Specifies the value of the Active Type field.';
                }
                field("Reactive Type"; Rec."Reactive Type")
                {
                    ToolTip = 'Specifies the value of the Reactive Type field.';
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Start Date field.';
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Price Type"; Rec."Price Type")
                {
                    ToolTip = 'Specifies the value of the Price Type field.';
                }
                field("Price Value No."; Rec."Price Value No.")
                {
                    ToolTip = 'Specifies the value of the Price Value No. field.';
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ToolTip = 'Specifies the value of the Line Amount field.';
                }
                field("Dyn. Inv. Template No."; Rec."Dyn. Inv. Template No.")
                {
                    ToolTip = 'Specifies the value of the Dyn. Inv. Template No. field.';
                }
            }
        }
    }
}
