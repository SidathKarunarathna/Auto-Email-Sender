report 50112 MyOrderConf
{
    Caption = 'My Order Confirmation';
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './layouts/MyOrderConf.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(BilltoAddress; "Bill-to Address")
            {
                IncludeCaption = true;
            }
            column(BilltoCustomerNo; "Bill-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(BilltoName; "Bill-to Name")
            {
                IncludeCaption = true;
            }
            column(BillPostCode; "Bill-to Post Code")
            {
                IncludeCaption = true;
            }
            column(BilltoCountryRegionCode; "Bill-to Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(No; "No.")
            {
                IncludeCaption = true;
            }
            column(TitleLbl; TitleLbl)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("no."), "Document Type" = field("Document Type");
                DataItemLinkReference = SalesHeader;

                column(No_; "No.")
                {
                    IncludeCaption = true;
                }
                column(Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
            }
        }
    }

    labels
    {
        TitleLabel = 'My Title';
    }
    var
        TitleLbl: Label 'My order Confirmation';
        PostingDate: Date;
}