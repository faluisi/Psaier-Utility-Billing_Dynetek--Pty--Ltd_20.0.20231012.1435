table 50236 "AAT Additional Fees SII"
{
    DataClassification = CustomerContent;
    Caption = 'Additional Fees';

    fields
    {
        field(10; "AAT POD No. SII"; Code[20])
        {
            Caption = 'POD No.';
            TableRelation = "Point of Delivery"."No.";
        }
        field(20; "AAT Fee Code SII"; Code[30])
        {
            Caption = 'Fee Code';
        }
        field(40; "AAT Start Date SII"; Date)
        {
            Caption = 'Start Date';
        }
        field(50; "AAT End Date SII"; Date)
        {
            Caption = 'End Date';
        }
        field(60; "AAT Fiscal Code SII"; Code[50])
        {
            Caption = 'Fiscal Code';
        }
        field(70; "AAT ISTAT Code SII"; Code[6])
        {
            Caption = 'ISTAT Code';
        }
        field(80; "AAT Amount SII"; Decimal)
        {
            Caption = 'Amount';
            AutoFormatType = 2;
        }
        field(90; "AAT Amount Code SII"; Code[10])
        {
            Caption = 'Amount Code';
        }
        field(100; "AAT Supply Start Date"; Date)
        {
            Caption = 'Supply Start Date';
        }
        field(110; "AAT Termination date"; Date)
        {
            Caption = 'Termination date';
        }
        field(120; "AAT Valid Year SII"; Integer)
        {
            Caption = 'Valid Year';
        }
        field(130; "AAT Communication Type"; Code[50])
        {
            Caption = 'Communication Type';
        }
        field(140; "AAT Reason Code SII"; Code[20])
        {
            Caption = 'Reason Code';
        }
        field(150; "AAT Compensation Scheme"; Code[50])
        {
            Caption = 'Compensation Scheme';
            TableRelation = "AAT Compensation Scheme SII"."AAT Code SII";
        }
        field(155; "AAT Rate SII"; Code[50])
        {
            Caption = 'Rate';
        }
        field(160; "AAT Outcome SII"; Boolean)
        {
            Caption = 'Outcome';
        }
        field(200; "AAT Fee Type SII";Enum "AAT Additional Fee Type")
        {
            Caption = 'Fee Type';
        }
    }
    keys
    {
        key(PK; "AAT Fee Code SII", "AAT Fee Type SII")
        {
            Clustered = true;
        }
    }
}
