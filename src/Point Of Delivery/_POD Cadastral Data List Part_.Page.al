page 50227 "POD Cadastral Data List Part"
{
    Editable = false;
    PageType = List;
    SourceTable = "Cadastral Data";
    Caption = 'POD Cadastral Data List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                    ApplicationArea = All;
                }
                field("Account Holder"; Rec."Account Holder")
                {
                    ToolTip = 'Specifies the value of the Account Holder field.';
                    Caption = 'Account Holder';
                    ApplicationArea = All;
                }
                field("Property Type"; Rec."Property Type")
                {
                    ToolTip = 'Specifies the value of the Prperty Type field.';
                    Caption = 'Property Type';
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
}
