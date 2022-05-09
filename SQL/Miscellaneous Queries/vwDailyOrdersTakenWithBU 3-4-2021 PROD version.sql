USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyOrdersTakenWithBU]    Script Date: 3/5/2021 1:04:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwDailyOrdersTakenWithBU] as

select  D.dtDate,D.iPeriodYear,D.iPeriod,iDayOfFiscalPeriod,iDayOfFiscalYear,
        (--ORDER CHANNEL or BU
        CASE   when O.ixBusinessUnit = 101 then 'Intercompany'   --1
                when O.ixBusinessUnit = 103 then 'Employee'                 --2
                when O.ixBusinessUnit = 102 then 'Internal Use'    --3
                when O.ixBusinessUnit = 104 then 'Pro Racer'                --4
                when O.ixBusinessUnit = 105 then 'Mr Roadster'              --5
                when O.ixBusinessUnit = 111 then 'Retail - Tolleson'  --6
                when O.ixBusinessUnit = 106 then 'Retail - Lincoln'  --7
                when O.ixBusinessUnit = 113 then 'Trade Show'               --8
                when O.ixBusinessUnit = 107 then 'WEB'     --9
                when O.ixBusinessUnit = 108 then 'Garage Sale'           --10
                when O.ixBusinessUnit = 109 then 'Marketplaces' -- 11
                ELSE 'Phone' -- 10
            END) OrdChan,
        (-- SubBU
        CASE   when O.ixBusinessUnit = 101 then ''   --1
                when O.ixBusinessUnit = 103 then ''       --2
                when O.ixBusinessUnit = 102 then ''   --3
                when O.ixBusinessUnit = 104 then ''                --4
                when O.ixBusinessUnit = 105 then ''              --5
                when O.ixBusinessUnit = 111 then ''  --6
                when O.ixBusinessUnit = 106 then ''  --7
                when O.ixBusinessUnit = 113 then ''               --8
                when O.ixBusinessUnit = 107 then (Case when O.flgDeviceType like 'MOBILE%' then 'Web – Mobile'
                                                                                                                           else 'Web – Desktop'
                                                                                                                           end)   
                when O.ixBusinessUnit = 108 then ''           --10
                when O.ixBusinessUnit = 109 then (Case when O.sSourceCodeGiven = 'AMAZON' then 'Amazon' 
                                                       when O.sSourceCodeGiven = 'AMAZONPRIME' then 'Amazon SFP'
                                                       when O.sSourceCodeGiven = 'AMAZONFBA' then 'Amazon FBA'
                                                       when O.sSourceCodeGiven = 'EBAY' then 'Ebay'
                                                       when O.sSourceCodeGiven = 'WALMART' then 'Walmart'
                                                  END)
        ELSE ''
          END) SubBU,
         (-- SORT ORDER
         CASE   when O.ixBusinessUnit = 101  then 100 -- 'Intercompany'  
                when O.ixBusinessUnit = 103 then 90 --'Employee'     
                when O.ixBusinessUnit = 102 then 110 -- 'Internal Use' 
                when O.ixBusinessUnit = 104 then 40 --'Pro Racer'   
                when O.ixBusinessUnit = 105 then 50 -- 'Mr Roadster'  
                when O.ixBusinessUnit = 111 then 70 -- 'Counter - TOL' 
                when O.ixBusinessUnit = 106 then 60 --'Counter - LNK' 
                when O.ixBusinessUnit = 113 then 199 
                when O.ixBusinessUnit = 107 then 10 -- 'WEB'  
                when O.ixBusinessUnit = 108 then 80 --'Garage Sale'          
                when O.ixBusinessUnit = 109 then 30 -- 'Marketplace' 
                ELSE 20 --'Phone'
            END) SortOrd,
        (case
            when --O.ixCustomer NOT in ('1770000','2672493') AND 
            (O.ixBusinessUnit = 105 
                     or O.ixBusinessUnit = 104) then 'Wholesale'
            else 'Retail'
         end) Division,
          sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) 'DailyNumOrds',  -- WE COUNT BACKORDERS MERCH, but we DON'T COUNT BACKORDERS as a new order!!!!!!
          sum(O.mMerchandise) 'DailySales',
          sum(O.mMerchandiseCost) 'DailyCoGS',
          (sum(O.mMerchandise)-sum(O.mMerchandiseCost)) 'DailyProductMargin',
          sum(O.mShipping) DailyShipping,
          (sum(O.mMerchandise) +sum(O.mShipping)) 'DailySalesPlusShipping',
          SUM(iTotalShippedPackages) 'PkgsShipped'
    from
          tblOrder O
          left join tblDate D           on O.ixOrderDate = D.ixDate
          left join tblCustomer CUST    on O.ixCustomer = CUST.ixCustomer            
    where D.dtDate >= '01/01/2017'  
        and O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
       -- and O.sOrderType <> 'Internal' -- REMOVE FROM FINAL BU VERSION!
    group by
        D.dtDate,D.iPeriodYear,D.iPeriod,iDayOfFiscalPeriod,iDayOfFiscalYear,
         (--ORDER CHANNEL or BU
            CASE when O.ixBusinessUnit = 101  then 'Intercompany'   --1
                when O.ixBusinessUnit = 103 then 'Employee'                 --2
                when O.ixBusinessUnit = 102 then 'Internal Use'    --3
                when O.ixBusinessUnit = 104 then 'Pro Racer'                --4
                when O.ixBusinessUnit = 105 then 'Mr Roadster'              --5
                when O.ixBusinessUnit = 111 then 'Retail - Tolleson'  --6
                when O.ixBusinessUnit = 106 then 'Retail - Lincoln'  --7
                when O.ixBusinessUnit = 113 then 'Trade Show'               --8
                when O.ixBusinessUnit = 107 then 'WEB'     --9
                when O.ixBusinessUnit = 108 then 'Garage Sale'           --10
                when O.ixBusinessUnit = 109 then 'Marketplaces' -- 11
                ELSE 'Phone' -- 10
            END),
        (-- SubBU
            CASE when O.ixBusinessUnit = 101 then ''   --1
                when O.ixBusinessUnit = 103 then ''       --2
                when O.ixBusinessUnit = 102 then ''   --3
                when O.ixBusinessUnit = 104 then ''                --4
                when O.ixBusinessUnit = 105 then ''              --5
                when O.ixBusinessUnit = 111 then ''  --6
                when O.ixBusinessUnit = 106 then ''  --7
                when O.ixBusinessUnit = 113 then ''               --8
                when O.ixBusinessUnit = 107 then (Case when O.flgDeviceType like 'MOBILE%' then 'Web – Mobile'
                                                                                                                           else 'Web – Desktop'
                                                                                                                           end)   
                when O.ixBusinessUnit = 108 then ''           --10
                when O.ixBusinessUnit = 109 then (Case when O.sSourceCodeGiven = 'AMAZON' then 'Amazon' 
                                                                                                when O.sSourceCodeGiven = 'AMAZONPRIME' then 'Amazon SFP'
                                                                                                when O.sSourceCodeGiven = 'AMAZONFBA' then 'Amazon FBA'
                                                                                                when O.sSourceCodeGiven = 'EBAY' then 'Ebay'
                                                                                                when O.sSourceCodeGiven = 'WALMART' then 'Walmart'
                                                                                            END)
          ELSE ''
          END),
         (-- SORT ORDER
         CASE   when O.ixBusinessUnit = 101  then 100 -- 'Intercompany'    
                when O.ixBusinessUnit = 103 then 90 --'Employee'     
                when O.ixBusinessUnit = 102 then 110 -- 'Internal Use' 
                when O.ixBusinessUnit = 104 then 40 --'Pro Racer'   
                when O.ixBusinessUnit = 105 then 50 -- 'Mr Roadster'  
                when O.ixBusinessUnit = 111 then 70 -- 'Counter - TOL' 
                when O.ixBusinessUnit = 106 then 60 --'Counter - LNK' 
                when O.ixBusinessUnit = 113 then 199   
                when O.ixBusinessUnit = 107 then 10 -- 'WEB'
                when O.ixBusinessUnit = 108 then 80 --'Garage Sale'          
                when O.ixBusinessUnit = 109 then 30 -- 'Marketplace' 
                ELSE 20 --'Phone'
            END) ,
        (case
            when --O.ixCustomer NOT in ('1770000','2672493') AND 
                    (O.ixBusinessUnit = 105  
                     or O.ixBusinessUnit = 104) then 'Wholesale'
            else 'Retail'
         end)
GO


