-- SMIHD-2965 - Analysis Repeat Purchasers using during Black Friday to Cyber Monday Promo dates
-- Promo IDs 859 & 853 & Black Friday

/* report of the number of customers who had repeat purchases 11/20-12/1 using promo IDs (859 & 853) 
Q. only orders with these promos are any orders placed by customers that used at least one of these promos?

and, if possible, purchases shipping for $63 during the Black Friday offer, 11/25-11/30 (no promo code used/needed for that offer.)
Q. I must be reading this wrong... I'm not seeing any orders with $63 shipping.  Can you give me some more details.

Additionally I'd like to see AOV and # of items/purchase for those repeat purchases.
I'd like this information by EOD Friday if possible.
*/

-- DROP TABLE [SMITemp].dbo.[PJC_SMIHD_2965_Buyers]
-- placed 1+ orders during that range
select distinct(O.ixCustomer) -- 12,211 customers
    --, O.sOrderStatus
into [SMITemp].dbo.[PJC_SMIHD_2965_Buyers]
from --tblOrderPromoCodeXref OPX
    tblOrder O 
where --OPX.ixPromoId in (859,853)
    O.sOrderStatus = 'Shipped' -- only other status for these was 'Cancelled'
    and O.dtOrderDate between '11/20/2015' and '12/01/2015'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
    and O.sOrderType = 'Retail'    


    
-- DROP TABLE [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] 
-- Multi-buyers   
SELECT B.ixCustomer, TS.TotSales, OC.OrderCount 'OrdersPlaced', TS.TotLineItems -- 1,047 customers made 2+ purchases
--into [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers]    
from [SMITemp].dbo.[PJC_SMIHD_2965_Buyers] B
    left join (-- Total Sales
                select O.ixCustomer, SUM(O.mMerchandise) TotSales, SUM(O.iTotalTangibleLines) TotLineItems
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.sOrderType = 'Retail'
                    and O.dtOrderDate between '11/20/2015' and '12/01/2015'                    
                group by O.ixCustomer                    
                ) TS on TS.ixCustomer = B.ixCustomer    
    left join (-- # of Orders
                select O.ixCustomer, COUNT(ixOrder) OrderCount
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.sOrderType = 'Retail'                    
                    and O.ixOrder NOT LIKE '%-%'
                    and O.dtOrderDate between '11/20/2015' and '12/01/2015'                    
                group by O.ixCustomer                    
                ) OC on OC.ixCustomer = B.ixCustomer    
where OC.OrderCount > 1
order by OC.OrderCount

SELECT * FROM [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers]


-- looking at custs with high qty of orders
SELECT * from tblCustomer where ixCustomer in (1034528,16504,2608750,1086086,2611559)


-- 
/* RESULTS SUMMARY
12,211 customers placed 1+ orders between 11/20/2015 and 12/01/2015
of those 1,047 placed 2+ orders between 11/20/2015 and 12/01/2015
*/


SELECT count(*) from [SMITemp].dbo.[PJC_SMIHD_2965_Buyers]      -- 12,211
SELECT count(*) from [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] --  1,047

-- 39 customers that only had backorders
SELECT * from tblOrder O
where ixCustomer in ('235423','2375644','1709670','1140142','836989','2608452','1773853','488815','2675440','151170','1079032','834478','746870','337514','1447133','2681658','2402955','2619054','2672459','513607','2629656','2617456','2697342','956858','2543956','1561632','1492580','1650765','2638452','2429945','1842744','2379048','2601458','657121','2514650','1028635','826913','1706676','2634452')
and  O.sOrderStatus = 'Shipped' -- only other status for these was 'Cancelled'
    and O.dtOrderDate between '11/20/2015' and '12/01/2015'  
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'  








--
SELECT B.ixCustomer, O.ixOrder, O.mMerchandise, O.mShipping, O.iTotalTangibleLines, OPX.ixPromoCode, OPX.ixPromoId
from [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] B
    left join tblOrder O on B.ixCustomer = O.ixCustomer
    left join tblOrderPromoCodeXref OPX on O.ixOrder = OPX.ixOrder
where O.sOrderStatus = 'Shipped' -- only other status for these was 'Cancelled'
    and O.dtOrderDate between  '11/20/2015' and '12/01/2015'  
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'  
    and O.ixOrder NOT LIKE '%-%'    
    
order by O.ixOrder

select ixOrder, COUNT(*)
from tblOrderPromoCodeXref
where ixOrder between '6200549' and '6399749'
group by ixOrder
order by  COUNT(*) desc




SELECT *, dbo.GetPromosUsed (ixCustomer) as 'Promos'
from [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] --  1,047
order by 
ixCustomer 
--LEN(dbo.GetPromosUsed (ixCustomer)) desc


select * from tblPromoCodeMaster
where ixPromoId between '850' and '870' --in ('854','855','856','859')
order by dtStartDate


SELECT ixCustomer,, dbo.GetPromosUsed (ixCustomer) as 'Promos'
from [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] --  1,047
order by 
ixCustomer 


-- Count of Orders that qualified for the $63 free shipping offer
SELECT MB.*, isnull(FS.OrderCnt,0) FSOrders
FROM [SMITemp].dbo.[PJC_SMIHD_2965_MultiBuyers] MB
    LEFT JOIN (SELECT O.ixCustomer, COUNT(O.ixOrder) 'OrderCnt'
                    from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.dtOrderDate between '11/20/2015' and '12/01/2015'
                    and O.mMerchandise > 63 -- requirement for free shipping
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.mShipping = 0
                group by O.ixCustomer
                ) FS on MB.ixCustomer = FS.ixCustomer
--WHERE isnull(FS.OrderCnt,0) > MB.OrdersPlaced                
ORDER BY MB.ixCustomer



SELECT * FROM tblOrder O
where ixCustomer in ('26807','315206','765447','832615','1875225','2115357')
AND  O.sOrderStatus = 'Shipped'
                    and O.dtOrderDate between '11/20/2015' and '12/01/2015'
ORDER BY O.ixCustomer
