page 50214 "Secondary Addresses"
{
    ApplicationArea = All;
    Caption = 'Secondary Addresses';
    PageType = List;
    SourceTable = "Secondary Language Address";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Source Type"; Rec."Source Type")
                {
                    ToolTip = 'Specifies the value of the Source Type field.';
                    Caption = 'Source Type';
                }
                field("Source No."; Rec."Source No.")
                {
                    ToolTip = 'Specifies the value of the Source No. field.';
                    Caption = 'Source No.';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.';
                    Caption = 'Type';
                }
                field("Language No."; Rec."Language No.")
                {
                    ToolTip = 'Specifies the value of the Language No. field.';
                    Caption = 'Language No.';
                }
                field(Language; Rec.Language)
                {
                    ToolTip = 'Specifies the value of the Language field.';
                    Caption = 'Language';
                }
                field("AAT CIV PUB"; Rec."AAT CIV PUB")
                {
                    Caption = 'CIV';
                    ToolTip = 'Specifies the value of the CIV field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                    Caption = 'Address';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                    Caption = 'Address 2';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    Caption = 'City';
                }
                field("Country No"; Rec."Country No")
                {
                    ToolTip = 'Specifies the value of the Country/Region No. field.';
                    Caption = 'Country/Region No.';
                }
                field("County Code"; Rec."County Code")
                {
                    ToolTip = 'Specifies the value of the County Code field.';
                    Caption = 'County Code';
                }
                field(County; Rec.County)
                {
                    ToolTip = 'Specifies the value of the County field.';
                    Caption = 'County';
                }
                field("ISTAT Code"; Rec."ISTAT Code")
                {
                    ToolTip = 'Specifies the value of the ISTAT Code field.';
                    Caption = 'ISTAT Code';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                    Caption = 'Post Code';
                }
            }
        }
    }
}
