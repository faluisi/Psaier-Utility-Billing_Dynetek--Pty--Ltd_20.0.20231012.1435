page 50237 "Measurement Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Measurement";
    PromotedActionCategories = 'New,Process,Report, Detailed Entries';
    Editable = false;
    Caption = 'Measurement Card';

    layout
    {
        area(Content)
        {
            group("POD Details")
            {
                Caption = 'POD Details';

                field("POD No."; Rec."POD No.")
                {
                    ToolTip = 'Specifies the value of the POD No. field.';
                    Caption = 'POD No.';
                }
            }
            group("Measurement Details")
            {
                Caption = 'Measurement Details';

                part("Measurement Detail"; "Measurement Detail List Part")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Measurement Detail';
                    SubPageLink = "POD No."=field("POD No.");
                    SubPageView = sorting(Month)order(descending);
                }
            }
        }
    }
    actions
    {
        area(Creation)
        {
            action("Open Detailed Entries")
            {
                ToolTip = 'Opend the Detailed Entries page.';
                PromotedCategory = Category4;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = TaskQualityMeasure;
                Caption = 'Open Detailed Entries';

                trigger OnAction()
                var
                    MeasurementHourlyDetail: Record "Measurement Hourly Detail";
                begin
                    MeasurementHourlyDetail.SetFilter("Measurement Entry No.", Format(Rec."Entry No."));
                    Page.RunModal(Page::"Measurement Hourly Detail", MeasurementHourlyDetail);
                end;
            }
            action("Export Measurement File")
            {
                ToolTip = 'Exports the selected Measurment File';
                PromotedCategory = Category4;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Export;
                Caption = 'Export Measurement File';

                trigger OnAction()
                var
                    Instream: InStream;
                begin
                    if Rec."Import Notes" = 'Estimation' then begin
                        Rec."XML File".CreateInStream(Instream);
                        File.DownloadFromStream(InStream, 'Measurement File', '', '.xml', Rec."File Name");
                    end;
                end;
            }
            action("Estimate for Missing Month")
            {
                ToolTip = 'Finds the missing month in the Measurements to estimate for that month';
                PromotedCategory = Category4;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = CalculateCalendar;
                Caption = 'Estimate for Missing Month';

                trigger OnAction()
                var
                    EstimationsMgt: Codeunit "Est. and Plausibility Mgt.";
                begin
                    EstimationsMgt.Estimate(Rec);
                end;
            }
        }
    }
}
