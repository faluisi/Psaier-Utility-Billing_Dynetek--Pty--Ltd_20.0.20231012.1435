pageextension 50204 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(Closed)
        {
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = All;
                Editable = false;
                DrillDown = false; //KB15122023 - TASK002199 Disable DrillDown
                Caption = 'Contract No.';
                ToolTip = 'Specifies the value of the Contract No. field.';

                trigger OnDrillDown()
                var
                    Contract: Record Contract;
                    ContractCard: Page "Contract Card";
                begin
                    Contract.Reset();
                    Contract.SetRange("No.", Rec."Contract No.");
                    if Contract.FindFirst()then begin
                        ContractCard.SetRecord(Contract);
                        ContractCard.Editable:=false;
                        ContractCard.RunModal();
                    end;
                end;
            }
            field("Tariff No."; Rec."Tariff No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Tariff No.';
                ToolTip = 'Specifies the value of the Tariff No. field.';
                DrillDown = false; //KB15122023 - TASK002199 Disable DrillDown

                trigger OnDrillDown()
                var
                    Tariff: Record "Tariff Header";
                    TariffHeaderCardPage: Page "Tariff Header Card Page";
                begin
                    Tariff.SetRange("No.", Rec."Tariff No.");
                    Tariff.SetRange(Description, Rec."Tariff Name");
                    if Tariff.FindFirst()then begin
                        TariffHeaderCardPage.SetRecord(Tariff);
                        TariffHeaderCardPage.Editable:=false;
                        TariffHeaderCardPage.RunModal();
                    end;
                end;
            }
            field("Tariff Name"; Rec."Tariff Name")
            {
                ApplicationArea = All;
                Editable = false;
                DrillDown = false; //KB15122023 - TASK002199 Disable DrillDown
                Caption = 'Tariff Name';
                ToolTip = 'Specifies the value of the Tariff Name field.';

                trigger OnDrillDown()
                var
                    Tariff: Record "Tariff Header";
                    TariffHeaderCardPage: Page "Tariff Header Card Page";
                begin
                    Tariff.SetRange("No.", Rec."Tariff No.");
                    Tariff.SetRange(Description, Rec."Tariff Name");
                    if Tariff.FindFirst()then begin
                        TariffHeaderCardPage.SetRecord(Tariff);
                        TariffHeaderCardPage.Editable:=false;
                        TariffHeaderCardPage.RunModal();
                    end;
                end;
            }
            field("AAT Invoice Contract Period"; Rec."AAT Invoice Contract Period")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Invoice Contract Period field.';
            }
        }
    }
}
