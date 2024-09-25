pageextension 50209 "Resource Card Ext" extends "Resource Card"
{
    layout
    {
        addafter(Name)
        {
            field("Name DE"; Rec."Name DE")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name DE field.', Comment = '%';
            }
            field("Name IT"; Rec."Name IT")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name IT field.', Comment = '%';
            }
        }
    }
}
