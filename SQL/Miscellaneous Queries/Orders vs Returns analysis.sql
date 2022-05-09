-- Orders vs Returns analysis

DECLARE
        @StartDate datetime,
        @EndDate datetime
SELECT
       @StartDate = '10/30/12' ,-- 0-12mo = '10/30/12'  13-24mo = '10/30/11' 
       @EndDate = '10/29/13'    -- 0-12mo = '10/29/13'  13-24mo = '10/29/12'

/*****************************************/
/***** RETAIL AND WHOLESALE COMBINED *****/
/*****************************************/
    /****** SALES *******/
    --  ORDER level info
    SELECT SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 -- excludes BackOrders
               ELSE 1
               END) OrderCount
        ,SUM(O.mMerchandise) AS Sales
    FROM tblOrder O
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.sOrderStatus = 'Shipped' 
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
      and O.mMerchandise > 0 -- > 1 if looking at non-US orders
      

     -- ORDERLINE level info 
    SELECT Count(OL.ixOrder) OLCount
       ,SUM(OL.iQuantity) SKUQtyCount
    FROM tblOrderLine OL
       left join tblOrder O on O.ixOrder = OL.ixOrder
       left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.sOrderStatus = 'Shipped' 
      and OL.flgLineStatus in ('Shipped','Dropshipped')
      and OL.flgKitComponent = 0
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
      and O.mMerchandise > 0
      and SKU.flgIntangible = 0 

    /****** RETURNS *******/
    -- MASTER level
    SELECT count(CMM.ixCreditMemo) CMcount
        ,SUM(CMM.mMerchandise) AS ReturnSales
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0'
      and CMM.mMerchandise > 0
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC        

    -- DETAIL level
    SELECT count(CMD.ixCreditMemoLine) CMLineCount
        ,SUM(CMD.iQuantityCredited) SKUCountCredited
       -- ,SUM(CMD.iQuantityReturned) SKUCountReturned -- total BS data
    FROM tblCreditMemoDetail CMD
        left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
        left join tblSKU SKU on CMD.ixSKU = SKU.ixSKU
        left join tblOrder O on CMM.ixOrder = O.ixOrder        
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0' 
      and CMM.mMerchandise > 0 
      and (CMM.sMemoTransactionType is NULL
           OR CMM.sMemoTransactionType = 'Return')
      and SKU.flgIntangible = 0 
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC        
      


  
/*****************************************/
/*****         WHOLESALE ONLY        *****/
/*****************************************/

DECLARE
       @StartDate datetime,
       @EndDate datetime
SELECT
       @StartDate = '10/30/12' ,-- 0-12mo = '10/30/12'  13-24mo = '10/30/11' 
       @EndDate = '10/29/13'    -- 0-12mo = '10/29/13'  13-24mo = '10/29/12'
       
         /****** SALES *******/
    --  ORDER level info
    SELECT SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 -- excludes BackOrders
               ELSE 1
               END) OrderCount
        ,SUM(O.mMerchandise) AS Sales
    FROM tblOrder O
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.ixOrderType in ('PRS','MR')
      and O.sOrderStatus = 'Shipped' 
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
      and O.mMerchandise > 0 -- > 1 if looking at non-US orders

     -- ORDERLINE level info 
    SELECT Count(OL.ixOrder) OLCount
       ,SUM(OL.iQuantity) SKUQtyCount
    FROM tblOrderLine OL
       left join tblOrder O on O.ixOrder = OL.ixOrder
       left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.ixOrderType in ('PRS','MR')    
      and O.sOrderStatus = 'Shipped' 
      and OL.flgLineStatus in ('Shipped','Dropshipped')
      and OL.flgKitComponent = 0
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
      and O.mMerchandise > 0
      and SKU.flgIntangible = 0 

    /****** RETURNS *******/
    -- MASTER level
    SELECT count(CMM.ixCreditMemo) CMcount
        ,SUM(CMM.mMerchandise) AS ReturnSales
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder    
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0'
      and CMM.mMerchandise > 0
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
      and O.ixOrderType in ('PRS','MR')  
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC             

    -- DETAIL level
    SELECT count(CMD.ixCreditMemoLine) CMLineCount
        ,SUM(CMD.iQuantityCredited) SKUCountCredited
       -- ,SUM(CMD.iQuantityReturned) SKUCountReturned -- total BS data
    FROM tblCreditMemoDetail CMD
        left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
        left join tblSKU SKU on CMD.ixSKU = SKU.ixSKU
        left join tblOrder O on CMM.ixOrder = O.ixOrder
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0' 
      and CMM.mMerchandise > 0 
      and (CMM.sMemoTransactionType is NULL
           OR CMM.sMemoTransactionType = 'Return')
      and SKU.flgIntangible = 0 
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC 
      and O.ixOrderType in ('PRS','MR') 
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC           
      
      
      
