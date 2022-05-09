USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyGrossRevAndPkgsByChannel]    Script Date: 9/20/2021 10:50:03 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
-- SMIHD-22631 -- TEMP version of vwDailyGrossRevAndPkgsByChannel

/***********************************************************************
CREATED: 06/01/2015
BY: PJC
PURPOSE: built for the "Gross Revenue Order and Package Count by Channel" 
         report under the Accounting folder.

NOTES:  per Accounting's request, 
        INTERNAL ORDERS ARE INCLUDED in this view!
***********************************************************************/

CREATE view [dbo].[vwDailyGrossRevAndPkgsByChannel_TEMP]
as
   
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
             WHERE  O.ixOrder in ('10111966','10104965')
             --O.dtShippedDate  between '01/01/2014' and getdate()   
                and O.sOrderStatus = 'Shipped'
                -- and O.sOrderType <> 'Internal' -- PER Jerry Malcom, Accounting needs to have Internal orders INCLUDED for this report
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
    where O.ixOrder in ('10111966','10104965')
    --O.dtShippedDate  between '01/01/2014' and getdate() 
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

GO


SELECT * FROM vwDailyGrossRevAndPkgsByChannel_TEMP