page 50274 "Request Page for UTF Monthly"
{
    ApplicationArea = All;
    Caption = 'UTF Date Range';
    PageType = Card;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(StartPeriod; StartPeriod)
                {
                    ApplicationArea = all;
                    Caption = 'Start Period';
                    NotBlank = true;
                    ToolTip = 'Specifies the value of the start period field.';
                }
                field(EndPeriod; EndPeriod)
                {
                    ApplicationArea = all;
                    Caption = 'End Period';
                    ToolTip = 'Specifies the value of the end period field.';
                    NotBlank = true;
                }
            }
        }
    }
    procedure GetRange(var StartD: date; var EndD: Date)
    var
        ErrorLbl: Label 'Date should not be blank.';
    begin
        if(StartPeriod = 0D) or (EndPeriod = 0D)then Error(ErrorLbl);
        StartD:=StartPeriod;
        EndD:=EndPeriod;
    end;
    var StartPeriod: Date;
    EndPeriod: Date;
}
