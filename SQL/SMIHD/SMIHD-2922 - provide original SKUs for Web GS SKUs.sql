-- SMIHD-2922 - provide original SKUs for Web GS SKUs
select * from tblSKU where ixSKU in ('UP13770','UP14011')




select S.ixSKU, S.ixOriginalPart, S.ixPGC, S.dtCreateDate, S.dtDiscontinuedDate, SKUM.iQAV
from tblSKU S
    left join vwSKUMultiLocation SKUM on S.ixSKU = SKUM.ixSKU
where (S.ixSKU like 'UP%'
or S.ixSKU like 'AUP%')
and SKUM.iQAV > 0
--and dtCreateDate >= '11/01/2015'
order by ixSKU, dtCreateDate


select GS.* 
from vwGarageSaleSKUs GS
    join vwSKUMultiLocation SKUM on GS.ixSKU = SKUM.ixSKU
where GS.ixSKU NOT LIKE 'UP%'
and GS.ixSKU NOT LIKE 'AUP%'
and GS.flgDeletedFromSOP = 0
and SKUM.iQAV > 0
order by SKUM.iQAV desc -- dtCreateDate desc.

SKU	            Description
91099819.GS	    WINNEBAGO SHOCK
10689095	    AFCO COILOVER COOLIE
7202295	        CARB ADPT INSTAL KIT
9183334	        3/4 IN. RIBBED TIRES


select SKUM.ixSKU, SKUM.flgActive,  SKUM.iQAV, SKUM.ixPGC
from vwSKUMultiLocation SKUM 
    left join vwGarageSaleSKUs GS on GS.ixSKU = SKUM.ixSKU
where (SKUM.ixSKU LIKE 'UP%'
OR SKUM.ixSKU LIKE 'AUP%')
and SKUM.flgDeletedFromSOP = 0
--and SKUM.iQAV > 0
and GS.ixSKU is NULL
order by SKUM.iQAV desc -- dtCreateDate desc.

-- DROP TABLE [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon 
SELECT * FROM [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon -- 9248
SELECT distinct ixSOPSKU from [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon -- 9248

SELECT * 
FROM [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon WGS
    join tblSKU S on WGS.ixSOPSKU = S.ixSKU

UID	ixSKUVariant	ixSOPSKU	ixOriginalSKU

-- populate ixOrigianlPart
BEGIN TRAN    
update WGS 
set ixOriginalSKU = S.ixOriginalPart -- 
from [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon WGS
 join tblSKU S on WGS.ixSOPSKU = S.ixSKU
COMMIT TRAN

select * from [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon -- 2,664 have an ixOriginalSKU value
where ixOriginalSKU is NULL                              -- 6,584 do not


-- output to update Wyatt's Excel file
select * from [SMITemp].dbo.PJC_SMIHD_2992_GSListFromRon 
order by UID
    
    