USE [SMI Reporting]
GO

/****** Object:  StoredProcedure [dbo].[spCSTSegmentPullCANADANEW]    Script Date: 09/06/2013 13:35:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



/*
The rules for CST segmentation as of 5-6-2013 are as follows:

Segment: 12M 3X $400+ Sprint/Midget 

To qualify for the above segment a customer would be someone who:

    Has ordered 1 or more @Market SKUs totally $1 or more in the 12 months
    AND
    Has at least @FREQUENCY orders containing @Market SKUs in the last 72 months
    AND
    Has purchases of @Market SKUs totaling at least @Monetary in the last 72 months

CampaignMarket = The market of the campaign, currently used to filter out mailing opt-outs on tblMailingOptIn
*/

ALTER PROCEDURE [dbo].[spCSTSegmentPullCANADANEW]
   @Recency int,
   @Frequency int,
   @Monetary money,
   @Market varchar(2),
   @CampaignMarket varchar(2)
WITH RECOMPILE      
AS
select distinct R.ixCustomer ,
    @Market 'ixMarket', 
    FM.Frequency 'Freq',
    FM.Monetary 'Monetary',    
    R.sMailToState,
    R.CustGroup
from (  -- RECENCY
            -- Customers with 1+ Orders containing SKUs (WITHIN THE MARKET) in the last @Recency Months
            select SP.ixCustomer, SP.sMailToState, SP.CustGroup,
                count(distinct O.ixOrder) 'Frequency',
                SUM(OL.mExtendedPrice)    'Monetary'
            from vwCSTStartingPoolCANADA SP
                join tblOrder O on O.ixCustomer = SP.ixCustomer
                join tblOrderLine OL on O.ixOrder = OL.ixOrder 
                join tblSKU SKU on SKU.ixSKU = OL.ixSKU        
                join tblPGC PGC on PGC.ixPGC = SKU.ixPGC   
            where  O.dtShippedDate >= DATEADD(MM, -@Recency, getdate())  -- (WITHIN THE RECENCY)
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               and OL.flgKitComponent = 0 
               and PGC.ixMarket = @Market   
               and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = @CampaignMarket and sOptInStatus = 'N')       
            group by SP.ixCustomer, SP.sMailToState, SP.CustGroup
            having count(distinct O.ixOrder) >= 1 -- ONE OR MORE ORDERS (WITHIN THE MARKET)
               and SUM(OL.mExtendedPrice) >= 1    -- ONE OR MORE DOLLARS(WITHIN THE MARKET)
          ) R 
    JOIN (  -- FREQUENCY & MONETARY
            -- Count of Orders containg SKUs (WITHIN THE MARKET)
            -- and Total Sales of SKUs (WITHIN THE MARKET) for each customer for the last 72 Months
            select O.ixCustomer, 
                count(distinct O.ixOrder) 'Frequency',
                SUM(OL.mExtendedPrice)    'Monetary' 
            from tblOrder O
                join tblOrderLine OL on O.ixOrder = OL.ixOrder 
                join tblSKU SKU on SKU.ixSKU = OL.ixSKU        
                join tblPGC PGC on PGC.ixPGC = SKU.ixPGC       
            where  
                   O.dtShippedDate >= DATEADD(MM, -72, getdate())  --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               and OL.flgKitComponent = 0 
               and PGC.ixMarket = @Market           
            group by O.ixCustomer
            having count(distinct O.ixOrder) >= @Frequency
               and SUM(OL.mExtendedPrice) >= @Monetary
          ) FM on R.ixCustomer = FM.ixCustomer

/* TESTING Proc

 EXEC spCSTSegmentPullCANADANEW 12,'2','150','R','R'   --   354 @8-12-13 1 sec 
                                                    --   247 @9-04-13 12 sec
                                                    
 EXEC spCSTSegmentPullCANADANEW 12,'2','150','SM','R'  --    79 @8-12-13 1 sec   
                                                    --    36 @9-04-13 7 sec
 
 EXEC spCSTSegmentPullCANADANEW 12,'6','1000','SR','R' --   238 @8-12-13 1 sec 
                                                    --   213 @9-04-13 6 sec
 
 EXEC spCSTSegmentPullCANADANEW 72,'1','1','SR','R'    -- 4,302 @8-12-13 1 sec      
                                                    -- 4,689 @9-04-13 11 sec
*/



GO


