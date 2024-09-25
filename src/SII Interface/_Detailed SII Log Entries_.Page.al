page 50230 "Detailed SII Log Entries"
{
    PageType = List;
    SourceTable = "Detailed SII Log Entries";
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Detailed SII Log Entries';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Group';

                field("Detailed Entry No."; Rec."Detailed Entry No.")
                {
                    ToolTip = 'Specifies the value of the Detailed Entry No. field.';
                    Editable = false;
                    Visible = false;
                    Caption = 'Detailed Entry No.';
                }
                field("Log Entry No."; Rec."Log Entry No.")
                {
                    ToolTip = 'Specifies the value of the Log Entry No. field.';
                    Visible = false;
                    Caption = 'Log Entry No.';
                }
                field("Contract No."; Rec."Contract No.")
                {
                    Tooltip = 'Specifies the value of the Contract No. Field';
                    Caption = 'Contract No.';
                }
                field("CP User"; Rec."CP User")
                {
                    Tooltip = 'Specifies the value of the CP User Field';
                    Caption = 'CP User';
                }
                field(Date; Rec.Date)
                {
                    ToolTip = 'Specifies the value of the Date field.';
                    Caption = 'Date';
                }
                field("File Type"; Rec."File Type")
                {
                    Tooltip = 'Specifies the value of the File Type field';
                    Caption = 'File Type';
                }
                field(Filename; Rec.Filename)
                {
                    ToolTip = 'Specifies the value of the Filename field.';
                    Caption = 'Filename';
                }
                field("Initial Upload Date"; Rec."Initial Upload Date")
                {
                    ToolTip = 'Specifies the value of the Initial Upload Date field.';
                    Caption = 'Initial Upload Date';
                }
                field("Action"; Rec.Action)
                {
                    ToolTip = 'Specifies the value of the Action field.';
                    Caption = 'Action';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Caption = 'Status';
                }
                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field.';
                    Caption = 'User';
                }
                field(Error; Rec.Error)
                {
                    ToolTip = 'Specifies the value of the Error field.';
                    Caption = 'Error';
                }
                field("Error Code"; Rec."Error Code")
                {
                    ToolTip = 'Specifies the value of the Error Code field.';
                    Caption = 'Error Code';
                }
                field(Message; Rec.Message)
                {
                    ToolTip = 'Specifies the value of the Message field.';
                    Caption = 'Message';
                }
            }
        }
    }
    actions
    {
        area(Reporting)
        {
            group(Cancel)
            {
                Caption = 'Cancel';

                action("Cancel Change of Customer Request")
                {
                    ToolTip = 'Specifies the Cancel Change of Customer Request Action';
                    Image = Cancel;
                    Visible = ChangeOfCustomerVisible;
                    Caption = 'Cancel Change of Customer Request';

                    trigger OnAction()
                    var
                        SIILogEntry: Record "SII Log Entries";
                        Contract: Record "Contract";
                        Customer: Record Customer;
                        ConfirmManagement: Codeunit "Confirm Management";
                        ChangeofCustomerManagement: Codeunit "Change of Customer Management";
                        MessageLbl: Label 'Are you sure you want to cancel the Change of Customer Request?', Locked = true;
                    begin
                        CurrPage.SetSelectionFilter(Rec);
                        SIILogEntry.SetRange("CP User", Rec."CP User");
                        SIILogEntry.SetRange(Type, SIILogEntry.Type::"Change of Customer");
                        if not SIILogEntry.IsEmpty() and SIILogEntry.FindFirst()then if ConfirmManagement.GetResponse(MessageLbl, false)then begin
                                Contract.SetRange("No.", SIILogEntry."Contract No.");
                                if not Contract.IsEmpty() and Contract.FindFirst()then if Customer.Get(Contract."Customer No.")then begin
                                        ChangeofCustomerManagement.CancelChangeofCustomerRequest(SIILogEntry, Contract, '');
                                        CurrPage.Update(true);
                                    end;
                            end;
                    end;
                }
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref("Cancel Change of Customer Request_Promoted"; "Cancel Change of Customer Request")
                {
                }
            }
        }
    }
    var UtilitySetup: Record "Utility Setup";
    ChangeOfCustomerVisible: Boolean;
    DevMode: Boolean;
    trigger OnOpenPage()
    var
        SIILogEntries: Record "SII Log Entries";
        DetailedSIILogEntries: Record "Detailed SII Log Entries";
    begin
        UtilitySetup.GetRecordOnce();
        CurrPage.SetSelectionFilter(DetailedSIILogEntries);
        if DetailedSIILogEntries.FindFirst()then begin
            SIILogEntries.SetRange("CP User", DetailedSIILogEntries."CP User");
            SIILogEntries.SetRange(Type, SIILogEntries.Type::"Change of Customer");
            if not SIILogEntries.IsEmpty()then ChangeOfCustomerVisible:=true;
        end;
        DevMode:=UtilitySetup."AAT Developer Mode PUB";
        CurrPage.Editable:=DevMode;
    end;
}
