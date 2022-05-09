-- SMIHD-2686 - Analyze Survery Customer data

SELECT COUNT(ixCustomer), COUNT(distinct ixCustomer)
FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts]
-- 1547	1547

-- CHECK current Cust Type
SELECT SC.ixCustomer, C.ixCustomerType
,C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts] SC
    JOIN tblCustomer C on SC.ixCustomer = C.ixCustomer
order by C.ixCustomerType
,C.dtDateLastSOPUpdate, C.ixTimeLastSOPUpdate
--   


-- PER Brandon, remove the customers that are currently ixCustomerType = 1
SELECT SC.*
-- DELETE 
FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts]
   WHERE ixCustomer in (select ixCustomer from tblCustomer WHERE ixCustomerType = '1' )



-- Table showing Qty of gift received by cust and SKU
SELECT ixCustomer, ixSKU, COUNT(*) 'QTY'
--into [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received]
from tblOrderLine
where ixSKU in ('SRGIFTSURVEY','RACEGIFTSURVEY')
    and flgLineStatus = 'Shipped'
group by ixCustomer, ixSKU
order by COUNT(*) desc, ixCustomer





SELECT * FROM  [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received]
WHERE ixSKU = 'RACEGIFTSURVEY'

SELECT * FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts]


RACEGIFTSURVEY_Qty	SRGIFTSURVEY_Qty


update SC 
set RACEGIFTSURVEY_Qty = R.QTY
from [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts] SC
 join [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received] R on SC.ixCustomer = R.ixCustomer
where R.ixSKU = 'RACEGIFTSURVEY'


update SC 
set SRGIFTSURVEY_Qty = R.QTY
from [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts] SC
 join [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received] R on SC.ixCustomer = R.ixCustomer
where R.ixSKU = 'SRGIFTSURVEY'


 
SELECT * FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts] 
WHERE RACEGIFTSURVEY_Qty IS not null
OR  SRGIFTSURVEY_Qty IS not null


SELECT * FROM [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts]
ORDER BY RACEGIFTSURVEY_Qty DESC, SRGIFTSURVEY_Qty DESC, ixCustomer
 
/*** CLEAR THE FIELDS ***********/
 UPDATE PJC_SMIHD_2686_SurveyCusts
 SET RACEGIFTSURVEY_Qty = NULL
 
 SELECT * FROM PJC_SMIHD_2686_SurveyCusts
 WHERE RACEGIFTSURVEY_Qty IS not NULL
 
 
  UPDATE PJC_SMIHD_2686_SurveyCusts
 SET SRGIFTSURVEY_Qty = NULL
 
 SELECT * FROM PJC_SMIHD_2686_SurveyCusts
 WHERE SRGIFTSURVEY_Qty IS not NULL




update A 
set RACEGIFTSURVEY_Qty = B.QTY
from [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts]  A
 join [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received] B on A.ixCustomer = B.ixCustomer  AND B.ixSKU = 'RACEGIFTSURVEY'
 
 
 
 
 
 SELECT distinct ixCustomer from [SMITemp].dbo.[PJC_SMIHD_2686_SurveyCusts_Received]  where ixSKU = 'RACEGIFTSURVEY'
 and QTY is NOT NULL
 
update A 
set COLUMN = B.COLUMN,
   NEXTCOLUMN = B.NEXTCOLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX 