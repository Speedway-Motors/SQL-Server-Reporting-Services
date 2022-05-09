-- SOP feed logs to SMI Reporting
SELECT
    'SMI ' as DB,
    convert(varchar, FL.dtDate, 10) as 'Date',
    substring(D.sDayOfWeek,1,3) as 'Day',
    T.chTime as 'Time',  
    FL.ixUser as 'User',
    FL.sFeedStatus as 'Status'
FROM [SMI Reporting].dbo.tblSOPFeedLog FL
   left join tblDate D on D.ixDate = FL.ixDate
   left join tblTime T on T.ixTime =  FL.ixTime
WHERE FL.dtDate >= DATEADD(dd,-3,DATEDIFF(dd,0,getdate()))  -- previous X days ago 
  --  and FL.ixTime NOT between 16500 and 24660 -- 04:35:00 and 06:51:00 = normal downtime window for Replication
  --  and FL.ixTime NOT between 75480 and 77460 -- 20:58:00 and 21:31:00  = normal nightly downtime
ORDER BY FL.dtDate desc, FL.ixTime Desc