-- INITIAL Temp Table 
select O.ixCustomer, 
    count(OL.ixSKU) GCcount, -- should sum up to 1,388v
    min(O.dtOrderDate)      as MinGCOrderDate, 
    sum(O.mMerchandise)     as TotMerch, 
    sum(O.mMerchandiseCost) as TotMerchCost -- these two will be sums
   
-- DROP TABLE PJC_16868_InitialTable   
-- INTO PJC_16868_InitialTable
FROM [SMI Reporting].dbo.tblOrder O
LEFT JOIN [SMI Reporting].dbo.tblOrderLine OL ON OL.ixOrder = O.ixOrder 
WHERE O.dtOrderDate between '11/01/2011' and '12/16/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType NOT IN ('Internal','Customer Service')
    and O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and (OL.ixSKU like 'GIFT%' 
         OR OL.ixSKU = 'EGIFT')
    and O.ixCustomer <> '707952'  
-- CHECK TO SEE IF NOT IN GCM    
--AND O.ixOrder NOT IN (select ixOrder from  [SMI Reporting].dbo.tblGiftCardMaster)   
/* GC NOT in GCM
ixCustomer	GCcount	MinGCOrderDate	TotMerch	TotMerchCost
148244	1	2011-12-12 00:00:00.000	25.00	0.00
483030	1	2011-12-12 00:00:00.000	25.00	0.00
1030928	1	2011-12-12 00:00:00.000	25.00	0.00
704224	1	2011-12-12 00:00:00.000	25.00	0.00
*/
   and O.ixOrder NOT IN ('4896740','4895740','4895749','4895742')
GROUP BY  O.ixCustomer   
ORDER BY GCcount DESC

select count(distinct ixCustomer) from PJC_16868_InitialTable -- 1,265



/* 2nd Temp Table
Need to find the first day of orders place by people in the 1st table 
AFTER their MinGCOrderDate
*/
select O.ixCustomer, 
   Min(O.dtOrderDate) as MinNextOrderDate -- these two will be sums
-- DROP TABLE PJC_16868_NextOrderDates   
INTO PJC_16868_NextOrderDates 
from [SMI Reporting].dbo.tblOrder O
    join PJC_16868_InitialTable IT on O.ixCustomer = IT.ixCustomer
WHERE O.dtOrderDate > IT.MinGCOrderDate
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType NOT IN ('Internal','Customer Service')
    and O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
GROUP BY   O.ixCustomer  
   







-- final table
SELECT
    IT.ixCustomer, IT.MinGCOrderDate, -- 1,265
    IT.TotMerch, IT.TotMerchCost,
    NOD.MinNextOrderDate,
    NULL as NOMerch, 
    NULL as NOMerchCost -- <-- these two will be sums
INTO PJC_16868_FinalTable  
from PJC_16868_InitialTable IT
    left join PJC_16868_NextOrderDates NOD on IT.ixCustomer = NOD.ixCustomer
    

-- Next Order Date summary table
select O.ixCustomer,
    sum(O.mMerchandise)     as NOMerch, 
    sum(O.mMerchandiseCost) as NOMerchCost
into PJC_16868_NextOrderSummary
from [SMI Reporting].dbo.tblOrder O
    join PJC_16868_FinalTable FIN on O.ixCustomer = FIN.ixCustomer
WHERE O.dtOrderDate = FIN.MinNextOrderDate
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType NOT IN ('Internal','Customer Service')
    and O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
GROUP BY   O.ixCustomer      

update A
set NOMerch = B.NOMerch,
    NOMerchCost = B.NOMerchCost
from PJC_16868_FinalTable A
  join PJC_16868_NextOrderSummary B on A.ixCustomer = B.ixCustomer 

update A 
set COLUMN = B.COLUMN
from FIRSTTABLE A
 join SECONDTABLE B on A.XXX = B.XXX



select * from  PJC_16868_FinalTable

select * from PJC_16868_FinalTable where MinGCOrderDate >= MinNextOrderDate
   



/********************************
  GIFT REDEMPTION INFO
********************************/

-- GC sold during 2011 timeframe
select GCM.ixGiftCard, --  1,388
    GCM.ixOrder, 
    GCM.mAmountIssued, 
    GCM.mAmountOutstanding,
    O.ixCustomer,
    OL.ixSKU,
    SKU.sDescription
from [SMI Reporting].dbo.tblGiftCardMaster GCM
    join [SMI Reporting].dbo.tblOrder O on GCM.ixOrder = O.ixOrder
    join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = OL.ixSKU
where O.dtOrderDate between '11/01/2011' and '12/16/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType NOT IN ('Internal','Customer Service')
    and O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and (OL.ixSKU like 'GIFT%' 
         OR OL.ixSKU = 'EGIFT')
    and O.ixCustomer <> '707952'
order by mAmountOutstanding
-- SKU.sDescription    
    
    
    
-- GC sold during 2011 timeframe that were partially or fully used
select GCM.ixGiftCard, --  1,046 
    GCM.ixOrder, 
    GCM.mAmountIssued, 
    GCM.mAmountOutstanding,
    O.ixCustomer,
    OL.ixSKU,
    SKU.sDescription
from [SMI Reporting].dbo.tblGiftCardMaster GCM
    join [SMI Reporting].dbo.tblOrder O on GCM.ixOrder = O.ixOrder
    join [SMI Reporting].dbo.tblOrderLine OL on O.ixOrder = OL.ixOrder
    left join [SMI Reporting].dbo.tblSKU SKU on SKU.ixSKU = OL.ixSKU
where O.dtOrderDate between '11/01/2011' and '12/16/2011'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType NOT IN ('Internal','Customer Service')
    and O.sOrderChannel NOT IN ('INTERNAL','TRADESHOW')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and (OL.ixSKU like 'GIFT%' 
         OR OL.ixSKU = 'EGIFT')
    and O.ixCustomer <> '707952'         
    and mAmountOutstanding <> mAmountIssued
order by mAmountOutstanding
-- (mAmountIssued - mAmountOutstanding) desc
-- SKU.sDescription        




/*************************************
-- ALAINA'S ORIG CODE
******************************************/