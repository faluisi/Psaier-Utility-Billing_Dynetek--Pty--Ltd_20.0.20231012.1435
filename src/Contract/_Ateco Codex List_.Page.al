page 60101 "Ateco Codex List"
{
    ApplicationArea = All;
    Caption = 'Ateco Codex List';
    PageType = List;
    SourceTable = "Ateco Codex";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Ateco Codex No."; Rec."Ateco Codex No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Ateco Codex No. field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
