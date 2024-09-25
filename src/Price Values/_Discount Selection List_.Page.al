page 50271 "Discount Selection List"
{
    ApplicationArea = All;
    Caption = 'Discount Selection List';
    PageType = ListPart;
    SourceTable = "Discount Selection";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Discount ID"; Rec."Discount ID")
                {
                    ToolTip = 'Specifies the value of the Discount ID field.';
                }
                field("Annual Consumption From"; Rec."Annual Consumption From")
                {
                    ToolTip = 'Specifies the value of the Annual Consumption From field.';
                }
                field("Annual Consumption To"; Rec."Annual Consumption To")
                {
                    ToolTip = 'Specifies the value of the Annual Consumption To field.';
                }
            }
        }
    }
}
