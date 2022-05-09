-- DSOTHER-24 

-- Topher's request for Nancy

-- counts by Order Channel by day
select CONVERT(VARCHAR, dtShippedDate, 101) 'Shipped' , sOrderChannel 'Type', count(O.ixOrder) Orders 
from tblOrder O             -- 586K orders (original)
  join tblCustomer C on O.ixCustomer = C.ixCustomer -- 471K (revised request)
where dtShippedDate >= '01/01/2013'
    and O.sOrderStatus = 'Shipped'
    and C.flgDeletedFromSOP = 0
    and len(C.sEmailAddress) > 5
    and C.sEmailAddress like '%@%.%'
    and O.sOrderType NOT IN ('MRR','PRS')
    and O.ixOrder NOT IN (select distinct ixOrder   -- 451,264
                          from tblOrderLine 
                          where dtShippedDate >= '01/01/2013' 
                            and ixSKU = 'NOEMAIL') 
    and (C.flgMarketingEmailSubscription is NULL
         OR C.flgMarketingEmailSubscription = 'Y')                               
   -- and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
  --  and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
  --  and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'
group by dtShippedDate, sOrderChannel
order by dtShippedDate, sOrderChannel



-- Total Record count
select count(O.ixOrder) Orders 
from tblOrder O             -- 586K orders (original)    475911
  join tblCustomer C on O.ixCustomer = C.ixCustomer -- 471K (revised request)
where dtShippedDate >= '01/01/2013'
    and O.sOrderStatus = 'Shipped'
    and C.flgDeletedFromSOP = 0
    and len(C.sEmailAddress) > 5 
    and C.sEmailAddress like '%@%.%'
    and O.sOrderType NOT IN ('MRR','PRS')           -- 453,665
    and O.ixOrder NOT IN (select distinct ixOrder   -- 451,264
                          from tblOrderLine 
                          where dtShippedDate >= '01/01/2013' 
                            and ixSKU = 'NOEMAIL')
    and (C.flgMarketingEmailSubscription is NULL
         OR C.flgMarketingEmailSubscription = 'Y')  -- 439,723                            
    
   -- and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
  --  and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
  --  and O.mMerchandise > 0 -- > 1 if looking at non-US orders
  --  and O.dtShippedDate between '01/01/2012' and '12/31/2012'

select * from tblSKU where ixSKU = 'NOEMAIL'
  
    
select sOrderType, count(*) OrdCount
from tblOrder
group by sOrderType
/*
sOrderType          OrdCount
Customer Service	67117
Internal	        37023
MRR	                66858
PRS	                102606
Retail	            2839031
*/    
    


select ixOrder from tblOrder
where dtShippedDate > '02/28/2014' and dtDateLastSOPUpdate < '03/28/2014'




select flgMarketingEmailSubscription, 
count(*)
from tblCustomer
group by flgMarketingEmailSubscription