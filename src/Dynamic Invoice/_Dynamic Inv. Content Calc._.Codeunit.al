codeunit 50217 "Dynamic Inv. Content Calc."
{
    trigger OnRun()
    begin
    end;
    /// <summary>
    /// Populate Bill Contents From Bill Template.
    /// Stage 1
    /// </summary>
    procedure PopulateContentFromTemplate(InvNo: Code[20])
    var
        CustomerLedgerEntry: Record "Cust. Ledger Entry";
        OutstandingInvoiceLine: Record "Dyn. Inv. Outstanding Invoice";
        BillContent: Record "Dynamic Inv. Content";
        BillContentTemplate: Record "Dynamic Inv. Content Template";
        TempBillContentTemplate: Record "Dynamic Inv. Content Template" temporary;
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        Language: Record Language;
        salesLine: Record "Sales Line";
        Contract: Record Contract;
        Measurement: Record Measurement;
        TarrifList: Record "Tariff Line";
        DynamicTotalTemplateList: List of[Integer];
        DynamicTotalTemplateNo: Integer;
        relatedLineNo: Integer;
        StartDate: Date;
        EndDate: Date;
        ThanksVar: text[20];
        AllInvoicePaidVar: text[100];
        AllInvoicePaidLbl: Label 'All Invoices appear paid until %1', Comment = 'All Invoices appear paid until %1';
        AllInvoicePaidGermenLbl: Label 'Alle Rechnungen bis zum %1 scheinen als bezahlt auf.', Comment = 'Alle Rechnungen bis zum %1 scheinen als bezahlt auf.';
        AllInvoicePaidItalianLbl: Label 'Le precedenti bollette fino al %1 risultano pagate.', Comment = 'Le precedenti bollette fino al %1 risultano pagate.';
        ThanksLbl: Label 'Thanks';
        ThankLbleGermenLbl: Label 'Danke', Comment = 'Danke';
        ThanksLblItalianLbl: Label 'Grazie', Comment = 'Grazie';
    begin
        SetCurrSalesHeader(InvNo);
        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, InvNo)then if Customer.Get(SalesHeader."Sell-to Customer No.")then if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: begin
                        ThanksVar:=ThanksLblItalianLbl;
                        AllInvoicePaidVar:=AllInvoicePaidItalianLbl;
                    end;
                    2064: begin
                        ThanksVar:=ThanksLblItalianLbl;
                        AllInvoicePaidVar:=AllInvoicePaidItalianLbl;
                    end;
                    5127: begin
                        ThanksVar:=ThankLbleGermenLbl;
                        AllInvoicePaidVar:=AllInvoicePaidGermenLbl;
                    end;
                    3079: begin
                        ThanksVar:=ThankLbleGermenLbl;
                        AllInvoicePaidVar:=AllInvoicePaidGermenLbl;
                    end;
                    4103: begin
                        ThanksVar:=ThankLbleGermenLbl;
                        AllInvoicePaidVar:=AllInvoicePaidGermenLbl;
                    end;
                    1031: begin
                        ThanksVar:=ThankLbleGermenLbl;
                        AllInvoicePaidVar:=AllInvoicePaidGermenLbl;
                    end;
                    else
                    begin
                        ThanksVar:=ThanksLbl;
                        AllInvoicePaidVar:=AllInvoicePaidLbl;
                    end;
                    end;
                end
                else
                begin
                    ThanksVar:=ThanksLbl;
                    AllInvoicePaidVar:=AllInvoicePaidLbl;
                end;
        // Remove All Existing Entries
        BillContent.SetRange("Invoice No.", InvNo);
        if BillContent.FindSet()then BillContent.DeleteAll();
        // Get all "universal" setups
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.DeleteAll();
        BillContentTemplate.Reset();
        BillContentTemplate.SetFilter("Customer No.", '%1', '');
        if BillContentTemplate.FindSet()then repeat TempBillContentTemplate.Init();
                TempBillContentTemplate.TransferFields(BillContentTemplate);
                TempBillContentTemplate.Insert();
            until BillContentTemplate.Next() = 0;
        // Get any Customer Spesific exceptions
        BillContentTemplate.Reset();
        BillContentTemplate.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        if BillContentTemplate.FindFirst()then repeat // Remove Global template entry
                TempBillContentTemplate.SetFilter("Customer No.", '%1', '');
                TempBillContentTemplate.SetRange("Section Code", BillContentTemplate."Section Code");
                TempBillContentTemplate.SetRange("Line No.", BillContentTemplate."Line No.");
                if TempBillContentTemplate.FindFirst()then TempBillContentTemplate.Delete();
                // Add mark for the Customer Spesific template
                TempBillContentTemplate.Reset();
                TempBillContentTemplate.Init();
                TempBillContentTemplate.TransferFields(BillContentTemplate);
                TempBillContentTemplate.Insert();
            until BillContentTemplate.Next() = 0;
        // [1/3] Use Template to populate Formatted Data (No Sales Line Data)
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Contains Measurement Link", false);
        TempBillContentTemplate.SetRange("Contains Sales Line Link", false);
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", false);
        if TempBillContentTemplate.FindFirst()then repeat BillContent.Init();
                BillContent."Invoice No.":=SalesHeader."No.";
                BillContent."Section Code":=TempBillContentTemplate."Section Code";
                BillContent."Line No.":=TempBillContentTemplate."Line No.";
                BillContent.Bold:=TempBillContentTemplate.Bold;
                BillContent.Promoted:=TempBillContentTemplate.Promoted;
                BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, -1, false, -1);
                BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, -1, false, -1);
                BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, -1, false, -1);
                BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, -1, false, -1);
                BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, -1, false, -1);
                BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, -1, false, -1);
                BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, -1, false, -1);
                BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, -1, false, -1);
                BillContent.Insert();
            until TempBillContentTemplate.Next() = 0;
        // [2/3] Add Everything with Multiple Lines
        // [A] Sales Line
        salesLine.SetRange("Document Type", SalesHeader."Document Type");
        salesLine.SetRange("Document No.", SalesHeader."No.");
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Contains Sales Line Link", true);
        TempBillContentTemplate.SetRange("Contains Measurement Link", false);
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", false);
        if TempBillContentTemplate.FindFirst()then repeat relatedLineNo:=TempBillContentTemplate."Line No.";
                if TempBillContentTemplate."Section Code" = TempBillContentTemplate."Section Code"::"Invoice Composition" then begin
                    salesLine.SetRange("Dyn. Inv. Template No.");
                    if salesLine.FindFirst()then begin
                        repeat if not DynamicTotalTemplateList.Contains(salesLine."Dyn. Inv. Template No.")then DynamicTotalTemplateList.Add(salesLine."Dyn. Inv. Template No.");
                        until salesLine.Next() = 0;
                        foreach DynamicTotalTemplateNo in DynamicTotalTemplateList do begin
                            BillContent.Init();
                            BillContent."Invoice No.":=SalesHeader."No.";
                            BillContent."Section Code":=TempBillContentTemplate."Section Code";
                            BillContent."Line No.":=relatedLineNo;
                            relatedLineNo+=10000;
                            BillContent.Bold:=TempBillContentTemplate.Bold;
                            BillContent.Promoted:=TempBillContentTemplate.Promoted;
                            BillContent."Caption Entry No.":=GetCaptionEnrtyNo(DynamicTotalTemplateNo);
                            BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, -1, true, DynamicTotalTemplateNo);
                            BillContent.Insert();
                        end;
                    end;
                end
                else if(TempBillContentTemplate."Section Code" = TempBillContentTemplate."Section Code"::"Excise Tax") or (TempBillContentTemplate."Section Code" = TempBillContentTemplate."Section Code"::"Electricity Bill")then begin
                        salesLine.SetRange("Dyn. Inv. Template No.");
                        TarrifList.Reset();
                        TarrifList.SetRange("Tariff No.", SalesHeader."Tariff No.");
                        TarrifList.SetRange("Line Cost Type", TarrifList."Line Cost Type"::"Acciso Cost");
                        if TarrifList.FindFirst()then begin
                            BillContent.Init();
                            BillContent."Invoice No.":=SalesHeader."No.";
                            BillContent."Section Code":=TempBillContentTemplate."Section Code";
                            BillContent."Line No.":=relatedLineNo;
                            relatedLineNo+=10000;
                            BillContent.Bold:=TempBillContentTemplate.Bold;
                            BillContent.Promoted:=TempBillContentTemplate.Promoted;
                            BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                            BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, -1, true, TarrifList."Dyn. Inv. Template No.");
                            BillContent.Insert();
                        end;
                    end
                    else
                    begin
                        salesLine.SetRange("Dyn. Inv. Template No.", TempBillContentTemplate."Entry No.");
                        if salesLine.FindSet()then repeat BillContent.Init();
                                BillContent."Invoice No.":=SalesHeader."No.";
                                BillContent."Section Code":=TempBillContentTemplate."Section Code";
                                BillContent."Line No.":=relatedLineNo;
                                relatedLineNo+=10000;
                                BillContent.Bold:=TempBillContentTemplate.Bold;
                                BillContent.Promoted:=TempBillContentTemplate.Promoted;
                                BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                                BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, salesLine."Line No.", false, -1);
                                BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, salesLine."Line No.", false, -1);
                                BillContent.Insert();
                            until salesLine.Next() = 0;
                    end;
            until TempBillContentTemplate.Next() = 0;
        // [B] Populate + add Outstanding Invoices
        Clear(CustomerLedgerEntry);
        CustomerLedgerEntry.SetRange(Open, true);
        CustomerLedgerEntry.SetRange("Document Type", "Gen. Journal Document Type"::Invoice);
        CustomerLedgerEntry.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        CustomerLedgerEntry.SetFilter("Posting Date", '<%1', SalesHeader."Posting Date");
        if CustomerLedgerEntry.FindSet()then begin
            Clear(OutstandingInvoiceLine);
            OutstandingInvoiceLine.SetRange("Target Document No.", InvNo);
            if not OutstandingInvoiceLine.IsEmpty()then OutstandingInvoiceLine.DeleteAll();
            relatedLineNo:=0;
            // [B1] Populate temp  table with Remaining Invoice Info
            repeat Clear(OutstandingInvoiceLine);
                OutstandingInvoiceLine.Init();
                relatedLineNo+=10000;
                OutstandingInvoiceLine."Target Document No.":=InvNo;
                OutstandingInvoiceLine."Invoice No.":=CustomerLedgerEntry."Document No.";
                OutstandingInvoiceLine."Line No.":=relatedLineNo;
                CustomerLedgerEntry.CalcFields("Remaining Amount");
                OutstandingInvoiceLine."Remaining Amount":=CustomerLedgerEntry."Remaining Amount";
                OutstandingInvoiceLine."Status Description":='Bill: ' + Format(CustomerLedgerEntry."Document No.") + ' Due: ' + Format(CustomerLedgerEntry."Due Date");
                OutstandingInvoiceLine.Insert();
            until CustomerLedgerEntry.Next() = 0;
        end;
        // [B2] Using the entries added, Map to the relevant sections
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Contains Sales Line Link", false);
        TempBillContentTemplate.SetRange("Contains Measurement Link", false);
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", true);
        if TempBillContentTemplate.FindFirst()then repeat relatedLineNo:=TempBillContentTemplate."Line No.";
                OutstandingInvoiceLine.Reset();
                if OutstandingInvoiceLine.FindSet()then repeat BillContent.Init();
                        BillContent."Invoice No.":=SalesHeader."No.";
                        BillContent."Section Code":=TempBillContentTemplate."Section Code";
                        relatedLineNo+=10000;
                        BillContent."Line No.":=relatedLineNo;
                        BillContent.Bold:=TempBillContentTemplate.Bold;
                        BillContent.Promoted:=TempBillContentTemplate.Promoted;
                        // 2023 For Overview we ignore the caption linked to the template. There are only 2x coulmns mapped on layout.
                        // Col2 and Col3
                        BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                        TempBillContentTemplate.SetBlankZeros(true);
                        BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, OutstandingInvoiceLine."Line No.", false, -1);
                        BillContent.Insert();
                    until OutstandingInvoiceLine.Next() = 0
                else
                begin
                    BillContent.Init();
                    BillContent."Invoice No.":=SalesHeader."No.";
                    BillContent."Section Code":=TempBillContentTemplate."Section Code";
                    relatedLineNo+=10000;
                    BillContent."Line No.":=relatedLineNo;
                    BillContent.Bold:=TempBillContentTemplate.Bold;
                    BillContent.Promoted:=TempBillContentTemplate.Promoted;
                    BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                    TempBillContentTemplate.SetBlankZeros(true);
                    BillContent."Column 1":=StrSubstNo(AllInvoicePaidVar, Format(SalesHeader."Posting Date", 0, '<Month Text> <Closing><Day>, <Year4>'));
                    BillContent."Column 2":='';
                    BillContent."Column 3":='';
                    BillContent."Column 4":='';
                    BillContent."Column 5":='';
                    BillContent."Column 6":='';
                    BillContent."Column 7":='';
                    BillContent."Column 8":='';
                    BillContent.Insert();
                    BillContent.Init();
                    BillContent."Invoice No.":=SalesHeader."No.";
                    BillContent."Section Code":=TempBillContentTemplate."Section Code";
                    relatedLineNo+=10000;
                    BillContent."Line No.":=relatedLineNo;
                    BillContent.Bold:=TempBillContentTemplate.Bold;
                    BillContent.Promoted:=TempBillContentTemplate.Promoted;
                    BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                    TempBillContentTemplate.SetBlankZeros(true);
                    BillContent."Column 1":='';
                    BillContent."Column 2":=ThanksVar;
                    BillContent."Column 3":='';
                    BillContent."Column 4":='';
                    BillContent."Column 5":='';
                    BillContent."Column 6":='';
                    BillContent."Column 7":='';
                    BillContent."Column 8":='';
                    BillContent.Insert();
                end;
            until TempBillContentTemplate.Next() = 0;
        // Cleanup
        Clear(OutstandingInvoiceLine);
        OutstandingInvoiceLine.SetRange("Target Document No.", InvNo);
        if not OutstandingInvoiceLine.IsEmpty()then OutstandingInvoiceLine.DeleteAll();
        // [3/3] Use Template to populate graph Data
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Show on Graph", true);
        TempBillContentTemplate.SetRange("Contains Sales Line Link", false); // -1 in line no wil cause error if mapped
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", false);
        TempBillContentTemplate.SetRange("Contains Measurement Link", false);
        if TempBillContentTemplate.FindFirst()then repeat BillContent.Init();
                BillContent."Invoice No.":=SalesHeader."No.";
                BillContent."Line No.":=TempBillContentTemplate."Line No.";
                BillContent.Bold:=TempBillContentTemplate.Bold;
                BillContent.Promoted:=TempBillContentTemplate.Promoted;
                BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                // Setup For Graph Entries
                BillContent."Section Code":=TempBillContentTemplate.GetRelatedGraphSectionCode();
                TempBillContentTemplate.SetFormatForGraphEntry(true);
                BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, -1, false, -1);
                BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, -1, false, -1);
                BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, -1, false, -1);
                BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, -1, false, -1);
                BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, -1, false, -1);
                BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, -1, false, -1);
                BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, -1, false, -1);
                BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, -1, false, -1);
                BillContent.Insert();
            until TempBillContentTemplate.Next() = 0;
        salesLine.Reset();
        salesLine.SetRange("Document Type", SalesHeader."Document Type");
        salesLine.SetRange("Document No.", SalesHeader."No.");
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Show on Graph", true);
        TempBillContentTemplate.SetRange("Contains Sales Line Link", true);
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", false);
        TempBillContentTemplate.SetRange("Contains Measurement Link", false);
        if TempBillContentTemplate.FindFirst()then repeat relatedLineNo:=TempBillContentTemplate."Line No.";
                if salesLine.FindFirst()then begin
                    repeat if not DynamicTotalTemplateList.Contains(salesLine."Dyn. Inv. Template No.")then DynamicTotalTemplateList.Add(salesLine."Dyn. Inv. Template No.");
                    until salesLine.Next() = 0;
                    foreach DynamicTotalTemplateNo in DynamicTotalTemplateList do begin
                        BillContent.Init();
                        BillContent."Invoice No.":=SalesHeader."No.";
                        relatedLineNo+=10000;
                        BillContent."Line No.":=relatedLineNo;
                        BillContent.Bold:=TempBillContentTemplate.Bold;
                        BillContent.Promoted:=TempBillContentTemplate.Promoted;
                        BillContent."Caption Entry No.":=GetCaptionEnrtyNo(DynamicTotalTemplateNo);
                        BillContent."Section Code":=TempBillContentTemplate.GetRelatedGraphSectionCode();
                        TempBillContentTemplate.SetFormatForGraphEntry(true);
                        BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, -1, true, DynamicTotalTemplateNo);
                        BillContent.Insert();
                    end;
                end;
            until TempBillContentTemplate.Next() = 0;
        GetDateInterval(SalesHeader."AAT Invoice Contract Period", StartDate, EndDate);
        TempBillContentTemplate.Reset();
        TempBillContentTemplate.SetRange("Contains Sales Line Link", false);
        TempBillContentTemplate.SetRange("Contains Inv. Overview Link", false);
        TempBillContentTemplate.SetRange("Contains Measurement Link", true);
        if TempBillContentTemplate.FindFirst()then repeat if Contract.Get(SalesHeader."Contract No.")then begin
                    Measurement.Reset();
                    Measurement.SetRange("POD No.", Contract."POD No.");
                    if TempBillContentTemplate."Section Code" = TempBillContentTemplate."Section Code"::"Consumption Billed" then Measurement.SetRange(Date, StartDate, EndDate)
                    else
                        Measurement.SetRange(Date, CalcDate('<-1M>', StartDate), EndDate);
                    if Measurement.FindSet()then repeat if TempBillContentTemplate."Section Code" = TempBillContentTemplate."Section Code"::"Consumption Billed" then begin
                                BillContent.Init();
                                BillContent."Invoice No.":=SalesHeader."No.";
                                BillContent."Section Code":=TempBillContentTemplate."Section Code";
                                relatedLineNo+=10000;
                                BillContent."Line No.":=relatedLineNo;
                                BillContent.Bold:=TempBillContentTemplate.Bold;
                                BillContent.Promoted:=TempBillContentTemplate.Promoted;
                                BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                                BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, Measurement."Entry No.", true, -1);
                                BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, Measurement."Entry No.", true, -1);
                                BillContent.Insert();
                            end
                            else
                            begin
                                BillContent.Init();
                                BillContent."Invoice No.":=SalesHeader."No.";
                                BillContent."Section Code":=TempBillContentTemplate."Section Code";
                                relatedLineNo+=10000;
                                BillContent."Line No.":=relatedLineNo;
                                BillContent.Bold:=TempBillContentTemplate.Bold;
                                BillContent.Promoted:=TempBillContentTemplate.Promoted;
                                BillContent."Caption Entry No.":=TempBillContentTemplate."Caption Entry No.";
                                BillContent."Column 1":=TempBillContentTemplate.CalculateColumnResults(1, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 2":=TempBillContentTemplate.CalculateColumnResults(2, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 3":=TempBillContentTemplate.CalculateColumnResults(3, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 4":=TempBillContentTemplate.CalculateColumnResults(4, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 5":=TempBillContentTemplate.CalculateColumnResults(5, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 6":=TempBillContentTemplate.CalculateColumnResults(6, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 7":=TempBillContentTemplate.CalculateColumnResults(7, InvNo, Measurement."Entry No.", false, -1);
                                BillContent."Column 8":=TempBillContentTemplate.CalculateColumnResults(8, InvNo, Measurement."Entry No.", false, -1);
                                BillContent.Insert();
                            end;
                        until Measurement.Next() = 0;
                end;
            until TempBillContentTemplate.Next() = 0;
    end;
    local procedure GetDateInterval(DatePeiord: Text; var StartDate: date; var EndDate: Date): Integer var
    begin
        Evaluate(StartDate, SelectStr(1, ConvertStr(DatePeiord, '.', ',')));
        Evaluate(EndDate, SelectStr(3, ConvertStr(DatePeiord, '.', ',')));
        exit(1 + DATE2DMY(EndDate, 2) - DATE2DMY(StartDate, 2) + 12 * (DATE2DMY(EndDate, 3) - DATE2DMY(StartDate, 3)));
    end;
    local procedure GetCaptionEnrtyNo(TemplateEntryNo: Integer): Integer var
        DynamicSection: Record "Dynamic Inv. Section";
        DynamicInvoiceTemplate: Record "Dynamic Inv. Content Template";
    begin
        if DynamicInvoiceTemplate.Get(TemplateEntryNo)then if DynamicSection.Get(DynamicInvoiceTemplate."Section Code")then exit(DynamicSection."Section Caption")
            else
                exit(0);
    end;
    /// <summary>
    /// Populate data after the invoice was created in BC
    /// Stage 3
    /// </summary>
    /// <param name="InvNo">Code[20].</param>
    procedure PopulateAfterInvoiceCreated(InvNo: Code[20])
    var
    begin
        SetCurrSalesHeader(InvNo);
    end;
    // --- Methods to add new contents ---
    procedure SetCurrSalesHeader(InvNo: Code[20])
    begin
        SalesHeader.Get(Enum::"Sales Document Type"::Invoice, InvNo);
        SalesHeaderSet:=true;
    end;
    procedure SetCurrSection(newCurrSection: Enum "Dynamic Invoice Sections")
    var
        DynamicInvContent: Record "Dynamic Inv. Content";
    begin
        // Allow calling the Set Fx back to back without performance impact
        if(currSection = newCurrSection)then exit;
        currSection:=newCurrSection;
        currSectionSet:=true;
        // Check that Sales Header was Set
        CheckGlobals();
        // Get the last Line No
        DynamicInvContent.Reset();
        DynamicInvContent.SetRange("Invoice No.", SalesHeader."No.");
        DynamicInvContent.SetRange("Section Code", currSection);
        if DynamicInvContent.FindLast()then LastLineNo:=DynamicInvContent."Line No."
        else
            LastLineNo:=0;
    end;
    local procedure CheckGlobals()
    var
        CurrentSelectionErr: Label '"Current Section" not set. Call SetCurrSection() before running this action.';
        SalesHeaderErr: Label '"Sales Header" not set. Call SetCurrSalesHeader() before running this action.';
    begin
        if SalesHeaderSet then Error(SalesHeaderErr);
        if currSectionSet then Error(CurrentSelectionErr);
    end;
    procedure InsertDynContentRow(labelCaptEntryNo: Integer; contents: Record "Dynamic Inv. Content")
    var
        NewBillContent: Record "Dynamic Inv. Content";
    begin
        CheckGlobals();
        NewBillContent.Init();
        NewBillContent."Invoice No.":=SalesHeader."No.";
        NewBillContent."Section Code":=currSection;
        LastLineNo+=10000;
        NewBillContent."Line No.":=LastLineNo;
        NewBillContent."Caption Entry No.":=labelCaptEntryNo;
        NewBillContent."Column 2":=contents."Column 2";
        NewBillContent."Column 3":=contents."Column 3";
        NewBillContent."Column 4":=contents."Column 4";
        NewBillContent."Column 5":=contents."Column 5";
        NewBillContent."Column 6":=contents."Column 6";
        NewBillContent."Column 7":=contents."Column 7";
        NewBillContent."Column 8":=contents."Column 8";
        NewBillContent.Insert();
    end;
    var SalesHeader: Record "Sales Header";
    currSectionSet: Boolean;
    SalesHeaderSet: Boolean;
    currSection: Enum "Dynamic Invoice Sections";
    LastLineNo: Integer;
}
