page 50263 "Discount Price Card"
{
    //KB03042024 - Discount Calculation +++
    ApplicationArea = All;
    Caption = 'Discount Price';
    PageType = Card;
    SourceTable = "Discount Price Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(ID; Rec.ID)
                {
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(Desciprtion; Rec.Desciprtion)
                {
                    ToolTip = 'Specifies the value of the Desciprtion field.';
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
            part("Discount Price Line"; "Discount Price Line")
            {
                Caption = 'Lines';
                SubPageLink = ID=field(ID);
            }
        }
    }
//KB03042024 - Discount Calculation ---
}
