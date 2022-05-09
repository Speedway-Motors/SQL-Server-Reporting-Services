-- Dynamic SSRS report documentation 
-- via a ReportServer.dbo.Catalog query
-- source: http://www.sqlservercentral.com/articles/Reporting+Services+(SSRS)/152814/?utm_source=SSC&utm_medium=pubemail


-- extracts the Content field to reveal the RDL XML code.
SELECT 
	Name as ReportName
	,CONVERT(Varchar(Max),CONVERT(VARBINARY(MAX),Content)) AS ReportContent 
FROM  
ReportServer.dbo.Catalog Where Content is NOT NULL




WITH XMLNAMESPACES ( DEFAULT 'http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition', 
    'http://schemas.microsoft.com/SQLServer/reporting/reportdesigner' AS rd )
SELECT DISTINCT ReportName		= Name
	  ,CommandText		= x.value('(Query/CommandText)[1]','VARCHAR(250)')
 FROM ( SELECT C.Name,CONVERT(XML,CONVERT(VARBINARY(MAX),C.Content)) AS reportXML
      FROM ReportServer.dbo.Catalog C
     WHERE C.Content is not null
      AND C.Type = 2
	  ) a
 CROSS APPLY reportXML.nodes('/Report/DataSets/DataSet') r ( x )
 CROSS APPLY x.nodes('Fields/Field') f(df) 
ORDER BY ReportName  