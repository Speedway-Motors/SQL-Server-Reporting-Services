-- SMIHD-1103 Change to the Gross Revenue and Order Count by Channel Report

-- 1 - need a new roll-up view the report can use
/*
(-- list of Order Channels
select distinct sOrderChannel
from tblOrder
where dtOrderDate >= DATEADD(yy, -1, getdate()) 
UNION
select 'COUNTER P/U' as sOrderChannel
) OC
*/
USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyGrossRevByChannel_TEMP]    Script Date: 06/22/2015 10:54:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER view [dbo].[vwDailyGrossRevByChannel_TEMP]
as
--SELECT ixPrimaryShipLocation, OrdChan, 
    
--    SUM(DailySales) 'Sales',
--    SUM(DailyNumOrds) 'Orders',
--    SUM(PkgCount) 'Packages'
--FROM ( 

   
SELECT ISNULL(ORDERS.dtShippedDate,PKG.dtShippedDate) 'dtShippedDate',
       ISNULL(ORDERS.ixPrimaryShipLocation,PKG.ixPrimaryShipLocation) 'ixPrimaryShipLocation',
       ISNULL(ORDERS.OrdChan,PKG.OrdChan) 'OrdChan',
       ISNULL(ORDERS.DailySales,0) 'DailySales',
       ISNULL(ORDERS.DailyNumOrds,0) 'DailyNumOrds',
       ISNULL(PKG.PkgCount,0) 'PkgCount'              
FROM 
    (-- ORDERS Sales & Counts
    SELECT O.dtShippedDate,
           O.ixPrimaryShipLocation,
           (case when O.iShipMethod = 1 and O.sOrderChannel not IN ('COUNTER', 'INTERNAL') then 'COUNTER P/U'
                 else O.sOrderChannel
            end) OrdChan,
                sum(O.mMerchandise) DailySales,
                sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) DailyNumOrds
             FROM  tblOrder O
             WHERE  O.dtShippedDate  between '01/01/2014' and getdate()   
                and O.sOrderStatus = 'Shipped'
                and O.sOrderType <> 'Internal'
    group by O.dtShippedDate,
             O.ixPrimaryShipLocation,
            (case when O.iShipMethod = 1 and O.sOrderChannel not IN ('COUNTER', 'INTERNAL') then 'COUNTER P/U'
                  else O.sOrderChannel
             end)                    
    --ORDER BY  O.ixPrimaryShipLocation, O.dtShippedDate, 
    --        (case when O.iShipMethod = 1 and O.sOrderChannel not IN ('COUNTER', 'INTERNAL') then 'COUNTER P/U'
    --              else O.sOrderChannel
    --        end) 
    --        
        ) ORDERS                      
         
FULL OUTER JOIN
    (-- PKG Counts                    
    select O.dtShippedDate,
           O.ixPrimaryShipLocation,
           (case when O.iShipMethod = 1 and O.sOrderChannel not IN ('COUNTER', 'INTERNAL') then 'COUNTER P/U'
                 else O.sOrderChannel
            end) OrdChan,
           COUNT(P.sTrackingNumber) PkgCount
    from tblPackage P
        join tblOrder O on O.ixOrder = P.ixOrder
    where O.dtShippedDate  between '01/01/2014' and getdate() 
        and P.flgCanceled = 0           -- 2,714
        and P.flgReplaced = 0
    group by O.dtShippedDate,
             O.ixPrimaryShipLocation,
            (case when O.iShipMethod = 1 and O.sOrderChannel not IN ('COUNTER', 'INTERNAL') then 'COUNTER P/U'
                  else O.sOrderChannel
             end) 
    ) PKG ON ORDERS.OrdChan = PKG.OrdChan 
             AND ORDERS.ixPrimaryShipLocation = PKG.ixPrimaryShipLocation
             AND ORDERS.dtShippedDate = PKG.dtShippedDate

) X

WHERE dtShippeDate between '01/01/2014' and getdate()
GROUP BY ixPrimaryShipLocation, OrdChan
--ORDER BY ixPrimaryShipLocation, OrdChan

/*

select flgReplaced, COUNT(*)
from tblPackage
where ixShipDate >= 17319
--and flgCanceled = 
group by flgReplaced

select sTrackingNumber, dtDateLastSOPUpdate
from tblPackage
where ixShipDate >= 17273 -- 16962 = ixDate 1 year ago
and 
(flgCanceled is NULL
OR 
 flgReplaced IS NULL)
 order by dtDateLastSOPUpdate


select distinct P.ixOrder
from tblPackage P
where ixOrder in (                    
                    select ixOrder 
                    from tblOrder 
                    where dtShippedDate = '06/02/2015'
                    and ixPrimaryShipLocation = 47                    
                    )
                    
                    
-- how to find SMI packages shipped from Afco?
SELECT O.*
FROM tblOrder O
 left join tblPackage P on O.ixOrder = P.ixOrder
where sOrderStatus = 'Shipped'
and ixPrimaryShipLocation = 47
and ixShippedDate between   17288 and   17318 -- May  1,533 orders
and P.ixOrder is NULL

-- count of packages Afco shipps for SMI               
SELECT P.sTrackingNumber 
FROM tblPackage P
    join tblOrder O on O.ixOrder = P.ixOrder
WHERE O.sOrderStatus = 'Shipped'
    and O.ixPrimaryShipLocation = 47
    and O.ixShippedDate = 17320 -- Jun 02            between 17288 and 17318 -- May  1,533 orders
    and P.flgCanceled = 0                       --      1,631 Packages
    and P.flgReplaced = 0                      
*/

    





SELECT * from vwDailyGrossRevByChannel_TEMP

select SUM(DailySales)
from vwDailyGrossRevByChannel_TEMP -- 153,660,622

SELECT SUM(mMerchandise)
from tblOrder
where ixShippedDate >= 16803
                and sOrderStatus = 'Shipped'
                and sOrderType <> 'Internal'
                
select SUM(DailyNumOrds)
from vwDailyGrossRevByChannel_TEMP -- 748,250                

SELECT COUNT(ixOrder) -- 748,250
from tblOrder
where ixShippedDate >= 16803
                and sOrderStatus = 'Shipped'
                and sOrderType <> 'Internal'
                and flgIsBackorder = 0
                


select distinct dtShippedDate -- 533
from vwDailyGrossRevByChannel_TEMP
order by dtShippedDate

select distinct dtDate -- 538
from tblDate
where dtDate between '01/01/2014' and getdate()  

select top 1 * from vwDailyGrossRevByChannel_TEMP

