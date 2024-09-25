page 50219 Toponyms
{
    ApplicationArea = All;
    Caption = 'Toponyms';
    PageType = List;
    SourceTable = Toponym;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field(Toponym; Rec.Toponym)
                {
                    ToolTip = 'Specifies the value of the Toponym field.';
                    Caption = 'Toponym';
                }
            }
        }
    }
}
