-- Case 18899 - Single Buyer Analysis

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
-- code modified from [spCSTSegmentPull]
DECLARE --@PromoId varchar(15),
        @Recency int,
        @Frequency int,
        @Monetary money,
        @Market varchar(2),
        @CampaignMarket varchar(2)
        
        
SELECT 
    @Recency = 24,   -- 
    @Frequency = 1,
    @Monetary = 1,
    @Market = 'SR',
    @CampaignMarket = 'SR'
select distinct R.ixCustomer ,
    @Market 'ixMarket', 
    '24M' as 'SingleBuyers',
    --FM.Frequency 'Freq',
    FM.Monetary 'Monetary'
--into PJC_SingleBuyers    
from (  -- RECENCY
            -- Customers with 1+ Orders containing SKUs (WITHIN THE MARKET) in the last @Recency Months
            select SP.ixCustomer,
                count(distinct O.ixOrder) 'Frequency',
                SUM(OL.mExtendedPrice)    'Monetary'
            from vwCSTStartingPool SP
                join tblOrder O on O.ixCustomer = SP.ixCustomer
                join tblOrderLine OL on O.ixOrder = OL.ixOrder 
                join tblSKU SKU on SKU.ixSKU = OL.ixSKU        
                join tblPGC PGC on PGC.ixPGC = SKU.ixPGC  
            where  O.dtShippedDate between '06/05/2011' and '06/05/2012'  -- (WITHIN @Recency)
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               and OL.flgKitComponent = 0 
               and PGC.ixMarket = @Market   
               and SP.ixCustomer not in (select ixCustomer from tblMailingOptIn where ixMarket = @CampaignMarket and sOptInStatus = 'N')   
            group by SP.ixCustomer
            having count(distinct O.ixOrder) = 1 -- ONE OR MORE ORDERS (WITHIN THE MARKET)
               and SUM(OL.mExtendedPrice) between 1 and 99    -- ONE OR MORE DOLLARS(WITHIN THE MARKET)
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
                   O.dtShippedDate >= '06/05/2007'   --DATEADD(MM, -@Recency, getdate()) 
               and O.sOrderType <> 'Internal'
               and O.sOrderChannel <> 'INTERNAL'
               and O.sOrderStatus in ('Shipped','Dropshipped')
               and O.mMerchandise > 1
               and OL.flgKitComponent = 0 
               and PGC.ixMarket = @Market           
            group by O.ixCustomer
            having count(distinct O.ixOrder) = 1
               and SUM(OL.mExtendedPrice) between 1 and 99  -- @Monetary
          ) FM on R.ixCustomer = FM.ixCustomer


/* TESTING PROC

 -- Largest 
 EXEC spCSTSegmentPull 12,'1','1','SR','SR'       -- 322,220 in 45 sec @6-5-13
                                                  -- 318,809 in 63 seconds @5-6-2013  
                                    
*/


select * from tblOrderLine where ixCustomer = '1840242'

select COUNT(distinct ixCustomer) from PJC_SingleBuyers -- 32942
select top 10 * from PJC_SingleBuyers
/*
ixCustomer	ixMarket	SingleBuyers	Monetary	OrigCustSource	SCGiven	SCMatchBack
1356742	SR	24M	154.95	NULL	NULL	NULL


*/
select top 10 * from tblCustomer order by NEWID()

GO


update A 
set SCGiven = O.sSourceCodeGiven
from PJC_SingleBuyers A
 join tblOrder O on A.ixCustomer = O.ixCustomer
and      O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '06/05/2011' and '06/05/2012' 
    

update A 
set SCMatchBack = O.sMatchbackSourceCode
from PJC_SingleBuyers A
 join tblOrder O on A.ixCustomer = O.ixCustomer
and      O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- verify if these should be filtered!
    and O.sOrderChannel <> 'INTERNAL'   -- verify if these should be filtered!
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '06/05/2011' and '06/05/2012'     


update PJC_SingleBuyers
set CustSourceGroup = (Case when OrigCustSource = 'EBAY' then 'EBAY'
                            when OrigCustSource like 'WEB%' then 'WEB'
                            else 'OTHER'
                       end)
 from PJC_SingleBuyers   
 
 select * from  PJC_SingleBuyers    
 
 
 
 select * from tblSourceCode        
 
 
 select distinct sSourceCodeType, COUNT(*)
 from tblSourceCode
 group by sSourceCodeType
 /*
 UNKNOWN	126
CAT-P	217
CAT-E	930
CAT-H	2856
OTHER	543
WEB-H	53
PIP-H	81
NULL	2
FLY-H	144
CAT-R	56
FLY-E	1
EMAIL-H	169
FLY-P	9
WEB-P	92
AD-PRINT	2228
EMAIL-P	3
*/
