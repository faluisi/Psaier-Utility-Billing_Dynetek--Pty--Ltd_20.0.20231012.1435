table 60101 "Ateco Codex"
{
    Caption = 'Ateco Codex';
    DataClassification = ToBeClassified;
    LookupPageId = "Ateco Codex List";

    fields
    {
        field(1; "Ateco Codex No."; Code[20])
        {
            Caption = 'Ateco Codex No.';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; "Ateco Codex No.")
        {
            Clustered = true;
        }
    }
}
