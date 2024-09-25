table 50227 "Dynamic Inv. Caption"
{
    Caption = 'Dynamic Inv. Multi Language Captions';
    DataClassification = CustomerContent;
    LookupPageId = "Dynamic Inv. Captions";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(3; "English Caption"; Text[500])
        {
            Caption = 'English Caption';
        }
        field(6; "Italian Caption"; Text[500])
        {
            Caption = 'Italian Caption';
        }
        field(9; "German Caption"; Text[500])
        {
            Caption = 'German Caption';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; "English Caption", "Italian Caption", "German Caption")
        {
        }
    }
    trigger OnModify()
    var
        DynamicInvTemplate: Record "Dynamic Inv. Content Template";
    begin
        // Update template Caption fields (Fixed values to make UX better when setting up templates)
        DynamicInvTemplate.SetRange("Caption Entry No.", Rec."Entry No.");
        if not DynamicInvTemplate.IsEmpty()then begin
            DynamicInvTemplate.ModifyAll("English Caption", Rec."English Caption");
            DynamicInvTemplate.ModifyAll("Italian Caption", Rec."Italian Caption");
            DynamicInvTemplate.ModifyAll("German Caption", Rec."German Caption");
        end;
    end;
    trigger OnDelete()
    var
        DynamicInvContentTemplate: Record "Dynamic Inv. Content Template";
        utilitySetup: Record "Utility Setup";
        CaptionInUse2Err: Label 'Caption is currently in use in: %1\ In Section: %2\ With Line No.: %3', Comment = '%1= Table Caption., %2= Section Code, %3 = Line no';
        CaptionInUseBySetupErr: Label 'Caption is currently used by Utility Setup page.';
    begin
        DynamicInvContentTemplate.SetRange("Caption Entry No.", Rec."Entry No.");
        if DynamicInvContentTemplate.FindFirst()then Error(CaptionInUse2Err, DynamicInvContentTemplate.TableCaption, DynamicInvContentTemplate."Section Code", DynamicInvContentTemplate."Line No.");
        utilitySetup.GetRecordOnce();
        if(utilitySetup."All Inv Paid Caption Entry No." = Rec."Entry No.")then Error(CaptionInUseBySetupErr);
    end;
    /// <summary>
    /// Given the target language code return the correct caption from the caption table
    /// </summary>
    /// <param name="LanguageCode">Related language code to eveluate</param>
    /// <returns>Returns the caption setup for the language</returns>
    procedure GetCaption(LanguageCode: Code[10]): Text[500]var
        Language: Record Language;
        blankCaptErrorLbl: Label 'Multi Language Caption Field empty for language code "%1" prefered by Customer.//Please enter a value and reprint.//Entry No.: %2', Comment = 'Language: %1, Entry: %2';
        finalCaption: Text[500];
    begin
        //2064(Switzerland)
        //3079(Austria) 5127(Liechtenstein) 4103(Luxembourg)
        Language.Get(LanguageCode);
        case Language."Windows Language ID" of 1040: finalCaption:=Rec."Italian Caption";
        2064: finalCaption:=Rec."Italian Caption";
        5127: finalCaption:=Rec."German Caption";
        3079: finalCaption:=Rec."German Caption";
        4103: finalCaption:=Rec."German Caption";
        1031: finalCaption:=Rec."German Caption";
        else
            finalCaption:=Rec."English Caption";
        end;
        if finalCaption.Trim() = '' then finalCaption:=Rec."English Caption";
        if(finalCaption.Trim() = '')then Error(blankCaptErrorLbl, LanguageCode, Rec."Entry No.");
        exit(finalCaption);
    end;
    /// <summary>
    /// Get caption for the target customer, based on language setup.
    /// </summary>
    /// <param name="targetCustomerNo">Text[500].</param>
    /// <returns>Returns the caption setup for the language</returns>
    procedure GetCaptionForCustomer(targetCustomerNo: Code[20]): Text[500]var
        Customer: Record Customer;
    begin
        Customer.Get(targetCustomerNo);
        exit(GetCaption(Customer."Language Code"));
    end;
}
