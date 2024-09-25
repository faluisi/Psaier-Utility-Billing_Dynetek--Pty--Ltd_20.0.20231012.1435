page 50236 "Dynamic Inv. Content"
{
    ApplicationArea = All;
    Caption = 'Dynamic Invoice Content';
    PageType = List;
    SourceTable = "Dynamic Inv. Content";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Section Code"; Rec."Section Code")
                {
                    ToolTip = 'Specifies the value of the Section Code field';
                    Caption = 'Section Code';
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    ToolTip = 'Specifies the value of the Invoice No. field';
                    Caption = 'Invoice No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field';
                    Caption = 'Line No.';
                }
                field("Caption Entry No."; Rec."Caption Entry No.")
                {
                    ToolTip = 'Specifies';
                    Caption = 'Caption No.';
                }
                field("ENG Caption"; Rec."English Caption")
                {
                    Caption = 'ENG Caption';
                    ToolTip = 'Specifies the value of the ENG Caption field.';
                }
                field("IT Caption"; Rec."Italian Caption")
                {
                    Visible = false;
                    Caption = 'IT Caption';
                    ToolTip = 'Specifies the value of the IT Caption field.';
                }
                field("DE Caption"; Rec."German Caption")
                {
                    Visible = false;
                    Caption = 'DE Caption';
                    ToolTip = 'Specifies the value of the DE Caption field.';
                }
                field("Column 1"; Rec."Column 1")
                {
                    ToolTip = 'Specifies the value of the Column 1 field';
                    Caption = 'Column 1';
                }
                field("Column 2"; Rec."Column 2")
                {
                    ToolTip = 'Specifies the value of the Column 2 field';
                    Caption = 'Column 2';
                }
                field("Column 3"; Rec."Column 3")
                {
                    ToolTip = 'Specifies the value of the Column 3 field';
                    Caption = 'Column 3';
                }
                field("Column 4"; Rec."Column 4")
                {
                    ToolTip = 'Specifies the value of the Column 4 field';
                    Caption = 'Column 4';
                }
                field("Column 5"; Rec."Column 5")
                {
                    ToolTip = 'Specifies the value of the Column 5 field';
                    Caption = 'Column 5';
                }
                field("Column 6"; Rec."Column 6")
                {
                    ToolTip = 'Specifies the value of the Column 6 field';
                    Caption = 'Column 6';
                }
                field("Column 7"; Rec."Column 7")
                {
                    ToolTip = 'Specifies the value of the Column 7 field';
                    Caption = 'Column 7';
                }
                field("Column 8"; Rec."Column 8")
                {
                    Caption = 'Column 8';
                    ToolTip = 'Specifies the value of the Column 8 field';
                }
                field(Bold; Rec.Bold)
                {
                    ToolTip = 'Specifies the value of the Bold field';
                    Caption = 'Bold';
                }
                field(Promoted; Rec.Promoted)
                {
                    Caption = 'Promoted';
                    ToolTip = 'Specifies if the content of Column 1 will be Promoted';
                }
            }
        }
    }
}
