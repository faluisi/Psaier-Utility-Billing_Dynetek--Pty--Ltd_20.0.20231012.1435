table 50243 "Quadro"
{
    Caption = 'Quadro';
    LookupPageId = "Quadro List";
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Output; Code[20])
        {
            Caption = 'Output';
        }
        field(2; Description; Text[250])
        {
            Caption = 'Description';
        }
    }
    keys
    {
        key(PK; Output)
        {
            Clustered = true;
        }
    }
}
