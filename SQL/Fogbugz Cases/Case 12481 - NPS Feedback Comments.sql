select top 10 * from vwFeedbackCommentReport


Select NPS, 
   (NPS* count(*)) TotScore
from (
      SELECT Distinct	VW.[Order Number], VW.[NPS]
        FROM [SPEEDWAY].[dbo].[vwFeedbackCommentReport] As VW
        WHERE VW.[Create Date] >= '2011-04-01' and VW.[Create Date] < '2011-05-01'
      ) X
Group by NPS


select count(distinct VW.[Order Number]) Tot_Orders
  FROM [SPEEDWAY].[dbo].[vwFeedbackCommentReport] As VW
  WHERE VW.[Create Date] >= '2011-04-01' and VW.[Create Date] < '2011-05-01'

select VW.[NPS], (VW.[NPS] * count(*)) Tot_Score
  FROM [SPEEDWAY].[dbo].[vwFeedbackCommentReport] As VW
  WHERE VW.[Create Date] > '2011-04-01' and VW.[Create Date] < '2011-05-01'
group by VW.[NPS]
order by VW.[NPS]


select * 
FROM [SPEEDWAY].[dbo].[vwFeedbackCommentReport] 
where VW.[Order Number] = '4523815'