select * from [LNK-DW1].[SMI Reporting].dbo.tblLatestFeed
select * from [LNK-DWSTAGING1].[SMI Reporting].dbo.tblLatestFeed

select * from [LNK-WEB2\SQLEXPRESS].[SPEEDWAY].dbo.Roles

/* when running above queries from DOMINO.[SMI Reporting] they both return...

Msg 18456, Level 14, State 1, Line 1
Login failed for user 'NT AUTHORITY\ANONYMOUS LOGON'.

*/





SELECT top 10 * from [LNK-DW1].[SMI Reporting].dbo.tblSnapAdjustedMonthlySKUSales

SELECT top 10 * from [LNK-WEB2\SQLEXPRESS].[SPEEDWAY].dbo.vwFeedbackCommentReport

exec sp_addlinkedserver [LNK-WEB2\SQLEXPRESS]



SELECT * from [LNK-WEB2\SQLEXPRESS].[SPEEDWAY].dbo.vwFeedbackCommentReport
order by [Feedback ID], [Create Date]   




select * from vwFeedbackCommentReport
where [Feedback ID] in (
						select [Feedback ID]-- , COUNT(*) QTY
						from vwFeedbackCommentReport
						group by [Feedback ID]
						having COUNT(*) > 2
						)
order by [Feedback ID]






, SPEEDWAY database, vwFeedbackCommentReport