/*****************************************/
/*****     RETAIL by Order Channel   *****/
/*****************************************/

DECLARE
        @StartDate datetime,
        @EndDate datetime

SELECT
       @StartDate = '10/30/11' ,-- 0-12mo = '10/30/12'  13-24mo = '10/30/11' 
       @EndDate = '10/29/12'    -- 0-12mo = '10/29/13'  13-24mo = '10/29/12'


SELECT ISNULL(S.sOrderChannel,SOL.sOrderChannel) as 'OrderChannel'
    , S.OrderCount as 'Orders'
    , SOL.OLCount as 'OrderLines'       
    , SOL.SKUQtyCount as 'SKUQtyCount'
    , S.Sales as 'Sales'
FROM     
    /****** SALES *******/
    --  ORDER level info
    (SELECT O.sOrderChannel
        ,SUM(CASE WHEN O.ixOrder LIKE '%-%' THEN 0 -- excludes BackOrders
               ELSE 1
               END) OrderCount
        ,SUM(O.mMerchandise) AS Sales
    FROM tblOrder O
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.ixOrderType NOT in ('PRS','MR')
      and O.sOrderStatus = 'Shipped' 
      and O.sOrderType <> 'Internal'   -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL' -- exclude per CCC 
      and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    GROUP BY O.sOrderChannel     
    --ORDER BY O.sOrderChannel
    ) S -- S = SALES

