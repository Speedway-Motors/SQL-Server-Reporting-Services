-- SMIHD-18966 - Dropship Revenue report

select * from tblOrderLine
where ixOrder = '9012578'

select O.ixOrder, sOrderChannel, sSourceCodeGiven, BU.sBusinessUnit -- sMatchbackSourceCode
from tblOrder O
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
where --DS.ixOrder is NOT NULL
O.ixOrder = '9012578'
--and O.sSourceCodeGiven <> BU.sBusinessUnit





ixOrder	flgLineStatus	mExtendedPrice
9012578	Dropshipped	    69.99


ueser enter shipped date range

-- DROP TABLE #DropshipOrders -- 1,112
select distinct ixOrder
into #DropshipOrders
from tblOrderLine 
where ixShippedDate BETWEEN 19268 AND 19292 -- 10/1 TO 10/25
    and flgLineStatus = 'Dropshipped'


select OL.mExtendedPrice, sOrderChannel, sSourceCodeGiven, BU.sBusinessUnit -- sMatchbackSourceCode
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
where DS.ixOrder is NOT NULL

select OL.mExtendedPrice, sOrderChannel, sSourceCodeGiven, BU.sBusinessUnit -- sMatchbackSourceCode
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
where DS.ixOrder is NOT NULL
and OL.flgLineStatus = 'Dropshipped' -- $316,990

select sum(OL.mExtendedPrice) from tblOrderLine OL
where ixShippedDate BETWEEN 19268 AND 19274 -- 10/1 TO 10/7
    and flgLineStatus = 'Dropshipped' -- $316,990


-- Summary Dropship Sales by BU
select sum(OL.mExtendedPrice) 'Merch', BU.sBusinessUnit -- sMatchbackSourceCode
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
where DS.ixOrder is NOT NULL
and OL.flgLineStatus = 'Dropshipped' -- $316.990
group by BU.sBusinessUnit
order by sum(OL.mExtendedPrice) desc



-- Detail report
SELECT O.ixOrder, O.dtOrderDate, O.dtShippedDate, O.ixCustomer, 
    O.sShipToState, O.sOrderChannel, O.sSourceCodeGiven, 
    SUM(OL.mExtendedPrice) 'Merch', BU.sBusinessUnit
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
WHERE DS.ixOrder is NOT NULL
    and OL.flgLineStatus = 'Dropshipped' -- $316.990
GROUP BY O.ixOrder, O.dtOrderDate, O.dtShippedDate, O.ixCustomer, 
    O.sShipToState, O.sOrderChannel, O.sSourceCodeGiven, BU.sBusinessUnit



select * from tblOrderLine
where ixOrder in ('9880869','9742662','9832560','9818063','9828061')
order by ixOrder

--  Sub-Dropship Revenue Summary.rdl
/*  ver 20.44.1
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '10/01/20',    @EndDate = '10/07/20'  
*/
-- DROP TABLE #DropshipOrders -- 1,112
SELECT distinct ixOrder
into #DropshipOrders
FROM tblOrderLine 
WHERE dtShippedDate between @StartDate and @EndDate --19268 AND 19274 -- 10/1 TO 10/08
    and flgLineStatus = 'Dropshipped'

    -- Detail report
SELECT O.ixOrder, O.dtOrderDate, O.dtShippedDate, O.ixCustomer, 
    O.sShipToState, O.sOrderChannel, O.sSourceCodeGiven, 
    SUM(OL.mExtendedPrice) 'Merch', BU.sBusinessUnit
FROM tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join tblBusinessUnit BU on O.ixBusinessUnit = BU.ixBusinessUnit
    left join #DropshipOrders DS on O.ixOrder = DS.ixOrder
WHERE DS.ixOrder is NOT NULL
    and OL.flgLineStatus = 'Dropshipped' -- $316.990
GROUP BY O.ixOrder, O.dtOrderDate, O.dtShippedDate, O.ixCustomer, 
    O.sShipToState, O.sOrderChannel, O.sSourceCodeGiven, BU.sBusinessUnit
ORDER BY O.dtShippedDate,O.ixOrder

DROP TABLE #DropshipOrders 

