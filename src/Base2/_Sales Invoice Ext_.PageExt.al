pageextension 50203 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        addafter(Status)
        {
            field("Contract No."; Rec."Contract No.")
            {
                ApplicationArea = All;
                Editable = false;
                Caption = 'Contract No.';
                ToolTip = 'Specifies the value of the Contract No. field.';

                trigger OnDrillDown()
                var
                    Contract: Record Contract;
                    ContractCard: Page "Contract Card";
                begin
                    if Contract.Get(Rec."Contract No.")then begin
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

                // DrillDownPageId = "Tariff Header Card Page";
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
    actions
    {
        addlast(Category_Category7)
        {
            actionref("DynInvoiceView_Promoted"; "View Dyn. Inv. Content")
            {
            }
            actionref(DetailedPriceCalc_Promoted; "View Detailed Price Calc. Entry")
            {
            }
        }
        addlast("&Invoice")
        {
            group("Dynamic Invoice")
            {
                Caption = 'Dynamic Invoice';

                action("View Dyn. Inv. Content")
                {
                    ApplicationArea = All;
                    Caption = 'View Dyn. Inv. Content';
                    ToolTip = 'Executes the View Dyn. Inv. Content action.';
                    Image = View;

                    trigger OnAction()
                    var
                        DynamicInvoiceContent: Record "Dynamic Inv. Content";
                        DynaInvContentCalc: Codeunit "Dynamic Inv. Content Calc.";
                        MessageLbl: Label 'No Dynamic content could be found for this Invoice';
                    begin
                        DynaInvContentCalc.PopulateContentFromTemplate(Rec."No.");
                        //  Commit before RunModal
                        Commit();
                        DynamicInvoiceContent.SetRange("Invoice No.", Rec."No.");
                        if DynamicInvoiceContent.Count = 0 then Message(MessageLbl)
                        else
                            Page.RunModal(Page::"Dynamic Inv. Content", DynamicInvoiceContent);
                    end;
                }
                action("View Detailed Price Calc. Entry")
                {
                    ApplicationArea = All;
                    Caption = 'View Detailed Price Calculation Entries';
                    ToolTip = 'Executes the View Detailed Price Calculation Entries action.';
                    Image = View;

                    trigger OnAction()
                    var
                        DetailedPriceCalcEntry: Record "Detailed Price Calc. Entry";
                    begin
                        DetailedPriceCalcEntry.Reset();
                        DetailedPriceCalcEntry.FilterGroup(2);
                        DetailedPriceCalcEntry.SetRange("Document Type", Rec."Document Type");
                        DetailedPriceCalcEntry.SetRange("Invoice No.", Rec."No.");
                        DetailedPriceCalcEntry.FilterGroup(0);
                        if DetailedPriceCalcEntry.FindSet()then Page.RunModal(Page::"Detailed Price Calc. Entries", DetailedPriceCalcEntry);
                    end;
                }
            }
        }
    }
}
