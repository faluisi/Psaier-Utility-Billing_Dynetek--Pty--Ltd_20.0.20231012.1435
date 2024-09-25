page 50207 "Additional Charges Subform"
{
    PageType = ListPart;
    SourceTable = "Contract Add. Charge Line";
    Caption = 'Additional Charges Subform';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Charge Against"; Rec."Charge Against")
                {
                    ToolTip = 'Specifies the value of the Charge Against field.';
                    Caption = 'Charge Against';
                    ApplicationArea = All;
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                    ApplicationArea = All;
                }
                field(Desciption; Rec.Desciption)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Desciption';
                    ApplicationArea = All;
                }
                field(Recurring; Rec.Recurring)
                {
                    ToolTip = 'Specifies the value of the Recurring field.';
                    Caption = 'Recurring';
                    ApplicationArea = All;
                }
                field("Recurring Start Date"; Rec."Recurring Start Date")
                {
                    ToolTip = 'Specifies the value of the Recurring Start Date field.';
                    Caption = 'Recurring Start Date';
                    ApplicationArea = All;
                }
                field("Invoiced Date"; Rec."Invoiced Date")
                {
                    ToolTip = 'Specifies the value of the Invoiced Date field.';
                    Caption = 'Invoiced Date';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                    ApplicationArea = All;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ToolTip = 'Specifies the value of the Invoiced field.';
                    Caption = 'Invoiced';
                    ApplicationArea = All;
                }
            }
        }
    }
}
