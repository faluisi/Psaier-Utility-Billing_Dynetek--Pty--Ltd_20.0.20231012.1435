page 50216 "Meter List"
{
    CardPageID = "Meter Card";
    PageType = List;
    SourceTable = Meter;
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Meter List';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Seral No. field.';
                    Caption = 'Serial No.';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Reading Type"; Rec."Reading Type")
                {
                    ToolTip = 'Specifies the value of the Reading Type field.';
                    Caption = 'Reading Type';
                }
                field("Reading Detection"; Rec."Reading Detection")
                {
                    ToolTip = 'Specifies the value of the Reading Detection field.';
                    Caption = 'Reading Detection';
                }
                field("Energy Coeff"; Rec."Energy Coeff")
                {
                    ToolTip = 'Specifies the value of the Energy Coeff field.';
                    Caption = 'Energy Coeff';
                }
                field(Mark; Rec.Mark)
                {
                    ToolTip = 'Specifies the value of the Mark field.';
                    Caption = 'Mark';
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                    Caption = 'Model';
                }
                field("Production Year"; Rec."Production Year")
                {
                    ToolTip = 'Specifies the value of the Production field.';
                    Caption = 'Production Year';
                }
            }
        }
    }
    actions
    {
    }
}
