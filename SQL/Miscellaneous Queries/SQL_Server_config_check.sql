/*=============================================
  File: SQL_Server_config_check.sql
 
  Author: Thomas LaRock, http://thomaslarock.com/contact-me/
  http://thomaslarock.com/2014/08/sql-server-configuration-check/
 
  Summary: This script will check the values of your sys.configurations table
   and compare it to the default values. The script should return a row for any 
   configuration option that is currently set to a non-default value. 
 
   I’ve created one table variable to hold the default values for every version of 
   SQL Server going back to SQL 2005. You can verify for yourself that I have used
   the default values for each version by reading this BOL entry:
 
   http://msdn.microsoft.com/en-us/library/ms189631.aspx
 
   You’ll note that the default values have not changed(!) between versions, but 
   certain configuration options are not available in each version. By using an 
   inner join on the name column I believe the extra rows are not an issue for 
   our final result set.
 
   But hey, I’ve been wrong before.
 
  Date: July 24th, 2014
 
  SQL Server Versions: SQL 2005, SQL 2008, SQL 2008R2, SQL 2012, SQL 2014
 
  You may alter this code for your own purposes. You may republish
  altered code as long as you give due credit. 
 
  THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY
  OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT
  LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR
  FITNESS FOR A PARTICULAR PURPOSE.
 
=============================================*/
 
DECLARE @config TABLE (
    name nvarchar(35),
    default_value sql_variant
)
 
INSERT INTO @config (name, default_value) VALUES
('access check cache bucket count',0),
('access check cache quota',0),
('Ad Hoc Distributed Queries',0),
('affinity I/O mask',0),
('affinity64 I/O mask',0),
('affinity mask',0),
('affinity64 mask',0),
('Agent XPs',1), —- Changes to 1 if SQL Agent is started, so I check for that
('allow updates',0),
('awe enabled',0),
('backup compression default',0),
('blocked process threshold (s)',0),
('c2 audit mode',0),
('clr enabled',0),
('common criteria compliance enabled',0),
('contained database authentication', 0), 
('cost threshold for parallelism',5),
('cross db ownership chaining',0),
('cursor threshold',-1),
('Database Mail XPs',0),
('default full-text language',1033),
('default language',0),
('default trace enabled',1),
('disallow results from triggers',0),
('EKM provider enabled',0),
('filestream access level',0),
('fill factor (%)',0),
('ft crawl bandwidth (max)',100),
('ft crawl bandwidth (min)',0),
('ft notify bandwidth (max)',100),
('ft notify bandwidth (min)',0),
('index create memory (KB)',0),
('in-doubt xact resolution',0),
('lightweight pooling',0),
('locks',0),
('max degree of parallelism',0),
('max full-text crawl range',4),
('max server memory (MB)',2147483647),
('max text repl size (B)',65536),
('max worker threads',0),
('media retention',0),
('min memory per query (KB)',1024),
('min server memory (MB)',0),
('nested triggers',1),
('network packet size (B)',4096),
('Ole Automation Procedures',0),
('open objects',0),
('optimize for ad hoc workloads',0),
('PH timeout (s)',60),
('precompute rank',0),
('priority boost',0),
('query governor cost limit',0),
('query wait (s)',-1),
('recovery interval (min)',0),
('remote access',1),
('remote admin connections',0),
('remote login timeout (s)',10),
('remote proc trans',0),
('remote query timeout (s)',600),
('Replication XPs',0),
('scan for startup procs',0),
('server trigger recursion',1),
('set working set size',0),
('show advanced options',0),
('SMO and DMO XPs',1),
('SQL Mail XPs',0),
('transform noise words',0),
('two digit year cutoff',2049),
('user connections',0),
('user options',0),
('Web Assistant Procedures', 0),
('xp_cmdshell',0)
 
SELECT sc.name, sc.value, sc.value_in_use, c.default_value
FROM sys.configurations sc
INNER JOIN @config c ON sc.name = c.name
WHERE sc.value <> sc.value_in_use
OR sc.value_in_use <> c.default_value
GO