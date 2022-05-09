-- Case DSOTHER-1

select * from CustomerSurvey
order by dtDateCreated desc


-- Aaron's example query
Select count(Distinct [Order Number]) 
from dbo.vwFeedbackCommentReport
Where [Create Date] between '2012-04-01' and '2012-05-01' And [Order Number] is not null
and NPS = '0';


-- All NPS scores
Select NPS, count(Distinct [Order Number]) Cnt
from dbo.vwFeedbackCommentReport
Where [Create Date] between '2012-04-01 00:00:00.000' and '2012-04-30 23:59:59.999' And [Order Number] is not null
GROUP BY NPS
ORDER BY NPS
/*
NULL	1
0	2
1	2
10	1261
3	2
5	13
6	3
7	11
8	58
9	135
*/


-- ALL NPS and Months
DECLARE
        @StartDate datetime,
        @EndDate datetime

SELECT 
       @StartDate = '04/01/2012',
       @EndDate = '04/30/2012'
SELECT datepart("yyyy",[Create Date]) 'Year', 
    datepart("mm",[Create Date])'Month', 
    NPS, count(Distinct [Order Number]) Cnt
FROM dbo.vwFeedbackCommentReport
WHERE CONVERT(VARCHAR(30),[Create Date],101) between  @StartDate and @EndDate 
    And [Order Number] is not null
GROUP BY datepart("yyyy",[Create Date]), 
        datepart("mm",[Create Date]),
         NPS
ORDER BY 'Year','Month',NPS
/*
Year	Month	NPS	Cnt
2012	4	    NULL	1
2012	4	    0	2
2012	4	    1	2
2012	4	    10	1261
2012	4	    3	2
2012	4	    5	13
2012	4	    6	3
2012	4	    7	11
2012	4	    8	58
2012	4	    9	135
*/








