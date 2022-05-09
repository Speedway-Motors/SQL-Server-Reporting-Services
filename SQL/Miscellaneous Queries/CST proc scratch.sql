--CST proc scratch

USE [SMI Reporting]


GO

/****** Object:  StoredProcedure [dbo].[spCSTSegmentPull]    Script Date: 05/01/2013 14:13:35 ******
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
The new rules for CST segmentation for RFM & Mkt are as follows:
Recency     = the customer only needs to have placed a single order during that recency.
Frequency   = Count of orders placed within the last 6 years - regardless of Market & recency
Monetary    = merchandise sum of all orders for a customer for the last 6 years - regardless of Market & recency
Market      = each market where a customer has spent at least $1 for that market within the Recency block - based on SKU Market.
CampaignMarket = The market of the campaign, currently used to filter out mailing opt-outs on tblMailingOptIn
*/

CREATE PROCEDURE [dbo].[spCSTSegmentPull]
   @Recency int,
   @Frequency int,
   @Monetary money,
   @Market varchar(2),
   @CampaignMarket varchar(2)
AS
*/
/*
12M 
3X 
$400+ 
Sprint/Midget 
    would be someone who...
+ ordered a Sprint Midget part in the past 12 months, 
with historic value of Sprint/Midget parts of at least $400, 
over at least 3 historic orders containing Sprint/Midget parts
*/

DECLARE 
   @Recency int,
   @Frequency int,
   @Monetary money,
   @Market varchar(2),
   @CampaignMarket varchar(2)

/* using the values below...
8,572  @15 seconds with current CST logic   
1,411  @20 seconds with the new logic
*/
SELECT 
    @Recency = 12,   -- 
    @Frequency = 3,
    @Monetary = 400,
    @Market = 'SM',
    @CampaignMarket = 'SM'

select distinct SP.ixCustomer ,
    PGC.ixMarket, 
    FM.Frequency 'Freq',
    FM.Monetary 'Monetary',    
    sMailToState
from vwCSTStartingPool SP
    join tblOrder O on SP.ixCustomer = O.ixCustomer
    join tblOrderLine OL on O.ixOrder = OL.ixOrder
    join tblSKU SKU on SKU.ixSKU = OL.ixSKU
    join tblPGC PGC on PGC.ixPGC = SKU.ixPGC
    join (  -- RECENCY & MONETARY
            -- Count of Orders and Total Sales for each customer for the last @Recency Months
            select O.ixCustomer, 
                count(distinct O.ixOrder) 'Frequency',
                SUM(OL.mExtendedPrice)    'Monetary' -- instead of O.mMerchandise
            from tblOrder O
                join tblOrderLine OL on O.ixOrder = OL.ixOrder 
                join tblSKU SKU on SKU.ixSKU = OL.ixSKU        
                join tblPGC PGC on PGC.ixPGC = SKU.ixPGC       
            where  
                   O.dtShippedDate >= DATEADD(MM, -@Recency, getdate())
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               and OL.flgKitComponent = 0 
               and PGC.ixMarket = @Market           
            group by O.ixCustomer
            having count(distinct O.ixOrder) >= @Frequency
               and SUM(OL.mExtendedPrice) >= @Monetary
          ) FM on SP.ixCustomer = FM.ixCustomer
where 
       PGC.ixMarket = @Market
   and FM.Monetary >= @Monetary
   and FM.Frequency >= @Frequency
   and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = @CampaignMarket and sOptInStatus = 'N')



