table 50206 "Contract Dicount/Reduction Lin"
{
    Caption = 'Contract Dicount/Reduction Lin';
    DataClassification = CustomerContent;

    fields
    {
        field(3; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(5; "Discount Against";ENum "Discount Against")
        {
            Caption = 'Discount Against';
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
        }
        field(15; Desciption; Text[50])
        {
            Caption = 'Desciption';
        }
        field(20; Recurring; Boolean)
        {
            Caption = 'Recurring';
        }
        field(25; "Recurring Start Date"; Date)
        {
            Caption = 'Recurring Start Date';
        }
        field(30; "Invoiced Date"; Date)
        {
            Caption = 'Invoiced Date';
        }
        field(35; "Start Date"; Date)
        {
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
            Caption = 'Amount';
        }
        field(50; Percentage; Decimal)
        {
            Caption = 'Percentage';
        }
        field(55; Invoiced; Boolean)
        {
            Caption = 'Invoiced';
        }
    }
    keys
    {
        key(Key1; "Contract No.")
        {
            Clustered = true;
        }
        key(Key2; "Discount Against")
        {
        }
    }
}
