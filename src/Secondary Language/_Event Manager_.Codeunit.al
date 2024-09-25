codeunit 50200 "Event Manager"
{
    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'First Name', false, false)]
    local procedure OnAfterValidateFirstName(var Rec: Record Customer)
    begin
        if Rec."Customer Type" = Rec."Customer Type"::Person then Rec.Name:=Rec."First Name" + ' ' + Rec."Last Name";
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Last Name', false, false)]
    local procedure OnAfterValidateLastName(var Rec: Record Customer)
    begin
        if Rec."Customer Type" = Rec."Customer Type"::Person then Rec.Name:=Rec."First Name" + ' ' + Rec."Last Name";
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Address', false, false)]
    local procedure OnAfterValidateAddress(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Address 2', false, false)]
    local procedure OnAfterValidateAddress2(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterLookupCity', '', false, false)]
    local procedure OnAfterValidateCity(var Customer: Record Customer)
    var
        PostCode: Record "Post Code";
    begin
        PostCode.SetRange(City, Customer."City");
        if not PostCode.IsEmpty() and PostCode.FindFirst()then begin
            Customer.Validate("County Code", PostCode."County Code");
            Customer.Validate("ISTAT Code", PostCode."ISTAT Code");
            Customer.UpdateAddress();
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventCity(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Country/Region Code', false, false)]
    local procedure OnAfterValidateCountryRegionCode(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'County', false, false)]
    local procedure OnAfterValidateCounty(var Rec: Record Customer)
    var
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Post Code', false, false)]
    local procedure OnAfterValidatePostCode(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'ISTAT Code', false, false)]
    local procedure OnAfterValidateEventISTATCode(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'City', false, false)]
    local procedure OnAfterValidateEventCity(var Rec: Record Customer)
    begin
        Rec.UpdateAddress();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterInsertEvent, '', false, false)]
    local procedure SetPreferredAddressOnAfterInsertEvent(var Rec: Record "Sales Header")
    var
        InvoiceGenerationManagement: Codeunit "Invoice Generation Management";
    begin
        if Rec."Document Type" <> "Sales Document Type"::Invoice then exit;
        InvoiceGenerationManagement.GetSecondaryLanguage(Rec);
    end;
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure OnBeforeInsertEvent(var Rec: Record Customer)
    begin
        Rec."Language Code":=Rec."Customer Language Code";
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure SalesLine_OnBeforeDeleteEvent(var Rec: Record "Sales Line")
    var
        DetailedPriceCalcEntries: Record "Detailed Price Calc. Entry";
    begin
        DetailedPriceCalcEntries.Reset();
        DetailedPriceCalcEntries.SetRange("Document Type", DetailedPriceCalcEntries."Document Type"::Invoice);
        DetailedPriceCalcEntries.SetRange("Invoice No.", Rec."Document No.");
        DetailedPriceCalcEntries.SetRange("Line No.", Rec."Line No.");
        if DetailedPriceCalcEntries.FindSet()then DetailedPriceCalcEntries.DeleteAll();
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Payment Terms Code', false, false)]
    local procedure OnCreatePaymentLinesSalesOnBeforePaymentLinesInsert(var Rec: Record "Sales Header")
    var
        PaymentDateLines: Record "Payment Lines";
    begin
        PaymentDateLines.Reset();
        PaymentDateLines.SetRange("Sales/Purchase", PaymentDateLines."Sales/Purchase"::Sales);
        PaymentDateLines.SetRange(Type, PaymentDateLines.Type::Invoice);
        PaymentDateLines.SetRange(Code, Rec."No.");
        if PaymentDateLines.FindLast()then Rec.Validate("Due Date", PaymentDateLines."Due Date");
    end;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure SalesHeader_OnBeforeDeletEvent(var Rec: Record "Sales Header")
    var
        UTFAnnual: Record "UTF Annual List";
    begin
        UTFAnnual.Reset();
        UTFAnnual.SetRange("Document No.", Rec."No.");
        if UTFAnnual.FindSet()then UTFAnnual.DeleteAll();
    end;
}
