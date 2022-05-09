-- SMIHD-1103 - new version of Gross Revenue and Order Count report

/*
vwDailyGrossRevByChannel_TEMP

dtShippedDate	ixPrimaryShipLocation	OrdChan	    DailySales	DailyNumOrds	PkgCount
2015-03-13  	99	                    INTERNAL	0.00	    0	            1
*/

DECLARE
    @StartDate datetime,
    @EndDate datetime--,
   -- @Location int

SELECT
    @StartDate = '05/01/15',
    @EndDate = '06/01/15'--,  
   -- @Location = 99

SELECT LOC.ixLocation,
       ISNULL(AUCTION.DailyNumOrds,0) AUCTIONNumOrds,
       ISNULL(AUCTION.DailySales,0) AUCTIONDailySales,
       ISNULL(AUCTION.PkgCount,0) AUCTIONPkgCount,

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
       
       (ISNULL(AUCTION.DailyNumOrds,0)+ISNULL(EMAIL.DailyNumOrds,0)+ISNULL(FAX.DailyNumOrds,0)+ISNULL(MAIL.DailyNumOrds,0)+ISNULL(PHONE.DailyNumOrds,0)+ISNULL(WEB.DailyNumOrds,0)+ISNULL(COUNTER.DailyNumOrds,0)+ISNULL(COUNTERPU.DailyNumOrds,0)+ISNULL(INTERNAL.DailyNumOrds,0)) 'TOTDailyNumOrds',                                                        
       (ISNULL(AUCTION.DailySales,0)+ISNULL(EMAIL.DailySales,0)+ISNULL(FAX.DailySales,0)+ISNULL(MAIL.DailySales,0)+ISNULL(PHONE.DailySales,0)+ISNULL(WEB.DailySales,0)+ISNULL(COUNTER.DailySales,0)+ISNULL(COUNTERPU.DailySales,0)+ISNULL(INTERNAL.DailySales,0)) 'TOTDailySales',
       (ISNULL(AUCTION.PkgCount,0)+ISNULL(EMAIL.PkgCount,0)+ISNULL(FAX.PkgCount,0)+ISNULL(MAIL.PkgCount,0)+ISNULL(PHONE.PkgCount,0)+ISNULL(WEB.PkgCount,0)+ISNULL(COUNTER.PkgCount,0)+ISNULL(COUNTERPU.PkgCount,0)+ISNULL(INTERNAL.PkgCount,0)) 'TOTPkgCount'
FROM   
    (SELECT *
     from tblLocation
     where ixLocation in (47,97,98,99)
     ) LOC
LEFT JOIN      
    (-- AUCTION
    SELECT ixPrimaryShipLocation,
            SUM(DailySales) DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevByChannel_TEMP
     WHERE OrdChan = 'AUCTION'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation
     ) AUCTION on LOC.ixLocation = AUCTION.ixPrimaryShipLocation
LEFT JOIN
    (-- E-MAIL
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
     WHERE OrdChan = 'PHONE'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) PHONE on LOC.ixLocation = PHONE.ixPrimaryShipLocation   
LEFT JOIN
    (-- WEB
     SELECT ixPrimaryShipLocation,
            SUM(DailySales)DailySales,
            SUM(DailyNumOrds) DailyNumOrds,
            SUM(PkgCount) PkgCount
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
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
     FROM vwDailyGrossRevByChannel_TEMP
     WHERE OrdChan = 'INTERNAL'
        and dtShippedDate between @StartDate and @EndDate
     GROUP BY ixPrimaryShipLocation        
     ) INTERNAL on LOC.ixLocation = INTERNAL.ixPrimaryShipLocation       
     
     
