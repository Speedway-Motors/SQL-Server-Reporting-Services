-- SMIHD-22299 - update Payment Processing fee logic for PP-AUCTION and EBAYPAY MoPs

select sMethodOfPayment, 
    FORMAT(COUNT(ixOrder),'###,###') 'OrderCnt', 
    FORMAT(SUM(mPaymentProcessingFee), '$###,###.##') 'TotPmtProcFee' -- 23,599 orders
from tblOrder
where dtOrderDate >= '08/01/20'
    and sMethodOfPayment in ('PP-AUCTION','EBAYPAY')
group by sMethodOfPayment
/*  SMI
sMethodOfPayment	OrderCnt	TotPmtProcFee
EBAYPAY	            105,620	    $283,864.29
PP-AUCTION	          3,890	     $11,763.46


AFCO
sMethodOfPayment	OrderCnt	TotPmtProcFee
PP-AUCTION	        2,646	    $6,476.16
*/

SELECT *
from tblOrder
where dtOrderDate >= '06/01/21'
and sMethodOfPayment in ('PP-AUCTION','EBAYPAY')
--and mPaymentProcessingFee > 0



select * into 
[SMIArchive].dbo.BU_tblOrder_20210817
from tblOrder



select sMethodOfPayment, 
    FORMAT(COUNT(ixOrder),'###,###') 'OrderCnt', 
    FORMAT(SUM(mPaymentProcessingFee), '$###,###.##') 'TotPmtProcFee' -- 23,599 orders
from tblOrder
where dtOrderDate >= '08/01/20'
    and sMethodOfPayment in ('PP-AUCTION','EBAYPAY')
    and mPaymentProcessingFee <> 0
group by sMethodOfPayment

/*
sMethodOfPayment	OrderCnt	TotPmtProcFee
PP-AUCTION	        1,565	    $6,476.16
*/

select ixOrder, mPaymentProcessingFee
from tblOrder
where dtOrderDate >= '08/01/20'
    and sMethodOfPayment in ('PP-AUCTION','EBAYPAY')
    and mPaymentProcessingFee <> 0


-- REFED about 300 orders to verify the stored procedure updated correctly
-- then manually updated all of the remain records because there were too many to feed
BEGIN TRAN

UPDATE tblOrder
set mPaymentProcessingFee = 0
where dtOrderDate BETWEEN '04/01/20' AND '09/01/21'
    and sMethodOfPayment in ('PP-AUCTION','EBAYPAY')
    and mPaymentProcessingFee <> 0

ROLLBACK TRAN



/*
ixDate	Date
18994	01/01/2020
18629	01/01/2019
18264	01/01/2018
17899	01/01/2017
17533	01/01/2016
17168	01/01/2015
16803	01/01/2014
16438	01/01/2013
16072	01/01/2012
15707	01/01/2011
15342	01/01/2010
14977	01/01/2009
14611	01/01/2008
14246	01/01/2007
13881	01/01/2006
*/

SELECT sMethodOfPayment, SUM(mPaymentProcessingFee) 'TotPPFee', count(ixOrder) 'OrderCnt'
FROM tblOrder
WHERE ixShippedDate > 13881	--01/01/2020
    AND sOrderStatus = 'Shipped' 
 --  AND (mMerchandise+mShipping+mTax-mCredits) > 0 
GROUP BY  sMethodOfPayment
ORDER BY sMethodOfPayment