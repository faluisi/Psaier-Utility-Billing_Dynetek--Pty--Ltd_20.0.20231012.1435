page 50251 "Tariff Line Header Card Page"
{
    Caption = 'Tariff Line Header Card Page';
    PageType = Card;
    SourceTable = "Tariff Line";
    DataCaptionFields = Description;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Tariff No."; Rec."Tariff No.")
                {
                    ToolTip = 'Specifies the value of the Tariff No. field.';
                    Caption = 'Tariff No.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field("Formula"; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    Caption = 'Formula';
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ToolTip = 'Specifies the value of the Resource No.';
                    Caption = 'Resource No.';
                    ApplicationArea = All;
                }
                field("Resource Name"; Rec."Resource Name")
                {
                    Editable = false;
                    Caption = 'Resource Name';
                    ToolTip = 'Specifies the value of the Resource Name field.';
                    ApplicationArea = All;
                }
                field("Meter Reading Detection"; Rec."Meter Reading Detection")
                {
                    Caption = 'Meter Reading Detection';
                    ToolTip = 'Specifies the value of the Meter Reading Detection field.';
                    ApplicationArea = All;
                }
            }
            group("Formula Lines Group")
            {
                Caption = 'Formula Lines';

                group("Formula Lines List")
                {
                    Caption = 'Formula Lines List';

                    part("Formula Lines"; "Formula Lines List Part")
                    {
                        ShowFilter = true;
                        //KB21022024 - Primary Key Remove Start Date End Date +++
                        SubPageLink = "Tariff No."=field("Tariff No."), "Tariff Line No."=field("Line No."), "Effective Start Date"=field("Effective Start Date"), "Effective End Date"=field("Effective End Date");
                        //KB21022024 - Primary Key Remove Start Date End Date ---
                        Caption = 'Formula Lines List Part';
                        ApplicationArea = All;
                    // Editable =          
                    }
                }
            }
        }
    }
    // AN 29112023 TASK002140 -Require a Status field on Tariff, and tariff should be non-editable if the Status is Approved ++
    trigger OnOpenPage()
    vAR
        TariffLine_LRec: Record "Tariff Line";
        TariffHeader_Lrec: Record "Tariff Header";
    begin
        TariffLine_LRec.Reset();
        TariffLine_LRec.SetRange("Tariff No.", rec."Tariff No.");
        TariffLine_LRec.SetRange("Line No.", rec."Line No.");
        if TariffLine_LRec.FindFirst()then begin
            TariffHeader_Lrec.Reset();
            TariffHeader_Lrec.SetRange("No.", TariffLine_LRec."Tariff No.");
            IF TariffHeader_Lrec.FindFirst()then if not(TariffHeader_Lrec.Status in[TariffHeader_Lrec.Status::Closed, TariffHeader_Lrec.Status::New])then begin
                    CurrPage.SetRecord(TariffLine_LRec);
                    CurrPage.Editable(false);
                end;
        end;
    end;
// AN 29112023 TASK002140 -Require a Status field on Tariff, and tariff should be non-editable if the Status is Approved --
}
