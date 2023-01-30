pageextension 50148 "Sales Order Email Ext " extends "Sales Order"
{
    actions
    {
        addafter(AttachAsPDF)
        {
            action("Send Email")
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Category11;
                Image = Email;
                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    SalesLine: Record "Sales Line";
                begin
                    SalesHeader.get(Rec."Document Type"::Order, Rec."No.");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    SalesLine.FindFirst();
                    SendMail(SalesHeader, SalesLine);

                end;
            }
        }
        addafter("Create Inventor&y Put-away/Pick")
        {
            action(Report1)
            {
                ApplicationArea = All;
                Caption = 'Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Sales: Record "Sales Header";
                begin
                    Sales.SetRange("Document Type", Rec."Document Type");
                    Sales.SetRange("No.", Rec."No.");
                    Report.Run(50112, true, true, Sales);
                end;
            }
        }
    }
    local procedure SendMail(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSend: Codeunit Email;
        BodyMessage: Text;
        LineNo: Text;
        Quantity: Text;
        Recipient: Text;
        UnitCost: Text;
        Total: Text;
        Text1: Text;
        TempBlob: Codeunit "Temp Blob";
        outStreamReport: OutStream;
        inStreamReport: InStream;
        RecRef: RecordRef;
        cnv64: Codeunit "Base64 Convert";
    begin
        Clear(BodyMessage);
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."No.");
        RecRef.GetTable(SalesHeader);
        BodyMessage := 'Dear <b>' + SalesHeader."Sell-to Customer Name" +
        ',</b><br><br>You have successfully placed Sales order No <b>' + SalesHeader."No." +
        '</b><br><br><table style="font-family: Arial, Helvetica, sans-serif;border-style:1px solid #00838F;width: 70%;">' +
        '<tr style="padding-top: 12px;padding-bottom: 12px;text-align: left;background-color: #00838F;color: white;">' +
        '<th>LineNo</th><th>Description</th><th>Quantity</th><th>Unit Price</th><th>Total</th></tr>';
        Recipient := SalesHeader."Sell-to E-Mail";
        repeat
            Clear(LineNo);
            Clear(Quantity);
            Clear(UnitCost);
            Clear(Total);
            LineNo := Format(SalesLine."Line No.");
            Quantity := Format(SalesLine.Quantity);
            UnitCost := Format(SalesLine."Unit Price");
            Total := Format(SalesLine.Amount);
            BodyMessage += '<tr style="background-color: #D9F0F2"><td>' + LineNo + '</td><td>' + SalesLine.Description + '</td><td>' + Quantity + '</td><td>' + UnitCost + '</td><td>' + Total + '</td></tr>';
        until SalesLine.Next() = 0;
        TempBlob.CreateOutStream(outStreamReport);
        if Report.SaveAs(Report::MyOrderConf, '', ReportFormat::Pdf, outStreamReport, RecRef) then begin
            TempBlob.CreateInStream(inStreamReport);
            Text1 := cnv64.ToBase64(inStreamReport, true);
            BodyMessage += '</table><br><br><b>Thank you & Regards</b><br>This is a System genarated Message';
            EmailMessage.Create(Recipient, 'Sales Order Confirmation ' + SalesHeader."No.", BodyMessage, true);
            EmailMessage.AddAttachment('My Order Confirmation.pdf', 'application/pdf', Text1);
            if EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then
                Message('Email Successfully Sent');
        end;




    end;

    var

}
