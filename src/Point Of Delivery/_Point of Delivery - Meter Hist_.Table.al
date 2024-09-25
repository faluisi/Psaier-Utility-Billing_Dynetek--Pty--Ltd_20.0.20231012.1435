table 50210 "Point of Delivery - Meter Hist"
{
    Caption = 'Point of Delivery - Meter Hist';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(5; "POD No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(6; "Meter Serial No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Meter."Serial No.";
            Caption = 'Meter Serial No.';
        }
        field(10; "Activation Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Activation Date';

            trigger OnValidate()
            var
                PointofDeliveryMeterHist2: Record "Point of Delivery - Meter Hist";
                ErrorMsg: Label 'Activation date cannot be after Deactivation date.';
                Error2Msg: Label 'New meter activation date cannot be before previous meter Deactivation date.';
            begin
                PointofDeliveryMeterHist2.SetRange("POD No.", Rec."POD No.");
                PointofDeliveryMeterHist2.SetFilter("Deactivation Date", '<>%1', 0D);
                PointofDeliveryMeterHist2.SetCurrentKey("Entry No.");
                if PointofDeliveryMeterHist2.FindLast()then if Rec."Activation Date" <= PointofDeliveryMeterHist2."Deactivation Date" then Error(Error2Msg);
                if("Activation Date" > "Deactivation Date") and ("Deactivation Date" <> 0D)then Error(ErrorMsg);
                PopulatePODMeterHistPeriod();
            end;
        }
        field(11; "Deactivation Date"; Date)
        {
            Editable = true;
            DataClassification = CustomerContent;
            Caption = 'Deactivation Date';

            trigger OnValidate()
            var
                Meter: Record Meter;
                ConfirmMsg: Label 'Deactivate Meter';
                DateErrorMsg: Label 'Deactivation date cannot be before Activation date.';
                ErrorMsg: Label 'Deactivation Date has already been set';
            begin
                if("Deactivation Date" < "Activation Date") and ("Deactivation Date" <> 0D)then Error(DateErrorMsg);
                PopulatePODMeterHistPeriod();
                if Format(xRec."Deactivation Date") = '' then begin
                    if not Confirm(ConfirmMsg)then begin
                        Meter.Get("Meter Serial No.");
                        Clear(Meter."POD No.");
                        Meter.Modify(true);
                    end
                    else
                    begin
                        Meter.Get("Meter Serial No.");
                        Clear(Meter."POD No.");
                        Meter.Modify(true);
                    end;
                end
                else
                begin
                    Rec."Deactivation Date":=xRec."Deactivation Date";
                    Error(ErrorMsg);
                end;
            end;
        }
        field(20; Model; Text[50])
        {
            CalcFormula = lookup(Meter.Model where("Serial No."=field("Meter Serial No.")));
            FieldClass = FlowField;
            Editable = false;
            Caption = 'Model';
        }
        field(30; "Number of Digits"; Integer)
        {
            CalcFormula = lookup(Meter."Number of Digits" where("Serial No."=field("Meter Serial No.")));
            FieldClass = FlowField;
            Editable = false;
            Caption = 'Number of Digits';
        }
        field(40; "Reading Type";Enum "POD Reading Type")
        {
            CalcFormula = lookup(Meter."Reading Type" where("Serial No."=field("Meter Serial No.")));
            FieldClass = FlowField;
            Editable = false;
            Caption = 'Reading Type';
        }
        field(50; Period; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(60; Active; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Active';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }
    procedure PopulatePODMeterHistPeriod()
    var
        PeriodLbl: Label '%1..%2', Comment = '%1 = Activation date, %2 = Deactivation date';
    begin
        Rec.Period:=StrSubstNo(PeriodLbl, Format(Rec."Activation Date"), Format(Rec."Deactivation Date"));
        if not Rec.Modify(true)then Rec.Insert(true);
    end;
}
