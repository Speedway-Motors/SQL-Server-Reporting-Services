-- SOP Feeds to DW Speeds

-- <> 
    SELECT TOP 1
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM
    WHERE dtDateLastSOPUpdate = '04/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate

/*************************************************/

-- <2> Bins
    SELECT TOP 1 ixBin,  
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblBin
    WHERE dtDateLastSOPUpdate = '10/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixBin	LastSOP_UD	ixTimeLastSOPUpdate
    V16JC3	2019.10.01	24608
    */


-- <3> BOMs (templates)
    SELECT TOP 1 ixFinishedSKU,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblBOMTemplateMaster
    WHERE dtDateLastSOPUpdate = '10/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixFinishedSKU	LastSOP_UD	ixTimeLastSOPUpdate
    9708201.1	    2019.10.01	24608
    */

        SELECT TOP 1 ixFinishedSKU, ixSKU,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
        FROM tblBOMTemplateDetail
        WHERE ixFinishedSKU = '9708201.1'
        ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        /*
        ixFinishedSKU	ixSKU	    LastSOP_UD	ixTimeLastSOPUpdate
        9708201.1	    9708201.1.1	2019.10.01	24608
        */


-- <4> BOM Sequences   
    -- Currently ALL is only refeed option


-- <5> BOM Transfers
    SELECT TOP 1 ixTransferNumber,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblBOMTransferMaster
    WHERE dtDateLastSOPUpdate = '10/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixFinishedSKU	LastSOP_UD	ixTimeLastSOPUpdate
    118365-1	    2019.10.01	24607
    */

        SELECT TOP 1 ixTransferNumber, ixSKU,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
        FROM tblBOMTransferDetail
        WHERE ixTransferNumber = '118365-1'
        ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        /*
        ixFinishedSKU	ixSKU	    LastSOP_UD	ixTimeLastSOPUpdate
        118365-1	    M2T0.14A01Q	2019.10.01	246078
        */





<6>-<10>
Customer Offers

-- <6> Catalog Requests
    -- Currently ALL or <S>ource Code are the only refeed options
    SELECT TOP 1 ixSourceCode,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblCatalogRequest
    WHERE ixSourceCode = '41998'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate


-- <7> Credit Memos
    SELECT TOP 1 ixCreditMemo,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblCreditMemoMaster
    WHERE dtDateLastSOPUpdate = '04/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixCreditMemo	LastSOP_UD	ixTimeLastSOPUpdate
    C-118668	    2019.04.01	29746
    */

        SELECT ixCreditMemo, ixSKU,
            FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
        FROM tblCreditMemoDetail
        WHERE ixCreditMemo = 'C-118668'
        --ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        /*
        ixCreditMemo	ixSKU	    LastSOP_UD	ixTimeLastSOPUpdate
        C-118668	    91034212-12	2019.04.01	29746
        C-118668	    91672001	2019.04.01	29746
        */

-- <8> Customer
    SELECT TOP 1 ixCustomer, 
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblCustomer
    WHERE dtDateLastSOPUpdate = '04/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
        /*
        ixCustomer	LastSOP_UD	ixTimeLastSOPUpdate
        11670	    2019.04.01	85718
        */

-- <9> 
    SELECT TOP 1 ixCustomerOriginal, ixCustomerMergedTo,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblMergedCustomers
    WHERE dtDateLastSOPUpdate >= '10/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixCustomer  ixCustomer
    Original	MergedTo	LastSOP_UD	ixTimeLastSOPUpdate
    1450512	    1549115	    2019.10.03	44479
    */


-- <10> Customer Offers
    SELECT TOP 1 ixCustomerOffer, ixCustomer, ixSourceCode,
        FORMAT(dtDateLastSOPUpdate,'yyyy.MM.dd') 'LastSOP_UD', ixTimeLastSOPUpdate
    FROM tblCustomerOffer
    WHERE dtDateLastSOPUpdate >= '10/01/2019'
    ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate
    /*
    ixCustomer              ixSource
    Offer	    ixCustomer	Code	LastSOP_UD	ixTimeLastSOPUpdate
    37635753	3634324	    41998	2019.10.01	7610
    */





<11>-<15>
Dropships
Employees
Inventory Forecasts
Inventory Receipts
Job Clock

<16>-<20>
Kits
Mailing Opt IN
Orders
Packages
PGC

<21>-<25>
Promo Code Xref
Purchase Orders
Receivers
SKUs
SKU Transactions

<26>-<30>
Source Codes
Time Clock
Transaction Types
Vendors
Web Reject Reasons






SELECT ixInvoiceDate, * from tblOrder 
where ixBusinessUnit is NULL
    and dtOrderDate >= '01/01/2019'
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'
    and sOrderStatus NOT IN ('Cancelled','Open','Backordered')
    and ixOrder NOT L
    
    SELECT ixOrder, ixInvoiceDate, ixBusinessUnit, sOrderStatus, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, * from tblOrder 
where ixBusinessUnit is NULL
    and dtOrderDate >= '01/01/2019'
    and ixOrder NOT LIKE 'P%'
    and ixOrder NOT LIKE 'Q%'
    and sOrderStatus NOT IN ('Cancelled','Open','Backordered')
    and ixOrder in ('8086187','8087053','8047164-1','8055974-1','8000148','8003540')


SELECT ixOrder, ixInvoiceDate, ixBusinessUnit, sOrderStatus, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, * from tblOrder 
where ixBusinessUnit is NULL
and ixInvoiceDate is NOT NULL

SELECT ixCreditMemo, ixCreateDate, ixBusinessUnit, mMerchandiseReturnedCost, flgCounter, dtDateLastSOPUpdate, ixTimeLastSOPUpdate, ixOrder, flgCanceled 
from tblCreditMemoMaster 
where ixBusinessUnit is NULL -- 158,979
-- and ixCreditMemo in ('C-613342','C-613343','C-613344','C-613345','C-613346','C-613365','C-613366','C-613367','C-613368','C-613369')
order by ixCreateDate desc

-- 18917	10/16/2019

SELECT ixBusinessUnit, FORMAT(count(*),'###,###') CMCnt from tblCreditMemoMaster
where ixCreditMemo like 'F%'
    and ixCreateDate >= 18626--	12/29/2018
group by ixBusinessUnit

select * from tblBusinessUnit

select ixBusinessUnit, count(*)
from tblCreditMemoMaster
group by ixBusinessUnit
order by ixBusinessUnit

select ixBusinessUnit, count(*)
from tblOrder
group by ixBusinessUnit
order by ixBusinessUnit


SELECT ixBusinessUnit, count(*) from tblOrder
group by ixBusinessUnit

8086187
8087053
8047164-1
8055974-1
8000148
8003540