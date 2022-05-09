-- SMIHD-19407 - Promo Code - First Time Customer Usage
--                          - Customer Analysis                            

/*
NAME: Promo Code - First Time Customer Usage 
   OR Promo Code - Customer Analysis 

@PromoCodeName (thinking this would be better than the actual ID? For instance, the initial request was for AUGUST-CX (ID #1808)
@StartDate & @EndDate

EXAMPLE PROMO -  AUGUST-CX (ID #1808)


Group by PROMO:

Promo Name
Promo Description
Promo dates?
Promo Reporting ID?

How many brand new (first time) customers used promo August-CX? Must be first time customer when using the promo code.

Customer Detail:
Customer number
Customer name
Column for date of first order.
Column for elapsed days to second order
Colum for total number of orders (which could be the reorder velocity field noted below)
Average Order Value (AOV)
Reorder velocity (2nd, 3rd, etc)
Total Revenue

Report goes in Call Center and Marketing folders, 

From Brian for historical purposes: would be slick to just be able to punch in promo or reporting i/d's and pull 
in subsequent sales data after the initial use of the promo. 
At this point, we are just looking for specifically the # of these 'new' customers and how many have placed a subsequent 2nd/3rd etc order 
between order date and now and what is the time line of those orders i/e reorder velocity and then $$ data i/e AOV margin etc.

 possibly naming it Promo Code/Customer Analysis.
 */
 -- Active Promo data set

--1ST DATA SET - PULL LIST OF PROMOS ACTIVE DURING DATE RANGE ENTERED
    DECLARE @StartDate datetime,        @EndDate datetime
    SELECT  @StartDate = '08/01/20',    @EndDate = '09/01/20'  

    SELECT DISTINCT TP.ixPromotion 'PromoID', TP.sPromoName -- aka TopLevelPromoID
    FROM tng.tblpromotion TP
    WHERE -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
          --we want to include promos that are at least partially active during the entered range.
        TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
           AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
    AND TP.ixPromotion IS NOT NULL
    -- AND TP.ixPromotion in ('1161','1529','1580','1601','1602')-- TESTING ONLY
    ORDER BY 'PromoID' DESC

-- 2ND DATA SET - GET PROMO OFFERS FROM SELECTED PROMO ID 
    DECLARE @PromoID VARCHAR(15)
    SELECT @PromoID = 1808
     SELECT distinct PO.ixPromotionOffer
          --  dtStartDateTimeUtc, dtEndDateTimeUtc,
           -- TP.sPromoCode,
           -- TP.sPromoName
            --ixPromoCode,  <-- this was causing a cartesian on a small # of PromoIDs e.g. PromoId 1410
          FROM tng.tblpromotion TP 
            left join tng.tblpromotion_offer PO on TP.ixPromotion = PO.ixPromotion
          WHERE TP.ixPromotion in (@PromoID)
                --and TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
                --AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
          AND TP.ixPromotion NOT like 'Z%'
         AND TP.ixPromotion is NOT NULL
    ORDER BY PO.ixPromotionOffer DESC



















-- sPromoName and sPromoCode are NOT UNIQUE.  They get used for multiple Promo IDs
SELECT TP.sPromoName, Count(TP.ixPromotion) 'PromoIDCount' -- aka TopLevelPromoID
FROM tng.tblpromotion TP
group by TP.sPromoName
having Count(TP.ixPromotion > 1
order by Count(TP.ixPromotion) desc

    SELECT TP.sPromoCode, Count(TP.ixPromotion) 'PromoIDCount' -- aka TopLevelPromoID
    FROM tng.tblpromotion TP
    group by TP.sPromoCode
    having Count(TP.ixPromotion) > 1
    order by Count(TP.ixPromotion) desc


    select * -- TP.ixPromotion 'PromoID', TP.sPromoName, *
    FROM tng.tblpromotion TP
    where sPromoName in (SELECT TP.sPromoName
                        FROM tng.tblpromotion TP
                        group by TP.sPromoName
                        having Count(TP.ixPromotion) > 1)
    ORDER BY TP.sPromoName







