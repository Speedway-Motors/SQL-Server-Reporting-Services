-- Tableau web order type grouping
select count(sWebOrderID) from PJC_sWebOrderID_NULLinTab            -- 6,503   <-- 1 dupe!?!
select count (distinct(sWebOrderID)) from PJC_sWebOrderID_NULLinTab -- 6,502



select N.*,O.*      -- 6,667
from PJC_sWebOrderID_NULLinTab N
left join [SMI Reporting].dbo.tblOrder O on O.sWebOrderID = N.sWebOrderID
order by 



-- multiple orders with same WebOrderID
select N.sWebOrderID, count(O.ixOrder) --N.*,O.*      -- 6,667
from PJC_sWebOrderID_NULLinTab N
left join [SMI Reporting].dbo.tblOrder O on O.sWebOrderID = N.sWebOrderID
group by N.sWebOrderID
having count(O.ixOrder) > 1



select * from [SMI Reporting].dbo.tblOrder where sWebOrderID in ('E1380381','E1379561','E1381083','E1380072','E1381713')
order by sWebOrderID

select COUNT(*) 'Qty', sOrderType
from [SMI Reporting].dbo.tblOrder O
where sWebOrderID is NOT NULL
   -- and O.dtOrderDate between '05/01/2015' and '05/10/2015'
    and O.dtShippedDate between '05/01/2015' and '05/10/2015' 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
 --   and O.sOrderChannel <> 'INTERNAL'   -- don't filter these typically!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sOrderType
order by  COUNT(*) desc
/*
-- BASED ON ORDER DATE
Qty	    sOrderType
7368	Retail
109	    PRS
67	    MRR
2	    Customer Service


-- BASED ON SHIPPED DATE
Qty	    sOrderType
7318	Retail
114	    PRS
71	    MRR
2	    Customer Service
*/


select COUNT(*) 'Qty', sOrderType
from [SMI Reporting].dbo.tblOrder O
where sWebOrderID is NOT NULL
   -- and O.dtOrderDate between '05/01/2015' and '05/10/2015'
    and O.dtShippedDate between '05/01/2015' and '05/10/2015' 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
 --   and O.sOrderChannel <> 'INTERNAL'   -- don't filter these typically!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by sOrderType
order by  COUNT(*) desc


select COUNT(*) 'Qty', ixOrderType
from [SMI Reporting].dbo.tblOrder O
where sWebOrderID is NOT NULL
   -- and O.dtOrderDate between '05/01/2015' and '05/10/2015'
    and O.dtShippedDate between '05/01/2015' and '05/10/2015' 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
 --   and O.sOrderChannel <> 'INTERNAL'   -- don't filter these typically!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by ixOrderType
order by  COUNT(*) desc
-- ALL NULL

SELECT ixOrderType 
from [SMI Reporting].dbo.tblOrder O
where sWebOrderID is NULL
   -- and O.dtOrderDate between '05/01/2015' and '05/10/2015'
    and O.dtShippedDate between '01/01/2015' and '05/10/2015' 
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
 --   and O.sOrderChannel <> 'INTERNAL'   -- don't filter these typically!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by ixOrderType

SELECT * FROM [SMI Reporting].dbo.tblOrder
WHERE ixOrderType IS not null