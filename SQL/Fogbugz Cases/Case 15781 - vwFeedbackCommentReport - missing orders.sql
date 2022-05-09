/*
Case 15781 - vwFeedbackCommentReport appears to be missing orders


  12,013 orders in CustomerSurvey            from '2012-01-01' to '2012-09-25'
- 12,009 orders in vwFeedbackCommentReport   from '2012-01-01' to '2012-09-25'
  ======
       4 = number of "missing" Orders to account for 
*/    


select VW.[NPS], count(VW.[NPS]) Tot_Count -- 12,389
  FROM
  (SELECT Distinct VW.[Order Number], VW.[NPS]
       FROM [vwFeedbackCommentReport] As VW
       WHERE VW.[Create Date] between '2012-01-01' and '2012-09-25') As VW
group by VW.[NPS]
order by VW.[NPS]
/*
NPS	    Tot_Count
NULL	0
0	32
1	10
10	10076
2	15
3	15
4	9
5	69
6	27
7	121
8	478
9	1157
        =======
        12,009
*/


select COUNT(distinct [Order Number])  -- 12,013
from vwFeedbackCommentReport -- 17,021
where [Create Date] between '2012-01-01' and '2012-09-25'




--Get total survey count since Jan 1, 2012 (each order should only count once, thus the Distinct)
select COUNT(distinct sOrderNumber) -- 12,013
from CustomerSurvey
where dtDateCreated between '2012-01-01' and '2012-09-25'


        

       

-- ORDERS IN CustomerSurvery 
-- BUT NOT IN vwFeedbackCommentReport
select * from CustomerSurvey -- 621
where dtDateCreated between '2012-01-01' and '2012-09-25'   
  and sOrderNumber not in   
                (SELECT Distinct VW.[Order Number] sOrderNumber
                FROM [vwFeedbackCommentReport] As VW
                WHERE VW.[Create Date] between '2012-01-01' and '2012-09-25') 



select ixSurveyId, 
COUNT(*) RowCnt
from CustomerSurvey
group by ixSurveyId
/*
ixSurveyId	RowCnt
23	        1678
29	        4282
12	        204
18	        4776
10	        7048
16	        57
11	        8
17	        921
28	        4185
8	        46
*/



from the 621 missing orders, all have a ixSurveryId of (17, 18, OR 29)


                       
select * from vwFeedbackCommentReport                       



-- Orders in CustomerSurvery but not in vwFeedbackCommentReport
select * from CustomerSurvey -- 621
where dtDateCreated between '2012-01-01' and '2012-09-25'   
  and sOrderNumber in   
                (SELECT Distinct VW.[Order Number] sOrderNumber
                FROM [SPEEDWAY].[dbo].[vwFeedbackCommentReport] As VW
                WHERE VW.[Create Date] between '2012-01-01' and '2012-09-25') 
and ixSurveyId in (17,18,29)                              