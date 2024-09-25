table 50200 Toponym
{
    Caption = 'Toponym';
    LookupPageId = Toponyms;

    fields
    {
        field(1; Toponym; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Toponym';
        }
    }
    keys
    {
        key(Key1; Toponym)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
