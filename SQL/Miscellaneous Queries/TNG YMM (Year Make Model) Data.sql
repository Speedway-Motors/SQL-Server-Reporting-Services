-- TNG YMM (Year Make Model) Data
select
s.ixSOPSKU as 'itemid'
, vy.ixVehicleYear
, vm.sVehicleMakeName
, vmod.sVehicleModelName
from tblskuvariant_vehicle_base svb
left join tblskuvariant s on svb.ixSKUVariant = s.ixSKUVariant
LEFT JOIN tblvehicle_base vb ON svb.ixVehicleBase = vb.ixVehicleBase
LEFT JOIN tblvehicle_year vy ON vb.ixVehicleYear = vy.ixVehicleYear
LEFT JOIN tblvehicle_make vm ON vb.ixVehicleMake = vm.ixVehicleMake
LEFT JOIN tblvehicle_model vmod ON vb.ixVehicleModel = vmod.ixVehicleModel
;


-- this will return 5,039,993 rows of data