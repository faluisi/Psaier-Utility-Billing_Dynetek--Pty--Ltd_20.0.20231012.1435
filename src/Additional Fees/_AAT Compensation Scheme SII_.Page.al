page 50266 "AAT Compensation Scheme SII"
{
    PageType = Card;
    UsageCategory = Administration;
    SourceTable = "AAT Compensation Scheme SII";
    ApplicationArea = All;
    Caption = 'Compensation Scheme';

    layout
    {
        area(Content)
        {
            group("Scheme Details")
            {
                Caption = 'Scheme Details';

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
            group("Scheme Lines Part")
            {
                Caption = 'Scheme Lines Part';

                part("Scheme Lines"; "AAT Comp. Scheme Line ListPart")
                {
                    SubPageLink = "AAT Scheme Code"=field("AAT Code SII"), "AAT Year"=field("AAT Year SII");
                    Caption = 'AAT Comp. Scheme Line ListPart';
                }
            }
        }
    }
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
    begin
        if not Rec.ConfirmEmptyCompScheme()then Error('');
    end;
}
