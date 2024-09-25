table 50228 "Dynamic Inv. Content"
{
    Caption = 'Dynamic Invoice Content';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Invoice No."; Code[20])
        {
            Caption = 'Invoice No.';
            NotBlank = true;
            TableRelation = "Sales Header"."No.";
        }
        field(6; "Section Code";Enum "Dynamic Invoice Sections")
        {
            Caption = 'Section Code';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Caption Entry No."; Integer)
        {
            Caption = 'Caption No.';
            TableRelation = "Dynamic Inv. Caption"."Entry No.";
        }
        field(40; "English Caption"; Text[500])
        {
            Caption = 'ENG Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Caption"."English Caption" where("Entry No."=field("Caption Entry No.")));
            Editable = false;
        }
        field(45; "Italian Caption"; Text[500])
        {
            Caption = 'IT Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Caption"."Italian Caption" where("Entry No."=field("Caption Entry No.")));
            Editable = false;
        }
        field(50; "German Caption"; Text[500])
        {
            Caption = 'DE Caption';
            FieldClass = FlowField;
            CalcFormula = lookup("Dynamic Inv. Caption"."German Caption" where("Entry No."=field("Caption Entry No.")));
            Editable = false;
        }
        field(10; "Column 1"; Text[500])
        {
            Caption = 'Column 1';
        }
        field(12; "Column 2"; Text[500])
        {
            Caption = 'Column 2';
        }
        field(15; "Column 3"; Text[500])
        {
            Caption = 'Column 3';
        }
        field(18; "Column 4"; Text[500])
        {
            Caption = 'Column 4';
        }
        field(21; "Column 5"; Text[500])
        {
            Caption = 'Column 5';
        }
        field(23; "Column 6"; Text[500])
        {
            Caption = 'Column 6';
        }
        field(26; "Column 7"; Text[500])
        {
            Caption = 'Column 7';
        }
        //KB12032024 - Dynamic Invoice Column 8 added +++
        field(29; "Column 8"; Text[500])
        {
            Caption = 'Column 8';
        }
        //KB12032024 - Dynamic Invoice Column 8 added ---
        field(60; "Bold"; Boolean)
        {
            Caption = 'Bold';
        }
        field(34; "Promoted"; Boolean)
        {
            Caption = 'Promoted';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Invoice No.", "Section Code", "Line No.")
        {
            Clustered = true;
        }
    }
    /// <summary>
    /// GetRalatedCaption.
    /// </summary>
    /// <param name="LanguageCode">Code[10].</param>
    /// <returns>Return value of type Text[50].</returns>
    procedure GetRalatedCaption(LanguageCode: Code[10]): Text[500]var
        DynInvCaption: Record "Dynamic Inv. Caption";
    begin
        if(Rec."Caption Entry No." = 0)then exit(' ');
        DynInvCaption.Get(Rec."Caption Entry No.");
        exit(DynInvCaption.GetCaption(LanguageCode));
    end;
}
