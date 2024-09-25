tableextension 50200 "Customer Ext" extends Customer
{
    fields
    {
        modify("PEC E-Mail Address")
        {
        trigger OnAfterValidate()
        begin
            Rec.Validate("Certified E-Mail Address", Rec."PEC E-Mail Address"); //KB14122023 - TASK002199 EMail Validation
        end;
        }
        modify(County)
        {
        TableRelation = "PS County".Code;
        CaptionClass = 'County Code';
        }
        //-> BB 2.2.7 QA Fixes
        modify(City)
        {
        TableRelation = "Post Code".City where("Country/Region Code"=filter('*'));

        trigger OnAfterValidate();
        var
            PostCode: Record "Post Code";
        begin
            "PostCode".Reset();
            "PostCode".SetRange(City, Rec.City);
            if not "PostCode".IsEmpty() and "PostCode".FindFirst()then begin
                Rec."Post Code":="PostCode".Code;
                Rec."Country/Region Code":="PostCode"."Country/Region Code";
                Rec.Validate("County Code", "PostCode"."County Code");
                Rec.County:="PostCode".County end;
        end;
        }
        // <-
        // -> BB 2.2.2 QA Fixes.
        modify("Individual Person")
        {
        trigger OnBeforeValidate()
        begin
            case Rec."Individual Person" of false: Rec."Customer Type":=Rec."Customer Type"::Company;
            true: begin
                Rec."Tax Representative Type":=Rec."Tax Representative Type"::" ";
                Rec."Tax Representative No.":='';
                Rec."Customer Type":=Rec."Customer Type"::Person;
            end;
            end;
        end;
        trigger OnAfterValidate();
        begin
            case Rec."Individual Person" of false: Rec.Resident:=Rec.Resident::"Non-Resident";
            true: Rec.Resident:=Rec.Resident::Resident;
            end;
        end;
        }
        field(50200; "Customer Type";Enum "Customer Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Type';

            trigger OnValidate()
            begin
                case Rec."Customer Type" of Rec."Customer Type"::Company: begin
                    Rec.Resident:=Rec.Resident::"Non-Resident";
                    Rec."Individual Person":=false;
                end;
                Rec."Customer Type"::Person: begin
                    Rec."Tax Representative Type":=Rec."Tax Representative Type"::" ";
                    Rec."Tax Representative No.":='';
                    Rec."Individual Person":=true;
                    Rec.Resident:=Rec.Resident::Resident;
                end;
                end;
            end;
        }
        // <-
        field(50210; "Province of Birth"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Province of Birth';
        }
        field(50211; "Nation of Birth"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Nation of Birth';
        }
        field(50212; Gender;Enum "Employee Gender")
        {
            DataClassification = CustomerContent;
            Caption = 'Gender';
        }
        field(50220; "Tel. Number"; Text[10])
        {
            DataClassification = CustomerContent;
            Numeric = true;
            Caption = 'Tel. Number';
        }
        field(50221; "Certified E-Mail Address"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Certified E-Mail Address';

            trigger OnValidate()
            var
                MailMgmt: Codeunit "Mail Management";
            begin
                //KB14122023 - TASK002199 EMail Validation +++
                if "Certified E-Mail Address" <> '' then MailMgmt.CheckValidEmailAddress("Certified E-Mail Address");
            //KB14122023 - TASK002199 EMail Validation ---
            end;
        }
        field(50230; "Split Payment"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Split Payment';
        }
        field(50235; "Recipient Codex"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Recipient Codex';
        }
        field(50240; Society;Enum Society)
        {
            DataClassification = CustomerContent;
            Caption = 'Society';
        }
        field(50245; Toponym; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Toponym.Toponym;
            Caption = 'Toponym';

            trigger OnValidate()
            var
            begin
                UpdateAddress();
            end;
        }
        field(50260; "ISTAT Code"; Code[6])
        {
            DataClassification = CustomerContent;
            Caption = 'ISTAT Code';

            trigger OnValidate()
            var
            begin
                UpdateAddress();
            end;
        }
        //-> BB 2.2.7 QA Fixes
        field(50262; "County Code"; Code[10])
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
            end;
        }
        // <-
        field(50265; "County Name"; Code[30])
        {
            Caption = 'County';
            DataClassification = CustomerContent;
        }
        field(50269; "AAT Billing CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Billing CIV';
        }
        field(50270; "Billing Toponym"; Code[50])
        {
            DataClassification = CustomerContent;
            TableRelation = Toponym.Toponym;
            Caption = 'Billing Toponym';
        }
        field(50271; "Billing Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Address';

            trigger OnValidate()
            var
            begin
                ValidateTextFields("Billing Address");
            end;
        }
        field(50272; "Billing Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Billing Address 2';

            trigger OnValidate()
            var
            begin
                ValidateTextFields("Billing Address 2");
            end;
        }
        field(50273; "Billing City"; Text[30])
        {
            DataClassification = CustomerContent;
            TableRelation = "Post Code".City;
            Caption = 'Billing City';

            trigger OnValidate()
            var
                "PostCode": Record "Post Code";
            begin
                "PostCode".Reset();
                "PostCode".SetRange(City, Rec."Billing City");
                if not "PostCode".IsEmpty() and "PostCode".FindFirst()then begin
                    Rec."Billing Post Code":="PostCode".Code;
                    Rec."Billing Country":="PostCode"."Country/Region Code";
                    Rec.Validate("Billing County Code", "PostCode"."County Code");
                    Rec."ISTAT Code":=PostCode."ISTAT Code";
                    Rec.Modify(true);
                end;
            end;
        }
        field(50274; "Billing Post Code"; Code[20])
        {
            TableRelation = "Post Code".Code;
            DataClassification = CustomerContent;
            Caption = 'Billing Post Code';
        }
        //-> BB 2.2.7 QA Fixes
        field(50275; "Billing County Code"; Code[20])
        {
            Caption = 'Billing County Code';
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;

            trigger OnValidate()
            var
                County: Record "PS County";
            begin
                County.SetRange(Code, Rec."Billing County Code");
                if County.FindFirst()then Rec."Billing County":=County.Name;
            end;
        }
        // <-
        field(50276; "Billing County"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Billing County';
        }
        field(50277; "Billing Country"; Text[30])
        {
            TableRelation = "Country/Region".Code;
            DataClassification = CustomerContent;
            Caption = 'Billing Country';
        }
        field(50278; "Billing ISTAT Code"; Code[6])
        {
            DataClassification = CustomerContent;
            Caption = 'Billing ISTAT Code';
        }
        field(50290; "Communication Toponym"; Code[50])
        {
            TableRelation = Toponym.Toponym;
            DataClassification = CustomerContent;
            Caption = 'Communication Toponym';
        }
        field(50291; "Communication Address"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication Address';

            trigger OnValidate()
            var
            begin
                ValidateTextFields("Communication Address");
            end;
        }
        field(50292; "Communication Address 2"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication Address 2';

            trigger OnValidate()
            var
            begin
                ValidateTextFields("Communication Address 2");
            end;
        }
        // -> BB 2.2.7 QA Fixes
        field(50293; "Communication City"; Text[30])
        {
            TableRelation = "Post Code".City;
            DataClassification = CustomerContent;
            Caption = 'Communication City';

            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.Reset();
                PostCode.SetRange(City, Rec."Communication City");
                if PostCode.FindFirst()then begin
                    Rec."Communication Post Code":=PostCode.Code;
                    Rec."Communication Country":=PostCode."Country/Region Code";
                    Rec.Validate("Communication County Code", PostCode."County Code");
                    Rec."ISTAT Code":=PostCode."ISTAT Code";
                    Rec.Modify(true);
                end end;
        }
        // <-
        field(50294; "Communication Post Code"; Code[20])
        {
            TableRelation = "Post Code".Code;
            DataClassification = CustomerContent;
            Caption = 'Communication Post Code';
        }
        //-> BB 2.2.7 QA Fixes
        field(50295; "Communication County Code"; Code[10])
        {
            Caption = 'Communication County Code';
            DataClassification = CustomerContent;
            TableRelation = "PS County".Code;

            trigger OnValidate()
            var
                County: Record "PS County";
            begin
                County.SetRange(Code, Rec."Communication County Code");
                if County.FindFirst()then Rec."Communication County":=County.Name;
            end;
        }
        // <-
        field(50296; "Communication County"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication County';
        }
        field(50297; "Communication Country"; Text[30])
        {
            TableRelation = "Country/Region".Code;
            DataClassification = CustomerContent;
            Caption = 'Communication Country';
        }
        field(50298; "Communication ISTAT Code"; Code[6])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication ISTAT Code';
        }
        field(50300; "AAT Communication CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Communication CIV';
        }
        field(50320; "Customer Language Code"; Code[10])
        {
            InitValue = 'DEU';
            TableRelation = Language.Code;
            DataClassification = CustomerContent;
            Caption = 'Customer Language Code';

            trigger OnValidate()
            begin
                Rec.validate("Language Code", Rec."Customer Language Code");
                if Rec."Customer Language Code" <> xRec."Customer Language Code" then UpdateInvoiceAddress();
            end;
        }
        field(50330; "Address Preferences";Enum "Adress Preferences")
        {
            DataClassification = CustomerContent;
            Caption = 'Address Preferences';

            trigger OnValidate()
            var
            begin
                UpdateAddressInformation();
            end;
        }
        field(50350; "AAT CIV PUB"; Text[10])
        {
            DataClassification = CustomerContent;
            Caption = 'CIV';
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
        //KB12122023 - TASK002199 Salvaguardia market +++
        field(50340; "Salvaguardia Market"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Salvaguardia Market';
        }
        //KB12122023 - TASK002199 Salvaguardia market ---
        field(50341; "Fiscal Code Legal Repre."; Code[20])
        {
            Caption = 'Fiscal Code of Legal Representative';

            trigger OnValidate()
            var
                LocalAppMgt: Codeunit LocalApplicationManagement;
            begin
                TestField(Resident, Resident::Resident);
                if "Fiscal Code Legal Repre." <> '' then LocalAppMgt.CheckDigit("Fiscal Code Legal Repre.");
            end;
        }
        field(50342; "First Name Legal Repre."; Text[50])
        {
            Caption = 'First Name Legal Representative';
        }
        field(50343; "Last Name Legal Repre."; Text[50])
        {
            Caption = 'Last Name Legal Representative';
        }
    }
    //-> BB 2.2.7 QA Fixes
    procedure UpdateAddressInformation()
    var
    begin
        case Rec."Address Preferences" of Rec."Address Preferences"::"Same as Legal (Default)": begin
            Rec."AAT Billing CIV PUB":=Rec."AAT CIV PUB";
            Rec."Billing Address":=Rec.Address;
            Rec."Billing Address 2":=Rec."Address 2";
            Rec."Billing Country":=Rec."Country/Region Code";
            Rec.Validate("Billing City", Rec.City);
            Rec."Billing County Code":="County Code";
            Rec."Billing County":=County;
            Rec."Billing Post Code":=Rec."Post Code";
            Rec."Billing ISTAT Code":=Rec."ISTAT Code";
            Rec."AAT Communication CIV PUB":=Rec."AAT CIV PUB";
            Rec."Communication Address":=Rec.Address;
            Rec."Communication Address 2":=Rec."Address 2";
            Rec."Communication Country":=Rec."Country/Region Code";
            Rec.Validate("Communication City", Rec.City);
            Rec."Communication County Code":="County Code";
            Rec."Communication Post Code":=Rec."Post Code";
            Rec."Communication ISTAT Code":=Rec."ISTAT Code";
        end;
        Rec."Address Preferences"::"Different Billing Address": begin
            Clear(Rec."AAT Billing CIV PUB");
            Clear(Rec."Billing Address");
            Clear(Rec."Billing Address 2");
            Clear(Rec."Billing Country");
            Clear(Rec."Billing City");
            Clear(Rec."Billing Post Code");
            Clear(Rec."Billing ISTAT Code");
            Clear(Rec."Billing County");
            Clear(Rec."Billing County Code");
            Rec."AAT Communication CIV PUB":=Rec."AAT CIV PUB";
            Rec."Communication Address":=Rec.Address;
            Rec."Communication Address 2":=Rec."Address 2";
            Rec."Communication Country":=Rec."Country/Region Code";
            Rec."Communication County":=Rec.County;
            Rec.Validate("Communication City", Rec.City);
            Rec."Communication County Code":="County Code";
            Rec."Communication Post Code":=Rec."Post Code";
            Rec."Communication ISTAT Code":=Rec."ISTAT Code";
        end;
        Rec."Address Preferences"::"Both Different than Legal Address": begin
            Clear(Rec."AAT Billing CIV PUB");
            Clear(Rec."Billing Address");
            Clear(Rec."Billing Address 2");
            Clear(Rec."Billing Country");
            Clear(Rec."Billing City");
            Clear(Rec."Billing County");
            Clear(Rec."Billing County Code");
            Clear(Rec."Billing Post Code");
            Clear(Rec."Billing ISTAT Code");
            Clear(Rec."AAT Communication CIV PUB");
            Clear(Rec."Communication Address");
            Clear(Rec."Communication Address 2");
            Clear(Rec."Communication Country");
            Clear(Rec."Communication City");
            Clear(Rec."Communication County");
            Clear(Rec."Communication County Code");
            Clear(Rec."Communication Post Code");
            Clear(Rec."Communication ISTAT Code");
        end;
        Rec."Address Preferences"::"Different Communication Address": begin
            Rec."AAT Billing CIV PUB":=Rec."AAT CIV PUB";
            Rec."Billing Address":=Rec.Address;
            Rec."Billing Address 2":=Rec."Address 2";
            Rec."Billing Country":=Rec."Country/Region Code";
            Rec.Validate("Billing City", Rec.City);
            Rec.Validate("Billing County Code", "County Code");
            Rec."Billing Post Code":=Rec."Post Code";
            Rec."Billing ISTAT Code":=Rec."ISTAT Code";
            Clear(Rec."AAT Communication CIV PUB");
            Clear(Rec."Communication Address");
            Clear(Rec."Communication Address 2");
            Clear(Rec."Communication Country");
            Clear(Rec."Communication County");
            Clear(Rec."Communication County Code");
            Clear(Rec."Communication City");
            Clear(Rec."Communication Post Code");
            Clear(Rec."Communication ISTAT Code");
        end;
        end;
    end;
    // <-
    procedure UpdateAddress();
    begin
        case Rec."Address Preferences" of "Address Preferences"::"Same as Legal (Default)": begin
            Rec."AAT Billing CIV PUB":=Rec."AAT CIV PUB";
            Rec."Billing Toponym":=Rec.Toponym;
            Rec."Billing Address":=Rec.Address;
            Rec."Billing Address 2":=Rec."Address 2";
            Rec."Billing Country":=Rec."Country/Region Code";
            Rec.Validate("Billing County Code", Rec."County Code");
            Rec."Billing County":=Rec.County;
            Rec."Billing City":=Rec.City;
            Rec."Billing Post Code":=Rec."Post Code";
            Rec."Billing ISTAT Code":=Rec."ISTAT Code";
            Rec."Communication Toponym":=Rec.Toponym;
            Rec."AAT Communication CIV PUB":=Rec."AAT CIV PUB";
            Rec."Communication Address":=Rec.Address;
            Rec."Communication Address 2":=Rec."Address 2";
            Rec."Communication Country":=Rec."Country/Region Code";
            Rec.Validate("Communication County Code", Rec."County Code");
            Rec."Communication County":=Rec.County;
            Rec."Communication City":=Rec.City;
            Rec."Communication Post Code":=Rec."Post Code";
            Rec."Communication ISTAT Code":=Rec."ISTAT Code";
        end;
        Rec."Address Preferences"::"Different Communication Address": begin
            Rec."AAT Billing CIV PUB":=Rec."AAT CIV PUB";
            Rec."Billing Toponym":=Rec.Toponym;
            Rec."Billing Address":=Rec.Address;
            Rec."Billing Address 2":=Rec."Address 2";
            Rec."Billing Country":=Rec."Country/Region Code";
            Rec.Validate("Billing County", Rec."County Code");
            Rec."Billing County":=Rec.County;
            Rec."Billing City":=Rec.City;
            Rec."Billing Post Code":=Rec."Post Code";
            Rec."Billing ISTAT Code":=Rec."ISTAT Code";
        end;
        "Address Preferences"::"Different Billing Address": begin
            Rec."AAT Communication CIV PUB":=Rec."AAT CIV PUB";
            Rec."Communication Toponym":=Rec.Toponym;
            Rec."Communication Address":=Rec.Address;
            Rec."Communication Address 2":=Rec."Address 2";
            Rec."Communication Country":=Rec."Country/Region Code";
            Rec."Communication City":=Rec.City;
            Rec."Communication County":=Rec.County;
            Rec.Validate("Communication County Code", Rec."County Code");
            Rec."Communication Post Code":=Rec."Post Code";
            Rec."Communication ISTAT Code":=Rec."ISTAT Code";
        end;
        end;
        UpdateInvoiceAddress();
    end;
    procedure UpdateInvoiceAddress()
    var
        SecondaryAddress: Record "Secondary Language Address";
    begin
        if(Rec."Customer Language Code" = 'ITA') or (Rec."Customer Language Code" = '')then begin
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
            SecondaryAddress.SetRange("Source Type", SecondaryAddress."Source Type"::Customer);
            SecondaryAddress.SetRange("Source No.", Rec."No.");
            SecondaryAddress.SetRange(Type, SecondaryAddress.Type::Legal);
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
    /// <summary>
    /// ValidateCounty.
    /// </summary>
    procedure ValidateTextFields(FieldName: Text)
    var
        SpecialCharErr: Label 'The following special characters are not allowed for the Address Information: „, Ž, ”, ™, , š or á';
    begin
        begin
            if StrPos("FieldName", '„') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", 'Ž') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", '”') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", '™') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", '') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", 'š') = 1 then Error(SpecialCharErr);
            if StrPos("FieldName", 'á') = 1 then Error(SpecialCharErr);
        end;
    end;
}
