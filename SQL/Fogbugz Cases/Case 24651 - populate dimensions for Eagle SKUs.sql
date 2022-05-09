-- Case 24651 - populate dimensions for Eagle SKUs
select ES.Page, ES.SKU, SKU.ixSKU, SKU.dWeight, SKU.iLength, SKU.iWidth, SKU.iHeight
from [SMITemp].dbo.PJC_24651_EagleOrig ES
left join tblSKU SKU on ES.SKU = SKU.ixSKU

select top 10 * from [SMITemp].dbo.PJC_24651_EagleOrig ES
/*
Page	SKU	        DESCRIPTION	U           M	RETAIL	DEALER	NEW	    LENGTH	WIDTH	HEIGHT	WEIGHT
41	    9708302-PLN	LEFT BIRDCAGE ASSEMBLY	EA	144.99	129.98	NULL	NULL	NULL	NULL	NULL
*/

        select distinct iLength
        from tblSKU
        order by iLength

        select distinct iWidth
        from tblSKU
        order by iWidth

        select distinct iHeight
        from tblSKU
        order by iHeight

        select distinct dWeight
        from tblSKU
        order by dWeight

update ES
set LENGTH = SKU.iLength,
   WIDTH = SKU.iWidth,
   HEIGHT = SKU.iHeight,
   WEIGHT = SKU.dWeight   
from [SMITemp].dbo.PJC_24651_EagleOrig ES
 left join tblSKU SKU on ES.SKU = SKU.ixSKU


select * from [SMITemp].dbo.PJC_24651_EagleOrig 
order by Page

