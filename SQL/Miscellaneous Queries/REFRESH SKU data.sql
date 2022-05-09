

SELECT substring(DB_NAME(),1,4) AS 'DB    ', DF.sTableName,	
    FORMAT(Records,'###,###') 'RecCnt',	DaysOld, FORMAT(getdate(),'MM/dd/yy') 'As Of'
from vwDataFreshness DF
WHERE sTableName = 'tblSKU'
order by DaysOld
/*
DB    	Table	Records	DaysOld	As Of
======  ======= ======= ======= ========
SMI 	tblSKU	83,076	   <=1  01/31/22
SMI 	tblSKU	134,178	   2-7
SMI 	tblSKU	208,113	  8-30
SMI 	tblSKU	39,942	 31-180
SMI 	tblSKU	75,251	181 +

SMI 	tblSKU	43,999	   <=1  01/20/22
SMI 	tblSKU	122,064	   2-7
SMI 	tblSKU	149,982	  8-30
SMI 	tblSKU	58,215	 31-180
SMI 	tblSKU	165,219	181 +

SMI 	tblSKU	84,641	   <=1	08/09/21
SMI 	tblSKU	23,079	   2-7	
SMI 	tblSKU	25,020	  8-30	
SMI 	tblSKU	390,137	 31-180	

DB    	Table	Records	DaysOld	As Of
======  ======= ======= ======= ========
AFCO	tblSKU	67,112	   <=1	01/31/22
AFCO	tblSKU	12,357	   2-7	
*/

-- SMI refeeds apprx  1.85 rec/sec   1,100 SKU/10 mins      6,600/hr 
-- AFCO refeeds apprx 4.5 rec/sec   2,700 /10 minS     
SELECT top 6000 -- SMI refeeds approx 1k SKU/10 mins     16,200/hr  
    ixSKU, FORMAT(dtDateLastSOPUpdate, 'yyyy.MM.dd') 'LastSOPUpdate', ixTimeLastSOPUpdate -- 2021.03.24	65970  to  2021.03.25	45625
from tblSKU
WHERE flgDeletedFromSOP = 0
   -- and flgActive = 1
   -- and ixSKU NOT LIKE 'UP%'
   --and mPriceLevel1 > 0
ORDER BY dtDateLastSOPUpdate, ixTimeLastSOPUpdate


BEGIN TRAN

UPDATE tblSKU
SET flgDeletedFromSOP = 1, 
    flgActive = 0 
WHERE ixSKU in ('32-30100452','32-50-16.00T1')

ROLLBACK TRAN
