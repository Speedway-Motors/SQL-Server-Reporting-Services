-- SMIHD-23157 - Change SOP logic to use original order date in Orderline

-- ONLY REFED UPDATES to tblOrderLine 
-- FOR THE PREV 12 MONTHS
-- 11/25/2020 TO PRESENT

-- SMI -- 
SELECT Distinct O.ixOrder--,  O.ixOrderDate, OL.ixOrderDate, OL.iOrdinality
from tblOrder O
    left join tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixOrderDate >= 19323	--11/25/2020    -- 886 orders
    and O.ixOrderDate <> OL.ixOrderDate
order by O.ixOrder --, OL.iOrdinality 

-- AFCO --
SELECT Distinct O.ixOrder--,  O.ixOrderDate, OL.ixOrderDate, OL.iOrdinality
from [AFCOReporting].dbo.tblOrder O
    left join [AFCOReporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
where O.ixOrderDate >= 19323	--11/25/2020    --  2,963 orders     1,287 2nd batch
    and O.ixOrderDate <> OL.ixOrderDate
order by O.ixOrder --, OL.iOrdinality 

