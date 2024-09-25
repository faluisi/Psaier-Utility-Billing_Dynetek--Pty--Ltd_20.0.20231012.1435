table 50219 "Utility Setup"
{
    Caption = 'Utility Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(10; "Contract No. Series"; Code[20])
        {
            Caption = 'Contract No. Series';
            TableRelation = "No. Series".Code;
        }
        field(148; "Plausibility Percentage"; Decimal)
        {
            Caption = 'Plausibility Percentage';
        }
        field(160; "Power Limit"; Decimal)
        {
            Caption = 'Power Limit';
        }
        field(110; "Report Code - G Household"; Code[20])
        {
            Caption = 'Report Code - German Household';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - G Household")then Rec."Report Name - G Household":=CustomReportLayout.Description;
            end;
        }
        field(111; "Report Name - G Household"; Text[250])
        {
            Caption = 'Report Name - German Household';
            Editable = false;
        }
        field(120; "Report Code - I Household"; Code[20])
        {
            Caption = 'Report Code - Italian Household';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - I Household")then Rec."Report Name - I Household":=CustomReportLayout.Description;
            end;
        }
        field(121; "Report Name - I Household"; Text[250])
        {
            Caption = 'Report Name - Italian Household';
            Editable = false;
        }
        field(130; "Report Code - G Farmer"; Code[20])
        {
            Caption = 'Report Code - German Farmer';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - G Farmer")then Rec."Report Name - G Farmer":=CustomReportLayout.Description;
            end;
        }
        field(131; "Report Name - G Farmer"; Text[250])
        {
            Caption = 'Report Name - German Farmer';
            Editable = false;
        }
        field(135; "Report Code - I Farmer"; Code[20])
        {
            Caption = 'Report Code - Italian Farmer';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - I Farmer")then Rec."Report Name - I Farmer":=CustomReportLayout.Description;
            end;
        }
        field(136; "Report Name - I Farmer"; Text[250])
        {
            Caption = 'Report Name - Italian Farmer';
            Editable = false;
        }
        field(140; "Report Code - G Resident"; Code[20])
        {
            Caption = 'Report Code - German Main Resident Household';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - G Resident")then Rec."Report Name - G Resident":=CustomReportLayout.Description;
            end;
        }
        field(141; "Report Name - G Resident"; Text[250])
        {
            Caption = 'Report Name - German Main Resident Household';
            Editable = false;
        }
        field(145; "Report Code - I Resident"; Code[20])
        {
            Caption = 'Report Code - Italian Main Resident Household';
            TableRelation = "Custom Report Layout".Code where("Report ID"=const(Report::"Physical Contract"));

            trigger OnValidate()
            var
                CustomReportLayout: Record "Custom Report Layout";
            begin
                if CustomReportLayout.Get(Rec."Report Code - I Resident")then Rec."Report Name - I Resident":=CustomReportLayout.Description;
            end;
        }
        field(146; "Report Name - I Resident"; Text[250])
        {
            Caption = 'Report Name - Italian Main Resitent Household';
            Editable = false;
        }
        // --- Dynamic Invoice ---
        field(200; "Allow Templ. Caption Creation"; Boolean)
        {
            Caption = 'Dynamic Invoice, Allow Direct Template Caption Creation';
        }
        field(250; "All Inv Paid Caption Entry No."; Integer)
        {
            Caption = 'All Invoices Paid Caption Entry No';
            TableRelation = "Dynamic Inv. Caption"."Entry No.";
        }
        field(251; "All Invoices Paid Caption"; Text[500])
        {
            Caption = 'All Invoices Paid Caption';
            TableRelation = "Dynamic Inv. Caption"."English Caption";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                dynInvoiceCaption: Record "Dynamic Inv. Caption";
            begin
                if("All Invoices Paid Caption" = '')then begin
                    "All Inv Paid Caption Entry No.":=0;
                    exit;
                end;
                dynInvoiceCaption.SetRange("English Caption", "All Invoices Paid Caption");
                if Rec."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."English Caption":="All Invoices Paid Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "All Inv Paid Caption Entry No.":=dynInvoiceCaption."Entry No.";
            end;
        }
        field(300; "AAT Developer Mode PUB"; Boolean)
        {
            Caption = 'Developer Mode';
        }
        // AN 30112023 TASK002178 added field for mapping television fees from Resource ++ 
        field(60101; "Television Fees Code"; Code[20])
        {
            Caption = 'Television Fees';
            TableRelation = Resource;
        }
        field(60102; "Social Bonus Code"; Code[20])
        {
            Caption = 'Social Bonus';
            TableRelation = Resource;
        }
        // AN 30112023 TASK002178 added field for mapping television fees from Resource --
        field(60103; "No. Series for Television Fees"; Code[20])
        {
            Caption = 'No. Series for Television Fees';
            DataClassification = ToBeClassified;
        }
        field(60104; "Default VAT Manager No."; Code[20])
        {
            Caption = 'Default VAT Manager No.';
            DataClassification = ToBeClassified;
        }
        field(50105; "Reactive Calc Threshold"; Decimal)
        {
            Caption = 'Reactive Calculation Threshold';
            DataClassification = ToBeClassified;
        }
        field(50106; "Peak Calc Threshold"; Decimal)
        {
            Caption = 'Peak Calculation Threshold';
            DataClassification = ToBeClassified;
        }
        field(50107; "TV Dyn. Inv. Template No."; Integer)
        {
            Caption = 'Television Fees Dyn. Inv. Template No.';
            TableRelation = "Dynamic Inv. Content Template"."Entry No.";
        }
        field(50108; "SB Dyn. Inv. Template No."; Integer)
        {
            Caption = 'Social Bonus Dyn. Inv. Template No.';
            TableRelation = "Dynamic Inv. Content Template"."Entry No.";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then exit;
        Get();
        RecordHasBeenRead:=true;
    end;
    procedure InsertIfNotExists()
    begin
        Reset();
        if not Get()then begin
            Init();
            Insert(true);
        end;
    end;
    var RecordHasBeenRead: Boolean;
}
