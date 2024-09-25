table 50230 "Tariff Header"
{
    Caption = 'Tariff Header';
    DataClassification = CustomerContent;
    LookupPageId = "Tariff List";

    fields
    {
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Description"; Text[100])
        {
            Caption = 'Description';
        }
        field(20; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
        }
        field(21; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
        }
        // AN 27112023 TASK002168  - Added below field ++ 
        field(22; COD_OFFERTA; Code[50])
        {
            Caption = 'COD OFFERTA';
            DataClassification = ToBeClassified;
        }
        // AN 27112023 TASK002168  - Added below field --
        // AN 29112023 TASK002140  - Added new field for Tariff Status ++
        field(23; Status;Enum "Tariff Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        // AN 29112023 TASK002140  - Added new field for Tariff Status --
        field(28; BTVE; Boolean)
        {
            Caption = 'BTVE';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    var
        TariffLines: Record "Tariff Line";
        Contract_LRec: Record Contract;
        ErrorLbl: Label 'You cannot delete the Tariff No. %1, as it is attached on contract %2 , please contact your administrator.', Comment = '%1 = Tariff No. , %2 = Contract No.';
    begin
        // AN 29112023 TASK002140  should not delete the Tariff if attached with Contract ++
        Contract_LRec.reset();
        Contract_LRec.SetRange("Tariff Option No.", Rec."No.");
        Contract_LRec.Setfilter(Status, '%1|%2', Contract_LRec.Status::Open, Contract_LRec.Status::"In Registration");
        if Contract_LRec.FindSet()then Error(ErrorLbl, rec."No.", Contract_LRec."No.");
        // AN 29112023 TASK002140  should not delete the Tariff if attached with Contract --
        TariffLines.SetRange("Tariff No.", Rec."No.");
        if not TariffLines.IsEmpty()then TariffLines.DeleteAll();
    end;
}
