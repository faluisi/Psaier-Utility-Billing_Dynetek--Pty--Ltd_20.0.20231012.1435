page 50246 "Dynamic Inv. Captions"
{
    ApplicationArea = All;
    Caption = 'Dynamic Inv. Multi Language Captions';
    PageType = List;
    SourceTable = "Dynamic Inv. Caption";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Caption = 'Entry No.';
                }
                field("English Caption"; Rec."English Caption")
                {
                    ToolTip = 'Specifies the value of the English Caption field.';
                    Caption = 'English Caption';
                }
                field("Italian Caption"; Rec."Italian Caption")
                {
                    ToolTip = 'Specifies the value of the Italian Caption Field field.';
                    Caption = 'Italian Caption';
                }
                field("German Caption"; Rec."German Caption")
                {
                    ToolTip = 'Specifies the value of the German Caption field.';
                    Caption = 'German Caption';
                }
            }
        }
    }
}
