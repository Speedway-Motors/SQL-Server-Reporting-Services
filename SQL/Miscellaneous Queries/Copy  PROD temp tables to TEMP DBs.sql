-- recreate  PROD temp tables on TEMP DBs 
SELECT count(*) from [SMI Reporting].dbo.PJC_339NotPulled

SELECT *
INTO PJC_339NotPulled
FROM [SMI Reporting].dbo.PJC_339NotPulled

SELECT count(*) from[SMI Reporting].dbo.PJC_339NotPulled -- 28256


