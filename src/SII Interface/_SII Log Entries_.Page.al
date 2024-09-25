page 50231 "SII Log Entries"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    Caption = 'SII Log Entries';

    layout
    {
        area(content)
        {
            group("Change of Customer")
            {
                Caption = 'Change of Customer';

                part("Change of Customer Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Change of Customer';
                    Editable = DevMode;
                    SubPageLink = Type=filter("Change of Customer");
                    UpdatePropagation = Both;
                }
            }
            group("Switch In")
            {
                Caption = 'Switch In';

                part("Switch In Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Switch In';
                    Editable = DevMode;
                    SubPageLink = Type=filter("Switch In");
                }
            }
            group("Switch Out")
            {
                Caption = 'Switch Out';

                part("Switch Out Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Switch Out';
                    Editable = DevMode;
                    SubPageLink = Type=filter("Switch Out");
                }
            }
            group("Change of Personal Data")
            {
                Caption = 'Change of Personal Data';

                part("Change of Personal Data Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Change of Personal Data';
                    Editable = DevMode;
                    SubPageLink = Type=filter("Change of Personal Data");
                    SubPageView = sorting("Contract No.")where(Type=filter("Change of Personal Data"));
                }
            }
            group("Contract Termination")
            {
                Caption = 'Contract Termination';

                part("Contract Termination Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Contract Termination';
                    Editable = DevMode;
                    SubPageLink = Type=filter("Contract Termination");
                }
            }
            //KB09112023 - TASK002126 Deactivation Process +++
            group("Deactivate")
            {
                Caption = 'Deactivate';

                part("Deactivate Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Deactivate';
                    Editable = DevMode;
                    SubPageLink = Type=const(Deactivate);
                }
            }
            //KB09112023 - TASK002126 Deactivation Process ---
            //KB20112023 - TASK002131 New Activation Process +++
            group("New Activation")
            {
                Caption = 'New Activation';

                part("New Activation Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'New Activation';
                    Editable = DevMode;
                    SubPageLink = Type=const("New Activation");
                }
            }
            //KB20112023 - TASK002131 New Activation Process ---
            //KB24112023 - TASK002167 Reactivation Process +++
            group("Reactivation")
            {
                Caption = 'Reactivation';

                part("Reactivation Page Part"; "SII Log Entries Basic List")
                {
                    Caption = 'Reactivation';
                    Editable = DevMode;
                    SubPageLink = Type=const("Reactivation");
                }
            }
        //KB24112023 - TASK002167 Reactivation Process ---
        }
    }
    actions
    {
        // AN 08112023 - TASK002127 // Add action for Upload File ++ 
        area(Navigation)
        {
            group(ImportExport)
            {
                Caption = 'ImportExport';

                action(Import)
                {
                    ToolTip = 'Specifies the Import Action';
                    Image = Import;
                    Visible = true;
                    Caption = 'Import';

                    trigger OnAction()
                    var
                        CSVImportManager: Codeunit "CSV Import Manager";
                    begin
                        CSVImportManager.CSVFileManager();
                    end;
                }
                group("View Log Entries Action Group")
                {
                    Caption = 'View Detailed Log Entries';
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(Import_Promoted; Import)
                {
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        UtilitySetup.GetRecordOnce();
        DevMode:=UtilitySetup."AAT Developer Mode PUB";
    end;
    var UtilitySetup: Record "Utility Setup";
    DevMode: Boolean;
}
