table 50229 "Dynamic Inv. Content Template"
{
    Caption = 'Bill Content Template';
    DataClassification = CustomerContent;
    LookupPageId = "Dynamic Inv. Template";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(6; "Section Code";Enum "Dynamic Invoice Sections")
        {
            Caption = 'Section Code';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer."No.";
        }
        field(60; "Bold"; Boolean)
        {
            Caption = 'Bold';
        }
        field(34; "Promoted"; Boolean)
        {
            Caption = 'Promoted';
        }
        field(36; "Show on Graph"; Boolean)
        {
            Caption = 'Show on Graph';

            trigger OnValidate()
            begin
                if Rec."Show on Graph" then if(not(Rec."Section Code" in["Dynamic Invoice Sections"::"Energy Mix Composition", "Dynamic Invoice Sections"::"Invoice Composition"]))then Error(StrSubstNo(NoRelatedGraphSectionErrorLbl, Rec."Section Code"));
            end;
        }
        field(5; "Caption Entry No."; Integer)
        {
            Caption = 'Caption No.';
            TableRelation = "Dynamic Inv. Caption"."Entry No.";
        }
        field(40; "English Caption"; Text[500])
        {
            Caption = 'ENG Caption';
            TableRelation = "Dynamic Inv. Caption"."English Caption";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                dynInvoiceCaption: Record "Dynamic Inv. Caption";
            begin
                Utilitysetup.GetRecordOnce();
                if("English Caption" = '')then exit;
                dynInvoiceCaption.SetRange("English Caption", "English Caption");
                if Utilitysetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."English Caption":="English Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Caption Entry No.":=dynInvoiceCaption."Entry No.";
                "English Caption":=dynInvoiceCaption."English Caption";
                "Italian Caption":=dynInvoiceCaption."Italian Caption";
                "German Caption":=dynInvoiceCaption."German Caption";
            end;
        }
        field(45; "Italian Caption"; Text[500])
        {
            Caption = 'IT Caption';
            TableRelation = "Dynamic Inv. Caption"."Italian Caption";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                dynInvoiceCaption: Record "Dynamic Inv. Caption";
            begin
                if("Italian Caption" = '')then exit;
                dynInvoiceCaption.SetRange("Italian Caption", "Italian Caption");
                if Utilitysetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."Italian Caption":="Italian Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Caption Entry No.":=dynInvoiceCaption."Entry No.";
                "English Caption":=dynInvoiceCaption."English Caption";
                "Italian Caption":=dynInvoiceCaption."Italian Caption";
                "German Caption":=dynInvoiceCaption."German Caption";
            end;
        }
        field(50; "German Caption"; Text[500])
        {
            Caption = 'DE Caption';
            TableRelation = "Dynamic Inv. Caption"."German Caption";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                dynInvoiceCaption: Record "Dynamic Inv. Caption";
            begin
                if("German Caption" = '')then exit;
                dynInvoiceCaption.SetRange("German Caption", "German Caption");
                if Utilitysetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."German Caption":="German Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Caption Entry No.":=dynInvoiceCaption."Entry No.";
                "English Caption":=dynInvoiceCaption."English Caption";
                "Italian Caption":=dynInvoiceCaption."Italian Caption";
                "German Caption":=dynInvoiceCaption."German Caption";
            end;
        }
        // --- Column Setups Start ---
        // Field Numbering Scheme: {Col Index}{Col related Field Index (2x digits)}
        // 1Fixed,3TableNo, 4TableName, 4FieldNo, 5FieldName, 60LookupFormatArg, 66ResultFormat
        // --- Column 1 ---
        field(100; "Fixed Value 1"; Text[500])
        {
            Caption = 'Fixed Value 1';
        }
        field(101; "Fixed Value 1 DE"; Text[500])
        {
            Caption = 'Fixed Value 1 DE';
        }
        field(102; "Fixed Value 1 IT"; Text[500])
        {
            Caption = 'Fixed Value 1 IT';
        }
        field(120; "Table 1 No."; Integer)
        {
            Caption = 'Table 1 No.';
            Editable = false;
        }
        field(121; "Table 1 Name"; Text[249])
        {
            Caption = 'Table 1 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 1 Name" = '')then exit;
                "Field 1 No.":=0;
                "Field 1 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 1 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 1 Name"));
                AllObjWithCaption.FindFirst();
                "Table 1 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 1 Name"));
                "Table 1 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(140; "Field 1 No."; Integer)
        {
            Caption = 'Field 1 No.';
            Editable = false;
        }
        field(141; "Field 1 Name"; Text[249])
        {
            Caption = 'Field 1 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 1 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 1 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record Field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 1 No.":=0;
                if "Field 1 Name" = '' then exit;
                field.SetRange(TableNo, "Table 1 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 1 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 1 Name"));
                field.FindFirst();
                "Field 1 Name":=field."Field Caption";
                "Field 1 No.":=field."No.";
            end;
        }
        field(160; "Lookup Format Arg 1"; Text[500])
        {
            Caption = 'Lookup Format 1';
        }
        field(166; "Format 1"; Text[100])
        {
            Caption = 'Format 1';
        }
        // --- Column 2 ---
        field(200; "Fixed Value 2"; Text[500])
        {
            Caption = 'Fixed Value 2';
        }
        field(201; "Fixed Value 2 DE"; Text[500])
        {
            Caption = 'Fixed Value 2 DE';
        }
        field(202; "Fixed Value 2 IT"; Text[500])
        {
            Caption = 'Fixed Value 2 IT';
        }
        field(220; "Table 2 No."; Integer)
        {
            Caption = 'Table 2 No.';
            Editable = false;
        }
        field(221; "Table 2 Name"; Text[249])
        {
            Caption = 'Table 2 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 2 Name" = '')then exit;
                "Field 2 No.":=0;
                "Field 2 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 2 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 2 Name"));
                AllObjWithCaption.FindFirst();
                "Table 2 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 2 Name"));
                "Table 2 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(240; "Field 2 No."; Integer)
        {
            Caption = 'Field 2 No.';
            Editable = false;
        }
        field(241; "Field 2 Name"; Text[249])
        {
            Caption = 'Field 2 Name';

            trigger OnLookup()
            var
                field: Record Field;
            begin
                field.SetRange(TableNo, "Table 2 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 2 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 2 No.":=0;
                if "Field 2 Name" = '' then exit;
                field.SetRange(TableNo, "Table 2 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 2 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 2 Name"));
                field.FindFirst();
                "Field 2 Name":=field."Field Caption";
                "Field 2 No.":=field."No.";
            end;
        }
        field(260; "Lookup Format Arg 2"; Text[500])
        {
            Caption = 'Lookup Format 2';
        }
        field(266; "Format 2"; Text[100])
        {
            Caption = 'Format 2';
        }
        // --- Column 3 ---
        field(300; "Fixed Value 3"; Text[500])
        {
            Caption = 'Fixed Value 3';
        }
        field(301; "Fixed Value 3 DE"; Text[500])
        {
            Caption = 'Fixed Value 3 DE';
        }
        field(302; "Fixed Value 3 IT"; Text[500])
        {
            Caption = 'Fixed Value 3 IT';
        }
        field(320; "Table 3 No."; Integer)
        {
            Caption = 'Table 3 No.';
            Editable = false;
        }
        field(321; "Table 3 Name"; Text[249])
        {
            Caption = 'Table 3 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 3 Name" = '')then exit;
                "Field 3 No.":=0;
                "Field 3 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 3 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 3 Name"));
                AllObjWithCaption.FindFirst();
                "Table 3 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 3 Name"));
                "Table 3 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(340; "Field 3 No."; Integer)
        {
            Caption = 'Field 3 No.';
            Editable = false;
        }
        field(341; "Field 3 Name"; Text[249])
        {
            Caption = 'Field 3 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 3 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 3 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 3 No.":=0;
                if "Field 3 Name" = '' then exit;
                field.SetRange(TableNo, "Table 3 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 3 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 3 Name"));
                field.FindFirst();
                "Field 3 Name":=field."Field Caption";
                "Field 3 No.":=field."No.";
            end;
        }
        field(360; "Lookup Format Arg 3"; Text[500])
        {
            Caption = 'Lookup Format 3';
        }
        field(366; "Format 3"; Text[100])
        {
            Caption = 'Format 3';
        }
        // --- Column 4 ---
        field(400; "Fixed Value 4"; Text[500])
        {
            Caption = 'Fixed Value 4';
        }
        field(401; "Fixed Value 4 DE"; Text[500])
        {
            Caption = 'Fixed Value 4 DE';
        }
        field(402; "Fixed Value 4 IT"; Text[500])
        {
            Caption = 'Fixed Value 4 IT';
        }
        field(420; "Table 4 No."; Integer)
        {
            Caption = 'Table 4 No.';
            Editable = false;
        }
        field(421; "Table 4 Name"; Text[249])
        {
            Caption = 'Table 4 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 4 Name" = '')then exit;
                "Field 4 No.":=0;
                "Field 4 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 4 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 4 Name"));
                AllObjWithCaption.FindFirst();
                "Table 4 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 4 Name"));
                "Table 4 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(440; "Field 4 No."; Integer)
        {
            Caption = 'Field 4 No.';
            Editable = false;
        }
        field(441; "Field 4 Name"; Text[249])
        {
            Caption = 'Field 4 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 4 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 4 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 4 No.":=0;
                if "Field 4 Name" = '' then exit;
                field.SetRange(TableNo, "Table 4 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 4 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 4 Name"));
                field.FindFirst();
                "Field 4 Name":=field."Field Caption";
                "Field 4 No.":=field."No.";
            end;
        }
        field(460; "Lookup Format Arg 4"; Text[500])
        {
            Caption = 'Lookup Format 4';
        }
        field(466; "Format 4"; Text[100])
        {
            Caption = 'Format 4';
        }
        // --- Column 5 ---
        field(500; "Fixed Value 5"; Text[500])
        {
            Caption = 'Fixed Value 5';
        }
        field(501; "Fixed Value 5 DE"; Text[500])
        {
            Caption = 'Fixed Value 5 DE';
        }
        field(502; "Fixed Value 5 IT"; Text[500])
        {
            Caption = 'Fixed Value 5 IT';
        }
        field(520; "Table 5 No."; Integer)
        {
            Caption = 'Table 5 No.';
            Editable = false;
        }
        field(521; "Table 5 Name"; Text[249])
        {
            Caption = 'Table 5 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 5 Name" = '')then exit;
                "Field 5 No.":=0;
                "Field 5 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 5 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 5 Name"));
                AllObjWithCaption.FindFirst();
                "Table 5 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 5 Name"));
                "Table 5 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(540; "Field 5 No."; Integer)
        {
            Caption = 'Field 5 No.';
            Editable = false;
        }
        field(541; "Field 5 Name"; Text[249])
        {
            Caption = 'Field 5 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 5 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 5 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 5 No.":=0;
                if "Field 5 Name" = '' then exit;
                field.SetRange(TableNo, "Table 5 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 5 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 5 Name"));
                field.FindFirst();
                "Field 5 Name":=field."Field Caption";
                "Field 5 No.":=field."No.";
            end;
        }
        field(560; "Lookup Format Arg 5"; Text[500])
        {
            Caption = 'Lookup Format 5';
        }
        field(566; "Format 5"; Text[100])
        {
            Caption = 'Format 5';
        }
        // --- Column 6 ---
        field(600; "Fixed Value 6"; Text[500])
        {
            Caption = 'Fixed Value 6';
        }
        field(601; "Fixed Value 6 DE"; Text[500])
        {
            Caption = 'Fixed Value 6 DE';
        }
        field(602; "Fixed Value 6 IT"; Text[500])
        {
            Caption = 'Fixed Value 6 IT';
        }
        field(620; "Table 6 No."; Integer)
        {
            Caption = 'Table 6 No.';
            Editable = false;
        }
        field(621; "Table 6 Name"; Text[249])
        {
            Caption = 'Table 6 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 6 Name" = '')then exit;
                "Field 6 No.":=0;
                "Field 6 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 6 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 6 Name"));
                AllObjWithCaption.FindFirst();
                "Table 6 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 6 Name"));
                "Table 6 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(640; "Field 6 No."; Integer)
        {
            Caption = 'Field 6 No.';
            Editable = false;
        }
        field(641; "Field 6 Name"; Text[249])
        {
            Caption = 'Field 6 Name';

            trigger OnLookup()
            var
                field: Record Field;
            begin
                field.SetRange(TableNo, "Table 6 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 6 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record Field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 6 No.":=0;
                if "Field 6 Name" = '' then exit;
                field.SetRange(TableNo, "Table 6 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 6 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 6 Name"));
                field.FindFirst();
                "Field 6 Name":=field."Field Caption";
                "Field 6 No.":=field."No.";
            end;
        }
        field(660; "Lookup Format Arg 6"; Text[500])
        {
            Caption = 'Lookup Format 6';
        }
        field(666; "Format 6"; Text[100])
        {
            Caption = 'Format 6';
        }
        // --- Column 7 ---
        field(700; "Fixed Value 7"; Text[500])
        {
            Caption = 'Fixed Value 7';
        }
        field(701; "Fixed Value 7 DE"; Text[500])
        {
            Caption = 'Fixed Value 7 DE';
        }
        field(702; "Fixed Value 7 IT"; Text[500])
        {
            Caption = 'Fixed Value 7 IT';
        }
        field(720; "Table 7 No."; Integer)
        {
            Caption = 'Table 7 No.';
            Editable = false;
        }
        field(721; "Table 7 Name"; Text[249])
        {
            Caption = 'Table 7 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 7 Name" = '')then exit;
                "Field 7 No.":=0;
                "Field 7 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 7 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 7 Name"));
                AllObjWithCaption.FindFirst();
                "Table 7 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 7 Name"));
                "Table 7 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(740; "Field 7 No."; Integer)
        {
            Caption = 'Field 7 No.';
            Editable = false;
        }
        field(741; "Field 7 Name"; Text[249])
        {
            Caption = 'Field 7 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 7 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 7 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 7 No.":=0;
                if "Field 7 Name" = '' then exit;
                field.SetRange(TableNo, "Table 7 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 7 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 7 Name"));
                field.FindFirst();
                "Field 7 Name":=field."Field Caption";
                "Field 7 No.":=field."No.";
            end;
        }
        field(760; "Lookup Format Arg 7"; Text[500])
        {
            Caption = 'Lookup Format 7';
        }
        field(766; "Format 7"; Text[100])
        {
            Caption = 'Format 7';
        }
        // --- Column Setups End ---
        //KB12032024 - Dynamic Invoice Column 8 added +++
        field(800; "Fixed Value 8"; Text[500])
        {
            Caption = 'Fixed Value 8';
        }
        field(801; "Fixed Value 8 DE"; Text[500])
        {
            Caption = 'Fixed Value 8 DE';
        }
        field(802; "Fixed Value 8 IT"; Text[500])
        {
            Caption = 'Fixed Value 8 IT';
        }
        field(820; "Table 8 No."; Integer)
        {
            Caption = 'Table 8 No.';
            Editable = false;
        }
        field(821; "Table 8 Name"; Text[249])
        {
            Caption = 'Table 8 Name';
            TableRelation = AllObjWithCaption."Object Caption" where("Object Type"=const(Table), "Object ID"=filter(50203|50221|18|50209|79|36|37|50212));
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                AllObjWithCaption: Record AllObjWithCaption;
                TableNamePriotityFilterLbl: Label '@%1', Comment = '%1 Table Name to Filter';
                TableNameFilterLbl: Label '@%1*', Comment = '%1 Table Name to Filter';
            begin
                if("Table 8 Name" = '')then exit;
                "Field 8 No.":=0;
                "Field 8 Name":='';
                AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNamePriotityFilterLbl, "Table 8 Name"));
                if AllObjWithCaption.IsEmpty()then AllObjWithCaption.SetFilter("Object Caption", StrSubstNo(TableNameFilterLbl, "Table 8 Name"));
                AllObjWithCaption.FindFirst();
                "Table 8 Name":=CopyStr(AllObjWithCaption."Object Caption", 1, MaxStrLen("Table 8 Name"));
                "Table 8 No.":=AllObjWithCaption."Object ID";
            end;
        }
        field(840; "Field 8 No."; Integer)
        {
            Caption = 'Field 8 No.';
            Editable = false;
        }
        field(841; "Field 8 Name"; Text[249])
        {
            Caption = 'Field 8 Name';

            trigger OnLookup()
            var
                field: Record field;
            begin
                field.SetRange(TableNo, "Table 8 No.");
                if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then Validate("Field 8 Name", field."Field Caption");
            end;
            trigger OnValidate()
            var
                field: Record field;
                FieldNamePriortyFilterLbl: Label '@%1', Comment = '%1 Field Name to Filter on.';
                FieldNameFilterLbl: Label '@%1*', Comment = '%1 Field Name to Filter on.';
            begin
                "Field 8 No.":=0;
                if "Field 8 Name" = '' then exit;
                field.SetRange(TableNo, "Table 8 No.");
                field.SetFilter("Field Caption", StrSubstNo(FieldNamePriortyFilterLbl, "Field 8 Name"));
                if field.IsEmpty()then field.SetFilter("Field Caption", StrSubstNo(FieldNameFilterLbl, "Field 8 Name"));
                field.FindFirst();
                "Field 8 Name":=field."Field Caption";
                "Field 8 No.":=field."No.";
            end;
        }
        field(860; "Lookup Format Arg 8"; Text[500])
        {
            Caption = 'Lookup Format 8';
        }
        field(866; "Format 8"; Text[100])
        {
            Caption = 'Format 8';
        }
        //KB12032024 - Dynamic Invoice Column 8 added ---
        field(900; "Contains Sales Line Link"; Boolean)
        {
            Caption = 'Contains Sales Line Link';
        }
        field(904; "Contains Inv. Overview Link"; Boolean)
        {
            Caption = 'Contains Inv. Overview Link';
        }
        field(905; "Contains Measurement Link"; Boolean)
        {
            Caption = 'Contains Measurement Link';
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Section Code", "Line No.", "Customer No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "Section Code", "Line No.", "English Caption", "Fixed Value 1", "Table 1 Name", "Field 1 Name")
        {
        }
    }
    trigger OnModify()
    begin
        CheckForSalesLineLink();
        CheckForInvStatusLink();
        CheckMeasurementLink();
    end;
    trigger OnInsert()
    begin
        CheckForSalesLineLink();
        CheckForInvStatusLink();
        CheckMeasurementLink();
    end;
    /// <summary>
    /// Get the final value setup on the template (current Rec.)
    /// Returns fixed value or looks up field and returns related value with custom format
    /// </summary>
    /// <param name="colIndex">Integer.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure CalculateColumnResults(colIndex: Integer; relatedDocNo: Code[20]; relatedLineNo: Integer; IsResource: Boolean; DynamicTotalTemplateNo: Integer): Text[500]var
        TemplateRecordRef: RecordRef;
        // To dynamically get setup from template record
        TemplateFixedValFieldRef: FieldRef;
        TemplateLookupTableIDFieldRef: FieldRef;
        TemplateLookupFieldIDFieldRef: FieldRef;
        TemplateLookupFormatArgFieldRef: FieldRef;
        TemplateFinalFormatFieldRef: FieldRef;
        TemplateNoFieldRef: FieldRef;
        Value: Decimal;
        TotalValue: Decimal;
        // To Perform lookup as defined on the template line
        LookupRecordRef: RecordRef;
        LookupFieldRef: FieldRef;
        FixedFieldCode: Text[2];
        // Store Lookup Results
        LookupTableID: Integer;
        LookupFieldNo: Integer;
        FixedValueResult: Text[500];
        FormatArgResult: Text[500];
        FinalFormatResult: Text[100];
        FinalResult: Text[500];
        relatedDynInvTemplateNo: Integer;
        LastRecordRef: RecordRef;
        LastDate: Date;
        PODNo: Code[20];
        MeterNo: code[25];
        LastFieldRef: FieldRef;
        LastMeasurement: Record Measurement;
        Meter: Record Meter;
    begin
        if not relatedFildetdocSet then begin
            DynamicInvFilterHelper.SetRelatedSalesInv(relatedDocNo);
            relatedFildetdocSet:=true;
        end;
        // 0. Link Template Ref to the current Record
        TemplateRecordRef.Open(Database::"Dynamic Inv. Content Template");
        TemplateRecordRef.Get(Rec.RecordId);
        TemplateNoFieldRef:=TemplateRecordRef.Field(1);
        relatedDynInvTemplateNo:=TemplateNoFieldRef.Value;
        // 0.1Get Format for the final Result (Setting Prefix and suffix aht the same time)
        TemplateFinalFormatFieldRef:=TemplateRecordRef.field(GetFieldNoFromIndex(colIndex, '66'));
        FinalFormatResult:=TemplateFinalFormatFieldRef.Value;
        if FinalFormatResult = '' then FinalFormatResult:='%1';
        // 1. Check for a fixed Vaule
        GetFixedValueCode(relatedDocNo, FixedFieldCode);
        TemplateFixedValFieldRef:=TemplateRecordRef.field(GetFieldNoFromIndex(colIndex, FixedFieldCode));
        FixedValueResult:=Format(TemplateFixedValFieldRef.Value);
        if FixedValueResult <> '' then exit(FormatFinalResults(FixedValueResult, FinalFormatResult, ''));
        // 2. No Fixed Value so Lookup the value setup
        TemplateLookupTableIDFieldRef:=TemplateRecordRef.field(GetFieldNoFromIndex(colIndex, '20'));
        Evaluate(LookupTableID, Format(TemplateLookupTableIDFieldRef.Value));
        TemplateLookupFieldIDFieldRef:=TemplateRecordRef.field(GetFieldNoFromIndex(colIndex, '40'));
        Evaluate(LookupFieldNo, Format(TemplateLookupFieldIDFieldRef.Value));
        // No Fixed value and no lookup definition > Return blank
        if(LookupTableID = 0) or (LookupFieldNo = 0)then exit(' ');
        //Error(StrSubstNo(EmptyTemplateDefinitionLbl, Rec."Section Code", Rec."Line No.", Rec."Customer No."));
        // Get Format for the lookup calculation
        TemplateLookupFormatArgFieldRef:=TemplateRecordRef.field(GetFieldNoFromIndex(colIndex, '60'));
        FormatArgResult:=TemplateLookupFormatArgFieldRef.Value;
        LookupRecordRef.Open(LookupTableID);
        TotalValue:=0;
        DynamicInvFilterHelper.GetRelatedFilters(LookupRecordRef, relatedLineNo, relatedDynInvTemplateNo, IsResource, DynamicTotalTemplateNo);
        // if LookupRecordRef.FindFirst() then begin
        if LookupRecordRef.FindSet()then begin
            repeat if IsResource and (LookupRecordRef.RecordId.TableNo = Database::Measurement)then begin
                    LastDate:=LookupRecordRef.Field(5).Value;
                    PODNo:=LookupRecordRef.Field(10).Value;
                    MeterNo:=LookupRecordRef.Field(15).Value;
                    if Meter.Get(MeterNo)then;
                    if Meter."Reading Type" <> Meter."Reading Type"::Consumption then begin
                        LastMeasurement.Reset();
                        LastMeasurement.SetCurrentKey("Meter Serial No.", "POD No.", date);
                        LastMeasurement.SetRange("POD No.", PODNo);
                        LastMeasurement.SetFilter(Date, '..%1', CalcDate('<-CM-1D>', LastDate));
                        if LastMeasurement.FindLast()then begin
                            LastRecordRef.Open(Database::Measurement);
                            LastRecordRef.GetTable(LastMeasurement);
                            LastFieldRef:=LastRecordRef.Field(LookupFieldNo);
                            if(LastFieldRef.Type = LastFieldRef.Type::Integer) or (LastFieldRef.Type = LastFieldRef.Type::Decimal)then begin
                                Evaluate(Value, Format(LastFieldRef.Value));
                                TotalValue:=-Value;
                            end;
                        end;
                    end;
                end;
                LookupFieldRef:=LookupRecordRef.field(LookupFieldNo);
                if LookupFieldRef.Class = FieldClass::FlowField then LookupFieldRef.CalcField();
                if(LookupFieldRef.Type = LookupFieldRef.Type::Integer) or (LookupFieldRef.Type = LookupFieldRef.Type::Decimal)then begin
                    Evaluate(Value, Format(LookupFieldRef.Value, 0, 0));
                    TotalValue+=Value;
                    FinalResult:=Format(TotalValue, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>');
                end
                else if LookupFieldRef.Type = LookupFieldRef.Type::Date then FinalResult:=Format(LookupFieldRef.Value, 0, '<Closing><Day, 2 >.<Month, 2 >.<Year4>')
                    else
                        // 2023-09-19 Add support to blank Zero values
                        FinalResult:=Format(LookupFieldRef.Value);
            until LookupRecordRef.Next() = 0;
            // end;
            if((BlankZeros) and (FinalResult.Trim() = '0'))then exit(' ');
            exit(FormatFinalResults(FinalResult, FinalFormatResult, FormatArgResult));
        end;
        exit(' ');
    end;
    procedure GetFixedValueCode(DocNo: Code[20]; var FieldCode: Text[2])
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
        Language: Record Language;
    begin
        if SalesHeader.Get(SalesHeader."Document Type"::Invoice, DocNo)then if Customer.Get(SalesHeader."Sell-to Customer No.")then if Language.Get(Customer."Language Code")then begin
                    case Language."Windows Language ID" of 1040: FieldCode:='02';
                    2064: FieldCode:='02';
                    5127: FieldCode:='01';
                    3079: FieldCode:='01';
                    4103: FieldCode:='01';
                    1031: FieldCode:='01';
                    else
                        FieldCode:='00';
                    end;
                end
                else
                begin
                    FieldCode:='00';
                end;
    end;
    /// <summary>
    /// Format results from the template based on doifferent flags and rules
    /// </summary>
    /// <param name="rawResults">Text[500].</param>
    /// <param name="finalFormat">Text[10].</param>
    /// <param name="lookupFormatArg">Text[500].</param>
    /// <returns>Return value of type Text[500].</returns>
    local procedure FormatFinalResults(rawResults: Text[500]; finalFormat: Text[100]; lookupFormatArg: Text[500]): Text[500]begin
        if FormatForGraphEntry then exit(rawResults);
        if lookupFormatArg <> '' then rawResults:=Format(rawResults, 0, lookupFormatArg);
        exit(StrSubstNo(finalFormat, rawResults));
    end;
    /// <summary>
    /// Helper function to dynamically return template data based on Column index and 'property' index
    /// </summary>
    /// <param name="colIndex">The target Column Index</param>
    /// <param name="propertyIndex">Second part of the field No that defines a 'property' in the template</param>
    /// <returns>Returns field No as Int to lookup in order to fetch the related property</returns>
    local procedure GetFieldNoFromIndex(colIndex: Integer; propertyIndex: Text[2]): Integer var
        resultText: Text[5];
        result: Integer;
    begin
        // Field Numbering According to Scheme (See Above field declerations)
        resultText:=Format(colIndex);
        resultText+=propertyIndex;
        Evaluate(result, resultText);
        exit(result);
    end;
    /// <summary>
    /// Set if the final results looked up should be formated as spesified by the template or raw value should be returned
    /// </summary>
    /// <param name="newFormatForGraphEntry">New Value</param>
    procedure SetFormatForGraphEntry(newFormatForGraphEntry: Boolean)
    begin
        FormatForGraphEntry:=newFormatForGraphEntry;
    end;
    /// <summary>
    /// Find the related Graph Section code.
    /// </summary>
    /// <returns>The Section code to use for graphs</returns>
    procedure GetRelatedGraphSectionCode(): Enum "Dynamic Invoice Sections" begin
        case Rec."Section Code" of "Dynamic Invoice Sections"::"Energy Mix Composition": exit("Dynamic Invoice Sections"::"Energy Mix Composition Graph");
        "Dynamic Invoice Sections"::"Invoice Composition": exit("Dynamic Invoice Sections"::"Invoice Composition Graph");
        end;
        Error(StrSubstNo(NoRelatedGraphSectionErrorLbl, Rec."Section Code"));
    end;
    /// <summary>
    /// Check if any of the 7 table setups contain links to the sales line table.
    /// These lines will be used differently in calculatiuon logic.
    /// Sets "Contains Sales Line Link"
    /// </summary>
    local procedure CheckForSalesLineLink()
    begin
        Rec."Contains Sales Line Link":=UsesSalesLine();
    // ValidateSingleSalesLinePerSectionCode();
    end;
    /// <summary>
    /// Does any ref use the sales lines?
    /// </summary>
    local procedure UsesSalesLine(): Boolean begin
        case(true)of Rec."Table 1 No." = 37: exit(true);
        Rec."Table 2 No." = 37: exit(true);
        Rec."Table 3 No." = 37: exit(true);
        Rec."Table 4 No." = 37: exit(true);
        Rec."Table 5 No." = 37: exit(true);
        Rec."Table 6 No." = 37: exit(true);
        Rec."Table 7 No." = 37: exit(true);
        Rec."Table 8 No." = 37: exit(true);
        end;
        exit(false);
    end;
    local procedure ValidateSingleSalesLinePerSectionCode()
    var
        DynamicInvContentTemplate: Record "Dynamic Inv. Content Template";
        MultioleSaleLineErr: Label 'Only one Sales Line entry allowed per Invoice Section.';
    // TempDynamicInvContentTemplate: Record "Dynamic Inv. Content Template" temporary;
    begin
        DynamicInvContentTemplate.SetRange("Section Code", Rec."Section Code");
        DynamicInvContentTemplate.SetRange("Contains Sales Line Link", true);
        if DynamicInvContentTemplate.Count > 1 then Error(MultioleSaleLineErr);
    end;
    // ##############################
    // Outstanding Invoices
    // ##############################
    local procedure CheckForInvStatusLink()
    begin
        Rec."Contains Inv. Overview Link":=UsesInvStatus();
    // ValidateSingleUseInvStatusPerSectionCode();
    end;
    local procedure CheckMeasurementLink()
    begin
        Rec."Contains Measurement Link":=MeasurementStatus();
    // ValidateSingleUserMeasurementPerSectionCode();
    end;
    /// <summary>
    /// Does any ref use the sales lines?
    /// </summary>
    local procedure UsesInvStatus(): Boolean begin
        case(true)of Rec."Table 1 No." = 50221: exit(true);
        Rec."Table 2 No." = 50221: exit(true);
        Rec."Table 3 No." = 50221: exit(true);
        Rec."Table 4 No." = 50221: exit(true);
        Rec."Table 5 No." = 50221: exit(true);
        Rec."Table 6 No." = 50221: exit(true);
        Rec."Table 7 No." = 50221: exit(true);
        Rec."Table 8 No." = 50221: exit(true);
        end;
        exit(false);
    end;
    local procedure MeasurementStatus(): Boolean begin
        case(true)of Rec."Table 1 No." = 50212: exit(true);
        Rec."Table 2 No." = 50212: exit(true);
        Rec."Table 3 No." = 50212: exit(true);
        Rec."Table 4 No." = 50212: exit(true);
        Rec."Table 5 No." = 50212: exit(true);
        Rec."Table 6 No." = 50212: exit(true);
        Rec."Table 7 No." = 50212: exit(true);
        Rec."Table 8 No." = 50212: exit(true);
        end;
        exit(false);
    end;
    local procedure ValidateSingleUseInvStatusPerSectionCode()
    var
        DynamicInvContentTemplate: Record "Dynamic Inv. Content Template";
        MultiStatusOverviewLineErr: Label 'Only one Invoice Status entry allowed per Invoice Section.';
    begin
        DynamicInvContentTemplate.SetRange("Section Code", Rec."Section Code");
        DynamicInvContentTemplate.SetRange("Contains Inv. Overview Link", true);
        if DynamicInvContentTemplate.Count > 1 then Error(MultiStatusOverviewLineErr);
    end;
    local procedure ValidateSingleUserMeasurementPerSectionCode()
    var
        DynamicInvContentTemplate: Record "Dynamic Inv. Content Template";
        MultiStatusOverviewLineErr: Label 'Only one Measurement Status entry allowed per Invoice Section.';
    begin
        DynamicInvContentTemplate.SetRange("Section Code", Rec."Section Code");
        DynamicInvContentTemplate.SetRange("Contains Measurement Link", true);
        if DynamicInvContentTemplate.Count > 1 then Error(MultiStatusOverviewLineErr);
    end;
    // ##############################
    // ##############################
    // ##############################
    procedure SetBlankZeros(newBlankZeros: Boolean)
    begin
        BlankZeros:=newBlankZeros;
    end;
    var // ColCalcFailedLbl: Label 'Failed to determain value for Column with index: %1';
    // EmptyTemplateDefinitionLbl: Label 'Dynamic Inv. Content Template should contain A Fixed Value or Value Lookup data.\Identifying fields: Section:%1, Line:%2, Cust:%3';
    NoRelatedGraphSectionErrorLbl: Label 'Section Code "%1" does not have a related graph section.';
    DynamicInvFilterHelper: Codeunit "Dynamic Inv. Filter Helper";
    relatedFildetdocSet: Boolean;
    FormatForGraphEntry: Boolean;
    BlankZeros: Boolean;
    Utilitysetup: Record "Utility Setup";
}
