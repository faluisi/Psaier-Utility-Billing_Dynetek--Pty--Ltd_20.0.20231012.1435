page 50260 "Formula Lines List Part"
{
    Caption = 'Formula Lines';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Formula Line";
    AutoSplitKey = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    NotBlank = true;
                    Caption = 'No.';
                    ApplicationArea = All;
                }
                field(Title; Rec.Title)
                {
                    ToolTip = 'Specifies the value of the Title field.';
                    NotBlank = true;
                    Caption = 'Title';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    ToolTip = 'Specifies the value of the Effective Date field.';
                    NotBlank = true;
                    Caption = 'Effective Start Date';
                    ApplicationArea = All;
                }
                field("Effective End Date"; Rec."Effective End Date")
                {
                    ToolTip = 'Specifies the value of the Effective End Date field.';
                    NotBlank = true;
                    Caption = 'Effective End Date';
                    ApplicationArea = All;
                }
                field("Parent Entry No."; Rec."Parent No.")
                {
                    visible = false;
                    ToolTip = 'Specifies the value of the Parent Entry No. field.';
                    Caption = 'Parent Entry No.';
                    ApplicationArea = All;
                }
                field("Parent Title"; Rec."Parent Title")
                {
                    visible = false;
                    ToolTip = 'Specifies the value of the Parent Title field.';
                    Caption = 'Parent Title';
                    ApplicationArea = All;
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.';
                    Visible = false;
                    Caption = 'Formula';
                    ApplicationArea = All;
                }
                field("Price Value No."; Rec."Price Value No.")
                {
                    ToolTip = 'Specifies the value of the Price Value No. field.';
                    Caption = 'Price Value No.';
                    ApplicationArea = All;
                }
                field("Price Type"; Rec."Price Type")
                {
                    ToolTip = 'Specifies the value of the Price Type field.';
                    Caption = 'Price Type';
                    ApplicationArea = All;
                }
                field("Entry Type"; Rec."Entry Type")
                {
                    ToolTip = 'Specifies the value of the Entry Type field.';
                    Visible = false;
                    Caption = 'Entry Type';
                    ApplicationArea = All;
                }
                field("Global Vaiable"; Rec."Global Vaiable")
                {
                    ToolTip = 'Specifies the value of the Global Vaiable field.';
                    Visible = false;
                    Caption = 'Global Vaiable';
                    ApplicationArea = All;
                }
                field("Expose for Ext. Documents"; Rec."Expose for Ext. Documents")
                {
                    ToolTip = 'Specifies the value of the Expose for Ext. Documents field.';
                    Visible = false;
                    Caption = 'Expose for Ext. Documents';
                    ApplicationArea = All;
                }
                field("Decimal Places"; Rec."Decimal Places")
                {
                    ToolTip = 'Specifies the value of the Decimal Places field.';
                    Visible = false;
                    Caption = 'Decimal Places';
                    ApplicationArea = All;
                }
                field("Lookup Table No."; Rec."Lookup Table No.")
                {
                    ToolTip = 'Specifies the value of the Lookup Table No. field.';
                    Visible = false;
                    Caption = 'Lookup Table No.';
                    ApplicationArea = All;
                }
                field("Lookup Table Name"; Rec."Lookup Table Name")
                {
                    ToolTip = 'Specifies the value of the Lookup Table Name field.';
                    Editable = false;
                    Visible = false;
                    Caption = 'Lookup Table Name';
                    ApplicationArea = All;
                }
                field("Lookup Field No."; Rec."Lookup Field No.")
                {
                    visible = false;
                    ToolTip = 'Specifies the value of the Lookup Field No. field.';
                    Caption = 'Lookup Field No.';
                    ApplicationArea = All;
                }
                field("Lookup Field Name"; Rec."Lookup Field Name")
                {
                    visible = false;
                    ToolTip = 'Specifies the value of the Lookup Field Name field.';
                    Editable = false;
                    Caption = 'Lookup Field Name';
                    ApplicationArea = All;
                }
                field("Lookup Filter"; Rec."Lookup Filter")
                {
                    ToolTip = 'Specifies the value of the Lookup Filter field.';
                    Visible = false;
                    Caption = 'Lookup Filter';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        TariffLine: Record "Tariff Line";
    begin
        if TariffLine.Get(Rec."Tariff No.", Rec."Tariff Line No.")then begin
            Rec."Effective Start Date":=TariffLine."Effective Start Date";
            Rec."Effective End Date":=TariffLine."Effective End Date";
        end;
    end;
}
