USE [SMI Reporting]
GO

/****** Object:  View [dbo].[vwDailyOrdersTakenGSShock]    Script Date: 01/27/2012 10:48:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vwDailyOrdersTakenGSShock]
as

SELECT isnull(GS.dtDate,SHOCK.dtDate)           dtDate,
    isnull(GS.iPeriod,SHOCK.iPeriod)            iPeriod,
    isnull(GS.iPeriodYear,SHOCK.iPeriodYear)    iPeriodYear,
    isnull(GS.GSDailyNumOrds,0)                 GSDailyNumOrds,
    isnull(GS.GSDailySales,0)                   GSDailySales,
    isnull(SHOCK.ShockDailyNumOrds,0)           ShockDailyNumOrds,
    isnull(SHOCK.ShockDailySales,0)             ShockDailySales
FROM    
    (/************ Garage Sale ****************/
    SELECT 
        D.dtDate,D.iPeriod,D.iPeriodYear,
        sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) GSDailyNumOrds,  -- COUNT BACKORDERS MERCH, but DON'T COUNT BACKORDERS as a new order!!!!!!
        sum(OL.mExtendedPrice) GSDailySales
    FROM  tblOrder O
          join tblOrderLine OL  on O.ixOrder = OL.ixOrder
          join tblSKU SKU       on SKU.ixSKU = OL.ixSKU
          join tblDate D        on O.ixOrderDate = D.ixDate
    WHERE 
          D.dtDate >= '01/01/2010'    -- otherwise view will go back to beginning of tblDate
          and O.sOrderChannel <> 'INTERNAL'
          and O.sOrderType <> 'Internal'      
          and O.sOrderStatus NOT in ('Pick Ticket','Cancelled')
          and OL.flgLineStatus in ('Shipped', 'Dropshipped','Open','Backordered' ) -- excludes status: Cancelled,fail,Lost,unknown
          and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
          and substring(SKU.ixPGC,2,1) in ('a','c','d','q','r','s','z') -- all the lower case values for the 2nd char of ixPGC      
    GROUP BY
        D.dtDate,D.iPeriod,D.iPeriodYear
    ) GS

FULL OUTER JOIN
    
    (/************ SHOCK ****************/
    SELECT 
        D.dtDate,D.iPeriodYear,D.iPeriod,
        sum(case when O.flgIsBackorder = '0' THEN 1 ELSE 0 END) ShockDailyNumOrds,  -- COUNT BACKORDERS MERCH, but DON'T COUNT BACKORDERS as a new order!!!!!!
        sum(OL.mExtendedPrice) ShockDailySales
    FROM  tblOrder O
          join tblOrderLine OL  on O.ixOrder = OL.ixOrder
          join tblSKU SKU       on SKU.ixSKU = OL.ixSKU
          join tblDate D        on O.ixOrderDate = D.ixDate
    WHERE 
          D.dtDate >= '01/01/2010'    -- otherwise view will go back to beginning of tblDate
          and  O.sOrderChannel <> 'INTERNAL'
          and O.sOrderType <> 'Internal'      
          and O.sOrderStatus NOT in ('Pick Ticket','Cancelled')
          and OL.flgLineStatus in ('Shipped', 'Dropshipped','Open','Backordered' ) -- excludes status: Cancelled,fail,Lost,unknown
          and OL.flgKitComponent = 0 -- KIT COMPONENT CHECK
          and substring(SKU.ixPGC,1,1) in ('k') -- all the lower case values for the 1st char of ixPGC
    GROUP BY
        D.dtDate,D.iPeriodYear,D.iPeriod
     ) SHOCK ON GS.dtDate = SHOCK.dtDate



GO
