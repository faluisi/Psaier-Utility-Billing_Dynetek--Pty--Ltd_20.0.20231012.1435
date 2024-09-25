page 50259 "Contract Posted Sales Invoices"
{
    Caption = 'Posted Sales Invoices';
    PageType = ListPart;
    SourceTable = "Sales Invoice Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    Tooltip = 'Specifies the value of the No. field.';
                    Editable = false;
                    Caption = 'No.';

                    trigger OnDrillDown()
                    var
                        SalesInvoice: Record "Sales Invoice Header";
                    begin
                        if SalesInvoice.Get(Rec."No.")then Page.Run(Page::"Posted Sales Invoice", SalesInvoice);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Tooltip = 'Specifies the value of the Posting Date field.';
                    Caption = 'Posting Date';
                }
                field("Due Date"; Rec."Due Date")
                {
                    Tooltip = 'Specifies the value of the Due Date.';
                    Caption = 'Due Date';
                }
                field(Amount; Rec.Amount)
                {
                    Tooltip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                }
                field(Closed; Rec.Closed)
                {
                    Tooltip = 'Specifies the value of the Closed field';
                    Caption = 'Closed';
                }
            }
        }
    }
}
