   select SC.ixSourceCode, count(ixOrder) ShippedOrderCount, sum(mMerchandise) TotalMerch
from tblOrder O
   join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode
where SC.ixCatalog = '318' 
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate > '05/04/2011'
group by SC.ixSourceCode
order by TotalMerch desc, ShippedOrderCount desc
--order by dtShippedDate





-- performance by day TY CATALOG
select O.dtShippedDate, count(ixOrder) ShippedOrderCount, sum(mMerchandise) TotalMerch
from tblOrder O
   join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
where SC.ixCatalog = '318' 
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate > '06/04/2011' --             05/05=FIRST ORDER SHIPPED
group by O.dtShippedDate
order by O.dtShippedDate

-- performance by day LY CATALOG
select O.dtShippedDate, count(ixOrder) ShippedOrderCount, sum(mMerchandise) TotalMerch
from tblOrder O
   join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
where SC.ixCatalog = '292' 
and O.sOrderStatus = 'Shipped'
and O.dtShippedDate > '02/28/2010' -- <- FIRST MONDAY 
AND O.dtShippedDate < '03/22/2010'
group by O.dtShippedDate
order by O.dtShippedDate





select SC.ixCatalog, O.dtShippedDate, count(ixOrder) ShippedOrderCount, sum(mMerchandise) TotalMerch
from tblOrder O
   join tblSourceCode SC on O.sSourceCodeGiven = SC.ixSourceCode
where O.sOrderStatus = 'Shipped'
   and O.dtShippedDate > '01/01/2008' -- <- FIRST MONDAY 
   and ixCatalog not like 'WEB%'
  -- and ixCatalog not like 'GEN%'
   and ixCatalog not like 'PRS%'
group by O.dtShippedDate,SC.ixCatalog
having (
--count(ixOrder) > 500
  --      OR 
        sum(mMerchandise) > 86004)
        
order by ixCatalog, TotalMerch


select distinct ixCatalog from tblCatalogMaster
where ixCatalog like 'WEB%'



SELECT * FROM tblCatalogMaster
where UPPER (sDescription) like '%STREET%'
and dtStartDate > '01/01/2010'


select * from tblSourceCode
where ixCatalog in ('292','293')
order by dtStartDate


select top 10 * from tblSKU


SELECT sum(merchandise) from tblOrder
where 

