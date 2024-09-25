page 50255 "Price Value Header Card"
{
    Caption = 'Tariff Price Value';
    DataCaptionFields = Name;
    PageType = Card;
    SourceTable = "Price Value Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    Caption = 'Effective Start Date';
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                    ToolTip = 'Specifies the value of the Effective Start Date field.';
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    Caption = 'Effective End Date';
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                }
                //KB03042024 - Net Loss Update in Billing +++
                field("Net Loss Type"; Rec."Net Loss Type")
                {
                    ToolTip = 'Specifies the value of the Net Loss Type field.';
                }
            //KB03042024 - Net Loss Update in Billing ---
            }
            group(Lines)
            {
                Caption = 'Lines';

                part("Price Value Lines"; "Price Value Lines")
                {
                    ShowFilter = true;
                    SubPageLink = "Price Value No."=field("No.");
                    Caption = 'Price Value Lines';
                }
            }
        }
    }
}
