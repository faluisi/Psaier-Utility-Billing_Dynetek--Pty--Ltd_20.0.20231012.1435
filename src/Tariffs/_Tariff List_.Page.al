page 50250 "Tariff List"
{
    ApplicationArea = All;
    Caption = 'Utility Tariff List';
    PageType = List;
    SourceTable = "Tariff Header";
    UsageCategory = Administration;
    CardPageId = "Tariff Header Card Page";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description.';
                    Caption = 'Description';
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    Caption = 'Effective Start Date';
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                    Caption = 'Effective End Date';
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                }
                // AN 27112023 TASK002168  - Added below field ++ 
                field(COD_OFFERTA; Rec.COD_OFFERTA)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the values of the COD_OFFERTA field.';
                }
            }
        }
    }
}
