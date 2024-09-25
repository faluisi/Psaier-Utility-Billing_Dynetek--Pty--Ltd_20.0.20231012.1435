page 50218 "Contract Status Cue"
{
    Caption = 'ContractStatusCue';
    PageType = CardPart;
    SourceTable = "Contract & SII Cue Table";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            cuegroup("Contract Status")
            {
                Caption = 'Contract Statusses';

                field("Contract - Waiting for Upload"; Rec."Contract - Waiting for Upload")
                {
                    Tooltip = 'Specifies the value of the Contract - Waiting for Upload field';
                    Caption = 'Waiting for Upload';
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        Contract: Record Contract;
                    begin
                        Contract.SetRange("Process Status", Contract."Process Status"::"Awaiting Contract Upload");
                        Page.Run(Page::"Contract List", Contract);
                    end;
                }
                field("Activation Contracts"; Rec."Activation Contracts")
                {
                    ToolTip = 'Specifies the value of the Activation Contracts field.';
                    Caption = 'Activation Contracts';
                    ApplicationArea = All;
                }
                field("Change of Customer"; Rec."Change of Customer")
                {
                    ToolTip = 'Specifies the value of the Change of Customer field.';
                    Caption = 'Change of Customer';
                    ApplicationArea = All;
                }
                field("Switch In Contracts"; Rec."Switch In Contracts")
                {
                    ToolTip = 'Specifies the value of the Switch In Contracts field.';
                    Caption = 'Switch In Contracts';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        Rec.Reset();
        if not Rec.Get()then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
