USE [SMI Reporting]
GO

/****** Object:  StoredProcedure [dbo].[spAfcoDDCTesting]    Script Date: 04/27/2012 11:46:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spAfcoDDCTesting]
   @StartDate datetime,
   @EndDate datetime,
   @ShipFromLocation varchar(2),
   @ShipToLocation varchar(2)
   
AS
SELECT
   VS.sVendorSKU AfcoPartNumber,
   --sum(OL.iQuantity) UnalteredSMIQty,
   isNull(AFCO.AFCOQtyNeeded,0) AFCOQtyNeeded,
   CAST(ROUND(sum((OL.iQuantity )* 1.30), 0) AS int) SMIQtyNeeded -- changed to 30% 3/8/12 Case #12838
   -- ,ForecastingSKUUsed
FROM 
   tblOrderLine OL
   left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
   left join tblOrder O on OL.ixOrder = O.ixOrder
   left join tblVendorSKU VS on VS.ixSKU = SKU.ixSKU
   left join tblSKULocation SL on SL.ixSKU = SKU.ixSKU
   left join (-- GET AFCO sales QTY
              SELECT SKU.ixSKU, 
                CAST(ROUND(sum((OL.iQuantity )* 1.05), 0) AS int) AFCOQtyNeeded -- 5% growth per CCC 3/14/12
              FROM
                   [AFCOReporting].dbo.tblOrderLine OL
                   left join [AFCOReporting].dbo.tblSKU SKU on OL.ixSKU = SKU.ixSKU
                   left join [AFCOReporting].dbo.tblOrder O on OL.ixOrder = O.ixOrder
              WHERE OL.dtShippedDate between @StartDate and @EndDate -- '04/01/2011' AND '04/07/2011' 
               and OL.flgLineStatus = 'Shipped' 
               and O.sOrderStatus = 'Shipped'
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.ixCustomer not in ('12410','10511','15242','27511','26101','26103','11571','11572','11573','11574')  -- excluding SPEEDWAY accounts
               and O.dtShippedDate between @StartDate and @EndDate -- '04/01/2011' AND '04/07/2011'
               and SKU.ixSKU not like 'UP%'
               and SKU.ixSKU not like 'GIFT%'
               and SKU.ixSKU not like 'EGIFT%'
               and SKU.flgIntangible = 0
               and SKU.flgDeletedFromSOP = 0
              GROUP BY SKU.ixSKU
             ) AFCO on VS.sVendorSKU COLLATE SQL_Latin1_General_CP1_CS_AS = AFCO.ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS
                            
WHERE OL.dtShippedDate between @StartDate and @EndDate -- '01/01/2011' and '12/31/2012'
   --and O.sOrderStatus = 'Shipped'
   --and OL.flgLineStatus in ('Shipped','Dropshipped')
   --and O.sOrderType <> 'Internal'
   --and O.sOrderChannel <> 'INTERNAL'
   --and O.dtShippedDate between @StartDate and @EndDate -- '04/01/2011' AND '04/07/2011'  
   --and SKU.ixSKU not like 'UP%'
   --and SKU.ixSKU not like 'GIFT%'
   --and SKU.ixSKU not like 'EGIFT%'
   --and SKU.flgIntangible = 0
   --and SKU.flgDeletedFromSOP = 0
   --and VS.ixVendor in ('0106','0311') -- Afco
   --and VS.iOrdinality = 1       
   --and SL.sPickingBin NOT in ('SHOP','ZNEW','!!!!','~') -- '999','9999'
   --and SL.sPickingBin NOT like 'V%'
   --and SL.ixLocation = 99   
-- TESTING ONLY
AND VS.sVendorSKU IN ('20182-1','20249')
GROUP BY VS.sVendorSKU, AFCO.AFCOQtyNeeded
--HAVING CAST(ROUND(sum((OL.iQuantity )* 1.30), 0) AS int) >= 1 -- will sell at least one
order by SMIQtyNeeded DESC

-- exec spAfcoDDCTesting '05/11/2011','05/25/2011',9,9  -- 1381 rows  110 seconds 
/*
20182-1
20249
*/



/***** CHECKING FOR SALES ON THE SPEEDWAY SIDE */

-- find the afco version of the SKUs
select * from tblVendorSKU
where   sVendorSKU IN ('20182-1','20249') 
    and ixVendor = 0106 -- Afco

-- Speedway Sales
SELECT SKU.ixSKU, 
                CAST(ROUND(sum((OL.iQuantity )* 1.05), 0) AS int) AFCOQtyNeeded -- 5% growth per CCC 3/14/12
              FROM
                   tblOrderLine OL
                   left join tblSKU SKU on OL.ixSKU = SKU.ixSKU
                   left join tblOrder O on OL.ixOrder = O.ixOrder
              WHERE 
              --OL.dtShippedDate between @StartDate and @EndDate -- '04/01/2011' AND '04/07/2011' 
              OL.ixSKU in ('106201821','10620249')-- afco ('20182-1','20249')
    and O.dtOrderDate between '05/11/2011' and '05/25/2011'
               and OL.flgLineStatus = 'Shipped' 
               and O.sOrderStatus = 'Shipped'
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.ixCustomer not in ('12410','10511','15242','27511','26101','26103','11571','11572','11573','11574')  -- excluding SPEEDWAY accounts
             --  and O.dtShippedDate between @StartDate and @EndDate -- '04/01/2011' AND '04/07/2011'
               and SKU.ixSKU not like 'UP%'
               and SKU.ixSKU not like 'GIFT%'
               and SKU.ixSKU not like 'EGIFT%'
               and SKU.flgIntangible = 0
               and SKU.flgDeletedFromSOP = 0
              GROUP BY SKU.ixSKU
              
GO


