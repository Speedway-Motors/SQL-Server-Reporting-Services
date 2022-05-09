-- Case 19275 - tblVendorSKU failed to update errors
-- failed SKUs
select * from tblErrorLogMaster
where ixErrorCode = '1126'
and dtDate >= '07/19/2013'

-- SKUs from above list
select * from [SMITemp].dbo.PJC_tblVendorSKU_failed_update_SKUs                 -- 14,371
select distinct ixSKU from [SMITemp].dbo.PJC_tblVendorSKU_failed_update_SKUs    -- 14,371


select * from [SMITemp].dbo.PJC_tblVendorSKU_failed_update_SKUs FVS
    --join [SMI Reporting].dbo.tblSKU SKU on FVS.ixSKU = SKU.ixSKU
    join [SMI Reporting].dbo.tblVendorSKU VS on FVS.ixSKU = VS.ixSKU
where --SKU.flgDeletedFromSOP = 0
    VS.iOrdinality = 1
    VS.dtDateLastSOPUpdate < '07/19/2013'
    
    
select *
from [SMI Reporting].dbo.tblVendorSKU
where dtDateLastSOPUpdate >= '07/20/2013'


-- iLeadTime not matching in tblVendorSKU vs tblSKU
select SKU.ixSKU, 
    SKU.dtDiscontinuedDate,
    SKU.iLeadTime 'SKU_LT',
    VS.iLeadTime 'VS_LT', VS.ixVendor,
    abs(SKU.iLeadTime -  VS.iLeadTime) 'Delta'
from tblSKU SKU
    join tblVendorSKU VS on SKU.ixSKU = VS.ixSKU
where VS.iOrdinality = 1
    and SKU.flgDeletedFromSOP = 0
    and abs(SKU.iLeadTime -  VS.iLeadTime) > 0    
order by SKU.dtDiscontinuedDate desc
    ,abs(SKU.iLeadTime -  VS.iLeadTime) desc   

/*
ixSKU	        SKU_LT	VS_LT	Delta
135144	        6	    26792	26786
210475-BLK-700	46	    13558	13512
9154125-STD-A	6	    11910	11904
210485-BLK-XS	52	    9121	9069
210485-BLK-S	79	    7485	7406




update tblVendorSKU
set iLeadTime = NULL



select * from tblVendorSKU











