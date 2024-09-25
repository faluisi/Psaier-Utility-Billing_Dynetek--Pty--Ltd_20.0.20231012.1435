page 50215 "Meter Card"
{
    PageType = Card;
    SourceTable = Meter;
    Caption = 'Meter Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Serial No."; Rec."Serial No.")
                {
                    ToolTip = 'Specifies the value of the Serial No. field.';
                    Caption = 'Serial No.';
                    ApplicationArea = All;
                }
                // AN 09112023 TASK002140 Removed this fields from meter card ++
                field(Mark; Rec.Mark)
                {
                    ToolTip = 'Specifies the value of the Mark field.';
                    Caption = 'Mark';
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Model; Rec.Model)
                {
                    ToolTip = 'Specifies the value of the Model field.';
                    Caption = 'Model';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Production Year"; Rec."Production Year")
                {
                    ToolTip = 'Specifies the value of the Production Year field.';
                    Caption = 'Production Year';
                    ApplicationArea = All;
                    Visible = false;
                }
                // AN 09112023 TASK002140 Removed this fields from meter card --
                field("Number of Digits"; Rec."Number of Digits")
                {
                    ToolTip = 'Specifies the value of the Number of Digits field.';
                    Caption = 'Number of Digits';
                    ApplicationArea = All;
                }
            }
            group("Meter Parameters")
            {
                Caption = 'Meter Parameters';

                field("Reading Type"; Rec."Reading Type")
                {
                    ToolTip = 'Specifies the value of the Reading Type field.';
                    Caption = 'Reading Type';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AdjustReadingType();
                        AdjustReadingDetection();
                        CurrPage.Update();
                    end;
                }
                field("Reading Detection"; Rec."Reading Detection")
                {
                    ToolTip = 'Specifies the value of the Reading Detection field.';
                    Caption = 'Reading Detection';
                    ShowMandatory = true; //KB14122023 - TASK002199 Show Mandatory
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        AdjustReadingDetection();
                        AdjustReadingType();
                        CurrPage.Update();
                    end;
                }
                field("Energy Coeff"; Rec."Energy Coeff")
                {
                    ToolTip = 'Specifies the value of the Energy Coeff field.';
                    Caption = 'Energy Coeff';
                    ApplicationArea = All;
                }
                label(Label)
                {
                    Visible = F1;
                    Caption = 'Label';
                    ApplicationArea = All;
                }
            }
            group("Point of Deliveries")
            {
                Caption = 'Point of Deliveries';
            }
            group(Installation)
            {
                Caption = 'Installation';

                field("Installation Date"; Rec."Installation Date")
                {
                    ToolTip = 'Specifies the value of the Installation Date field.';
                    Visible = true;
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                group(InstallationMeasurementrs)
                {
                    ShowCaption = false;

                    group(InActive)
                    {
                        Caption = 'Active';
                        Visible = Active;

                        group(InActiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Installation F0 Active"; Rec."Installation F0 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F0 Active field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            //Visible = F0;
                            }
                        }
                        group(InActiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Installation F1 Active"; Rec."Installation F1 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F1 Active field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(InActiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Installation F2 Active"; Rec."Installation F2 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F2 Active field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(InActiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Installation F3 Active"; Rec."Installation F3 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F3 Active field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(InActiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Installation F4 Active"; Rec."Installation F4 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F4 Active field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(InActiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Installation F23 Active"; Rec."Installation F23 Active")
                            {
                                ToolTip = 'Specifies the value of the Installation F23 Active field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(InReactive)
                    {
                        Caption = 'Reactive';
                        Visible = Reactive;

                        group(InReactiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Installation F0 Reactive"; Rec."Installation F0 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Installation F0 Reactive field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(InReactiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Installation F1 Reactive"; Rec."Installation F1 Reactive")
                            {
                                ToolTip = 'Specifies the value of the installation F1 Reactive field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(InReactiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Installation F2 Reactive"; Rec."Installation F2 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Installation F2 Reactive field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(InReactiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Installation F3 Reactive"; Rec."Installation F3 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Installation F3 Reactive field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(InReactiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Installation F4 Reactive"; Rec."Installation F4 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Installation F4 Reactive field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(InReactiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Installation F23 Reactive"; Rec."Installation F23 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Installation F23 Reactive field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(InPeak)
                    {
                        Caption = 'Peak';
                        Visible = Peak;

                        group(InPeakF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Installation F0 Peak"; Rec."Installation F0 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F0 Peak field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(InPeakF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Installation F1 Peak"; Rec."Installation F1 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F1 Peak field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(InPeakF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Installation F2 Peak"; Rec."Installation F2 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F2 Peak field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(InPeakF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Installation F3 Peak"; Rec."Installation F3 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F3 Peak field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(InPeakF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Installation F4 Peak"; Rec."Installation F4 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F4 Peak field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(InPeakF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Installation F23 Peak"; Rec."Installation F23 Peak")
                            {
                                ToolTip = 'Specifies the value of the Installation F23 Peak field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                }
            }
            group(Uninstallation)
            {
                Caption = 'Uninstallation';

                field("Uninstallation Date"; Rec."Uninstallation Date")
                {
                    ToolTip = 'Specifies the value of the Uninstallation Date field.';
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                group(UninstallationMeasurements)
                {
                    ShowCaption = false;

                    group(UnActive)
                    {
                        Caption = 'Active';
                        Visible = Active;

                        group(UnActiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Uninstallation F0 Active"; Rec."Uninstallation F0 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F0  field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(UnActiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Uninstallation F1 Active"; Rec."Uninstallation F1 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F1 Active field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(UnActiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Uninstallation F2 Active"; Rec."Uninstallation F2 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F2 Active field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(UnActiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Uninstallation F3 Active"; Rec."Uninstallation F3 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F3 Active field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(UnActiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Uninstallation F4 Active"; Rec."Uninstallation F4 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F4 Active field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(UnActiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Uninstallation F23 Active"; Rec."Uninstallation F23 Active")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F23 Active field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(UnReactive)
                    {
                        Caption = 'Reactive';
                        Visible = Reactive;

                        group(UnReactiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Uninstallation F0 Reactive"; Rec."Uninstallation F0 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F0 Reactive field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(UnReactiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Uninstallation F1 Reactive"; Rec."Uninstallation F1 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F1 Reactive field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(UnReactiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Uninstallation F2 Reactive"; Rec."Uninstallation F2 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F2 Reactive field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(UnReactiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Uninstallation F3 Reactive"; Rec."Uninstallation F3 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F3 Reactive field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(UnReactiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Uninstallation F4 Reactive"; Rec."Uninstallation F4 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F4 Reactive field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(UnReactiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Uninstallation F23 Reactive"; Rec."Uninstallation F23 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F23 Reactive field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(UnPeak)
                    {
                        Caption = 'Peak';
                        Visible = Peak;

                        group(UnPeakF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Uninstallation F0 Peak"; Rec."Uninstallation F0 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F0 Peak field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(UnPeakF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Uninstallation F1 Peak"; Rec."Uninstallation F1 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F1 Peak field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(UnPeakF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Uninstallation F2 Peak"; Rec."Uninstallation F2 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F2 Peak field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(UnPeakF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Uninstallation F3 Peak"; Rec."Uninstallation F3 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F3 Peak field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(UnPeakF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Uninstallation F4 Peak"; Rec."Uninstallation F4 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F4 Peak field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(UnPeakF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Uninstallation F23 Peak"; Rec."Uninstallation F23 Peak")
                            {
                                ToolTip = 'Specifies the value of the Uninstallation F23 Peak field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                }
            }
            //KB07122023 - TASK002199 Deactivation Process Changes +++
            group(Deactivation)
            {
                Caption = 'Deactivation';

                field("Deactivation Date"; Rec."Deactivation Date")
                {
                    ToolTip = 'Specifies the value of the Deactivation Date field.';
                    Visible = true;
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                group(DeactivationMeasurementrs)
                {
                    ShowCaption = false;

                    group(DeactivationActive)
                    {
                        Caption = 'Active';
                        Visible = Active;

                        group(DeactivationActiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Deactivation F0 Active"; Rec."Deactivation F0 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F0 Active field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationActiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Deactivation F1 Active"; Rec."Deactivation F1 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F1 Active field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationActiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Deactivation F2 Active"; Rec."Deactivation F2 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F2 Active field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationActiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Deactivation F3 Active"; Rec."Deactivation F3 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F3 Active field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationActiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Deactivation F4 Active"; Rec."Deactivation F4 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F4 Active field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationActiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Deactivation F23 Active"; Rec."Deactivation F23 Active")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F23 Active field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(DeactivationReactive)
                    {
                        Caption = 'Reactive';
                        Visible = Reactive;

                        group(DeactivationReactiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Deactivation F0 Reactive"; Rec."Deactivation F0 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F0 Reactive field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationReactiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Deactivation F1 Reactive"; Rec."Deactivation F1 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F1 Reactive field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationReactiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Deactivation F2 Reactive"; Rec."Deactivation F2 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F2 Reactive field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationReactiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Deactivation F3 Reactive"; Rec."Deactivation F3 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F3 Reactive field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationReactiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Deactivation F4 Reactive"; Rec."Deactivation F4 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F4 Reactive field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationReactiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Deactivation F23 Reactive"; Rec."Deactivation F23 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F23 Reactive field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(DeactivationPeak)
                    {
                        Caption = 'Peak';
                        Visible = Peak;

                        group(DeactivationPeakF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Deactivation F0 Peak"; Rec."Deactivation F0 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F0 Peak field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationPeakF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Deactivation F1 Peak"; Rec."Deactivation F1 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F1 Peak field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationPeakF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Deactivation F2 Peak"; Rec."Deactivation F2 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F2 Peak field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationPeakF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Deactivation F3 Peak"; Rec."Deactivation F3 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F3 Peak field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationPeakF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Deactivation F4 Peak"; Rec."Deactivation F4 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F4 Peak field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(DeactivationPeakF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Deactivation F23 Peak"; Rec."Deactivation F23 Peak")
                            {
                                ToolTip = 'Specifies the value of the Deactivation F23 Peak field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                }
            }
            //KB07122023 - TASK002199 Deactivation Process Changes ---
            //KB07122023 - TASK002199 Reactivation Process Changes +++
            group(Reactivation)
            {
                Caption = 'Reactivation';

                field("Reactivation Date"; Rec."Reactivation Date")
                {
                    ToolTip = 'Specifies the value of the Reactivation Date field.';
                    Visible = true;
                    Caption = 'Date';
                    ApplicationArea = All;
                }
                group(ReactivationMeasurementrs)
                {
                    ShowCaption = false;

                    group(ReactivationActive)
                    {
                        Caption = 'Active';
                        Visible = Active;

                        group(ReactivationActiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Reactivation F0 Active"; Rec."Reactivation F0 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F0 Active field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationActiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Reactivation F1 Active"; Rec."Reactivation F1 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F1 Active field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationActiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Reactivation F2 Active"; Rec."Reactivation F2 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F2 Active field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationActiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Reactivation F3 Active"; Rec."Reactivation F3 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F3 Active field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationActiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Reactivation F4 Active"; Rec."Reactivation F4 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F4 Active field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationActiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Reactivation F23 Active"; Rec."Reactivation F23 Active")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F23 Active field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(ReactivationReactive)
                    {
                        Caption = 'Reactive';
                        Visible = Reactive;

                        group(ReactivationReactiveF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Reactivation F0 Reactive"; Rec."Reactivation F0 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F0 Reactive field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationReactiveF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Reactivation F1 Reactive"; Rec."Reactivation F1 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F1 Reactive field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationReactiveF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Reactivation F2 Reactive"; Rec."Reactivation F2 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F2 Reactive field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationReactiveF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Reactivation F3 Reactive"; Rec."Reactivation F3 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F3 Reactive field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationReactiveF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Reactivation F4 Reactive"; Rec."Reactivation F4 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F4 Reactive field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationReactiveF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Reactivation F23 Reactive"; Rec."Reactivation F23 Reactive")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F23 Reactive field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                    group(ReactivationPeak)
                    {
                        Caption = 'Peak';
                        Visible = Peak;

                        group(ReactivationPeakF0Grp)
                        {
                            ShowCaption = false;
                            Visible = F0;

                            field("Reactivation F0 Peak"; Rec."Reactivation F0 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F0 Peak field.';
                                Caption = 'F0';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationPeakF1Grp)
                        {
                            ShowCaption = false;
                            Visible = F1;

                            field("Reactivation F1 Peak"; Rec."Reactivation F1 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F1 Peak field.';
                                Caption = 'F1';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationPeakF2Grp)
                        {
                            ShowCaption = false;
                            Visible = F2;

                            field("Reactivation F2 Peak"; Rec."Reactivation F2 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F2 Peak field.';
                                Caption = 'F2';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationPeakF3Grp)
                        {
                            ShowCaption = false;
                            Visible = F3;

                            field("Reactivation F3 Peak"; Rec."Reactivation F3 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F3 Peak field.';
                                Caption = 'F3';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationPeakF4Grp)
                        {
                            ShowCaption = false;
                            Visible = F4;

                            field("Reactivation F4 Peak"; Rec."Reactivation F4 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F4 Peak field.';
                                Caption = 'F4';
                                ApplicationArea = All;
                            }
                        }
                        group(ReactivationPeakF23Grp)
                        {
                            ShowCaption = false;
                            Visible = F23;

                            field("Reactivation F23 Peak"; Rec."Reactivation F23 Peak")
                            {
                                ToolTip = 'Specifies the value of the Reactivation F23 Peak field.';
                                Caption = 'F23';
                                ApplicationArea = All;
                            }
                        }
                    }
                }
            }
        //KB07122023 - TASK002199 Reactivation Process Changes ---
        }
    }
    actions
    {
    }
    var Active: Boolean;
    Reactive: Boolean;
    Peak: Boolean;
    F0: Boolean;
    F1: Boolean;
    F2: Boolean;
    F3: Boolean;
    F4: Boolean;
    F23: Boolean;
    local procedure AdjustReadingDetection()
    var
    begin
        case Rec."Reading Detection" of Rec."Reading Detection"::Monorary: begin
            F0:=true;
            F1:=false;
            F2:=false;
            F3:=false;
            F4:=false;
            F23:=false;
        end;
        Rec."Reading Detection"::Bioraria: begin
            F0:=false;
            F1:=true;
            F2:=false;
            F3:=false;
            F4:=false;
            F23:=true;
        end;
        Rec."Reading Detection"::Phase: begin
            F0:=false;
            F1:=true;
            F2:=true;
            F3:=true;
            F4:=false;
            F23:=false;
        end;
        Rec."Reading Detection"::"Multi-Hour": begin
            F0:=false;
            F1:=true;
            F2:=true;
            F3:=true;
            F4:=true;
            F23:=false;
        end
        else
        begin
            F0:=true;
            F1:=true;
            F2:=true;
            F3:=true;
            F4:=true;
            F23:=true;
        end;
        end;
    end;
    local procedure AdjustReadingType()
    var
    begin
        case Rec."Reading Type" of Rec."Reading Type"::Active: begin
            Active:=true;
            Reactive:=false;
            Peak:=false;
        end;
        Rec."Reading Type"::"Active - Reactive": begin
            Active:=true;
            Reactive:=true;
            Peak:=false;
        end;
        Rec."Reading Type"::"Active - Peak": begin
            Active:=true;
            Peak:=true;
            Reactive:=false;
        end;
        Rec."Reading Type"::"Active - Reactive - Peak": begin
            Active:=true;
            Reactive:=true;
            Peak:=true;
        end;
        Rec."Reading Type"::"Consumption": begin
            Active:=true;
            Reactive:=true;
            Peak:=true;
        end
        else
        begin
            Active:=true;
            Reactive:=true;
            Peak:=true;
        end;
        end;
    end;
    trigger OnAfterGetCurrRecord()
    begin
        AdjustReadingType();
        AdjustReadingDetection();
        CurrPage.Update(false);
    end;
    trigger OnOpenPage()
    var
    begin
        AdjustReadingType();
        AdjustReadingDetection();
    end;
}
