-- SMIHD-8715 - Create a view joining data from PO Master Detail and Dropship

-- 1st part of UNION query pulling from PO Master & Detail
SELECT --POM.ixPO -- need to make it unique...  prepend with PO for Purchase Orders?
      'PO'+CONVERT(varchar(10),POM.ixPO) 'ixPO'
    , POM.ixIssueDate 
    , POM.ixIssuer
    , POM.ixVendor
    , POM.flgIssued
    , POM.flgOpen
    , POD.ixSKU
    , POD.iQuantity
    , POD.ixUnitofMeasurement
    , POD.mCost
    , POD.iOrdinality
    , POD.ixExpectedDeliveryDate
    , POD.iQuantityReceivedPending
    , POD.iQuantityPosted
    , NULL as ixDropship
FROM tblPOMaster POM
    left join tblPODetail POD on POM.ixPO = POD.ixPO
WHERE POM.ixPODate = 18111 -- 08/01/2017
/*
ixPO	ixPODate	ixIssuer	ixVendor	flgIssued	flgOpen	ixSKU	    iQuantity	ixUnitofMeasurement	mCost	    iOrdinality	ixExpectedDeliveryDate	iQuantityReceivedPending	iQuantityPosted
114120R	18166	    AJBIII	    2895	    1	        1	    9300101	    5	        PR	                0.00	    1	        18436	                0	                        0
123822	18111	    AHH	        2736	    1	        0	    94031010	10	        EA	                25.00	    1	        18117	                0	                        10
123822	18111	    AHH	        2736	    1	        0	    94031120	1	        EA	                480.00	    2	        18117	                0	                        1
*/

UNION

-- 2nd part of UNION query pulling from tblDropShip and ???
select --top 10 
    --DS.ixDropship 'ixPO' -- need to make it unique...  prepend with DS for dropship?
  'DS'+CONVERT(varchar(10),DS.ixDropship) 'ixPO'    
, O.ixOrderDate 'ixIssueDate'
, 'Dropship' as ixIssuer
, DS.ixVendor
, 1 as 'flgIssued'
, (CASE WHEN ixActualShipDate IS NULL AND ixCancelledDate IS NULL THEN 1
   ELSE 0
   END) 'flgOpen'
, DS.ixSKU
, DS.iQty
, 'EA' as ixUnitofMeasurement -- per CCC
, DS.mCost
, DS.iOrdinality
, NULL ixExpectedDeliveryDate -- ???
, (CASE WHEN ixActualShipDate IS NULL AND ixCancelledDate IS NULL THEN iQty
   ELSE 0
   END) 'iQuantityReceivedPending'
, (CASE WHEN ixActualShipDate IS NULL AND ixCancelledDate IS NULL THEN 0
   ELSE iQty
   END) 'iQuantityPosted'   
, DS.ixDropship
FROM tblDropship DS
    left join tblOrder O on DS.ixOrder = O.ixOrder
WHERE O.ixOrderDate = 18111 -- 08/01/2017

SELECT * from tblPOMaster
where ixPODate = 18111
and ixPO like 'F%'

select * from tblPODetail where ixPO = 'F7004'

select * from tblPOMaster  
where ISNUMERIC(ixPO) =  0
and ixPODate >= 17000
and ixPO like '%-%'
order by ixPO



124135#2
124135#3
124135#4
100564-1
100564-2
100564-3
100564-4
114120R
CU742200
A5635
B0520
F7043


SELECT * FROM tblPOMaster
WHERE ixPODate = 18111

select top 1 * from tblDropship


SELECT ixUnitofMeasurement, COUNT(*)
FROM tblPODetail
group by ixUnitofMeasurement

SELECT *
from tblPOMaster -- 127782
where ixPODate <> ixIssueDate
and flgIssued = 1
and ixPODate >= 18111


select top 10 * from tblDropship

select COUNT(*) from tblDropship                    -- 73798
select COUNT(distinct ixDropship) from tblDropship  -- 73798
select COUNT(distinct ixSpecialOrder) from tblDropship  -- 61560

select ixDropship from tblDropship 
order by ixDropship

select MIN(ixPODate)
from tblPOMaster


select * from tblDate where ixDate = 7629

SELECT iYear, COUNT(ixPO)
from tblPOMaster POM
join tblDate D on POM.ixPODate = D.ixDate
group by iYear
order by iYear

select COUNT(*) from tblPODetail

SELECT COUNT(*) from tblPOMaster -- 127782
where ixPODate <> ixIssueDate
and flgIssued = 1
and ixPODate >= 18111


select * from tblDropship -- 73,878
where iQty > 1-- 