-- New tables in SMI Reporting with data imported from TNG
select top 200            -- all rows = 7.3m as of 6-15-17
       s.ixSKU
       , vy.ixVehicleYear
       , vm.sVehicleMakeName
       , vmmod.sVehicleModelName
from tblSKU s
inner join tblskuvariant_vehicle_base svb on s.ixSKU = svb.ixSKU
inner join tblvehicle_base vb on svb.ixVehicleBase = vb.ixVehicleBase
inner join tblvehicle_make vm on vm.ixVehicleMake = vb.ixVehicleMake
inner join tblvehicle_model vmmod on vmmod.ixVehicleModel = vb.ixVehicleModel
inner join tblvehicle_year vy on vy.ixVehicleYear = vb.ixVehicleYear


select --top 20   -- all rows = 166,379 as of 6-15-17
       s.ixSKU
       , rt.sRaceType
from tblSKU s
inner join tblskuvariant_racetype_xref rx on rx.ixSOPSKU = s.ixSKU
inner join tblracetype rt on rt.ixRaceType = rx.ixRaceType


select --top 20  -- all rows = 3,595 as of 6-15-17
       s.ixSKU
       , tf.sTransmissionFamilyName
       , tf.sTransmissionGroup
from tblSKU s
inner join tblskuvariant_transmission_family_xref tx on tx.ixSOPSKU = s.ixSKU
inner join tbltransmission_family tf on tf.ixTransmissionFamily = tx.ixTransmissionFamily



SELECT * from tblSKU
where ixSKU = 

