table 50207 "Contract Add. Charge Line"
{
    Caption = 'Contract Add. Charge Line';

    fields
    {
        field(5; "Charge Against";Enum "Charge Against")
        {
            DataClassification = CustomerContent;
            Caption = 'Charge Against';
        }
        field(10; "Contract No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
        }
        field(15; Desciption; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Desciption';
        }
        field(20; Recurring; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Recurring';
        }
        field(25; "Recurring Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Recurring Start Date';
        }
        field(30; "Invoiced Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoiced Date';
        }
        field(35; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Start date cannot be after End date.';
            begin
                if("Start Date" > "End Date") and ("End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(40; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'End date cannot be before Start date.';
            begin
                if("End Date" < "Start Date") and ("End Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(45; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
        field(50; Invoiced; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Invoiced';
        }
    }
    keys
    {
        key(Key1; "Contract No.")
        {
            Clustered = true;
        }
        key(Key2; "Charge Against")
        {
        }
    }
}
