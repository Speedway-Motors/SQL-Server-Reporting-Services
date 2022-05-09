-- SMIHD-20349 - research discrepancies between DOT and Tableau

USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyOrdersTakenWithBU]    Script Date: 3/3/2021 12:22:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDailyOrdersTakenWithBU_ORDERLINECOST] as

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
          --sum(O.mMerchandise) 'DailySales',
          sum(OL.mExtendedPrice) 'DailySales', -- CCC says do not subtract credits because it reduces Margin accuracy
          sum(OL.mExtendedCost) 'DailyCoGS',
          --(sum(O.mMerchandise)-sum(OL.mExtendedCost)) 'DailyProductMargin',
          (sum(OL.mExtendedPrice)-sum(OL.mExtendedCost)) 'DailyProductMargin',
          sum(O.mShipping) DailyShipping,
          --(sum(O.mMerchandise) +sum(O.mShipping)) 'DailySalesPlusShipping',
          (sum(OL.mExtendedPrice) +sum(O.mShipping)) 'DailySalesPlusShipping',
          SUM(iTotalShippedPackages) 'PkgsShipped'
    from    
          tblOrder O
          left join (-- Total ExtendedCost from the OL level
                     SELECT O.ixOrder, SUM(OL.mExtendedPrice) 'mExtendedPrice', SUM(OL.mExtendedCost) 'mExtendedCost'
                     FROM tblOrder O
                        left join tblOrderLine OL on O.ixOrder = OL.ixOrder
                     WHERE O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
                        and OL.flgLineStatus NOT IN ('Cancelled','Cancelled Quote','Quote','Lost','ZeroQty','unknown','fail','Split Order')
                        --and flgLineStatus IN ('Open','Dropshipped','Backordered','Shipped','Backordered FS')
                            and OL.flgKitComponent = 0 
                     GROUP BY O.ixOrder 
                     ) OL on O.ixOrder = OL.ixOrder
          left join tblDate D           on O.ixOrderDate = D.ixDate /*on O.ixInvoiceDate = D.ixDate*/  --   SWITCH BACK TO ORDER DATE AFTER TESTING
          left join tblCustomer CUST    on O.ixCustomer = CUST.ixCustomer            
    where D.dtDate >= '01/01/2017'  
        and O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
       -- and O.sOrderStatus <> 'Backordered' -- TEMP FOR TESTING ONLY
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

select dtOrderDate, ixOrder, ixInvoiceDate, sOrderStatus
from tblOrder
where dtOrderDate = '02/03/21'
and sOrderStatus = 'Backordered'

-- order status types without invoice dates
select sOrderStatus, count(*) 'OrderCount'
from tblOrder
where dtOrderDate = '02/03/21'
    and ixInvoiceDate is NULL
group by sOrderStatus
order by sOrderStatus
/*
sOrder          Order
Status	        Count
===========     =======
Backordered	     96
Cancelled	     80
Cancelled Quote	242
Open	          5
Pick Ticket	     71
*/


-- order status types without invoice dates
select sOrderStatus, count(*) 'OrderCount'
from tblOrder
where dtOrderDate = '02/03/21'
    and ixBusinessUnit is NULL
group by sOrderStatus
order by sOrderStatus
/*
sOrder          Order
Status	        Count
===========     =======
Cancelled	    9
Cancelled Quote	242
Pick Ticket	    71
*/


SELECT * FROM vwDailyOrdersTakenWithBU
WHERE dtDate >= '01/01/21'
order by SortOrd


SELECT dtDate, SUM(DailyNumOrds)
FROM vwDailyOrdersTakenWithBU
WHERE dtDate >= '01/01/21'
GROUP BY dtDate
ORDER BY  SUM(DailyNumOrds)



SELECT * FROM vwDailyOrdersTakenWithBU
WHERE dtDate = '02/03/21'
order by SortOrd

SELECT * FROM [vwDailyOrdersTakenWithBU_ORDERLINECOST]
WHERE dtDate = '02/03/21'
order by SortOrd

SELECT * FROM vwDailyOrdersTakenWithBU
WHERE dtDate = '03/02/21'
order by SortOrd

SELECT * FROM [vwDailyOrdersTakenWithBU_ORDERLINECOST]
WHERE dtDate = '03/02/21'
order by SortOrd

[vwDailyOrdersTakenWithBU_ORDERLINECOST]


select * from tblOrder
where dtOrderDate = '02/03/21'
and ixOrder like '%-%'
and sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
order by mMerchandiseCost -- 179

-- 216 131

mMerchandiseCost
0.00

