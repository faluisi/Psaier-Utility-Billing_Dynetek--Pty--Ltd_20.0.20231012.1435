table 50209 "Point of Delivery"
{
    DrillDownPageID = "Point of Delivery List";
    LookupPageID = "Point of Delivery List";
    Caption = 'Point of Delivery';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
            NotBlank = true;

            // AN 09112023 - TASK002140 Added Validation for POD No. It starts with “IT”, then there will be 3 digits, then “E” and then 8 digits.  ++
            trigger OnValidate()
            Var
                LengthErrLbl: Label 'The Length of the Pod No. must be 14.';
                Position: Integer;
                PodNoErrorLbl: Label 'Only "%1" is Allowed in Position %2', Comment = 'Only "%1" is Allowed in Position %2';
                OnlyNumericErr: Label 'Only Numeric is allowed in the position %1.', Comment = '%1 = Position';
            begin
                if StrLen("No.") <> 14 then Error(LengthErrLbl);
                for Position:=1 to 14 do begin
                    Case Position of 1: if not(CopyStr("No.", Position, 1)in['I'])then Error(PodNoErrorLbl, 'I', Position);
                    2: if not(CopyStr("No.", Position, 1)in['T'])then Error(PodNoErrorLbl, 'T', Position);
                    3 .. 5: if not(CopyStr("No.", Position, 1)in['0' .. '9'])then error(OnlyNumericErr, Position);
                    6: if not(CopyStr("No.", Position, 1)in['E'])then Error(PodNoErrorLbl, 'E', Position);
                    7 .. 14: if not(CopyStr("No.", Position, 1)in['0' .. '9'])then error(OnlyNumericErr, Position);
                    End;
                end;
            end;
        // AN 09112023 - TASK002140 Added Validation for POD No. It starts with “IT”, then there will be 3 digits, then “E” and then 8 digits.  --
        }
        field(2; "AAT POD Status";Enum "AAT POD Status PUB")
        {
            DataClassification = CustomerContent;
            Caption = 'POD Status';
        }
        field(5; "Meter Serial No."; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Meter Serial No.';
        }
        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if Customer.Get(Rec."Customer No.")then begin
                    Rec."Customer Name":=Customer.Name;
                    Rec."AAT CIV PUB":=Customer."AAT CIV PUB";
                    Rec.Toponym:=Customer."Billing Toponym";
                    Rec."Address":=Customer."Billing Address";
                    Rec."Address 2":=Customer."Billing Address 2";
                    Rec."City":=Customer."Billing City";
                    Rec."County Code":=CopyStr(Customer."Billing County Code", 1, MaxStrLen(Rec."County Code"));
                    Rec."Country/Region Code":=Customer."Country/Region Code";
                    Rec."Post Code":=Customer."Billing Post Code";
                    Rec."ISTAT Code":=Customer."Billing ISTAT Code";
                    // AN 22112023 - TASK002140 - Address Language Code flowed from Customer Card ++ 
                    Rec."Address Langauge Code":=Customer."Customer Language Code";
                // AN 22112023 - TASK002140 - Address Language Code flowed from Customer Card --
                end;
                UpdateInvoiceAddress();
            end;
        }
        field(11; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
            DataClassification = CustomerContent;
        }
        field(19; "AAT CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CIV';
        }
        field(20; Toponym; Code[50])
        {
            Caption = 'Toponym';
            DataClassification = CustomerContent;
            TableRelation = Toponym.Toponym;
        }
        field(21; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(22; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(23; City; Text[30])
        {
            Caption = 'City';
            TableRelation = if("Country/Region Code"=const(''))"Post Code".City
            else if("Country/Region Code"=filter(<>''))"Post Code".City where("Country/Region Code"=field("Country/Region Code"));
            ValidateTableRelation = true;

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
                BillToCounty: Text;
                CountryCode: Code[10];
            begin
                PostCode.LookupPostCode(City, "Post Code", BillToCounty, CountryCode);
                Rec.Validate(City, Rec.City);
            end;
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(City, Rec.City);
                PostCode.SetRange(Code, Rec."Post Code");
                if PostCode.FindFirst()then begin
                    Rec.Validate("County Code", PostCode."County Code");
                    Rec."Country/Region Code":=PostCode."Country/Region Code";
                    Rec."ISTAT Code":=PostCode."ISTAT Code";
                end;
                UpdateInvoiceAddress();
            end;
        }
        field(24; "Post Code"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = if("Country/Region Code"=const(''))"Post Code".Code
            else if("Country/Region Code"=filter(<>''))"Post Code".Code where("Country/Region Code"=field("Country/Region Code"));
            Caption = 'Post Code';

            trigger OnLookup()
            var
                PostCode: Record "Post Code";
                BillToCounty: Text;
                CountryCode: Code[10];
            begin
                PostCode.LookupPostCode(City, "Post Code", BillToCounty, CountryCode);
                Rec.Validate("Post Code", Rec."Post Code");
            end;
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(City, Rec.City);
                PostCode.SetRange(Code, Rec."Post Code");
                if PostCode.FindFirst()then begin
                    Rec.Validate("County Code", PostCode."County Code");
                    Rec."Country/Region Code":=PostCode."Country/Region Code";
                    Rec."ISTAT Code":=PostCode."ISTAT Code";
                end;
                UpdateInvoiceAddress();
            end;
        }
        field(25; "County Code"; Code[10])
        {
            Caption = 'County Code';
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;

            trigger OnValidate()
            var
                County: Record "PS County";
            begin
                County.SetRange(Code, Rec."County Code");
                if not County.IsEmpty() and County.FindFirst()then Rec.County:=County.Name;
                UpdateInvoiceAddress();
            end;
        }
        field(26; County; Text[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(27; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(30; "Address Langauge Code"; Code[10])
        {
            Caption = 'Address Language Code';
            DataClassification = CustomerContent;
            TableRelation = Language.Code;
            InitValue = 'DEU';

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(35; "ISTAT Code"; Code[6])
        {
            DataClassification = CustomerContent;
            Caption = 'ISTAT Code';

            trigger OnValidate()
            begin
                UpdateInvoiceAddress();
            end;
        }
        field(40; "Consumption Constant"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Consumption Constant';
        }
        field(50; "POD Cost"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'POD Cost';
        }
        field(50331; "Invoice Address"; Text[100])
        {
            Caption = 'Invoice Address';
            DataClassification = ToBeClassified;
        }
        field(50332; "Invoice Address 2"; Text[50])
        {
            Caption = 'Invoice Address 2';
            DataClassification = ToBeClassified;
        }
        field(50333; "Invoice City"; Text[30])
        {
            Caption = 'Invoice City';
            DataClassification = ToBeClassified;
        }
        field(50335; "Invoice Country Code"; Code[10])
        {
            Caption = 'Invoice Country Code';
            DataClassification = ToBeClassified;
        }
        field(50336; "Invoice County"; Text[50])
        {
            Caption = 'Invoice County';
            DataClassification = ToBeClassified;
        }
        field(50337; "Invoice ISTAT"; Code[6])
        {
            Caption = 'Invoice ISTAT';
            DataClassification = ToBeClassified;
        }
        field(50338; "Invoice Post Code"; Code[20])
        {
            Caption = 'Invoice Post Code';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    procedure ValidatePOD()
    var
        Meter: Record Meter;
        NoMeterAssErr: Label 'POD:\\No Meter Assigned.';
        NoMeterSysErr: Label 'POD:\\Meter not found in system.';
    begin
        if Rec."Meter Serial No." = '' then Error(NoMeterAssErr);
        if not Meter.Get(Rec."Meter Serial No.")then Error(NoMeterSysErr);
        Meter.ValidateMeter();
    end;
    procedure PopulatePhysicalAddress(var Contract: Record Contract)
    begin
        Contract."Physical Toponym":=Rec.Toponym;
        Contract."AAT Physical CIV PUB":=Rec."AAT CIV PUB";
        Contract."Physical Address":=Rec.Address;
        Contract."Physical Address 2":=Rec."Address 2";
        Contract."Physical City":=Rec.City;
        Contract."Physical Country Code":=Rec."Country/Region Code";
        Contract."Physical County Code":=Rec."County Code";
        Contract."Physical Post Code":=Rec."Post Code";
        if Contract.Modify()then;
    end;
    procedure UpdateInvoiceAddress()
    var
        SecondaryAddress: Record "Secondary Language Address";
    begin
        if(Rec."Address Langauge Code" = 'ITA') or (Rec."Address Langauge Code" = '')then begin
            Rec."Invoice Address":=Rec.Address;
            Rec."Invoice Address 2":=Rec."Address 2";
            Rec."Invoice Country Code":=Rec."Country/Region Code";
            Rec."Invoice City":=Rec.City;
            Rec."Invoice County":=Rec.County;
            Rec."Invoice Post Code":=Rec."Post Code";
            Rec."Invoice ISTAT":=Rec."ISTAT Code";
        end
        else
        begin
            SecondaryAddress.Reset();
            SecondaryAddress.SetRange("Source Type", SecondaryAddress."Source Type"::POD);
            SecondaryAddress.SetRange("Source No.", Rec."No.");
            SecondaryAddress.SetRange(Type, SecondaryAddress.Type::Physical);
            if SecondaryAddress.FindFirst()then begin
                Rec."Invoice Address":=SecondaryAddress.Address;
                Rec."Invoice Address 2":=SecondaryAddress."Address 2";
                Rec."Invoice Country Code":=SecondaryAddress."Country No";
                Rec."Invoice City":=SecondaryAddress.City;
                Rec."Invoice County":=SecondaryAddress.County;
                Rec."Invoice Post Code":=SecondaryAddress."Post Code";
                Rec."Invoice ISTAT":=SecondaryAddress."ISTAT Code";
            end
            else
            begin
                Clear(Rec."Invoice Address");
                Clear(Rec."Invoice Address 2");
                Clear(Rec."Invoice Country Code");
                Clear(Rec."Invoice City");
                Clear(Rec."Invoice County");
                Clear(Rec."Invoice Post Code");
                Clear(Rec."Invoice ISTAT");
            end;
        end;
    end;
}
