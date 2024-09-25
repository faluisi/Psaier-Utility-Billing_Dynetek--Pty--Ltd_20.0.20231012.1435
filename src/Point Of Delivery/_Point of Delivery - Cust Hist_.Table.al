table 50213 "Point of Delivery - Cust Hist"
{
    Caption = 'Point of Delivery - Cust Hist';

    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Caption = 'Entry No';
        }
        field(5; "POD No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(6; "AAT Contract No"; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Contract."No.";
            Caption = 'Contract No.';

            trigger OnValidate()
            var
                Contract: Record Contract;
            begin
                Contract.Get("AAT Contract No");
                "AAT Contract Description":=Contract."Contract Description";
            end;
        }
        field(7; "AAT Contract Description"; Text[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Contract."Contract Description";
            Caption = 'Contract Description';
        }
        field(10; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
            Caption = 'Customer No.';
        }
        field(11; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
        field(20; Period; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(25; "From Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'From Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Start date cannot be after end date.';
            begin
                if(Rec."From Date" > Rec."To Date") and ("To Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(30; "To Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'To Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'End date cannot be before start date.';
            begin
                if(Rec."To Date" < Rec."From Date") and (Rec."To Date" <> 0D)then Error(ErrorMsg);
                PopulateCustHistPeriod();
            end;
        }
    }
    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
    }
    procedure PopulateCustHistPeriod()
    var
        PeriodLbl: Label '%1..%2', Comment = '%1 = start date, %2 = End date';
    begin
        Rec.Period:=StrSubstNo(PeriodLbl, Format(Rec."From Date"), Format(Rec."To Date"));
        if not Rec.Modify(true)then Rec.Insert(true);
    end;
}