select * from tblOrderLine
where ixOrder in ('9605993-1','9605994-1','9606997-1','9614997-1','9619990-1','9626990-1','9628991-1','9630895-1','9630992-1','9630997-1','9630999-1','9631996-1','9632997-2','9635998-1','9636897-1','9636898-2','9638990-1','9638991-1','9638995-1','9640890-1','9640994-1','9642894-1','9636997-1','9637892-1','9642899-1','9645998-1','9646997-1','9647892-1','9649896-1','9649899-1','9650994-1','9652997-1','9652999-1','9648996-1','9654895-1','9655894-1','9657994-1','9658992-1','9658999-1','9661897-1','9661994-1','9661996-1','9666892-1','9668999-1','9670992-1','9671991-1','9673896-1','9673899-1','9673992-1','9669897-1','9676996-1','9677896-1','9677991-1','9679892-1','9679894-1','9681898-1','9682998-1','9684993-1','9689891-1','9689893-1','9689990-1','9698896-1','9699897-1','9699990-1','9697891-1','9701194-1','9702092-1','9703099-1','9705199-1','9710094-1','9711198-1','9712193-1','9715094-1','9726092-1','9726094-1','9727090-1','9734091-1','9741097-1','9742093-1','9746095-1','9747090-1','9740091-1','9759097-1','9753097-1','9764096-1','9769096-1','9776090-1','9785092-1','9790091-1','9792092-1','9793094-1','9794090-1','9798093-1','9799093-1','9799098-1')


select flgLineStatus, count(OL.ixOrder) 'OLCount', SUM(OL.mExtendedCost) 'ExtCost'
from tblOrderLine OL
    left join tblOrder O on OL.ixOrder = O.ixOrder
where O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')
    and O.ixOrderDate >= 19360 -- 01/01/2019
    and OL.flgLineStatus NOT IN ('Cancelled','Cancelled Quote','Quote','Lost','ZeroQty','unknown','fail') -- what about ' Order' ?
group by flgLineStatus
order by flgLineStatus

select ixOrder, mExtendedPrice, mExtendedCost, iQuantity 
from tblOrderLine
where ixOrderDate >= 19360
and flgLineStatus = 'Split Order'

select * from tblOrder where ixOrder in ('9992280','9994287','9999388')

select * from tblOrder 
where ixMasterOrderNumber in ('S4745','S4746','S4757')

select * from tblOrderLine 
where ixOrder in ('9999388','9900482')

SELECT distinct sOrderStatus
from tblOrder
select distinct flgLineStatus
from tblOrderLine 
where flgLineStatus NOT IN ('Cancelled','Cancelled Quote','Quote','Lost','ZeroQty','unknown','fail','Split Order')
flgLineStatus IN ('Backordered','Backordered FS','Dropshipped','Open','Shipped')




SELECT DISTINCT sOrderStatus
from tblOrder O
WHERE O.sOrderStatus NOT in ('Recall','Pick Ticket','Cancelled','Quote','Cancelled Quote')

SELECT ixOrder, dtOrderDate, mMerchandise, mMerchandiseCost, sOrderStatus
FROM tblOrder
where dtOrderDate = '02/03/21'
    and ixBusinessUnit = 103
    and sOrderStatus <> 'Cancelled'


SELECT ixOrder, mExtendedPrice, mExtendedCost, flgLineStatus 
FROM tblOrderLine
where ixOrder in ('9656998','9663994','9663994-1')




SELECT * FROM [vwDailyOrdersTakenWithBU_ORDERLINECOST]
WHERE dtDate between '11/01/2020' and '11/30/2020' -- '02/03/21'
order by SortOrd

-- ROLLING UP VIEW FOR SPECIFIC DATE RANGE
SELECT OrdChan 'BU', SubBU, SortOrd, 
    SUM(DailyNumOrds) 'Orders',
    SUM(DailySales) 'Sales',
    SUM(DailyCoGS) 'Cogs',
    SUM(DailyProductMargin) 'PM$'
FROM [vwDailyOrdersTakenWithBU_ORDERLINECOST]
WHERE dtDate between '11/01/2020' and '11/30/2020' -- '02/03/21'
GROUP BY OrdChan, SubBU, SortOrd
ORDER BY SortOrd


SELECT OrdChan 'BU', SubBU, SortOrd, 
    SUM(DailyNumOrds) 'Orders',
    SUM(DailySales) 'Sales',
    SUM(DailyCoGS) 'Cogs',
    SUM(DailyProductMargin) 'PM$'
FROM [vwDailyOrdersTakenWithBU_ORDERLINECOST]
WHERE dtDate between '01/01/2020' and '01/31/2020' -- '02/03/21'
GROUP BY OrdChan, SubBU, SortOrd
ORDER BY SortOrd


select * from tblOrder where sOrderStatus = 'Shipped'
and mCredits <> 0
order by dtOrderDate desc

