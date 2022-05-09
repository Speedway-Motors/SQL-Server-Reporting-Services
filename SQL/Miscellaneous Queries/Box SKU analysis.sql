-- Box SKU analysis

-- Slapper Box SKU analysis
-- SKUs are not formatted correctly!   
-- many contain extra - marks.  Waiting for Connie have have them go through the same filter as tblSKU.ixSKU
SELECT P.ixBoxSKU, 
    --S.ixSKU, 
    S.iLength, S.iWidth, S.iHeight, S.dWeight, FORMAT(count(P.sTrackingNumber),'###,###') AS 'PKGcount'
FROM dbo.tblPackage P 
    left join dbo.tblSKU S on P.ixBoxSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE ixShipDate >= 18568 -- 11/01/18
    and ixBoxSKU IS NOT NULL
    and ixBoxSKU NOT LIKE 'BOX-%'
    and ixBoxSKU NOT LIKE 'PS%'
    and ixBoxSKU NOT LIKE 'FCM%'                                                        -- 3,049 as of 11-12-19 @10:00
group by  P.ixBoxSKU, S.ixSKU,  S.iLength, S.iWidth, S.iHeight, S.dWeight               -- 3,671 as of 11-12-19 @17:30
order by count(P.sTrackingNumber) desc





SELECT count(*) FROM dbo.tblPackage P 
WHERE ixBoxSKU is NOT NULL

select FORMAT(count(*),'###,###') PkgCnt -- 164,979
from tblPackage
where ixBoxSKU <> 'CUSTOM'
    and ixBoxSKU is NOT NULL
    and ixShipDate < 18939






-- packages with BAD box SKUs
SELECT ixBoxSKU, dtShippedDate, P.sTrackingNumber,
    P.ixOrder, sTrackingNumber, ixBoxSKU, S.ixSKU 'SKUintblSKU', D.dtDate 'ShippedDate', 
    dBoxWeight, O.sOrderStatus, O.iShipMethod, P.dtDateLastSOPUpdate, P.ixTimeLastSOPUpdate,
   O.sOrderChannel, O.sSourceCodeGiven
from tblPackage P
    left join tblSKU S on P.ixBoxSKU = S.ixSKU
    left join tblOrder O on P.ixOrder = O.ixOrder
    left join tblDate D on D.ixDate = P.ixShipDate
    left join (SELECT ixOrder, count(ixSKU) 'OLCount'
               from tblOrderLine
               group by ixOrder) OLC on OLC.ixOrder = P.ixOrder
where --ixShipDate between 18933 and 18938 --	        11/01/2019 - 11/06/2019
     S.ixSKU is NULL -- 835  (494 of which are CUSTOM)  
    and P.ixBoxSKU <> 'CUSTOM'
  --  and P.ixBoxSKU NOT LIKE '910%'
  --  and P.ixBoxSKU NOT LIKE '917%'
  --  and P.ixBoxSKU NOT LIKE '715%'
  --  and P.ixBoxSKU NOT LIKE '916%'
   -- and P.ixOrder = '8021991' -- 2019-11-07 00:00:00.000	35486
order by P.ixBoxSKU

select * from tblPackage where ixBoxSKU is NOT NULL and ixShipDate < 18629

select top 30000 ixOrder, sTrackingNumber, ixShipDate, dtDateLastSOPUpdate
from tblPackage 
where ixBoxSKU is NULL
and ixShipDate >= 18800	-- 11/01/2019
order by ixShipDate desc

select * from tblPackage where dtDateLastSOPUpdate < '11/07/2019'
order 

-- packages with BAD box SKUs
SELECT P.ixOrder, sTrackingNumber, ixBoxSKU, S.ixSKU 'SKUintblSKU', D.dtDate 'ShippedDate', 
    dBoxWeight, O.sOrderStatus, O.iShipMethod, P.dtDateLastSOPUpdate, P.ixTimeLastSOPUpdate,
    O.sOrderChannel, O.sSourceCodeGiven
from tblPackage P
    left join tblSKU S on P.ixBoxSKU = S.ixSKU
    left join tblOrder O on P.ixOrder = O.ixOrder
    left join tblDate D on D.ixDate = P.ixShipDate
    left join (SELECT ixOrder, count(ixSKU) 'OLCount'
               from tblOrderLine
               group by ixOrder) OLC on OLC.ixOrder = P.ixOrder
