page 50254 "Discount List"
{
    //KB03042024 - Discount Calculation +++
    ApplicationArea = All;
    Caption = 'Discount List';
    PageType = List;
    SourceTable = "Discount Price Header";
    UsageCategory = Lists;
    CardPageId = "Discount Price Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(Desciprtion; Rec.Desciprtion)
                {
                    ToolTip = 'Specifies the value of the Desciprtion field.';
                }
            }
        }
    }
//KB03042024 - Discount Calculation ---
}
