-- Case 18326 - Analysis for potential Web and eBay CST segments        
                      
-- eBay pureplay 12Mo
select COUNT(distinct O.ixCustomer) CustCount -- 16,057
from tblOrder O
LEFT JOIN (Select distinct ixCustomer
            from tblOrder O
            where   O.sOrderStatus = 'Shipped'
            --and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate >= '04/15/2012' 
            and O.sMatchbackSourceCode <> 'EBAY'
            ) NE on O.ixCustomer = NE.ixCustomer
where NE.ixCustomer is NULL  
and  O.sOrderStatus = 'Shipped'
and O.mMerchandise > 0 -- > 1 if looking at non-US orders
and O.dtShippedDate >= '04/15/2012' 
and O.sMatchbackSourceCode = 'EBAY' 


-- eBay pureplay 24Mo
select COUNT(distinct O.ixCustomer) CustCount -- 26,925
from tblOrder O
LEFT JOIN (Select distinct ixCustomer
            from tblOrder O
            where   O.sOrderStatus = 'Shipped'
            --and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate > '04/15/2011' 
            and O.sMatchbackSourceCode <> 'EBAY'
            ) NE on O.ixCustomer = NE.ixCustomer
where NE.ixCustomer is NULL  
and  O.sOrderStatus = 'Shipped'
and O.mMerchandise > 0 -- > 1 if looking at non-US orders
and O.dtShippedDate > '04/15/2011' 
and O.sMatchbackSourceCode = 'EBAY'     


-- eBay pureplay 36Mo
select COUNT(distinct O.ixCustomer) CustCount -- 30,012
from tblOrder O
LEFT JOIN (Select distinct ixCustomer
            from tblOrder O
            where   O.sOrderStatus = 'Shipped'
            --and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
            --and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
            and O.mMerchandise > 0 -- > 1 if looking at non-US orders
            and O.dtShippedDate > '04/15/2010' 
            and O.sMatchbackSourceCode <> 'EBAY'
            ) NE on O.ixCustomer = NE.ixCustomer
where NE.ixCustomer is NULL  
and  O.sOrderStatus = 'Shipped'
and O.mMerchandise > 0 -- > 1 if looking at non-US orders
and O.dtShippedDate > '04/15/2010' 
and O.sMatchbackSourceCode = 'EBAY'    
    
    
    
    
    
    
    

            