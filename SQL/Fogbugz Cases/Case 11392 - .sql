/*********
 Aliases
 G = Gross
 R = Returns
 N = Net -- will be calculated in the report as G - R
 
 WE NEED TO DECIDE IF WE WANT TO ROLL UP SOME CATEGORIES INTO OTHERS
 E.G. ROLL UP ORDER CHANNELS EBAY INTO AUCTION AND TRADESHOW INTO SOMETHING ELSE?
      ROLL UP MRR & PRS INTO WHOLESALE (MY VOTE WOULD BE TO LEAVE THEM SPLIT OUT, WE ALREADY HAVE ANOTHER TYPE OF "OTHER" ANYHOW
      ROLL UP VARIOUS CATALOG SOURCE CODE TYPES INTO JUST "CATALOG" TYPE, ETC.
 *********/
 
 
-- Sales by ORDER CHANNEL
SELECT distinct O.sOrderChannel, -- CASE STATEMENT HERE IF WE WILL ROLL ANYTHING UP TO ROLL UP
    isnull(G.GMerchSales,0) AS GMerchSales,
    isnull(G.GMerchCost,0)  AS GMerchCost,
    isnull(R.RMerchSales,0) AS RMerchSales,
    isnull(R.RMerchCost,0)  AS RMerchCost,
    isnull(G.OrdCount,0)    AS OrdCount
FROM tblOrder O
             -- GROSS  a.k.a. Sales
   left join (  SELECT O.sOrderChannel, 
                    SUM(O.mMerchandise)     AS GMerchSales, 
                    SUM(O.mMerchandiseCost) AS GMerchCost,
                    SUM(case when O.ixOrder like '%-%' then 0
                          else 1
                          end)              AS OrdCount  -- NOT counting backorders as new orders
                FROM tblOrder O
                WHERE O.dtShippedDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderStatus = 'Shipped'
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                     and O.mMerchandise > 0 
                group by O.sOrderChannel
              ) G on O.sOrderChannel = G.sOrderChannel
              -- RETURNS
    left join (SELECT O.sOrderChannel,
                    SUM(CMM.mMerchandise)     RMerchSales, 
                    SUM(CMM.mMerchandiseCost) RMerchCost
                FROM tblCreditMemoMaster CMM
                    join tblOrder O on CMM.ixOrder = O.ixOrder  
                WHERE CMM.dtCreateDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                group by O.sOrderChannel
               )R on R.sOrderChannel = O.sOrderChannel          
WHERE O.sOrderChannel <> 'INTERNAL'
order by O.sOrderChannel

select * from [LNK-DW1].[SMI Reporting].dbo.tblLatestFeed


-- Sales by Wholesale/Retail
SELECT distinct C.sCustomerType,
    isnull(G.GMerchSales,0) AS GMerchSales,
    isnull(G.GMerchCost,0)  AS GMerchCost,
    isnull(R.RMerchSales,0) AS RMerchSales,
    isnull(R.RMerchCost,0)  AS RMerchCost,
    isnull(G.OrdCount,0)    AS OrdCount
FROM tblCustomer C
             -- GROSS  a.k.a. Sales
   left join (  SELECT C.sCustomerType, 
                    SUM(O.mMerchandise)     AS GMerchSales, 
                    SUM(O.mMerchandiseCost) AS GMerchCost,
                    SUM(case when O.ixOrder like '%-%' then 0
                          else 1
                          end)              AS OrdCount  -- NOT counting backorders as new orders
                FROM tblOrder O
                    join tblCustomer C on O.ixCustomer = C.ixCustomer
                WHERE O.dtShippedDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderStatus = 'Shipped'
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                     and O.mMerchandise > 0 
                group by C.sCustomerType
              ) G on C.sCustomerType = G.sCustomerType
              -- RETURNS
    left join (SELECT C.sCustomerType,
                    SUM(CMM.mMerchandise)     RMerchSales, 
                    SUM(CMM.mMerchandiseCost) RMerchCost
                FROM tblCreditMemoMaster CMM
                    join tblOrder O on CMM.ixOrder = O.ixOrder 
                    join tblCustomer C on O.ixCustomer = C.ixCustomer                     
                WHERE CMM.dtCreateDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                group by C.sCustomerType
               )R on R.sCustomerType = C.sCustomerType          
order by C.sCustomerType






-- Sales by SourceCode Type
SELECT distinct SC.sSourceCodeType, -- investigate single NULL value
    isnull(G.GMerchSales,0) AS GMerchSales,
    isnull(G.GMerchCost,0)  AS GMerchCost,
    isnull(R.RMerchSales,0) AS RMerchSales,
    isnull(R.RMerchCost,0)  AS RMerchCost,
    isnull(G.OrdCount,0)    AS OrdCount
FROM tblSourceCode SC
             -- GROSS  a.k.a. Sales
   left join (  SELECT SC.sSourceCodeType, 
                    SUM(O.mMerchandise)     AS GMerchSales, 
                    SUM(O.mMerchandiseCost) AS GMerchCost,
                    SUM(case when O.ixOrder like '%-%' then 0
                          else 1
                          end)              AS OrdCount  -- NOT counting backorders as new orders
                FROM tblOrder O
                    join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode
                WHERE O.dtShippedDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderStatus = 'Shipped'
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                     and O.mMerchandise > 0 
                group by SC.sSourceCodeType
              ) G on SC.sSourceCodeType = G.sSourceCodeType
              -- RETURNS
    left join (SELECT SC.sSourceCodeType,
                    SUM(CMM.mMerchandise)     RMerchSales, 
                    SUM(CMM.mMerchandiseCost) RMerchCost
                FROM tblCreditMemoMaster CMM
                    join tblOrder O on CMM.ixOrder = O.ixOrder 
                    join tblSourceCode SC on O.sMatchbackSourceCode = SC.ixSourceCode                
                WHERE CMM.dtCreateDate between '01/01/2010' and '12/31/2010' -- @StartDate and @EndDate
                     and O.sOrderType <> 'Internal'
                     and O.sOrderChannel <> 'INTERNAL'
                group by SC.sSourceCodeType
               )R on R.sSourceCodeType = SC.sSourceCodeType          
order by SC.sSourceCodeType



sp_who2