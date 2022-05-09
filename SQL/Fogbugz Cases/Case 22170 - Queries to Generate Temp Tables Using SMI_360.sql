SELECT CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101))  AS dtSurveySubmitted
     , CS.sOrderNumber   
--INTO dbo.ASC_22170_SurveyResponseTime        
FROM dbo.Feedback F 
LEFT JOIN FeedbackType FT ON FT.ixType = F.ixType -- the type/description would be a parameter value in the report for the user to select from 
LEFT JOIN CustomerSurvey CS ON CS.ixFeedbackId = F.ixFeedbackId
LEFT JOIN SpeedwayCustomer SC ON SC.sSpeedwayCustomerNumber = CS.sCustomerNumber   
WHERE CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN '04/12/11' AND '03/31/14' -- @StartDate AND @EndDate 
  AND sTypeDescription IN ('Survey') --(@FeedbackDeliveryMethod ) --IN ('Facebook','Service Request','Survey','Twitter') 
  AND CS.sOrderNumber IS NOT NULL 
ORDER BY CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101))



SELECT CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) AS dtSurveySubmitted -- F.dtDateSubmitted
     , COUNT(DISTINCT F.ixFeedbackId) AS iSurveyCount   
--INTO dbo.ASC_22170_SurveyCountByDay    
FROM dbo.Feedback F 
LEFT JOIN FeedbackType FT ON FT.ixType = F.ixType -- the type/description would be a parameter value in the report for the user to select from 
LEFT JOIN CustomerSurvey CS ON CS.ixFeedbackId = F.ixFeedbackId
LEFT JOIN SpeedwayCustomer SC ON SC.sSpeedwayCustomerNumber = CS.sCustomerNumber   
WHERE CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN '04/12/11' AND '03/31/14' -- @StartDate AND @EndDate 
  AND sTypeDescription IN ('Survey') --(@FeedbackDeliveryMethod ) --IN ('Facebook','Service Request','Survey','Twitter') 
  AND CS.sOrderNumber IS NOT NULL
GROUP BY CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101))
ORDER BY CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101))