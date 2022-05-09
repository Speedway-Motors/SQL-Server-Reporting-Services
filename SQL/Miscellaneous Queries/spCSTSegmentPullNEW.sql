USE [SMI Reporting]
GO

/****** Object:  StoredProcedure [dbo].[spCSTSegmentPullNEW]    Script Date: 09/06/2013 13:35:41 ******/
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

ALTER PROCEDURE [dbo].[spCSTSegmentPullNEW]
   @Recency int,
   @Frequency int,
   @Monetary money,
   @Market varchar(2),
   @CampaignMarket varchar(2)
WITH RECOMPILE      
AS

/* TO RUN MANUALLY in Management Studio: 

SELECT 
    @Recency = 12,   -- 
    @Frequency = 3,
    @Monetary = 400,
    @Market = 'SM',
    @CampaignMarket = 'SM'

        using the values above...
        8,572  @15 seconds with the CST in Prod on from 4-26-13
        1,411  @20 seconds with the new logic deployed to Prod on 5-1-13 
        3,085  @26 seconds with the new logic deployed to Prod on 5-6-13     
        3,085  @ 9 seconds with the new logic deployed to Prod on 5-6-13 @5:15PM           
*/
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
            from vwCSTStartingPool SP
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


/* TESTING PROC

 -- Smallest Segment
 EXEC spCSTSegmentPullNEW 12,'3','400','SM','SM'     --   3085 in 5 seconds @5-6-2013  
  
 EXEC spCSTSegmentPullNEW 12,'1','1000','R','SR'    -- 15,345 29 sec 
 
 EXEC spCSTSegmentPull    12,'1','1000','R','SR'    -- 15,345 17 sec

 
 -- Largest 
 EXEC spCSTSegmentPullNEW 72,'1','1','SR','SR'       -- 318,809 in 63 seconds @5-6-2013  
                                                  -- 333,419 in 46 seconds @9-4-2013   
*/




GO


