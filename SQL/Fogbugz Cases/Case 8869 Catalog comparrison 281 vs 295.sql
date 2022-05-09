-- SALES BY CATALOG AND SOURCECODE
select SC.ixCatalog, O.sMatchbackSourceCode, SC.sDescription,
      MC.Mailed,
      sum(O.mMerchandise), 
      count(O.ixOrder)                       OrdCount, 
      (sum(O.mMerchandise)/count(O.ixOrder)) AvgOrd
from tblOrder O
   join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
      -- Mail Count
   left join (select ixSourceCode, count(ixCustomer) Mailed -- 281: 58,012    295: 59,956
               from tblCustomerOffer CO
              group by ixSourceCode 
             ) MC on MC.ixSourceCode = O.sMatchbackSourceCode
where SC.ixSourceCode like '281%' -- '295%'
      and SC.ixCatalog = '281'    -- '295'
      and O.sOrderStatus = 'Shipped'
      and O.sOrderChannel <> 'INTERNAL'
group by SC.ixCatalog, O.sMatchbackSourceCode, SC.sDescription, MC.Mailed
order by SC.ixCatalog, O.sMatchbackSourceCode



-- CATALOG DETAILS
select * from tblCatalogMaster where ixCatalog in ('281','295')

select top 10 * from tblCustomerOffer

-- # OF CATALOGS MAILED FOR EACH CATALOG AND HOW MANY OVERLAPPED
select count(CO.ixCustomer) -- 281: 58,012    295: 59,956
from tblCustomerOffer CO
  join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
where SC.ixCatalog = '295'
and CO.ixCustomer in 
                     (select CO.ixCustomer -- JEN this query could have been joined on by ixCustomer instead of me using the IN statement
                      from tblCustomerOffer CO
                           join tblSourceCode SC on CO.ixSourceCode = SC.ixSourceCode
                      where SC.ixCatalog = '281')  



-- COUNT OF ORDERS USING PROMO CODES
select O.sPromoApplied, 
   sum(O.mMerchandise)                    Sales,
   count(O.ixOrder)                       OrdCount, 
   (sum(O.mMerchandise)/count(O.ixOrder)) AvgOrd
from tblOrder O
   join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
      and O.sOrderStatus = 'Shipped'
      and O.sOrderChannel <> 'INTERNAL'
where SC.ixSourceCode like '281%' -- '281%'
      and SC.ixCatalog = '281'    -- '281'
group by O.sPromoApplied
order by OrdCount desc


select top 10 * from tblSourceCode

only include the catalog-specific source codes (meaning those that start with "281" or "295").  

-- exclude any cancelled orders.  
-- exclude orders with an order channel of "INTERNAL" as well.  

--show # of orders and average order.  
--show sales and avg order for those orders that used a promo code.
