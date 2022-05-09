USE [SMI Reporting]
GO

/****** Object:  StoredProcedure [dbo].[spGetDateDetails]    Script Date: 03/21/2012 10:17:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetDateDetails]

AS
select ixDate,
    CONVERT(VARCHAR(10), dtDate, 101) AS 'Date',
    sDayOfWeek,
    iPeriod,
    iISOWeek
from tblDate
where dtDate between DATEADD(yy, -1, getdate()) and GETDATE()
order by dtDate desc

GO


