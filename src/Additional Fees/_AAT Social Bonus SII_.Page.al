page 50264 "AAT Social Bonus SII"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    Caption = 'Social Bonus Fees';
    SourceTable = "AAT Additional Fees SII";
    SourceTableView = where("AAT Fee Type SII"=const("AAT Additional Fee Type"::"Social Bonus"));

    layout
    {
        area(Content)
        {
            repeater(SocialBonus)
            {
                Caption = 'SocialBonus';

                field("AAT Fee Code SII"; Rec."AAT Fee Code SII")
                {
                    ToolTip = 'Specifies the value of the Fee Code field.';
                    Caption = 'Fee Code';
                }
                field("AAT Communication Type"; Rec."AAT Communication Type")
                {
                    ToolTip = 'Specifies the value of the Communication Type field.';
                    Caption = 'Communication Type';
                }
                field("AAT Reason Code SII"; Rec."AAT Reason Code SII")
                {
                    ToolTip = 'Specifies the value of the Reason Code field.';
                    Caption = 'Reason Code';
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
                field("AAT Compensation Scheme"; Rec."AAT Compensation Scheme")
                {
                    ToolTip = 'Specifies the value of the Compensation Scheme field.';
                    Caption = 'Compensation Scheme';
                }
                field("AAT Valid Year SII"; Rec."AAT Valid Year SII")
                {
                    ToolTip = 'Specifies the value of the Valid Year field.';
                    Caption = 'Valid Year';
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
                field("AAT Termination date"; Rec."AAT Termination date")
                {
                    ToolTip = 'Specifies the value of the Termination date field.';
                    Caption = 'Termination date';
                }
                field("AAT Outcome SII"; Rec."AAT Outcome SII")
                {
                    ToolTip = 'Specifies the value of the Outcome field.';
                    Caption = 'Outcome';
                }
                field("AAT Fee Type SII"; Rec."AAT Fee Type SII")
                {
                    ToolTip = 'Specifies the value of the Fee Type field.';
                    Caption = 'Fee Type';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Import)
            {
                Caption = 'Import';

                action(ImportMain)
                {
                    ApplicationArea = All;
                    Caption = 'Import Main';
                    ToolTip = 'Import BSAS3 file';
                    Image = Import;

                    trigger OnAction()
                    var
                        AATAdditionalChargeImports: Codeunit "AAT Additional Charge Imports";
                    begin
                        AATAdditionalChargeImports.SocialBonusImport();
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
                action(ImportEsito)
                {
                    ApplicationArea = All;
                    Caption = 'Import Confirm';
                    ToolTip = 'Import BSAS3-ESITO file';
                    Image = Import;

                    trigger OnAction()
                    var
                        AATAdditionalChargeImports: Codeunit "AAT Additional Charge Imports";
                    begin
                        AATAdditionalChargeImports.SocialBonusESITOImport();
                        CurrPage.Update();
                    end;
                }
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
