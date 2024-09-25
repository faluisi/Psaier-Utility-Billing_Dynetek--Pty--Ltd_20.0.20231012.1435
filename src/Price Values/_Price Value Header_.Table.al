table 50232 "Price Value Header"
{
    Caption = 'Price Value';
    DataClassification = CustomerContent;
    LookupPageId = "Price Value Header List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(5; "Name"; Text[100])
        {
            Caption = 'Name';
        }
        field(25; "Effective Start Date"; Date)
        {
            Caption = 'Effective Start Date';
        }
        field(26; "Effective End Date"; Date)
        {
            Caption = 'Effective End Date';
        }
        //KB03042024 - Net Loss Update in Billing +++
        field(27; "Net Loss Type";Enum "Net Loss Type")
        {
            Caption = 'Net Loss Type';
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
        PriceValueLines: Record "Price Value Line";
    begin
        PriceValueLines.SetRange("Price Value No.", "No.");
        if not PriceValueLines.IsEmpty()then PriceValueLines.DeleteAll();
    end;
}
