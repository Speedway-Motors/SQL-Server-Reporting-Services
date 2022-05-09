-- DROP table PJC_17916_tblBinSku_SMI_BACKUP

select * -- 248258
into PJC_17916_tblBinSku_SMI_BACKUP
from [SMI Reporting].dbo.tblBinSku

select count(*) from [SMI Reporting].dbo.tblBinSku -- 5K at 2PM 7K@2:45  = 46/min

/*
select * -- 71631
into PJC_17916_tblBinSku_AFCO_BACKUP
from [AFCOReporting].dbo.tblBinSku
*/


select





select distinct ixBin,ixSKU,ixLocation from PJC_17916_tblBinSku_AFCO_BACKUP -- AFCO QTY original table=  71,631    new PK =  67,731    expecting = 97,898   got 84,194

select distinct ixBin,ixSKU,ixLocation from PJC_17916_tblBinSku_SMI_BACKUP  --  SMI QTY original table= 248,258    new PK = 144,447    expecting = ?


select count(*) from PJC_17916_tblBinSku_AFCO_BACKUP
select count(*) from [AFCOReporting].dbo.tblBinSku -- 48031 = 425/min

select count(*) from [SMI Reporting].dbo.tblBinSku -- 232277

select * from [AFCOReporting].dbo.tblBinSku -- 71631


select * from [SMI Reporting].dbo.tblBinSku
select * from [AFCOReporting].dbo.tblBinSku


SELECT * FROM PJC_17916_tblBinSku_SMI_BACKUP
WHERE sPickingBin is NULL

select ixDate, count(*) from [SMI Reporting].dbo.tblSKUTransaction
where ixDate >= '03/04/2013'
group by ixDate
order by ixDate

new table       = SQL_Latin1_General_CP1_CS_AS
old table       = SQL_Latin1_General_CP1_CS_AS

new ixBin field = SQL_Latin1_General_CP1_CS_AS
old ixBin field = SQL_Latin1_General_CP1_CS_AS


