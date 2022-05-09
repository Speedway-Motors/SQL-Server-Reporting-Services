-- trimmed version of code originally from  tngLive.`spSkuVariant_ReportYMMInfo`

SELECT 
  DISTINCT 
  s.ixSOPSKU as SKU
   , pl.sTitle as ProductLine
  , vy.ixVehicleYear as Year
  ,vm.sVehicleMakeName as Make
  ,vmod.sVehicleModelName as Model
  , CASE 
      WHEN (s.flgPublish = 1 AND b.flgWebPublish = 1 AND pp.flgActive) THEN 1
      ELSE 0
    END AS AvailableForSaleOnWeb
  , s.flgDiscontinued as Discountinued
  , s.iTotalQAV AS QAV, s.flgBackorderable AS Backorderable
FROM 
  tblskuvariant s

INNER JOIN tblskubase b ON s.ixSKUBase = b.ixSKUBase
INNER JOIN tblproductpageskubase ppsb ON b.ixSKUBase = ppsb.ixSKUBase
INNER JOIN tblproductpage pp ON ppsb.ixProductPage = pp.ixProductPage
LEFT JOIN tblskuvariant_vehicle_base svb ON s.ixSKUVariant = svb.ixSkuVariant
LEFT JOIN tblvehicle_base vb ON svb.ixVehicleBase = vb.ixVehicleBase
LEFT JOIN tblvehicle_year vy ON vb.ixVehicleYear = vy.ixVehicleYear
LEFT JOIN tblvehicle_make vm ON vb.ixVehicleMake = vm.ixVehicleMake
LEFT JOIN tblvehicle_model vmod ON vb.ixVehicleModel = vmod.ixVehicleModel
LEFT JOIN tblproductline pl ON b.ixProductLine = pl.ixProductLine
WHERE   vy.ixVehicleYear = 1975
  and vm.sVehicleMakeName = 'Porsche'
-- ORDER BY s.ixSOPSKU
LIMIT 200000
;

