table 50202 "Secondary Language Address"
{
    Caption = 'Secondary Language Address';

    fields
    {
        field(1; "Source Type";Enum "Secondary Lang. Source Type")
        {
            Caption = 'Source Type';
            DataClassification = CustomerContent;
        }
        field(2; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            DataClassification = CustomerContent;
            TableRelation = "Source Code".Code;
        }
        field(3; "Language No."; Code[50])
        {
            Caption = 'Language No.';
            DataClassification = CustomerContent;
            TableRelation = Language;

            trigger OnValidate()
            var
                Language: Record Language;
            begin
                if Language.Get(Rec."Language No.")then Rec.Language:=Language.Name;
            end;
        }
        field(4; Language; Text[50])
        {
            Caption = 'Language';
            DataClassification = CustomerContent;
        }
        field(10; Type;Enum "Secondary Language Type")
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(15; "AAT CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CIV';
        }
        field(20; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(21; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(25; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if("Country No"=const(''))"Post Code"."City in Deutsch"
            else if("Country No"=filter(<>''))"Post Code"."City in Deutsch" where("Country/Region Code"=field("Country No"));
            ValidateTableRelation = true;
        }
        field(30; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = CustomerContent;
            TableRelation = if("Country No"=const(''))"Post Code".Code
            else if("Country No"=filter(<>''))"Post Code".Code where("Country/Region Code"=field("Country No"));
        }
        field(35; "County Code"; Code[10])
        {
            Caption = 'County Code';
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;

            trigger OnValidate()
            var
                County: Record "PS County";
            begin
                County.SetRange(Code, Rec."County Code");
                if not County.IsEmpty() and County.FindFirst()then Rec.County:=County.Name;
            end;
        }
        field(37; County; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'County';
        }
        field(40; "Country No"; Code[10])
        {
            Caption = 'Country/Region No.';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region";
        }
        field(45; "ISTAT Code"; Code[6])
        {
            Caption = 'ISTAT Code';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Source Type", "Source No.", "Language No.", Type)
        {
            Clustered = true;
        }
    }
}
