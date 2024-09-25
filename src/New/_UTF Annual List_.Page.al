page 50273 "UTF Annual List"
{
    ApplicationArea = All;
    Caption = 'UTF Annual List';
    PageType = List;
    SourceTable = "UTF Annual List";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Quadro No."; Rec."Quadro No.")
                {
                    ToolTip = 'Specifies the value of the Quadro No. field.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Physical County Code"; Rec."Physical County Code")
                {
                    ToolTip = 'Specifies the value of the Physical County Code field.';
                }
                field("Physical City"; Rec."Physical City")
                {
                    ToolTip = 'Specifies the value of the Physical City field.';
                }
                field("Cadastral Municipality Code"; Rec."Cadastral Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Cadastral Municipality Code field.';
                }
                field(Usage; Rec.Usage)
                {
                    ToolTip = 'Specifies the value of the Usage field.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(Residenza; Rec.Residenza)
                {
                    ToolTip = 'Specifies the value of the Residenza field.';
                }
                field("Essente Accise"; Rec."Essente Accise")
                {
                    ToolTip = 'Specifies the value of the Essente Accise field.';
                }
                field("Recupero Accise"; Rec."Recupero Accise")
                {
                    ToolTip = 'Specifies the value of the Recupero Accise field.';
                }
                field("Acciso Starting Range"; Rec."Acciso Starting Range")
                {
                    ToolTip = 'Specifies the value of the Acciso Starting Range field.';
                }
                field("Acciso Ending Range"; Rec."Acciso Ending Range")
                {
                    ToolTip = 'Specifies the value of the Acciso Ending Range field.';
                }
                field("Acciso Consumption"; Rec."Acciso Consumption")
                {
                    ToolTip = 'Specifies the value of the Acciso Consumption field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export UTF Annual")
            {
                ApplicationArea = all;
                Image = ExportFile;
                Caption = 'Export UTF Annual';
                ToolTip = 'Export UTF Annual file.';

                trigger OnAction()
                var
                    UTFFileExportMgmt: Codeunit "UTF File Export Mgmt";
                    UTFMonthlyDatePeriod: Page "Request Page for UTF Monthly";
                    StartDate: Date;
                    EndDate: Date;
                begin
                    Clear(UTFMonthlyDatePeriod);
                    UTFMonthlyDatePeriod.LookupMode(true);
                    if UTFMonthlyDatePeriod.RunModal() = Action::LookupOK then begin
                        UTFMonthlyDatePeriod.GetRange(StartDate, EndDate);
                        UTFFileExportMgmt.ExportUTFAnnual(StartDate, EndDate);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(Export_UTF_Annual_Promoted; "Export UTF Annual")
            {
            }
        }
    }
}
