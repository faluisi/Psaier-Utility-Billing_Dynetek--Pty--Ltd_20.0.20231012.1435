page 50269 "Discount Price Line"
{
    ApplicationArea = All;
    Caption = 'Discount Price Line';
    PageType = ListPart;
    AutoSplitKey = true;
    SourceTable = "Discount Price Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Price Value No."; Rec."Price Value No.")
                {
                    ToolTip = 'Specifies the value of the Price Value No. field.';
                }
                field("Line Cost Type"; Rec."Line Cost Type")
                {
                    ToolTip = 'Specifies the value of the Line Cost Type field.';
                }
                field("Discount Type"; Rec."Discount Type")
                {
                    ToolTip = 'Specifies the value of the Discount Type field.';
                }
                field("Discount %"; Rec."Discount %")
                {
                    ToolTip = 'Specifies the value of the Discount % field.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }
}
