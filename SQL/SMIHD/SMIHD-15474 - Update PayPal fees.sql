-- SMIHD-15474 - Update PayPal fees
select * into [SMIArchive].dbo.BU_tblOrderArchive_20191028 -- 6823813
FROM tblOrder

select * into [SMIArchive].dbo.BU_tblOrderLineArchive_20191028 -- 26341437
FROM tblOrderLine

-- DROP TABLE #TempFees
select ixOrder, dtOrderDate, mPaymentProcessingFee 'PPFBefore', mPaymentProcessingFee 'PPAfter', (mPaymentProcessingFee-mPaymentProcessingFee) 'Dif'
into #TempFees -- 7,464
from tblOrder
where dtOrderDate between '10/07/2019' and '10/27/2019'
and sMethodOfPayment in ('PP-AUCTION','PAYPAL')
and sOrderStatus = 'Shipped'

select * from #TempFees

select sum(PPFBefore) from #TempFees -- 25,007.74
select sum(PPAfter) from #TempFees -- 

update TF 
set PPAfter = O.mPaymentProcessingFee
from #TempFees TF
 join tblOrder O on TF.ixOrder = O.ixOrder  



UPDATE #TempFees
SET Dif = PPAfter - PPFBefore


