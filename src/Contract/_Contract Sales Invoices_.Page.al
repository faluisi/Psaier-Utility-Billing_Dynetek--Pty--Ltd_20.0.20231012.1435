page 50258 "Contract Sales Invoices"
{
    Caption = 'Sales Invoices';
    PageType = ListPart;
    SourceTable = "Sales Header";
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
                    Editable = false;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the estimate.';

                    trigger OnDrillDown()
                    var
                        SalesInvoice: Record "Sales Header";
                    begin
                        if SalesInvoice.Get(Enum::"Sales Document Type"::Invoice, Rec."No.")then Page.Run(Page::"Sales Invoice", SalesInvoice);
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Tooltip = 'Specifies the value of the Posting Date field';
                    Caption = 'Posting Date';
                }
                field("Due Date"; Rec."Due Date")
                {
                    Tooltip = 'Specifies the value of the Due Date field';
                    Caption = 'Due Date';
                }
                field(Amount; Rec.Amount)
                {
                    Tooltip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                }
            }
        }
    }
}
