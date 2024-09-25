page 50213 "County List"
{
    ApplicationArea = All;
    Caption = 'County List';
    PageType = List;
    SourceTable = "PS County";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    Caption = 'Code';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Caption = 'Name';
                }
            }
        }
    }
}
