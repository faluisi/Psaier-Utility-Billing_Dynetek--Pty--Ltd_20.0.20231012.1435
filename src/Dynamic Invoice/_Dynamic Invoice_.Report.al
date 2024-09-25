report 50201 "Dynamic Invoice"
{
    ApplicationArea = All;
    Caption = 'Dynamic Invoice';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "DynamicInvoice.rdl";
    UseRequestPage = true;
    EnableHyperlinks = true;

    dataset
    {
        dataitem(SalesInvoiceHeader; "Sales Invoice Header")
        {
        }
        dataitem(SalesHeader; "Sales Header")
        {
        }
        dataitem(DynamicInvoiceDataItem; "Dynamic Invoice DataItem")
        {
            column(PostingDate; "Posting Date")
            {
            }
            column(InvoiceNo; "No.")
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(Language_Code; GetLanguageCode())
            {
            }
            dataitem("Bill Sections"; "Dynamic Inv. Section")
            {
                column(Invoice_Detail_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Invoice Detail"))
                {
                }
                column(Personal_Data_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Personal Data"))
                {
                }
                column(Electricity_Supply_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Electricity Contract Supply"))
                {
                }
                column(Payment_Open_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Payment and Open"))
                {
                }
                column(Electricity_Bill_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Electricity Bill"))
                {
                }
                column(Invoice_Composition_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Invoice Composition"))
                {
                }
                column(Technical_Data_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Technical Data"))
                {
                }
                column(Excise_Tax_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Excise Tax"))
                {
                }
                column(VAT_Detail_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"VAT Detail"))
                {
                }
                column(Meter_Reading_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Meter Readings"))
                {
                }
                column(Consumption_Billed_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Consumption Billed"))
                {
                }
                column(Energy_Mix_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Energy Mix Composition"))
                {
                }
                column(Material_Expenses_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Material Expenses"))
                {
                }
                column(Managment_Expenses_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Management Expenses"))
                {
                }
                column(System_Charges_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"System Charges"))
                {
                }
                column(Taxes_Fees_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Taxes and Fees"))
                {
                }
                column(Total_Summary_Section_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Total Summary"))
                {
                }
                column(Useful_Information_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Useful Information"))
                {
                }
                column(Footer_Data_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Footer Data"))
                {
                }
                column(VAT_Caption; GetSectionCaption("Dynamic Invoice Sections"::VAT))
                {
                }
                column(Blind_Energy_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Blind Energy"))
                {
                }
                column(Social_Bonus_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Social Bonus"))
                {
                }
                column(Television_Fees_Caption; GetSectionCaption("Dynamic Invoice Sections"::"Television Fees"))
                {
                }
                dataitem("Company Information"; "Company Information")
                {
                    DataItemTableView = sorting("Primary Key");

                    column(Picture; Picture)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        "Company Information".CalcFields(Picture);
                    end;
                }
            }
            dataitem("Electricity Bill"; "Dynamic Inv. Content")
            {
                //DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Electricity Bill"));
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Electricity Bill"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Electricity Bill"));
                column(Electricity_Bill; "Section Code")
                {
                }
                column(Electricity_Bill_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Electricity_Bill_Column_2; "Column 1")
                {
                }
                column(Electricity_Bill_Column_3; "Column 2")
                {
                }
                column(Electricity_Bill_Column_4; "Column 3")
                {
                }
                column(Electricity_Bill_Column_5; "Column 4")
                {
                }
                column(Electricity_Bill_Column_6; "Column 5")
                {
                }
                column(Electricity_Bill_Column_7; "Column 6")
                {
                }
                column(Electricity_Bill_Column_8; "Column 7")
                {
                }
                column(Electricity_Bill_Column_9; "Column 8")
                {
                }
                column(Electricity_Bill_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Electricity Bill");
                // end;
            }
            dataitem("Payment and Open"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Payment and Open"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Payment and Open"));
                column(Payment_and_Open_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Payment_and_Open_Column_2; "Column 1")
                {
                }
                column(Payment_and_Open_Column_3; "Column 2")
                {
                }
                column(Payment_and_Open_Column_4; "Column 3")
                {
                }
                column(Payment_and_Open_Column_5; "Column 4")
                {
                }
                column(Payment_and_Open_Column_6; "Column 5")
                {
                }
                column(Payment_and_Open_Column_7; "Column 6")
                {
                }
                column(Payment_and_Open_Column_8; "Column 7")
                {
                }
                column(Payment_and_Open_Column_9; "Column 8")
                {
                }
                column(Payment_and_Open_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Payment and Open");
                // end;
            }
            dataitem("Invoice Composition"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Composition"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Composition"));
                column(Invoice_Composition_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Invoice_Composition_Column_2; "Column 1")
                {
                }
                column(Invoice_Composition_Column_3; "Column 2")
                {
                }
                column(Invoice_Composition_Column_4; "Column 3")
                {
                }
                column(Invoice_Composition_Column_5; "Column 4")
                {
                }
                column(Invoice_Composition_Column_6; "Column 5")
                {
                }
                column(Invoice_Composition_Column_7; "Column 6")
                {
                }
                column(Invoice_Composition_Column_8; "Column 7")
                {
                }
                column(Invoice_Composition_Column_9; "Column 8")
                {
                }
                column(Invoice_Composition_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Invoice Composition");
                // end;
            }
            dataitem("Technical Data"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Technical Data"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Technical Data"));
                column(Technical_Data_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Technical_Data_Column_2; "Column 1")
                {
                }
                column(Technical_Data_Column_3; "Column 2")
                {
                }
                column(Technical_Data_Column_4; "Column 3")
                {
                }
                column(Technical_Data_Column_5; "Column 4")
                {
                }
                column(Technical_Data_Column_6; "Column 5")
                {
                }
                column(Technical_Data_Column_7; "Column 6")
                {
                }
                column(Technical_Data_Column_8; "Column 7")
                {
                }
                column(Technical_Data_Column_9; "Column 8")
                {
                }
                column(Technical_Data_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Technical Data");
                // end;
            }
            dataitem("VAT Detail"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"VAT Detail"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"VAT Detail"));
                column(VAT_Detail_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(VAT_Detail_Column_2; "Column 1")
                {
                }
                column(VAT_Detail_Column_3; "Column 2")
                {
                }
                column(VAT_Detail_Column_4; "Column 3")
                {
                }
                column(VAT_Detail_Column_5; "Column 4")
                {
                }
                column(VAT_Detail_Column_6; "Column 5")
                {
                }
                column(VAT_Detail_Column_7; "Column 6")
                {
                }
                column(VAT_Detail_Column_8; "Column 7")
                {
                }
                column(VAT_Detail_Column_9; "Column 8")
                {
                }
                column(VAT_Detail_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"VAT Detail");
                // end;
            }
            dataitem("Excise Tax"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Excise Tax"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Excise Tax"));
                column(Excises_Tax_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Excises_Tax_Column_2; "Column 1")
                {
                }
                column(Excises_Tax_Column_3; "Column 2")
                {
                }
                column(Excises_Tax_Column_4; "Column 3")
                {
                }
                column(Excises_Tax_Column_5; "Column 4")
                {
                }
                column(Excises_Tax_Column_6; "Column 5")
                {
                }
                column(Excises_Tax_Column_7; "Column 6")
                {
                }
                column(Excises_Tax_Column_8; "Column 7")
                {
                }
                column(Excises_Tax_Column_9; "Column 8")
                {
                }
                column(Excises_Tax_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Excise Tax");
                // end;
            }
            dataitem("Meter Readings"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Meter Readings"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Meter Readings"));
                column(Meter_Readings_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Meter_Readings_Column_2; "Column 1")
                {
                }
                column(Meter_Readings_Column_3; "Column 2")
                {
                }
                column(Meter_Readings_Column_4; "Column 3")
                {
                }
                column(Meter_Readings_Column_5; "Column 4")
                {
                }
                column(Meter_Readings_Column_6; "Column 5")
                {
                }
                column(Meter_Readings_Column_7; "Column 6")
                {
                }
                column(Meter_Readings_Column_8; "Column 7")
                {
                }
                column(Meter_Readings_Column_9; "Column 8")
                {
                }
                column(Meter_Readings_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Meter Readings");
                // end;
            }
            dataitem("Consumption Billed"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Consumption Billed"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Consumption Billed"));
                column(Consumption_Billed_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Consumption_Billed_Column_2; "Column 1")
                {
                }
                column(Consumption_Billed_Column_3; "Column 2")
                {
                }
                column(Consumption_Billed_Column_4; "Column 3")
                {
                }
                column(Consumption_Billed_Column_5; "Column 4")
                {
                }
                column(Consumption_Billed_Column_6; "Column 5")
                {
                }
                column(Consumption_Billed_Column_7; "Column 6")
                {
                }
                column(Consumption_Billed_Column_8; "Column 7")
                {
                }
                column(Consumption_Billed_Column_9; "Column 8")
                {
                }
                column(Consumption_Billed_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Consumption Billed");
                // end;
            }
            dataitem("Energy Mix Composition"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Energy Mix Composition"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Energy Mix Composition"));
                column(Energy_Mix_Composition_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Energy_Mix_Composition_Column_2; "Column 1")
                {
                }
                column(Energy_Mix_Composition_Column_3; "Column 2")
                {
                }
                column(Energy_Mix_Composition_Column_4; "Column 3")
                {
                }
                column(Energy_Mix_Composition_Column_5; "Column 4")
                {
                }
                column(Energy_Mix_Composition_Column_6; "Column 5")
                {
                }
                column(Energy_Mix_Composition_Column_7; "Column 6")
                {
                }
                column(Energy_Mix_Composition_Column_8; "Column 7")
                {
                }
                column(Energy_Mix_Composition_Column_9; "Column 8")
                {
                }
                column(Energy_Mix_Composition_Bold; Bold)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Energy Mix Composition");
                // end;
            }
            dataitem("Material Expenses"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Material Expenses"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Material Expenses"));
                column(Material_Expenses_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Material_Expenses_Column_2; "Column 1")
                {
                }
                column(Material_Expenses_Column_3; "Column 2")
                {
                }
                column(Material_Expenses_Column_4; "Column 3")
                {
                }
                column(Material_Expenses_Column_5; "Column 4")
                {
                }
                column(Material_Expenses_Column_6; "Column 5")
                {
                }
                column(Material_Expenses_Column_7; "Column 6")
                {
                }
                column(Material_Expenses_Column_8; "Column 7")
                {
                }
                column(Material_Expenses_Column_9; "Column 8")
                {
                }
                column(Material_Expenses_Bold; Bold)
                {
                }
                column(Material_Expenses_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalMaterialExpFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalMaterialExp += DecimalValue;
                            MaterialExpCount += 1;
                        end;
                end;
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Material Expenses");
                // end;
            }
            dataitem("Management Expenses"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Management Expenses"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Management Expenses"));
                column(Management_Expenses_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Management_Expenses_Column_2; "Column 1")
                {
                }
                column(Management_Expenses_Column_3; "Column 2")
                {
                }
                column(Management_Expenses_Column_4; "Column 3")
                {
                }
                column(Management_Expenses_Column_5; "Column 4")
                {
                }
                column(Management_Expenses_Column_6; "Column 5")
                {
                }
                column(Management_Expenses_Column_7; "Column 6")
                {
                }
                column(Management_Expenses_Column_8; "Column 7")
                {
                }
                column(Management_Expenses_Column_9; "Column 8")
                {
                }
                column(Management_Expenses_Bold; Bold)
                {
                }
                column(Management_Expenses_Promoted; Promoted)
                {
                }
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Management Expenses");
                // end;
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalMgmtExpFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalMgmtExp += DecimalValue;
                            MgmtExpCount += 1;
                        end;
                end;
            }
            dataitem("System Charges"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"System Charges"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"System Charges"));
                column(System_Charges_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(System_Charges_Column_2; "Column 1")
                {
                }
                column(System_Charges_Column_3; "Column 2")
                {
                }
                column(System_Charges_Column_4; "Column 3")
                {
                }
                column(System_Charges_Column_5; "Column 4")
                {
                }
                column(System_Charges_Column_6; "Column 5")
                {
                }
                column(System_Charges_Column_7; "Column 6")
                {
                }
                column(System_Charges_Column_8; "Column 7")
                {
                }
                column(System_Charges_Column_9; "Column 8")
                {
                }
                column(System_Charges_Bold; Bold)
                {
                }
                column(System_Charges_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalSystemFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalSystemCharge += DecimalValue;
                            SystemChargeCount += 1;
                        end;
                end;
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"System Charges");
                // end;
            }
            dataitem("Taxes and Fees"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Taxes and Fees"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Taxes and Fees"));
                column(Taxes_and_Fees_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Taxes_and_Fees_Column_2; "Column 1")
                {
                }
                column(Taxes_and_Fees_Column_3; "Column 2")
                {
                }
                column(Taxes_and_Fees_Column_4; "Column 3")
                {
                }
                column(Taxes_and_Fees_Column_5; "Column 4")
                {
                }
                column(Taxes_and_Fees_Column_6; "Column 5")
                {
                }
                column(Taxes_and_Fees_Column_7; "Column 6")
                {
                }
                column(Taxes_and_Fees_Column_8; "Column 7")
                {
                }
                column(Taxes_and_Fees_Column_9; "Column 8")
                {
                }
                column(Taxes_and_Fees_Bold; Bold)
                {
                }
                column(Taxes_and_Fees_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalTaxesFeesFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalTaxesFees += DecimalValue;
                            TaxesFeesCount += 1;
                        end;
                end;
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::"Taxes and Fees");
                // end;
            }
            dataitem("VAT"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::VAT));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::VAT));
                column(VAT_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(VAT_Column_2; "Column 1")
                {
                }
                column(VAT_Column_3; "Column 2")
                {
                }
                column(VAT_Column_4; "Column 3")
                {
                }
                column(VAT_Column_5; "Column 4")
                {
                }
                column(VAT_Column_6; "Column 5")
                {
                }
                column(VAT_Column_7; "Column 6")
                {
                }
                column(VAT_Column_8; "Column 7")
                {
                }
                column(VAT_Column_9; "Column 8")
                {
                }
                column(VAT_Column_Bold; Bold)
                {
                }
                column(VAT_Column_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalVATFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalVAT += DecimalValue;
                            VATCount += 1;
                        end;
                end;
                // trigger OnPreDataItem()
                // begin
                //     SetRange("Section Code", "Dynamic Invoice Sections"::VAT);
                // end;
            }
            dataitem("Total Summary"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Total Summary"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Total Summary"));
                column(Total_Summary_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Total_Summary_2; "Column 1")
                {
                }
                column(Total_Summary_3; "Column 2")
                {
                }
                column(Total_Summary_4; "Column 3")
                {
                }
                column(Total_Summary_5; "Column 4")
                {
                }
                column(Total_Summary_6; "Column 5")
                {
                }
                column(Total_Summary_7; "Column 6")
                {
                }
                column(Total_Summary_8; "Column 7")
                {
                }
                column(Total_Summary_9; "Column 8")
                {
                }
                column(Total_Summary_Bold; Bold)
                {
                }
            }
            dataitem("Invoice Detail"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Detail"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Detail"));
                column(Invoice_Detail_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Invoice_Detail_2; "Column 1")
                {
                }
                column(Invoice_Detail_3; "Column 2")
                {
                }
                column(Invoice_Detail_4; "Column 3")
                {
                }
                column(Invoice_Detail_5; "Column 4")
                {
                }
                column(Invoice_Detail_6; "Column 5")
                {
                }
                column(Invoice_Detail_7; "Column 6")
                {
                }
                column(Invoice_Detail_8; "Column 7")
                {
                }
                column(Invoice_Detail_9; "Column 8")
                {
                }
                column(Invoice_Detail_Bold; Bold)
                {
                }
            }
            dataitem("Blind Energy"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Blind Energy"));

                // DataItemTableView = where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Detail"));
                column(Blind_Energy_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Blind_Energy_2; "Column 1")
                {
                }
                column(Blind_Energy_3; "Column 2")
                {
                }
                column(Blind_Energy_4; "Column 3")
                {
                }
                column(Blind_Energy_5; "Column 4")
                {
                }
                column(Blind_Energy_6; "Column 5")
                {
                }
                column(Blind_Energy_7; "Column 6")
                {
                }
                column(Blind_Energy_8; "Column 7")
                {
                }
                column(Blind_Energy_9; "Column 8")
                {
                }
                column(Blind_Energy_Bold; Bold)
                {
                }
                column(Blind_Energy_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalBlindEnergyFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalBlindEnergy += DecimalValue;
                            BlindEnergyCount += 1;
                        end;
                end;
            }
            dataitem("Personal Data"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Personal Data"));

                column(Personal_Data_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Personal_Data_2; "Column 1")
                {
                }
                column(Personal_Data_3; "Column 2")
                {
                }
                column(Personal_Data_4; "Column 3")
                {
                }
                column(Personal_Data_5; "Column 4")
                {
                }
                column(Personal_Data_6; "Column 5")
                {
                }
                column(Personal_Data_7; "Column 6")
                {
                }
                column(Personal_Data_8; "Column 7")
                {
                }
                column(Personal_Data_9; "Column 8")
                {
                }
                column(Promoted; Promoted)
                {
                }
                column(Personal_Data_Bold; Bold)
                {
                }
            }
            dataitem("Electricity Contract Supply"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Electricity Contract Supply"));

                column(Electricity_Contract_Supply_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Electricity_Contract_Supply_2; "Column 1")
                {
                }
                column(Electricity_Contract_Supply_3; "Column 2")
                {
                }
                column(Electricity_Contract_Supply_4; "Column 3")
                {
                }
                column(Electricity_Contract_Supply_5; "Column 4")
                {
                }
                column(Electricity_Contract_Supply_6; "Column 5")
                {
                }
                column(Electricity_Contract_Supply_7; "Column 6")
                {
                }
                column(Electricity_Contract_Supply_8; "Column 7")
                {
                }
                column(Electricity_Contract_Supply_9; "Column 8")
                {
                }
                column(Electricity_Contract_Supply_Bold; Bold)
                {
                }
            }
            dataitem("Social Bonus"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Social Bonus"));

                column(Social_Bonus_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Social_Bonus_2; "Column 1")
                {
                }
                column(Social_Bonus_3; "Column 2")
                {
                }
                column(Social_Bonus_4; "Column 3")
                {
                }
                column(Social_Bonus_5; "Column 4")
                {
                }
                column(Social_Bonus_6; "Column 5")
                {
                }
                column(Social_Bonus_7; "Column 6")
                {
                }
                column(Social_Bonus_8; "Column 7")
                {
                }
                column(Social_Bonus_9; "Column 8")
                {
                }
                column(Social_Bonus_Bold; Bold)
                {
                }
                column(Social_Bonus_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalSocialBonusFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalSocialBonus += DecimalValue;
                            SocialBonusCount += 1;
                        end;
                end;
            }
            dataitem("Television Fees"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Television Fees"));

                column(Television_Fees_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Television_Fees_2; "Column 1")
                {
                }
                column(Television_Fees_3; "Column 2")
                {
                }
                column(Television_Fees_4; "Column 3")
                {
                }
                column(Television_Fees_5; "Column 4")
                {
                }
                column(Television_Fees_6; "Column 5")
                {
                }
                column(Television_Fees_7; "Column 6")
                {
                }
                column(Television_Fees_8; "Column 7")
                {
                }
                column(Television_Fees_9; "Column 8")
                {
                }
                column(Television_Fees_Bold; Bold)
                {
                }
                column(Television_Fees_Promoted; Promoted)
                {
                }
                trigger OnAfterGetRecord()
                var
                    DecimalValue: Decimal;
                begin
                    if StrLen("Column 7") > 2 then
                        if Evaluate(DecimalValue, CopyStr("Column 7", 1, StrLen("Column 7") - 2)) then begin
                            TotalTelevisionFeesFormat := SelectStr(2, ConvertStr(DelChr("Column 7", '=', ','), ' ', ','));
                            TotalTelevisionFees += DecimalValue;
                            TelevisionFeesCount += 1;
                        end;
                end;
            }
            dataitem("Invoice Composition/Graph"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Invoice Composition Graph"));

                column(Invoice_Composition_Column_1_Graph; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Invoice_Composition_Column_2_Graph; FormatGraphData(RecordId))
                {
                }
                column(Invoice_Composition_Column_3_Graph; "Column 2")
                {
                }
                column(Invoice_Composition_Column_4_Graph; "Column 3")
                {
                }
                column(Invoice_Composition_Column_5_Graph; "Column 4")
                {
                }
                column(Invoice_Composition_Column_6_Graph; "Column 5")
                {
                }
                column(Invoice_Composition_Column_7_Graph; "Column 6")
                {
                }
                column(Invoice_Composition_Column_8_Graph; "Column 7")
                {
                }
                column(Invoice_Composition_Column_9_Graph; "Column 8")
                {
                }
            }
            dataitem("Energy Mix Composition/Graph"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Energy Mix Composition Graph"));

                column(Energy_Composition_Column_1_Graph; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Energy_Composition_Column_2_Graph; FormatGraphDataEnergyMix(RecordId))
                {
                }
                column(Energy_Composition_Column_3_Graph; "Column 2")
                {
                }
                column(Energy_Composition_Column_4_Graph; "Column 3")
                {
                }
                column(Energy_Composition_Column_5_Graph; "Column 4")
                {
                }
                column(Energy_Composition_Column_6_Graph; "Column 5")
                {
                }
                column(Energy_Composition_Column_7_Graph; "Column 6")
                {
                }
                column(Energy_Composition_Column_8_Graph; "Column 7")
                {
                }
                column(Energy_Composition_Column_9_Graph; "Column 8")
                {
                }
            }
            dataitem("Footer Data"; "Dynamic Inv. Content")
            {
                DataItemLink = "Invoice No." = field("No.");
                DataItemTableView = sorting("Invoice No.", "Section Code", "Line No.") where("Section Code" = const("Dynamic Invoice Sections"::"Footer Data"));

                column(Footer_Data_Column_1; GetRalatedCaption(Customer."Language Code"))
                {
                }
                column(Footer_Data_Column_2; "Column 1")
                {
                }
                column(Footer_Data_Column_3; "Column 2")
                {
                }
                column(Footer_Data_Column_4; "Column 3")
                {
                }
                column(Footer_Data_Column_5; "Column 4")
                {
                }
                column(Footer_Data_Column_6; "Column 5")
                {
                }
                column(Footer_Data_Column_7; "Column 6")
                {
                }
                column(Footer_Data_Column_8; "Column 7")
                {
                }
                column(Footer_Data_Column_9; "Column 8")
                {
                }
                column(Bold; Bold)
                {
                }
                trigger OnPreDataItem()
                begin
                    FooterCount := 0;
                end;

                trigger OnAfterGetRecord()
                begin
                    FooterCount += 1;
                    FooterData[FooterCount, 1] := "Column 1" + ' ' + "Column 2";
                    FooterData[FooterCount, 2] := "Column 3" + ' ' + "Column 4";
                    FooterData[FooterCount, 3] := "Column 5" + ' ' + "Column 6";
                end;
            }
            dataitem(Totals; Integer)
            {
                DataItemTableView = where(Number = const(1));

                column(MaterialExpCount; MaterialExpCount)
                {
                }
                column(MgmtExpCount; MgmtExpCount)
                {
                }
                column(SystemChargeCount; SystemChargeCount)
                {
                }
                column(TaxesFeesCount; TaxesFeesCount)
                {
                }
                column(VATCount; VATCount)
                {
                }
                column(BlindEnergyCount; BlindEnergyCount)
                {
                }
                column(SocialBonusCount; SocialBonusCount)
                {
                }
                column(TelevisionFeesCount; TelevisionFeesCount)
                {
                }
                column(TotalMaterialExp; StrSubstNo('%1 ' + TotalMaterialExpFormat, Format(TotalMaterialExp, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalMgmtExp; StrSubstNo('%1 ' + TotalMgmtExpFormat, Format(TotalMgmtExp, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalSystemCharge; StrSubstNo('%1 ' + TotalSystemFormat, Format(TotalSystemCharge, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalTaxesFees; StrSubstNo('%1 ' + TotalTaxesFeesFormat, Format(TotalTaxesFees, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalVAT; StrSubstNo('%1 ' + TotalVATFormat, Format(TotalVAT, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalBlindEnergy; StrSubstNo('%1 ' + TotalBlindEnergyFormat, Format(TotalBlindEnergy, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalSocialBonus; StrSubstNo('%1 ' + TotalSocialBonusFormat, Format(TotalSocialBonus, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(TotalTelevisionFees; StrSubstNo('%1 ' + TotalTelevisionFeesFormat, Format(TotalTelevisionFees, 0, '<Precision,2:6><Sign><Integer Thousand><Decimals>')))
                {
                }
                column(FooterData11; FooterData[1, 1])
                {
                }
                column(FooterData12; FooterData[1, 2])
                {
                }
                column(FooterData13; FooterData[1, 3])
                {
                }
                column(FooterData21; FooterData[2, 1])
                {
                }
                column(FooterData22; FooterData[2, 2])
                {
                }
                column(FooterData23; FooterData[2, 3])
                {
                }
                column(FooterData31; FooterData[3, 1])
                {
                }
                column(FooterData32; FooterData[3, 2])
                {
                }
                column(FooterData33; FooterData[3, 3])
                {
                }
            }
            trigger OnPreDataItem()
            var
                SalesInvoiceHeader2: Record "Sales Invoice Header";
            begin
                if (SalesHeader.GetFilters() <> '') then begin
                    SalesHeader2.CopyFilters(SalesHeader);
                    SalesHeader2.FindFirst();
                    DynamicInvoiceDataItem.DeleteAll();
                    DynamicInvoiceDataItem.Init();
                    DynamicInvoiceDataItem."No." := SalesHeader2."No.";
                    DynamicInvoiceDataItem."Document Type" := "Document Type"::Invoice;
                    DynamicInvoiceDataItem."Posting Date" := SalesHeader2."Posting Date";
                    DynamicInvoiceDataItem."Due Date" := SalesHeader2."Due Date";
                    DynamicInvoiceDataItem."Sell-to Customer No." := SalesHeader2."Sell-to Customer No.";
                    DynamicInvoiceDataItem.Insert();
                end;
                if (SalesInvoiceHeader.GetFilters() <> '') then begin
                    SalesInvoiceHeader2.CopyFilters(SalesInvoiceHeader);
                    SalesInvoiceHeader2.FindFirst();
                    DynamicInvoiceDataItem.DeleteAll();
                    DynamicInvoiceDataItem.Init();
                    DynamicInvoiceDataItem."No." := SalesInvoiceHeader2."Pre-Assigned No.";
                    //DynamicInvoiceDataItem."No." := SalesInvoiceHeader2."No."; *FA*240925
                    DynamicInvoiceDataItem."Document Type" := "Document Type"::Invoice;
                    DynamicInvoiceDataItem."Posting Date" := SalesInvoiceHeader2."Posting Date";
                    DynamicInvoiceDataItem."Due Date" := SalesInvoiceHeader2."Due Date";
                    DynamicInvoiceDataItem."Sell-to Customer No." := SalesInvoiceHeader2."Sell-to Customer No.";
                    DynamicInvoiceDataItem.Insert();
                end;
                Customer.Get(DynamicInvoiceDataItem."Sell-to Customer No.");
            end;
        }
    }
    rendering
    {
        layout("DynamicInvoice.rdl")
        {
            Type = RDLC;
            LayoutFile = '.\src\Dynamic Invoice\Report Layout\2023-05-06_Dynamic Invoice.rdl';
        }
    }
    trigger OnPreReport()
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ErrorLbl: Label 'Cannot generate the invoice from both Sales Invoice and Sales Orders.';
    begin
        if (SalesHeader.GetFilters() <> '') and (SalesInvoiceHeader.GetFilters() <> '') then Error(ErrorLbl);
    end;
    /// <summary>
    /// get Code ie ENG, DE based on "Windows Language ID"
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    local procedure GetLanguageCode(): Text
    var
        Language: Record Language;
    begin
        Language.Get(Customer."Language Code");
        case Language."Windows Language ID" of
            1040:
                exit('ITA');
            2064:
                exit('ITA');
            5127:
                exit('DE');
            3079:
                exit('DE');
            4103:
                exit('DE');
            1031:
                exit('DE');
            else
                exit('ENG');
        end;
    end;
    /// <summary>
    /// Return caption for the sections. From Sections list.
    /// </summary>
    /// <param name="CurrSection">Enum "Dynamic Invoice Sections".</param>
    /// <returns>Return value of type Text[100].</returns>
    local procedure GetSectionCaption(CurrSection: Enum "Dynamic Invoice Sections"): Text[100]
    var
        DynamicBillSections: Record "Dynamic Inv. Section";
        DynamicMultiLangCaption: Record "Dynamic Inv. Caption";
    begin
        DynamicBillSections.Get(CurrSection);
        // Allow Blank Captions
        if (DynamicBillSections."Section Caption" = 0) then exit(' ');
        DynamicMultiLangCaption.Get(DynamicBillSections."Section Caption");
        exit(CopyStr(DynamicMultiLangCaption.GetCaption(Customer."Language Code"), 1, 100));
    end;

    local procedure FormatGraphData(RecordID: RecordId): Decimal
    var
        DynamicInvContent: Record "Dynamic Inv. Content";
        DecimalValue: Decimal;
        ColumnValue: Text;
    begin
        DynamicInvContent.Get(RecordID);
        ColumnValue := DynamicInvContent."Column 1";
        Evaluate(DecimalValue, ColumnValue);
        exit(DecimalValue);
    end;

    local procedure FormatGraphDataEnergyMix(RecordID: RecordId): Decimal
    var
        DynamicInvContent: Record "Dynamic Inv. Content";
        DecimalValue: Decimal;
        ColumnValue: Text;
    begin
        DynamicInvContent.Get(RecordID);
        ColumnValue := DynamicInvContent."Column 3";
        Evaluate(DecimalValue, ColumnValue);
        exit(DecimalValue);
    end;

    var
        Customer: Record Customer;
        SalesHeader2: Record "Sales Header";
        TotalMaterialExpFormat: Text;
        TotalMaterialExp: Decimal;
        MaterialExpCount: Integer;
        TotalMgmtExpFormat: Text;
        TotalMgmtExp: Decimal;
        MgmtExpCount: Integer;
        TotalSystemFormat: Text;
        TotalSystemCharge: Decimal;
        SystemChargeCount: Integer;
        TotalTaxesFeesFormat: Text;
        TotalTaxesFees: Decimal;
        TaxesFeesCount: Integer;
        TotalVATFormat: Text;
        TotalVAT: Decimal;
        VATCount: Integer;
        TotalBlindEnergyFormat: Text;
        TotalBlindEnergy: Decimal;
        BlindEnergyCount: Integer;
        TotalSocialBonus: Decimal;
        SocialBonusCount: Integer;
        TotalSocialBonusFormat: Text;
        TotalTelevisionFees: Decimal;
        TelevisionFeesCount: Integer;
        TotalTelevisionFeesFormat: Text;
        FooterData: array[3, 3] of Text[500];
        FooterCount: Integer;
}
