page 50200 "Address Secondary Language"
{
    Caption = 'Secondary Address';
    SourceTable = "Secondary Language Address";
    InsertAllowed = false; //KB14122023 - TASK002199 Disable Insert
    DeleteAllowed = false; //KB14122023 - TASK002199 Disable Delete

    layout
    {
        area(content)
        {
            group("Secondary Address Group")
            {
                Caption = 'Secondary Address Group';

                group("Legal Address Grp")
                {
                    Caption = 'Legal Address';
                    Editable = LegalEditable;
                    Visible = LegalVisible;

                    field("Legal CIV"; LegalAddress."AAT CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIV field.';

                        trigger OnValidate()
                        var
                            Customer: Record Customer;
                        begin
                            if Customer.Get(LegalAddress."Source No.")then if Customer."Address Preferences" = Customer."Address Preferences"::"Same as Legal (Default)" then begin
                                    BillingAddress.Validate(Address, LegalAddress.Address);
                                    CommunicationAddress.Validate(Address, LegalAddress."Address");
                                end;
                        end;
                    }
                    field("Legal Address"; LegalAddress.Address)
                    {
                        ToolTip = 'Specifies the value of the Legal Address field.';
                        Caption = 'Address';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            Customer: Record Customer;
                        begin
                            if Customer.Get(LegalAddress."Source No.")then if Customer."Address Preferences" = Customer."Address Preferences"::"Same as Legal (Default)" then begin
                                    BillingAddress.Validate(Address, LegalAddress.Address);
                                    CommunicationAddress.Validate(Address, LegalAddress."Address");
                                end;
                        end;
                    }
                    field("Legal Address 2 "; LegalAddress."Address 2")
                    {
                        ToolTip = 'Specifies the value of the Legal Address 2 field.';
                        Caption = 'Address 2';
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            Customer: Record Customer;
                        begin
                            if Customer.Get(LegalAddress."Source No.")then if Customer."Address Preferences" = Customer."Address Preferences"::"Same as Legal (Default)" then begin
                                    BillingAddress.Validate("Address 2", LegalAddress."Address 2");
                                    CommunicationAddress.Validate("Address 2", LegalAddress."Address 2");
                                end;
                        end;
                    }
                    field("Legal City"; LegalAddress.City)
                    {
                        ToolTip = 'Specifies the value of the Legal City field.';
                        Caption = 'City';
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(LegalAddress);
                        end;
                        trigger OnValidate()
                        var
                            Customer: Record Customer;
                        begin
                            if Customer.Get(LegalAddress."Source No.")then if Customer."Address Preferences" = Customer."Address Preferences"::"Same as Legal (Default)" then begin
                                    BillingAddress.Validate(City, LegalAddress.City);
                                    CommunicationAddress.Validate(City, LegalAddress.City);
                                end;
                        end;
                    }
                    field("Legal Post Code"; LegalAddress."Post Code")
                    {
                        ToolTip = 'Specifies the value of the Legal Post Code field.';
                        Caption = 'Post Code';
                        LookupPageID = "Post Codes";
                        TableRelation = "Post Code".Code;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(LegalAddress);
                        end;
                    }
                    field("Legal County Code"; LegalAddress."County Code")
                    {
                        ToolTip = 'Specifies the value of the Legal County Code field.';
                        Caption = 'County Code';
                        TableRelation = "PS County".Code;
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            County: Record "PS County";
                        begin
                            if County.Get(Rec."County Code")then Rec.County:=County.Name;
                        end;
                    }
                    field("Legal County"; LegalAddress.County)
                    {
                        ToolTip = 'Specifies the value of the Legal County field.';
                        Caption = 'County';
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("Legal Country"; LegalAddress."Country No")
                    {
                        ToolTip = 'Specifies the value of the Legal Country field.';
                        Caption = 'Country';
                        TableRelation = "Country/Region".Code;
                        ApplicationArea = All;
                    }
                    field("Legal ISTAT Code"; LegalAddress."ISTAT Code")
                    {
                        ToolTip = 'Specifies the value of the Legal ISTAT Code field.';
                        Caption = 'ISTAT Code';
                        Visible = (not pageOpenedFromPODCard);
                        ApplicationArea = All;
                    }
                }
                group("Billing Address Grp")
                {
                    Caption = 'Billing Address';
                    Editable = "BillingEditable";
                    Visible = "BillingVisible";

                    field("Billing CIV"; BillingAddress."AAT CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIV field.';
                    }
                    field("Billing Address"; BillingAddress.Address)
                    {
                        ToolTip = 'Specifies the value of the Billing Address field.';
                        Caption = 'Address';
                        ApplicationArea = All;
                    }
                    field("Billing Address 2"; BillingAddress."Address 2")
                    {
                        ToolTip = 'Specifies the value of the Billing Address 2 field.';
                        Caption = 'Address 2';
                        ApplicationArea = All;
                    }
                    field("Billing City"; BillingAddress.City)
                    {
                        ToolTip = 'Specifies the value of the Billing City field.';
                        Caption = 'City';
                        LookupPageID = "Post Codes";
                        TableRelation = "Post Code"."City in Deutsch";
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(BillingAddress);
                        end;
                    }
                    field("Billing Post Code"; BillingAddress."Post Code")
                    {
                        ToolTip = 'Specifies the value of the Billing Post Code field.';
                        Caption = 'Post Code';
                        TableRelation = "Post Code".Code;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(BillingAddress);
                        end;
                    }
                    field("Billing County Code"; BillingAddress."County Code")
                    {
                        ToolTip = 'Specifies the value of the Billing County Code field.';
                        Caption = 'County Code';
                        TableRelation = "PS County".Code;
                        ApplicationArea = All;

                        trigger OnValidate()
                        var
                            County: Record "PS County";
                        begin
                            if County.Get(Rec."County Code")then Rec.County:=County.Name;
                        end;
                    }
                    field("Billing County"; BillingAddress.County)
                    {
                        ToolTip = 'Specifies the value of the Billing County field.';
                        Caption = 'County';
                        visible = false;
                        ApplicationArea = All;
                    }
                    field("Billing Country"; BillingAddress."Country No")
                    {
                        ToolTip = 'Specifies the value of the Billing Country field.';
                        Caption = 'Country';
                        TableRelation = "Country/Region".Code;
                        ApplicationArea = All;
                    }
                    field("Billing ISTAT Code"; BillingAddress."ISTAT Code")
                    {
                        ToolTip = 'Specifies the value of the Billing ISTAT Code field.';
                        Caption = 'ISTAT Code';
                        Visible = (not pageOpenedFromPODCard);
                        ApplicationArea = All;
                    }
                }
                group("Communication Address Grp")
                {
                    Caption = 'Communication Address';
                    Editable = "CommunicationEditable";
                    Visible = "CommunicationVisible";

                    field("Communication CIV"; CommunicationAddress."AAT CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIV field.';
                    }
                    field("Communication Address"; CommunicationAddress.Address)
                    {
                        ToolTip = 'Specifies the value of the Communication Address field.';
                        Caption = 'Address';
                        ApplicationArea = All;
                    }
                    field("Communication Address 2"; CommunicationAddress."Address 2")
                    {
                        ToolTip = 'Specifies the value of the Communication Address 2 field.';
                        Caption = 'Address 2';
                        ApplicationArea = All;
                    }
                    field("Communication City"; CommunicationAddress.City)
                    {
                        ToolTip = 'Specifies the value of the Communication City field.';
                        Caption = 'City';
                        TableRelation = "Post Code"."City in Deutsch";
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(CommunicationAddress);
                        end;
                    }
                    field("Communication Post Code"; CommunicationAddress."Post Code")
                    {
                        ToolTip = 'Specifies the value of the Communication Post Code field.';
                        Caption = 'Post Code';
                        TableRelation = "Post Code".Code;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(CommunicationAddress);
                        end;
                    }
                    field("Communication County Code"; CommunicationAddress."County Code")
                    {
                        ToolTip = 'Specifies the value of the Communication County Code field.';
                        Caption = 'County Code';
                        Lookup = true;
                        TableRelation = "PS County".Code;
                        ApplicationArea = All;
                    }
                    field("Communication County"; CommunicationAddress.County)
                    {
                        ToolTip = 'Specifies the value of the Communication County field.';
                        Caption = 'County';
                        visible = false;
                        ApplicationArea = All;
                    }
                    field("Communication Country"; CommunicationAddress."Country No")
                    {
                        ToolTip = 'Specifies the value of the Communication County field.';
                        Caption = 'Country';
                        TableRelation = "Country/Region".Code;
                        ApplicationArea = All;
                    }
                }
                group("Physical Address Grp")
                {
                    Caption = 'Physical Address';
                    Editable = "PhysicalEditable";
                    Visible = "PhysicalVisible";

                    field("Physical CIV"; PhysicalAddress."AAT CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the CIV field.';
                    }
                    field("Physical Address"; PhysicalAddress.Address)
                    {
                        ToolTip = 'Specifies the value of the Physical Address field.';
                        Caption = 'Address';
                        ApplicationArea = All;
                    }
                    field("Physical Address 2"; PhysicalAddress."Address 2")
                    {
                        ToolTip = 'Specifies the value of the Physical Address 2 field.';
                        Caption = 'Address 2';
                        ApplicationArea = All;
                    }
                    field("Physical City"; PhysicalAddress.City)
                    {
                        ToolTip = 'Specifies the value of the Physical City field.';
                        Caption = 'City';
                        TableRelation = "Post Code"."City in Deutsch";
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean var
                        begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(PhysicalAddress);
                        end;
                    }
                    field("Physical Post Code"; PhysicalAddress."Post Code")
                    {
                        ToolTip = 'Specifies the value of the Physical Post Code field.';
                        Caption = 'Post Code';
                        TableRelation = "Post Code".Code;
                        ApplicationArea = All;

                        trigger OnLookup(var Text: Text): Boolean begin
                            ModifySecondaryLanguage.ValidateSecondaryAddressFields(PhysicalAddress);
                        end;
                    }
                    field("Physical County Code"; PhysicalAddress."County Code")
                    {
                        ToolTip = 'Specifies the value of the Physical County Code field.';
                        Caption = 'County Code';
                        TableRelation = "PS County".Code;
                        ApplicationArea = All;
                    }
                    field("Physical Country"; PhysicalAddress."Country No")
                    {
                        ToolTip = 'Specifies the value of the Physical Country field.';
                        Caption = 'Country';
                        TableRelation = "Country/Region".Code;
                        ApplicationArea = All;
                    }
                    field("Physical ISTAT Code"; PhysicalAddress."ISTAT Code")
                    {
                        ToolTip = 'Specifies the value of the Physical ISTAT Code field.';
                        Caption = 'ISTAT Code';
                        Visible = (not pageOpenedFromPODCard);
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    actions
    {
    }
    //KB14122023 - TASK002199 Disable Next and Previous Button +++
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(100);
        Rec.SetRange("Source Type", Rec."Source Type");
        Rec.SetRange("Source No.", Rec."Source No.");
        Rec.SetRange("Language No.", Rec."Language No.");
        Rec.SetRange(Type, Rec.Type);
        Rec.FilterGroup(0);
    end;
    //KB14122023 - TASK002199 Disable Next and Previous Button --- 
    trigger OnQueryClosePage(CloseAction: Action): Boolean begin
        if not LegalAddress.Insert(true)then LegalAddress.Modify(true);
        if not BillingAddress.Insert(true)then BillingAddress.Modify(true);
        if not CommunicationAddress.Insert(true)then CommunicationAddress.Modify(true);
        if not PhysicalAddress.Insert(true)then PhysicalAddress.Modify(true);
    end;
    trigger OnClosePage()
    var
        SalesHeader: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        InvoiceGenerationManagement: Codeunit "Invoice Generation Management";
    begin
        SalesHeader.SetRange("Document Type", "Sales Document Type"::Invoice);
        SalesHeader.SetRange("Sell-to Customer No.", CustomerNo);
        SalesHeader.SetRange(Status, SalesHeader.Status::Open);
        if SalesHeader.FindSet()then repeat SalesHeader2.Get(SalesHeader."Document Type", SalesHeader."No.");
                InvoiceGenerationManagement.GetSecondaryLanguage(SalesHeader2);
            until SalesHeader.Next() = 0;
    end;
    var BillingAddress: Record "Secondary Language Address";
    CommunicationAddress: Record "Secondary Language Address";
    LegalAddress: Record "Secondary Language Address";
    PhysicalAddress: Record "Secondary Language Address";
    SecondaryAddress: Record "Secondary Language Address";
    ModifySecondaryLanguage: Codeunit "Modify Secondary Language";
    BillingEditable: Boolean;
    BillingVisible: Boolean;
    CommunicationEditable: Boolean;
    CommunicationVisible: Boolean;
    LegalEditable: Boolean;
    LegalVisible: Boolean;
    PhysicalEditable: Boolean;
    PhysicalVisible: Boolean;
    pageOpenedFromPODCard: Boolean;
    CustomerNo: Code[20];
    /// <summary>
    /// OpenPageFromCustomerPage.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    procedure OpenPageFromCustomerPage(Customer: Record Customer)
    var
        SecondaryAdressType: Enum "Secondary Language Type";
    begin
        CustomerNo:=Customer."No.";
        "LegalVisible":=true;
        "LegalEditable":=true;
        if Customer."Address Preferences" = Customer."Address Preferences"::"Same as Legal (Default)" then SameAsLegalModifyInsert(Customer, SecondaryAdressType);
        if Customer."Address Preferences" = Customer."Address Preferences"::"Different Billing Address" then DifferentBillingModifyInsert(Customer, SecondaryAdressType);
        if Customer."Address Preferences" = Customer."Address Preferences"::"Different Communication Address" then DifferentCommunicationModifyInsert(Customer, SecondaryAdressType);
        if Customer."Address Preferences" = Customer."Address Preferences"::"Both Different than Legal Address" then BothDifferentModifyInsert(Customer, SecondaryAdressType);
    end;
    procedure OpenPageFromPODPage(POD: Record "Point of Delivery")
    var
        SecondaryAddress2: Record "Secondary Language Address";
    begin
        SetVisibilityNEditable(false, false, false, true, false, false, false, true);
        PhysicalAddress.SetRange("Source Type", Rec."Source Type"::POD);
        PhysicalAddress.SetRange("Source No.", POD."No.");
        PhysicalAddress.SetRange(Type, Rec.Type::Physical);
        if PhysicalAddress.IsEmpty then begin
            if not ModifySecondaryLanguage.InsertPhysicalAddress(POD, PhysicalAddress)then Error(GetLastErrorText);
        end
        else
        begin
            PhysicalAddress.FindFirst();
            ModifySecondaryLanguage.ModifyPhysicalAddress(POD, PhysicalAddress);
        end;
        PhysicalAddress.Reset();
        PhysicalAddress.SetRange("Source Type", Rec."Source Type"::POD);
        PhysicalAddress.SetRange("Source No.", POD."No.");
        PhysicalAddress.SetRange(Type, Rec.Type::Physical);
        if PhysicalAddress.FindSet()then begin
            ModifySecondaryLanguage.GetSecondaryAddress(PhysicalAddress."Source Type"::POD, POD."No.", Format(Rec.Type::Physical), SecondaryAddress2, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
            ModifySecondaryLanguage.setOpenedFromPOD(true);
            RunModal();
            ModifySecondaryLanguage.SetSecondaryAddress(SecondaryAddress2, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
        end;
    end;
    local procedure BothDifferentModifyInsert(var Customer: Record Customer; var SecondaryAdressType: Enum "Secondary Language Type")
    begin
        SetVisibilityNEditable(true, true, true, false, true, true, true, false);
        InsertModifyLegalAddress(Customer);
        InsertModifyBillingAddress(Customer);
        InsertModifyCommunicationAddress(Customer);
        SecondaryAddress.Reset();
        SecondaryAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        SecondaryAddress.SetRange("Source No.", Customer."No.");
        SecondaryAddress.SetFilter(Type, '%1|%2|%3', SecondaryAdressType::Legal, SecondaryAdressType::Billing, SecondaryAdressType::Communication);
        if SecondaryAddress.FindFirst()then ModifySecondaryLanguage.GetSecondaryAddress(SecondaryAddress."Source Type"::Customer, Customer."No.", Format(Rec.Type), SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
        RunModal();
        ModifySecondaryLanguage.SetSecondaryAddress(SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
    end;
    local procedure DifferentBillingModifyInsert(var Customer: Record Customer; var SecondaryAdressType: Enum "Secondary Language Type")
    begin
        SetVisibilityNEditable(true, false, true, false, true, false, true, false);
        InsertModifyLegalAddress(Customer);
        ModifySecondaryLanguage.InsertModifyCommunicationAddressFromLegal(Customer, CommunicationAddress, LegalAddress);
        InsertModifyBillingAddress(Customer);
        SecondaryAddress.Reset();
        SecondaryAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        SecondaryAddress.SetRange("Source No.", Customer."No.");
        SecondaryAddress.SetFilter(Type, '%1|%2', SecondaryAdressType::Legal, SecondaryAdressType::Billing);
        if SecondaryAddress.FindSet()then ModifySecondaryLanguage.GetSecondaryAddress(SecondaryAddress."Source Type"::Customer, Customer."No.", StrSubstNo('%1|%2', SecondaryAdressType::Legal, SecondaryAdressType::Billing), SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
        RunModal();
        ModifySecondaryLanguage.SetSecondaryAddress(SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
    end;
    local procedure DifferentCommunicationModifyInsert(var Customer: Record Customer; var SecondaryAdressType: Enum "Secondary Language Type")
    begin
        SetVisibilityNEditable(false, true, true, false, false, true, true, false);
        InsertModifyLegalAddress(Customer);
        ModifySecondaryLanguage.InsertModifyBillingAddressFromLegal(Customer, BillingAddress, LegalAddress);
        InsertModifyCommunicationAddress(Customer);
        SecondaryAddress.Reset();
        SecondaryAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        SecondaryAddress.SetRange("Source No.", Customer."No.");
        SecondaryAddress.SetFilter(Type, '%1|%2', SecondaryAdressType::Legal, SecondaryAdressType::Communication);
        if SecondaryAddress.FindSet()then ModifySecondaryLanguage.GetSecondaryAddress(SecondaryAddress."Source Type"::Customer, Customer."No.", StrSubstNo('%1|%2', SecondaryAdressType::Legal, SecondaryAdressType::Communication), SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
        RunModal();
        ModifySecondaryLanguage.SetSecondaryAddress(SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
    end;
    local procedure InsertModifyBillingAddress(var Customer: Record Customer)
    begin
        BillingAddress.Reset();
        BillingAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        BillingAddress.SetRange("Source No.", Customer."No.");
        BillingAddress.SetRange(Type, Rec.Type::Billing);
        if not BillingAddress.FindFirst()then if not ModifySecondaryLanguage.InsertBillingAddress(Customer, BillingAddress)then Error(GetLastErrorText);
    end;
    local procedure InsertModifyCommunicationAddress(var Customer: Record Customer)
    begin
        CommunicationAddress.Reset();
        CommunicationAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        CommunicationAddress.SetRange("Source No.", Customer."No.");
        CommunicationAddress.SetRange(Type, Rec.Type::Communication);
        if not CommunicationAddress.FindFirst()then if not ModifySecondaryLanguage.InsertCommunicationAddress(Customer, CommunicationAddress)then Error(GetLastErrorText);
    end;
    local procedure InsertModifyLegalAddress(var Customer: Record Customer)
    begin
        LegalAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        LegalAddress.SetRange("Source No.", Customer."No.");
        LegalAddress.SetRange(Type, Rec.Type::Legal);
        if not LegalAddress.FindFirst()then if not ModifySecondaryLanguage.InsertLegalAddress(Customer, LegalAddress)then Error(GetLastErrorText);
    end;
    local procedure SameAsLegalModifyInsert(var Customer: Record Customer; var SecondaryAdressType: Enum "Secondary Language Type")
    begin
        SetVisibilityNEditable(true, true, true, false, false, false, true, false);
        InsertModifyLegalAddress(Customer);
        ModifySecondaryLanguage.InsertModifyBillingAddressFromLegal(Customer, BillingAddress, LegalAddress);
        ModifySecondaryLanguage.InsertModifyCommunicationAddressFromLegal(Customer, CommunicationAddress, LegalAddress);
        SecondaryAddress.Reset();
        SecondaryAddress.SetRange("Source Type", Rec."Source Type"::Customer);
        SecondaryAddress.SetRange("Source No.", Customer."No.");
        SecondaryAddress.SetFilter(Type, '%1|%2|%3', SecondaryAdressType::Legal, SecondaryAdressType::Billing, SecondaryAdressType::Communication);
        if SecondaryAddress.FindSet()then ModifySecondaryLanguage.GetSecondaryAddress(SecondaryAddress."Source Type"::Customer, Customer."No.", StrSubstNo('%1|%2|%3', SecondaryAdressType::Legal, SecondaryAdressType::Billing, SecondaryAdressType::Communication), SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
        RunModal();
        ModifySecondaryLanguage.SetSecondaryAddress(SecondaryAddress, CommunicationAddress, BillingAddress, LegalAddress, PhysicalAddress);
    end;
    local procedure SetVisibilityNEditable("pBillingVisible": Boolean; "pCommunicationVisible": Boolean; "pLegalVisible": Boolean; "pPhysicalVisible": Boolean; "pBillingEditable": Boolean; "pCommunicationEditable": Boolean; "pLegalEditable": Boolean; "pPhysicalEditable": Boolean)
    begin
        "BillingVisible":=pBillingVisible;
        "CommunicationVisible":="pCommunicationVisible";
        "BillingEditable":="pBillingEditable";
        "CommunicationEditable":="pCommunicationEditable";
        "LegalVisible":="pLegalVisible";
        "LegalEditable":="pLegalEditable";
        "PhysicalVisible":="pPhysicalVisible";
        "PhysicalEditable":="pPhysicalEditable";
    end;
}
