page 50206 "Cadastral Data List"
{
    PageType = List;
    SourceTable = "Cadastral Data";
    UsageCategory = Lists;
    ApplicationArea = all;
    Caption = 'Cadastral Data List';

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
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                }
                field("Account Holder"; Rec."Account Holder")
                {
                    ToolTip = 'Specifies the value of the Account Holder field.';
                    Caption = 'Account Holder';
                }
                field("Municipality Comm. Date"; Rec."Municipality Comm. Date")
                {
                    ToolTip = 'Specifies the value of the Municipality Comm. Date field.';
                    Caption = 'Municipality Comm. Date';
                }
                field("Property Type"; Rec."Property Type")
                {
                    ToolTip = 'Specifies the value of the Property Type field.';
                    Caption = 'Property Type';
                }
                field("Concession Building"; Rec."Concession Building")
                {
                    ToolTip = 'Specifies the value of the Concession Building field.';
                    Caption = 'Concession Building';
                }
                field("Cadatsral Municpality Code"; Rec."Cadastral Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Cadatsral Municipality Code field.';
                    Caption = 'Cadastral Municipality Code';
                }
                field("Admin. Municipality Code"; Rec."Admin. Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Admin. Municipality Code field.';
                    Caption = 'Admin. Municipality Code';
                }
                field(Section; Rec.Section)
                {
                    ToolTip = 'Specifies the value of the Section field.';
                    Caption = 'Section';
                }
                field(Sheet; Rec.Sheet)
                {
                    ToolTip = 'Specifies the value of the Sheet field.';
                    Caption = 'Sheet';
                }
                field(Particle; Rec.Particle)
                {
                    ToolTip = 'Specifies the value of the Particle field.';
                    Caption = 'Particle';
                }
                field("Partice Extension"; Rec."Partice Extension")
                {
                    ToolTip = 'Specifies the value of the Partice Extension field.';
                    Caption = 'Partice Extension';
                }
                field(Subordinate; Rec.Subordinate)
                {
                    ToolTip = 'Specifies the value of the Subordinate field.';
                    Caption = 'Subordinate';
                }
                field("Absense of Cadastral Data"; Rec."Absense of Cadastral Data")
                {
                    ToolTip = 'Specifies the value of the Absense of Cadastral Data field.';
                    Caption = 'Absense of Cadastral Data';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                }
            }
        }
    }
}
