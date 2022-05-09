USE [SMI Reporting]
GO

/****** Object:  StoredProcedure [dbo].[spCSTSegmentRequestorPullCANADANEW]    Script Date: 09/06/2013 13:35:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[spCSTSegmentRequestorPullCANADANEW]
   @Recency int,
   @Market varchar(2),
   @CampaignMarket varchar(2)
WITH RECOMPILE   
AS

select ixCustomer,
    ixCatalogMarket as ixMarket,
    LatestRequestDate as dtLatestRequestDate,
    sMailToState,
    CustGroup
from vwCSTStartingPoolRequestorsCANADA SPR
where LatestRequestDate >= DATEADD(MM, -@Recency, getdate()) -- subracts # of months from current date
   and ixCatalogMarket =  @Market -- MARKET 'SR'
   and SPR.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = @CampaignMarket and sOptInStatus = 'N')

/* TESTING 
-- EXEC spCSTSegmentRequestorPullCANADANEW 24,'R','R' -- 3 @09-04-2013 11 seconds

-- EXEC spCSTSegmentRequestorPullCANADANEW 12,'SR','R' -- 44,822 NEW


--
        Unfiltered
SC      Counts
=====   ==========
555126   10,791 v
555128   44,822 v


    v = verified exact match in CST
    
*/




GO


