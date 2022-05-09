--  SMIHD-19000 - Purchase Specific Email Test List
/*      ver 20.43.1
*/
DECLARE @SKU varchar(30), @StartDate datetime,  @EndDate datetime
SELECT @SKU = '91064022', @StartDate = '04/04/2020',    @EndDate = '07/03/2020'

select DISTINCT OL.ixSKU, O.ixCustomer, TNG.sEmailAddress 'OrderEmail' --C.sEmailAddress 'CUSTemail', 
from tblOrder O
    Left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    Left join tblCreditMemoMaster CMM on CMM.ixOrder = O.ixOrder
    Left join tblCreditMemoDetail CMD on CMD.ixCreditMemo = CMM.ixCreditMemo and CMD.ixSKU = OL.ixSKU
    Left join tblCustomer C on O.ixCustomer = C.ixCustomer
    Left join tng.tblorder TNG on TNG.ixSopOrderNumber = O.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS
where O.dtOrderDate between @StartDate and @EndDate
    and O.ixBusinessUnit <> 109 -- exclude Marketplaces
    and OL.ixSKU in (@SKU)
    and OL.flgLineStatus in ('Shipped','Open') -- Dropshipped too?
    and CMD.ixSKU is NULL -- exclude returns
    and TNG.sEmailAddress NOT IN ('DECLINED','')
    and TNG.sEmailAddress is NOT NULL
--and C.sEmailAddress <> TNG.sEmailAddress COLLATE SQL_Latin1_General_CP1_CI_AS -- match 591 out of 675   88%
order by TNG.sEmailAddress


    select ixSopOrderNumber, dtShippedDate, sEmailAddress
    from tng.tblorder where ixSopOrderNumber = '2511868'

    select * from tblBusinessUnit
        

    JQGYD564QW4K41Z@MARKETPLACE.AMAZON.COM
5949554



select DISTINCT O.ixCustomer, C.dtAccountCreateDate, C.sEmailAddress 'CustEmail',  
 TNG.sEmailAddress 'OrderEmail', O.ixOrder, O.ixMasterOrderNumber, O.sOrderStatus, O.dtOrderDate, 
 BU.sBusinessUnit 'BusinesUnit'
from tblOrder O
    Left join tblCustomer C on O.ixCustomer = C.ixCustomer
    Left join tng.tblorder TNG on TNG.ixSopOrderNumber = O.ixOrder COLLATE SQL_Latin1_General_CP1_CI_AS
    left join tblBusinessUnit BU on BU.ixBusinessUnit = O.ixBusinessUnit
where C.flgDeletedFromSOP = 0
--and O.dtOrderDate > '04/04/2020'
and O.sOrderStatus = 'Shipped'
    and O.ixBusinessUnit <> 109
and (TNG.sEmailAddress like '%@MARKETPLACE%'
    OR C.sEmailAddress like '%@MARKETPLACE%')
order by O.ixCustomer, O.dtOrderDate


select * from tblCustomer
where ixCustomer = 29078

ixBU BU     sDescription
107	WEB	    Website
109	MKT	    Marketplaces
110	PHONE	CX Orders



select ixCustomer from tblOrder
where ixOrder = '9135775' -- 1609122

select * from tblOrderLine
where ixOrder = '9135775' -- 1609122


select * from tblMailingOptIn
where ixCustomer = 1609122

select * from tblCustomer
where ixCustomer = 1609122

select sMailingStatus, count(*)
from tblCustomer
where flgDeletedFromSOP = 0
group by sMailingStatus

select ixOrder, ixCustomer, sShipToEmailAddress
from tblOrder
where ixCustomer = 1609122  

select * 
from tblOrder
where sShipToEmailAddress is NOT NULL


select ixSKU, count(*)
FROM tblOrderLine
where mExtendedPrice > 0
and ixShippedDate > 19268
group by ixSKU
having count(*) > 100
order by count(*) desc
