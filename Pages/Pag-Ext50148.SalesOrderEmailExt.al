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
    }
    local procedure SendMail(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        EmailMessage: Codeunit "Email Message";
        EmailSend: Codeunit Email;
        BodyMessage: Text;
        AddBodyMessage: Text;
        LineNo: Text;
        Quantity: Text;
        Recipient: Text;
        UnitCost: Text;
        Total: Text;
    begin
        Clear(BodyMessage);
        Clear(AddBodyMessage);
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
        BodyMessage += '</table><br><br><b>Thank you & Regards</b><br>This is a System genarated Message';
        EmailMessage.Create(Recipient, 'Sales Order Confirmation ' + SalesHeader."No.", BodyMessage, true);
        if EmailSend.Send(EmailMessage, Enum::"Email Scenario"::Default) then
            Message('Email Successfully Sent');


    end;

    var

}
