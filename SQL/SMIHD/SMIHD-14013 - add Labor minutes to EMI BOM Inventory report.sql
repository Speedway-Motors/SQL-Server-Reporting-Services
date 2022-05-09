-- SMIHD-14013 - add Labor minutes to EMI BOM Inventory report

-- Vendor 1410 is EMI.  They are the PV for all of the BOMs they manufacture.

-- ALL of EMIs labor SKUS start with 9460%


select * from tblBOMTemplateMaster
where ixFinishedSKU = '94612220'

select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, S.sDescription, TD.dtDateLastSOPUpdate
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
where ixFinishedSKU in ('91637033','96627509','91637034','9401985','94037018.1','91637031','9708201.1','94049006','91690210','94037025','9401802','96622938','94057000','94037026','91637035','9708000','91037300')
order by ixFinishedSKU, ixSKU
/*
ixFinishedSKU	ixSKU	        iQuantity	sDescription
9601118	        94600-BEND	    5	        SHOP LABOR/BURDEN RATE
9601118	        94600-COPE	    1	        SHOP LABOR-COPE
9601118	        94600-CUT	    2	        SHOP LABOR-CUT
9601118	        94600-GRIND	    3	        SHOP LABOR-GRIND
9601118	        94600-LATHE	    2	        LATHE WORK
9601118	        94600-SETUP	    6	        SHOP LABOR-SETUP
9601118     	94600-WELD	    6	        SHOP LABOR-WELD
9601118     	M3R.75D.065H	122	.75 OD X .065 304 STAINLESS

                                25 mins TOT LABOR
*/



select ixSKU, sDescription from tblSKU
where ixSKU like '9460%'
order by ixSKU


select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, S.sDescription
--INTO #LaborSKUs
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
where sDescription like '%LABOR%'
ORDER BY TD.ixSKU




select TD.ixFinishedSKU, TD.ixSKU, TD.iQuantity, S.sDescription
INTO #EagleBOMsLaborSKUs
-- DROP TABLE ##EagleBOMsLaborSKUs
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
    left join #EagleBOMs EBOM on EBOM.ixFinishedSKU = TD.ixFinishedSKU
where TD.ixSKU like '9460%'
ORDER BY TD.ixFinishedSKU

select count(distinct ixFinishedSKU) -- 804
from #EagleBOMsLaborSKUs



select ixFinishedSKU, count(ixSKU) 'LaborSKUs'
from #EagleBOMsLaborSKUs
GROUP BY ixFinishedSKU
HAVING count(ixSKU) > 5




select DISTINCT S.sDescription, TD.iQuantity
from tblBOMTemplateDetail TD
    left join tblSKU S on TD.ixSKU = S.ixSKU
where sDescription like '%LABOR%'
ORDER BY S.sDescription, TD.iQuantity




-- CALCULATE LABOR MINUTES FOR EVERY EAGLE BOM


-- Eagle BOMs
SELECT distinct TD.ixFinishedSKU
--into #EagleBOMs
from tblBOMTemplateDetail TD
    left join tblVendorSKU VS on TD.ixSKU = VS.ixSKU and VS.iOrdinality = 1
    left join tblSKU S on TD.ixSKU = S.ixSKU
where VS.ixVendor = '1410'
    and S.dtDiscontinuedDate > getdate()
    and S.flgDeletedFromSOP = 0


-- EMI BOMs that do not have any Labor SKUs assigned
select * from #EagleBOMs
where ixFinishedSKU NOT IN (select ixFinishedSKU From #EagleBOMsLaborSKUs)

select * from tblBOMTemplateDetail
where ixFinishedSKU in 



select * from #EMILaberMins
order by LaborSKUs desc


where ixFinishedSKU = '9601118'



