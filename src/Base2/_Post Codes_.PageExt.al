pageextension 50202 "Post Codes" extends "Post Codes"
{
    layout
    {
        addafter(City)
        {
            field("City in Deutsch"; Rec."City in Deutsch")
            {
                ToolTip = 'Specifies the value of the City in Deutsch field';
                ApplicationArea = All;
                Caption = 'City in Deutsch';
            }
        }
        addafter("Country/Region Code")
        {
            field("County Code"; Rec."County Code")
            {
                ToolTip = 'Specifies the value of the County Code field';
                ApplicationArea = All;
                Caption = 'County Code';

                trigger OnValidate()
                var
                begin
                    Rec.GetCountry();
                end;
            }
            field("ISTAT Code"; Rec."ISTAT Code")
            {
                Tooltip = 'Specifies the value of the ISTAT Code field';
                ApplicationArea = All;
                Caption = 'ISTAT Code';
            }
        }
    }
}
