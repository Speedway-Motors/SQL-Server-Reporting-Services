-- SMIHD-9756 - Wholesale Sales by Associate



DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/24/18',    @EndDate = '1/28/18'  

SELECT O.sOrderTaker, O.sOrderChannel,
    SUM(O.mMerchandise) 'MerchTot', 
    SUM(O.mMerchandiseCost) 'MerchCost', 
    -- COUNT(O.ixOrder) 'OrigOrderCount',
	SUM(case when O.sOrderStatus = 'Shipped' and O.ixOrder NOT LIKE '%-%' THEN 1 
	    ELSE 0 
	    END) 'OrderCount' -- per CCC Open and Backordered sales should be included in Revenue but NOT Order Count
FROM tblOrder O
WHERE O.dtOrderDate between @StartDate and @EndDate 
	and (O.sSourceCodeGiven like '%PRS%'
		 OR O.sSourceCodeGiven like '%MRR%'
		 OR O.sSourceCodeGiven like '%EMI%')	
    and O.sOrderStatus in  ('Shipped', 'Backordered', 'Open')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
GROUP BY O.sOrderTaker, O.sOrderChannel
ORDER BY O.sOrderTaker, O.sOrderChannel


/*
sOrder
Taker	sOrderStatus	MerchTot	MerchCost	OrigOrderCount	CCCOrderCount
DMH		Open			9483.74		6069.57		3				0
DMH		Shipped			4730.72		2930.186	15				15	
					   $14,214.46 
*/

select distinct sOrderStatus from tblOrder

-- verifying DMH orders
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '01/24/18',    @EndDate = '1/25/18'  

SELECT O.sOrderTaker, O.sOrderStatus, O.mMerchandise, O.ixOrder
   /* SUM(O.mMerchandise) 'MerchTot', 
    SUM(O.mMerchandiseCost) 'MerchCost', 
    COUNT(O.ixOrder) 'OrigOrderCount',
	SUM(case when O.sOrderStatus = 'Shipped' and O.ixOrder NOT LIKE '%-%' THEN 1 ELSE 0 END) 'CCCOrderCount'
	*/
FROM tblOrder O
WHERE O.dtOrderDate between @StartDate and @EndDate 
	and (O.sSourceCodeGiven like '%PRS%'
		 OR O.sSourceCodeGiven like '%MRR%'
		 OR O.sSourceCodeGiven like '%EMI%')	
    and O.sOrderStatus in  ('Shipped', 'Backordered', 'Open')
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
	and O.sOrderTaker = 'DMH'
	and O.sOrderChannel = 'PHONE'
ORDER BY  O.sOrderTaker, O.sOrderStatus

/***************
query from		Call Center > Orders by Associate.rdl
***************/
SELECT O.sOrderTaker, 
    SUM(O.mMerchandise) 'MerchTot', 
    SUM(O.mMerchandiseCost) 'MerchCost', 
    COUNT(O.ixOrder) 'OrderCount', 

    (SUM(O.mMerchandise)/COUNT(O.ixOrder)) 'AOV'
FROM tblOrder O
WHERE O.sOrderStatus = 'Shipped'
    and O.dtShippedDate between @StartDate and @EndDate -- '10/01/2016' and '10/07/2016'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
GROUP BY   O.sOrderTaker
ORDER BY  O.sOrderTaker


/***************
query from		Call Center > Orders by Associate.rdl
***************/
DECLARE @StartDate datetime,        @EndDate datetime,		@OrderType varchar(15)
SELECT  @StartDate = '01/24/18',    @EndDate = '1/25/18',	@OrderType = 'PHONE'

SELECT O.sOrderTaker    Associate,
         ISNULL(ICE.QTY, 0)         Shipped,        
         ISNULL(ICE.Merchandise, 0)  ShippedMerchTotal,
        ISNULL(XORD.QTY, 0) AS  Cancelled,
        ISNULL (PIC.QTY, 0)         Opened,
        O.dtOrderDate 
