page 50268 "AAT Comp. Scheme Line ListPart"
{
    PageType = ListPart;
    UsageCategory = Lists;
    SourceTable = "AAT Compensation Scheme Lines";
    Caption = 'Compensation Scheme Line List Part';

    layout
    {
        area(Content)
        {
            repeater("Scheme List Part")
            {
                Caption = 'Scheme List Part';

                field("AAT Scheme Code"; Rec."AAT Scheme Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Scheme Code field.';
                    Caption = 'Scheme Code';
                }
                field("AAT Start Date"; Rec."AAT Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                }
                field("AAT End Date"; Rec."AAT End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                }
                field("AAT Additional Monthly Disc."; Rec."AAT Additional Monthly Disc.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Additional Monthly Disc. field.';
                    Caption = 'Additional Monthly Disc.';
                }
                field("AAT Year"; Rec."AAT Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Year field.';
                    Caption = 'Year';
                }
            }
        }
    }
}
