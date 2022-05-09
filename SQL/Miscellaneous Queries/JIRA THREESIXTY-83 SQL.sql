SELECT F.dtDateSubmitted AS DateSubmitted
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
     , SC.iNumberOfTransactions
     , SC.mLifetimeSales
     , A.sAnswerText AS NPS --Net Promoter Score 
     , CC.sCommentText AS CustomerComments 
     , BQ.sCommentText AS BonusQuestion
     , CR.sCommentText AS CustomerRequests
     , FUS.sFollowUpSummary
     , FUS.dtSummarySubmitted 
     , U2.sFirstName + ' ' + U2.sLastName AS FollowupBy 
FROM dbo.Feedback F 
LEFT JOIN FeedbackStatus FS ON FS.ixStatus = F.ixStatus 
LEFT JOIN FeedbackType FT ON FT.ixType = F.ixType -- the type/description would be a parameter value in the report for the user to select from 
LEFT JOIN FeedbackEmployeeAssociation FEA ON FEA.ixFeedbackId = F.ixFeedbackId
LEFT JOIN Users U ON U.ixUserId = FEA.ixUserId
LEFT JOIN CustomerSurvey CS ON CS.ixFeedbackId = F.ixFeedbackId
LEFT JOIN OrderType OT ON OT.ixOrderType = CS.iOrderType
LEFT JOIN CustomerSurveyAnswer CSA ON CSA.ixFeedbackId = F.ixFeedbackId
LEFT JOIN Answer A ON A.ixAnswerId = CSA.ixAnswerId --AND A.iQuestionId = '13'
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId = '25' -- "How could we have made your shopping experience better?"
          ) CC ON CC.ixFeedbackId = F.ixFeedbackId --CC = Customer Comments 
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId = '42' -- "Is there anything for your project that you need, but couldn't find in our catalogs or on our website?"
          ) BQ ON BQ.ixFeedbackId = F.ixFeedbackId --BQ = Bonus Question 
LEFT JOIN (SELECT sCommentText 
                , ixFeedbackId
           FROM CustomerSurveyComment 
           WHERE ixQuestionId = '41' -- "Tell us about your current project.  We want to hear about it!"
          ) CR ON CR.ixFeedbackId = F.ixFeedbackId --CR = Customer Requests         
LEFT JOIN SpeedwayCustomer SC ON SC.sSpeedwayCustomerNumber = CS.sCustomerNumber   
LEFT JOIN FollowUpSummary FUS ON FUS.ixFeedbackId = F.ixFeedbackId   
LEFT JOIN Users U2 ON U2.ixUserId = FUS.ixUserId                
WHERE CONVERT(datetime,CONVERT(varchar(10),dtDateSubmitted,101)) BETWEEN '10/14/13' AND '10/14/13' --@StartDate AND @EndDate 
  AND sTypeDescription IN ('Survey') --@FeedbackDeliveryMethod --IN ('Facebook','Service Request','Survey','Twitter') 
  AND iQuestionId = '13'
  
