SELECT O.dtOrderDate
     , T.iHour --Consider making case statement (i.e. CASE WHEN iHour = 13 THEN 1-2p WHEN iHour = 14 THEN 2-3p ... ELSE 'After Hours')
     --, (CASE WHEN iHour = 7 THEN '7a - 8a'
     --        WHEN iHour = 8 THEN '8a - 9a'
     --        WHEN iHour = 9 THEN '9a - 10a'
     --        WHEN iHour = 10 THEN '10a - 11a'
     --        WHEN iHour = 11 THEN '11a - 12p'
     --        WHEN iHour = 12 THEN '12p - 1p'
     --        WHEN iHour = 13 THEN '1p - 2p'
     --        WHEN iHour = 14 THEN '2p - 3p'
     --        WHEN iHour = 15 THEN '3p - 4p'
     --        WHEN iHour = 16 THEN '4p - 5p'
     --        WHEN iHour = 17 THEN '5p - 6p'
     --        WHEN iHour = 18 THEN '6p - 7p'
     --        WHEN iHour = 19 THEN '7p - 8p'
     --        WHEN iHour = 20 THEN '8p - 9p'
     --        WHEN iHour = 21 THEN '9p - 10p'
     --        ELSE 'After Hours'
     --   END) AS iHour 
     , COUNT(DISTINCT O.ixOrder) AS OrdCnt                                                    
FROM tblOrder O     
LEFT JOIN tblTime T ON T.ixTime = O.ixOrderTime 
LEFT JOIN tblDate D ON D.ixDate = O.ixOrderDate    
WHERE dtOrderDate BETWEEN '09/03/13' AND '09/03/13' --@StartDate AND @EndDate 
  AND iHour BETWEEN '7' AND '22' --@StartTime AND @EndTime 
  AND sDayOfWeek IN ('TUESDAY') --@DayOfWeek
  AND O.mMerchandise > 0 
  AND sOrderStatus <> 'Cancelled'   
  AND sOrderChannel <> 'INTERNAL'      
GROUP BY O.dtOrderDate
       , T.iHour
       --, (CASE WHEN iHour = 7 THEN '7a - 8a'
       --      WHEN iHour = 8 THEN '8a - 9a'
       --      WHEN iHour = 9 THEN '9a - 10a'
       --      WHEN iHour = 10 THEN '10a - 11a'
       --      WHEN iHour = 11 THEN '11a - 12p'
       --      WHEN iHour = 12 THEN '12p - 1p'
       --      WHEN iHour = 13 THEN '1p - 2p'
       --      WHEN iHour = 14 THEN '2p - 3p'
       --      WHEN iHour = 15 THEN '3p - 4p'
       --      WHEN iHour = 16 THEN '4p - 5p'
       --      WHEN iHour = 17 THEN '5p - 6p'
       --      WHEN iHour = 18 THEN '6p - 7p'
       --      WHEN iHour = 19 THEN '7p - 8p'
       --      WHEN iHour = 20 THEN '8p - 9p'
       --      WHEN iHour = 21 THEN '9p - 10p'
       --      ELSE 'After Hours'
       -- END)
       
       
