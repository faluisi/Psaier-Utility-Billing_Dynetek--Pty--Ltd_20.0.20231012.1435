page 50229 "POD Contract Hist List Part"
{
    Editable = true;
    PageType = ListPart;
    SourceTable = "Point of Delivery - Cust Hist";
    // ApplicationArea = All;
    Caption = 'POD Contract Hist List Part';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Contract No"; Rec."AAT Contract No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No';
                }
                field("Contract Description"; Rec."AAT Contract Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Contract Description field.';
                    Caption = 'Contract Description';
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
// trigger OnInit()
// var
//     PointofDeliveryCustHist: Record "Point of Delivery - Cust Hist";
// begin
//     ViewFilter := ''
// end;
// var
//     ViewFilter: Text;
}
