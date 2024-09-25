table 50216 "SII Log Entries"
{
    Caption = 'SII Log Entries';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Caption = 'Entry No.';
        }
        field(5; "POD No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery";
            Caption = 'POD No.';
        }
        field(10; "Contract No."; Code[25])
        {
            DataClassification = CustomerContent;
            TableRelation = Contract."No.";
            Caption = 'Contract No.';
        }
        field(15; Type;enum "Process Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Type';
        }
        field(20; "Customer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
        field(25; "Fiscal Code"; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'Fiscal Code';
        }
        field(30; "VAT Number"; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'VAT Number';
        }
        field(35; "Initial Upload"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Initial Upload';
        }
        field(40; "Effective Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Effective Date';
        }
        field(45; Status;Enum "AAT Log Status SII")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
        }
        field(50; Date; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date';
        }
        field(55; "CP User"; Code[25])
        {
            DataClassification = CustomerContent;
            Caption = 'CP User';

            trigger OnValidate()
            begin
                if "CP User" <> xRec."CP User" then begin
                    SIIInterfaceGneralSetup.Get();
                    case Rec.Type of Type::"Switch In": NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Switch In CP User");
                    Type::"Change of Customer": NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."CoC CP User");
                    Type::"Contract Termination": NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Contract Termination CP User");
                    Type::"Change of Personal Data": NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."CoA CP User");
                    //KB09112023 - TASK002126 Deactivation Process +++
                    Type::Deactivate: NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Deactivation CP User");
                    //KB09112023 - TASK002126 Deactivation Process ---  
                    //KB20112023 - TASK002131 New Activation Process +++
                    Type::"New Activation": NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Activation CP User");
                    //KB20112023 - TASK002131 New Activation Process ---
                    else
                    end;
                    "No. Series":='';
                end;
            end;
        }
        field(60; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
            Caption = 'No. Series';
        }
        //KB09112023 - TASK002126 Deactivation Process +++
        field(70000; "Deactivation No."; Code[20])
        {
            Caption = 'Deactivation No.';
            DataClassification = ToBeClassified;
        }
        //KB09112023 - TASK002126 Deactivation Process ---
        //KB20112023 - TASK002131 New Activation Process +++
        field(70100; "New Activation Notes"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Notes';
        }
        field(70101; "New Activation No."; Code[20])
        {
            Caption = 'New Activation No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(SK; "Contract No.")
        {
        }
        key(TK; "CP User")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    var
        IsHandled: Boolean;
    begin
        IsHandled:=false;
        OnBeforeInsert(Rec, IsHandled);
        if IsHandled then exit;
        if "CP User" = '' then begin
            SIIInterfaceGneralSetup.Get();
            case Rec.Type of Type::"Switch In": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Switch In CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."Switch In CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            Type::"Change of Customer": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."CoC CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."CoC CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            Type::"Switch Out": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Switch Out CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."Switch Out CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            Type::"Change of Personal Data": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."CoA CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."CoA CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            Type::"Contract Termination": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Contract Termination CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."Contract Termination CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            //KB09112023 - TASK002126 Deactivation Process +++
            Type::Deactivate: begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Deactivation CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."Deactivation CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            //KB09112023 - TASK002126 Deactivation Process ---
            //KB20112023 - TASK002131 New Activation Process +++
            Type::"New Activation": begin
                NoSeriesMgt.TestManual(SIIInterfaceGneralSetup."Activation CP User");
                NoSeriesMgt.InitSeries(SIIInterfaceGneralSetup."Activation CP User", xRec."No. Series", 0D, "CP User", "No. Series");
            end;
            //KB20112023 - TASK002131 New Activation Process ---    
            end;
        end;
        OnAfterOnInsert(Rec, xRec);
    end;
    var SIIInterfaceGneralSetup: Record "SII Interface General Setup";
    NoSeriesMgt: Codeunit NoSeriesManagement;
    [IntegrationEvent(false, false)]
    local procedure OnAfterOnInsert(var SIILogEntry: Record "SII Log Entries"; xSIILogEntry: Record "SII Log Entries")
    begin
    end;
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsert(var SIILogEntry: Record "SII Log Entries"; var IsHandled: Boolean)
    begin
    end;
}
