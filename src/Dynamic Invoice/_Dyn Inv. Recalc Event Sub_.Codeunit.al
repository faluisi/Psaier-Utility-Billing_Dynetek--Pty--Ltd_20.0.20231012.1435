codeunit 50220 "Dyn Inv. Recalc Event Sub"
{
    trigger OnRun()
    begin
    end;
    /// <summary>
    /// Re Calculate Dynamic Inv Contents before printing
    /// </summary>
    /// <param name="SalesHeader">Record "Sales Header".</param>
    [EventSubscriber(ObjectType::CodeUnit, Codeunit::"Document-Print", 'OnBeforePrintProformaSalesInvoice', '', false, false)]
    local procedure OnBeforePrintProformaSalesInvoice(SalesHeader: Record "Sales Header")
    var
        ConfirmMsg: Label 'Refresh Dynamic Invoice Content before printing?';
    begin
        if not Confirm(ConfirmMsg)then exit;
        DynaInvContentCalc.PopulateContentFromTemplate(SalesHeader."No.");
        Commit();
    end;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostInvoice', '', false, false)]
    local procedure OnBeforePostInvoice(var SalesHeader: Record "Sales Header"; var CustLedgerEntry: Record "Cust. Ledger Entry"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]);
    begin
        DynaInvContentCalc.PopulateContentFromTemplate(SalesHeader."No.");
    end;
    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoice", 'OnBeforeSalesInvHeaderPrintRecords', '', false, false)]
    local procedure OnBeforeSalesInvHeaderPrintRecords(var SalesInvHeader: Record "Sales Invoice Header")
    var
        XMLExportManager: Codeunit "XML Export Manager";
    begin
        XMLExportManager.ExportEGlueFile(SalesInvHeader);
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line")
    begin
        SalesLine."VAT Amount":=SalesLine."Amount Including VAT" - SalesLine.Amount;
    end;
    var DynaInvContentCalc: Codeunit "Dynamic Inv. Content Calc.";
}
