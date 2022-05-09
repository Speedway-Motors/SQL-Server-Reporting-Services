-- SMIHD-23217 - Replace tblOrder mPaymentProcessingFee calcs with SOP values

/*
select ixOrder, mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrder
where ixOrder in ('10804974','10531176-1')

-- select top 10 * from tblOrder

-- select * from tblTime where ixTime = 44574 -- 12:22:54  

/*
ixOrder	    mPaymentProcessingFee	mMarketplaceSellingFee	dtDateLastSOPUpdate	ixTimeLastSOPUpdate
10531176-1	0.00	                0.00	                2021-11-17	44574
10804974	30.84	                30.84	                2021-11-17	44609
*/

select ixOrder, mPaymentProcessingFee, mMarketplaceSellingFee, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
from tblOrder
where ixOrder in ('923062')


-- DROP TABLE [SMIArchive].dbo.BU_tblOrder_PaymentProcessingFee_20211117

select ixOrder, mPaymentProcessingFee, mMarketplaceSellingFee
into [SMIArchive].dbo.BU_tblOrder_PaymentProcessingFee_20211117
from tblOrder -- 9,035,288

-- DROP TABLE [SMIArchive].dbo.BU_AFCO_tblOrder_PaymentProcessingFee_20211117
select ixOrder, mPaymentProcessingFee, mMarketplaceSellingFee
into [SMIArchive].dbo.BU_AFCO_tblOrder_PaymentProcessingFee_20211117
from [AFCOReporting].dbo.tblOrder -- 512,850

select sum (mPaymentProcessingFee) -- 31,269,712.1163
from tblOrder

select count(*) , sum (mPaymentProcessingFee) -- 934,124	3,421,009.6201
from tblOrder
where dtShippedDate >= '01/01/2021'

select sum (mPaymentProcessingFee) -- truncate TABLE [SMITemp].dbo.PJC_SMIHD23217_2021PaymentProcFees 
from [SMITemp].dbo.PJC_SMIHD23217_2021PaymentProcFees -- 3,350,769.63

select NEW.* 
--into #OrdersToUpdate
from [SMITemp].dbo.PJC_SMIHD23217_2021PaymentProcFees NEW
    left join tblOrder O on NEW.ixOrder = O.ixOrder
where NEW.mPaymentProcessingFee <> O.mPaymentProcessingFee
order by NEW.mPaymentProcessingFee desc

select * from tblOrder
where mPaymentProcessingFee < 0


BEGIN TRAN 

set rowcount 50000 -- 600K
UPDATE O
SET mPaymentProcessingFee = NEW.mPaymentProcessingFee
from tblOrder O
    join #OrdersToUpdate NEW on O.ixOrder = NEW.ixOrder
where O.mPaymentProcessingFee <> NEW.mPaymentProcessingFee

ROLLBACK TRAN
*/




/************* CLEARING OUT OLDER mPaymentProcessingFee VALUES ***************/
/*

select  D.iYear, FORMAT(count(*),'###,###') 'PmtProcFeeOrders'
FROM tblOrder O
    left join tblDate D on O.ixShippedDate = D.ixDate
where mPaymentProcessingFee > 0
GROUP BY D.iYear
ORDER BY D.iYear
    /*      PmtProc         
    iYear	FeeOrders   NOW
    =====   =========   =======
    NULL	221         20
    2007	227,061     0
    2008	270,242     0
    2009	294,971     0
    2010	324,519     0
    2011	368,068     0
    2012	420,995     0
    2013	432,903     0
    2014	452,096     0
    2015	478,671     0
    2016	517,654     0
    2017	553,357     0
    2018	603,084     0
    2019	567,754     0
    2020	633,274     0
    2021	669,574
*/
/*
select  D.iYear, FORMAT(count(*),'###,###')
FROM tblOrder O
    left join tblDate D on O.ixShippedDate = D.ixDate
where mMarketplaceSellingFee > 0
GROUP BY D.iYear
ORDER BY D.iYear

            MPSelling
    iYear	FeeOrders
    =====   =========
    NULL	118
    2019	163,717
    2020	213,565
    2021	210,673

*/

SELECT ixOrder, mPaymentProcessingFee, sOrderStatus, dtShippedDate, ixShippedDate, dtOrderDate, dtDateLastSOPUpdate, mMerchandise, iShipMethod, sSourceCodeGiven
FROM tblOrder
where mPaymentProcessingFee > 0
AND dtShippedDate is NULL
order by dtOrderDate

SET ROWCOUNT 50000
*/



-- BEGIN TRAN
    UPDATE tblOrder
        SET mPaymentProcessingFee = 0
    -- SELECT FORMAT(count(*),'###,###') from tblOrder
    WHERE mPaymentProcessingFee > 0
        AND ixShippedDate < 19115 --	5/1/2020     
                                           
-- ROLLBACK TRAN
/*
ixDate	Date
19146	2020-06-01
19176	2020-07-01
19207	2020-08-01
19238	2020-09-01
19268	2020-10-01
19299	2020-11-01
19329	2020-12-01


*/
select * from tblDate 
where iYear = 2020
and iDayOfFiscalPeriod = 1



SELECT FORMAT(count(*),'###,###') from tblOrder
    WHERE mPaymentProcessingFee > 0
        AND ixShippedDate < 14977--	01/01/2009

