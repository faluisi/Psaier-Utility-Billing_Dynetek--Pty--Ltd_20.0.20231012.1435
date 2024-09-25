pageextension 50207 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    actions
    {
        addlast(processing)
        {
            action("Delete Multiple Invoice")
            {
                Caption = 'Delete Multiple Invoice';
                ApplicationArea = all;
                Image = Delete;
                ToolTip = 'Delete selected Invoice Documents.';

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                begin
                    CurrPage.SetSelectionFilter(SalesHeader);
                    SalesHeader.DeleteAll(true);
                end;
            }
        }
        addlast(Category_Category6)
        {
            actionref(Delete_Multiple_Invoice_Promoted; "Delete Multiple Invoice")
            {
            }
        }
    }
}
