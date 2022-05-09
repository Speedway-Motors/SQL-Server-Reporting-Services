-- drop table PJC_BOM_12MoUsage
-- BOM's in file 12776
select distinct TM.ixFinishedSKU 
into PJC_TMSkus
from tblBOMTemplateMaster TM -- 12930
    join tblSKU SKU on TM.ixFinishedSKU = SKU.ixSKU
where SKU.flgDeletedFromSOP = 0    


select distinct ixFinishedSKU from tblBOMTemplateMaster TM
where ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS not in (select ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS from PJC_BOM_12MoUsage)

select * from PJC_BOM_12MoUsage
where ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS NOT in (select ixFinishedSKU COLLATE SQL_Latin1_General_CP1_CS_AS from tblBOMTemplateMaster)

select * from tblSKU where ixSKU in ('24EDGE-M','197XADJSRET','1683638-1R')


select count(*) from PJC_BOM_12MoUsage
select count(distinct ixSKU) from PJC_BOM_12MoUsage


select * from PJC_TMSkus -- 154
where ixFinishedSKU NOT in (select ixSKU COLLATE SQL_Latin1_General_CP1_CS_AS from PJC_BOM_12MoUsage)



5135030T
1375U
2154
2140

-- in SOP with 12MoBOMQTY... not in File
select * from PJC_BOM_12MoUsage where ixSKU = '10420'
40199X
10420
0000194


select 


