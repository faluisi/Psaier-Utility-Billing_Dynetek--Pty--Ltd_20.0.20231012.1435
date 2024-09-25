codeunit 50218 "Dynamic Inv. Filter Helper"
{
    /// <summary>
    /// Given Rec Ref set related filters
    /// </summary>
    /// <param name="recRef">The ref where filters should be set</param>
    /// <param name="relatedTemplateRecRef">Related Rec Ref for setting additional filters</param>
    procedure GetRelatedFilters(var recRef: RecordRef; relatedLineNo: Integer; RelatedDynInvTemplateNo: Integer; IsResource: Boolean; DynamicTotalTemplateNo: Integer)
    var
    // For Sales Line Filtering
    begin
        case recRef.RecordId.TableNo of Database::Contract: recRef.GetTable(contract);
        Database::Customer: recRef.GetTable(customer);
        Database::"Point of Delivery": recRef.GetTable(pointOfDelivery);
        Database::"Company Information": recRef.GetTable(companyInformation);
        Database::"Sales Header": recRef.GetTable(salesHeader);
        Database::"Sales Line": begin
            salesLine.Reset();
            salesLine.SetRange("Document Type", salesHeader."Document Type");
            salesLine.SetRange("Document No.", salesHeader."No.");
            if IsResource then salesLine.SetRange("Dyn. Inv. Template No.", DynamicTotalTemplateNo)
            else
                salesLine.SetRange("Line No.", relatedLineNo);
            recRef.GetTable(salesLine);
        end;
        Database::"Dyn. Inv. Outstanding Invoice": begin
            outstandingInvoiceLine.SetRange("Target Document No.", targetInvoiceNo);
            outstandingInvoiceLine.SetRange("Line No.", relatedLineNo);
            recRef.GetTable(outstandingInvoiceLine);
        end;
        Database::Measurement: begin
            Measurement.SetRange("Entry No.", relatedLineNo);
            recRef.GetTable(Measurement);
        end;
        end;
    end;
    /// <summary>
    /// Filter all tables that might be used for lookups to locate correct entries
    /// Using Sales Invoice as as strating point.
    /// </summary>
    /// <param name="salesInvNo">Curr Sales Invoice No</param>
    procedure SetRelatedSalesInv(salesInvNo: Code[20])
    begin
        targetInvoiceNo:=salesInvNo;
        // Set filters and findset > Filters used by recref, Findfirst used to continue filtering
        salesHeader.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        salesHeader.SetRange("No.", targetInvoiceNo);
        salesHeader.FindFirst();
        SetRelatedFilters(salesHeader."Sell-to Customer No.", salesHeader."Contract No.");
    end;
    /// <summary>
    /// Filter all tables that might be used for lookups to locate correct entries
    /// Using Posted Sales Invoice as as strating point.
    /// </summary>
    /// <param name="postedSalesInvNo">Curr Posted sales Invoice No</param>
    local procedure SetRelatedFilters(custNo: Code[20]; contractNo: Code[25])
    begin
        // Set filters and findset > Filters used by recref, Findfirst used to continue filtering
        // Customer
        customer.SetRange("No.", custNo);
        customer.FindFirst();
        // Contrat
        contract.SetRange("No.", contractNo);
        contract.SetRange(Status, Enum::"Contract Status"::Open);
        contract.FindFirst();
        // Point Of Delivery
        pointOfDelivery.SetRange("No.", contract."POD No.");
        pointOfDelivery.FindFirst();
    end;
    var contract: Record Contract;
    customer: Record Customer;
    pointOfDelivery: Record "Point of Delivery";
    companyInformation: Record "Company Information";
    salesHeader: Record "Sales Header";
    salesLine: Record "Sales Line";
    outstandingInvoiceLine: Record "Dyn. Inv. Outstanding Invoice";
    Measurement: Record Measurement;
    targetInvoiceNo: Code[20];
}
