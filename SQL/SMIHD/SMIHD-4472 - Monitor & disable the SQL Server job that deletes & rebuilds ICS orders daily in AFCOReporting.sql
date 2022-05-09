-- SMIHD-4472 - Monitor & disable the SQL Server job that deletes & rebuilds ICS orders daily in AFCOReporting

-- SSA JOB "AFCO Bulk Upload"  has code the clears and repopulates records for the 4 tables below. It also appears to only take about 65 seconds to complete.


/**** BEFORE and AFTER final update *****/
-- RUN THIS AGAIN RIGHT BEFORE THE FINAL BATCH IS KICKED OFF TO MAKE SURE VALUES HAVE NOT CHANGED.
-- RUN A FINAL TIME AFTER THE BATCH FINISHES UPDATING

select CONVERT(VARCHAR, GETDATE(), 101) AS 'AsOf    ', count(*) 'RecCnt', SUM(mMerchandise) 'Merch', SUM(mMerchandiseCost) 'MerchCost' 
from tblOrder where ixCustomer in (26101,26103)
/*
AsOf    	RecCnt	Merch	        MerchCost
05/13/2016	81,513	6,587,249.59	3,838,211.86
05/16/2016	81,513	6,587,249.59	3,838,211.86
05/23/2016	81,528	6,829,079.03	3,964,616.57
05/23/2016	81,513	6,587,249.59	3,838,211.86 -- AFTER CONNIE kicked off SOP job & I ran the SSA job
05/23/2016	81,526	6,828,527.02	3,964,339.815 -- AFTER I REFED 15 SMI orders that weren't in ICS file
*/

select CONVERT(VARCHAR, GETDATE(), 101) AS 'AsOf    ', count(*) 'RecCnt', SUM(iQuantity) 'Qty', SUM(mExtendedPrice) 'ExtPrice', SUM(mExtendedCost) 'ExtCost' 
from tblOrderLine where ixCustomer in (26101,26103) and ixTimeLastSOPUpdate >= 39600

/*
AsOf    	RecCnt	Qty	    ExtPrice	    ExtCost
05/13/2016	105,936	156,886	6,587,249.59	3,838,211.86
05/16/2016	105,936	156,886	6,587,249.59	3,838,211.86
05/23/2016	107,168	162,671	6,829,079.021	3,964,616.573
05/23/2016	105,936	156,886	6,587,249.59	3,838,211.86 -- AFTER CONNIE kicked off SOP job
05/23/2016	107,153	162,642	6,828,527.011	3,964,339.815 -- AFTER I REFED 15 SMI orders that weren't in ICS file
                                                        We were unable to account for the small discrepancy.  We decided to go ahead and disable the jobs permanently.

*/

SELECT * from tblOrderLine
where ixCustomer in (26101,26103) 
and ixOrderDate > 17640
order by dtOrderDate desc

select CONVERT(VARCHAR, GETDATE(), 101) AS 'AsOf    ', count(*) 'RecCnt', SUM(mMerchandise) 'Merch', SUM(mMerchandiseCost) 'MerchCost' 
from tblCreditMemoMaster where ixOrder in 
        (select ixOrder from tblOrder where ixCustomer in (26101,26103)) -- 2,697
/*
AsOf    	RecCnt	Merch	    MerchCost
05/13/2016	2,697	276,073.56	162,529.13
05/16/2016	2,697	276,073.56	162,529.13
05/23/2016	2,697	276,073.56	162,529.13
*/


select  CONVERT(VARCHAR, GETDATE(), 101) AS 'AsOf    ', count(*) 'RecCnt', SUM(mExtendedPrice) 'Merch', SUM(mExtendedCost) 'MerchCost' 
from tblCreditMemoDetail where ixCreditMemo in 
        (select ixCreditMemo from tblCreditMemoMaster where ixOrder in (select ixOrder from tblOrder where ixCustomer in (26101,26103))) -- 3,205
/*
AsOf    	RecCnt	Merch	    MerchCost
05/13/2016	3,205	276,073.56	162,529.13
05/16/2016	3,205	276,073.56	162,529.13
05/23/2016	3,205	276,073.56	162,529.13
*/


select dtDateLastSOPUpdate, COUNT(*)
FROM tblOrder
where ixCustomer in (26101,26103)
group by dtDateLastSOPUpdate
order by dtDateLastSOPUpdate desc

select MIN(ixTimeLastSOPUpdate), MAX(ixTimeLastSOPUpdate), MAX(ixTimeLastSOPUpdate)-MIN(ixTimeLastSOPUpdate) 'TotSec'
from tblOrder where ixCustomer in (26101,26103)
and dtDateLastSOPUpdate = 








