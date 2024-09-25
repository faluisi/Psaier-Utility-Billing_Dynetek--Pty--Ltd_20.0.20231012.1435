page 50247 "Dynamic Inv. Template"
{
    ApplicationArea = All;
    Caption = 'Dynamic Invoice Template';
    PageType = List;
    SourceTable = "Dynamic Inv. Content Template";
    UsageCategory = Lists;
    SourceTableView = sorting("Section Code", "Line No.", "Customer No.")order(ascending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    Visible = false;
                    Caption = 'Entry No.';
                }
                field("Section Code"; Rec."Section Code")
                {
                    ToolTip = 'Specifies the value of the Section Code field.';
                    Caption = 'Section Code';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Customer No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Customer No. field.';
                    Caption = 'Line No.';
                }
                field("Caption Entry No."; Rec."Caption Entry No.")
                {
                    ToolTip = 'Links the entry to a Dynamic Invoice Caption record for setting multi language captions';
                    Caption = 'Caption No.';
                }
                field("ENG Caption"; Rec."English Caption")
                {
                    ToolTip = 'English caption related to this template entry';
                    Caption = 'ENG Caption';
                }
                field("IT Caption"; Rec."Italian Caption")
                {
                    ToolTip = 'Italian caption related to this template entry';
                    Caption = 'IT Caption';
                }
                field("DE Caption"; Rec."German Caption")
                {
                    ToolTip = 'German caption related to this template entry';
                    Caption = 'DE Caption';
                }
                // --- Column 1 ---
                field("Fixed Value 1"; Rec."Fixed Value 1")
                {
                    ToolTip = 'Set a fixed value for Column 1 for this Template Entry';
                    Caption = 'Fixed Value 1';
                }
                field("Fixed Value 1 DE"; Rec."Fixed Value 1 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 1 DE field.';
                }
                field("Fixed Value 1 IT"; Rec."Fixed Value 1 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 1 IT field.';
                }
                field("Lookup Table1 Name"; Rec."Table 1 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 1 for this Template Entry';
                    Caption = 'Table 1 Name';
                }
                field("Lookup Field1 Name"; Rec."Field 1 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 1 for this Template Entry';
                    Caption = 'Field 1 Name';
                }
                field("Format 1"; Rec."Format 1")
                {
                    ToolTip = 'Set the format of the final result. %1 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 1';
                }
                field("Lookup Format Arg 1"; Rec."Lookup Format Arg 1")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 1';
                }
                field("Lookup Table 1 No."; Rec."Table 1 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 1 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 1 No.';
                }
                field("Lookup Field 1 No."; Rec."Field 1 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 1 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 1 No.';
                }
                // --- Column 2 ---
                field("Fixed Value 2"; Rec."Fixed Value 2")
                {
                    ToolTip = 'Set a fixed value for Column 2 for this Template Entry';
                    Caption = 'Fixed Value 2';
                }
                field("Fixed Value 2 DE"; Rec."Fixed Value 2 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 2 DE field.', Comment = '%';
                }
                field("Fixed Value 2 IT"; Rec."Fixed Value 2 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 2 IT field.', Comment = '%';
                }
                field("Lookup Table2 Name"; Rec."Table 2 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 2 for this Template Entry';
                    Caption = 'Table 2 Name';
                }
                field("Lookup Field2 Name"; Rec."Field 2 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 2 for this Template Entry';
                    Caption = 'Field 2 Name';
                }
                field("Format 2"; Rec."Format 2")
                {
                    ToolTip = 'Set the format of the final result. %2 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 2';
                }
                field("Lookup Format Arg 2"; Rec."Lookup Format Arg 2")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 2';
                }
                field("Lookup Table 2 No."; Rec."Table 2 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 2 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 2 No.';
                }
                field("Lookup Field 2 No."; Rec."Field 2 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 2 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 2 No.';
                }
                // --- Column 3 ---
                field("Fixed Value 3"; Rec."Fixed Value 3")
                {
                    ToolTip = 'Set a fixed value for Column 3 for this Template Entry';
                    Caption = 'Fixed Value 3';
                }
                field("Fixed Value 3 DE"; Rec."Fixed Value 3 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 3 DE field.', Comment = '%';
                }
                field("Fixed Value 3 IT"; Rec."Fixed Value 3 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 3 IT field.', Comment = '%';
                }
                field("Lookup Table3 Name"; Rec."Table 3 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 3 for this Template Entry';
                    Caption = 'Table 3 Name';
                }
                field("Lookup Field3 Name"; Rec."Field 3 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 3 for this Template Entry';
                    Caption = 'Field 3 Name';
                }
                field("Format 3"; Rec."Format 3")
                {
                    ToolTip = 'Set the format of the final result. %3 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 3';
                }
                field("Lookup Format Arg 3"; Rec."Lookup Format Arg 3")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 3';
                }
                field("Lookup Table 3 No."; Rec."Table 3 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 3 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 3 No.';
                }
                field("Lookup Field 3 No."; Rec."Field 3 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 3 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 3 No.';
                }
                // --- Column 4 ---
                field("Fixed Value 4"; Rec."Fixed Value 4")
                {
                    ToolTip = 'Set a fixed value for Column 4 for this Template Entry';
                    Caption = 'Fixed Value 4';
                }
                field("Fixed Value 4 DE"; Rec."Fixed Value 4 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 4 DE field.', Comment = '%';
                }
                field("Fixed Value 4 IT"; Rec."Fixed Value 4 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 4 IT field.', Comment = '%';
                }
                field("Lookup Table4 Name"; Rec."Table 4 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 4 for this Template Entry';
                    Caption = 'Table 4 Name';
                }
                field("Lookup Field4 Name"; Rec."Field 4 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 4 for this Template Entry';
                    Caption = 'Field 4 Name';
                }
                field("Format 4"; Rec."Format 4")
                {
                    ToolTip = 'Set the format of the final result. %4 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 4';
                }
                field("Lookup Format Arg 4"; Rec."Lookup Format Arg 4")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 4';
                }
                field("Lookup Table 4 No."; Rec."Table 4 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 4 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 4 No.';
                }
                field("Lookup Field 4 No."; Rec."Field 4 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 4 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 4 No.';
                }
                // --- Column 5 ---
                field("Fixed Value 5"; Rec."Fixed Value 5")
                {
                    ToolTip = 'Set a fixed value for Column 5 for this Template Entry';
                    Caption = 'Fixed Value 5';
                }
                field("Fixed Value 5 DE"; Rec."Fixed Value 5 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 5 DE field.', Comment = '%';
                }
                field("Fixed Value 5 IT"; Rec."Fixed Value 5 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 5 IT field.', Comment = '%';
                }
                field("Lookup Table5 Name"; Rec."Table 5 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 5 for this Template Entry';
                    Caption = 'Table 5 Name';
                }
                field("Lookup Field5 Name"; Rec."Field 5 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 5 for this Template Entry';
                    Caption = 'Field 5 Name';
                }
                field("Format 5"; Rec."Format 5")
                {
                    ToolTip = 'Set the format of the final result. %5 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 5';
                }
                field("Lookup Format Arg 5"; Rec."Lookup Format Arg 5")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 5';
                }
                field("Lookup Table 5 No."; Rec."Table 5 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 5 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 5 No.';
                }
                field("Lookup Field 5 No."; Rec."Field 5 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 5 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 5 No.';
                }
                // --- Column 6 ---
                field("Fixed Value 6"; Rec."Fixed Value 6")
                {
                    ToolTip = 'Set a fixed value for Column 6 for this Template Entry';
                    Caption = 'Fixed Value 6';
                }
                field("Fixed Value 6 DE"; Rec."Fixed Value 6 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 6 DE field.', Comment = '%';
                }
                field("Fixed Value 6 IT"; Rec."Fixed Value 6 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 6 IT field.', Comment = '%';
                }
                field("Lookup Table6 Name"; Rec."Table 6 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 6 for this Template Entry';
                    Caption = 'Table 6 Name';
                }
                field("Lookup Field6 Name"; Rec."Field 6 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 6 for this Template Entry';
                    Caption = 'Field 6 Name';
                }
                field("Format 6"; Rec."Format 6")
                {
                    ToolTip = 'Set the format of the final result. %6 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 6';
                }
                field("Lookup Format Arg 6"; Rec."Lookup Format Arg 6")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 6';
                }
                field("Lookup Table 6 No."; Rec."Table 6 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 6 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 6 No.';
                }
                field("Lookup Field 6 No."; Rec."Field 6 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 6 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 6 No.';
                }
                // --- Column 7 ---
                field("Fixed Value 7"; Rec."Fixed Value 7")
                {
                    ToolTip = 'Set a fixed value for Column 7 for this Template Entry';
                    Caption = 'Fixed Value 7';
                }
                field("Fixed Value 7 DE"; Rec."Fixed Value 7 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 7 DE field.', Comment = '%';
                }
                field("Fixed Value 7 IT"; Rec."Fixed Value 7 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 7 IT field.', Comment = '%';
                }
                field("Lookup Table7 Name"; Rec."Table 7 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 7 for this Template Entry';
                    Caption = 'Table 7 Name';
                }
                field("Lookup Field7 Name"; Rec."Field 7 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 7 for this Template Entry';
                    Caption = 'Field 7 Name';
                }
                field("Format 7"; Rec."Format 7")
                {
                    ToolTip = 'Set the format of the final result. %7 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 7';
                }
                field("Lookup Format Arg 7"; Rec."Lookup Format Arg 7")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 7';
                }
                field("Lookup Table 7 No."; Rec."Table 7 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 7 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 7 No.';
                }
                field("Lookup Field 7 No."; Rec."Field 7 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 7 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 7 No.';
                }
                //KB12032024 - Dynamic Invoice Column 8 added +++
                field("Fixed Value 8"; Rec."Fixed Value 8")
                {
                    ToolTip = 'Set a fixed value for Column 8 for this Template Entry';
                    Caption = 'Fixed Value 8';
                }
                field("Fixed Value 8 DE"; Rec."Fixed Value 8 DE")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 8 DE field.', Comment = '%';
                }
                field("Fixed Value 8 IT"; Rec."Fixed Value 8 IT")
                {
                    ToolTip = 'Specifies the value of the Fixed Value 8 IT field.', Comment = '%';
                }
                field("Lookup Table8 Name"; Rec."Table 8 Name")
                {
                    ToolTip = 'Set related table for lookup a value for Column 8 for this Template Entry';
                    Caption = 'Table 8 Name';
                }
                field("Lookup Field8 Name"; Rec."Field 8 Name")
                {
                    ToolTip = 'Set related field for lookup a value for Column 8 for this Template Entry';
                    Caption = 'Field 8 Name';
                }
                field("Format 8"; Rec."Format 8")
                {
                    ToolTip = 'Set the format of the final result. %8 will be replaced by the lookup result. (Quick way to setup a prefix and suffix)';
                    Caption = 'Format 8';
                }
                field("Lookup Format Arg 8"; Rec."Lookup Format Arg 8")
                {
                    ToolTip = 'BC Format code used on the lookup result. Such as rounding and date formats';
                    Visible = false;
                    Caption = 'Lookup Format 8';
                }
                field("Lookup Table 8 No."; Rec."Table 8 No.")
                {
                    ToolTip = 'The related Table ID to be used for lookup for Column 8 for this Template Entry';
                    Visible = false;
                    Caption = 'Table 8 No.';
                }
                field("Lookup Field 8 No."; Rec."Field 8 No.")
                {
                    ToolTip = 'The related Field ID to be used for lookup for Column 8 for this Template Entry';
                    Visible = false;
                    Caption = 'Field 8 No.';
                }
                //KB12032024 - Dynamic Invoice Column 8 added ---
                // Misc Fields
                field("Bold"; Rec.Bold)
                {
                    Caption = 'Bold';
                    ToolTip = 'Specifies the value of the Bold field.';
                }
                field("Promoted"; Rec.Promoted)
                {
                    Caption = 'Promoted';
                    ToolTip = 'Specifies the value of the Promoted field.';
                }
                field("Show on Graph"; Rec."Show on Graph")
                {
                    Caption = 'Show on Graph';
                    ToolTip = 'Specifies the value of the Show on Graph field.';
                }
                field("Contains Sales Line Link"; Rec."Contains Sales Line Link")
                {
                    Visible = false;
                    Caption = 'Contains Sales Line Link';
                    ToolTip = 'Specifies the value of Contains sales line link field.';
                }
            }
        }
    }
}
