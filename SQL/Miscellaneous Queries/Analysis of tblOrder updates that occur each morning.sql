-- Analysis of tblOrder updates that occur each morning

    /* CONCLUSION:  as of 5-4-2016 it appears we have minimized the 
                    number of orders that are unnecessarily refed each morning.
    */
    
    
-- TRUNCATE table [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160429
-- DROP table [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160429
SELECT *
    INTO [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504
FROM [ErrorLogging].dbo.ProcedureLog
WHERE LogDate >= '2016-05-04 00:01:00.000'
    AND ProcedureName = '[SMI Reporting].[dbo].[spUpdateOrder]'
ORDER BY LogDate desc


SELECT count(*) from [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504 -- 9,808


SELECT Value1 'ixOrder', count(*)
FROM [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504 -- 3,879
GROUP BY Value1
ORDER BY count(*) DESC


SELECT * FROM [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504
WHERE Value1 = '6885867'
ORDER BY LogDate


SELECT DISTINCT ixOrder, dtOrderDate, dtShippedDate, sOrderStatus
FROM [SMI Reporting].dbo.tblOrder O
    join [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504 T on O.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS = T.Value1 COLLATE SQL_Latin1_General_CP1_CS_AS 
ORDER BY sOrderStatus, dtOrderDate
/*  Qty  Status
    160  Backordered
     81  Cancelled
     86  Cancelled Quote
    753  Open               <-- 98% orders taken in last 30 days
     11  Pick Ticket
      9  Quote
  2,779  Shipped            <-- 99+% orders shipped in last 30 days
 */

    
SELECT ixOrder, dtOrderDate FROM [SMI Reporting].dbo.tblOrder
where sOrderStatus = 'Open' and ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS NOT IN (SELECT Value1 COLLATE SQL_Latin1_General_CP1_CS_AS  from [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504)


SELECT DISTINCT ixOrder, dtOrderDate, dtShippedDate, sOrderStatus
FROM [SMI Reporting].dbo.tblOrder O
join [SMITemp].dbo.PJC_CallsTospUpdateOrder_20160504 T on O.ixOrder COLLATE SQL_Latin1_General_CP1_CS_AS = T.Value1 COLLATE SQL_Latin1_General_CP1_CS_AS 
WHERE O.sOrderStatus = 'Open'
ORDER BY dtOrderDate -- sOrderStatus, dtOrderDate

