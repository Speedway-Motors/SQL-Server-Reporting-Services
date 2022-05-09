-- SMIHD-22190 - Ppdate logic for data extracts that are delivered to Loyalty Builders

select * from tblBusinessUnit

select O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType,
    FORMAT(count(O.ixOrder),'###,###') 'OrderCnt'
 from tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE O.ixOrderDate between 14977 and 19571	-- 01/01/2009 and 07/31/2021 	
    and O.sOrderStatus = 'Shipped'
	    and O.sShipToCountry='US'
        and O.ixBusinessUnit is NOT NULL
GROUP BY O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType
ORDER BY O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType



/***** WHOLESALE orders where BU and Order Type are not matching ******/
-- PRS
    -- Order Type = Retail but BU = PRS
    select ixOrder, sOrderType, ixBusinessUnit, dtOrderDate, dtDateLastSOPUpdate, sOrderStatus -- 1,544 v
     from tblOrder
    where ixBusinessUnit = 104 --'PRS' 
        and sOrderType = 'Retail'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'
    order by sOrderStatus, dtOrderDate desc -- dtDateLastSOPUpdate

    -- Order Type = PRS but BU <> PRS
    select ixOrder, sOrderType, ixBusinessUnit, dtOrderDate, dtDateLastSOPUpdate, sOrderStatus -- 6,147
     from tblOrder
    where ixBusinessUnit <> 104 --'PRS' 
        and sOrderType = 'PRS'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'
    order by sOrderStatus, dtOrderDate desc -- dtDateLastSOPUpdate



-- MRR
    -- Order Type = Retail but BU = MRR
    select ixOrder, sOrderType, ixBusinessUnit, dtOrderDate, dtDateLastSOPUpdate, sOrderStatus -- 297 v
     from tblOrder
    where ixBusinessUnit = 105 --'MRR' 
        and sOrderType = 'Retail'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'
        
    order by sOrderStatus, dtOrderDate desc -- dtDateLastSOPUpdate

    -- Order Type = MRR but BU <> MRR
    select ixOrder, sOrderType, ixBusinessUnit, dtOrderDate, dtDateLastSOPUpdate, sOrderStatus -- 1,065 v
    from tblOrder
    where ixBusinessUnit <> 105 --'MRR' 
        and sOrderType = 'MRR'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'
    order by sOrderStatus, dtOrderDate desc -- dtDateLastSOPUpdate


select count(*) -- 12,629 match   109 mismatch    
from tblOrder
where ixBusinessUnit = 105 --'MRR' 
        and sOrderType = 'MRR'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'

select count(*) -- 26,082  match    1,192 mismatch
from tblOrder
where ixBusinessUnit = 104 --'MRR' 
        and sOrderType = 'PRS'
        and sOrderStatus <> 'Cancelled'
        and dtOrderDate > '08/04/2020'



select O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType,
    FORMAT(count(O.ixOrder),'###,###') 'OrderCnt'
 from tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
WHERE O.ixOrderDate between 14977 and 19571	-- 01/01/2009 and 07/31/2021 	
    and O.sOrderStatus = 'Shipped'
	    and O.sShipToCountry='US'
        and O.ixBusinessUnit is NOT NULL
        AND O.sOrderType in ('PRS')
GROUP BY O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType
ORDER BY O.ixBusinessUnit, BU.sBusinessUnit, O.sOrderType

select ixBusinessUnit, count(*)
from tblOrder
group by ixBusinessUnit
order by ixBusinessUnit

SELECT * FROM tblBusinessUnit
/*
104	PRS
105	MRR
*/