-- SMIHD-22631 - research how dropships are categorized in Gross Revenue Order and Package Count by Channel report

-- On this report where does an order show up if it was a factory shipment (direct from our supplier to our customer)?

/* Gross Revenue Order and Package Count by Channel.rdl
    ver 18.15.1
*/
DECLARE @StartDate datetime,        @EndDate datetime,      @Location INT 
SELECT  @StartDate = '08/02/21',    @EndDate = '10/02/21',  @Location = 99


SELECT LOC.ixLocation, 
       LOC.sDescription,
       ISNULL(AUCTION.DailyNumOrds,0) AUCTIONNumOrds,
       ISNULL(AUCTION.DailySales,0) AUCTIONDailySales,
       ISNULL(AUCTION.PkgCount,0) AUCTIONPkgCount,

       ISNULL(AMAZON.DailyNumOrds,0) AMAZONNumOrds,
       ISNULL(AMAZON.DailySales,0) AMAZONDailySales,
       ISNULL(AMAZON.PkgCount,0) AMAZONPkgCount,
       
       ISNULL(EMAIL.DailyNumOrds,0) EMAILNumOrds,       
       ISNULL(EMAIL.DailySales,0) EMAILDailySales,
       ISNULL(EMAIL.PkgCount,0) EMAILPkgCount,

       ISNULL(FAX.DailyNumOrds,0) FAXNumOrds,       
       ISNULL(FAX.DailySales,0) FAXDailySales,
       ISNULL(FAX.PkgCount,0) FAXPkgCount,

       ISNULL(MAIL.DailyNumOrds,0) MAILNumOrds,
       ISNULL(MAIL.DailySales,0) MAILDailySales,
       ISNULL(MAIL.PkgCount,0) MAILPkgCount,
       
       ISNULL(PHONE.DailyNumOrds,0) PHONENumOrds,
       ISNULL(PHONE.DailySales,0) PHONEDailySales,
       ISNULL(PHONE.PkgCount,0) PHONEPkgCount,
       
       ISNULL(WALMART.DailyNumOrds,0) WALMARTNumOrds,
       ISNULL(WALMART.DailySales,0) WALMARTDailySales,
       ISNULL(WALMART.PkgCount,0) WALMARTPkgCount,

       ISNULL(WEB.DailyNumOrds,0) WEBNumOrds,
       ISNULL(WEB.DailySales,0) WEBDailySales,
       ISNULL(WEB.PkgCount,0) WEBPkgCount,

       ISNULL(COUNTER.DailyNumOrds,0) COUNTERNumOrds,       
       ISNULL(COUNTER.DailySales,0) COUNTERDailySales,
       ISNULL(COUNTER.PkgCount,0) COUNTERPkgCount,
       
       ISNULL(COUNTERPU.DailyNumOrds,0) COUNTERPUNumOrds,
       ISNULL(COUNTERPU.DailySales,0) COUNTERPUDailySales,
       ISNULL(COUNTERPU.PkgCount,0) COUNTERPUPkgCount,
       
       ISNULL(INTERNAL.DailyNumOrds,0) INTERNALUNumOrds,
       ISNULL(INTERNAL.DailySales,0) INTERNALDailySales,
       ISNULL(INTERNAL.PkgCount,0) INTERNALPkgCount,
       
       (ISNULL(AUCTION.DailyNumOrds,0)+ISNULL(AMAZON.DailyNumOrds,0)+ISNULL(EMAIL.DailyNumOrds,0)+ISNULL(FAX.DailyNumOrds,0)+ISNULL(MAIL.DailyNumOrds,0)+ISNULL(PHONE.DailyNumOrds,0)+ISNULL(WALMART.DailyNumOrds,0)+ISNULL(WEB.DailyNumOrds,0)+ISNULL(COUNTER.DailyNumOrds,0)+ISNULL(COUNTERPU.DailyNumOrds,0)+ISNULL(INTERNAL.DailyNumOrds,0)) 'TOTDailyNumOrds',                                                        
       (ISNULL(AUCTION.DailySales,0)+ISNULL(AMAZON.DailySales,0)+ISNULL(EMAIL.DailySales,0)+ISNULL(FAX.DailySales,0)+ISNULL(MAIL.DailySales,0)+ISNULL(PHONE.DailySales,0)+ISNULL(WALMART.DailySales,0)+ISNULL(WEB.DailySales,0)+ISNULL(COUNTER.DailySales,0)+ISNULL(COUNTERPU.DailySales,0)+ISNULL(INTERNAL.DailySales,0)) 'TOTDailySales',
       (ISNULL(AUCTION.PkgCount,0)+ISNULL(AMAZON.PkgCount,0)+ISNULL(EMAIL.PkgCount,0)+ISNULL(FAX.PkgCount,0)+ISNULL(MAIL.PkgCount,0)+ISNULL(PHONE.PkgCount,0)+ISNULL(WALMART.PkgCount,0)+ISNULL(WEB.PkgCount,0)+ISNULL(COUNTER.PkgCount,0)+ISNULL(COUNTERPU.PkgCount,0)+ISNULL(INTERNAL.PkgCount,0)) 'TOTPkgCount'
FROM   
    (SELECT *
     from tblLocation
     where ixLocation in (@Location) -- (47,97,98,99)
     ) LOC
LEFT JOIN      
    (-- AUCTION
    SELECT ixPrimaryShipLocation,
            SUM(DailySales) DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'AUCTION'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation
     ) AUCTION on LOC.ixLocation = AUCTION.ixPrimaryShipLocation
LEFT JOIN      
    (-- AMAZON
    SELECT ixPrimaryShipLocation,
            SUM(DailySales) DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'AMAZON'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation
     ) AMAZON on LOC.ixLocation = AMAZON.ixPrimaryShipLocation     
LEFT JOIN
    (-- E-MAIL
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'E-MAIL'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) EMAIL on LOC.ixLocation = EMAIL.ixPrimaryShipLocation
LEFT JOIN
    (-- FAX
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'FAX'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) FAX on LOC.ixLocation = FAX.ixPrimaryShipLocation     
LEFT JOIN
    (-- MAIL
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'MAIL'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) MAIL on LOC.ixLocation = MAIL.ixPrimaryShipLocation      
LEFT JOIN
    (-- PHONE
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'PHONE'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) PHONE on LOC.ixLocation = PHONE.ixPrimaryShipLocation   
LEFT JOIN      
    (-- WALMART
    SELECT ixPrimaryShipLocation,
            SUM(DailySales) DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'WALMART'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation
     ) WALMART on LOC.ixLocation = WALMART.ixPrimaryShipLocation     
LEFT JOIN
    (-- WEB
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'WEB'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) WEB on LOC.ixLocation = WEB.ixPrimaryShipLocation    
 LEFT JOIN
    (-- COUNTER
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'COUNTER'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) COUNTER on LOC.ixLocation = COUNTER.ixPrimaryShipLocation  
 LEFT JOIN
     (-- COUNTER-PU
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'COUNTER P/U'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) COUNTERPU on LOC.ixLocation = COUNTERPU.ixPrimaryShipLocation        
 LEFT JOIN
    (-- INTERNAL
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevAndPkgsByChannel_TEMP
     WHERE OrdChan = 'INTERNAL'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) INTERNAL on LOC.ixLocation = INTERNAL.ixPrimaryShipLocation

