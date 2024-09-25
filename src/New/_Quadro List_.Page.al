page 50272 "Quadro List"
{
    ApplicationArea = All;
    Caption = 'Monthly Quadro List';
    PageType = List;
    SourceTable = Quadro;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Output; Rec.Output)
                {
                    ToolTip = 'Specifies the value of the Output field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Export UTF Monthly")
            {
                ApplicationArea = all;
                Image = Export;
                Caption = 'Export UTF Monthly';
                ToolTip = 'Export UTF Monthly file.';

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
                        UTFFileExportMgmt.ExportUTFMonthly(StartDate, EndDate);
                    end;
                end;
            }
        }
        area(Promoted)
        {
            actionref(UTF_Monthly_Promoted; "Export UTF Monthly")
            {
            }
        }
    }
}
