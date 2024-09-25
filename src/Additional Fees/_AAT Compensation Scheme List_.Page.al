page 50267 "AAT Compensation Scheme List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "AAT Compensation Scheme SII";
    SourceTable = "AAT Compensation Scheme SII";
    Caption = 'Compensation Scheme List';

    layout
    {
        area(Content)
        {
            repeater(Schemes)
            {
                Caption = 'Schemes';

                field("AAT Code SII"; Rec."AAT Code SII")
                {
                    ToolTip = 'Specifies the value of the Code field.';
                    Caption = 'Code';
                }
                field("AAT Year SII"; Rec."AAT Year SII")
                {
                    ToolTip = 'Specifies the value of the Year field.';
                    Caption = 'Year';
                }
                field("AAT Monthly Discount SII"; Rec."AAT Monthly Discount SII")
                {
                    ToolTip = 'Specifies the value of the Monthly Discount field.';
                    Caption = 'Monthly Discount';
                }
                field("AAT Description SII"; Rec."AAT Description SII")
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                }
            }
        }
    }
}
