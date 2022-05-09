--INITIAL DATA SET TO PULL LIST OF PROMOS ACTIVE DURING DATE RANGE ENTERED
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '08/12/18'  

SELECT DISTINCT TP.ixPromotion 'PromoID' -- aka TopLevelPromoID
FROM tng.tblpromotion TP
WHERE -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
      --we want to include promos that are at least partially active during the entered range.
    TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
       AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
ORDER BY 'PromoID'


select Distinct PO.ixPromotion, PO.ixPromotionOffer
FROM tng.tblpromotion_offer PO
where PO.ixPromotion in  1601


-- NEED A DISTINCT LIST OF ALL PROMOS & PROMOTION OFFERS ACTIVE BETWEEN TWO DATES
DECLARE @StartDate datetime,        @EndDate datetime
SELECT  @StartDate = '08/12/18',    @EndDate = '11/12/18'   
SELECT DISTINCT PO.ixPromotionOffer 
FROM tng.tblpromotion TP
left join tng.tblpromotion_offer PO on PO.ixPromotion = TP.ixPromotion
WHERE -- read the next conditions closely. This can NOT be a BEETWEEN statement.  
      --we want to include promos that are at least partially active during the entered range.
    TP.dtStartDateTimeUtc <= @EndDate -- promo starts before date range ENDS       
       AND TP.dtEndDateTimeUtc >= @StartDate  -- promo ends after date range STARTS
       and TP.ixPromotion = 1580
ORDER BY 'PromoID'

