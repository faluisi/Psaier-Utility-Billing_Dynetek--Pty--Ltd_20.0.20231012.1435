codeunit 50221 "AAT Attachment Events"
{
    trigger OnRun()
    begin
    end;
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", OnBeforeDrillDown, '', false, false)]
    local procedure OnBeforeDrillDownContractAttachment(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        Contract: Record Contract;
    begin
        case DocumentAttachment."Table ID" of Database::Contract: begin
            RecRef.Open(Database::Contract);
            if Contract.Get(DocumentAttachment."No.")then RecRef.GetTable(Contract);
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRefContractAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[25];
    begin
        case RecRef.Number of DATABASE::Contract: begin
            FieldRef:=RecRef.Field(1);
            RecNo:=FieldRef.Value;
            DocumentAttachment.SetRange("No.", RecNo);
        end;
        end;
    end;
    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRefContractAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[25];
    begin
        case RecRef.Number of DATABASE::Contract: begin
            FieldRef:=RecRef.Field(1);
            RecNo:=FieldRef.Value;
            DocumentAttachment.Validate("No.", RecNo);
        end;
        end;
    end;
}
