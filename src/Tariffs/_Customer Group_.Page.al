page 50262 "Customer Group"
{
    Caption = 'Customer Group';
    PageType = ListPart;
    SourceTable = "Customer Group";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Tariff No."; Rec."Tariff No.")
                {
                    ToolTip = 'Specifies the value of the Tariff No. field.';
                    Caption = 'Tariff No.';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Add Customer Group")
            {
                Caption = 'Add Customer Group';
                ToolTip = 'Executes the Add Customer Group action.';
                ApplicationArea = All;
                Image = AddContacts;

                trigger OnAction()
                var
                    TariffHeader: Record "Tariff Header";
                    CustomerGroup: Record "Customer Group";
                begin
                    if Page.RunModal(Page::"Tariff List", TariffHeader) = Action::LookupOK then begin
                        CustomerGroup.Init();
                        CustomerGroup."Customer No.":=Rec."Customer No.";
                        CustomerGroup."Tariff No.":=TariffHeader."No.";
                        CustomerGroup.Insert(true);
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
}