FROM (select distinct sOrderTaker, dtOrderDate
        from tblOrder
        WHERE sOrderChannel in (@OrderType) 
        and dtOrderDate between @StartDate and @EndDate
	    and (sSourceCodeGiven like '%PRS%'
			 OR sSourceCodeGiven like '%MRR%'
			 OR sSourceCodeGiven like '%EMI%')
AND sOrderTaker = 'DMH'
     ) O
    left join (select sOrderTaker,
                             dtOrderDate,
                             ISNULL (count(ixOrder),0) QTY 
                 FROM tblOrder
                 WHERE sOrderChannel in (@OrderType) 
                    and dtOrderDate between @StartDate and @EndDate
                    and sOrderStatus = 'Cancelled' 
					and (sSourceCodeGiven like '%PRS%'
						 OR sSourceCodeGiven like '%MRR%'
						 OR sSourceCodeGiven like '%EMI%')
                 GROUP by sOrderTaker, dtOrderDate   
               ) XORD on XORD.sOrderTaker = O.sOrderTaker
               and XORD.dtOrderDate = O.dtOrderDate
    left join (select sOrderTaker,
                             dtOrderDate,
                             count(ixOrder) QTY 
                 FROM tblOrder
                 WHERE sOrderChannel in (@OrderType) 
                    and dtOrderDate between @StartDate and @EndDate
                    and sOrderStatus = 'Open'  
					and (sSourceCodeGiven like '%PRS%'
						 OR sSourceCodeGiven like '%MRR%'
						 OR sSourceCodeGiven like '%EMI%')
                 GROUP by sOrderTaker, dtOrderDate    
               ) PIC on PIC.sOrderTaker = O.sOrderTaker
               and PIC.dtOrderDate = O.dtOrderDate
    left join (select sOrderTaker, 
                              dtOrderDate,
                              count(ixOrder) QTY,
                              sum(mMerchandise) Merchandise 
                 FROM tblOrder
                 WHERE sOrderChannel in (@OrderType) 
                    and dtOrderDate between @StartDate and @EndDate
                    and sOrderStatus = 'Shipped'  
					and (sSourceCodeGiven like '%PRS%'
						 OR sSourceCodeGiven like '%MRR%'
						 OR sSourceCodeGiven like '%EMI%')
                 GROUP by sOrderTaker, dtOrderDate   
               ) ICE on ICE.sOrderTaker = O.sOrderTaker
               and ICE.dtOrderDate = O.dtOrderDate
order by O.sOrderTaker, O.dtOrderDate







select distinct sOrderChannel
from tblOrder      
where ixOrderDate >= 18292 -- 01/29/2018
order by sOrderChannel

AMAZON
AUCTION
COUNTER
E-MAIL
FAX
INTERNAL
MAIL
PHONE
WEB


SELECT DISTINCT sOrderType
from tblOrder
where dtOrderDate = '01/19/2018'

select ixOrder, sSourceCodeGiven, sOrderType
from tblOrder where dtOrderDate = '01/19/2018'
and sOrderType in ('MRR','PRS')
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'





select ixOrder, sSourceCodeGiven, sOrderType
from tblOrder where dtOrderDate >= '01/19/2018'
and sOrderType in ('MRR','PRS')
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'
and sSourceCodeGiven NOT LIKE'PRS%'
and sSourceCodeGiven NOT LIKE'MRR%'


select ixOrder, sSourceCodeGiven, sOrderType
from tblOrder where dtOrderDate >= '01/01/2018'
and sOrderType NOT in ('MRR','PRS')
and (sSourceCodeGiven LIKE'PRS%'
or sSourceCodeGiven  LIKE'MRR%')
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'





select distinct sSourceCodeGiven --ixOrder, sSourceCodeGiven, sOrderType
from tblOrder where dtOrderDate >= '01/01/2017'
and ixOrder NOT LIKE 'Q%'
and ixOrder NOT LIKE 'P%'
and sSourceCodeGiven like '%EMI%'


SELECT distinct sOrderStatus
from tblOrder
where dtOrderDate  >= '01/01/2017'


Backordered
Open
Shipped