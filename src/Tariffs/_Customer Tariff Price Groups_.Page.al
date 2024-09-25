page 50209 "Customer Tariff Price Groups"
{
    PageType = ListPart;
    SourceTable = "Customer Tariff Price Group";
    Caption = 'Customer Tariff Price Groups';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
