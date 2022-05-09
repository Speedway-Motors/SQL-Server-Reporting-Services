-- Case 22885 - WV customers with a count of returns greater than count of orders past 24 months

-- STARTING POOL - WV customers with orders past 24 months
-- drop table [SMITemp].dbo.PJC_22885_WVCusts24Mo
SELECT distinct ixCustomer  -- 2,409
into [SMITemp].dbo.PJC_22885_WVCusts24Mo
from tblOrder
where dtOrderDate >= '05/29/2012' 
    and ixCustomer <> '1692730' -- Customer last name = ROD RUN PROMO   !!! WTF!?!
    and sShipToState = 'WV'
    and sOrderStatus IN ('Shipped','Open')
    and ixCustomer IN (-- has at least one CM from the last 24 Months
                       select distinct ixCustomer 
                       from tblCreditMemoMaster 
                       where dtCreateDate >= '05/29/2012'   
                          and flgCanceled = 0)


-- DETAILS
SELECT CM.ixCustomer, C.sCustomerFirstName, C.sCustomerLastName,  --      283 Custs
       C.sCustomerType, C.ixCustomerType, C.flgTaxable, C.iPriceLevel, 
       C.sMailToCity, C.sMailToState, C.dtAccountCreateDate, 
       CM.CMMCount,   --      468 CMs
       O.OrdCount,     --    4,778 Orders
       O.Sales,
       CM.TotCredits
FROM tblCustomer C
    join (-- WV custs with Credit Memos
           select WV.ixCustomer,   -- 284 customers with 468 CMs
                COUNT(distinct CMM.ixCreditMemo) CMMCount,
                SUM(CMM.mMerchandise) TotCredits
            from [SMITemp].dbo.PJC_22885_WVCusts24Mo WV
                join tblCreditMemoMaster CMM on WV.ixCustomer = CMM.ixCustomer 
            where CMM.dtCreateDate >= '05/29/2012'   
                and CMM.flgCanceled = 0
            group by WV.ixCustomer 
        ) CM ON C.ixCustomer = CM.ixCustomer
left join
        (-- WV custs with Orders
        select WV.ixCustomer, -- 2,410 Customers with 9,424 orders
            COUNT(O.ixOrder) OrdCount,
            SUM(O.mMerchandise) Sales
         from [SMITemp].dbo.PJC_22885_WVCusts24Mo WV
            join tblOrder O on WV.ixCustomer = O.ixCustomer
         where O.dtOrderDate >= '05/29/2012'  
         and sOrderStatus IN ('Shipped','Open')
         group by WV.ixCustomer
         ) O on CM.ixCustomer = O.ixCustomer
--WHERE CM.CMMCount >= O.OrdCount
ORDER BY O.OrdCount desc         






SELECT CM.ixCustomer, --      283 Custs
       CM.CMMCount,   --      468 CMs
       O.OrdCount     --    4,778 Orders
FROM (-- WV custs with Credit Memos
       select WV.ixCustomer,   -- 284 customers with 468 CMs
            COUNT(distinct CMM.ixCreditMemo) CMMCount,
        from [SMITemp].dbo.PJC_22885_WVCusts24Mo WV
            join tblCreditMemoMaster CMM on WV.ixCustomer = CMM.ixCustomer 
        where CMM.dtCreateDate >= '05/29/2012'   
            and CMM.flgCanceled = 0
        group by WV.ixCustomer
        ) CM
left join
        (-- WV custs with Orders
        select WV.ixCustomer, -- 2,410 Customers with 9,424 orders
            COUNT(O.ixOrder) OrdCount
         from [SMITemp].dbo.PJC_22885_WVCusts24Mo WV
            join tblOrder O on WV.ixCustomer = O.ixCustomer
         where O.dtOrderDate >= '05/29/2012'  
         and sOrderStatus IN ('Shipped','Open')
         group by WV.ixCustomer
         ) O on CM.ixCustomer = O.ixCustomer
--WHERE CM.CMMCount >= O.OrdCount
ORDER BY O.OrdCount desc   


select * from tblCustomer where ixCustomer in ('746028','1857255','386465','1155856','1034425','645701','594439','1627940','1481952','157667')

select * from tblCustomer where ixCustomer = '1692730'


-- (3:25 PM) Alaina: 
SELECT COUNT(DISTINCT ixOrder) AS OrderCount 
     , ISNULL(Credits.CreditCount,0) AS CreditCount 
     , Credits.TotCredits
     , SUM(O.mMerchandise) TotSales
     , (COUNT(DISTINCT ixOrder)) - ISNULL(Credits.CreditCount,0) AS Diff 
     , ISNULL(O.ixCustomer,Credits.ixCustomer) AS Customer 
FROM tblOrder O 
LEFT JOIN (SELECT COUNT(DISTINCT ixCreditMemo) AS CreditCount 
                , SUM(CMM.mMerchandise) AS TotCredits
                , CMM.ixCustomer 
		   FROM tblCreditMemoMaster CMM
           LEFT JOIN  tblOrder O ON O.ixOrder = CMM.ixOrder
		   WHERE sShipToState = 'WV' 
             AND flgCanceled = 0 
			 AND sOrderStatus IN ('Shipped', 'Open') 
			 AND dtCreateDate >=  '05/29/2012' 
		   GROUP BY CMM.ixCustomer 
          ) Credits ON Credits.ixCustomer = O.ixCustomer 
