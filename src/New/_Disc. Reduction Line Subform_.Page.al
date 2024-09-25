page 50208 "Disc. Reduction Line Subform"
{
    PageType = ListPart;
    SourceTable = "Contract Dicount/Reduction Lin";
    ApplicationArea = all;
    Caption = 'Disc. Reduction Line Subform';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Discount Against"; Rec."Discount Against")
                {
                    ToolTip = 'Specifies the value of the Discount Against field.';
                    Caption = 'Discount Against';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                }
                field(Desciption; Rec.Desciption)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Desciption';
                }
                field(Recurring; Rec.Recurring)
                {
                    ToolTip = 'Specifies the value of the Recurring field.';
                    Caption = 'Recurring';
                }
                field("Recurring Start Date"; Rec."Recurring Start Date")
                {
                    ToolTip = 'Specifies the value of the AUC Exempt field.';
                    Caption = 'Recurring Start Date';
                }
                field("Invoiced Date"; Rec."Invoiced Date")
                {
                    ToolTip = 'Specifies the value of the Invoiced Date field.';
                    Caption = 'Invoiced Date';
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
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                }
                field(Percentage; Rec.Percentage)
                {
                    ToolTip = 'Specifies the value of the Percentage field.';
                    Caption = 'Percentage';
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ToolTip = 'Specifies the value of the Invoiced field.';
                    Caption = 'Invoiced';
                }
            }
        }
    }
}
