tableextension 50206 "Company Infomation Ext" extends "Company Information"
{
    fields
    {
        field(50200; "Company Code"; Code[20])
        {
            Caption = 'Company Code';
            DataClassification = ToBeClassified;
        }
        field(50201; "Legal Representative"; Text[100])
        {
            Caption = 'Legal Representative';
            DataClassification = ToBeClassified;
        }
        field(50202; "Presence of Delegate"; Boolean)
        {
            Caption = 'Presence of Delegate';
            DataClassification = ToBeClassified;
        }
        field(50203; "Delegate Legal Representative"; Code[20])
        {
            Caption = 'Delegate Legal Representative';
            DataClassification = ToBeClassified;
        }
        field(50204; "Delegate Tax Code"; Code[20])
        {
            Caption = 'Delegate Tax Code';
            DataClassification = ToBeClassified;
        }
        field(50205; "Tax Code"; Code[20])
        {
            Caption = 'Tax Code';
            DataClassification = ToBeClassified;
        }
        field(50206; "Delegate Surname"; Text[200])
        {
            Caption = 'Delegate Surname';
            DataClassification = ToBeClassified;
        }
        field(50207; "Delegate First Name"; Text[200])
        {
            Caption = 'Delegate First Name';
            DataClassification = ToBeClassified;
        }
        field(50208; "Delegate Protocol Date"; Date)
        {
            Caption = 'Delegate Protocol Date';
            DataClassification = ToBeClassified;
        }
        field(50209; "Deledate attorney  number"; Text[30])
        {
            Caption = 'Deledate attorney number';
            DataClassification = ToBeClassified;
        }
    }
}
