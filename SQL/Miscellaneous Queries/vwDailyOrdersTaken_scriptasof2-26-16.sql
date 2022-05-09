USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyOrdersTaken]    Script Date: 02/26/2016 12:05:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [dbo].[vwDailyOrdersTaken] as
select  D.dtDate,D.iPeriodYear,D.iPeriod,iDayOfFiscalPeriod,iDayOfFiscalYear,
        (case
            when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)   
            when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay/Auction'
            when O.sOrderChannel = 'AMAZON' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Amazon'            
            when CUST.sCustomerType = 'MRR' then 'MRR'
            when CUST.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end) OrdChan,
         (case
            when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then '15'
                                                                                                                           else '10'
                                                                                                                           end)   
            when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '20'
            when O.sOrderChannel = 'AMAZON' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '25'                   
            when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '40'
            when CUST.sCustomerType = 'MRR' then '50'
            when CUST.sCustomerType = 'PRS' then '60'
            else '30'
         end) SortOrd,
        (case
            when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
            else 'Retail'
         end) Division,
          sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) DailyNumOrds,  -- WE COUNT BACKORDERS MERCH, but we DON'T COUNT BACKORDERS as a new order!!!!!!
          sum(O.mMerchandise) DailySales,
          sum(O.mShipping) DailyShipping
    from
          tblOrder O
          left join tblDate D           on O.ixOrderDate = D.ixDate
          left join tblCustomer CUST    on O.ixCustomer = CUST.ixCustomer            
    where 
          D.dtDate >= '01/01/2012'  
          and O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
          and O.sOrderType <> 'Internal'
    group by
        D.dtDate,D.iPeriodYear,D.iPeriod,iDayOfFiscalPeriod,iDayOfFiscalYear,
        (case
            when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then 'WEB-Mobile'
                                                                                                                           else 'WEB'
                                                                                                                           end)
            when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Counter'
            when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Ebay/Auction'
            when O.sOrderChannel = 'AMAZON' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then 'Amazon'               
            when CUST.sCustomerType = 'MRR' then 'MRR'
            when CUST.sCustomerType = 'PRS' then 'PRS'
            else 'Catalog'
         end),
         (case
            when O.sOrderChannel = 'WEB' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then (Case when O.flgDeviceType like 'MOBILE%' then '15'
                                                                                                                           else '10'
                                                                                                                           end)
            when O.sOrderChannel = 'AUCTION' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '20'
            when O.sOrderChannel = 'AMAZON' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '25'              
            when O.sOrderChannel = 'COUNTER' and (CUST.sCustomerType not in ('MRR','PRS') or CUST.sCustomerType is null) then '40'
            when CUST.sCustomerType = 'MRR' then '50'
            when CUST.sCustomerType = 'PRS' then '60'
            else '30'
         end),
        (case
            when CUST.sCustomerType in ('MRR','PRS') then 'Wholesale'
            else 'Retail'
         end)


-- select * from vwDailyOrdersTaken where dtDate = '02/25/2015' and Division = 'Retail' order by SortOrd





GO


