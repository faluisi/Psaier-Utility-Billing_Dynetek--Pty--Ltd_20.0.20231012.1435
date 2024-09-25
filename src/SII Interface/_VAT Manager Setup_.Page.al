page 50233 "VAT Manager Setup"
{
    //KB140224 - VAT Manager Setup added +++
    ApplicationArea = All;
    Caption = 'VAT Manager Setup';
    PageType = List;
    SourceTable = "VAT Manager Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("POD No."; Rec."POD No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the POD No. field.';
                }
                field("Distributor No."; Rec."Distributor No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Distributor No. field.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Distributor Name"; Rec."Distributor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Distributor Name field.';
                }
                field("VAT Manager No."; Rec."VAT Manager No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the VAT Manager No. field.';
                }
            }
        }
    }
//KB140224 - VAT Manager Setup added ---
}
