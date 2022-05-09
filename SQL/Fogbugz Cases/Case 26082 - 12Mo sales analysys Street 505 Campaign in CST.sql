-- Case 26082 - 12Mo sales analysys Street 505 Campaign in CST

/*** Retail AND Wholesale Sales***/
-- 504 Cust List
SELECT sum(O.mMerchandise) Sales -- 82,088,564   out of 100,767,402 = 81.5%
FROM [SMITemp].dbo.PJC_26082_12moSalesForCat505CustList L
left join tblOrder O on O.ixCustomer = L.ixCustomer
WHERE     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '05/12/2014' and '05/11/2015'
    
-- ALL customers    
    SELECT sum(O.mMerchandise) Sales -- 82,088,564.91
FROM tblOrder O 
WHERE     O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '05/12/2014' and '05/11/2015'
    
    
    
    
    
/*** Retail Sales only ***/    
-- RETAIL SALES ONLY    
SELECT sum(O.mMerchandise) Sales -- 81,050,436  out of 86,380,386  = 94.0%
FROM [SMITemp].dbo.PJC_26082_12moSalesForCat505CustList L
left join tblOrder O on O.ixCustomer = L.ixCustomer
WHERE     O.sOrderStatus in ('Shipped','Dropshipped')
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '05/12/2013' and '05/11/2015'
    
    
select distinct sOrderStatus from tblOrder
    
    
SELECT sum(O.mMerchandise) Sales -- 86,280,604   86281302.028
FROM tblOrder O                  -- 86281302.028 OL summary
WHERE    O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '05/12/2013' and '05/11/2015'  
    
    
select sum(OL.mExtendedPrice) Sales -- 86281302.028
from tblOrderLine OL
left join tblOrder O on OL.ixOrder = O.ixOrder
WHERE     O.sOrderStatus in ('Shipped','Dropshipped')
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '05/12/2014' and '05/11/2015'   --
    --and OL.flgLineStatus NOT in ('Shipped','Dropshipped') -- 766,011.46
    and OL.flgLineStatus in ('Shipped','Dropshipped') -- 766,011.46    
    
    
    
    SELECT sum(O.mMerchandise) Sales -- 86,280,604   86281302.028
FROM tblOrder O                  -- 86281302.028 OL summary
WHERE    O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderType = 'Retail'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtOrderDate between '05/12/2013' and '05/11/2015'  
    
    
    
 -- reran code for 24Mo   
    $156,505,675 out of $167,487,491