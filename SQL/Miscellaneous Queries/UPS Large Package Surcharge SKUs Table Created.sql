select DISTINCT ixSKU 
into [SMITemp].dbo.ASC_UPS_Oversize_PartOne -- DROP TABLE [SMITemp].dbo.ASC_UPS_Oversize_PartOne
from

(

select ixSKU
     , iLength
     , iWidth
     , iHeight -- 1315
from tblSKU
where flgDeletedFromSOP = 0
AND (iLength > 60
OR iWidth > 60
OR iHeight > 60)

UNION

select ixSKU, iLength, iWidth,iHeight -- 906
from tblSKU
where flgDeletedFromSOP = 0
AND iLength > 30
AND (iWidth > 30 OR iHeight > 30) 


UNION 

select ixSKU, iLength, iWidth,iHeight -- 906
from tblSKU
where flgDeletedFromSOP = 0
AND iWidth > 30 
AND(iLength > 30 OR iHeight > 30)

UNION 

select ixSKU, iLength, iWidth,iHeight -- 95
from tblSKU
where flgDeletedFromSOP = 0
AND iHeight > 30
AND(iLength > 30 OR iWidth > 30)


) X


select DISTINCT ixSKU 
into [SMITemp].dbo.ASC_UPS_Oversize_PartTwo -- DROP TABLE [SMITemp].dbo.ASC_UPS_Oversize_PartTwo
FROM
(
select DISTINCT ixSKU
     --, dWeight
     --, dDimWeight
     --, iLength
     --, iWidth
     --, iHeight     
from tblSKU
where flgDeletedFromSOP = 0
AND (dWeight > 70 -- 2116
OR dDimWeight > 70 -- 4287
 OR (iLength + ((iHeight*2)+(iWidth*2))) > 130 -- 4372
 )
) B



select DISTINCT (ISNULL(PO.ixSKU,PT.ixSKU)) ixSKU 
into [SMITemp].dbo.ASC_UPS_Oversize_PartThree -- DROP TABLE [SMITemp].dbo.ASC_UPS_Oversize_PartThree
from [SMITemp].dbo.ASC_UPS_Oversize_PartOne PO 
full outer join [SMITemp].dbo.ASC_UPS_Oversize_PartTwo PT ON PT.ixSKU = PO.ixSKU


select PT.ixSKU
     , flgActive
     , iLength
     , iHeight
     , iWidth
     , dWeight
     , dDimWeight
     , flgORMD
     , flgAdditionalHandling
INTO [SMITemp].dbo.ASC_UPS_LargePackageSurchargeSKUs     
FROM [SMITemp].dbo.ASC_UPS_Oversize_PartThree PT 
left join tblSKU S ON S.ixSKU = PT.ixSKU

