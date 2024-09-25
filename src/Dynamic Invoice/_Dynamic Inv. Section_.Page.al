page 50204 "Dynamic Inv. Section"
{
    ApplicationArea = All;
    Caption = 'Dynamic Invoice Section';
    PageType = List;
    SourceTable = "Dynamic Inv. Section";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field';
                    Caption = 'No.';
                //Editable = false;
                }
                field("Section Caption"; Rec."Section Caption")
                {
                    ToolTip = 'Specifies the value of the Section Caption field';
                    Caption = 'Section Caption';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field';
                    Caption = 'Description';
                    Visible = false;
                }
                field("English Caption"; Rec."English Caption")
                {
                    ToolTip = 'Specifies the value of the English Caption field';
                    Caption = 'English Caption';
                }
                field("Italian Caption"; Rec."Italian Caption")
                {
                    ToolTip = 'Specifies the value of the Italian Caption field';
                    Caption = 'Italian Caption';
                    Visible = false;
                }
                field("German Caption"; Rec."German Caption")
                {
                    ToolTip = 'Specifies the value of the German Caption field';
                    Caption = 'German Caption';
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Update Sections")
            {
                Caption = 'Update Sections';
                Image = UpdateDescription;
                ToolTip = 'Executes the Update Sections action.';

                trigger OnAction()
                var
                    totalNewSections: Integer;
                begin
                    totalNewSections:=Rec.CreateSectionsIfNotExist();
                    if(totalNewSections > 0)then begin
                        CurrPage.Update(false);
                        CurrPage.Update();
                        Message(CreatedNewSectionsLbl, totalNewSections);
                    end;
                end;
            }
            action("clear Sections")
            {
                Caption = 'clear Sections';
                ToolTip = 'Executes the clear Sections action.';
                Image = ClearFilter;

                trigger OnAction()
                var
                    dynamicInvSection: Record "Dynamic Inv. Section";
                    dynInvCaptions: Record "Dynamic Inv. Caption";
                    ConfirmMsg: Label 'Delete All?';
                begin
                    if not confirm(ConfirmMsg)then Error('');
                    dynamicInvSection.DeleteAll();
                    dynInvCaptions.DeleteAll();
                    CurrPage.Update();
                end;
            }
        }
    }
    var CreatedNewSectionsLbl: Label 'Successfully added %1 new sections', Comment = 'Successfully added %1 new sections';
}
