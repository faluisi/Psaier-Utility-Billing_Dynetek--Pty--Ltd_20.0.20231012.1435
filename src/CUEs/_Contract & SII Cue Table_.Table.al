table 50201 "Contract & SII Cue Table"
{
    Caption = 'Contract & SII Cue Table';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(10; "Contract - Waiting for Upload"; Integer)
        {
            Caption = 'Contract - Waiting for Upload';
            FieldClass = FlowField;
            CalcFormula = count(Contract where("Process Status"=const("Awaiting Contract Upload")));
            Editable = false;
        }
        field(15; "Activation Contracts"; Integer)
        {
            Caption = 'Activation Contracts';
            FieldClass = FlowField;
            CalcFormula = count(Contract where("Activation Cause"=const(Activation)));
            Editable = false;
        }
        field(16; "Switch In Contracts"; Integer)
        {
            Caption = 'Switch In Contracts';
            FieldClass = FlowField;
            CalcFormula = count(Contract where("Activation Cause"=const(Switch)));
            Editable = false;
        }
        field(17; "Change of Customer"; Integer)
        {
            Caption = 'Change of Customer';
            FieldClass = FlowField;
            CalcFormula = count(Contract where("Activation Cause"=const("Take Over")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
