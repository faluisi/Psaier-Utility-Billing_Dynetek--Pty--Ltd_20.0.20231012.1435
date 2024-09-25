page 50217 "Meter Assigment Card Page"
{
    PageType = Card;
    SourceTable = "Meter";
    UsageCategory = Administration;
    Caption = 'Meter Assigment Card Page';

    layout
    {
        area(content)
        {
            field("Serial No."; PODMeterHist."Meter Serial No.")
            {
                ToolTip = 'Specifies the value of the Assigned Serial No. field.';
                // AN 22112023 - TASK002140 meters which are assigned to a POD should not appear in the meter list, since a meter cannot be assigned twice ++
                TableRelation = Meter."Serial No." where("POD No."=filter(''));
                // AN 22112023 - TASK002140 meters which are assigned to a POD should not appear in the meter list, since a meter cannot be assigned twice --
                Caption = 'Meter Serial No.';
                ApplicationArea = All;

                trigger OnValidate()
                var
                    "AssignedMeter2": Record "Point of Delivery - Meter Hist";
                    ErrorMsg: Label 'Meter with Serial No.: %1 has already been assigned to a different POD', Comment = 'Meter with Serial No.: %1 has already been assigned to a different POD';
                begin
                    "AssignedMeter2".SetRange("Meter Serial No.", PODMeterHist."Meter Serial No.");
                    "AssignedMeter2".SetFilter("Deactivation Date", '%1', 0D);
                    if not "AssignedMeter2".IsEmpty then Error(ErrorMsg, PODMeterHist."Meter Serial No.")
                    else
                        PODMeterHist.CalcFields(Model, "Reading Type", "Number of Digits");
                end;
            }
            field("Activation Date"; PODMeterHist."Activation Date")
            {
                ToolTip = 'Specifies the value of the Activiation Date field.';
                NotBlank = true;
                Caption = 'Activation Date';
                ApplicationArea = All;
            }
            group("Meter Details")
            {
                Caption = 'Meter Details';

                field(Model; PODMeterHist.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                    Editable = false;
                    Caption = 'Model';
                    ApplicationArea = All;
                }
                field("Number of Digits"; PODMeterHist."Number of Digits")
                {
                    ToolTip = 'Specifies the value of the Number of Digits field.';
                    Editable = false;
                    Caption = 'Number of Digits';
                    ApplicationArea = All;
                }
                field("Reading Type"; PODMeterHist."Reading Type")
                {
                    ToolTip = 'Specifies the value of the Reading Type field.';
                    Editable = false;
                    Caption = 'Reading Type';
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
    }
    procedure GetPODMeterHistRecord(): Record "Point of Delivery - Meter Hist" begin
        exit(PODMeterHist);
    end;
    var PODMeterHist: Record "Point of Delivery - Meter Hist";
}
