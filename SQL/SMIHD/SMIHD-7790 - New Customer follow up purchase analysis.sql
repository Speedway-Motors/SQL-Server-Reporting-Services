-- SMIHD-7790 - New Customer follow up purchase analysis

SELECT COUNT(distinct O.ixCustomer) 'DistCust', 
    COUNT(O.ixOrder) 'ShippedOrders' 
FROM tblOrder O 
    join tblOrderPromoCodeXref PCX on O.ixOrder = PCX.ixOrder -- 546
where ixPromoId in (1369) 
    AND sOrderStatus = 'Shipped'
    --AND O.sOrderType = 'Retail'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders


/***** Promo 1369
  546 Shipped Orders with those Promo IDs
  518 unique customers  
    # were existing customers
    # were new customers
    # of the new customers placed 1+ follow-up orders
    # avg # of orders for the repeat buyers
 $### AOV for the repeat buyers
**********/ 
 


select C.ixCustomer, C.dtAccountCreateDate, MIN(dtOrderDate) FirstPromoOrder --, sOrderStatus  
into [SMITemp].dbo.PJC_SMIHD7790_NewCustsFromPromos1369
from tblCustomer C
    join tblOrder O on C.ixCustomer = O.ixCustomer
    join tblOrderPromoCodeXref PCX on O.ixOrder = PCX.ixOrder
where ixPromoId in (1369) -- (1276, 1277, 1295, 1296, 1318, 1367, 1376) -- 45
    and O.sOrderStatus = 'Shipped'
group by C.ixCustomer, C.dtAccountCreateDate    
having C.dtAccountCreateDate >= MIN(dtOrderDate)
order by C.dtAccountCreateDate -- sOrderStatus
        -- MIN(dtOrderDate) 
        
        
1,939 Shipped Orders with those Promo IDs
1,322 unique customers  
1,121 were existing customers
  201 were new customers
   57 of the new customers placed 1+ follow-up orders
  2.8 avg # of orders for the repeat buyers
 $299 AOV for the repeat buyers
  
  
  
SELECT ixCustomer, COUNT(O.ixOrder) 'Orders'
into [SMITemp].dbo.PJC_SMIHD7790_NewCustsAdditionalOrders1369
from tblOrder O
where sOrderStatus = 'Shipped'
    and ixCustomer in (select ixCustomer from [SMITemp].dbo.PJC_SMIHD7790_NewCustsFromPromos1369)  -- 20 
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by ixCustomer
having COUNT(O.ixOrder) > 1

SELECT NC.ixCustomer, NC.Orders, SUM(O.mMerchandise) TotalSales
from tblOrder O
    join [SMITemp].dbo.PJC_SMIHD7790_NewCustsAdditionalOrders NC on O.ixCustomer = NC.ixCustomer
where sOrderStatus = 'Shipped'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
group by NC.ixCustomer, NC.Orders
