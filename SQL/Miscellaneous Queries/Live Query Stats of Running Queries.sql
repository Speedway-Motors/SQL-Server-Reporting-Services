-- Live Query Stats of Running Queries

SELECT       
   p.node_id NodeId,
   p.session_id SessionId,
   p.request_id RequestId,
   [sql].[text] [SQL],
   p.physical_operator_name [PlanOperator], 
   obj.name AS  [Object],
   ix.name AS  [Index],	   
   SUM(p.estimate_row_count) [EstimatedRows],
   SUM(p.row_count) [ActualRows],
   CAST(CAST(SUM(p.row_count) * 100 / SUM(p.estimate_row_count) AS DECIMAL(5,2)) AS VARCHAR(6)) + ' %' Progress,
   'SELECT query_plan FROM sys.dm_exec_query_plan (' + CONVERT(VARCHAR(MAX),plan_handle,1) + ')' GetPlan
FROM 
   sys.dm_exec_query_profiles p
   LEFT JOIN sys.objects obj ON p.object_id = obj.object_id
   LEFT JOIN sys.indexes ix ON p.index_id = ix.index_id AND p.object_id = ix.object_id
   CROSS APPLY(
      SELECT node_id 
      FROM sys.dm_exec_query_profiles thisDb 
      WHERE 
         thisDb.session_id = p.session_id AND 
         thisDb.request_id = p.request_id AND 
         thisDb.database_id = DB_ID()) a
   OUTER APPLY(SELECT * FROM sys.dm_exec_sql_text(sql_handle)) [sql]
GROUP BY p.request_id, p.node_id, p.session_id, p.physical_operator_name, obj.name, ix.name,database_id,[sql].[text],plan_handle
ORDER BY p.session_id, p.request_id