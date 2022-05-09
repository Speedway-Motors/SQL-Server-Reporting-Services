-- Case 18459 - research Afco orders failing to feed

Select * from PJC_18459_Failed_Afco_Orders -- 454

select O.* 
from [AFCOReporting].dbo.tblOrder O
join PJC_18459_Failed_Afco_Orders FO on O.ixOrder collate SQL_Latin1_General_CP1_CI_AS = FO.ixOrder collate SQL_Latin1_General_CP1_CI_AS
order by dtDateLastSOPUpdate, ixTimeLastSOPUpdate

-- most of the orders where last updated on 4-17-2013
/*
Open	2
Shipped	452
*/
-- the dtOrderDates are scattered fairly evenly from December 2011 to present.

-- !!!! ALL of the failed orders are sShipToCountry are outside the US

select O.dtOrderDate, count (O.ixOrder) OrdCount 
from [AFCOReporting].dbo.tblOrder O
join PJC_18459_Failed_Afco_Orders FO on O.ixOrder collate SQL_Latin1_General_CP1_CI_AS = FO.ixOrder collate SQL_Latin1_General_CP1_CI_AS
group by O.dtOrderDate












