-- SMIHD-1485 - Top Revenue Customers

/*
Report Goal: ID new and returning customers so they can be recognized via a hand written thank-you card as time permits.												
												
Shipped orders only												
Retail Customers only
												
					
Start & End Date
Minimum Order Value

+ 1 of these 3 options for customer type:
    *First Time Customers 
    *Returning Customers > 36 Months since last order 					
    *All					
												
Fields:												
Customer #, # of transactions on acct,	Lifetime Revenue              <-- Cust level
Order #,	Shipping State,	Order $ Total,	Order Date,	Order Channel <-- Order level

*Sorted in by dollar total in decending order (by default)												
*/

DECLARE
    @StartDate datetime,
    @EndDate datetime,
    @MinOrderVal smallmoney

SELECT
    @StartDate = '10/12/15',
    @EndDate = '10/18/15',
    @MinOrderVal = 500


SELECT C.ixCustomer 'CustomerNum',  -- 11,694 orders
    OC.OrderCount AS 'Orders', -- count of orders
    TS.TotSales AS 'LifetimeRevenue',
    O.ixOrder,
    O.sShipToState,
    O.mMerchandise,
    O.dtOrderDate,
    O.sOrderChannel,
    ISNULL(DS.DaysSincePrevOrder, 999999 ) 'DaysSincePrevOrder',
    ISNULL(FT.FirstTimeBuyer,'N') 'FirstTimeBuyer'
FROM tblCustomer C
    left join tblOrder O on C.ixCustomer = O.ixCustomer
    left join (-- # of Orders
                select O.ixCustomer, COUNT(ixOrder) OrderCount
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.ixOrder NOT LIKE '%-%'
                group by O.ixCustomer                    
                ) OC on OC.ixCustomer = C.ixCustomer
    left join (-- Total Sales
                select O.ixCustomer, SUM(O.mMerchandise) TotSales
                from tblOrder O
                where O.sOrderStatus = 'Shipped'
                    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
                    and O.sOrderType <> 'Internal'   -- USUALLY filtered
                    and O.ixOrder NOT LIKE '%-%'
                group by O.ixCustomer                    
                ) TS on TS.ixCustomer = C.ixCustomer
    left join (SELECT MR1.ixCustomer, DATEDIFF(D,MR2.dtShippedDate,MR1.dtShippedDate) DaysSincePrevOrder, MAX(MR1.OrderRank) 'MaxRank'
               FROM [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup MR1
               LEFT JOIN [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup MR2 ON MR1.ixCustomer = MR2.ixCustomer 
               WHERE MR1.OrderRank = 1
               and MR2.OrderRank = 2
--and MR1.ixCustomer in ('1794861','664216')
               GROUP BY MR1.ixCustomer, DATEDIFF(D,MR2.dtShippedDate,MR1.dtShippedDate)
               ) DS on C.ixCustomer = DS.ixCustomer
    left join (-- First time buyers (they only have placed one order)
               SELECT MR.ixCustomer, MAX(MR.OrderRank) 'MaxRank', 'Y' as FirstTimeBuyer, MR.dtAccountCreateDate
               FROM [SMITemp].dbo.CustomerTwoMostRecentOrders_Rollup MR
                join tblOrder O on MR.ixCustomer = O.ixCustomer
               WHERE O.dtShippedDate between @StartDate and @EndDate
               GROUP BY MR.ixCustomer, MR.dtAccountCreateDate  
               HAVING   MAX(MR.OrderRank) = 1
               ) FT ON C.ixCustomer = FT.ixCustomer        
    WHERE O.dtShippedDate between @StartDate and @EndDate
    and O.mMerchandise > @MinOrderVal    
    and C.sCustomerType = 'Retail'
    and O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'   -- USUALLY filtered
ORDER BY ISNULL(DS.DaysSincePrevOrder, 999999 ) desc
-- C.ixCustomer

/*
SELECT * FROM tblOrder where ixCustomer in ('1794861','664216')
order by ixCustomer, dtOrderDate


*/

/*
ixCustomer	Orders	LifetimeRevenue	ixOrder	sShipToState	mMerchandise	dtOrderDate	DaysSincePrevOrder
111226	    2	    5549.97	        6214938	CA	            5099.98	        2015-08-31 	178
391624	    18	    8471.03	        6381238	MO	            1262.98	        2015-09-02 	9
420339	    5	    2543.60	        6390430	IL	            1269.93	        2015-09-04 	688
595906	    1	    1499.94	        6380032	MO	            1499.94	        2015-09-01 	NULL

select * from tblOrder where ixCustomer = 595906
and sOrderStatus = 'Shipped'
order by dtShippedDate
*/
