table 50235 "VAT Manager Setup"
{
    //KB140224 - VAT Manager Setup added +++
    Caption = 'VAT Manager Setup';

    fields
    {
        field(1; "POD No."; Code[20])
        {
            Caption = 'POD Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                ErrorLbl: Label 'Lenght of POD Code must be 3.';
            begin
                if StrLen("POD No.") <> 3 then Error(ErrorLbl);
            end;
        }
        field(2; "Distributor No."; Code[20])
        {
            Caption = 'Distributor No.';
            DataClassification = ToBeClassified;
        }
        field(3; "Distributor Name"; Text[100])
        {
            Caption = 'Distributor Name';
            DataClassification = ToBeClassified;
        }
        field(4; "VAT Manager No."; Code[50])
        {
            Caption = 'VAT Manager No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "POD No.")
        {
            Clustered = true;
        }
    }
//KB140224 - VAT Manager Setup added ---
}
