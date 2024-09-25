page 50257 "Price Value Header List"
{
    ApplicationArea = All;
    Caption = 'Price Value List';
    PageType = List;
    SourceTable = "Price Value Header";
    UsageCategory = Lists;
    CardPageId = "Price Value Header Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the Tariff Price Value No. field.';
                    Caption = 'No.';
                }
                field(Name; Rec.Name)
                {
                    Tooltip = 'Specifies the value of the Name field.';
                    Caption = 'Name';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Delete Tariff Price Value Lines")
            {
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Caption = 'Delete Tariff Price Value Lines';
                ToolTip = 'Executes the Delete Tariff Price Value Lines action.';

                trigger OnAction()
                var
                    TariffPriceValueLines: Record "Price Value Line";
                begin
                    TariffPriceValueLines.DeleteAll();
                end;
            }
        }
    }
}
