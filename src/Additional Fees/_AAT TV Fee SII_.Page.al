page 50265 "AAT TV Fee SII"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Television Fees';
    SourceTable = "AAT Additional Fees SII";
    SourceTableView = where("AAT Fee Type SII"=const("AAT Additional Fee Type"::"TV Fee"));

    layout
    {
        area(Content)
        {
            repeater(TVFee)
            {
                Caption = 'Television Fees';

                field("AAT Fee Code SII"; Rec."AAT Fee Code SII")
                {
                    ToolTip = 'Specifies the value of the Fee Code field.';
                    Caption = 'Fee Code';
                }
                field("AAT POD No. SII"; Rec."AAT POD No. SII")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("AAT Fiscal Code SII"; Rec."AAT Fiscal Code SII")
                {
                    ToolTip = 'Specifies the value of the Fiscal Code field.';
                    Caption = 'Fiscal Code';
                }
                field("AAT Amount SII"; Rec."AAT Amount SII")
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    Caption = 'Amount';
                }
                field("AAT Amount Code SII"; Rec."AAT Amount Code SII")
                {
                    ToolTip = 'Specifies the value of the Amount Code field.';
                    Caption = 'Amount Code';
                }
                field("AAT Start Date SII"; Rec."AAT Start Date SII")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Caption = 'Start Date';
                }
                field("AAT End Date SII"; Rec."AAT End Date SII")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Caption = 'End Date';
                }
                field("AAT ISTAT Code SII"; Rec."AAT ISTAT Code SII")
                {
                    ToolTip = 'Specifies the value of the ISTAT Code field.';
                    Caption = 'ISTAT Code';
                }
                field("AAT Rate SII"; Rec."AAT Rate SII")
                {
                    ToolTip = 'Specifies the value of the Rate field.';
                    Caption = 'Rate';
                }
                field("AAT Supply Start Date"; Rec."AAT Supply Start Date")
                {
                    ToolTip = 'Specifies the value of the Supply Start Date field.';
                    Caption = 'Supply Start Date';
                }
                field("AAT Fee Type SII"; Rec."AAT Fee Type SII")
                {
                    ToolTip = 'Specifies the value of the Fee Type field.';
                    Caption = 'Fee Type';
                    Visible = false;
                }
            }
        }
        area(Factboxes)
        {
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import';
                ToolTip = 'Import CR1 file';
                Image = Import;

                trigger OnAction()
                var
                    AATAdditionalChargeImports: Codeunit "AAT Additional Charge Imports";
                begin
                    AATAdditionalChargeImports.TVFeeImport();
                    CurrPage.Update();
                end;
            }
            action(DeleteEntry)
            {
                ApplicationArea = All;
                Caption = 'Delete Entry';
                ToolTip = 'Delete selected entry';
                Image = Delete;
                Visible = DevMode;
                Enabled = DevMode;

                trigger OnAction()
                begin
                    Rec.Delete()end;
            }
            action(TestExportIEA)
            {
                ApplicationArea = All;
                Caption = 'IEA Txt Export';
                ToolTip = 'Executes the IEA Txt Export action.';
                Image = Export;

                trigger OnAction()
                var
                    AATPaidTVExportSII: Codeunit "AAT Paid TV Export SII";
                begin
                    AATPaidTVExportSII.ExportIEAFile();
                    CurrPage.Update();
                end;
            }
            action(TestExportIEB)
            {
                ApplicationArea = All;
                Caption = 'IEB Txt Export';
                ToolTip = 'Executes the IEB Txt Export action.';
                Image = Export;

                trigger OnAction()
                var
                    AATPaidTVExportSII: Codeunit "AAT Paid TV Export SII";
                begin
                    AATPaidTVExportSII.ExportIEBFile();
                    CurrPage.Update();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(DeleteEntry_Promoted; DeleteEntry)
                {
                }
                actionref(TestExportIEA_Promoted; TestExportIEA)
                {
                }
                actionref(TestExportIEB_Promoted; TestExportIEB)
                {
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        UtilitySetup.GetRecordOnce();
        DevMode:=UtilitySetup."AAT Developer Mode PUB";
        CurrPage.Editable:=DevMode;
        CurrPage.Update();
    end;
    var UtilitySetup: Record "Utility Setup";
    DevMode: Boolean;
}
