pageextension 50208 "Company Information Ext" extends "Company Information"
{
    layout
    {
        addlast(General)
        {
            field("Company Code"; Rec."Company Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Company Code field.', Comment = '%';
            }
            field("Tax Code"; Rec."Tax Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tax Code field.', Comment = '%';
            }
            field("Presence of Delegate"; Rec."Presence of Delegate")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Presence of Delegate field.', Comment = '%';
            }
            field("Delegate  Legal  Representative"; Rec."Delegate Legal Representative")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Delegate  Legal  Representative field.', Comment = '%';
            }
            field("Delegate Tax Code"; Rec."Delegate Tax Code")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Delegate Tax Code field.', Comment = '%';
            }
            field("Delegate Surname"; Rec."Delegate Surname")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Delegate Surname field.', Comment = '%';
            }
            field("Delegate First Name"; Rec."Delegate First Name")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Delegate First Name field.', Comment = '%';
            }
            field("Delegate Protocol Date"; Rec."Delegate Protocol Date")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Delegate Protocol Date field.', Comment = '%';
            }
            field("Deledate attorney  number"; Rec."Deledate attorney  number")
            {
                ApplicationArea = All;
                Visible = Rec."Presence of Delegate";
                ToolTip = 'Specifies the value of the Deledate attorney  number field.', Comment = '%';
            }
        }
    }
}
