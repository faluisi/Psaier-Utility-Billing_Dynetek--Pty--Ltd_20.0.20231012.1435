codeunit 50215 "Modify Secondary Language"
{
    TableNo = "Secondary Language Address";

    procedure InsertLegalAddress(var Customer: Record Customer; var LegalAddress: Record "Secondary Language Address"): Boolean var
        LegalAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        LegalAddress2.Init();
        LegalAddress2."Source Type":=LegalAddress."Source Type"::Customer;
        LegalAddress2."Source No.":=Customer."No.";
        LegalAddress2.Validate("Language No.", Customer."Customer Language Code");
        LegalAddress2.Type:=LegalAddress.Type::Legal;
        LegalAddress2."Post Code":=Customer."Post Code";
        LegalAddress2."ISTAT Code":=Customer."ISTAT Code";
        LegalAddress2."AAT CIV PUB":=Customer."AAT CIV PUB";
        PostCode.SetRange(Code, Customer."Post Code");
        if PostCode.FindFirst()then begin
            LegalAddress2.City:=PostCode."City in Deutsch";
            LegalAddress2.Validate("County Code", PostCode."County Code");
            LegalAddress2."Country No":=PostCode."Country/Region Code";
        end;
        if LegalAddress2.Insert(true)then begin
            Commit();
            LegalAddress:=LegalAddress2;
            exit(true);
        end
        else
            exit(false);
    end;
    procedure InsertBillingAddress(var Customer: Record Customer; var BillingAddress: Record "Secondary Language Address"): Boolean var
        BillingAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        BillingAddress2.Init();
        BillingAddress2."Source Type":=BillingAddress."Source Type"::Customer;
        BillingAddress2."Source No.":=Customer."No.";
        BillingAddress2.Validate("Language No.", Customer."Customer Language Code");
        BillingAddress2.Type:=BillingAddress.Type::Billing;
        BillingAddress2."ISTAT Code":=Customer."Billing ISTAT Code";
        BillingAddress2.Address:=Customer.Address;
        BillingAddress2."Address 2":=Customer."Address 2";
        BillingAddress2."AAT CIV PUB":=Customer."AAT CIV PUB";
        if PostCode.Get(Customer."Billing Post Code", Customer."Billing City")then begin
            BillingAddress2.Validate("Post Code", PostCode.Code);
            BillingAddress2.Validate(City, PostCode."City in Deutsch");
            BillingAddress2.Validate("County Code", PostCode."County Code");
            BillingAddress2.Validate(County, PostCode.County);
            BillingAddress2.Validate("Country No", PostCode."Country/Region Code");
        end;
        if BillingAddress2.Insert(true)then begin
            Commit();
            BillingAddress:=BillingAddress2;
            exit(true)end
        else
            exit(false);
    end;
    procedure InsertCommunicationAddress(var Customer: Record Customer; var CommunicationAddress: Record "Secondary Language Address"): Boolean var
        CommunicationAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        CommunicationAddress2.Init();
        CommunicationAddress2."Source Type":=CommunicationAddress."Source Type"::Customer;
        CommunicationAddress2."Source No.":=Customer."No.";
        CommunicationAddress2.Validate("Language No.", Customer."Customer Language Code");
        CommunicationAddress2.Type:=CommunicationAddress.Type::Communication;
        CommunicationAddress2."ISTAT Code":=Customer."Communication ISTAT Code";
        CommunicationAddress2.Address:=Customer.Address;
        CommunicationAddress2."Address 2":=Customer."Address 2";
        CommunicationAddress2."AAT CIV PUB":=Customer."AAT CIV PUB";
        if PostCode.Get(Customer."Communication Post Code", Customer."Communication City")then begin
            CommunicationAddress2.Validate("Post Code", PostCode.Code);
            CommunicationAddress2.Validate(City, PostCode."City in Deutsch");
            CommunicationAddress2.Validate("County Code", PostCode."County Code");
            CommunicationAddress2.Validate(County, PostCode.County);
            CommunicationAddress2.Validate("Country No", PostCode."Country/Region Code");
        end;
        if CommunicationAddress2.Insert(true)then begin
            Commit();
            CommunicationAddress:=CommunicationAddress2;
            exit(true)end
        else
            exit(false);
    end;
    procedure InsertModifyCommunicationAddressFromLegal(var Customer: Record Customer; var CommunicationAddress: Record "Secondary Language Address"; var LegalAddress: Record "Secondary Language Address"): Boolean var
        CommunicationAddress2: Record "Secondary Language Address";
    begin
        CommunicationAddress2.Reset();
        CommunicationAddress2.Type:=LegalAddress.Type::Communication;
        CommunicationAddress2.Address:=LegalAddress.Address;
        CommunicationAddress2."Address 2":=LegalAddress."Address 2";
        CommunicationAddress2."AAT CIV PUB":=LegalAddress."AAT CIV PUB";
        CommunicationAddress2.City:=LegalAddress.City;
        CommunicationAddress2.County:=LegalAddress.County;
        CommunicationAddress2."County Code":=LegalAddress."County Code";
        CommunicationAddress2."Country No":=LegalAddress."Country No";
        CommunicationAddress2."ISTAT Code":=LegalAddress."ISTAT Code";
        CommunicationAddress2."Post Code":=LegalAddress."Post Code";
        if CommunicationAddress2.Insert(true)then begin
            Commit();
            CommunicationAddress:=CommunicationAddress2;
            exit(true)end
        else if CommunicationAddress2.Modify(false)then begin
                Commit();
                CommunicationAddress:=CommunicationAddress2;
                exit(true)end
            else
                exit(false);
    end;
    procedure InsertModifyBillingAddressFromLegal(var Customer: Record Customer; var BillingAddress: Record "Secondary Language Address"; var LegalAddress: Record "Secondary Language Address"): Boolean var
        BillingAddress2: Record "Secondary Language Address";
    begin
        BillingAddress2.Reset();
        BillingAddress2.Type:=LegalAddress.Type::Billing;
        BillingAddress2.Address:=LegalAddress.Address;
        BillingAddress2."Address 2":=LegalAddress."Address 2";
        BillingAddress2."AAT CIV PUB":=LegalAddress."AAT CIV PUB";
        BillingAddress2.City:=LegalAddress.City;
        BillingAddress2."Post Code":=LegalAddress."Post Code";
        BillingAddress2."ISTAT Code":=LegalAddress."ISTAT Code";
        BillingAddress2.County:=LegalAddress.County;
        BillingAddress2."County Code":=LegalAddress."County Code";
        BillingAddress2."Country No":=LegalAddress."Country No";
        if BillingAddress2.Insert(true)then begin
            Commit();
            BillingAddress:=BillingAddress2;
            exit(true)end
        else if BillingAddress2.Modify(false)then begin
                Commit();
                BillingAddress:=BillingAddress2;
                exit(true)end
            else
                exit(false);
    end;
    /// <summary>
    /// GetSecondaryAddress.
    /// </summary>
    /// <param name="Source Type ">Enum "Secondary Lang. Source Type".</param>
    /// <param name="Source No . ">Code[20].</param>
    /// <param name="Type Filter  String ">Text.</param>
    procedure GetSecondaryAddress(SourceType: Enum "Secondary Lang. Source Type"; "SourceNo.": Code[20]; "TypeFilterString": Text; SecondaryAddress: Record "Secondary Language Address"; CommunicationAddress: Record "Secondary Language Address"; BillingAddress: Record "Secondary Language Address"; LegalAddress: Record "Secondary Language Address"; PhysicalAddress: Record "Secondary Language Address")
    var
    begin
        SecondaryAddress.SetRange("Source Type", SecondaryAddress."Source Type");
        SecondaryAddress.SetRange("Source No.", SecondaryAddress."Source No.");
        SecondaryAddress.SetFilter(Type, "TypeFilterString");
        if not SecondaryAddress.IsEmpty and SecondaryAddress.FindSet()then repeat case SecondaryAddress.Type of SecondaryAddress.Type::Billing: BillingAddress:=SecondaryAddress;
                SecondaryAddress.Type::Legal: LegalAddress:=SecondaryAddress;
                SecondaryAddress.Type::Communication: CommunicationAddress:=SecondaryAddress;
                SecondaryAddress.Type::Physical: PhysicalAddress:=SecondaryAddress;
                else
                end;
            until SecondaryAddress.Next() = 0;
    end;
    /// <summary>
    /// SetSecondaryAddress.
    /// </summary>
    procedure SetSecondaryAddress(var SecondaryAddress: Record "Secondary Language Address"; CommunicationAddress: Record "Secondary Language Address"; BillingAddress: Record "Secondary Language Address"; LegalAddress: Record "Secondary Language Address"; PhysicalAddress: Record "Secondary Language Address")
    var
    begin
        SecondaryAddress.Reset();
        if SecondaryAddress.Get("LegalAddress"."Source Type", "LegalAddress"."Source No.", "LegalAddress"."Language No.", "LegalAddress".Type)then ModifySecondaryAddress(SecondaryAddress, "LegalAddress");
        SecondaryAddress.Reset();
        if SecondaryAddress.Get("BillingAddress"."Source Type", "BillingAddress"."Source No.", "BillingAddress"."Language No.", "BillingAddress".Type)then ModifySecondaryAddress(SecondaryAddress, "BillingAddress");
        SecondaryAddress.Reset();
        if SecondaryAddress.Get("CommunicationAddress"."Source Type", "CommunicationAddress"."Source No.", "CommunicationAddress"."Language No.", "CommunicationAddress".Type)then ModifySecondaryAddress(SecondaryAddress, "CommunicationAddress");
        SecondaryAddress.Reset();
        if SecondaryAddress.Get("PhysicalAddress"."Source Type", "PhysicalAddress"."Source No.", "PhysicalAddress"."Language No.", "PhysicalAddress".Type)then ModifySecondaryAddress(SecondaryAddress, "PhysicalAddress");
    end;
    procedure ModifySecondaryAddress(SecondaryAddress: Record "Secondary Language Address"; AddressVar: Record "Secondary Language Address")
    begin
        SecondaryAddress."AAT CIV PUB":=AddressVar."AAT CIV PUB";
        SecondaryAddress.Address:=AddressVar.Address;
        SecondaryAddress."Address 2":=AddressVar."Address 2";
        SecondaryAddress.City:=AddressVar.City;
        SecondaryAddress."Post Code":=AddressVar."Post Code";
        SecondaryAddress.Validate("County Code", AddressVar."County Code");
        SecondaryAddress."Country No":=AddressVar."Country No";
        SecondaryAddress."ISTAT Code":=AddressVar."ISTAT Code";
        SecondaryAddress.Modify(true);
    end;
    /// <summary>
    /// SetVisibilityNEditable.
    /// </summary>
    /// <param name="Customer">Record Customer.</param>
    /// <param name="pBilling Visible ">Boolean.</param>
    /// <param name="pCommunication Visible ">Boolean.</param>
    /// <param name="pLegal Visible ">Boolean.</param>
    /// <param name="pPhysical Visible ">Boolean.</param>
    /// <param name="pBilling Editable ">Boolean.</param>
    /// <param name="pCommunication Editable ">Boolean.</param>
    /// <param name="pLegal Editable ">Boolean.</param>
    /// <param name="pPhysical Editable ">Boolean.</param>
    procedure ModifyLegalAddress(Customer: Record Customer; var LegalAddress: Record "Secondary Language Address")
    var
        LegalAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        if LegalAddress2.Get(LegalAddress2."Source Type"::Customer, Customer."No.", Customer."Customer Language Code", LegalAddress2.Type::Legal)then begin
            LegalAddress2."ISTAT Code":=Customer."ISTAT Code";
            LegalAddress2."AAT CIV PUB":=Customer."AAT CIV PUB";
            LegalAddress2.Address:=Customer.Address;
            LegalAddress2."Address 2":=Customer."Address 2";
            if PostCode.Get(Customer."Post Code", Customer.City)then begin
                LegalAddress2."Post Code":=PostCode.Code;
                LegalAddress2.City:=PostCode."City in Deutsch";
                LegalAddress2.Validate("County Code", PostCode."County Code");
                LegalAddress2."Country No":=PostCode."Country/Region Code";
                if LegalAddress2.Modify(true)then begin
                    Commit();
                    LegalAddress:=LegalAddress2 end;
            end;
        end;
    end;
    procedure ModifyBillingAddress(Customer: Record Customer; var BillingAddress: Record "Secondary Language Address")
    var
        BillingAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        BillingAddress2."ISTAT Code":=Customer."Billing ISTAT Code";
        if BillingAddress2.Get(BillingAddress2."Source Type"::Customer, Customer."No.", Customer."Customer Language Code", BillingAddress2.Type::Billing)then begin
            BillingAddress2."AAT CIV PUB":=Customer."AAT Billing CIV PUB";
            BillingAddress2.Address:=Customer."Billing Address";
            BillingAddress2."Address 2":=Customer."Billing Address 2";
            if PostCode.Get(Customer."Billing Post Code", Customer."Billing City")then begin
                BillingAddress2."Post Code":=PostCode.Code;
                BillingAddress2.City:=PostCode."City in Deutsch";
                BillingAddress2.Validate("County Code", PostCode."County Code");
                BillingAddress2."Country No":=PostCode."Country/Region Code";
                if BillingAddress2.Modify(true)then begin
                    Commit();
                    BillingAddress:=BillingAddress2;
                end;
            end;
        end;
    end;
    procedure ModifyCommunicationAddress(Customer: Record Customer; var CommunicationAddress: Record "Secondary Language Address")
    var
        CommunicationAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        if CommunicationAddress2.Get(CommunicationAddress2."Source Type"::Customer, Customer."No.", Customer."Customer Language Code", CommunicationAddress2.Type::Communication)then begin
            CommunicationAddress2."AAT CIV PUB":=Customer."AAT Communication CIV PUB";
            CommunicationAddress2.Address:=Customer."Communication Address";
            CommunicationAddress2."Address 2":=Customer."Communication Address 2";
            if PostCode.Get(Customer."Communication Post Code", Customer."Communication City")then begin
                CommunicationAddress2."Post Code":=PostCode.Code;
                CommunicationAddress2.City:=PostCode."City in Deutsch";
                CommunicationAddress2.Validate("County Code", PostCode."County Code");
                CommunicationAddress2."Country No":=PostCode."Country/Region Code";
                if CommunicationAddress2.Modify(true)then begin
                    Commit();
                    CommunicationAddress:=CommunicationAddress2;
                end;
            end;
        end;
    end;
    procedure InsertPhysicalAddress(POD: Record "Point of Delivery"; var PhysicalAddress: Record "Secondary Language Address"): Boolean var
        PhysicalAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        PhysicalAddress2.Init();
        PostCode.SetRange("City", POD.City);
        if(not PostCode.IsEmpty()) and PostCode.FindFirst()then PhysicalAddress2.City:=PostCode."City in Deutsch";
        PhysicalAddress2."Source Type":=PhysicalAddress2."Source Type"::POD;
        PhysicalAddress2."Source No.":=POD."No.";
        PhysicalAddress2.Type:=PhysicalAddress2.Type::Physical;
        PhysicalAddress2."Language No.":=POD."Address Langauge Code";
        PhysicalAddress2."Post Code":=POD."Post Code";
        PhysicalAddress2."Country No":=POD."Country/Region Code";
        PhysicalAddress2."County Code":=POD."County Code";
        if PhysicalAddress2.Insert(true)then begin
            Commit();
            exit(true)end
        else
            exit(false);
    end;
    procedure ModifyPhysicalAddress(POD: Record "Point of Delivery"; var PhysicalAddress: Record "Secondary Language Address"): Boolean var
        PhysicalAddress2: Record "Secondary Language Address";
        PostCode: Record "Post Code";
    begin
        PostCode.SetRange("City", POD.City);
        if(not PostCode.IsEmpty()) and PostCode.FindFirst()then PhysicalAddress2.City:=PostCode."City in Deutsch"
        else
            PhysicalAddress2.City:=POD.City;
        PhysicalAddress2."Post Code":=POD."Post Code";
        PhysicalAddress2."Country No":=POD."Country/Region Code";
        PhysicalAddress2."County Code":=POD."County Code";
        PhysicalAddress2."ISTAT Code":=POD."ISTAT Code";
        if PhysicalAddress2.Modify(true)then begin
            Commit();
            PhysicalAddress:=PhysicalAddress2;
            exit(true)end
        else
            exit(false);
    end;
    procedure ValidateSecondaryAddressFields(var SecondaryLanguageAdress: Record "Secondary Language Address")
    var
        PostCode: Record "Post Code";
    begin
        if PAGE.RunModal(Page::"Post Codes", PostCode) = Action::LookupOK then begin
            SecondaryLanguageAdress.Validate(City, PostCode."City in Deutsch");
            SecondaryLanguageAdress.Validate("Post Code", PostCode.Code);
            SecondaryLanguageAdress.Validate("County Code", PostCode."County Code");
            SecondaryLanguageAdress."Country No":=PostCode."Country/Region Code";
            SecondaryLanguageAdress."ISTAT Code":=PostCode."ISTAT Code";
            if not SecondaryLanguageAdress.Modify(true)then SecondaryLanguageAdress.Insert(true);
        end;
    end;
    /// <summary>
    /// setOpenedFromPOD.
    /// </summary>
    /// <param name="newpageOpenedFromPODCard">Boolean.</param>
    procedure setOpenedFromPOD(newpageOpenedFromPODCard: Boolean)
    begin
        pageOpenedFromPODCard:=newpageOpenedFromPODCard;
    end;
    var pageOpenedFromPODCard: Boolean;
}
