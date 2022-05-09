-- Case 17538 - Unbranded SKUs

-- Active SKU file from Ryan
select count(ixSKU) from [SMITemp].dbo.PJC_17538_WebActiveSkus02122013            -- 90877
select count(distinct ixSKU) from [SMITemp].dbo.PJC_17538_WebActiveSkus02122013   -- 90877

select count(ixSKU) from [SMITemp].dbo.PJC_17538_WebActiveSkus02122013  
where ixSKU in (select ixSKU from [SMI Reporting].dbo.tblSKU)       -- 90877



-- Main Query
select SKU.ixSKU, SKU.sDescription, 
    V1.ixVendor as 'Prime Vendor#',V1.sName as  'Prime Vendor',
    V2.ixVendor as '2nd Vendor#',V2.sName as  '2nd Vendor',    
    V3.ixVendor as '3rd Vendor#',V3.sName as  '3rd Vendor',  
    V4.ixVendor as '4th Vendor#',V4.sName as  '4th Vendor',  
    V5.ixVendor as '5th Vendor#',V5.sName as  '5th Vendor',              
    SKU.ixBrand,
    SKU.sSEMACategory,
    SKU.sSEMASubCategory,
    SKU.sSEMAPart,
    SKU.sBaseIndex,
    SKU.dtCreateDate,
    WA.WebActiveAsOf02122013
from tblSKU SKU
                --Prime Vendor
    left join (select VS.ixSKU,
                      VS.ixVendor,
                      V.sName
               from tblVendorSKU VS
                    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 1
               ) V1 on V1.ixSKU = SKU.ixSKU
                -- 2nd Vendor
    left join (select VS.ixSKU,
                      VS.ixVendor,
                      V.sName
               from tblVendorSKU VS
                    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 2
               ) V2 on V2.ixSKU = SKU.ixSKU
                -- 3rd Vendor               
    left join (select VS.ixSKU,
                      VS.ixVendor,
                      V.sName
               from tblVendorSKU VS
                    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 3
               ) V3 on V3.ixSKU = SKU.ixSKU 
                -- 4th Vendor               
    left join (select VS.ixSKU,
                      VS.ixVendor,
                      V.sName
               from tblVendorSKU VS
                    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 4
               ) V4 on V4.ixSKU = SKU.ixSKU      
                -- 5th Vendor               
    left join (select VS.ixSKU,
                      VS.ixVendor,
                      V.sName
               from tblVendorSKU VS
                    join tblVendor V on VS.ixVendor = V.ixVendor and VS.iOrdinality = 5
               ) V5 on V5.ixSKU = SKU.ixSKU   
               -- Web Active SKUs
    left join (select ixSKU, 'Y' as WebActiveAsOf02122013
               from [SMITemp].dbo.PJC_17538_WebActiveSkus02122013
               ) WA on WA.ixSKU = SKU.ixSKU                                         
where SKU.ixBrand = '10013'
  and SKU.dtDiscontinuedDate >= '02/12/2013'
  and SKU.flgIntangible = 0
  and SKU.flgActive = 1
  --and SKU.ixSKU not LIKE 'UP%' -- not all UP parts are Garage Sale, so Jeremy said to include them.
  and SKU.flgDeletedFromSOP = 0
  and V1.ixVendor NOT in (0009,9999)
order by 
    V1.ixVendor
   ,SKU.ixSKU  
  
  
  

  
