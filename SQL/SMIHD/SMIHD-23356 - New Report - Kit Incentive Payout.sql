-- SMIHD-23356 - New Report - Kit Incentive Payout

/* -- ORIG QUERY PROVIDED

Declare @PayoutAmount money = 20
declare @DateToCheck date = getdate() -- Defaults to today
-- set @DateToCheck = '11/3/2021' -- Can override it to any date
-- set @DateToCheck = '01/01/2022' -- Can override it to any date
declare @StartDate date
declare @EndDate date
Declare @TempDate date
-- Figure out the previous month
set @TempDate = dateadd(month, -1 , @DateToCheck)
set @StartDate = DATEFROMPARTS( year(@TempDate), month(@TempDate),1)
set @TempDate = @DateToCheck
set @EndDate = DATEFROMPARTS( year(@TempDate), month(@TempDate),1)

SELECT   sa.sTitle
       , sav.sAttributeValue
       , SUM(@PayoutAmount) AS EmployeeTotal
       , STRING_AGG(s.ixSOPSKU,',') WITHIN GROUP (ORDER BY IXSOPSKU) as SKUList
       , STRING_AGG(s.sSKUVariantName,',') WITHIN GROUP (ORDER BY IXSOPSKU) as SKUNameList
       , @StartDate as StartDate
       , dateadd(day,-1,@EndDate) as EndDate
FROM tngLive.tblskuvariant s
    INNER JOIN tngLive.tblskuvariant_skuattribute_value ssav ON ssav.ixSkuVariant = s.ixSKUVariant
    INNER JOIN tngLive.tblskuattribute_value sav ON sav.ixSkuAttributeValue = ssav.ixSkuAttributeValue
    INNER JOIN tngLive.tblskuattribute sa ON sa.ixSkuAttribute = sav.ixSkuAttribute
WHERE sTitle = 'Kit Originator'
              and s.dtCreate >=  @StartDate
              and s.dtCreate < @EndDate
GROUP BY sTitle
       ,sav.sAttributeValue
*/


-- REPORT VERSION

/* Kit Incentive Payout.rdl
    ver 21.49.1

DECLARE @PayoutAmount money = 20
DECLARE @StartDate date     = '11/01/2021'
DECLARE @EndDate date       = '11/30/2021'
*/
SELECT   sa.sTitle
       , sav.sAttributeValue
       , SUM(@PayoutAmount) AS EmployeeTotal
       , STRING_AGG(s.ixSOPSKU,', ') WITHIN GROUP (ORDER BY IXSOPSKU) as SKUList
       , STRING_AGG(s.sSKUVariantName,', ') WITHIN GROUP (ORDER BY IXSOPSKU) as SKUNameList
       , @StartDate as StartDate
       , @EndDate as EndDate
FROM tngLive.tblskuvariant s
    INNER JOIN tngLive.tblskuvariant_skuattribute_value ssav ON ssav.ixSkuVariant = s.ixSKUVariant
    INNER JOIN tngLive.tblskuattribute_value sav ON sav.ixSkuAttributeValue = ssav.ixSkuAttributeValue
    INNER JOIN tngLive.tblskuattribute sa ON sa.ixSkuAttribute = sav.ixSkuAttribute
WHERE sTitle = 'Kit Originator'
              and s.dtCreate >= @StartDate
              and s.dtCreate < @EndDate
GROUP BY sTitle
       ,sav.sAttributeValue