table 50217 "PS County"
{
    DataClassification = ToBeClassified;
    Caption = 'PS County';

    fields
    {
        field(1; Code; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Code';
        }
        field(5; Name; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
    }
    keys
    {
        key(pk; Code)
        {
            Clustered = true;
        }
    }
}
