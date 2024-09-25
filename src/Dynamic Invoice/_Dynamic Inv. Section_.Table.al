table 50226 "Dynamic Inv. Section"
{
    Caption = 'Dynamic Invoice Section';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No.";Enum "Dynamic Invoice Sections")
        {
            Caption = 'No.';
            Editable = false;
        }
        field(3; "Section Caption"; Integer)
        {
            Caption = 'Section Caption';
            Editable = false;
            TableRelation = "Dynamic Inv. Caption"."Entry No.";
        }
        field(6; "Description"; Text[50])
        {
            Caption = 'Description';
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
                if("English Caption" = '')then exit;
                dynInvoiceCaption.SetRange("English Caption", "English Caption");
                if UtilitySetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."English Caption":="English Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Section Caption":=dynInvoiceCaption."Entry No.";
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
                if UtilitySetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."Italian Caption":="Italian Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Section Caption":=dynInvoiceCaption."Entry No.";
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
                if UtilitySetup."Allow Templ. Caption Creation" then begin
                    if not dynInvoiceCaption.FindLast()then begin
                        dynInvoiceCaption.Init();
                        dynInvoiceCaption."German Caption":="German Caption";
                        dynInvoiceCaption.Insert();
                    end;
                end
                else
                    dynInvoiceCaption.FindLast();
                "Section Caption":=dynInvoiceCaption."Entry No.";
                "English Caption":=dynInvoiceCaption."English Caption";
                "Italian Caption":=dynInvoiceCaption."Italian Caption";
                "German Caption":=dynInvoiceCaption."German Caption";
            end;
        }
    }
    procedure CreateSectionsIfNotExist(): Integer var
        dynInvCaptions: Record "Dynamic Inv. Caption";
        dynamicInvSection: Record "Dynamic Inv. Section";
        dynamicInvSection2: Record "Dynamic Inv. Section";
        invSection: Enum "Dynamic Invoice Sections";
        currentOrdinalIndex: Integer;
        insertCount: Integer;
    begin
        foreach currentOrdinalIndex in Enum::"Dynamic Invoice Sections".Ordinals()do begin
            invSection:=Enum::"Dynamic Invoice Sections".FromInteger(currentOrdinalIndex);
            Clear(dynamicInvSection);
            dynamicInvSection.Reset();
            dynamicInvSection.SetRange("No.", invSection);
            if dynamicInvSection.IsEmpty()then begin
                // Insert Section
                dynamicInvSection2.Init();
                dynamicInvSection2."No.":=invSection;
                dynamicInvSection2.Insert();
                insertCount+=1;
            end;
        end;
        // Update Or Create Captions
        dynamicInvSection.Reset();
        dynamicInvSection.SetRange("Section Caption", 0);
        if dynamicInvSection.FindSet(true)then repeat Clear(dynInvCaptions);
                dynInvCaptions.SetFilter("English Caption", '%1', Format(invSection).Trim());
                if not dynInvCaptions.FindFirst()then begin
                    dynInvCaptions.Init();
                    dynInvCaptions."English Caption":=Format(dynamicInvSection."No.");
                    dynInvCaptions.Insert();
                end;
                dynamicInvSection."Section Caption":=dynInvCaptions."Entry No.";
                dynamicInvSection.Modify();
            until dynamicInvSection.Next() = 0;
        exit(insertCount);
    end;
    var UtilitySetup: Record "Utility Setup";
}
