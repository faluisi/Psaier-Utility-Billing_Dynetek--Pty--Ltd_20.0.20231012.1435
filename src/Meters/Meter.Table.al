table 50211 Meter
{
    DrillDownPageID = "Meter List";
    LookupPageID = "Meter List";
    Caption = 'Meter';

    fields
    {
        field(1; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(5; "POD No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "Point of Delivery"."No.";
            Caption = 'POD No.';
        }
        field(10; Mark; Text[30])
        {
            Caption = 'Mark';
            DataClassification = CustomerContent;
        }
        field(11; Model; Text[50])
        {
            Caption = 'Model';
            DataClassification = CustomerContent;
        }
        field(15; "Production Year"; Integer)
        {
            Caption = 'Production Year';
            DataClassification = CustomerContent;
        }
        field(20; "Number of Digits"; Integer)
        {
            Caption = 'Number of Digits';
            DataClassification = CustomerContent;
        }
        field(30; "Reading Type";Enum "POD Reading Type")
        {
            Caption = 'Reading Type';
            DataClassification = CustomerContent;

            // AN 22112023 - TASK002140 Added Validation ++ 
            trigger OnValidate()
            Var
                ErrorLbl: Label 'Cannot change the Reading Type after Installation, Please contact your administrator.';
            begin
                if rec."Installation Date" <> 0D then Error(ErrorLbl);
            end;
        // AN 22112023 - TASK002140 Added Validation ++ 
        }
        field(31; "Reading Detection";Enum "Meter Reading Detection")
        {
            Caption = 'Reading Detection';
            DataClassification = CustomerContent;

            // AN 22112023 - TASK002140 Added Validation ++ 
            trigger OnValidate()
            Var
                ErrorLbl: Label 'Cannot change the Reading Detection after Installation, Please contact your administrator.';
            begin
                if rec."Installation Date" <> 0D then Error(ErrorLbl);
            end;
        // AN 22112023 - TASK002140 Added Validation -- 
        }
        field(35; "Energy Coeff"; Decimal)
        {
            Caption = 'Energy Coeff';
            DataClassification = CustomerContent;
        }
        field(40; "Installation Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Installation date cannot be after Uninstallation date.';
            begin
                if("Installation Date" > "Uninstallation Date") and ("Uninstallation Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(45; "Installation F0 Active"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F0 Active" < 0) or ("Uninstallation Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(46; "Installation F1 Active"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F1 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(47; "Installation F2 Active"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F2 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(48; "Installation F3 Active"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F3 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(49; "Installation F4 Active"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F4 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(50; "Installation F23 Active"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Installation F23 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(55; "Installation F0 Reactive"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(56; "Installation F1 Reactive"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(57; "Installation F2 Reactive"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(58; "Installation F3 Reactive"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(59; "Installation F4 Reactive"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(60; "Installation F23 Reactive"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(65; "Installation F0 Peak"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(66; "Installation F1 Peak"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(67; "Installation F2 Peak"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(68; "Installation F3 Peak"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(69; "Installation F4 Peak"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(70; "Installation F23 Peak"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(73; "Uninstallation Date"; Date)
        {
            Caption = 'Uninstallation Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Uninstallation date cannot be before Installation date.';
            begin
                if("Uninstallation Date" < "Installation Date") and ("Uninstallation Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(75; "Uninstallation F0 Active"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(76; "Uninstallation F1 Active"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(77; "Uninstallation F2 Active"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(78; "Uninstallation F3 Active"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(79; "Uninstallation F4 Active"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(80; "Uninstallation F23 Active"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(85; "Uninstallation F0 Reactive"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(86; "Uninstallation F1 Reactive"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(87; "Uninstallation F2 Reactive"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(88; "Uninstallation F3 Reactive"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(89; "Uninstallation F4 Reactive"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(90; "Uninstallation F23 Reactive"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(95; "Uninstallation F0 Peak"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(96; "Uninstallation F1 Peak"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(97; "Uninstallation F2 Peak"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(98; "Uninstallation F3 Peak"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(99; "Uninstallation F4 Peak"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(100; "Uninstallation F23 Peak"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        //KB07122023 - TASK002199 Reactivation Process Changes +++
        field(101; "Reactivation Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Reactivation date cannot be before Deactivation date.';
            begin
                if("Reactivation Date" < "Deactivation Date") and ("Deactivation Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(102; "Reactivation F0 Active"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F0 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(103; "Reactivation F1 Active"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F1 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(104; "Reactivation F2 Active"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F2 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(105; "Reactivation F3 Active"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F3 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(106; "Reactivation F4 Active"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F4 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(107; "Reactivation F23 Active"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Reactivation F23 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(108; "Reactivation F0 Reactive"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(109; "Reactivation F1 Reactive"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(110; "Reactivation F2 Reactive"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(111; "Reactivation F3 Reactive"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(112; "Reactivation F4 Reactive"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(113; "Reactivation F23 Reactive"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(114; "Reactivation F0 Peak"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(115; "Reactivation F1 Peak"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(116; "Reactivation F2 Peak"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(117; "Reactivation F3 Peak"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(118; "Reactivation F4 Peak"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(119; "Reactivation F23 Peak"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        //KB07122023 - TASK002199 Reactivation Process Changes ---
        //KB07122023 - TASK002199 Deactivation Process Changes +++
        field(120; "Deactivation Date"; Date)
        {
            Caption = 'Date';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Deactivation date cannot be before Installation date.';
            begin
                if("Deactivation Date" < "Installation Date") and ("Installation Date" <> 0D)then Error(ErrorMsg);
            end;
        }
        field(121; "Deactivation F0 Active"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F0 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(122; "Deactivation F1 Active"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F1 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(123; "Deactivation F2 Active"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F2 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(124; "Deactivation F3 Active"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F3 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(125; "Deactivation F4 Active"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F4 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(126; "Deactivation F23 Active"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                ErrorMsg: Label 'Invalid value entered.';
            begin
                if("Deactivation F23 Active" < 0)then Error(ErrorMsg);
            end;
        }
        field(127; "Deactivation F0 Reactive"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(128; "Deactivation F1 Reactive"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(129; "Deactivation F2 Reactive"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(130; "Deactivation F3 Reactive"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(131; "Deactivation F4 Reactive"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(132; "Deactivation F23 Reactive"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
        field(133; "Deactivation F0 Peak"; Decimal)
        {
            Caption = 'F0';
            DataClassification = CustomerContent;
        }
        field(134; "Deactivation F1 Peak"; Decimal)
        {
            Caption = 'F1';
            DataClassification = CustomerContent;
        }
        field(135; "Deactivation F2 Peak"; Decimal)
        {
            Caption = 'F2';
            DataClassification = CustomerContent;
        }
        field(136; "Deactivation F3 Peak"; Decimal)
        {
            Caption = 'F3';
            DataClassification = CustomerContent;
        }
        field(137; "Deactivation F4 Peak"; Decimal)
        {
            Caption = 'F4';
            DataClassification = CustomerContent;
        }
        field(138; "Deactivation F23 Peak"; Decimal)
        {
            Caption = 'F23';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Key1; "Serial No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    var
        NoSerialNoErr: Label 'No Serial Number added to meter';
    begin
        if Rec."Serial No." = '' then Error(NoSerialNoErr);
    end;
    procedure ValidateMeter()
    var
        NoReadingTypeErr: Label 'No reading type assigned for meter %1', Comment = '%1 = Serial No';
        NoReadingDetectionErr: Label 'No Reading detection assigned for meter %1', Comment = '%1 = Serial No';
    begin
        if Rec."Reading Type" = "POD Reading Type"::" " then Error(NoReadingTypeErr, Rec."Serial No.");
        if Rec."Reading Detection" = "Meter Reading Detection"::" " then Error(NoReadingDetectionErr, Rec."Serial No.");
    end;
}
