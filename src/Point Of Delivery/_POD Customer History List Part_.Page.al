page 50225 "POD Customer History List Part"
{
    PageType = ListPart;
    SourceTable = "Point of Delivery - Cust Hist";
    // ApplicationArea = All;
    Caption = 'POD Customer History List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                    Caption = 'Customer Name';
                    ApplicationArea = All;
                }
                field("Period"; Rec.Period)
                {
                    ToolTip = 'Specifies the value of the Period field.';
                    Caption = 'Period';
                    ApplicationArea = All;
                }
                // field("AAT Contract No"; Rec."AAT Contract No")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Contract No. field.';
                //     // Visible = false;
                // }
                field("Entry No"; Rec."Entry No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No field.';
                    Visible = false;
                    Editable = false;
                }
                field("POD No."; Rec."POD No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
    }
}