FULL OUTER JOIN
    (-- ORDERLINE level info 
    SELECT O.sOrderChannel
        , Count(OL.ixOrder) OLCount
       ,SUM(OL.iQuantity) SKUQtyCount
    FROM tblOrderLine OL
       left join tblOrder O on O.ixOrder = OL.ixOrder
       left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
    WHERE O.dtShippedDate BETWEEN @StartDate AND @EndDate 
      and O.ixOrderType NOT in ('PRS','MR')    
      and O.sOrderStatus = 'Shipped' 
      and OL.flgLineStatus in ('Shipped','Dropshipped')
      and OL.flgKitComponent = 0
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
      and O.mMerchandise > 0
      and SKU.flgIntangible = 0 
    GROUP BY O.sOrderChannel     
    --ORDER BY O.sOrderChannel
    ) SOL ON S.sOrderChannel = SOL.sOrderChannel -- SOL = SALES ORDER LINE (no really.. that's what it means)
ORDER BY 'OrderChannel'    
    
    /****** RETURNS *******/
    -- MASTER level
    SELECT O.sOrderChannel
        ,  count(CMM.ixCreditMemo) CMcount
        ,SUM(CMM.mMerchandise) AS ReturnSales
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder    
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0'
      and CMM.mMerchandise > 0
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC  
      and O.ixOrderType NOT in ('PRS','MR')
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC               
    GROUP BY O.sOrderChannel     
    ORDER BY O.sOrderChannel      

    -- DETAIL level
    SELECT O.sOrderChannel
        ,  count(CMD.ixCreditMemoLine) CMLineCount
        ,SUM(CMD.iQuantityCredited) SKUCountCredited
       -- ,SUM(CMD.iQuantityReturned) SKUCountReturned -- total BS data
    FROM tblCreditMemoDetail CMD
        left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
        left join tblSKU SKU on CMD.ixSKU = SKU.ixSKU
        left join tblOrder O on CMM.ixOrder = O.ixOrder
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0' 
      and CMM.mMerchandise > 0 
      and (CMM.sMemoTransactionType is NULL
           OR CMM.sMemoTransactionType = 'Return')
      and SKU.flgIntangible = 0 
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC 
      and O.ixOrderType NOT in ('PRS','MR')   
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC       
    GROUP BY O.sOrderChannel     
    ORDER BY O.sOrderChannel      
      
/*



*/
            
-- verifying ixOrderType is accurate so it can be used to ID MRR and PRS orders      
select dtOrderDate, sSourceCodeGiven
    --, sMatchbackSourceCode
    , ixOrderType
from tblOrder   
where   ixOrderType in  ('PRS','MRR') 
and  sSourceCodeGiven NOT in ('PRS','MRR') 

select sSourceCodeGiven
    --, sMatchbackSourceCode
    , ixOrderType
from tblOrder   
where   sSourceCodeGiven in  ('PRS','MRR') 
and  ixOrderType NOT in ('PRS','MRR') 



select distinct ixOrderType
from tblOrder
order by ixOrderType


select distinct sMemoType
from tblCreditMemoMaster


-- REFEED THESE LATER!!!!
select ixOrder,dtOrderDate 
    -- sSourceCodeGiven
    --, sMatchbackSourceCode
    ,sOrderStatus
    , ixOrderType
    , dtDateLastSOPUpdate
from tblOrder   
where   sSourceCodeGiven in  ('PRS','MRR')
and ixOrderType is NULL
and sOrderStatus = 'Shipped'
and dtDateLastSOPUpdate is NULL
order by dtDateLastSOPUpdate, dtOrderDate


select datepart (yyyy, dtShippedDate) 'year', COUNT(*) from tblOrder
where dtDateLastSOPUpdate is NULL
group by datepart (yyyy, dtShippedDate)

select datepart (yyyy, dtOrderDate) 'year', COUNT(*) from tblOrder
where dtDateLastSOPUpdate is NULL
group by datepart (yyyy, dtOrderDate)
order by 'year'

select MIN(dtOrderDate) from tblOrder
where dtDateLastSOPUpdate is NOT NULL

--JACKED UP RETURNS
DECLARE
        @StartDate datetime,
        @EndDate datetime

SELECT
       @StartDate = '10/30/11' ,-- 0-12mo = '10/30/12'  13-24mo = '10/30/11' 
       @EndDate = '10/29/13'    -- 0-12mo = '10/29/13'  13-24mo = '10/29/12'
       
    /****** RETURNS *******/
    -- MASTER level
    SELECT CMM.ixCreditMemo
    , O.*--count(CMM.ixCreditMemo) CMcount
--,SUM(CMM.mMerchandise) AS ReturnSales
    FROM tblCreditMemoMaster CMM
        left join tblOrder O on CMM.ixOrder = O.ixOrder    
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0'
      and CMM.mMerchandise > 0
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
      and O.ixOrderType is NULL --NOT in ('PRS','MR')        

    -- DETAIL level
    SELECT count(CMD.ixCreditMemoLine) CMLineCount
        ,SUM(CMD.iQuantityCredited) SKUCountCredited
       -- ,SUM(CMD.iQuantityReturned) SKUCountReturned -- total BS data
    FROM tblCreditMemoDetail CMD
        left join tblCreditMemoMaster CMM on CMD.ixCreditMemo = CMM.ixCreditMemo
        left join tblSKU SKU on CMD.ixSKU = SKU.ixSKU
        left join tblOrder O on CMM.ixOrder = O.ixOrder
    WHERE CMM.dtCreateDate BETWEEN @StartDate AND @EndDate 
      and CMM.flgCanceled = '0' 
      and CMM.mMerchandise > 0 
      and (CMM.sMemoTransactionType is NULL
           OR CMM.sMemoTransactionType = 'Return')
      and SKU.flgIntangible = 0 
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC 
      and O.ixOrderType is NULL --NOT in ('PRS','MR')    
      
      
      
-- Avg Delay between Order Shipped and CM being generated
select
O.dtShippedDate, CMM.dtCreateDate, O.ixOrder, CMM.ixCreditMemo, CMM.mMerchandise,
DATEDIFF (d,O.dtShippedDate, CMM.dtCreateDate) DaysApart
from tblOrder O
join tblCreditMemoMaster CMM on O.ixOrder = CMM.ixOrder
where dtShippedDate between '08/01/2012' and '08/01/2013'
      and CMM.flgCanceled = '0'
      and CMM.mMerchandise > 0
      and CMM.ixCreditMemo NOT like 'F%' -- exclude Freestanding CMs per CCC
      and O.sOrderType <> 'Internal'    -- exclude per CCC 
      and O.sOrderChannel <> 'INTERNAL'    -- exclude per CCC 
Order by  DaysApart desc       








