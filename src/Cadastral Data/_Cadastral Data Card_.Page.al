page 50205 "Cadastral Data Card"
{
    PageType = Card;
    SourceTable = "Cadastral Data";
    Caption = 'Cadastral Data Card';
    InsertAllowed = false; //KB14122023 - TASK002199 Disable Insert
    DeleteAllowed = false; //KB14122023 - TASK002199 Disable Delete

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Start Date"; CadastralData."Start Date")
                {
                    ToolTip = 'Specifies the value of the Start Date field.';
                    Editable = true;
                    Caption = 'Start Date';
                    ApplicationArea = All;
                }
                field("End Date"; CadastralData."End Date")
                {
                    ToolTip = 'Specifies the value of the End Date field.';
                    Editable = true;
                    Caption = 'End Date';
                    ApplicationArea = All;
                }
                field("Contract No."; CadastralData."Contract No.")
                {
                    ToolTip = 'Specifies the value of the Contract No. field.';
                    Caption = 'Contract No.';
                    ApplicationArea = All;
                }
                field("Municpality Comm. Date"; CadastralData."Municipality Comm. Date")
                {
                    ToolTip = 'Specifies the value of the Municpality Comm. Date field.';
                    Caption = 'Municipality Comm. Date';
                    ApplicationArea = All;
                }
                field("Property Type"; CadastralData."Property Type")
                {
                    ToolTip = 'Specifies the value of the Property Type field.';
                    Caption = 'Property Type';
                    ApplicationArea = All;
                }
                field("Concession Building"; CadastralData."Concession Building")
                {
                    ToolTip = 'Specifies the value of the Concession Building field.';
                    Caption = 'Concession Building';
                    ApplicationArea = All;
                }
                field("Cadastral Municipality Code"; CadastralData."Cadastral Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Cadastral Municipality Code field.';
                    Caption = 'Cadastral Municipality Code';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;
                }
                field("Admin. Municipality Code"; CadastralData."Admin. Municipality Code")
                {
                    ToolTip = 'Specifies the value of the Admin. Municipality Code field.';
                    Caption = 'Admin. Municipality Code';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;
                }
                field(Section; CadastralData.Section)
                {
                    ToolTip = 'Specifies the value of the Section field.';
                    Caption = 'Section';
                    ApplicationArea = All;
                }
                field(Sheet; CadastralData.Sheet)
                {
                    ToolTip = 'Specifies the value of the Sheet field.';
                    Caption = 'Sheet';
                    ApplicationArea = All;
                }
                field(Particle; CadastralData.Particle)
                {
                    ToolTip = 'Specifies the value of the Particle field.';
                    Caption = 'Particle';
                    ApplicationArea = All;
                }
                field("Particle Type"; CadastralData."Particle Type")
                {
                    Tooltip = 'Specifies the calue of the Particle field';
                    Caption = 'Particle Type';
                    ApplicationArea = All;
                }
                field("Particle Extension"; CadastralData."Partice Extension")
                {
                    ToolTip = 'Specifies the value of the Particle Extension field.';
                    Caption = 'Partice Extension';
                    ApplicationArea = All;
                }
                field(Subordinate; CadastralData.Subordinate)
                {
                    ToolTip = 'Specifies the value of the Subordinate field.';
                    Caption = 'Subordinate';
                    ApplicationArea = All;
                }
                field("Absense of Cadastral Data"; CadastralData."Absense of Cadastral Data")
                {
                    ToolTip = 'Specifies the value of the Absense of Cadastral Data field.';
                    Caption = 'Absense of Cadastral Data';
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                    begin
                        if CadastralData."Absense of Cadastral Data" then ReasonVisible:=true
                        else
                        begin
                            ReasonVisible:=false;
                            Clear(CadastralData."Reason for Absence");
                            CadastralData.Modify(true);
                        end;
                    end;
                }
                group("Reason for Absence Group")
                {
                    ShowCaption = false;
                    Visible = ReasonVisible;

                    field("Reason for Absence"; CadastralData."Reason for Absence")
                    {
                        Tooltip = 'Specifies the value of the Reason for Absence field';
                        Caption = 'Reason for Absence';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    actions
    {
    }
    trigger OnOpenPage()
    begin
        CadastralData.SetRange("Contract No.", Rec."Contract No.");
        if CadastralData.FindLast()then if CadastralData."Absense of Cadastral Data" = true then ReasonVisible:=true
            else
                ReasonVisible:=false;
        //KB14122023 - TASK002199 Disable Next and Previous Button +++
        Rec.FilterGroup(100);
        Rec.SetRange("No.", CadastralData."No.");
        Rec.FilterGroup(0);
    //KB14122023 - TASK002199 Disable Next and Previous Button ---
    end;
    trigger OnQueryClosePage(CloseAction: Action): Boolean var
        ConfirmMsg: Label 'Changes have been made to the record.\ \Do you want to save the changes?';
    begin
        if CadastralData."Start Date" = 0D then CadastralData."Start Date":=Today;
        CadastralData.ValidateCadastralData();
        CadastralData2.SetRange("Contract No.", Rec."Contract No.");
        if CadastralData2.FindLast()then if Rec."Start Date" = 0D then CadastralData2.Delete();
        if CadastralData2.FindLast()then begin
            if Format(CadastralData) <> Format(CadastralData2)then begin
                if Confirm(ConfirmMsg)then begin
                    CadastralData."Start Date":=Today;
                    CadastralData2."End Date":=Today - 1;
                    // CadastralData.Modify(true);
                    CadastralData2.Modify(true);
                    InsertNewCadastralData();
                    CadastralData.PopulateCadDataPeriod();
                end;
            end
            else
                exit;
        end
        else
        begin
            InsertNewCadastralData();
            CadastralData.PopulateCadDataPeriod();
        end;
    end;
    var CadastralData: Record "Cadastral Data";
    CadastralData2: Record "Cadastral Data";
    Contract: Record Contract;
    ReasonVisible: Boolean;
    /// <summary>
    /// SetContractNo.
    /// </summary>
    /// <param name="ContractNo">Code[25].</param>
    /// <param name="PODNo">Code[25].</param>
    procedure SetContractNo(ContractNo: Code[25]; PODNo: Code[25])
    begin
        Rec."Contract No.":=ContractNo;
        Rec."POD No.":=PODNo;
    end;
    local procedure InsertNewCadastralData()
    var
        CadData: Record "Cadastral Data";
    begin
        CadData.Copy(CadastralData);
        CadData."No.":=0;
        CadData.Insert(true);
        Contract.SetRange("No.", CadastralData."Contract No.");
        if not Contract.IsEmpty() and Contract.FindFirst()then begin
            Contract."Municipality Comm. Date":=CadData."Municipality Comm. Date";
            Contract."Property Type":=CadData."Property Type";
            Contract.Validate("Concession Building", CadData."Concession Building");
            Contract.Validate("Cadastral Municipality Code", CadData."Cadastral Municipality Code");
            Contract.Validate("Admin. Municipality Code", CadData."Admin. Municipality Code");
            Contract.Validate("Cadastral Data No.", CadData."No.");
            Contract.Validate(Section, CadData.Section);
            Contract.Validate(Sheet, CadData.Sheet);
            Contract.Validate(Particle, CadData.Particle);
            Contract.Validate("Particle Extension", CadData."Partice Extension");
            Contract.Validate(Subordinate, CadData.Subordinate);
            // Contract.Validate("POD No.",CadData."POD No.");
            Contract.Validate("Absense of Cadastral Data", CadData."Absense of Cadastral Data");
            Contract.Validate("Cadastral Data Start Date", CadData."Start Date");
            Contract.Validate("Cadastral Data End Date", CadData."End Date");
            Contract.Validate("Reason for Absence", CadData."Reason for Absence");
            Contract.Validate("Particle Type", CadData."Particle Type");
            Contract.Modify(true);
        end;
        CadastralData.Copy(CadData);
        CadastralData.Modify(true);
    end;
    //KB08012024 - Temporary data issue +++
    procedure GetCadestralData(): Record "Cadastral Data" begin
        exit(CadastralData);
    end;
//KB08012024 - Temporary data issue ---
}
