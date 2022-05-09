-- Case 17352 - Customer Project Survey Data

-- 195,289 customers placed orders in 2012
select count(distinct ixCustomer) 
from tblOrder O
    where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
  --  and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2012' and '12/31/2012'
    

-- 195,289 customers placed orders in 2012 out of those 8,148 (4.2%) filled out a survery answering at least one of the two Project questions.
select count(distinct O.ixCustomer) 
from [SMI Reporting].dbo.tblOrder O
    join PJC_17352_ProjectSurveryCustomers PSC on O.ixCustomer = PSC.ixCustomer -- customers who answered ixQuestionId 40 AND OR 41
    join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
  --  and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2012' and '12/31/2012'
    and C.sEmailAddress is NOT NULL
    and (C.flgMarketingEmailSubscription = 'Y'
        or C.flgMarketingEmailSubscription is NULL)
        

select count(distinct O.ixCustomer) 
from [SMI Reporting].dbo.tblOrder O
    join PJC_17352_ProjectSurveryCustomers PSC on O.ixCustomer = PSC.ixCustomer -- customers who answered ixQuestionId 40 AND OR 41
    join [SMI Reporting].dbo.tblCustomer C on O.ixCustomer = C.ixCustomer
where O.sOrderStatus = 'Shipped'
    and O.sOrderType <> 'Internal'
  --  and O.sOrderChannel <> 'INTERNAL'
    and O.mMerchandise > 0 -- > 1 if looking at non-US orders
    and O.dtShippedDate between '01/01/2012' and '12/31/2012'
    and C.sEmailAddress is NOT NULL
    and (C.flgMarketingEmailSubscription = 'Y'
        or C.flgMarketingEmailSubscription is NULL)        
    
    
    
    
    
    
    
    
    
select flgMarketingEmailSubscription,
count(*)
from [SMI Reporting].dbo.tblCustomer
group by flgMarketingEmailSubscription    

SELECT CS.sCustomerNumber , CS.sOrderNumber , 
    CSC.ixQuestionId,
    F.dtDateSubmitted , CSC.sCommentText 
FROM [SMI_360].[dbo].[CustomerSurveyComment] CSC 
    LEFT JOIN [SMI_360].[dbo].Feedback F on F.ixFeedbackId = CSC.ixFeedbackId 
    LEFT JOIN [SMI_360].[dbo].CustomerSurvey CS on CS.ixFeedbackId = CSC.ixFeedbackId 
WHERE CSC.ixQuestionId in (26,39,40) --'42' AND F.dtDateSubmitted BETWEEN @StartDate AND @EndDate --'1-15-2013' AND '1-18-2013'

ORDER BY dtDateSubmitted--ixQuestionId


SELECT CS.sCustomerNumber
     , CS.sOrderNumber
     , F.dtDateSubmitted
     , CSC.sCommentText
FROM [SMI_360].[dbo].[CustomerSurveyComment] CSC
    LEFT JOIN [SMI_360].[dbo].Feedback F on F.ixFeedbackId = CSC.ixFeedbackId  
    LEFT JOIN [SMI_360].[dbo].CustomerSurvey CS on CS.ixFeedbackId = CSC.ixFeedbackId
WHERE CSC.ixQuestionId in (40,41)
  AND F.dtDateSubmitted BETWEEN '1-01-2012' AND '12-31-2012'
  
  ORDER BY dtDateSubmitted--ixQuestionId
  

