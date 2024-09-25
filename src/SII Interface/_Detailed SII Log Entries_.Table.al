table 50215 "Detailed SII Log Entries"
{
    Caption = 'Detailed SII Log Entries';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Detailed Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Detailed Entry No.';
        }
        field(5; "Log Entry No."; Integer)
        {
            TableRelation = "SII Log Entries"."Entry No.";
            Caption = 'Log Entry No.';
        }
        field(7; "Contract No."; Code[25])
        {
            TableRelation = Contract."No.";
            Caption = 'Contract No.';
        }
        field(10; Date; Date)
        {
            Caption = 'Date';
        }
        field(15; Filename; Text[50])
        {
            Caption = 'Filename';
        }
        field(17; "File Type";Enum "AAT File Type SII")
        {
            Caption = 'File Type';
        }
        field(20; "Initial Upload Date"; Date)
        {
            Caption = 'Initial Upload Date';
        }
        field(25; "Action";enum "SII Action")
        {
            Caption = 'Action';
        }
        field(30; Status;enum "SII Detailed Status")
        {
            Caption = 'Status';

            trigger OnValidate();
            var
                Contract: Record Contract;
            begin
                if Rec.Status = Status::Accepted then case Rec."File Type" of "AAT File Type SII"::"VT1.0150", "AAT File Type SII"::"SE4.0200": // open contract on accepted final file.
 begin
                        Contract.Get(Rec."Contract No.");
                        Contract.Validate(Status, "Contract Status"::Open);
                        Contract.Modify(true);
                    end;
                    "AAT File Type SII"::"RC1.0100", "AAT File Type SII"::"SE3.0200": //Close contract on accepted final file
 begin
                        Contract.Get(Rec."Contract No.");
                        Contract.Validate(Status, "Contract Status"::Closed);
                        Contract.Modify(true);
                    end;
                    end;
            end;
        }
        field(35; User; Text[50])
        {
            Caption = 'User';
        }
        field(40; Error; Boolean)
        {
            Caption = 'Error';
        }
        field(45; "Error Code"; Code[25])
        {
            Caption = 'Error Code';
        }
        field(47; "Message"; Text[2048])
        {
            Caption = 'Message';
        }
        field(50; "CP User"; Code[25])
        {
            TableRelation = "SII Log Entries"."CP User";
            Caption = 'CP User';
        }
        field(55; "POD No."; Code[20])
        {
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(60; "CVS Text"; Blob)
        {
            Caption = 'CVS Text';
        }
    }
    keys
    {
        key(Key1; "Detailed Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
}