where ixShipDate between 18933 and 18938 --	        11/01/19 - 11/06/19
   and P.flgCanceled = 0
   and P.flgReplaced = 0    --8,706
   -- and P.dBoxWeight IS NULL -- 72
   and P.dBoxWeight = 0 -- 738
   -- and P.ixOrder = '8021991' -- 2019-11-07 00:00:00.000	35486
order by O.sOrderChannel -- P.dtDateLastSOPUpdate, P.ixTimeLastSOPUpdate --P.ixBoxSKU
/*
11/1 to 11/6 
8,706 packages shipped
   72 NULL for BoxWeight
  738 0 for BoxWeight
   45 have BOX SKUs that do not exist in tblSKU
*/

select sTrackingNumber from tblPackage where ixBoxSKU in ('715-752','910-11049','910-13822-1','910-13822-2','910-13824-1','910-13824-2','910-13826-1','910-13826-2','910-13832-1','910-13832-2','910-13840','910-34340-MAN','910-43106','910-43447','910-45958','910-5246-PLN','910-6005','910-64017','910-64022','910-76255','910-82100','910-84112-3','916-28910','917-340-22','917-340-31','917-341-24','917-347-24','917-347-26','917-347-31','917-5159','930-0550','930-C32H','930-C4')

select ixOrder, count(*)
from tblOrderLine
where ixOrder in ('8019291','8045293','8001294','8047294','8049699','8071691')
group by ixOrder

SELECT ixOrder, sOrderStatus, ixShippedDate, iShipMethod
FROM tblOrder
where ixOrder in ('8019291','8045293','8001294','8047294','8049699','8071691')
/*      Order   Shipped Ship                Tracking
ixOrder	Status	Date	Method  Packages    Numbers
8001294	Shipped	18937	8       2           88424433        00503505549
8019291	Shipped	18933	2       1           1Z62F9970300006260
8045293	Shipped	18933	2       1           1Z62F9970300006279
8047294	Shipped	18938	8       2           88469494        00503505565
8049699	Shipped	18937	8       2           00503505531     88426440
8071691	Shipped	18937	8       2           00503505557     88428402
*/
-- ALL 6 orders have shipped


SELECT sTrackingNumber, ixOrder, dtDateLastSOPUpdate, ixTimeLastSOPUpdate
FROM tblPackage
where sTrackingNumber in ('1Z6353580354645697','914918023','OMA96071882','88155493','SP0103850386971453','1Z6353580354624138')
order by ixOrder



-- Standard Box SKU Usage
select P.ixBoxSKU, S.ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', S.iLength, S.iWidth, S.iHeight, S.dWeight, count(P.sTrackingNumber) 'PKGcount'
FROM tblPackage P 
    left join tblSKU S on P.ixBoxSKU = S.ixSKU
where --ixShipDate between 18902 and 18938 --	        10/01/2019 - 11/06/2019
    ixBoxSKU is NOT NULL
    and (ixBoxSKU LIKE 'BOX-%'
        OR ixBoxSKU LIKE 'PS%'
        OR ixBoxSKU LIKE 'FCM%'
        )
   -- and S.dWeight < 0.0625 -- Standard envelop weighs 0.0625 lbs
group by P.ixBoxSKU, S.ixSKU,  ISNULL(S.sWebDescription, S.sDescription), S.iLength, S.iWidth, S.iHeight, S.dWeight
order by --count(P.sTrackingNumber) desc
            P.ixBoxSKU -- 


-- 
select P.ixBoxSKU, count(P.sTrackingNumber) 'PKGcount'
FROM tblPackage P 
    left join tblSKU S on P.ixBoxSKU = S.ixSKU
where ixShipDate between 18933 and 18939 --	        10/01/2019 - 11/06/2019
    AND ixBoxSKU is NOT NULL
group by P.ixBoxSKU
ORDER BY count(P.sTrackingNumber) DESC

select * from tblOrder where ixOrder = '5302620'
select * from tblPackage where ixBoxSKU = '5302620'
select * from tblSKU where ixSKU = '5302620'

-- shipped as SLAPPERs
select P.ixBoxSKU, S.ixSKU, ISNULL(S.sWebDescription, S.sDescription) 'SKUDescription', S.sSEMACategory,S.sSEMASubCategory,
    S.iLength, S.iWidth, S.iHeight, S.dWeight, count(P.sTrackingNumber) 'PKGcount'
