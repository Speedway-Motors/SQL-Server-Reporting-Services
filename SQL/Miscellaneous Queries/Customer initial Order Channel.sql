-- Customer initial Order Channel



/**** NOT ACCURATE YET, NEEDS TO WORK!!!   *****/
select O.ixCustomer, O.sOrderChannel 'OrigOrderChan'
from vwOrderAllHistory O
    -- FIRST ORDER
      join (select ixCustomer,
                min(dtOrderDate) 'dtFirstOrderDate'-- [FirstOrder]
                ,min(ixOrderTime) 'ixFirstOrderTime'
            from vwOrderAllHistory
            where sOrderStatus = 'Shipped'
                and sOrderType <> 'Internal'
                and sOrderChannel <> 'INTERNAL'
                and mMerchandise > 0
            group by ixCustomer) FO on O.ixCustomer = FO.ixCustomer and O.dtShippedDate = FO.dtFirstOrderDate and O.ixOrderTime = FO.ixFirstOrderTime
order by O.ixCustomer       
       
-- 368,042       



select COUNT(distinct ixCustomer) -- 853,247
from vwOrderAllHistory
where sOrderStatus = 'Shipped'
                and sOrderType <> 'Internal'
                and sOrderChannel <> 'INTERNAL'
                and mMerchandise > 0     
                
                
                



select O.ixCustomer, O.sOrderChannel 'OrigOrderChan'
from tblOrder O
      join tblCustomer C on O.ixCustomer = C.ixCustomer
    -- FIRST ORDER
      join (select ixCustomer,
                min(dtOrderDate) 'dtFirstOrderDate'-- [FirstOrder]
                ,min(ixOrderTime) 'ixFirstOrderTime'
            from tblOrder
            where sOrderStatus = 'Shipped'
                and sOrderType <> 'Internal'
                and sOrderChannel <> 'INTERNAL'
                and mMerchandise > 0
                and dtOrderDate >= '01/01/2007'
                and ixOrder NOT LIKE '%-%'
            group by ixCustomer) FO on O.ixCustomer = FO.ixCustomer and O.dtShippedDate = FO.dtFirstOrderDate and O.ixOrderTime = FO.ixFirstOrderTime
where C.flgDeletedFromSOP = 0
    and C.dtAccountCreateDate >= '01/01/2007'
order by O.ixCustomer       
       
-- 211,621    



select COUNT(distinct O.ixCustomer)
from tblOrder O
    join tblCustomer C on O.ixCustomer = C.ixCustomer
where sOrderStatus = 'Shipped'
    and sOrderType <> 'Internal'
    and sOrderChannel <> 'INTERNAL'
    and mMerchandise > 0  
    and ixOrder NOT LIKE '%-%'                  
and C.flgDeletedFromSOP = 0
     and dtOrderDate >= '01/01/2007'
    and C.dtAccountCreateDate >= '01/01/2007'               
-- 417,721              

