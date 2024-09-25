pageextension 50201 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(Address)
        {
            field("AAT CIV PUB"; Rec."AAT CIV PUB")
            {
                ApplicationArea = All;
                Caption = 'CIV';
                ToolTip = 'Specifies the value of the CIV field.';
            }
        }
        addafter("No.")
        {
            field("Customer Type"; Rec."Customer Type")
            {
                ToolTip = 'Specifies the value of the Customer Type field.';
                ApplicationArea = All;
                Caption = 'Customer Type';

                trigger OnValidate()
                begin
                    case Rec."Customer Type" of Rec."Customer Type"::Company: begin
                        EditCompany:=true;
                        EditPerson:=false;
                        PersonVisibility:=true;
                        TaxRepresentationVisibility:=false;
                    end;
                    Rec."Customer Type"::Person: begin
                        EditPerson:=true;
                        EditCompany:=false;
                        PersonVisibility:=false;
                        TaxRepresentationVisibility:=True;
                    end;
                    Rec."Customer Type"::" ": begin
                        PersonVisibility:=false;
                        TaxRepresentationVisibility:=True;
                    end;
                    end;
                end;
            }
        }
        // AN 06122023 - TASK002140 - Not required field if the customer type is company ++
        addlast(General)
        {
            group("Tax Representation")
            {
                Visible = TaxRepresentationVisibility;
            }
        }
        addlast(Individual)
        {
            group("Person details")
            {
                Visible = PersonVisibility;
            }
        }
        addlast("Person details")
        {
            field("First Name Legal Repre."; Rec."First Name Legal Repre.")
            {
                ToolTip = 'Specifies the value of First Name Legal Repre field.';
                ApplicationArea = Basic, Suite;
            }
            field("Last Name Legal Repre."; Rec."Last Name Legal Repre.")
            {
                ToolTip = 'Specifies the value of Last Name Legal Repre field.';
                ApplicationArea = Basic, Suite;
            }
            field("Fiscal Code Legal Repre."; Rec."Fiscal Code Legal Repre.")
            {
                ToolTip = 'Specifies the value of Fiscal Code Legal Repre field.';
                ApplicationArea = Basic, Suite;
            }
            field("Province of Birth"; Rec."Province of Birth")
            {
                ToolTip = 'Specifies the value of Province of Birth field.';
                ApplicationArea = Basic, Suite;
            }
            field("Nation of Birth"; Rec."Nation of Birth")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Nation of Birth field.';
            }
            field(Gender; Rec.Gender)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the value of Gender field.';
            }
        }
        movelast("Person details"; "Date of Birth")
        movelast("Person details"; "PEC E-Mail Address")
        movelast("Person details"; "PA Code")
        movelast("Person details"; "Place of Birth")
        movefirst("Person details"; "Individual Person")
        movefirst("Tax Representation"; "Tax Representative Type")
        movelast("Tax Representation"; "Tax Representative No.")
        // AN 06122023 - TASK002140 - Not required field if the customer type is company --
        moveafter(Name; "First Name")
        moveafter("First Name"; "Last Name")
        moveafter("Fiscal Code"; "VAT Registration No.")
        // AN 21112023 - TASK002140 - field editable false if customer type is Person ++  
        modify("VAT Registration No.")
        {
            Editable = (Rec."Customer Type" = Rec."Customer Type"::Company) or (Rec."Customer Type" = Rec."Customer Type"::" ");
        }
        // AN 21112023 - TASK002140 - field editable false if customer type is Person --  
        // AN 21112023 - TASK002140 - Bill-to-customer, GLN, and Registration number - Need to be removed for both Person and Company Customers ++
        modify("Bill-to Customer No.")
        {
            Visible = false;
        }
        modify(GLN)
        {
            Visible = false;
        }
        modify("Registration Number")
        {
            Visible = false;
        }
        // AN 21112023 - TASK002140 - Bill-to-customer, GLN, and Registration number - Need to be removed for both Person and Company Customers  --
        modify(Name)
        {
            Editable = EditCompany;
        }
        modify("First Name")
        {
            Editable = EditPerson;
        }
        modify("Last Name")
        {
            Editable = EditPerson;
        }
        modify(PricesandDiscounts)
        {
            Visible = false;
        }
        modify(PostingDetails)
        {
            Visible = true;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
        modify("EORI Number")
        {
            Visible = false;
        }
        modify(ShowMap)
        {
            Visible = false;
        }
        modify(Resident)
        {
            Visible = false;
        }
        modify("Use GLN in Electronic Document")
        {
            Visible = false;
        }
        modify("Copy Sell-to Addr. to Qte From")
        {
            Visible = false;
        }
        // -> BB 2.2.2 QA Fixes.
        modify("Individual Person")
        {
            // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person ++
            Visible = not(Rec."Customer Type" = Rec."Customer Type"::person);

            // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person --
            trigger OnBeforeValidate()
            begin
                case Rec."Individual Person" of false: begin
                    EditCompany:=true;
                    EditPerson:=false;
                end;
                true: begin
                    EditPerson:=true;
                    EditCompany:=false;
                end;
                end;
            end;
        }
        moveafter(General; "Address & Contact")
        modify("Address & Contact")
        {
            Caption = 'Legal Address & Contact';
        }
        moveafter("Post Code"; County)
        addbefore(Address)
        {
            field("Address Preferences"; Rec."Address Preferences")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value ofvalue of the Address Preference field.';
                Caption = 'Address Preferences';

                trigger OnValidate()
                var
                begin
                    UpdateAddressInfo();
                end;
            }
            field("Customer Language Code"; Rec."Customer Language Code")
            {
                Caption = 'Address Language Preferance';
                ApplicationArea = All;
                ToolTip = 'Specifies the value ofvalue of the Customer Language Code field.';
                AssistEdit = true;

                trigger OnAssistEdit()
                var
                    UtilitySetup: Record "Utility Setup";
                    SecondaryAddressPage: Page "Address Secondary Language";
                    ErrorMsg: Label 'Change the customer language code something other than ITA to add secondary language addresses for the customer.';
                    MissingBillingMsg: Label 'Enter an address into the Billing Address fields.';
                    MissingCommunicationMsg: Label 'Enter an address into the Communication Address fields.';
                    MissingAddressMsg: Label 'Enter an address into the Billing Address and Communication Address fields.';
                begin
                    UtilitySetup.GetRecordOnce();
                    if(Rec."Customer Language Code" = 'ITA') or (Rec."Customer Language Code" = '')then Error(ErrorMsg);
                    case Rec."Address Preferences" of Rec."Address Preferences"::"Different Billing Address": if(Rec."Billing Post Code" = '') or (Rec."Billing County Code" = '')then Error(MissingBillingMsg);
                    Rec."Address Preferences"::"Different Communication Address": if(Rec."Communication Post Code" = '') or (Rec."Communication County" = '')then Error(MissingCommunicationMsg);
                    Rec."Address Preferences"::"Both Different than Legal Address": if(Rec."Billing Post Code" = '') or (Rec."Billing County Code" = '') or (Rec."Communication Post Code" = '') or (Rec."Communication County" = '')then Error(MissingAddressMsg);
                    end;
                    SecondaryAddressPage.OpenPageFromCustomerPage(Rec);
                    Rec.UpdateInvoiceAddress();
                end;
            }
            field(Toponym; Rec.Toponym)
            {
                Caption = 'Toponym';
                ToolTip = 'Specifies the value ofvalue of the Toponym field.';
                ApplicationArea = All;
            }
        }
        modify(County)
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        addafter("Post Code")
        {
            field("County Code"; Rec."County Code")
            {
                Caption = 'County Code';
                ToolTip = 'Specifies the value of the County Code field.';
                ApplicationArea = All;
            }
            field("County Name"; Rec."County Name")
            {
                Caption = 'County';
                ToolTip = 'Specifies the value of the County Name field.';
                ApplicationArea = All;
                Visible = false;
            }
            field("Country"; Rec."Country/Region Code")
            {
                Caption = 'Country';
                ToolTip = 'Specifies the value of the Country field.';
                ApplicationArea = All;
            }
            field("ISTAT Code"; Rec."ISTAT Code")
            {
                ToolTip = 'Specifies the value of the ISTAT Code field.';
                ApplicationArea = All;
                Caption = 'ISTAT Code';
            }
            //KB12122023 - TASK002199 Salvaguardia market +++
            field("Salvaguardia Market"; Rec."Salvaguardia Market")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salvaguardia Market field.';
            }
        //KB12122023 - TASK002199 Salvaguardia market ---
        }
        addafter("E-Mail")
        {
            // AN 22112023 - TASK002140  field removed ++ 
            field("Certified E-Mail Address"; Rec."Certified E-Mail Address")
            {
                ExtendedDatatype = EMail;
                ToolTip = 'Specifies the value of the Certified E-Mail Address field.';
                ApplicationArea = All;
                Caption = 'Certified E-Mail Address';
                Visible = false;
            }
        // AN 22112023 - TASK002140  field removed --
        }
        addafter("Address & Contact")
        {
            group("Billing / Communication")
            {
                Caption = 'Billing / Communication';

                group("Billing Information")
                {
                    Caption = 'Billing Information';

                    field("Billing Toponym"; Rec."Billing Toponym")
                    {
                        ToolTip = 'Specifies the value of the Billing Toponym field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing Toponym';
                    }
                    field("AAT Billing CIV PUB"; Rec."AAT Billing CIV PUB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Billing CIV field.';
                        Editable = BilledEditable;
                        Caption = 'Billing CIV';
                    }
                    field("Billing Address"; Rec."Billing Address")
                    {
                        ToolTip = 'Specifies the value of the Biling Address field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing Address';
                    }
                    field("Billing Address 2"; Rec."Billing Address 2")
                    {
                        ToolTip = 'Specifies the value of the Billing Address 2 field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing Address 2';
                    }
                    field("Billing City"; Rec."Billing City")
                    {
                        ToolTip = 'Specifies the value of the Billing City field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing City';
                    }
                    field("Billing Post Code"; Rec."Billing Post Code")
                    {
                        ToolTip = 'Specifies the value of the Billing Post Code field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing Post Code';
                    }
                    field("Billing County Code"; Rec."Billing County Code")
                    {
                        ToolTip = 'Specifies the value of the Billing County Code field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing County Code';
                    }
                    field("Billing County"; Rec."Billing County")
                    {
                        ToolTip = 'Specifies the value of the Billing County field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Visible = false;
                        Caption = 'Billing County';
                    }
                    field("Billing Country"; Rec."Billing Country")
                    {
                        ToolTip = 'Specifies the value of the Billing Country field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing Country';
                    }
                    field("Billing ISTAT Code"; Rec."Billing ISTAT Code")
                    {
                        ToolTip = 'Specifies the value of the Billing ISTAT Code field.';
                        ApplicationArea = All;
                        Editable = BilledEditable;
                        Caption = 'Billing ISTAT Code';
                    }
                }
                group("Communication Information")
                {
                    Visible = CommunicationVisible;
                    Caption = 'Communication Information';

                    field("Communication Toponym"; Rec."Communication Toponym")
                    {
                        ToolTip = 'Specifies the value of the Communication Toponym field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                        Caption = 'Communication Toponym';
                    }
                    field("AAT Communication CIV PUB"; Rec."AAT Communication CIV PUB")
                    {
                        ApplicationArea = All;
                        Caption = 'Communication CIV';
                        Editable = CommunicationEditable;
                        ToolTip = 'Specifies the value of the Communication CIV field.';
                    }
                    field("Communication Address"; Rec."Communication Address")
                    {
                        ToolTip = 'Specifies the value of the Communication Address field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                        Caption = 'Communication Address';
                    }
                    field("Communication Address 2"; Rec."Communication Address 2")
                    {
                        ToolTip = 'Specifies the value of the Communication Address 2 field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                        Caption = 'Communication Address 2';
                    }
                    field("Communication City"; Rec."Communication City")
                    {
                        Caption = 'Communication City';
                        ToolTip = 'Specifies the value of the Communication City field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                    }
                    field("Communication Post Code"; Rec."Communication Post Code")
                    {
                        Caption = 'Communication Post Code';
                        ToolTip = 'Specifies the value of the Communication Post Code field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                    }
                    field("Communication County Code"; Rec."Communication County Code")
                    {
                        Caption = 'Communication Code';
                        ToolTip = 'Specifies the value of the Communication County Code field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                    }
                    field("Communication County"; Rec."Communication County")
                    {
                        Caption = 'Communication County';
                        ToolTip = 'Specifies the value of the Communication County field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                        Visible = false;
                    }
                    field("Communication Country"; Rec."Communication Country")
                    {
                        Caption = 'Communication Country';
                        ToolTip = 'Specifies the value of the Communication Country field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                    }
                    field("Communication ISTAT Code"; Rec."Communication ISTAT Code")
                    {
                        Caption = 'Communication ISTAT Code';
                        ToolTip = 'Specifies the value of the Communication ISTAT Code field.';
                        ApplicationArea = All;
                        Editable = CommunicationEditable;
                    }
                }
            }
        }
        addafter("Billing / Communication")
        {
            group("Administrative Data")
            {
                Caption = 'Administrative Data';
                // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person ++
                Visible = not(Rec."Customer Type" = Rec."Customer Type"::person);

                // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person --
                field("Split Payment"; Rec."Split Payment")
                {
                    Tooltip = 'Specifies the value of the Split Payment field';
                    ApplicationArea = All;
                    Caption = 'Split Payment';
                }
                field(Society; Rec.Society)
                {
                    Tooltip = 'Specifies the value of the Society field';
                    ApplicationArea = All;
                    Caption = 'Society';
                }
            }
            group("Customer Group")
            {
                Caption = 'Customer Group';
                // AN 21112023 - TASK002140 - For the Person, it is Not Applicable. It is Applicable in the case of the Company ++
                Visible = not(Rec."Customer Type" = Rec."Customer Type"::person);

                // AN 21112023 - TASK002140 - For the Person, it is Not Applicable. It is Applicable in the case of the Company --
                part(CustomerGroup; "Customer Group")
                {
                    ApplicationArea = All;
                    SubPageLink = "Customer No."=field("No.");
                    Caption = 'Customer Group';
                }
            }
        }
    }
    actions
    {
        addafter(ApplyTemplate)
        {
            action("Export Anagraphic Data")
            {
                ToolTip = 'Export AE1.0050';
                Caption = '';
                ApplicationArea = All;
                Image = Export;

                trigger OnAction()
                var
                    Contract: Record Contract;
                    ChangeOfAnagraphicDataMgt: Codeunit "Change of Anagraphic Data Mgt.";
                    Text001Lbl: Label 'Currently there is no Contract available for Customer No.:- %1.', Comment = '%1 = "No."';
                    FileName: Text;
                begin
                    FileName:='';
                    Contract.SetRange("Customer No.", Rec."No.");
                    if Contract.FindLast()then ChangeOfAnagraphicDataMgt.NewChangeOfAnagraphicData(Contract, FileName)
                    else
                        Message(Text001Lbl, Rec."No.");
                end;
            }
        }
        addfirst(Category_Category4)
        {
            actionref("Export Anagraphic Data_Promoted"; "Export Anagraphic Data")
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateAddressInfo();
    end;
    trigger OnAfterGetRecord()
    var
    begin
        UpdateAddressInfo();
        if rec."Customer Type" = Rec."Customer Type"::Person then rec."Individual Person":=true;
        UpdatePageBasedOnCustomerType()end;
    // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person ++ 
    local procedure UpdatePageBasedOnCustomerType()
    begin
        case Rec."Customer Type" of Rec."Customer Type"::" ": begin
            PersonVisibility:=false;
            TaxRepresentationVisibility:=True;
        end;
        Rec."Customer Type"::Person: begin
            PersonVisibility:=false;
            TaxRepresentationVisibility:=True;
        end;
        // AN 21112023 - TASK002140 - Changes in field property based on Customer Type person --
        // AN 21112023 - TASK002140 - Changes in field property based on Customer Type Company ++ 
        Rec."Customer Type"::Company: begin
            PersonVisibility:=true;
            TaxRepresentationVisibility:=false;
        end;
        // AN 21112023 - TASK002140 - Changes in field property based on Customer Type Company --
        end;
        CurrPage.Update(false);
    end;
    local procedure UpdateAddressInfo()
    var
    begin
        case Rec."Address Preferences" of Rec."Address Preferences"::"Same as Legal (Default)": begin
            BilledEditable:=false;
            CommunicationEditable:=false;
            CommunicationVisible:=false;
        end;
        Rec."Address Preferences"::"Different Billing Address": begin
            BilledEditable:=true;
            CommunicationEditable:=false;
            CommunicationVisible:=false;
        end;
        Rec."Address Preferences"::"Both Different than Legal Address": begin
            BilledEditable:=true;
            CommunicationEditable:=true;
            CommunicationVisible:=true;
        end;
        Rec."Address Preferences"::"Different Communication Address": begin
            BilledEditable:=false;
            CommunicationEditable:=true;
            CommunicationVisible:=true;
        end;
        end;
    end;
    var BilledEditable: Boolean;
    CommunicationEditable: Boolean;
    CommunicationVisible: Boolean;
    EditCompany: Boolean;
    EditPerson: Boolean;
    PersonVisibility: Boolean;
    TaxRepresentationVisibility: Boolean;
}
