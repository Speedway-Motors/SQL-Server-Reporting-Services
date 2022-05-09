-- SMIHD-16784 - Tracking SKU & BRAND Changes
-- Colby and Jeremy new report request

 --Created DI-1702 for Ron to add brand changes to [dbo].[tblSkuVariantWebSnapshot] on DW 
 --     and to create a brand version view similar to vwSkuVariantWebSnapshotPrice

SELECT TOP 10 * FROM [dbo].[tblSkuvariantWebWarehouseQuantitySnapshot]

SELECT TOP 100000 * FROM [dbo].[tblSkuVariantWebSnapshot]
where dtStartEffectiveDate = '02/18/2020'

SELECT TOP 100000 * FROM [dbo].[tblSkuVariantWebSnapshot]
WHERE ixSOPSKU = '1011347104'
order by dtStartEffectiveDate desc

    SELECT b.dtDateFirstMadeWebActiveUtc, *
    FROM tngLive.tblskubase b
    where dtDateFirstMadeWebActiveUtc between '01/31/2020' and getdate()
    and ixSOPSKUBase NOT LIKE 'UP%'


select * from vwSkuVariantWebSnapshotPrice
WHERE ixSOPSKU = '1011347104'


--    "Using SOP fields for purposes they weren't intended for causes a lot of issues behind the scenes and reporting problems downstream.  
--   When there is a need to store new data, please request that a new field be created for it in SOP."

