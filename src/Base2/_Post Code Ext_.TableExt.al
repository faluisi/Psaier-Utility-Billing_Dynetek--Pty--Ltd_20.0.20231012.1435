tableextension 50201 "Post Code Ext" extends "Post Code"
{
    fields
    {
        field(50200; "City in Deutsch"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'City in Deutsch';
        }
        field(50205; "County Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;
            Caption = 'County Code';
        }
        field(50210; "ISTAT Code"; Code[6])
        {
            DataClassification = CustomerContent;
            Caption = 'ISTAT Code';
        }
    }
    keys
    {
        key(Key1; "County Code")
        {
        }
    }
    procedure GetCountry()
    var
        County: Record "PS County";
    begin
        County.Get(Rec."County Code");
        Rec.County:=CopyStr(County.Name, 1, MaxStrLen(Rec.County));
    end;
    var
}
