
SELECT sOrderTypeDesciption AS OrderType 
    -- , CS.dtDateCreated
     , SUBSTRING((CONVERT(varchar(10),CONVERT(varchar(10),dtDateSubmitted,101))),1,10) AS DateSubmitted  
     , COUNT(DISTINCT CS.ixFeedbackId) AS Cnt  
FROM CustomerSurvey CS
LEFT JOIN Feedback F ON F.ixFeedbackId = CS.ixFeedbackId
LEFT JOIN OrderType OT ON OT.ixOrderType = CS.iOrderType
WHERE F.ixType = 1 
  AND CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN '01/01/2013' AND '09/30/13'  
  AND sOrderTypeDesciption <> 'Counter'
GROUP BY sOrderTypeDesciption   
       , SUBSTRING((CONVERT(varchar(10),CONVERT(varchar(10),dtDateSubmitted,101))),1,10)
ORDER BY DateSubmitted
       , OrderType       


