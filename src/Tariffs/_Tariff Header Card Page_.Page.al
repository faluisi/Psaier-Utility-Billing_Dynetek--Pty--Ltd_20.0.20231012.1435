page 50253 "Tariff Header Card Page"
{
    Caption = 'Tariff Card Page';
    PageType = Card;
    SourceTable = "Tariff Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    NotBlank = true;
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description.';
                    NotBlank = true;
                    Caption = 'Description';
                    ApplicationArea = All;
                    Editable = not(rec.Status = rec.Status::Approved);
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    NotBlank = true;
                    Caption = 'Effective Start Date';
                    ApplicationArea = All;
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                    // AN 29112023 TASK002140 Condition for Page editable based Status ++
                    Editable = not(rec.Status = rec.Status::Approved);
                // AN 29112023 TASK002140 Condition for Page editable based Status --
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                    NotBlank = true;
                    Caption = 'Effective End Date';
                    ApplicationArea = All;
                    Visible = false; //KB21022024 - Primary Key Remove Start Date End Date
                    // AN 29112023 TASK002140 Condition for Page editable based Status ++
                    Editable = not(rec.Status = rec.Status::Approved);
                // AN 29112023 TASK002140 Condition for Page editable based Status --
                }
                // AN 29112023 TASK002140  - Added new field for Tariff Status ++
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                // AN 29112023 TASK002140  - Added new field for Tariff Status --
                field(BTVE; Rec.BTVE)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BTVE field.';
                }
            }
            group(LinesGrp)
            {
                Caption = 'Lines';

                part(TariffLines; "Tariff Lines List Part")
                {
                    //KB21022024 - Primary Key Remove Start Date End Date +++
                    SubPageLink = "Tariff No."=field("No.");
                    //KB21022024 - Primary Key Remove Start Date End Date ---
                    Caption = 'Tariff Lines List Part';
                    ApplicationArea = All;
                    // AN 29112023 TASK002140 Condition for Page editable based Status ++
                    Editable = not(rec.Status = rec.Status::Approved);
                // AN 29112023 TASK002140 Condition for Page editable based Status --
                }
            }
        }
    }
}