WHERE sShipToState = 'WV'
  AND sOrderStatus IN ('Shipped', 'Open') 
  AND dtShippedDate >=  '05/29/2012' 
GROUP BY ISNULL(Credits.CreditCount,0) 
       , ISNULL(O.ixCustomer,Credits.ixCustomer)  
            , Credits.TotCredits   
HAVING ISNULL(Credits.CreditCount,0) >= 1   
and    ISNULL(Credits.CreditCount,0) >= COUNT(DISTINCT ixOrder) 
ORDER BY Diff 


SELECT * FROM tblCustomer where ixCustomer in ( '1662270','1553257','1329258') 
select * from tblCustomerType where ixCustomerType = '96'

select * from tblCustomer where sMailToState = 'WV' AND ixCustomerType = '96'

select * from tblCustomer where sEmailAddress like '%AUTOGROUP@AOL.COM'


select * --SKU.ixSKU, SKU.sDescription, SKU.flgIntangible
from tblOrderLine OL
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where ixCustomer in ( '1662270','1553257','1329258','1197362') 
and mExtendedPrice > 0



select * --SKU.ixSKU, SKU.sDescription, SKU.flgIntangible
from tblOrderLine OL
    join tblSKU SKU on OL.ixSKU = SKU.ixSKU
where --ixCustomer in ( '220054','226317','1060634','1109266','1197362','1248560') 
--and 
OL.ixSKU in ('91667917-CHR','91667918-CHR','5721010','9300302','2474440')
and ixOrder in (select ixOrder from tblCreditMemoMaster CMM where CMM.dtCreateDate >= '05/29/2012'   
            and CMM.flgCanceled = 0)
and ixCustomer NOT in  ( '1662270','1553257','1329258','1197362') 

and mExtendedPrice > 0





/********** ALAINA'S CODE MODIFIED WITH CCC REQUESTS ******/
SELECT ISNULL(Credits.CreditCount,0) AS CreditCount 
     , COUNT(DISTINCT ixOrder) AS OrderCount 
     ,NULL 'PlaceHolder'
     , ISNULL(Credits.TotCredits,0) AS TotCredits
     , SUM(O.mMerchandise) TotSales
     ,NULL 'PlaceHolder2'
     , (ISNULL(Credits.TotCredits,0)) - (SUM(O.mMerchandise)) AS SalesDiff
     , (COUNT(DISTINCT ixOrder)) - ISNULL(Credits.CreditCount,0) AS OrderDiff 
     , ISNULL(O.ixCustomer,Credits.ixCustomer) AS Customer ,
C.sCustomerFirstName, C.sCustomerLastName,  --      283 Custs
       C.sCustomerType, C.ixCustomerType, C.flgTaxable, C.iPriceLevel, 
       C.sMailToCity, C.sMailToState   
       ,C.sMailToCountry, C.dtAccountCreateDate 
FROM tblOrder O 
    join tblCustomer C on O.ixCustomer = C.ixCustomer
LEFT JOIN (SELECT COUNT(DISTINCT ixCreditMemo) AS CreditCount 
                , SUM(CMM.mMerchandise) AS TotCredits
                , CMM.ixCustomer 
		   FROM tblCreditMemoMaster CMM
           LEFT JOIN  tblOrder O ON O.ixOrder = CMM.ixOrder
		   WHERE sShipToCountry = 'US' 
		     AND O.sMethodOfPayment IN ('PAYPAL','PP-AUCTION')
             AND flgCanceled = 0 
			 AND sOrderStatus IN ('Shipped', 'Open') 
			 AND dtCreateDate >=  '05/29/2012' 
		   GROUP BY CMM.ixCustomer 
          ) Credits ON Credits.ixCustomer = O.ixCustomer 
WHERE sShipToCountry = 'US'
  AND sOrderStatus IN ('Shipped', 'Open') 
  AND dtShippedDate >=  '05/29/2012' 
  AND O.sMethodOfPayment IN ('PAYPAL','PP-AUCTION')
GROUP BY ISNULL(Credits.CreditCount,0) 
       , ISNULL(O.ixCustomer,Credits.ixCustomer)  
       , ISNULL(Credits.TotCredits,0) 
       ,C.sCustomerFirstName, C.sCustomerLastName,  --      283 Custs
       C.sCustomerType, C.ixCustomerType, C.flgTaxable, C.iPriceLevel, 
       C.sMailToCity, C.sMailToState, C.dtAccountCreateDate  
       ,C.sMailToCountry
     --  , O.sShipToState            
HAVING ISNULL(Credits.CreditCount,0) >= 1   
   AND ISNULL(Credits.CreditCount,0) >=  COUNT(DISTINCT ixOrder) * .5 -- at least 50% ratio  PER chris     -- WRONG!!! SWITCH TO DOLLARS RATIO !!!!!!
   AND ISNULL(Credits.TotCredits,0) > 20 -- MORE THAN $20 IN CREDITS
 --  AND (ISNULL(Credits.TotCredits,0)) - (SUM(O.mMerchandise)) <= 0
ORDER BY SalesDiff DESC
       , ISNULL(O.ixCustomer,Credits.ixCustomer)
       
       
       
select distinct sMethodOfPayment from tblOrder    
where    dtShippedDate >=  '05/29/2012' 