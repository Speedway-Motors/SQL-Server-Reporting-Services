-- SMIHD-15194 Populate new fields in tblOrder
-- DROP TABLE PJC_SMIHD15194_PopulateTblOrder
SELECT ixOrder, ixOptimalShipLocation, ixMasterOrderNumber, flgSplitOrder, flgBackorder -- 6,773,666
into PJC_SMIHD15194_PopulateTblOrder
from [SMI Reporting].dbo.tblOrder



SELECT * FROM PJC_SMIHD15194_PopulateTblOrder

/**************   ixOptimalShipLocation  ***************

    UPDATE PJC_SMIHD15194_PopulateTblOrder
        set ixOptimalShipLocation = 99
        where ixOrder NOT LIKE 'PC%'
            and ixOrder NOT LIKE 'Q%'

SELECT ixOptimalShipLocation, FORMAT(count(*),'###,###') OrderCnt
FROM PJC_SMIHD15194_PopulateTblOrder
GROUP BY ixOptimalShipLocation

ixOptimal
ShipLocation	OrderCnt
============    =========
NULL	          349,745
99	            6,423,928

SELECT * FROM PJC_SMIHD15194_PopulateTblOrder
WHERE ixOptimalShipLocation IS null
and ixOrder NOT LIKE 'PC%'
            and ixOrder NOT LIKE 'Q%'
-- no rows

SELECT ixOptimalShipLocation, FORMAT(count(*),'###,###') OrderCnt
FROM PJC_SMIHD15194_PopulateTblOrder
WHERE ixOrder LIKE 'PC%'
    OR ixOrder  LIKE 'Q%'
GROUP BY ixOptimalShipLocation

    ixOptimal
    ShipLocation	OrderCnt
    ============    =========
    NULL	        349,745

********************************************************/
/****************   flgBackorder  ***********************

    UPDATE PJC_SMIHD15194_PopulateTblOrder
        set flgBackorder = 1
        where ixOrder NOT LIKE 'PC%'
            and ixOrder NOT LIKE 'Q%'
            and ixOrder LIKE '%-%'


    UPDATE PJC_SMIHD15194_PopulateTblOrder
        set flgBackorder = 0
        where flgBackorder is NULL

SELECT flgBackorder, FORMAT(count(*),'###,###') OrderCnt
FROM PJC_SMIHD15194_PopulateTblOrder
GROUP BY flgBackorder

    flgBack
    order	OrderCnt
    ======= ========
    0	    6,576,440
    1	    197,233

SELECT flgBackorder, FORMAT(count(*),'###,###') OrderCnt
FROM PJC_SMIHD15194_PopulateTblOrder
WHERE ixOrder LIKE '%-%'
GROUP BY flgBackorder

    flgBack
    order	OrderCnt
    ======= ========
    1	    197,233

********************************************************/
/****************   flgSplitOrder  ***********************

    UPDATE PJC_SMIHD15194_PopulateTblOrder
        set flgSplitOrder = 0

SELECT flgSplitOrder, FORMAT(count(*),'###,###') OrderCnt
FROM PJC_SMIHD15194_PopulateTblOrder
GROUP BY flgSplitOrder

    flgBack
    order	OrderCnt
    ======= ========
    0	    6,773,673



********************************************************/
/*************   ixMasterOrderNumber  *******************

    UPDATE PJC_SMIHD15194_PopulateTblOrder
        set ixMasterOrderNumber = ixOrder
        where ixOrder NOT LIKE '%-%'

    UPDATE PJC_SMIHD15194_PopulateTblOrder
        SET ixMasterOrderNumber = SUBSTRING(ixOrder,0,CHARINDEX ('-',ixOrder))
        where ixOrder LIKE '%-%'

SELECT min(len(ixOrder)), max(len(ixOrder))
FROM PJC_SMIHD15194_PopulateTblOrder
where ixMasterOrderNumber is NULL
--    8-10


SELECT ixOrder, ixMasterOrderNumber
FROM PJC_SMIHD15194_PopulateTblOrder
 where ixOrder LIKE '%-%'
order by ixOrder

SELECT * FROM PJC_SMIHD15194_PopulateTblOrder
WHERE ixMasterOrderNumber is NULL

********************************************************/



select * from PJC_SMIHD15194_PopulateTblOrder
where ixOrder NOT LIKE 'PC%'
and ixOrder NOT LIKE 'Q%'
order by ixOrder






select * from PJC_SMIHD15194_PopulateTblOrder
where ixOrder NOT LIKE 'PC%'
and ixOrder NOT LIKE 'Q%'
order by ixOrder



select top 500 *
from PJC_SMIHD15194_PopulateTblOrder
order by newid()




-- TEST REFEEDING OLDER ORDERS
SELECT T.ixOrder, T.ixOptimalShipLocation, T.ixMasterOrderNumber, T.flgSplitOrder, T.flgBackorder,
    O.ixOrder, O.ixOptimalShipLocation, O.ixMasterOrderNumber, O.flgSplitOrder, O.flgBackorder, O.dtDateLastSOPUpdate -- 6,773,666
