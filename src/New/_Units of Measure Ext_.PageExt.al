pageextension 50210 "Units of Measure Ext" extends "Units of Measure"
{
    layout
    {
        addafter(Code)
        {
            field("UOM DE"; Rec."UOM DE")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Of Measure DE field.';
            }
            field("UOM IT"; Rec."UOM IT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Unit Of Measure IT field.';
            }
        }
    }
}
