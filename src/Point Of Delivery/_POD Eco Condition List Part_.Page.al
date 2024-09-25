page 50226 "POD Eco Condition List Part"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = "Economic Condition";
    // ApplicationArea = All;
    Caption = 'POD Eco Condition List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Seller Name"; Rec."Seller Name")
                {
                    ToolTip = 'Specifies the value of the Seller Name field.';
                    Caption = 'Seller Name';
                    ApplicationArea = All;
                }
                field(Typology; Rec.Typology)
                {
                    ToolTip = 'Specifies the value of the Typology field.';
                    Caption = 'Typology';
                    ApplicationArea = All;
                }
                field("Con. kW"; Rec."Con. kW")
                {
                    ToolTip = 'Specifies the value of the Con. KW field.';
                    Caption = 'Con. kW';
                    ApplicationArea = All;
                }
                field("Dis. kW"; Rec."Dis. kW")
                {
                    ToolTip = 'Specifies the value of the Dis. KW field.';
                    Caption = 'Dis. kW';
                    ApplicationArea = All;
                }
                field("Ten. V"; Rec."Ten. V")
                {
                    ToolTip = 'Specifies the value of the Ten. V field.';
                    Caption = 'Ten. V';
                    ApplicationArea = All;
                }
                field(Period; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    Caption = 'Period';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
}
