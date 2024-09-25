codeunit 60101 "Switch Out File Import"
{
    procedure ImportSwitchOutSE03200(Var CSVBuffer: Record "CSV Buffer"; FileName: Text; RowNo: Integer)
    Var
        VATManagerSetup: Record "VAT Manager Setup";
        SIILogEntryRec: Record "SII Log Entries";
        UtilitySetup: Record "Utility Setup";
        VATManagerNo: Code[50];
        VATManagerNoCheck: Code[50];
        ManagerVATNoErrorLbl: Label 'There is no VAT No. that corresponds with: %1', Locked = true;
        CompletedStatuErrorLbl: Label 'The Status for CP User No.: %1 is %2, Please Contact your administrator.', Locked = true;
    begin
        VATManagerNo:=GetText(RowNo, 4, CSVBuffer); //KB140224 - VAT Manager Setup added
        //KB140224 - VAT Manager Setup added +++
        UtilitySetup.Get();
        if VATManagerSetup.Get(CopyStr(GetText(RowNo, 6, CSVBuffer), 3, 3))then VATManagerNoCheck:=VATManagerSetup."VAT Manager No."
        else
            VATManagerNoCheck:=UtilitySetup."Default VAT Manager No.";
        if VATManagerNoCheck <> VATManagerNo then Error(ManagerVATNoErrorLbl, VATManagerNo);
        //KB140224 - VAT Manager Setup added ---
        // AN 07122023 - TASK002127 - Added Error for already Imported file. +++
        SIILogEntryRec.Reset();
        SIILogEntryRec.SetRange("POD No.", GetText(RowNo, 6, CSVBuffer));
        SIILogEntryRec.SetRange("CP User", GetText(RowNo, 5, CSVBuffer));
        if SIILogEntryRec.FindFirst()then if SIILogEntryRec.Status <> SIILogEntryRec.Status::Completed then begin
                UpdateSwitchOutFields(CSVBuffer, RowNo, SIILogEntryRec);
                SIILogEntryRec.Modify(true);
            end
            else
                Error(CompletedStatuErrorLbl, SIILogEntryRec."CP User", SIILogEntryRec.Status)
        // AN 07122023 - TASK002127 - Added Error for already Imported file. ---
        else
            ImportNewSwitchOutSE03200(CSVBuffer, RowNo);
    end;
    local procedure GetText(LineNo: Integer; FieldNo: Integer; TempCSVBuffer: Record "CSV Buffer"): Text Var
        Value: Text;
    begin
        TempCSVBuffer.Reset();
        if TempCSVBuffer.Get(LineNo, FieldNo)then if Evaluate(value, TempCSVBuffer.Value)then exit(Value)end;
    local procedure GetDate(LineNo: Integer; FieldNo: Integer; TempCSVBuffer: Record "CSV Buffer"): Date Var
        Value: Date;
    begin
        TempCSVBuffer.Reset();
        if TempCSVBuffer.Get(LineNo, FieldNo)then if Evaluate(value, TempCSVBuffer.Value)then exit(Value)end;
    local procedure ImportNewSwitchOutSE03200(var CSVBuffer: Record "CSV Buffer"; RowNo: Integer)
    var
        SIILogEntry_LRec: Record "SII Log Entries";
    begin
        SIILogEntry_LRec.Init();
        SIILogEntry_LRec.Type:=SIILogEntry_LRec.Type::"Switch Out";
        SIILogEntry_LRec.Validate("CP User", GetText(RowNo, 5, CSVBuffer));
        SIILogEntry_LRec.Validate("POD No.", GetText(RowNo, 6, CSVBuffer));
        UpdateSwitchOutFields(CSVBuffer, RowNo, SIILogEntry_LRec);
        SIILogEntry_LRec.Insert();
    end;
    local procedure UpdateSwitchOutFields(var CSVBuffer: Record "CSV Buffer"; RowNo: Integer; var SIILogEntry_LRec: Record "SII Log Entries")
    var
        contract_LRec: Record Contract;
        Customer_LRec: Record Customer;
        EconomicCondition_Rec: Record "Economic Condition";
    begin
        SIILogEntry_LRec.Validate("Effective Date", GetDate(RowNo, 7, CSVBuffer));
        SIILogEntry_LRec.Validate(Date, Today());
        SIILogEntry_LRec.Validate("Initial Upload", Today());
        contract_LRec.Reset();
        contract_LRec.SetRange("POD No.", GetText(RowNo, 6, CSVBuffer));
        contract_LRec.SetRange(Status, contract_LRec.Status::Open);
        if contract_LRec.FindFirst()then begin
            SIILogEntry_LRec.Validate("Contract No.", contract_LRec."No.");
            SIILogEntry_LRec.Validate("Customer Name", contract_LRec."Customer Name");
            contract_LRec.Validate("Switch Out Date", SIILogEntry_LRec."Effective Date");
            contract_LRec.Validate("Contract End Date", CalcDate('<-1D>', SIILogEntry_LRec."Effective Date"));
            contract_LRec.Validate("Deactivation Cause", contract_LRec."Deactivation Cause"::Switch);
            contract_LRec.Modify();
        end;
        // AN 07122023 TASK0021127 Added End Date as Contract End Date +++
        EconomicCondition_Rec.Reset();
        EconomicCondition_Rec.SetRange("Contract No.", contract_LRec."No.");
        EconomicCondition_Rec.SetRange("Tariff Option No.", contract_LRec."Tariff Option No.");
        EconomicCondition_Rec.SetRange("POD No.", contract_LRec."POD No.");
        if EconomicCondition_Rec.FindFirst()then begin
            EconomicCondition_Rec.Validate("End Date", contract_LRec."Contract End Date");
            EconomicCondition_Rec.Modify();
        end;
        // AN 07122023 TASK0021127 Added End Date as Contract End Date +++
        Customer_LRec.Reset();
        Customer_LRec.SetRange(Name, SIILogEntry_LRec."Customer Name");
        if Customer_LRec.FindFirst()then begin
            SIILogEntry_LRec.Validate("VAT Number", Customer_LRec."VAT Registration No.");
            SIILogEntry_LRec.Validate("Fiscal Code", Customer_LRec."Fiscal Code");
        end;
        SIILogEntry_LRec.Validate(Status, SIILogEntry_LRec.Status::Completed);
    end;
}