FROM dbo.tblPackage P 
    left join dbo.tblSKU S on P.ixBoxSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
where ixShipDate >= 18933--	11/01/2019
    and ixBoxSKU NOT LIKE 'BOX-%'
    and ixBoxSKU NOT LIKE 'PS%'
    and ixBoxSKU NOT LIKE 'FCM%'
    and ixBoxSKU <> 'CUSTOM'
    and S.ixSKU is NOT NULL -- excluding BOX SKUs that aren't formatted correctly
group by  P.ixBoxSKU, S.ixSKU,  S.iLength, S.iWidth, S.iHeight, S.dWeight,  ISNULL(S.sWebDescription, S.sDescription), S.sSEMACategory,S.sSEMASubCategory
order by S.iLength
    --   S.sSEMACategory,S.sSEMASubCategory
    -- count(P.sTrackingNumber) desc

BEGIN TRAN

UPDATE tblPackage
set ixBoxSKU = NULL
WhERE ixOrder in ('8014746','8906932','7515039')
and ixBoxSKU in ('910-6005','910-84112-3','917-347-24')

ROLLBACK TRAN




/************   REFEEDING PACKAGE DATA   ********************/

select FORMAT(count(sTrackingNumber),'###,###') from tblPackage
where 
ixVerificationDate between 18264 and 18294	--	01/01/18 - 01/31/18 61,960   
--ixVerificationDate between 18295 and 18322	--	02/01/18 - 02/28/18 73,508 
--ixVerificationDate between 18323 and 18353	--	03/01/18 - 03/31/18 94,375
--ixVerificationDate between 18354 and 18383	--	04/01/18 - 04/30/18 91,535  
--ixVerificationDate between 18384 and 18414	--	05/01/18 - 05/31/18  88,818
--ixVerificationDate between 18415 and 18444	--	06/01/18 - 06/30/18  81,868 
--ixVerificationDate between 18445 and 18475	--	07/01/18 - 07/31/18  81,555
--ixVerificationDate between 18476 and 18506	--	08/01/18 - 08/31/18  82,519
--ixVerificationDate between 18507 and 18536	--	09/01/18 - 09/30/18  66,802
--ixVerificationDate between 18537 and 18567	--	10/01/18 - 10/31/18  63,847
--ixVerificationDate between 18568 and 18597	--	11/01/18 - 11/30/18 61,488     

--ixVerificationDate between 18598 and 18628	--	12/01/18 - 12/31/18 70,841


select * from tblDate where iPeriodYear = 2018
and iPeriod = 2
order by ixDate -- 12/30/2017 is day 1 for 2018




SELECT P.ixBoxSKU, 
    --S.ixSKU, 
    S.iLength, S.iWidth, S.iHeight, S.dWeight, FORMAT(count(P.sTrackingNumber),'###,###') AS 'PKGcount'
FROM dbo.tblPackage P 
    left join dbo.tblSKU S on P.ixBoxSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE ixShipDate >= 18568 -- 11/01/18
    and ixBoxSKU IS NOT NULL
    and ixBoxSKU NOT LIKE 'BOX-%'
    and ixBoxSKU NOT LIKE 'PS%'
    and ixBoxSKU NOT LIKE 'FCM%'                                                        -- 3,049 as of 11-12-19 @10:00
group by  P.ixBoxSKU, S.ixSKU,  S.iLength, S.iWidth, S.iHeight, S.dWeight               -- 3,671 as of 11-12-19 @17:30
order by count(P.sTrackingNumber) desc



SELECT P.ixBoxSKU, count(*) 'pkgCount' 
    --S.ixSKU, 
   -- S.iLength, S.iWidth, S.iHeight, S.dWeight, FORMAT(count(P.sTrackingNumber),'###,###') AS 'PKGcount'
FROM dbo.tblPackage P 
  --  left join dbo.tblSKU S on P.ixBoxSKU = S.ixSKU COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE ixShipDate >= 18582 -- 11/15/18
    and P.flgCanceled = 0
group by P.ixBoxSKU
order by P.ixBoxSKU
order by count(*) desc

SELECT P.ixPacker, count(*) 'CustomPkgCount' 
FROM dbo.tblPackage P 
WHERE ixShipDate >= 18582 -- 11/15/18
    and P.flgCanceled = 0
    and P.ixBoxSKU = 'CUSTOM'
group by P.ixPacker
order by count(*) desc
