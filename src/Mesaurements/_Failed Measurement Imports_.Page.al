page 50245 "Failed Measurement Imports"
{
    ApplicationArea = All;
    Caption = 'Failed Measurement Imports';
    PageType = List;
    SourceTable = Measurement;
    PromotedActionCategories = 'New, Create, Process, Approve';
    UsageCategory = Lists;
    SourceTableView = sorting("Entry No.")order(descending)where("Import Error"=const(true));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field(Month; Rec.Month)
                {
                    ToolTip = 'Specifies the value of the Month field.';
                    Caption = 'Month';
                }
                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
                field("Meter Serial No."; Rec."Meter Serial No.")
                {
                    ToolTip = 'Specifies the value of the Meter Serial No. field.';
                    Caption = 'Meter Serial No.';
                }
                field("Import Error"; Rec."Import Error")
                {
                    ToolTip = 'Specifies the value of the Import Error field.';
                    Caption = 'Import Error';
                }
                field("Errors while Importing"; Rec."Import Notes")
                {
                    ToolTip = 'Specifies the value of the Errors while Importing field.';
                    Caption = 'Import Notes';
                }
                field("Import Status"; Rec."Import Status")
                {
                    ToolTip = 'Specifies the value of the Import Status field.';
                    Caption = 'Import Status';
                }
                field("Import Date"; Rec."Import Date")
                {
                    ToolTip = 'Specifies the value of the Import Date field.';
                    Caption = 'Import Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Approve Measurement")
            {
                Caption = 'Approve Measurement';
                ToolTip = 'Appoved the Failed Measurement Import';
                Promoted = true;
                PromotedCategory = Category4;
                Image = Approval;

                trigger OnAction()
                begin
                    Rec.ApproveMeasurementEntry();
                    CurrPage.Update();
                end;
            }
        }
    }
}
