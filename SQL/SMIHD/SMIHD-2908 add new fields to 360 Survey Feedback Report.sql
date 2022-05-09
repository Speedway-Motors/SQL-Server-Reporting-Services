-- SMIHD-2908 add new fields to 360 Survey Feedback Report
-- CONNECT TO LNK-WEB2\SQLEXPRESS & USE THE SMI_360 DB

-- RON says its a SQL box so we may be able to set up a linked server to pull the data from elsewhere
-- in case we need to pull data in from SMI Reporting
/*
DECLARE
    @StartDate datetime,
    @EndDate datetime

SELECT
    @StartDate = '11/01/15', -- 894 SURVEYS FOR NOV
    @EndDate = '11/30/15'  
*/
SELECT CONVERT(varchar(10), F.dtDateSubmitted, 110)  AS DateSubmitted
     , CONVERT(varchar(8), F.dtDateSubmitted, 114) AS TimeSubmitted
     , F.dtDateSubmitted AS LongDate 
     , F.ixFeedbackId
     --, F.ixType
     , FT.sTypeDescription AS DeliveryMethod 
     --, F.ixStatus
     , FS.sStatusDescription AS SurveyStatus 
     --, F.iTotalScore
     --, F.flgAwaitingCallback
     --, F.iOverallPerception
     , U.sFirstName + ' ' + U.sLastName AS OrderRep
     , CS.sOrderNumber
     , OT.sOrderTypeDesciption AS OrderType 
     , CS.sCustomerNumber
     , SC.sMailingState     
     , A.sAnswerText AS NPS --Net Promoter Score 
     , CC.sCommentText AS CustomerComments 
     , BQ.sCommentText AS BonusQuestion
     , CR.sCommentText AS CustomerRequests
     , FUS.sFollowUpSummary
     , FUS.dtSummarySubmitted 
     , U2.sFirstName + ' ' + U2.sLastName AS FollowupBy 
     , TS.TotSurveys
     , SC.iNumberOfTransactions -- Total # of Transactions	
     , SC.mLifetimeSales -- Lifetime Sales 
     , SC.dtLastTransaction -- Previous Order
FROM dbo.Feedback F 
LEFT JOIN FeedbackStatus FS ON FS.ixStatus = F.ixStatus 
LEFT JOIN FeedbackType FT ON FT.ixType = F.ixType -- the type/description would be a parameter value in the report for the user to select from 
LEFT JOIN FeedbackEmployeeAssociation FEA ON FEA.ixFeedbackId = F.ixFeedbackId AND FEA.ixEmployeeAssociationType = '1'
LEFT JOIN Users U ON U.ixUserId = FEA.ixUserId
LEFT JOIN CustomerSurvey CS ON CS.ixFeedbackId = F.ixFeedbackId
LEFT JOIN OrderType OT ON OT.ixOrderType = CS.iOrderType
LEFT JOIN CustomerSurveyAnswer CSA ON CSA.ixFeedbackId = F.ixFeedbackId
LEFT JOIN Answer A ON A.ixAnswerId = CSA.ixAnswerId 
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId IN ('20', '25', '36', '49') -- "How could we have made your shopping experience better?"
          ) CC ON CC.ixFeedbackId = F.ixFeedbackId --CC = Customer Comments 
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId IN ('42', '50') -- "Is there anything for your project that you need, but couldn't find in our catalogs or on our website?"
          ) BQ ON BQ.ixFeedbackId = F.ixFeedbackId --BQ = Bonus Question 
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId = '41' -- "Tell us about your current project.  We want to hear about it!"
          ) CR ON CR.ixFeedbackId = F.ixFeedbackId --CR = Customer Requests   
LEFT JOIN (SELECT CS.sCustomerNumber, count(F.ixFeedbackId) 'TotSurveys' -- 66,294
            FROM dbo.Feedback F 
            LEFT JOIN FeedbackStatus FS ON FS.ixStatus = F.ixStatus 
            LEFT JOIN FeedbackType FT ON FT.ixType = F.ixType -- the type/description would be a parameter value in the report for the user to select from 
            LEFT JOIN CustomerSurvey CS ON CS.ixFeedbackId = F.ixFeedbackId
            LEFT JOIN CustomerSurveyAnswer CSA ON CSA.ixFeedbackId = F.ixFeedbackId
            LEFT JOIN Answer A ON A.ixAnswerId = CSA.ixAnswerId 
            WHERE -- CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN @StartDate AND @EndDate 
               sTypeDescription IN ('Survey') --(@FeedbackDeliveryMethod ) --IN ('Facebook','Service Request','Survey','Twitter') 
              AND (iQuestionId IN ('13', '46') OR iQuestionId IS NULL)
              --AND OT.sOrderTypeDesciption IN (@OrderType)--IN ('Counter','Email','Fax','General', 'Mail', 'Phone', 'Web')
            group by CS.sCustomerNumber
            --order by count(F.ixFeedbackId) desc
          ) TS ON TS.sCustomerNumber =   CS.sCustomerNumber --TS = Total Surveys        
LEFT JOIN SpeedwayCustomer SC ON SC.sSpeedwayCustomerNumber = CS.sCustomerNumber   
LEFT JOIN FollowUpSummary FUS ON FUS.ixFeedbackId = F.ixFeedbackId   
LEFT JOIN Users U2 ON U2.ixUserId = FUS.ixUserId                
WHERE
  CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN @StartDate AND @EndDate 
  AND 
  sTypeDescription IN ('Survey') --(@FeedbackDeliveryMethod ) --IN ('Facebook','Service Request','Survey','Twitter') 
  AND (iQuestionId IN ('13', '46') OR iQuestionId IS NULL)
  AND OT.sOrderTypeDesciption IN (@OrderType)--IN ('Counter','Email','Fax','General', 'Mail', 'Phone', 'Web') -- COMMENT BACK IN AFTER TESTING!

ORDER BY sOrderTypeDesciption


/**** some customer summary data may already exist in this table!

SELECT * FROM SpeedwayCustomer
where sSpeedwayCustomerNumber = 709242