from [SMI Reporting].dbo.tblOrder O
LEFT JOIN PJC_SMIHD15194_PopulateTblOrder T on O.ixOrder = T.ixOrder
where O.ixOrder IN ('8999646','8900646-1','Q1923129','PC132808')
-- RECORDS RE-FED from SOP updated with the correct values.   
-- Logic to assign the ixOptimalShipLocation will be assigned at a later date.



select * from tblOrder
where ixPrimaryShipLocation = 47
and dtOrderDate > = '09/21/2019'

select sOptimalShipOrigination, count(*)
from tblOrder
group by sOptimalShipOrigination


SELECT * FROM tblOrder
where dtOrderDate = '04/01/2019' -- 3,762
and ixMasterOrderNumber is NOT NULL -- 7

BEGIN TRAN

        UPDATE O
        set ixMasterOrderNumber = T.ixMasterOrderNumber,
            flgSplitOrder = T.flgSplitOrder,
            flgBackorder = T.flgBackorder
        from [SMI Reporting].dbo.tblOrder O
         join [SMITemp].dbo.PJC_SMIHD15194_PopulateTblOrder T on O.ixOrder = T.ixOrder
        where O.ixMasterOrderNumber is NULL
        and O.dtOrderDate BETWEEN '01/01/2006' AND '12/31/2019' 

ROLLBACK TRAN
/*                      updates ~175k every 10 mins
In   
Queue	Table	    AsOf
======  ========    ===========
242,927	tblOrder	10.25 11:13

27	tblOrder	10.25 11:12

313,776	tblOrder	10.25 10:44             ETA 11:04

32,082	tblOrder	10.25 10:43 -- 350k 30 mins
381,720	tblOrder	10.25 10:23

57,433	tblOrder	10.25 10:23
157,248	tblOrder	10.25 10:17

29,362	tblOrder	10.24 17:28 <-- 300k <18 mins

*/

-- RUN in LNK-SQL-LIVE-1.[SMI Reporting]

select format(count(*),'###,###,###') as 'CntInQueue', r.sTableName, FORMAT(getdate(),'MM.dd HH:mm') 'AsOf'
from tblAwsQueueStage q (nolock) 
    inner join tblAwsQueueTypeReference r on q.ixAwsQueueTypeReference = r.ixAwsQueueTypeReference
--where r.ixAwsQueueTypeReference = 5  -- if you want to only look at a specific table
group by r.ixAwsQueueTypeReference, r.sTableName
   HAVING COUNT(*) > 10 -- more than X recoords in the queue    -- 9k@15:25
order by count(*) desc, sTableName

/*
ixAwsQueueTypeReference	CntInStagingQueue	sTableName	AsOf
5	141,480	tblOrder	2019.10.24 12:07







SELECT FORMAT(COUNT(ixMasterOrderNumber),'###,###') 'OrderCnt'
FROM tblOrder                                   -- 244,722 TARGET
WHERE ixMasterOrderNumber is NOT NULL
    and dtOrderDate BETWEEN  '08/01/2017' AND  '01/01/2018'          
    

SELECT ixInvoiceDate, ixOptimalShipLocation, count(*)
from tblOrder
where ixInvoiceDate is NOT NULL
and ixInvoiceDate= 18619 -- between 18600 and 18630
GROUP BY ixInvoiceDate,ixOptimalShipLocation
order by ixInvoiceDate

SELECT ixInvoiceDate, ixOptimalShipLocation, count(*)
from tblOrder
where ixInvoiceDate is NOT NULL
and ixInvoiceDate >= 18626 -- between 18600 and 18630
GROUP BY ixInvoiceDate,ixOptimalShipLocation
order by ixInvoiceDate

select distinct ixOrder
from tblOrder
where ixInvoiceDate is NOT NULL
 and ixOptimalShipLocation is NULL
and ixInvoiceDate between  18923 and 18924 -- between 18600 and 18630




select count(*) from [SMITemp].dbo.PJC_SMIHD15194_PopulateTblOrder -- 6,773,673
where ixOrderDate < '03/01/2016'

select top 10 * from [SMITemp].dbo.PJC_SMIHD15194_PopulateTblOrder



SELECT FORMAT(COUNT(ixMasterOrderNumber),'###,###') 'OrderCnt'
FROM tblOrder                                   -- 244,722 TARGET
WHERE flgSplitOrder  is NULL

SELECT flgSplitOrder, FORMAT(COUNT(ixOrder),'###,###') 'OrderCnt'
from tblOrder
group by flgSplitOrder

SELECT flgBackorder , FORMAT(COUNT(ixOrder),'###,###') 'OrderCnt'
from tblOrder
group by flgBackorder 

select * from tblSKU S
left join tblSKULocation SL on S.ixSKU = SL.ixSKU and SL.ixLocation = 99
where dtCreateDate >= '04/01/2019'
and SL.iQAV > 50
AND S.flgActive = 1
and S.ixSKU NOT LIKE 'UP%'
and S.ixSKU NOT LIKE 'AUP%'
AND S.mPriceLevel1 > 0
AND S.flgDeletedFromSOP = 0


