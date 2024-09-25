table 50205 "Cadastral Data"
{
    Caption = 'Cadastral Data';

    fields
    {
        field(1; "No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(5; "Municipality Comm. Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Municipality Comm. Date';
        }
        field(8; "Account Holder"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Account Holder';
        }
        field(10; "Property Type";Enum "Property Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Property Type';
        }
        field(15; "Concession Building"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Concession Building';
        }
        field(20; "Cadastral Municipality Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cadastral Municipality Code';
        }
        field(25; "Admin. Municipality Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Admin. Municipality Code';
        }
        field(30; Section; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Section';
        }
        field(35; Sheet; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Sheet';
        }
        field(40; Particle; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Particle';
        }
        field(45; "Partice Extension"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Partice Extension';
        }
        field(50; Subordinate; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Subordinate';
        }
        field(55; "Absense of Cadastral Data"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Absense of Cadastral Data';
        }
        field(60; "Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Start Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'Start date cannot be after end date.';
            begin
                if(Rec."Start Date" > Rec."End Date") and ("End Date" <> 0D)then Error(ErrorMsg);
                PopulateCadDataPeriod();
            end;
        }
        field(65; "End Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'End Date';

            trigger OnValidate()
            var
                ErrorMsg: Label 'End date cannot be before start date.';
            begin
                if(Rec."End Date" < Rec."Start Date") and (Rec."End Date" <> 0D)then Error(ErrorMsg);
                PopulateCadDataPeriod();
            end;
        }
        field(70; "Contract No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Contract No.';
            TableRelation = Contract."No.";
        }
        field(75; "POD No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(80; Period; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Period';
        }
        field(85; "Reason for Absence";Enum "Reason For Absence")
        {
            DataClassification = CustomerContent;
            Caption = 'Reason for Absence';
        }
        field(90; "Particle Type";Enum "Particle Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Particle Type';
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    procedure PopulateCadDataPeriod()
    var
        PeriodLbl: Label '%1..%2', Comment = '%1 = start date, %2 = End date';
    begin
        Rec.Period:=StrSubstNo(PeriodLbl, Format(Rec."Start Date"), Format(Rec."End Date"));
        if not Rec.Modify(true)then Rec.Insert(true);
    end;
    procedure ValidateCadastralData()
    var
        Contract: Record Contract;
        EmptyStartDateErr: Label 'Cadastral Data:\\Start Date cannot be empty.';
        CadMunicipalityCodeErr: Label 'Cadastral Data:\\Cadastral Municipality Code cannot be empty.';
        AdminMunicipalityCodeErr: Label 'Cadastral Data:\\Admin. Municipality Code cannot be empty.';
    begin
        if Rec."Start Date" = 0D then Error(EmptyStartDateErr);
        if Rec."POD No." = '' then if Contract.Get("Contract No.")then begin
                Rec.Validate("POD No.", Contract."POD No.");
                Rec.Modify(true);
            end;
        if Rec."Admin. Municipality Code" = '' then Error(AdminMunicipalityCodeErr);
        if Rec."Cadastral Municipality Code" = '' then Error(CadMunicipalityCodeErr);
    end;
}
